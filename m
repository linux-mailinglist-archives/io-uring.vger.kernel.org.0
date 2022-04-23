Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7739350CCA6
	for <lists+io-uring@lfdr.de>; Sat, 23 Apr 2022 19:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236640AbiDWRmP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Apr 2022 13:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236599AbiDWRmO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Apr 2022 13:42:14 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8DB21C82C7
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 10:39:17 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id c12so17785230plr.6
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 10:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zPD3oXUSwzncZySFSn5YaDl6CFJYMTeuwOOKTNcfZLQ=;
        b=VZAK044JzkGVwhczA/vlQJxcnLYIGh4yDsrdZrMpVWs64cizjEAJx9XdO9VbBw+AMZ
         9M7mPKFxa4AQfgmHMp8365XbVfETMXAqwC1vlGXL/9Q4Pdqu8wQF+bnSeEbxBTZunnxT
         wkw3NCBYewI/zasX0Wm0KCyOelxvH6PsAibZghC8phItOUIWTfzUhey92XDlDRlQn8fv
         /K6jAVgGz3Y7njAxPocmQJkpTE62pDlNC8S/JMY+4YgPEovKxwok49RidvJwb2DOrQNM
         82sw/awdfbwqnbJ16GkENG3E3g0Nq/x4sP9WK0edy/tOVxM4sh66KXHDcmUDA4EpSEAQ
         TWRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zPD3oXUSwzncZySFSn5YaDl6CFJYMTeuwOOKTNcfZLQ=;
        b=wpFGplIhgInwdKklJxtPG07bttp92+7m9tr+L6DXb97138tvyRNHB0rYFVKgccMytE
         Krk5cJQLyy4qGV5gPrd2sBkL0hb2oVZ6O3JejgogO0U16WHHdLU/a/AEJxdw+NIXDXgX
         K4F2X7dn62Mp4L5DCVs0RBBaX7pKk/820vikNHcQu0phcWPtTXysQoa4InIblN5eAnes
         eCaLKCdAmdTm4v98QB9u66/6Je7pCw3JxOj1LtQGPpKEuZNaNwwT1ipVBa7eau/zZhRD
         viKZMr0X8wekn0ZfB92jixrjdQgnByAHQ14Ni+hywx/1vZBlYfaJHdfS6QznIpLeOv6I
         bUUA==
X-Gm-Message-State: AOAM531NKdw8hZeje9skdd7VFr6QmA8oU3RDtsnfo22eO0ESop+I70rj
        HlV5eIPfLkLBU2h8ZpR7CVwBqQU1L6+JEOd6
X-Google-Smtp-Source: ABdhPJx9kV8gZya4JKc74CMc4dC6ZFg4Pgftng9k404byS7Z38M4cskHx+k3LtXgrpMP8jOgTnzbAQ==
X-Received: by 2002:a17:902:8f94:b0:154:839b:809f with SMTP id z20-20020a1709028f9400b00154839b809fmr9909418plo.150.1650735557048;
        Sat, 23 Apr 2022 10:39:17 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e16-20020a63ee10000000b0039d1c7e80bcsm5198854pgi.75.2022.04.23.10.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Apr 2022 10:39:16 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/5] io-wq: use __set_notify_signal() to wake workers
Date:   Sat, 23 Apr 2022 11:39:09 -0600
Message-Id: <20220423173911.651905-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220423173911.651905-1-axboe@kernel.dk>
References: <20220423173911.651905-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The only difference between set_notify_signal() and __set_notify_signal()
is that the former checks if it needs to deliver an IPI to force a
reschedule. As the io-wq workers never leave the kernel, and IPI is never
needed, they simply need a wakeup.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 32aeb2c581c5..824623bcf1a5 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -871,7 +871,7 @@ static bool io_wq_for_each_worker(struct io_wqe *wqe,
 
 static bool io_wq_worker_wake(struct io_worker *worker, void *data)
 {
-	set_notify_signal(worker->task);
+	__set_notify_signal(worker->task);
 	wake_up_process(worker->task);
 	return false;
 }
@@ -991,7 +991,7 @@ static bool __io_wq_worker_cancel(struct io_worker *worker,
 {
 	if (work && match->fn(work, match->data)) {
 		work->flags |= IO_WQ_WORK_CANCEL;
-		set_notify_signal(worker->task);
+		__set_notify_signal(worker->task);
 		return true;
 	}
 
-- 
2.35.1

