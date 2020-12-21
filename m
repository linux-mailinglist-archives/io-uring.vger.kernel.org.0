Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC212DF9DD
	for <lists+io-uring@lfdr.de>; Mon, 21 Dec 2020 09:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgLUIYI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Dec 2020 03:24:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgLUIYI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Dec 2020 03:24:08 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 072ABC061282
        for <io-uring@vger.kernel.org>; Mon, 21 Dec 2020 00:22:57 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id z3so6070830qtw.9
        for <io-uring@vger.kernel.org>; Mon, 21 Dec 2020 00:22:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ntP8YLY2615UTqPXUm2rxMadDYP9leeW6asOE6N43ZU=;
        b=TeAJ4GbKvqoS0v9Vh0QKoV7WqRvdxg8EJwCmAPIuO2zvB8cJMOcBW9DQ5YHtc+mA7v
         WAQA/hciuhRpu26ru2GrIyh5FiJ7+0PKRpw9yp6A/nURuz8sE53w+kgfqEXFeXommTyU
         1H4r97TQLZBRPXv7z6chJhd1qW6hm/S43K9VgCzJ1hbWKELnxhcBhKVPV1iOTa8eIOMU
         2rx4fbmdUNl8ElW1Sd7pRObbUNUP1O/yl3yFPSyTxuz3zJcthmWj6Yqfi/tCehFNx8dR
         +imt1v50dfpNgUneL0jlXHmPqyo3DRhCt0XtvrqDBY8oPYg9a2l0z8Lkm5R07ci2nV7h
         E1DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ntP8YLY2615UTqPXUm2rxMadDYP9leeW6asOE6N43ZU=;
        b=h+DBpaWpYEp8pyo+IOxwlphtf9ez2zBoMsQPXwcyZxX2DlTJ+Q2woCIqai4Nrv1jra
         xH6bfM9RTjpuq+x0CdjxE2IWyjkZbPPzd4Y5SCef8Waz2QuVe0F8AT/oF1Eu9YnuRNFp
         ZJo4cvk/BX3qdZSW5bFWK/P/bAzV++E1SbDfpg4a//UOGsXVHABknQEhtTZOUCOx/IJm
         bBdQlolXCF1kLvYfQM6iMOM+zqdFuxTvG/WfghG2OBG6o7JuIxPQb+K/+OKIn0xoNsBj
         YTKTabtWTuvQxWBN7G5Zin4eQnRWdbT/71xRfAK3XhHIBQGe4DJ4Ln5F5jwcP6z4cnD1
         dqZw==
X-Gm-Message-State: AOAM531CMP4zjNvHfs34DCS0Fra41OO72MvVgiqD/35f45Kozpu3Pqpq
        jAO1ssNZhKEPgrNrCn+qu32T9lNgsbTC0Gm6rTI=
X-Google-Smtp-Source: ABdhPJyMeInKcCkAIW9bpPXfFXB3PSz0dsCFpRxF0gEhkM3ru1AK1RscbypphvnpSL6KNA17MXXzIldP3AXySUt/BAQ=
X-Received: by 2002:ac8:729a:: with SMTP id v26mr15208495qto.53.1608538975773;
 Mon, 21 Dec 2020 00:22:55 -0800 (PST)
MIME-Version: 1.0
References: <4dc9c74b-249d-117c-debf-4bb9e0df2988@kernel.dk>
 <2B352D6C-4CA2-4B09-8751-D7BB8159072D@googlemail.com> <d9205a43-ebd7-9412-afc6-71fdcf517a32@kernel.dk>
 <CAAss7+ps4xC785yMjXC6u8NiH9PCCQQoPiH+AhZT7nMX7Q_uEw@mail.gmail.com>
 <0fe708e2-086b-94a8-def4-e4ebd6e0b709@kernel.dk> <614f8422-3e0e-25b9-4cc2-4f1c07705ab0@kernel.dk>
 <986c85af-bb77-60d4-8739-49b662554157@gmail.com> <e88403ad-e272-2028-4d7a-789086e12d8b@kernel.dk>
 <df79018a-0926-093f-b112-3ed3756f6363@gmail.com> <CAAss7+peDoeEf8PL_REiU6s_wZ+Z=ZPMcWNdYt0i-C8jUwtc4Q@mail.gmail.com>
 <0fb27d06-af82-2e1b-f8c5-3a6712162178@gmail.com> <ff816e37-ce0e-79c7-f9bf-9fa94d62484d@kernel.dk>
 <CAAss7+o7_FZtBFs5c2UOS6KSXuDBkDwi=okffh4JRmYieTF3LA@mail.gmail.com>
 <CAAss7+raikmW4jGMYk8vLTqm4Y4X-im6zzWiVZY3ikQ7DifKQA@mail.gmail.com> <31cf2c96-82a5-3c21-e413-3eccc772495c@gmail.com>
