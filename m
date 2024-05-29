Return-Path: <io-uring+bounces-1993-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 058538D3E6E
	for <lists+io-uring@lfdr.de>; Wed, 29 May 2024 20:35:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 222211C21541
	for <lists+io-uring@lfdr.de>; Wed, 29 May 2024 18:35:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7113815CD59;
	Wed, 29 May 2024 18:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="UVVZR5ri"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03951C0DC4
	for <io-uring@vger.kernel.org>; Wed, 29 May 2024 18:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717007722; cv=fail; b=akTjBZjBpG6d1QEUozKvApBzwcOPiuI5KYnJzM+MrOABWoLEK3iDAi+XhvdRmC3uAxTJ9OqnOK2zYToB9OWxqScoSRXm+dUqT82IgwPPA6Bbnah6sl1dKEi62ghn3hfntqW7n377e0xCRmx2S3PUYWN2PedhtNNuCryM9QIUzKg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717007722; c=relaxed/simple;
	bh=6nLOPBYBmAXqnJ8sBNCyQIY8UbBZnkgg9dgN9vA65fk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mKu44VKtkhgsbqdRUrMHOXHAzZwh0Qx7gb4Hj7wzCHcGWGUWFAz/FF4DKiAoGEeC8Pcud/P7pcUmzozXjDd9tkTne+3yUf8jyHhih4IKvI9FnfPbC+Cf2MwRTuOJLmlGHzHLBLqtyfaFK0DZSVA6JOdRzjb60cVBU1fEjBarN4I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=UVVZR5ri; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169]) by mx-outbound47-163.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 29 May 2024 18:35:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K2L0xrb0N3G4R3TPNovBtEq1HsLMckdd6tjjkOQp7KDtsxShQzhsFPOOvlEjJ4g5sPQTEXpSUYXjKD9+R519jNmY2Ch3uPFXihtPeP2q1mjb5l0VxqQuAckclsv7IRcRqSuXej1MgxzPg8COffiv1DBoCKuYsOBz5cPSyBpPzPX5h//Pi5aMAVW4/0HyKev406La7Mqp3nlrPbL0HNfyaFp2LH/TcPTmx/ZmuoOzKMkcL0dTu9zYNPbHbboRZuE7veBsD/XuV+htFwc6c378+ESsyvBUiAm537gTJ1gH+56mfLES4ppgKLJketVjS7lCPi5P7By/MVL+hGbeB0uwTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BVOW3lpBCXsE91W1B9cz5GiMA7CnbbQ2oNomuKCRLbE=;
 b=IdNgkF2Wl2b2AXO/fTOiki821pzDnq/2A8698SmjxiT1RaqSfxUbcTsC2svVdntrPvqd2usaJE9xSDiRob6d1u+j4k7NydVe2w/24xd6WTP4eF/ZD05OCiMrk+kmXwj2oAa7nXkjXMx/9gujoJufowuj/XHXOqiGQTLUAIhGolioCAwmgKXBr9fQITFf4b3gTYeZxRvWogv9jRQMR2zSn83Yt4kdRiX9fTLCSm66jtqf35Rd16W1MTeU3N2KscFWWq7r/BIUqWxx/rPLC2zXwtWkfVVaTv610EYMsIpMwMKSI9MR367edBlUYr97xeLTEjAi1TVb4AHK+f5Hgn520Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BVOW3lpBCXsE91W1B9cz5GiMA7CnbbQ2oNomuKCRLbE=;
 b=UVVZR5ridQBhWsgPp9Yy7Zq3ziyhaonhp2w8PL7gxgRxHCN/2rO6Qxr4NSgPAGQlCK4oz3g1xWnqaDQrM2fcSzEbnlraz1uH2mxy4TG4HAoyNua9uX1z9BWchRfG80plTNaWxFJy87VZlR6+MM6nwn/vN2GMcwe++nyOOSK3ifU=
