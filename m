Return-Path: <io-uring+bounces-5710-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8FF8A034C3
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 02:59:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CD3A47A23BA
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 01:59:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE8C14964F;
	Tue,  7 Jan 2025 01:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="DXVLzWxx"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B449A7080E
	for <io-uring@vger.kernel.org>; Tue,  7 Jan 2025 01:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736215160; cv=fail; b=BKO5CDq5lUr5Vrz9uSKRVCo0iaSj9aeXnr5M5QK0T+j/RsTw+Qkj8tbS66ZBomQuQJzfSlNByBGO/TdoK/VrEiVVAM1IwKouE93UlQRcyiRAKcs5GIzxKNetmfBRuVHaTptLcSyvvOHgh7HchXuTEXT8y5UYoxqgAvqzGbpPLWk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736215160; c=relaxed/simple;
	bh=hbrqLrzVQ8p6pBRv8IEhG30OABD16GwccSapM1sxW5Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=oB4bWg7+UFU4hLBscUEnnsNcl0r1QW0iecRKmznCS4ZpVxD9XPV/NDNutpxqbYHyMH+HvSKcxqqXVxqpxqJQON9V0VLNqLjFHMre//D5lY6D6a7VzoZtVrvzcRKUYtq+VKAwRYdO04K2plZL2z3tyWCcLSY7SSzHNuFsVWz2Zdk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=DXVLzWxx; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2043.outbound.protection.outlook.com [104.47.56.43]) by mx-outbound40-113.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Tue, 07 Jan 2025 01:59:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ffLhA0AmcVE3HpK9s5llsW1eFke6k1TqvQjbLCvvfPFov2Pgo9QbyyaAA16z3IQ0z34rNOkeFVXzOVYuN1ZI1yv6nDJDvllzCbgMBLuIWdYZEVEGyiHilSXyKNtLJYVXwHZ91SQwptLH96TotZ60b61+M3NNCWmChMNjZTCekvgD498UBWXAaZLzeOB3P9zSqbHWzXFga2Xzco+4dJsaSBakVECJmSSC3lNDTjH+fwoRQpphDnt80l18ol9ktmSlZ2S0kPwJaj5+t5kLbpDnbjCnnqoEv1NJa9W0w5LmWJ9qkvBnzd3qqu+kdhc7Y64oONdOlb0s9Z1I2dm8XdXrQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q2+Oc6tUk6NXTUSXsYpk5uTJfTakaKecuMbxhiDV+BE=;
 b=Mrz/HKRTB038Fk43lxgV1DkgvT3g7zAyVrwlWWURolBDqauzvLQ4q7GVLLSliX7aqK6tJIHwzGa0sbvxZbUyX7w4S5UBEnAysVCe+nr+FOb5l8N+3vG+xhQwf5RvCtIa0WmDSksKco3KX6VglC5eclklV/zKNEpEEyK9HSlSF0jgCKO/U5+91I+anuUuOrJ7Uw5QlXTll3fJWaX7r3OVbd6ZSXrVzZuu+gWq/06EI52bMbL/JpzX3q5Nof9fhbmoTtzE0SaNPJKwa6C2rELf9NB+pFSDY6vl7ZtpMW+mPKulyogGDrO7p3m1ysQKAoohfXl60f3orUZ0G3nY4mr7NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q2+Oc6tUk6NXTUSXsYpk5uTJfTakaKecuMbxhiDV+BE=;
 b=DXVLzWxxukFMS6ZwpbWkdfw5AXYX+4UupGplznA5ES/fvbW4QJTX9ibGnpZ+rYt4gSDt5pHCFzoYd29xwxWzKdgU+XNHQlWOSjLTxI5n18Z9PVk/N/IhM43/4jbp4gwZPQl4H4X++PlDvPPQcsq24trTSVWRlEqddHjqWZwNNtg=
