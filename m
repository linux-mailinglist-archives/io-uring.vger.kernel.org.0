Return-Path: <io-uring+bounces-3709-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 77B3A99FD42
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 02:39:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C14B7B213BA
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 00:39:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C1961097B;
	Wed, 16 Oct 2024 00:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="XRAxDc8B"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871F1E574
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 00:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729039148; cv=fail; b=gHXqSLVBibIiWi+gfcnYiP/zh19e5eRuCEDePi+YcsuRHJHgQbA2yFUj9GtOd22oPlxqdjLVSz3wegbvkp7NHgGTBpEG5mmtKnMV4c4Hz6yVBhcwKdbXXkOG63TF9lOTY5iHVze19PZ9yVXWtu47hQDcwD5Bz6U0ANOpSfFT/oc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729039148; c=relaxed/simple;
	bh=kxd7WZI62yzyG8I2jj0Qg1Mf0LWeh2pb5fEjZ+QpxYc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=c8HderYysOzuYFB+yDcgv0GY9fDTIYOEOxxNXvDVufMboITbwM1ROtNx4Kn24rVSo9Nt/AYjujveMSu61cXh7vSVQgOG2dqpmKCnVzFJOx0QBkCqyafrrTR/zykXALcKIZWAzzwAwPkv9DF4i85gix3ERn+yPdm4hOT0M14MsP4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=XRAxDc8B; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42]) by mx-outbound14-248.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 16 Oct 2024 00:39:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tgs/WGuFLiS8DREecXjWgB64i4bRvKJUjDJeXwDXAKKyM3Y9j5eLsPLCpDXSjKbB9Tn9P+k2I02KDff8YbN64z2qAbMSHPVXR2mAulsQOKd7S6iJJaeOzUOSOsgygBg11QdNi1/mtMSETiRgfpnhihWQgvSep4FRPNIrWprR2ooGExTWfLqse9xrTV1m7YTfQAMCCsEW7Nu0KODeGesxumAoz8C3OuwNAIrwHK+vc7QKU6OV6G4b04a+C88ZT1WIyoLmlcLVeWzgrH1GYML0DwpH2KF0Vdio8HrhFyvEpQL3IoUWzjNJtaV6kZA9WRhQHeZ+y0YyM53hosRmH4uPKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KcIGYKzNIixd5dmjaCE4zhPOtcctg7hqHSHo7mkIorA=;
 b=xPmPMLUOKPArznSuMz2099KK/9vHfa+6UNZQBoJdilTiRi/bMwPO0EGl61BttWlK/XQK4ycGd6eeWNQAq8xJE+78iSbvFZBUM8qwA7juiZP4BXakFAceXTwEqogG1rQo+S7D22Q+StHzxTN804aCf+Yl6NDT/4tcJmxngFs8Cuhbbuigzok4EuuZg2qGWEiFXj/JiX6DO5itnjz1BZPJ3Wl0vhA5FQ3vgQ2W7N9Mz2LhV5y73Vqx751zVsEGEoC4RsI9TEfdNt3/jqeq7fVlWbNgQFQnkSppOyuUF6eNt+SRvn0atbBT6SdfmIhJx1iqRc0wcApVlXMF9jxmgRY/dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KcIGYKzNIixd5dmjaCE4zhPOtcctg7hqHSHo7mkIorA=;
 b=XRAxDc8BPtRo63nDgdISg16b2OTcXNrEekAvGc0kKQ3avr/iXwdK9MilxmtMj+3HManVd3RkpmehrLqXglD7t1UiONBxQLxKl5X5FONFUtVfh9owbDm2jYWRjxwH3TXrK7fp59pskJ/qLqtwEFKp8vm/zFuGVaaZlb/MH4xix50=
