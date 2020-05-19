Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B13E1DA41B
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2020 23:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgESVwb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 May 2020 17:52:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47178 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgESVwb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 May 2020 17:52:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04JLpT1k142605;
        Tue, 19 May 2020 21:52:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=jSmSmRPmMDO7m85YjHzVX979hZlekn4HkpKtmEK6rkc=;
 b=yii879+0Si4ws0+M7TTHRf1PiHiDpMV/L8Exc0Jfya5fMkaxpmUnn6kZHlXAXVsq3rgV
 w6pwXv/hopHlRM4HjqsxK8JAdhSe3HN1Nkec2XShzGKHLe9wV7MuYOfuKEk+cLBhnA7k
 e9OQHpGNKtXiSyn0ERIBx2DW4hkTEL8vXp9nshBtGscmknTrX3kCz/IUNZnvfkCg+esA
 8H0qGsgzS1iWJWeqE+wqn9BKJEe9zrGc4euew8ps5+pVIRz8fxqkVbABMOYcXTK4eiwM
 eJZ1clew56G3dj6wTxIUP5vzu09faG0UHfrcXMyjBZ1iAOcTZBUlpF+0bM6kjgT5+7xu yg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 3128tnfwmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 May 2020 21:52:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04JLqPgo020027;
        Tue, 19 May 2020 21:52:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 314gm5vnpv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 May 2020 21:52:28 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04JLqSsD021401;
        Tue, 19 May 2020 21:52:28 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 14:52:28 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [PATCH liburing 3/3] remove duplicate call to __io_uring_peek_cqe()
Date:   Tue, 19 May 2020 14:52:21 -0700
Message-Id: <1589925141-48552-4-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1589925141-48552-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1589925141-48552-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=1
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190184
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 bulkscore=0 spamscore=0
 clxscore=1015 cotscore=-2147483648 suspectscore=1 lowpriorityscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190184
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Remove the __io_uring_peek_cqe() call from io_uring_wait_cqe_nr()
since the former is unconditionally called from io_uring_wait_cqe_nr()
-> __io_uring_get_cqe(). Also move __io_uring_get_cqe() together with
__io_uring_get_cqe() since that's now the only caller.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 src/include/liburing.h | 32 --------------------------------
 src/queue.c            | 27 +++++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 32 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index dd85f7b..4311325 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -444,32 +444,6 @@ static inline unsigned io_uring_cq_ready(struct io_uring *ring)
 	return io_uring_smp_load_acquire(ring->cq.ktail) - *ring->cq.khead;
 }
 
-static int __io_uring_peek_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_ptr)
-{
-	struct io_uring_cqe *cqe;
-	unsigned head;
-	int err = 0;
-
-	do {
-		io_uring_for_each_cqe(ring, head, cqe)
-			break;
-		if (cqe) {
-			if (cqe->user_data == LIBURING_UDATA_TIMEOUT) {
-				if (cqe->res < 0)
-					err = cqe->res;
-				io_uring_cq_advance(ring, 1);
-				if (!err)
-					continue;
-				cqe = NULL;
-			}
-		}
-		break;
-	} while (1);
-
-	*cqe_ptr = cqe;
-	return err;
-}
-
 /*
  * Return an IO completion, waiting for 'wait_nr' completions if one isn't
  * readily available. Returns 0 with cqe_ptr filled in on success, -errno on
@@ -479,12 +453,6 @@ static inline int io_uring_wait_cqe_nr(struct io_uring *ring,
 				      struct io_uring_cqe **cqe_ptr,
 				      unsigned wait_nr)
 {
-	int err;
-
-	err = __io_uring_peek_cqe(ring, cqe_ptr);
-	if (err || *cqe_ptr)
-		return err;
-
 	return __io_uring_get_cqe(ring, cqe_ptr, 0, wait_nr, NULL);
 }
 
diff --git a/src/queue.c b/src/queue.c
index da2f405..3db52bd 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -32,6 +32,33 @@ static inline bool sq_ring_needs_enter(struct io_uring *ring,
 	return false;
 }
 
+static int __io_uring_peek_cqe(struct io_uring *ring,
+			       struct io_uring_cqe **cqe_ptr)
+{
+	struct io_uring_cqe *cqe;
+	unsigned head;
+	int err = 0;
+
+	do {
+		io_uring_for_each_cqe(ring, head, cqe)
+			break;
+		if (cqe) {
+			if (cqe->user_data == LIBURING_UDATA_TIMEOUT) {
+				if (cqe->res < 0)
+					err = cqe->res;
+				io_uring_cq_advance(ring, 1);
+				if (!err)
+					continue;
+				cqe = NULL;
+			}
+		}
+		break;
+	} while (1);
+
+	*cqe_ptr = cqe;
+	return err;
+}
+
 int __io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_ptr,
 		       unsigned submit, unsigned wait_nr, sigset_t *sigmask)
 {
-- 
1.8.3.1

