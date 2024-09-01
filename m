Return-Path: <io-uring+bounces-3004-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43B2F967708
	for <lists+io-uring@lfdr.de>; Sun,  1 Sep 2024 16:12:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB2CD281F5C
	for <lists+io-uring@lfdr.de>; Sun,  1 Sep 2024 14:12:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12FB018132F;
	Sun,  1 Sep 2024 14:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="1k0DCccb"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3075014A4FF
	for <io-uring@vger.kernel.org>; Sun,  1 Sep 2024 14:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725199922; cv=fail; b=ksknuTgSpkns4zjtrKwfw/lGqBYB4wQ+ojgGpqAMr3b86HVoobbXj3fhHIrgfnfE6/nEh0VZNemgEAUlCa0XMKrTNOFiuY0MIy4ZZoCRAzBgbu1FLNi+qK+Su1BXToXDHjOjF44gyF8/Or5S29yP2y5dNycU+UjEDD6NCqHuvnI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725199922; c=relaxed/simple;
	bh=48GPYOKOv8QstAokuDa8NlonP/TjSLahD8Y3o5cLiWU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=i83ezMBwGVSMuTedjkJJo8SWgTWnzgCetlMbeGQryMbiP3mhIgv1l5AwVDOsaFhdVD32s24OFBfUzFRO02KmrAShHQof6pGMQcqG74KQ5ylbiSn1e2eh1TNhIzuk7qPEEB7an50thCUyd4n/h3+CqAFgniABf1C0oB706+2L3NA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=1k0DCccb; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2040.outbound.protection.outlook.com [104.47.51.40]) by mx-outbound45-16.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Sun, 01 Sep 2024 14:11:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LGldjW+pdnw382ICfhaKojonegL6xgGsl5HOIfTR7XJVyhH9NmYZOMlG4xdMF1GSMs1CIq+9OoM5pPIBGvnClNPU0iuC/TVg2xXDll8ZuQuzUTLn/ofXg4mh00Ei6XlI3z8yp3EqR/29FsKicvIhRmJqnKM30l9g98Pm9Q/LDcw/wqR9UzmVtMlmKrjWwDaKy+xxHmvLqaaej+PEH+7MHY62Vqe2hqnupS2QMWiyWJyr2Xyj4MKpQ4B24ZRQN1/WPvVaWNXAvcGCdcqoeC4WV6MRlm729RsWQIBVy7jkfV8EjG5kkSELMM4KPjcPWs8+v5qdBhnGHNlTd6jXHKLG5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HQOtdUiFVUeg27JJdVwU6S2ZUaMwoGj91RAVXoW+FYo=;
 b=ig0pHTD2DAeGozWCnV8QM5ewQGfQRB7Uf+aO67YIwxD4qD8x4rYzX2DC9zu6HyNk5zMT9ek+QgOUpFTV2vZxuzfegncjrkn/VcHgqrRQa0rIvWWeCroyskuZbcKIN6stlzGBq3MymGk1vWxZFdAisqEPaypuPhJ4ORKlZP3KH/D5u9F39WOnP97ZARYYwo/A7JHqHJDGz6k5j/Pt10BCbqDYh5gDCyUL6RBCDPh4Bga3txstC7N8G61E9pD7D4C/waJ5lwSvVbKH4c1j+uohqDhWW6p/R0E4EJBN0iDVy56kG+yyguebFb3ZgO7FbjeVdiXsN8b4GUODmLf8twaI9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HQOtdUiFVUeg27JJdVwU6S2ZUaMwoGj91RAVXoW+FYo=;
 b=1k0DCccbhRsrIs88UJmI0oQmqGpZjxw88FiMcUawoV4fgK1kUmF8VM/J7pFPaUEYlc3MeQ19VAcx0vfUUtGelled/QCByfyHcWx2qE8BHhK+q6vzGKLrjvqsLIXENVaAT5jVk9rDEQmmg3wxcig64jI9YiZT8YaLbiRBFXdUPNA=
