Return-Path: <io-uring+bounces-5071-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84FFE9DA8B7
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 14:41:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 47110282A69
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 13:41:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A6CA1FDE00;
	Wed, 27 Nov 2024 13:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="XUpwcPHD"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACAA61FCF69;
	Wed, 27 Nov 2024 13:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732714863; cv=fail; b=rjsmScubHDOg6k22YendZnG+K2OSfrWUdcKb0ddoN7i61sCvI6o497fJT+9X/DhkuP6e2P/c1oO8BCJ7NGYOswSZiyZqYVTG9TFV1suYk2sAHLd+y3d9IZScl/mWECdqhM/NI8Mv0dkg/NXcqCXO/HGPnfaBbElntrDPp6ztO9c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732714863; c=relaxed/simple;
	bh=YMDRA/9vyPHvJ4SYiHECXaAT2XkWqbd5Qmx9AghyOpg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qPnTyWObOgJ/k3vgqE1GG7PsGeieh8e77yPJSzYJ4ng0RPAQR6TG9Uh7llwysvPqO7PB2Ej1YUtEechD2g9e1O0x/B/RCP7fepxmv03Cn7CmeRURbEptcHl5xUgubBPjKKtz+zxzF6GdAoT1Xxs7SNZUtiWUaaX75F9rXhbfP3E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=XUpwcPHD; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2047.outbound.protection.outlook.com [104.47.57.47]) by mx-outbound14-13.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 27 Nov 2024 13:40:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IDGtbQL7Wr9Iie1pBQZan0r7zXzmk3cnFztJWPGgPdE6DTY9BgOGMMfxVHXpTONwVh6HIRLI6Gt80xjvynedXVMFyMEFWz6ld9/yde+rWgWY7/uNDZRgWcPKNOYXWUDxRHrWwbU3xMM96T/JiURvV9eWYA4bztuSDesoMQvlOGK/tN/jmey3YXQaLuuha/gDc9IDyW+HCHBAKUyTzv/clS25fzDwp6zNA4WjCfY7E8au+AIQOFSbiXpvQDBulgICnywqYzBoOtnJ6g++EIKJOLADK/GqUChbKs583/bNgRzPvnmJneXqKoLUjk1bC8+z+vXXMMSt7dqpENpr1W8jxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ArICW21BCfXstjqQ4sE5Z/YXHrwdQe2KHKQeEbeYLAk=;
 b=A6NCoxeZ1NNjGuBEMMFMaFCUaBb0Sl/acJNNhLiEdCr4mK8Y6G8IqKIctZTGqdVOd6HM5I62NGCeKiwpXt8P9CoOqqRgMufrt8L7c/YR2vUlAdSXaizoSAYjFwL/XnIpJKBAHAftLTxMbscbvIIWb6H2QCrTxyhRz3TTb9O7K0XKPj031aQLQr4zGfkwPbgyYIeckz/9j1rmv/8mmlAD6AoiR57oZNnNTthRkjm7joDSvax82IbtJ2SKkzKQ/8yCn5iD4sTkz3crS/ysSXvEuwjmmoL7eu9A5HC0T75iPBgPSRB75CZoQYK3bhxIY1epqJZHu+83x9UjOnhPQ97n4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ArICW21BCfXstjqQ4sE5Z/YXHrwdQe2KHKQeEbeYLAk=;
 b=XUpwcPHDEuoxyCbMGPnOjd8e5WfEt3u8Zl1SNa4gIYU5R65yoerj6YPNOgYi8eIMccS1RUW+xcAsJqmVCThQ9/yFVVun41chiHrbD8koCyDPqnm4LcSgz2Hw4g4ogqigB9hjBYusbVvDTX+abpaZrJOtMq3qkL2/6EiR/Q59/M4=
