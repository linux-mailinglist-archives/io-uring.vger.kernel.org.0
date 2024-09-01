Return-Path: <io-uring+bounces-3008-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF27196772A
	for <lists+io-uring@lfdr.de>; Sun,  1 Sep 2024 17:09:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2EABC281E93
	for <lists+io-uring@lfdr.de>; Sun,  1 Sep 2024 15:09:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B96233CF7E;
	Sun,  1 Sep 2024 15:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="At9QoBci"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F204F446AB
	for <io-uring@vger.kernel.org>; Sun,  1 Sep 2024 15:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725203373; cv=fail; b=FV0q2pl/euQYPugAdoH6Hu9HzPOuP8x+nIYEmkC+XPlRQloAYjc1uhwFwJktIxVwkjLqlaIjDxcpVHQzB/wDi0L6SqpT+JiTlJQSB7pWn9aPgjEc8iMgz0SwqV4/zvqONkshikq8c7QC96xnDwY7jU/KDPLemd7J2RRvZjyvTBQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725203373; c=relaxed/simple;
	bh=iY2u27Lx75nk/Jbh8FJuFoTqdy1g9U9WNWFnLzjscRY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Y+0O6yml1fFjzOCIuFLMfCFEpDgv62loV+RDPQiq0FqQVJDEGrRUeZBz+EPcsEGilTL3NGymRb/L5ULvG1o/ln2hFzXNfnioi0CrmscHb8yTRuIdao95nFG7g0rEqk53DQ+t6DQLJSeOODP6AL+9RgmfwfRS4rPqMDkkbEkY8xQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=At9QoBci; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2173.outbound.protection.outlook.com [104.47.73.173]) by mx-outbound-ea22-15.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Sun, 01 Sep 2024 15:09:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pfnd6xdu4sNs6vigWshcM3jUAUxR4/frwtYVl6zlvXlPeVEsxAeRY9/P1NGvJ5JcdWYHrUWkPYLiuroC6UisHlVMxOt2DANIEdHRvqsmeP98FnSv8ICw+rWAIdxL6wR+U2RCScj1atI0z/5q8ZuwQw1xYHlvU+9UPrT1tG8jjs19rN9ka7zboV9NUlUixLKCRMWZ+TohvqpHJVrQO+FcVjFWs94LpSjJItZsK1x3TVWnz94sL2uDKKrTN8KBTArFLBs2SnloN/hRNxMDoscg6QarCRRoC1njnCupd6JENvKA+slqoTercOem6nK5pEAf9Ekftu00I3ICCDigGmjFIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H1tBy1zQLOJh/01sA2m8CZ71UkTSo5m8UsZlpi6fGcI=;
 b=DfdC+R+6uQ4PgkX7sOF6+2xrmrXr/NAM9cd3UKi+tBZLiJyhwR0GOLSTRZM9I2AFO5qz2r4+N/D2uweaIXnHgCShQd01tp4RyoxncYxy7stFSnJxUaD6tej9+cVoczderMDb8VnzXI3SLX/+32Acxm/X5DF2mSU8q7jVHYftYH7ioyJe7RvqIg4L43lKSFG+PwtDjlAysJG4Gq8M96yUEYGAPdLm6nxWiSJhYBlt9RRFYmJwac4deNoUGAAXt8Kh4JCuQSGH5cbr43qSXUa5wpJHO3LOMVhX8w3MRJoDSMpR5glBEfAgRcyotdDiJ0pqzeGbNCGBmCS5vwtLrUGobw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H1tBy1zQLOJh/01sA2m8CZ71UkTSo5m8UsZlpi6fGcI=;
 b=At9QoBcixCfYgp+cuVaDn8j3Y9UAwMldG/Q73Zk8gbcM+3/7Ql8zLshE8PxICbRCH5XSwib8udwuKrddhdfC2mgqDIH2l7xfm+2mV/LnHAY5VLiDToq/p9vW9d0JyVMUon4cM/ohsls+k2vWtmeCwx0WRSzpQdI2pn81mLb2Ml8=
