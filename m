Return-Path: <io-uring+bounces-11990-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EDw0FmwrfGn1KwIAu9opvQ
	(envelope-from <io-uring+bounces-11990-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 04:54:20 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D3AC1B6EE1
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 04:54:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E83CE304607B
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 03:52:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D34C328850C;
	Fri, 30 Jan 2026 03:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JnAB038d"
X-Original-To: io-uring@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011041.outbound.protection.outlook.com [52.101.52.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9C434A767;
	Fri, 30 Jan 2026 03:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769745137; cv=fail; b=SA+u8zSHWzgGtqqglfd/0fo5XRRjesFG9njCh1/Tyw8zYTWQaqC87HIrNF3xLJNkAAncrZpE58sEGalnT26WkwCtd8v9bf5I9kjxlMvbqxpKLBk/sGm7z1XyBzHRUimr8HXqXspqg7y7Nuw5W/Tmsb1SAroox7TsEqDJ5sG2T5M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769745137; c=relaxed/simple;
	bh=dfH0P/L0zwlHP3/uuHg0BloE3tjungRR0NYRrFKlkRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZQ+CJibva6LP/ZqBn5kQikRxcgvCBME6rDBaM8/BPOvhpJZYfrwO1laOcnG12HE8jytCYrNdBbS737/EEXKh9tJPVJHuNBAM/KKh4T/pE2cg+ZDRwj8AHAVGUXh2XF29wXlIrcca+I2UiVVuvP565CMOMcU3wDmVjwagQGX3Rmk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JnAB038d; arc=fail smtp.client-ip=52.101.52.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uMnzlojQKsIpVxYyadQNEswJAD3WFY7NuTMODysJi3RSPgCYm92oAnyF3ZSVH4DWdoBtpFR4x0eGCvSKFclkyYrtuabXW+7zDNEoIurLPN1o/DgG+th+CiRrwCXeopuEJjKIyNdJZuoVCW38dAMYZELHn00TkfimkbR3FnCa49zL9Gzl4+mUdPKdVttYM9bhYa0znWZFzsRYHft2n4EBGxLRIK8aKTmOfYqz7cCHoWFAOrkE7Kx4AmOAfsWY0sVEIMiNY7m2bDXqg74g437aa2ujmFkLg9kg3rvMICv7wELL3z9oTFT+oTYVrgspu1n1gjW6+gP75hd66Ezt8kqEIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8QkFb4RYKNfRLy0oKunZW6vYQkKk2GE+D9M9vROfh/k=;
 b=DrDPOD+X7nDpd2aOi3Pkg4GM+Cy51O/sQjLAnh18lz6sJPwRXI3StGV2UPIsGc9Qnlv9pehyXKg/4AVM/GIRw4LgXq4nPCT/FhzxdcPcQbSMZcFJodu3csi8OEzz3Fmz7uxrYojlza9W00zzg2PmAVdG1LDMv7qGZemHzPIGVK+j6sUK+U9EMUB4g+ZpVILJwMaOY4X4f//aCIqzJ2JNTVsfo8uR2ZiUUP01fxFOgL3sA58qEHo9Bl6KKBl+pvhO5wMqAuYufnaiI/1OpMvFLTGkvWwvzhTUxL8ct8eWb6cVaGbWKRX6AB5/4i77eDwAXHhRGTnryL0wzBCm8MaqOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8QkFb4RYKNfRLy0oKunZW6vYQkKk2GE+D9M9vROfh/k=;
 b=JnAB038dWXu8v+UBwQSNNh0uwo/NwwuPRxPlguFOUNExmAfNWeR6yMPZZ2c6aHu1JfH4eDBw9StejfC1++iNaBN50COWXd2oxXesrxLwnCOQxhgfXlXqO5H2O4HrUX6rAXdlYnxgqEU6NvHxx8pw6SOzWTpEhbgIyI1q9pnEhrG3CnxWqaCAaFAI/kQ79QeXIhDnZ3us7ZuoT6QylM7C5WsKceOIVaFUedHhjxxBbCXI+ERpfyYCXAqpcxHol3RLqhPuSH9bf6yB7jAroGGkOg3U4a+ocIPX2oeY7rikOa8jHeKLKvEapA2bIvcO+R6P3FjeGW+B33WudYK+a65SZw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB8312.namprd12.prod.outlook.com (2603:10b6:208:3fc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Fri, 30 Jan
 2026 03:52:11 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9564.006; Fri, 30 Jan 2026
 03:52:11 +0000
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
Subject: [RFC PATCH 5/5] mm: code separation for compound page and folio
Date: Thu, 29 Jan 2026 22:48:18 -0500
Message-ID: <20260130034818.472804-6-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260130034818.472804-1-ziy@nvidia.com>
References: <20260130034818.472804-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0P223CA0007.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:52b::27) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB8312:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a47f5ae-a86f-459a-7ff3-08de5fb2f289
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?J5oeXgKmORtEb4TrvfjfHkpopzxLqhKuqts3Bi+4Qe2Fso+vRMWbREFIoDic?=
 =?us-ascii?Q?nxoZ3fOnOsJ9G4PWFgNez8LRLwxuTHUSSuVO0YQG3Ofda1jAYOwnIzTABWT7?=
 =?us-ascii?Q?YBNZzb2wDmVBXHe1dHBfvbSjvNwbP+9P/Aegn1ps6ybxqzPYWj7Y/3NfkDyG?=
 =?us-ascii?Q?rs6chINCTKbL7ODFVij3mJU1VEP5CAZlGuxJelAgqErqCcw3HQw5JCYwGIqG?=
 =?us-ascii?Q?elPTgq48Lpj3MlLUuvpHUXTmonc6NTS0G7LeVqHg3PvPNs8sVG+W8hejI+QR?=
 =?us-ascii?Q?fyJrNhdO0J55mXc8BLEV5skqsncVfgaSZT/+mHsnWUuxBd4chnccLAudaXML?=
 =?us-ascii?Q?Dj6bQRZB86nxa/GmBNzEL3OWK8i47M6JeIv0BY6NxzKediCHsWoOPEPxs9Q2?=
 =?us-ascii?Q?B12p3pz0edy2ZNi8iKVnNRWMVROKspq1g2weGRdAfbSGbEza1cRAPmiVYxSN?=
 =?us-ascii?Q?tpk/G584xl6cavmpBa2ZALpz4GXphVf6GDGep1s8f+7KEGAqnuhWI72itxyC?=
 =?us-ascii?Q?LZ+arMXrat+BbozV3WVHwONUPN22+fiaXVQqEo4uRrmIBqVmH95+KL/KzKu2?=
 =?us-ascii?Q?Dqp34sB9xV4qk7scRKIWrzAjqw6ewagEvg+lI+FKawcMKqyRUTOlN8WNo77o?=
 =?us-ascii?Q?kEWTAHNpUEZ6Ub9TLDYy89drJE6/nddjJHbxQZ57WuQWg9+aOVOUs/QVZJ5Q?=
 =?us-ascii?Q?qHxkl3tQsz73UrX4GnCc0R/FoaCO/ru/k02jrAdrEy5IgxgsNRq0SbmCRxSp?=
 =?us-ascii?Q?9ZB6mgjVHI9Fz4Zq5KowIpxkayK5UJvisi8ORuLhAMAIuWyz6DgJ+GoQzPsg?=
 =?us-ascii?Q?marbXCqkBnfsL+WNLxNP3LzgVldyxRuo7vqLu8S+QUVwfP9UJl5hMFZBLlNQ?=
 =?us-ascii?Q?L92HDfBiC34QwMC8ydNYgRhyy/JNK3KgeVxCjX7q6ycLuQOkWstQ13TJ2A35?=
 =?us-ascii?Q?16La0vB4oD+0f+DGXJ/h7gdr5LtYjl2WltwBHvLnVP9TYxFUWlNz1iEGTXSG?=
 =?us-ascii?Q?aP5aiDzDKOoLgln3V/FbqwZLAWxerLtsfI9xHp7+ElB8wxrwIKPnSSVyRj1x?=
 =?us-ascii?Q?yBt2jFYQn/tXPRDO25WHYqNjrZZ2gBsdPSwFzm8SLBz6n828KgbyDUA8uWDq?=
 =?us-ascii?Q?SRGOdmxZjyPL0kLE3LrJirZTM15ArNea7Rx5qbp/NalicXcnurnpL8Orrw6l?=
 =?us-ascii?Q?dnLxHTU4t4TtXBVkqHuo2QBeLMF3ERzx/y5lmwe23KkR7W8s0cCcR4iVMEwx?=
 =?us-ascii?Q?GuYWrN4QD1ZMGk68goDH0taljiDqtMtWAg0h4g9/svrT5yxXuWT6pvh5+NYs?=
 =?us-ascii?Q?GvyhlFXq0ZbBGcY6OfR/6h6V8zA0Mpmuh3nJCQqYIBrwQ0pFxQiqyplJRAOE?=
 =?us-ascii?Q?PotXn3dnUGq8ZMX/qLIiLedRNlY5YxZuP/f8YtcGsJ/A3seP5siXpFGB9sV6?=
 =?us-ascii?Q?8syj7BUM/gsO8h2LO58rT5axdhHZKmFMWvCK0VseeMzh6ow5XQrrxkI+WEBJ?=
 =?us-ascii?Q?a5UDE1xlNZCpH2iqfNZI9eceiN6g9zQRBL2AhKV+lVdYHciDzrwRGyIJcD/t?=
 =?us-ascii?Q?Lcg2H5A2xmA30fRMy7M=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?b1/0MliG55/5eLJGSecjf6emk9kfdfeCtmKGHzuO6DgFhnUaxbbyZqWsH7Sg?=
 =?us-ascii?Q?eiVu1/Ic734p20919m7aTnp77t8LwnpMMbcO3FurhkkApOJCIRWPJDx83VqY?=
 =?us-ascii?Q?K2MHc5jEM2Xmy7hjjlB8f5P1CJiLaLpKDXtVe907dpp7hUoqQJKGiZhHDgyC?=
 =?us-ascii?Q?xOgkx7lqTUqg/7cSqHXhlDAdXn9mm9WXRLM9bKGYGgoH3AdISNLqV1NM2ChK?=
 =?us-ascii?Q?v7PDeL15w4+SYt17tz+Eg1efLimgeq8cx6Nd4mciCpdt1Rr8UDmMLXaxCLlT?=
 =?us-ascii?Q?mA6SFuXqSoTu493pjSygXnj8mxSaUNGjELOUHsHRsStXEcOdP+GQyu9xqxrC?=
 =?us-ascii?Q?ACC5vgIy0DXVJf559nvRMGFhH+ENECCVqV4QiAxiPFfahqmBzdTRJI2plwb2?=
 =?us-ascii?Q?NB8EO3Pml6yE8RJ3MZkh8TokkSB0NbnN/mkV+Wx7qALmAbd4kD33AkqyW2gO?=
 =?us-ascii?Q?wAyoy/RTKn87A+qcf+nHEk1D74B37Zu435O5eDVI/hL4GT3pMMpt/iXhg36x?=
 =?us-ascii?Q?jcWYFXTpR5FKkC30S/I5ugvOT1DzmGG0xAXWkqjSdDr6TaSHAZP6TIsXdoSW?=
 =?us-ascii?Q?GkktUS0G+sI+GIRUZ8wdYjo7ispuxMApLqoH4ji93SOmmnkV5lGKdQ4bo+za?=
 =?us-ascii?Q?7Zivt2S+vXscG1vHJCjKYuZ7kuAAuCBaiBRHTE1EmXKyt3yZ3zceWEwyi0Vu?=
 =?us-ascii?Q?iVvCTVdnfP6rnpJEA/AwYEJlybegIwMHNbwwFsZu3lZ2EXtmRVoN4C5hA7jH?=
 =?us-ascii?Q?NbYqR2tG6xupIbmBhnT5xZDxZvikDyqulVJYPf2djzy2ypJ7wqxqVMgF7BsX?=
 =?us-ascii?Q?GUrljlIKER15Gm1I/nTOJo4NaUKuxielhSgqWEmkRB8b0oXY503elijpv9vB?=
 =?us-ascii?Q?s79jH0JQWus/gxCUFc0L2bzD+XDqZVjBzlYKB6WjaiA+4duJ7J1ErLXMJhMu?=
 =?us-ascii?Q?DWmgBnHrFvz94iaxQ0BlrsjsqjDsdqD+Ucdc5XieDsk1HmttMh5303B7T9pN?=
 =?us-ascii?Q?+MCRNz64Icyj358OZa0LoKhzUycOK+TcFWOY9JMKXcVVfvQaWxcT2S3RuKrw?=
 =?us-ascii?Q?OpHZicYe/EXLw9RPwGjcBjSc+ZiBeTmgT9rx27K+V9dh48IM+Vjf6L1WY1tp?=
 =?us-ascii?Q?iTxn66bVlNL95KH9rbvXvEVg1ZWvCtqhBfwDCkUMccaeT71vOwG2x/PUOGtA?=
 =?us-ascii?Q?CalbG5fPW4UAVuPUfxjlOOuA69TO/fvSVpmNJKN20r0dwKb8rGbVIREC87iN?=
 =?us-ascii?Q?TCE3OUQ7mhq+Yhq/VfOBdPhH3dy2WzhJw76V/f446BAjk34REvWVMd+qc7H6?=
 =?us-ascii?Q?vxW3RCwS2p+ZJqbKnngmEQ1/baclI7mJzOsnxropaloV2rr0DyXh2Y1GBkuJ?=
 =?us-ascii?Q?bAqOh2Q+isd7UunZ6tvoet/c6BuElMRBRmi+3pCe7RSvXJAtABc4x1d92Vwg?=
 =?us-ascii?Q?LSXmaVftQ2uYviEKOJBz2S9K3yoae8UwF/xMlpTmjDPT8HGYSGaFIv3K+yE3?=
 =?us-ascii?Q?2Gghn8p+gUYQYDZbddsa1N4PAdlhG0FBF3X938XUHFY5j6CHL/ahmAUbKx3s?=
 =?us-ascii?Q?j/b6DyzUnUCOTbMSxWpoA7nVMA+Iryil3RGq3RUDnxvcLfQqGJvR1Rhb8KdL?=
 =?us-ascii?Q?K8bslG9Xau0s1ZUdOjwCpTQt0JFzeM3vm5AKab3G3Jbg7y+xn1vQ7swNctyS?=
 =?us-ascii?Q?FSTX2fnsDEPXScXtSARPSM5SQfGqw1MF4Z+V2Tnm73lNNUV5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a47f5ae-a86f-459a-7ff3-08de5fb2f289
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 03:52:11.2683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1OeSusg6e1g9+MqO+iJqtGigT6vdL0tVD4FVVwv2BX1LGm8Ghu7w2i4l7ma1guK5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8312
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[27];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11990-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[nvidia.com:mid,nvidia.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,Nvidia.com:dkim]
X-Rspamd-Queue-Id: D3AC1B6EE1
X-Rspamd-Action: no action

A compound page is not a folio. Using struct folio in prep_compound_head()
causes confusion, since the input page is not a folio. The compound page to
folio conversion happens in page_rmappable_folio(). So move folio code from
prep_compound_head() to page_rmappable_folio().

After the change, a compound page no longer has the following folio field
set:
1. folio->_nr_pages,
2. folio->_large_mapcount,
3. folio->_nr_pages_mapped,
4. folio->_mm_ids,
5. folio->_mm_id_mapcount,
6. folio->_pincount,
7. folio->_entire_mapcount,
8. folio->_deferred_list.

The page freeing path for compound pages does not need to check these
fields and now just checks ->mapping == TAIL_MAPPING for all subpages.
So free_tail_page_prepare() has a new large_rmappable input to distinguish
between a compound page and a folio.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/hugetlb.c    |  2 +-
 mm/internal.h   | 44 ++++++++++++++++++++++++++------------------
 mm/mm_init.c    |  2 +-
 mm/page_alloc.c | 23 ++++++++++++++++++-----
 4 files changed, 46 insertions(+), 25 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 7466c7bf41a1..231c91c3d93b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3204,7 +3204,7 @@ static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
 	ret = folio_ref_freeze(folio, 1);
 	VM_BUG_ON(!ret);
 	hugetlb_folio_init_tail_vmemmap(folio, 1, nr_pages);
-	prep_compound_head(&folio->page, huge_page_order(h));
+	set_compound_order(&folio->page, huge_page_order(h));
 }
 
 static bool __init hugetlb_bootmem_page_prehvo(struct huge_bootmem_page *m)
diff --git a/mm/internal.h b/mm/internal.h
index 8bb22fb9a0e1..4d72e915d623 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -854,30 +854,38 @@ static inline struct folio *page_rmappable_folio(struct page *page)
 {
 	struct folio *folio = (struct folio *)page;
 
-	if (folio && folio_test_large(folio))
+	if (folio && folio_test_large(folio)) {
+		unsigned int order = compound_order(page);
+
+#ifdef NR_PAGES_IN_LARGE_FOLIO
+		folio->_nr_pages = 1U << order;
+#endif
+		atomic_set(&folio->_large_mapcount, -1);
+		if (IS_ENABLED(CONFIG_PAGE_MAPCOUNT))
+			atomic_set(&folio->_nr_pages_mapped, 0);
+		if (IS_ENABLED(CONFIG_MM_ID)) {
+			folio->_mm_ids = 0;
+			folio->_mm_id_mapcount[0] = -1;
+			folio->_mm_id_mapcount[1] = -1;
+		}
+		if (IS_ENABLED(CONFIG_64BIT) || order > 1) {
+			atomic_set(&folio->_pincount, 0);
+			atomic_set(&folio->_entire_mapcount, -1);
+		}
+		if (order > 1)
+			INIT_LIST_HEAD(&folio->_deferred_list);
 		folio_set_large_rmappable(folio);
+	}
 	return folio;
 }
 
-static inline void prep_compound_head(struct page *page, unsigned int order)
+static inline void set_compound_order(struct page *page, unsigned int order)
 {
-	struct folio *folio = (struct folio *)page;
+	if (WARN_ON_ONCE(!order || !PageHead(page)))
+		return;
+	VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);
 
-	folio_set_order(folio, order);
-	atomic_set(&folio->_large_mapcount, -1);
-	if (IS_ENABLED(CONFIG_PAGE_MAPCOUNT))
-		atomic_set(&folio->_nr_pages_mapped, 0);
-	if (IS_ENABLED(CONFIG_MM_ID)) {
-		folio->_mm_ids = 0;
-		folio->_mm_id_mapcount[0] = -1;
-		folio->_mm_id_mapcount[1] = -1;
-	}
-	if (IS_ENABLED(CONFIG_64BIT) || order > 1) {
-		atomic_set(&folio->_pincount, 0);
-		atomic_set(&folio->_entire_mapcount, -1);
-	}
-	if (order > 1)
-		INIT_LIST_HEAD(&folio->_deferred_list);
+	page[1].flags.f = (page[1].flags.f & ~0xffUL) | order;
 }
 
 static inline void prep_compound_tail(struct page *head, int tail_idx)
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 1a29a719af58..23a42a4af77b 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1102,7 +1102,7 @@ static void __ref memmap_init_compound(struct page *head,
 		prep_compound_tail(head, pfn - head_pfn);
 		set_page_count(page, 0);
 	}
