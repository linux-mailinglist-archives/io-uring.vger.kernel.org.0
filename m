Return-Path: <io-uring+bounces-3705-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16BAD99FD3C
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 02:38:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C7B7C281536
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 00:38:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 084CF1097B;
	Wed, 16 Oct 2024 00:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="phbG/qis"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3088FE574;
	Wed, 16 Oct 2024 00:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729039110; cv=fail; b=A8H5Et2qzbjQOMpr9p34RgIauBzLZBdPodJ5dzf4+avWCKpu1kLy9ZepjFGQ0u5f6rle4QIwWNyylYjVb+bB/gqmkGyzxABV7G7VTRzSkdEmvqlbv3Asatv41tIDp83HSScaHpZfPewpagIuutGlg4YECUlGZ0hjJosNWTPtw6w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729039110; c=relaxed/simple;
	bh=BgFfhvEGN7m+wreSHkg6j6jdrq5eYLwkMz2PHkavrEc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BlH1mgq23IUVbStqh+MHCeWpUU1g4LBQei/XAuygyCekVcfVCppeCELjZ1DvnQIhTzAuTO5AsjeuPkKp5J5hEROhjZM5H7ddYRWOrmjTyzxQruMivXnXzPPIMWictKbWmcgUcSIey6b7GrV1SLJcAKcrS2RhMLn9EI86INNXOcU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=phbG/qis; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2040.outbound.protection.outlook.com [104.47.58.40]) by mx-outbound19-158.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 16 Oct 2024 00:38:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ncKsGxndADt7KnPA4IsZjOqfyfXxt5CsSIteiZrIs6LtjUx1EpVkF5pkGr2XdbkJl7VAnLZRXiPeClS+Nh9xHFrgnGDndLDJMQ13beNDhPoQIbFuulYXlThx6ttjUKALNm9H6f1/45w+EQgGUGceXM56+HTlG7ra7keTy2gOcifueXsioPDOY0Mb6OAtTvu7IMBFqA6g9zu0/Py2VrSZ0FfEiSagNsZHtPv/gBH6En9LOawCLfLi4KWdGW0Afm068T0X3fCk6kXFCUKN3TQNa5HX92tFOKidqGGpzDu5mlCSSQKmoXGSc/zX0BAf8CxYaFjF2VTC3KQI6dsGQTye1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wbj8GKOEap7E+5/Lr5bDNxYBjpGT/1hlPblIhM/ZU7s=;
 b=Bfokc4G5wgeN0E5W7DBXkns/AIaU8TeFtOmfxTa2SLyyvM4/12E20L3nKvA8Mgzu3JAOKzh2TQo9oUaX1LFLIkvut9MC7f27taVHKMkilNiPMuxON4QSSM9HjXpSQvEfakFkerfaYDVs/WbsZ3OssyZuA3eITpikDO0K3anaL0aXOJSUWz1TlNfvcQ0EX0rqMwbON62o3vclpHeIcM5iI+TJgU1GzzMMXy83E/gqU65yJonreIUum3NssC4tet2LUr7ZoiVMCI8LbD5Oqcc6gsq8Pqv20fnBJLNCL/+hRv2ZNpxyprzhHLv12dDbaRrCeuTeGyZh3TPqerReNt9cyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wbj8GKOEap7E+5/Lr5bDNxYBjpGT/1hlPblIhM/ZU7s=;
 b=phbG/qisvrqw7MA3EbPSKfFPupUPTe046F6kEAUP/045qaZjoJ15mCjs4QLaWcGa669Cb7QnuE/f3Y7MuKb/9CzMvmBjC8DdlCdYL30W18OBsssi149fUSVAcGB/HNRv/O46NfD4IildN7NV5ljYN3Ku0OAPsKptKC8xXYbxMpM=
