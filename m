Return-Path: <io-uring+bounces-4948-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A16EA9D5654
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 00:44:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 73F54B234D7
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 23:44:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D379E1DE8B8;
	Thu, 21 Nov 2024 23:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="WntV1mqh"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA3F1CCECC;
	Thu, 21 Nov 2024 23:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732232653; cv=fail; b=BYhoTJqyAUpJoC+7oI0yk8SVPL8oS20RtZmWxhf1ryrCymfCCLRWe7OtMumVEX4vQjKNryEC5sj4InNJzBdH2xkN5b1y/8zm7NywHpgEy17CqYlnuni95a9uD3KXzJV12M+udHe/cw48ty7fmrPktVWk0fk29Ngrqud2/Esi+Tc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732232653; c=relaxed/simple;
	bh=qqx868tGyDw5xZZuq9FXzl5HlH5zvSG2W4LzxNADCc4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MwhhKAQm8eaED0NlQPeC3v8CShuPeqq7axH7+dW7erxyDRUUYE5uhBH0iNl3Tr/AUEsf6XoJSDapV3Upj1ts0qVRSoI5FbzIlv2BlMLkVgL7XctSdhM+FYhoj6i85wPHsCdfWnlHBdgESrZYDPoRn5iSi/zHwvBhTMCQ/q8zDxc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=WntV1mqh; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174]) by mx-outbound-ea22-15.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 21 Nov 2024 23:44:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vbqftvrKgtMinaIPivOgNs/qUD/fR0VefG9YMxxoIIEtfoAQSqDv0m5FYiumBurZgcP831h3jSiBBMPPNdd5TnVIeG5O32iavnrm3WkA69DqXh4eyKc6nZMeT+BvPXrvrp4W+65nfJyeH1epu1PpbLsUS1TEasS/E5fpw2PXPsRB/LlWJI43tR0NHnvtCMxw63qoDAwBNUniIG76VXGdW1+b7hkao25r+7f0ROHrPWfDu6jrrdGHcB3ChCzuRFTMQ4o8mKWTz0kIRRsBZg+3UUEXCzyMIrwup0jiELJPRlR0FQ8xBkJsEDJAKgV/R2mTnMQtmrOpsArj3ifKezEB7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=16RRFb/xAw/dqZWvCEFWiWT9fLGSzu+LZzgJRddshBs=;
 b=Nq+8G7G459zSwjSlA1SRmFxSK/4z0bNaiOq6aNzEpazferWSVEa9p7AL4gE7cJdsSKayCQVxagXfqP/c1HOjY11IghHJDOrrfjnn0lCEfUQS1ift+cOIXmImhDhg6iYuzhM26oEuH/OTKhduY+P1+KkKDf6+rGIDkP8Ra+27KM+6jrslJt2LU6eLhdSH/ewwZB0lQl2ZSVd1H0gQ/jpcnF9WZ/HE12V69zyVGJtvx2NKq66yFY8RyO15JUP3PqjrIDvE8xUCZAfKV2MQSdca+xRm17zvR+iE2VMPGFFt7keOvEwyvE+Wy/YKB0PtiDh25mY/PFkVMsud7lf2b503xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=16RRFb/xAw/dqZWvCEFWiWT9fLGSzu+LZzgJRddshBs=;
 b=WntV1mqh08GdDkqO799j5AzWPJ7eIRPhbJFJXxdHdOfngjcm3MPHK5+cxbapQeLcIMEyeSVGjaCMfUsdr3hjkaT8DGIDWKWN0Mw50GYo215YAIirxwzY+oaMpyz8x3u4F8FEkQ9xzACQ/bScTLo0oq9Cos8LunE6O+Nsh93P3+0=
