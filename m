Return-Path: <io-uring+bounces-6083-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C32D7A1A63F
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 15:52:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 21E55160660
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 14:52:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AE7C2139C8;
	Thu, 23 Jan 2025 14:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="ZL8kMTkW"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C98212B04;
	Thu, 23 Jan 2025 14:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737643910; cv=fail; b=k7j9fy239o9FVTXvS3VkMzKr6yEWrDiF1tITjagsfDdzCT9DWlwZ//KtMB00wykZfMc09S9+BqxWjsY/QKmbXXXTHAWAH11U8jAWtDu9bexH9zV52Khn5AVqdIkADxCuBumTSeDmBBWPvvTZnovXggbm8jRrEP21D0sMpwUOMzA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737643910; c=relaxed/simple;
	bh=VitBIYgS7fqFRqA0xGy20CMOl9dkjSDSY3vWEj20hEM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dGbftrU4yWzpY/mhAhprsFd2Hw4E05qFFBcS6+A6wMpPmAGlZPS13QBsRwppsfbopx/AbXcMzh55ervmBAZlwkIpG5Z18iWFxDyb42GoWJPvbVZEu6Hy29J0b5wn8KVe+KRRID/oxnUIEeCkndyb17DHLD8egWDQqX7il6ZwXqI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=ZL8kMTkW; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2044.outbound.protection.outlook.com [104.47.58.44]) by mx-outbound47-151.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 23 Jan 2025 14:51:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u1ZPYFJRbwf9KNQcb6LZ0W63fBN2yKVv/589iYCrEbit5BMTeLokuEjMqlJJvdxY70j7IISs8ZaUanpinFzhU7N5Nlj1SZco5Az0PliJsaD+efiydKbOJF0bHtUv7jnbY3DCSSSDWbRjrTWUv4gtQuV0jO1m0ezT2SpeFkdws47qrIuoJikHEN5OorK67lcP+d+1iPkC/UnyfNtgNgB8oFk8lYEPfFkcHHAX5bXSIuleQWhHRJcmvaYlmhXfVfxDjoa8cbYrXqydFGOCz6khOPyEX0GTBOCgBs98coitrlcyPEnF18bx+hCaT1luFTeBMChnQUEdKlJs+jni2v5WWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0NBjgTPodBwSUe9BLi8C6vT6MLEmgXjqP8QqfVKXpw4=;
 b=YCA5S+0+MEzfJ4++ZkaTqWQDk1R7e3CU4xFbfiMq3D4xMZC7weovMqUzRJa4bXsmKwoJ3CqHDVXsz3wmWuvR0NEik4MJOnlBBsj0WUFg/CWjLxrQKSaj1hvcDQF2IOB8o26SJ71vIQExDCtLfRquK9RKbDwcxqTRL/0Sh95tARCAKX3lgKmro3kMfJpzQ8qncAZEXDlvRqfKN0n/OyUii6DP0cK3ykIb8QEfvZzrR/QZiQonoUSVf25P49I8blOL+T7qw3KYPIIVbZUBUakE6kdKhM9sJDKVV0lniyyIrQK8Upb8UQpBhgFT9Es/qUTVXjcJW/EZtx0M9jciS96lWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0NBjgTPodBwSUe9BLi8C6vT6MLEmgXjqP8QqfVKXpw4=;
 b=ZL8kMTkWvpCvrKnUa/tEq1agw1MK83wgFTXcutPXVJTSUzk8Y0vYmfwqRIDZOrYSHTSTR4gvVgAkZh4bmK7Hgc2Y6thB7TQXDLoyNpAS4701OwyE7dTkQ1l436Y1e0PRVE1S6mNYJS9oYEb2XquIfSuNhC3ZVZpdKlu68uMCdhA=
