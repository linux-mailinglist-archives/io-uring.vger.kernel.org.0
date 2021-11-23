Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A0945AAE3
	for <lists+io-uring@lfdr.de>; Tue, 23 Nov 2021 19:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239757AbhKWSLG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Nov 2021 13:11:06 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:25330 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239697AbhKWSLG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Nov 2021 13:11:06 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ANG9OH9011284
        for <io-uring@vger.kernel.org>; Tue, 23 Nov 2021 10:07:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=QYwJRBCG4n+C26vq1/A2iI/NNChm5L4P2Zru/0cXo3o=;
 b=XM7wT+eLmfrlnKYjPqhjrz+Gj2Rbl7cj01fo/gcIRBZE0VSV1aCr9WjeuN9cFpXjwUmQ
 3xS4+4ZRfila2lkRwSuKz2rplPYev7D6Kmd4oIOSRRFj1ks/gX15YQtFzAMLQBYMcLFG
 lz5Gt2pRLPwJx1YEbZH3jMerYjaggoNBNbU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3ch3jsry0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 23 Nov 2021 10:07:58 -0800
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Tue, 23 Nov 2021 10:07:57 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id DB9A56CCCD47; Tue, 23 Nov 2021 10:07:54 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <shr@fb.com>
Subject: [PATCH v1 1/4] liburing: update io_uring.h header file
Date:   Tue, 23 Nov 2021 10:07:50 -0800
Message-ID: <20211123180753.1598611-2-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211123180753.1598611-1-shr@fb.com>
References: <20211123180753.1598611-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: atPluy_8apcZQb6kNKOMQaQllRmiw8xh
X-Proofpoint-ORIG-GUID: atPluy_8apcZQb6kNKOMQaQllRmiw8xh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-23_06,2021-11-23_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=727
 lowpriorityscore=0 phishscore=0 impostorscore=0 suspectscore=0
 priorityscore=1501 clxscore=1011 bulkscore=0 mlxscore=0 malwarescore=0
 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111230089
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Update io_uring.h header file with new op code for getdents64.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 src/include/liburing/io_uring.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_ur=
ing.h
index 61683bd..5a1f9f9 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -144,6 +144,7 @@ enum {
 	IORING_OP_MKDIRAT,
 	IORING_OP_SYMLINKAT,
 	IORING_OP_LINKAT,
+	IORING_OP_GETDENTS,
=20
 	/* this goes last, obviously */
 	IORING_OP_LAST,
--=20
2.30.2

