Return-Path: <io-uring+bounces-5325-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DABF99E99B2
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 15:59:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5843B167F9B
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 14:59:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AEF81F2C29;
	Mon,  9 Dec 2024 14:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="a9VggEDK"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B331B4254;
	Mon,  9 Dec 2024 14:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733756226; cv=fail; b=KIqvSTVCZARBOj1JSsjD2/L+JlUf5IW/74CyqsAcc984QJvx3bUi5i+0yxaZeBPb/wqsqw9qQkXYLSigQIRZmvzjFjtK7ShJ4q6oR19V+0/a359CTl6F/fOw3s10CwpUPUwZDRaMln/olbg/XEbED/gkknYYIyyH3JlJDJbh4Gg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733756226; c=relaxed/simple;
	bh=/M1wyxByHVvwTSlRk/PuikX9dE2QyBQM/XxMq9BZi5c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=u8osp4BH0Qr9odHRISxHS3/OtlMU4GeqEpV2q+H5CKnyChh5soH2gz0gSnlV4iKQzojCmOmmLultIn8uwq3FpsTOJSDDVcRnIxKN4195puHACY8ZmIwrNCHS45/g2luCtPZW5AMHeT5nu9ekfOmOdwkAj3fYAAcSDd/B/aB9EV4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=a9VggEDK; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177]) by mx-outbound13-209.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 09 Dec 2024 14:56:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=icpAKY+e4OUJxW6nrj61tZkdJyttWog7kQft2oq0y6WaIeiaJtWWExO7Xp+Qn+bNgtFFkKc3eqtxVra30eo2DGiwvxTZCLRvrgpSYg+uOlglEGHtuv35pvePX4gwbKHgd/CqcbpViJEGO+bjQyVkj3u1s+fWpXhUseXrbNOMiWC2RkYK++saaZEUB1M6q9rg7zq/RBY5RTNrg4AGar3tk2vYBD+fqd/ktSNAvy9MvI4JcjApf8m2aPeWNh4Mftf1YzWYmqGFmNnVZ1BRv4dpGlDSHkBt4i18tQkMEdKPn7q/GCL4rzFw15eSdmaNXHmvjeyIcKb3dNtrz5Dec7Yd5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mW6dQn6sD2KFs/h3P37EcShT0ZSlBbUomfJOIKk81NQ=;
 b=y7DjbOHrfPmTsB+OqOcc4EjOF6EpqA4y7THt7d1/OJ0xMjWQE2CEw4gP7EZGuOZ1I6VyllFWmMDCADiJXX2SqXEBeDjo0tgmEywhv7O32FCFU96W8eferVIvmFXVoI3uLQBOiqe2CsX00aT0w5ZFzYhg9+SEufT5ciKSx172N8RyruUi2oCRQqiXJaPRREW+DrxfJWrOnAg3E04ANjm7uovRYKZwxiLr2S2aO3J9vxVVq01AappOxJGd5BoCsX9kg0YhBa6yHLHryVKuOdL5zNBfyeijDG228TtX9kxpWf3D7MtiMV80kNAHJ59bZXbgm/iOpwhNopxmkK+acvdERg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mW6dQn6sD2KFs/h3P37EcShT0ZSlBbUomfJOIKk81NQ=;
 b=a9VggEDKdsFkZIqtEvuyA12D+RciOcRRHC9hv+HdNF08z5bwKUXv8gUKy4xfgd2h3OKWvb1DWRO6khJXIozGRUO7DJAY09kykA4CtD1UMo3/aUFUbrElc8j4dLFUvfj5Ysll5pSX+KgbFezK21OzVfZfL7qr9UReLJkIsHgxTmg=
