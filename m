Return-Path: <io-uring+bounces-3703-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DABC899FD3A
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 02:38:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3A791B20FD4
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 00:38:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D23751097B;
	Wed, 16 Oct 2024 00:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="FxT80JRQ"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36344E574
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 00:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729039087; cv=fail; b=qASeq/Gupn46/lxlcK5HiE2w50FCCU/aLjLtnaf4AOMVowmOlaWUVdJJ4izQUJiZ9eWmB5BACF+Hf/Ju2545Lwc3vbBoucw/wzFOmqOwYASmmYuswX1KQYtU0OJztXCB+02+HO+CYsww2yDaAU6xchm8MnzKdVvhsGVxOQVTh4g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729039087; c=relaxed/simple;
	bh=4aej8Q309HVdsLZ+KC2yW0OlMYe5WL12QUhlElP9L/s=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BZK6jsEQlsprCI3oH/IDAvpcn/V8qSOvNZHIty07Mor2fuCqWG5fSZepRZsJwMq36ZbGHbTSOi5jPHgzLqe1m8832rR1Dp012mfarlqA3OcAQcka4rQS8G8ebezvT0TPtQ1Zds2y4y4YE9JOmWR3maMh4TKxx9LKAMnPk6aziwc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=FxT80JRQ; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2048.outbound.protection.outlook.com [104.47.73.48]) by mx-outbound-ea46-177.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 16 Oct 2024 00:38:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B4sV3ICCJz9hZ2dbolBkf78auri22nGp42giWdgTsgp2BY1Oercj4QcKELezbQpRhfFna9f6xNeuL3RK4N+fRjXr25GCnNjV3z6nYMk0P2KIoEZDaW/Uyfeg7myzJAslDFd4stC2g1tTYjUrGQIvaxCoCdG3oceeuJYnfBtw0Pm7+9ZHo14cET2kWx+YFIGKUelb4qTB1eGPfG9TS3hM1SzFv631sp2pz+3I3sAgkxWy3uN3gLlM4t6gNZmbYnSVfo6ArXNQpsFDaL06EHk7dgmimaqYG2UW/GN8JojasW3sUX2yQnYl+fsXCtqu1rlpPWTubkkQ1eunGYRZ3OEzgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QP20MrM72ZPBWJig3YallASttR3UM3rXUUsgiM+d2lk=;
 b=dmEQhVys4CY0hCCAhiYZU09t8sZ9+uA7Qlg2GIb4yoeN7EAonSwBFZ+WgCSbG+Tc95F6k+o16aJbLplU/lMhNvf6VFeyJRa00Wt/5oUQB15GBstuQZc9KQQtNJrjOmBQJSPm2P/fRTF00LWqU2fVV6sETnUOqOaSjyAf/XNQ/nblMNeAuQWt8eyHu2UC1YsDs2c8kVdnzjsAYFhvETUYbdzPNdvIz5DtJjTZySZtzmhuyt8xs+4kaUi3FvEbWdrk9T1xZeS4hbqwu8ijYOwATS2BE+BvvHbcwBFHCudALwjL/cTmci21rTSEmE67JtgSNT2Lvmm3gMdnorc4p0t0fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QP20MrM72ZPBWJig3YallASttR3UM3rXUUsgiM+d2lk=;
 b=FxT80JRQoEe0rgBh58uz/OqUd9C9AxFUD3uklGuCk3RXLMuOaeUuOeKeH0sk+qdNanQ5lbBq6DBxVQ9icI5T7fndFX+Cd30+Te6YduA+Wt7dlVk3n5XuUxgQ8GpvbXUaRvwbxy9mcTKmSvNi0MGqGCIA46TW0GAwk5H7kNhO/xM=