Received: from DM5PR07CA0112.namprd07.prod.outlook.com (2603:10b6:4:ae::41) by
 CH2PR19MB3943.namprd19.prod.outlook.com (2603:10b6:610:9e::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.23; Thu, 21 Nov 2024 23:44:00 +0000
Received: from CY4PEPF0000EDD1.namprd03.prod.outlook.com
 (2603:10b6:4:ae:cafe::aa) by DM5PR07CA0112.outlook.office365.com
 (2603:10b6:4:ae::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.15 via Frontend
 Transport; Thu, 21 Nov 2024 23:44:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CY4PEPF0000EDD1.mail.protection.outlook.com (10.167.241.197) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8182.16
 via Frontend Transport; Thu, 21 Nov 2024 23:44:00 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id A841D32;
	Thu, 21 Nov 2024 23:43:59 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Fri, 22 Nov 2024 00:43:26 +0100
Subject: [PATCH RFC v6 10/16] fuse: {uring} Handle teardown of ring entries
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241122-fuse-uring-for-6-10-rfc4-v6-10-28e6cdd0e914@ddn.com>
References: <20241122-fuse-uring-for-6-10-rfc4-v6-0-28e6cdd0e914@ddn.com>
In-Reply-To: <20241122-fuse-uring-for-6-10-rfc4-v6-0-28e6cdd0e914@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1732232629; l=12152;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=qqx868tGyDw5xZZuq9FXzl5HlH5zvSG2W4LzxNADCc4=;
 b=P24cqy/peBqDraMGIBtJJ2gazVHAfMCsuGBcBU4ThFqNNxvTZkaF7MoKOvvehunLWhn1Nr3ET
 8fXD1rkX3BGDUvkoaY/wOK1S98HeYmxlYZN/d3N9ap3iAABZZLWUfuD
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD1:EE_|CH2PR19MB3943:EE_
X-MS-Office365-Filtering-Correlation-Id: 91905fb1-85c9-40b5-740f-08dd0a865fc4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WVdOOHkwNllIMjRYUEhqNWZiZU13Tk5PNkJXMERJMWk3bzFPY2hNcktEdmlx?=
 =?utf-8?B?TnRRWFJNSjR1ZkVnK1BRRWE1b05YYnY1ckRlL1l3YVpmN2pxbTdiRVlTSlhG?=
 =?utf-8?B?eVFwVUdocSsvU2ZvL3pqanpvSFdEeXUwSUREUnpzdUZheER4NVJXNkF2Qkd4?=
 =?utf-8?B?dW5iSjhsdWxrVW9IVWVNOU1KdXZyYW5NMnJzUzc2V0Q1TkFETkdEWCtNbFlL?=
 =?utf-8?B?RisrOHdBT0JTUUJVQkFjYXE2cCtLb2Jsc1RTTThRZE9BeER1QUtIK3JPaDNo?=
 =?utf-8?B?TElHN0RxVjB1YjdnK2NldGp3QitGMUxQUjd5MGpTZUdnb2Uyaklram0yRFNJ?=
 =?utf-8?B?aHF4ZWZyVXI1Z0NBTGxhQ1IwT1cyU2VaL2VMTnpZSUNRbkxLa0tJTGVVMmNi?=
 =?utf-8?B?NDhUMmRZaXM3QTM2REV6Mk8yYXZVenIzajVjSXEwRHhzNVdubnB0MlJQMnUz?=
 =?utf-8?B?Z3piZ29NN1JhU29hQWd0dXB2alJsbU1vd1o0aFhLVWZnc2tNSXUwMVJqOUxH?=
 =?utf-8?B?S2N2b2czSWtzMExiZk1BQ0RlazVPVTBHcW90bzJFQjg0eHZDaFhZMHNiWEZa?=
 =?utf-8?B?NXh4eDVzYmZRckFuS2ZsMWptNTlMVEI5VHRTdWlEbUhQdzdSbXUzSVo1UnN4?=
 =?utf-8?B?d1lKRnJSK3NKQk5SSXRoQ3VmSWZxV3Z6cUxPOUhMRlpnekQxWlJuVjVLaStq?=
 =?utf-8?B?RzV2eW5ST0hTZXhveVY2U2UrUm5yd2FYOEVNdERRMDZvS3VSRmNOY0poL0kv?=
 =?utf-8?B?M0ZmYkxDKzc4V3V4Z09NVkZDNTFTT2M0VnVTUmdCajNPRVNpZUFoQWcrOGhj?=
 =?utf-8?B?OXd5OTJuY1RNWXdEaVh5NEk1cFZiUjh1cU9QbnRZR20zU2tCUk04akU3MWZv?=
 =?utf-8?B?T2VjVVE3OFd2TmVsNjRVSDV6ZzhKdXFOZjh4eW9PcnNqaU42NnhDV3VoYU43?=
 =?utf-8?B?RHFNNjVOdlEraGN4K2o3ZXpIeUhTTk1HSmdpYksxNHFETGJ3VVhQYytxS0tp?=
 =?utf-8?B?dzdYbDFGR2RRK0dtTldBUlpndmtzSFhrN3c0MzJMNGNEUkRKTWV0TmZ2d3dx?=
 =?utf-8?B?OVc5dkRyMElvQkRMTVlYdFA1WlZmVFplM0VmTURSbzloenByT1dheHdhbXF2?=
 =?utf-8?B?cWRXUmNhYTlHLzY2OEJsL3V0Q0o4Z2dXK0U2SGl5TUluMDI4d3J5TUc4b0E0?=
 =?utf-8?B?MEkxVVhnYTM5V0dEOEhEVURyUHRldFk0SmdwcUQxUzFnRFhTTmVJejlzYzJm?=
 =?utf-8?B?SE5tVXJSQ3VxaUYrSy9uajAwM0JmQTREYmhORjNkVjNpeVl3eXZZQW41ekZt?=
 =?utf-8?B?aFIyRHZUM2xtbzNpbXE3dE5lSTFKaS9oNFVjbnAvS2xPNWNBZXg2K2xIenli?=
 =?utf-8?B?Y3c3WWR1VmFUNmQ0cVlSUWdYaERkMUF5bFJMMEtiMFVGOU93WXBKaWpIaktN?=
 =?utf-8?B?Y1Vpb1kvYk9OR0h3UXRtdEVtN0hhOTI3YytBUW1OSG0vRUUxeFd6RVp5SURz?=
 =?utf-8?B?a1g1R3NYVWxVYzRjNEdDMjBMM0ZQcnVxVlpadnBWd2NhNTlQVE51b0x4YUxT?=
 =?utf-8?B?MDJnanQyaS9UdFl6bFJWc1V2a2lWYkQwRmZmNS8xNGc1bHUzYVBhcEJkaU1H?=
 =?utf-8?B?R2tVRGFZODlQTXllR3FDQnFXNlBtNXZTSXRtU0svREt6V3hEOEdMSEQwS2F6?=
 =?utf-8?B?V0lXN05rQjlDckIxWFVvczFuWjdEQmV5cUNUK0RZZVNQRVlOYVRIUXNOMnBq?=
 =?utf-8?B?MmhpQW1kUFU4cDR2M1h2L0VMZnBuMWNWR0l1aXYydS9pZWtucHlhV1RxUUo2?=
 =?utf-8?B?ZHJPOGcxWTRET1UzNklGdXhDb05pSm00OFFqTSt5YnlDcHZhcTdUNVhESGdW?=
 =?utf-8?B?YXhrcGQ4S0tENXdUQ2xTcUYrTHpTUkFRWGZGcy9naFBuZWc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700013);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PXq/qsYgEVgIB4kfgClPfg7n4vj3yWrg/j/85Sgkw0i+DUHwCPq2AfBBbvgwUN9GbPTw/X6GdO45RTJspz5wmtNz+wsOVBXEeVrhEwY0rAQE6gNIpMsFIAgg7aKSdZjbvc7FmRmqJFofHLTMzu9PJ/SuFMZfVvunaqTl5mCT6pZdFcmB+PWxMAy1da5vFSi1fRRMHIdbVVvckqpB3U2ZynRHCU5+Pb2Oy+KUBhzUOul5EeFFUVTw55IGLyoLln6bo7ke+pdlSHK4hJMDrGS9dwrbz+Srl0sqcIhD3Ov078m732zdNgIBUsf8bGsggYjcNnFE6lj1shM4IVjQJJxxyiHoPmGbGMSrXeRL4ovkRcUjauQM2tWZo25mbLsjdJ2WbDifqQq/x/SmfPWZBTcVtKnqG0jngW/+D99RFCpLuKuVofUJH4bbF/hLWmNTVkdXcolX/CpSEXg0NvI3p5NYHFdR+9uf44iAryzeXkboljJxhPHJm0Ymc13qyBXhiDWT2Pi9GKt3EHy+IU+rFCiHAyAqgkoKoX+84auCADDZHPt4R4buGtBqhk4yfWYKysMahdcJDqi3VsfUBfv+1zk0XnIob9gbepEIX9G8Jn7Zq7cHjcMMI3XPw9wxWrg9IHZeFFDuhfE5xBHaMnTUmQrBsQ==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2024 23:44:00.4302
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 91905fb1-85c9-40b5-740f-08dd0a865fc4
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR19MB3943
X-BESS-ID: 1732232644-105647-10640-35209-1
X-BESS-VER: 2019.3_20241120.2021
X-BESS-Apparent-Source-IP: 104.47.57.174
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoaG5saGQGYGUDTJIjE51TIx0T
	LVONnEyMzU0NDE0NgkySQp0TzN3MTSSKk2FgByvYfaQgAAAA==
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260587 [from 
	cloudscan19-44.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

On teardown struct file_operations::uring_cmd requests
need to be completed by calling io_uring_cmd_done().
Not completing all ring entries would result in busy io-uring
tasks giving warning messages in intervals and unreleased
struct file.

Additionally the fuse connection and with that the ring can
only get released when all io-uring commands are completed.

Completion is done with ring entries that are
a) in waiting state for new fuse requests - io_uring_cmd_done
is needed

b) already in userspace - io_uring_cmd_done through teardown
is not needed, the request can just get released. If fuse server
is still active and commits such a ring entry, fuse_uring_cmd()
already checks if the connection is active and then complete the
io-uring itself with -ENOTCONN. I.e. special handling is not
needed.

