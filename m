Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3CC7382156
	for <lists+io-uring@lfdr.de>; Sun, 16 May 2021 23:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhEPV7v (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 May 2021 17:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbhEPV7q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 May 2021 17:59:46 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E10C061756
        for <io-uring@vger.kernel.org>; Sun, 16 May 2021 14:58:29 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id p7so684586wru.10
        for <io-uring@vger.kernel.org>; Sun, 16 May 2021 14:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=S+kRdIkeFQny0A2e1C+JjHjiwH+o7XfJrquVojDsznc=;
        b=It14V/BgYR0wWA5bYzDAvtfMDeMGdpH2C9lgJL+86dSR8F3nUtTaZe7SrgLFt/wGtu
         NSSOfM2LlLKfXE4970YoebEViSwiinZR9mGFJSAUsWl5gxCf+2xN/czDqho3+tUSF0lV
         h74g3NhDyEDqGsRDw9V3a9K0yKqNB+kIb7W8LdErkllyOanJI78SXMuZa4oP6XmhALUS
         BXnqffsmoHNgMsqcnd5QU+Od2WwgWlgWg0PPXaRzrwCWySDVAZR0ebTSoERL1LgwvnHz
         LyOpthf2n8I4berx1qUcPC3a+1S1iI2M1fo5kzyhWhrSsNORbGKMj93EDjIWGqU18VVu
         tmvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S+kRdIkeFQny0A2e1C+JjHjiwH+o7XfJrquVojDsznc=;
        b=m0GwUeixK814OviVw6El5iQkKN4s2Sg6eVPcDdF+7K+xHwlNwXg1QimlVLrA7AC7rM
         lyVnyRt/meBh3jgaHpk6euuqDefEJxixlSp9Cf3g2/6JwJuiR69eNiCeEMnm9G5b44nX
         xvVDv4w4f5BLMAtV7JaLTELMp3PNdUnj5VDWHtXiDOPsCVCmYLbLNB6XlmuFtGPYrb/c
         pQcQ+ZJ+qMu+WV4ZgYAeZH3iYbQdVT3ZxitYm07+InH/+yBn+IQ06MvYxvst9mNWVyd2
         Wx96257N0BnSiIkXIO1JOI6BWbqY56ojxojQDLnVZuSYdfFACpWAuwnkrwl3djwoldbu
         VMbA==
X-Gm-Message-State: AOAM532XKvYSK/fOKMQCgYaO+fazPXY+sjjv+NU/606ks6DtN2aZ+7qq
        +6rxYAJwUZxa94Jr0Lvd2hc=
X-Google-Smtp-Source: ABdhPJxJZ3LA/FimEJaUa1d7YVChPOQCQX20zNFfzVOSnV28VXQS9VIyP87oRGMewuQVH8t/WMFnsw==
X-Received: by 2002:a05:6000:188b:: with SMTP id a11mr68406817wri.275.1621202308683;
        Sun, 16 May 2021 14:58:28 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.7])
        by smtp.gmail.com with ESMTPSA id p10sm13666365wmq.14.2021.05.16.14.58.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 May 2021 14:58:28 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 03/13] io_uring: remove unused park_task_work
Date:   Sun, 16 May 2021 22:58:02 +0100
Message-Id: <310d8b76a2fbbf3e139373500e04ad9af7ee3dbb.1621201931.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621201931.git.asml.silence@gmail.com>
References: <cover.1621201931.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As sqpoll cancel via task_work is killed, remove everything related to
park_task_work as it's not used anymore.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 64caf3767414..152873b88efe 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -288,7 +288,6 @@ struct io_sq_data {
 
 	unsigned long		state;
 	struct completion	exited;
-	struct callback_head	*park_task_work;
 };
 
 #define IO_IOPOLL_BATCH			8
@@ -6829,7 +6828,6 @@ static bool io_sqd_handle_event(struct io_sq_data *sqd)
 		mutex_lock(&sqd->lock);
 	}
 	io_run_task_work();
-	io_run_task_work_head(&sqd->park_task_work);
 	return did_sig || test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
 }
 
@@ -6851,9 +6849,6 @@ static int io_sq_thread(void *data)
 	current->flags |= PF_NO_SETAFFINITY;
 
 	mutex_lock(&sqd->lock);
-	/* a user may had exited before the thread started */
-	io_run_task_work_head(&sqd->park_task_work);
-
 	while (1) {
 		int ret;
 		bool cap_entries, sqt_spin, needs_sched;
@@ -6914,7 +6909,6 @@ static int io_sq_thread(void *data)
 		}
 
 		finish_wait(&sqd->wait, &wait);
-		io_run_task_work_head(&sqd->park_task_work);
 		timeout = jiffies + sqd->sq_thread_idle;
 	}
 
@@ -6923,7 +6917,6 @@ static int io_sq_thread(void *data)
 	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 		io_ring_set_wakeup_flag(ctx);
 	io_run_task_work();
-	io_run_task_work_head(&sqd->park_task_work);
 	mutex_unlock(&sqd->lock);
 
 	complete(&sqd->exited);
-- 
2.31.1

