Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41EB2155B08
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2020 16:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgBGPuq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Feb 2020 10:50:46 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:41143 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726874AbgBGPuq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Feb 2020 10:50:46 -0500
Received: by mail-il1-f195.google.com with SMTP id f10so2071058ils.8
        for <io-uring@vger.kernel.org>; Fri, 07 Feb 2020 07:50:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B0WgSOI3PFdezy1B0LSOA0pgAlsguKG2eeWCxqvj6Fc=;
        b=i71Ha+1ttLJJUaodokeBtvS5sStsXR9ZRGaeqekDcHfnYPG/9UOYfnrgCnQbyQLTHy
         gJWSFcWwXccgsBlloLod/6gHuzvk4sIuBmIu7dt1MlbITOcgp+DaPKn86NzwL2wVVQqO
         L3kkbtG3s40SEbmcwAL2CCL+fvJvIntGR9Z9E6E5NinWKEvTilyf+HmVvsysg/J3arbr
         3gAY/bmS5fPZKW0Qgogt1Bd8bhxH7qiAcRyiLLDpDxuOU4heo+dmoHjW6MgujiiK5CN7
         RKyaaGzgs9SR5nwaEKq6gVnwJroLLfUemIShNCFIIJKOa3Pv5M6kx+WYHlkz9DHMSTyU
         t28Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B0WgSOI3PFdezy1B0LSOA0pgAlsguKG2eeWCxqvj6Fc=;
        b=DClUEbOvgzkmvv/KB18EB+HUhp2bMa4Lu5anfvC+WgEI9BXgmmAnkGl8cvYzMMypdh
         I9oATHcIRHNJ2jzlvBy6yMHwwfTW3txk6Wl+YRgzRh6sdaXL/dm7RbUT6/XXCpgT67Di
         Oii+p5wbnpssPYvreAUyLJ1bWX0mTfkKqebPewzHIGr9dMTmZ+duIMZEIkPFil1bBOyG
         C8EDPpoIvDneHUT7Jm21H6i2lZl5k53yJWdZtnm7VhwBGuWSt93JP9liWnH1XI3tHq8q
         GAq0FpY2vB1sR0ag3VMOQctxj+/v5uun5gltFwbemIKftdUE9/OYYg+SyPy/TMH6+uyV
         Mnkw==
X-Gm-Message-State: APjAAAWUuJZbjaHTkvL9CIQETxi4tlkiT7qDi6xJbqhFc7a+9XETufiq
        8la7z4japuG6SSbM9DvAVMe30037XbM=
X-Google-Smtp-Source: APXvYqyH7Ej0lmWBsxecgYFr0kt6M9QR+CiJ8bJVVCZC8aC1NqAsSGyoskwcnRP170bDoiYbNn7tzg==
X-Received: by 2002:a92:7d07:: with SMTP id y7mr19412ilc.270.1581090644289;
        Fri, 07 Feb 2020 07:50:44 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r18sm978493iom.71.2020.02.07.07.50.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 07:50:43 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io_uring: grab owning task fs_struct
Date:   Fri,  7 Feb 2020 08:50:36 -0700
Message-Id: <20200207155039.12819-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200207155039.12819-1-axboe@kernel.dk>
References: <20200207155039.12819-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We need this for work that operates on relative paths.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ba97bb433922..da6a5998fa30 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -75,6 +75,7 @@
 #include <linux/fsnotify.h>
 #include <linux/fadvise.h>
 #include <linux/eventpoll.h>
+#include <linux/fs_struct.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -264,6 +265,8 @@ struct io_ring_ctx {
 
 	const struct cred	*creds;
 
+	struct fs_struct	*fs;
+
 	/* 0 is for ctx quiesce/reinit/free, 1 is for sqo_thread started */
 	struct completion	*completions;
 
@@ -6261,6 +6264,16 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	if (ctx->account_mem)
 		io_unaccount_mem(ctx->user,
 				ring_pages(ctx->sq_entries, ctx->cq_entries));
+	if (ctx->fs) {
+		struct fs_struct *fs = ctx->fs;
+
+		spin_lock(&ctx->fs->lock);
+		if (--fs->users)
+			fs = NULL;
+		spin_unlock(&ctx->fs->lock);
+		if (fs)
+			free_fs_struct(fs);
+	}
 	free_uid(ctx->user);
 	put_cred(ctx->creds);
 	kfree(ctx->completions);
@@ -6768,6 +6781,13 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p)
 	ctx->user = user;
 	ctx->creds = get_current_cred();
 
+	task_lock(current);
+	spin_lock(&current->fs->lock);
+	ctx->fs = current->fs;
+	ctx->fs->users++;
+	spin_unlock(&current->fs->lock);
+	task_unlock(current);
+
 	ret = io_allocate_scq_urings(ctx, p);
 	if (ret)
 		goto err;
-- 
2.25.0

