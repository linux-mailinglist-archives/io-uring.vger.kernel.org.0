Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 926B3156BBC
	for <lists+io-uring@lfdr.de>; Sun,  9 Feb 2020 18:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbgBIRMg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 9 Feb 2020 12:12:36 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35658 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727399AbgBIRMg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 9 Feb 2020 12:12:36 -0500
Received: by mail-pl1-f196.google.com with SMTP id g6so1841424plt.2
        for <io-uring@vger.kernel.org>; Sun, 09 Feb 2020 09:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LR0QGwqm/HiVwp0wNcUQoV3hgBiXj766Yw8Z8b+RQNw=;
        b=UT5NB/TrHVI2f5Ey8tD1IAJnBE+/9vczR7PjOQ/17YaPmuR/I4d6BCdf7a7wvqNfnn
         PgVfcMLaVxxNwOnb9S4MR8S1MktDWULBTbP0lR6tFkJCU6OGBn3xa/g98W8oAOizhB6/
         tIqDXF0wENhA0CQbgtJkez5oFCEqfulKTFphNavhXwk9oiYhXqpTsRADDmlP2WwLuTaA
         wmLhliKYfeSRG85wsxvchO1ziL4VTdkI3k8QZtf7UmNd0/dnkCVbFj88f+R87L+q51kp
         sQethN3ZqmqoOKkTLxhV0hWH7GxzXy1fORqdvMZUfEjqfrSuU/f4VBSNfDkiNBgl16I6
         vexg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LR0QGwqm/HiVwp0wNcUQoV3hgBiXj766Yw8Z8b+RQNw=;
        b=rxInF2k8zCNaa1Ni9SpRqQ0gFnWPEYbttde2Bu+Lg2RV5gzdvQYgNLl1nNXEZYXJDw
         mkoNqqXNyZagpaQU5hfca57O9gym9wZzZe21/1cCxh5qHp6PLMXUHdOmehwWbZxo0Iht
         fuEIHCcEzUBb+0pGL3sFVap29dINtH0AUvUWwd7i1vjcza3IVAh3oeelucRpKBZy9VbF
         Ka0KH8Kk8ymBESRrMruazFyW87sdsBGnmwkCd6i1Og+gW73fqjZoXe/z5Yh9eMdJJM4r
         QVR7ADwZlWZZkdqWqEoY3lBeb6+RKUeiWo4dXFF+r/lEHIAMxctpAdNHkhzVzaoD9TyA
         Sg1g==
X-Gm-Message-State: APjAAAVXB24BMr7so1SfaH7glhWyuzsrpYuQfgl8EATwEXzeJ91sdVwf
        kqG6pBxjCFMxhZm2GqiQQTvi8vEgPKQ=
X-Google-Smtp-Source: APXvYqwcmVTmriT7eMEVH9eSnO/A58B9ao8+S2yZmFrcRnpAoH/8xHoLHmTMvWVa1MvchnBs5ug/sw==
X-Received: by 2002:a17:90a:cf08:: with SMTP id h8mr15971183pju.81.1581268353947;
        Sun, 09 Feb 2020 09:12:33 -0800 (PST)
Received: from x1.localdomain ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id z29sm9869695pgc.21.2020.02.09.09.12.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2020 09:12:33 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring: cancel pending async work if task exits
Date:   Sun,  9 Feb 2020 10:12:23 -0700
Message-Id: <20200209171223.14422-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200209171223.14422-1-axboe@kernel.dk>
References: <20200209171223.14422-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Normally we cancel all work we track, but for untracked work we could
leave the async worker behind until that work completes. This is totally
fine, but does leave resources pending after the task is gone until that
work completes.

Cancel work that this task queued up when it goes away.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 24ebd5714bf9..bd5ac9a6677f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -925,6 +925,7 @@ static inline void io_req_work_grab_env(struct io_kiocb *req,
 		}
 		spin_unlock(&current->fs->lock);
 	}
+	req->work.task_pid = task_pid_vnr(current);
 }
 
 static inline void io_req_work_drop_env(struct io_kiocb *req)
@@ -6474,6 +6475,13 @@ static int io_uring_flush(struct file *file, void *data)
 	struct io_ring_ctx *ctx = file->private_data;
 
 	io_uring_cancel_files(ctx, data);
+
+	/*
+	 * If the task is going away, cancel work it may have pending
+	 */
+	if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
+		io_wq_cancel_pid(ctx->io_wq, task_pid_vnr(current));
+
 	return 0;
 }
 
-- 
2.25.0

