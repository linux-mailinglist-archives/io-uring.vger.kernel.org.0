Return-Path: <io-uring+bounces-191-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D6B78000C3
	for <lists+io-uring@lfdr.de>; Fri,  1 Dec 2023 02:00:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20A2D28165B
	for <lists+io-uring@lfdr.de>; Fri,  1 Dec 2023 01:00:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B7E81842;
	Fri,  1 Dec 2023 01:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cB56Bzi1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1373B1984;
	Thu, 30 Nov 2023 16:59:32 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-a195e0145acso89024266b.2;
        Thu, 30 Nov 2023 16:59:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701392371; x=1701997171; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GaNHncYiyyTzToiDSMP5RgHvu4Yg0JcV9JIBEbeRs3w=;
        b=cB56Bzi1V3+mOtdlzfgLyMm+KePmdHEqOqlrMQHozfuqlD3KetZ3FfsKxL3Tm7090u
         8onNI+RfIZpMgGO3V1j+NH+wd/5nmvYpXEAlEbBll2soPVwweQ5jizZXi+8G0YlslWhI
         I/anyyOlQwBAgxmTni7ngTP5KmTTUli2mTqXz5mAPdvEmU7Qio27c6aos4KeR7SBwQIv
         xNSRhBE2vjeM9IPWpyZtW6Hdh0hJrbW8c0cTooCHXwj78M0hczzRci/rz8D9G67eKU6k
         e3m/HaMBLj0sJy2NBAhuSW5HoHxO2C1MTmxDJIVhvARrKCEzpbrKVrpO1QVklWNgZsrZ
         LADA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701392371; x=1701997171;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GaNHncYiyyTzToiDSMP5RgHvu4Yg0JcV9JIBEbeRs3w=;
        b=quHE1Q9tKmoIfZj2Mw+MfiVDueP5iNBIxT3nHJp7m/pXJKm8DdT5+Iocc9zIZf6DVD
         NcW595h/3fv9bddGs5nPzJ749e/bI8Mi0tPC6hPupPu0ChZXdEQ9T3LHMBnzSZzUkVuA
         oma3TP+dTlHVpCsQU8RVJTOT9ej75+fSR4phFcgG5+iN1wuIObsBwl2+xDeuMJin5s9C
         zJ1/LwTxYPrY4F5hXg3aGVytCgRu5I45CCKYPFXucvcMg6fzHftJ5kYbImpjufiB7tBa
         06xc7oYflktXhrcCeuEv6qDOFiVkP/WjU/SdFRfQAvz95TcdGRxnhtRhn69mSNeCNQaI
         Sb2Q==
X-Gm-Message-State: AOJu0Yz59k1kzbFAKhIqrMAC/ek1VamS+MYKTvev7dQjHC1XXxEDHLvA
	cnVVCSCnHEf7WigBXffVd/w5arFkoEc=
X-Google-Smtp-Source: AGHT+IHN18Vie6HATw1PPPFt85dTXvpNpLdDv8JYGa3XhqgiNXCHSB4oCF2jeberpNqKNzZam8ywzw==
X-Received: by 2002:a17:906:6cc:b0:a10:f087:ba43 with SMTP id v12-20020a17090606cc00b00a10f087ba43mr155845ejb.43.1701392371096;
        Thu, 30 Nov 2023 16:59:31 -0800 (PST)
Received: from 127.0.0.1localhost ([185.69.145.191])
        by smtp.gmail.com with ESMTPSA id ks19-20020a170906f85300b00a11b2677acbsm1250511ejb.163.2023.11.30.16.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 16:59:30 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	linux-block@vger.kernel.org,
	ming.lei@redhat.com,
	joshi.k@samsung.com,
	linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH v2 3/3] io_uring/cmd: inline io_uring_cmd_get_task
Date: Fri,  1 Dec 2023 00:57:37 +0000
Message-ID: <aa8e317f09e651a5f3e72f8c0ad3902084c1f930.1701391955.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1701391955.git.asml.silence@gmail.com>
References: <cover.1701391955.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With io_uring_types.h we see all required definitions to inline
io_uring_cmd_get_task().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring/cmd.h | 10 +++++-----
 io_uring/uring_cmd.c         |  6 ------
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index ee9b3bc3a4af..d69b4038aa3e 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -39,7 +39,6 @@ void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
 
 void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
 		unsigned int issue_flags);
-struct task_struct *io_uring_cmd_get_task(struct io_uring_cmd *cmd);
 
 #else
 static inline int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
@@ -60,10 +59,6 @@ static inline void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
 		unsigned int issue_flags)
 {
 }
-static inline struct task_struct *io_uring_cmd_get_task(struct io_uring_cmd *cmd)
-{
-	return NULL;
-}
 #endif
 
 /* users must follow the IOU_F_TWQ_LAZY_WAKE semantics */
@@ -79,4 +74,9 @@ static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
 	__io_uring_cmd_do_in_task(ioucmd, task_work_cb, 0);
 }
 
+static inline struct task_struct *io_uring_cmd_get_task(struct io_uring_cmd *cmd)
+{
+	return cmd_to_io_kiocb(cmd)->task;
+}
+
 #endif /* _LINUX_IO_URING_CMD_H */
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 94e9de1c24aa..34030583b9b2 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -52,12 +52,6 @@ void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_mark_cancelable);
 
-struct task_struct *io_uring_cmd_get_task(struct io_uring_cmd *cmd)
-{
-	return cmd_to_io_kiocb(cmd)->task;
-}
-EXPORT_SYMBOL_GPL(io_uring_cmd_get_task);
-
 static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *ts)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
-- 
2.43.0


