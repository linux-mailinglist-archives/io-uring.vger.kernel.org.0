Return-Path: <io-uring+bounces-12051-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uB8+A7GUg2mppgMAu9opvQ
	(envelope-from <io-uring+bounces-12051-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 04 Feb 2026 19:49:21 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AA1DEBBFD
	for <lists+io-uring@lfdr.de>; Wed, 04 Feb 2026 19:49:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E3F4D3010D97
	for <lists+io-uring@lfdr.de>; Wed,  4 Feb 2026 18:49:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 725DE348865;
	Wed,  4 Feb 2026 18:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uVs3r3m6"
X-Original-To: io-uring@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011002.outbound.protection.outlook.com [52.101.52.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16513346AFC;
	Wed,  4 Feb 2026 18:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770230958; cv=fail; b=QZt8y9lKctS/X9XnWJC8fTPYngDYH6dTn4Wf41r0U3Rxc4AH5uFZCgkwwqcM9crok+Zn+QnePdSfMekKTHw71tlEd/opqcSBnlDtCBO1zAYXhDy7UHc7pxuef2Y7IldOW+QEeJiQCiDLSLg71p+fIkPT+zSDPvVaflRDDHpzVak=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770230958; c=relaxed/simple;
	bh=GuusEgYOYoDSaXRMKDV1SNpnXCqDf1Un/CYcqj/5wmE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GHt8HdpyE6FVXvbGdELkwKPNB6Zu4aY9YsK9rFxlmmv7xsMqdEynHNMPJ1k/DaDhXY7uriM8aer8vEIZriguUbx9n4Tr9qwe0cgkbhS8PFCutq+PL37AvD/NjPQwBJOTNXLcv0GDYX//QBlUdYzb6mxxHxCVMNrTLXi2lt0Ow4A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uVs3r3m6; arc=fail smtp.client-ip=52.101.52.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v25YbOw1iUKceRefGzoYNboLCF6muQ6aGFkBPbEtTXZecCek660rIzCb9+GbzuR+N0nRhfkFUxzMoTGA+sW8gkAM8BwmYqcBf8aKshd9qRT8WCwnkn4RptBCGKJEDZ69tObE2xtSVSqLoi1k3yezYsj488v1FFUbWTlJwBmu69LZdtV6EZ3LHcn03hFL9PfWAJ3Z5Flat6YDAfM2JOxig/7H0yC9AZ904gBqMg4gvEciRY/zPtvgcqqGYZruYPgieaPjGN43+I7E0+hvKDXUiQxXMEKWqTCFMZV5f1vvzQSJitEmLleq8nzmGLt6P6t7Kqwk8a7NYV8XxfTt+K550A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+1FKG9fMNbausyyl7k2+oCkumYXbuWsznPRJHS+PdiA=;
 b=PEjZ8pnIgeUnnF3SAf3x2mEx+leUkk5lodYjw55n8p3xImfGxZEwAwWGFtP1ctmxczGCjI3vTZu5MHHBez8CpmPsCkYAreQ2YqYHTJtT8lCiRidPIyLgE6G/VJYOGUKMhmlPAPlo+RjyTUMuDGfvUlSDtVXYI2JWjtB5WaGagcPiINr98bUfmhXh/ZpkMNbZ3KW22iZPMZxNugerkw0wykwZDhenLlKHhZHxxZ+/++eCNkLyi0o/wDFj0l9gsX/BukcHXCXobaSWFYv0/LFKi5D3Lp/nUKLnXRL9YRZDTn2yPAlWBkaZuOChUbm1igR1nyTDfr9I7ao6sG5GAJUk3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+1FKG9fMNbausyyl7k2+oCkumYXbuWsznPRJHS+PdiA=;
 b=uVs3r3m6F8YgxC+RYJy3FRrWklTzWOclqcchiPEhgN+o+Jx2Vh1nIir85u/xoWMCpuD7qsoCXbC6ZjVJE0bkSLHo9q814lPcgUd2Ednzmzzh8E4d8Ir0IUuvaWnR0KUHexqRyPSbd0iUPxcdzgsDYTb1/PC6guN3jk4OnCM85KD7/0ZvLZ64ZwkNq3MdybTmQ5+tlnTI46tDtdOmcuhM0+z1a8mzCwiilMk20jKASiy9ii5P2WXlkj6LauqwGrTeAYrav837J8zYsg1+3sgrsRoVbIL0icL+8BA43kSx+Hg6yE0YT7vYw7+s6J/j0v8LswS7TV+75+Rp3Ht6FMItug==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SJ2PR12MB8739.namprd12.prod.outlook.com (2603:10b6:a03:549::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Wed, 4 Feb
 2026 18:49:13 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9587.010; Wed, 4 Feb 2026
 18:49:13 +0000
Date: Wed, 4 Feb 2026 14:49:11 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>, David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jens Axboe <axboe@kernel.dk>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] Separate compound page from folio
Message-ID: <20260204184911.GI3931454@nvidia.com>
References: <20260130034818.472804-1-ziy@nvidia.com>
 <70e06ac9-5cbb-4616-b20c-33f5bc1601e6@nvidia.com>
 <2EF8F5BB-7CEB-431C-B9CB-00B1E3E44E1E@nvidia.com>
 <33B161E0-5468-4A31-A5BC-B4F1FCE72CEC@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33B161E0-5468-4A31-A5BC-B4F1FCE72CEC@nvidia.com>
X-ClientProxiedBy: BLAPR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:208:32b::18) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SJ2PR12MB8739:EE_
X-MS-Office365-Filtering-Correlation-Id: c2695b7f-bfe1-45b3-5cd7-08de641e16e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9cjiLVZ0bX4WU7amxnznV6Xi4iY3BSMjZKfXzIYMrix1WkAFk2QqtQbA7UnY?=
 =?us-ascii?Q?jmBDdnIuAForDdmCaAKTVVQSF5Hq0wgc8AZ/uw3zOM7eenuEX3/VMxOJ7024?=
 =?us-ascii?Q?bfd3pZeWurGlvgLTLPaB0BQGSfrVLkFZpY7PrDmhJ64Q0bWNi/zGporvByVZ?=
 =?us-ascii?Q?S+WHgcq2WatlpHTwEkOZMpuFFG/XL6YfuNhH1Lih+kGVVi9N7HYpQdOFXVS1?=
 =?us-ascii?Q?avRmn4JYSDO/m+ViDgdcgv8Mc5339dYifdCNZCZy/UQkC59JEnhoTKKBDdRN?=
 =?us-ascii?Q?5eQSGfrMVy18Yc0bsSnTpiWF3U86MhwVP44/VOunosbh8VEEEP/XXQsP6hv3?=
 =?us-ascii?Q?QR5knvGDUNpUi2j4txZgmsIa9+yFNeEee+HjR4JRhxMqeob794yP0C5DfIc/?=
 =?us-ascii?Q?E9ODoeOdgcsir0Viqxi9OaIAWsGBozXcyOX9M2OtBEQc2QeVITtBwkbYOlxz?=
 =?us-ascii?Q?nwxHabC62J2bYmSJ72NFBaCwVK/0Ti2WFK5ovqq4mT0ke4Kl6XZk64auNRkq?=
 =?us-ascii?Q?TVdB60M2eAfbkfYPaXrkWgLZOiU0ICUm9QkdsoBYU5xXfaw4Yn6fV26QDvNS?=
 =?us-ascii?Q?39zWJGgtFofJdFbn4B7E+82bNWuuSCuZNxfhpYjNfTfCgIh1/VDq0mkaotrG?=
 =?us-ascii?Q?bL7wFHN2OpEucOQIuMHpK9mp5dqLBqoBnYtgg1RHeARrdfy/qvyz3BEN1PuQ?=
 =?us-ascii?Q?efg+tbhDhZGrSECAlm+P36c/f2K9icP1/6DCsAzIPU7dwO5zlX+YoHk2ydbe?=
 =?us-ascii?Q?Eac5+7YvDuBt+oyQ0FRn26cRBDMNILfUggt+n9NK5y1+KzY9/0V5NnL2/GFF?=
 =?us-ascii?Q?RLZmH8dwGuVZfyF6yBTd1HuN3udTL1JNGe6Qo0IM/qGpUBZfic4cMnRpFupf?=
 =?us-ascii?Q?0Ig5BZCf5fiUk9FOau1jtAD1phIQYiDv1MGwcc+tkOMscIB7MPbOddWA73fE?=
 =?us-ascii?Q?8p136BLwjeZN3PmWH6uKmqaBWpCpCA6aFw/D6ZJ1SfVGUQOimJBzfQjWOaqm?=
 =?us-ascii?Q?LXesFswGTsVPNFi7vgERLXkWDNJ9WZYzoLV5PIY95WU78Vi5Td1npaVcB6Ti?=
 =?us-ascii?Q?xi0YCDH6ruVNlNF2AZO1WQhChOY5bnWIYsVO/v3KwJqxHeREiEDbC5vVf3ZL?=
 =?us-ascii?Q?r42mQZNin7gmHrb0yi/M29+Wapw76Q5tOk8mGnr+20rQN614sqNpiNPKGRSF?=
 =?us-ascii?Q?Ziat5AOgGksQgcglrvcK/yeXjvr7PeJlwEeQU3Ssqj5Ol9D4oc2ze8dpVl1l?=
 =?us-ascii?Q?6r1kvthhm1OIZs2zTp/dJ/6ne3R3KnBgCoHQDFONz4OCQXUdp/KnlFfU/0Az?=
 =?us-ascii?Q?vZGG8QWjIIp1kGF+gCr4LMDBHZ4LnC4mt7YBFOHETAimo/+XAVL1JOmaszmj?=
 =?us-ascii?Q?m84dxacJpEC126YhpzqOhK95VArmmxsz9XnKuLIkDjCqFz+vM+vNpYhKQhd+?=
 =?us-ascii?Q?IW8E9qAjQuwaOFy0eY0bH8Ni8aPA53dO3XZGMOU1uWJIZ7+0SO0FC/nn5GKr?=
 =?us-ascii?Q?+QD5C3GKdEFGDePbcJShSsTKH+/8ZpU5Wq+X32QuTR2s9n0YFmrFnC0AFS0m?=
 =?us-ascii?Q?HBut9RMkjMrFE1m135M=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nuA8b5iv4NVfJr0fx7i/wqLarH8iE+Pj/q+GvmoGGlYuPsJCx/MYK3iBiTsK?=
 =?us-ascii?Q?9peeMW21fNsu+9rIIT5prHhPtIU3iSCi8oDDrvmNmmY4iTPa9Viap38qDN9G?=
 =?us-ascii?Q?XKo9mWiST29q3OxDLFFZOcIxC3G9CSohWVUuqk1VjaIlwK+XC5zH+AVOdrM8?=
 =?us-ascii?Q?WZCs8ND0fh/wzk0lgKQU5SUXxHwxFDRu2hpEmBLZ3gbtjlX1f8/lcFAgYWAm?=
 =?us-ascii?Q?sBX6g92o/LYSlMqIlcy6e25Yp4FsGnvl+YApFg7X5w5FVoIiGpx4DVzGUDpB?=
 =?us-ascii?Q?a8oOnSqPyD6EcMOa7lTlRR7nMtTAsVHqkFaSydPd+ee50j8n8G7R/Okfmf/q?=
 =?us-ascii?Q?FEVGgKL4qyOhy/lPdsfZAtuXG4P/shmNTXZbVvgWqFve5Ruyzv3/Z/UuVWJZ?=
 =?us-ascii?Q?lVBc8zUBtm2p8B9WJKORI/hJdFpHMDdV7IuC5N4SfR3bsyLFawf49OtQo9Sb?=
 =?us-ascii?Q?glFNmFvFEHb7MjqBXKmfT9Gk+f6uaQWPAJ/fRM+Sj1mxHqC+VS0zGKBC/WKJ?=
 =?us-ascii?Q?iBD5x74H1l2pAnapkWMEbV78Ksp39VAwoVcBIswbbZgEqVbNFt68FzERSoRv?=
 =?us-ascii?Q?xg2W3H7GBDtdfAeTrZ+9dhYsmFLaUA3uX5eluKwg2UefH62ruSv77c8bFyoy?=
 =?us-ascii?Q?97mE/YT0QaaGCq5jsjfnnsSnFJpFKEWSLcx3qLUkOmm+HNdQSkjr8IVZxox2?=
 =?us-ascii?Q?WbXy2oEoOzrG3C9qo0HEoR0aK/tf92zEMIkuQBfpRvmygJz3J2fqUi8/+Em0?=
 =?us-ascii?Q?T1ye6lsgWaxniZEUcaD0EaiK09qZo7Lott9KX+MaXSWP7/E/ViHafMeG5CY5?=
 =?us-ascii?Q?dBqYf7aZUhH0W9hmn3pSkyKyGPQWtkKgARCO7wAbzt8CARIBe4JRb0zI2wic?=
 =?us-ascii?Q?gxzNXdkAQZQ1hioRYks29ph4iDACA0+BZdLgbCYsx9REpospsAAOeHbJ6xRJ?=
 =?us-ascii?Q?39+rL1LCRqFG5N8Vmt1rd6qapnBn/6/ChFn8Lxc371oPjzi5nN9vNU1cg/cK?=
 =?us-ascii?Q?YLxUx/WINfngF7V784kgEo1BIRPaNBQUsh7MPkDgpro+Nexy7gs8I8DxmWx6?=
 =?us-ascii?Q?m5eE2cdtk89QLElnq4tHu6qGdv1zP984WxrFYuADmoLM+uo/95j5vHq1pRHD?=
 =?us-ascii?Q?p42K7rG6M4Ag5EAtKzCYJ7lG/ypoDFAik1V6CyWseWJjtJWK/NGsjPvUOR4r?=
 =?us-ascii?Q?Ybyo6p4chAUi2iil4ejuscR8Bmv5DuXMRlcvf0JwzHvajzaLfSt+INLk3w+b?=
 =?us-ascii?Q?T7WWlbpPAsafTajDJ8aq7YO5gWiCNInCO79AwSvR9b2H4YIE+WrFMxjYkyt6?=
 =?us-ascii?Q?Ts5nw3Qbxcn0G9QrTBWx7JjQTd0LYZAJ46rsOcl79KPUlBW8xbZBqxSo9dFy?=
 =?us-ascii?Q?hiPoybTlLKn2SVPlRFtt7Fm7juctZIQySOcBTX8A3p+GGAH0gZhJiTiDSdk7?=
 =?us-ascii?Q?Ylz9jVyugKBAEZqWC1DDypxPlup/byXYS2huqNLIoY9B69pgFyAiM1sJ6QBu?=
 =?us-ascii?Q?isVYq+iS2S0MGT6K5R6Se9yHZlqbcp7VixpVnY6/BSNOJSuv46ZAsH4c3bTY?=
 =?us-ascii?Q?CuRW3aEiIqDqQpTcJgR8GFIEMQgXORVmcTw6bNTkGd1zNYl7/tSSq9q22Fq2?=
 =?us-ascii?Q?W6YOElrqFsq9FdOHAS6o0QgU9vNWMyS8VffPwshBsFBau1oyX4z0XZlC8U78?=
 =?us-ascii?Q?jTXPccyru813l3VxIBbsPwBBaQJfTp82NE/VLnC+qAu0azB9UiLHPkDuNMhA?=
 =?us-ascii?Q?VBGUTiL3fw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2695b7f-bfe1-45b3-5cd7-08de641e16e2
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 18:49:13.1389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wzjvfb9t2P2OU5ZmNYotyeYHY9XYkXpQ7xGqOEcM31cBQKbaieU/HR+7ookcwrkj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8739
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12051-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[26];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jgg@nvidia.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[Nvidia.com:dkim,nvidia.com:mid]
X-Rspamd-Queue-Id: 5AA1DEBBFD
X-Rspamd-Action: no action

On Wed, Feb 04, 2026 at 01:29:45PM -0500, Zi Yan wrote:
> > For in-tree users, I am converting them all in this series.
> 
> Considering a recent report[1], where drivers/scsi/sg.c allocates compound
> pages with __GFP_COMP and maps them into userspace via sg_vma_fault(),
> I guess almost all __GFP_COMP users are really using folios instead of
> compound pages.

This would be my guess, and it seems like a good cleanup to make them
actually create fully proper folios if they are being mmaped.

I suspect the only places not using "folios" are frozen page users (or
places yet to be converted to frozen pages)

Which is back to my previous remarks that having a good definition for
what struct page memory is allowed to be used by a frozen page user
would be helpful. If the mm can retain some of the tail page memory
for itself you don't need to make several of the changes here.

Jason

