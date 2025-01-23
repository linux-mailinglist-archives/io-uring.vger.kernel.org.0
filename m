Return-Path: <io-uring+bounces-6076-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F170A1A636
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 15:52:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F2C23AAA38
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 14:52:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E8CB2101B5;
	Thu, 23 Jan 2025 14:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="1mKMg9p6"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11FF2116F7;
	Thu, 23 Jan 2025 14:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737643904; cv=fail; b=HRtxQcEW+Fg6PSnfGV1FZLn7VGwkagtZLYqYxrdrTaGhvIaz8yISVwIkf7/MeHVvA0ZWwCgKsbnzuaurCn2KjGs+KAB466XijhYIPzw4KYBug8HmskNrPpeEu00x/LHzX8TtY8CrkDRt3lkOOFgaZTNeg3OPysv538v0OcuOhdI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737643904; c=relaxed/simple;
	bh=CKEaRPam95CWIQlDjvZ4t7TYcD3yT0Mx4sWZgSxX9J4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=I8vW5wcEKnUzotwyFuFoK7ZkbwS8CpdVhcdxlemJbM9zInJI3R+Ppl9pC1bToqAVcTuE0VRK/nRSvwAH4aHrCl+XkgcRouSZfSUjyAlRh6AclqF9U8n85pX5me/B09uX50LH4mOBfyMZWTBt7GqK4dku5tRkYEkwKx7xZSu3h/k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=1mKMg9p6; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168]) by mx-outbound45-228.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 23 Jan 2025 14:51:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oUUkXj4VkeHLs3POynXXDFHxyCZ8oBhAQXGewzGpG92n5mZ/foA9OgAJFvU+fMT+ZEBJ4m2Rr0DXFy+pmSUxfXPmBPgQ+YzhoywHvfGGuWBWP4nF9QF2k9bLprgc58C8Oe7gs5z0Hnr5dBdWLNlGGuYY3WRSIKeTimf8zkLL+yqakPzZSMMOkJK4GfsfXbLvPWArl1eR4aAieL/XBKgFvXaQOfpOFSwh5AZy26qp/emQ9TPVD+EPecnSZB8I4ixf2L/nfeIF8N03W18gls7LXrPc+Iz+WNNUf7IzoIny/4VNYlqYbLcD+DtnyIyZOyTqYx0MPOyL3pOJ2e8Sk43YqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ki4gPayiT/3xhe1yF43+6U+upbRK3PsctQEV29vLEmk=;
 b=DtX/GlcTYNFluKD7NOOpTW4arwVMtIvhq3fGGuYTu81de5Tslt5f00pxqA9oibmBa4JKuR3SeLuXOwpTujQJT2TG22eVFOpcH2L7NIKMmfbGSJEaKcdGsguMR+GL1rihzoGWPYieicwixSOj+MYHH4S4fhJ7pUXCwb+pPRZHBq3WEaVDlzbMsAtzlFfjnaaeSpsKhyGqQCcuSIdRiZ86844JyQ8mZ7iSNizA/MEqxAamCOrYndfAvgIAyS2rvOD0LoHpLoEJ5YF2C8RqRsBT9Ja6eDfHhiOtqSy0YIxcI75zXh9T3AaorRJIHunhi95BkEERTJk01VHNl7si52YJhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ki4gPayiT/3xhe1yF43+6U+upbRK3PsctQEV29vLEmk=;
 b=1mKMg9p6SvXrRl4rNmSzmupfI/1Az3pKRFOZ70x0eHZWwzAad29X6iNUH2fHWpg/J4YKOFqLDMV+uJUmnOJZORcF2YiO8pB4A09W2XknjHh+NCPMyr9Leey2NEVUxYtmlgzR16LpQdtI2UtsSFn1sJKy2+eFUVf41tGUUewaM/0=