-	prep_compound_head(head, order);
+	set_compound_order(head, order);
 }
 
 void __ref memmap_init_zone_device(struct zone *zone,
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e4104973e22f..2194a6b3a062 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -746,7 +746,7 @@ void prep_compound_page(struct page *page, unsigned int order)
 	for (i = 1; i < nr_pages; i++)
 		prep_compound_tail(page, i);
 
-	prep_compound_head(page, order);
+	set_compound_order(page, order);
 }
 
 static inline void set_buddy_order(struct page *page, unsigned int order)
@@ -1126,7 +1126,8 @@ static inline bool is_check_pages_enabled(void)
 	return static_branch_unlikely(&check_pages_enabled);
 }
 
-static int free_tail_page_prepare(struct page *head_page, struct page *page)
+static int free_tail_page_prepare(struct page *head_page, struct page *page,
+		bool large_rmappable)
 {
 	struct folio *folio = (struct folio *)head_page;
 	int ret = 1;
@@ -1141,6 +1142,13 @@ static int free_tail_page_prepare(struct page *head_page, struct page *page)
 		ret = 0;
 		goto out;
 	}
+	if (!large_rmappable) {
+		if (page->mapping != TAIL_MAPPING) {
+			bad_page(page, "corrupted mapping in compound page's tail page");
+			goto out;
+		}
+		goto skip_rmappable_checks;
+	}
 	switch (page - head_page) {
 	case 1:
 		/* the first tail page: these may be in place of ->mapping */
@@ -1198,11 +1206,12 @@ static int free_tail_page_prepare(struct page *head_page, struct page *page)
 		fallthrough;
 	default:
 		if (page->mapping != TAIL_MAPPING) {
-			bad_page(page, "corrupted mapping in tail page");
+			bad_page(page, "corrupted mapping in folio's tail page");
 			goto out;
 		}
 		break;
 	}
+skip_rmappable_checks:
 	if (unlikely(!PageTail(page))) {
 		bad_page(page, "PageTail not set");
 		goto out;
@@ -1392,17 +1401,21 @@ __always_inline bool free_pages_prepare(struct page *page,
 	 * avoid checking PageCompound for order-0 pages.
 	 */
 	if (unlikely(order)) {
+		bool large_rmappable = false;
 		int i;
 
 		if (compound) {
+			large_rmappable = folio_test_large_rmappable(folio);
+			/* clear compound order */
 			page[1].flags.f &= ~PAGE_FLAGS_SECOND;
 #ifdef NR_PAGES_IN_LARGE_FOLIO
-			folio->_nr_pages = 0;
+			if (large_rmappable)
+				folio->_nr_pages = 0;
 #endif
 		}
 		for (i = 1; i < (1 << order); i++) {
 			if (compound)
-				bad += free_tail_page_prepare(page, page + i);
+				bad += free_tail_page_prepare(page, page + i, large_rmappable);
 			if (is_check_pages_enabled()) {
 				if (free_page_is_bad(page + i)) {
 					bad++;
-- 
2.51.0


