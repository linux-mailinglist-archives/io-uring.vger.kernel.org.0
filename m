Return-Path: <io-uring+bounces-10049-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D3BD7BE89E1
	for <lists+io-uring@lfdr.de>; Fri, 17 Oct 2025 14:41:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6C3FF4E3F80
	for <lists+io-uring@lfdr.de>; Fri, 17 Oct 2025 12:41:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 397552E5B2A;
	Fri, 17 Oct 2025 12:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TObgM7CN"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1052DC328
	for <io-uring@vger.kernel.org>; Fri, 17 Oct 2025 12:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760704889; cv=none; b=YZ6qX+5mapzj1OkjvLaektsbE+iyUoHuqhtj3ngfi0FWNUvqabHK6LkmxolEDigXdkBI2adJO2nkuNp+HzXUXKer1n1e+hoSSEKY2kU6Cmp3AcC7n4HxNo7FdXfbalUTdz1gPYv1t61BOk1rHySvrQHSpx7C3agXe1YYNQ/KTQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760704889; c=relaxed/simple;
	bh=vZggdkUf7jnX+h8X1bYU+Y/iElE5TJV0J64jXX2Gwbc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XzQ6fyoFTgnc0Np2NxNjvsXGXOQTxCtjameIHOqgQ7l3Cj18PNF+vkGoAI08kd/WsvIeVdW4+UBtuP4v+Z2QWsWPhqLKmokLZj6Cup2E0WzK/Dg0W2QAdQNxXHABYrUnXut2Q6efQcDGRgh12NOdfzhblDpeowpl1mu5HDGie3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TObgM7CN; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59HCdZkA030258;
	Fri, 17 Oct 2025 12:41:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=1UoJDzCZZ4LhKLW8H9U3/C/En761l
	XK9HuA/1TIHXkg=; b=TObgM7CNFMdCrFpi8GQTvMRV9aaUwn486NJI16O1iWPGh
	z+EqqYHHDkg10rRWHqNm+0G9T2IrZlI7ehJgLE6G/Q9AjRxeXRW/S8FvI6r8vu49
	ypzXG5Cx72c9vCr96xzZ7qgM+Au2BczJZ9elLCl+zMEIr8Rqwe6cQkU9HS4ebPRy
	bUWtzFruLA+LI8A/tSOfzZQClY+1HDn+exmmqvrCXqQnhnU+5lFiW/ZnvpEERifB
	uUwav0dAeu6KHP0ZgutkmfM1rne2jM/CNX9y3jvgGbiISlnKHnjnctwAaYN7fET2
	57+UaxjqBR4pbb+J4ChPXQrzPXRywQa6MPeH1+e4A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qdncatcw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 12:41:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59HCFAuv026006;
	Fri, 17 Oct 2025 12:41:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49qdpk1ttr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 12:41:25 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 59HCdl0f028597;
	Fri, 17 Oct 2025 12:41:24 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 49qdpk1tpn-1;
	Fri, 17 Oct 2025 12:41:24 +0000
From: Alok Tiwari <alok.a.tiwari@oracle.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org
Cc: alok.a.tiwari@oracle.com
Subject: [PATCH] io_uring: fix incorrect unlikely() usage in io_waitid_prep()
Date: Fri, 17 Oct 2025 05:41:14 -0700
Message-ID: <20251017124117.1435973-1-alok.a.tiwari@oracle.com>
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
 definitions=2025-10-17_04,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510170093
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAwNiBTYWx0ZWRfXwAqwwhu0WzFA
 CFpiZ0dtdXFflXxpoVRnAi7UwRtWUqseoaMTtt7reUx9pg7VLxePn4xNhm5nTw/cJEHSAFbAHr8
 BsNdfjwlPIqxe9COARQE/FjVSSVrD5kbyopTp3q4NM0gVOfLOpCIjglrrHI13Ao87waxc+oIklE
 3AXkjiNwr2lKDb5snjnlP830D+iOi2yZl8BXG5J0qVmefS9vF1xz6ps1T5blglgVfz2mpWxpYjW
 EEgmHYWLvx/ATbctYa8l1lz1ocMMeGXkFEBQe4etaqUfdAFle/C47lz6rcpICDYQraz+ugcUwpj
 8Hbxshs7rR22EGU0ncSBCUPgNVFnKYWq/h4Jn41QtHY5MsWaH0dZVwrwqnzSUXKR/pDLaXpaPC6
 b0naTJKHBS8kXC/d0fIMF9XxdcVawBQ/YYxjGWsWJ0GWFt4xcc4=
X-Proofpoint-GUID: 4lkk12JU0-F68wR0foed6qMQNpsHkHNI
X-Authority-Analysis: v=2.4 cv=ReCdyltv c=1 sm=1 tr=0 ts=68f23975 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=h5z9rYTt_CK6w-t67_cA:9 cc=ntf awl=host:12091
X-Proofpoint-ORIG-GUID: 4lkk12JU0-F68wR0foed6qMQNpsHkHNI

The negation operator incorrectly places outside the unlikely() macro:

    if (!unlikely(iwa))

This caused the compiler hint to be applied to the constant result
of the negation rather than the pointer check itself.

Fix it by moving the negation inside unlikely(), matching the usual
kernel pattern:

    if (unlikely(!iwa))

Fixes: 2b4fc4cd43f2 ("io_uring/waitid: setup async data in the prep handler")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
---
 io_uring/waitid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/waitid.c b/io_uring/waitid.c
index f25110fb1b12..53532ae6256c 100644
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -250,7 +250,7 @@ int io_waitid_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -EINVAL;
 
 	iwa = io_uring_alloc_async_data(NULL, req);
-	if (!unlikely(iwa))
+	if (unlikely(!iwa))
 		return -ENOMEM;
 	iwa->req = req;
 
-- 
2.50.1