Received: from CH0PR13CA0049.namprd13.prod.outlook.com (2603:10b6:610:b2::24)
 by SN7PR19MB6565.namprd19.prod.outlook.com (2603:10b6:806:26f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.17; Wed, 16 Oct
 2024 00:05:35 +0000
Received: from CH2PEPF0000009D.namprd02.prod.outlook.com
 (2603:10b6:610:b2:cafe::87) by CH0PR13CA0049.outlook.office365.com
 (2603:10b6:610:b2::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.16 via Frontend
 Transport; Wed, 16 Oct 2024 00:05:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CH2PEPF0000009D.mail.protection.outlook.com (10.167.244.25) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8069.17
 via Frontend Transport; Wed, 16 Oct 2024 00:05:35 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id F203029;
	Wed, 16 Oct 2024 00:05:33 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Wed, 16 Oct 2024 02:05:22 +0200
Subject: [PATCH RFC v4 10/15] fuse: {uring} Add a ring queue and send
 method
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241016-fuse-uring-for-6-10-rfc4-v4-10-9739c753666e@ddn.com>
References: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
In-Reply-To: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Amir Goldstein <amir73il@gmail.com>, 
 Ming Lei <tom.leiming@gmail.com>, Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1729037122; l=4852;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=BgFfhvEGN7m+wreSHkg6j6jdrq5eYLwkMz2PHkavrEc=;
 b=6cgw9Ub19Xrn5acWZ7ab0Fd4VfBhS9V8bwfBwN+1sBzDNJlO3HyPdyUWcr+JAsnfNpWEPtJ04
 TJA53loaGc5CjdDEHxMAjCzDTmMg8Q23y3VMWpeXXoW13SHLR4fgB9c
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009D:EE_|SN7PR19MB6565:EE_
X-MS-Office365-Filtering-Correlation-Id: 788a4c69-fabe-49ab-d848-08dced76423c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q0dPNDNLTmFQcnBnZ1VPNjFvblY4b2NLUmZydDlXNmFnT3dQMzJyaFRSU3pJ?=
 =?utf-8?B?ZXNzU1F4MEVnczI5U2FnSkEvbDN2VnBMR1YxZ2Nad2F1QlBCaTB6ZSt6d0wx?=
 =?utf-8?B?a2thcFFaSmJFYWpkQm4vSU03WkNxZi9lS3Eydk9PSUwwclhzV2dwNmxDbTFG?=
 =?utf-8?B?bHVIQ1VpVlRWT1NFaXpNbTMvYUxLODJxd0JEeHRtNUhaNm1TTU9EZUpxZG5J?=
 =?utf-8?B?MndCMllmTzM3bFNPTUxXZUh3czlOeCtkbTdrMnNGa0R6ZWRaZEQvVTZpdThm?=
 =?utf-8?B?eU1UaHNuTWs1Qk80NVNlNERFL21IMDBZNlhYQmg3ZFRLRkVNRGVyN0RibnNK?=
 =?utf-8?B?VkRsbjA4T2trdmNXcWp2dW0zN1UvRnFQZWlQZE5pNzIvVExpR0RtOGZSd2Jk?=
 =?utf-8?B?NnZ4dnpvT3p2Nm1GcFdTdm9iMkJWdlVyaERRb0JUNGExdFdPRHc0dkNFaEk5?=
 =?utf-8?B?MkgxSnpHTlh0dGl3eE9oekFMT1ZDdDlQOVM2eWNwSDR2SVJmS0lGbEluZ0hN?=
 =?utf-8?B?WkVkY1NUTlZQMk0rS0lXUW85QkxVWGY5M2ZmZlppTEVidGVGbk5kV1p3by93?=
 =?utf-8?B?TGZOemxUN3VldjI1dHI3MFlxUDVKSkZuMmlkTllralRROUs2MHlVNEFBdWZU?=
 =?utf-8?B?VlpSb3Q0UkV5UjBVMk9IcWlqTzVEaVMwUnRMdVd0Y3dkWjNabTZQNEdPaXpx?=
 =?utf-8?B?NGNGSFAwZ21Ha0RBQy9tejk1M1FjbmZqSjBsREIyVlJsTTZYOHIzazN5YWRi?=
 =?utf-8?B?eEk2TEdMZkhtVTF6dXZyNnE5ajQxQ3F0blR5YUN3VGtWZmk0RUs5NnlOYUlM?=
 =?utf-8?B?WkI4cXBvOHlVeExFNTV4VzRORGpJcWR5TVl1cDFsV0p1T1VRdWVoSFFOY2ox?=
 =?utf-8?B?d0JtWFhqT1FwbXJGRUc5ZDBqdFNCQmxaeCt0UWUyOXpKOUZtd1d4LzBHcHls?=
 =?utf-8?B?WFdzVUZ6Qm5yRmdEaUpGNndZRUJkRTZMSUU0disvQ2FXRnZ3aEgvanZzZTI4?=
 =?utf-8?B?OFUvTTZFd2s1UksyTnZLUUd6NU54RkRQWGZPK1liVUN2ejI3cXp3ZU1wbFVi?=
 =?utf-8?B?ZUlIcDg3MVc0MGh4SER2di9jeUo0SWVDQmNZekpxekpSSk9JNnU1VUp0ZWZz?=
 =?utf-8?B?djdHYXNpeFFLR3hIejdMRHo3bEpoRFpLWFI4MDdYS3dVOXQvRlVLS1VsSXNo?=
 =?utf-8?B?R2FzOGIvWm9vOTg1VWFTVVd5NkQ2ME04ZnUxMTFQWHk1RnhPOWNSNW1yZzRC?=
 =?utf-8?B?N25aZFNtOXZtbEpGN2pRYmowYThEYlQxVVZDUGozYmNVR0VLYUFzWmVxTXdw?=
 =?utf-8?B?Nno2KzZ1cmhNS0xKOERLL2lHWmdJMjN3TGdnK0QrQktpeVlWSEZmTW4xYU1J?=
 =?utf-8?B?RVRIckV2TDlhak9ORW9HTWpKeHBjUEpFU0RuTHE4VFpLRFpZMDhRN3RuNUZZ?=
 =?utf-8?B?Y0V0eDhQalpmYytWeE0xTTJvVUxDWnZrdHh3cmtZbFlNb0kzZGw4WFhrUXo3?=
 =?utf-8?B?THJ2cWx6Wi85azdXYm1IS1BIWTJaMWIzOEU3SWl5Tk9MYmRhbXlxcEJPRDNa?=
 =?utf-8?B?Szh0NnV0UW5sRW9adCtmQnhpbFEwek02WTI5QWszN1N5ZXMvQ2ZnTC91Qyta?=
 =?utf-8?B?ODFOOHdxOUdrWGVWUEFVWVE5STJLeTc1WllpRUd4ZENZc3dRS0paOUFtYXJr?=
 =?utf-8?B?UWJUY2hVenJ5VHljd0ticUFBNTdCMUFpTmx3Q1Fhektuc1hCNU1pQ1lveXpD?=
 =?utf-8?B?VkxjamVZa2FtcWlsTVdjUjdhekJ6aDJrVEdEMzFzNldXbk9hVHJOblB0ZUY1?=
 =?utf-8?B?blBUMlg5YnZmNEJVSWdXR2lCa25uVHhXK290eENQSGgxSDlQUG5XeG85dnBm?=
 =?utf-8?Q?1jXrSbCLs+K6E?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0+OZ0NMnzfOxF0LbV1CWtW63Mu6I+6me5vH5HCwi+t68ABzOPdovzkhOiEtXrjVqOwLLnFXTfzcTOyqE8Yz+cw/idJh0vmfE/z6LhikwxgoQbpK6L155VShDjpz8AvDk54WVYXMEjwHzn+WHr8CRlJW/+avYYbwQPHJgUwCnD0e/rrYka2wRx4pKMTFZYB3xdR8d59/DgwuQm5SWcHYnLNdRIyAELaLACUC4QINF+nQkTuc0g7SLXAyssW0jssqeKClkCg84J1sLzr6I305nk7l8/x69MbgPO6EofD5WNHTo5ijx4UDNW6p+wddXRvrQ59ngA7wYVK2LhHfM9LWY+l3Dq6vpDtEsFYphaXjExUuNnzHXIS+jzCIguwj/9LZXljGes1Kdf5RTqL/LmTOZ5pwfsGHH3n0PUJZ8iXBgAvm8JFGothmDI3oYqBTnOlJEoAJgf4XfZCtO0WuphMaIkNDVBiqoADvOJpWUhGL7t3RAdhxYwSYWwDA9lvfiCbJd1KVGtsGMe0W7Bbsk0Bm30UXAyFsP8a4WbJX/1u3mAEM9VB3K1CjcdxgzJKhNRkZnfvLlMLjZgN30tU5z8qS24GinFgUaLIbkR7RytPCE55u5aOyL7LrBLPROc1XzSNZhqhYHZrVJz1Y2wBhgKXROSA==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 00:05:35.0631
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 788a4c69-fabe-49ab-d848-08dced76423c
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR19MB6565
X-OriginatorOrg: ddn.com
X-BESS-ID: 1729039105-105022-12728-62650-1
X-BESS-VER: 2019.1_20241015.1627
X-BESS-Apparent-Source-IP: 104.47.58.40
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVibmBoZAVgZQ0DLRyCQt2SItMS
	3NwiQp2TQtOTXVwDDR3DAlLTktNdVSqTYWAPdO7OpBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.259752 [from 
	cloudscan13-9.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This prepares queueing and sending through io-uring.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev_uring.c   | 101 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h |   7 ++++
 2 files changed, 108 insertions(+)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 455a42a6b9348dda15dd082d3bfd778279f61e0b..3f1c39bb43e24a7f9c5d4cdd507f56fe6358f2fd 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -19,6 +19,10 @@ MODULE_PARM_DESC(enable_uring,
 		 "Enable uring userspace communication through uring.");
 #endif
 
+struct fuse_uring_cmd_pdu {
+	struct fuse_ring_ent *ring_ent;
+};
+
 /*
  * Finalize a fuse request, then fetch and send the next entry, if available
  */
@@ -931,3 +935,100 @@ int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 
 	return -EIOCBQUEUED;
 }
+
+/*
+ * This prepares and sends the ring request in fuse-uring task context.
+ * User buffers are not mapped yet - the application does not have permission
+ * to write to it - this has to be executed in ring task context.
+ * XXX: Map and pin user paged and avoid this function.
+ */
+static void
+fuse_uring_send_req_in_task(struct io_uring_cmd *cmd,
+			    unsigned int issue_flags)
+{
+	struct fuse_uring_cmd_pdu *pdu = (struct fuse_uring_cmd_pdu *)cmd->pdu;
+	struct fuse_ring_ent *ring_ent = pdu->ring_ent;
+	struct fuse_ring_queue *queue = ring_ent->queue;
+	int err;
+
+	BUILD_BUG_ON(sizeof(pdu) > sizeof(cmd->pdu));
+
+	err = fuse_uring_prepare_send(ring_ent);
+	if (err)
+		goto err;
+
+	io_uring_cmd_done(cmd, 0, 0, issue_flags);
+
+	spin_lock(&queue->lock);
+	ring_ent->state = FRRS_USERSPACE;
+	list_move(&ring_ent->list, &queue->ent_in_userspace);
+	spin_unlock(&queue->lock);
+	return;
+err:
+	fuse_uring_next_fuse_req(ring_ent, queue);
+}
+
+/* queue a fuse request and send it if a ring entry is available */
+int fuse_uring_queue_fuse_req(struct fuse_conn *fc, struct fuse_req *req)
+{
+	struct fuse_ring *ring = fc->ring;
+	struct fuse_ring_queue *queue;
+	int qid = 0;
+	struct fuse_ring_ent *ring_ent = NULL;
+	int res;
+
+	/*
+	 * async requests are best handled on another core, the current
+	 * core can do application/page handling, while the async request
+	 * is handled on another core in userspace.
+	 * For sync request the application has to wait - no processing, so
+	 * the request should continue on the current core and avoid context
+	 * switches.
+	 * XXX This should be on the same numa node and not busy - is there
+	 * a scheduler function available  that could make this decision?
+	 * It should also not persistently switch between cores - makes
+	 * it hard for the scheduler.
+	 */
+	qid = task_cpu(current);
+
+	if (WARN_ONCE(qid >= ring->nr_queues,
+		      "Core number (%u) exceeds nr ueues (%zu)\n", qid,
+		      ring->nr_queues))
+		qid = 0;
+
+	queue = ring->queues[qid];
+	if (WARN_ONCE(!queue, "Missing queue for qid %d\n", qid))
+		return -EINVAL;
+
+	spin_lock(&queue->lock);
+
+	if (unlikely(queue->stopped)) {
+		res = -ENOTCONN;
+		goto err_unlock;
+	}
+
+	list_add_tail(&req->list, &queue->fuse_req_queue);
+
+	if (!list_empty(&queue->ent_avail_queue)) {
+		ring_ent = list_first_entry(&queue->ent_avail_queue,
+					    struct fuse_ring_ent, list);
+		list_del_init(&ring_ent->list);
+		fuse_uring_add_req_to_ring_ent(ring_ent, req);
+	}
+	spin_unlock(&queue->lock);
+
+	if (ring_ent) {
+		struct io_uring_cmd *cmd = ring_ent->cmd;
+		struct fuse_uring_cmd_pdu *pdu =
+			(struct fuse_uring_cmd_pdu *)cmd->pdu;
+
+		pdu->ring_ent = ring_ent;
+		io_uring_cmd_complete_in_task(cmd, fuse_uring_send_req_in_task);
+	}
+
+	return 0;
+
+err_unlock:
+	spin_unlock(&queue->lock);
+	return res;
+}
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index c19e439cd51316bdabdd16901659e97b2ff90875..4f5586684cb8fec3ddc825511cb6b935f5cf85d6 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -122,6 +122,7 @@ void fuse_uring_destruct(struct fuse_conn *fc);
 void fuse_uring_stop_queues(struct fuse_ring *ring);
 void fuse_uring_abort_end_requests(struct fuse_ring *ring);
 int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
+int fuse_uring_queue_fuse_req(struct fuse_conn *fc, struct fuse_req *req);
 
 static inline void fuse_uring_set_stopped_queues(struct fuse_ring *ring)
 {
@@ -175,6 +176,12 @@ static inline void fuse_uring_abort(struct fuse_conn *fc)
 static inline void fuse_uring_wait_stopped_queues(struct fuse_conn *fc)
 {
 }
+
+static inline int
+fuse_uring_queue_fuse_req(struct fuse_conn *fc, struct fuse_req *req)
+{
+	return -EPFNOSUPPORT;
+}
 #endif /* CONFIG_FUSE_IO_URING */
 
 #endif /* _FS_FUSE_DEV_URING_I_H */

-- 
2.43.0


