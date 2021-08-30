Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80943FB77A
	for <lists+io-uring@lfdr.de>; Mon, 30 Aug 2021 16:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhH3OD0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 Aug 2021 10:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236916AbhH3OD0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 Aug 2021 10:03:26 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92417C06175F
        for <io-uring@vger.kernel.org>; Mon, 30 Aug 2021 07:02:32 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id b200so19981088iof.13
        for <io-uring@vger.kernel.org>; Mon, 30 Aug 2021 07:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=SYywIXrpIVYzBjWQG1mVtJzWQLfONmZgA9gSi/Ggvwo=;
        b=dqN6ZLmT910571QgPRnUUIvNdN6Jxq7FxYtabxkps4stUUI6UQYU4xiZDoY+NWZCUU
         uBHJ/flZuGS0XCTakolASnFG6BWjn0kOVIiwk0s4cs5Sc/1/Ig2rsOzQBeqJkWbB2+6O
         IfAdZIIvIihAVJhi8f8mr2xA9pBzqxnr8EyQWSqt3m86S6Ulkat/gvA/SSkUbGztbHgU
         fadiRPbk05KsZKXuqxLw4aQ3Mazo/uTYeKkytaOrgMHR0u/tUeHpwXK07lbjvTQYWCxY
         93pIkIWy2ToQgCA3gKJL/5n8MoeJSDdrswpJHtWlIJnzawetMmwv0+rF0YA14+vq7tK2
         9ySw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=SYywIXrpIVYzBjWQG1mVtJzWQLfONmZgA9gSi/Ggvwo=;
        b=AafhfC9SiHHUd6c+Otiy9+055LwdWx+5/dAkWwp7rwEytouxJd7rqSDIGEc5VZImuR
         wKfFVqqcADy8JEDFwU/+T7EdAJGz3csDptCa0oEF/a/DX+qEhonnWghjQPdCh7BQjddO
         TCMPCYiJJYKIJi4U8kktUfpWH83gtF+63bze3J4udcaS25YGst5gUj6G2c36oZWn2Dn7
         4xAgmCJyvaUD8XdkEyusCkmb6FixWB8BJvlQwPt8wHKu8guYm6EQiFPXFF8soA+m30lT
         mQlOVZwOyw3cu6FQM0+rtmzgqJO3myak1TK58Ty/3KuFjRQ5J4Rhw71AnOFVf1+dA7p7
         4n2g==
X-Gm-Message-State: AOAM531lFnCF3x1vyMfx03zodqVzKCApu0ms7PhBE6aKWHjnKDu3+pSn
        dA4FcXtKP/Nik1zmK9y/qgzAiMXE3gMQoQ==
X-Google-Smtp-Source: ABdhPJzBTVqpz4KiQXUbfg7YWqMz/LIDI37RFfMEJMZk3H5Je+3Jtvz6xlcaLl+f3BSzx0eA8L2WmA==
X-Received: by 2002:a02:ce37:: with SMTP id v23mr20331474jar.81.1630332151979;
        Mon, 30 Aug 2021 07:02:31 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id f2sm8051946ioz.14.2021.08.30.07.02.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Aug 2021 07:02:31 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Andres Freund <andres@anarazel.de>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io-wq: fix wakeup race when adding new work
Message-ID: <37972d83-dc9a-27a9-7831-b9577062c9ad@kernel.dk>
Date:   Mon, 30 Aug 2021 08:02:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When new work is added, io_wqe_enqueue() checks if we need to wake or
create a new worker. But that check is done outside the lock that
otherwise synchronizes us with a worker going to sleep, so we can end
up in the following situation:

CPU0                            CPU1
lock
insert work
unlock
atomic_read(nr_running) != 0
                                lock
                                atomic_dec(nr_running)
no wakeup needed

Hold the wqe lock around the "need to wakeup" check. Then we can also get
rid of the temporary work_flags variable, as we know the work will remain
valid as long as we hold the lock.

Cc: stable@vger.kernel.org
Reported-by: Andres Freund <andres@anarazel.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 13aeb48a0964..cd9bd095fb1b 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -794,7 +794,7 @@ static void io_wqe_insert_work(struct io_wqe *wqe, struct io_wq_work *work)
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 {
 	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
-	int work_flags;
+	bool do_wake;
 
 	/*
 	 * If io-wq is exiting for this task, or if the request has explicitly
@@ -806,14 +806,14 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 		return;
 	}
 
-	work_flags = work->flags;
 	raw_spin_lock(&wqe->lock);
 	io_wqe_insert_work(wqe, work);
 	wqe->flags &= ~IO_WQE_FLAG_STALLED;
+	do_wake = (work->flags & IO_WQ_WORK_CONCURRENT) ||
+			!atomic_read(&acct->nr_running);
 	raw_spin_unlock(&wqe->lock);
 
-	if ((work_flags & IO_WQ_WORK_CONCURRENT) ||
-	    !atomic_read(&acct->nr_running))
+	if (do_wake)
 		io_wqe_wake_worker(wqe, acct);
 }
 
-- 
Jens Axboe

