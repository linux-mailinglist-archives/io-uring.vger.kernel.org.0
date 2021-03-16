Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02FE833D55D
	for <lists+io-uring@lfdr.de>; Tue, 16 Mar 2021 15:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234491AbhCPOC5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Mar 2021 10:02:57 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:17486 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235797AbhCPOCh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Mar 2021 10:02:37 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210316140235epoutp0416aad8829f6e7ed50c044abf8408846e~s14pO6SCw1376213762epoutp04J
        for <io-uring@vger.kernel.org>; Tue, 16 Mar 2021 14:02:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210316140235epoutp0416aad8829f6e7ed50c044abf8408846e~s14pO6SCw1376213762epoutp04J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1615903355;
        bh=RH3gCxootWicOI2ffETEmG9ADDpmT1h729M2N9hS73g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bib85te245WjY3E+3T3Kfp5AFT/inBK5kCgXKdGhFhdrgc73iIwnZu67jg+gncxd+
         kX6ne97sMqAry4Q+ZuIYbiKlNBhR+ZTWoDWDXtgAMEXuqu/ZDqnWsqe8nlFdG6fjOF
         5MtpQgprSgT46jYmNVQxD5KNgoXdYzgTYIMXj6Ig=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20210316140234epcas5p222b34ffe8258a818f184c057ae662d33~s14oliaVT3056830568epcas5p2u;
        Tue, 16 Mar 2021 14:02:34 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        CA.6D.33964.A7AB0506; Tue, 16 Mar 2021 23:02:34 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20210316140233epcas5p372405e7cb302c61dba5e1094fa796513~s14nsPRxm0793407934epcas5p3F;
        Tue, 16 Mar 2021 14:02:33 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210316140233epsmtrp131a97636be1fe48740d3526dd16423c4~s14nrcWj50307603076epsmtrp1Y;
        Tue, 16 Mar 2021 14:02:33 +0000 (GMT)
X-AuditID: b6c32a4b-ea1ff700000184ac-82-6050ba7a7c93
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        2E.54.08745.97AB0506; Tue, 16 Mar 2021 23:02:33 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210316140231epsmtip29784637b602a3c3fc10515d3c7e97354~s14l2f3Ce1114911149epsmtip2d;
        Tue, 16 Mar 2021 14:02:31 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        chaitanya.kulkarni@wdc.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        anuj20.g@samsung.com, javier.gonz@samsung.com,
        nj.shetty@samsung.com, selvakuma.s1@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [RFC PATCH v3 1/3] io_uring: add helper for uring_cmd completion in
 submitter-task