Received: from CH2PR04CA0019.namprd04.prod.outlook.com (2603:10b6:610:52::29)
 by SJ0PR19MB4448.namprd19.prod.outlook.com (2603:10b6:a03:287::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.13; Wed, 27 Nov
 2024 13:40:45 +0000
Received: from CH1PEPF0000AD78.namprd04.prod.outlook.com
 (2603:10b6:610:52:cafe::39) by CH2PR04CA0019.outlook.office365.com
 (2603:10b6:610:52::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8182.21 via Frontend Transport; Wed,
 27 Nov 2024 13:40:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CH1PEPF0000AD78.mail.protection.outlook.com (10.167.244.56) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.12
 via Frontend Transport; Wed, 27 Nov 2024 13:40:44 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 35BD555;
	Wed, 27 Nov 2024 13:40:44 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Wed, 27 Nov 2024 14:40:22 +0100
Subject: [PATCH RFC v7 05/16] fuse: make args->in_args[0] to be always the
 header
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241127-fuse-uring-for-6-10-rfc4-v7-5-934b3a69baca@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1732714838; l=6435;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=YMDRA/9vyPHvJ4SYiHECXaAT2XkWqbd5Qmx9AghyOpg=;
 b=uwGcy6zA5MUVKGXUq+CLFp3A4KO2S984QeI3Oofg/etParW6KP8RAeVvCGooAzDzFKAzZSC3M
 xn78XuBr7GZBdDS9PJ7CBzZ7P4YjTQzUZsyR70ag6HXEfMdJvg3b0G/
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD78:EE_|SJ0PR19MB4448:EE_
X-MS-Office365-Filtering-Correlation-Id: 1641315d-16a1-4ed9-0a98-08dd0ee9182e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NTV4YkNqU1dxL2VmNis1cmNNU3g5bHRyQkFFTUFoQnhod0ZtVHNvU0VDbXIx?=
 =?utf-8?B?VU5SaW8wUDhMUk14QnRPZ05OZ2ZaQmFIMllSakNDb0pQNTFFTEYxM3hodTlo?=
 =?utf-8?B?NEUzVUhLZmdRSTlzS2RsZE40U255VTlWYmUvQm5saTdwd0lsYm9rYUk3cTNr?=
 =?utf-8?B?Wm9aakkxMWFVOTZyb1FSTVFaYjhMMGxldzZVRU15SDc4NXh6emtaWXNzTFht?=
 =?utf-8?B?TWluS24wTGdiNXg2a0V5RUV6RWZFY1JGV3hLTi9WdlloNkNCeEdRcUJKVHBh?=
 =?utf-8?B?WC81RmZIWTVkQmVoV0pkWXI3T25zQVVmNXJvVGJteHJUeGEwVDlHWjE0VkZN?=
 =?utf-8?B?ZkdHRnorVk5IUE5MMUt6WmNVRnlvSXZTcjgwYlcwOXFqak83bWdjZmVpbUVU?=
 =?utf-8?B?UWNGVzBvdlpYbittdmoxZU9HK0kzbXI3empCTnNGamF6ak16RElDQ0Z4SitD?=
 =?utf-8?B?WngrdGxuQURJS04xZlg0NVFDV2lmK1BIY1R6UzNSRUsyV3lYUEUvSktDSDNG?=
 =?utf-8?B?STdIYnNCREtJU2EwdlZkTmNpSFVjN1pIVy9LeHgzYXljbFlteUlEcnNHSC9K?=
 =?utf-8?B?cXMvYVdteGlRelNVL0F2RzB6KzBQRFRma0dmS3duRXQ5L0RMb051U0MwbGli?=
 =?utf-8?B?Z3I1VjVJWU5rVFk1L1gwSFdXRktKcFVaWkFneGs1Y1B5b0NJMkR2SEJQdllG?=
 =?utf-8?B?UUxzUGpjQ2plWm9ONjZDeXdkRmRqNThzMDk4UjNZdUJWMlQ5TUIrU3NTT0My?=
 =?utf-8?B?cHRLY1ZwZlhZN3psRGZSeHNIQnBieDd2emgyTnNETC9vL1JvdW5URkJHdlBP?=
 =?utf-8?B?K3k5dWlSemlXc2x6OE9BZTFoZmxCUzJBdG5sQ3I2eGt0cUJ5VWxLMHQ0SDV1?=
 =?utf-8?B?aGRJNnZFWjNsQnBsaHphdGVuOWZPYkNRaS95cTRlOE11TGFLUWt6MUtza1gv?=
 =?utf-8?B?VFc2TDFkdTNuQXRvWXMrT0MyZlo2VG5GSUI3ZUxPNjMxS1ArVTRjQ1kwY0kz?=
 =?utf-8?B?b2Z6Qnh6TUlVaVBycWZFS3FiUkpobU5xYkhEUFlGTUlkY1Mwb1cyN0NmdUpE?=
 =?utf-8?B?K21GdlpZRTNEei9nYjFiS0hZOGl4SFhqdHlWbVErQWN3OTkvaVl0Y0NFMXdl?=
 =?utf-8?B?Q2NRZ1RKanQzU25POEIwWkdVWXJ1Vm80dExXMU5BcHJ6dXlBTmhXRlZkTFZq?=
 =?utf-8?B?QWU2K0U2S3ErQmpkd2ZZQnpCalhaNm5BbHdoSTVJMjkvZmtsQSt3dlZIL0Nz?=
 =?utf-8?B?Y3FSME00c0F5MU04aWErbkthWTJoTUxwdzZWSTQvQ2daWlhjcXl5SWs0N0VK?=
 =?utf-8?B?UWVvOFJwaHFWWjNZc2x0MUJxT2VvMXVyV293V0FiZGsrVGVPTkVKcDVwNU14?=
 =?utf-8?B?cDBVaW54bXl0VnVjUGNsRDhuYzdaN2trRndGRXh1eE9SYS9JYnRaaW1JdkM4?=
 =?utf-8?B?ZVZyZUtyMjIrZDVZYVNZMzMva2FNalhIUUVBQWZXUEZZS1BxcTNKWGY5S1pM?=
 =?utf-8?B?MldkWmhYL2dBT2s2akRvRkpDY0czcU1Yem1JdS92Vmo0anRjQ3VraElRNW0r?=
 =?utf-8?B?UXVjYVY0Zk9uclhzMzVVR0JTODhuamphSVZnZ3dqaWRwMFFCQmpvbTdkMDM1?=
 =?utf-8?B?aW1pdEFhb1k3TFNwSVpYQ2VyYVh2YVFva0czajd4b2paSVhUTVgzOS96L09N?=
 =?utf-8?B?bWUvQm5LM3B3SWpickkra1lSM3J2MnRWUVhraE9JWEROanQyZ1daK05RM3JV?=
 =?utf-8?B?d0w2cTdaRzBydmgyNlovUTRxM1pJaW4reGZ2ZzVtc1lKbGFWSG9ROHZlZmdR?=
 =?utf-8?B?VG1ndWtPY1ZDQkdwR3dvN0RSMGJycEkyMDF4aWlBMXB1U3V0SVJjZ3VpQVRy?=
 =?utf-8?B?Y2FKNzFiRU5jUG9Ldm5paTBhd0IyK1Voa1BvZzdURkMrOVhIdjQ0Rm5CTTZ6?=
 =?utf-8?Q?1K9W6SZ6QNYCY7dooN+LUtGkpd/eMFus?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(1800799024)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xf8nfOK0k4uvxy0Fcu+ZTFhE0i6XY8X3zkYpZ3iHpsHzeHx2vbKvNogKIeKeoWy4WOssGiQSSbbEzK6RLh0uEtsHJS9781ZtnPrx7z3cWK0Ms4Aiv1VzZDJuW+zv42jkPuMFb8TQ6NIDbqQg7a4GKdrSQWCogemND0oX0gJIF5YXhXpcbWkLlm92pEZYk4EN8JSZe5PsOXPDe6c9YPl0XZfOQQcItFRYqh12lQMzcC5qiisd4ablXb1q05in9w3HuD03pwuKFG/FEY/Ri9XLaeZQZFk44wPxj3iFdB7X5R/LRk4YKnqtuEPZcf1q+ZYgzZ2KBBFoSmjcsnNDZFHsi7d6xDjwcM7yX4daN87xvTIfVDN+cQhp3KY7r/JeGIxPGi4lEL/f2TXPi23JsyKbpAhtrKleoq6jEIAsF9Wh5EKb8iXuCcNnRYmmAOtU0i4mOg2B47XfaKln1u4QnO+5xQzey1XTYH4JqRuz6p7xsA9S3TZRdZSZxVd7zjDXhDzLQtQg/uwii8aNmJUDmyw7vsNZ5f43mK6cZ55d0GA4l8t8p1Wx4yCJragg6HkdwigzQlUKnjXjF6f4BbusK6iWJzBQ19lbH5dgmP/0cPP0EJknc2rzO5kH5+qCw7mAIarXL9pZ0pgmY/cwe8V/OBJkzw==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2024 13:40:44.9661
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1641315d-16a1-4ed9-0a98-08dd0ee9182e
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD78.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR19MB4448
X-BESS-ID: 1732714848-103597-13476-2193-1
X-BESS-VER: 2019.1_20241126.2220
X-BESS-Apparent-Source-IP: 104.47.57.47
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVmZGppZAVgZQ0MIiLdkkzTDVwj
	TFxMTMJM0gzcw0JSnZNNU41czQINlYqTYWADF/4GRBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260718 [from 
	cloudscan12-255.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This change sets up FUSE operations to have headers in args.in_args[0],
even for opcodes without an actual header. We do this to prepare for
cleanly separating payload from headers in the future.

For opcodes without a header, we use a zero-sized struct as a
placeholder. This approach:
- Keeps things consistent across all FUSE operations
- Will help with payload alignment later
- Avoids future issues when header sizes change

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dax.c    | 11 ++++++-----
 fs/fuse/dev.c    |  9 +++++----
 fs/fuse/dir.c    | 32 ++++++++++++++++++--------------
 fs/fuse/fuse_i.h | 13 +++++++++++++
 fs/fuse/xattr.c  |  7 ++++---
 5 files changed, 46 insertions(+), 26 deletions(-)

diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
index 12ef91d170bb3091ac35a33d2b9dc38330b00948..44bd30d448e4e8c1d8c6b0499e50564fa0828efc 100644
--- a/fs/fuse/dax.c
+++ b/fs/fuse/dax.c
@@ -240,11 +240,12 @@ static int fuse_send_removemapping(struct inode *inode,
 
 	args.opcode = FUSE_REMOVEMAPPING;
 	args.nodeid = fi->nodeid;
-	args.in_numargs = 2;
-	args.in_args[0].size = sizeof(*inargp);
-	args.in_args[0].value = inargp;
-	args.in_args[1].size = inargp->count * sizeof(*remove_one);
-	args.in_args[1].value = remove_one;
+	args.in_numargs = 3;
+	fuse_set_zero_arg0(&args);
+	args.in_args[1].size = sizeof(*inargp);
+	args.in_args[1].value = inargp;
+	args.in_args[2].size = inargp->count * sizeof(*remove_one);
+	args.in_args[2].value = remove_one;
 	return fuse_simple_request(fm, &args);
 }
 
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index fd8898b0c1cca4d117982d5208d78078472b0dfb..63c3865aebb7811fdf4a5729b2181ee8321421dc 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1735,7 +1735,7 @@ static int fuse_retrieve(struct fuse_mount *fm, struct inode *inode,
 	args = &ap->args;
 	args->nodeid = outarg->nodeid;
 	args->opcode = FUSE_NOTIFY_REPLY;
-	args->in_numargs = 2;
+	args->in_numargs = 3;
 	args->in_pages = true;
 	args->end = fuse_retrieve_end;
 
@@ -1762,9 +1762,10 @@ static int fuse_retrieve(struct fuse_mount *fm, struct inode *inode,
 	}
 	ra->inarg.offset = outarg->offset;
 	ra->inarg.size = total_len;
-	args->in_args[0].size = sizeof(ra->inarg);
-	args->in_args[0].value = &ra->inarg;
-	args->in_args[1].size = total_len;
+	fuse_set_zero_arg0(args);
+	args->in_args[1].size = sizeof(ra->inarg);
+	args->in_args[1].value = &ra->inarg;
+	args->in_args[2].size = total_len;
 
 	err = fuse_simple_notify_reply(fm, args, outarg->notify_unique);
 	if (err)
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 54104dd48af7c94b312f1a8671c8905542d456c4..ccb240d4262f9399c9c90434aaeaf76b50f223ad 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -175,9 +175,10 @@ static void fuse_lookup_init(struct fuse_conn *fc, struct fuse_args *args,
 	memset(outarg, 0, sizeof(struct fuse_entry_out));
 	args->opcode = FUSE_LOOKUP;
 	args->nodeid = nodeid;
-	args->in_numargs = 1;
-	args->in_args[0].size = name->len + 1;
-	args->in_args[0].value = name->name;
+	args->in_numargs = 2;
+	fuse_set_zero_arg0(args);
+	args->in_args[1].size = name->len + 1;
+	args->in_args[1].value = name->name;
 	args->out_numargs = 1;
 	args->out_args[0].size = sizeof(struct fuse_entry_out);
 	args->out_args[0].value = outarg;
@@ -927,11 +928,12 @@ static int fuse_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	FUSE_ARGS(args);
 
 	args.opcode = FUSE_SYMLINK;
-	args.in_numargs = 2;
-	args.in_args[0].size = entry->d_name.len + 1;
-	args.in_args[0].value = entry->d_name.name;
-	args.in_args[1].size = len;
-	args.in_args[1].value = link;
+	args.in_numargs = 3;
+	fuse_set_zero_arg0(&args);
+	args.in_args[1].size = entry->d_name.len + 1;
+	args.in_args[1].value = entry->d_name.name;
+	args.in_args[2].size = len;
+	args.in_args[2].value = link;
 	return create_new_entry(idmap, fm, &args, dir, entry, S_IFLNK);
 }
 
@@ -991,9 +993,10 @@ static int fuse_unlink(struct inode *dir, struct dentry *entry)
 
 	args.opcode = FUSE_UNLINK;
 	args.nodeid = get_node_id(dir);
-	args.in_numargs = 1;
-	args.in_args[0].size = entry->d_name.len + 1;
-	args.in_args[0].value = entry->d_name.name;
+	args.in_numargs = 2;
+	fuse_set_zero_arg0(&args);
+	args.in_args[1].size = entry->d_name.len + 1;
+	args.in_args[1].value = entry->d_name.name;
 	err = fuse_simple_request(fm, &args);
 	if (!err) {
 		fuse_dir_changed(dir);
@@ -1014,9 +1017,10 @@ static int fuse_rmdir(struct inode *dir, struct dentry *entry)
 
 	args.opcode = FUSE_RMDIR;
 	args.nodeid = get_node_id(dir);
-	args.in_numargs = 1;
-	args.in_args[0].size = entry->d_name.len + 1;
-	args.in_args[0].value = entry->d_name.name;
+	args.in_numargs = 2;
+	fuse_set_zero_arg0(&args);
+	args.in_args[1].size = entry->d_name.len + 1;
+	args.in_args[1].value = entry->d_name.name;
 	err = fuse_simple_request(fm, &args);
 	if (!err) {
 		fuse_dir_changed(dir);
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index e6cc3d552b1382fc43bfe5191efc46e956ca268c..e3748751e231d0991c050b31bdd84db0b8016f9f 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -938,6 +938,19 @@ struct fuse_mount {
 	struct rcu_head rcu;
 };
 
+/*
+ * Empty header for FUSE opcodes without specific header needs.
+ * Used as a placeholder in args->in_args[0] for consistency
+ * across all FUSE operations, simplifying request handling.
+ */
+struct fuse_zero_header {};
+
+static inline void fuse_set_zero_arg0(struct fuse_args *args)
+{
+	args->in_args[0].size = sizeof(struct fuse_zero_header);
+	args->in_args[0].value = NULL;
+}
+
 static inline struct fuse_mount *get_fuse_mount_super(struct super_block *sb)
 {
 	return sb->s_fs_info;
diff --git a/fs/fuse/xattr.c b/fs/fuse/xattr.c
index 9f568d345c51236ddd421b162820a4ea9b0734f4..93dfb06b6cea045d6df90c61c900680968bda39f 100644
--- a/fs/fuse/xattr.c
+++ b/fs/fuse/xattr.c
@@ -164,9 +164,10 @@ int fuse_removexattr(struct inode *inode, const char *name)
 
 	args.opcode = FUSE_REMOVEXATTR;
 	args.nodeid = get_node_id(inode);
-	args.in_numargs = 1;
-	args.in_args[0].size = strlen(name) + 1;
-	args.in_args[0].value = name;
+	args.in_numargs = 2;
+	fuse_set_zero_arg0(&args);
+	args.in_args[1].size = strlen(name) + 1;
+	args.in_args[1].value = name;
 	err = fuse_simple_request(fm, &args);
 	if (err == -ENOSYS) {
 		fm->fc->no_removexattr = 1;

-- 
2.43.0


