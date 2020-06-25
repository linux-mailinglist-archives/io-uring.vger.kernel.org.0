Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E17A20A3DE
	for <lists+io-uring@lfdr.de>; Thu, 25 Jun 2020 19:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406729AbgFYRSq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Jun 2020 13:18:46 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:38671 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406640AbgFYRSp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Jun 2020 13:18:45 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200625171841epoutp031a70c555cc6302dc7ba93710dd09df35~b2QgCDG2n1397513975epoutp03e
        for <io-uring@vger.kernel.org>; Thu, 25 Jun 2020 17:18:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200625171841epoutp031a70c555cc6302dc7ba93710dd09df35~b2QgCDG2n1397513975epoutp03e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593105521;
        bh=HQ3oW5/y/qIsAd2fPg9vdYDB3D3VLLAhMflX2Yb0t+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TUEHGmmPNroX/tjbmiAffrwjXaIasd4rGN6XqzhCYPKIr55/zZN7IbQ8D8CATi3QW
         MvToDZ2/zoYn82ru0B8RgVDUdliHs0MXpAid+1wp+GpOHSCkenU/H7yaAzhQYZN4p4
         9vInzb1gJV4gKAicxeG8NfM5OO5LKJbHE0eCeWVo=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200625171840epcas5p3174975f291cba500e7a66006fa08b72d~b2QevPGXa2161421614epcas5p3W;
        Thu, 25 Jun 2020 17:18:40 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B4.AA.09703.07CD4FE5; Fri, 26 Jun 2020 02:18:40 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20200625171838epcas5p449183e12770187142d8d55a9bf422a8d~b2QdfKmNw2789327893epcas5p4F;
        Thu, 25 Jun 2020 17:18:38 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200625171838epsmtrp1931ab9d87e36f85f6419629057796c65~b2QdeXyeQ1577615776epsmtrp1J;
        Thu, 25 Jun 2020 17:18:38 +0000 (GMT)
X-AuditID: b6c32a4a-4cbff700000025e7-ec-5ef4dc70d9f4
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        AC.1A.08303.E6CD4FE5; Fri, 26 Jun 2020 02:18:38 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200625171836epsmtip24aad812c1b8b4d3aaf07072aa0407e22~b2Qa-iYUC1929119291epsmtip2d;
        Thu, 25 Jun 2020 17:18:36 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, viro@zeniv.linux.org.uk, bcrl@kvack.org
Cc:     asml.silence@gmail.com, Damien.LeMoal@wdc.com, hch@infradead.org,
        linux-fsdevel@vger.kernel.org, mb@lightnvm.io,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        selvakuma.s1@samsung.com, nj.shetty@samsung.com,
        javier.gonz@samsung.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v2 2/2] io_uring: add support for zone-append
