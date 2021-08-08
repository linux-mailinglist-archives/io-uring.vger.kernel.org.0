Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216DE3E37A6
	for <lists+io-uring@lfdr.de>; Sun,  8 Aug 2021 02:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbhHHAOy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 Aug 2021 20:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbhHHAOx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 Aug 2021 20:14:53 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF65BC061760;
        Sat,  7 Aug 2021 17:14:35 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id u21-20020a17090a8915b02901782c36f543so19589951pjn.4;
        Sat, 07 Aug 2021 17:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q7xelSKQIVAAeT9cO6b5gPD0TRf5dv3ql90j043ZjZo=;
        b=HRWmWAJ6m11oPVYyXf/HahqhiC53dyZ/NUVYjKpN9BD3QxGBaJ/10f0TbUC3iwoMww
         CduT0T26acUz3ieCfuWODuyzA0ucCJaHsAkP21VKXJX0kB2X2ddWUpTl5oaEtTu0EAWA
         KrJpUpcOvuJhoiqrXiIsnLTbmH6cOCAJQIK8/99GNArBOX8o8meS0DJPyO7w7P+jXraN
         EGfYYjR01QltDkrKE7ziLbx3O4uhlmR0yo+5UvNs/UuQFQxZkS2rTUcHNTIwbqQhaQFd
         hHtsIxP1p36+cddXeYTB4g+U/OEEepYZQ5NBJMFQt7xGcZjcOkXvsHNZLy5rUeyRIQPS
         bLAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q7xelSKQIVAAeT9cO6b5gPD0TRf5dv3ql90j043ZjZo=;
        b=nDmDgk5tyvqhxTwTN90gjTzzkzFnEE+jPpFd3iKuzjBmCo8qXK9jAwzcJH/FyFihvh
         ob5hy4oZgmWbdKlKW3Wv9LlCgS4olfVsLCBZBPUhM7tianN/vPmNQdS7LTUNOkgz5pdG
         lUD20lDkgwruaOQMHkRP1yLi1sL/EtoIfL9881m/2nXdAH3SJywdlnsSJyDrTQyGOYJB
         vLzRdqGvpdVp8cLCwQaNAO+9kfqqPhpT9K9bBCI353CqcMpTNvgWBIm73Nc2tlk5TbGs
         JUaKjzWzyczxISXJDjJQiJRBwoUWKv9lKhYxGY+wafc0WVYGTzNs/PfbTTDcGXvicGLJ
         RhhA==
X-Gm-Message-State: AOAM533Fe3B66Hi9rmxSKwmcuv5LF67USupQ9/uEla4y8iU+3wmxmXjW
        7qrciMvso39j/arKMf9eFI7hfCCKQ7PaYw==
X-Google-Smtp-Source: ABdhPJxz6NBfXB/qB3VpX9QVRYs/tT+Df3SUy1w4jd4MvdZUe31CoO+UiP97ikuk1p7fASumUZFOdA==
X-Received: by 2002:a17:90a:c286:: with SMTP id f6mr28517925pjt.121.1628381675283;
        Sat, 07 Aug 2021 17:14:35 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id u3sm16624278pjr.2.2021.08.07.17.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Aug 2021 17:14:34 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@vmware.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 1/2] io_uring: clear TIF_NOTIFY_SIGNAL when running task work
Date:   Sat,  7 Aug 2021 17:13:41 -0700
Message-Id: <20210808001342.964634-2-namit@vmware.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210808001342.964634-1-namit@vmware.com>
References: <20210808001342.964634-1-namit@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

When using SQPOLL, the submission queue polling thread calls
task_work_run() to run queued work. However, when work is added with
TWA_SIGNAL - as done by io_uring itself - the TIF_NOTIFY_SIGNAL remains
set afterwards and is never cleared.

Consequently, when the submission queue polling thread checks whether
signal_pending(), it may always find a pending signal, if
task_work_add() was ever called before.

The impact of this bug might be different on different kernel versions.
It appears that on 5.14 it would only cause unnecessary calculation and
prevent the polling thread from sleeping. On 5.13, where the bug was
found, it stops the polling thread from finding newly submitted work.

Instead of task_work_run(), use tracehook_notify_signal() that clears
TIF_NOTIFY_SIGNAL. Test for TIF_NOTIFY_SIGNAL in addition to
current->task_works to avoid a race in which task_works is cleared but
the TIF_NOTIFY_SIGNAL is set.

Fixes: 685fe7feedb96 ("io-wq: eliminate the need for a manager thread")
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Nadav Amit <namit@vmware.com>
---
 fs/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5a0fd6bcd318..f39244d35f90 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -78,6 +78,7 @@
 #include <linux/task_work.h>
 #include <linux/pagemap.h>
 #include <linux/io_uring.h>
+#include <linux/tracehook.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -2203,9 +2204,9 @@ static inline unsigned int io_put_rw_kbuf(struct io_kiocb *req)
 
 static inline bool io_run_task_work(void)
 {
-	if (current->task_works) {
+	if (test_thread_flag(TIF_NOTIFY_SIGNAL) || current->task_works) {
 		__set_current_state(TASK_RUNNING);
-		task_work_run();
+		tracehook_notify_signal();
 		return true;
 	}
 
-- 
2.25.1

