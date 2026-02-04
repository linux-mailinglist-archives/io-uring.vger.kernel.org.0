Return-Path: <io-uring+bounces-12049-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IGYqItx2g2mFmwMAu9opvQ
	(envelope-from <io-uring+bounces-12049-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 04 Feb 2026 17:42:04 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 06C37EA658
	for <lists+io-uring@lfdr.de>; Wed, 04 Feb 2026 17:42:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5F5E430293C6
	for <lists+io-uring@lfdr.de>; Wed,  4 Feb 2026 16:36:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE4D230171A;
	Wed,  4 Feb 2026 16:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hHYlUMrS"
X-Original-To: io-uring@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010019.outbound.protection.outlook.com [52.101.56.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A4F3033C8;
	Wed,  4 Feb 2026 16:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770222970; cv=fail; b=FK6fYO96QMBnoY3sVmU5hhfDvDyAnEw77FMZ3r2g8bpniQG4UxNX2fZBLTO7uYgKjuEHyw74F7VRC/hAToqXbc+H/NgJ8c+evvTBy+mqqImdauKCLdnh/rhrXszO9EWqrj4WfffA74KY6Ua7mZnuQ99vt5TR3TYo8xa9JnKnqB0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770222970; c=relaxed/simple;
	bh=dpvmHYn1aJdmX3OeJVcY5B6Hvle3QPNOzhxS7LmM1GM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bTreZC4EEtnu5Sa7+W/w1O2vrUv7ImL+IweoIW3spzDJ4TYADVpahjpzo8PZ9yuUDcom1/xSsS6K4sU1cPUDG/F6IGfA+iBl8HU5BqNDBkqj1grSdofRltLKWhP7ZG3C0bi8lPJIafdDfTZtiwRralTB6uS2sOA2JUm5tz9APy8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hHYlUMrS; arc=fail smtp.client-ip=52.101.56.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=heQ41Am/QX6WFHElxptiT+36I81Hp2oGSCIT/5mJOkQcaHe8oMOeIcgSVz/Rx5nxfpWrH7MvWYSvbKBt9dLhQHnzaBPNd32hrmrtrMV8RutAoqRiYrEQHKTVkCnVEnUMSymRpQqDBXsVMZfJyk2lCc0YSPGZBxav5e+jl9aYK7MEN335Rz25jUqdX3v+dxF9od0NIBqz5v/1W/Z3BpJOOU/VSloiVWK8Zr4B6a77rqhqqPp6i/ukt51rAy0/Vj5GPQnY8FXYWgThyykjuu+zi/fSStv45c614GiIC3DYW81lIgaDbMYOTxb9dBgmpaJw8wZoyO4WcgpdiJMxcCfDMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dIACaWBzbIdZtVMgju4ygYod7D77Gug+YYMke0S6Ppk=;
 b=c0xpP/9TJEyuvqIfJHAuU/i6PkiaalZEECu5BUnWqDAwnfivPszw1112HD+AqAHPImvoZJHzoJjeO84l9OSpwfvQFyzS998qHjw9tK9kgxAvE0kxbOowbqEvTTW+1pzj+zLb5a0x3HtpM5djFbp1ezOGbQ4INGjhS6+9gpdxZpsQfN+u7FfJ2+0ILxVAxut3rhYZhjY91kfvAhjbGoVb2K+D9//A4yI8IwYlEkeQRWd7Mot1wrOlgCatuCDcwUzA3ReQEpw8w+sSSGR+HZSGBB4w0wiQflQa31flx/oJanYa76SmIMDuf+J4XWiHcn8tcbZzwQTCv4pbl/SebXYzpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dIACaWBzbIdZtVMgju4ygYod7D77Gug+YYMke0S6Ppk=;
 b=hHYlUMrSa+C+50nOBORgh/9ZHLbY/TVw1cbR5LJhETvE/G9a/R701YBldRVPcEegLj28Pr6wWyJlcQ00/JWUCfNPuDRhiIrTRWPmjOsjeGi3a5O68NPTxWLvMaTMVEqje7143DD2+0FTblsLI8DTL0OdbzsYGmtSpd1N+e3I1/VnZ6iXVLdlkK9HHquw8uftA2Rjb3jle+wDWfFvs7IEpNiH+IezCCaGkpVTKkdKTDr0wc8PjEgng5prdrZkOg8XNtXPyYIJd9J0v7r+VcKv5azCHG4pEvpjcqn28katMGbjAhFkpQHFN/IOItRjI6pixtMkDHbRsQhYo8k0MH5pCQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN0PR12MB6296.namprd12.prod.outlook.com (2603:10b6:208:3d3::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.13; Wed, 4 Feb 2026 16:36:03 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9587.013; Wed, 4 Feb 2026
 16:36:03 +0000
From: Zi Yan <ziy@nvidia.com>
To: Balbir Singh <balbirs@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, David Hildenbrand <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Alistair Popple <apopple@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jens Axboe <axboe@kernel.dk>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] Separate compound page from folio
Date: Wed, 04 Feb 2026 11:21:01 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <2EF8F5BB-7CEB-431C-B9CB-00B1E3E44E1E@nvidia.com>
In-Reply-To: <70e06ac9-5cbb-4616-b20c-33f5bc1601e6@nvidia.com>
References: <20260130034818.472804-1-ziy@nvidia.com>
 <70e06ac9-5cbb-4616-b20c-33f5bc1601e6@nvidia.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR14CA0018.namprd14.prod.outlook.com
 (2603:10b6:208:23e::23) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN0PR12MB6296:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d98c8ce-6b5b-4204-5c91-08de640b7ca8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xmo7MMnEoVqQru4a7OM4msibutPvJM+4OjR5ddqnXmyp0hW+fT/0JgeRtzt9?=
 =?us-ascii?Q?znkPqsYNQYlTWF63i7iKEx+/x0rx3bY1AfBsQ0Hk+l1vtFLF+S9QUVNqk2mx?=
 =?us-ascii?Q?el7a6NiAIq8NHHTTleCN3dxgsuZmbQvKHhquXPmnH81nmSe01zqzKL2ZA0Og?=
 =?us-ascii?Q?tL3VI+Ce9A+Qxbmv9e6IQDbjKgRA5vX9Dh4/eCvdMP8GiXeg9YeAnevSdBWo?=
 =?us-ascii?Q?3ou7rIoNnvXh/3ZGzxiutdlC0XD4KQA1EjLkO3W6ZnGwrhGymwAdBh0scnjT?=
 =?us-ascii?Q?JC/iaI9H/MNmnET3zEtLbwRCCpMhDXs5VFPy+cSDiIj8H5ajAJW25qaQrSrp?=
 =?us-ascii?Q?SDEgWOf6eCDDI4F2ky2dh9SZR3QD2q+LOyyeykHWYekcVsSYfRJCsaCjgE3e?=
 =?us-ascii?Q?BaSJTsOkSsAdrYsbugPoWToytoYDwT//xqx1AskWIBetv28hyNVm/mZ7FBYP?=
 =?us-ascii?Q?QsK5BZYje0ds/AHDsKC7sZtXLETk+BztUuWAUQl9A+RUVFuXV1erzZRgfBTS?=
 =?us-ascii?Q?m+pZLHXA3K0HNNzcv9m2t3Z3foChooQxs1KK63ePno0xRh7ORZEg0fgDLjnz?=
 =?us-ascii?Q?+e1+K3hG8rkYeZSScX6mzO6kvPe5CddBOsCzKZ2CIi0AtZxfklfju8kMZ7w4?=
 =?us-ascii?Q?4ZDlvTq5VRHyh6NvkmYPUpzvyI06WIcaHvJctKQ4kj4oyNpIB1hBnKCIsy8U?=
 =?us-ascii?Q?qShydc0lUS2Vr8i9w1Uiqe1l73J7JdRv2/rDDoBpVhINcZbMA6Fp0hXOsEp+?=
 =?us-ascii?Q?7FHsztpXLzA2rkok4b6wYVtVxJiBKxJDE13NBMb6N90mF/EM1yFBSMH9xrYD?=
 =?us-ascii?Q?Xf5vQrlK3ak2y2tuDUpSMGHsY6jrfpaOaIOEchM7Z+JZVdfHeQLGID8UcpHQ?=
 =?us-ascii?Q?2uWue6+EOHjYe/YAV9zj5jm1kI42olekuqhtxtrgwpufACQmAvtPH6GPB9zh?=
 =?us-ascii?Q?zo109I03mX8w7iFyjemy19m8whVpxuSo8nx0Ylhp2E061B2r+lEPayjgGm4W?=
 =?us-ascii?Q?qsLlBM6nUtSM5vkJTX0NvTbG4mL/NuCPS57FPGLVsl7B5SaZZWdg+0I8KFzt?=
 =?us-ascii?Q?NeDI+d6pNXYkV23pY3QtEefWlD5g2T9QsIOX4T5dM3sfAgaYMlriPQdV/sG5?=
 =?us-ascii?Q?0c9/TaS6VsQNSqcpftkVuPCLn2+51xm3lJb3vTbojiiL8qamdoqK0g8RTDNB?=
 =?us-ascii?Q?3L+C8RjAa/E4B8fUa2e31lH7ej3tqEEwCyYSVW9NatMOafsscvUk3nz9cEU/?=
 =?us-ascii?Q?jE3xE96KMKwSw5LuuHWW/gnhpJQLURVTVUZduZo/qnc+sifdDf06TOiYFiwM?=
 =?us-ascii?Q?IVBM7ZKc9wxcyWnyLS66VQv104LM8u/GenZEUukVFpc+3fF/qQr8kd9Tzh11?=
 =?us-ascii?Q?eiJtdOlSw2JtIblo4A/ZBi0pZLb2+FU+4vIBhDNuRqQBHdNVZLF7qYMaDtGz?=
 =?us-ascii?Q?GpMSYEzNnUmCmdfOIkk/nZPt2nxNJgxNX2MSajMjNNzr+8kwbNLneA4v0n7U?=
 =?us-ascii?Q?bLhN5Iej/duS0bc+Z3suFsnVcUrLACAwLu6det6AtQafRKabjaPTxgSluV0m?=
 =?us-ascii?Q?7T4sLhcWKR7aoby0Cso=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UaADDgoJpYLwLE+vwm93zx5iGvIu5K34wj/UJ5FwSrPlPGhi5EBY4YUdUP4I?=
 =?us-ascii?Q?5MibvhOjqm8LE+zy24f2jei1AlaPZfmvQDa2P0qlz743u5oCHrKKJogmIQOG?=
 =?us-ascii?Q?IORn1egkZte2T1vr6QttKT4dkuFUlKcmagM0swfSIKli6VOn3hIhISv+KwgD?=
 =?us-ascii?Q?UdHKhJ+Cd//xBS852nY1Ms/Ec4nWEZ0U07/xLAAdMIPvg9sZRKINZsM9hzk1?=
 =?us-ascii?Q?NbUelN7vmVhRjvmLPhZpQEX4l+/PsPK+0Ngu/OKxX5FhuAjc1wDWKMDmIi7X?=
 =?us-ascii?Q?NgW+MJ1IHDSGB71vRtNvrl73HwQgGZoJ4mCcWYGmMD30NEf1uXPt2a6Ap1aq?=
 =?us-ascii?Q?KyZQ0TnVnqFO7CwAHY0KRhzZr2RJ9uCByxWor+8N52+zgYfRYvzwFx2CLpVj?=
 =?us-ascii?Q?7V6B9uPKUCMrfHyJgaKB36YPz7F07tKvtlAnOM30sX2TcJellIKQsQXnaU1i?=
 =?us-ascii?Q?dzYxBibvEikzrVXhNqELaREMbQqCDxlxLn4tNNG5vy5TPAHFqmto0GANaJAm?=
 =?us-ascii?Q?/hlweEbTFsaiPNi6gCFRRkBKFycgImeJM8cPWPsAb40svLgvfMEvbXfXJ4vX?=
 =?us-ascii?Q?FSuZVfMmgjwO3nDUsEssEQLjwNxxSS415PUJzmD7FE4Oc8zidMKMOsylBLyq?=
 =?us-ascii?Q?pJVwLD2MjraW9pfar+HMguuFA1GXyCeeraGr8r6z6SXXSrzFRWZNNAzkkY9z?=
 =?us-ascii?Q?RkxbfAnq6E+Fn7Q2OPxWYiOnR3Kj736N5IzrR6wu6ZZxjmVWduYgGPUvJxHX?=
 =?us-ascii?Q?/biRUAjxdyiHnr5f6TT1nynHKprFSDnS6AvbW0arpLyr1qxhCOerR3ujsQR9?=
 =?us-ascii?Q?QY+7FsUB8QqoU97BwqMGdACkgxytHSlOw6yD3IF+aG/6ocdEb5lTfCEowfwD?=
 =?us-ascii?Q?ZpKjY8/MD3foVLlcmC9hywd2gq+qsxnd+VKZOHkBETKHSUYVarkqkogcGrmq?=
 =?us-ascii?Q?iFEKrhllDCglmyllovDq0DlQoZzIj4CFJmpGGrOcOxYD+SVZkhc1BWcNnR+G?=
 =?us-ascii?Q?8Sv5/N7pLoUvMgMBYwANal5AQdcqY2HxtA6xD64kA6eemGG3u5eteNMNTgkA?=
 =?us-ascii?Q?MKx+KZSuS3Ux2YsLSZqlfZrAefPdTFrb4eO7ktT2R7wDTyOpUxqU85nIxu/J?=
 =?us-ascii?Q?f7sbnYsWjveASg3KiDO8jfwy6Z8aaWgOC0HzeuIu/VmerNGPabQ/F3qNoeYw?=
 =?us-ascii?Q?/t+lGQ7N8a+itxkvUv+iSpmUjzb04z4ve8+7X5Rs+K9qQmOX6V5YuY8hA3z7?=
 =?us-ascii?Q?Bg/LTGA7rWOYXc/eO4b2LRxK2MgvgXJoACMiSZrZ5bnFPm3hfXCayUIHMKn2?=
 =?us-ascii?Q?wDt3te7aiJhg6ZFkaLsp1t4lE+tv2BiaU2n0bsNMagry3kx7BcF33vAjGnmH?=
 =?us-ascii?Q?zvvVj+lSIiFvCXwFGaU+eibSXfeTuw+oStT0y1fBKiT7Cl4B0Mi8u+QDMGY5?=
 =?us-ascii?Q?4HlWclYk+kDNn3p3CqhLSxsy7UYYgT/kelw8kvqiyWbt3S4z8H8/SxmJnG/O?=
 =?us-ascii?Q?e51GiwiOQQ3gRjFQQPqpOZIheODPRB+ZUkPWJ/444SBG5gyX7UO9xKe1bZQ2?=
 =?us-ascii?Q?ckwcqx+T//DwWNLqX7SsVmRauMKH8gBXj9oULzyW8fqLTwbMTVKvFinqYTN8?=
 =?us-ascii?Q?m6nHgS6obbnC0S5UolOLdegkVQpDblEwQFgaZRxQa6HIUCUAUjJ2A75cr6Me?=
 =?us-ascii?Q?rl4v+xJ/c0+h0dqTUJSceD1IuXQbW/Xx8PqnT6DWk95h3itq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d98c8ce-6b5b-4204-5c91-08de640b7ca8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 16:36:03.3665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8oYKwj4LvEQdTB/zh4Gn1M8ePvQVzLpbfzn/wLTFOHwwVdQy+gjEFml7PkRDGpBy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6296
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[26];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12049-lists,io-uring=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[Nvidia.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,nvidia.com:mid]
X-Rspamd-Queue-Id: 06C37EA658
X-Rspamd-Action: no action

On 2 Feb 2026, at 23:30, Balbir Singh wrote:

> On 1/30/26 14:48, Zi Yan wrote:
>> Hi all,
>>
>> Based on my discussion with Jason about device private folio
>> reinitialization[1], I realize that the concepts of compound page and =
folio
>> are mixed together and confusing, as people think a compound page is e=
qual
>> to a folio. This is not true, since a compound page means a group of
>> pages is managed as a whole and it can be something other than a folio=
,
>> for example, a slab page. To avoid further confusing people, this
>> patchset separates compound page from folio by moving any folio relate=
d
>> code out of compound page functions.
>>
>> The code is on top of mm-new (2026-01-28-20-27) and all mm selftests
>> passed.
>>
>> The key change is that a compound page no longer sets:
>> 1. folio->_nr_pages,
>> 2. folio->_large_mapcount,
>> 3. folio->_nr_pages_mapped,
>> 4. folio->_mm_ids,
>> 5. folio->_mm_id_mapcount,
>> 6. folio->_pincount,
>> 7. folio->_entire_mapcount,
>> 8. folio->_deferred_list.
>>
>> Since these fields are only used by folios that are rmappable. The cod=
e
>> setting these fields is moved to page_rmappable_folio(). To make the
>> code move, this patchset also needs to changes several places, where
>> folio and compound page are used interchangably or unusual folio use:
>>
>> 1. in io_mem_alloc_compound(), a compound page is allocated, but later=

>>    it is mapped via vm_insert_pages() like a rmappable folio;
>> 2. __split_folio_to_order() sets large_rmappable flag directly instead=

>>    of using page_rmappable_folio() for after-split folios;
>> 3. hugetlb unsets large_rmappable to escape deferred_list unqueue
>>    operation.
>>
>> At last, the page freeing path is also changed to have different check=
s
>> for compound page and folio.
>>
>
> Thanks for doing this!
>
>
>> One thing to note is that for compound page, I do not store compound
>> order in folio->_nr_pages, which overlaps with page[1].memcg_data and
>> use 1 << compound_order() instead, since I do not want to add a new
>> union to struct page and compound_nr() is not as widely used as
>> folio_nr_pages(). But let me know if there is a performance concern fo=
r
>> this.
>>
>> Comments and suggestions are welcome.
>>
>
> What does this mean for treating compound pages as folios, does this br=
eak
> code that makes any assumptions about their interop?

Yes. All folio initialization code is moved from prep_compound_page() to
page_rmappable_folio(), so such users will see warnings on some folio fie=
lds
are not set properly. They should call page_rmappable_folio() on compound=

pages they are planning to use as folios. A common use case is to
vm_insert_page(s)() on subpages of a folio.

For in-tree users, I am converting them all in this series.

>
>>
>>
>> Link: https://lore.kernel.org/all/F7E3DF24-A37B-40A0-A507-CEF4AB76C44D=
@nvidia.com/ [1]
>>
>> Zi Yan (5):
>>   io_uring: allocate folio in io_mem_alloc_compound() and function
>>     rename
>>   mm/huge_memory: use page_rmappable_folio() to convert after-split
>>     folios
>>   mm/hugetlb: set large_rmappable on hugetlb and avoid deferred_list
>>     handling
>>   mm: only use struct page in compound_nr() and compound_order()
>>   mm: code separation for compound page and folio
>>
>>  include/linux/mm.h | 12 ++++--------
>>  io_uring/memmap.c  | 12 ++++++------
>>  mm/huge_memory.c   |  5 ++---
>>  mm/hugetlb.c       |  8 ++++----
>>  mm/hugetlb_cma.c   |  2 +-
>>  mm/internal.h      | 47 +++++++++++++++++++++++++++------------------=
-
>>  mm/mm_init.c       |  2 +-
>>  mm/page_alloc.c    | 23 ++++++++++++++++++-----
>>  8 files changed, 64 insertions(+), 47 deletions(-)
>>


Best Regards,
Yan, Zi

