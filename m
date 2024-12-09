Return-Path: <io-uring+bounces-5320-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AF229E99A7
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 15:58:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA9662840F3
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 14:58:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E900E1BEF9E;
	Mon,  9 Dec 2024 14:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="Ph5F3w4Y"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04E51BEF9B;
	Mon,  9 Dec 2024 14:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733756221; cv=fail; b=PFzkJxx1hUTs0qd6tCCVrfDQZrMdBfZ5ua7nh5gwv0gcWMW8NomN8oQ0cXDpgMx+4Ft4urLAPdn7i2DyACtfTuYlMUVnW9TptR2rcmGKYOhTW2XrvcBny1ZAQb0ueiQ8hAjioAYR58WpKzJmbAi7UA/PsfA+waL+P0amr97Lq/U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733756221; c=relaxed/simple;
	bh=bH7AXbAgM9O8WxYv19f8qiXoKWtYqGZmQxByq03RmGI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FP/jyKAsdrHzOXIm9BNEgS/Xe01X52/JMSHe9SvA/rQnLBChfHK09W9VCBKFo3yV29N/ueuLeBij2dza5jQtVOxGU5evjrBEAUCV9ekGHVJaUVYK/3gY9nkZrTKoaGq9AMBNO1WbhaZ4AdS2CEY7nBEeyGtNPRrd0rgpZOZY7g8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=Ph5F3w4Y; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2049.outbound.protection.outlook.com [104.47.56.49]) by mx-outbound8-209.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 09 Dec 2024 14:56:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CWPMvzCdLvmYNgVeZRTapfLkkOPT6joj4sd4Jx1FnZ5JafoMUy+qaHaylqJ7N9yR+IDySPQoffc93Yz05c+QSbw10gMhqpEugyyUVMOPwTdz+tIvrKq+wGUkiH7KLOXBwiQKvfS9QG6NPr7R2S3+elx6w5SJgMN5AiW0ga+Tej0Aphm0q2txP26DY6x8rk1eLur1weMx9NC7QOWx9dgTudAJDAXuOk+6oLsaQciHm7fe1xZhtFbfzBlible1XUEXK5P8U2j1peAJD2PXT1s2Pb2GQjNkDudNXjseEg9TeIjv1hBhSrKl8euaK2aozjGcBrVl4ENpXZ4vWBSQ3bxCRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jJz3+THbXTIKY43167MS2efTc2Qn1MdwFPpXT/QQ29o=;
 b=O9kwO2xl5Q6ASmQchr2Eamt53GyBEkjFkjMCaC/hCopQqw/8E2Ng/GkVpxQQFepro8uaGoUJ6Q1h06Xzy6uW15+e1kOI3RvRPS6uvYPiTI+vR3gIiRJO28DUd31rUvYK2hGVmouNQpeYO4bOXffZZgBC0HK8GN2OKsNvOX9aRkOExnapYJRsz5aah0AZ1fr6d7W67G6JtmqTwfDoRHiaqZrLGyCsaebwh4Xbw8EIE8Q1gHisW4jo35r73u+9y+x/UedZgAYgCA77Mpge8e85A3PP/loM2ryjnCoIMjrEn9I9Cbltk5OixhgxsF2MXoZ4CEvi41j1k2u7X5nQniIGMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jJz3+THbXTIKY43167MS2efTc2Qn1MdwFPpXT/QQ29o=;
 b=Ph5F3w4YIXJhyZtLs+TKe7nofORc6jxCfPNmWXrAzNFCMmvgbqD2KwMwT5YJdkExAZBtFoLeMu7p3EJdhQ3+Ts/xl5xS/KRV/j30NsQmlyM4K3Yc6mU1fG/SW/A6WkA+Q0YwSywdqP2rMETt+uiJQHs8TVlJQWhk2s0ObMRediM=
