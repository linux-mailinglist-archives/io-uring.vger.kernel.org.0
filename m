Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6841832C997
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232448AbhCDBKI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 20:10:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376845AbhCDAex (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 19:34:53 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FFCC0610DF
        for <io-uring@vger.kernel.org>; Wed,  3 Mar 2021 16:27:36 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id ba1so15068885plb.1
        for <io-uring@vger.kernel.org>; Wed, 03 Mar 2021 16:27:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MdKZSFjvoMiVuG+zundoLzOc5p+vfC/oYsFrAJU6hpQ=;
        b=zyuzDN6nH/ws/lURlGaJTo6Lo8YniMB+1OwfBvH441NLSZY+QY3Jwz15gbzJdAgMBD
         Y+Xrcx6diI+WL584h2DK2etxWGd26hKbrshH7jwADnOAwda0sUV912j0IDCbCHOA3fl5
         Sd92QNRalM9MTESHseLNK/3FziG6NCiwdlwCIKzmxW8go6kMh4H1dpXDbm5X8GNfsX5A
         OK4VwcjCKRMgs43ZBJOS29z8TX+D3VXVJ5yFrdwqWbWsYXdQdi0nTMoqrA1zCEKEeB/u
         YE8ZoOA10OCbODDGxvgdydhJZjQTzQzvaVx33Q1amjO0EZ9zc+2q60WpABlPg8Xy+x2Q
         ib7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MdKZSFjvoMiVuG+zundoLzOc5p+vfC/oYsFrAJU6hpQ=;
        b=unXKiOU0fqg9oeVSuNcV+iaKRjPyC07YgUlDvl8gEmWGFWeEdFyNQIbCRsByFX4zOK
         nFdDDr5dCdC1uPGr7wLq5+n/luaCWtaDzZMihKzAzQ6JV4NZlPohIrWHnPUl7f0x44sD
         6dprUQc6IMPY/O4qZ0v5FDbVQHrNcSrUSvHZ+vYuhdSdLe0yuSB8xWLv5fiQYuckr5lR
         vi3c+vfIO3LuJGPPRHnyJ6XH7BqNwaocfI+KqbC89EFOcOyco0D4ZdS0rm5lP+v0oSxx
         Uvyezw4zdn7TsTQQkWG4wsgx1b9JZ4HJguGfqWJ/iM79T52hIua4BnO35iT6IKKPqHcv
         jnUA==
X-Gm-Message-State: AOAM530S3sqkVoliRiNE9KiSuUxRCo1e6bw0RkFptefluQuECQOI3pOX
        j57ZyvKF+2hwuI2yQU9DUCtrCfdHeWF1dtrL
X-Google-Smtp-Source: ABdhPJzcCSHmFmqJrRRWdP01DVFwRP6zySxKxWMYVujGPOvCK8g3Sh4JpOYIws2BXo2t2jtcxx0etA==
X-Received: by 2002:a17:90a:74c6:: with SMTP id p6mr1596177pjl.134.1614817655339;
        Wed, 03 Mar 2021 16:27:35 -0800 (PST)
Received: from localhost.localdomain ([2600:380:7540:52b5:3f01:150c:3b2:bf47])
        by smtp.gmail.com with ESMTPSA id b6sm23456983pgt.69.2021.03.03.16.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 16:27:35 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 25/33] io_uring: remove sqo_task
Date:   Wed,  3 Mar 2021 17:26:52 -0700
Message-Id: <20210304002700.374417-26-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304002700.374417-1-axboe@kernel.dk>
References: <20210304002700.374417-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

Now, sqo_task is used only for a warning that is not interesting anymore
since sqo_dead is gone, remove all of that including ctx->sqo_task.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index da90d877afd4..28a360aac4a3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -379,11 +379,6 @@ struct io_ring_ctx {
 
 	struct io_rings	*rings;
 
-	/*
-	 * For SQPOLL usage
-	 */
-	struct task_struct	*sqo_task;
-
 	/* Only used for accounting purposes */
 	struct mm_struct	*mm_account;
 
@@ -8747,10 +8742,6 @@ static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
 				fput(file);
 				return ret;
 			}
-
-			/* one and only SQPOLL file note, held by sqo_task */
-			WARN_ON_ONCE((ctx->flags & IORING_SETUP_SQPOLL) &&
-				     current != ctx->sqo_task);
 		}
 		tctx->last = file;
 	}
@@ -9398,7 +9389,6 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	ctx->compat = in_compat_syscall();
 	if (!capable(CAP_IPC_LOCK))
 		ctx->user = get_uid(current_user());
-	ctx->sqo_task = current;
 
 	/*
 	 * This is just grabbed for accounting purposes. When a process exits,
-- 
2.30.1

