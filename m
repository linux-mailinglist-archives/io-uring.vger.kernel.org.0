Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCD2735F19F
	for <lists+io-uring@lfdr.de>; Wed, 14 Apr 2021 12:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233742AbhDNKse (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Apr 2021 06:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233163AbhDNKsd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Apr 2021 06:48:33 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6FF7C061756
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 03:48:12 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id 12so19423927wrz.7
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 03:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=VI1fw/7EK9qWyY0VWzJLFtkCSBonMMUYXtzaKXPeiKA=;
        b=ieiGAYMRXERBfzofXjPeQS7hZ1R0EYtiKOC3IcZrALTW45mPjD9xsbECfqxEfb+Z/r
         p4ookxyuNv3fnYrAas7pKEnf6AqF+pkHXvSc4mCWNQh1V7va4qe3vM/sSBHJrT/8EqKJ
         0u/Z28tKwh4M3dtStHzqj0Bt0AP4nFJCXPat5WVUNQG1Lb30pEMb2bO58VR3Aqm+znGz
         ZEL0woOYuFMaXlNItcSRPc2LxsJugWIiUifeh8NwS6kwNp6zelDAUfQinwHl8h5W8Iga
         3TKmWvjq8+7GkZWlOZ9wzE2fccqzN7S4GivMX4XDWarJ54ysmX+lWUKlm3AR2KRCXloe
         6y1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VI1fw/7EK9qWyY0VWzJLFtkCSBonMMUYXtzaKXPeiKA=;
        b=IBVa7osWgtLZC+f7v/l8YdL2op2cTcDH4YzVU+CQmML8xFlXLEO8Wwu7d1C3fDtxK2
         94sKhdaTHn7cuW2HEVa0ZrE34FJegy/kYrdOxcO3KBuNjZjhZidYoXdiwNdK6qtpbOwO
         5GOgAKdqNpBP9L9SbstunKqTLZbzQQi1q9eP6QwKg76s1+mNBE+ZMpqDX6Hau6t0GSh/
         tcgXRK5+ZCokZX2W9w4Rno+iaHkEgwjc5PyLRdPz4X759S3oQQBZJzOg5iHjvT36sYpd
         J/r5BtUT4lnfiaQp5zbvKgVYDsys4ADEeLK6+N6ja/tRE8aaAFHVvJmp9LNZDo2kG0NL
         PX5Q==
X-Gm-Message-State: AOAM532M6zKHF0e/+uVgiXV0Z6yu3fItV9OPOZ85y/XW+cUSFL0GgSkc
        fRyja1MXFmZjD1ynxZmKm9c=
X-Google-Smtp-Source: ABdhPJz+HbWVOKKDB3ZcT0zhKHn0MJZe2cQTsl0KRnWTAUihWcfjLpTZwWozUYButqDI0KPjSZNAeg==
X-Received: by 2002:a5d:6607:: with SMTP id n7mr33375170wru.146.1618397291466;
        Wed, 14 Apr 2021 03:48:11 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.163])
        by smtp.gmail.com with ESMTPSA id n14sm5003002wmk.5.2021.04.14.03.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 03:48:11 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/5] io_uring: refactor io_ring_exit_work()
Date:   Wed, 14 Apr 2021 11:43:51 +0100
Message-Id: <8042ff02416ca0ced8305c30417b635c59ac570a.1618396838.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1618396838.git.asml.silence@gmail.com>
References: <cover.1618396838.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't reinit io_ring_exit_work()'s exit work/completions on each
iteration, that's wasteful. Also add list_rotate_left(), so if we failed
to complete the task job, we don't try it again and again but defer it
until others are processed.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 693fb5c5e58c..6a70bf455c49 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8601,6 +8601,9 @@ static void io_ring_exit_work(struct work_struct *work)
 		WARN_ON_ONCE(time_after(jiffies, timeout));
 	} while (!wait_for_completion_timeout(&ctx->ref_comp, HZ/20));
 
+	init_completion(&exit.completion);
+	init_task_work(&exit.task_work, io_tctx_exit_cb);
+	exit.ctx = ctx;
 	/*
 	 * Some may use context even when all refs and requests have been put,
 	 * and they are free to do so while still holding uring_lock or
@@ -8613,9 +8616,8 @@ static void io_ring_exit_work(struct work_struct *work)
 
 		node = list_first_entry(&ctx->tctx_list, struct io_tctx_node,
 					ctx_node);
-		exit.ctx = ctx;
-		init_completion(&exit.completion);
-		init_task_work(&exit.task_work, io_tctx_exit_cb);
+		/* don't spin on a single task if cancellation failed */
+		list_rotate_left(&ctx->tctx_list);
 		ret = task_work_add(node->task, &exit.task_work, TWA_SIGNAL);
 		if (WARN_ON_ONCE(ret))
 			continue;
@@ -8623,7 +8625,6 @@ static void io_ring_exit_work(struct work_struct *work)
 
 		mutex_unlock(&ctx->uring_lock);
 		wait_for_completion(&exit.completion);
-		cond_resched();
 		mutex_lock(&ctx->uring_lock);
 	}
 	mutex_unlock(&ctx->uring_lock);
-- 
2.24.0

