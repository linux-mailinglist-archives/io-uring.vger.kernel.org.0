Return-Path: <io-uring+bounces-3712-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F2F5599FD47
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 02:39:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B26E528230B
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 00:39:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6201010A19;
	Wed, 16 Oct 2024 00:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="LqVTt29W"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A997C3A8D2
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 00:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729039188; cv=fail; b=QIB0a37EfyC5muO6rc5AVmXPEAh7OgJYV9T1ba9GGLAqUjF80QGmwxKfNVPsm8hSPrGdfTfkypmtp8mYSxj2Nfm/04qPTmtq46X2YF72o224uPAyJAeIvVMZiNk3cLV6ZytVxfcKvAukTaXCfzu0XskWBVKj89zejO0c8+gUDws=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729039188; c=relaxed/simple;
	bh=LNRjk1BQzlDUsM9lv7ATvb3bUoxo9H0fgwLuky5tTO0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=sdcx6YkxtJBOSnWd7HWXY0ItZG6I/ei4t+x68chJsGh/UdLTqrxM8ct6x5mnyO/N2gf/iIzOfwbK/eGM0aK2AtcEKub0KbI1U50uAMQwvOOcocF8f+AAlmYDDgCtDmiwwHA/9cVdhE8dLhC1CgzFRo9ikD8+y/s2f81ibLG6vZM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=LqVTt29W; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175]) by mx-outbound15-86.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 16 Oct 2024 00:39:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XyI1gunq0EwOPmE+euQvvzlfCUTDcTvzxRig5E+4e+qpCkgxqsPdYgq81rIyYVmZ1wDzIQZAL7UqUMVxEqaOuiPFXbjqPjUXIddUHVJjOO7mibA+IPAuXZBudn0ZoFBCt9QsoYM7sT4A39YosJBtv5PYBXiE/WSug+iz3D0gNXbObHsBUPac6FTe4nZ6HcjIujFy2YhlEcmsEJ00fELFXNLc/JqvlNDhRdnvgCBOcZQMrBhg1H0TKvCoixQdCLavcS9V0AV1E2XyQg02Wev+nOivOzU/wMpmKO+v8S1FtGYZ4LMGe4Oer2d2gBeRzFSvoWaRwX5DtZoTSh/C2hsYOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sJzM04F5auMPqTC4+F6onlxqr84QUG4DCTOySQU1uKA=;
 b=QJoVJwBO5+AgtCqplQktZd0X5VW/31/8Y7pjFXdG2TBLfHMQomXVyCZtW/U9OkygIAvOqXp40E21bU/2ACbytTLWe86DsKUfjUxKeDdOvwCZ2sgU2VMqbwRdj7Ow0o07UTIUsOeGvQLJyf5gcA32TFEzqjWMp8B9dj38FZtZ/j4UeYTPRqS/uRjPMyLsW9WiQEwfr76TE4byKxhIy35jau/b9TmbJFIXbDp3Sn7vBxVO8wf+bNdUAfHCh7hu6iIREuKakYn2S91IoO5Qif2zJJbIQiDPp+CGIDadtLDjetNaXp8zVaSwtewrSnlXjynzaPsMwUbYV5FUFMoiBUx3XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sJzM04F5auMPqTC4+F6onlxqr84QUG4DCTOySQU1uKA=;
 b=LqVTt29WohiODgNuwFBdjwxdbzSTLU+s85OOPEqa/Zp/wTLMHaY71JmhmVGnYPUkEuVSjYTjs6Ca2pW1cENmJm3gQhAMh/N4xHjm4bDjp4zw+zCsW15kmq/DsCWzpmgHOZVdlLWrXc3A7kemLd29wUm5OhVr34qdnYXEJZQmdNI=