Received: from SJ0P220CA0004.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:41b::9)
 by PH7PR19MB6061.namprd19.prod.outlook.com (2603:10b6:510:1dc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Wed, 29 May
 2024 18:01:09 +0000
Received: from SJ1PEPF00002313.namprd03.prod.outlook.com
 (2603:10b6:a03:41b:cafe::17) by SJ0P220CA0004.outlook.office365.com
 (2603:10b6:a03:41b::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30 via Frontend
 Transport; Wed, 29 May 2024 18:01:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SJ1PEPF00002313.mail.protection.outlook.com (10.167.242.167) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.7633.15
 via Frontend Transport; Wed, 29 May 2024 18:01:08 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id B5B0325;
	Wed, 29 May 2024 18:01:07 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Wed, 29 May 2024 20:00:54 +0200
Subject: [PATCH RFC v2 19/19] fuse: {uring} Optimize async sends
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240529-fuse-uring-for-6-9-rfc2-out-v1-19-d149476b1d65@ddn.com>
References: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
In-Reply-To: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 linux-fsdevel@vger.kernel.org, Bernd Schubert <bschubert@ddn.com>, 
 bernd.schubert@fastmail.fm
Cc: io-uring@vger.kernel.org
X-Mailer: b4 0.14-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1717005648; l=5240;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=6nLOPBYBmAXqnJ8sBNCyQIY8UbBZnkgg9dgN9vA65fk=;
 b=oNFZMkYn3UU+NgrSqJaki//mVeNFQqLxPYT5gdt5fe/G2go2yBu0HK75zU3Xgap236r6BCDBm
 ZYwqtPi0n4dAt6kWsMHBwOQHNjr/NkdtV3awJeBzY91VqIim7xYtkSM
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002313:EE_|PH7PR19MB6061:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ba9bf97-1abf-4483-8cd4-08dc80095165
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230031|36860700004|82310400017|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?OEFvWFh4NDRwUXRmaE9mRmxlY0lEelJvL2ZGUmNsRnUrWGZINVJUaGxITjNQ?=
 =?utf-8?B?Ni9ycnQxRTFWNExBVU5vQ2FZNVhGRTBKMXdRRVFXRHM2QWdwV3ZHVkZxaXRY?=
 =?utf-8?B?ZHZoRHl4ZUlSSUtSeWlZSFFRdEVJOTJudXlqaUVXNW13YkZWMFo5c2YxeUpz?=
 =?utf-8?B?YkZxcFROaHFvR0hoalJCTlhUVUx5em9qZXF4N2Y1bkIzUUtGUmg3Uk5haFlz?=
 =?utf-8?B?aEFuU09KbysxN0N0QnkralRLZjVNcWpLKzhWUGdLc2psamNTSEtrZCtaUENW?=
 =?utf-8?B?SXVycVBRN1pBWWZva3NQSk1SWUdHWGZBZzBlTFFRVEY1aWFTL0Y5cnZGZ3Ux?=
 =?utf-8?B?d1ZYcmgvenFXWU4rQ3RkMjR1RDEwK0xMR29rMlQwdmZWUk1saUNsdC9jK2V1?=
 =?utf-8?B?TlVLaXc0aFBkTlFCVmdpajBPcmZZSVA1OXUweU5JaUZXTGZVSHBEWmE0NXRD?=
 =?utf-8?B?TTA2b3NkaUFOOFBBSjBFamdXRG1XU3UwM3J0U3NoWUNjd0JBc095bW5TNmMz?=
 =?utf-8?B?elIzSmdoTUVPbk5pdldXL3lrbUk1RWQ1dkpJQXFaS0V4U3ZGMGM3OVlEeFY5?=
 =?utf-8?B?elhUNU12bCs4b0tuMStBV2pZOWhoUVQ3Sm1VVVpSSVRWT1J5b2FxUDVPVFE4?=
 =?utf-8?B?UzJsSzNoNG9NNEFBa0NBK2RUR3RsQ2xBMWxiQXllS2ZsYnBKUUNWK3lQRkVV?=
 =?utf-8?B?ejBSZGFmdTIxalREMmNURFFvQVBEbE9CQ2QzbXZ2cDZkR1A2VXhxM2ZxMS9x?=
 =?utf-8?B?NkkyZHFMQm1RSjNjQk50YVYvUm1YeXJhOCtDY2sydmVUOStqQk55YWRhUHAz?=
 =?utf-8?B?K29TcDhpeDZsbmxzYTIzcTM4MWV2dmpQYXBhQUlDUWZKQjhKQlVHQXQ2eGpl?=
 =?utf-8?B?Z1hSL3NlNDYvQTI3NFNtOVRCczl1UUxTczFIcXNFQ1h5cU55VFpYRlk0ZkZj?=
 =?utf-8?B?cHhsbVZhL1liM1VFTmYyaWhlbGhOSGtZRWNES0s2MldSZzd0T2ZRN1FZU0tZ?=
 =?utf-8?B?dWhkOEFhTUJRL2R5Q3pVVThTYUpLU0p6MGFqOXNENmZ4Mzd4czJiNTdTU3Vx?=
 =?utf-8?B?TEdJY0wvS3lZamRCTWQxRXBJUjhhTWx1cVdKUGFla1Robm5hdUZZWGFOY1Uv?=
 =?utf-8?B?SlZscWpoTFM0TU5oWkZOUXkycDgxYnpVeGt3a2M0YlF3cWJhelBleXBoeDRm?=
 =?utf-8?B?TWdQVHI5Sm1lQWVQRDRQTENKUmVVVU5KT2QwemV6eG0waklmRjVtYVh6a1Br?=
 =?utf-8?B?VFM1ZkFIRmxEclNVT3hmRm9FaFh4STlTR0xmblJrcmRUYTZtd3oxMjNxQmli?=
 =?utf-8?B?RHFlNDhQWUtqcjVKb0ZkSXpMWTMrTGpOOURMT1BTT0V1NE5aNzFHU3JXQnd3?=
 =?utf-8?B?aFJiN0dMMGtHQjA5VDJzM0cvME1hRDhWbkxWTGRzOFNHcjRIVTE5THQ4aTgy?=
 =?utf-8?B?U2dKeDFrc2tRSmhDcitJeHFCTWJWdm9IMi9aMGs0aVczUU5FVEZDRmdKcW9W?=
 =?utf-8?B?cWxBSXIySDJ5amVjVVFMaW1yUDRDQ1NWOTFjOUZLTmtWYWN6OEdJN0ZvVGhR?=
 =?utf-8?B?T0h6YnhDZTQxbThBOHI5dnYvMWJXaFB4bEJPV3ZCOXFxS2ZDcUhGWW4wd3Jl?=
 =?utf-8?B?TWZVWGtJUUprcUo5VGZ1b2d0QUlkSUFvNUhIOXZ1aEMyYzZhUFArR0oyR1ln?=
 =?utf-8?B?dWRsakNoa3pPY29oZi8zaFV4OVdrYm40YkdSSUIycUlZVGNmZ1JSZkVkdTBu?=
 =?utf-8?B?aUdsWWkyOTNjckY0MndzS1dQZmp3bXYrL3VMNHA4eEdvNTRnTHZDWUZoVDht?=
 =?utf-8?Q?VypK4SxTt5WlS3G3p6ayFVQMLLL15q0BBWoGM=3D?=
X-Forefront-Antispam-Report:
 CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(82310400017)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 trfRWF6rGs0ZPnRfwXTsK/1z7MIKk7o4oo08ZB7XLjeIWSzNgLN3Vxl1hcXIhvSq9z5J4ZVqnLvCy0VycFMUzL5JZBhJiDbo2PZHXgHwYS3zHAHX0mFmdZT1LtZEcMuOxtpwIzBWclWlT2KBJ0nOlO3hLyps7RA9zMJlY11oH8rpUgoszOSPJccGuk46Kkm6ae8V/bISkoOAFjhkZr8KacazyTEiwOZi9q8Elf567VARk8Ea0xRdSCCI5cLoMkqFYlOWTshfonGkdx0bf6/TEgM2WN1HUuq/XFxctv4SZSX3+VG9uURNJONRP+OX5NBK+DhIiZ6sh/ZrudN5XslXk5SjOZP/LKCGVW+Xw/c7oI87JDMup6sbDPLFo+FcuMoGsxp4FJ7pvBzKWJT2ZYA9ELQNNrtIDzGgj3RkYK1IWq5tTh96UzDrGS2HFujhWm+j5NSzKyhUxDx/pWdf/f8jPWd6qdQHTFAXbcEzKz8YJT58N9JJDy0ZlPTCzsHkHWn4QixFARU+FylSgBm75/0c5ttFNGs63L0SJ6DHF/YM8aMEicEZp2EPUuEYQOdkx6/uh/anI5DN4RQ0HnFuDYPtzX0WITGRTeluFGLibVMsKjmL8fimr1Nb187VlqdwtPsawSY4PDjav4yqdS4d1LUjpA==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2024 18:01:08.5938
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ba9bf97-1abf-4483-8cd4-08dc80095165
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
 SJ1PEPF00002313.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR19MB6061
X-OriginatorOrg: ddn.com
X-BESS-ID: 1717007718-112195-12639-41375-1
X-BESS-VER: 2019.1_20240429.2309
X-BESS-Apparent-Source-IP: 104.47.59.169
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVqYGlgZAVgZQMDU50SQ5ydzC0M
	DI1DTR3MAyySLNxNTAzAzISjG3TFKqjQUA4Et9TUEAAAA=
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.256584 [from 
	cloudscan10-46.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND, BSF_SC0_MISMATCH_TO
X-BESS-BRTS-Status:1

This is to avoid using async completion tasks
(i.e. context switches) when not needed.

Cc: io-uring@vger.kernel.org
Signed-off-by: Bernd Schubert <bschubert@ddn.com>

---
This condition should be better verified by io-uring developers.

} else if (current->io_uring) {
    /* There are two cases here
     * 1) fuse-server side uses multiple threads accessing
     *    the ring
     * 2) IO requests through io-uring
     */
    send_in_task = true;
    issue_flags = 0;
---
 fs/fuse/dev_uring.c | 57 ++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 46 insertions(+), 11 deletions(-)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index cdc5836edb6e..74407e5e86fa 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -32,7 +32,8 @@
 #include <linux/io_uring/cmd.h>
 
 static void fuse_uring_req_end_and_get_next(struct fuse_ring_ent *ring_ent,
-					    bool set_err, int error);
+					    bool set_err, int error,
+					    unsigned int issue_flags);
 
 static void fuse_ring_ring_ent_unset_userspace(struct fuse_ring_ent *ent)
 {
@@ -682,7 +683,9 @@ static int fuse_uring_copy_to_ring(struct fuse_ring *ring, struct fuse_req *req,
  * userspace will read it
  * This is comparable with classical read(/dev/fuse)
  */
-static void fuse_uring_send_to_ring(struct fuse_ring_ent *ring_ent)
+static void fuse_uring_send_to_ring(struct fuse_ring_ent *ring_ent,
+				    unsigned int issue_flags,
+				    bool send_in_task)
 {
 	struct fuse_ring *ring = ring_ent->queue->ring;
 	struct fuse_ring_req *rreq = ring_ent->rreq;
@@ -723,13 +726,16 @@ static void fuse_uring_send_to_ring(struct fuse_ring_ent *ring_ent)
 		 __func__, ring_ent->queue->qid, ring_ent->tag, ring_ent->state,
 		 rreq->in.opcode, rreq->in.unique);
 
-	io_uring_cmd_complete_in_task(ring_ent->cmd,
-				      fuse_uring_async_send_to_ring);
+	if (send_in_task)
+		io_uring_cmd_complete_in_task(ring_ent->cmd,
+					      fuse_uring_async_send_to_ring);
+	else
+		io_uring_cmd_done(ring_ent->cmd, 0, 0, issue_flags);
 
 	return;
 
 err:
-	fuse_uring_req_end_and_get_next(ring_ent, true, err);
+	fuse_uring_req_end_and_get_next(ring_ent, true, err, issue_flags);
 }
 
 /*
@@ -806,7 +812,8 @@ static bool fuse_uring_ent_release_and_fetch(struct fuse_ring_ent *ring_ent)
  * has lock/unlock/lock to avoid holding the lock on calling fuse_request_end
  */
 static void fuse_uring_req_end_and_get_next(struct fuse_ring_ent *ring_ent,
-					    bool set_err, int error)
+					    bool set_err, int error,
+					    unsigned int issue_flags)
 {
 	struct fuse_req *req = ring_ent->fuse_req;
 	int has_next;
@@ -822,7 +829,7 @@ static void fuse_uring_req_end_and_get_next(struct fuse_ring_ent *ring_ent,
 	has_next = fuse_uring_ent_release_and_fetch(ring_ent);
 	if (has_next) {
 		/* called within uring context - use provided flags */
-		fuse_uring_send_to_ring(ring_ent);
+		fuse_uring_send_to_ring(ring_ent, issue_flags, false);
 	}
 }
 
@@ -857,7 +864,7 @@ static void fuse_uring_commit_and_release(struct fuse_dev *fud,
 out:
 	pr_devel("%s:%d ret=%zd op=%d req-ret=%d\n", __func__, __LINE__, err,
 		 req->args->opcode, req->out.h.error);
-	fuse_uring_req_end_and_get_next(ring_ent, set_err, err);
+	fuse_uring_req_end_and_get_next(ring_ent, set_err, err, issue_flags);
 }
 
 /*
@@ -1156,10 +1163,12 @@ int fuse_uring_queue_fuse_req(struct fuse_conn *fc, struct fuse_req *req)
 	struct fuse_ring_queue *queue;
 	struct fuse_ring_ent *ring_ent = NULL;
 	int res;
-	int async = test_bit(FR_BACKGROUND, &req->flags) &&
-		    !req->args->async_blocking;
+	int async_req = test_bit(FR_BACKGROUND, &req->flags);
+	int async = async_req && !req->args->async_blocking;
 	struct list_head *ent_queue, *req_queue;
 	int qid;
+	bool send_in_task;
+	unsigned int issue_flags;
 
 	qid = fuse_uring_get_req_qid(req, ring, async);
 	queue = fuse_uring_get_queue(ring, qid);
@@ -1182,11 +1191,37 @@ int fuse_uring_queue_fuse_req(struct fuse_conn *fc, struct fuse_req *req)
 			list_first_entry(ent_queue, struct fuse_ring_ent, list);
 		list_del(&ring_ent->list);
 		fuse_uring_add_req_to_ring_ent(ring_ent, req);
+		if (current == queue->server_task) {
+			issue_flags = queue->uring_cmd_issue_flags;
+		} else if (current->io_uring) {
+			/* There are two cases here
+			 * 1) fuse-server side uses multiple threads accessing
+			 *    the ring. We only have stored issue_flags for
+			 *    into the queue for one thread (the first one
+			 *    that submits FUSE_URING_REQ_FETCH)
+			 * 2) IO requests through io-uring, we do not have
+			 *    issue flags at all for these
+			 */
+			send_in_task = true;
+			issue_flags = 0;
+		} else {
+			if (async_req) {
+				/*
+				 * page cache writes might hold an upper
+				 * spinlockl, which conflicts with the io-uring
+				 * mutex
+				 */
+				send_in_task = true;
+				issue_flags = 0;
+			} else {
+				issue_flags = IO_URING_F_UNLOCKED;
+			}
+		}
 	}
 	spin_unlock(&queue->lock);
 
 	if (ring_ent != NULL)
-		fuse_uring_send_to_ring(ring_ent);
+		fuse_uring_send_to_ring(ring_ent, issue_flags, send_in_task);
 
 	return 0;
 

-- 
2.40.1


