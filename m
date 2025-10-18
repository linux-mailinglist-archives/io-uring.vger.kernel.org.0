Return-Path: <io-uring+bounces-10057-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A8157BEDA8C
	for <lists+io-uring@lfdr.de>; Sat, 18 Oct 2025 21:33:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 805A24E68C2
	for <lists+io-uring@lfdr.de>; Sat, 18 Oct 2025 19:33:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E46CE2206AC;
	Sat, 18 Oct 2025 19:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PQbm1RE/"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4501D618C
	for <io-uring@vger.kernel.org>; Sat, 18 Oct 2025 19:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760815989; cv=none; b=OxM7d0pH7ZuG9hXFWsw2mafVWW5TKsm+Dioyv2lYFAp1fLHYyVijGFPYN5m1r6fFqouHltEUt6jxdt/O1Ldru2uR4KOY/MSJiGjKQlzGW5aydodfvDjLCKis6p8wFXxugfCkRy5rQOPgoHLskhgma0aZuM1EjtFWq+CHVioGe8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760815989; c=relaxed/simple;
	bh=mMRa86PQ7eAhksy5gfSVBHC2wU5nwP0hfFHWIt2kAxI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JCavSmGHv8Q8Oom9j4OEpjVJfa+0BtHEJ9PXBFLUNUCzFiXzYkMUH5u1i+VeAwg9yT9iKgv/t9qBTilPoOTOvLES+yivZEtSLolVbnjLjvAN3yEb+gtjH7ka9J5E5PflWl6FMqzzMSSjdNipljqMmR0HSPfTLp+xnImCak5O264=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PQbm1RE/; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59II1fIR007494;
	Sat, 18 Oct 2025 19:33:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=Afnpwd2ZKiqb9a/n7Ig/ycVsgQMW3
	gs2RjKlOb8yJc0=; b=PQbm1RE/9fWpJgVv/7Hu9SQMca8p6o5GeR+LdC6RmEmp9
	9+oqmMHg5Vt128SabiQOQXfdslK6GU3SGm5kRPFTrvM566stgd40e/vLzTZeor8P
	ECXQYN6o0i1xD/pazL5xru9Z3WdpcV4b5N5NU4olYU9GKTjcmykd0WfR42Jz9GlN
	DVRHL0OMc2ZNzb17lRHd43gIRmSOxQe2PiYL88ZESXYVji5JN82Ur91O82PKFMYC
	hgVJ/tbsyPjWaEQTySTDngzrxbz8OyTAs/PKBEG4FviDSCVBRIMVscLcOU8XE52y
	1nR6Lja7L69N0wSRB6t8m3HoQstxRl+qXbMMSndZg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v2vvrfw2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 18 Oct 2025 19:33:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59IDZ6IQ025383;
	Sat, 18 Oct 2025 19:33:02 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1b9fte1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 18 Oct 2025 19:33:02 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 59IJVfAs031342;
	Sat, 18 Oct 2025 19:33:02 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 49v1b9ftdu-1;
	Sat, 18 Oct 2025 19:33:02 +0000
From: Alok Tiwari <alok.a.tiwari@oracle.com>
To: csander@purestorage.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        alok.a.tiwari@oracle.com
Cc: alok.a.tiwarilinux@gmail.com
Subject: [PATCH v2] io_uring: fix incorrect unlikely() usage in io_waitid_prep()
Date: Sat, 18 Oct 2025 12:32:54 -0700
Message-ID: <20251018193300.1517312-1-alok.a.tiwari@oracle.com>
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
 definitions=2025-10-18_06,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510180141
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfXxnrDiqY9fzvU
 LXcQmd22vmW1rc9jPweBm/jTyYItQ22R5R2cb8I2peeppAlMOWscGmuq1mG0yvbx0VunncLv/H6
 UX7o0J3dBe1m+kzzYFoGyO6Uf6L7z03+36EE0yB0slsF4J2+27H+VnLbQAmpWK06rpdQ+18+YbC
 mMbEMOHlWSgvLMauJTjsTh1ZPjCIm2N9euINXdaXVUP4ixNGZgL5VhaRpIfVo4KFFhgaS8cVBRf
 OiAx5Lo8VrPTzYNCDJBJZkzyPUUWAh+CMvL3+h7P+ywnFP2+4sPH/2e8zn7Vb7oUPFED/nMVKEH
 tvZ9Vg+MkqckzRad3sXSACHbWoVSCZf/9OQEsjNRqLOiQUjOOhMXEsQroWwUn37Whtwb+n1VmAA
 AkdcgSPFkiwqS4xcoEtkxdNdzR7Gxg==
X-Proofpoint-ORIG-GUID: klHa_Hz1xKC6d7xmoU0YuLOrxDzcLcQT
X-Proofpoint-GUID: klHa_Hz1xKC6d7xmoU0YuLOrxDzcLcQT
X-Authority-Analysis: v=2.4 cv=FuwIPmrq c=1 sm=1 tr=0 ts=68f3eb70 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=qSk_1sJgm9nw_u2xY5wA:9

The negation operator incorrectly places outside the unlikely() macro:

    if (!unlikely(iwa))

This inverted the compiler branch prediction hint, marking the NULL
case as likely instead of unlikely. The intent is to indicate that
allocation failures are rare, consistent with common kernel patterns.

 Moving the negation inside unlikely():

    if (unlikely(!iwa))

Fixes: 2b4fc4cd43f2 ("io_uring/waitid: setup async data in the prep handler")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
---
v1 -> v2
Remove misleading "constant result" wording and
rephrase commit message
--
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