Received: from SA1PR05CA0005.namprd05.prod.outlook.com (2603:10b6:806:2d2::7)
 by PH7PR19MB6978.namprd19.prod.outlook.com (2603:10b6:510:201::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Wed, 16 Oct
 2024 00:05:27 +0000
Received: from SN1PEPF000397B4.namprd05.prod.outlook.com
 (2603:10b6:806:2d2:cafe::e5) by SA1PR05CA0005.outlook.office365.com
 (2603:10b6:806:2d2::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.17 via Frontend
 Transport; Wed, 16 Oct 2024 00:05:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SN1PEPF000397B4.mail.protection.outlook.com (10.167.248.58) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8069.17
 via Frontend Transport; Wed, 16 Oct 2024 00:05:27 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 3B2E17D;
	Wed, 16 Oct 2024 00:05:26 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Wed, 16 Oct 2024 02:05:15 +0200
Subject: [PATCH RFC v4 03/15] fuse: Move request bits
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241016-fuse-uring-for-6-10-rfc4-v4-3-9739c753666e@ddn.com>
References: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
In-Reply-To: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Amir Goldstein <amir73il@gmail.com>, 
 Ming Lei <tom.leiming@gmail.com>, Bernd Schubert <bschubert@ddn.com>, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1729037122; l=1326;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=kxd7WZI62yzyG8I2jj0Qg1Mf0LWeh2pb5fEjZ+QpxYc=;
 b=AYdIp7AyzLZh4LMyZUqJ4KJbEMDaMWZhfswnUOWySPLzuUOJ8QTtzS7yfrio4dqmdEHPovYUT
 NBUT+yHtBmWAXvL4Nzpem7MN4wZPegjO3rH/H8fpplzcyD3+ZH77hah
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B4:EE_|PH7PR19MB6978:EE_
X-MS-Office365-Filtering-Correlation-Id: fcae5824-7a95-4495-f1d3-08dced763d64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N2VTVG9jOS9vOHg1YUdSblB1V1ozWks5eDB3eEtYOWVCUUg3THROemY1b0Fk?=
 =?utf-8?B?TTFQRFdtcElHanBrMjlMNEVya1JmTnA2R1hKYkdmdDR5WTUzY1VNRWZaZEVx?=
 =?utf-8?B?Tk5vOUdpalVDSE1ybjI2SVo4Z0ZzYnJqZ3VLcjZHR0VBQUc3aTRUM2dKREpx?=
 =?utf-8?B?a2t3bHBST1FvK0RqRUNuTytFVERxYUREWVZyckRxbEpOM1hESlE0V0c2NUJv?=
 =?utf-8?B?dHBtSnk0VWJxdFBKSi9EcG9XaFN6VWl2ZXd2Mk5jMzNEekVMWk1Qa0ZtbFpt?=
 =?utf-8?B?bTAyRm8wL1ZTTkhFT0dmcEJuakplYzFwWFJjbnZEZ2dkRFVBRkVsSzB5dHVp?=
 =?utf-8?B?S1g4WVF1VFNJWDNtTkxUQWt5K3RIbC95UHlkbWlPbTRyQVpZNlQ0K3VzVDJo?=
 =?utf-8?B?NmgyNFNtMVNzUW4zRDNPbjdTWGlaTzBQZm9XYjZhdkpaMzd4aUhkZ3RQeFdH?=
 =?utf-8?B?US95NVF3dnpnZE5TKy9IU1N1U2NhdVNRMUlFTGhjSW9IeUpINEdRWTA4S09B?=
 =?utf-8?B?eUU5UnppUStGYzJ4UjZBZnpNSHhOeUZ1MmtXelFvZ2FaRVZPeTE3VHVyNVpr?=
 =?utf-8?B?aG9pUnEzS2dDNWovODhrMHBISlNLTWUwbG90SkNzSnM0RUdBZkNNakhDSmw1?=
 =?utf-8?B?RWRaN1dEYi9jUlJtQ3VWZ2lqek1tM0xFSmNFL2hLN0gvSXlBNEFwbTdkUXNQ?=
 =?utf-8?B?TDNZL1grM1h6Rjk2U0xxQ1IxOXkrenhMWE9PN2E5d1QveU52ODhxRjN2MGhL?=
 =?utf-8?B?VEk0dmQ2OXRXc1NlWjJRdUpLU1ZUY2pJNEZCOHcxWXhLRUhsMWs1OXgyY3dY?=
 =?utf-8?B?Q3MwOXR1c1U5SW02STZGZGZUVXpUTWZOR3JNYXZyN0lvY05qMUtyT2ZmUHdi?=
 =?utf-8?B?ZnVwTCtOSmkzODYyUkxwYm1HR0NzdDgzMUtwd0NXOEx2U0ZMVWlVek8vSzdR?=
 =?utf-8?B?SmdzWUxZY1NBd2hEbmFCZTA5M24wTXE0elgzWEhCQTVnQTBKL0MyY3c2ZlFk?=
 =?utf-8?B?Z2YyK0d2MHlrYUNhM2srN3dVZDdQWjVFQjZMVWFYa3BKUTJwODRKL1RmQmVv?=
 =?utf-8?B?M3lwVHoxUCtpcGVjOW5vZVdKSnFBTTRudTgzOC9GbEdlNEtyT2IxUGVlUGlI?=
 =?utf-8?B?bjRxQmVkZFI4ZlRBOWpSYWM1SGY0alRWNXN2NVBmY3ZvbkUwM2RiZ1NzTFdn?=
 =?utf-8?B?bU9JdGZiRDBUNzJ3a2tHWmlRb1VPWWhIbE01SEJwV3ZkWStUMGZaeG9sRVo5?=
 =?utf-8?B?aWxTU3Z1TVBCY0RIR3JPR1lLei9scnBibk91Y0pzNUc0N2dHWG15Tm1PM1h5?=
 =?utf-8?B?YTBKVXZWUUMvZ3dBTk5hMXpCWmNJbWN2R0pZSVlNemh6aWlSb1JZVW8zU1hN?=
 =?utf-8?B?S1RvcmJibXI2TFhXd1pXZGV1VHppeGdRUDVUeUR6S2NaR2lwbndkMkFpMkVE?=
 =?utf-8?B?SW9SWERKWm5kbVFEOUhnaGNaTDZoQ0FDSlV2UnRvbzZpRGFRM21tSEpsSThE?=
 =?utf-8?B?clFTQ2dJTjhSQlhIM25IaEtCNnlzRlBJd3hGZEtFSWxxZUdqVkJFUkJhQzZS?=
 =?utf-8?B?VGJxQXd0bVhjanlPa3QwVUwzbmdKNk43ZGFBMWNVeGxDc2l0Z3p2dWpMdnpl?=
 =?utf-8?B?V3RXTXJOMDhjMjlvZHdXeVk1MUxsZmd6RnNhRExxb3RiQnFlK2JuNlZvRUJh?=
 =?utf-8?B?T1pGbFcySkY0aFRCWlhjTGpHdzk3QTFEUnFYZWg3Q013MWl0eThzMWk5Uk84?=
 =?utf-8?B?ZndyQ0ZDT1kzQVFYdmZyUlBvOE5zU25HcmhYUUswekhMS3NHVHh3anN6NXFS?=
 =?utf-8?Q?ga7tAx/UoEttbLEmcSgW3x1+xxlsow3tXd6xA=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+cD5s9tJuxiZrKEt3zQ0KoOgd9Zaa7j3yzA5YJEFccPAABh+NBE+g7+vIJGum2LDHeYon6Ibg89hhx9WRq1otWmEdVov+KlQuzX4VbKbiRUZD+dhzRUm2hF02VDLw1NykybCIHeGkzHxzrPhxi/peXwjf5YZI+vBZDVlmXFKMOsBrBx0hpy17vpbgyeIIzaUxHvKAPzpMJyIt49JNHgH2J01DI9ydoXYOka+wJFDj2QTpVLyx3lYYLp+b8WThFNL6Y4kbBJNqdmWnkK1Yw9avhDFaI6vqEZiw78aazmtZJJzifsZDWIVUgCp5+NryDy8QSsJOrPz7Ny3Jg6SYBtHUSH5RaAqhGxo6Aa6DPknJn0hA3ifG7qMQhlH0UW5fLwuB/bOZTi0b8T3Y1tMQCB++ivzswoFagucw6hfEVR7CLT/TtFUfCbMVSoNBIkRrgqzWR4mYxdfKYeSaOs193/XofMKZ6RZjCV622kje2AMZsDU0XUcZp9IhlfcWB7ojNJeNX2NxwtpoweJWpj0igHZu6j5Mt3IgpXJptk5xE9AUBkkXPGXFH+YJxZlOiWuSfAGJq//j5ASgX7h6ee6qbTh6dzv5dXL8srLK9V7AmzP5xJguuOg9zwkwxZoEm7ujEaPaJejsXqylp/xKG8U4f60Ow==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 00:05:27.0936
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fcae5824-7a95-4495-f1d3-08dced763d64
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR19MB6978
X-OriginatorOrg: ddn.com
X-BESS-ID: 1729039145-103832-12748-12509-1
X-BESS-VER: 2019.1_20241015.1627
X-BESS-Apparent-Source-IP: 104.47.66.42
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoZGFqZAVgZQMMXEONEwJdkkxd
	LMyDTZ2MTE1Mws1dQ01TTZyNzMKNlAqTYWAFfTRnhBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.259752 [from 
	cloudscan18-90.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND, BSF_SC0_MISMATCH_TO
X-BESS-BRTS-Status:1

These are needed by dev_uring functions as well

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/fuse/dev.c        | 4 ----
 fs/fuse/fuse_dev_i.h | 4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 9ac69fd2cead0d1fe062dc3405a7dedcd1d36691..dbc222f9b0f0e590ce3ef83077e6b4cff03cff65 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -26,10 +26,6 @@
 MODULE_ALIAS_MISCDEV(FUSE_MINOR);
 MODULE_ALIAS("devname:fuse");
 
-/* Ordinary requests have even IDs, while interrupts IDs are odd */
-#define FUSE_INT_REQ_BIT (1ULL << 0)
-#define FUSE_REQ_ID_STEP (1ULL << 1)
-
 static struct kmem_cache *fuse_req_cachep;
 
 static void fuse_request_init(struct fuse_mount *fm, struct fuse_req *req)
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index b38e67b3f889f3fa08f7279e3309cde908527146..6c506f040d5fb57dae746880c657a95637ac50ce 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -8,6 +8,10 @@
 
 #include <linux/types.h>
 
+/* Ordinary requests have even IDs, while interrupts IDs are odd */
+#define FUSE_INT_REQ_BIT (1ULL << 0)
+#define FUSE_REQ_ID_STEP (1ULL << 1)
+
 static inline struct fuse_dev *fuse_get_dev(struct file *file)
 {
 	/*

-- 
2.43.0


