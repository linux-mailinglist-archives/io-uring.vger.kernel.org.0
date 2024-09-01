Return-Path: <io-uring+bounces-3000-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E8FD9676B6
	for <lists+io-uring@lfdr.de>; Sun,  1 Sep 2024 15:38:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F7921C20F69
	for <lists+io-uring@lfdr.de>; Sun,  1 Sep 2024 13:38:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2680E183CD9;
	Sun,  1 Sep 2024 13:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="a7faAJEj"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A91183063;
	Sun,  1 Sep 2024 13:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725197845; cv=fail; b=BU7KkJD5ZW5zD9dPHr5gAOP7J7ZMcKeBaBzVjS8n9piSQntLiB0htuS5asa8H890HKh84rHoL9iwX7AfgGi2mRD1RQJVF6IA/8/T1h9sYcsII8dQwZU9DBKPXloPJXPtoABweBV5fHBZX9Ndfy/zeZsHFYD1n30tAlEh302vNWQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725197845; c=relaxed/simple;
	bh=mT02XlyX4gmi4ocpMbkDD+Qv65yCFHgFxbcP2gxZjPQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Q4cZHw7HKoX2tOexZv0N6foTLOqqmTzGX+0znjWsxUiVuf3eJ9Th3cH09PbIlIKvXF8q+9oY3CtyI5TXHKi3BDoQXBEJVlHztqvSORPgcyOV4wORVM4ebChPH5Ip9PkM4VCu+Plm/KEOIntCxUjOmSw3Zxwq9TvJKq3H3trdG1M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=a7faAJEj; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43]) by mx-outbound22-20.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Sun, 01 Sep 2024 13:37:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IHltib7UIQxr9AEk+e09La7SGCg1DiLkLhADIhhdjXSSDCaSzRK9TPYdBK7sAytN6fVjAlzwt3FDaM96aj/mQttx6QqtTLobBmRa1BSAVwuwW1wTWXnL0JQwk9JqILCXc/SodQ3nYkivuz5z5JIMIpTlPp2iMfqafFgR3A7KihhCkoo/hvD0Z6Elv8Ki/tk8EPqmtSFtdzOF6hVuSlmFgZ9eCxttG6TeMuU0iReT8M+Ziu/XYPTSfKsZcE31ISu57YRbE+/2GEFVmwpn/19hPvBmj5Mkr0ZBftKmyQ+j8GORL2+F+3qEZRkviQPrmHn6ZwmvGsBGjE6B8KUUzOxCRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PUQ7YhCmB9FZswPSTwkDTgWzD/Vt8/BQcnaZo0gIQyI=;
 b=mvL2/vLwgHQ8QA5YaK9qQYCkKr3/eJjBofLRau0kO6P3pyLXdOpgg25eQTb3F4vOPrKHbHEzB08MwoWnpYniYmHGPUUsLB+4D7vPcrsQDHekWlbzLKmHmm4VuYYoFjEnUCEZsjNr9FtePrNzklKnR4y1FtA2jzf7BqP7niHtKMi/FyPr0jAXDY44ha9kyZLrRd4aT0C/2AXfmW/qmXDq4r90CzNgLvpl8gA/BfjciR8O9MZOlQGDp9PTfWcmKI++Lni1w10DAwXTQS5z6l+qb3cOCvN1UyZ+Fi/iTfzadNc5Hb2ITclrQEtwxdqEPbeTacuLYxVXXENrWu5kQSGAhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PUQ7YhCmB9FZswPSTwkDTgWzD/Vt8/BQcnaZo0gIQyI=;
 b=a7faAJEjWuMq2BzOIK6lP/Ut+PbnnYLxEXhgJhS1uoubIVesNnxQYUWvX3KRuM0tK6h2Hmb1b3Ci9xU8+1upZAPQsAsiADDeAuytt04WROlhrjDjYWGNtKIc89KzkvE+G/AdHpmwttQ5+DFjGrAIdmgiAC57e7Elff1Cc8lsErI=
