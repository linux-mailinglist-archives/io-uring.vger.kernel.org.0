Return-Path: <io-uring+bounces-4549-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 97A189C0D0F
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 18:37:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 28DA71F24167
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 17:37:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E917C21643F;
	Thu,  7 Nov 2024 17:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="P+nmEc0z"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF2B215037
	for <io-uring@vger.kernel.org>; Thu,  7 Nov 2024 17:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731001064; cv=fail; b=nOhUGKk+kqZEyKsWmBQQ7wGZPZzwKmnM0FeP2E2tmAqJXBFozulwjNf9lO8VGUbQazSwXzblECBP3Au74ARLYs8VvoAjtffCKt4HUqcGeCIB4L0kV7EHEGYlZlBxnSUckeSoWPLJhxUrp+W7CWzpH7kTL/PA0RSnl9nrBbSxq5k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731001064; c=relaxed/simple;
	bh=qPjPlv+ALLWi2d1RcybZcXQ4moZV8H3KjAxZ8jqYrfY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=p09yEnauGEeRIi0n8hDzZRfWbpWTK7MCytSzyCrjPtNVkNrVDjS5pxrxtXYsXPX4ZpAlOc5cBLWroiXBAkD/q3cfIEPBqrdaI3OVdm6Zb823nxq0u6E6B8x2XBYmNn4Ms3Pbk3hwB+4BBNE21Zc91ps/ekJEhvwjmzyFm2/FzzA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=P+nmEc0z; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2040.outbound.protection.outlook.com [104.47.70.40]) by mx-outbound42-219.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 07 Nov 2024 17:37:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qwuh0Swx/dkPN12MApAESsP40t/UL/n8Bbts2ur9eLo3RshZnIT92QJgWXwShP7mFHHf+iBLd7h/ZxeU7vDcZB2sv5DSd1Gm8NNN+5OOqw2RMiAQIvazdZQMnXIN6/Zed601uXDyArCK/W4B+QTuBo7M2Z/KBq3ethDsbglU4voJYNo/wtZG/0QpQehV0uITiFUAFqBYLGONtGm3HK/kuVrhvpm1xQJu0kfIn6RK6w7HCwbd/KdUhAzwbgIGhlweWy7KnVdHT69UmsiNm+HxZCJ6tvsZUZLVuZeNjZx2X68uJGnxSPjjM61BUYzCnDHIxDnJ4tJcau9pDC1Ilj7Ovg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UJbGYdfcKxrisStMC23eIxi28Iz9jbW7IhfhfVAUNR0=;
 b=pdcDwXRCUyfKARotHqRJ6DzE2yvs0jxzD8HZupxAwAfZUYPvfK3YNARdNE1MRWZozgsTzaFreiPhfIA52ZEgvkEMeaoklmEJGrHWG0TaVHFrNyWaeJx/1pgdG0ZCTaFR10SQh/JxnHNUyn9s20PEN8L7MqgbIUe3OctpxzFyMQFkrV1NPkYWb0+6iWUtWlYlYMgL785O8IDvrSDUJzqnR05wLfTvrd1GSk6OyDi3sn0pLysFPUfqIrifdGhPwteVRFLPtYqUSblQghtW64RnrdJEbquF2aGVlhZZOOyQcmAPDB4BwRbwdY9vueQKQY2ZJ6OqQ2qVSqyu9W80tipctg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UJbGYdfcKxrisStMC23eIxi28Iz9jbW7IhfhfVAUNR0=;
 b=P+nmEc0zthInBnq80v5xg4sEbZjgPVsi6dEadLoHNJeL6WDNYcQmhEZs+nZ2zpDHBKstwz6xAhD/KGrm9myQzyDR9PGVvfOzh81uB4uHXo7K/rUUqYxJceSk3xLWkDUiYvuyxWpLA/HwDCv03/k6ejniPwJcI7s7xFYUxO/RMb0=