Received: from SA9PR10CA0009.namprd10.prod.outlook.com (2603:10b6:806:a7::14)
 by DS7PR19MB6133.namprd19.prod.outlook.com (2603:10b6:8:87::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Wed, 16 Oct
 2024 00:05:39 +0000
Received: from SA2PEPF000015C9.namprd03.prod.outlook.com
 (2603:10b6:806:a7:cafe::f6) by SA9PR10CA0009.outlook.office365.com
 (2603:10b6:806:a7::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.18 via Frontend
 Transport; Wed, 16 Oct 2024 00:05:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SA2PEPF000015C9.mail.protection.outlook.com (10.167.241.199) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8069.17
 via Frontend Transport; Wed, 16 Oct 2024 00:05:39 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 644F880;
	Wed, 16 Oct 2024 00:05:38 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Wed, 16 Oct 2024 02:05:26 +0200
Subject: [PATCH RFC v4 14/15] fuse: {io-uring} Prevent mount point hang on
 fuse-server termination
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241016-fuse-uring-for-6-10-rfc4-v4-14-9739c753666e@ddn.com>
References: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
In-Reply-To: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Amir Goldstein <amir73il@gmail.com>, 
 Ming Lei <tom.leiming@gmail.com>, Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1729037122; l=3263;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=LNRjk1BQzlDUsM9lv7ATvb3bUoxo9H0fgwLuky5tTO0=;
 b=OSxHr7iE5Z9jpuEd/Hh4hKpj+WZY6v6a1lCErC19rnFjofITSCT53k5PGozETC9dAjChOkLTO
 6aJ9zQx/6x8D2QdJHwaFwVObWLsitRFVH5igA8X+uj9j7VpqG0HAyTR
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF000015C9:EE_|DS7PR19MB6133:EE_
X-MS-Office365-Filtering-Correlation-Id: 07ccda9f-6189-4c09-3d69-08dced7644aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?clZsWHNORnAzVk5NMWorOTJuQWVRNUJTQWV3UXRyQ3BkTzRZZUFBa0dCMEhL?=
 =?utf-8?B?ZjA5Y2tOTjRRMHBOSDVMeGdpMklJRzN1RW1lMlVjemNLOWEzUkIxOFI5THhh?=
 =?utf-8?B?Z3BIVVk0dkNpYzVSeUtQWmFHRWhDWGdyTEs5WCt5OGt1YnJ1dkdJSGVJNWFW?=
 =?utf-8?B?REtycXlGeGpCWHAxQWNjQTNNTWx2RXlZZVVrMjZVWlhyWVVuSE5xbWp1Wno2?=
 =?utf-8?B?eEhoYzE3K1liMDEvV0RhWElGQ01LNC9GcXdhdExqcCs1clkwUTlTMXRXdWs5?=
 =?utf-8?B?NjZpSGVLUWpFeHFRb3VWNVJaSmlxOWpJUjVPVTk5a2xScWI1VDlkTW9YNjh2?=
 =?utf-8?B?QVhrU2M4UkZWSzZ4Qm5QS1dDZS9pVVdKQXRvbmlqZ2NWeUR6SlphOGtIQ3V5?=
 =?utf-8?B?R1VIUWdISUJsUHIrZTR1ZFl1RWFHQTVyczh3aWI4bDlRTHovelROelorUC9Q?=
 =?utf-8?B?amRjeER2MThDUzlPQ0d0RmEyTXByUFlvdUROZGpqS2NXREFWdFdFbTJmcTJO?=
 =?utf-8?B?cnRzSW44YkFaQzQ2UDNlNEw4Tm9tSGVURytUSXRyV1ZaZVB5Y1ZhWlJGNW10?=
 =?utf-8?B?NjRwNEVFVW00QnFSNlh1V0tHNXY2cWxCU05PQkszS3dNU3pYQ0E4K3c4bzcr?=
 =?utf-8?B?STRkempHTjNiVjArZUROU2pwVmVzV2dUSFJvbEtZbGNTeUVNV3ppcGY4Zkd2?=
 =?utf-8?B?OW9nZnRZRDhXV1hoU2RWc1duWVM2dU9rMnJicllpZ0dyVkNFNHZnNkFCTXRQ?=
 =?utf-8?B?TGRPcDAwaWlJcngyNHdyVkJKSFlKWTBDOVlBd0E0d2RkWnM3K21JR1ZsOWxN?=
 =?utf-8?B?M2FBWXVDKzZuaTEydVBMZ3E1azAyM2c5bG45ZmFCNlRBSGpyL3NZOUxJREhs?=
 =?utf-8?B?QzlDQmE4YU1IK2tGeldDWjg2YVlMNEtFWWtWcE1OdThiaUY4Y0NLOXBQU0Nu?=
 =?utf-8?B?ZVhYdjJpNUVCTmtQT3Y2TndrRDl6RFk5RVR4bjkxZ25YblVOQSsyUnRjajR5?=
 =?utf-8?B?cEZhQnFkT2dlajhic3ZscXM5UGtBQmxDclNOS05MYkdTZnV4Z1ZHMXhYT1px?=
 =?utf-8?B?SDZQQlE5MTJFOWdoT0VqOGw0enVyaU1pbnAyVkUyMHR0REROeUdSVm5xRStk?=
 =?utf-8?B?bGJpMDdWd1UrZkw5L21Nam1GejFzKzI1V0NDMXFuYVJ6WDQrUnVpOTVtRHpw?=
 =?utf-8?B?UUYvWXdHditXUWN5RjlRZWVtb29uVVg5d0JjdkJNK3c4OTJuSk5LTnZlelNF?=
 =?utf-8?B?RHBlVnJya3RkTnNCelRxeXpQZFQ5NG1leFliRU9wUXZwRHdtMjhtTjZhR1JW?=
 =?utf-8?B?b21xS0VVQ1Q4dTEvYkF5TVZ0TS9VSlNQTzZlN0NweEJiaGpsSE8vQUNxL2Za?=
 =?utf-8?B?WDBIU0lTamJsVEhKbm9ZNnNWZnVVRU5lSEk3UEtSVzJDanllSHhxbWNSK0Yx?=
 =?utf-8?B?cUxIcFloeWdVbUpsM2ZheDlNZEN5YTVsd29ndUlyK3JsWVlkTVBZdUFBQVFM?=
 =?utf-8?B?MWFnbkpVSkFMUm82Q3NYZkM2VU9iYnYxWDRhcWFIUGp4R0xWNzVqaWJ3UDMr?=
 =?utf-8?B?bTYzd2RpRkl1ZUFNN3ZkZ3V6aDNEc1U3N3o2aHJBSFFpTXFsWXpMSUFBR0hO?=
 =?utf-8?B?alZCRXpyYkMxTHhJNzZnZlBGYUUxUzBJbTJMVVZMNE1TUUNhdEJpSWtjMDky?=
 =?utf-8?B?ZDQrbzQ1RlErVC9VVnE2bURKTkVkK0lIT1FuRmlTdjk0Mm0ybElUdlphMjRQ?=
 =?utf-8?B?WTlRVWxHeEJPZGRXQlVaYzFLRFhyZlltdUJTOWZBOFRVTG1hQUd1eDY1cDdV?=
 =?utf-8?B?Wi9HZ0RXSzRZTUFnNC9aODRJM2oyQ3lrVUlEVmxTMkJGOU9LOWpzWmJsdHNH?=
 =?utf-8?Q?d8Acq9D/X87bP?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Hcyr/Jz/8OIZxRWrfKtKDoEb9Y1b1kKn6WYuEr8Pk/jfaRFHhMUqf7gGMA7XGqJu6D96Mf05SE4cp0s9M+ufra3C+XWyjrv1MtJ94VQvHX8/2ezyV+jOxZuKg3MIwJ15bBTLszghE9k2og3yTBipMQzfm5u7EaFnW+zO+C1HYW+Rvqhdcl0yk//hcGLcMD879X3qB8R+933HFlUCd5RxA2Ek8+iZ3q3RFpwZO/Pr+5zYSsvvd6QTVZPg5yZPXIECDiQY/5Th2H4JveOZPsh3W2mMggxuMNTJUF6MkU7k/AsmjGdZiPdlRr5vIx4AKZxLG9PXbNy1QDL9/LsMctDmYrdzWSGQkVB7+LAaMEF4xqZFCoCfGaO5uCJ/+/8kw1DZD6Jd4nlHyFxlofVxCikp2E6UfGOrQH2QDkiBhNBeXqE+DYHtxw3DaMqkofnYUDjf8vGOkj5LW9Svyz5sq/F7tr/RJfpjHK18Xz+M+i0Z8/NEu3ewxzUGqX85mvaklyCU6RBORMelrPlFZ8td3HaaDUzwLd25P1kbpm4hGtfM8oDxL5h4bUdGy4IWWZ0lCzHHAXAQ4BpMyJtBxw3DOdscwQwXg4T4YtFvEyHGA7BLD6h3zbZnG1cHixxLbJMFs1lJ5GJll+aCXLh72CrLsJS8Pw==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 00:05:39.2917
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 07ccda9f-6189-4c09-3d69-08dced7644aa
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015C9.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR19MB6133
X-OriginatorOrg: ddn.com
X-BESS-ID: 1729039185-103926-12767-18337-1
X-BESS-VER: 2019.1_20241015.1627
X-BESS-Apparent-Source-IP: 104.47.58.175
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVsaGpkZAVgZQMDkx0dTAzDzJ0D
	LRMC3NyMzUwNw4MdHQyMDSwsTUIDlFqTYWAKwjkepBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.259752 [from 
	cloudscan20-251.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND, BSF_SC0_MISMATCH_TO
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
 fs/fuse/dev_uring.c | 62 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 6632c9163b8a51c39e07258fea631cf9383ce538..5603831d490c64045ff402140c317019e69f8987 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -21,6 +21,7 @@ MODULE_PARM_DESC(enable_uring,
 
 struct fuse_uring_cmd_pdu {
 	struct fuse_ring_ent *ring_ent;
+	struct fuse_ring_queue *queue;
 };
 
 /*
@@ -374,6 +375,61 @@ void fuse_uring_stop_queues(struct fuse_ring *ring)
 	}
 }
 
+/*
+ * Handle IO_URING_F_CANCEL, typically should come on on daemon termination
+ */
+static void fuse_uring_cancel(struct io_uring_cmd *cmd,
+			      unsigned int issue_flags, struct fuse_conn *fc)
+{
+	struct fuse_uring_cmd_pdu *pdu = (struct fuse_uring_cmd_pdu *)cmd->pdu;
+	struct fuse_ring_queue *queue = pdu->queue;
+	struct fuse_ring_ent *ent;
+	bool found = false;
+	bool need_cmd_done = false;
+
+	spin_lock(&queue->lock);
+
+	/* XXX: This is cumbersome for large queues. */
+	list_for_each_entry(ent, &queue->ent_avail_queue, list) {
+		if (pdu->ring_ent == ent) {
+			found = true;
+			break;
+		}
+	}
+
+	if (!found) {
+		pr_info("qid=%d Did not find ent=%p", queue->qid, ent);
+		spin_unlock(&queue->lock);
+		return;
+	}
+
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
@@ -902,6 +958,7 @@ static int fuse_uring_fetch(struct io_uring_cmd *cmd, unsigned int issue_flags,
 		goto err;
 
 	atomic_inc(&ring->queue_refs);
+	fuse_uring_prepare_cancel(cmd, issue_flags, ring_ent);
 	_fuse_uring_fetch(ring_ent, cmd, issue_flags);
 
 	return 0;
@@ -947,6 +1004,11 @@ int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	if (fc->aborted)
 		goto out;
 
+	if ((unlikely(issue_flags & IO_URING_F_CANCEL))) {
+		fuse_uring_cancel(cmd, issue_flags, fc);
+		return 0;
+	}
+
 	switch (cmd_op) {
 	case FUSE_URING_REQ_FETCH:
 		err = fuse_uring_fetch(cmd, issue_flags, fc);

-- 
2.43.0


