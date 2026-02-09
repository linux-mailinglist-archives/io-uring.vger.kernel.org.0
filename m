Return-Path: <io-uring+bounces-12100-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qI2dMcjbiWndCgAAu9opvQ
	(envelope-from <io-uring+bounces-12100-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 14:06:16 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7048810F681
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 14:06:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 310293008224
	for <lists+io-uring@lfdr.de>; Mon,  9 Feb 2026 13:06:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9C592459DD;
	Mon,  9 Feb 2026 13:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Y+LUqa1R"
X-Original-To: io-uring@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013015.outbound.protection.outlook.com [40.93.196.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64FE22459D4;
	Mon,  9 Feb 2026 13:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770642372; cv=fail; b=rn5j0OHSaU++IoTRndUszhkkeBj7KrRUqPISK7MmFe2XpOyP2F5WgiR1IBnbKir4ZTBrqtET5iG8R5tYOtDMddHRTVeKB6gJGNzlscPK1A19DjBsuSzxS5lKVY6INQ/53WwhmiIsgu9hHfaI6b05khOXTmyqBwsFqg/JmkIzIDc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770642372; c=relaxed/simple;
	bh=la9FYaKmLBX6Is3bEsYAJN6dHbZOYucSy61hvprntNo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BRfd4XYks3h0Fy6LpxW0WZswcKNU3DG786v+9iA46+Y8FsQg0iLsov3vGmBq2U0o6mUE8cWGRMBHLtVIqT8MMNaf3SB27tOw0ErlHNYuUGPpFpDBdVK8hvL/d1TAwAwtTnIcCSOke7bkGPBoTyzJ7wfxqdYT49J9le0iANsLzPo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Y+LUqa1R; arc=fail smtp.client-ip=40.93.196.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RsNqO0A12Uh1JDWXpLn+aZeGllEW4iH6llm8+10RnBf4UH6VlGCXGilcM4LWStggUXCxbLXz5OT4uzavUKMaSVvRWv+zp9IdaUiRCsZ7X+Mv5nQzo1hpTTFhz95ceeAt0Xd7mPSnQeJgLD7FcXOcpOAzHq7F+XCJYQDY9g9ItOD3ayR1YBtf8x8rLRC1JrLhGPjjw2PdUdthEModowmwZ6+GavEwCcsKyE+XzEZ6NelykdC92YPZvNEVDQAv/0PIV0IatsoJSwFqCHuTK37podzgeO0GddMOivXc+poptXBTTHuaPcTNbuoP/B02uLa8BiUl0fsOjMjIjzAWXICUgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+vLOXyVRridkD4VsiMxfYXtycPtzqLEszYI6dnKKeOQ=;
 b=DWVc6poPjc0+dRgH4lBmPYwyLV2vPaFwSl09SQ9Cg+n7P/7muBWpUwpdqT/e3fvqdFg+dYApF0klBQQ3elQPnT/gRifULuJFgyziivAH3ug4aeGLEYvzIXGLO2FGp45v7Ba1byCQj31c53wTzhUXgXAhVyih592SZEveXYcqVgtn8Vl861ywSNVbiVN80kvW6LH9Q12wOXtjEg+eOj7h19QrGZsQ7uoGeix9UryEXaaEoFTt5D0fyqLu7ByqbOtceB1cHAit4Pq1RVyZnCG6WpsLbzyznKdfpdWGcAlEjs/U8o58bu8iiLF0we0tsX6N9n3tumN2spvCG4BIR4fHyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+vLOXyVRridkD4VsiMxfYXtycPtzqLEszYI6dnKKeOQ=;
 b=Y+LUqa1RdQVvRCsOuCn6aLgim9k46Z/re4fnRFzN5eSsKZ015q4vRU19RdVDd5HiSdHpUS3VU8dkoJwRcEL87NJbnhN3Q4bpFjaQeGimtSi4TbDJH3dSUCHOwNPANhwSsFhjEhh895yu3OLn7AGgYSzLuCEdRbSL5Zq1Y2h1RCfxId94QOeRtUEQ18BJzyAqsFM/Wn9xO8B8784OBLKlDK7DzF544OSvfnV1nFknyPrQwk+3iOT/Zo6ZyRJeTHHGXBF5rUOS/9Y86BzLaqZATTQH/D2SVhgMxeVbuNWuuYDbaG+JpDuZ+XQW1DTx9+niXkdAfdP0b1nIS9PsQ2YZ2A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CH3PR12MB8457.namprd12.prod.outlook.com (2603:10b6:610:154::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Mon, 9 Feb
 2026 13:06:08 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9587.017; Mon, 9 Feb 2026
 13:06:08 +0000
Date: Mon, 9 Feb 2026 09:06:07 -0400
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
Message-ID: <20260209130607.GF1874040@nvidia.com>
References: <4796d2f7-5300-4884-bd2e-3fcc7fdd7cea@gmail.com>
 <20260205174135.GA444713@nvidia.com>
 <dbcc2912-e1df-491d-b1e0-7812279297de@gmail.com>
 <20260205235647.GA4177530@nvidia.com>
 <3281a845-a1b8-468c-a528-b9f6003cddea@gmail.com>
 <20260206152041.GA1874040@nvidia.com>
 <df7fe4d7-ca28-408e-bed3-bd1fa23e7588@gmail.com>
 <20260206183756.GB1874040@nvidia.com>
 <4736af5c-4bf8-4e9b-8f82-4b89a75d2cdb@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4736af5c-4bf8-4e9b-8f82-4b89a75d2cdb@gmail.com>
X-ClientProxiedBy: BL1PR13CA0303.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::8) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CH3PR12MB8457:EE_
X-MS-Office365-Filtering-Correlation-Id: 953e1a4d-1990-4406-b849-08de67dbfd4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mpyuQljqc2w7cOGT3Scz8RlbUWaop826nVlY/LVWmR3j2xivGuREmGVYz/YB?=
 =?us-ascii?Q?wqadthdpl5ZcaKfgaNLgXuH+xyUq6UBJYLUegCfDeWiFHCAEmC/fZewq6nWi?=
 =?us-ascii?Q?fBAVeUSeRPHhYX90ChCnMfwv2VGhAYUly4gdPAoM4Uvc7dN3fVXJdoOJM7c6?=
 =?us-ascii?Q?oNAwdyPsdzIG+kPUtpy06tOS1C8Lzv/D+T8k96X3Ik3b0ht1NnzcIGsqNb94?=
 =?us-ascii?Q?Yq80i5jBb/wgPd9YajShvjfcnZ/CxOjRWHndi4qcVj6KJYRVoBFBLh9qU68B?=
 =?us-ascii?Q?aOW1bNqBNznr2JEG01FC8+oMN+DOKMkO/U1ucRp+w5nP1PuPPGoczy4CQvQU?=
 =?us-ascii?Q?37prPhfvyGST3mu0/BLRmTceMfEByHjmEqh9wadHDKDI+s7NZgbKdRAMSLQq?=
 =?us-ascii?Q?YVXICiFQk5P+4xXjdK8f6EsrhyF3fpLZkqfz9EJC36VxwJuHczhnS0jRku/b?=
 =?us-ascii?Q?m7B9QAoPNNPqKJsvb4mhVhPEWJvmEA48A9mA2RGX2B/lHLUcT7ObPlR1cq2A?=
 =?us-ascii?Q?FeRG62zzFj+HiRfrO+F7jkb0qKVSTcmHDiUPBmv/0Cltm2YJ4uHThoCRn/ex?=
 =?us-ascii?Q?Ba0smIl5HJd1mee6K7ieDMCwMAYNOtEcGdlh/wXLKLXA3T6pRn1dfWLst5Ye?=
 =?us-ascii?Q?UNgE9k/EeZ3t+HPDpaji4KAD7vGQhhR9R1nyAV+GDK+DegAnPRESlUZCqkcG?=
 =?us-ascii?Q?XCNY4ykJ5WsSKseZigmoVvqaJODj6kxksOhiHzvRcvUq4/nwFGRTbO0UhZW9?=
 =?us-ascii?Q?akgR6rCzzAnspup/UaJCif7cXyWiCojokDIQCp0Hi3fU8ZWODZaFk720zgeu?=
 =?us-ascii?Q?euQJtlozRV95BZR5v3/jaUF4KSB7So6BVQuf+RQDuMpTuWaVGL3xXZPrvLFc?=
 =?us-ascii?Q?nWjm5bsOQLnGm12TWfTxBlEqO9PBJk9or4d8VvrjR1RR2ViKQ7DJ8OWDDNVN?=
 =?us-ascii?Q?n2+jXGjsRlt9CcCYpGlKg/oCCvnurfGXfs1ROZOF1zrD8AYqzkehFAhoLrQr?=
 =?us-ascii?Q?cgcXI9xqyBHwXkxXLSVTNtIjhWouZePR6aoRvbN4SZCwKgx6suwFaCmUg+HU?=
 =?us-ascii?Q?Os6vdBkPxbpD9i9oI50J5tvKfBnPokB/7FrlZiQTbH6APpYx1vyIWZHf5N7C?=
 =?us-ascii?Q?izF+nq0dOJRKNDki7Kl2/V1FHeY1XjCUGYiniDsY1ozO68Y/30TmAhlXsYOC?=
 =?us-ascii?Q?GM2gIy7Whgex44qJygMByAW58MbDN5QRdUwXnMmBJ35xRYMwGvlzfvVp235U?=
 =?us-ascii?Q?rZSJ8o0cU5lvSy7zF9gB0CT3xOqEKb8psgGh6Q+eMmb/MIslwjxUXuJKQCHq?=
 =?us-ascii?Q?K2UNQHOuh2fzp+px4UvWzY3gv1hokAEg96Qs7xqLWOaA7CMYkinZpSv6gbpA?=
 =?us-ascii?Q?3IryEeHZ++NIvIL975rJmj5OpCn0YA8OHSp6oKLuDFsQYCwfv4v6GxrrUIDT?=
 =?us-ascii?Q?EP4mN3Zaf1ZDYtIaWFEhVv5shxkexQBgJ/jWFvpKCKweLkIG6WzW2fesSfRc?=
 =?us-ascii?Q?so5Dx0bbdrfCc+EOx1HBzQ79cHvdMBec9rPCu6d11E/wPLo90w6Jam9B11f7?=
 =?us-ascii?Q?enXrM5UZLkZJ+Nyza8o=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nAauHLHrHispaAub8b7dJ0w0bYDICMO+wxgrix3UmsLKQ4dV1l+q7O8DgqZd?=
 =?us-ascii?Q?8I6tCzq+QecPGjtgOWQvYchiTH+/sik2QyOn5KMplu7yA1YcI058zxhtJzIf?=
 =?us-ascii?Q?JLXI/gEOsYNmOzBGpmsbtSVhc5/0wSwuPn3kOESvpPH2uk6Q2dN1lprYRoUE?=
 =?us-ascii?Q?kFVed59CnAsE1zrKDG1TTEb+fliQxXagP70/8siAj98om19jTOnyFF9hTRsK?=
 =?us-ascii?Q?K0fz8AhJJIjFbCCbdnx9TnKFnFtJSL4GZJK/Dw39Q8o4CYSGqBarK8+pl2WY?=
 =?us-ascii?Q?6DB6is5zZzYqzzu68GSTmsbGYWvO1iMCiTVm2tFynxpyJaKbNHlDfd7VJ/+f?=
 =?us-ascii?Q?TpiCC48HF8XTWJjjj9LnhZ+ikHXCczij9azmO94cZgYb/OL4PexEDPO9HFhR?=
 =?us-ascii?Q?fV/H4L/cmCJU4xwYdADVzqt5z0NELVO+AN81FLnEGWfl5mkp2VVJ7J2kysci?=
 =?us-ascii?Q?HPM0bqwiKgiEtHSAtRauikayqNX4h6B/ahBOuLX2Z6pJPrdQEYb7AD6nWpJ2?=
 =?us-ascii?Q?l9XXiPtCZDb9o+1SD0fY2t30dNmzNdn+o7l/HxixKmJxYgZsm5YGUljFLcwa?=
 =?us-ascii?Q?PsjoLOo0opKax0DNMu1bGFdBqJX37XQ+bJ3Syp+zP2RgWhF2AEirspRajS7y?=
 =?us-ascii?Q?2VO0+iYBhrcNjb+1lIglwcFWfsIcBjOyb6oB7WQuyzyfabqtBaFGhoz1AvMf?=
 =?us-ascii?Q?4XdcV2yVzBFAA+7Q7lINks9ffmkNg0bwELxUTEWdYZzjXRNFkJQmwUx9/8jk?=
 =?us-ascii?Q?u3aS0F0SGQxwjtpV5pOifWUGi+/myTLbF+ZG7QhBlVGg6r+EF58ES1NsuiAv?=
 =?us-ascii?Q?OzhjnTMJZ0t5q8QAjuXEVcq7TzRO2q4wSq6Tcqqo7tBQawDxtnNbs6mP0gsr?=
 =?us-ascii?Q?kmGYTdlhCH13tp68QvywiAL7pFZ4+8mIJYC6Tb46Wt0q+BlZkorQ1d1UABH1?=
 =?us-ascii?Q?22nYy6jaye4pNK7JLpL2eTcjZqQcz6lI8IaVHkbb7hGfkaWXpLPA05OmaL/r?=
 =?us-ascii?Q?CIXMwdCldGFosE1MLygaYVIAlXzw1g97Sg9RnUwDD+YLAOSG6ySwLhCDze67?=
 =?us-ascii?Q?QoNAQErCn0qJZmrm1cYs1nY9S+nDm6KC8fjMuwsgzaUbfg5whJt6i6bRm14V?=
 =?us-ascii?Q?qax8OX/GGaenP1S5Idut7znTzMQ4FyFbDmSAWqAeIY+2aC5vcwLBw57w17fq?=
 =?us-ascii?Q?AxLagImk4WdmgFe3EJYi+e5bTRCsRBkEQsgD9KGPZ+3tC9VSa8cIMDk8OkAU?=
 =?us-ascii?Q?GZAJGq453qI8yMP1yVm3WcAEG2wB+pW6EQj5trsJoQVUfFh4cx4DdQJ9+4cu?=
 =?us-ascii?Q?xnqKolw68djmOcfSeihyz4mvEFwQhkj/KJT2DrHRE0swPQfvTEwCu5cwEHKE?=
 =?us-ascii?Q?gII+OS9dX0vZxwv+SKp3q/VDk67Ehz4r8cOdMZ527+PRyfb6hbkn+QgCC23Z?=
 =?us-ascii?Q?rU54+3GTe3ADYymZHJlN224a2m4idqBzhqxMLOlwn3egExKPQ6EkK8vpUh2M?=
 =?us-ascii?Q?vuvs0E+l+OYiySK4KoJmlN2NQMdj0oNx/70SBAmAbEngpdnjAN1yCNq4rKf3?=
 =?us-ascii?Q?lGcKhnkLbjspI9FnR1bFni0Lg0zWi5wZiDMEo+TWtEvEsqdOHGJ+jvgAWzrI?=
 =?us-ascii?Q?o/PDVfPvAMXOWCHel6Ali86ew7fmKfWN3+0kAiubpwIp8Ucc48UyDTuUmxlw?=
 =?us-ascii?Q?8uvFvlsa8dyfuwEY6yerRK69q/RtwbOia3saYzIcYs5EGQ32?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 953e1a4d-1990-4406-b849-08de67dbfd4d
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 13:06:08.0468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C8lnronyt73bOjYqlawQiBmWGkbj+uN7LpQ7RV4rZwX7XAum0l6Q31sGyPvm0VKz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8457
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
	TAGGED_FROM(0.00)[bounces-12100-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jgg@nvidia.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[11];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[nvidia.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,Nvidia.com:dkim]
X-Rspamd-Queue-Id: 7048810F681
X-Rspamd-Action: no action

On Mon, Feb 09, 2026 at 10:59:53AM +0000, Pavel Begunkov wrote:

> > As a step forward I could imagine having a DMABUF handing out P2P
> > pages and allowing io uring to "register" it complete with move
> 
> Forcing dma-buf to have pages is a big step back, IMHO

Naw, some drivers already have them anyhow, and we are already looking
at optional ways to allow a very limited select group of importers to
access the underlying physical.

It is not a big leap from there to say io_uring pre-registration is a
special importer that only interworks with drivers providing P2P
pages.

It could immediately address everything except pre-registration. And
do you really care about pre-registration? Why? Running performance
workloads with the iommu doing a DMA mapping is pretty unusual.

> > Pre-iommu-mapping the pool seems like an orthogonal project as it
> > applies to everything coming from pre-registered io uring buffers,
> > even normal cpu memory. You could have a next step of pre-mapping the
> > P2P pages and CPU pages equally.
> 
> It was already tried for normal user memory (not by me), but
> the verdict was that it should be dma-buf based.

I'm not sure how DMA-buf helps anything here. It is the io uring layer
that should be interacting with DMA-buf, the lower level stuff
shouldn't touch it.

Jason

