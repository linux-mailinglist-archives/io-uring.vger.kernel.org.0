Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 802CD11EA74
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2019 19:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728796AbfLMSgp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Dec 2019 13:36:45 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:43348 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728829AbfLMSgo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Dec 2019 13:36:44 -0500
Received: by mail-io1-f65.google.com with SMTP id s2so602167iog.10
        for <io-uring@vger.kernel.org>; Fri, 13 Dec 2019 10:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Tbz2/17zT8Ai2M4oM7NQjrHb28uKPQh8iT//ot5Yuj8=;
        b=dQlSeUjmRFxMuAOL1bbejpQxLslW+811/PiBruQH9rdWgyG7FuNyckf1WzFAYM9jLO
         sR1lxIsMFis5KQiwEf7lbJEw0XpLXBoIlZci9psK0ApIJqr7TKiiDtX0hzFk+NoCbaKc
         kvvrx0QPvZY+e3NYRVRhVDtD/kuTGyKYjOD7XQwwkRaRnhW9E+WgeacXBjgXXN8vjvpQ
         XMsIQ99h3NwJIauwUF2hXQVK0sfECaFfOkUWM619fqFKtFugKsMepMWwDtJg669J+cXq
         OHRHoVQXVSdjquwLCoFDNwOUEyeVvXZCIjGq5xx7YFsjOu2tdfHtP6CqWemJ4U/MEmvT
         6mgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Tbz2/17zT8Ai2M4oM7NQjrHb28uKPQh8iT//ot5Yuj8=;
        b=JegGFZUL/8TvUE9n3F8iZbX4DsQFJ6Rh+UblHaGqqopSoFNhmmuis6OO1CHspNaQBB
         +gJfBYZ6PBvG64WTVmV1BcLtDBo05M29Y7Jf1DbQnIahXmHGrJgI7ElnN9bheE272eid
         2GnQnAWR4QoI8A5aQJhuK0j22d+RXlBaGcr+T/Gn1RrANv5VaRv93jt8rXYd5Dtu2qi6
         fr+97phlwz5TuXun+KSa2FslvSNa8EeXr9YDSZ7Ui5+XjQ7HjEv3GM9JjvW8ih0nDo7A
         5nc8WNeP5ivA08gPAhlVhC7wuIBpHdYppL3tFczq2gJIRgQhEHs8WwMuteeTqYKcIut8
         nliA==
X-Gm-Message-State: APjAAAUMCdpdSbhhWs5EEISx7gLlHZgagtq2ZqqRWq81HNkV4hi0l/bx
        tgMGdyIGmsQPrxKgOINAAhnZiQTwNhNUFw==
X-Google-Smtp-Source: APXvYqyarshMIlC2UeymxFB3ePCQGFiXdNYc9VPMrMGT5VUGCSERVuQCYgjyqMcZVeCaM7feM0nvsA==
X-Received: by 2002:a6b:f80b:: with SMTP id o11mr8706198ioh.175.1576262203387;
        Fri, 13 Dec 2019 10:36:43 -0800 (PST)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id w24sm2932031ilk.4.2019.12.13.10.36.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 10:36:42 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 06/10] fs: move filp_close() outside of __close_fd_get_file()
Date:   Fri, 13 Dec 2019 11:36:28 -0700
Message-Id: <20191213183632.19441-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191213183632.19441-1-axboe@kernel.dk>
References: <20191213183632.19441-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Just one caller of this, and just use filp_close() there manually.
This is important to allow async close/removal of the fd.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 drivers/android/binder.c | 6 ++++--
 fs/file.c                | 2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index e9bc9fcc7ea5..e8b435870d6b 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2249,10 +2249,12 @@ static void binder_deferred_fd_close(int fd)
 		return;
 	init_task_work(&twcb->twork, binder_do_fd_close);
 	__close_fd_get_file(fd, &twcb->file);
-	if (twcb->file)
+	if (twcb->file) {
+		filp_close(twcb->file, current->files);
 		task_work_add(current, &twcb->twork, true);
-	else
+	} else {
 		kfree(twcb);
+	}
 }
 
 static void binder_transaction_buffer_release(struct binder_proc *proc,
diff --git a/fs/file.c b/fs/file.c
index 3da91a112bab..a250d291c71b 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -662,7 +662,7 @@ int __close_fd_get_file(unsigned int fd, struct file **res)
 	spin_unlock(&files->file_lock);
 	get_file(file);
 	*res = file;
-	return filp_close(file, files);
+	return 0;
 
 out_unlock:
 	spin_unlock(&files->file_lock);
-- 
2.24.1

