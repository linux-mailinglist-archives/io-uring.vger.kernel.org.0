Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48FE5214EB2
	for <lists+io-uring@lfdr.de>; Sun,  5 Jul 2020 20:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbgGESwd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Jul 2020 14:52:33 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:31898 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727950AbgGESwc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Jul 2020 14:52:32 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200705185228epoutp026bbb629499a32d09ab2c9b624ba97ee1~e7-Pb7php3204432044epoutp02D
        for <io-uring@vger.kernel.org>; Sun,  5 Jul 2020 18:52:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200705185228epoutp026bbb629499a32d09ab2c9b624ba97ee1~e7-Pb7php3204432044epoutp02D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593975148;
        bh=EDeoKzff2L3XGHadZi/OIFUby3HIdjDpDQcs/wY5K7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h0vCiK0vfynf7uS3gvJlWms2MQeu8M+FS+SHtQUQvyafvenqgHCZAmcoXOB9EryHX
         g0o5FTw/BJ7ecm3vKmE8M4/PLFDnUakZZZlR21BhHKAegbJkXAPA2JAB+aQEXA90bi
         /Uwb6T6y989qhkukq4YITiC1rW6ouyz7ApWmsyOk=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20200705185228epcas5p4d63536fb4ff71ca1a9d91322c2aec8b2~e7-O7A85D1418914189epcas5p4D;
        Sun,  5 Jul 2020 18:52:28 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D5.C7.09703.C61220F5; Mon,  6 Jul 2020 03:52:28 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20200705185227epcas5p16fba3cb92561794b960184c89fdf2bb7~e7-OS5KwJ2311023110epcas5p1E;
        Sun,  5 Jul 2020 18:52:27 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200705185227epsmtrp1958b2733946f97338ab9ed5a3835c095~e7-OSHD770303903039epsmtrp1_;
        Sun,  5 Jul 2020 18:52:27 +0000 (GMT)
X-AuditID: b6c32a4a-4b5ff700000025e7-54-5f02216c3ddb
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        4D.37.08303.B61220F5; Mon,  6 Jul 2020 03:52:27 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200705185224epsmtip27b31b5b2d629a5e08596d2873cb48d57~e7-Ln6_Kc3204432044epsmtip2i;
        Sun,  5 Jul 2020 18:52:24 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, viro@zeniv.linux.org.uk, bcrl@kvack.org
Cc:     hch@infradead.org, Damien.LeMoal@wdc.com, asml.silence@gmail.com,
        linux-fsdevel@vger.kernel.org, mb@lightnvm.io,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: [PATCH v3 4/4] io_uring: add support for zone-append