This scheme is basically represented by the ring entry state
FRRS_WAIT and FRRS_USERSPACE.

Entries in state:
- FRRS_INIT: No action needed, do not contribute to
  ring->queue_refs yet
- All other states: Are currently processed by other tasks,
  async teardown is needed and it has to wait for the two
  states above. It could be also solved without an async
  teardown task, but would require additional if conditions
  in hot code paths. Also in my personal opinion the code
  looks cleaner with async teardown.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev.c         |   8 ++
 fs/fuse/dev_uring.c   | 216 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h |  51 ++++++++++++
 3 files changed, 275 insertions(+)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 15dc168fd789bf11f27fae11a732a3dfc60de97d..17a76d0c964f1ecd27dd447504c94646f4ba6b6e 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -2295,6 +2295,12 @@ void fuse_abort_conn(struct fuse_conn *fc)
 		spin_unlock(&fc->lock);
 
 		fuse_dev_end_requests(&to_end);
+
+		/*
+		 * fc->lock must not be taken to avoid conflicts with io-uring
+		 * locks
+		 */
+		fuse_uring_abort(fc);
 	} else {
 		spin_unlock(&fc->lock);
 	}
@@ -2306,6 +2312,8 @@ void fuse_wait_aborted(struct fuse_conn *fc)
 	/* matches implicit memory barrier in fuse_drop_waiting() */
 	smp_mb();
 	wait_event(fc->blocked_waitq, atomic_read(&fc->num_waiting) == 0);
