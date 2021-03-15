Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1452033BCB0
	for <lists+io-uring@lfdr.de>; Mon, 15 Mar 2021 15:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbhCOO2M (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Mar 2021 10:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238932AbhCOO1S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Mar 2021 10:27:18 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE46C061763
        for <io-uring@vger.kernel.org>; Mon, 15 Mar 2021 07:27:17 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id o16so5793823wrn.0
        for <io-uring@vger.kernel.org>; Mon, 15 Mar 2021 07:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=yM2Q78OFw2T1xOItgXl4+0T5MUnk99YxnK2L8x5p2y8=;
        b=Gv3vslSKTkBxclmG5KL+es3p11NZSpyxWKZLMc39MCkIu+2ufpCNX5llWSlB7vkPcR
         e4WS7SyxZqHbyOxQUUg0BZFeTyNS/2Mvyi5ZIrRJJs1nvSf3L/lv3ld6dCeqjexJOD7v
         2JtEO6abE8AX+hrj0mMT1BCDS/JFILTMA4G63mqaemtf2bUyiwdad3xZ9DBicXmTdiOS
         aU4VstJbz25i6BLQ022qyfFdvLrnA1w25OsEnFjJOpyfd/9GJ0ZBNviSmWH/aN6AQZVr
         tkhmDOcmhLYupOOOas2xJp/9USXMsQSRpAW6nwJ2ME668fAqolxdVXVy4LwAzoiv00s2
         AJaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yM2Q78OFw2T1xOItgXl4+0T5MUnk99YxnK2L8x5p2y8=;
        b=RWUCmGl3cWK7Hd3P+biiaNPZpTkxoTxNglcyLHmwzBkEezSNgxgvUCaUiLKmaHejwW
         vKShjUOZBjn1JFvZbDPPiRb6XKsSKvVWm6Zh0umgztZq4/W7f/0w7g9leLWsoDmw/JO0
         P2rwL5ruPjNPyct7nLg23O484UDj6YWU1jlHPDaNtQKt66/HkLB4Xr+f73NSv4cBYSGb
         uytYL/BiGKEXCIfs74i1Rpi2FMPEx7oibK+oNCe88C72r1bAmuyX4sbNupbcbS88Npqd
         19ngM7D4s+x7IZk8Vr7B4QU7C6InXJn5Tu8Xf+gNjfGgFndVSjC/t1t1WWJY9NjuEjJP
         dzHQ==
X-Gm-Message-State: AOAM530V/8YXNpZ1hnfURwGntXtC3FWln7FN4UppywF18ZzJKbUOFGMr
        7QnybeVuUNGdILgWIEwfj0E=
X-Google-Smtp-Source: ABdhPJw225ubDb12yDzqLhqtgVjJB9wxxH61oszngU7fLI5VTGme8wrU/9gkzTGB4RAIe4hT4/8xxg==
X-Received: by 2002:adf:ffc8:: with SMTP id x8mr27378267wrs.384.1615818436109;
        Mon, 15 Mar 2021 07:27:16 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.232])
        by smtp.gmail.com with ESMTPSA id u9sm8782168wmc.38.2021.03.15.07.27.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 07:27:15 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/2] io_uring: fix sqpoll cancellation via task_work
Date:   Mon, 15 Mar 2021 14:23:08 +0000
Message-Id: <423b0cc97b20756511a76a65896654d2d273339f.1615818144.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1615818144.git.asml.silence@gmail.com>
References: <cover.1615818144.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Running sqpoll cancellations via task_work_run() is a bad idea because
it depends on other task works to be run, but those may be locked in
currently running task_work_run() because of how it's (splicing the list
in batches).

Enqueue and run them through a separate callback head, namely
struct io_sq_data::park_task_work. As a nice bonus we now precisely
control where it's run, that's much safer than guessing where it can
happen as it was before.

Reported-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f396063b4798..481b2ea85a50 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -274,6 +274,7 @@ struct io_sq_data {
 
 	unsigned long		state;
 	struct completion	exited;
+	struct callback_head	*park_task_work;
 };
 
 #define IO_IOPOLL_BATCH			8
@@ -6724,6 +6725,7 @@ static int io_sq_thread(void *data)
 			cond_resched();
 			mutex_lock(&sqd->lock);
 			io_run_task_work();
+			io_run_task_work_head(&sqd->park_task_work);
 			timeout = jiffies + sqd->sq_thread_idle;
 			continue;
 		}
@@ -6778,6 +6780,7 @@ static int io_sq_thread(void *data)
 		}
 
 		finish_wait(&sqd->wait, &wait);
+		io_run_task_work_head(&sqd->park_task_work);
 		timeout = jiffies + sqd->sq_thread_idle;
 	}
 
@@ -6789,6 +6792,7 @@ static int io_sq_thread(void *data)
 	mutex_unlock(&sqd->lock);
 
 	io_run_task_work();
+	io_run_task_work_head(&sqd->park_task_work);
 	complete(&sqd->exited);
 	do_exit(0);
 }
@@ -8886,7 +8890,7 @@ static void io_sqpoll_cancel_sync(struct io_ring_ctx *ctx)
 	if (task) {
 		init_completion(&work.completion);
 		init_task_work(&work.task_work, io_sqpoll_cancel_cb);
-		WARN_ON_ONCE(task_work_add(task, &work.task_work, TWA_SIGNAL));
+		io_task_work_add_head(&sqd->park_task_work, &work.task_work);
 		wake_up_process(task);
 	}
 	io_sq_thread_unpark(sqd);
-- 
2.24.0