Received: from PH7PR17CA0061.namprd17.prod.outlook.com (2603:10b6:510:325::11)
 by CH3PR19MB8190.namprd19.prod.outlook.com (2603:10b6:610:19e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.12; Mon, 9 Dec
 2024 14:56:51 +0000
Received: from MWH0EPF000A6735.namprd04.prod.outlook.com
 (2603:10b6:510:325:cafe::97) by PH7PR17CA0061.outlook.office365.com
 (2603:10b6:510:325::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.12 via Frontend Transport; Mon,
 9 Dec 2024 14:56:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 MWH0EPF000A6735.mail.protection.outlook.com (10.167.249.27) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.7
 via Frontend Transport; Mon, 9 Dec 2024 14:56:50 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 886CF55;
	Mon,  9 Dec 2024 14:56:49 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Mon, 09 Dec 2024 15:56:32 +0100
Subject: [PATCH v8 10/16] fuse: Add io-uring sqe commit and fetch support
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241209-fuse-uring-for-6-10-rfc4-v8-10-d9f9f2642be3@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1733756199; l=15167;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=/M1wyxByHVvwTSlRk/PuikX9dE2QyBQM/XxMq9BZi5c=;
 b=sALJJITKPa29S3rT7Do6lY+HicpxVkWEi2rU5p+bfARVu23HPzZuar8YA8Uq4PpWqeE6MN+Ux
 7sbVBNKYwG1CGN5WFIk7dOGRSIhXP3K6XpaN16Dr2V3ip6oBXP3lWRx
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6735:EE_|CH3PR19MB8190:EE_
X-MS-Office365-Filtering-Correlation-Id: 16f4a471-af45-49bc-d93d-08dd1861b627
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WXJwOFAvRTd4d3hnd3J6MXo4bFRITVZzbTYrYVRoZ0xrTjJ6cmdJL1hWNy9m?=
 =?utf-8?B?RkV0TXR6ZEpmOFhqWllTTGVhQzBjNlVkeUJ5T1VFckszcUVZOWkweEIzbFlD?=
 =?utf-8?B?eWFGeEJUSG41bFBVUWdHcHpFZGM0T3RYeW1ZZGVnY2MzYnkrRE44UFlIWStY?=
 =?utf-8?B?Wk0xMHVDV1hKM3BjUkdZWDY1aWM5THJHSGg0SFNJVFNkcnFuMmsxUkcrOEtS?=
 =?utf-8?B?eGJVNXgxOU9BU3p4TmlCZlY4MWVpTnR3a1ZyUXpUQ2RaVVNydmtTdzFrVUJh?=
 =?utf-8?B?dER0UDJrN2x4UFZ4MHl4K3RwNVg2OXU2eG9HbXpYSEJQYzQvZVNBVld3VnBn?=
 =?utf-8?B?WE9tdlVVTlZpMUxMcVd4dlNDWlZYNzJhSlpIZXFrcndXaVBicE5DOXRpWll1?=
 =?utf-8?B?UENUU3lFREZjNUhzblFtQ21CdDlqTUNPcWhPUkpZTGJJcEVoUjMyaHpuaENZ?=
 =?utf-8?B?dXNkMXpDMmNrTVJPcTVQOFdmMUROdHFvZ1p3c3p0NGRvVEZheG4wODR2OGhJ?=
 =?utf-8?B?OHlpeXI2Q1NYbWpXQk82dWdpWFJTYWlUQUlYRGhxU2E5SGQxdUkwbzgyYTRG?=
 =?utf-8?B?L2Z1Q0R1OVhLTVFpTHIrODhnMmp6NEcrYkxyMGtiYzVUclVyMGNLL054SjVN?=
 =?utf-8?B?b013cWZEU0tmdmpKdmVLaFFVUDlNWk1oUUdDTW9KQ2ZoUmswNjVQZUNrVnpy?=
 =?utf-8?B?OFAzZjJrUkJxMGxsMUpWUXVZbHZiY2hpak00WHdBM0ZsUDcwcGZhWks2TC9l?=
 =?utf-8?B?eHRycUFPdWQ3dkxVelMrTjFPUFlUNkxmVVRxeURXY1ovd3RPclJqNUtyTWVN?=
 =?utf-8?B?aENQUUt5MW5qWXJlbUxPMDRGSjRYNzBYa2hKNXVkcW5jd2pkdnI4ZDdnSXE2?=
 =?utf-8?B?d1ovbzdMRzh4L0M2akVvVkZ0VWorL1NoMnlFVjFudnhNMmUreW5keXNkQXJU?=
 =?utf-8?B?eEVBRGk3Q1hTYlp5cm9ncTJUeTM5T1NaMWdTa2RhRlB2Y09WRGY1c3Bkc21S?=
 =?utf-8?B?T2RrUmNFMDNTZEJ0VmxtQllydFZFeW8wUUU5RkNlcmtabFEyUnM2ZndFNTNP?=
 =?utf-8?B?c0tsY3NqWGxVSnI0MFJ4eFhOR25HMFFGa1FwNXJXUmE2b2xUckpuamx5a2Vq?=
 =?utf-8?B?WmNYUlhldXZLQ3pDOWxhV08wQ04yd2RsOVhVd3RBeWVwa0RsbElPWFE0SkE5?=
 =?utf-8?B?VEYyZVcxSUU1Z1M5SURqU2FOM0VZcldPdlZybURXZlF3Z1dJVmRZMEN2dEw0?=
 =?utf-8?B?QW9FdjdWZTVzc1pWaDBmYkJabzlOc05pbEFkamNmYWo3TjVXRUJEb2pId21k?=
 =?utf-8?B?aDV0TktHcFJzNkE0NlRWbHh3MEt6TTFoUnJzZ0tOY0RYd0daZVVaMmpHVU92?=
 =?utf-8?B?SDBkSmZKWDYzUi9qYzBSUnZpUXRMaHpsY0RWZVpqSVhCV2VQcE9TUDEzRXJQ?=
 =?utf-8?B?dVNHRXlFUlBQd29pVUQ3Tlg0WmYvejZQZUlKK1UxRGpuZ2k0OEVTKzgySHBH?=
 =?utf-8?B?ZE5JNXJvN211MUFTNW9NVXl1ajV1OUJndmQ2djRTYUt3dFVzU09hc0llZzhz?=
 =?utf-8?B?c3d5M0VDSnJDUE9qemhoM1NRRHgrSHI4UHRZMzVBUG00Tjg0LzB2dDl2ci82?=
 =?utf-8?B?UjcrYXM0R0N3azJVOG9Tb1pQMFVpeTV5WVI0b3lqeDNMNDVTbnkvU0NqdUxj?=
 =?utf-8?B?ZTZ4Y2xSQ1RzZjJRVzFLT0Nwd2tJZTRRUE00Q0k3UW0wWWtEeGZEelpQcWNY?=
 =?utf-8?B?ankwRGl6RGtFSGNsSTdjejUzOXRXcEdiRVRmSk15UUcvWnY3K0hRbys2dWJB?=
 =?utf-8?B?bzhsZGtGTnNLeWwvSW8wOHdlSWF5RE5LbUtiL3NmY0hKNVUraXhieHVTSmxa?=
 =?utf-8?B?SkQ5WU43MEg2aGtxa2ZvUUI2NUpwQjN0QkxqNTE2c1p1OTdrWVdwMEVuQWFh?=
 =?utf-8?Q?xCMbrWhCTpkR9KxhLOnDCc5WZGb1Zgqm?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	r1b28nDkEshu7dqc7rgBnX3WIeBrke3xmIsYqnI5dPXJAITQZ5sjHokeEZwwkupKtRo5cc/4NIhsObUKVO4I+94PLbG/gh8YiwLd/31qDwLKy6KLvtTP6Z9lUJSeHDrEjU5orp2kiIrRyQ9HiFSZkCnn9y5gzPMq0p1o6kMK1lQ2DBud3VgJtNvIYLyjdcvs+UKgAxkna5gukEd5wZrFZU4iRP2/3xUiNxmNY5KIV9TX8D+L/l77v1fcTNUbuXMfm3KLbOAK692vCSN5u6MvDleCM/BGTNpcCHTX1bHVGsploq9mwNrI4u3Ngz3xgO/ywiabLE9M3PzDg7Guv7wVwnPRULwatSnJTBf9zovgO5EksB+Y94Psx5du2FxGTD+wfXG6vAVCin7VoWdufhxHdwCeQnKlDWPoJlxUXsQWJoQV262DrXJ67tOckBdultKHgvkLAA/gU+FRnT+8Na3CoJEdqFc9BE0JHkDbWbzk1nxVFNhmEIkrwBOC+Sg69PwDalAOBD0L+Grughf6IhPCMms+bunAGAn6EmvR3zQXibDYy46uSCZgNnCtKr3yj40/EJ139wGJnel4lEzTSzvbqL6aYzJWmPtLmshUTX5UG0g/MkmoRrbAStMLJpADFBGmopnbJNxS9RW+8F3FlgFE0w==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 14:56:50.2500
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 16f4a471-af45-49bc-d93d-08dd1861b627
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6735.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR19MB8190
X-BESS-ID: 1733756215-103537-13400-6407-1
X-BESS-VER: 2019.1_20241126.2220
X-BESS-Apparent-Source-IP: 104.47.57.177
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoYmZoYmQGYGUDTVzNjIKDXFIi
	Up1cjSzNTCIsko0dTMxCQlLS3V1MAiUak2FgAExr0UQgAAAA==
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260997 [from 
	cloudscan9-140.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This adds support for fuse request completion through ring SQEs
(FUSE_URING_CMD_COMMIT_AND_FETCH handling). After committing
the ring entry it becomes available for new fuse requests.
Handling of requests through the ring (SQE/CQE handling)
is complete now.

Fuse request data are copied through the mmaped ring buffer,
there is no support for any zero copy yet.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev_uring.c   | 431 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h |  12 ++
 fs/fuse/fuse_i.h      |   4 +
 3 files changed, 447 insertions(+)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index f0c5807c94a55f9c9e2aa95ad078724971ddd125..b43e48dea4eba2d361119735c549f6a6cd461372 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -26,6 +26,19 @@ bool fuse_uring_enabled(void)
 	return enable_uring;
 }
 
+static void fuse_uring_req_end(struct fuse_ring_ent *ring_ent, bool set_err,
+			       int error)
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
 static int fuse_ring_ent_unset_userspace(struct fuse_ring_ent *ent)
 {
 	struct fuse_ring_queue *queue = ent->queue;
@@ -56,8 +69,11 @@ void fuse_uring_destruct(struct fuse_conn *fc)
 			continue;
 
 		WARN_ON(!list_empty(&queue->ent_avail_queue));
+		WARN_ON(!list_empty(&queue->ent_w_req_queue));
 		WARN_ON(!list_empty(&queue->ent_commit_queue));
+		WARN_ON(!list_empty(&queue->ent_in_userspace));
 
+		kfree(queue->fpq.processing);
 		kfree(queue);
 		ring->queues[qid] = NULL;
 	}
@@ -117,16 +133,30 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
 {
 	struct fuse_conn *fc = ring->fc;
 	struct fuse_ring_queue *queue;
+	struct list_head *pq;
 
 	queue = kzalloc(sizeof(*queue), GFP_KERNEL_ACCOUNT);
 	if (!queue)
 		return ERR_PTR(-ENOMEM);
+	pq = kcalloc(FUSE_PQ_HASH_SIZE, sizeof(struct list_head), GFP_KERNEL);
+	if (!pq) {
+		kfree(queue);
+		return ERR_PTR(-ENOMEM);
+	}
+
+		kfree(queue->fpq.processing);
 	queue->qid = qid;
 	queue->ring = ring;
 	spin_lock_init(&queue->lock);
 
 	INIT_LIST_HEAD(&queue->ent_avail_queue);
 	INIT_LIST_HEAD(&queue->ent_commit_queue);
+	INIT_LIST_HEAD(&queue->ent_w_req_queue);
+	INIT_LIST_HEAD(&queue->ent_in_userspace);
+	INIT_LIST_HEAD(&queue->fuse_req_queue);
+
+	queue->fpq.processing = pq;
+	fuse_pqueue_init(&queue->fpq);
 
 	spin_lock(&fc->lock);
 	if (ring->queues[qid]) {
@@ -141,6 +171,210 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
 	return queue;
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
+	err = -EINVAL;
+	if (oh->unique == 0) {
+		/* Not supportd through io-uring yet */
+		pr_warn_once("notify through fuse-io-uring not supported\n");
+		goto seterr;
+	}
+
+	err = -EINVAL;
+	if (oh->error <= -ERESTARTSYS || oh->error > 0)
+		goto seterr;
+
+	if (oh->error) {
+		err = oh->error;
+		goto err;
+	}
+
+	err = -ENOENT;
+	if ((oh->unique & ~FUSE_INT_REQ_BIT) != req->in.h.unique) {
+		pr_warn_ratelimited("unique mismatch, expected: %llu got %llu\n",
+				    req->in.h.unique,
+				    oh->unique & ~FUSE_INT_REQ_BIT);
+		goto seterr;
+	}
+
+	/*
+	 * Is it an interrupt reply ID?
+	 * XXX: Not supported through fuse-io-uring yet, it should not even
+	 *      find the request - should not happen.
+	 */
+	WARN_ON_ONCE(oh->unique & FUSE_INT_REQ_BIT);
+
+	return 0;
+
+seterr:
+	oh->error = err;
+err:
+	return err;
+}
+
+static int fuse_uring_copy_from_ring(struct fuse_ring *ring,
+				     struct fuse_req *req,
+				     struct fuse_ring_ent *ent)
+{
+	struct fuse_copy_state cs;
+	struct fuse_args *args = req->args;
+	struct iov_iter iter;
+	int err, res;
+	struct fuse_uring_ent_in_out ring_in_out;
+
+	res = copy_from_user(&ring_in_out, &ent->headers->ring_ent_in_out,
+			     sizeof(ring_in_out));
+	if (res)
+		return -EFAULT;
+
+	err = import_ubuf(ITER_SOURCE, ent->payload, ring->max_payload_sz,
+			  &iter);
+	if (err)
+		return err;
+
+	fuse_copy_init(&cs, 0, &iter);
+	cs.is_uring = 1;
+	cs.req = req;
+
+	return fuse_copy_out_args(&cs, args, ring_in_out.payload_sz);
+}
+
+ /*
+  * Copy data from the req to the ring buffer
+  */
+static int fuse_uring_copy_to_ring(struct fuse_ring *ring, struct fuse_req *req,
+				   struct fuse_ring_ent *ent)
+{
+	struct fuse_copy_state cs;
+	struct fuse_args *args = req->args;
+	struct fuse_in_arg *in_args = args->in_args;
+	int num_args = args->in_numargs;
+	int err, res;
+	struct iov_iter iter;
+	struct fuse_uring_ent_in_out ent_in_out = {
+		.flags = 0,
+		.commit_id = ent->commit_id,
+	};
+
+	err = import_ubuf(ITER_DEST, ent->payload, ring->max_payload_sz, &iter);
+	if (err) {
+		pr_info_ratelimited("fuse: Import of user buffer failed\n");
+		return err;
+	}
+
+	fuse_copy_init(&cs, 1, &iter);
+	cs.is_uring = 1;
+	cs.req = req;
+
+	if (num_args > 0) {
+		/*
+		 * Expectation is that the first argument is the per op header.
+		 * Some op code have that as zero.
+		 */
+		if (args->in_args[0].size > 0) {
+			res = copy_to_user(&ent->headers->op_in, in_args->value,
+					   in_args->size);
+			err = res > 0 ? -EFAULT : res;
+			if (err) {
+				pr_info_ratelimited(
+					"Copying the header failed.\n");
+				return err;
+			}
+		}
+		in_args++;
+		num_args--;
+	}
+
+	/* copy the payload */
+	err = fuse_copy_args(&cs, num_args, args->in_pages,
+			     (struct fuse_arg *)in_args, 0);
+	if (err) {
+		pr_info_ratelimited("%s fuse_copy_args failed\n", __func__);
+		return err;
+	}
+
+	ent_in_out.payload_sz = cs.ring.offset;
+	res = copy_to_user(&ent->headers->ring_ent_in_out, &ent_in_out,
+			   sizeof(ent_in_out));
+	err = res > 0 ? -EFAULT : res;
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static int
+fuse_uring_prepare_send(struct fuse_ring_ent *ring_ent)
+{
+	struct fuse_ring_queue *queue = ring_ent->queue;
+	struct fuse_ring *ring = queue->ring;
+	struct fuse_req *req = ring_ent->fuse_req;
+	int err, res;
+
+	err = -EIO;
+	if (WARN_ON(ring_ent->state != FRRS_FUSE_REQ)) {
+		pr_err("qid=%d ring-req=%p invalid state %d on send\n",
+		       queue->qid, ring_ent, ring_ent->state);
+		err = -EIO;
+		goto err;
+	}
+
+	/* copy the request */
+	err = fuse_uring_copy_to_ring(ring, req, ring_ent);
+	if (unlikely(err)) {
+		pr_info_ratelimited("Copy to ring failed: %d\n", err);
+		goto err;
+	}
+
+	/* copy fuse_in_header */
+	res = copy_to_user(&ring_ent->headers->in_out, &req->in.h,
+			   sizeof(req->in.h));
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
+static int fuse_uring_send_next_to_ring(struct fuse_ring_ent *ring_ent,
+					unsigned int issue_flags)
+{
+	int err = 0;
+	struct fuse_ring_queue *queue = ring_ent->queue;
+
+	err = fuse_uring_prepare_send(ring_ent);
+	if (err)
+		goto err;
+
+	spin_lock(&queue->lock);
+	ring_ent->state = FRRS_USERSPACE;
+	list_move(&ring_ent->list, &queue->ent_in_userspace);
+	spin_unlock(&queue->lock);
+
+	io_uring_cmd_done(ring_ent->cmd, 0, 0, issue_flags);
+	return 0;
+
+err:
+	return err;
+}
+
 /*
  * Make a ring entry available for fuse_req assignment
  */
@@ -151,6 +385,195 @@ static void fuse_uring_ent_avail(struct fuse_ring_ent *ring_ent,
 	ring_ent->state = FRRS_WAIT;
 }
 
+/* Used to find the request on SQE commit */
+static void fuse_uring_add_to_pq(struct fuse_ring_ent *ring_ent,
+				 struct fuse_req *req)
+{
+	struct fuse_ring_queue *queue = ring_ent->queue;
+	struct fuse_pqueue *fpq = &queue->fpq;
+	unsigned int hash;
+
+	/* commit_id is the unique id of the request */
+	ring_ent->commit_id = req->in.h.unique;
+
+	req->ring_entry = ring_ent;
+	hash = fuse_req_hash(ring_ent->commit_id);
+	list_move_tail(&req->list, &fpq->processing[hash]);
+}
+
+/*
+ * Assign a fuse queue entry to the given entry
+ */
+static void fuse_uring_add_req_to_ring_ent(struct fuse_ring_ent *ring_ent,
+					   struct fuse_req *req)
+{
+	struct fuse_ring_queue *queue = ring_ent->queue;
+
+	lockdep_assert_held(&queue->lock);
+
+	if (WARN_ON_ONCE(ring_ent->state != FRRS_WAIT &&
+			 ring_ent->state != FRRS_COMMIT)) {
+		pr_warn("%s qid=%d state=%d\n", __func__, ring_ent->queue->qid,
+			ring_ent->state);
+	}
+	list_del_init(&req->list);
+	clear_bit(FR_PENDING, &req->flags);
+	ring_ent->fuse_req = req;
+	ring_ent->state = FRRS_FUSE_REQ;
+	list_move(&ring_ent->list, &queue->ent_w_req_queue);
+	fuse_uring_add_to_pq(ring_ent, req);
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
+	struct fuse_req *req;
+	struct fuse_ring_queue *queue = ring_ent->queue;
+	struct list_head *req_queue = &queue->fuse_req_queue;
+
+	lockdep_assert_held(&queue->lock);
+
+	/* get and assign the next entry while it is still holding the lock */
+	req = list_first_entry_or_null(req_queue, struct fuse_req, list);
+	if (req) {
+		fuse_uring_add_req_to_ring_ent(ring_ent, req);
+		return true;
+	}
+
+	return false;
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
+	struct fuse_req *req = ring_ent->fuse_req;
+	ssize_t err = 0;
+	bool set_err = false;
+
+	err = copy_from_user(&req->out.h, &ring_ent->headers->in_out,
+			     sizeof(req->out.h));
+	if (err) {
+		req->out.h.error = err;
+		goto out;
+	}
+
+	err = fuse_uring_out_header_has_err(&req->out.h, req, fc);
+	if (err) {
+		/* req->out.h.error already set */
+		goto out;
+	}
+
+	err = fuse_uring_copy_from_ring(ring, req, ring_ent);
+	if (err)
+		set_err = true;
+
+out:
+	fuse_uring_req_end(ring_ent, set_err, err);
+}
+
+/*
+ * Get the next fuse req and send it
+ */
+static void fuse_uring_next_fuse_req(struct fuse_ring_ent *ring_ent,
+				     struct fuse_ring_queue *queue,
+				     unsigned int issue_flags)
+{
+	int err;
+	bool has_next;
+
+retry:
+	spin_lock(&queue->lock);
+	fuse_uring_ent_avail(ring_ent, queue);
+	has_next = fuse_uring_ent_assign_req(ring_ent);
+	spin_unlock(&queue->lock);
+
+	if (has_next) {
+		err = fuse_uring_send_next_to_ring(ring_ent, issue_flags);
+		if (err)
+			goto retry;
+	}
+}
+
+/* FUSE_URING_CMD_COMMIT_AND_FETCH handler */
+static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
+				   struct fuse_conn *fc)
+{
+	const struct fuse_uring_cmd_req *cmd_req = io_uring_sqe_cmd(cmd->sqe);
+	struct fuse_ring_ent *ring_ent;
+	int err;
+	struct fuse_ring *ring = fc->ring;
+	struct fuse_ring_queue *queue;
+	uint64_t commit_id = READ_ONCE(cmd_req->commit_id);
+	unsigned int qid = READ_ONCE(cmd_req->qid);
+	struct fuse_pqueue *fpq;
+	struct fuse_req *req;
+
+	err = -ENOTCONN;
+	if (!ring)
+		return err;
+
+	if (qid >= ring->nr_queues)
+		return -EINVAL;
+
+	queue = ring->queues[qid];
+	if (!queue)
+		return err;
+	fpq = &queue->fpq;
+
+	spin_lock(&queue->lock);
+	/* Find a request based on the unique ID of the fuse request
+	 * This should get revised, as it needs a hash calculation and list
+	 * search. And full struct fuse_pqueue is needed (memory overhead).
+	 * As well as the link from req to ring_ent.
+	 */
+	req = fuse_request_find(fpq, commit_id);
+	err = -ENOENT;
+	if (!req) {
+		pr_info("qid=%d commit_id %llu not found\n", queue->qid,
+			commit_id);
+		spin_unlock(&queue->lock);
+		return err;
+	}
+	list_del_init(&req->list);
+	ring_ent = req->ring_entry;
+	req->ring_entry = NULL;
+
+	err = fuse_ring_ent_unset_userspace(ring_ent);
+	if (err != 0) {
+		pr_info_ratelimited("qid=%d commit_id %llu state %d",
+				    queue->qid, commit_id, ring_ent->state);
+		spin_unlock(&queue->lock);
+		return err;
+	}
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
+	fuse_uring_next_fuse_req(ring_ent, queue, issue_flags);
+	return 0;
+}
+
 /*
  * fuse_uring_req_fetch command handling
  */
@@ -331,6 +754,14 @@ int __maybe_unused fuse_uring_cmd(struct io_uring_cmd *cmd,
 			return err;
 		}
 		break;
+	case FUSE_IO_URING_CMD_COMMIT_AND_FETCH:
+		err = fuse_uring_commit_fetch(cmd, issue_flags, fc);
+		if (err) {
+			pr_info_once("FUSE_IO_URING_COMMIT_AND_FETCH failed err=%d\n",
+				     err);
+			return err;
+		}
+		break;
 	default:
 		return -EINVAL;
 	}
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index 73e9e3063bb038e8341d85cd2a440421275e6aa8..6149d43dc9438a0dec400a9cebb8c8b7755d66b0 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -20,6 +20,9 @@ enum fuse_ring_req_state {
 	/* The ring entry is waiting for new fuse requests */
 	FRRS_WAIT,
 
+	/* The ring entry got assigned a fuse req */
+	FRRS_FUSE_REQ,
+
 	/* The ring entry is in or on the way to user space */
 	FRRS_USERSPACE,
 };
@@ -72,7 +75,16 @@ struct fuse_ring_queue {
 	 * entries in the process of being committed or in the process
 	 * to be send to userspace
 	 */
+	struct list_head ent_w_req_queue;
 	struct list_head ent_commit_queue;
+
+	/* entries in userspace */
+	struct list_head ent_in_userspace;
+
+	/* fuse requests waiting for an entry slot */
+	struct list_head fuse_req_queue;
+
+	struct fuse_pqueue fpq;
 };
 
 /**
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index e545b0864dd51e82df61cc39bdf65d3d36a418dc..e71556894bc25808581424ec7bdd4afeebc81f15 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -438,6 +438,10 @@ struct fuse_req {
 
 	/** fuse_mount this request belongs to */
 	struct fuse_mount *fm;
+
+#ifdef CONFIG_FUSE_IO_URING
+	void *ring_entry;
+#endif
 };
 
 struct fuse_iqueue;

-- 
2.43.0