+
+	fuse_uring_wait_stopped_queues(fc);
 }
 
 int fuse_dev_release(struct inode *inode, struct file *file)
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 46aab7f7ee0680e84e3a62ae99e664d8b0f85421..19d5d3eafced090a84651b21a9f65cd8b3414435 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -52,6 +52,37 @@ static int fuse_ring_ent_unset_userspace(struct fuse_ring_ent *ent)
 	return 0;
 }
 
+/* Abort all list queued request on the given ring queue */
+static void fuse_uring_abort_end_queue_requests(struct fuse_ring_queue *queue)
+{
+	struct fuse_req *req;
+	LIST_HEAD(req_list);
+
+	spin_lock(&queue->lock);
+	list_for_each_entry(req, &queue->fuse_req_queue, list)
+		clear_bit(FR_PENDING, &req->flags);
+	list_splice_init(&queue->fuse_req_queue, &req_list);
+	spin_unlock(&queue->lock);
+
+	/* must not hold queue lock to avoid order issues with fi->lock */
+	fuse_dev_end_requests(&req_list);
+}
+
+void fuse_uring_abort_end_requests(struct fuse_ring *ring)
+{
+	int qid;
+	struct fuse_ring_queue *queue;
+
+	for (qid = 0; qid < ring->nr_queues; qid++) {
+		queue = READ_ONCE(ring->queues[qid]);
+		if (!queue)
+			continue;
+
+		queue->stopped = true;
+		fuse_uring_abort_end_queue_requests(queue);
+	}
+}
+
 void fuse_uring_destruct(struct fuse_conn *fc)
 {
 	struct fuse_ring *ring = fc->ring;
@@ -111,9 +142,12 @@ static struct fuse_ring *fuse_uring_create(struct fuse_conn *fc)
 		goto out_err;
 	}
 
