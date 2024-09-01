Return-Path: <io-uring+bounces-3005-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 80CDF967724
	for <lists+io-uring@lfdr.de>; Sun,  1 Sep 2024 16:36:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0AC561F20F04
	for <lists+io-uring@lfdr.de>; Sun,  1 Sep 2024 14:36:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E893A143C6C;
	Sun,  1 Sep 2024 14:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="Oy1C5Ym4"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23B84D8AF
	for <io-uring@vger.kernel.org>; Sun,  1 Sep 2024 14:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725201361; cv=fail; b=uYcoTsSbmSWdOXTiz1dyX7ZSF8gF5Qiynu8t6U6s5CNtqUSbsIvbW1LspqKWuRuFiZLvE//txLMbbAXwWWIlOQ/uXUEJNFrjdj498MIB8KJCPTQeLuF0kOdwk1IOJM2suVHjJveJYMvk9JQf7BA/Zzr7T49ZEEEHnMofM1lpf+0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725201361; c=relaxed/simple;
	bh=ZME187ZIoTraUGLA+e92Xf8VYOAztMWsB26PBlPBFwc=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=ZZj/+PqZdDYnX2P1LtbCiFDgYli63TXLG/kZQ0aUsIENQBKXXNvvTbFmKEKvyc4+mJcw0PLEt7hPb4/EvJnAuaW6ag2rX8T2dbcBKatNbPLFRnUOXWz28GQcVHqgUT2nXoRJ1Y0HMvcwW6RJk4M21yyQnhN4EG3U3sIpP7U0rGg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=Oy1C5Ym4; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176]) by mx-outbound22-208.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Sun, 01 Sep 2024 14:35:55 +0000