Received: from PH8PR05CA0019.namprd05.prod.outlook.com (2603:10b6:510:2cc::25)
 by MN0PR19MB6066.namprd19.prod.outlook.com (2603:10b6:208:381::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23; Sun, 1 Sep
 2024 13:37:05 +0000
Received: from MWH0EPF000A6733.namprd04.prod.outlook.com
 (2603:10b6:510:2cc:cafe::ce) by PH8PR05CA0019.outlook.office365.com
 (2603:10b6:510:2cc::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24 via Frontend
 Transport; Sun, 1 Sep 2024 13:37:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 MWH0EPF000A6733.mail.protection.outlook.com (10.167.249.25) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.7918.13
 via Frontend Transport; Sun, 1 Sep 2024 13:37:05 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 77C9BD2;
	Sun,  1 Sep 2024 13:37:04 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Sun, 01 Sep 2024 15:37:01 +0200
Subject: [PATCH RFC v3 07/17] fuse: {uring} Add a dev_release exception for
 fuse-over-io-uring
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-7-9207f7391444@ddn.com>
References: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
In-Reply-To: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>, 
 Pavel Begunkov <asml.silence@gmail.com>, bernd@fastmail.fm
Cc: linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1725197817; l=3491;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=iY2u27Lx75nk/Jbh8FJuFoTqdy1g9U9WNWFnLzjscRY=;
 b=b6FPd+AMFMLVBA0vSwR1/RvE8baeZy+z+vp+wJI0ze+5O6cWrLuD3m7AeXThAqVdMm8hi4Z0V
 WL1TWe+pvHZCmZihtrp9DY7RZ6E5zKpN8GywLXpvVp18ONT2SN0UI+w
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6733:EE_|MN0PR19MB6066:EE_
X-MS-Office365-Filtering-Correlation-Id: 900c58cc-efbe-442a-1c61-08dcca8b2b22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VmN5UjNDdmVTdkJCZGdNSVNtZ29nL3lKMVZmaWFRd3hMREJXWFIrTFZRcnoz?=
 =?utf-8?B?dktRUFRvMHFhWkRWcWs4Q0p2MVdyMzVUa0ZJMUg3UEFobHVvcVQ0TVNaYWNQ?=
 =?utf-8?B?dmJ5WmtHM3Zlb0Q0dlIzSjQ2YXpKdUZoeTdsODhZNjh0TjBxUTF1bDJDczBP?=
 =?utf-8?B?NDdJTFN1ZjZWWVBSZFJScUVtV2JwUGU3RWU5a0ZzNzZGY09EY1Y0WnhBSGlZ?=
 =?utf-8?B?eVlvMFg3Wmc4eU8xSXJHT0lLbGF2TGo2MEowcmgwd01HeWJVRWdBblJlTEdp?=
 =?utf-8?B?aDhGL0RaNml4VVRLQUtzY3VBZ0VyYVB6Qk9EMkZBTTkwQTFFLzhQeWgwQ2Fo?=
 =?utf-8?B?QmJwK0FYZVBWS0MvYjBLMlRWWjlHeVJobHJmU0dkZ2RrWVhzbCtyR1BwUnJC?=
 =?utf-8?B?cVZySWVrS0xQTVBWSXBCcmt1WDRtd2hrNDBTWmdNR1ZoZjhRWXl6QUJsQ2hB?=
 =?utf-8?B?eEV5SzMzWmNETkFVNy9PaGJmdk9IdEVMd3hnNEQ5cDRVN3hwSWNObHRkSWxk?=
 =?utf-8?B?ZzZQaE9LOXNCT1RWcERYR2orZlBDN0dBM3BZeFloZXpaNk5lYjVLdE1RVmQ2?=
 =?utf-8?B?aTZtQkFrYUN3NmowNXZHQzFPSkVzZ3ZrMGdUUW1RSWxpenZLOFN0eEZKd3BJ?=
 =?utf-8?B?dGRHRDkyWWVHS2FmYW4xRU5adVRXTEFVc1lPNzZHci85cW03VnMvbDB6Ynh3?=
 =?utf-8?B?Q0VUM1AvQmUwa3ZMMjZmWGNuREhNWm5DTWtwcGduM1FMdHlXbWsydzdXMFRL?=
 =?utf-8?B?anBTWmRwb25Ra0JRYU9DVE5ROFczWGszZGZSVzdndVloZEpYZ1lXMUtLazFI?=
 =?utf-8?B?MmYwcnVkSE01VnMzOVFNcFJrZnM4NWFWRkt6SzR5anllTHNVTURsL2tDNnpG?=
 =?utf-8?B?MkdsYnVmZU13TmpnOHRjN1VLWHRMZ0l1SmNlS0ZKVzBSa0dwckhsUjdGQW4v?=
 =?utf-8?B?RVIrVWxOTU9ld3ZQZ1I3cFl5ZXc1b1ZwSzRaUE44VXFxR3o5TUFDaXdhYnN2?=
 =?utf-8?B?MEVvTThseUszTElLd05kNDduSE5mNWxKVUNRU1JZRGd4Q05TamhvbXVkaU53?=
 =?utf-8?B?TVpuOUpqaG9WSUNnbmNudVgwc0NseGtPYzJrbEUyVGV6R25uNEdjQSswUXRw?=
 =?utf-8?B?UldON0tFbkhDbGpGK0tnVnFyd1lxM08yZGJwUUhxVDZvdEhYS3JxWlFDcHJ4?=
 =?utf-8?B?K3ZTVDhLWEpNcEFsRmZ1TlA4RjJlNWQ2SXMydUFTbmU5VUxuUE80ZFQ4ZWlr?=
 =?utf-8?B?c0FJc2FDbkNGZWpic0t0Sy95bW5yU2NybFRkeStIOG9ldlVZKzlNSkhpU0VL?=
 =?utf-8?B?UWhMQStUUGRueEFqQWRtdHc4cUN3MStaMzU4M2VJQ29IRGxWckY3RmFXblJL?=
 =?utf-8?B?K3M2d0J6VFoyMGk1UGt4TWJFVnl3SkxjU0VSalZKVlhXTEpERjk4KzJDWWEx?=
 =?utf-8?B?MVBObm5ueXdjQTAwRk9oTnZPMEc3WWduQ0J5eDFudDZmcUpVeXlIZHdnckhG?=
 =?utf-8?B?VkhkWkhwb0JzaEVRQnYzcTdlQW1Cc1ZDZEs3RFFaZHgycWM4OXE3UzBnb2lt?=
 =?utf-8?B?bGZYc2FiSUE0d1pzYjZGanN2YTcySXZMR2h4bVZZK3gvWUVldDY2WS82eWlu?=
 =?utf-8?B?REhaNUNvSTI5OFN0b1FkbVVremhadEx1U1BpVFNTNGg5WHA5dkZ5T1NWR2JI?=
 =?utf-8?B?RG8rY3lFL2pFcTkwQXE2clpkaHFma0Y2b1JqcGJpZ0Q2dEl5aVU3YjArNlJl?=
 =?utf-8?B?aGNTK3dIWUxGMXh4dXBlblg0SmxGSDRZSVlNZHp6ZDZubWx3VlNmeXFBVkt2?=
 =?utf-8?B?Q255YVVVMStKbEhUK1plTmxYSCtlUzJXOGE4YlBDOTJDekZjcWFFNHVRd1Fz?=
 =?utf-8?B?MUpONng4MW1nOHpCTzNTY25TNkdxTnhWdSs3YUMyNmRYbnEvQzZJTzFtMXdW?=
 =?utf-8?Q?fKscIF3vz1R6caSXiSi3LuGQhdppQ0N5?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XjehkRUVJa3oL+/LItDSP1Hv+c9WuRfZgOBNxBnZiP3zaj4llPj98+joVy9wcik5cNT3mopOCexQgLHE/Pa6tdQebq3qqTExpIsQD8re1RFVWBXXiXr8XtNmG0g2IXbu7UGC1NJQuyfDUpNtwYYix7pYJ0HMttJS35RME2nKJYbnBhontZz7rFyLplEk0EyH5gv4A/yyU/R+nMdNw7svFm4eCUTT/Le/f4rlHWeWxbFq0feHm11XZCxdSDhSQiWeXmKWtEf2iw3mg9+1ViSxN+sFLmxsD8PBIE2rXH7BtuDy/VuStgXc7WBP2iD+y8fOsI/5ZrJz4nyGuUB42f8LTehVd5oU6J+a+VskaWNn06q+RjNdnrJZJ5ayMM05YGaMhCq1+ePsfHiSBUcXryhPgo/KoM8pj2u1f9YktgiFf2Sn7NgarsqDqnU/01YBufmemjmFzC7a2+k+xxax6RxFxZeS6WgX5l0CGO9GwO5a35EIKdaHVDWcZYW993cvSZCrBlA2p7op5vq/0QQc5RNAulgJ8vCMh/BKaca0jes/BCQow3sGd60eOwFQ8IwaVKnFHgCbrmYC/p/Ohyg9FB2/O1HBXojR9QNA3H1s0IiJJI+mjkuXHXPPIbRMTPQtgLPzfchn90JnOkR6uVBchepi/A==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2024 13:37:05.0657
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 900c58cc-efbe-442a-1c61-08dcca8b2b22
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6733.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR19MB6066
X-OriginatorOrg: ddn.com
X-BESS-ID: 1725203370-105647-14397-78717-1
X-BESS-VER: 2019.3_20240829.2013
X-BESS-Apparent-Source-IP: 104.47.73.173
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVsbGZqZAVgZQMDnF2DTJ0MI0NT
	XZyMjS3MgiNdHE0sI8ycDE3MDY3MRIqTYWAFoRZDlBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.258745 [from 
	cloudscan21-205.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC0_MISMATCH_TO, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

fuse-over-io-uring needs an implicit device clone, which is done per
queue to avoid hanging "umount" when daemon side is already terminated.
Reason is that fuse_dev_release() is not called when there are queued
(waiting) io_uring commands.
Solution is the implicit device clone and an exception in fuse_dev_release
for uring devices to abort the connection when only uring device
are left.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev.c         | 34 ++++++++++++++++++++++++++++++++--
 fs/fuse/dev_uring_i.h | 24 +++++++++++++++++-------
 2 files changed, 49 insertions(+), 9 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 06ea4dc5ffe1..fec995818a9e 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -2258,6 +2258,8 @@ int fuse_dev_release(struct inode *inode, struct file *file)
 		struct fuse_pqueue *fpq = &fud->pq;
 		LIST_HEAD(to_end);
 		unsigned int i;
+		int dev_cnt;
+		bool abort_conn = false;
 
 		spin_lock(&fpq->lock);
 		WARN_ON(!list_empty(&fpq->io));
@@ -2267,8 +2269,36 @@ int fuse_dev_release(struct inode *inode, struct file *file)
 
 		fuse_dev_end_requests(&to_end);
 
-		/* Are we the last open device? */
-		if (atomic_dec_and_test(&fc->dev_count)) {
+		/* Are we the last open device?  */
+		dev_cnt = atomic_dec_return(&fc->dev_count);
+		if (dev_cnt == 0)
+			abort_conn = true;
+
+#ifdef CONFIG_FUSE_IO_URING
+		/*
+		 * Or is this with io_uring and only ring devices left?
+		 * These devices will not receive a ->release() as long as
+		 * there are io_uring_cmd's waiting and not completed
+		 * with io_uring_cmd_done yet
+		 */
+		if (fuse_uring_configured(fc)) {
+			struct fuse_dev *list_dev;
+			bool all_uring = true;
+
+			spin_lock(&fc->lock);
+			list_for_each_entry(list_dev, &fc->devices, entry) {
+				if (list_dev == fud)
+					continue;
+				if (!list_dev->ring_q)
+					all_uring = false;
+			}
+			spin_unlock(&fc->lock);
+			if (all_uring)
+				abort_conn = true;
+		}
+#endif
+
+		if (abort_conn) {
 			WARN_ON(fc->iq.fasync != NULL);
 			fuse_abort_conn(fc);
 		}
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index 301b37d16506..26266f923321 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -15,10 +15,10 @@
 #define FUSE_URING_MAX_QUEUE_DEPTH 32768
 
 enum fuse_ring_req_state {
+	FRRS_INVALID = 0,
 
 	/* request is basially initialized */
-	FRRS_INIT = 1,
-
+	FRRS_INIT,
 };
 
 /* A fuse ring entry, part of the ring queue */
@@ -29,11 +29,8 @@ struct fuse_ring_ent {
 	/* array index in the ring-queue */
 	unsigned int tag;
 
-	/*
-	 * state the request is currently in
-	 * (enum fuse_ring_req_state)
-	 */
-	unsigned long state;
+	/* state the request is currently in */
+	enum fuse_ring_req_state state;
 };
 
 struct fuse_ring_queue {
@@ -108,6 +105,14 @@ fuse_uring_get_queue(struct fuse_ring *ring, int qid)
 	return (struct fuse_ring_queue *)(ptr + qid * ring->queue_size);
 }
 
+static inline bool fuse_uring_configured(struct fuse_conn *fc)
+{
+	if (fc->ring != NULL)
+		return true;
+
+	return false;
+}
+
 #else /* CONFIG_FUSE_IO_URING */
 
 struct fuse_ring;
@@ -121,6 +126,11 @@ static inline void fuse_uring_conn_destruct(struct fuse_conn *fc)
 {
 }
 
+static inline bool fuse_uring_configured(struct fuse_conn *fc)
+{
+	return false;
+}
+
 #endif /* CONFIG_FUSE_IO_URING */
 
 #endif /* _FS_FUSE_DEV_URING_I_H */

-- 
2.43.0