Received: from SJ0PR13CA0038.namprd13.prod.outlook.com (2603:10b6:a03:2c2::13)
 by DS0PR19MB7975.namprd19.prod.outlook.com (2603:10b6:8:15f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Thu, 23 Jan
 2025 14:51:25 +0000
Received: from SJ1PEPF00001CEB.namprd03.prod.outlook.com
 (2603:10b6:a03:2c2:cafe::93) by SJ0PR13CA0038.outlook.office365.com
 (2603:10b6:a03:2c2::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.14 via Frontend Transport; Thu,
 23 Jan 2025 14:51:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SJ1PEPF00001CEB.mail.protection.outlook.com (10.167.242.27) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.8
 via Frontend Transport; Thu, 23 Jan 2025 14:51:24 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id D30A980;
	Thu, 23 Jan 2025 14:51:23 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Thu, 23 Jan 2025 15:51:11 +0100
Subject: [PATCH v11 12/18] fuse: {io-uring} Make
 fuse_dev_queue_{interrupt,forget} non-static
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250123-fuse-uring-for-6-10-rfc4-v11-12-11e9cecf4cfb@ddn.com>
References: <20250123-fuse-uring-for-6-10-rfc4-v11-0-11e9cecf4cfb@ddn.com>
In-Reply-To: <20250123-fuse-uring-for-6-10-rfc4-v11-0-11e9cecf4cfb@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Luis Henriques <luis@igalia.com>, Dan Carpenter <dan.carpenter@linaro.org>, 
 Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <mszeredi@redhat.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737643871; l=1965;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=CKEaRPam95CWIQlDjvZ4t7TYcD3yT0Mx4sWZgSxX9J4=;
 b=2y6Kljv6rR8RkEfw65mBTn/C3/8SORLksfxXMcuvYFVSLn6mgatLPyFkPlgqlJwPzPaUYQhT2
 nSnOVjrSwoaCnIRLrLINT2+HiUhRsvyPoZr+cIPI6EG+R4xMYqjnNEg
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CEB:EE_|DS0PR19MB7975:EE_
X-MS-Office365-Filtering-Correlation-Id: ddf0ce40-a230-4587-cf37-08dd3bbd68a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UmsvZ2JvK1dVTTdhUnVNRmtxZ2hidHdlcFBPRVl2dEpiTitWaTF1NDNrM3lT?=
 =?utf-8?B?YTh3R2NxUTlscThxbnpFSHU0RFZtK2cxcWJzRFdhK2U1alVhQlA0TFRydHRO?=
 =?utf-8?B?ME5aWkU0MGY4enp6NlpiemwrVHVrOU0ya3FsOFR1bldaSTZDUmVkVnNzcFNt?=
 =?utf-8?B?NDJLcGQ3L1BaUzdZZmlMOGdIOFZiMEo5K1NKUElyZnpFTW9DY1R3dCtVeEhC?=
 =?utf-8?B?Mmh5ek1WSnNCZ0JjbmpOanIxczI5cWNEcUNEbU5JUk8xdVV3dU5MWVkzamU1?=
 =?utf-8?B?WCswa3lScHlLSjBTNHFIUXRpcS9veWxlSC9jTnRRWndVWjdVNEFQUzBUMmFw?=
 =?utf-8?B?bk9ZWU9UcUUyYTlmdTlTWjdrYks0c3NHL2hhdjdEbFlRU0xJbmV6N1dhOEM2?=
 =?utf-8?B?enpvb1Z2UnhuRWtDNCtPVUptRk5Obk1UNmMyWTY4aW5Gb2dxSWRlZUtYQ1Bt?=
 =?utf-8?B?NXAvTmtWem14RWZEd2cvSlBBTjBlVUJWamlLUVRsOVdnSFNnenJsZ09BYVc1?=
 =?utf-8?B?aGVaSGZTcWtDZG9qSHlSZ3RySlREL2liZ3VCSzNjdEowU1VJaGlMeGI1bWl1?=
 =?utf-8?B?Y1k3OE9KRmlXYjlad0hZR3Jkc2hWQVlCMzVtQiswQStGbHRNeEVxa0Qyc2xn?=
 =?utf-8?B?WmRSRGppcXdqb2d3V3E0S2NvZVMrOHU5QlFqYWlUcndCckp0NzBMTUF0NjZY?=
 =?utf-8?B?NjVGVFNsZEhicGpCRkFMb0VBeW52endWOXVMRE9FUXpxOXNzRE1RTGxlZ1Vt?=
 =?utf-8?B?Yzc2Z3F3WTVKN29HeDk4WFZQMWlEOWVRZkJ6cUhzOHQ0SzAzbkcwd0M1S0ZU?=
 =?utf-8?B?blR4Yy9MV21FblZXeXdla0RpN0w1UUFkZE0wZDhCYkFNWWpOSlhzQTl4aWFk?=
 =?utf-8?B?R2VEVUJ6TVJ5NjZQQmd6cjBhRG9Wb1VaR0FJcmlCMXhIcVNCWHNrUHZwN3dr?=
 =?utf-8?B?QjNrbU8wdlFrc2ZMczh3a0NYSGtoZFV1VysvWlpXMGJyYVNNdFM0MStjU1lw?=
 =?utf-8?B?V0x0TTRoaGw0R0ZKakVLakhUSFgwR1UvcXA5RlIrcEQvUU9OSVdyeWdGODhE?=
 =?utf-8?B?U2ZNOGRBOHhIeHRPRHJESFF0ZGZZd2MzNFV2R0tHNk43MVdVR3RRZU9pNmgz?=
 =?utf-8?B?K21CKzdLMi96Y2pvSU9qSk5ZQ0hsa3l0K3liNUNXM1N3S1JrK0tIb1JLRFFt?=
 =?utf-8?B?ZUdWVWlmUzRpZXRNcUZBVlNEOFhtWi91YVNMRmdPQzRvdFpwL1JVT2MrYmNJ?=
 =?utf-8?B?cnBiVW5LT1E1SFczRTU2WjB5VFllQnQyTW1vaEdGbldQZThiMWtQZENpSkh5?=
 =?utf-8?B?WVl2T2dZSXhydU1PYjhITFJrbWh3TjVWeXlKR09zM1lvYXQ3WUMxaG43K3JB?=
 =?utf-8?B?eWM4QjJ6YVI2UTlCREVCVC9iMmFaVGQycHJ3RWpuc0dDczZKNm5QMitFK05C?=
 =?utf-8?B?QytmS00rU093MVRjM2dMTGY5MHl6ay9wd3Qwb0RMdmRHZFlmU2FRM2VnK0h3?=
 =?utf-8?B?c0dkMXEzemQ0R0Zad0JYaGVTNjVYS0twVUg3bkVYOS9ab3BHTzByNHJrZExR?=
 =?utf-8?B?RXgwN1lleW5hVzhQWGhVVkRvakk1ZW81dVhUNUh4ZGtCZ2hzL05zVTZxRGl4?=
 =?utf-8?B?U2lVUzN3U2dJa1lMTXk1STZmMmxsK1VHNG85am9DMmhoREdGYmNHV3BycWZm?=
 =?utf-8?B?bk9ka24vdkFHaytOWUo5SjZuU1JRNDJDR05NNkVhbVJXL0hURjRuVGszQ1Zh?=
 =?utf-8?B?eDN2VUZtWi9RblA0bWhMWXR2ZlhxSU94YTZ2RlUwMnczSVJnb2E2YTVDbVJJ?=
 =?utf-8?B?cEsvYzY2VmFqQ2N2T203ZFoxaXVKYVdUcDVXazIrUUFQNzJraHZueWhkT0M1?=
 =?utf-8?B?U0gxYmo5c1czWW9vbk85am1rVzNnRmlYSEVTS0JGWC9mWmpHKzBoNHBiNmt1?=
 =?utf-8?B?VFF2WFhUWHJuOUpHaml0NEFWRWMrdHJxWG5QYU96VkVEak1uaFBFbU8zRk1m?=
 =?utf-8?Q?CHGbTHZTG5xXUa1DoiO50vyn/NTM7s=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(7416014)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	AJw1Q91eka3NjJEbVeU09X/K80c5xySkPtLhmHb3rWLzvoIcl/3bAf1b+Bkb04AZGUVxeJ60W2IamGlGwdmxLJ84UYI4Ls1pHrq8jDg6qoqM98Ws/Z5zCie/JyICd/BmHrP0WT5qMFbrz5sv55MDF6+k2Q5hHlJA2SDoaV/CtH+mvsr8LhbIsqDT/e2PzLDHxaZCaG136TpYdP/QSkCN3RlxdxBEkSjkJBquGckzjRBDdNcemcW0FYQeBicHuOWVuth/wM2pxaXD+bf4sRQSEaRvF+b62ER1kiyPTLTEwCVE5XAEmsa4l3nNgYJf074Ldr4sL5NILy+g05HLAzIWf84T8ZL3fWvr8GnaNtFZfpEtjTRnlKu5FAT8rA72kaLleEqwBFkIyMcmIA1T6UN4XtEux4FWQJXjYx7vMXS/T69DRrEVWD5rv35woQmPqAoIculpbwZIIrAgFTfhulSw5TLtIeTIRMaDRU2QKt/sTiiDIdVGhju3CKzDZt7sVW8IOvVXxIowkJf8Jgdo1AAWLBYv5eafRrt60lUfmM2BcnoTKGEL7T0ZSiY2CTteL0l2m60YFE0wMYOGkyGIr0WNOp4BGAh2TZQEKBqhnKJUxydtBPT7l//FNxis9PnKjFmnn0OVuPAiG/DQI75KiiMovA==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2025 14:51:24.6292
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ddf0ce40-a230-4587-cf37-08dd3bbd68a8
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CEB.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR19MB7975
X-BESS-ID: 1737643888-111748-13462-6474-1
X-BESS-VER: 2019.1_20250122.1822
X-BESS-Apparent-Source-IP: 104.47.58.168
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoaWBhZAVgZQMC3RLC3R2MjUJD
	XV0MDY3NDA0sI4xcgi1dLE3CI1OTlNqTYWAFTeCbBBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.262002 [from 
	cloudscan21-233.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

These functions are also needed by fuse-over-io-uring.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/fuse/dev.c        | 5 +++--
 fs/fuse/fuse_dev_i.h | 5 +++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 1c21e491e891196c77c7f6135cdc2aece785d399..ecf2f805f456222fda02598397beba41fc356460 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -237,7 +237,8 @@ __releases(fiq->lock)
 	spin_unlock(&fiq->lock);
 }
 
-static void fuse_dev_queue_forget(struct fuse_iqueue *fiq, struct fuse_forget_link *forget)
+void fuse_dev_queue_forget(struct fuse_iqueue *fiq,
+			   struct fuse_forget_link *forget)
 {
 	spin_lock(&fiq->lock);
 	if (fiq->connected) {
@@ -250,7 +251,7 @@ static void fuse_dev_queue_forget(struct fuse_iqueue *fiq, struct fuse_forget_li
 	}
 }
 
-static void fuse_dev_queue_interrupt(struct fuse_iqueue *fiq, struct fuse_req *req)
+void fuse_dev_queue_interrupt(struct fuse_iqueue *fiq, struct fuse_req *req)
 {
 	spin_lock(&fiq->lock);
 	if (list_empty(&req->intr_entry)) {
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index b64ab84cbc0d5189882b043aa564934135cef756..3b2bfe1248d3573abe3b144a6d4bf6a502f56a40 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -16,6 +16,8 @@ struct fuse_arg;
 struct fuse_args;
 struct fuse_pqueue;
 struct fuse_req;
+struct fuse_iqueue;
+struct fuse_forget_link;
 
 struct fuse_copy_state {
 	int write;
@@ -56,6 +58,9 @@ int fuse_copy_args(struct fuse_copy_state *cs, unsigned int numargs,
 		   int zeroing);
 int fuse_copy_out_args(struct fuse_copy_state *cs, struct fuse_args *args,
 		       unsigned int nbytes);
+void fuse_dev_queue_forget(struct fuse_iqueue *fiq,
+			   struct fuse_forget_link *forget);
+void fuse_dev_queue_interrupt(struct fuse_iqueue *fiq, struct fuse_req *req);
 
 #endif
 

-- 
2.43.0