Received: from MN2PR15CA0032.namprd15.prod.outlook.com (2603:10b6:208:1b4::45)
 by LV2PR19MB5790.namprd19.prod.outlook.com (2603:10b6:408:179::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.17; Wed, 16 Oct
 2024 00:05:38 +0000
Received: from BN1PEPF00004683.namprd03.prod.outlook.com
 (2603:10b6:208:1b4:cafe::5e) by MN2PR15CA0032.outlook.office365.com
 (2603:10b6:208:1b4::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27 via Frontend
 Transport; Wed, 16 Oct 2024 00:05:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BN1PEPF00004683.mail.protection.outlook.com (10.167.243.89) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8069.17
 via Frontend Transport; Wed, 16 Oct 2024 00:05:38 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 4C6E37D;
	Wed, 16 Oct 2024 00:05:37 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Wed, 16 Oct 2024 02:05:25 +0200
Subject: [PATCH RFC v4 13/15] fuse: {uring} Handle IO_URING_F_TASK_DEAD
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241016-fuse-uring-for-6-10-rfc4-v4-13-9739c753666e@ddn.com>
References: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
In-Reply-To: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Amir Goldstein <amir73il@gmail.com>, 
 Ming Lei <tom.leiming@gmail.com>, Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1729037122; l=1122;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=4aej8Q309HVdsLZ+KC2yW0OlMYe5WL12QUhlElP9L/s=;
 b=QI8HKRcAEt4pqYZlFImnPX+NSL3Dt1T6GfFCXk9XeDhBisiyBUJipnQ3qldJ1iE3F4UWFaUQ/
 zta/CnO3bPSDy2RdCXfO0NFQKq8bSOKHixTCVoT778MZSE66Q1ctuLD
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004683:EE_|LV2PR19MB5790:EE_
X-MS-Office365-Filtering-Correlation-Id: 84ed494c-89ac-44c4-769b-08dced76442f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bHVrQU1PNEdPcTRVUFE5ZUJZbkhFYjFnbXVhYzExVTF4TURySlNNM0E2b25r?=
 =?utf-8?B?ajVnSm5ka21EZDRGSitodUxTcXVjNFlpQmp4aXNZUVU0NnFaL1NBRDd0NnJV?=
 =?utf-8?B?TnlJL09CMmNiUXdTajM0UHdYU0Q3c2c0S1dOM2x1djE3OUViTmthVkJPOTJs?=
 =?utf-8?B?Q3pVOC8zRUg2WGFacFFnUkR3WDZUQ0ppbVhCUU91TjV3dU5teCswQStVeXVs?=
 =?utf-8?B?eSt5OVVydjJoTTJwTGJNVXJ6OWtmUXh5WGR1MWlKK1ZBcjBIZzRCSnRVV2Rz?=
 =?utf-8?B?ZXUwM1ZnT2d6MStMa0hBTFpsU2JBc05WZVpXUXFJZFZrNk9jaEl0RmszZ1F4?=
 =?utf-8?B?WThUMnQ1aGZLM1pxZTJ1aTBGWXZWRytnNVJpa1ZlZWhvV3J6VnRxMFo1aGNj?=
 =?utf-8?B?eEdLd05tMnB3MG1PVmp6R3lFVjRCQUZhRDU3NzVUa2kwa210RXM3ZUN0ZlhD?=
 =?utf-8?B?cUFndGJITTQ3SlZoUUFKR3o3eTdDTmJsQ2VNUUZyVTk3UkMrb2t5TXNJaDN1?=
 =?utf-8?B?aklNYmV3ZFBLaEFuMC90NVptQXIwQUh5ZGRSTlBiOFZFMEpkUFhIVXAyUjNG?=
 =?utf-8?B?Q0NDdjRGTEhQZlZvZHN3cFRkR2RJbmVvdUZIMDlyNE1aaWo3WlpUdXFSVUZn?=
 =?utf-8?B?dVpYdGd5SUo4Slo2TURkbUczNkVLTGVVYStua3kvRXoxY211b0pxaldseXBz?=
 =?utf-8?B?MFdxdEJhdldqdU5MdUlSS0JZT0JVNUVMOFE3Q0dBekpCdnN3YUZiQ0ZLenlx?=
 =?utf-8?B?azFnb0hzeFRmWEw1YTYvVHYyWmkxL3hCR3JxVFN5QW5IaGxabkd2ZzdVTE9s?=
 =?utf-8?B?QzBTSDYxUHVNVk4wSHZUYWtHdHVwY3ZsaGZoenN1SEVPSitJekIxa3ZKaFQz?=
 =?utf-8?B?bk5DenlIMTFsNG01R3NjMHkvWC9VUGdOYUFIM3M5S01iTytBWDZtSlZIZDVx?=
 =?utf-8?B?WVh6aGNVd3Bzd1cwYVA2UThFRFdQU1BqdTZlVDByVXR3WnFKbDh4NFcwcnlt?=
 =?utf-8?B?VWVGMmp5QUQ3NGJZWWdoQmgxMURERkREQXJ0MkNwMVA5S29qcUlja3RUVDE4?=
 =?utf-8?B?L3FyaVRyamJBWGM1S3lXVS9Wa0FvYUZ3dUx0aVIvTVdqQnd1Q05MdDJtdFI0?=
 =?utf-8?B?bUEzVHhHdEhSM3lqeWZmdDMvdXdRTEh3c1RpYnZXRWRyazQ5SHFab29PZlFn?=
 =?utf-8?B?aDVaSVpQdDVRdmlUU1d2RTAyWW1BUUFBL3ZqVGU0RUNMYUpFbE9nMkY1bEM2?=
 =?utf-8?B?ME9KQ2kvUnIvcjl6NXY4MFp0anlDS1JWdHRVQ3oxMXBzYXdHa01VKzd3enNP?=
 =?utf-8?B?dVpVR0laTmF3b0J6ZHhtV2gzWXdGN3N5ZGU2bFY0dkJEa3lqc0ZsMXRPK2hP?=
 =?utf-8?B?SVY1emFXc2o2VThZUDBuWEd6dTh1cVdXTjJuM01GMEx3cENyeUhXWldFNCtj?=
 =?utf-8?B?WkIyM3lmR0ZVcDB1YndFSWo2ZkpVeGU4RklDcFFvVFUzdzZpM3VqZ3YzYVl5?=
 =?utf-8?B?N0hCOUNHRS8zYXgrYkJLbktPV2F0azBnSmhwNXZOY3hRVnhQbjAyL3dHeDFE?=
 =?utf-8?B?K0Yvb1YzYUp1OWovaTU0QmN3bWNKakR2TkEvWXNtdGdUTGExME81L2c0VzIz?=
 =?utf-8?B?WTBicTB3NUZVbktsd0hPL2dsV2d1b1FOb1dNZ3I0U0gxbTVGRjR5RkJxUHlj?=
 =?utf-8?B?cHRWU0kycXY4aTMrVG1xdURtclVtU0dTMHBZMVdGbDNHK2NZNW1TVE90cC9s?=
 =?utf-8?B?M3JrOXVPOUdtd2NsZ3NBcGZKMjIvcGNCMlVkOGVTRlNKbHNqVVVmM1ROYVBQ?=
 =?utf-8?Q?IeL5zaPOQBpdge5EvvEmfZ06xoZmhH4XcjJBg=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	23hDnS9LywscdQaxKN+SccGbnz4WbJa5VVQMZQa50/tw1Modo0/AGqMr8qb4cAnirRFb02S6ScDBPkiCyycjYzTD9twnFkS91DTZchnuXaOhL1OuGTm1dLC1FFBTMUCMMYM+AKRcnbp89FEo0pyqzPKC8OBHi2v07+h3NnpS1Ov5quU6cjrk9EwR6Bvt9nBO1BP9aWOVk2XkNlOkkVnCQpUA9vqClc55miquRI7+DpxTJ4NyTyY76ZhVNxbZtKohW7VvumTnSFHgzAr6Hso4FzM8Ogok6XoAD2d0ie5MBtOHDN4sU5zthAHQcwgiWJDBEazMT6+CuHIqQubwqegCPG/+mQpn3v611skISuo6xa5Ktozv13NNNaDUy3kauyjdLdoGK2uOZ131KeAo6gWqunjDL8G0psdSgfKWenC8AcCZaDgknWpoc0I6XYdYillsFbX6gJrwvRSC+Wl2dYxN1b35uQx64iXpXknlzfk6xX7RvW9MVndGGr4tiMSfr87eEUymD1oatFSGEJh8VFRQ59y8WWR3Ih3gl0CaZRiykacvm/cwxKEv6oaP6MVR/x+TcZEhhEQslCdLc9uHkF/PdnNM86ocbS7g6HdZJ+T4dvEPR0UFQXfNi3IlnNm3kaMV6ydUKbUrCXm6OuVuaAzGAQ==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 00:05:38.4090
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 84ed494c-89ac-44c4-769b-08dced76442f
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004683.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR19MB5790
X-OriginatorOrg: ddn.com
X-BESS-ID: 1729039085-111953-26388-18957-1
X-BESS-VER: 2019.3_20241015.1555
X-BESS-Apparent-Source-IP: 104.47.73.48
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoYGFsZAVgZQMMXQOCXVyNTC3M
	AyxdLM0tIyySzRxNTYKMnQzMQiOTVNqTYWAOEiGAJBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.259752 [from 
	cloudscan20-251.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC0_MISMATCH_TO, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

The ring task is terminating, it not safe to still access
its resources. Also no need for further actions.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev_uring.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 6af14a32e908bcb82767ab1bf1f78d83329f801a..6632c9163b8a51c39e07258fea631cf9383ce538 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -986,16 +986,22 @@ fuse_uring_send_req_in_task(struct io_uring_cmd *cmd,
 
 	BUILD_BUG_ON(sizeof(pdu) > sizeof(cmd->pdu));
 
+	if (unlikely(issue_flags & IO_URING_F_TASK_DEAD)) {
+		err = -ECANCELED;
+		goto terminating;
+	}
+
 	err = fuse_uring_prepare_send(ring_ent);
 	if (err)
 		goto err;
 
-	io_uring_cmd_done(cmd, 0, 0, issue_flags);
-
+terminating:
 	spin_lock(&queue->lock);
 	ring_ent->state = FRRS_USERSPACE;
 	list_move(&ring_ent->list, &queue->ent_in_userspace);
 	spin_unlock(&queue->lock);
+	io_uring_cmd_done(cmd, err, 0, issue_flags);
+
 	return;
 err:
 	fuse_uring_next_fuse_req(ring_ent, queue);

-- 
2.43.0


