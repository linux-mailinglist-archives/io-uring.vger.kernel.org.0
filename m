Return-Path: <io-uring+bounces-5172-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3A779E194C
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 11:31:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E7241641F2
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 10:31:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48A6C1E0DEB;
	Tue,  3 Dec 2024 10:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="1z6U+VJ2"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030A01E22FC;
	Tue,  3 Dec 2024 10:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733221905; cv=fail; b=nxNYy/Q927wVzHHFXJXxtPTPEl9dpLHwWK3aCVMxeQIGks6Lhu3XCJktnJgEiIR+qMSKZO7t1AddF/0R3Yc+gUhRlyaHQNdUx+tqnrds6EYBM038Sn8yampEF2sF6PukFjvs70uehYJ85Hi25Z46F+h7ZjInZ8y+xgDiw5jEl9w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733221905; c=relaxed/simple;
	bh=nHOmP131y8Oa0pNAcfAJzQe30Jz/Aighg/q+swsXXwk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=buDmVRU8etU/urTEKOkL5xWrLC/Fj6NsO4eBkFR+sU+VSFIQO0XXZn35ufTIfFfprm4p0bZIwdLChJQcsD/okh5EkA8MiGgKUXwCPrkxhmsSUWZ+GvRCKQKghJvhhR08fldbT/qrSTRRzUHCQRSVYN5to/6uh8gYKRE3am5Q2xY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=1z6U+VJ2; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176]) by mx-outbound43-165.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Tue, 03 Dec 2024 10:31:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dmMDBqwW1p1iQDTdmZn7ydxhNfhdmOyaIVuwGcGuX3WGRV6WfZuc31AeR9fqRO2sXh5bGo+OTY+RNuq8VRnLD5gHhQ/GNeO7Mxe++Ei3Mow0CavEJMcesBEaXPTuj46cUweqqVVYT7kgNoqJPT+BZ7eeBhR5CzUz2bBfXb0reeoXi696t5anDI7ObCY9TZoCnyxdORynx6EC5s9Zk5sev76z7Zj70dCN6a3ngMTes07ZPWeaGmgnZ09DMAGyepFauF62PCsvq9q4XKUNvsfqRQIPp6qTVpYuElqHCelRJS7kv29nZzTh2/4nzKPvMAbIteffthVR+kAFPpKSOgqySw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wVm4H8RXRaqZ8LBjd2ZCTdPtiLPehx//xhmLmyaFlEE=;
 b=ina2YTmhmwDi1oCxjTENhC3Dz6IN7CAxOhxl4tAfMx85kXZ+Fbsq6rj7TugPILvOSPzMVS79pzaWp1+oTsYCEoLnu8IzjFO6ZtscfUoXiWm+PvhtKROJ69enaMR6CiUtF1fSjlb6RSeWyS6ByUMV3lO9MvR1SVEy0S+bthYORxeayjY7PhW/uV6U01efwFhbjwS5oSasXYao5fwpXYaC2DzDfAqNmIIEO9W7Bkw6lM/tXaNo2fguFk+7a8YRrWp8MdHXDOpRjKqyJTA+TQpl46gTiwLWuIQ1eDuXJzN5x/tr8R27JukX7kYdn+1kvPQ43ZaOSrx9WVD1AqTDn2MKRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wVm4H8RXRaqZ8LBjd2ZCTdPtiLPehx//xhmLmyaFlEE=;
 b=1z6U+VJ2fSHHN1WCrLUMeXQUHHk449npu6OGEVvkPomK9LkkAxJ4Jtb+x85mObt21keZODnglEoXyFE9RpIz2wiJ16u+ZZKKiWs6kgqfwCMXZvZGTlxhkqxSXq7Mr2uXkJoWstS7d2pv2czi762mlX4LJA3zurFjUg99zgm226g=
