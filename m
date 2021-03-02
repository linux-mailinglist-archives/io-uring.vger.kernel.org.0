Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA93432B551
	for <lists+io-uring@lfdr.de>; Wed,  3 Mar 2021 07:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346647AbhCCGoG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 01:44:06 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:57767 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1836035AbhCBTgU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Mar 2021 14:36:20 -0500
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210302161002epoutp0373b6411b8ab8bbfe42adc851759422e5~okl7krl2U0956509565epoutp03E
        for <io-uring@vger.kernel.org>; Tue,  2 Mar 2021 16:10:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210302161002epoutp0373b6411b8ab8bbfe42adc851759422e5~okl7krl2U0956509565epoutp03E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1614701402;
        bh=zJAu+4AnrLTTfRdnWiFSMH7omT70gsIqx7Jptlap+8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AGPi4mna1vtkRp0zF4MgmUpk5djFEKs9TgMyc36Hk4tkz3jeUPwsQr0wPpYXclImr
         csX9VPQKJy7ERMpI3apzywpdoxaYaNrORo0x8NjlMxy+lzzt8DAQtc2UkjCLuGXGH7
         LDWpiM6S28dFZwLx4GFemDYKd4tha1PMzC9fJiWE=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20210302161001epcas5p372100b9f4499916f98caed549d2c6f85~okl6mIb731145211452epcas5p3_;
        Tue,  2 Mar 2021 16:10:01 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        32.E2.15682.9536E306; Wed,  3 Mar 2021 01:10:01 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20210302161000epcas5p3ec5c461a8eec593b6d83a9127c7fec4f~okl5s9nLE1145211452epcas5p39;
        Tue,  2 Mar 2021 16:10:00 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210302161000epsmtrp1aadd0570132ebffaeaa3aed807f4fe80~okl5sLnla2256522565epsmtrp1h;
        Tue,  2 Mar 2021 16:10:00 +0000 (GMT)
X-AuditID: b6c32a49-8bfff70000013d42-77-603e63594d4a
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        CD.0D.13470.8536E306; Wed,  3 Mar 2021 01:10:00 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210302160959epsmtip16b625f52691ef82c2dab28c2e7963b82~okl4R3kKj1249612496epsmtip1L;
        Tue,  2 Mar 2021 16:09:59 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        anuj20.g@samsung.com, javier.gonz@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [RFC 1/3] io_uring: add helper for uring_cmd completion in
 submitter-task
Date:   Tue,  2 Mar 2021 21:37:32 +0530
Message-Id: <20210302160734.99610-2-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210302160734.99610-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0hTYRjG+XbOzs5Wi+OSfFumOag0mNPIOIXdoGJaYYYFCaFjHtby2o7r
        SrSShtpSUdO27CbllbK8lDVXOVlhpdmFzLBYZJl5qVQylHU57UT993u/93m+h+fjIzFZiVBO
        6tMyGUOaJkVBSPDrbSHByu3alYlhU5MB9NECD0bXvs4n6Opal4AeOdaJ0+96x0S06+cwQRc6
        XyD6XMV7Ef28uBxbLVY/6zCq62tyCHXDxcNqe4+JUOc11iD1WH3AZiJeEpnEpOj3MAbVykTJ
        zkH3Y1HGuP8+c9aEwISyIBeJSaCWQElPHZGLJKSMsiO4Of4ZeYdRBK7G+yLv8A1BS5Vd9Ndy
        9XM2r3IgqPrRxPvHELz8OIHnIpIkqBDoKjJyBl9qMdwZbRdyGowqRtD5pE3ALWZScXDhereQ
        Y5yaD27HIOJYStFQaWvFvGmBYH06IeLuFFPL4JVjgVfiA+3WPpxj7Lckq+k0xt0PlEcEZW/v
        8d61kNdv43kmfLrfyDeQw0C+mWcWJntdvDkbQbfJinsXq+BJi0fABWO/y9TdUnnDZsCJqb4/
        x0BJIdss86qD4E3he6GX/eDtqYs8q6Hu1Tj/ihYEx2/bsQIUaPuvg+2/DrZ/aecRVoNmMxls
        qo5hIzLC05i9oawmlTWm6UK16an16M/XWRTVjF67v4Q6kYBETgQkpvCV+g2sSJRJkzT7DzCG
        9ASDMYVhnWgOiSv8pM1h7gQZpdNkMskMk8EY/m4FpFhuEsQVDUQQ6a2rzSaPLKsjAA25HnSU
        rH+qD7oxK/pkQrN/vtOhzIz/+n1w2rTYYd9bSVEhu8ilcZGlX4ZCdUFTnbLpu6vYDV2JL049
        DJfrUvGXwneFRywWm7IoZJ1gx2RnQk3xpraqex/zyrZMn/SJXufZ2H9ZMle7cZ7qof70ofm0
        3GjpfTBSHpMSowB18LXsA5eD5y5/LlnTVReF2am2g3qfCLFrNOdxbnLyYPldH23Jkeqv7Ij7
        bIvrQ9DJ1iR/rHJfteNbgzmnzI/RVioLrP13N5eekceM5u8utFSgrUM3KlQN0Wc+KZ8N46Lw
        2NIr3QsDt1mJwMieeapeZ9+jSwqc3akJX4QZWM0vdo6Gj6kDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsWy7bCSnG5Esl2CwfbZshZNE/4yW6y+289m
        sXL1USaLd63nWCwe3/nMbnH0/1s2i0mHrjFazF/2lN3iypRFzA6cHpfPlnpsWtXJ5rF5Sb3H
        7psNbB59W1YxenzeJBfAFsVlk5Kak1mWWqRvl8CV8frBefaCLzIVbc3fmRoYmyW6GDk5JARM
        JDa872DsYuTiEBLYzSjRcWoGK0RCXKL52g92CFtYYuW/5+wQRR8ZJWau/M7UxcjBwSagKXFh
        cilIjYiAmcTSw2tYQGxmgRmMEhuWpYOUCAsESXyZqQISZhFQlXiw9zUjiM0rYCGxfNZBZojx
        8hIzL31nBynnFLCUuLVXDSQsBFQyed1/VohyQYmTM59ATZeXaN46m3kCo8AsJKlZSFILGJlW
        MUqmFhTnpucWGxYY5qWW6xUn5haX5qXrJefnbmIEh7qW5g7G7as+6B1iZOJgPMQowcGsJMIr
        /tI2QYg3JbGyKrUoP76oNCe1+BCjNAeLkjjvha6T8UIC6YklqdmpqQWpRTBZJg5OqQamXcv3
        +BhNfv1fdaPBp0tODpKr5G/cy00LlO9NDJVjX33K+9WpXN0FGSHSO7cpiplOE32+tnQTu7FR
        3Clt78sFfDrZbb/rPt5bX7wq7NTRbVNyZluJu1Y/mdbP2v/jA9dH0U9TFh3JuXbn8JF7B/Ju
        sbmu7fRkP/Ga1/halQ33CtapqSethVtKy2NPXGG4sG/2Jhl7pkrNXyWbvUJt/v9Z0iv93o6Z
        YZrB7uTIP8zFGZmMa0RXTFnw5kFf7MzXcVM2FV1p6BSMZH5SwVfL05L4ZkUYz3nDT8If7La8
        /cFTNo+hZM1PocPLHphc33M2v7HlsfqR8KrTf01mP9ZoKnC2fVig+UzzgcunBA2/sz7zlFiK
        MxINtZiLihMBTfZtY+QCAAA=
