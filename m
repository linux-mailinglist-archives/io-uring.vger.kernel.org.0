Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55466702D42
	for <lists+io-uring@lfdr.de>; Mon, 15 May 2023 14:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241918AbjEOM6G (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 May 2023 08:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242087AbjEOM5v (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 May 2023 08:57:51 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5451BD8;
        Mon, 15 May 2023 05:57:40 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-96a2b6de3cbso1066625866b.1;
        Mon, 15 May 2023 05:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684155459; x=1686747459;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MBnj2lFa+PB4bOPosEwzuAw3ZW4WfbS6upUcJq1uNTI=;
        b=JsNN5O2Ztvssh2QEpi9nbfl/t9Sn3wkwVm3DmD2Z12g9RFC+Hkr7AQPTrknfPKL7RI
         iAvvhEIyzfD/UWYOlTyVzaeVZLlnBJxLtGwqN73pfKqDlVVXZPebFEoxd1ddUpDInV3q
         CXFhjKNEhDRcwisQ3p8TZyZGk1QnfW1RRaxqi7kolzEqR2yvKd4uvh5YgjoE30hJTPch
         Dd+qUMrHnWHEZS9fpjt5gO4JUrJHms5G6tQpzUVEgmmMPrH8hE1liHC8NZ0lFL1Agu/n
         thH7plw9sbTROyM2NnHspOU9UKqYmGRv1uRroxP1GCtTsaMv5xsBhv+g7QbyfWdD4ux1
         7bzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684155459; x=1686747459;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MBnj2lFa+PB4bOPosEwzuAw3ZW4WfbS6upUcJq1uNTI=;
        b=ETPxSxgg7P6WSKhnErWQVf5T+Ib1MA1ATOq5oIdgJr96vIj+KPCwsolaIhVHHXf+nC
         hNkXN6Wjt0WmkZP4FYhz5d4hwbHPQnZo7c+MtHEkavMU/uI8jfjoYwqUOQmgHSluNMni
         0LlmC53r/EKomPG7UBSgmkrP5xDE29CuUugyeRLW1W2a5cVZXnzMPQmeP4XkNWvXcMr0
         w8Nr/I7uuiBNgrC5GvIej7/7vz+KlrzKPgfcV8qGu6dvRRAyGn081xpjzwU94bU63xez
         EbYgqiSMUNsmEdgsR+h5sIA448nWzPhbeemcelhTOfNhwdZJG45/qsxh2qI126DOzHfb
         Vx8g==
X-Gm-Message-State: AC+VfDwyAv3R4fde1+bioRd9AxCu9r6rA3QDm4iaDcY63rVdPNeSN2r5
        ZB0/F/mSHzhcN4rDiPNcX0Y=
X-Google-Smtp-Source: ACHHUZ4Tu3v8GwHhl2ppjKrwpi6gObiB3V9WdWreNVleJpQ6F0XBMVo3hvhxBZLu7ZUQ++IdKXq2gw==
X-Received: by 2002:a17:907:c26:b0:966:238a:c93 with SMTP id ga38-20020a1709070c2600b00966238a0c93mr30248914ejc.68.1684155458787;
        Mon, 15 May 2023 05:57:38 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:6366])
        by smtp.gmail.com with ESMTPSA id m13-20020a17090672cd00b0096ace7ae086sm4003685ejl.174.2023.05.15.05.57.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 May 2023 05:57:38 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, axboe@kernel.dk
Cc:     kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        joshi.k@samsung.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH for-next 1/2] io_uring/cmd: add cmd lazy tw wake helper
Date:   Mon, 15 May 2023 13:54:42 +0100
Message-Id: <5b9f6716006df7e817f18bd555aee2f8f9c8b0c3.1684154817.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1684154817.git.asml.silence@gmail.com>
References: <cover.1684154817.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We want to use IOU_F_TWQ_LAZY_WAKE in commands. First, introduce a new
cmd tw helper accepting TWQ flags, and then add
io_uring_cmd_do_in_task_laz() that will pass IOU_F_TWQ_LAZY_WAKE and
imply the "lazy" semantics, i.e. it posts no more than 1 CQE and
delaying execution of this tw should not prevent forward progress.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring.h | 18 ++++++++++++++++--
 io_uring/uring_cmd.c     | 16 ++++++++++++----
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 7fe31b2cd02f..bb9c666bd584 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -46,13 +46,23 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter, void *ioucmd);
 void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2,
 			unsigned issue_flags);
-void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
-			void (*task_work_cb)(struct io_uring_cmd *, unsigned));
 struct sock *io_uring_get_socket(struct file *file);
 void __io_uring_cancel(bool cancel_all);
 void __io_uring_free(struct task_struct *tsk);
 void io_uring_unreg_ringfd(void);
 const char *io_uring_get_opcode(u8 opcode);
+void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
+			    void (*task_work_cb)(struct io_uring_cmd *, unsigned),
+			    unsigned flags);
+/* users should follow semantics of IOU_F_TWQ_LAZY_WAKE */
+void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
+			void (*task_work_cb)(struct io_uring_cmd *, unsigned));
+
+static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
+			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
+{
+	__io_uring_cmd_do_in_task(ioucmd, task_work_cb, 0);
+}
 
 static inline void io_uring_files_cancel(void)
 {
@@ -85,6 +95,10 @@ static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
 			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
 {
 }
+static inline void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
+			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
+{
+}
 static inline struct sock *io_uring_get_socket(struct file *file)
 {
 	return NULL;
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 5e32db48696d..476c7877ce58 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -20,16 +20,24 @@ static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *ts)
 	ioucmd->task_work_cb(ioucmd, issue_flags);
 }
 
-void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
-			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
+void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
+			void (*task_work_cb)(struct io_uring_cmd *, unsigned),
+			unsigned flags)
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
 
 	ioucmd->task_work_cb = task_work_cb;
 	req->io_task_work.func = io_uring_cmd_work;
-	io_req_task_work_add(req);
+	__io_req_task_work_add(req, flags);
+}
+EXPORT_SYMBOL_GPL(__io_uring_cmd_do_in_task);
+
+void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
+			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
+{
+	__io_uring_cmd_do_in_task(ioucmd, task_work_cb, IOU_F_TWQ_LAZY_WAKE);
 }
-EXPORT_SYMBOL_GPL(io_uring_cmd_complete_in_task);
+EXPORT_SYMBOL_GPL(io_uring_cmd_do_in_task_lazy);
 
 static inline void io_req_set_cqe32_extra(struct io_kiocb *req,
 					  u64 extra1, u64 extra2)
-- 
2.40.0