Received: from MW3PR06CA0008.namprd06.prod.outlook.com (2603:10b6:303:2a::13)
 by DS7PR19MB5856.namprd19.prod.outlook.com (2603:10b6:8:7b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.19; Thu, 23 Jan
 2025 14:51:30 +0000
Received: from CO1PEPF000075ED.namprd03.prod.outlook.com
 (2603:10b6:303:2a:cafe::27) by MW3PR06CA0008.outlook.office365.com
 (2603:10b6:303:2a::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.18 via Frontend Transport; Thu,
 23 Jan 2025 14:51:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CO1PEPF000075ED.mail.protection.outlook.com (10.167.249.36) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.8
 via Frontend Transport; Thu, 23 Jan 2025 14:51:28 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id B4D6D34;
	Thu, 23 Jan 2025 14:51:27 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Thu, 23 Jan 2025 15:51:15 +0100
Subject: [PATCH v11 16/18] fuse: block request allocation until io-uring
 init is complete
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250123-fuse-uring-for-6-10-rfc4-v11-16-11e9cecf4cfb@ddn.com>
References: <20250123-fuse-uring-for-6-10-rfc4-v11-0-11e9cecf4cfb@ddn.com>
In-Reply-To: <20250123-fuse-uring-for-6-10-rfc4-v11-0-11e9cecf4cfb@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Luis Henriques <luis@igalia.com>, Dan Carpenter <dan.carpenter@linaro.org>, 
 Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <mszeredi@redhat.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737643871; l=2987;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=pyfKXeRC6n/Ug+8lUk7YZaqTmonpVrAgqJMPMB0WmUA=;
 b=qE1N0SGXRk3X9f4lruwG5GAaU4gf4zhBLW8tMPdIz5e00FGKbkhR8Ni0khw/rw/0wbQ5eN6Yj
 CEKEWf3QSMsCHMprngvoL+dMtv6bZ/J+gIVHu/HDTj1mIV+fcuGM1Zs
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075ED:EE_|DS7PR19MB5856:EE_
X-MS-Office365-Filtering-Correlation-Id: fee3e4e2-2706-4ec7-9bf2-08dd3bbd6af0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|1800799024|82310400026|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aVkrZnJoaDU3U1FpZzdYRGJpaWx4ejltbTRhUXVoakhySFBnSkRHTVNFMlpO?=
 =?utf-8?B?UlhIV3JyWi9nK0xTdGRBc3ljWUo2ZEUrVlUva0xtcEZvRkp5VFFvTTZIaFRR?=
 =?utf-8?B?dEpXQUM5QkdpRWZSUU1uOE1iZ054R1YrVGxYNS8yV2F5ZFJRbGhRUTcvNktk?=
 =?utf-8?B?RGRxYSsxUWtwVnR0czNuU1IwTDNVRjRaaWNleHpBcnZMWkt4alFVMmxiZ3dW?=
 =?utf-8?B?K3hWNjhGNHh6WlpPa3JWT2R6SXcyUVVaQkhrQ2tQTm1GL2pOSC9uVXVJQ3h0?=
 =?utf-8?B?TXNraWJqSStCQXNLcWNUWjQvR2VLZWFrZTNWaTNCeEpRdlVlU1pBMjN1OXRi?=
 =?utf-8?B?U24wYnBBTkFIUGR4bmtITEMyZnl3SFEyUndHY29FSUtiV05lcnlobUp4MVZ0?=
 =?utf-8?B?L3BGSTZVeUw0Wjl1bXJ3Z09qRlRGakVtLzNlakp1WDZ6bE1sek95MDlvRGR6?=
 =?utf-8?B?T1g2OXNoLzFkVTFneEZ3RFJlaEZ1djBHV0JhcWJnWGE4eEhLQlk3SVNvd3gv?=
 =?utf-8?B?dG9lVUxwenlmRU9GLytDcmE1YUYwYjdQa1R1akEvOG1ZaTY0YUhoQnJpZVR5?=
 =?utf-8?B?alJXd2lTNDIzSTNtc0g4aGdYMk1vZUNDdWVPQUNXem1Od1ZWSEVyQkpVR1JY?=
 =?utf-8?B?NE1nU1hGM3A3TitscmhSbDNubWtNdnpwSWswS212WTNnMVQ4NHF1d2pUTVd0?=
 =?utf-8?B?RHBJVnpRSnQ4V3FEeWxNYW5MZlhwaG10TVpWVmk3WjJxM05Tbk40QUxnU05F?=
 =?utf-8?B?b2VaaUJMS1laWkg0MjM5cXBaL202dWc0azFPTzNnMDBtYUswOVZSc0p1RDdM?=
 =?utf-8?B?MTY2c01idEJ3UHEwNWxqQnEyVGVoNUFBdWhmS0IyWVZCdjlSSGkwQ0NvZ1kr?=
 =?utf-8?B?aTYyYTNBVmtGM1N2dU5ySlJDT1VuUjBsK3FXTnNVeDd2QTVMbEVtYUNTRDVT?=
 =?utf-8?B?emJrMGVkdTk2NzY3M3ZacHZrOFNXY2pFZzdLUEJxbk9wM0xpQzhoQ3dDcGIv?=
 =?utf-8?B?TkthVitRblpUTkUrY2hjaXg4Rk1VRExZZnh3ZzZCRzBrTFpRMDNYNW1sUmFH?=
 =?utf-8?B?MXJWQXQ4dTZXTUhMTStDck9aU2t1RVFaVUxkMzlKalQ0TC9haFNESnczUi9R?=
 =?utf-8?B?MGRVK0p1bEpQL1IvR0QzUFdKR2Y4eDdLazJ1S3h3SS9WcTFJTTI4YW54N3I3?=
 =?utf-8?B?bWsrbWlFVTdpSGN2RWtXVFpjUzAxcU5vTVFuK1lscU94dTlxN2hhSEYyaC9w?=
 =?utf-8?B?Q0lnYlZUVDFoWmRFOUhSWVZUbWVlbzlPSEEvM1FzUFVlZjMxcjg1eFYyamhX?=
 =?utf-8?B?VUdOcWtDc1dZdWFxbklVZitqaWJCTThDa01mQWNaYzFXSUVFS1RFNzd4SjNT?=
 =?utf-8?B?ckw5M3NuME04QW9xbVMrZ2FHRkVFZ1M1bVJiZEo3T0pjY2EzempFRDE1bEZw?=
 =?utf-8?B?Wjl2UzVHWlM4bjlkM3ZBRzczV2NnWFFwSm5wVS9jcWkvMzJsbUdzZnAvQXFO?=
 =?utf-8?B?WmxJUm0xaUYrN2pnWDh6c1U2a2NqNFZua2FRd0FVS0dzVjYxT1k1Y2hMTHFr?=
 =?utf-8?B?alNUeFlpWUZFUFkxTnIxYjRIUTNORDZvT01PWE93eUo5aktOdkJpdVBjNzR1?=
 =?utf-8?B?SStJTVpVaUtaeC9VMTFIemc5SzM4bU1JLzhiSnM5WmVSbFBmM0IxRzNYS2FT?=
 =?utf-8?B?VWxSbG5rVHNZL3pqSnNSbHdYa0dVNDJGQ0NWRkIwSm01TGtTbXF6RUhFbFRK?=
 =?utf-8?B?VTJaeHlBZ2JDU2FJZitGS2NQQmtVeUF0TnRXSmowRmlYdmczVFlYWDdRSDZs?=
 =?utf-8?B?QlAwcTFjVGIwRFhoNUwxR1dIazZpQk5heFR1eFlPRVI5elRqZGs4K2ZkZlBK?=
 =?utf-8?B?UFRzbTFCZDdUd0pMYWFjT0x5YU1RYUpuSWhnVStkZnBETHIramlkUytYNTZU?=
 =?utf-8?B?N0tOVkV4V2lPOGd0dXB5WmRFMXVhdCt6TTVHMVFJcGxRbk5CREFYU0xra1Ry?=
 =?utf-8?Q?0fbmJikT2xGtjwIelFTduJAG+YMTac=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(1800799024)(82310400026)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GZvQXz1DtjagvgzXI3ExubS14t5XEypYWqIzXuFFW84rUyUOXgfmQOi7SHF5oJYPxISZmhsHWBMXkgaNRSCLK9345BsJoV69J3m2+xOYY1rWdEgCwMdMsqZBeGo3rgdTk9xYFso7a9McsN0evVEJ19Jjde+IVXpjfuW3rCyN/JoK9zX1hX0TG4s1yw4RZFbHYSBQohkAjesIN/9gwhXWv/yDJqRnr7k5I6bCA+1NzeBIPANqRwBLANRiAtGGZ3Svq+1bykeB5mwmTSj1IlxFfcqgafu9fxi/ng2iRRnA+PSpXZxh3hmcE8/VXKgPsQR2UdjVCJhaZXI/SVZhcYeS2gY3Yohd/s3babsq/Anw/rMycRgxGq6Yimdq627rIZobUe26InzWt95t+38Xf/2AP2xrXPP0tAWbCgGYDpD29OtbstoTpm8M4DfLktxvQ1Dx97lQD/6tJRKO/EcHXtMVSX8JzyiHI0wh/Ovy2bZAe9rTpMhtqeTHpwTAyyYWI3E0UE2Vidid6hORpN7NevS6W02YNwTCQQ4OrkVPpUBEP5Ktz1LHDuM1SfW4/mw1iQz5wcz1xAxEVfTwsC7c9gOkOuqfa4wMWr+jYZSEZoZMKDAOGZ+tI7C0BbTxx8QuOqL3/uYXoAZetzgIbT6LvrA9aw==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2025 14:51:28.4552
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fee3e4e2-2706-4ec7-9bf2-08dd3bbd6af0
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075ED.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR19MB5856
X-BESS-ID: 1737643894-112183-13446-6461-1
X-BESS-VER: 2019.1_20250122.1822
X-BESS-Apparent-Source-IP: 104.47.58.44
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVkaWJkZAVgZQMNEi1SQ1yTwtxT
	LNyDglMTHJ3Cw50czQ3MTYzDzJ2ChJqTYWALF7WQtBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.262002 [from 
	cloudscan18-156.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

From: Bernd Schubert <bernd@bsbernd.com>

Avoid races and block request allocation until io-uring
queues are ready.

This is a especially important for background requests,
as bg request completion might cause lock order inversion
of the typical queue->lock and then fc->bg_lock

    fuse_request_end
       spin_lock(&fc->bg_lock);
       flush_bg_queue
         fuse_send_one
           fuse_uring_queue_fuse_req
           spin_lock(&queue->lock);

Signed-off-by: Bernd Schubert <bernd@bsbernd.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/fuse/dev.c       | 3 ++-
 fs/fuse/dev_uring.c | 3 +++
 fs/fuse/fuse_i.h    | 3 +++
 fs/fuse/inode.c     | 2 ++
 4 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 1b593b23f7b8c319ec38c7e726dabf516965500e..f002e8a096f97ba8b6e039309292942995c901c5 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -76,7 +76,8 @@ void fuse_set_initialized(struct fuse_conn *fc)
 
 static bool fuse_block_alloc(struct fuse_conn *fc, bool for_background)
 {
-	return !fc->initialized || (for_background && fc->blocked);
+	return !fc->initialized || (for_background && fc->blocked) ||
+	       (fc->io_uring && !fuse_uring_ready(fc));
 }
 
 static void fuse_drop_waiting(struct fuse_conn *fc)
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index fd8c368371e69637323f99c07e54e0365d38abe3..5a44de5d647ee7259ed9a750d0184deebca1de19 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -957,6 +957,7 @@ static void fuse_uring_do_register(struct fuse_ring_ent *ent,
 		if (ready) {
 			WRITE_ONCE(fiq->ops, &fuse_io_uring_ops);
 			WRITE_ONCE(ring->ready, true);
+			wake_up_all(&fc->blocked_waitq);
 		}
 	}
 }
@@ -1130,6 +1131,8 @@ int __maybe_unused fuse_uring_cmd(struct io_uring_cmd *cmd,
 		if (err) {
 			pr_info_once("FUSE_IO_URING_CMD_REGISTER failed err=%d\n",
 				     err);
+			fc->io_uring = 0;
+			wake_up_all(&fc->blocked_waitq);
 			return err;
 		}
 		break;
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index ba6901c1bc2d0ac102f762f3d37e8b8a2d5ae2a4..fee96fe7887b30cd57b8a6bbda11447a228cf446 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -867,6 +867,9 @@ struct fuse_conn {
 	/* Use pages instead of pointer for kernel I/O */
 	unsigned int use_pages_for_kvec_io:1;
 
+	/* Use io_uring for communication */
+	unsigned int io_uring;
+
 	/** Maximum stack depth for passthrough backing files */
 	int max_stack_depth;
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 328797b9aac9a816a4ad2c69b6880dc6ef6222b0..e9db2cb8c150878634728685af0fa15e7ade628f 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1390,6 +1390,8 @@ static void process_init_reply(struct fuse_mount *fm, struct fuse_args *args,
 				else
 					ok = false;
 			}
+			if (flags & FUSE_OVER_IO_URING && fuse_uring_enabled())
+				fc->io_uring = 1;
 		} else {
 			ra_pages = fc->max_read / PAGE_SIZE;
 			fc->no_lock = 1;

-- 
2.43.0


