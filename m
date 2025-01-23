Return-Path: <io-uring+bounces-6082-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B7E3A1A643
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 15:52:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4EFC0188B9C3
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 14:52:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D628212B0C;
	Thu, 23 Jan 2025 14:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="JGwgc36H"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8EC5211A26;
	Thu, 23 Jan 2025 14:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737643910; cv=fail; b=hw+IguBPgrCqEnPdxpeSb/gHmf6XhUttY34GELjtEE8fmltMarbhadeV+NBXsCEwZu0NQe3Xhv3NEnu+X2P3lXKapz8lVnod/N1nntc/8Kb3hnGIlVBsVdVsCPsZgdT6R+LJSM4MzNPhdkhvtZOsljWTJlxShbupXqCgPfa1g8E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737643910; c=relaxed/simple;
	bh=JaL28vUDRHyLRH6IuE5cI5kTL2uhfcSzsXA3PN4eazg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=bmb02f8LFwdyiBy9V0bWVk5ZkrttPbw+VHwVNZNddeU1e5q5zf3Y34M42WNLdO4JUi73KfnPCrQghQy9Ni42hl8CbR0RK0/mhx9sJXsqeTslmZ/+MZtB2u2XT9PCP7jcYxXiAf3Och+z9lLV6r8QTM36DSRP+fzZVGw7I6QCa9A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=JGwgc36H; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40]) by mx-outbound14-199.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 23 Jan 2025 14:51:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QreHF1LhNlmn/Ng7YVrNccvblWimQ82rqNk3DC517BvvELJxlRcverdktBqHWSqsnFu9Du42ygDr/CK6zthm95i8knLle/ud9aH21XECu3jfBlQ5XQybR65TauBcL+q40olZ2Tn5D0R4c8SOshK3QJGC9M8y/mhkrmB8diQ6RsEReF/t2ULCeGsyAbNsbLr+TdTR4mlDuv4Ha/L0tvp2fFph0T2ZWVvMPazsOXU+gvk0UzeRGpa+qsQlf+38dSdnsfK2G8I27CFBakoGQNtZRmRfkrYB0TTv/8v7JyCHURb4Tsffs0Nz/tLnz5+FsmvMkqUW3Va8oClMbIFROS3N9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=feWxCcUneaaTSOkRr7g2XXwvCKhX+ADWpGcd8csDxEs=;
 b=Ndu+mWuI2OFZIep6Pj/fQHDh4TM6EZm8xWfk/8SO6dk13IvPAK2zwqER9hhnD0S8+wy14Pgba6JEszlvDuVUNiPDfPdUmRmrpLx5pUjXTSm30JeAc1ef8vkUngAcqDmvxsvKrZ64s4O4HdkzX4zhIM25d9l7NfywXl+I1Tsw3JBuZtI1wBE8yciHi2mP0pOhR7UceV7SXLYgX31Fh25cAQkn0gvFGbtQjvCQSOf7EuYMFiCPMyK+5URb+Rvk4Q2lntvLZIOTwGVIwU7wIOmGXLJTJpYYfGUNSW2U7KOJvjEqdXkM374N6zsj6BO8RGuEVKJgIlmYzx9IawQ3xpY43Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=feWxCcUneaaTSOkRr7g2XXwvCKhX+ADWpGcd8csDxEs=;
 b=JGwgc36HrYK45EQ8nv1+alytixx1Q3kihx1M+takfMm0AhTYJPnMgu4y9GbU/gNM7z4Mu6k3qWaUPdwIFeEpEY0kXQpRr4hjRcLAwfQCsTT9DwO3hHBKxsetR5sVIosg7tSCrA+zvCFFANP48MAatPAr6Zl5f6OHEn8WzvpQASM=