+	init_waitqueue_head(&ring->stop_waitq);
+
 	fc->ring = ring;
 	ring->nr_queues = nr_queues;
 	ring->fc = fc;
+	atomic_set(&ring->queue_refs, 0);
 
 	spin_unlock(&fc->lock);
 	return ring;
@@ -175,6 +209,182 @@ fuse_uring_async_send_to_ring(struct io_uring_cmd *cmd,
 	io_uring_cmd_done(cmd, 0, 0, issue_flags);
 }
 
+static void fuse_uring_stop_fuse_req_end(struct fuse_ring_ent *ent)
+{
+	struct fuse_req *req = ent->fuse_req;
+
+	/* remove entry from fuse_pqueue->processing */
+	list_del_init(&req->list);
+	ent->fuse_req = NULL;
+	clear_bit(FR_SENT, &req->flags);
+	req->out.h.error = -ECONNABORTED;
+	fuse_request_end(req);
+}
+
+/*
+ * Release a request/entry on connection tear down
+ */
+static void fuse_uring_entry_teardown(struct fuse_ring_ent *ent,
+					 bool need_cmd_done)
+{
+	struct fuse_ring_queue *queue = ent->queue;
+
+	/*
+	 * fuse_request_end() might take other locks like fi->lock and
+	 * can lead to lock ordering issues
+	 */
+	lockdep_assert_not_held(&ent->queue->lock);
+
+	if (need_cmd_done) {
+		pr_devel("qid=%d sending cmd_done\n", queue->qid);
+
+		io_uring_cmd_done(ent->cmd, -ENOTCONN, 0,
+				  IO_URING_F_UNLOCKED);
+	}
+
+	if (ent->fuse_req)
+		fuse_uring_stop_fuse_req_end(ent);
+
+	list_del_init(&ent->list);
+	kfree(ent);
+}
+
+static void fuse_uring_stop_list_entries(struct list_head *head,
+					 struct fuse_ring_queue *queue,
+					 enum fuse_ring_req_state exp_state)
+{
+	struct fuse_ring *ring = queue->ring;
+	struct fuse_ring_ent *ent, *next;
+	ssize_t queue_refs = SSIZE_MAX;
+	LIST_HEAD(to_teardown);
+
+	spin_lock(&queue->lock);
+	list_for_each_entry_safe(ent, next, head, list) {
+		if (ent->state != exp_state) {
+			pr_warn("entry teardown qid=%d state=%d expected=%d",
+				queue->qid, ent->state, exp_state);
+			continue;
+		}
+
+		list_move(&ent->list, &to_teardown);
+	}
+	spin_unlock(&queue->lock);
+
+	/* no queue lock to avoid lock order issues */
+	list_for_each_entry_safe(ent, next, &to_teardown, list) {
+		bool need_cmd_done = ent->state != FRRS_USERSPACE;
+
+		fuse_uring_entry_teardown(ent, need_cmd_done);
+		queue_refs = atomic_dec_return(&ring->queue_refs);
+
+		if (WARN_ON_ONCE(queue_refs < 0))
+			pr_warn("qid=%d queue_refs=%zd", queue->qid,
+				queue_refs);
+	}
+}
+
+static void fuse_uring_teardown_entries(struct fuse_ring_queue *queue)
+{
+	fuse_uring_stop_list_entries(&queue->ent_in_userspace, queue,
+				     FRRS_USERSPACE);
+	fuse_uring_stop_list_entries(&queue->ent_avail_queue, queue, FRRS_WAIT);
+}
+
+/*
+ * Log state debug info
+ */
+static void fuse_uring_log_ent_state(struct fuse_ring *ring)
+{
+	int qid;
+	struct fuse_ring_ent *ent;
+
+	for (qid = 0; qid < ring->nr_queues; qid++) {
+		struct fuse_ring_queue *queue = ring->queues[qid];
+
+		if (!queue)
+			continue;
+
+		spin_lock(&queue->lock);
+		/*
+		 * Log entries from the intermediate queue, the other queues
+		 * should be empty
+		 */
+		list_for_each_entry(ent, &queue->ent_w_req_queue, list) {
+			pr_info(" ent-req-queue ring=%p qid=%d ent=%p state=%d\n",
+				ring, qid, ent, ent->state);
+		}
+		list_for_each_entry(ent, &queue->ent_commit_queue, list) {
+			pr_info(" ent-req-queue ring=%p qid=%d ent=%p state=%d\n",
+				ring, qid, ent, ent->state);
+		}
+		spin_unlock(&queue->lock);
+	}
+	ring->stop_debug_log = 1;
+}
+
+static void fuse_uring_async_stop_queues(struct work_struct *work)
+{
+	int qid;
+	struct fuse_ring *ring =
+		container_of(work, struct fuse_ring, async_teardown_work.work);
+
+	/* XXX code dup */
+	for (qid = 0; qid < ring->nr_queues; qid++) {
+		struct fuse_ring_queue *queue = READ_ONCE(ring->queues[qid]);
+
+		if (!queue)
+			continue;
+
+		fuse_uring_teardown_entries(queue);
+	}
+
+	/*
+	 * Some ring entries are might be in the middle of IO operations,
+	 * i.e. in process to get handled by file_operations::uring_cmd
+	 * or on the way to userspace - we could handle that with conditions in
+	 * run time code, but easier/cleaner to have an async tear down handler
+	 * If there are still queue references left
+	 */
+	if (atomic_read(&ring->queue_refs) > 0) {
+		if (time_after(jiffies,
+			       ring->teardown_time + FUSE_URING_TEARDOWN_TIMEOUT))
+			fuse_uring_log_ent_state(ring);
+
+		schedule_delayed_work(&ring->async_teardown_work,
+				      FUSE_URING_TEARDOWN_INTERVAL);
+	} else {
+		wake_up_all(&ring->stop_waitq);
+	}
+}
+
+/*
+ * Stop the ring queues
+ */
+void fuse_uring_stop_queues(struct fuse_ring *ring)
+{
+	int qid;
+
+	for (qid = 0; qid < ring->nr_queues; qid++) {
+		struct fuse_ring_queue *queue = READ_ONCE(ring->queues[qid]);
+
+		if (!queue)
+			continue;
+
+		fuse_uring_teardown_entries(queue);
+	}
+
+	if (atomic_read(&ring->queue_refs) > 0) {
+		pr_info("ring=%p scheduling async queue stop\n", ring);
+		ring->teardown_time = jiffies;
+		INIT_DELAYED_WORK(&ring->async_teardown_work,
+				  fuse_uring_async_stop_queues);
+		schedule_delayed_work(&ring->async_teardown_work,
+				      FUSE_URING_TEARDOWN_INTERVAL);
+	} else {
+		wake_up_all(&ring->stop_waitq);
+	}
+}
+
 /*
  * Checks for errors and stores it into the request
  */