Received: from BY1P220CA0003.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:59d::10)
 by CH2PR19MB3878.namprd19.prod.outlook.com (2603:10b6:610:9c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23; Sun, 1 Sep
 2024 13:37:07 +0000
Received: from CO1PEPF000075ED.namprd03.prod.outlook.com
 (2603:10b6:a03:59d:cafe::ac) by BY1P220CA0003.outlook.office365.com
 (2603:10b6:a03:59d::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23 via Frontend
 Transport; Sun, 1 Sep 2024 13:37:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CO1PEPF000075ED.mail.protection.outlook.com (10.167.249.36) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.7918.13
 via Frontend Transport; Sun, 1 Sep 2024 13:37:05 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 7F9BA72;
	Sun,  1 Sep 2024 13:37:03 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Sun, 01 Sep 2024 15:37:00 +0200
Subject: [PATCH RFC v3 06/17] fuse: Add the queue configuration ioctl
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-6-9207f7391444@ddn.com>
References: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
In-Reply-To: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>, 
 Pavel Begunkov <asml.silence@gmail.com>, bernd@fastmail.fm
Cc: linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1725197817; l=4637;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=mT02XlyX4gmi4ocpMbkDD+Qv65yCFHgFxbcP2gxZjPQ=;
 b=+94++RXxVoA7dhYuDirAidazAUjB4HbPchYcB9wY70TX3jONJEueJJDYspKaw7/iSbtH+4eEw
 fY6GMUUbsCcDIRKwEPVSEYiMj/98xG8znhLyMO5vrRLsYAwlh+ZsN8w
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075ED:EE_|CH2PR19MB3878:EE_
X-MS-Office365-Filtering-Correlation-Id: f818af4b-d5a4-4c92-c78d-08dcca8b2c3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZktLK2RVbFZHM0RXTHJaSXdVOEU3RU5DOEdqUnkvd3d1bTY0QXF5QnBwRm1w?=
 =?utf-8?B?UG1DNnBrcHZjcmxkQng4eW0yTTFDS0tuS0Z1VVEyV3NNS2ZHT0dIKzQrdzJE?=
 =?utf-8?B?bWpjdHFScXlJVXFwZ2pzTlIzWWVNcVJ5ZjNwM01aK2FnWU5OaUJJV25TRmpp?=
 =?utf-8?B?ZkJ1ckVLRGVJeE1odlRWZTgycmF1SmoxS3J0QnUwc2pYcVd2TFZTNFY3Mnh5?=
 =?utf-8?B?OFZISDE0YUMvVUJ0ckZZUUFtTDR2THloRmM4TGVNUGw5VU9iRzAwLzhxQ3Z1?=
 =?utf-8?B?VVUwL2lTalBicXdQRTRLNUxJMnF1dUdMbklUS3dwVmRRSDBqZTVVRCsyWGIx?=
 =?utf-8?B?RU9XVyt1ZzhPV2p0MFkraUx3ZDdtbXR2Y2hUd2xRUkJNZk9XajhsU21JbFI1?=
 =?utf-8?B?cHFFVzJmSGo0NVp3SFdrYmNYbzhFb1N3c21wRGRkUXNlVXU3ZFg2VzZYcWI3?=
 =?utf-8?B?MkZlN0VXZEUxY3VGa3M4c1cyUG0yOWtQUEl2ZlNRb3FYNFBKbFJ3dG5Ca2ly?=
 =?utf-8?B?RDZPUW5wUnJ1dEhsd1h6SytWNUpLTEE5WXBqSWc0UlVuVGtlTTJDWmlEc29h?=
 =?utf-8?B?d0RjVU1ZR2p1TDkwamhVRG44bTljM2txZFNCL1ZhY2NaQ0o4VmZGc3FIU0lt?=
 =?utf-8?B?RjhSdTNsRVp2OThianYwcWV1SksyaFY0ZDVWYjA5SlpBWERMZ0xidDVTZURQ?=
 =?utf-8?B?R1dFbnlRU1FpTzkrQ1QyajJUWiszaUV3MGd3SEx0QklWVEF0VEkrcGU0Snlo?=
 =?utf-8?B?WWRadGJCWlZUOXBpbHAzVDdKVmtaRjZyM2JRVzJMcFRWeFhIbDVzbkpsalNr?=
 =?utf-8?B?MmMxRzJRc3VJd2RUc3Y2b3M4MmE3cWxFY2JZRU1FY0lmcWNlRWwzaXAyUWJF?=
 =?utf-8?B?bzNEcU5CRFFTR21lamlodHNmbm5HSXllNWFwZ29Bc1BDbGxzOHVJM0lyZWNL?=
 =?utf-8?B?cjVJYjRFcnRheGJSdndIbTRuYWoxZHVnOW9sNEQ3T1c1U2hJVmVKM2lqTmp2?=
 =?utf-8?B?V2RqV3RFTW5mbTZ1K1hkZTNlNyt5UjJYMlowUWpEc0FRZmZrSVR5ZFQwZWhk?=
 =?utf-8?B?MHNYSWtzZ1VyZTRKeEZYV0RPV3lodzhmYjIzblU3QktCQitQZ1llOXo2OTJO?=
 =?utf-8?B?T0pWVDR0RmhQMHhGUENZYUR1RnNVZVFDK1I3Yk1ZakxPNnhGRksxaWJqWGQ4?=
 =?utf-8?B?Rjliek9rOE4wV2w2Q1cyNDNWYzBwMUw4RnpKakQvemI3SVdkckFWR0F3LzBJ?=
 =?utf-8?B?V3MwMFc1R3FjeVNUQ0NYTVRIekw1enp5U29zWjhNazkxNTArR1VQUEhndDZD?=
 =?utf-8?B?UTRlcC9ETXMxaCt5MVo3eFkrNHVrQlBKOGpuMUw5SVlKTldzd1h3WEJZWVZT?=
 =?utf-8?B?alk2VDEwY3poYUZwOGlPUjdZRjA2QklmdEw4VkNLK0RYc0Z0R0RlMnRmWFl3?=
 =?utf-8?B?WU9ZZ3ZUdFQ5V3pGcDNpNWZKcEtsOE5CTkVLRHZ3WDNWVXFxTW1HSWw5M3l5?=
 =?utf-8?B?TW0wcnVRUWU3RTAvUTVKMGQ0VTFzMkZ0My8xWTY3cVd1ZkNHVlUrV3pHZGM0?=
 =?utf-8?B?VCtRWnJkeVBnSU52c1RJZ1lXWC9aTThMMVA0Nnl6N0NvNFhNb2VsS0g1ZnBF?=
 =?utf-8?B?UHlDYzRxSTBzN1VlR1hzV1FOT1dVUE82UzhKbEVMWjZQQS9aTTVlVU5lNm9F?=
 =?utf-8?B?cHpOVGRxVzErdHZSOUlUYnpIb2VkTlRjVWZTNTVYc3U3UjZEVk53S3RGRGUx?=
 =?utf-8?B?cTFjK0N2RTZsOGIyOEtRTDZML2lvNy85UUdkQ1ZnR2R5ZXI0V3RTT2tlbWFw?=
 =?utf-8?B?UHlwQW1kUTRlNEJZc1UrMWE2MTk3WVA3ajFSd2dON3ViV0xZL1lmLzAxTUhC?=
 =?utf-8?B?a2VLR0N2bTN1cmhxbzhCa1Vqb3dFVk1vYmlzbWR5Mlo3V0cvYSthR1dvREYw?=
 =?utf-8?Q?hc5v6DGviJcoSxXDmnnaz8nOAyUduxSk?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OZEs84whfJh9qTh3Vq3WwK3ks/tnnpuYnRv5Ko2wm4phtAs1+uYWGV1TTmvKQ9/JDIRhtEeTD73i7a8cF/fkVLa8YEsHRt0zntmZF16ya+er4bPAxyRQQMtq4VltjDf9iCKjvyZ44ayyzuYOrDLytfG4jwZtbh+Qc4UaH5IEbiEVQzpTHwwpmzZNAwt+rVr0rSr5ToNjdQzOAZtDmevIgu8fkmMe8uHggVnJOuFNKkhcBI/P1iwlvfOlJt3gPi289vvOz299ONXbMAAuHECiBvTMRPRI1yekv2Gt6XJVNxdXthYSRacn2PMEGw0IxNivRoNSraevYf1FqiHcSM1QDx4Pr0C48bBRmAnWCzpWmqh18xjV5Jnp7vBda9RxWB3QZtNxEO1b6B8j21HVGuN7PIiNwyOVB51cWgSPmUPZlH7WHMd9mLIYvZQvU/iokuDKGsama8laDrheLqU6wtSlj5/QQEX3qvbsKM4iiSAPtqK/B/3OvrA/iGVWz/0B4zfIxIooLhnetJ+WncsEUqgDxsV6yP/bMzh0z+bevCFaHBJ4/n1VpNTBeuv/drLhh3rv627AEqM+4LkNvYVYbzB+UUCcGpAGTtwnMOxC3MOCzCwCju2xNtKsnNxfB5G3f/6YBPXp51mW7RTzoiJVrL72fw==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2024 13:37:05.9116
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f818af4b-d5a4-4c92-c78d-08dcca8b2c3b
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075ED.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR19MB3878
X-BESS-ID: 1725197831-105652-12653-5390-1
X-BESS-VER: 2019.1_20240829.0001
X-BESS-Apparent-Source-IP: 104.47.66.43
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKViYmpuZAVgZQ0MjIKDHFPM3SMD
	nNNCnRLDk52TLJxNjSwCLNODnFPNlcqTYWAKbYgktBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.258743 [from 
	cloudscan16-237.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev.c             | 30 ++++++++++++++++++++++++++++++
 fs/fuse/dev_uring.c       |  2 ++
 fs/fuse/dev_uring_i.h     | 13 +++++++++++++
 fs/fuse/fuse_i.h          |  4 ++++
 include/uapi/linux/fuse.h | 39 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 88 insertions(+)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 6489179e7260..06ea4dc5ffe1 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -2379,6 +2379,33 @@ static long fuse_dev_ioctl_backing_close(struct file *file, __u32 __user *argp)
 	return fuse_backing_close(fud->fc, backing_id);
 }
 
+#ifdef CONFIG_FUSE_IO_URING
+static long fuse_uring_queue_ioc(struct file *file, __u32 __user *argp)
+{
+	int res = 0;
+	struct fuse_dev *fud;
+	struct fuse_conn *fc;
+	struct fuse_ring_queue_config qcfg;
+
+	res = copy_from_user(&qcfg, (void *)argp, sizeof(qcfg));
+	if (res != 0)
+		return -EFAULT;
+
+	res = _fuse_dev_ioctl_clone(file, qcfg.control_fd);
+	if (res != 0)
+		return res;
+
+	fud = fuse_get_dev(file);
+	if (fud == NULL)
+		return -ENODEV;
+	fc = fud->fc;
+
+	fud->ring_q = fuse_uring_get_queue(fc->ring, qcfg.qid);
+
+	return 0;
+}
+#endif
+
 static long
 fuse_dev_ioctl(struct file *file, unsigned int cmd,
 	       unsigned long arg)
@@ -2398,6 +2425,9 @@ fuse_dev_ioctl(struct file *file, unsigned int cmd,
 #ifdef CONFIG_FUSE_IO_URING
 	case FUSE_DEV_IOC_URING_CFG:
 		return fuse_uring_conn_cfg(file, argp);
+
+	case FUSE_DEV_IOC_URING_QUEUE_CFG:
+		return fuse_uring_queue_ioc(file, argp);
 #endif
 	default:
 		return -ENOTTY;
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 4e7518ef6527..4dcb4972242e 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -42,6 +42,8 @@ static void fuse_uring_queue_cfg(struct fuse_ring_queue *queue, int qid,
 
 		ent->queue = queue;
 		ent->tag = tag;
+
+		ent->state = FRRS_INIT;
 	}
 }
 
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index d4eff87bcd1f..301b37d16506 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -14,6 +14,13 @@
 /* IORING_MAX_ENTRIES */
 #define FUSE_URING_MAX_QUEUE_DEPTH 32768
 
+enum fuse_ring_req_state {
+
+	/* request is basially initialized */
+	FRRS_INIT = 1,
+
+};
+
 /* A fuse ring entry, part of the ring queue */
 struct fuse_ring_ent {
 	/* back pointer */
@@ -21,6 +28,12 @@ struct fuse_ring_ent {
 
 	/* array index in the ring-queue */
 	unsigned int tag;
+
+	/*
+	 * state the request is currently in
+	 * (enum fuse_ring_req_state)
+	 */
+	unsigned long state;
 };
 
 struct fuse_ring_queue {
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 33e81b895fee..5eb8552d9d7f 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -540,6 +540,10 @@ struct fuse_dev {
 
 	/** list entry on fc->devices */
 	struct list_head entry;
+
+#ifdef CONFIG_FUSE_IO_URING
+	struct fuse_ring_queue *ring_q;
+#endif
 };
 
 enum fuse_dax_mode {
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index a1c35e0338f0..143ed3c1c7b3 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -1118,6 +1118,18 @@ struct fuse_ring_config {
 	uint8_t padding[64];
 };
 
+struct fuse_ring_queue_config {
+	/* qid the command is for */
+	uint32_t qid;
+
+	/* /dev/fuse fd that initiated the mount. */
+	uint32_t control_fd;
+
+	/* for future extensions */
+	uint8_t padding[64];
+};
+
+
 /* Device ioctls: */
 #define FUSE_DEV_IOC_MAGIC		229
 #define FUSE_DEV_IOC_CLONE		_IOR(FUSE_DEV_IOC_MAGIC, 0, uint32_t)
@@ -1126,6 +1138,8 @@ struct fuse_ring_config {
 #define FUSE_DEV_IOC_BACKING_CLOSE	_IOW(FUSE_DEV_IOC_MAGIC, 2, uint32_t)
 #define FUSE_DEV_IOC_URING_CFG		_IOR(FUSE_DEV_IOC_MAGIC, 3, \
 					     struct fuse_ring_config)
+#define FUSE_DEV_IOC_URING_QUEUE_CFG	_IOR(FUSE_DEV_IOC_MAGIC, 3, \
+					     struct fuse_ring_queue_config)
 
 struct fuse_lseek_in {
 	uint64_t	fh;
@@ -1233,4 +1247,29 @@ struct fuse_supp_groups {
 #define FUSE_RING_HEADER_BUF_SIZE 4096
 #define FUSE_RING_MIN_IN_OUT_ARG_SIZE 4096
 
+/**
+ * This structure mapped onto the
+ */
+struct fuse_ring_req {
+	union {
+		/* The first 4K are command data */
+		char ring_header[FUSE_RING_HEADER_BUF_SIZE];
+
+		struct {
+			uint64_t flags;
+
+			uint32_t in_out_arg_len;
+			uint32_t padding;
+
+			/* kernel fills in, reads out */
+			union {
+				struct fuse_in_header in;
+				struct fuse_out_header out;
+			};
+		};
+	};
+
+	char in_out_arg[];
+};
+
 #endif /* _LINUX_FUSE_H */

-- 
2.43.0


