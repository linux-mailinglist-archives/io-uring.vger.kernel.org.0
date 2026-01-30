Return-Path: <io-uring+bounces-11989-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uAbkKlArfGn1KwIAu9opvQ
	(envelope-from <io-uring+bounces-11989-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 04:53:52 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 532BDB6ED3
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 04:53:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 596EC303C4C2
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 03:52:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 193DF366555;
	Fri, 30 Jan 2026 03:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lICcBcOe"
X-Original-To: io-uring@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011041.outbound.protection.outlook.com [52.101.52.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7F236656B;
	Fri, 30 Jan 2026 03:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769745136; cv=fail; b=cQVuallK3rGEVgIF0DRjUENkuQnapSQc72tjJ5TAF0l4PisRuIb0THt8xjS6dKoeuYPlIypE5UzWhPMlUKw9X0wwhQO/9jI1jauiUeXH00MDLbgdFHB0xUA90uedrzzOc0troqdQhzIMHcLeaBLCQ6aqcNHVhFsxtwxsWjse+sc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769745136; c=relaxed/simple;
	bh=dj41B5sI/6F4jjyUQFJ8KfDepgIW3zGZPg95eqWcBtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=P3mK73447RGZ1OqILJdvldQYCWuYVQvbgTy1U/5LIzLPiF5G7Tf+eWyLH3WMiUGizvkx8I4IXrep3xaD2b8kXmpEVuMKNQ2JJuq4cJGlx9OpLSP4U+6SZ5sorcOj3qJpHsZ26wATzPj8gs+Az/rlINDkbAi8MmJkH7UMJYoufVc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lICcBcOe; arc=fail smtp.client-ip=52.101.52.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eqJLu1Kc22TjYs/aMSuCOdAc1XPj377P/iV4sukd1th/dR9WsVQRbpu5CVrhe7tE0WBAIgDrFRVimvojLQpAQTBO9inmUq/1Oi/KxxGUB10fJRlRon3KF8FVEF+Y1aDVfpK5Fa6Uzui9955bz3kPFG+DsDS7PpcUV4j6PyXxaLF58LzvY1sGKiV1mAIzRaejXJIYr71w5R6a8jCjiLYzzNMF5jt3vVk/A5kkd/yo2RVzRHTxL1WLNK+9hNXbXFWg8Y/j4tD4ZQcI3qaXpa/T7AOnLuBSy/n1o1crCGasu45e0xkid9GvgQrFz+GxzOFlIoGApe/x1KqkadyMhJL82w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L4QaHhwuZyYRo1vThHw7667LfULyy3R1hHQFyr1poY4=;
 b=BGaEdL5ym9N/MzYoHk14BBCocqS2Je8V/+iFot3X//NdfOL7f52YzlPsrv8tlR0qs49tsmtVk+/WfEeq6H+/W5R1FKkLq9Z6anXuDY2PMqbCTggIJaHwNAjHu47wWo3xWudql8xcxgAD1GV+8We2gzzxbSoMhgswQwT2yaBYsdqj1Ep6VP5Rc/cT+7WK8H6BSkGiaq1SbxX4BNu1VJEcj5PVQmIpIo7Gk3KHd7x6rgIwDjMwl7fW0VAyILfrBY2rAhlZiVhdrBMi6t7itx5EHUsDJoRTYd40rSdAtSJ5OEcYk8G/bFTkhNS9YgDe5ovLngIC4X8sRJFCKSzObLyw8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L4QaHhwuZyYRo1vThHw7667LfULyy3R1hHQFyr1poY4=;
 b=lICcBcOemomcqLMmFEH/1BS81DHKwFNR9OwIcVYVEaqv5Cktnh1PVPZ3Wny8m60WybK/21Ef/KXcS7CKWb96W0vq2hpVIq4UW47ReP7hvcNG6Hpn2FvMzAxY6VYJhc7u1/lknMYHnhC7JEO90SmR09qiHr/QLyARzEV3R/DY7O+tom6YrFwIQCKQTVrcYLnJO7uHak3F+RTYp6Agk5gJZM95m4ArybPhfQ94jklfoVlo73PIJXZ74TPQNLlZjcftOAuWCXgAbUTcovT9ec7cwtMMlZeCh7UagYSKXHqZhpDy4QJnCYhB+X1C/H6tWIZH93VMycNfRhBucW8Z2r2guw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB8312.namprd12.prod.outlook.com (2603:10b6:208:3fc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Fri, 30 Jan
 2026 03:52:10 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9564.006; Fri, 30 Jan 2026
 03:52:10 +0000
From: Zi Yan <ziy@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>
Cc: Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jens Axboe <axboe@kernel.dk>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [RFC PATCH 4/5] mm: only use struct page in compound_nr() and compound_order()
Date: Thu, 29 Jan 2026 22:48:17 -0500
Message-ID: <20260130034818.472804-5-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260130034818.472804-1-ziy@nvidia.com>
References: <20260130034818.472804-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:208:23a::30) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB8312:EE_
X-MS-Office365-Filtering-Correlation-Id: 350d25a9-9552-4671-971a-08de5fb2f1cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7uuWkCaBnMw+jYhgVPLkT8jkd7fJOaNHXTSNXrcqDbcERIdqQ08Q/+FKEpwR?=
 =?us-ascii?Q?Id+e1bsFwdNg5mguOSRssXMWEgVRC8PutAE+C4sszkLu5pePU04CAHJ6jzZg?=
 =?us-ascii?Q?gymXFiL6XNxDeTx7NrthwVA0t3yncuSDgIxGlMmI/ycU0fUEAwtjOzUCcnmx?=
 =?us-ascii?Q?ttyIxTolYoD/uxs1La6KUhOvmi4NdnLNqvsjExwsgL3hEzC4cEflipi40aI7?=
 =?us-ascii?Q?Piymlt2vGCopme2GYZZfWB2EqJ7KYi3bVRof9Q7XyWd5hYoUkWHHXzj8e3Dn?=
 =?us-ascii?Q?B79bhj5Y+wR9l1HuMruLo7G4CceF7hRHNt8XICPecl96AtWNvtJdRBAX5N3/?=
 =?us-ascii?Q?NV4oU9Obh+kloDeICq2QtYy3557mzWC40C4RM6fsc+TWME+DYyP7xKH+3CVQ?=
 =?us-ascii?Q?ndryw9/Ls+AK0nNuDoVFNp5X7uMoKjbRcfHVyoTVcO3HrtlH8dwQcb3C5slj?=
 =?us-ascii?Q?5FE8TfASfxIu57NC3OwPTWowCvsaye2hODmbUEarMdQUVpBaMbQC06/O6frJ?=
 =?us-ascii?Q?kvqQgQ7xK2dcEy/gdr4rwGCruXQsNQnYNSHuPDZpcgvWr5N05YtPRO2T6U/M?=
 =?us-ascii?Q?6CZyf1MBgM8PoLH6dxDF2QudihhDIdQ0bKgzdZfaB8IsuZtRj5UbM9/QNn2b?=
 =?us-ascii?Q?4NbEDN3Xnj7Gj7oPlKW/1Wtvcb1ivRenXROL7KiIQMqTQwciwP6Ubn92coc5?=
 =?us-ascii?Q?A0d+3jeMbIBH0456BR+stIdgqNxYYxRqVALL1U7TAxhF2/kYMil0hPoJ3gXs?=
 =?us-ascii?Q?1cgMyU4WnqZmsv8tUG1SUrMSJEz6MCHNlk5+x73nUnxOZ0SpAMba+Xu5YCW+?=
 =?us-ascii?Q?5uysKrKzuBpmiuVaeQ9ykogpjwkDVO6bC8GynS7mVJGjIxbuwt/oOsJxzyo5?=
 =?us-ascii?Q?UTczziM7d86VcSJl7K8dJBxP/EZ7+sa8SfHjUsvmkrHCOz5XQ20emF5ah+tS?=
 =?us-ascii?Q?FjXNQ4pHuSd1DZK7rf6+XT6s8zmzHkyidJOuY4LyOUyrVFCPFop7hR4efs3B?=
 =?us-ascii?Q?V+h7ig2nSM90olGqef1nSxol1EALA598c+m5LOjtoe+rBr1iYqken7Nledb1?=
 =?us-ascii?Q?E6B4gKWNeOSsmX7ZwODuQNiiTfjjd/EYbetSnNjKjYDgjpB9GUOHbWzzbtXE?=
 =?us-ascii?Q?VPB6L00nmXC9FJZqKRqCuk1Vo0lyj5eQR9islnDg2wEEzBldQISv6rtes40e?=
 =?us-ascii?Q?1WQUCeoXQnFP76nTjrMHUzO27Xsp/pvWJIfOoqc8Hs/EpplSTdbaACEXc6CB?=
 =?us-ascii?Q?Sy+YA2JS3IH0L5q21UuHEqcORHu4iIdggPBCuiT7ogo88/xnX9FZ2A7SDl4m?=
 =?us-ascii?Q?Zbs4k4ctEM2U1Y7bEy1G27QgFTOstCo2P7oJKDzGFRdYZYFeV+LDhhLymQSj?=
 =?us-ascii?Q?Vho8/lAHtP36Vo4XKo4eBMAX+r/zrM8FW1ALjs+S0HPvPJujzKXbt29Dj5IG?=
 =?us-ascii?Q?KaNGoolsWtZjWN6AN9uXIJ804JYw4jboCB3r9p4E2PbS+MC5MeFS2IsGS7Ro?=
 =?us-ascii?Q?sw0cmIx412F9knKHyK/97WHmLcjQFtVIT7EUhrkcp8zGIUQkYcbmi13f7bwj?=
 =?us-ascii?Q?TeU4Z33ZwuCRryExxCk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?auiubOjtTr/3pnRg02l/mFFzeqZkV03T41CApq9/USKBAsb8I5LFt/0kxQSD?=
 =?us-ascii?Q?a3mxq56EAW28p5ANP7xOKIpnf/MJS/AwIO5xzf7xY9EkWh+uPStfsbcuT+Xe?=
 =?us-ascii?Q?2w5wayIVFdiG79q7zWm5nZSPFovw0M1UJuLgHO8XmfnX84DbTwiv2qmxoHCL?=
 =?us-ascii?Q?kurzcRf3gM18kcTGsvD8MrwrMyfSNKZtMJz3WJJ37p05WKb1A1Yn8KC1NtsT?=
 =?us-ascii?Q?PaS5D6VSqvohBA38T2wLYvagUW7xIczS7H6TplhryRAvSh0hPYWs2C5UwIXd?=
 =?us-ascii?Q?ApOFGbKOK750g48L5A9ocaJIvl8dLzBUNdCtnyEJZchjFACQ4PgCO13FJT/b?=
 =?us-ascii?Q?Ev6o4e74J5oOC5C4OWPmEE0PHYlS5SAXMN+01SIPklZepkxulldxlOEbytr/?=
 =?us-ascii?Q?Zr20BDnYft3TUYE+44mLZfY5Q52yc2m9SAY9qIjKB7mPYkUJFOd251f+tmdr?=
 =?us-ascii?Q?lbIZz0Dqjbh+0N7LCOYEUk+W7le1IR/ow3o0Jng8t0OfElWFB/Nh7S3HN8Le?=
 =?us-ascii?Q?itzSacIlPL1eMwlMuyElTRB0FnMJ6eG30ARGfZWzFq9M72VRDTQjCqDF6zGP?=
 =?us-ascii?Q?l9Xq3F6uYEXut1Bj0ECpzptM82FWce+MlsSGkapwT7kiBSnc15pUbdTMwjIS?=
 =?us-ascii?Q?4xy4+VYNetoDIUsYfx/96E4WVSX5iQrrNi64RKkH4fEVyhPv7KG9IaZBrIt+?=
 =?us-ascii?Q?J+pl0KuPpkoiZtHDKGqf7AfSZukvs1d1Bcu3jQQqTJkZBoffqY/5bU1bSLfC?=
 =?us-ascii?Q?3e6nwUvGG36A0oTdTPvbnFSuDPLtShNBjCEM85pTe/SDLE5t3qqeYKvLQdK0?=
 =?us-ascii?Q?eauC990w3rXFu2RsG1ftuFt3TNthc3foaMvCJh0TOTsxArGZhd4e2pgpqBbi?=
 =?us-ascii?Q?MHASjI2akhqV4JrH8rbUJdxgQFJ8FhnR/GvDh869fmJYR7IEeD6ucdgR2VlO?=
 =?us-ascii?Q?dGkwQxMjVNdiknBx8xMu+mTrs12CDXChcZnbgYzU8rL/rSvyZvV7I+KYYd40?=
 =?us-ascii?Q?EjbDr+bawqhFiC3dsb8OHNFSLY/tux9fvLORakJJPmcuJ6ZlQMg3N0nTukFa?=
 =?us-ascii?Q?BL7hfP3xFdMHGNQeksarpzg+0ykLQKWa9R2z1C4kYhD1PvopN5J5pJ2iM4LS?=
 =?us-ascii?Q?5/qVVYvLIVRvhoBnpNOl/WdhYwNoAb4Pd5eJnYK6eSlOF118AURC72FUV8ig?=
 =?us-ascii?Q?f7kNiHkYkn8km4iGwROce3RhMQ+bqToPhHKjpXK1uNxx+30yFakIi0ijPRTd?=
 =?us-ascii?Q?sg6kJ7AgF3murqWxV1jDzXNTKSY9Edlbzl18g8u4bmWWrvZdMT6masLGM7RS?=
 =?us-ascii?Q?8aBKke8vIiXDesKrNiPTCFLPaaq4AUHuLQkZfK7lzf0i3cGcvMZpAsKHqAD0?=
 =?us-ascii?Q?nf3VTP/mLRSSg5+maHTDWDX2FH5gEcOixfd72H+XqSUK7PI3NusN5orhrqik?=
 =?us-ascii?Q?VZkl+kIWiFNoAJinEeGeRNOjBzYuvmNBAEuaJa1/AMGA0Xq4+lPnJqp/hbI9?=
 =?us-ascii?Q?6kAWPG76ck5ERM9Mm2cq3t9rAhBaJzRMXAczC+PnVFiV5XQJTQbNPKVGOJKh?=
 =?us-ascii?Q?Qug9vOavL7xbG8AHPPsAgPd61uH57/dAwTwcxZVtOxwQayTtA9HUc9gfCWxq?=
 =?us-ascii?Q?wTEE07Wengsesg8MR5WLh4dCIpk0gaLucISJ0XCMjbBI6DZrcY7u46Nmevgu?=
 =?us-ascii?Q?kRjiwoWXst2/v5+P/pCnLDQhfwwUtHfH64xZV4dS3GO/9cgy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 350d25a9-9552-4671-971a-08de5fb2f1cb
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 03:52:10.0046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rZBH98EMAkhUzQDRZp4LmKiv2MSTSYR0i+SeupccTzcOcBL5dd+SgUdJfPglkijW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8312
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[27];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11989-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ziy@nvidia.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,nvidia.com:mid,nvidia.com:email,Nvidia.com:dkim]
X-Rspamd-Queue-Id: 532BDB6ED3
X-Rspamd-Action: no action

A compound page is not a folio. Using struct folio in compound_nr() and
compound_order() is misleading. Use struct page and refer to the right
subpage of a compound page to set compound page order. compound_nr() is
calculated using compound_order() instead of reading folio->_nr_pages.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 include/linux/mm.h | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f8a8fd47399c..f1c54d9f4620 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1428,11 +1428,9 @@ static inline unsigned long folio_large_nr_pages(const struct folio *folio)
  */
 static inline unsigned int compound_order(const struct page *page)
 {
-	const struct folio *folio = (struct folio *)page;
-
-	if (!test_bit(PG_head, &folio->flags.f))
+	if (!test_bit(PG_head, &page->flags.f))
 		return 0;
-	return folio_large_order(folio);
+	return page[1].flags.f & 0xffUL;
 }
 
 /**
@@ -2514,11 +2512,9 @@ static inline unsigned long folio_nr_pages(const struct folio *folio)
  */
 static inline unsigned long compound_nr(const struct page *page)
 {
-	const struct folio *folio = (struct folio *)page;
-
-	if (!test_bit(PG_head, &folio->flags.f))
+	if (!test_bit(PG_head, &page->flags.f))
 		return 1;
-	return folio_large_nr_pages(folio);
+	return 1 << compound_order(page);
 }
 
 /**
-- 
2.51.0


