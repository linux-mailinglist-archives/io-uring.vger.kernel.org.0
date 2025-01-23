Return-Path: <io-uring+bounces-6081-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2398EA1A63B
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 15:52:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 581951632E5
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 14:52:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9763A212B05;
	Thu, 23 Jan 2025 14:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="wkYVwNAF"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2323238B;
	Thu, 23 Jan 2025 14:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737643909; cv=fail; b=mp83aanBhAa5V2O8Bllk5X32mYn7oHk1cNdgMcIJ3+Uno13RP6Kl3/HY8XbKNgPu+nSqQuGa2pWtRxWG+XZqU+vlE7Gg49PE7nZoEiIBsOirBqhI3WOVCHeSsgrF9udlQ2KDMZrOui3wCmZDiuwMNXImvtDCKtg0GEd35elauzM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737643909; c=relaxed/simple;
	bh=ZvHcnDFcanbmppWrgkDvfr/TMZH3ghjPnr+xXvsVqIw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Jhqk6zeqt37MTTbvsCsQzZDBSS5qpDS3axGnF08LXoaUKXj/v7wT0telE1VR3M55gYiE2srgnX8yoG8e/ofj+x791IaR75j5JI6aqT6GawvfENo/6SNN7pTrSvcVJi0D7kwqb/KI41VQ9+J8FNC5QdSpsl7bovsqtIZ0KSZ8LMc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=wkYVwNAF; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177]) by mx-outbound14-67.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 23 Jan 2025 14:51:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WQ+WvL3QTb9+L0BzCB0XbrsN8RNNlNVKUI8A7wcHbzGRr6AQyPEUdPw8YZswng0lnsyRohrFQPc/MMAPTgZyn3v0JmeYSD6LBqkiXv4DBiWtkEd5D7r0IOhFtsh3BjoaD4CR+JDn0g6vtX9vQUt+jLsVXjOkLLFbMPrI7xUPlwH44VIG+w+RdPHOn9U0xed18q2XKe/zS5hh501ALBptEeZKKd+YaBc/4mhgKnZQaJZepazLO9Qzbvfp9q70NFFQioDYnxlP9if2mBJuWTVB2XnT/bnLd28n/RUKA7lxgLu7i1exe4ZJmXJ5Xyy7FS9fjgK1C6xe63WFGKET40E6RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f8Tzn2LqNYOkio0ylfB61+ygcosEc2Bi6zNxeYKxsLY=;
 b=axY55ts8qwiXRAthhNvamA+pc1+lJ7VfalZ3pRgb2tfrlF8pSo+/KDYdxwxKbkd6dLiy2y2w6mteGLb+zfFeOKZIPlgz1Jy9Z3wZOfQs3Oj7P4SuTyZBnXEzShOPyLv6qQ4tHjh/hpFACQGEm0rsnTz6KcFqXZdOHejGJUfmR5l6Ljq2DFiGT/4R5KVrjP/nDF42/DuYbTGqOqbH95OUgyDMrZqEh1LQegVTaCBO7pKeSfNwaqNbI4IaJw7H11N8bDcJf6fUhn4+OyHZLRQ0LvUXOn37d8zxPix8yhaJ5NRd7yePWleKZXzFhyX3MBdDsOmGzUb/j1Z6R4dZ9T1F/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f8Tzn2LqNYOkio0ylfB61+ygcosEc2Bi6zNxeYKxsLY=;
 b=wkYVwNAFwavWQpCrKuOM2DIBRfUdsjockgSU35q1SqtdrKUjb3P/ULT5TMP/2nFY1JKsluvMxwh3r1an0U1QgezjsuxeRUH155glUoGf9nfXDJr36d743eotZT55mCcnFZgn50sI6V1TiU5X77rcXASxaAz2BPYz7s/xuwR3/5U=
