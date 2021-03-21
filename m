Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B632534349D
	for <lists+io-uring@lfdr.de>; Sun, 21 Mar 2021 21:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbhCUUVi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Mar 2021 16:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbhCUUVI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Mar 2021 16:21:08 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C58C061574
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 13:21:08 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id 11so9580764pfn.9
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 13:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=ECWEaxowq9HCF2XD6mjGeDAcq7HNoBR+R6uIuejgYgE=;
        b=oGS8qPaM80V13sUcl1Z9BHlZ/Wym36CLTnksI3NkxNzvrH+UVJIiaKBgTmIz3CYbfj
         Su63r3ihwgUm3SH/JbB2LJ0+LX/K06KjCYsSW5mCDgYxoXC63purrQzkAD07w37XTFmO
         S6tkM7GrvXhsJmg7W024AgFNYvelH+l/MAB0C/21vNsMKJ3+0qR2Oq64eu0dDi2SWWYq
         so1yAvaUynxBDJyKGWfcAMDsgHAK79q9aI2V9kgcBLc7tqw0LNd4OH2aGki9iWarFmbD
         nvvxWVqXeWEQw8U6ueb6GCOkFiWMjEtWjPbnNFMFyLJ6bvbHf/I6dnKHsgE+CkFXlA1H
         sIUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=ECWEaxowq9HCF2XD6mjGeDAcq7HNoBR+R6uIuejgYgE=;
        b=k9Jl7a1UlLawl0H2yNfg4/ypW1uaBzm4pBHfI6mTgobhDbRopvA6UFXDCWhIFGk1tD
         GMsZXrJWZ7dAS5xY/A2j5kgMUz9rQKJw7V+NkOBStve7SfxyfWgQA/krvrjSNDYob7Lb
         0Z6x0vVB9Mj4XohLuDnqyEk22Uj4b/SsBrVpfrK/VPqMEe5vUvubszc/HDFJ+6TvgfE6
         Y3aYK5YskWixGXQSJH9xhVRnTLsQKoTqcTF/m/ekNDbOwlaHSEw9yZoBiSMeeDDFTgqW
         FrOn1BNHzAyiZuO8R/QdQaMGpO4kwdD8h28qQigzaD6x0+aJ2xoL7OyuUKl5WnBG7suN
         77LA==
X-Gm-Message-State: AOAM533RhZO7+HI3BjMJkOs6ptxx63uvUyx27v6Nar0Lp88QY/ryImDm
        GcgEC1eZs2db/pdzaUOWgh/IfdjCAhIpoQ==
X-Google-Smtp-Source: ABdhPJy6zQWKDtjHHawRhwRlkWDkHmZZ8i0mM7uUrCMRuRBa4oWNo6aCUR4+P09SlojJg0WN3LJLCQ==
X-Received: by 2002:a63:1026:: with SMTP id f38mr20382482pgl.142.1616358067807;
        Sun, 21 Mar 2021 13:21:07 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id q25sm10896807pff.104.2021.03.21.13.21.07
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Mar 2021 13:21:07 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: don't use {test,clear}_tsk_thread_flag() for
 current
Message-ID: <411aeec5-9951-cdbb-1b18-d0d2ae9fc931@kernel.dk>
Date:   Sun, 21 Mar 2021 14:21:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Linus correctly points out that this is both unnecessary and generates
much worse code on some archs as going from current to thread_info is
actually backwards - and obviously just wasteful, since the thread_info
is what we care about.

Since io_uring only operates on current for these operations, just use
test_thread_flag() instead. For io-wq, we can further simplify and use
tracehook_notify_signal() to handle the TIF_NOTIFY_SIGNAL work and clear
the flag. The latter isn't an actual bug right now, but it may very well
be in the future if we place other work items under TIF_NOTIFY_SIGNAL.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/io-uring/CAHk-=wgYhNck33YHKZ14mFB5MzTTk8gqXHcfj=RWTAXKwgQJgg@mail.gmail.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 3dc10bfd8c3b..2dd43bdb9c7b 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -388,11 +388,9 @@ static struct io_wq_work *io_get_next_work(struct io_wqe *wqe)
 
 static bool io_flush_signals(void)
 {
-	if (unlikely(test_tsk_thread_flag(current, TIF_NOTIFY_SIGNAL))) {
+	if (unlikely(test_thread_flag(TIF_NOTIFY_SIGNAL))) {
 		__set_current_state(TASK_RUNNING);
-		if (current->task_works)
-			task_work_run();
-		clear_tsk_thread_flag(current, TIF_NOTIFY_SIGNAL);
+		tracehook_notify_signal();
 		return true;
 	}
 	return false;
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 543551d70327..be04bc6b5b99 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6873,7 +6873,7 @@ static int io_run_task_work_sig(void)
 		return 1;
 	if (!signal_pending(current))
 		return 0;
-	if (test_tsk_thread_flag(current, TIF_NOTIFY_SIGNAL))
+	if (test_thread_flag(TIF_NOTIFY_SIGNAL))
 		return -ERESTARTSYS;
 	return -EINTR;
 }

-- 
Jens Axboe

