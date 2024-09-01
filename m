Return-Path: <io-uring+bounces-2998-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BCD449676B1
	for <lists+io-uring@lfdr.de>; Sun,  1 Sep 2024 15:38:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 496CD1F216C4
	for <lists+io-uring@lfdr.de>; Sun,  1 Sep 2024 13:38:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29003183CAD;
	Sun,  1 Sep 2024 13:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="ZpQn4BRM"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765B9178389;
	Sun,  1 Sep 2024 13:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725197843; cv=fail; b=QHct1c+G83tL7ZtpmUjgkE559r3ZHyil6uWOiRD5CO09BIS/CGW2wZfnyZFgeXj+eU1B/dks34JcJP988cKegtEgYX9KJqj7qHTYSPIExQor4FmnK8/3j0iWOCz1FES/guW61eFoRZodlNOsc1bN3qA/sYcpASHTOp5YDX525hc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725197843; c=relaxed/simple;
	bh=w0NJq/l16y0S+J6XuJP4C9FZbMOgQfXOGxgt3ADtXEw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=r9R59fKZRpwyrENUujH7BE6vcuomwFkQZZ/PoSWtvNRY677mT5rSM2wqSYY2uRiaF0/zvHOPu7au+ncAngnquhhlWYsPy4InXqQ9y7FrL4jaDzDSjSVacDYdjx9vXrh30qFZk+hgxxjGG07SqPfhJeJE2SyS+OzX68G99srtaK8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=ZpQn4BRM; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175]) by mx-outbound10-30.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Sun, 01 Sep 2024 13:37:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h0DFG3MiWF0Yx+Fi0xSQk237Ku7tXq2o2IVHvTOpmK65J9r8pVo22bemWPF9ew0PZ6XHuACo4unVx1/Su3bQ3aoVlkSE2ZphGY5/jxG0HNBrTdA1GUZz3+np8k/6LSu9DXHSu3Oqa5/8zG7bmiSbuOnOTR5WRwNg0RaFmFZfpFnd9lqlYQvsX0U9IuLZiZZWWi1+r19/QwW19xNH/6Hwd14iJCoxwlRxQbbPLolAgAgrc6Ggk6J9CWNUZ9ThS+7AIaWsmgqdVfIIMhBfaaXeccHIagULfX2PF6lMvtAaN5LKFPC8/Mqdz2cLMsyq72d9lsYWqVImjxsPFedM5EZD1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q2WC8bx3EVBfO5DeBhJ0BHqJRiE4M/E88qGR0Ivt+ac=;
 b=OWvRW0Txqm8ZtNcP+YRyyJPT+TQPZDTUknLl2Rqef2P7/CGLjlODS8OCmgI4InZbRnHLZM1nqUg7vh5/6jWQD3CjSRQ8p98B2l0UCQMDP/38227+kivH0YWScnFAzRNoFFByvga6mHUfiJl6wLlzeArTa42ADP9Md3rAWb7v8NhZwEeZY5HrySzs2rrnWLtfIWRX4+WXukhrbQnZvTbD+S9iHNPCX4r43yE7KhP+ConO4hFf0AYX9tDGBBxgsBgGwWBSa+nXXOW+c9e8dlvS9qwcalZ2rFXa7bkuZlRRF74woNGkwfkk6HXJE9835vIEvjzv1yvGu9Hybqj0BHIttA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q2WC8bx3EVBfO5DeBhJ0BHqJRiE4M/E88qGR0Ivt+ac=;
 b=ZpQn4BRMfQHoaLKAVmFW1ut2KiS6/zc7B7Y+2rXOLHOpQCQw8XEgMopelAMxASnRI7jxAfp02F95Qw07NUp+fGJyU+Jy3A3SwvYMne9YB5kt0prxQzTvnSlGY1UrTj37pMl44PzrMW9mNWPILwYvjzILGI7FMNi7e5VHXe43mzs=
