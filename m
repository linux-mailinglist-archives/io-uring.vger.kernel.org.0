Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F25223E4E3
	for <lists+io-uring@lfdr.de>; Fri,  7 Aug 2020 01:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbgHFX5d (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Aug 2020 19:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgHFX5d (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Aug 2020 19:57:33 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 150CCC061574
        for <io-uring@vger.kernel.org>; Thu,  6 Aug 2020 16:57:33 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id k18so24342pfp.7
        for <io-uring@vger.kernel.org>; Thu, 06 Aug 2020 16:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=3CrmlIxVhpMLcMWr7s4rLEupo3OLqktKvK0T2ee7Y6w=;
        b=Y1g5H+1gDX7MIdTyZvNV75d/eZ6nH/LORHgZBdZaf0D7xoLUrh0E3mNmTIwedr54/T
         R+uQoBkGFJ3yFdz4+B25wy/fUBQ/FOJMOFh/i2NT5bF+9OL6rn6yHOEagcOSmVUW1BmP
         IL+3dVynP2C9xR9PAb9a1fxOygfPRbbST61Yy4FBI31+/v/LNvGp4ystdugM1ntFCsRn
         bV0Gzv7t3tVvYV+lAf10uyrXc3ldlgzikUw3xIBUlnnrDQ5vNVTkZwZCQyr+1wBfUoLs
         gWbpGhM3I0M0nTSC6zEMiBs4M3AMY9qZimacyy8YHiT2FYQddcXgLF9VoE/q28ERBsTw
         HyIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=3CrmlIxVhpMLcMWr7s4rLEupo3OLqktKvK0T2ee7Y6w=;
        b=IkNY4ddkEvytZxj7gw9rFsC8MUHkp7NTPilvpZxt9rbbj0RETBmFafxEbjUFIxBhYn
         lJKF56hIBzwaypmIV2YejTiC6R4kx1BdxEm/ZirvyAjX/jLFdj0NimiEqyLSHuMJqGDn
         xqEaiqaP9zeQRcS2oTUq/qVj6mRgeeNU+wzrDyQBN3kkDrSXd+3xOEwnXdOPSpKn7QJq
         amCuOOF6fC0jU8jWsPBIt9RxE/3gy+xrK6WvrBaBmVJtO4D/TIHqElwCUtPQp+1a5tFT
         HrkZ9yoNavOlJIiAFovz0BigfaA+IREj8JtWv74HRVPPOznUd0793oB7xfF1ibArIujX
         YwOg==
X-Gm-Message-State: AOAM533BE/SF4EcorpocWP4wu4k9XIZIk5ZU9R2Be6dg97HIwrD3MafI
        P1zOPCiNDqeVzXz8szOUIEdWRVOpckA=
X-Google-Smtp-Source: ABdhPJw2aeBasaZqxW1W5KttQKuHFtZzh+Ci198APlYF2bW1UEBbVVp7F0cG/KvDt+hE2WtW/922vQ==
X-Received: by 2002:a63:5a59:: with SMTP id k25mr2980291pgm.116.1596758252019;
        Thu, 06 Aug 2020 16:57:32 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id t19sm9962471pfq.179.2020.08.06.16.57.31
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2020 16:57:31 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: use TWA_SIGNAL for task_work related to eventfd
Message-ID: <d6e647c8-5448-e496-10c0-3c319b0f4a03@kernel.dk>
Date:   Thu, 6 Aug 2020 17:57:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

An earlier commit:

b7db41c9e03b ("io_uring: fix regression with always ignoring signals in io_cqring_wait()")

ensured that we didn't get stuck waiting for eventfd reads when it's
registered with the io_uring ring for event notification, but that didn't
cover the general case of waiting on eventfd and having that dependency
between io_uring and eventfd.

Ensure that we use signaled notification for anything related to eventfd.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/eventfd.c b/fs/eventfd.c
index df466ef81ddd..4eb7ae838f61 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -321,7 +321,7 @@ static void eventfd_show_fdinfo(struct seq_file *m, struct file *f)
 }
 #endif
 
-static const struct file_operations eventfd_fops = {
+const struct file_operations eventfd_fops = {
 #ifdef CONFIG_PROC_FS
 	.show_fdinfo	= eventfd_show_fdinfo,
 #endif
diff --git a/fs/io_uring.c b/fs/io_uring.c
index e9b27cdaa735..c76062be9c4c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1720,7 +1720,7 @@ static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb)
 	 */
 	if (ctx->flags & IORING_SETUP_SQPOLL)
 		notify = 0;
-	else if (ctx->cq_ev_fd)
+	else if (ctx->cq_ev_fd || (req->file && eventfd_file(req->file)))
 		notify = TWA_SIGNAL;
 
 	ret = task_work_add(tsk, cb, notify);
diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index dc4fd8a6644d..2e5eeb3a813c 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -14,6 +14,7 @@
 #include <linux/err.h>
 #include <linux/percpu-defs.h>
 #include <linux/percpu.h>
+#include <linux/fs.h>
 
 /*
  * CAREFUL: Check include/uapi/asm-generic/fcntl.h when defining
@@ -49,6 +50,13 @@ static inline bool eventfd_signal_count(void)
 	return this_cpu_read(eventfd_wake_count);
 }
 
+extern const struct file_operations eventfd_fops;
+
+static inline bool evenfd_file(struct file *file)
+{
+	return file->f_op == &eventfd_fops;
+}
+
 #else /* CONFIG_EVENTFD */
 
 /*
@@ -82,6 +90,11 @@ static inline bool eventfd_signal_count(void)
 	return false;
 }
 
+static inline bool eventfd_file(struct file *file)
+{
+	return false;
+}
+
 #endif
 
 #endif /* _LINUX_EVENTFD_H */

-- 
Jens Axboe

