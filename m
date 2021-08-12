Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1B43E9D3C
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 06:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbhHLEPN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Aug 2021 00:15:13 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:52699 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230187AbhHLEPM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Aug 2021 00:15:12 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UikT1XN_1628741676;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UikT1XN_1628741676)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 12 Aug 2021 12:14:46 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 2/3] io_uring: remove files pointer in cancellation functions
Date:   Thu, 12 Aug 2021 12:14:35 +0800
Message-Id: <20210812041436.101503-3-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20210812041436.101503-1-haoxu@linux.alibaba.com>
References: <20210812041436.101503-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When doing cancellation, we use a parameter to indicate where it's from
do_exit or exec. So a boolean value is good enough for this, remove the
struct files* as it is not necessary.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c            | 4 ++--
 include/linux/io_uring.h | 8 ++++----
 kernel/exit.c            | 2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index efd818419014..b29774aa1f09 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9205,9 +9205,9 @@ static void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 	}
 }
 
-void __io_uring_cancel(struct files_struct *files)
+void __io_uring_cancel(bool cancel_all)
 {
-	io_uring_cancel_generic(!files, NULL);
+	io_uring_cancel_generic(cancel_all, NULL);
 }
 
 static void *io_uring_validate_mmap_request(struct file *file,
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index ed13304e764c..2b42f9c012fb 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -7,18 +7,18 @@
 
 #if defined(CONFIG_IO_URING)
 struct sock *io_uring_get_socket(struct file *file);
-void __io_uring_cancel(struct files_struct *files);
+void __io_uring_cancel(bool cancel_all);
 void __io_uring_free(struct task_struct *tsk);
 
-static inline void io_uring_files_cancel(struct files_struct *files)
+static inline void io_uring_files_cancel(void)
 {
 	if (current->io_uring)
-		__io_uring_cancel(files);
+		__io_uring_cancel(false);
 }
 static inline void io_uring_task_cancel(void)
 {
 	if (current->io_uring)
-		__io_uring_cancel(NULL);
+		__io_uring_cancel(true);
 }
 static inline void io_uring_free(struct task_struct *tsk)
 {
diff --git a/kernel/exit.c b/kernel/exit.c
index 9a89e7f36acb..91a43e57a32e 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -777,7 +777,7 @@ void __noreturn do_exit(long code)
 		schedule();
 	}
 
-	io_uring_files_cancel(tsk->files);
+	io_uring_files_cancel();
 	exit_signals(tsk);  /* sets PF_EXITING */
 
 	/* sync mm's RSS info before statistics gathering */
-- 
2.24.4

