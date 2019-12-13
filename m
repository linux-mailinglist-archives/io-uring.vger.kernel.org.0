Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF5611EA7C
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2019 19:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbfLMSgw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Dec 2019 13:36:52 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:37476 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728857AbfLMSgp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Dec 2019 13:36:45 -0500
Received: by mail-il1-f195.google.com with SMTP id h15so250770ile.4
        for <io-uring@vger.kernel.org>; Fri, 13 Dec 2019 10:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Jqa6MrRMwGhteMvnxEE0pQsK1Y7JVSd+n+3sGbg66cg=;
        b=z9CRmVfVq6N31yb02SyOmk1jpslgp1IZr8Nbz1BOdLlAVYVlzGP+HaUtFPn4x9FVqo
         3sZ4l7QDOGROiSx5koIOaXyqJNV4K36L7PpgBevPb4pn5yMYEW6czpHhlh4ywOllcZPz
         aMCUk9qhe1TU8Q8FpM49aL07zLF3CnFa27Yr7doL2MUAXjMi/yVBcafHuQX2vOv9wNDg
         V/b5UUSgu454/JslwwSTuAo0tR5ufyePHiOLev+SM3q3sRQ01PcX9beU69Y/J9ssV8wO
         5O/Rsd/bYQQC0WHAgo+TD+TT068mJnxfqk/AASQeCJ0kI3PHllLkq2pvjbMuOC/4+cp4
         AOOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Jqa6MrRMwGhteMvnxEE0pQsK1Y7JVSd+n+3sGbg66cg=;
        b=ro1/SPkW0jRJTnGct8hxHiif4355+bgR4mFnjGlKEgSdoGHTb//31X4vnFYa2JmySb
         Zje7TBq7r2jWrhbvjndc6ZPluhBplUAsXIQ0gjZct08Vb5oFR/WNbSUy+OvIAkl3aOqk
         CyxbRquuhjFUXK4niWiz7GToK0F5kCtSTADofr0vY0DelLvuXlC1tUDfOH6whLI++HW2
         md5Hpv8jDSOpGpIm5HYMrJq3RSz8fawbX2hd+DKfuG/GiNsJTZYLDboLcynWNsD83J2x
         V7YOISoDeemt4U7ncS6Fqz/tlBnrddsUaaBIT7BG0SSEl0miXm67Tz3oUTu5mg9wFXtm
         wRew==
X-Gm-Message-State: APjAAAXnu/RpmE2LmQHzjc04J0HbGgaA86dCxYYaZJtcDoXzd5Q5PCaR
        J+1tl7FQWp8ic3cCiqXo8qs4Rd1VrWiq9w==
X-Google-Smtp-Source: APXvYqy54QCvA37rO1DX1k9xPWxzDBqnGOA/5w15osuie0vhamb5ZlypNpsRofDC21lTNdVVbrDeMg==
X-Received: by 2002:a92:d610:: with SMTP id w16mr639990ilm.283.1576262204780;
        Fri, 13 Dec 2019 10:36:44 -0800 (PST)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id w24sm2932031ilk.4.2019.12.13.10.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 10:36:43 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 07/10] io-wq: add support for uncancellable work
Date:   Fri, 13 Dec 2019 11:36:29 -0700
Message-Id: <20191213183632.19441-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191213183632.19441-1-axboe@kernel.dk>
References: <20191213183632.19441-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Not all work can be cancelled, some of it we may need to guarantee
that it runs to completion. Allow the caller to set IO_WQ_WORK_NO_CANCEL
on work that must not be cancelled. Note that the caller work function
must also check for IO_WQ_WORK_NO_CANCEL on work that is marked
IO_WQ_WORK_CANCEL.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c    | 8 +++++++-
 fs/io-wq.h    | 1 +
 fs/io_uring.c | 5 ++++-
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 90c4978781fb..d0303ad17347 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -453,6 +453,10 @@ static void io_worker_handle_work(struct io_worker *worker)
 		}
 		if (!worker->creds)
 			worker->creds = override_creds(wq->creds);
+		/*
+		 * OK to set IO_WQ_WORK_CANCEL even for uncancellable work,
+		 * the worker function will do the right thing.
+		 */
 		if (test_bit(IO_WQ_BIT_CANCEL, &wq->state))
 			work->flags |= IO_WQ_WORK_CANCEL;
 		if (worker->mm)
@@ -829,6 +833,7 @@ static bool io_work_cancel(struct io_worker *worker, void *cancel_data)
 	 */
 	spin_lock_irqsave(&worker->lock, flags);
 	if (worker->cur_work &&
+	    !(worker->cur_work->flags & IO_WQ_WORK_NO_CANCEL) &&
 	    data->cancel(worker->cur_work, data->caller_data)) {
 		send_sig(SIGINT, worker->task, 1);
 		ret = true;
@@ -903,7 +908,8 @@ static bool io_wq_worker_cancel(struct io_worker *worker, void *data)
 		return false;
 
 	spin_lock_irqsave(&worker->lock, flags);
-	if (worker->cur_work == work) {
+	if (worker->cur_work == work &&
+	    !(worker->cur_work->flags & IO_WQ_WORK_NO_CANCEL)) {
 		send_sig(SIGINT, worker->task, 1);
 		ret = true;
 	}
diff --git a/fs/io-wq.h b/fs/io-wq.h
index fb993b2bd0ef..f0a016c4ee9c 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -12,6 +12,7 @@ enum {
 	IO_WQ_WORK_UNBOUND	= 32,
 	IO_WQ_WORK_INTERNAL	= 64,
 	IO_WQ_WORK_CB		= 128,
+	IO_WQ_WORK_NO_CANCEL	= 256,
 
 	IO_WQ_HASH_SHIFT	= 24,	/* upper 8 bits are used for hash key */
 };
diff --git a/fs/io_uring.c b/fs/io_uring.c
index db79ac79d80e..132f887ef18d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3153,8 +3153,11 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 	/* Ensure we clear previously set non-block flag */
 	req->rw.ki_flags &= ~IOCB_NOWAIT;
 
-	if (work->flags & IO_WQ_WORK_CANCEL)
+	/* if NO_CANCEL is set, we must still run the work */
+	if ((work->flags & (IO_WQ_WORK_CANCEL|IO_WQ_WORK_NO_CANCEL)) ==
+				IO_WQ_WORK_CANCEL) {
 		ret = -ECANCELED;
+	}
 
 	if (!ret) {
 		req->has_user = (work->flags & IO_WQ_WORK_HAS_MM) != 0;
-- 
2.24.1

