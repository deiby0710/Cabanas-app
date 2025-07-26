import React from 'react';
import { FlatList } from 'react-native';
import { Card, Title, Paragraph } from 'react-native-paper';

const cabins = [
  {
    id: '1',
    name: 'Cabaña del Bosque',
    description: 'Rodeada de naturaleza.',
    image: 'https://picsum.photos/700/400?random=1',
  },
  {
    id: '2',
    name: 'Cabaña del Lago',
    description: 'Vista al lago cristalino.',
    image: 'https://picsum.photos/700/400?random=2',
  },
];

export default function HomeScreen() {
  return (
    <FlatList
      contentContainerStyle={{ padding: 16 }}
      data={cabins}
      keyExtractor={(item) => item.id}
      renderItem={({ item }) => (
        <Card style={{ marginBottom: 16 }}>
          <Card.Cover source={{ uri: item.image }} />
          <Card.Content>
            <Title>{item.name}</Title>
            <Paragraph>{item.description}</Paragraph>
          </Card.Content>
        </Card>
      )}
    />
  );
}