Date:   Thu, 25 Jun 2020 22:45:49 +0530
Message-Id: <1593105349-19270-3-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1593105349-19270-1-git-send-email-joshi.k@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA0WSe1BMYRjGfeecPXtqZs1xLPvJ1ExLTBkht89MyBTOMGZcSjKKxZlldFl7
        5LJFCau2SUkIIWnIZmpkFbuVLiqXSCRqWqORbZSKrViadTl2jf9+7/s+z/O+881H4cwlkRu1
        M3oPp45WRMpJV6K01nvqdFXHUMTMnEoKjZzNEqEcfSlAheZ0Eul+Ggh07PhXDD3JyMNQ/7Fn
        BHrfMShGdb/6SJR1JgmgivZpqLziEYFeGnNIVFD2gEClI5dx1JKVh6Ne2yMSNdkbRAEMe++8
        WczeLvBhXz6NZUusmWI29ZUNsCcMesAOlniwx6tSMbakqw9b7bLR1X87F7lzL6eesWiL646L
        aZ6qW5776z61kokgZaIOuFCQngPfHL1E6IArxdAmAKvOGJ2FFcDs4geYoGLoQQCvvJ/3z2HN
        GSEdIiOAFnMS7ij+iJ5oa0U6QFEk7Q2fn4oVUEr7w3v5kwUJTrdgsDv7gkgIGksvhNcz8wiB
        CdoLfn/ciwssoQNhVVmGyLHMA7Y9S8GFHBc6CJZ2iIUcSBso2HO9nnBogmB96mHcwWNhT4NB
        7GA3+DFd62Qe/uiowx3mZABfJ55zmhfD5nI7JizA/9xcbJwhtHF6NEwb6frbhrQEJmsZh9oT
        vs384DxNBjuz853Mwl9FZuebnAWwdyBbnAHcz/9PzQVADyZwKj5KyfFzVX7R3D5fXhHFx0Yr
        fbfFRJWAv1/IZ8Vd0Pnus28NwChQAyCFy6WS4GXWCEayXXFAw6ljNqtjIzm+BkykCLlMIrc1
        RjC0UrGH28VxKk79b4pRLm6JmNQrjBkOsV8L+BY4DxUlPwwPtUji7perQhf8CN9in+Z98LRS
        pukTb9Xq4m+Gdd3ptqTMxxpPtI83bkhrdQ+mK9zHfCisjLnhW7auyJw7petImEYfNdv7wLpv
        NWsyErhdH1u7l+rzr20LGbbvHb87Ic6zKUy6KeDk0MBq05LGpY8Lq5OG/CaZXo0z9LYvM7NT
        Xt9cqRmj+mIi408GrtJPCr+qic8dVT1gObe85UVe8aGY9U3rgxZNXzv/YP/3Av2EBVNNjFI6
        PPN02xoPc2B9XJDMr9bWw4dQzZG5A4YW/5AL6ar+TGsoUXtrVXdwX3Pllc6s4c0ig42W9Vja
        qhMatMVWOcHvUMzywdW84jfS0QhMsQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsWy7bCSvG7enS9xBlOfalv8nj6F1WLOqm2M
        Fqvv9rNZdP3bwmLR2v6NyeL0hEVMFu9az7FYPL7zmd3i6P+3bBZTpjUxWuy9pW2xZ+9JFovL
        u+awWazYfoTFYtvv+cwWV6YsYrZ4/eMkm8X5v8dZHYQ8ds66y+6xeYWWx+WzpR6bPk1i9+i+
        +oPRo2/LKkaPz5vkPNoPdDN5bHrylimAM4rLJiU1J7MstUjfLoErY26vYsFGxYqjb66xNTB2
        SncxcnJICJhIfJrzm62LkYtDSGAHo8TU9oUsEAlxieZrP9ghbGGJlf+es0MUfWSU+HJtJpDD
        wcEmoClxYXIpSI2IgINE1/HHTCA1zAJPmCQ6v21kBEkIC9hKLJ+0CGwoi4CqxM9Tr5lBbF4B
        Z4kD2yewQiyQk7h5rpMZZCangIvEtjtg44WASk4/VZjAyLeAkWEVo2RqQXFuem6xYYFRXmq5
        XnFibnFpXrpecn7uJkZwBGhp7WDcs+qD3iFGJg7GQ4wSHMxKIrwhbp/ihHhTEiurUovy44tK
        c1KLDzFKc7AoifN+nbUwTkggPbEkNTs1tSC1CCbLxMEp1cA0rZN33/M4I74NEkfOqT00zLju
        8is0c/+VoDNBS30nBkRU9FodZS21Wte06v405QWbyy9terpFcUJYYBG7Q81DpQWTre92xn/L
        n7DN8e7qY3e8nJtUDAPOMn6+wHKysHPyDkMG5em2bLdPRf5k+3O7OebFqc+RVbenMBsncLdU
        KJ3qfJ2c07b0+rPiCtXzW9iyjO4lbGntuvHcaM3pq+W8JyJmO9btcpPV29Sxpu21bf2tmT/i
        eH8YRRh78vxP5FENFTj9IGo738UdL+NESwzkN9/nM7p8d+vbk8uXC+xYOF3uU5uVEte/PSfl
        rueyv1yraMxkrLDkxYneKtbDWy6/eNAyL0/WgS/n/PU372eaKrEUZyQaajEXFScCAA0hLezv
        AgAA
X-CMS-MailID: 20200625171838epcas5p449183e12770187142d8d55a9bf422a8d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200625171838epcas5p449183e12770187142d8d55a9bf422a8d
References: <1593105349-19270-1-git-send-email-joshi.k@samsung.com>
        <CGME20200625171838epcas5p449183e12770187142d8d55a9bf422a8d@epcas5p4.samsung.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Selvakumar S <selvakuma.s1@samsung.com>

For zone-append, block-layer will return zone-relative offset via ret2
of ki_complete interface. Make changes to collect it, and send to
user-space using ceq->flags.
Detect and report early error if zone-append is requested with
fixed-buffers.