Date:   Mon,  6 Jul 2020 00:17:50 +0530
Message-Id: <1593974870-18919-5-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1593974870-18919-1-git-send-email-joshi.k@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsWy7bCmlm6OIlO8wY0OTovf06ewWsxZtY3R
        YvXdfjaLrn9bWCxa278xWZyesIjJ4l3rORaLx3c+s1sc/f+WzWLKtCZGi723tC327D3JYnF5
        1xw2ixXbj7BYbPs9n9niypRFzBavf5xkszj/9zirg5DHzll32T02r9DyuHy21GPTp0nsHt1X
        fzB69G1ZxejxeZOcR/uBbiaPTU/eMgVwRnHZpKTmZJalFunbJXBlzJm1gb1grnRFzzexBsaF
        Yl2MHBwSAiYSL9uluhi5OIQEdjNKTNmxhgXC+cQosat7IhOE85lR4uepl8xdjJxgHX1Pb7NB
        JHYBJVYdQqg6/qeTEWQum4CmxIXJpSCmiICNxM4lKiAlzALtzBIndt5hAhkkLGArce7PKnYQ
        m0VAVeLOmUlgNq+As8TGi+dZIZbJSdw81wm2mFPARaJt92lmkEESAls4JI6encYGUeQi8f7g
        OyhbWOLV8S3sELaUxMv+Nii7WOLXnaNQzR2MEtcbZrJAJOwlLu75ywRyKTPQ0et36YOEmQX4
        JHp/P2GChBGvREebEES1osS9SU+hbhOXeDhjCZTtIXGs+QLYX0IC0xkl5pwvmcAoOwth6AJG
        xlWMkqkFxbnpqcWmBUZ5qeV6xYm5xaV56XrJ+bmbGMFJSMtrB+PDBx/0DjEycTAeYpTgYFYS
        4e3VZowX4k1JrKxKLcqPLyrNSS0+xCjNwaIkzqv040yckEB6YklqdmpqQWoRTJaJg1OqgWlu
        2ZKGfwmfWq7aX3hwNUq6PntZa+npY6cPXUqJM3N12pfLZLPF8tS5ud8e7PBK+7+5eGWTyZfu
        9IU3M/Yf0NlctD027FDS44LI2MA09ik9Dx5mXvToMA6ocnZZsOHcrNscf5z2/y1blSFRW3rf
        TyExlS8v5q51+9vuq5H6GhnfD4XWuCzc5xld/kHilcpm7Ve/RL9N7zLnPX1z8/rMXfcf3u2J
        Kd48mS2qIm7RDq09XhuenHmouo7fecVl/lDLqRudDufL3zK4FPR6YZ5pdMqPy6+C/Dnion22
        dwpUK/hZHYrVtJ7x3UqZPZF14s5YayHXe9IN7SX5sx9oP1cw9xf8+WX32Qkc/+Ifdf+qtlBi
        Kc5INNRiLipOBAAT/P/DsQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsWy7bCSvG62IlO8Qe97KYvf06ewWsxZtY3R
        YvXdfjaLrn9bWCxa278xWZyesIjJ4l3rORaLx3c+s1sc/f+WzWLKtCZGi723tC327D3JYnF5
        1xw2ixXbj7BYbPs9n9niypRFzBavf5xkszj/9zirg5DHzll32T02r9DyuHy21GPTp0nsHt1X
        fzB69G1ZxejxeZOcR/uBbiaPTU/eMgVwRnHZpKTmZJalFunbJXBlzJm1gb1grnRFzzexBsaF
        Yl2MnBwSAiYSfU9vs3UxcnEICexglDiyfDcTREJcovnaD3YIW1hi5b/n7BBFHxklLky6A9TB
        wcEmoClxYXIpSI2IgINE1/HHTCA1zAJTmSV2vlvCBpIQFrCVOPdnFdggFgFViTtnJoHZvALO
        EhsvnmeFWCAncfNcJzOIzSngItG2+zQzyHwhoJqplxQnMPItYGRYxSiZWlCcm55bbFhglJda
        rlecmFtcmpeul5yfu4kRHANaWjsY96z6oHeIkYmD8RCjBAezkghvrzZjvBBvSmJlVWpRfnxR
        aU5q8SFGaQ4WJXHer7MWxgkJpCeWpGanphakFsFkmTg4pRqYavVfztGIPcy9oVLt6qZ9Mrnf
        bX27pzp3/rs8L9b/Su7V1VXMtVxqLx33Tn532udU1wNWYRXdk4nLzVrfvrly4tAq6zO+cYY+
        ebu8zmYZfWx6Wjrj+LU/3YontPXqE2vk/N60zxd5/3pPZ4u6gNfMNx9uu36p2xDucLw7psj3
        /IQ/1QYnWkrzfWz/t9jUuT5IMJY3OexyqtYi4fHW5J+WP/588a2Mfchyso9tX5rUpXS1X7Vf
        JVvW//WfO+nsfvmSxtXcLfxnvlza/6Uj2/HLZct+R57HhetaWXz+H8mtFNof9EhKd3pX2T/m
        NZ0xD39/v1LiE8WyzemW/r78yTdceOU/exy78ftaUepS611flFiKMxINtZiLihMBLkoc7vAC
        AAA=
X-CMS-MailID: 20200705185227epcas5p16fba3cb92561794b960184c89fdf2bb7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200705185227epcas5p16fba3cb92561794b960184c89fdf2bb7
References: <1593974870-18919-1-git-send-email-joshi.k@samsung.com>
        <CGME20200705185227epcas5p16fba3cb92561794b960184c89fdf2bb7@epcas5p1.samsung.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Selvakumar S <selvakuma.s1@samsung.com>

For zone-append, block-layer will return zone-relative offset via ret2
of ki_complete interface. Make changes to collect it, and send to
user-space using cqe->flags.

Signed-off-by: Selvakumar S <selvakuma.s1@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>
---
 fs/io_uring.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 155f3d8..cbde4df 100644
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
@@ -1955,6 +1962,10 @@ static void io_complete_rw_common(struct kiocb *kiocb, long res)
 		req_set_fail_links(req);
 	if (req->flags & REQ_F_BUFFER_SELECTED)
 		cflags = io_put_kbuf(req);
+	/* use cflags to return zone append completion result */
+	if (req->flags & REQ_F_ZONE_APPEND)
+		cflags = res2;
+
 	__io_cqring_add_event(req, res, cflags);
 }
 
@@ -1962,7 +1973,7 @@ static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 
-	io_complete_rw_common(kiocb, res);
+	io_complete_rw_common(kiocb, res, res2);
 	io_put_req(req);
 }
 
@@ -1975,6 +1986,9 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 
 	if (res != req->result)
 		req_set_fail_links(req);
+	if (req->flags & REQ_F_ZONE_APPEND)
+		req->rw.append_offset = res2;
+
 	req->result = res;
 	if (res != -EAGAIN)
 		WRITE_ONCE(req->iopoll_completed, 1);
@@ -2739,6 +2753,9 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)
 						SB_FREEZE_WRITE);
 		}
 		kiocb->ki_flags |= IOCB_WRITE;
+		/* zone-append requires few extra steps during completion */
+		if (kiocb->ki_flags & IOCB_ZONE_APPEND)
+			req->flags |= REQ_F_ZONE_APPEND;
 
 		if (!force_nonblock)
 			current->signal->rlim[RLIMIT_FSIZE].rlim_cur = req->fsize;
-- 
2.7.4

