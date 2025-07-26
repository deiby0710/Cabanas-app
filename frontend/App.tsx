import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import Navigation from './navigation';
import { Provider as PaperProvider } from 'react-native-paper';

export default function App() {
  return (
    <PaperProvider>
      <NavigationContainer>
        <Navigation />
      </NavigationContainer>
    </PaperProvider>
  );
}