Received: from SA9P223CA0005.NAMP223.PROD.OUTLOOK.COM (2603:10b6:806:26::10)
 by MN2PR19MB3792.namprd19.prod.outlook.com (2603:10b6:208:1ef::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.22; Thu, 23 Jan
 2025 14:51:29 +0000
Received: from SA2PEPF00001509.namprd04.prod.outlook.com
 (2603:10b6:806:26:cafe::74) by SA9P223CA0005.outlook.office365.com
 (2603:10b6:806:26::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.22 via Frontend Transport; Thu,
 23 Jan 2025 14:51:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SA2PEPF00001509.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.8
 via Frontend Transport; Thu, 23 Jan 2025 14:51:29 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id AE4A458;
	Thu, 23 Jan 2025 14:51:28 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Thu, 23 Jan 2025 15:51:16 +0100
Subject: [PATCH v11 17/18] fuse: prevent disabling io-uring on active
 connections
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250123-fuse-uring-for-6-10-rfc4-v11-17-11e9cecf4cfb@ddn.com>
References: <20250123-fuse-uring-for-6-10-rfc4-v11-0-11e9cecf4cfb@ddn.com>
In-Reply-To: <20250123-fuse-uring-for-6-10-rfc4-v11-0-11e9cecf4cfb@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Luis Henriques <luis@igalia.com>, Dan Carpenter <dan.carpenter@linaro.org>, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737643871; l=1520;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=JaL28vUDRHyLRH6IuE5cI5kTL2uhfcSzsXA3PN4eazg=;
 b=MXWj0nrOxpw409MIXfKhOxGW2BjKJFgKC2txIqdyarPf3XoiWIS/x9uFTJtiqDPtwNOl4T3Pw
 Q+Q03ZhYX1NBp/IgiJTAAjMngy01TwrSSHwr5AS4yHkpzQU1ZFGddD5
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001509:EE_|MN2PR19MB3792:EE_
X-MS-Office365-Filtering-Correlation-Id: 1dfbc0d9-d50f-43b3-4ef1-08dd3bbd6b7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bVBGOC8wQVNObStPbzZNaXo5L2hobmNGODdsOHJtL3k0aVVsM3RQTnpZNjZW?=
 =?utf-8?B?dXIwY0I5eVlXZ0U2cXdjRTJKaktsSXRMRjI3L0tKUnEzQXdnQVFsZjVjclgx?=
 =?utf-8?B?eFZIUTE2L2xab3U3a1FNMkNHVEZ3RWM5Y2JZVXdTZW9CaWQ1dSsva1NEamJ4?=
 =?utf-8?B?U2N0SjhnVzhyVXpUWGg5b0RnZU0xMzNkdEVKNUJ1RG00U2l3OVlQdWpzOHIv?=
 =?utf-8?B?bjN1bnNTT2ppeGdHWEFSeGV0Nm83a0RyanF1YWh5Tjc5My9xRkNoQkEwMHRJ?=
 =?utf-8?B?Ni95a012dFZweVlhOFF2U0laRi9pQy9zZEo5eXRrcXNENkl5dXVNRndiaUhk?=
 =?utf-8?B?bHVyMGJGWE9Ib0ZFR2RUV3ZRUUJ1eUF4Qk12emdWYjlDV0FsRWwxb2oxZ29O?=
 =?utf-8?B?M3BRNUlHVVl0ODRXU3F0Z2diWlZGYUgxajlhWmFJaTBRVzZUM3hWVWdmMmFI?=
 =?utf-8?B?RkhDZWJJZFhBRkRGUTZKL3JqQ25MNVJUMVR2Zm5UTHo4aGhaUzQwZ0ttckRL?=
 =?utf-8?B?amphSzhsY0ZFK2RkR0t6VjlDSTNqSzdxeVpBN1VTRk8wVDNSSjV2VDhSdU5p?=
 =?utf-8?B?Y1RKMmx1NUZueTlJVlQ2ejErb3VXVmEyOWMzdlhVa0lPWTR2WExMUjl1ajhv?=
 =?utf-8?B?aHZzYzNLNmRuU05ERm1IY0QyL3NMU1J0c3JDNkp2YkJEZXR4NWhYRFRKTysx?=
 =?utf-8?B?QkNxQ2x5T3UyNlVKTzdWNFVjMnBSSncxcHgydW4yMzE1MkJCUVFJYjJPWnkr?=
 =?utf-8?B?QUs5QXNHemNIampRV09FOGl5dUtaQUxQb0lJTG1aZ01ZZzluMkNIMXVxajQr?=
 =?utf-8?B?K2tKNGMwUE5DQTNldUdxNDFuSGpqcTRxcHVnMVhSNGVIQ2VEWUprbUR4S2FR?=
 =?utf-8?B?Qm5vUi93bTY3aTBxbUd3NWNXUXZ0dnJWeGg5VXdYeXpsMURHNHh0Uzk1QkJY?=
 =?utf-8?B?YmQyWTlIR3JxQXVici9qRG1RMnB2MWEzWFgxemRHNFNrMTFISjFySGRiYmNx?=
 =?utf-8?B?WWEvZlR5bG4wbURDSXR1bDY5Y3VrdkExRFJIbkRLTHE0SUxvdHdWMElmTWZj?=
 =?utf-8?B?UDRRNmRUdFVzeXpCQk5FVSthU0FVQnhrODVlaFF6b0FKTnM4eUsxRkY5YWIr?=
 =?utf-8?B?WXU1ZFFNOWNIOHdCdENWMEJiZlMwY1FqQUhLREZ5K3d0bTBDYU51TWd3eWZV?=
 =?utf-8?B?eHF2cjNZQ05mSkpIaUFoNytyWHA4ekI4SDNETkJpMHZyblNSNWF4TWd6anJS?=
 =?utf-8?B?R1VndVhpTnhSVmp4L1NiaSswUmZSVFo0RFE5THdueUt5K3ZZd0JqVVR3THZY?=
 =?utf-8?B?RU94M1M5V2lSZ0RCQmY1K1pWbEcwNjVOck5tSXY5dUhyUEVHeVNlTTlFT0M2?=
 =?utf-8?B?WE8ydG11RUVROU82RTRqUnBVNFAxQURMbldrS0srYXRrT0xPQU5vaExzcUlQ?=
 =?utf-8?B?bmFrT2NIdHhtTi94bUlnTlNQZjVjUzdBOXpwUGtZelVxTlFTRTFIS2k0QmVz?=
 =?utf-8?B?dlVKNTc0S294dWVvd1IvVk9YN0pSUFJ3TDNKTHdLQkhSSXV4TEZoZVVnQW1K?=
 =?utf-8?B?WGpVN1RjOUtCZWQ5czZiRkI5Mmw1VnR3eEQ2OFJmNStmYlVBNkMvcklYRXNi?=
 =?utf-8?B?STJKZHVBRk5zQXpvN2wrclFEOU1YcHEyRTNqcTJCaGhacDQ4bElEaXFPaHMr?=
 =?utf-8?B?UUdYdmJRR0xzSmY5RWUxWHk1MGFEczdxYXZnZUV1SHNwdUY2UE8wOVEvUG9K?=
 =?utf-8?B?a0JVMDJmQTVVNzFHditTYjczZXhvMlpZTlBvSlhRMGw4aU5kSElwRmZYL0x3?=
 =?utf-8?B?Sm9iY3RJYnUyb1k5Q2o1aVdrR3FIay9MbTFPMjJnbGtma1Y5UXNMTTEyWHdJ?=
 =?utf-8?B?QmszU09pR1JWTzZPTnhXa3FLYkFyS1krWGdpMkJhMitiSFZWaFN2L2wwc2Zk?=
 =?utf-8?B?cUt5NndMMzRRVlA3TWk1OXNRWklCZC9MZGx4K3B2SXZDdnhmOXNHV1VUcVMw?=
 =?utf-8?Q?1RDnWh4waN9hnWBKcUQviGC8PHccEQ=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(7416014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JZobpMqyaBNIM6ALGiPRQaDmCcK/uPPmsrZkcT31ykxAVTjWLUosid+TSsEEVinVakp04D+AuGtlZQj3a1Gr3KuDQB/6gnJUo2JvxFuKC2dqldn+eFszXZ8kcICqD8a5hyz+VgRpK5v61rG8wJw0TJRErUEibdcOOJyFUmBrYH4ebOLXww1JRoBLf1QpfF0urIx+ztHwDjJMvLCQxY5b2GDSdfEOjPKQPnCz6Rp/x1pnLoi1CXDwZrxchoIbwkcI3bovB6rDWQ0PH67ny6IT+IxO8CbA03iO4EYO24GxpgSC791hnd3s1kZxBhkUdagG6FyXeaE59waAUx2N1ThojTaQ8bXQ8wAs/v5y5cBFp3E9m7nNRHSJ2rcmXw8/SZxVgq0Jt/lZuB7pjhg9O9Run7frMcoh/had2gWB49ZePjMrSd9NmMVnx7A2Ral9Gobl8FsH+TfUtaz3BS2p0iSPCzA4DNuEvDWBpuXlMjUEM+aHOFTECZYYyGnfniUhiUbeWc808N6BsqUuDzs70vrgdHrRsWFgO7GMc2lwzQe3W4/yfsvdIG4Sfw2Lsi4t0gmqUmaAePXMQ+BfhC1T9b61zuLVQPVsM/n8kBh7ZkZhuQ8trAt89KVvAPWyFU3VqxhB9NT620g9PiQvMsFJauVgyQ==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2025 14:51:29.3863
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dfbc0d9-d50f-43b3-4ef1-08dd3bbd6b7c
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001509.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR19MB3792
X-BESS-ID: 1737643893-103783-13535-6257-1
X-BESS-VER: 2019.1_20250122.1822
X-BESS-Apparent-Source-IP: 104.47.66.40
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoYm5mZAVgZQ0CQtKckw0dQwOc
	UiOcnAzMQgMcXcPC3VIsU4OSXVzNxSqTYWAEcZPJZBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.262002 [from 
	cloudscan11-44.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

The enable_uring module parameter allows administrators to enable/disable
io-uring support for FUSE at runtime. However, disabling io-uring while
connections already have it enabled can lead to an inconsistent state.

Fix this by keeping io-uring enabled on connections that were already using
it, even if the module parameter is later disabled. This ensures active
FUSE mounts continue to function correctly.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev_uring.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 5a44de5d647ee7259ed9a750d0184deebca1de19..b67bde903c126fcd1426771b4a96071fc37fffba 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -1092,11 +1092,6 @@ int __maybe_unused fuse_uring_cmd(struct io_uring_cmd *cmd,
 	u32 cmd_op = cmd->cmd_op;
 	int err;
 
-	if (!enable_uring) {
-		pr_info_ratelimited("fuse-io-uring is disabled\n");
-		return -EOPNOTSUPP;
-	}
-
 	if ((unlikely(issue_flags & IO_URING_F_CANCEL))) {
 		fuse_uring_cancel(cmd, issue_flags);
 		return 0;
@@ -1113,6 +1108,12 @@ int __maybe_unused fuse_uring_cmd(struct io_uring_cmd *cmd,
 	}
 	fc = fud->fc;
 
+	/* Once a connection has io-uring enabled on it, it can't be disabled */
+	if (!enable_uring && !fc->io_uring) {
+		pr_info_ratelimited("fuse-io-uring is disabled\n");
+		return -EOPNOTSUPP;
+	}
+
 	if (fc->aborted)
 		return -ECONNABORTED;
 	if (!fc->connected)

-- 
2.43.0


