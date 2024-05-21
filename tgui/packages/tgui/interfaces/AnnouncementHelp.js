import { filter } from 'common/collections';
import { flow } from 'common/fp';
import { createSearch } from 'common/string';
import { useBackend } from '../backend';
import { Button, Icon, Input, Section, Stack, Tabs } from '../components';
import { useLocalState } from '../backend';
import { Window } from '../layouts';

export const AnnouncementHelp = (props, context) => {
  const { act, data } = useBackend(context);
  const { vox_types = {} } = data;

  const [
    current_page,
    set_page,
  ] = useLocalState(context, 'current_page', 0);

  const [
    search_text,
    set_search_text,
  ] = useLocalState(context, 'search_text', '');

  // I love `Object`s!!
  const words_filtered = prepare_search(Object.keys(vox_types[Object.keys(vox_types)[current_page]]), search_text);

  return (
    <Window
      width={500}
      height={500}
      resizable
      title="Announcement Help">
      <Window.Content>
        <Section fill overflow="auto">
          <Stack vertical>
            <Stack.Item>
              <Tabs fluid textAlign="center">
                {
                  Object.keys(vox_types).map((vox_type, index) => (
                    <Tabs.Tab
                      key={index}
                      onClick={() => set_page(index)}
                      selected={current_page === index}>
                      {vox_type}
                    </Tabs.Tab>
                  ))
                }
              </Tabs>
            </Stack.Item>
            <Stack.Item>
              <Stack>
                <Stack.Item>
                  <Icon name="search" mt={0.6} />
                </Stack.Item>
                <Stack.Item grow>
                  <Input
                    fluid
                    placeholder="Find a word..."
                    onInput={(e, value) => set_search_text(value)}
                  />
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item>
              {words_filtered.map(nestedKey => (
                <Button
                  key={nestedKey}
                  onClick={() => act("say_word", {
                    "vox_type": Object.keys(vox_types)[current_page],
                    "to_speak": nestedKey,
                  })} >
                  {nestedKey}
                </Button>
              ))}
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};

export const prepare_search = (words_filtered, search_text = '') => {
  const search = createSearch(search_text,
    word_soup => word_soup);
  return flow([
    search_text && filter(search),
  ])(words_filtered);
};