Received: from BY5PR19MB4099.namprd19.prod.outlook.com (2603:10b6:a03:227::9)
 by MW3PR19MB4297.namprd19.prod.outlook.com (2603:10b6:303:43::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23; Sun, 1 Sep
 2024 14:35:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jBXdAK2NAVsRMORTKd/avQlHmyFk8OVjAzbZlI8zCp/YipPxoMnKI0TbNXTF/785C8jEkFPYA5c9rYwFuzQAZFZZsbYBg8VjYfeoYM0Gi+J2vl+azgePHgWjjEMu3LgCq40T+LDdnWS71h5EMfzMnfjTFd26WV8Mc409zHES+sPaZ1PzELd9m78M2XkeL3l+PgKdsRlGm3Iyp5lggj2kd1gcb/SI2tVDAKlByQP8qyQfcB2AsmSWB5OKxrIBuVBHA8kquODNsPAtURyasFGjcdsUSdJi3h7/NZBHGFQSUSscKYyOYK8BJiS/qmo+XbYkHLshnnz97VYP2MXlG5wAdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UT7S0BfdKG4BGgtmjVp0ARGSuyWmBwCxdlteWjySkNo=;
 b=iUcEh8GmVpCprzpaQSQ1B/NAuaQhXk8dy2hN+JTC5209Tos0Fh56wsoAcWi/qI8rqPINR/IeyiCio7hKI1jVAgLQCHoFt/SDJ/9DVaZ0cnrIGtt38DKx6xwR6uRBqrmhH06+l5UX3qv2tkOezz9IVZ9s/kb7+OpzGWPiR9a4UikxIwFKoWMM0yzzxSpgd9yK9YSotdFFR40cZI47qGzog2ws6CtMAENU/AFxHNKjK7am3ex+u9HTV09ASDec3aB0PNyN55UHnAKnh1BhrH/GJm2wgH71ci0yDfnClY0FfLAK2INANFYRvHt6frPqpd1kkH3T81dZWuBItDuBIc6JIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UT7S0BfdKG4BGgtmjVp0ARGSuyWmBwCxdlteWjySkNo=;
 b=Oy1C5Ym4Ls3ELTFF9Nj3JqcpOhoz+ErBR6gFat2gXmQhUz+T205o7e/GpTjerHw8jdyJnygvzzZE9V5EMxwZTNu5ID5yS5ZDguPoOChivdxNTP72M7WPv24USWetTPSbV315EAdxMaQrqNC8JRNYX4XVxIFKRk5J88cNT6Cte4o=
Received: from DM6PR03CA0021.namprd03.prod.outlook.com (2603:10b6:5:40::34) by
 BY5PR19MB4099.namprd19.prod.outlook.com (2603:10b6:a03:227::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.23; Sun, 1 Sep 2024 13:36:58 +0000
Received: from CH2PEPF00000142.namprd02.prod.outlook.com
 (2603:10b6:5:40:cafe::c5) by DM6PR03CA0021.outlook.office365.com
 (2603:10b6:5:40::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23 via Frontend
 Transport; Sun, 1 Sep 2024 13:36:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CH2PEPF00000142.mail.protection.outlook.com (10.167.244.75) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.7918.13
 via Frontend Transport; Sun, 1 Sep 2024 13:36:58 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id AB53A72;
	Sun,  1 Sep 2024 13:36:57 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Subject: [PATCH RFC v3 00/17] fuse: fuse-over-io-uring
Date: Sun, 01 Sep 2024 15:36:54 +0200
Message-Id: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPZt1GYC/x3NsQqDMBCA4VeRm3twJtJi10IfoGvpkMaL3mCUi
 7GC+O6Gjt/y/zskVuEE92oH5VWSTLHAXirwg4s9o3TFYMg01FKN3wZDToxZJfaowa8Wf7IMU15
 wHN2Mre/c1Rqimm5QMrNykO2/eMPr+YDPcZxc/3GidwAAAA==
To: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>, 
 Pavel Begunkov <asml.silence@gmail.com>, bernd@fastmail.fm
Cc: linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1725197817; l=10651;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=ZME187ZIoTraUGLA+e92Xf8VYOAztMWsB26PBlPBFwc=;
 b=G5bJxrVIiSVc1uWOoxAQh/t4RlWO1Qd3kTzRkiy0UBGvA1Lj356t2Lwx673uEdHgIcUuMIBqM
 O/Fezqcfz/oC4iPx71Ajqd6PsdQE9RIPL2m24gVOyHMGCPVbNk8eF+V
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
	CH2PEPF00000142:EE_|BY5PR19MB4099:EE_|MW3PR19MB4297:EE_
X-MS-Office365-Filtering-Correlation-Id: d621f560-f5cb-4289-ac18-08dcca8b2722
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?QlptZVJSaWZLZmZkOUJGSy84Ykk0U1dZTStGOCtnVjZVRXp3eFdlbU9KaVFF?=
 =?utf-8?B?OWZtczlqaFpVWlF1c3VvNlVjMGtRMEJQNlNxV1lLaENyUVF4TUF0bzd4dUhJ?=
 =?utf-8?B?SWVvdUJhb1VxYjBQcEsvUkdZMnNCbjFMcjVrNm02Yll0WHZPU01WVkFRT1Z0?=
 =?utf-8?B?blVSU3Z1aHBrMFEwNmo3bm5Odzd3QjM1cVFqMXhYTkZWVVFhSldUZEJVNUVT?=
 =?utf-8?B?YWFyQlh0OVcxZ2pjeDhOUFgwd2xKUGprblFKOCtlb2ViQWFsQSt0aDhOVERj?=
 =?utf-8?B?L1NsY3dianBzbTBBQUo3VWtvYTROcW01eFhpNFIwaFdEWHBENnUzUmhPVnpQ?=
 =?utf-8?B?YWdOM3dYcTNoQlZaRmJoZnQxVFQxSTA3RHFibDhWMk1nNXM3RHdNTXdDTlV5?=
 =?utf-8?B?U0RIOEtkekJ3M1VRZ2lWcHExNmduc2xtQjJJMEp4bWRJdFcyT1p0ckpHTzFK?=
 =?utf-8?B?K2xtUXlxTXAvQThoVkt2RDQxRXZ0VHpMbm0wSy9nYWRuNDJSSmRLRkZJWDQz?=
 =?utf-8?B?ZXI5OVhweldpSGQrQlJlSE81ZktkK25QVGY1RmFqRzB1enhKSC95QUc0L2xS?=
 =?utf-8?B?cGkyc0ZQSU5Pb2hBVlhqZ0preVVueTNHTHhOWGFLMGY2SVIwanB6bllnQlNs?=
 =?utf-8?B?Z0RmTnlrZmwrVUNFVmtIeUdJK29XYUZPTlRxQWdlRWwrU0VTUU82cjMrbERo?=
 =?utf-8?B?NktRbFFpbUNMbmVxWEVHTllUWHpqZkROT2hrTHRubHhWWEpYcVFtRlVXOWV6?=
 =?utf-8?B?M2FaaWQ4M2JpeVdjVXlYaDIzK3BrYmcwTGFBY1pieWwvN2hBUGNXb3NLZGh5?=
 =?utf-8?B?b0JjeFhKcERQYUlUT0VENm5IZHJ4UWpNZElDSHQzSUhxTnEybnZkYlVCWTdG?=
 =?utf-8?B?UXNFb2l5R1lZZUFGN1dVS2trUGFwcitBMlpoN1BDdngyL000L3M4TUQ1SEV4?=
 =?utf-8?B?QkNOc25UNFVlUlNjVFk0YzZLTi9MYzNpTGZ3U3ZGbWJmaU5UemhwY01CN1hL?=
 =?utf-8?B?QjBIY09XSGg2L0tHbklFazBWa24yRXpNWVc3U1hMdlExL3FKRVgvTTRSWjBL?=
 =?utf-8?B?V01VMS9RamlqVG1GM21mL3FKYnl4QkFyTG1lbDdRUUdYTmZadVIwRk9zMTRS?=
 =?utf-8?B?dDhVWEJmeVFVUWdDcWNuWVpWL1JIbmhpZTV0ekptT3VMUG9idVR4U2t2UVBX?=
 =?utf-8?B?UU9nV3k2bHBDOTJjQytIdFZyM3JyNlFYd3JRZmp1VE9wRE9rY0hES2dDZExp?=
 =?utf-8?B?alFyZE5aOHlLUC81TTE2UGgxQytlTjZBQm1oRnIxcEVzNnBPRDUxMitlZ0xZ?=
 =?utf-8?B?OXJQVHVMdm5GdmE5d2JNckRrakN5WjNLVkR3TDB4dzdqT1hXeitXdVI3UlBE?=
 =?utf-8?B?VDMwbERsZ3VCQjIvay83TTN2WnFIcjFTQlB4SHpCRzJpRXlVRHhVWTJKNWRx?=
 =?utf-8?B?WVo1bUdkM1pqbzQxQXkyT3pUU0dRWEZ6SmJnanFaSzJUUDcwQ2t5NmNoWE9O?=
 =?utf-8?B?RW1xSFl1dlJlMWtlSGpMSStWVFZEL25CTFh4RkhhTFkvUEN3aVh1RktKclAz?=
 =?utf-8?B?NDlVM2J4MUNCbmp1UGlFL2swNVJqdklpcWQ3ZlRpc1VPNmY1YmxBVHUzdzFu?=
 =?utf-8?B?dFJraENMK3NkYWsydWQ5aFMrNC9nK2xHK3A0TDlQTU9udWpya0lTR294Tkh0?=
 =?utf-8?B?MFhCTW9qZEM0NTYzYkdDQU5OUjdLUUViOGJLeTdYY0RHT0RYTk9jdFY2NFVL?=
 =?utf-8?B?UXNwYnJRd0NsOVV2Y1ljWmk1OTBMaGVCQnEvdlFZVzRhWVh6aFpja2NyWWo1?=
 =?utf-8?B?SHFvRzZCeFY5OVJoQmxQVE1Mck55ZG1JaGNWbXpabWZWYklCTWx6M1Y0WnNR?=
 =?utf-8?B?OXpnRml2WmphbXYxT055aTZDbm1uSVBSdU4zTmFoRjVTWFE9PQ==?=
X-Forefront-Antispam-Report:
 CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 O0chxY0PjSpr5qmS7/7F6dCDOXM+U9PBNtjqLDeG6g28+e60ulA3yjiaqmtNpg1CepgzXiFFj/puM304ADxch45Z2/6Dq1viUmjUQaC7k2vZ1iwVSYrUuGzmFxC3Js2zBH3Pdodgu2ABfXhjXCozHwcrthIac43RzkBoSxoP8Ig2gtXazcfgMy/ejiGi1ufbi1/SN7r1YtHxjb3x6ZHa/IUmmwMpYdpAjj2CYj3ZIBA4IkTYKSPpHs1oEqQXcJVaYeEG5CizhO0xqer4gMTYwVhx+4SxYWG1aNZWK+ABDcJaCcCdBMVEouV1kiYgMrmNsbP/aGJcS3fm+sXfRKrjNOmd+m404rV7qu9rVvkfVYGQgtYzj35xQFint/V/tsDgt+G1ibKKZe8T1geTu0/lJNQUVEhCghxT6Tgy/cirBQO8JBJTdyi1eYbN19APm892+vyZhVO0a989pPzPnCOIkqfJ4iq6vNe66TZNg4Nq2orTaFChYrTNefIDAmyUazKHOUMKCSnOmFRxLqMrjAG+dQ5BNq87S1qCS/tMwAl2RoNjaZxQ1zofz35Bnmi0HWaozYvfeYZpZTSJaZjMun0ywR2bIcBuM3jwdTatM6rm6VVPNSK585MLDMo0S6ERucv44bVF3yNJIX6LGVSLxtx6+g==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2024 13:36:58.3585
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d621f560-f5cb-4289-ac18-08dcca8b2722
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
 CH2PEPF00000142.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR19MB4099
X-OriginatorOrg: ddn.com
X-BESS-ID: 1725201355-105840-21272-41203-1
X-BESS-VER: 2019.1_20240829.0001
X-BESS-Apparent-Source-IP: 104.47.57.176
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoYGxpbGQGYGUNQsOdHI0sw8Mc
	XYPMXIONks0cTAzNLSwtw4ydAy1SA5Rak2FgAUwCG/QgAAAA==
X-BESS-Outbound-Spam-Score: 0.40
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.258744 [from 
	cloudscan20-139.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
	0.40 BSF_SC0_SA085b         META: Custom Rule SA085b 
X-BESS-Outbound-Spam-Status: SCORE=0.40 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC0_MISMATCH_TO, BSF_BESS_OUTBOUND, BSF_SC0_SA085b
X-BESS-BRTS-Status:1

This adds support for uring communication between kernel and
userspace daemon using opcode the IORING_OP_URING_CMD. The basic
appraoch was taken from ublk.  The patches are in RFC state,
some major changes are still to be expected.

Motivation for these patches is all to increase fuse performance.
In fuse-over-io-uring requests avoid core switching (application
on core X, processing of fuse server on random core Y) and use
shared memory between kernel and userspace to transfer data.
Similar approaches have been taken by ZUFS and FUSE2, though
not over io-uring, but through ioctl IOs

https://lwn.net/Articles/756625/
https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git/log/?h=fuse2

Avoiding cache line bouncing / numa systems was discussed
between Amir and Miklos before and Miklos had posted
part of the private discussion here
https://lore.kernel.org/linux-fsdevel/CAJfpegtL3NXPNgK1kuJR8kLu3WkVC_ErBPRfToLEiA_0=w3=hA@mail.gmail.com/

This cache line bouncing should be reduced by these patches, as
a) Switching between kernel and userspace is reduced by 50%,
as the request fetch (by read) and result commit (write) is replaced
by a single and submit and fetch command
b) Submitting via ring can avoid context switches at all.
Note: As of now userspace still needs to transition to the kernel to
wake up the submit the result, though it might be possible to
avoid that as well (for example either with IORING_SETUP_SQPOLL
(basic testing did not show performance advantage for now) or
the task that is submitting fuse requests to the ring could also
poll for results (needs additional work).

I had also noticed waitq wake-up latencies in fuse before
https://lore.kernel.org/lkml/9326bb76-680f-05f6-6f78-df6170afaa2c@fastmail.fm/T/

This spinning approach helped with performance (>40% improvement
for file creates), but due to random server side thread/core utilization
spinning cannot be well controlled in /dev/fuse mode.
With fuse-over-io-uring requests are handled on the same core
(sync requests) or on core+1 (large async requests) and performance
improvements are achieved without spinning.

Splice/zero-copy is not supported yet, Ming Lei is working
on io-uring support for ublk_drv, we can probably also use
that approach for fuse and get better zero copy than splice.
https://lore.kernel.org/io-uring/20240808162438.345884-1-ming.lei@redhat.com/

RFCv1 and RFCv2 have been tested with multiple xfstest runs in a VM
(32 cores) with a kernel that has several debug options
enabled (like KASAN and MSAN). RFCv3 is not that well tested yet.
O_DIRECT is currently not working well with /dev/fuse and
also these patches, a patch has been submitted to fix that (although
the approach is refused)
https://www.spinics.net/lists/linux-fsdevel/msg280028.html

Up the to RFCv2 nice effect in io-uring mode was that xftests run faster
(like generic/522 ~2400s /dev/fuse vs. ~1600s patched), though still
slow as this is with ASAN/leak-detection/etc.
With RFCv3 and removed mmap overall run time as approximately the same,
though some optimizations are removed in RFCv3, like submitting to
the ring from the task that created the fuse request (hence, without
io_uring_cmd_complete_in_task()).

The corresponding libfuse patches are on my uring branch,
but need cleanup for submission - will happen during the next
days.
https://github.com/bsbernd/libfuse/tree/uring

Testing with that libfuse branch is possible by running something
like:

example/passthrough_hp -o allow_other --debug-fuse --nopassthrough \
--uring --uring-per-core-queue --uring-fg-depth=1 --uring-bg-depth=1 \
/scratch/source /scratch/dest

With the --debug-fuse option one should see CQE in the request type,
if requests are received via io-uring:

cqe unique: 4, opcode: GETATTR (3), nodeid: 1, insize: 16, pid: 7060
    unique: 4, result=104

Without the --uring option "cqe" is replaced by the default "dev"

dev unique: 4, opcode: GETATTR (3), nodeid: 1, insize: 56, pid: 7117
   unique: 4, success, outsize: 120

TODO list for next RFC version
- make the buffer layout exactly the same as /dev/fuse IO
- different request size - a large ring queue size currently needs
too much memory, even if most of the queue size is needed for small
IOs

Future work
- notifications, probably on their own ring
- zero copy

I had run quite some benchmarks with linux-6.2 before LSFMMBPF2023,
which, resulted in some tuning patches (at the end of the
patch series).

Some benchmark results (with RFC v1)
=======================================

System used for the benchmark is a 32 core (HyperThreading enabled)
Xeon E5-2650 system. I don't have local disks attached that could do
>5GB/s IOs, for paged and dio results a patched version of passthrough-hp
was used that bypasses final reads/writes.

paged reads
-----------
            128K IO size                      1024K IO size
jobs   /dev/fuse     uring    gain     /dev/fuse    uring   gain
 1        1117        1921    1.72        1902       1942   1.02
 2        2502        3527    1.41        3066       3260   1.06
 4        5052        6125    1.21        5994       6097   1.02
 8        6273       10855    1.73        7101      10491   1.48
16        6373       11320    1.78        7660      11419   1.49
24        6111        9015    1.48        7600       9029   1.19
32        5725        7968    1.39        6986       7961   1.14

dio reads (1024K)
-----------------

jobs   /dev/fuse  uring   gain
1	    2023   3998	  2.42
2	    3375   7950   2.83
4	    3823   15022  3.58
8	    7796   22591  2.77
16	    8520   27864  3.27
24	    8361   20617  2.55
32	    8717   12971  1.55

mmap reads (4K)
---------------
(sequential, I probably should have made it random, sequential exposes
a rather interesting/weird 'optimized' memcpy issue - sequential becomes
reversed order 4K read)
https://lore.kernel.org/linux-fsdevel/aae918da-833f-7ec5-ac8a-115d66d80d0e@fastmail.fm/

jobs  /dev/fuse     uring    gain
1       130          323     2.49
2       219          538     2.46
4       503         1040     2.07
8       1472        2039     1.38
16      2191        3518     1.61
24      2453        4561     1.86
32      2178        5628     2.58

(Results on request, setting MAP_HUGETLB much improves performance
for both, io-uring mode then has a slight advantage only.)

creates/s
----------
threads /dev/fuse     uring   gain
1          3944       10121   2.57
2          8580       24524   2.86
4         16628       44426   2.67
8         46746       56716   1.21
16        79740      102966   1.29
20        80284      119502   1.49

(the gain drop with >=8 cores needs to be investigated)

Remaining TODO list for RFCv3:
--------------------------------
1) Let the ring configure ioctl return information,
like mmap/queue-buf size

Right now libfuse and kernel have lots of duplicated setup code
and any kind of pointer/offset mismatch results in a non-working
ring that is hard to debug - probably better when the kernel does
the calculations and returns that to server side

2) In combination with 1, ring requests should retrieve their
userspace address and length from kernel side instead of
calculating it through the mmaped queue buffer on their own.
(Introduction of FUSE_URING_BUF_ADDR_FETCH)

3) Add log buffer into the ioctl and ring-request