@@ -565,6 +775,9 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
 		return err;
 	fpq = queue->fpq;
 
+	if (!READ_ONCE(fc->connected) || READ_ONCE(queue->stopped))
+		return err;
+
 	spin_lock(&queue->lock);
 	/* Find a request based on the unique ID of the fuse request
 	 * This should get revised, as it needs a hash calculation and list
@@ -732,6 +945,7 @@ static int fuse_uring_fetch(struct io_uring_cmd *cmd, unsigned int issue_flags,
 	if (WARN_ON_ONCE(err != 0))
 		goto err;
 
+	atomic_inc(&ring->queue_refs);
 	_fuse_uring_fetch(ring_ent, cmd, issue_flags);
 
 	return 0;
@@ -758,6 +972,8 @@ int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	pr_info_ratelimited("fuse-io-uring is not enabled yet\n");
 	return err;
 
+	pr_devel("%s:%d received: cmd op %d\n", __func__, __LINE__, cmd_op);
+
 	err = -EOPNOTSUPP;
 	if (!enable_uring) {
 		pr_info_ratelimited("uring is disabled\n");
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index 65e8ca9bcb10f11b1b62f2b59cda979da961ebd4..e567a20731d76f47b7ebe3f31da4a9348f6d2bc8 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -11,6 +11,9 @@
 
 #ifdef CONFIG_FUSE_IO_URING
 
+#define FUSE_URING_TEARDOWN_TIMEOUT (5 * HZ)
+#define FUSE_URING_TEARDOWN_INTERVAL (HZ/20)
+
 enum fuse_ring_req_state {
 	FRRS_INVALID = 0,
 
@@ -85,6 +88,8 @@ struct fuse_ring_queue {
 	struct list_head fuse_req_queue;
 
 	struct fuse_pqueue fpq;
+
+	bool stopped;
 };
 
 /**
@@ -99,11 +104,50 @@ struct fuse_ring {
 	size_t nr_queues;
 
 	struct fuse_ring_queue **queues;
+	/*
+	 * Log ring entry states onces on stop when entries cannot be
+	 * released
+	 */
+	unsigned int stop_debug_log : 1;
+
+	wait_queue_head_t stop_waitq;
+
+	/* async tear down */
+	struct delayed_work async_teardown_work;
+
+	/* log */
+	unsigned long teardown_time;
+
+	atomic_t queue_refs;
 };
 
 void fuse_uring_destruct(struct fuse_conn *fc);