Received: from CH0PR13CA0005.namprd13.prod.outlook.com (2603:10b6:610:b1::10)
 by CO6PR19MB5402.namprd19.prod.outlook.com (2603:10b6:303:149::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.19; Tue, 3 Dec
 2024 10:31:07 +0000
Received: from CH1PEPF0000A345.namprd04.prod.outlook.com
 (2603:10b6:610:b1:cafe::a0) by CH0PR13CA0005.outlook.office365.com
 (2603:10b6:610:b1::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.9 via Frontend Transport; Tue, 3
 Dec 2024 10:31:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CH1PEPF0000A345.mail.protection.outlook.com (10.167.244.8) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.7
 via Frontend Transport; Tue, 3 Dec 2024 10:31:06 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 09A2E2D;
	Tue,  3 Dec 2024 10:31:05 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Tue, 03 Dec 2024 11:31:05 +0100
Subject: [PATCH v2] io_uring: Change res2 parameter type in
 io_uring_cmd_done
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241203-io_uring_cmd_done-res2-as-u64-v2-1-5e59ae617151@ddn.com>
X-B4-Tracking: v=1; b=H4sIAOjdTmcC/42NTQrCMBBGr1Jm7Yj5wVRX3kNKicmknUUTSWxRS
 u9u7AncfPC+xXsrFMpMBa7NCpkWLpxiBXlowI02DoTsK4M8SS3qIKd+zhyH3k2+9ykSZioSbcH
 5rFEKYzVp87ioANXxzBT4vfvvXeWRyyvlz55bxO/917wIFGh0UEq1rVO+vXkfjy5N0G3b9gXyC
 z3GyAAAAA==
X-Change-ID: 20241202-io_uring_cmd_done-res2-as-u64-217a4e47b93f
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 Kanchan Joshi <joshi.k@samsung.com>
Cc: io-uring@vger.kernel.org, stable@vger.kernel.org, 
 Li Zetao <lizetao1@huawei.com>, Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1733221865; l=2910;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=nHOmP131y8Oa0pNAcfAJzQe30Jz/Aighg/q+swsXXwk=;
 b=0U6Vw6jig85BFWmh3BSXWa7em1TjIOR0bhui/6Y+pU7E+mEQLkmrrPQZ6UKEAWIRyf2JYnMBC
 XEvB3vBqXisBPKNwTeKWFKVAYbU0SpYWmZcps2N15ENRXRHztoP+2Au
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A345:EE_|CO6PR19MB5402:EE_
X-MS-Office365-Filtering-Correlation-Id: d2c9a0a2-414a-4e11-77a9-08dd138598b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NXRsTjJFRmpnMFMrMGFTdy83MG9SVktHUHl4dHhKYUJKaVJzelZFS1BaVHhy?=
 =?utf-8?B?L0hVQUorNi9ZbVk1MGdvMldjOW9aY1Q5cWtRbU43K3RmSUVDVE4xcVFDRXZu?=
 =?utf-8?B?bUlBMlc0QjVtY1R2T0hPZzBFaWx2SFFLL1hlclRQbjFWRXdHdDNyN0VMckJZ?=
 =?utf-8?B?SWlIZW1aMzhqdm5Vand0Q3BPWkpad0lwaDM5alByTGVFV2VlQlJncHlRT0w1?=
 =?utf-8?B?UVN3dlM1c0t6YjJzaHJxREpPMEZyN0pqZnlLNk9udEU0QXdIS21CeXpKbjdo?=
 =?utf-8?B?UGVhakRlcUkwN3lQZ2FJM1M2ZWhCdE8waVRIaUJlV1VBTllvM3czdWVQaFha?=
 =?utf-8?B?Y2ZUcHA0Z3FFRC81T3FpQmU3THgycVVQL3Y0QzZMZHZaMGRvOUt1emFtT3k1?=
 =?utf-8?B?MnJMTy9oUlkweEo4ZzBQM1hVZGp3UWJLNVh1Z3ZkRk1lT0l4SXB4WUZ3QSsr?=
 =?utf-8?B?aWxpMXVzVzZTMjBWc0RDdnFhdlpJZkIzMFVZRitySEl3ZTh3UCs3dGdsbzR0?=
 =?utf-8?B?R3prTmpiVzZ2T2pwVDZyRGNIYWczRStNVENPckF1dDJpUWkxeGNTdlNrS3BK?=
 =?utf-8?B?cUdNYWtLQ2FWa21tR2NUZUIweDNpWUxBT1I1M0tUT0xTcTBybWkxN0ovbHZi?=
 =?utf-8?B?QUVzVlNVKzluSVJrNmFhcmExeTU4L29sUkR6a3RhVStKN2xuanhrTlRKeDBU?=
 =?utf-8?B?NEZPU3R0bktXand0MjQ0M2txQnRJSHBMZ3ZZOGNQY0dLQko2OENGanBTY21K?=
 =?utf-8?B?cDdPbzkvR2t5RUYzWEJIZHdwZU9VTFVuNjRZd3pTUGRmai9oU1ozSURFZUx5?=
 =?utf-8?B?SUIvQWFBSkE0RVZuYWZoYnMySkR5OHBackxVN0lVRFIxUTJVa3NyNTdDTndr?=
 =?utf-8?B?QkdVc2hEQVU4K2xISWdwaC90M01xQzFYaURCWFFtRUFvR1lNUU9WOVRwcFdh?=
 =?utf-8?B?Vi96aEJJdDJGNUNNalJwSkxuUzdvK0pieC9WY0xGSmN0NHZrSnFUNzJCWFkr?=
 =?utf-8?B?dzg0THo4dzM4bHNTZU53V3ptUGRPYm8vTHk5aTZ5OVhrTXZIeEVobG02WHRW?=
 =?utf-8?B?WHMyQUxybkJrZTZiakRaUUpFRG9QM0p6aThjQjBSMWRRQkF3a2xEcUlieEx0?=
 =?utf-8?B?TXZGRGpDUi9WV3pQcjBCY040eDVJU1p0dy8rMmpoSElodWNvanQvazJ6dTBz?=
 =?utf-8?B?TUY1bnFzd1dYTkY1c1pBY25uWUQ5Y2xZVEgxalRrODFrenN6V2xUUTBtNy9Z?=
 =?utf-8?B?SW82V0I3MVVyRkpZNFlxeXczUXQ5YVpWbWNZekJqMHhCekJ2VnRsYkdBYVp0?=
 =?utf-8?B?cEswU091WUNXTzkwNmpWZEExSmkyKzBoNHRoblRlVy9SaUVINnlaemkwMCta?=
 =?utf-8?B?U2pSSFRmdGwrZEhYaTAxTE5NNEErZVJQNStnMzl3NHg2Mkk1RkpoS3dDTWUx?=
 =?utf-8?B?VGRUTGQ2M2V6cFUzN1d6bjdad3V1QWhKRXcwSHlLOHF5VEpmcjljalBHZVV5?=
 =?utf-8?B?MDVaSld3MEszcWV0YjgzelJXbTd0YVVPWGJUNU9MOFJ5dGEzOHRQbU5zU0E3?=
 =?utf-8?B?b2FzeUVFUWRGZXZtTVU5cGR0NjQ0VWNFNWlQYkxJY1dsYW1jSDVBQjR0emZm?=
 =?utf-8?B?SUk4aUZnejBrNG9zWHFSUTEwUG5hL0tWLzd3R2dPUUtUelZYQTlDdHBNZHZ3?=
 =?utf-8?B?NFBEdjVKQ0o4MkJhRHo1YldvMlM2a25DUzM1S1BUTXhmUTN2NXJCRE10VTJh?=
 =?utf-8?B?ZkJmbkc1R0RXUGlBdjlqdFFhYWVnbXB5M2QvWWVqa2VKTVJoa1Z1TDNrS2dD?=
 =?utf-8?B?TkVzOTBvSlF2c1VOcWM0Wlpxcnk2U2xnU2F6SE0zMXVsQ2IvQS9JRXVFN2ww?=
 =?utf-8?B?MFNrUUMxblRUUGRoT3NFbUlHSW5pMm4wZm1RRDBoQU9OU1RWdlZmRXllelFD?=
 =?utf-8?Q?Zk1+S9oPDs3X9C0Wv3uslEnyi18U+lz2?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	v3txr2d348mNjUEUZOxByHvdmNznyBC19QKedNgpOEzHz4T0PLPRP3ya6I9s8MGXVLxqvEzcGDy9Q7Kf0nKgTVV52KMv/zr9cMUwerzAwCQSAoAJajGsdYHrivrLD57lZcbZdn+pcHDUdHqJ/LAoX9Nk7VsPnHI0HAk/h4KSYqgemk1Inkg6lwibqRSI5Unh7ZFyn3dLfDGmPB8j4Nm8SWchhnUC69huadR6caV0LdLK77lN/Yp1WhIU2KbeD8f4Si+S1AjQ/QaKx/wEhntHq2gC4jV/NWTaD3L0Q7FqYXtpIPLfYcwrhZKM31gUnpq9HUr+CaaN/4jhnZm2MXFWaNSWiokKFWRcSFMIWTkuICPdwc4wd9r1YKkWO1nHAeC59oKkNiXIGkmkwKsVVJuk0U1RY+s+Sy8iICJaK18kgZbDel0FBd871jIMM1ADIaZJ87gDx2xkZcgmg0sXSPWs4hieocjRAwmrkiO1xW68zcKN0aLA9F9rGG/O94QXxz/cwFlx+vxNn1c5mR7P6mNUe2FyFuaR73Sv2bdxAhWwtSgpdO0eKcM15FUS3HdAbUCMoQW7vGTQrn1evcvEJxe0YJ7kCpShNSemn/4eDrKoIeHUJDVzH+Imw0U9Wt5pa5qc2y/79XXeKNkgWgmnafHoUw==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2024 10:31:06.8276
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d2c9a0a2-414a-4e11-77a9-08dd138598b6
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A345.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR19MB5402
X-BESS-ID: 1733221870-111173-13374-2072-1
X-BESS-VER: 2019.1_20241126.2220
X-BESS-Apparent-Source-IP: 104.47.59.176
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVkYWJiZAVgZQ0MAyySDV1CzVIC
	XN3MzYMM0iMc3S2NwsMSUpycLcyDhJqTYWAKvmSClBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260854 [from 
	cloudscan19-146.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

Change the type of the res2 parameter in io_uring_cmd_done from ssize_t
to u64. This aligns the parameter type with io_req_set_cqe32_extra,
which expects u64 arguments.
The change eliminates potential issues on 32-bit architectures where
ssize_t might be 32-bit.

Only user of passing res2 is drivers/nvme/host/ioctl.c and it actually
passes u64.

Fixes: ee692a21e9bf ("fs,io_uring: add infrastructure for uring-cmd")
Cc: stable@vger.kernel.org
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Tested-by: Li Zetao <lizetao1@huawei.com>
Reviewed-by: Li Zetao <lizetao1@huawei.com>
Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
Changes in v2:
- As suggested by Li Zetao, also update the type with CONFIG_IO_URING=n
- Link to v1: https://lore.kernel.org/r/20241202-io_uring_cmd_done-res2-as-u64-v1-1-74f33388c3d8@ddn.com
---
 include/linux/io_uring/cmd.h | 4 ++--
 io_uring/uring_cmd.c         | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 578a3fdf5c719cf45fd4b6f9c894204d6b4f946c..0d5448c0b86cdde2e9764842adebafa1f8f49e61 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -43,7 +43,7 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
  * Note: the caller should never hard code @issue_flags and is only allowed
  * to pass the mask provided by the core io_uring code.
  */
-void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2,
+void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, u64 res2,
 			unsigned issue_flags);
 
 void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
@@ -67,7 +67,7 @@ static inline int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 	return -EOPNOTSUPP;
 }
 static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret,
-		ssize_t ret2, unsigned issue_flags)
+		u64 ret2, unsigned issue_flags)
 {
 }
 static inline void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index d9fb2143f56ff5d13483687fa949c293f9b8dbef..af842e9b4eb975ba56aaeaaa0c2e207a7732beba 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -151,7 +151,7 @@ static inline void io_req_set_cqe32_extra(struct io_kiocb *req,
  * Called by consumers of io_uring_cmd, if they originally returned
  * -EIOCBQUEUED upon receiving the command.
  */
-void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2,
+void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, u64 res2,
 		       unsigned issue_flags)
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);

---
base-commit: 7af08b57bcb9ebf78675c50069c54125c0a8b795
change-id: 20241202-io_uring_cmd_done-res2-as-u64-217a4e47b93f

Best regards,
-- 
Bernd Schubert <bschubert@ddn.com>


