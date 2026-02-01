Return-Path: <io-uring+bounces-12007-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sx3xMtK0fmkedAIAu9opvQ
	(envelope-from <io-uring+bounces-12007-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 01 Feb 2026 03:05:06 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1610FC49D0
	for <lists+io-uring@lfdr.de>; Sun, 01 Feb 2026 03:05:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E0BE1300B9D1
	for <lists+io-uring@lfdr.de>; Sun,  1 Feb 2026 02:05:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A0DC19D08F;
	Sun,  1 Feb 2026 02:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="unVPThiU"
X-Original-To: io-uring@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012056.outbound.protection.outlook.com [40.107.200.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2531186E58;
	Sun,  1 Feb 2026 02:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769911503; cv=fail; b=IVbJF/PDJi1+ucrX05TagWnlH3A0T04YvMCGfKQ7xIsmu30d+KzoaDFuYRHLcWkPjNwiivE8s3L9GHkAwa7OYOF9G+44KrCL2URe7QQb2jQMVFPwYZOqjqrTitngKyjLDb1YiOdVHwfxVH22m3Qk95z0mmK2m0Ry55/wa5Yv4ds=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769911503; c=relaxed/simple;
	bh=xD4fJLQHDmQGrkAotX4VY/EjzvnvGVbitS8ftsdnMUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OwOQQepp6KTUVs7R00GHPXKjSqto0vay+cDEOWB2jJW/pk5wEIxZ7XCXoV1kcD8raGOowlROzsVVSJe3t6iW3TwZR0W6wORI6K+NOGecFCx++6Hln8XHVHtUKZbVWKXng61UrGvzP4NJs/NMRF1Aij5erT1J4roAr6InwoN3gfY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=unVPThiU; arc=fail smtp.client-ip=40.107.200.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oQPklptp/MuRjJsp/iD/UbT7kl/KPzH6yjREvxGqbSb5tu51HhVYyRr9Cyg6jMs8Of4E16RHQJtTCACOUzq/a6wVQp6yi3Gdo2xlEQXhLVhFqiFZQ/i1E33Cr7UL448lPDt7Yd8eppAh3X7Lj3+6kAj0EBtmL3TZIZqgjBxFA6zokCVGqSiEbFsNcY9C6f2kpdAMxwuAhcbUpZKoB8Up6uZrXJgMj1ckOqIe+zZsniPkiChP6BxetkLp5nVFNN5ofw8VQWxSBoI2Jkt7nmo3g7ikjZtvoN3+mYrZIh45R9PhNNMK2gNXGYo9vHEWoCg3zv6svFzCql5i9RJMaULFNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J+HxjVzWLqxjln6wTaGrk/5SNzJlaDilJHpG/gjcCgc=;
 b=hvERO5cSjM12XLrJDy62QwhKur1SJs14RgbxG0L+afrXX0wCtWMtiJZLWM26oPgQgnt8cHB2Y85nONALM3tqs0kqdPpYO761mt3Xn8zKo8jLj63qKN4j8Xolys0eJfNMKJTf6yhprOyU1b3xbcJojSLhlZjYusaY1TnKOOK1QtU17S927tOC8wR3asM35iSGkGCmOcueM0ZnCLOMBiHtNk22O7V1uYE7jxwtKR3CGski5qdYOFOIClhxLj13mrQRw8VkU6DWuZMjdjEwHAYpCeMaWZCptn/11NnRcgb4eKJdEbLoBJ4DR/4GtPkK2CrdrotszEb66TBRVxuBJFdg5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J+HxjVzWLqxjln6wTaGrk/5SNzJlaDilJHpG/gjcCgc=;
 b=unVPThiUzzorfiRSlryOnZchOwQE+ajGNfliCwBsIEn4GDQQQN3MCmP6VnL112kEYwgL8PZs28vSD6RNcLeOvYCFHoeWT6MdS5KEN3GSXH3Yl4k4GYQY5VHTzv5KzTHDnDInAAscYTnWhIDlp7GDEo0u+bNl41gVhwW+vlXIfSBC49Ljc0cOs7b+fibwAHtJC9feB3hYgMI4xvPdicrLrh8PE633pd5ZIqw75/I4pSvG6bp6BWl6MO+B7fwwqHGOJlBgW+o5AGLJ1OtqKgtYdY3DwCGBhKtjjHFARM3zF6RkDv3vxOK1UQRrbvDXSO9aGx9+U2rntmxd6WqZtyJZ6g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA5PPFCAFD069B8.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8e1) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.15; Sun, 1 Feb
 2026 02:04:57 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9564.010; Sun, 1 Feb 2026
 02:04:56 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: Alistair Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Suren Baghdasaryan <surenb@google.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Michal Hocko <mhocko@suse.com>,
 Jens Axboe <axboe@kernel.dk>, David Hildenbrand <david@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC PATCH 1/5] io_uring: allocate folio in
 io_mem_alloc_compound() and function rename
