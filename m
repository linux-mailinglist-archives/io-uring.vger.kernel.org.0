Return-Path: <io-uring+bounces-12071-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MKM5EVkuhWnK9gMAu9opvQ
	(envelope-from <io-uring+bounces-12071-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 06 Feb 2026 00:57:13 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A0A5EF872F
	for <lists+io-uring@lfdr.de>; Fri, 06 Feb 2026 00:57:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BCCF13017242
	for <lists+io-uring@lfdr.de>; Thu,  5 Feb 2026 23:56:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6480433D510;
	Thu,  5 Feb 2026 23:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cgw7jIC4"
X-Original-To: io-uring@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010029.outbound.protection.outlook.com [52.101.201.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2273523ABB0;
	Thu,  5 Feb 2026 23:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770335812; cv=fail; b=cOzHIA2IqeJqd1VsjQMzt8DHOp/dmZ2ux5C0wYyLEuUE6uypYeTRxfZdIHQxopp+d5ysAYDk8HpcQpIoZCost8SSN61rU5Ll8elt8Mm6cCZgQoP7sLRH+VBgAXk8x0RP293apiSu4qZoLjBXKLnhl2IsQkO4b+HGyZ9b1ttmR98=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770335812; c=relaxed/simple;
	bh=e+l2yR2UMHRUltkt1UCjLG2fl8Rx9m3WMkbrIvZvm7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HmLL6D5YHj/2exQ5cr2zJG/W0eDTrV257L4vcCLhmIEvAA65FSfGxG+9wIz8VNu1CEF9Us5F8bel1KColv36W2ly6CO+psL51c2oQJy7MTTGgw9VLjgosHUguL/ZvqSdrKOueAtx+fDDknTpsat3FxY1ZCzSZnY+l9XmPGi7G8s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cgw7jIC4; arc=fail smtp.client-ip=52.101.201.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Odq0tKlqy+BeBG+VjBO8gNgQRk0d1mZ3bJkNtOJgrg0g4fWTc+zIUT0rI8EahvjB7I4kfcO5vBh01pLBRP5XYzvEIaQDZBxdpDoAGKFelveYgLHwS/+8pIpxxmA9f+1omIFK9pdxS7a4AawcL/RHtmPakRIdrYt61L/U0p9ZbEAKDzasmtVR0Z8j3JbiyJcM1yr72a/IzN8H2TMMg2MC9nPdIc1FEp8XnjWLsSyz2qqQklOegVM7YS/lH2UXrVg9xTOoOXdvls/u4GBbcMsTU1mTzKsRsX5hCqOzexwZ0JVsYD4lKMc1gRy/RaZmP3YvPiQssX1niJPQShALCYZFtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jT/vk3IKkCPiOqgJ6ubjpWiK1I9ooT6ArQqFBwBoZtY=;
 b=LprAhBk1o3rlI7Xke2EAy4SmuU1usTnTjx4Vk0g9EuBY94T64JmGi6hU/qOJS2ZzEtdAoUgxNNFNgscPSW2Gzq4E7KKTuoUN5wKckEImFh/GmoXFDuGZsHwUzqnX+cpMfm02Lu5f9780JdXg7amJ96n0rNtZSBhxYIqyqsDBMplcFyDQ9Gj90nw3oAwASF/OgrXDKscL3a4hCqkSmv/QrEL+x0OohLyZ/ah36UnB1U4THqhD9XDb5e5IUaHmEthvU2VRTDVPuhS70nHd7zyA53GTEiJEigSJEciOl2bvcuTMWnv085akNM1PX6YMEpsoeuSfbbTFL5QLz8MXyu0Qww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jT/vk3IKkCPiOqgJ6ubjpWiK1I9ooT6ArQqFBwBoZtY=;
 b=cgw7jIC4q+kEPHJ0A6sDhDrQE9SVkzLmFM/oy36kcLYpj6PLIEody+HBtywVB796O5vBYqTj9qsxhg9JqPM1CYhRjBqgKJWCShkDW0Z3p2+VY88EWAe1x7DL9HRLBUOtUXXmOAowlz2uvJltRW6q50Xyr3r6C8+MmaGlU3gb2BYPDBrPKzZ+rxMexvILwFpwSSFeg1GVGljrBUTboX07aJFsC+z/0HkuD/4ePRKZdRQpmo39fH6N89o/Q/zy2RH8rVtlZmjQExbVth+1caiK5SugA3T1AtppEEGmVc+E5QRxyQc3PjJUQk8KeibHaZFL1qhAmly2QMMOYJmOVyNing==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SJ0PR12MB7475.namprd12.prod.outlook.com (2603:10b6:a03:48d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.13; Thu, 5 Feb
 2026 23:56:49 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9587.013; Thu, 5 Feb 2026
 23:56:48 +0000
Date: Thu, 5 Feb 2026 19:56:47 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org, io-uring <io-uring@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"Gohad, Tushar" <tushar.gohad@intel.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Christoph Hellwig <hch@lst.de>, Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Subject: Re: [LSF/MM/BPF TOPIC] dmabuf backed read/write
Message-ID: <20260205235647.GA4177530@nvidia.com>
References: <4796d2f7-5300-4884-bd2e-3fcc7fdd7cea@gmail.com>
 <20260205174135.GA444713@nvidia.com>
 <dbcc2912-e1df-491d-b1e0-7812279297de@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbcc2912-e1df-491d-b1e0-7812279297de@gmail.com>
X-ClientProxiedBy: MN2PR17CA0032.namprd17.prod.outlook.com
 (2603:10b6:208:15e::45) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SJ0PR12MB7475:EE_
X-MS-Office365-Filtering-Correlation-Id: 21e25722-2965-4bb4-acf8-08de6512398a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LHrRaC4I8i27+QCue+Z2BuZKPY105Y2T90D+YBpHP0Qm6XOuDPN2WgaHvr8K?=
 =?us-ascii?Q?1FUMzdGCoxMtKD9jSzH9XYOUI08yi0KOtPwh9aB6sPJZ72wCihnnRsynZK4U?=
 =?us-ascii?Q?gxGKPd3HLVHZzUEM3KmZk4Dwo9PIiTmeKsnh2/ymJxMwLZIEkVyoEJomSH+b?=
 =?us-ascii?Q?CkC7fWFP8TQ8rYWVgqzQREvQs8Ml2CY339ExUkMCtONLNYWsZVkMzZOooeDR?=
 =?us-ascii?Q?zpY+WBo9tDB3BHyA06GV9MaONws9pS1LC6R2se3dQar9CpvhIXdu3YVajiUO?=
 =?us-ascii?Q?t3kwzwySFR1VlU6oJ+2F1Ru5vWK4+3bjleeTFJciJJtc4wrvkkFXrHRLGtgn?=
 =?us-ascii?Q?AdtUG0SMvb7fFXyb8eWRCtryNt7UqGje3ryitdAxMmXKfJFnoyccXkGFsRyH?=
 =?us-ascii?Q?wVXHSvOBRZpmey5KEcAHxUV8MJl2Dgm0Jkmg6/Ni8lu5FVjF2WXbg30AR+ec?=
 =?us-ascii?Q?3Tfaj9M4+upSLQJ2Vv4Ld9FVAnGmzex9SxYEI/EBL7KkVhwCtkhtCHspe71M?=
 =?us-ascii?Q?v6OHt1FzgKlc88O0jHBBsJebGJ/okWNYwf+hQ9vn9ktSG/SBzne416Y9ufUw?=
 =?us-ascii?Q?CttJYSK6tDk7TuGcTxSaiiuH2nyGp2dwGo3wa4YQSdYvM6SpdfD0CfoUPo+G?=
 =?us-ascii?Q?12X8YKaOTULu2CyT3BMck7w1aMrpZq4upNvN1++ihtDJzhkb12oAuF5p4Aes?=
 =?us-ascii?Q?aTukzlvXYkElEYhmDQljmHHNuMzbQc3CoiAeBC4ezsCesYNKZcAlbql5UecU?=
 =?us-ascii?Q?kTRIS4QvmcOlAb36rN0aUbdzcbslgKcAk0+6qiz5wlEGznXa6V/RYSPYt1on?=
 =?us-ascii?Q?NtTPrOiQpoeU4THyiohBCh/XMPVpNx4GB9+POBWIlsxEHagfQ6txI2jQeJ5S?=
 =?us-ascii?Q?NO77cNNc7ZxSrP1lRs+EVdgSqsXSIjZY4Pg9jqyvlWxWEQBNNpWc001cn8lm?=
 =?us-ascii?Q?8UQLc8JMM0p5TXE4UCjsnVL/zS0WPmhO2/xQjCrQzScmlkLUKd2aqkuUFk9D?=
 =?us-ascii?Q?UKcT8J8bjLxaoA85xrBmyiSoOenkpOSbuKFEiJ9fmeaCMZCBOoxhqGGne1Lk?=
 =?us-ascii?Q?XXSDbYv3tYRNQA0B0PqkRCUFAtvdLjpUFTv0OgIaRUKObbfZGUngOlopZVH2?=
 =?us-ascii?Q?JJxvjRl/PlBDmyqhMrgfs1iZgWsyHJPz/2/kaSIHAJ+YrYH5dP7kDCjPmuSF?=
 =?us-ascii?Q?sbEw2l8+eqpgPKDDYpSUMHlexbCYpoG1nUiMMvFa4Dg9Ej90IgYe+Bx9TcIR?=
 =?us-ascii?Q?rsdRkFAwdH6rxZH4s3yebdG+K5i3odOdH2F86O0Y4d2o+PonCkPoWjE5RAbC?=
 =?us-ascii?Q?mr6Lit5AJskc86Y3YAhQXjYYtFNwEcFdvBCQ/E3e/SQ1WLox5uslJzr8w5NA?=
 =?us-ascii?Q?4kmBI4CzzwTcGCWltXv6R7OG49rP7Ww1bVY1M3gKMz39YIoJUjq1vO4onmvi?=
 =?us-ascii?Q?9XUqr9vb7ZxdaZ3d3NJP6xrCE5+HuwoePemB+IqSjGBXBBKqsYU5cXO3M2Zf?=
 =?us-ascii?Q?Q9uVuK8xFevw45KkW6rLRSh9lWY+xi64DsCy7vMjNvhf3FW0nXjTtm29QGZP?=
 =?us-ascii?Q?NNxJGaRM+0XYom3GvVQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?c5qQdUgEUcpoirFQ42WyoASLgYPfQ6FOlOcymNvrdJ5Xs95WH6UXSBEgWOfy?=
 =?us-ascii?Q?SGrch0+4dZImcjf1Ks4i1QzwhRIoDcQGcX04e5I+FLXl7kSAAuEFtG5/G6bA?=
 =?us-ascii?Q?VrpYjoSCaL9miZPkHJYdPUbwSUgdc0PhF18YJxlbMYkr3f245xYQFAFrEMNA?=
 =?us-ascii?Q?voaG2+nW4qMP1ux8R5bnbGdYYanrf0xkflx6YGqK9PbB2HT1d8+OhG/XsXSo?=
 =?us-ascii?Q?wmEg67USSon68Bz/ls/ETAOYJ8GQ9KY2SztWxvX6QH8NRQQwuNwTjQe5KmLJ?=
 =?us-ascii?Q?QT9HUuig1oBIvoDX/Y3Dw33vmsUPRYffH4K4qOguGh0b0rrq1aZYM+vjashy?=
 =?us-ascii?Q?QhrZE7wW0lveS3zmncWhOJSyWnf477FlVBr0IzGZ/ptszxYMhBxiwd7z54k6?=
 =?us-ascii?Q?e1bHazDkvQ8bnYMCCAEwACP8P/2NAu56Sqe5G3+6y4RqG3sSZFNNKyp18hpH?=
 =?us-ascii?Q?hPYesp325XjmgfaNQapyRm18+WiiLMqQ/mUeMx9ab2+eLXMozs5M5gcOMJEd?=
 =?us-ascii?Q?epXib0kVW+38VKYeAC7593LFPruBB1I+Ng895FA0/am3cIt05XshwDcTFFn8?=
 =?us-ascii?Q?F6e0eTwk3bz1J9lFmC/w2cwhfwnJdOF4W5AjGYYBc5LeAsX+2Pw0ukocM7bN?=
 =?us-ascii?Q?Das2cncZNDHrQAEr94uGl16GmABjmEXGPw4WeBjmATlkiFjWj3f06LmI7a5l?=
 =?us-ascii?Q?fAH9VQ0hJuBFkNFA/xGkWcFO8N/4MYT602mD+OSsdsB/AZbyf18p2Q3+NkhE?=
 =?us-ascii?Q?wyh6SAwTILs+US3alqFgiswO/R+GjQdwzwCMBCNrqvvsRZJf32ve8QiEulc9?=
 =?us-ascii?Q?chFgjEXK+hd/n/BkQ+pgjXzpfR+LwjfQoHzUzwcdNCsImne1umMN7DyM0Dh0?=
 =?us-ascii?Q?GysCyNORLI0kIrfgGHIbGUAt53TP6bNywcW5cHsbhlmBteCLkQY8Q0K2ve/D?=
 =?us-ascii?Q?NAG9kh6n3WngTfh+3iS4zVKs4pu1kslQMxSkRkBmEbZ2np78u7YM+VHPed/s?=
 =?us-ascii?Q?l0GRWae6iRF69msih0KNqvK3/L48GCe5AvplJZZI0Foff16O7dZBp7alQtpD?=
 =?us-ascii?Q?9QpbckVcyDz6YGehsQ9F9UT5xsG2NGoCGXD1YygfPoWhU6f23LFDxmNLiJ4z?=
 =?us-ascii?Q?BjKktSv0Sg+k9PSMo9apAfWfAOFoLGmtIKKrDjR4WRKOzTHuKH8WgKtId6DV?=
 =?us-ascii?Q?j21KjAtUQGZ3lPSiJ7xTG/A/0oZgyisk4fpsDLMdeqLGHp76flpwSoiI+xAn?=
 =?us-ascii?Q?K/CLS16HwVF58WEWDpe8wl05E+lY4OE/zL1hVhu4Fd56FQmSLiohf7xki6cH?=
 =?us-ascii?Q?X2xn1jOW9ERx4rYc2kz2jj0YlFI53sTmyQtP5/I9PaF5b/4wNPIM2iogl97Y?=
 =?us-ascii?Q?r8qsRhoADJGSSAbBf5p66r8d04kZkWXbfou8FyP+DFTROoGekNeP8e+7cXjv?=
 =?us-ascii?Q?HMal2JK3tLrJSY1RcIWs+J4naHIzn6ru7TgFk4O8sy0FCLJsXxySCLNHmXEM?=
 =?us-ascii?Q?YiN1jqHcS8EMoph0cl8rwB15OQ4o7H+AN++OJ8mSePYB5B6A2JLljiXlECn8?=
 =?us-ascii?Q?0bsGQLyF8+nAu/bNRlgV8rJKDbDGBGLfDhrvNhzvHXom5natA6wQwNDowKuW?=
 =?us-ascii?Q?3UetFj75VdIqP5zvP3NG72PxXoggGsKUfjOPUNct434OcQhFnAcqwqMJsP1c?=
 =?us-ascii?Q?8H9fXS7AsUaLWZl4qu+5DoKzmzhNp81sKbs2gkInWKuryGoN7FqQ6agZD6iT?=
 =?us-ascii?Q?+kfs7emWTg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21e25722-2965-4bb4-acf8-08de6512398a
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 23:56:48.3943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A4WnVBuziIcHcmZ8Y9tyZ7QNNhHWSIxlk3UCPgX8LpOuR6sY+2I5J9FHL3LkoZ0z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7475
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-12071-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2600:3c0a:e001:db::12fc:5321:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jgg@nvidia.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[100.90.174.1:received,2603:10b6:408:2a1::19:received];
	RCPT_COUNT_SEVEN(0.00)[11];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,nvidia.com:mid,Nvidia.com:dkim]
X-Rspamd-Queue-Id: A0A5EF872F
X-Rspamd-Action: no action

On Thu, Feb 05, 2026 at 07:06:03PM +0000, Pavel Begunkov wrote:
> On 2/5/26 17:41, Jason Gunthorpe wrote:
> > On Tue, Feb 03, 2026 at 02:29:55PM +0000, Pavel Begunkov wrote:
> > 
> > > The proposal consists of two parts. The first is a small in-kernel
> > > framework that allows a dma-buf to be registered against a given file
> > > and returns an object representing a DMA mapping.
> > 
> > What is this about and why would you need something like this?
> > 
> > The rest makes more sense - pass a DMABUF (or even memfd) to iouring
> > and pre-setup the DMA mapping to get dma_addr_t, then directly use
> > dma_addr_t through the entire block stack right into the eventual
> > driver.
> 
> That's more or less what I tried to do in v1, but 1) people didn't like
> the idea of passing raw dma addresses directly, and having it wrapped
> into a black box gives more flexibility like potentially supporting
> multi-device filesystems. 

Ok.. but what does that have to do with a user space visible file?

> 2) dma-buf folks want dynamic attachments,
> and it makes it quite a bit more complicated when you might be asked to
> shoot down DMA mappings at any moment, so I'm isolating all that
> into something that can be reused.

IMHO there is probably nothing really resuable here. The logic to
fence any usage is entirely unique to whoever is using it, and the
locking tends to be really hard.

You should review the email threads linked to this patch and all it's
prior versions as the expected importer behavior for pinned dmabufs is
not well understood.

https://lore.kernel.org/all/20260131-dmabuf-revoke-v7-0-463d956bd527@nvidia.com/

> > > Tushar was helping and mention he got good numbers for P2P transfers
> > > compared to bouncing it via RAM.
> > 
> > We can already avoid the bouncing, it seems the main improvements here
> > are avoiding the DMA map per-io and allowing the use of P2P without
> > also creating struct page. Meanginful wins for sure.
> 
> Yes, and it should probably be nicer for frameworks that already
> expose dma-bufs.

I'm not sure what this means?

Jason
 