Received: from PH0PR07CA0025.namprd07.prod.outlook.com (2603:10b6:510:5::30)
 by IA1PR19MB7711.namprd19.prod.outlook.com (2603:10b6:208:3d9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.18; Mon, 9 Dec
 2024 14:56:44 +0000
Received: from MWH0EPF000A6730.namprd04.prod.outlook.com
 (2603:10b6:510:5:cafe::f6) by PH0PR07CA0025.outlook.office365.com
 (2603:10b6:510:5::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.13 via Frontend Transport; Mon,
 9 Dec 2024 14:56:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 MWH0EPF000A6730.mail.protection.outlook.com (10.167.249.22) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.7
 via Frontend Transport; Mon, 9 Dec 2024 14:56:43 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id AD10855;
	Mon,  9 Dec 2024 14:56:42 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Mon, 09 Dec 2024 15:56:25 +0100
Subject: [PATCH v8 03/16] fuse: Move request bits
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241209-fuse-uring-for-6-10-rfc4-v8-3-d9f9f2642be3@ddn.com>
References: <20241209-fuse-uring-for-6-10-rfc4-v8-0-d9f9f2642be3@ddn.com>
In-Reply-To: <20241209-fuse-uring-for-6-10-rfc4-v8-0-d9f9f2642be3@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1733756199; l=1370;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=bH7AXbAgM9O8WxYv19f8qiXoKWtYqGZmQxByq03RmGI=;
 b=F7xuOfHmwR+qLdrcRBAoUZweAVgpFW1TMCRn7IoI0fg9iftMrlThMQWU/7YmNQc4Go9B8SpGO
 gmk+pXGyVLdCZRZUP7Twj5K9BP02WMKiiVP6muZr+0slV7Z5YPKzFyU
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6730:EE_|IA1PR19MB7711:EE_
X-MS-Office365-Filtering-Correlation-Id: 562dd1df-65c0-4709-5817-08dd1861b21b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ai9oM1IvWTFRTDBoNGVHYUpqZG9mRHF1K1BvQ0N3T2dKM0d1Qk9FOHpCWGFs?=
 =?utf-8?B?cGluQkJIYVdUMWZVTEViUmFpc3pScnUweEtlNTN5c0xLeWhtT2pHOWVIVGtN?=
 =?utf-8?B?MzRISk81Uk5ieU40azNFTGxrd3NqRkcrN3E3eUp5TGRKcTBxZlpSL1pXQ3V3?=
 =?utf-8?B?cDdxWkxtNU4wVzdDUFJ0MVphc2UrNnpVdWJ0VHl3Ulpja2p1Rm9tbjFYMW1w?=
 =?utf-8?B?ZWNBSk1nV2lqTnRFdGFqZnNqeTM3R0NET2QvTzJTQVlDQ1BpNWdPQ09qVVcy?=
 =?utf-8?B?NU9jV2tRYWZlWU5mMzUxWWxmTTI5Rjg4TEFoNldGV1BuOTlteXZwdjZnQ0I0?=
 =?utf-8?B?Wng3eDlCdmJRNURYbWtiUkNORUNqb3gzcUFVRklVUlROUnBTMGM1NWszSzha?=
 =?utf-8?B?cTFCUVBiMVNYK2l4dHdjdFdhRFBUTmEyMEpORzh3dW12Wll2c2kxcWRONjM5?=
 =?utf-8?B?aEkyOE40YXlkK3daK29DU1hoWkk3ZDNERkpJSERadldLYmNWV20vbUo3S3Rs?=
 =?utf-8?B?OHExYk42Z2pJZHJRL3h0S3VHK25kT0tZWTNkU1c1WGhhb3F6VmlVKzJTNHNL?=
 =?utf-8?B?VENxQlhldGJLRFFzMTU3VFZPcldyWFQrdG5QYW9XQ3AzWkxxOEZyblRBczdy?=
 =?utf-8?B?Ulk3bGF5RUE3ekJuNHBPdDBPZHV3UTVXWGF3aHF3UjFTVGtXVHhDRmJ3ME91?=
 =?utf-8?B?UnZvd2k4VmV5OHE2TE9ObUdFUnV0NDBhZUFzeUM2VlJkZ2p1aVkzdWdPQlUw?=
 =?utf-8?B?MVppeFVKY0RLNm02aFovYXBuenRxcEtpN0dJS1dTUFFPb1dGVkhuNWxUUkxn?=
 =?utf-8?B?eS9nMUZOazROUEgrcEZ4K1pYMkFuNSswNzRCQ2hkT051QVZ5NVZiUU1iYlg4?=
 =?utf-8?B?QWR3K2FKZnFPZGFmL0Y3bDB6Tks4THg1V2l0SElMSlVkODZ1a0RrOTBNK2xL?=
 =?utf-8?B?QTlhU1EvdjY1eklYbkZMQ0V0UGJNa1VubVNHREVzK0NVRUVWNzdkdFd6ZXdK?=
 =?utf-8?B?T09Ha3JqTE56Tzcxbit3b3A4bmRYZXhHbktpY0Q5bG40bENlRTRDVUdLbjRO?=
 =?utf-8?B?VGRSYjI4RUpHV0dsSGJaMWpOQXdUN0huc3J3dHJYaFBtZG91NGc4OEkvYzI3?=
 =?utf-8?B?aFZqNHYyeFFQM1M4RDFoanU1eFBxdXFLd2Q3NExTYVAwVjVwai9LelBLK1Nn?=
 =?utf-8?B?OURlTU5HdGJkRy82UHZ0Tnk0dVVwOW8rOFEySVRESC8vTm94d0hTZHkzZEhQ?=
 =?utf-8?B?SjFSajZCN0FDN0RMU3g4cWpvd0tyOC9zZTEza3h4Q3FsdFBtUVlHeDBZblA1?=
 =?utf-8?B?Z09qTlRiR1ZKNVV0OGdTSGFBNUoxWHdmYVNUVnorWmVCdnJEQWkwNlJDeGJI?=
 =?utf-8?B?VDlJdzdZVkZrKzRKSEl2VzdjL1NvdkZuY2t3dU83di9kbFlKSzd6dlJZd1Y1?=
 =?utf-8?B?VExtTWZyQnB3RE0wMXFXTGFZM2d4aFpLcXdYS0ZteDRQVTVJOHAvWWl2VnlI?=
 =?utf-8?B?L1pBeEE4eW5rTy95cTNjcit0OHQ2bEFMVFl3dC9kMVVLQytXY2VET2RtRU1D?=
 =?utf-8?B?aWdCamNXR2IwZDIra2NSQ0NDWTNNS0dubTY2MW1pUVBTdGhSUzBuaURkOVo0?=
 =?utf-8?B?cnpMbi96U3o5R01VbGg4OVZJS0t6dGlNcHQ0L2xVb0dwZUlqeDRIOEREd2hI?=
 =?utf-8?B?YXlQWnZJcXFPQnlEZWh0b25mOGU5VTIvWUlkbDUrbk5xTEV1RnFGL1I5NW05?=
 =?utf-8?B?WnhKK2FwRm1nZnJKa3JwdlU4cWtwc3dENnc2N2F4QnUxWlRmNWp1Nk01MUlJ?=
 =?utf-8?B?WTNTL2dmNnRuVWY0dzlrQTMrMVovTTlKVjZ4MVRZUkwwVWhDT3QxN25BZWVS?=
 =?utf-8?B?QWltU1FkUzBXUEVjcEc2OFg2WDlHOFdBdS9mZGtQUFA4ZGtDUmQyMXV6ZXhE?=
 =?utf-8?Q?pn3pNuqsn8ziXkpcXfL1tRaP6RpfeYRp?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qzLNEFVjFF8gFCiuqACK0eJEk9iMpPzo+BFfDDdybtDyBXcTFXXg26/UjnGvGMflRbkS+4MB9kM+BNG/L+gk1ShMxPHkl+2gf/uAYL9Rx1QTfGhMbVdZRCLACFbiH9yFdy6Ch1kMaidCzJTJHo1SCi1cP2I+uy0IpxV6RiUxfb1q2pbXz+QieIKG1xEFL3Kjx5J1jKgA2wCl+eljhk30MEjJy4PBrAKE870U9tx5S/uEFRezyJkJDsgnl0LUURS0tRyXZ1Q1Dj/33ZGhkb5+oAu5zsplJvmQifcUhJbHZPDZAeM663U3qtU7zpoFzfqO3GKrOx56hL82+iBi3ZcoOWng5mMIxYq/hSaYwZt7UJmYM0yVXzAd5H7lVRI6zs7x0OjUswuim24oXoFeK0KU8KshTZinKy+iLviilwTiItQ8JYhoRiEn1YvqvJ3fSbH0GG+bv3kv7jvnyPGY0QVvsl3dzSo0Oadaww81bU5JhDZi8uylpxHdh1tuYKknDIYHhQkXjIuk1jWgbo8Ji/oVpFtdbrDn+5HGwgPRlb4wD6hmGunFj5DRXvRpqQxppDIRp/vHNLzqfMH19SBriMWZts4BmsJQM1uTGgVmg1ZWmuLov/yKqCvIDMqV60zlPtfaOC7+EHtNDTV5wtXCAcd5VQ==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 14:56:43.4571
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 562dd1df-65c0-4709-5817-08dd1861b21b
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6730.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR19MB7711
X-BESS-ID: 1733756206-102257-13468-1819-1
X-BESS-VER: 2019.1_20241126.2220
X-BESS-Apparent-Source-IP: 104.47.56.49
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVobGRhZAVgZQ0DLFOMnAwiQ5Mc
	XMyNjIMsnEwjA5MTE1ydIgycLEKC1JqTYWAJk6n8ZBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260997 [from 
	cloudscan22-239.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

These are needed by fuse-over-io-uring.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/dev.c        | 4 ----
 fs/fuse/fuse_dev_i.h | 4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 3db3282bdac4613788ec8d6d29bfc56241086609..4f8825de9e05b9ffd291ac5bff747a10a70df0b4 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -29,10 +29,6 @@
 MODULE_ALIAS_MISCDEV(FUSE_MINOR);
 MODULE_ALIAS("devname:fuse");
 
-/* Ordinary requests have even IDs, while interrupts IDs are odd */
-#define FUSE_INT_REQ_BIT (1ULL << 0)
-#define FUSE_REQ_ID_STEP (1ULL << 1)
-
 static struct kmem_cache *fuse_req_cachep;
 
 static void fuse_request_init(struct fuse_mount *fm, struct fuse_req *req)
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index e7ea1b21c18204335c52406de5291f0c47d654f5..08a7e88e002773fcd18c25a229c7aa6450831401 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -8,6 +8,10 @@
 
 #include <linux/types.h>
 
+/* Ordinary requests have even IDs, while interrupts IDs are odd */
+#define FUSE_INT_REQ_BIT (1ULL << 0)
+#define FUSE_REQ_ID_STEP (1ULL << 1)
+
 static inline struct fuse_dev *fuse_get_dev(struct file *file)
 {
 	/*

-- 
2.43.0