Received: from MW4PR04CA0151.namprd04.prod.outlook.com (2603:10b6:303:85::6)
 by LV2PR19MB5864.namprd19.prod.outlook.com (2603:10b6:408:172::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Tue, 7 Jan
 2025 00:25:19 +0000
Received: from SJ1PEPF00002321.namprd03.prod.outlook.com
 (2603:10b6:303:85:cafe::93) by MW4PR04CA0151.outlook.office365.com
 (2603:10b6:303:85::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.16 via Frontend Transport; Tue,
 7 Jan 2025 00:25:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SJ1PEPF00002321.mail.protection.outlook.com (10.167.242.91) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8335.7
 via Frontend Transport; Tue, 7 Jan 2025 00:25:17 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id E8B774D;
	Tue,  7 Jan 2025 00:25:16 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Tue, 07 Jan 2025 01:25:11 +0100
Subject: [PATCH v9 06/17] fuse: {io-uring} Handle SQEs - register commands
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250107-fuse-uring-for-6-10-rfc4-v9-6-9c786f9a7a9d@ddn.com>
References: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
In-Reply-To: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1736209509; l=17357;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=hbrqLrzVQ8p6pBRv8IEhG30OABD16GwccSapM1sxW5Q=;
 b=RtcxEM181z3v1ABpuxlSmwAic7JuAcVx2i7Anc00CidYyjcJaprJcdhmLqeyQEPi7YsShW3un
 fOmun6X+3ieC1EwUqUBI6vKOIW34msGjIbFuArmOKxDMCrNDJ4wmlkR
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002321:EE_|LV2PR19MB5864:EE_
X-MS-Office365-Filtering-Correlation-Id: 49a6f994-cd26-42f1-5d34-08dd2eb1c37f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|36860700013|82310400026|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?U2tycmdJUEt0NDRIQjNHajk3dElYY24xdVNSM2xpNVMwem9VMmJ2VjRFQXdZ?=
 =?utf-8?B?eU05MHpiQlJTN0hVN0JzMXNrNmlGNVBjMy9iRG80TDlzdVU3Smppbm1wVnY1?=
 =?utf-8?B?WXJ3dFA2bUw5SXpHMVN3K3g2anRZRFdzVGxnMHFMdThTMFhGTlVjNFFmRDJV?=
 =?utf-8?B?Y2g3NkxkTUYwd2oxby9xbzBpbC9oMGpzREZQQmM2dzhBeTNwWFRwVk9VSTRB?=
 =?utf-8?B?VUVaQ1hNYlRvSVVaRE5VRGlyN3p4eUtHOTYvR0RHSG96RnVBOUdYL0xwa1lM?=
 =?utf-8?B?WEtScUZxUzNJMEhoNnluSHppazJORWk5U1pMb25RYTlzUGJRQXlOc1RqZVJZ?=
 =?utf-8?B?MWZMUFYyeHlSVjltYmZxVEpUcjBMVDQvUVVWTTJKVVpwakRsaFl4d01yWUZm?=
 =?utf-8?B?ZTBFSGc4Tlc4ZUI3U1BLcmE5SmFlWUVnOEUyNktSNFVnRDJZeGNacm1WZ1FT?=
 =?utf-8?B?RCtBaVN6d0lwcXVKY3hLcnhtU0RNbE0xQ2I1SytLbURhck16b1V6WWZpekR4?=
 =?utf-8?B?UTliS1FoTDZpb3Y4WDZaN0lyYVZIRjAxb0FCODR1bE9FcGVIQUdEN0JrMmNV?=
 =?utf-8?B?Nnk3ajZRbzdZcUVnbGxvb0RVTmVqNWtXaE9BN3dhclVxSE54SWtNb0ZGTWk0?=
 =?utf-8?B?d0pnSHhjYVl0ZU83Rlc4a0t4OE4ySkIwbHJ5NlIvLys1cmxhY3Q5d2ppYzZw?=
 =?utf-8?B?cnAyUFE4dk5kVmE2QmpFMUR4TTZ0NmE3bVpGY3pRRkNwUlMrSTB1dE5MNnc1?=
 =?utf-8?B?Snk3TnFqTWJKdlc4eVFVczFkN0VkcWxaTUdNZ05kaSsxNDFjbEJtNXd3VmxD?=
 =?utf-8?B?Q0tGcDFJYkVsZklkd2MzUjZuR2tXWTVHZ2JwdnNGWm1RNXZSaTdBdmhoaEtr?=
 =?utf-8?B?VmJIVkU0QUNhVEs4bExEdmNEYzBldmVhcGxVQnROYVZ2Sm9zcWh4MXhibFRQ?=
 =?utf-8?B?bXZweFNPdTM0MTdnVHFMR3VZOVUrdFpGRmZjbnl1ZDIrRm1KblcrSmdmTEhO?=
 =?utf-8?B?U2RzV3dwSTNJaXlDM1paZStibnlTelkrYU9ER0dMdWdVOFE4WjVtTkhVSDhq?=
 =?utf-8?B?cFM2bUg2cmFmQXMrQ0pTQTlncG9md2M3UGZUT2JNMXhxMS9kaCtRTEhIbmxV?=
 =?utf-8?B?cklTazdnSkpybUZBclkwdVNMbzB4bndYdXZaQTJEVDYzVDQ3d2hjcUdtYkVn?=
 =?utf-8?B?VUFRakNveDc5WTJvaExYa2JxZG9sTVVhbVVIQXhvOHVrV2JESk1Cei9WT3Jl?=
 =?utf-8?B?SWFOSTRiZmdJNkRMNG0zTGs2NG9FVjhCQ2Exa0xNekU4c2d1MjdXMXU1bUxR?=
 =?utf-8?B?RVNHSGZRWmxhcGYvbmF6UUNXb29CdmFibTdZYjlFdytkOGo0ODU2WG94a3lG?=
 =?utf-8?B?MWJnc2RNaGgyazZQdXdsL0MvTmxCL05FTXAwWG5ManRaeURiSzRHZUVLbWhQ?=
 =?utf-8?B?d05iSit6T3JMWEdxdnpMb0JzNVNYRWY1Z0FYR2IwbnRyaHlMMDlTTCtxc3Mr?=
 =?utf-8?B?MElTdzNZTWcyYTZTU1BIM01lVVk5UHlXd3Y3WUVFT0xVZ2ZqTnUzVEZ6VDVa?=
 =?utf-8?B?SXlSMXdPRnRkdVdlYlJ4dkx1YkVraTNNOUJ2WTl6VmMzWE14RGkwRldpVlph?=
 =?utf-8?B?bkI4UjM2NFJER0xYdmhEdlo0aU1kazJnZXZpZHZncG1JUmNnVFoxeDNNOGlR?=
 =?utf-8?B?eXZFZlAyOTBsTDl6YXhpQVpjdFU4alZOWTY3NjQxcVJpVGRZNVlCRzByeHUv?=
 =?utf-8?B?MlVJNFdJL1dwQW1xMS9uWllzTTRnVG01VEVORFMyT09jY1NSM0t1VmprU2ht?=
 =?utf-8?B?Nko3STYxVzRkTHRkbTF1QTBGODBSSjIrQkhlYUFCR01kZ05FVVV3MGhZRFQy?=
 =?utf-8?B?NWt3WHlZa2pjbWpuL255YllZMlpwOU9aVDhGeTIxTCtqdmY3ZVRRNElzeGYv?=
 =?utf-8?B?QlYvaDR1WTZwL0FoaFB3TEdxMVptenlxNkVIY3pZVXZycUdGWEswSDBKM25y?=
 =?utf-8?Q?MkKIhi1gCDatIsUwKOV4iZibS5WPgQ=3D?=
X-Forefront-Antispam-Report:
 CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(7416014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 QSc8nRHLkjuXzF4+00mvYcuFhm5JtoVj3OQe9VZes/IJ6htj+7vGcud0FF7WigqcXIEojImXbTVVPxfqddaBYM1uMR5usiUnWIGEY98qvX+1+KiiEATSob1S6M31q0I2iiPhTkEYznMcdEBPu1YvzOMrXtXhYAKyhRndRXOII+sQISdd+8KeROytFcqwfKY5E2j1KJYYrcgjRjccgbj9rsWEqeE5o1sjzHGrKOGeWVsLd50WJL9mFmY79W7YVdEwLqoZaODkZW5+WmNYlUbANEzaWPP6DmLmCeVcvmRgRWV+cN0dVt3OorGKjLhc9bW3PMheSJRFmsRJf7kzB6icZElBCCkKmFYixn8xs266l0bCgsPzKR0mFqW02ZTcoAJvzhRE4TlGOszu4t47uqML7m2zUZVuTqj+69SevcmU6SCXJKYVW7GtEMoPSNkLRb689nL2ipf9CWc1FjREo3D+TWpwDOZhj+Nl4uNx4ILutCYJIR9q+WsWuUYwHmIhnSwHWDZsc8162AuNTBYD4IwXUHQc/QObk5YrjIrY7CP+3whbaKvcAgawd62gv+lIEUIUsBDV1HXnK6A/TX9ab0M0q/98F3Y8Yk9lkMxSMnOfqlqMV1j1cZtIZdUg7pzisZ7IpudAeHm/HeZnZcZsmemjPQ==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 00:25:17.8752
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 49a6f994-cd26-42f1-5d34-08dd2eb1c37f
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
 SJ1PEPF00002321.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR19MB5864
X-OriginatorOrg: ddn.com
X-BESS-ID: 1736215155-110353-13428-34700-1
X-BESS-VER: 2019.1_20241219.1759
X-BESS-Apparent-Source-IP: 104.47.56.43
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoZmZhYmQGYGUNTcIjHZNNnY3N
	zYxNDQ1NAw0djA2Cw5CcgxSzRKskhTqo0FAM0txRtCAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.261637 [from 
	cloudscan16-146.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC0_MISMATCH_TO, BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This adds basic support for ring SQEs (with opcode=IORING_OP_URING_CMD).
For now only FUSE_IO_URING_CMD_REGISTER is handled to register queue
entries.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/Kconfig           |  12 ++
 fs/fuse/Makefile          |   1 +
 fs/fuse/dev_uring.c       | 333 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h     | 116 ++++++++++++++++
 fs/fuse/fuse_i.h          |   5 +
 fs/fuse/inode.c           |  10 ++
 include/uapi/linux/fuse.h |  76 ++++++++++-
 7 files changed, 552 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/Kconfig b/fs/fuse/Kconfig
index 8674dbfbe59dbf79c304c587b08ebba3cfe405be..ca215a3cba3e310d1359d069202193acdcdb172b 100644
--- a/fs/fuse/Kconfig
+++ b/fs/fuse/Kconfig
@@ -63,3 +63,15 @@ config FUSE_PASSTHROUGH
 	  to be performed directly on a backing file.
 
 	  If you want to allow passthrough operations, answer Y.
+
+config FUSE_IO_URING
+	bool "FUSE communication over io-uring"
+	default y
+	depends on FUSE_FS
+	depends on IO_URING
+	help
+	  This allows sending FUSE requests over the io-uring interface and
+          also adds request core affinity.
+
+	  If you want to allow fuse server/client communication through io-uring,
+	  answer Y
diff --git a/fs/fuse/Makefile b/fs/fuse/Makefile
index 2c372180d631eb340eca36f19ee2c2686de9714d..3f0f312a31c1cc200c0c91a086b30a8318e39d94 100644
--- a/fs/fuse/Makefile
+++ b/fs/fuse/Makefile
@@ -15,5 +15,6 @@ fuse-y += iomode.o
 fuse-$(CONFIG_FUSE_DAX) += dax.o
 fuse-$(CONFIG_FUSE_PASSTHROUGH) += passthrough.o
 fuse-$(CONFIG_SYSCTL) += sysctl.o
+fuse-$(CONFIG_FUSE_IO_URING) += dev_uring.o
 
 virtiofs-y := virtio_fs.o
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
new file mode 100644
index 0000000000000000000000000000000000000000..b44ba4033615e01041313c040035b6da6af0ee17
--- /dev/null
+++ b/fs/fuse/dev_uring.c
@@ -0,0 +1,333 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * FUSE: Filesystem in Userspace
+ * Copyright (c) 2023-2024 DataDirect Networks.
+ */
+
+#include "fuse_i.h"
+#include "dev_uring_i.h"
+#include "fuse_dev_i.h"
+
+#include <linux/fs.h>
+#include <linux/io_uring/cmd.h>
+
+#ifdef CONFIG_FUSE_IO_URING
+static bool __read_mostly enable_uring;
+module_param(enable_uring, bool, 0644);
+MODULE_PARM_DESC(enable_uring,
+		 "Enable userspace communication through io-uring");
+#endif
+
+#define FUSE_URING_IOV_SEGS 2 /* header and payload */
+
+
+bool fuse_uring_enabled(void)
+{
+	return enable_uring;
+}
+
+void fuse_uring_destruct(struct fuse_conn *fc)
+{
+	struct fuse_ring *ring = fc->ring;
+	int qid;
+
+	if (!ring)
+		return;
+
+	for (qid = 0; qid < ring->nr_queues; qid++) {
+		struct fuse_ring_queue *queue = ring->queues[qid];
+
+		if (!queue)
+			continue;
+
+		WARN_ON(!list_empty(&queue->ent_avail_queue));
+		WARN_ON(!list_empty(&queue->ent_commit_queue));
+
+		kfree(queue);
+		ring->queues[qid] = NULL;
+	}
+
+	kfree(ring->queues);
+	kfree(ring);
+	fc->ring = NULL;
+}
+
+/*
+ * Basic ring setup for this connection based on the provided configuration
+ */
+static struct fuse_ring *fuse_uring_create(struct fuse_conn *fc)
+{
+	struct fuse_ring *ring;
+	size_t nr_queues = num_possible_cpus();
+	struct fuse_ring *res = NULL;
+	size_t max_payload_size;
+
+	ring = kzalloc(sizeof(*fc->ring), GFP_KERNEL_ACCOUNT);
+	if (!ring)
+		return NULL;
+
+	ring->queues = kcalloc(nr_queues, sizeof(struct fuse_ring_queue *),
+			       GFP_KERNEL_ACCOUNT);
+	if (!ring->queues)
+		goto out_err;
+
+	max_payload_size = max(FUSE_MIN_READ_BUFFER, fc->max_write);
+	max_payload_size = max(max_payload_size, fc->max_pages * PAGE_SIZE);
+
+	spin_lock(&fc->lock);
+	if (fc->ring) {
+		/* race, another thread created the ring in the meantime */
+		spin_unlock(&fc->lock);
+		res = fc->ring;
+		goto out_err;
+	}
+
+	fc->ring = ring;
+	ring->nr_queues = nr_queues;
+	ring->fc = fc;
+	ring->max_payload_sz = max_payload_size;
+
+	spin_unlock(&fc->lock);
+	return ring;
+
+out_err:
+	kfree(ring->queues);
+	kfree(ring);
+	return res;
+}
+
+static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
+						       int qid)
+{
+	struct fuse_conn *fc = ring->fc;
+	struct fuse_ring_queue *queue;
+
+	queue = kzalloc(sizeof(*queue), GFP_KERNEL_ACCOUNT);
+	if (!queue)
+		return NULL;
+	queue->qid = qid;
+	queue->ring = ring;
+	spin_lock_init(&queue->lock);
+
+	INIT_LIST_HEAD(&queue->ent_avail_queue);
+	INIT_LIST_HEAD(&queue->ent_commit_queue);
+
+	spin_lock(&fc->lock);
+	if (ring->queues[qid]) {
+		spin_unlock(&fc->lock);
+		kfree(queue);
+		return ring->queues[qid];
+	}
+
+	/*
+	 * write_once and lock as the caller mostly doesn't take the lock at all
+	 */
+	WRITE_ONCE(ring->queues[qid], queue);
+	spin_unlock(&fc->lock);
+
+	return queue;
+}
+
+/*
+ * Make a ring entry available for fuse_req assignment
+ */
+static void fuse_uring_ent_avail(struct fuse_ring_ent *ring_ent,
+				 struct fuse_ring_queue *queue)
+{
+	list_move(&ring_ent->list, &queue->ent_avail_queue);
+	ring_ent->state = FRRS_AVAILABLE;
+}
+
+/*
+ * fuse_uring_req_fetch command handling
+ */
+static void fuse_uring_do_register(struct fuse_ring_ent *ring_ent,
+				   struct io_uring_cmd *cmd,
+				   unsigned int issue_flags)
+{
+	struct fuse_ring_queue *queue = ring_ent->queue;
+
+	spin_lock(&queue->lock);
+	fuse_uring_ent_avail(ring_ent, queue);
+	spin_unlock(&queue->lock);
+}
+
+/*
+ * sqe->addr is a ptr to an iovec array, iov[0] has the headers, iov[1]
+ * the payload
+ */
+static int fuse_uring_get_iovec_from_sqe(const struct io_uring_sqe *sqe,
+					 struct iovec iov[FUSE_URING_IOV_SEGS])
+{
+	struct iovec __user *uiov = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	struct iov_iter iter;
+	ssize_t ret;
+
+	if (sqe->len != FUSE_URING_IOV_SEGS)
+		return -EINVAL;
+
+	/*
+	 * Direction for buffer access will actually be READ and WRITE,
+	 * using write for the import should include READ access as well.
+	 */
+	ret = import_iovec(WRITE, uiov, FUSE_URING_IOV_SEGS,
+			   FUSE_URING_IOV_SEGS, &iov, &iter);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static struct fuse_ring_ent *
+fuse_uring_create_ring_ent(struct io_uring_cmd *cmd,
+			   struct fuse_ring_queue *queue)
+{
+	struct fuse_ring *ring = queue->ring;
+	struct fuse_ring_ent *ent;
+	size_t payload_size;
+	struct iovec iov[FUSE_URING_IOV_SEGS];
+	int err;
+
+	err = fuse_uring_get_iovec_from_sqe(cmd->sqe, iov);
+	if (err) {
+		pr_info_ratelimited("Failed to get iovec from sqe, err=%d\n",
+				    err);
+		return ERR_PTR(err);
+	}
+
+	/*
+	 * The created queue above does not need to be destructed in
+	 * case of entry errors below, will be done at ring destruction time.
+	 */
+	err = -ENOMEM;
+	ent = kzalloc(sizeof(*ent), GFP_KERNEL_ACCOUNT);
+	if (!ent)
+		return ERR_PTR(err);
+
+	INIT_LIST_HEAD(&ent->list);
+
+	ent->queue = queue;
+	ent->cmd = cmd;
+
+	err = -EINVAL;
+	if (iov[0].iov_len < sizeof(struct fuse_uring_req_header)) {
+		pr_info_ratelimited("Invalid header len %zu\n", iov[0].iov_len);
+		return ERR_PTR(err);
+	}
+
+	ent->headers = iov[0].iov_base;
+	ent->payload = iov[1].iov_base;
+	payload_size = iov[1].iov_len;
+
+	if (payload_size < ring->max_payload_sz) {
+		pr_info_ratelimited("Invalid req payload len %zu\n",
+				    payload_size);
+		return ERR_PTR(err);
+	}
+
+	return ent;
+}
+
+/* Register header and payload buffer with the kernel and fetch a request */
+static int fuse_uring_register(struct io_uring_cmd *cmd,
+			       unsigned int issue_flags, struct fuse_conn *fc)
+{
+	const struct fuse_uring_cmd_req *cmd_req = io_uring_sqe_cmd(cmd->sqe);
+	struct fuse_ring *ring = fc->ring;
+	struct fuse_ring_queue *queue;
+	struct fuse_ring_ent *ring_ent;
+	int err;
+	struct iovec iov[FUSE_URING_IOV_SEGS];
+	unsigned int qid = READ_ONCE(cmd_req->qid);
+
+	err = fuse_uring_get_iovec_from_sqe(cmd->sqe, iov);
+	if (err) {
+		pr_info_ratelimited("Failed to get iovec from sqe, err=%d\n",
+				    err);
+		return err;
+	}
+
+	err = -ENOMEM;
+	if (!ring) {
+		ring = fuse_uring_create(fc);
+		if (!ring)
+			return err;
+	}
+
+	if (qid >= ring->nr_queues) {
+		pr_info_ratelimited("fuse: Invalid ring qid %u\n", qid);
+		return -EINVAL;
+	}
+
+	err = -ENOMEM;
+	queue = ring->queues[qid];
+	if (!queue) {
+		queue = fuse_uring_create_queue(ring, qid);
+		if (!queue)
+			return err;
+	}
+
+	ring_ent = fuse_uring_create_ring_ent(cmd, queue);
+	if (IS_ERR(ring_ent))
+		return PTR_ERR(ring_ent);
+
+	fuse_uring_do_register(ring_ent, cmd, issue_flags);
+
+	return 0;
+}
+
+/*
+ * Entry function from io_uring to handle the given passthrough command
+ * (op code IORING_OP_URING_CMD)
+ */
+int __maybe_unused fuse_uring_cmd(struct io_uring_cmd *cmd,
+				  unsigned int issue_flags)
+{
+	struct fuse_dev *fud;
+	struct fuse_conn *fc;
+	u32 cmd_op = cmd->cmd_op;
+	int err;
+
+	if (!enable_uring) {
+		pr_info_ratelimited("fuse-io-uring is disabled\n");
+		return -EOPNOTSUPP;
+	}
+
+	/* This extra SQE size holds struct fuse_uring_cmd_req */
+	if (!(issue_flags & IO_URING_F_SQE128))
+		return -EINVAL;
+
+	fud = fuse_get_dev(cmd->file);
+	if (!fud) {
+		pr_info_ratelimited("No fuse device found\n");
+		return -ENOTCONN;
+	}
+	fc = fud->fc;
+
+	if (fc->aborted)
+		return -ECONNABORTED;
+	if (!fc->connected)
+		return -ENOTCONN;
+
+	/*
+	 * fuse_uring_register() needs the ring to be initialized,
+	 * we need to know the max payload size
+	 */
+	if (!fc->initialized)
+		return -EAGAIN;
+
+	switch (cmd_op) {
+	case FUSE_IO_URING_CMD_REGISTER:
+		err = fuse_uring_register(cmd, issue_flags, fc);
+		if (err) {
+			pr_info_once("FUSE_IO_URING_CMD_REGISTER failed err=%d\n",
+				     err);
+			return err;
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return -EIOCBQUEUED;
+}
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
new file mode 100644
index 0000000000000000000000000000000000000000..4e46dd65196d26dabc62dada33b17de9aa511c08
--- /dev/null
+++ b/fs/fuse/dev_uring_i.h
@@ -0,0 +1,116 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * FUSE: Filesystem in Userspace
+ * Copyright (c) 2023-2024 DataDirect Networks.
+ */
+
+#ifndef _FS_FUSE_DEV_URING_I_H
+#define _FS_FUSE_DEV_URING_I_H
+
+#include "fuse_i.h"
+
+#ifdef CONFIG_FUSE_IO_URING
+
+enum fuse_ring_req_state {
+	FRRS_INVALID = 0,
+
+	/* The ring entry received from userspace and it is being processed */
+	FRRS_COMMIT,
+
+	/* The ring entry is waiting for new fuse requests */
+	FRRS_AVAILABLE,
+
+	/* The ring entry is in or on the way to user space */
+	FRRS_USERSPACE,
+};
+
+/** A fuse ring entry, part of the ring queue */
+struct fuse_ring_ent {
+	/* userspace buffer */
+	struct fuse_uring_req_header __user *headers;
+	void __user *payload;
+
+	/* the ring queue that owns the request */
+	struct fuse_ring_queue *queue;
+
+	/* fields below are protected by queue->lock */
+
+	struct io_uring_cmd *cmd;
+
+	struct list_head list;
+
+	enum fuse_ring_req_state state;
+
+	struct fuse_req *fuse_req;
+
+	/* commit id to identify the server reply */
+	uint64_t commit_id;
+};
+
+struct fuse_ring_queue {
+	/*
+	 * back pointer to the main fuse uring structure that holds this
+	 * queue
+	 */
+	struct fuse_ring *ring;
+
+	/* queue id, corresponds to the cpu core */
+	unsigned int qid;
+
+	/*
+	 * queue lock, taken when any value in the queue changes _and_ also
+	 * a ring entry state changes.
+	 */
+	spinlock_t lock;
+
+	/* available ring entries (struct fuse_ring_ent) */
+	struct list_head ent_avail_queue;
+
+	/*
+	 * entries in the process of being committed or in the process
+	 * to be sent to userspace
+	 */
+	struct list_head ent_commit_queue;
+};
+
+/**
+ * Describes if uring is for communication and holds alls the data needed
+ * for uring communication
+ */
+struct fuse_ring {
+	/* back pointer */
+	struct fuse_conn *fc;
+
+	/* number of ring queues */
+	size_t nr_queues;
+
+	/* maximum payload/arg size */
+	size_t max_payload_sz;
+
+	struct fuse_ring_queue **queues;
+};
+
+bool fuse_uring_enabled(void);
+void fuse_uring_destruct(struct fuse_conn *fc);
+int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
+
+#else /* CONFIG_FUSE_IO_URING */
+
+struct fuse_ring;
+
+static inline void fuse_uring_create(struct fuse_conn *fc)
+{
+}
+
+static inline void fuse_uring_destruct(struct fuse_conn *fc)
+{
+}
+
+static inline bool fuse_uring_enabled(void)
+{
+	return false;
+}
+
+#endif /* CONFIG_FUSE_IO_URING */
+
+#endif /* _FS_FUSE_DEV_URING_I_H */
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index babddd05303796d689a64f0f5a890066b43170ac..d75dd9b59a5c35b76919db760645464f604517f5 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -923,6 +923,11 @@ struct fuse_conn {
 	/** IDR for backing files ids */
 	struct idr backing_files_map;
 #endif
+
+#ifdef CONFIG_FUSE_IO_URING
+	/**  uring connection information*/
+	struct fuse_ring *ring;
+#endif
 };
 
 /*
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 3ce4f4e81d09e867c3a7db7b1dbb819f88ed34ef..e4f9bbacfc1bc6f51d5d01b4c47b42cc159ed783 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -7,6 +7,7 @@
 */
 
 #include "fuse_i.h"
+#include "dev_uring_i.h"
 
 #include <linux/pagemap.h>
 #include <linux/slab.h>
@@ -992,6 +993,8 @@ static void delayed_release(struct rcu_head *p)
 {
 	struct fuse_conn *fc = container_of(p, struct fuse_conn, rcu);
 
+	fuse_uring_destruct(fc);
+
 	put_user_ns(fc->user_ns);
 	fc->release(fc);
 }
@@ -1446,6 +1449,13 @@ void fuse_send_init(struct fuse_mount *fm)
 	if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
 		flags |= FUSE_PASSTHROUGH;
 
+	/*
+	 * This is just an information flag for fuse server. No need to check
+	 * the reply - server is either sending IORING_OP_URING_CMD or not.
+	 */
+	if (fuse_uring_enabled())
+		flags |= FUSE_OVER_IO_URING;
+
 	ia->in.flags = flags;
 	ia->in.flags2 = flags >> 32;
 
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index f1e99458e29e4fdce5273bc3def242342f207ebd..5e0eb41d967e9de5951673de4405a3ed22cdd8e2 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -220,6 +220,15 @@
  *
  *  7.41
  *  - add FUSE_ALLOW_IDMAP
+ *  7.42
+ *  - Add FUSE_OVER_IO_URING and all other io-uring related flags and data
+ *    structures:
+ *    - struct fuse_uring_ent_in_out
+ *    - struct fuse_uring_req_header
+ *    - struct fuse_uring_cmd_req
+ *    - FUSE_URING_IN_OUT_HEADER_SZ
+ *    - FUSE_URING_OP_IN_OUT_SZ
+ *    - enum fuse_uring_cmd
  */
 
 #ifndef _LINUX_FUSE_H
@@ -255,7 +264,7 @@
 #define FUSE_KERNEL_VERSION 7
 
 /** Minor version number of this interface */
-#define FUSE_KERNEL_MINOR_VERSION 41
+#define FUSE_KERNEL_MINOR_VERSION 42
 
 /** The node ID of the root inode */
 #define FUSE_ROOT_ID 1
@@ -425,6 +434,7 @@ struct fuse_file_lock {
  * FUSE_HAS_RESEND: kernel supports resending pending requests, and the high bit
  *		    of the request ID indicates resend requests
  * FUSE_ALLOW_IDMAP: allow creation of idmapped mounts
+ * FUSE_OVER_IO_URING: Indicate that client supports io-uring
  */
 #define FUSE_ASYNC_READ		(1 << 0)
 #define FUSE_POSIX_LOCKS	(1 << 1)
@@ -471,6 +481,7 @@ struct fuse_file_lock {
 /* Obsolete alias for FUSE_DIRECT_IO_ALLOW_MMAP */
 #define FUSE_DIRECT_IO_RELAX	FUSE_DIRECT_IO_ALLOW_MMAP
 #define FUSE_ALLOW_IDMAP	(1ULL << 40)
+#define FUSE_OVER_IO_URING	(1ULL << 41)
 
 /**
  * CUSE INIT request/reply flags
@@ -1206,4 +1217,67 @@ struct fuse_supp_groups {
 	uint32_t	groups[];
 };
 
+/**
+ * Size of the ring buffer header
+ */
+#define FUSE_URING_IN_OUT_HEADER_SZ 128
+#define FUSE_URING_OP_IN_OUT_SZ 128
+
+/* Used as part of the fuse_uring_req_header */
+struct fuse_uring_ent_in_out {
+	uint64_t flags;
+
+	/*
+	 * commit ID to be used in a reply to a ring request (see also
+	 * struct fuse_uring_cmd_req)
+	 */
+	uint64_t commit_id;
+
+	/* size of user payload buffer */
+	uint32_t payload_sz;
+	uint32_t padding;
+
+	uint64_t reserved;
+};
+
+/**
+ * Header for all fuse-io-uring requests
+ */
+struct fuse_uring_req_header {
+	/* struct fuse_in_header / struct fuse_out_header */
+	char in_out[FUSE_URING_IN_OUT_HEADER_SZ];
+
+	/* per op code header */
+	char op_in[FUSE_URING_OP_IN_OUT_SZ];
+
+	struct fuse_uring_ent_in_out ring_ent_in_out;
+};
+
+/**
+ * sqe commands to the kernel
+ */
+enum fuse_uring_cmd {
+	FUSE_IO_URING_CMD_INVALID = 0,
+
+	/* register the request buffer and fetch a fuse request */
+	FUSE_IO_URING_CMD_REGISTER = 1,
+
+	/* commit fuse request result and fetch next request */
+	FUSE_IO_URING_CMD_COMMIT_AND_FETCH = 2,
+};
+
+/**
+ * In the 80B command area of the SQE.
+ */
+struct fuse_uring_cmd_req {
+	uint64_t flags;
+
+	/* entry identifier for commits */
+	uint64_t commit_id;
+
+	/* queue the command is for (queue index) */
+	uint16_t qid;
+	uint8_t padding[6];
+};
+
 #endif /* _LINUX_FUSE_H */

-- 
2.43.0