Received: from BLAPR03CA0015.namprd03.prod.outlook.com (2603:10b6:208:32b::20)
 by CO6PR19MB4804.namprd19.prod.outlook.com (2603:10b6:5:346::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.17; Thu, 23 Jan
 2025 14:51:27 +0000
Received: from BL6PEPF0001AB73.namprd02.prod.outlook.com
 (2603:10b6:208:32b:cafe::5a) by BLAPR03CA0015.outlook.office365.com
 (2603:10b6:208:32b::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.18 via Frontend Transport; Thu,
 23 Jan 2025 14:51:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BL6PEPF0001AB73.mail.protection.outlook.com (10.167.242.166) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.8
 via Frontend Transport; Thu, 23 Jan 2025 14:51:26 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id C3C8034;
	Thu, 23 Jan 2025 14:51:25 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Thu, 23 Jan 2025 15:51:13 +0100
Subject: [PATCH v11 14/18] fuse: Allow to queue bg requests through
 io-uring
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250123-fuse-uring-for-6-10-rfc4-v11-14-11e9cecf4cfb@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737643871; l=7400;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=ZvHcnDFcanbmppWrgkDvfr/TMZH3ghjPnr+xXvsVqIw=;
 b=DBIA4HhH0cVa63QAA0FJlHH2qn+zPe6aCxXxVzezvHAFhufjWTZPWGEiJJ0XAf4g457JmGlMY
 sZQrIHfa0XnAx3z7kxq6PFOeH3uoZ1wBQuQed1c+7tGKw1cyOs2/2hC
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB73:EE_|CO6PR19MB4804:EE_
X-MS-Office365-Filtering-Correlation-Id: cee07d2d-b17a-4740-501e-08dd3bbd69f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QXhIZWxjUGt2SmhRdER0ZFpMZXlWZEhmQzllZldoUGkvQU45eHUyYnAzWjVN?=
 =?utf-8?B?WHZZSGVRMXRuMFlON09XU2x0d2JSUmVyTC81aVcyRjk1YkpYVjhQbEtaamV0?=
 =?utf-8?B?bGNoSmxDKyt3WW1uRVp1VERjRFZwRDJVZDQxQTVtUm84MUNSZHBCNy83MEVa?=
 =?utf-8?B?Y2JBZGhqMFJkWGQ1Q3V4UXYrQS9kODB5M0RLczVmWHNyWmFKT2dIUkZQM1Ju?=
 =?utf-8?B?ak5haGdFZlBXMFB5QStSTXJpQVg4em1DcXp0VldLTTlHZWZDRzRFWU1QYlRN?=
 =?utf-8?B?SUdDQzRaQTR4a1JZZU1ORlBoTUxReXVMcXFOMmJBQXhOTUZibks2QXIzcjBh?=
 =?utf-8?B?T3VwZy81eFRVNnpjVDNDTThsQjBlMzRqSll5cDRoMUIwVXVaQVV1NFBtQ0hj?=
 =?utf-8?B?RHgrSmM2WUx3ZzhldHhUQWpURU9XeG9zN3lHRXR3akpDZzdmZlBMMGFnL010?=
 =?utf-8?B?NE0renhZZnhRQUZSSlFTRGh3Z2JjSWY5djB6TDZDYXFCTlFPWkY4NHVmbEdE?=
 =?utf-8?B?SWpiYU9GTktub2tIZEdqYTU1OEZkSWFVcWF0djQreE9rRG9XWWFKK1gzcDdt?=
 =?utf-8?B?dUVYMU1ZTkZLbXh5OFp5OFdyQWpGd1RmblhjdWpGTU9iQ2ZGZWRCNTdIQ3Yy?=
 =?utf-8?B?YmJjQnNkTUxvME9uNHgyV0drQ2lrd1lIeFlXcHBpMzdGMGthbFFqWG5QSHlz?=
 =?utf-8?B?WWNvV2dWTVdiVjJWQlNlVUVzYUcvQUVpanBmVDlFWkV2Y0ZkdlowQU96YlRp?=
 =?utf-8?B?ZHNORW1pa0tLWkdySDUydzVrUGREWThacndpRXVTeWROUXVuaGhuMHo5eXRI?=
 =?utf-8?B?TmFlTlZ0VFBqcDZZZlpNQlNkMUFEakNWOTA4Q3dDMnRRd29XOXd4UU5abll3?=
 =?utf-8?B?Qmd3SGRJZlFublg4YytQUi9QR1Axb2pKUXltNVpFMUVaS0h6S1dtd3NLVXJS?=
 =?utf-8?B?OGd1dzdLRzY4Z3FxRk8rOGFrdTFlclMvZmFJN2pJL0RkcEljNTFwbUpva25w?=
 =?utf-8?B?TEZlaERETC91RjBYZTlNRk5ZSUxzRjJ6ZWRqcFJrRGludTV3VmRjSUNRQTBI?=
 =?utf-8?B?VU1DQkt3QmtIRHcxNDhvZnJSS1J2ZExta0xVWFdld1Bqa1RjNUZuNTBmMFdu?=
 =?utf-8?B?bng0M0hxc2ZyR0wzWXhObDkvaXdHVzdueHZlOUQxdElQbmFMZExaTkZlYzhj?=
 =?utf-8?B?Z1hoQU9nK2hSeEVlM2xvc0paOGZYUnl2dHkxa3RHTkNSSXVidFhGNTFIRE1Q?=
 =?utf-8?B?NncyTFJZVTBDTHZvd1Y5OFNIZFJTK0pqRTFXTnMvdVp6ckJFbWg5ZVJkZ0pX?=
 =?utf-8?B?K0lTTWlac1BycnhJWXBycjB3LzM5TFllNjJpMFFxRVZuNzV5cXlVYis0WG9R?=
 =?utf-8?B?aXhwMll0ZWg4eTZSbG1nL3J4NExzelMxN1V5WWUvbXNuTDd5dU9IZnM3cUFZ?=
 =?utf-8?B?SW0yS0NvM1BuaHBNZkNKaXdzcEdQeFFnR29SRFVKdGRsOG9TZHQwRGZhU2dv?=
 =?utf-8?B?dGZFaVZpNXQwRitadWc3ZzlGdXNHMWhrUHpPMFE0b3RJbDhxZTBJcGZ0anpq?=
 =?utf-8?B?VFA0YXR5N1hNNHVURktkSjhZK3dpaFNFS1RzbXJpcC9zN2p4VmVrUDlkK2ZM?=
 =?utf-8?B?WEF5RHZQek9rTXBkc0toK2dWVEE5N05hT3MxRWJSU0dyWjREYitzMjZ2SnQw?=
 =?utf-8?B?bWNkS0REdTNiQzNJcGk0MDNmTUxEMnFaTSs5YTNTbmZwTzl4KzBOa2dCbHV6?=
 =?utf-8?B?KzduQTVRbVN4NC84QzdURGdwWUsvVUwvLzlTeWVEMzRjUkNmVGl3NnBESFNQ?=
 =?utf-8?B?S1E0SnZDTDVxNmhQdktpR0xWOXRoWDlIWkpQNVBTUThZKy9odWVVWXFDQ2t1?=
 =?utf-8?B?cWpjNTdxdGFNL1BpRURNQmp1RjBidDJpU2oxVzVQckJGbzRwT0FkRExBU25z?=
 =?utf-8?B?UFEwT09yUUJnbVRWMEtvOEJhUnVRd042OG92UDBGTGIwU3I4c2hWektYc2NY?=
 =?utf-8?Q?YbIeFhiy70H58EYMyRGfvX1CYX+siY=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pkenrEFpSioQT7iJxOhEXWAJM2rPFY5/++gVXS6JogSAcDgDv8g0wIzUaDBxsLJ+cRKgFdSQyHOZ+Qg1tze4ha5JqI3P900ljoUlO0/ENonJShVEPHcsezZgxCqvwVY/vlM6r1HiIq2Dp1PVcEsiW1eOD2oWpUaM8sxf/SV4ZmIpqbqeu3TLNAi0uwkipiySJKoY7NkCjAgLiuJ8FPJkRbA2nh8w1g1wkj7Wa3qZhxe8mQOKlFxry8ajJlkrXzfseLzuU/avLiApeBrlqhoTPlmLP8Vg4k4JPlq7dgF9MWIuLOhD7vpLv8AwyqUMnMeaHsUtpylwouwb9U2lnbIR8o33bcVxsK+YOdZNwxPtryUHsgRZW/WJuU2YOcI2e2McPSE6dukmIui8Ou51ghlIIsBKfVGa28l0r93E/znmHkXZaQfmoywVpvdIMkidvUys7I4P/UpANd66C8kXM75LuwjQ4oY9lv3am2CB9UeROhfv8vATPz1py3hJ2XbvycNyplIlTspCSyEraJX+AGyGB80C6MpSho5heZ4tQ+3yrNxfmx7/Zd0AyGu44kFxEIrJGr3YPlYYZgDLAv+pDhsJR109lRH0umJo/OtwOqci2QNNWNsp0r8YKTviERmQ8jzdKm2ZLdfvCN2DwWZ9VIHfGg==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2025 14:51:26.7679
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cee07d2d-b17a-4740-501e-08dd3bbd69f6
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB73.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR19MB4804
X-BESS-ID: 1737643890-103651-19135-6278-1
X-BESS-VER: 2019.1_20250122.1822
X-BESS-Apparent-Source-IP: 104.47.56.177
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVuaGZsZAVgZQ0NLM3CzJ2CQpJd
	UsOdHYyDzFNNEwNc0s2SDFxNjMJM1UqTYWAL/hiIpBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.262002 [from 
	cloudscan20-143.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This prepares queueing and sending background requests through
io-uring.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com> # io_uring
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/fuse/dev.c         | 26 +++++++++++++-
 fs/fuse/dev_uring.c   | 98 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h | 12 +++++++
 3 files changed, 135 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index ecf2f805f456222fda02598397beba41fc356460..1b593b23f7b8c319ec38c7e726dabf516965500e 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -568,7 +568,25 @@ ssize_t __fuse_simple_request(struct mnt_idmap *idmap,
 	return ret;
 }
 
-static bool fuse_request_queue_background(struct fuse_req *req)
+#ifdef CONFIG_FUSE_IO_URING
+static bool fuse_request_queue_background_uring(struct fuse_conn *fc,
+					       struct fuse_req *req)
+{
+	struct fuse_iqueue *fiq = &fc->iq;
+
+	req->in.h.unique = fuse_get_unique(fiq);
+	req->in.h.len = sizeof(struct fuse_in_header) +
+		fuse_len_args(req->args->in_numargs,
+			      (struct fuse_arg *) req->args->in_args);
+
+	return fuse_uring_queue_bq_req(req);
+}
+#endif
+
+/*
+ * @return true if queued
+ */
+static int fuse_request_queue_background(struct fuse_req *req)
 {
 	struct fuse_mount *fm = req->fm;
 	struct fuse_conn *fc = fm->fc;
@@ -580,6 +598,12 @@ static bool fuse_request_queue_background(struct fuse_req *req)
 		atomic_inc(&fc->num_waiting);
 	}
 	__set_bit(FR_ISREPLY, &req->flags);
+
+#ifdef CONFIG_FUSE_IO_URING
+	if (fuse_uring_ready(fc))
+		return fuse_request_queue_background_uring(fc, req);
+#endif
+
 	spin_lock(&fc->bg_lock);
 	if (likely(fc->connected)) {
 		fc->num_background++;
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index d5de116ec136f806c4490fc446a0fa0f3aa79e2e..93360fb4ee3c686e38ce041bffaf5ccd4b6cec65 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -47,9 +47,51 @@ static struct fuse_ring_ent *uring_cmd_to_ring_ent(struct io_uring_cmd *cmd)
 	return pdu->ent;
 }
 
+static void fuse_uring_flush_bg(struct fuse_ring_queue *queue)
+{
+	struct fuse_ring *ring = queue->ring;
+	struct fuse_conn *fc = ring->fc;
+
+	lockdep_assert_held(&queue->lock);
+	lockdep_assert_held(&fc->bg_lock);
+
+	/*
+	 * Allow one bg request per queue, ignoring global fc limits.
+	 * This prevents a single queue from consuming all resources and
+	 * eliminates the need for remote queue wake-ups when global
+	 * limits are met but this queue has no more waiting requests.
+	 */
+	while ((fc->active_background < fc->max_background ||
+		!queue->active_background) &&
+	       (!list_empty(&queue->fuse_req_bg_queue))) {
+		struct fuse_req *req;
+
+		req = list_first_entry(&queue->fuse_req_bg_queue,
+				       struct fuse_req, list);
+		fc->active_background++;
+		queue->active_background++;
+
+		list_move_tail(&req->list, &queue->fuse_req_queue);
+	}
+}
+
 static void fuse_uring_req_end(struct fuse_ring_ent *ent, int error)
 {
+	struct fuse_ring_queue *queue = ent->queue;
 	struct fuse_req *req = ent->fuse_req;
+	struct fuse_ring *ring = queue->ring;
+	struct fuse_conn *fc = ring->fc;
+
+	lockdep_assert_not_held(&queue->lock);
+	spin_lock(&queue->lock);
+	if (test_bit(FR_BACKGROUND, &req->flags)) {
+		queue->active_background--;
+		spin_lock(&fc->bg_lock);
+		fuse_uring_flush_bg(queue);
+		spin_unlock(&fc->bg_lock);
+	}
+
+	spin_unlock(&queue->lock);
 
 	if (error)
 		req->out.h.error = error;
@@ -79,6 +121,7 @@ void fuse_uring_abort_end_requests(struct fuse_ring *ring)
 {
 	int qid;
 	struct fuse_ring_queue *queue;
+	struct fuse_conn *fc = ring->fc;
 
 	for (qid = 0; qid < ring->nr_queues; qid++) {
 		queue = READ_ONCE(ring->queues[qid]);
@@ -86,6 +129,13 @@ void fuse_uring_abort_end_requests(struct fuse_ring *ring)
 			continue;
 
 		queue->stopped = true;
+
+		WARN_ON_ONCE(ring->fc->max_background != UINT_MAX);
+		spin_lock(&queue->lock);
+		spin_lock(&fc->bg_lock);
+		fuse_uring_flush_bg(queue);
+		spin_unlock(&fc->bg_lock);
+		spin_unlock(&queue->lock);
 		fuse_uring_abort_end_queue_requests(queue);
 	}
 }
@@ -191,6 +241,7 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
 	INIT_LIST_HEAD(&queue->ent_w_req_queue);
 	INIT_LIST_HEAD(&queue->ent_in_userspace);
 	INIT_LIST_HEAD(&queue->fuse_req_queue);
+	INIT_LIST_HEAD(&queue->fuse_req_bg_queue);
 
 	queue->fpq.processing = pq;
 	fuse_pqueue_init(&queue->fpq);
@@ -1139,6 +1190,53 @@ void fuse_uring_queue_fuse_req(struct fuse_iqueue *fiq, struct fuse_req *req)
 	fuse_request_end(req);
 }
 
+bool fuse_uring_queue_bq_req(struct fuse_req *req)
+{
+	struct fuse_conn *fc = req->fm->fc;
+	struct fuse_ring *ring = fc->ring;
+	struct fuse_ring_queue *queue;
+	struct fuse_ring_ent *ent = NULL;
+
+	queue = fuse_uring_task_to_queue(ring);
+	if (!queue)
+		return false;
+
+	spin_lock(&queue->lock);
+	if (unlikely(queue->stopped)) {
+		spin_unlock(&queue->lock);
+		return false;
+	}
+
+	list_add_tail(&req->list, &queue->fuse_req_bg_queue);
+
+	ent = list_first_entry_or_null(&queue->ent_avail_queue,
+				       struct fuse_ring_ent, list);
+	spin_lock(&fc->bg_lock);
+	fc->num_background++;
+	if (fc->num_background == fc->max_background)
+		fc->blocked = 1;
+	fuse_uring_flush_bg(queue);
+	spin_unlock(&fc->bg_lock);
+
+	/*
+	 * Due to bg_queue flush limits there might be other bg requests
+	 * in the queue that need to be handled first. Or no further req
+	 * might be available.
+	 */
+	req = list_first_entry_or_null(&queue->fuse_req_queue, struct fuse_req,
+				       list);
+	if (ent && req) {
+		fuse_uring_add_req_to_ring_ent(ent, req);
+		spin_unlock(&queue->lock);
+
+		fuse_uring_dispatch_ent(ent);
+	} else {
+		spin_unlock(&queue->lock);
+	}
+
+	return true;
+}
+
 static const struct fuse_iqueue_ops fuse_io_uring_ops = {
 	/* should be send over io-uring as enhancement */
 	.send_forget = fuse_dev_queue_forget,
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index 0517a6eafc9173475d34445c42a88606ceda2e0f..0182be61778b26a94bda2607289a7b668df6362f 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -82,8 +82,13 @@ struct fuse_ring_queue {
 	/* fuse requests waiting for an entry slot */
 	struct list_head fuse_req_queue;
 
+	/* background fuse requests */
+	struct list_head fuse_req_bg_queue;
+
 	struct fuse_pqueue fpq;
 
+	unsigned int active_background;
+
 	bool stopped;
 };
 
@@ -127,6 +132,7 @@ void fuse_uring_stop_queues(struct fuse_ring *ring);
 void fuse_uring_abort_end_requests(struct fuse_ring *ring);
 int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
 void fuse_uring_queue_fuse_req(struct fuse_iqueue *fiq, struct fuse_req *req);
+bool fuse_uring_queue_bq_req(struct fuse_req *req);
 
 static inline void fuse_uring_abort(struct fuse_conn *fc)
 {
@@ -179,6 +185,12 @@ static inline void fuse_uring_abort(struct fuse_conn *fc)
 static inline void fuse_uring_wait_stopped_queues(struct fuse_conn *fc)
 {
 }
+
+static inline bool fuse_uring_ready(struct fuse_conn *fc)
+{
+	return false;
+}
+
 #endif /* CONFIG_FUSE_IO_URING */
 
 #endif /* _FS_FUSE_DEV_URING_I_H */

-- 
2.43.0