In-Reply-To: <31cf2c96-82a5-3c21-e413-3eccc772495c@gmail.com>
From:   Josef <josef.grieb@gmail.com>
Date:   Mon, 21 Dec 2020 09:22:44 +0100
Message-ID: <CAAss7+pyB8m1b8=oqG4c7MwxCCc+Kirgbxy1U8Xs4VidZxSZkw@mail.gmail.com>
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Norman Maurer <norman.maurer@googlemail.com>,
        Dmitry Kadashev <dkadashev@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pavel I'm sorry...my kernel build process was wrong...the same kernel
patch(the first one) was used...I run different load tests on all 3
patches several times

your first patch works great and unfortunately second and third patch
doesn't work

Here the patch summary:

first patch works:

[1] git://git.kernel.dk/linux-block
branch io_uring-5.11, commit dd20166236953c8cd14f4c668bf972af32f0c6be

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f3690dfdd564..3a98e6dd71c0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8919,8 +8919,6 @@ void __io_uring_files_cancel(struct files_struct *files)
                struct io_ring_ctx *ctx = file->private_data;

                io_uring_cancel_task_requests(ctx, files);
-               if (files)
-                       io_uring_del_task_file(file);
        }

        atomic_dec(&tctx->in_idle);
@@ -8960,6 +8958,8 @@ static s64 tctx_inflight(struct io_uring_task *tctx)
 void __io_uring_task_cancel(void)
 {
        struct io_uring_task *tctx = current->io_uring;
+       struct file *file;
+       unsigned long index;
        DEFINE_WAIT(wait);
        s64 inflight;

@@ -8986,6 +8986,9 @@ void __io_uring_task_cancel(void)

        finish_wait(&tctx->wait, &wait);
        atomic_dec(&tctx->in_idle);
+
+       xa_for_each(&tctx->xa, index, file)
+               io_uring_del_task_file(file);
 }

 static int io_uring_flush(struct file *file, void *data)
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 35b2d845704d..54925c74aa88 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -48,7 +48,7 @@ static inline void io_uring_task_cancel(void)
 static inline void io_uring_files_cancel(struct files_struct *files)
 {
        if (current->io_uring && !xa_empty(&current->io_uring->xa))
-               __io_uring_files_cancel(files);
+               __io_uring_task_cancel();
 }
 static inline void io_uring_free(struct task_struct *tsk)
 {

second patch:

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f3690dfdd564..4e1fb4054516 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8620,6 +8620,10 @@ static int io_remove_personalities(int id, void
*p, void *data)
        return 0;
 }

+static void io_cancel_defer_files(struct io_ring_ctx *ctx,
+                                 struct task_struct *task,
+                                 struct files_struct *files);
+
 static void io_ring_exit_work(struct work_struct *work)
 {
        struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx,
@@ -8633,6 +8637,8 @@ static void io_ring_exit_work(struct work_struct *work)
         */
        do {
                io_iopoll_try_reap_events(ctx);
+               io_poll_remove_all(ctx, NULL, NULL);
+               io_kill_timeouts(ctx, NULL, NULL);
        } while (!wait_for_completion_timeout(&ctx->ref_comp, HZ/20));
        io_ring_ctx_free(ctx);
 }
@@ -8647,6 +8653,7 @@ static void io_ring_ctx_wait_and_kill(struct
io_ring_ctx *ctx)

                io_cqring_overflow_flush(ctx, true, NULL, NULL);
        mutex_unlock(&ctx->uring_lock);

+       io_cancel_defer_files(ctx, NULL, NULL);
        io_kill_timeouts(ctx, NULL, NULL);
        io_poll_remove_all(ctx, NULL, NULL);

third patch you already sent which is similar to the second one:
https://lore.kernel.org/io-uring/a195a207-db03-6e23-b642-0d04bf7777ec@gmail.com/T/#t

-- 
Josef
