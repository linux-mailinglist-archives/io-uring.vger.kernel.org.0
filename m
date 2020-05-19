Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF781DA420
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2020 23:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbgESVxA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 May 2020 17:53:00 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47420 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgESVw7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 May 2020 17:52:59 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04JLpVH5142615;
        Tue, 19 May 2020 21:52:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=mZi+uiJeYJv500UiMWcRJxlZaVrp5CSzWarmLuLj4Js=;
 b=0DmfXHI4VvS/S4i6SqSfi0gjxsHd4zie7R1o4EywaiEcloNuSl3jgcwwvyi8ThrMcZU1
 TskygfQt5RsiNbCEDMlrHAbHoY/7FWEOoMGcD16VNj0You3kuw2Xjwr4/DMq011Wcok8
 M5jDG9fDtI3Rcbg9cE+HaMHSA6EASQ1Z823mKW+5ElEbjbnVyAx+k/ErnlyEH3wnakVL
 52im/Och1Ggwpc0HdDyuPkzKU/VED45nM8/L4bJVEEPRZoRDypZpmjbjir69h1ANfdhW
 3XtnTUKxmcgHlBLDQk29w0FoMI82JRcx+5bZhR8we8FwHCAMlmmm6bIsC5eZGxOAYc01 Gw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 3128tnfwpk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 May 2020 21:52:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04JLqQMS020232;
        Tue, 19 May 2020 21:52:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 314gm5vp2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 May 2020 21:52:57 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04JLquRQ005850;
        Tue, 19 May 2020 21:52:56 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 14:52:56 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [RFC 1/2] io_uring: don't use kiocb.private to store buf_index
Date:   Tue, 19 May 2020 14:52:49 -0700
Message-Id: <1589925170-48687-2-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1589925170-48687-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1589925170-48687-1-git-send-email-bijan.mottahedeh@oracle.com>
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

kiocb.private is used in iomap_dio_rw() so store buf_index separately.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7a17418..9596859 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -401,6 +401,7 @@ struct io_rw {
 	struct kiocb			kiocb;
 	u64				addr;
 	u64				len;
+	u16				buf_index;
 };
 
 struct io_connect {
@@ -2122,9 +2123,7 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 	req->rw.addr = READ_ONCE(sqe->addr);
 	req->rw.len = READ_ONCE(sqe->len);
-	/* we own ->private, reuse it for the buffer index  / buffer ID */
-	req->rw.kiocb.private = (void *) (unsigned long)
-					READ_ONCE(sqe->buf_index);
+	req->rw.buf_index = READ_ONCE(sqe->buf_index);
 	return 0;
 }
 
@@ -2167,7 +2166,7 @@ static ssize_t io_import_fixed(struct io_kiocb *req, int rw,
 	struct io_ring_ctx *ctx = req->ctx;
 	size_t len = req->rw.len;
 	struct io_mapped_ubuf *imu;
-	unsigned index, buf_index;
+	u16 index, buf_index;
 	size_t offset;
 	u64 buf_addr;
 
@@ -2175,7 +2174,7 @@ static ssize_t io_import_fixed(struct io_kiocb *req, int rw,
 	if (unlikely(!ctx->user_bufs))
 		return -EFAULT;
 
-	buf_index = (unsigned long) req->rw.kiocb.private;
+	buf_index = req->rw.buf_index;
 	if (unlikely(buf_index >= ctx->nr_user_bufs))
 		return -EFAULT;
 
@@ -2291,10 +2290,10 @@ static void __user *io_rw_buffer_select(struct io_kiocb *req, size_t *len,
 					bool needs_lock)
 {
 	struct io_buffer *kbuf;
-	int bgid;
+	u16 bgid;
 
 	kbuf = (struct io_buffer *) (unsigned long) req->rw.addr;
-	bgid = (int) (unsigned long) req->rw.kiocb.private;
+	bgid = req->rw.buf_index;
 	kbuf = io_buffer_select(req, len, bgid, kbuf, needs_lock);
 	if (IS_ERR(kbuf))
 		return kbuf;
@@ -2385,7 +2384,7 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 	}
 
 	/* buffer index only valid with fixed read/write, or buffer select  */
-	if (req->rw.kiocb.private && !(req->flags & REQ_F_BUFFER_SELECT))
+	if (req->rw.buf_index && !(req->flags & REQ_F_BUFFER_SELECT))
 		return -EINVAL;
 
 	if (opcode == IORING_OP_READ || opcode == IORING_OP_WRITE) {
-- 
1.8.3.1

