Return-Path: <io-uring+bounces-5080-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A0BB49DA8C8
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 14:42:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6123E28146C
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 13:42:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABF7F1FE45A;
	Wed, 27 Nov 2024 13:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="1sddP6XI"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABC61FDE02;
	Wed, 27 Nov 2024 13:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732714867; cv=fail; b=DmZABShw0L1vxsCnj+7HQJScO91qke7kY4/9/3iaucJSDzoffZnXAy8tzDWWpB5XRwnwrj/UkaCsGzfg/Z+E43JszeIsXXsXBEPvjXXB3xpKEM1KCsO9jLfGF4rXJRUlwonYOzOE1NotfRED1YSjtWytTj2J8dg8tDWBINCfIrY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732714867; c=relaxed/simple;
	bh=U0rOiOpbEi0wwx1eGkRe+gsNPTVSxtP4ER7cQV8xVR0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aY//IahNET9ap/Ryc8hwiRkcd6rOr46CMQDzmtVuy5ydOSu+qHzm1Rgjr795IZwZ5J+jRHXNA1n/liBYBHjmiNKSIi/fJiCTdYiPPdEjvbyYuJhCaao2exvb6/QlRrIz7ugjRyMSE/3JOaHjPovrlzQ31Nzk7HtDJIp+a9MZ4LY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=1sddP6XI; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169]) by mx-outbound41-168.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 27 Nov 2024 13:40:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q4TLABV+FYA8UooddxM4Ja9r1EV6Le1j36PYlv9XX2Fvs7AYDXccZiwBDOTtElhcVLfiN/hISrsxacCcLygOP5s1rNfXYNRsrCilds+svGPvm6TplGRduH3viaWFzyU4+HJbfvEEZkjLOrinm9gNs6fDrQr28oXfa9GqsZ9wE65gCsjwDDX2/INRxVq4dWhY5r6vzklS6QCY0OQqH6OPABt2J4y9S3DP97vwvrQT5cdyxXiq/TtmaqO1xdF4jdEEBW4C8MaTGo13AWMcyBEGyy1n3ar8Mx0V/BNG2avmqL+hNv1zTw8qpnDOuK3thFXkJj9VLR5dTZyaQ7oefe7vWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PQbxxKacmAonMd5Qo/sy8APS/T3tU1DF7yb6bfGdkPI=;
 b=Y+P8RwamyR0O0sPZLFPmcLrgccVph7VfzAzUCIxR5UFVE+D7JtE3zPD+LHfc5PF6WhE0diWgt6fW1+BmVbNy4i8lXpzq8IIXO9WhJRkzO7RKf3I7PxcTQREPzmzMqf2sYHCWFpYZBx3hPcjg/Yag6kCCVYczQui+ayuHVfinyzDYs9fPssgoS6SsCYR0iH7wJW//M3/66CgSmif6h4kuY2eZDsVsJD+acMkpX4vIVaR4vc5/SAsEDkGp72SteYZxUNZbud3CPsTK56TJn9FfD4t9170rMm36mOptBbQtzC/W7EgzmZQjm+PNMmQi48FZ0XwQXqGJalINU+5cHOFbzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PQbxxKacmAonMd5Qo/sy8APS/T3tU1DF7yb6bfGdkPI=;
 b=1sddP6XIRDyFVjN3cgh8DTAkyJ4DNqantP7EchU4NvvA53jDqdzMKpHp8gNjUhucKlgVK4yH2Wkq7ReGkZ8Lr83/F3iiR7y3JuyHNm1yD75uMDmgN22ICfb8WJdiOVKnz3TTtIVxs30zmZqvnLPDVC1rEZbzbOqGmihxKvn2Chg=