Received: from SJ0PR05CA0081.namprd05.prod.outlook.com (2603:10b6:a03:332::26)
 by PH7PR19MB5750.namprd19.prod.outlook.com (2603:10b6:510:1d1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23; Sun, 1 Sep
 2024 13:37:11 +0000
Received: from SJ5PEPF000001CA.namprd05.prod.outlook.com
 (2603:10b6:a03:332:cafe::b4) by SJ0PR05CA0081.outlook.office365.com
 (2603:10b6:a03:332::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24 via Frontend
 Transport; Sun, 1 Sep 2024 13:37:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SJ5PEPF000001CA.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.7918.13
 via Frontend Transport; Sun, 1 Sep 2024 13:37:10 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 4B26372;
	Sun,  1 Sep 2024 13:37:10 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Sun, 01 Sep 2024 15:37:07 +0200
Subject: [PATCH RFC v3 13/17] fuse: {uring} Add a ring queue and send
 method
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-13-9207f7391444@ddn.com>
References: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
In-Reply-To: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>, 
 Pavel Begunkov <asml.silence@gmail.com>, bernd@fastmail.fm
Cc: linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1725197817; l=4710;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=48GPYOKOv8QstAokuDa8NlonP/TjSLahD8Y3o5cLiWU=;
 b=UScpLiDFoG2eYQJr7xRap+gaF572Z5o5JdLBVXHRhwA0nNLk6nQcaPDaFp6Z2C6+SUNNKCA5F
 /WvOtmURGw8DbDogm7V/S+NYAVTsELyHp8rnOFa0dy+KhUeW6wgBiCE
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CA:EE_|PH7PR19MB5750:EE_
X-MS-Office365-Filtering-Correlation-Id: c1acfc8e-f83d-40df-0479-08dcca8b2e9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V2tQdUpzWWJEVFhPS2ltbGdHQUF0T0ZLYWlKaDdvUU9aZGRFeDFoeWlxRHhW?=
 =?utf-8?B?Szl5azZabXdBRmFicUd6dTgrWUpsSDhjckVzUXl0cFdocTg1YWhJa1ZKT1l4?=
 =?utf-8?B?N1YyZ2JrN3R6aHlnVm1RaFFqT1JQQ25JaktML2hoVXlNRG0vU2tPTFd0cERq?=
 =?utf-8?B?ZXphOFhpVnRpOHliRXhlMXl3VlNaa1dJUnV4M2laNC9iT3BNbXlTekFURmdX?=
 =?utf-8?B?bDMzcjc2UktvMTJtM0F2SXhDT0p1QVR5eThEcFQyVnBRS2dkbjFOVkc3NEdK?=
 =?utf-8?B?akliSUNqMWEvSGJ3M0lFNitDZDZLVGVEVStjdmZDNWdtelJrKzhKL0pTbm04?=
 =?utf-8?B?MG5yM1RBaVVYTC9uaHkydjJYZjltNjE3aEs3R1dMdmg0MGdBRGpnbC8zb2xZ?=
 =?utf-8?B?RnRja09UVzlSSHlrZjJIdE01RC85NVg5eERicnJoQjBielZHSzJoTjFhbTVn?=
 =?utf-8?B?NGpZcTIxQW9yNnJkRjZEdFIxWFAwTzFKcmlJSEliM2pKRFUwa1Q4dmNVZWNC?=
 =?utf-8?B?SkNqa08yUkFtZzdVcDd2WnU0dFpKc3YwQzZuMDlqclBYZEJLR3JPU0FBMThq?=
 =?utf-8?B?SkpMUG1sV21KQ2pNQU41TVNCNllLSlliaG5jd05ocTdzclZIZldVMlZOSDRz?=
 =?utf-8?B?OUNlb1pNNUpaRWdkZnEvaGpKVi9Pd0tnOWJvUW5zbG9mUUJ4bDhOeThQWFJH?=
 =?utf-8?B?WHZDbGEwS2lrTWFwNlFCT2tKczVUMS8xOFhRQUQyK2RJMDFDZEpFaEZUQnAv?=
 =?utf-8?B?QUZrTXF5c2JiODVWRW94WXQ5a3dMZmFkY2Q1NFVQNlVTWVQxRG8yN283M0JJ?=
 =?utf-8?B?WU5xODB6Y2Y2QTBCNHlHNEx2QnpwdEZjK1hjNGR6WkRGRUZOTGo2K3pnZjVw?=
 =?utf-8?B?T3pKcnNjbUNobHVTM3dvS3dlWURFVGM4WU1pS2Z2WC8xSEc1a1llNGZFRFlh?=
 =?utf-8?B?OFE5aVRoZDQwUGh0aVZGcUFqQTVtYTFGZ3NhNUhVbkxmNkFpb3lRN2JIdlF0?=
 =?utf-8?B?bDh1ZlRNWDBrQjEzVWJweWVTSXRLdzhVMGhqY3FQeFBBU0hqVjNzeGQzYWdO?=
 =?utf-8?B?Z2hEcEQxeE9zc3pKT051YnRYK2JucGZSNTdjdjR6RVlHMXF4ZEZPUHUwMGZx?=
 =?utf-8?B?Q0lxZTlCZXBqZEswbW05b1loMGxZd3pRZGdBVTQyVHBZQjlSK04xOWZyRXZZ?=
 =?utf-8?B?TVNQdDFmMk16OXNZalNlSXREay9oZW8zc1ZZbmdBVmkwR01iT1ZJYWZubFVR?=
 =?utf-8?B?UFlqUzBZcmhQUk53NFJFRGJmMXpoc2lXV3N4TWI3cGlqVGJCNUY3RFM2a0VV?=
 =?utf-8?B?RnRWZCtoN2xqcVZqVmtnNXJXdkZra0ozZmx3OUZlMDF1WFhZZXd6UkRSSXRF?=
 =?utf-8?B?Ny9BdVBDZUhNc0EvUEU5YUJKTXNvRlFZNjFqZUtkMktsZFl1TG1qUkw3WWJs?=
 =?utf-8?B?ME5Dc1l2QTFOTCt4T00yN2xVRDZyLzEzbjF4a2VCNmw3eGFCaUZRaS9Jc0VU?=
 =?utf-8?B?K3BqRnpFVjBDNklSYUR5WmF2ZWxzMFhydlJCU2JwRjB4L2xQUUkzT2lQbDVL?=
 =?utf-8?B?NkZVaTZERzJYZjRiWm1vQ0hiaEh2K2gwSThYdHFWVHNpNXVvaWRwSEp0S2p3?=
 =?utf-8?B?dlI1WHdkb2JoeHQ2WmhDR0NLSDBQTTNudmppMWhid0E0VHRhTXpMR3FESHRT?=
 =?utf-8?B?UEpwbDUyc0ZzcVlsd1JrTzAxSTV1TmkyM0UwKzdpWkJ2Y3BySEpTZHo3NER2?=
 =?utf-8?B?c0hsVDlnT1BOOFpQYkpPWmFlM2ZUdlZ5MHg3TmR5WnhFU0dQV2lONDZZRmFH?=
 =?utf-8?B?OEV5S2prQmxvL2lFWEdITWhjdE15R0JGWVpNSzluT05uU3Y3aDJzWFJaYlVG?=
 =?utf-8?B?dTRxblh6Yk9haVBNUVZNdmFNeThrTmhib2VucTBSVk8yaXF4VHYvdlhyQXRW?=
 =?utf-8?Q?WUJQHVgnB+GuGFKO4uTn7sQbPF5rYXzk?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	e4SAmlVj6P7sIvaXZB8jUcRLri4pjT8QGz8rqP+4hMoldIsHoRN3X56vRlMPJUM13E18uKi4b9a7yeW3ybMut+Gy5oO4tvXWOrecA60HayEwTniVpBo1qumD+U/Kw2QE78oo9O4uDd/yjt4wx7MmfR+NuumsQRTl8AC31PcC+fwSe9Xt51+GxU09sNAJ9tB+ZpKJ/X9fVlFNwPywcfjAKDE+6o40XaBbrkON0gNe0h6TuAi0SlG6D1ZQAQjDHZx6q5J5+0fQE0Yi/beWLB/Qxz7Jtgnz62ERHeWd9Soce0yGGw04qtyT8u+NUSxARaitoQDgSqA9gePkg3GXc1CPOsB037nsw/hkwkKWBTrGJaLzUcG7uqqrW0lS5ex1JFS38yY5k9rKL+QlL1h0hJ85zqBQvx51irTjCh0OsJ1y7iId7twDvXpWX+jNF0a6ItXm2p3LuYZISafWkj4XmkFZyodVqczr1UJIRNCNXqYvzJT0HmGM6ou+OysH25KIaAwGvr42UA0yXvEhlR+VcmRZ9E3RRf+HyC7pFoygo+9X/u+XzNsmUPnEOiMzkQ/5JJdhbRttymssisKdFuDeEDsERVFUSOw6dWWf6YV6W4u3kjotQtixR0LfM9boP0KnDP0pSzjrB/SJggykFylySaPRcg==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2024 13:37:10.9850
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c1acfc8e-f83d-40df-0479-08dcca8b2e9b
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR19MB5750
X-OriginatorOrg: ddn.com
X-BESS-ID: 1725199918-111536-13527-71134-1
X-BESS-VER: 2019.1_20240829.0001
X-BESS-Apparent-Source-IP: 104.47.51.40
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKViamZsZAVgZQ0CzNwjjJNNHSwN
	IiMTkxxcLSLC0xzTLFwNzAIs0wNclSqTYWALB0aLpBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.258744 [from 
	cloudscan22-227.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND, BSF_SC0_MISMATCH_TO
X-BESS-BRTS-Status:1

This prepares queueing and sending through io-uring.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev_uring.c   | 104 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h |   7 ++++
 2 files changed, 111 insertions(+)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 52e2323cc258..43e7486d9f93 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -975,3 +975,107 @@ int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	spin_unlock(&queue->lock);
 	goto out;
 }
+
+/*
+ * This prepares and sends the ring request in fuse-uring task context.
+ * User buffers are not mapped yet - the application does not have permission
+ * to write to it - this has to be executed in ring task context.
+ * XXX: Map and pin user paged and avoid this function.
+ */
+static void
+fuse_uring_send_req_in_task(struct io_uring_cmd *cmd,
+			    unsigned int issue_flags)
+{
+	struct fuse_uring_cmd_pdu *pdu = (struct fuse_uring_cmd_pdu *)cmd->pdu;
+	struct fuse_ring_ent *ring_ent = pdu->ring_ent;
+	struct fuse_ring_queue *queue = ring_ent->queue;
+	int err;
+
+	BUILD_BUG_ON(sizeof(pdu) > sizeof(cmd->pdu));
+
+	err = fuse_uring_prepare_send(ring_ent);
+	if (err)
+		goto err;
+
+	io_uring_cmd_done(cmd, 0, 0, issue_flags);
+
+	spin_lock(&queue->lock);
+	ring_ent->state = FRRS_USERSPACE;
+	list_add(&ring_ent->list, &queue->ent_in_userspace);
+	spin_unlock(&queue->lock);
+
+	return;
+err:
+	fuse_uring_next_fuse_req(ring_ent, queue);
+}
+
+/* queue a fuse request and send it if a ring entry is available */
+int fuse_uring_queue_fuse_req(struct fuse_conn *fc, struct fuse_req *req)
+{
+	struct fuse_ring *ring = fc->ring;
+	struct fuse_ring_queue *queue;
+	int qid = 0;
+	struct fuse_ring_ent *ring_ent = NULL;
+	int res;
+	bool async = test_bit(FR_BACKGROUND, &req->flags);
+	struct list_head *req_queue, *ent_queue;
+
+	if (ring->per_core_queue) {
+		/*
+		 * async requests are best handled on another core, the current
+		 * core can do application/page handling, while the async request
+		 * is handled on another core in userspace.
+		 * For sync request the application has to wait - no processing, so
+		 * the request should continue on the current core and avoid context
+		 * switches.
+		 * XXX This should be on the same numa node and not busy - is there
+		 * a scheduler function available  that could make this decision?
+		 * It should also not persistently switch between cores - makes
+		 * it hard for the scheduler.
+		 */
+		qid = task_cpu(current);
+
+		if (WARN_ONCE(qid >= ring->nr_queues,
+			      "Core number (%u) exceeds nr ueues (%zu)\n",
+			      qid, ring->nr_queues))
+			qid = 0;
+	}
+
+	queue = fuse_uring_get_queue(ring, qid);
+	req_queue = async ? &queue->async_fuse_req_queue :
+			    &queue->sync_fuse_req_queue;
+	ent_queue = async ? &queue->async_ent_avail_queue :
+			    &queue->sync_ent_avail_queue;
+
+	spin_lock(&queue->lock);
+
+	if (unlikely(queue->stopped)) {
+		res = -ENOTCONN;
+		goto err_unlock;
+	}
+
+	list_add_tail(&req->list, req_queue);
+
+	if (!list_empty(ent_queue)) {
+		ring_ent =
+			list_first_entry(ent_queue, struct fuse_ring_ent, list);
+		list_del_init(&ring_ent->list);
+		fuse_uring_add_req_to_ring_ent(ring_ent, req);
+	}
+	spin_unlock(&queue->lock);
+
+	if (ring_ent != NULL) {
+		struct io_uring_cmd *cmd = ring_ent->cmd;
+		struct fuse_uring_cmd_pdu *pdu =
+			(struct fuse_uring_cmd_pdu *)cmd->pdu;
+
+		pdu->ring_ent = ring_ent;
+		io_uring_cmd_complete_in_task(cmd, fuse_uring_send_req_in_task);
+	}
+
+	return 0;
+
+err_unlock:
+	spin_unlock(&queue->lock);
+	return res;
+}
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index 432465d4bfce..d9988d4beeed 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -176,6 +176,7 @@ void fuse_uring_abort_end_requests(struct fuse_ring *ring);
 int fuse_uring_conn_cfg(struct file *file, void __user *argp);
 void fuse_uring_stop_queues(struct fuse_ring *ring);
 int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
+int fuse_uring_queue_fuse_req(struct fuse_conn *fc, struct fuse_req *req);
 
 static inline void fuse_uring_conn_destruct(struct fuse_conn *fc)
 {
@@ -293,6 +294,12 @@ static inline void fuse_uring_abort(struct fuse_conn *fc)
 static inline void fuse_uring_wait_stopped_queues(struct fuse_conn *fc)
 {
 }
+
+static inline int
+fuse_uring_queue_fuse_req(struct fuse_conn *fc, struct fuse_req *req)
+{
+	return -EPFNOSUPPORT;
+}
 #endif /* CONFIG_FUSE_IO_URING */
 
 #endif /* _FS_FUSE_DEV_URING_I_H */

-- 
2.43.0


