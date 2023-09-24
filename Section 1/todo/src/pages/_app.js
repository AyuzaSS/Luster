import '@/styles/globals.css'
import { ToDoListProvider } from '../../context/ToDoListApp'

const MyApp = ({ Component, pageProps }) => (
  <ToDoListProvider>
    <div>
    return <Component {...pageProps} />;
    </div>
  </ToDoListProvider>
);

export default MyApp;