This is to provide better error messages (instead of just
errno)

3) Multiple IO sizes per queue

Small IOs and metadata requests do not need large buffer sizes,
we need multiple IO sizes per queue.

4) FUSE_INTERRUPT handling

These are not handled yet, kernel side is probably not difficult
anymore as ring entries take fuse requests through lists.

Long term TODO:
--------------
Notifications through io-uring, maybe with a separated ring,
but I'm not sure yet.

Changes since RFCv1
- Removed the __wake_on_current_cpu optimization (for now
  as that needs to go through another subsystem/tree) ,
  removing it means a significant performance drop)
- Removed MMAP (Miklos)
- Switched to two IOCTLs, instead of one ioctl that had a field
  for subcommands (ring and queue config) (Miklos)
- The ring entry state is a single state and not a bitmask anymore
  (Josef)
- Addressed several other comments from Josef (I need to go over
  the RFCv2 review again, I'm not sure if everything is addressed
  already)

---
- Link to v2: https://lore.kernel.org/all/20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com/
- Link to v1: https://lore.kernel.org/r/20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com

Signed-off-by: Bernd Schubert <bschubert@ddn.com>

---
Bernd Schubert (16):
      fuse: rename to fuse_dev_end_requests and make non-static
      fuse: Move fuse_get_dev to header file
      fuse: Move request bits
      fuse: Add fuse-io-uring design documentation
      fuse: Add a uring config ioctl
      fuse: Add the queue configuration ioctl
      fuse: {uring} Add a dev_release exception for fuse-over-io-uring
      fuse: {uring} Handle SQEs - register commands
      fuse: Make fuse_copy non static
      fuse: Add buffer offset for uring into fuse_copy_state
      fuse: {uring} Add uring sqe commit and fetch support
      fuse: {uring} Handle teardown of ring entries
      fuse: {uring} Add a ring queue and send method
      fuse: {uring} Allow to queue to the ring
      fuse: {uring} Handle IO_URING_F_TASK_DEAD
      fuse: {uring} Pin the user buffer

Pavel Begunkov (1):
      ate:   2024-08-30 15:43:32 +0100

 Documentation/filesystems/fuse-io-uring.rst |  108 +++
 fs/fuse/Kconfig                             |   12 +
 fs/fuse/Makefile                            |    1 +
 fs/fuse/dev.c                               |  254 ++++--
 fs/fuse/dev_uring.c                         | 1144 +++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h                       |  322 ++++++++
 fs/fuse/fuse_dev_i.h                        |   61 ++
 fs/fuse/fuse_i.h                            |    9 +
 fs/fuse/inode.c                             |    3 +
 include/linux/io_uring_types.h              |    1 +
 include/uapi/linux/fuse.h                   |  124 +++
 io_uring/uring_cmd.c                        |    6 +-
 12 files changed, 1989 insertions(+), 56 deletions(-)
---
base-commit: 0c3836482481200ead7b416ca80c68a29cfdaabd
change-id: 20240901-b4-fuse-uring-rfcv3-without-mmap-9cda63200107

Best regards,
-- 
Bernd Schubert <bschubert@ddn.com>


