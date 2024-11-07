Return-Path: <io-uring+bounces-4544-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD0599C0C89
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 18:10:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F07C41C22D2C
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 17:10:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B7D1217657;
	Thu,  7 Nov 2024 17:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="z2fkcI7T"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66BA216449;
	Thu,  7 Nov 2024 17:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730999086; cv=fail; b=ofhVJhnS5wqpLxh/mWRVXA+gfyN2jKf68WkeVSkPc/CBwHA7mIN75Gyw1BmR0pWCKGKQUI6YbXQZdyIEXNLtH49tXtrH3me2wt9UonL8zP1ZweTpgzOPPzcrsSaa8C1GZzrJnlut8yFk1AQE+6o+BIs/lxpkVKLgTmfTuVcK5IQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730999086; c=relaxed/simple;
	bh=wc2mAxs2Kxeea0Xe+wGTfRrD9ppkb/SSUYT+pcFG8uc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=F2siUIIVVn7IzqY0hQnbsAHgyXRTwlK4+kWBN3yI+tCzUUMmFdDq989PzqorXPN5vUkkQMTBNr2E4/Hzqa0mJ24oZ9woJQ4Vl7ZAXZz5BrhoeK92qh4GIzcPvZ9mSwTpgEG+IFyMl4xhPf1BJF0WdSsTF7fauZrQnA9l1IrP7bQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=z2fkcI7T; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170]) by mx-outbound42-115.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 07 Nov 2024 17:04:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hDklKdVXN3rLdvd0+kiCFL01avAXVvjdTdnLH6vQ/SfWtDeTsIXh+QIYuMjtiRbWpzgdKPtYFyWcImeOuHlIVnQEvsujHeu4achLL+mIa+bEQ6rCDwUQGLgq/JF5YzVYpUs+xLU/SMLqHfcLUbg6MBTPhOXR0tSXKIklkpHXTFUv56AWLLfB7ZF64QfJQbx/BKLVf7+cgpz9Rux+iFArZQt7RJtJoTG53Gz7735G5rDazNea7Kw6lUdRhM55tm/CHuRu/uzW1PONx8+zoXVdZ6R0oJzPug1W/QlocVzzCgKAcm6oxzbarXv3V+pfkdvMze5OqNqyruvTWxn7JDpRYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lR/i5NJSgjkHp+rLMUus/APsFY7JnE4vZFJkThJqjH0=;
 b=NQIDFuidJBy9JthMso/ebuz2ptFrJexssSMJem5VFPJIZ68rwbjPh7vuNcX/+RxvLDC5fRQLPL53byJpGFVsojbgxxlEJpzuqWhWc/gW0GZcUYJNMnobriiO4BpkdAsiIRXS+cGblRspoMrtXZMsnNIDjZ5E4mmJ+/5qHgK6nWHsBi3gt0IXCE8kquAbuu5+bQOZ4h7gExGrUmkV1wZXUQgIHYFQMoiEgTAg7X42XVt2ysiE4QgGIynTEP4USRilmRxqPeFJOxu7YqX04E0OECXJARllkiDR8juafDxhsRTRQ0HHJGhfYGkjjjbB8Nt5IOa9VDnNL/z5fcUBhk4D9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lR/i5NJSgjkHp+rLMUus/APsFY7JnE4vZFJkThJqjH0=;
 b=z2fkcI7TNmD3+mSvTMHgaXhfV7Lz7JX4SVPxIzxe67d4EyywJSmKiRkvXDYIroX72lnwujGaz6dl/gkXHbDSY5fRGjaQWpY/tQMcxdaQAwCbXem0UhqMyABduIqhIOb+PSw8qT/K3sL9PHmp3Qam1eGQt/ssNEZLYHUSV2bo/7g=
