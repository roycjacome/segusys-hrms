export type DashboardStat = {
  label: string;
  value: string;
  detail: string;
  icon: 'users' | 'shield' | 'clock' | 'file';
};

export type LiveShift = {
  guard: string;
  code: string;
  location: string;
  client: string;
  status: string;
  time: string;
  tone: 'success' | 'warning' | 'info' | 'danger';
};

export type HrAlert = {
  label: string;
  owner: string;
  due: string;
};

export type GuardRow = {
  name: string;
  code: string;
  status: string;
  fileStatus: string;
  equipment: string;
};

export type LocationRow = {
  name: string;
  client: string;
  guards: string;
  status: string;
};

export type IncidentRow = {
  title: string;
  location: string;
  priority: string;
  time: string;
};

export type ClientRow = {
  name: string;
  users: string;
  locations: string;
  status: string;
};