X-CMS-MailID: 20210302161000epcas5p3ec5c461a8eec593b6d83a9127c7fec4f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20210302161000epcas5p3ec5c461a8eec593b6d83a9127c7fec4f
References: <20210302160734.99610-1-joshi.k@samsung.com>
        <CGME20210302161000epcas5p3ec5c461a8eec593b6d83a9127c7fec4f@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Completion of a uring_cmd ioctl may involve referencing certain
ioctl-specific fields, requiring original submitter context.
Introduce 'uring_cmd_complete_in_task' that driver can use for this
purpose. The API facilitates task-work infra, while driver gets to
implement cmd-specific handling in a callback.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 fs/io_uring.c            | 37 +++++++++++++++++++++++++++++++++----
 include/linux/io_uring.h |  8 ++++++++
 2 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 116ac0f179e0..d4ed1326b9f1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -775,9 +775,12 @@ struct io_kiocb {
 		/* use only after cleaning per-op data, see io_clean_op() */
 		struct io_completion	compl;
 	};
-
-	/* opcode allocated if it needs to store data for async defer */
-	void				*async_data;
+	union {
+		/* opcode allocated if it needs to store data for async defer */
+		void				*async_data;
+		/* used for uring-cmd, when driver needs to update in task */
+		void (*driver_cb)(struct io_uring_cmd *cmd);
+	};
 	u8				opcode;
 	/* polled IO has completed */
 	u8				iopoll_completed;
@@ -1719,7 +1722,7 @@ static void io_dismantle_req(struct io_kiocb *req)
 {
 	io_clean_op(req);
 
-	if (req->async_data)
+	if (io_op_defs[req->opcode].async_size && req->async_data)
 		kfree(req->async_data);
 	if (req->file)
 		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
@@ -2035,6 +2038,31 @@ static void io_req_task_submit(struct callback_head *cb)
 	__io_req_task_submit(req);
 }
 
+static void uring_cmd_work(struct callback_head *cb)
+{
+	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
+	struct io_uring_cmd *cmd = &req->uring_cmd;
+
+	req->driver_cb(cmd);
+}
+int uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
+			void (*driver_cb)(struct io_uring_cmd *))
+{
+	int ret;
+	struct io_kiocb *req = container_of(ioucmd, struct io_kiocb, uring_cmd);
+
+	req->driver_cb = driver_cb;
+	req->task_work.func = uring_cmd_work;
+	ret = io_req_task_work_add(req);
+	if (unlikely(ret)) {
+		req->result = -ECANCELED;
+		percpu_ref_get(&req->ctx->refs);
+		io_req_task_work_add_fallback(req, io_req_task_cancel);
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(uring_cmd_complete_in_task);
+
 static void io_req_task_queue(struct io_kiocb *req)
 {
 	int ret;
@@ -3537,6 +3565,7 @@ void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret)
 		req_set_fail_links(req);
 	io_req_complete(req, ret);
 }
+EXPORT_SYMBOL_GPL(io_uring_cmd_done);
 
 static int io_uring_cmd_prep(struct io_kiocb *req,
 			     const struct io_uring_sqe *sqe)
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 5849b15334b8..dba8f0b3da9f 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -41,6 +41,8 @@ struct io_uring_cmd {
 
 #if defined(CONFIG_IO_URING)
 void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret);
+int uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
+			void (*driver_cb)(struct io_uring_cmd *));
 struct sock *io_uring_get_socket(struct file *file);
 void __io_uring_task_cancel(void);
 void __io_uring_files_cancel(struct files_struct *files);
@@ -65,6 +67,12 @@ static inline void io_uring_free(struct task_struct *tsk)
 static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret)
 {
 }
+
+int uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
+			void (*driver_cb)(struct io_uring_cmd *))
+{
+	return -1;
+}
 static inline struct sock *io_uring_get_socket(struct file *file)
 {
 	return NULL;
-- 
2.25.1