Received: from MW4P222CA0023.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::28)
 by SA1PR19MB4928.namprd19.prod.outlook.com (2603:10b6:806:185::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.21; Thu, 7 Nov
 2024 17:04:20 +0000
Received: from CO1PEPF000044F5.namprd05.prod.outlook.com
 (2603:10b6:303:114:cafe::c1) by MW4P222CA0023.outlook.office365.com
 (2603:10b6:303:114::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19 via Frontend
 Transport; Thu, 7 Nov 2024 17:04:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CO1PEPF000044F5.mail.protection.outlook.com (10.167.241.75) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8137.17
 via Frontend Transport; Thu, 7 Nov 2024 17:04:19 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 12AC9C6;
	Thu,  7 Nov 2024 17:04:18 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Thu, 07 Nov 2024 18:03:53 +0100
Subject: [PATCH RFC v5 09/16] fuse: {uring} Add uring sqe commit and fetch
 support
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241107-fuse-uring-for-6-10-rfc4-v5-9-e8660a991499@ddn.com>
References: <20241107-fuse-uring-for-6-10-rfc4-v5-0-e8660a991499@ddn.com>
In-Reply-To: <20241107-fuse-uring-for-6-10-rfc4-v5-0-e8660a991499@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730999049; l=18832;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=wc2mAxs2Kxeea0Xe+wGTfRrD9ppkb/SSUYT+pcFG8uc=;
 b=nhLmFBi+c8jODrcCM+/bc59+pMBhprKATalO8aMCub0PqGdyC10K8BoXjyCPQeAPrqezmGtz8
 LqPChMm8ICJDW/c+KCyEItz0IdmzOVI5pnPOuWn+HE8e2nNGAsquV6x
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F5:EE_|SA1PR19MB4928:EE_
X-MS-Office365-Filtering-Correlation-Id: 692fd557-f271-4d93-83e0-08dcff4e386c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U0dOVldOV2dSaVhVVW82WE9xOXh3MUhDQ1l3ZHJlcFBlTmM1aXRGNlg3Rnl4?=
 =?utf-8?B?ZmVVdVh0emt2YjEzVmovbmN0L3VKbnUzVENnNHNxZFRFTjUva09Wc1lscVla?=
 =?utf-8?B?dDc5RndRMGNwUGtJb0RVUkJ1ZkVvanhrNnV3b0xSTnJWVThXYis5cStLc2tr?=
 =?utf-8?B?ZGZHOVNtQTRDV2tpYXJqb21KcWNtRTVycWtEM0gyTE9YRXNFbnF1d1B3em0w?=
 =?utf-8?B?VmEycWd1Q0ozbzZjZW5qYzloS3lidnY5ejRLRFRPUU9kOVFpM0RiWTdsdGRo?=
 =?utf-8?B?Q2l5L1gyaDRvOUc0eWFkaVBtVGVUVC9JTW9PYitxaUo3S2wwemdUSkx5SU1l?=
 =?utf-8?B?ZmJYZEthUmsrd1NmdWV0aGc2cVI4dm1QM2NzbVJ6VGZDbTA1UWpiSkJHM3Q1?=
 =?utf-8?B?bDBNWk5tOXJYaHlUVnBOZWRmaUtabStsZGZyNytOeWFqekd2cU5xV0M5NFRk?=
 =?utf-8?B?TkloaTA2cjROZW5jZlBMbnF3c1IrWlRGWUZZeFhhS2MwZ0xYdk5ReEZtVERs?=
 =?utf-8?B?VGtMTmNYV2FXYUo3OHhWdURBNkdDVXh3ajBWSC81WlRrbk5UbFNTcmFJOHo0?=
 =?utf-8?B?alhrNExxZzVSUG9STU1oS2hTVUNMZWZuelQ4VG1NYU5vU01hRFc2SVJTYUVU?=
 =?utf-8?B?WFNaZnFlODZWQWJJd2NTcGtUckxaaFdRWkVWOEY3TnM0R3RjSTUyVTI1VDA0?=
 =?utf-8?B?QjRuNVJIQUNabDhtdzF0VUwyS1FyK1ppTUIwK2dSR1B2RzI2b0xha21CNlFn?=
 =?utf-8?B?OXowdVEyMlo2VVprazJQSW9uR2FwQzk5TytXZTVMUExVOFIyTXdlSlV1UlJT?=
 =?utf-8?B?SXh4WldYbHhWbllYRERwZUo5ZkdMR1J5eVk4d2FDYTR2RTRhQWw1V1JrcW0x?=
 =?utf-8?B?Vk82MHJqbStnT0FDT2lOUHQ2UGRteFJ1b2IvUWNOdWFnNVVzYUpRcEhUbWwr?=
 =?utf-8?B?TWlJYVI3VC94Z2w2ME1jdmRmU0ZFSVZEMnA0dzNOZU9Nb0JNN1E2aVFqd1NQ?=
 =?utf-8?B?bmd6NVZtZktYUFhLTDBWWE4xNkVMeUZjZ2tHdnI3bDNzWEU1YVNRWFVoV0U3?=
 =?utf-8?B?T3RiK2x5UnZGT2RsMStuZCtKbXVldVRPU3hybHZRdjExcGVGVnlEQTI1REl5?=
 =?utf-8?B?SWJXY21PMU1ySDVOL1Uxcm9GZ256THpENEFSS0VRbk81bjJwcWpZTEZuTnNQ?=
 =?utf-8?B?cHdFWEtzbVpTWUtONlVhZFEzRlJyQmdRRUxCRTdzRlVZOFlUdE1KdUJDTE5C?=
 =?utf-8?B?Wm1BYzFnRzNaQ0NsUCs2RDVuNFVDbnJrVE53SHYvTExVTUhLTnd5UnZFaTBR?=
 =?utf-8?B?TDErdnF1ZTBqWWtDd2pWQWlQY2J2RS9nNUtMcVA4eFdTQnY2eVhxTVgybUlh?=
 =?utf-8?B?R3B3dHk4K1NPQ1gwN3JRb2RkNDcyUFFmS2N5L0RsdStmRHJGNWpIQWlYdExW?=
 =?utf-8?B?NHlaWnFtOUFaa1FGbUZ1Q1RWZ3FaN1cyWG40TmprTWhjL3ZyQ05iNjl2REV6?=
 =?utf-8?B?cStGc25ZdVllcjJ3NGhjWC9GUGlOVnNaK0s5SVkyOTE5TkxsYzVlVVowYVpq?=
 =?utf-8?B?QUMwUnpyZHdBQ0VaVi9FVXlJY2k3MkxqcHpRTjJPWlAreWlzMnpSeEpPZk1U?=
 =?utf-8?B?dVRjL2xoQTVweGZiOS9pOGJwVEJXVGpxblA5SnRoUG1wUmdMdEpIS1BCMG9o?=
 =?utf-8?B?cXpPSXdNaS9tdUNTdk1EeEtkYUlBZ0oxNVlVSG5wUzV6YXhQaDQxdjhuT0xJ?=
 =?utf-8?B?Ym1Idkx2UjZkTnU2RVJiNVU4WDhiOVBqYksyOG8yK21Fc3hDMGJOaHhhMlpZ?=
 =?utf-8?B?MmZMbHZyeEtOQWxaYi9xL2RpRzcxdEZrMjFtdk1wQ2I3OFBrTlIxbTNrd0dm?=
 =?utf-8?B?UFdQUnRYWlhtbnNZQ1NjOU9BZkREVEZJUlNCYUdNeW50dFE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(7416014)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	M98dlsemyWX2HOr/yLPsI8uHzqdNZBKAtbxethiKozdngwLJzbTgoQt99hZ7LpoTbpsPl0tE95HYqgBrKG1Kg21FzWsqJ3To+ecyloFPoPod2KbT4dTs9IQd7djyPge/h+s4C72SXBjRvQ28g1Rn2An/Y/W5wFoKnRbjelJhD0f7oSPKjdrdd19n3P9kH1ud00aMDXHsKX0oU9n/N0x3Mrb8OuZ9ZtdujR40GtzT1OYB1QL1+1zbPIHTBCXn7LbkiT48onSYf3eBJsZ6dN8WnWz/oBHPwcj6Z1q2nhqB2/zpmEnJA4kFExWAK4gTbGVzODXbFFt4rKy8KvtlmCCk5u2i6dwQjLidD2urZvKe71I75UOaBaz/RQKuZScI516X7/X2aA1j12HKvsyjT4HPD4sAqC3L20UQFOwSF6oeo3p9mIbxxyubJrmhven3gjkv/BdW0LbByHysbUt4HK+KB6vLYwtQDwJq6OC31LWIzloUWAfXs1+h/7WWmTvW75YkHs6WreHjW/drZ+WfxPYkSC6MAXgNoT9v81QEtcYGNX7ilnJnv5DVKBgdM3CMGi3pxUiHZzrul5SCsuJ3wQRh7DczqzG0xtnG6AN9sFr/LkKvLQajBKzV9nFLJlrAH2tz2WaDrFxuwKc5Wlp7f0dzkA==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 17:04:19.7998
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 692fd557-f271-4d93-83e0-08dcff4e386c
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F5.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR19MB4928
X-BESS-ID: 1730999068-110867-12758-13482-1
X-BESS-VER: 2019.1_20241029.2310
X-BESS-Apparent-Source-IP: 104.47.55.170
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoYWhuYGQGYGUDTN2NjY3MIwzR
	xIG5qmmaclJhqlGhobGqQYW5oYpJko1cYCAJ3hzPJCAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260269 [from 
	cloudscan8-205.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This adds support for fuse request completion through ring SQEs
(FUSE_URING_REQ_COMMIT_AND_FETCH handling). After committing
the ring entry it becomes available for new fuse requests.
Handling of requests through the ring (SQE/CQE handling)
is complete now.

Fuse request data are copied through the mmaped ring buffer,
there is no support for any zero copy yet.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev.c         |   6 +-
 fs/fuse/dev_uring.c   | 449 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h |  11 ++
 fs/fuse/fuse_dev_i.h  |   7 +-
 fs/fuse/fuse_i.h      |   9 +
 fs/fuse/inode.c       |   2 +-
 6 files changed, 479 insertions(+), 5 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 4ca67c8ae0e28072383478d6ee7ad7791566b6ce..b085176ea824bd612a8736e00c9b6f8f9e232208 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -188,7 +188,7 @@ u64 fuse_get_unique(struct fuse_iqueue *fiq)
 }
 EXPORT_SYMBOL_GPL(fuse_get_unique);
 
-static unsigned int fuse_req_hash(u64 unique)
+unsigned int fuse_req_hash(u64 unique)
 {
 	return hash_long(unique & ~FUSE_INT_REQ_BIT, FUSE_PQ_HASH_BITS);
 }
@@ -1860,7 +1860,7 @@ static int fuse_notify(struct fuse_conn *fc, enum fuse_notify_code code,
 }
 
 /* Look up request on processing list by unique ID */
-static struct fuse_req *request_find(struct fuse_pqueue *fpq, u64 unique)
+struct fuse_req *fuse_request_find(struct fuse_pqueue *fpq, u64 unique)
 {
 	unsigned int hash = fuse_req_hash(unique);
 	struct fuse_req *req;
@@ -1944,7 +1944,7 @@ static ssize_t fuse_dev_do_write(struct fuse_dev *fud,
 	spin_lock(&fpq->lock);
 	req = NULL;
 	if (fpq->connected)
-		req = request_find(fpq, oh.unique & ~FUSE_INT_REQ_BIT);
+		req = fuse_request_find(fpq, oh.unique & ~FUSE_INT_REQ_BIT);
 
 	err = -ENOENT;
 	if (!req) {
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index ce0a41b00613133ea1b8062290bc960b95254ac9..4f8a0bd1e2192bfbc310eb53dd8e89274e6f479b 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -19,6 +19,24 @@ MODULE_PARM_DESC(enable_uring,
 		 "Enable uring userspace communication through uring.");
 #endif
 
+#define FUSE_URING_IOV_SEGS 2 /* header and payload */
+
+/*
+ * Finalize a fuse request, then fetch and send the next entry, if available
+ */
+static void fuse_uring_req_end(struct fuse_ring_ent *ring_ent, bool set_err,
+			       int error)
+{
+	struct fuse_req *req = ring_ent->fuse_req;
+
+	if (set_err)
+		req->out.h.error = error;
+
+	clear_bit(FR_SENT, &req->flags);
+	fuse_request_end(ring_ent->fuse_req);
+	ring_ent->fuse_req = NULL;
+}
+
 static int fuse_ring_ent_unset_userspace(struct fuse_ring_ent *ent)
 {
 	struct fuse_ring_queue *queue = ent->queue;
@@ -50,7 +68,9 @@ void fuse_uring_destruct(struct fuse_conn *fc)
 
 		WARN_ON(!list_empty(&queue->ent_avail_queue));
 		WARN_ON(!list_empty(&queue->ent_intermediate_queue));
+		WARN_ON(!list_empty(&queue->ent_in_userspace));
 
+		kfree(queue->fpq.processing);
 		kfree(queue);
 		ring->queues[qid] = NULL;
 	}
@@ -109,13 +129,21 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
 {
 	struct fuse_conn *fc = ring->fc;
 	struct fuse_ring_queue *queue;
+	struct list_head *pq;
 
 	queue = kzalloc(sizeof(*queue), GFP_KERNEL_ACCOUNT);
 	if (!queue)
 		return ERR_PTR(-ENOMEM);
+	pq = kcalloc(FUSE_PQ_HASH_SIZE, sizeof(struct list_head), GFP_KERNEL);
+	if (!pq) {
+		kfree(queue);
+		return ERR_PTR(-ENOMEM);
+	}
+
 	spin_lock(&fc->lock);
 	if (ring->queues[qid]) {
 		spin_unlock(&fc->lock);
+		kfree(queue->fpq.processing);
 		kfree(queue);
 		return ring->queues[qid];
 	}
@@ -127,12 +155,244 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
 
 	INIT_LIST_HEAD(&queue->ent_avail_queue);
 	INIT_LIST_HEAD(&queue->ent_intermediate_queue);
+	INIT_LIST_HEAD(&queue->ent_in_userspace);
+	INIT_LIST_HEAD(&queue->fuse_req_queue);
+
+	queue->fpq.processing = pq;
+	fuse_pqueue_init(&queue->fpq);
 
 	spin_unlock(&fc->lock);
 
 	return queue;
 }
 
+static void
+fuse_uring_async_send_to_ring(struct io_uring_cmd *cmd,
+			      unsigned int issue_flags)
+{
+	io_uring_cmd_done(cmd, 0, 0, issue_flags);
+}
+
+/*
+ * Checks for errors and stores it into the request
+ */
+static int fuse_uring_out_header_has_err(struct fuse_out_header *oh,
+					 struct fuse_req *req,
+					 struct fuse_conn *fc)
+{
+	int err;
+
+	if (oh->unique == 0) {
+		/* Not supportd through request based uring, this needs another
+		 * ring from user space to kernel
+		 */
+		pr_warn("Unsupported fuse-notify\n");
+		err = -EINVAL;
+		goto seterr;
+	}
+
+	if (oh->error <= -512 || oh->error > 0) {
+		err = -EINVAL;
+		goto seterr;
+	}
+
+	if (oh->error) {
+		err = oh->error;
+		pr_devel("%s:%d err=%d op=%d req-ret=%d", __func__, __LINE__,
+			 err, req->args->opcode, req->out.h.error);
+		goto err; /* error already set */
+	}
+
+	if ((oh->unique & ~FUSE_INT_REQ_BIT) != req->in.h.unique) {
+		pr_warn("Unpexted seqno mismatch, expected: %llu got %llu\n",
+			req->in.h.unique, oh->unique & ~FUSE_INT_REQ_BIT);
+		err = -ENOENT;
+		goto seterr;
+	}
+
+	/* Is it an interrupt reply ID?	 */
+	if (oh->unique & FUSE_INT_REQ_BIT) {
+		err = 0;
+		if (oh->error == -ENOSYS)
+			fc->no_interrupt = 1;
+		else if (oh->error == -EAGAIN) {
+			/* XXX Interrupts not handled yet */
+			/* err = queue_interrupt(req); */
+			pr_warn("Intrerupt EAGAIN not supported yet");
+			err = -EINVAL;
+		}
+
+		goto seterr;
+	}
+
+	return 0;
+
+seterr:
+	pr_devel("%s:%d err=%d op=%d req-ret=%d", __func__, __LINE__, err,
+		 req->args->opcode, req->out.h.error);
+	oh->error = err;
+err:
+	return err;
+}
+
+static int fuse_uring_copy_from_ring(struct fuse_ring *ring,
+				     struct fuse_req *req,
+				     struct fuse_ring_ent *ent)
+{
+	struct fuse_copy_state cs;
+	struct fuse_args *args = req->args;
+	struct iov_iter iter;
+	int err;
+	int res_arg_len;
+
+	err = copy_from_user(&res_arg_len, &ent->headers->in_out_arg_len,
+			     sizeof(res_arg_len));
+	if (err)
+		return err;
+
+	err = import_ubuf(ITER_SOURCE, ent->payload, ent->max_arg_len, &iter);
+	if (err)
+		return err;
+
+	fuse_copy_init(&cs, 0, &iter);
+	cs.is_uring = 1;
+	cs.req = req;
+
+	return fuse_copy_out_args(&cs, args, res_arg_len);
+}
+
+ /*
+  * Copy data from the req to the ring buffer
+  */
+static int fuse_uring_copy_to_ring(struct fuse_ring *ring, struct fuse_req *req,
+				   struct fuse_ring_ent *ent)
+{
+	struct fuse_copy_state cs;
+	struct fuse_args *args = req->args;
+	struct fuse_in_arg *in_args = args->in_args;
+	int num_args = args->in_numargs;
+	int err, res;
+	struct iov_iter iter;
+
+	if (num_args == 0)
+		return 0;
+
+	err = import_ubuf(ITER_DEST, ent->payload, ent->max_arg_len, &iter);
+	if (err) {
+		pr_info_ratelimited("Import user buffer failed\n");
+		return err;
+	}
+
+	fuse_copy_init(&cs, 1, &iter);
+	cs.is_uring = 1;
+	cs.req = req;
+
+	/*
+	 * Expectation is that the first argument is the header, for some
+	 * operations it might be zero.
+	 */
+	if (args->in_args[0].size > 0) {
+		res = copy_to_user(&ent->headers->op_in, in_args->value,
+				   in_args->size);
+		err = res > 0 ? -EFAULT : res;
+		if (err) {
+			pr_info_ratelimited("Copying the header failed.\n");
+			return err;
+		}
+	}
+
+	/* Skip the already handled header */
+	in_args++;
+	num_args--;
+
+	err = fuse_copy_args(&cs, num_args, args->in_pages,
+			     (struct fuse_arg *)in_args, 0);
+	if (err) {
+		pr_info_ratelimited("%s fuse_copy_args failed\n", __func__);
+		return err;
+	}
+
+	BUILD_BUG_ON((sizeof(ent->headers->in_out_arg_len) !=
+		      sizeof(cs.ring.offset)));
+	res = copy_to_user(&ent->headers->in_out_arg_len, &cs.ring.offset,
+			   sizeof(ent->headers->in_out_arg_len));
+	err = res > 0 ? -EFAULT : res;
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static int
+fuse_uring_prepare_send(struct fuse_ring_ent *ring_ent)
+{
+	struct fuse_ring_queue *queue = ring_ent->queue;
+	struct fuse_ring *ring = queue->ring;
+	struct fuse_req *req = ring_ent->fuse_req;
+	int err = 0, res;
+
+	if (WARN_ON(ring_ent->state != FRRS_FUSE_REQ)) {
+		pr_err("qid=%d ring-req=%p invalid state %d on send\n",
+		       queue->qid, ring_ent, ring_ent->state);
+		err = -EIO;
+	}
+
+	if (err)
+		return err;
+
+	pr_devel("%s qid=%d state=%d cmd-done op=%d unique=%llu\n", __func__,
+		 queue->qid, ring_ent->state, req->in.h.opcode,
+		 req->in.h.unique);
+
+	/* copy the request */
+	err = fuse_uring_copy_to_ring(ring, req, ring_ent);
+	if (unlikely(err)) {
+		pr_info("Copy to ring failed: %d\n", err);
+		goto err;
+	}
+
+	/* copy fuse_in_header */
+	res = copy_to_user(&ring_ent->headers->in, &req->in.h,
+			   sizeof(req->in.h));
+	err = res > 0 ? -EFAULT : res;
+	if (err)
+		goto err;
+
+	set_bit(FR_SENT, &req->flags);
+	return 0;
+
+err:
+	fuse_uring_req_end(ring_ent, true, err);
+	return err;
+}
+
+/*
+ * Write data to the ring buffer and send the request to userspace,
+ * userspace will read it
+ * This is comparable with classical read(/dev/fuse)
+ */
+static int fuse_uring_send_next_to_ring(struct fuse_ring_ent *ring_ent)
+{
+	int err = 0;
+	struct fuse_ring_queue *queue = ring_ent->queue;
+
+	err = fuse_uring_prepare_send(ring_ent);
+	if (err)
+		goto err;
+
+	spin_lock(&queue->lock);
+	ring_ent->state = FRRS_USERSPACE;
+	list_move(&ring_ent->list, &queue->ent_in_userspace);
+	spin_unlock(&queue->lock);
+
+	io_uring_cmd_complete_in_task(ring_ent->cmd,
+				      fuse_uring_async_send_to_ring);
+	return 0;
+
+err:
+	return err;
+}
+
 /*
  * Put a ring request onto hold, it is no longer used for now.
  */
@@ -159,6 +419,192 @@ static void fuse_uring_ent_avail(struct fuse_ring_ent *ring_ent,
 	ring_ent->state = FRRS_WAIT;
 }
 
+/* Used to find the request on SQE commit */
+static void fuse_uring_add_to_pq(struct fuse_ring_ent *ring_ent)
+{
+	struct fuse_ring_queue *queue = ring_ent->queue;
+	struct fuse_req *req = ring_ent->fuse_req;
+	struct fuse_pqueue *fpq = &queue->fpq;
+	unsigned int hash;
+
+	hash = fuse_req_hash(req->in.h.unique);
+	list_move_tail(&req->list, &fpq->processing[hash]);
+	req->ring_entry = ring_ent;
+}
+
+/*
+ * Assign a fuse queue entry to the given entry
+ */
+static void fuse_uring_add_req_to_ring_ent(struct fuse_ring_ent *ring_ent,
+					   struct fuse_req *req)
+{
+	lockdep_assert_held(&ring_ent->queue->lock);
+
+	if (WARN_ON_ONCE(ring_ent->state != FRRS_WAIT &&
+			 ring_ent->state != FRRS_COMMIT)) {
+		pr_warn("%s qid=%d state=%d\n", __func__, ring_ent->queue->qid,
+			ring_ent->state);
+	}
+	list_del_init(&req->list);
+	clear_bit(FR_PENDING, &req->flags);
+	ring_ent->fuse_req = req;
+	ring_ent->state = FRRS_FUSE_REQ;
+
+	fuse_uring_add_to_pq(ring_ent);
+}
+
+/*
+ * Release the ring entry and fetch the next fuse request if available
+ *
+ * @return true if a new request has been fetched
+ */
+static bool fuse_uring_ent_assign_req(struct fuse_ring_ent *ring_ent)
+	__must_hold(&queue->lock)
+{
+	struct fuse_req *req = NULL;
+	struct fuse_ring_queue *queue = ring_ent->queue;
+	struct list_head *req_queue = &queue->fuse_req_queue;
+
+	lockdep_assert_held(&queue->lock);
+
+	/* get and assign the next entry while it is still holding the lock */
+	if (!list_empty(req_queue)) {
+		req = list_first_entry(req_queue, struct fuse_req, list);
+		fuse_uring_add_req_to_ring_ent(ring_ent, req);
+		list_move(&ring_ent->list, &queue->ent_intermediate_queue);
+	}
+
+	return req ? true : false;
+}
+
+/*
+ * Read data from the ring buffer, which user space has written to
+ * This is comparible with handling of classical write(/dev/fuse).
+ * Also make the ring request available again for new fuse requests.
+ */
+static void fuse_uring_commit(struct fuse_ring_ent *ring_ent,
+			      unsigned int issue_flags)
+{
+	struct fuse_ring *ring = ring_ent->queue->ring;
+	struct fuse_conn *fc = ring->fc;
+	struct fuse_req *req = ring_ent->fuse_req;
+	ssize_t err = 0;
+	bool set_err = false;
+
+	err = copy_from_user(&req->out.h, &ring_ent->headers->out,
+			     sizeof(req->out.h));
+	if (err) {
+		req->out.h.error = err;
+		goto out;
+	}
+
+	err = fuse_uring_out_header_has_err(&req->out.h, req, fc);
+	if (err) {
+		/* req->out.h.error already set */
+		pr_devel("%s:%d err=%zd oh->err=%d\n", __func__, __LINE__, err,
+			 req->out.h.error);
+		goto out;
+	}
+
+	err = fuse_uring_copy_from_ring(ring, req, ring_ent);
+	if (err)
+		set_err = true;
+
+out:
+	pr_devel("%s:%d ret=%zd op=%d req-ret=%d\n", __func__, __LINE__, err,
+		 req->args->opcode, req->out.h.error);
+	fuse_uring_req_end(ring_ent, set_err, err);
+}
+
+/*
+ * Get the next fuse req and send it
+ */
+static void fuse_uring_next_fuse_req(struct fuse_ring_ent *ring_ent,
+				    struct fuse_ring_queue *queue)
+{
+	int has_next, err;
+	int prev_state = ring_ent->state;
+
+	do {
+		spin_lock(&queue->lock);
+		has_next = fuse_uring_ent_assign_req(ring_ent);
+		if (!has_next) {
+			fuse_uring_ent_avail(ring_ent, queue);
+			spin_unlock(&queue->lock);
+			break; /* no request left */
+		}
+		spin_unlock(&queue->lock);
+
+		err = fuse_uring_send_next_to_ring(ring_ent);
+		if (err)
+			ring_ent->state = prev_state;
+	} while (err);
+}
+
+/* FUSE_URING_REQ_COMMIT_AND_FETCH handler */
+static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
+				   struct fuse_conn *fc)
+{
+	const struct fuse_uring_cmd_req *cmd_req = io_uring_sqe_cmd(cmd->sqe);
+	struct fuse_ring_ent *ring_ent;
+	int err;
+	struct fuse_ring *ring = fc->ring;
+	struct fuse_ring_queue *queue;
+	uint64_t commit_id = cmd_req->commit_id;
+	struct fuse_pqueue fpq;
+	struct fuse_req *req;
+
+	err = -ENOTCONN;
+	if (!ring)
+		return err;
+
+	queue = ring->queues[cmd_req->qid];
+	if (!queue)
+		return err;
+	fpq = queue->fpq;
+
+	spin_lock(&queue->lock);
+	/* Find a request based on the unique ID of the fuse request
+	 * This should get revised, as it needs a hash calculation and list
+	 * search. And full struct fuse_pqueue is needed (memory overhead).
+	 * As well as the link from req to ring_ent.
+	 */
+	req = fuse_request_find(&fpq, commit_id);
+	err = -ENOENT;
+	if (!req) {
+		pr_info("qid=%d commit_id %llu not found\n", queue->qid,
+			commit_id);
+		spin_unlock(&queue->lock);
+		return err;
+	}
+	list_del_init(&req->list);
+	ring_ent = req->ring_entry;
+	req->ring_entry = NULL;
+
+	err = fuse_ring_ent_unset_userspace(ring_ent);
+	if (err != 0) {
+		pr_info_ratelimited("qid=%d commit_id %llu state %d",
+				    queue->qid, commit_id, ring_ent->state);
+		spin_unlock(&queue->lock);
+		return err;
+	}
+
+	ring_ent->cmd = cmd;
+	spin_unlock(&queue->lock);
+
+	/* without the queue lock, as other locks are taken */
+	fuse_uring_commit(ring_ent, issue_flags);
+
+	/*
+	 * Fetching the next request is absolutely required as queued
+	 * fuse requests would otherwise not get processed - committing
+	 * and fetching is done in one step vs legacy fuse, which has separated
+	 * read (fetch request) and write (commit result).
+	 */
+	fuse_uring_next_fuse_req(ring_ent, queue);
+	return 0;
+}
+
 /*
  * fuse_uring_req_fetch command handling
  */
@@ -333,6 +779,9 @@ int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 		if (err)
 			pr_info_once("fuse_uring_fetch failed err=%d\n", err);
 		break;
+	case FUSE_URING_REQ_COMMIT_AND_FETCH:
+		err = fuse_uring_commit_fetch(cmd, issue_flags, fc);
+		break;
 	default:
 		err = -EINVAL;
 		pr_devel("Unknown uring command %d", cmd_op);
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index 11798080896372c72692228ff7072bbee6a63e53..c7bac19e91b781fc9ccce540e39d99b39b751f6b 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -19,6 +19,9 @@ enum fuse_ring_req_state {
 	/* The ring request waits for a new fuse request */
 	FRRS_WAIT,
 
+	/* The ring req got assigned a fuse req */
+	FRRS_FUSE_REQ,
+
 	/* request is in or on the way to user space */
 	FRRS_USERSPACE,
 };
@@ -72,6 +75,14 @@ struct fuse_ring_queue {
 	 * to be send to userspace
 	 */
 	struct list_head ent_intermediate_queue;
+
+	/* entries in userspace */
+	struct list_head ent_in_userspace;
+
+	/* fuse requests waiting for an entry slot */
+	struct list_head fuse_req_queue;
+
+	struct fuse_pqueue fpq;
 };
 
 /**
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index 7ecb103af6f0feca99eb8940872c6a5ccf2e5186..a8d578b99a14239c05b4a496a4b3b1396eb768dd 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -7,7 +7,7 @@
 #define _FS_FUSE_DEV_I_H
 
 #include <linux/types.h>
-
+#include <linux/fs.h>
 
 /* Ordinary requests have even IDs, while interrupts IDs are odd */
 #define FUSE_INT_REQ_BIT (1ULL << 0)
@@ -15,6 +15,8 @@
 
 struct fuse_arg;
 struct fuse_args;
+struct fuse_pqueue;
+struct fuse_req;
 
 struct fuse_copy_state {
 	int write;
@@ -44,6 +46,9 @@ static inline struct fuse_dev *fuse_get_dev(struct file *file)
 	return READ_ONCE(file->private_data);
 }
 
+unsigned int fuse_req_hash(u64 unique);
+struct fuse_req *fuse_request_find(struct fuse_pqueue *fpq, u64 unique);
+
 void fuse_dev_end_requests(struct list_head *head);
 
 void fuse_copy_init(struct fuse_copy_state *cs, int write,
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 91c2e7e35cdbd470894a8a9cd026b77368b7a4b6..8bb6bd1854e41afb52a0d0081fa5fc6bfdfa58d8 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -435,6 +435,10 @@ struct fuse_req {
 
 	/** fuse_mount this request belongs to */
 	struct fuse_mount *fm;
+
+#ifdef CONFIG_FUSE_IO_URING
+	void *ring_entry;
+#endif
 };
 
 struct fuse_iqueue;
@@ -1207,6 +1211,11 @@ void fuse_change_entry_timeout(struct dentry *entry, struct fuse_entry_out *o);
  */
 struct fuse_conn *fuse_conn_get(struct fuse_conn *fc);
 
+/**
+ * Initialize the fuse processing queue
+ */
+void fuse_pqueue_init(struct fuse_pqueue *fpq);
+
 /**
  * Initialize fuse_conn
  */
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 59f8fb7b915f052f892d587a0f9a8dc17cf750ce..a1179c1e212b7a1cfd6e69f20dd5fcbe18c6202b 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -894,7 +894,7 @@ static void fuse_iqueue_init(struct fuse_iqueue *fiq,
 	fiq->priv = priv;
 }
 
-static void fuse_pqueue_init(struct fuse_pqueue *fpq)
+void fuse_pqueue_init(struct fuse_pqueue *fpq)
 {
 	unsigned int i;
 

-- 
2.43.0