+void fuse_uring_stop_queues(struct fuse_ring *ring);
+void fuse_uring_abort_end_requests(struct fuse_ring *ring);
 int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
 
+static inline void fuse_uring_abort(struct fuse_conn *fc)
+{
+	struct fuse_ring *ring = fc->ring;
+
+	if (ring == NULL)
+		return;
+
+	if (atomic_read(&ring->queue_refs) > 0) {
+		fuse_uring_abort_end_requests(ring);
+		fuse_uring_stop_queues(ring);
+	}
+}
+
+static inline void fuse_uring_wait_stopped_queues(struct fuse_conn *fc)
+{
+	struct fuse_ring *ring = fc->ring;
+
+	if (ring)
+		wait_event(ring->stop_waitq,
+			   atomic_read(&ring->queue_refs) == 0);
+}
+
 #else /* CONFIG_FUSE_IO_URING */
 
 struct fuse_ring;
@@ -116,6 +160,13 @@ static inline void fuse_uring_destruct(struct fuse_conn *fc)
 {
 }
 
+static inline void fuse_uring_abort(struct fuse_conn *fc)
+{
+}
+
+static inline void fuse_uring_wait_stopped_queues(struct fuse_conn *fc)
+{
+}
 #endif /* CONFIG_FUSE_IO_URING */
 
 #endif /* _FS_FUSE_DEV_URING_I_H */

-- 
2.43.0