Received: from SA9PR13CA0101.namprd13.prod.outlook.com (2603:10b6:806:24::16)
 by DM4PR19MB7972.namprd19.prod.outlook.com (2603:10b6:8:186::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23; Sun, 1 Sep
 2024 13:37:09 +0000
Received: from SN1PEPF0002636C.namprd02.prod.outlook.com
 (2603:10b6:806:24:cafe::f) by SA9PR13CA0101.outlook.office365.com
 (2603:10b6:806:24::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23 via Frontend
 Transport; Sun, 1 Sep 2024 13:37:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SN1PEPF0002636C.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.7918.13
 via Frontend Transport; Sun, 1 Sep 2024 13:37:08 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 59FC972;
	Sun,  1 Sep 2024 13:37:08 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Sun, 01 Sep 2024 15:37:05 +0200
Subject: [PATCH RFC v3 11/17] fuse: {uring} Add uring sqe commit and fetch
 support
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-11-9207f7391444@ddn.com>
References: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
In-Reply-To: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>, 
 Pavel Begunkov <asml.silence@gmail.com>, bernd@fastmail.fm
Cc: linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1725197817; l=15001;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=w0NJq/l16y0S+J6XuJP4C9FZbMOgQfXOGxgt3ADtXEw=;
 b=MeknDXt2v16jma3yhcyhslsJ6GPMmnnIMZFpkhgzOqPfekrv6j4XzDd1667Wt2OJ5niqOiHuF
 rDf3n3qkEUdCEcqU1pdEyaBKdtYhKPF1m6YQHL0s/KqIHVXo/YmtdP4
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636C:EE_|DM4PR19MB7972:EE_
X-MS-Office365-Filtering-Correlation-Id: 08e4490e-8a5a-449f-d3fd-08dcca8b2d66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YTVwTkRQQk9CMyt0WnRHaFFTa1orNlp2ZXVKYnVDNWt6bE5WNmowdEFVUmNa?=
 =?utf-8?B?TmFvMlVIaExwSGxkbmNqOWc0TWJSdlF1dUJiemR1RlFyaXlsZHpBZ0dtbWhi?=
 =?utf-8?B?ZUxvM1ltY1ZPRHM2UFdva1oxcU9PQ1I2b1lpRHZLTzNpaWh2ajUxWXF1TnN0?=
 =?utf-8?B?N2dWUzNndllkaEYvMTJoUkRlNnZ2UzRRRjI1bmxNcW02SjltLzBjZU85cXJB?=
 =?utf-8?B?WUg1V2V3VDhRa3pVcVVmRkpDTngyVThjMXVPNlFiQkIwSnpwNEh1LzNnNmQ0?=
 =?utf-8?B?VkY1M0Z2VzRSM2NiN0htQlMyNlJuWHM4dkhJZXVWaklDbk9ReXcwQSs3bHVQ?=
 =?utf-8?B?Qm15dGVWdm40UTV3b2l4RW1oN2pyZ1JIcTdyc05ZYUJoUFBwMGlWRnJEZ003?=
 =?utf-8?B?TFpwMVdPZnZnUTAwUGF4S3FwWks4cnMrZ0QxQXM2L2hsVDl2UDhaQXhRZ2Fk?=
 =?utf-8?B?eDNQWWI4RDdxbS9CaFJPbHNJdEx4SWo5WkJyZkdtK1QwL1JFMGw0amxvamlX?=
 =?utf-8?B?UnZjdHUxN0JGbkdzekZITytBTityWHhyZm5EZGVNR3ZiZkhqWW1MREVzeFY3?=
 =?utf-8?B?dlJMd2g1a2lEOTQzakExZ2RjeWFIcXZVSVlIK3o4YmlTam9seERrMFdzaUcz?=
 =?utf-8?B?NDRUQm5zalpkRG5YTTBSQkZxOHBwTmdVcElKRTdMTW1KcTdZR0pVd2Z3a01C?=
 =?utf-8?B?bFJRYnRCVlJDa2hwbkF3bU1KUTNzZ0J4VDZVQVY0ck9Rc1lsS3Q3a3lZN0RG?=
 =?utf-8?B?N0hjQWl1bkQ1UTdtbWwrN0RxakZneVhiN1Y0RllKbHRDaGp6cERWTjBsK0N1?=
 =?utf-8?B?bE00WlhGM3Mvb3BxNi9tUmxpZmtyaGxJYStBa0Q5aGlrd1ZSZnJBR0lEL3hD?=
 =?utf-8?B?Z3Q2bzZzZmdvN0NtV1lwOGl4YWRZV2NPMWJ6VG1zenh0NnAxK3RlOVJIVzRL?=
 =?utf-8?B?aEovVlF5N2FKRUdYdlh6eUlZbG5NWk9YUk96ZVFwL0F3d0IydkxrUFE0QWxS?=
 =?utf-8?B?ZFIyRUZEcDF1YmdEOURnaFNaUUFoMU5aUjNmazd3cG8yRlMxbitUNGZ0MFZi?=
 =?utf-8?B?c0EwQXdSMytuY0dkekZraDBlS01OZER0NHk1VUlVSkQ0Y1pjd0FCTjVMVGho?=
 =?utf-8?B?UHhON0lmNEZESEZzQW9TdDV3Z0JycDVGY0p1Zml0Y0VxL2NydzFuaXRCVmVN?=
 =?utf-8?B?Y0x0SHVPYlI4QVVCOVh6QjNsTFc4cUxCSmV0RjhYU3UwQUIzSXIxU1NZV0Rx?=
 =?utf-8?B?aHJVd09PRnRJMGRwNHo1QzkrTE5RM3lwSHNvYXFrRW5ZSTlNdXNMbFFRVk1Z?=
 =?utf-8?B?dkYxVXc0V1VtRUpORlUxUWgzZ1NHbndENjZ4NXNmRFhHcXZDbm9DODdoOHE2?=
 =?utf-8?B?UDMxVFBzSERxdVp3ZFQwKzdjTW1aUVgyRnRXdDlpNVpZVGhUcnl6K0pSM3JU?=
 =?utf-8?B?MXpINFJLZTVvQXBNREU4LzZjRDZMVXNkeXM4TllXdERUNUt2d0wrSENMdWRG?=
 =?utf-8?B?clk1d0RHSEhqQ2dzVXNEU0RrV0ZlNHlIczdGMWhTMEVZVk1xdzBWUXFxaCtG?=
 =?utf-8?B?TE5UWDdQZExqNit5QjU0MUpHNHFrSTQ0eG5lczVmckFHamVHTEJkYy81TnRP?=
 =?utf-8?B?WFE4WlZQaUZQTVIrdlFnWVcyd1hWN3NEK2ZiVzd6MEl4MUxlVnVqZkI3cGd2?=
 =?utf-8?B?cTNWREkvZlROUlFjWEJMVmdWZXUzV1RaTVd5ekswRk94dzQ5MUxBeDhpVm9G?=
 =?utf-8?B?di95aDlTM2pBTFpPajh3K2hjY3YyY0Izd2FCckNLWnc0UVV6ZHYvSEdVRDAw?=
 =?utf-8?B?WXJ1NlZ3YUlQdEZtNVdqZk1DM3UvRnFGcXZJSE1zWVpzdndUMk9VSlB4ako1?=
 =?utf-8?B?V2dNVzVxMUhZQXczSlZybEptQWZuTjhpbXd0Qm45SDBEVlhPWGNLTU9Yazcy?=
 =?utf-8?Q?S0Hbkwdqk62rpZRVh4n6MH/2efrrId+c?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	on6GYrdyO+/Rz6dXFNBAmR91jrmY7TfipeCyaAiSz1zWRuUhkwEJNfY+9gFrlZCttBcfsFbtz+szWAHK8DOmTJKp3tBxpkCcmC2eWKfATUeXOOjDVE/ImB4JPTw5JzTgN2000zbrSSRBGOHifrwo9REpLwimdhD907ujrGzB1erVRs0nRXNRNWRT/xJFJrHlYdO32vbPJMGTkDClz/G6GW7X5akf71QoKKZD13Oesmjc2krWGvt+ZV8eKxcVH05gCIRmeqQnvyKAW3L/gDlZVu92Zpb7lzn78p5O3gW7jMEDduoDtNKaLEXL/lv4l8nlSm/trpVgPJ4YaL3H0cgcZw6/at9mEY4MUzqr+X/94c1ELfyQr2wyZ8j7q328/qq2G1qLzlx6OK60sWGJP44NE8XWD2vahjRtKiNcENaH9GteZRUCP4PhkQwUJvMvSjhqhbaTs6jyAszKz3EPYZ15usa/sclWvbH2JnYmfHs/CbYmJGnd/R6SA0cITaAZw2qOVxhs7e45+IbzD5bxPGoRO+TxDm1zcYjqloC8aBKpZvuI5XwpWhySey3GStZ6gg55OGcARZ271lBciEaxAwzpZQxsMZoV6bk368LkEEDjzM4CSpahPht+GTy47oXT03LcMo6evw28ionMnjHSm/+jFQ==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2024 13:37:08.9964
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 08e4490e-8a5a-449f-d3fd-08dcca8b2d66
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR19MB7972
X-BESS-ID: 1725197830-102590-12632-7784-1
X-BESS-VER: 2019.1_20240829.0001
X-BESS-Apparent-Source-IP: 104.47.55.175
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoYmJuYmQGYGUNTA1DTF3MzM0D
	TV2MAiOTHVxNQ82cAw0dLS0NQi0cjUTKk2FgAlzCdEQgAAAA==
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.258743 [from 
	cloudscan23-211.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
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
 fs/fuse/dev_uring.c   | 407 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h |  21 +++
 2 files changed, 428 insertions(+)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 46c2274193bf..96347751668e 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -29,6 +29,26 @@
 #include <linux/topology.h>
 #include <linux/io_uring/cmd.h>
 
+struct fuse_uring_cmd_pdu {
+	struct fuse_ring_ent *ring_ent;
+};
+
+/*
+ * Finalize a fuse request, then fetch and send the next entry, if available
+ */
+static void fuse_uring_req_end(struct fuse_ring_ent *ring_ent,
+			       bool set_err, int error)
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
 static int fuse_ring_ring_ent_unset_userspace(struct fuse_ring_ent *ent)
 {
 	if (WARN_ON_ONCE(ent->state != FRRS_USERSPACE))
@@ -40,6 +60,13 @@ static int fuse_ring_ring_ent_unset_userspace(struct fuse_ring_ent *ent)
 	return 0;
 }
 
+static void
+fuse_uring_async_send_to_ring(struct io_uring_cmd *cmd,
+			      unsigned int issue_flags)
+{
+	io_uring_cmd_done(cmd, 0, 0, issue_flags);
+}
+
 /* Update conn limits according to ring values */
 static void fuse_uring_conn_cfg_limits(struct fuse_ring *ring)
 {
@@ -65,6 +92,9 @@ static void fuse_uring_queue_cfg(struct fuse_ring_queue *queue, int qid,
 
 	INIT_LIST_HEAD(&queue->sync_ent_avail_queue);
 	INIT_LIST_HEAD(&queue->async_ent_avail_queue);
+	INIT_LIST_HEAD(&queue->ent_in_userspace);
+	INIT_LIST_HEAD(&queue->sync_fuse_req_queue);
+	INIT_LIST_HEAD(&queue->async_fuse_req_queue);
 
 	for (tag = 0; tag < ring->queue_depth; tag++) {
 		struct fuse_ring_ent *ent = &queue->ring_ent[tag];
@@ -173,6 +203,200 @@ int fuse_uring_conn_cfg(struct file *file, void __user *argp)
 	return res;
 }
 
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
+	pr_devel("%s:%d err=%d op=%d req-ret=%d", __func__, __LINE__, err,
+		 req->args->opcode, req->out.h.error);
+	return err;
+}
+
+static int fuse_uring_copy_from_ring(struct fuse_ring *ring,
+				     struct fuse_req *req,
+				     struct fuse_ring_ent *ent)
+{
+	struct fuse_ring_req __user *rreq = ent->rreq;
+	struct fuse_copy_state cs;
+	struct fuse_args *args = req->args;
+	struct iov_iter iter;
+	int err;
+	int res_arg_len;
+
+	err = copy_from_user(&res_arg_len, &rreq->in_out_arg_len,
+			     sizeof(res_arg_len));
+	if (err)
+		return err;
+
+	err = import_ubuf(ITER_SOURCE, (void __user *)&rreq->in_out_arg,
+			  ent->max_arg_len, &iter);
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
+	struct fuse_ring_req __user *rreq = ent->rreq;
+	struct fuse_copy_state cs;
+	struct fuse_args *args = req->args;
+	int err, res;
+	struct iov_iter iter;
+
+	err = import_ubuf(ITER_DEST, (void __user *)&rreq->in_out_arg,
+			  ent->max_arg_len, &iter);
+	if (err) {
+		pr_info("Import user buffer failed\n");
+		return err;
+	}
+
+	fuse_copy_init(&cs, 1, &iter);
+	cs.is_uring = 1;
+	cs.req = req;
+	err = fuse_copy_args(&cs, args->in_numargs, args->in_pages,
+			     (struct fuse_arg *)args->in_args, 0);
+	if (err) {
+		pr_info("%s fuse_copy_args failed\n", __func__);
+		return err;
+	}
+
+	BUILD_BUG_ON((sizeof(rreq->in_out_arg_len) != sizeof(cs.ring.offset)));
+	res = copy_to_user(&rreq->in_out_arg_len, &cs.ring.offset,
+			   sizeof(rreq->in_out_arg_len));
+	err = res > 0 ? -EFAULT : res;
+
+	return err;
+}
+
+static int
+fuse_uring_prepare_send(struct fuse_ring_ent *ring_ent)
+{
+	struct fuse_ring_req *rreq = ring_ent->rreq;
+	struct fuse_ring_queue *queue = ring_ent->queue;
+	struct fuse_ring *ring = queue->ring;
+	struct fuse_req *req = ring_ent->fuse_req;
+	int err = 0, res;
+
+	if (WARN_ON(ring_ent->state != FRRS_FUSE_REQ)) {
+		pr_err("qid=%d tag=%d ring-req=%p buf_req=%p invalid state %d on send\n",
+		       queue->qid, ring_ent->tag, ring_ent, rreq,
+		       ring_ent->state);
+		err = -EIO;
+	}
+
+	if (err)
+		return err;
+
+	pr_devel("%s qid=%d tag=%d state=%d cmd-done op=%d unique=%llu\n",
+		 __func__, queue->qid, ring_ent->tag, ring_ent->state,
+		 req->in.h.opcode, req->in.h.unique);
+
+	/* copy the request */
+	err = fuse_uring_copy_to_ring(ring, req, ring_ent);
+	if (unlikely(err)) {
+		pr_info("Copy to ring failed: %d\n", err);
+		goto err;
+	}
+
+	/* copy fuse_in_header */
+	res = copy_to_user(&rreq->in, &req->in.h, sizeof(rreq->in));
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
+
+	err = fuse_uring_prepare_send(ring_ent);
+	if (err)
+		goto err;
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
@@ -206,6 +430,166 @@ static void fuse_uring_ent_avail(struct fuse_ring_ent *ring_ent,
 	ring_ent->state = FRRS_WAIT;
 }
 
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
+		pr_warn("%s qid=%d tag=%d state=%d async=%d\n", __func__,
+			ring_ent->queue->qid, ring_ent->tag, ring_ent->state,
+			ring_ent->async);
+	}
+	list_del_init(&req->list);
+	clear_bit(FR_PENDING, &req->flags);
+	ring_ent->fuse_req = req;
+	ring_ent->state = FRRS_FUSE_REQ;
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
+	struct list_head *req_queue = ring_ent->async ?
+					      &queue->async_fuse_req_queue :
+					      &queue->sync_fuse_req_queue;
+
+	lockdep_assert_held(&queue->lock);
+
+	/* get and assign the next entry while it is still holding the lock */
+	if (!list_empty(req_queue)) {
+		req = list_first_entry(req_queue, struct fuse_req, list);
+		fuse_uring_add_req_to_ring_ent(ring_ent, req);
+		list_del_init(&ring_ent->list);
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
+	struct fuse_ring_req *rreq = ring_ent->rreq;
+	struct fuse_req *req = ring_ent->fuse_req;
+	ssize_t err = 0;
+	bool set_err = false;
+
+	err = copy_from_user(&req->out.h, &rreq->out, sizeof(req->out.h));
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
+	WARN_ON_ONCE(!list_empty(&ring_ent->list));
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
+		if (err) {
+			ring_ent->state = prev_state;
+			continue;
+		}
+
+		err = 0;
+		spin_lock(&queue->lock);
+		ring_ent->state = FRRS_USERSPACE;
+		list_add(&ring_ent->list, &queue->ent_in_userspace);
+		spin_unlock(&queue->lock);
+	} while (err);
+}
+
+/* FUSE_URING_REQ_COMMIT_AND_FETCH handler */
+static int fuse_uring_commit_fetch(struct fuse_ring_ent *ring_ent,
+				   struct io_uring_cmd *cmd, int issue_flags)
+__releases(ring_ent->queue->lock)
+{
+	int err;
+	struct fuse_ring_queue *queue = ring_ent->queue;
+	struct fuse_ring *ring = queue->ring;
+
+	err = -ENOTCONN;
+	if (unlikely(!ring->ready)) {
+		pr_info("commit and fetch, but fuse-uring is not ready.");
+		return err;
+	}
+
+	err = -EALREADY;
+	if (ring_ent->state != FRRS_USERSPACE) {
+		pr_info("qid=%d tag=%d state %d SQE already handled\n",
+			queue->qid, ring_ent->tag, ring_ent->state);
+		return err;
+	}
+
+	fuse_ring_ring_ent_unset_userspace(ring_ent);
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
@@ -250,6 +634,7 @@ __must_hold(ring_ent->queue->lock)
 	return 0;
 }
 
+/* FUSE_URING_REQ_FETCH handler */
 static int fuse_uring_fetch(struct fuse_ring_ent *ring_ent,
 			    struct io_uring_cmd *cmd, unsigned int issue_flags)
 	__releases(ring_ent->queue->lock)
@@ -339,10 +724,32 @@ int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	if (unlikely(fc->aborted || queue->stopped))
 		goto err_unlock;
 
+	ring_ent->rreq = (void __user *)cmd_req->buf_ptr;
+	ring_ent->max_arg_len = cmd_req->buf_len -
+				offsetof(struct fuse_ring_req, in_out_arg);
+	ret = -EINVAL;
+	if (cmd_req->buf_len < ring->req_buf_sz) {
+		pr_info("Invalid req buf len, expected: %zd got %d\n",
+			ring->req_buf_sz, cmd_req->buf_len);
+		goto err_unlock;
+	}
+
+	ring_ent->rreq = (void __user *)cmd_req->buf_ptr;
+	ring_ent->max_arg_len = cmd_req->buf_len -
+				offsetof(struct fuse_ring_req, in_out_arg);
+	if (cmd_req->buf_len < ring->req_buf_sz) {
+		pr_info("Invalid req buf len, expected: %zd got %d\n",
+			ring->req_buf_sz, cmd_req->buf_len);
+		goto err_unlock;
+	}
+
 	switch (cmd_op) {
 	case FUSE_URING_REQ_FETCH:
 		ret = fuse_uring_fetch(ring_ent, cmd, issue_flags);
 		break;
+	case FUSE_URING_REQ_COMMIT_AND_FETCH:
+		ret = fuse_uring_commit_fetch(ring_ent, cmd, issue_flags);
+		break;
 	default:
 		ret = -EINVAL;
 		pr_devel("Unknown uring command %d", cmd_op);
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index 6561f4178cac..697963e5d524 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -26,6 +26,9 @@ enum fuse_ring_req_state {
 	/* The ring request waits for a new fuse request */
 	FRRS_WAIT,
 
+	/* The ring req got assigned a fuse req */
+	FRRS_FUSE_REQ,
+
 	/* request is in or on the way to user space */
 	FRRS_USERSPACE,
 };
@@ -47,6 +50,17 @@ struct fuse_ring_ent {
 	struct list_head list;
 
 	struct io_uring_cmd *cmd;
+
+	/* fuse_req assigned to the ring entry */
+	struct fuse_req *fuse_req;
+
+	/*
+	 * buffer provided by fuse server
+	 */
+	struct fuse_ring_req __user *rreq;
+
+	/* struct fuse_ring_req::in_out_arg size*/
+	size_t max_arg_len;
 };
 
 struct fuse_ring_queue {
@@ -69,6 +83,13 @@ struct fuse_ring_queue {
 	struct list_head async_ent_avail_queue;
 	struct list_head sync_ent_avail_queue;
 
+	/* fuse fg/bg request types */
+	struct list_head async_fuse_req_queue;
+	struct list_head sync_fuse_req_queue;
+
+	/* entries sent to userspace */
+	struct list_head ent_in_userspace;
+
 	/*
 	 * available number of sync requests,
 	 * loosely bound to fuse foreground requests

-- 
2.43.0