Received: from SA1P222CA0143.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c2::19)
 by SA1PR19MB7087.namprd19.prod.outlook.com (2603:10b6:806:2b8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.20; Wed, 27 Nov
 2024 13:40:54 +0000
Received: from SN1PEPF0002636D.namprd02.prod.outlook.com
 (2603:10b6:806:3c2:cafe::b0) by SA1P222CA0143.outlook.office365.com
 (2603:10b6:806:3c2::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.12 via Frontend Transport; Wed,
 27 Nov 2024 13:40:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SN1PEPF0002636D.mail.protection.outlook.com (10.167.241.138) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.12
 via Frontend Transport; Wed, 27 Nov 2024 13:40:54 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id D91BD2D;
	Wed, 27 Nov 2024 13:40:53 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Wed, 27 Nov 2024 14:40:32 +0100
Subject: [PATCH RFC v7 15/16] fuse: {io-uring} Prevent mount point hang on
 fuse-server termination
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241127-fuse-uring-for-6-10-rfc4-v7-15-934b3a69baca@ddn.com>
References: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com>
In-Reply-To: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1732714838; l=9835;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=U0rOiOpbEi0wwx1eGkRe+gsNPTVSxtP4ER7cQV8xVR0=;
 b=1lUu1tvxyj64PPeU5AGGWBimSyjEyOQxN9yS/kiIX+vduO1OG1/H2sjYYLa3JVjP1HFo77rPg
 m0lDo8l/wzEBd5fVxJ5bMi4JF5UD/p+Hao58I1sk94oHUUkstp+0NJc
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636D:EE_|SA1PR19MB7087:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ff30fcb-c93a-4f7f-575a-08dd0ee91dd5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eFVFRE5HVFk4eXZadEFrcHRsbUVBRGx6MllYejg1WHV3cmFPTHJXc1E2RFZj?=
 =?utf-8?B?MDU1K0VGRllJWEYrbmUzYkFLd2M2MkhFWnY4TXIrSnkvaFpaRTNvaGw5dmpr?=
 =?utf-8?B?cWdGUzVPczZxYlFNaWFQZGNBbDcyZjVCU21jMXREeHdsN292S0wrZCtMUmY4?=
 =?utf-8?B?U1VaN2VLaTVCZnZBZUp2TzlPSU5FcEhDQUFlUlpSd0VnbkRxTVBPTnVpY2Zx?=
 =?utf-8?B?L3BQOGRaMmZCQnRHU0xZWnF5cDRkYXF0NnJLUXlYdThiZWpJanZ4Z3cyRUFS?=
 =?utf-8?B?anhjM3BuYVBDa2FmWTlkT0llSmlHRXAzKzM3emsyOWlGQmVlNFpSTlpXbGJl?=
 =?utf-8?B?dm9MUndlaWJUZHVNaUJRQ2FOaDNaVUZHNjJXcDcrcFFKZXBLK0JzdXNNTk5Z?=
 =?utf-8?B?bHdiTVgvY2JoS3orWldhbDhnTjh0WTh4Ymk3K3kxUWdLOWdOYk5ZNGlwNXdv?=
 =?utf-8?B?NjVBNFlPT204RmhnRWxCaEhVTGl0THlQbUlYd3orMFNpTWxIQ0RFWEl6V2Rj?=
 =?utf-8?B?YVhOMDdXcVFiTnRnaVZURlZ6YkNYQUdFQnhMUk1maXdGeVEvcEtpUHRscDR6?=
 =?utf-8?B?clVxOGtNcGhRWFVNbGhNU0p1UnZQSUpRMFJxdjJxTVNsLzF4b3IxVm1Vd04y?=
 =?utf-8?B?eXJVQmNLWTBZOXRhbmRzZkVQTzlHMERzQzVuOFRiZ0dNYUJBNUtCUkhRY0RI?=
 =?utf-8?B?UmZDR2xsVFFFVmlXUDQyREhLUC9nd01BOHhUYkdhbEFkMkVnQmwvS1FPYkYy?=
 =?utf-8?B?eXN6ZUxJRGFCdlJFcDcrS0FqT3IyNHhiZE15Z1J5M29aNkdUVkppUXBIYUsy?=
 =?utf-8?B?R0MwZE1nK1A3ZUJPL3k2ZHlwUjk0OXFldGE1YS9ROTYyV1BINkE0YjhzZWc5?=
 =?utf-8?B?SHVJQXRmMkk1UGUwM1k5RkF2WlNFdWJmMDB6RGhWb2dzaHJ6YmZYWUJlWGpE?=
 =?utf-8?B?YUZoTzFqS0FHZkZyUFlZaGxCMGdEcDh5SDBFK3EvS3hVQjVQTXYrc0FNbFE5?=
 =?utf-8?B?TWpFejExN3duZWQ5aG5DeUhtVjhMdXpWRUhXTk1NRFkzSnkzaTRKUkxocU1I?=
 =?utf-8?B?RVBTS1BGV3plWmVaVVZxRGJ4RStobThJMkxYa3ZCby9vKzd2dVEvcUgwV2c5?=
 =?utf-8?B?UDVNWkw1enlQYjkraC9DazlmWDhiSmZDdG00SWNhVS9EUUhZWjlKcU1uTVBj?=
 =?utf-8?B?bnkyK3dWYnZjdU42UEZtT0Q1TVV2OGd1ZnFucEYvWGdReVhaM3U1RXRld2Nm?=
 =?utf-8?B?eTlBR1YxNWxpaG5zWkR6QUdSZ3FjK2dMMUF4a0drVmtzV0wvbVBENzUvTmlU?=
 =?utf-8?B?TDZldVNkRWdaNURPMFVqY1YxUWhPcUJ2SmloQUx5T1NBR0tQN2FoeUxKdUxh?=
 =?utf-8?B?MGdZdWYzZ3VJU0NLRFpJNVY5OFNVeTlRWWdiRnJGRDkvZ3U0alFzMWJPZW91?=
 =?utf-8?B?d1Fzb0pCeURjTDcxZEx3WjIyZ3p0dk9kTTI3c1QvdXQrQnUxVkh6WWkzaXpz?=
 =?utf-8?B?Si9PektYMjVnVVE2RmYvK2tIeWsxc0ZicVVMNkxFZERIVmFEOEcrSW5Samlo?=
 =?utf-8?B?UCtOR0IxUTdvVW5scS9WNXB4bWpBdjZnb3ppVHl1ayt5YlNiMjVPS0NWYUZz?=
 =?utf-8?B?dFZJcEhuU3RucXYwUDdQSlF2THhEV0tFdTBqNVF6VVh5SkZab2M2ZlFHbFVm?=
 =?utf-8?B?ZkJ2eURhQ3BDL2hnWGxZNk5zaWJESlFnbFpKYUxSYU9WS3JwRHNpU09RSzcx?=
 =?utf-8?B?SmFlNHBKbDdSSmM1N0MwSEpVU2JFdXFwOVUwV0F6M24ydVNtVzFoVXRTUVlo?=
 =?utf-8?B?MEl3Wm1neHAzQlArY3B1Ym1xVXVOQnJmNTRPcXhkSlFVdW1NeE83R1dYeU9u?=
 =?utf-8?B?N1NMdUJpRlFaYy8raTB0TG9pb3FJbjVXcmg3bHJFVDB4a1hWbGV1bVltKy9K?=
 =?utf-8?Q?UWUNCkRpJOzVOiQ28iVpXhdwjWDCFROa?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	agjcKNmk/regw4zQRhz4wsWbLste5JPJQpbc0Mxu/YB3dOSpLsJvxUdQTSRnIntzhYWXBH3t6TuHdyKyw2PNC/T/bz3NTTiyG7Etm5UB/y+Z/Tzi+FEjZhCcKY1oRXADuqPT2Uo22vSDkOMOXqhaSvgq7T99WitUT5crsvLd472A7nCcy0aCVR+SxN/uYeRIMPnopd+UxlrRgDutbxZtixGo4rvkPdxqtgvSyKrXnjQPMM6wyGyZWhaNX8RFMc1XAvM75QWi3mlyyLYbPaIIRbtTIof9c4L6DsZBPUKHd7KuNsjooGkXOMGnWyT7sBkJvU3DiQBousnev+RNh9Wmyc2umfK1ssrno19Ap3+c595StbLWR1MybYiGqhsrlH5HGTt5bP5Dww1mOSY2iyP01mkb5EpGeQQWlucjzbTIlLAofIPHkvI1c0XJKxVacYt4Ptjp99rM1cxqsGHL5A+8aJTsddDgoRyxZF5s95TlEJkjV5W5/KBk2ps3FUj9+YNvnGzE+KUUftCgiZ5mwjWpxQvzlgJ6N2l5qRL2dLuVMIjiv79qZGqiY9ui+B0eSrB1eAm4JnvOln/yL3YC6IWsrmayo9zRp/lruXqZBx8WB8wVYlj0+47nuysUjFxHqE8bQ8SgdlUY3k8lj73+medlKQ==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2024 13:40:54.6230
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ff30fcb-c93a-4f7f-575a-08dd0ee91dd5
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR19MB7087
X-BESS-ID: 1732714857-110664-13393-2147-1
X-BESS-VER: 2019.1_20241126.2220
X-BESS-Apparent-Source-IP: 104.47.55.169
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVpamJgZAVgZQ0MwkJcXAOC3ZPM
	3UwtQ8MTXR0iA1JTk10TA1Kckw0dBAqTYWAPlXP/NBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260718 [from 
	cloudscan19-165.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
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
 fs/fuse/dev_uring.c   | 109 ++++++++++++++++++++++++++++++++++++++------------
 fs/fuse/dev_uring_i.h |  12 ++++++
 2 files changed, 95 insertions(+), 26 deletions(-)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 94dc3f56d4ab604eb4b87d3b9731567e3a214b0a..fe24e31bbfecec526f88bc5b82b0aa132357c1cc 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -26,6 +26,7 @@ bool fuse_uring_enabled(void)
 
 struct fuse_uring_cmd_pdu {
 	struct fuse_ring_ent *ring_ent;
+	struct fuse_ring_queue *queue;
 };
 
 const struct fuse_iqueue_ops fuse_io_uring_ops;
@@ -221,6 +222,7 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
 	struct fuse_conn *fc = ring->fc;
 	struct fuse_ring_queue *queue;
 	struct list_head *pq;
+	struct fuse_ring_ent *ent, *next;
 
 	queue = kzalloc(sizeof(*queue), GFP_KERNEL_ACCOUNT);
 	if (!queue)
@@ -249,6 +251,12 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
 	INIT_LIST_HEAD(&queue->ent_in_userspace);
 	INIT_LIST_HEAD(&queue->fuse_req_queue);
 	INIT_LIST_HEAD(&queue->fuse_req_bg_queue);
+	INIT_LIST_HEAD(&queue->ent_released);
+
+	list_for_each_entry_safe(ent, next, &queue->ent_released, list) {
+		list_del_init(&ent->list);
+		kfree(ent);
+	}
 
 	queue->fpq.processing = pq;
 	fuse_pqueue_init(&queue->fpq);
@@ -281,24 +289,27 @@ static void fuse_uring_stop_fuse_req_end(struct fuse_ring_ent *ent)
 /*
  * Release a request/entry on connection tear down
  */
-static void fuse_uring_entry_teardown(struct fuse_ring_ent *ent,
-					 bool need_cmd_done)
+static void fuse_uring_entry_teardown(struct fuse_ring_ent *ent)
 {
-	/*
-	 * fuse_request_end() might take other locks like fi->lock and
-	 * can lead to lock ordering issues
-	 */
-	lockdep_assert_not_held(&ent->queue->lock);
+	struct fuse_ring_queue *queue = ent->queue;
 
-	if (need_cmd_done)
+	if (ent->need_cmd_done)
 		io_uring_cmd_done(ent->cmd, -ENOTCONN, 0,
 				  IO_URING_F_UNLOCKED);
 
 	if (ent->fuse_req)
 		fuse_uring_stop_fuse_req_end(ent);
 
-	list_del_init(&ent->list);
-	kfree(ent);
+	/*
+	 * The entry must not be freed immediately, due to access of direct
+	 * pointer access of entries through IO_URING_F_CANCEL - there is a risk
+	 * of race between daemon termination (which triggers IO_URING_F_CANCEL
+	 * and accesses entries without checking the list state first
+	 */
+	spin_lock(&queue->lock);
+	list_move(&ent->list, &queue->ent_released);
+	ent->state = FRRS_RELEASED;
+	spin_unlock(&queue->lock);
 }
 
 static void fuse_uring_stop_list_entries(struct list_head *head,
@@ -318,15 +329,15 @@ static void fuse_uring_stop_list_entries(struct list_head *head,
 			continue;
 		}
 
+		ent->need_cmd_done = ent->state != FRRS_USERSPACE;
+		ent->state = FRRS_TEARDOWN;
 		list_move(&ent->list, &to_teardown);
 	}
 	spin_unlock(&queue->lock);
 
 	/* no queue lock to avoid lock order issues */
 	list_for_each_entry_safe(ent, next, &to_teardown, list) {
-		bool need_cmd_done = ent->state != FRRS_USERSPACE;
-
-		fuse_uring_entry_teardown(ent, need_cmd_done);
+		fuse_uring_entry_teardown(ent);
 		queue_refs = atomic_dec_return(&ring->queue_refs);
 
 		WARN_ON_ONCE(queue_refs < 0);
@@ -434,6 +445,49 @@ void fuse_uring_stop_queues(struct fuse_ring *ring)
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
+	struct fuse_ring_ent *ent = pdu->ring_ent;
+	bool need_cmd_done = false;
+
+	/*
+	 * direct access on ent - it must not be destructed as long as
+	 * IO_URING_F_CANCEL might come up
+	 */
+	spin_lock(&queue->lock);
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
@@ -638,8 +692,10 @@ static int fuse_uring_send_next_to_ring(struct fuse_ring_ent *ring_ent)
  * Make a ring entry available for fuse_req assignment
  */
 static void fuse_uring_ent_avail(struct fuse_ring_ent *ring_ent,
-				 struct fuse_ring_queue *queue)
+				 struct fuse_ring_queue *queue,
+				 unsigned int issue_flags)
 {
+	fuse_uring_prepare_cancel(ring_ent->cmd, issue_flags, ring_ent);
 	list_move(&ring_ent->list, &queue->ent_avail_queue);
 	ring_ent->state = FRRS_WAIT;
 }
@@ -742,7 +798,8 @@ static void fuse_uring_commit(struct fuse_ring_ent *ring_ent,
  * Get the next fuse req and send it
  */
 static void fuse_uring_next_fuse_req(struct fuse_ring_ent *ring_ent,
-				    struct fuse_ring_queue *queue)
+				    struct fuse_ring_queue *queue,
+				    unsigned int issue_flags)
 {
 	int has_next, err;
 	int prev_state = ring_ent->state;
@@ -751,7 +808,7 @@ static void fuse_uring_next_fuse_req(struct fuse_ring_ent *ring_ent,
 		spin_lock(&queue->lock);
 		has_next = fuse_uring_ent_assign_req(ring_ent);
 		if (!has_next) {
-			fuse_uring_ent_avail(ring_ent, queue);
+			fuse_uring_ent_avail(ring_ent, queue, issue_flags);
 			spin_unlock(&queue->lock);
 			break; /* no request left */
 		}
@@ -826,7 +883,7 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
 	 * and fetching is done in one step vs legacy fuse, which has separated
 	 * read (fetch request) and write (commit result).
 	 */
-	fuse_uring_next_fuse_req(ring_ent, queue);
+	fuse_uring_next_fuse_req(ring_ent, queue, issue_flags);
 	return 0;
 }
 
@@ -868,7 +925,7 @@ static void _fuse_uring_fetch(struct fuse_ring_ent *ring_ent,
 	struct fuse_iqueue *fiq = &fc->iq;
 
 	spin_lock(&queue->lock);
-	fuse_uring_ent_avail(ring_ent, queue);
+	fuse_uring_ent_avail(ring_ent, queue, issue_flags);
 	ring_ent->cmd = cmd;
 	spin_unlock(&queue->lock);
 
@@ -1022,6 +1079,11 @@ int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	if (!fc->connected || fc->aborted)
 		return fc->aborted ? -ECONNABORTED : -ENOTCONN;
 
+	if ((unlikely(issue_flags & IO_URING_F_CANCEL))) {
+		fuse_uring_cancel(cmd, issue_flags, fc);
+		return 0;
+	}
+
 	switch (cmd_op) {
 	case FUSE_URING_REQ_FETCH:
 		err = fuse_uring_fetch(cmd, issue_flags, fc);
@@ -1074,7 +1136,7 @@ fuse_uring_send_req_in_task(struct io_uring_cmd *cmd,
 
 	return;
 err:
-	fuse_uring_next_fuse_req(ring_ent, queue);
+	fuse_uring_next_fuse_req(ring_ent, queue, issue_flags);
 }
 
 static struct fuse_ring_queue *fuse_uring_task_to_queue(struct fuse_ring *ring)
@@ -1129,14 +1191,11 @@ void fuse_uring_queue_fuse_req(struct fuse_iqueue *fiq, struct fuse_req *req)
 
 	if (ring_ent) {
 		struct io_uring_cmd *cmd = ring_ent->cmd;
-		struct fuse_uring_cmd_pdu *pdu =
-			(struct fuse_uring_cmd_pdu *)cmd->pdu;
-
 		err = -EIO;
 		if (WARN_ON_ONCE(ring_ent->state != FRRS_FUSE_REQ))
 			goto err;
 
-		pdu->ring_ent = ring_ent;
+		/* pdu already set by preparing IO_URING_F_CANCEL */
 		io_uring_cmd_complete_in_task(cmd, fuse_uring_send_req_in_task);
 	}
 
@@ -1189,12 +1248,10 @@ bool fuse_uring_queue_bq_req(struct fuse_req *req)
 				       list);
 	if (ring_ent && req) {
 		struct io_uring_cmd *cmd = ring_ent->cmd;
-		struct fuse_uring_cmd_pdu *pdu =
-			(struct fuse_uring_cmd_pdu *)cmd->pdu;
 
 		fuse_uring_add_req_to_ring_ent(ring_ent, req);
 
-		pdu->ring_ent = ring_ent;
+		/* pdu already set by preparing IO_URING_F_CANCEL */
 		io_uring_cmd_complete_in_task(cmd, fuse_uring_send_req_in_task);
 	}
 	spin_unlock(&queue->lock);
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index 0826fb1c03e2e38dedad56552ea09461965e248f..df541247f07e413923b13b6bf203f301e8c1710a 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -28,6 +28,12 @@ enum fuse_ring_req_state {
 
 	/* The ring entry is in or on the way to user space */
 	FRRS_USERSPACE,
+
+	/* The ring entry is in teardown */
+	FRRS_TEARDOWN,
+
+	/* The ring entry is released, but not freed yet */
+	FRRS_RELEASED,
 };
 
 /** A fuse ring entry, part of the ring queue */
@@ -52,6 +58,9 @@ struct fuse_ring_ent {
 	 */
 	unsigned int state;
 
+	/* The entry needs io_uring_cmd_done for teardown */
+	unsigned int need_cmd_done;
+
 	struct fuse_req *fuse_req;
 };
 
@@ -84,6 +93,9 @@ struct fuse_ring_queue {
 	/* entries in userspace */
 	struct list_head ent_in_userspace;
 
+	/* entries that are released */
+	struct list_head ent_released;
+
 	/* fuse requests waiting for an entry slot */
 	struct list_head fuse_req_queue;
 

-- 
2.43.0