Received: from MW4PR03CA0267.namprd03.prod.outlook.com (2603:10b6:303:b4::32)
 by SN7PR19MB4799.namprd19.prod.outlook.com (2603:10b6:806:f6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.21; Thu, 7 Nov
 2024 17:04:26 +0000
Received: from SJ5PEPF000001CC.namprd05.prod.outlook.com
 (2603:10b6:303:b4:cafe::39) by MW4PR03CA0267.outlook.office365.com
 (2603:10b6:303:b4::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19 via Frontend
 Transport; Thu, 7 Nov 2024 17:04:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SJ5PEPF000001CC.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8137.17
 via Frontend Transport; Thu, 7 Nov 2024 17:04:25 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id D6436C6;
	Thu,  7 Nov 2024 17:04:24 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Thu, 07 Nov 2024 18:03:59 +0100
Subject: [PATCH RFC v5 15/16] fuse: {io-uring} Prevent mount point hang on
 fuse-server termination
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241107-fuse-uring-for-6-10-rfc4-v5-15-e8660a991499@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730999049; l=5408;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=qPjPlv+ALLWi2d1RcybZcXQ4moZV8H3KjAxZ8jqYrfY=;
 b=wdUEGYmxhJbr1XHg+aTQAMiYMsb7Qm7rbH28VP+TEgewB2R/fi2RgwQBAwAI1ax7QlayzNO1X
 GrsA787zCSOAiJCeJ6PKCa30Wm3QRy6GiOOvqpX2hA2aMzhNNH7ZMG9
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CC:EE_|SN7PR19MB4799:EE_
X-MS-Office365-Filtering-Correlation-Id: e9f1c937-b05d-406e-e137-08dcff4e3bec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SG5qMGk1M2JjR1Y1OUFsMlhvQ3gzMnZPNzlxYWR2MExwLzQ3UzNzZjhRMDhx?=
 =?utf-8?B?N0lmN2tNZzdVeFlIVk95dTRNQWRUQlN6dWowbmpOUlNrTzNSMXRuUDNyNWJJ?=
 =?utf-8?B?bVRYcnREcDlRWVcyd3pVLy9KYzh5dXlYeHVMeUJMYjVZcnNMTFpPb3NRQlRn?=
 =?utf-8?B?NU9sMzR5UkZPeW95OWxodFBrZHBYVEFJQkJmTjEzS21FU21GVExBa2I1ckVO?=
 =?utf-8?B?Zm9BYU93WVowRzFTb3lnQzNqS0dYb3NaWEo4eHA0Q3N0dHA4MytNK1Zhckx2?=
 =?utf-8?B?eTh6Mjd6SWZvdVU1UUVIb0ltRXhYL3RwYjVJRkh3K2VGUUovRHBsMXNTNnVN?=
 =?utf-8?B?b3k0VnhocmlwYUMvcGRhQ2gvTDdOVWZ5UmRlK3E5TG1EVE0ydWR0RnBhdTJO?=
 =?utf-8?B?SEgzOUkvb2JWZ00wdjZJQUFYNi95WGt0b1JLOHhqZmNuazlqY0FKYThPVDBs?=
 =?utf-8?B?NFdKMFdNTDVLZ2dCY0lVUlBGcWVONEhtQytrRFZRL291N1RxR0E0a29IMWZx?=
 =?utf-8?B?Ty9Udlk4d1pWUDZRUTJYMUQzMWQvaGRHQ1VSTFNuWENoRTJGQW1KSUZub21V?=
 =?utf-8?B?SzVrcDVDMDMyWWFYNlk3ZXR0TmdqZExIdWlvR2IxTHB6UmhoV3U5bjVkODY0?=
 =?utf-8?B?ODViQWNISzJaaGRKRktLK2hYZW0zVFIzMm44bGFVZGo1ZlhGLzlDQndxZ1dK?=
 =?utf-8?B?SG8rQXBmWi9uZjdLQS9vMjhMajJrUzlXbzJyQkJyYVFLUkVrY3RUNUxvY0Vv?=
 =?utf-8?B?RmZuV1hxZjYvc21VWGNTTEVDdzZ2a3hSNVYxSWNXTVgrTFAyR2ZhcG5BMkhl?=
 =?utf-8?B?V3czQTgyTHZkSFJTTHJ2aGJnQmtYbDZqZ2Q4c3BDN01ySnZRaXRSMi83VVBY?=
 =?utf-8?B?bXhPODZaWnhReDdhUjMwVmRRMXcyN2k2YjN3NUFRR0RxdGRKSHdZc0luaGxq?=
 =?utf-8?B?NDN2T0NZeCtrWkk4WmRBM0FGWVpPRWpaN2RnRFVVd2dXQWd4VmpkbVdpSC8z?=
 =?utf-8?B?cWVYOGdpSnZZT09kSnpTTDJsZW1aQ1hsTHhZSU5pOEYzRDZnWmc4RHpxRVBt?=
 =?utf-8?B?U0hxVTRDV2hTbGdlcVNrK3NUd1NkSnB3OEFkZ3Y2OE5CMmYwS2dxaytISzRD?=
 =?utf-8?B?Q1ZMQStYNVQrQ1VrZnhDTm9GN1d0ZWptS0dud1QzUUZLVlUvU3JuVDQzK2Uv?=
 =?utf-8?B?eEFMRmRqd0tCNGNldWlWMzlFUmZWMHQ3QWFJZ3dBR1laWnR4K0szSUVWRGZL?=
 =?utf-8?B?Y3ZIVjRWSmIraFBlSjBZY2pBNGltbnRuQjlvYVNCT3hNUXl5Z1F4S1dTOWhz?=
 =?utf-8?B?Y1pHMEZOSUlVcHVjU0tmMHZRWXdQZW5ETkdBdTA1bTNMY0NadUVadjBUeVhz?=
 =?utf-8?B?ZTcyUkVWcE5la0ZqL0MxVHNKOXBWOFprTm9mREF0aEFkSG9GWDVpNTNjNkVo?=
 =?utf-8?B?Mnl4RmtNaTduS0JuUHJRY1pHSGhUcGdRcE1wYjVqMnpLUFRBOWdwRkFvMGhW?=
 =?utf-8?B?dHVNUGF0a3g3Y3l3Y3Vzc1RkVTJrOHk0OWZRVC9ZdjhrVU9KN0dKNGdkN2sr?=
 =?utf-8?B?dHdOSnNaVUtLTjdhTiszbXNsZzRlZkg0REw1R3JiSXN1UWJxYU1mVkxnVUZr?=
 =?utf-8?B?RGcvUmI5WWlrWlc3YkdIdUJQaEhGTDluN3hqWWxuakR2anBTVlM4cjFUaTZH?=
 =?utf-8?B?VUNPMGc4WmxsT01SSi95Q21jd1hORDNxOGNOVlV4NkVEN2hJVVY0V2xraGhK?=
 =?utf-8?B?dkhySk9MaDUzS1NPaDBpM2hVemlnNkF3QjdWUDBhOFBLNDZjUDZpM2UrYUdm?=
 =?utf-8?B?dGVNd3h5ckd6d0NnUGp3b0s1S0krTDB4NGVEZ0R5Y2svSG1ad3BCT2l0VW5s?=
 =?utf-8?B?WHJwOHVtU2sxSUNXQkhWL1RvQi9EVUhMa2VVTitLcFpwRWc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(7416014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CmRkf9+x7Cbw0DvztJ7V81IBo+3jhTGItwcDM2x23bmvUpP8/dFbhKPbIVSMHWQdHR066cUrvFV1N7P9wOv9NC7o+Zes5QGE+tMNlBjpAM8nhDZMWqr6aO6NCXxsfKKnTLcZK3wmIOOwok9jSOoUCD71S2EyxHLAYr6AR4MN9kflz/anwAkE6/b/feMw/06hlJuFGjo8G7qXKwfIq/yV9G6c7LRr65cZ/UmIzSpXf8vpDs540YSF/3dA5duwHHaC8975/1nRhq67OfjGfeU8vhchDOJhLOOgCt3qwtlR1Z1RKzEgYUZBwJu9VQD462IrhMnRokJKw304LNIZAjfNzbq+lQlLtR4p+T4aPs2MpiWPsdOh3e1THxOxeCcwtGWwU19faeJpxTnBkaZ6yqivfydgNg/cttDvUkAohlTyQOXvBbpezO8FNu+vuCRzSg/eoglZldecMmslRUT5xPzis07fRMAdomNVrpo6qSOBhuI/AZqdKBUleCHYV03cKsICvShOIoKeTcZZgPPG3/8DZM8FIEIy/tb5zZZJdeNV+aLjGwH6zNCmFlzTIHIj1I8VXKJEpZfKdizGZaCOhrQ3nj3Enwn0FwontUhWC1fjtFaAWbUBfHMxqPFUKreddgj/5LZGf6yBGCuF4CfWOacdPA==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 17:04:25.6429
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e9f1c937-b05d-406e-e137-08dcff4e3bec
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR19MB4799
X-OriginatorOrg: ddn.com
X-BESS-ID: 1731001061-110971-12656-9425-1
X-BESS-VER: 2019.1_20241029.2310
X-BESS-Apparent-Source-IP: 104.47.70.40
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVqZGJoZAVgZQ0CA10cQ8Mc0o2d
	zMLMXCJM0ixdjAwNgkzcjQNNXE1NhQqTYWAB8s6L9BAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260269 [from 
	cloudscan8-29.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND, BSF_SC0_MISMATCH_TO
X-BESS-BRTS-Status:1

When the fuse-server terminates while the fuse-client or kernel
still has queued URING_CMDs, these commands retain references
to the struct file used by the fuse connection. This prevents
fuse_dev_release() from being invoked, resulting in a hung mount
point.

This patch addresses the issue by making queued URING_CMDs
cancelable, allowing fuse_dev_release() to proceed as expected
and preventing the mount point from hanging.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev_uring.c | 76 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 70 insertions(+), 6 deletions(-)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 6af515458695ccb2e32cc8c62c45471e6710c15f..b465da41c42c47eaf69f09bab1423061bc8fcc68 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -23,6 +23,7 @@ MODULE_PARM_DESC(enable_uring,
 
 struct fuse_uring_cmd_pdu {
 	struct fuse_ring_ent *ring_ent;
+	struct fuse_ring_queue *queue;
 };
 
 /*
@@ -382,6 +383,61 @@ void fuse_uring_stop_queues(struct fuse_ring *ring)
 	}
 }
 
+/*
+ * Handle IO_URING_F_CANCEL, typically should come on daemon termination
+ */
+static void fuse_uring_cancel(struct io_uring_cmd *cmd,
+			      unsigned int issue_flags, struct fuse_conn *fc)
+{
+	struct fuse_uring_cmd_pdu *pdu = (struct fuse_uring_cmd_pdu *)cmd->pdu;
+	struct fuse_ring_queue *queue = pdu->queue;
+	struct fuse_ring_ent *ent;
+	bool found = false;
+	bool need_cmd_done = false;
+
+	spin_lock(&queue->lock);
+
+	/* XXX: This is cumbersome for large queues. */
+	list_for_each_entry(ent, &queue->ent_avail_queue, list) {
+		if (pdu->ring_ent == ent) {
+			found = true;
+			break;
+		}
+	}
+
+	if (!found) {
+		pr_info("qid=%d Did not find ent=%p", queue->qid, ent);
+		spin_unlock(&queue->lock);
+		return;
+	}
+
+	if (ent->state == FRRS_WAIT) {
+		ent->state = FRRS_USERSPACE;
+		list_move(&ent->list, &queue->ent_in_userspace);
+		need_cmd_done = true;
+	}
+	spin_unlock(&queue->lock);
+
+	if (need_cmd_done)
+		io_uring_cmd_done(cmd, -ENOTCONN, 0, issue_flags);
+
+	/*
+	 * releasing the last entry should trigger fuse_dev_release() if
+	 * the daemon was terminated
+	 */
+}
+
+static void fuse_uring_prepare_cancel(struct io_uring_cmd *cmd, int issue_flags,
+				      struct fuse_ring_ent *ring_ent)
+{
+	struct fuse_uring_cmd_pdu *pdu = (struct fuse_uring_cmd_pdu *)cmd->pdu;
+
+	pdu->ring_ent = ring_ent;
+	pdu->queue = ring_ent->queue;
+
+	io_uring_cmd_mark_cancelable(cmd, issue_flags);
+}
+
 /*
  * Checks for errors and stores it into the request
  */
@@ -606,7 +662,8 @@ static int fuse_uring_send_next_to_ring(struct fuse_ring_ent *ring_ent)
  * Put a ring request onto hold, it is no longer used for now.
  */
 static void fuse_uring_ent_avail(struct fuse_ring_ent *ring_ent,
-				 struct fuse_ring_queue *queue)
+				 struct fuse_ring_queue *queue,
+				 unsigned int issue_flags)
 	__must_hold(&queue->lock)
 {
 	struct fuse_ring *ring = queue->ring;
@@ -626,6 +683,7 @@ static void fuse_uring_ent_avail(struct fuse_ring_ent *ring_ent,
 	list_move(&ring_ent->list, &queue->ent_avail_queue);
 
 	ring_ent->state = FRRS_WAIT;
+	fuse_uring_prepare_cancel(ring_ent->cmd, issue_flags, ring_ent);
 }
 
 /* Used to find the request on SQE commit */
@@ -729,7 +787,8 @@ static void fuse_uring_commit(struct fuse_ring_ent *ring_ent,
  * Get the next fuse req and send it
  */
 static void fuse_uring_next_fuse_req(struct fuse_ring_ent *ring_ent,
-				    struct fuse_ring_queue *queue)
+				    struct fuse_ring_queue *queue,
+				    unsigned int issue_flags)
 {
 	int has_next, err;
 	int prev_state = ring_ent->state;
@@ -738,7 +797,7 @@ static void fuse_uring_next_fuse_req(struct fuse_ring_ent *ring_ent,
 		spin_lock(&queue->lock);
 		has_next = fuse_uring_ent_assign_req(ring_ent);
 		if (!has_next) {
-			fuse_uring_ent_avail(ring_ent, queue);
+			fuse_uring_ent_avail(ring_ent, queue, issue_flags);
 			spin_unlock(&queue->lock);
 			break; /* no request left */
 		}
@@ -813,7 +872,7 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
 	 * and fetching is done in one step vs legacy fuse, which has separated
 	 * read (fetch request) and write (commit result).
 	 */
-	fuse_uring_next_fuse_req(ring_ent, queue);
+	fuse_uring_next_fuse_req(ring_ent, queue, issue_flags);
 	return 0;
 }
 
@@ -853,7 +912,7 @@ static void _fuse_uring_fetch(struct fuse_ring_ent *ring_ent,
 	struct fuse_ring *ring = queue->ring;
 
 	spin_lock(&queue->lock);
-	fuse_uring_ent_avail(ring_ent, queue);
+	fuse_uring_ent_avail(ring_ent, queue, issue_flags);
 	ring_ent->cmd = cmd;
 	spin_unlock(&queue->lock);
 
@@ -1021,6 +1080,11 @@ int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	if (fc->aborted)
 		goto out;
 
+	if ((unlikely(issue_flags & IO_URING_F_CANCEL))) {
+		fuse_uring_cancel(cmd, issue_flags, fc);
+		return 0;
+	}
+
 	switch (cmd_op) {
 	case FUSE_URING_REQ_FETCH:
 		err = fuse_uring_fetch(cmd, issue_flags, fc);
@@ -1080,7 +1144,7 @@ fuse_uring_send_req_in_task(struct io_uring_cmd *cmd,
 
 	return;
 err:
-	fuse_uring_next_fuse_req(ring_ent, queue);
+	fuse_uring_next_fuse_req(ring_ent, queue, issue_flags);
 }
 
 /* queue a fuse request and send it if a ring entry is available */

-- 
2.43.0