Date: Sat, 31 Jan 2026 21:04:53 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <01AA2C89-9E6B-4C9D-9072-147FAA5DE7C1@nvidia.com>
In-Reply-To: <b37f990b-cb70-489b-849e-202eae190c37@linux.dev>
References: <20260130034818.472804-1-ziy@nvidia.com>
 <20260130034818.472804-2-ziy@nvidia.com>
 <b37f990b-cb70-489b-849e-202eae190c37@linux.dev>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0133.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::18) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA5PPFCAFD069B8:EE_
X-MS-Office365-Filtering-Correlation-Id: 7beaebc6-8a3e-4c04-23cd-08de61364bdf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?I9badF+sr9QzFaMmjCtCIGCbjPDfSPr5gzi3W50MeWfjkURvaN5lX0M0sRLP?=
 =?us-ascii?Q?b3SUv4azHDXEFFQ77l72qz3h5Y8B6cyoMG8Ee6tKg6YsnKZELc04hNd51ylO?=
 =?us-ascii?Q?Eeek8um4j5QnOF4GGvUBqXvgWoY1g7xTpqRKODTDcVC/Z6/VHlEJjHbCdxit?=
 =?us-ascii?Q?KrF99M12qzZJEVyjgyfPr7Np/sVGiGBcPTJaVgYB/AxvfmcF/rqqIeI0uKo9?=
 =?us-ascii?Q?AbF4WmVKrNe5gAPFcd7Yb7KZkJeDAxzCQkka1pbApHvmwVsZAKHw2iQ95dRv?=
 =?us-ascii?Q?+V7GEGHE9WnCo+UJrisiwQvpvZdTdYDBHV4YBIGydE9gTqBQ4Z/txNu0zvvM?=
 =?us-ascii?Q?uQzKruEl3wWeFpIf+tuqihJj4acPNCsAyY316r0zYQzgrtckoIcSVPj4AXzy?=
 =?us-ascii?Q?u5s5Q9fiJWetjMBKKKPhUMh/pe34X2AUJMf5s27Gwg92K766gZMw3LgBPxLg?=
 =?us-ascii?Q?qkU+XJbqgKfNTpECzp7ZVsBUFcHwrcqzUEsGIzQvYnlfwTMGjY6WeuVgHn5Y?=
 =?us-ascii?Q?H1nxaKVf/nhBI/umDBAW0McmnNjE6o8+BW8st8vJVcJVBhKQD0hPi2d4GsPW?=
 =?us-ascii?Q?GNVJUCu4W1zjX5PE32yy4K/qccLshUBIU7aLgClS3IM7HvwzeoHLpWXuBGfz?=
 =?us-ascii?Q?1otwsqYbY5yDAiPhnbiGSCsf2ngeG6Khu53PYa/01RkIT+u85AyFr4MEklHb?=
 =?us-ascii?Q?yBU5cwKQMBaxgdkTqYhDjPN501xXL+BwYRWQxft8XoWMIRAO2Zf3ZNMTBeV3?=
 =?us-ascii?Q?DvoJ8pCdx+IXkX8Ccgcp07bNfCju1sSqyIi6dBr9d1pYKsbqC7yn4fW9/VH7?=
 =?us-ascii?Q?xXTJgxBKGQH/dnVDp8WU1NaoOESYPfxn9q8fuQ+Zacz7yeiMq/MrZopBkcUj?=
 =?us-ascii?Q?qnNKdKNTBfuDZcSYgrfEdoBx/Xj1gsM93TXGlHyUsIYhQENVT+BHX37ZYSsl?=
 =?us-ascii?Q?7Oo5uJ+GJzK3Qeh2abEqbiEPxg85/kq5i+cliIs8KvAcPHy7rSwdl/EZowgv?=
 =?us-ascii?Q?k8/HRFSioFmPSkzC1JFovae0Z5CVcIx2FADrvJ+L3JXHVBnrn+3vundaHg3Q?=
 =?us-ascii?Q?ycXrAiLOvXvyASPSX8w0m7dnaf1Ck3t9MsVxdq5pDilSngcYK+fxEKWbVCjE?=
 =?us-ascii?Q?V40sA0kxnVz0Z84aF8Id3AacOnXWbG9YQ8Q2Yu0Q34V2cm7CzqyjfLHYPisn?=
 =?us-ascii?Q?w82w0tNiz68OiXyBTO9neTah955eRqAqsp2acYSNQF0aiqeAsHBtTE/zwkuF?=
 =?us-ascii?Q?4QQqttngeQNwXrm2N6FSSvvuSD2sCyCehYaPFa4KQdklBT377h+PXbgbzyY5?=
 =?us-ascii?Q?hG+9wZKlcNcNX4qeYuO2reGSsgFG0AbqFnWXU0GrEbST5jQL0YECRGvVgXx1?=
 =?us-ascii?Q?vncu/o3UVX1f7ER1ihw8AY/QD9vVJL3duwgFAzeAPA4ENrvq//Rz6xcw6fc3?=
 =?us-ascii?Q?Zh9xTUxCD0uNO8Ln9Q92e1oVk7YSr40VbFhwHaTmWuAR32QoHqsbW1GCv+tN?=
 =?us-ascii?Q?IssuySzpzWMIFTXzPYoK0vToVxVIJIJqUwj+5e+DuXgDkDpqA/m62/skTbva?=
 =?us-ascii?Q?eZRdqM6Tq2bgrCPaynI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dBXaQLFxDd/TVc026mOWY0XsPOUoBZUga+FVK1aWgv5OM4B7nbS9Y7ZGhYgK?=
 =?us-ascii?Q?csm6zIMrasVfWVxiMEX99c2Bs0o0xlRvAnwhoKFTB8N+QCF5uKKhq77Wceb3?=
 =?us-ascii?Q?LoNJtsFypA6EjjQxrW8gRLHnLNMh08mpXwokcIjDH1QqG+J0HX3n2gXPUNOn?=
 =?us-ascii?Q?BFSthFhuHam694N3jrSnI//VlcJT5I/Ns8kOMOC1LZhCrNx2zebWNAcqxPZB?=
 =?us-ascii?Q?G6fAZN/FAxoaADolvtZHIN4UDbMhqDzBeYkwlMVGT/gAunc+DgeMnhfwISCO?=
 =?us-ascii?Q?GCNl7NQEi406BGk2HsGJBkwqvqP7NsBN19OSy8I1K+jzFPBjcQPqAdkNYElC?=
 =?us-ascii?Q?9f+Y5X5s03xnC6tBRF1PHxZbiP8y2A0jnp3kl/vDD2sY7zWBdZszjkKESn5K?=
 =?us-ascii?Q?wuEaLH472u1BTha7yBLsZ4ZVoTPKh5W6CqKdkTHd1jlYzaB+BJvJzVLCq2uH?=
 =?us-ascii?Q?YxNvm7hh15m2gMWgeVzAKGX8c2JNd/0vqOIWxUIgezXkE0Fg3HgU+Vnfy4yV?=
 =?us-ascii?Q?dv7qAhNBD61JWWJrOPL69vaL2k++ZIsLpOitTpWPQt5jSHCCangYt4T7SO2E?=
 =?us-ascii?Q?g15YEgl605f/KFt9RLilIfoUrA5+bdWoCcBXXTYQJDse0/WedyykqMqpbI/x?=
 =?us-ascii?Q?rQXNXNmQC9N3grzHTFkhwNwF5sqdA1ONAJL8LLkvLOWdn1nWrKLMj4Ahp7mQ?=
 =?us-ascii?Q?rQ4HIuho1AmT5BlwEnC3lmbixf/NcRnd9fqzNan/g6ic1hAR5EAI7Rlcwmmr?=
 =?us-ascii?Q?6P5mkd4QriPCkgPIhBFowQLzCorXnOBoc3nvRm6VFByGxFFwxPub+GVw48F2?=
 =?us-ascii?Q?lREKUQLdjIILEwIv+VlYGEqaEFg8tybEGen10IDZBsX1aPd/lyb4fBO0txje?=
 =?us-ascii?Q?aCSCutVUKQ4LKTJF+wckPCRWg8rkx4CjetASWGmexpJyH7vHglnEZwPNH04Q?=
 =?us-ascii?Q?Xf43WtfYfaFZuXGr2LHxKvK/izRWMRE294zy6nmHCmCMhu8Dj5E9i6WQ7snK?=
 =?us-ascii?Q?G0SllNin+KeYxjkRna4vHojQXAKfSwrenEymLSFLwPWbv+1KZo6rr6nLY+Md?=
 =?us-ascii?Q?HVIgedW6WajtYq/3Z/Kwui+5gNCNZQif4s9ouUkCP8n55fCB0GIPqzW4goQg?=
 =?us-ascii?Q?7tpTJHI4tRvcC4SUhb9qzOFaWz7h+u7TYddBK9kZbygy8IIyLK16AfhrfaAk?=
 =?us-ascii?Q?mBN00cgjthegRQSDQpgFBQ28CchjraQW1dOzZlmChhoeSA5fvbwdTeJ5MnD/?=
 =?us-ascii?Q?Zv+vrak2NKIKHuHFUYGucrK3NtvcvuqM9icL7ABAXGxgX/rl7cQzpfBCZONi?=
 =?us-ascii?Q?oWZQSTXhejdPvwc8LTEnYo6wuRnFV777NrgSsbL1cfFuedALHUmiOacOhdoc?=
 =?us-ascii?Q?4pr/X0dlgzsR+2b78EXDdudXR8h4UBZXS1oMeRqc/xWA7u1v95jANbfYA1FG?=
 =?us-ascii?Q?uuY4WCk0umG3lqIhQaLJVT6e8tBG+7IAhdovEnlHwEyxgd+R6iJHWoNwvQhb?=
 =?us-ascii?Q?rqDunEnTcK6MDE8pAKGAHm7TsbnmKIbS3gUw958cf3BSQdhyc3CWptkwwSCZ?=
 =?us-ascii?Q?MNWZBYSAdeGEaUAD0OjbOosDAHcfYcU7j0+OxTWnkpJ+SNmJ6BkeGK/5u1V+?=
 =?us-ascii?Q?I3EltgSkz/x9vlfvEI9mq64yww+N8CClf4BZ1MJjvxu0clhVTwxeawAtSSAz?=
 =?us-ascii?Q?EdLHxDbPSrboPAx8LoSZ1U3nVNtflIWGrKH+QcN7GA2Cg/X/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7beaebc6-8a3e-4c04-23cd-08de61364bdf
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2026 02:04:56.3615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AOXA+SAyuLIxlcyeDHwvy6B5bMEzNru+gfnoO4mTQ5qzW3aJWuzhYnOHqa67ieo1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPFCAFD069B8
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[26];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12007-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ziy@nvidia.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1610FC49D0
X-Rspamd-Action: no action

