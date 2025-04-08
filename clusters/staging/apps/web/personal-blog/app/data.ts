type Project = {
  name: string
  description: string
  link: string
  video: string
  id: string
}

type WorkExperience = {
  company: string
  title: string
  start: string
  end: string
  link: string
  id: string
}

type BlogPost = {
  title: string
  description: string
  link: string
  uid: string
}

type SocialLink = {
  label: string
  link: string
}

export const PROJECTS: Project[] = [
  {
    name: 'Trailwisdom Travel Blog',
    description: 'Used Nexjs, Tailwind + Sanity.io',
    link: 'https://trailwisdom.xyz/',
    video:
      'https://res.cloudinary.com/read-cv/video/upload/t_v_b/v1/1/profileItems/W2azTw5BVbMXfj7F53G92hMVIn32/newProfileItem/d898be8a-7037-4c71-af0c-8997239b050d.mp4?_a=DATAdtAAZAA0',
    id: 'project1',
  },
  {
    name: 'Motion Primitives stuff',
    description: 'UI kit to make beautiful, animated interfaces.',
    link: 'https://motion-primitives.com/',
    video:
      'https://res.cloudinary.com/read-cv/video/upload/t_v_b/v1/1/profileItems/W2azTw5BVbMXfj7F53G92hMVIn32/XSfIvT7BUWbPRXhrbLed/ee6871c9-8400-49d2-8be9-e32675eabf7e.mp4?_a=DATAdtAAZAA0',
    id: 'project2',
  },
]

export const WORK_EXPERIENCE: WorkExperience[] = [
  {
    company: 'Fivecast',
    title: 'Graduate Software Developer',
    start: '2022',
    end: '2024',
    link: 'https://trailwisdom.xyz',
    id: 'work1',
  },
  {
    company: 'Intellilearn',
    title: 'Programmer / Data Entry',
    start: '2021',
    end: '2022',
    link: 'https://trailwisdom.xyz',
    id: 'work2',
  },
]

export const BLOG_POSTS: BlogPost[] = [
  {
    title: 'HomeLab: Getting up to speed!',
    description:
      'As an aspiring Network Engineer I wanted to get a HomeLab up and going using Kubernetes, Proxmox, VPN, Firewall +',
    link: '/blog/exploring-the-intersection-of-design-ai-and-design-engineering',
    uid: 'blog-1',
  },
]

export const SOCIAL_LINKS: SocialLink[] = [
  {
    label: 'Github',
    link: 'https://github.com/lewi0231',
  },
  // {
  //   label: 'Twitter',
  //   link: 'https://twitter.com/',
  // },
  // {
  //   label: 'Instagram',
  //   link: 'https://www.instagram.com/',
  // },
]

export const EMAIL = 'paul.richard.lewis.esq@gmail.com'
