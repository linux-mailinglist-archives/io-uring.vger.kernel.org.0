Return-Path: <io-uring+bounces-10155-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DDA1C00ED9
	for <lists+io-uring@lfdr.de>; Thu, 23 Oct 2025 13:56:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8A1F119A5008
	for <lists+io-uring@lfdr.de>; Thu, 23 Oct 2025 11:57:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8B6430AD0D;
	Thu, 23 Oct 2025 11:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kS79nOc+"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2080D2FE04C
	for <io-uring@vger.kernel.org>; Thu, 23 Oct 2025 11:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761220614; cv=none; b=Zf7e1kXgZPsxdUTlL98wj7njpbIW7mX+KpFUsKTF4QcNc6UVTS8a8D1brvQ2aa/c9QbLCeLBwWb92C5NH/Mj4+qexP2WqEbfY9y9ALiuMIPySA7MoHUTugccIBgZ14Zq47VtB0oApbYI55jTqv+aIu7dogeZmJEgQubjrkfGPR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761220614; c=relaxed/simple;
	bh=2mCyZ/casYpKKs4kEQALfq6uaFE+arwn/K0lqtCYuHI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IqxQ/+n6Wm4RSdLrD3kvedzesUDlW1nYfukwTQYO62I+dCOhnVtxlX/pOkHTu1F0AFBGCXdMNhOpAPggE34j8E8vsnfRcF0adjkhA+3pNpNEm6l8EtEYWHRb+ZHu1ZuToPW4S3pClPt0Xbq5z8WVHQfWj6Q/0jC2MOYISMg6WYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kS79nOc+; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59N7uUYS025031;
	Thu, 23 Oct 2025 11:56:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=5KKrLjIcIlX/YnU42jGXR7sBhOjwv
	jXQpBKFSHQjK6w=; b=kS79nOc+OT/GHZ0nHONxBL95fAeZNqUuFgXWbxFVAJhWz
	c2Xr3CwIm6p8hOkZ7Axgvzz+Dw8oHZh+NhffHqydmTBG08LHSFJ7BSS0yat7oY8J
	ZyXXIODRjWRT8SXAW+S0tjm2x3KBBJpxHkCF852O+xxwXy00k7qjVsgjhd67R2CH
	/LcwDjqArodWspAS9AepzR7Sdh/xYRQKsC09YDD75PyLje7vfmVib/5R45Uuvaik
	gQMXOX7leyU8bpEChciBTZeYhbjNWGheab9nC+bys9K0OSz3m3fFsDPDLog25zye
	/k5qFGuYPt78IxD8NKbYaBt0fWqwc9RNAFpB/I3AA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49xv5wjbk4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Oct 2025 11:56:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59N9SXtF022433;
	Thu, 23 Oct 2025 11:56:49 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bfgv2a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Oct 2025 11:56:49 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 59NBpweI034918;
	Thu, 23 Oct 2025 11:56:49 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 49v1bfgv1q-1;
	Thu, 23 Oct 2025 11:56:48 +0000
From: Alok Tiwari <alok.a.tiwari@oracle.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, alok.a.tiwari@oracle.com
Cc: alok.a.tiwarilinux@gmail.com
Subject: [PATCH] io_uring: correct __must_hold annotation in io_install_fixed_file
Date: Thu, 23 Oct 2025 04:55:24 -0700
Message-ID: <20251023115644.816507-1-alok.a.tiwari@oracle.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_08,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510230108
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDA3MSBTYWx0ZWRfX9FWg8/G1iBIh
 km9Yi5+9ppt7D0kfzx23Y2HS9vPHgCef353GncOT7/WDxxUhL32BDjDOvhPWfYOful2xdagZY92
 EJ0dWqk+WFhv/AHcGD2mPEC5kTuhSAtmVwlSzaNjgr+Zy/Hak426ojGhztdzm8IWNhDrgmbTyZg
 7L8mCQ2bneeAGj6lFM8Qzf5db2SW0OfbLvtuHhuBoGQuMgQ4NH97eemHzmj1JxReXX/E+kvpzgr
 y7QU/SZrExINdTcEYYNxCm/fN9NTh/7PgSR5fDLpFnlLEHoFrinTSUqj2E6Bdu2CesVyBMNLPZZ
 cjarBlB4aNKul+J2oiEpSkcbUVMPMR6M2PJyAgwWwHicBKdKSwHpx0QrEWSROVZlWKagfUMrf13
 ssJ8vCOkuIMV1VDBNSycTVk9ge9HrkKC0/4w3i+fFrlIMb6ajGg=
X-Proofpoint-GUID: Z5TKBDrE7BdSpBAJNLUsMUolYSNSFwSD
X-Proofpoint-ORIG-GUID: Z5TKBDrE7BdSpBAJNLUsMUolYSNSFwSD
X-Authority-Analysis: v=2.4 cv=RfOdyltv c=1 sm=1 tr=0 ts=68fa1802 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=bIF5ntOWYHFxN4-9KOoA:9 cc=ntf awl=host:13624

The __must_hold annotation references &req->ctx->uring_lock, but req
is not in scope in io_install_fixed_file. This change updates the
annotation to reference the correct ctx->uring_lock.
improving code clarity.

Fixes: f110ed8498af ("io_uring: split out fixed file installation and removal")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
---
 io_uring/filetable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/filetable.c b/io_uring/filetable.c
index a21660e3145a..794ef95df293 100644
--- a/io_uring/filetable.c
+++ b/io_uring/filetable.c
@@ -57,7 +57,7 @@ void io_free_file_tables(struct io_ring_ctx *ctx, struct io_file_table *table)
 
 static int io_install_fixed_file(struct io_ring_ctx *ctx, struct file *file,
 				 u32 slot_index)
-	__must_hold(&req->ctx->uring_lock)
+	__must_hold(&ctx->uring_lock)
 {
 	struct io_rsrc_node *node;
 
-- 
2.50.1