On 31 Jan 2026, at 10:30, Lance Yang wrote:

> On 2026/1/30 11:48, Zi Yan wrote:
>> The page allocated in io_mem_alloc_compound() is actually used as a fo=
lio
>> later in io_region_mmap(). So allocate a folio instead of a compound p=
age
>> and rename io_mem_alloc_compound() to io_mem_alloc_folio().
>>
>> This prepares for code separation of compound page and folio in a foll=
ow-up
>> commit.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>   io_uring/memmap.c | 12 ++++++------
>>   1 file changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/io_uring/memmap.c b/io_uring/memmap.c
>> index 7d3c5eb58480..8ed8a78d71cc 100644
>> --- a/io_uring/memmap.c
>> +++ b/io_uring/memmap.c
>> @@ -15,10 +15,10 @@
>>   #include "rsrc.h"
>>   #include "zcrx.h"
>>  -static bool io_mem_alloc_compound(struct page **pages, int nr_pages,=

>> +static bool io_mem_alloc_folio(struct page **pages, int nr_pages,
>>   				  size_t size, gfp_t gfp)
>>   {
>> -	struct page *page;
>> +	struct folio *folio;
>>   	int i, order;
>>    	order =3D get_order(size);
>> @@ -27,12 +27,12 @@ static bool io_mem_alloc_compound(struct page **pa=
ges, int nr_pages,
>
> Nit:
>
>>   	else if (order)
>>   		gfp |=3D __GFP_COMP;
>
> Since we're switching to folio_alloc(), which already adds __GFP_COMP
> internally, the "else if (order)" part above can be dropped while at it=
=2E
>
> IIUC, for order =3D=3D 0, __GFP_COMP gets ignored anyway:
>
>  - prep_new_page() won't call prep_compound_page() (since order is zero=
)
>  - page_rmappable_folio() sees a non-compound page and does nothing
>
> So no behavior change there :)
>
Sure. Will update it in the next version. Thanks.

--
Best Regards,
Yan, Zi