Date:   Tue, 16 Mar 2021 19:31:24 +0530
Message-Id: <20210316140126.24900-2-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210316140126.24900-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsWy7bCmum7VroAEg4/H5C2aJvxltlh9t5/N
        Ytbt1ywWK1cfZbJ413qOxeLxnc/sFkf/v2WzmHToGqPF/GVP2S22/Z7PbHFlyiJmi9c/TrI5
        8HhcPlvqsWlVJ5vH5iX1HrtvNrB59G1ZxejxeZOcR/uBbqYA9igum5TUnMyy1CJ9uwSujFvv
        57MWXJCqaP98gLGBcaJYFyMnh4SAicSdS7cYuxi5OIQEdjNKzNi1ixXC+cQoce7xDjYI5zOj
        xK6+d8wwLdtW90JV7WKU+H3yOjtc1c8734AcDg42AU2JC5NLQRpEBAIkdh38zARiMwscZZR4
        tLIaxBYWiJXo/jINLM4ioCrx7MpUVhCbV8BC4uycqewQy+QlZl76DmZzClhK7NvbwwZRIyhx
        cuYTFoiZ8hLNW2czg9wgITCTQ+Jk234WiGYXiQvPVrFB2MISr45vgRoqJfGyvw3KLpb4deco
        VHMHo8T1hplQzfYSF/f8ZQJ5hhnomfW79CGW8Un0/n4CFpYQ4JXoaBOCqFaUuDfpKSuELS7x
        cMYSKNtDYtGzw0yQ8OlhlLg/5yvLBEb5WUh+mIXkh1kI2xYwMq9ilEwtKM5NTy02LTDOSy3X
        K07MLS7NS9dLzs/dxAhOTlreOxgfPfigd4iRiYPxEKMEB7OSCK9pXkCCEG9KYmVValF+fFFp
        TmrxIUZpDhYlcd4dBg/ihQTSE0tSs1NTC1KLYLJMHJxSDUy8llVNocWlZ4MDxfTWcDzUc9Rb
        ebBGQpP5VuVty+6IPqXH9T80/lr9WTh5+vbDCyy+xFUu33vE+v+/A4Gb/R/y3SiUfaLqs6Ix
        7U1x/7Tf6qX3Plqn5025oKEZUr1zyQtzXZ81uzVCdylE+4ip1nx7tVV06eqmHQYLPzJ/b4ng
        W+f4iOX69/PzJuzcyVBx+sDES0/3GLFsuLHtdkzIrTvuWoZRPjHlZj2dD8OPtLEZ5T58xOrV
        0zx/Y1XUhT+PTad4K5bM+souIFjd7/0rs23RomkcC2csYDh3ycJuhYDS5+dzHaPj2NS5qr/a
        RNeeE7kks1h63txtIut7p1T/vfbJ6fjdh+nxJY/W9n6bMP+6EktxRqKhFnNRcSIAlM72070D
        AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsWy7bCSvG7lroAEg2VbpCyaJvxltlh9t5/N
        Ytbt1ywWK1cfZbJ413qOxeLxnc/sFkf/v2WzmHToGqPF/GVP2S22/Z7PbHFlyiJmi9c/TrI5
        8HhcPlvqsWlVJ5vH5iX1HrtvNrB59G1ZxejxeZOcR/uBbqYA9igum5TUnMyy1CJ9uwSujFvv
        57MWXJCqaP98gLGBcaJYFyMnh4SAicS21b2sXYxcHEICOxglHryYzwaREJdovvaDHcIWllj5
        7zk7RNFHRok9HVeAHA4ONgFNiQuTS0FqRARCJLrmbWMCqWEWOMsosfxxOyNIQlggWqL32A4m
        EJtFQFXi2ZWprCA2r4CFxNk5U6EWyEvMvPQdzOYUsJTYt7cH7AghoJrpJy+xQdQLSpyc+YQF
        xGYGqm/eOpt5AqPALCSpWUhSCxiZVjFKphYU56bnFhsWGOWllusVJ+YWl+al6yXn525iBEeG
        ltYOxj2rPugdYmTiYDzEKMHBrCTCa5oXkCDEm5JYWZValB9fVJqTWnyIUZqDRUmc90LXyXgh
        gfTEktTs1NSC1CKYLBMHp1QDk3Br6INeZ0NWH/E1K2aXVL7Ui06Oiru99v3nn69WByxpqNNU
        jz/xJmvqPHHDVXIf1z2sUjxRH8z59Itj09u90j/EJtVtTtz9coYwr8kq/RN5z1vvvjx98P+K
        x+cuOxyeMzE7afqENq2JlxJEb2bcyjHeO6G/YKl10b2DKyZfMcn/c+K6nOCyvevi68Jn3u9s
        q5apM/5e9FDq7Vz9JX/DWbLneOvbbWKcs1to5b1rL2ZMbMqSjheLMZt1P9rowj3eHob5AZy7
        ba+n+B5vzD2ilLJrfwlvQ+ziXtmKWi3Vt0lTEyYvNd+gsILB67aCe/rf7iL/SJXTjX1H4lMZ
        IsMy1jz6aRhR933bUzvL8rWsAUosxRmJhlrMRcWJALJNdHr7AgAA
X-CMS-MailID: 20210316140233epcas5p372405e7cb302c61dba5e1094fa796513
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20210316140233epcas5p372405e7cb302c61dba5e1094fa796513
References: <20210316140126.24900-1-joshi.k@samsung.com>
        <CGME20210316140233epcas5p372405e7cb302c61dba5e1094fa796513@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Completion of a uring_cmd ioctl may involve referencing certain
ioctl-specific fields, requiring original subitter context.
Introduce 'uring_cmd_complete_in_task' that driver can use for this
purpose. The API facilitates task-work infra, while driver gets to
implement cmd-specific handling in a callback.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 fs/io_uring.c            | 36 ++++++++++++++++++++++++++++++++----
 include/linux/io_uring.h |  8 ++++++++
 2 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 583f8fd735d8..ca459ea9cb83 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -772,9 +772,12 @@ struct io_kiocb {
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
@@ -1716,7 +1719,7 @@ static void io_dismantle_req(struct io_kiocb *req)
 {
 	io_clean_op(req);
 
-	if (req->async_data)
+	if (io_op_defs[req->opcode].async_size && req->async_data)
 		kfree(req->async_data);
 	if (req->file)
 		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
@@ -2032,6 +2035,31 @@ static void io_req_task_submit(struct callback_head *cb)
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
+EXPORT_SYMBOL(uring_cmd_complete_in_task);
+
 static void io_req_task_queue(struct io_kiocb *req)
 {
 	int ret;
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index e0a31354eff1..559f41d0f19a 100644
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