Signed-off-by: Selvakumar S <selvakuma.s1@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>
---
 fs/io_uring.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 155f3d8..31a9da58 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -402,6 +402,8 @@ struct io_rw {
 	struct kiocb			kiocb;
 	u64				addr;
 	u64				len;
+	/* zone-relative offset for append, in sectors */
+	u32			append_offset;
 };
 
 struct io_connect {
@@ -541,6 +543,7 @@ enum {
 	REQ_F_NO_FILE_TABLE_BIT,
 	REQ_F_QUEUE_TIMEOUT_BIT,
 	REQ_F_WORK_INITIALIZED_BIT,
+	REQ_F_ZONE_APPEND_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -598,6 +601,8 @@ enum {
 	REQ_F_QUEUE_TIMEOUT	= BIT(REQ_F_QUEUE_TIMEOUT_BIT),
 	/* io_wq_work is initialized */
 	REQ_F_WORK_INITIALIZED	= BIT(REQ_F_WORK_INITIALIZED_BIT),
+	/* to return zone relative offset for zone append*/
+	REQ_F_ZONE_APPEND	= BIT(REQ_F_ZONE_APPEND_BIT),
 };
 
 struct async_poll {
@@ -1745,6 +1750,8 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 
 		if (req->flags & REQ_F_BUFFER_SELECTED)
 			cflags = io_put_kbuf(req);
+		if (req->flags & REQ_F_ZONE_APPEND)
+			cflags = req->rw.append_offset;
 
 		__io_cqring_fill_event(req, req->result, cflags);
 		(*nr_events)++;
@@ -1943,7 +1950,7 @@ static inline void req_set_fail_links(struct io_kiocb *req)
 		req->flags |= REQ_F_FAIL_LINK;
 }
 
-static void io_complete_rw_common(struct kiocb *kiocb, long res)
+static void io_complete_rw_common(struct kiocb *kiocb, long res, long res2)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 	int cflags = 0;
@@ -1953,8 +1960,14 @@ static void io_complete_rw_common(struct kiocb *kiocb, long res)
 
 	if (res != req->result)
 		req_set_fail_links(req);
+
 	if (req->flags & REQ_F_BUFFER_SELECTED)
 		cflags = io_put_kbuf(req);
+
+	/* use cflags to return zone append completion result */
+	if (req->flags & REQ_F_ZONE_APPEND)
+		cflags = res2;
+
 	__io_cqring_add_event(req, res, cflags);
 }
 
@@ -1962,7 +1975,7 @@ static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 
-	io_complete_rw_common(kiocb, res);
+	io_complete_rw_common(kiocb, res, res2);
 	io_put_req(req);
 }
 
@@ -1975,6 +1988,9 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 
 	if (res != req->result)
 		req_set_fail_links(req);
+	if (req->flags & REQ_F_ZONE_APPEND)
+		req->rw.append_offset = res2;
+
 	req->result = res;
 	if (res != -EAGAIN)
 		WRITE_ONCE(req->iopoll_completed, 1);
@@ -2127,6 +2143,9 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (kiocb->ki_flags & IOCB_NOWAIT)
 		req->flags |= REQ_F_NOWAIT;
 
+	if (kiocb->ki_flags & IOCB_ZONE_APPEND)
+		req->flags |= REQ_F_ZONE_APPEND;
+
 	if (force_nonblock)
 		kiocb->ki_flags |= IOCB_NOWAIT;
 
@@ -2409,6 +2428,14 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 
 	opcode = req->opcode;
 	if (opcode == IORING_OP_READ_FIXED || opcode == IORING_OP_WRITE_FIXED) {
+		/*
+		 * fixed-buffers not supported for zone-append.
+		 * This check can be removed when block-layer starts
+		 * supporting append with iov_iter of bvec type
+		 */
+		if (req->flags == REQ_F_ZONE_APPEND)
+			return -EINVAL;
+
 		*iovec = NULL;
 		return io_import_fixed(req, rw, iter);
 	}
@@ -2704,6 +2731,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)
 		req->rw.kiocb.ki_flags &= ~IOCB_NOWAIT;
 
 	req->result = 0;
+
 	io_size = ret;
 	if (req->flags & REQ_F_LINK_HEAD)
 		req->result = io_size;
-- 
2.7.4

