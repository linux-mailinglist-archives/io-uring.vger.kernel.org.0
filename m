Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA8A2DF5A3
	for <lists+io-uring@lfdr.de>; Sun, 20 Dec 2020 15:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727621AbgLTOXU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Dec 2020 09:23:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727489AbgLTOXU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Dec 2020 09:23:20 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B17E5C0613CF
        for <io-uring@vger.kernel.org>; Sun, 20 Dec 2020 06:22:39 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id y23so8145297wmi.1
        for <io-uring@vger.kernel.org>; Sun, 20 Dec 2020 06:22:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZmGgSLAoeeyRU4gKzj+KQBa3cFwxmjRfik+PkViMDTg=;
        b=vf1ChVl/wJ3KJSKgXlsCH4T5Nw9Kc4j5YhfF7TXJDwhZnUqnLBa1k1jjwdiEbqJZoT
         +KfCZtB0P31nS31V/79aiSbCRFfNIG5crwoLNTlfRr3cwBYJVYglqzKK8uuUJOlWfYtl
         8iB2DVrrUsDefouzAt2A4Ls0wdfhy33n03s7woAH2nVJpgqEa2Rx+qhEJFMSUdiB0L52
         rmzwlgfotku4RqFhr675iE3HkX1yB8A/1QfmNkM0wZIx2JNnPF3v2Xa8qqSY5FIgBqcr
         87iMpRO8NH2kLYDU04HJij6dkhvbiw6rkpy0xAmzyQlm7ecV3e22Z8AsXx5sTZ8B2wQr
         VxGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ZmGgSLAoeeyRU4gKzj+KQBa3cFwxmjRfik+PkViMDTg=;
        b=HCGJzzFUix1YquPJCuOKna3G4x+YgW2Lt6j1bv7dtnxsslEOvrhsEnmusQorVjrSq9
         fNnUaFEGiGVj9owJTtbQSXxVzVIAlDIdCCtRFFgzn5VEctdXgg20Xl93QSQrR3apVT0v
         x4ebJFKMpYqltbM5F61oLg8T4mO/AYOnEgq9ypR/WbF1hhRuXKZKGRpUYVTmX04VCR1q
         +eqJx+POngiCEtkhYjPYTnE9CYYYXyt1ku+fP03J2DT8URSlKEqphdg1ZZe6Sg6p9Wy8
         p21/t4W5StVqbf5p1mG4tSsvvOozu7/3UPvdoWZx2xIvYKDlXZ35MLFwrT04fOVLRsfi
         7Lfw==
X-Gm-Message-State: AOAM530ZpjJZo8YLrQXo1J9z3WcWfIEs2jOyCkAQTDtbOmomZmMT+4fC
        fD1axiKF0C1mbykhK2vYiQNGIV+TlQWvoQ==
X-Google-Smtp-Source: ABdhPJyQYVFgZP8DXtdln0XFpt3dfvwNsPd/08xLwCjfl2jm4c1vG+mc9EHUl4+snBUYQVUPusuCFQ==
X-Received: by 2002:a1c:9692:: with SMTP id y140mr5858607wmd.128.1608474158158;
        Sun, 20 Dec 2020 06:22:38 -0800 (PST)
Received: from [192.168.8.139] ([85.255.237.164])
        by smtp.gmail.com with ESMTPSA id y63sm19933378wmd.21.2020.12.20.06.22.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Dec 2020 06:22:37 -0800 (PST)
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Josef <josef.grieb@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Norman Maurer <norman.maurer@googlemail.com>,
        Dmitry Kadashev <dkadashev@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <4dc9c74b-249d-117c-debf-4bb9e0df2988@kernel.dk>
 <2B352D6C-4CA2-4B09-8751-D7BB8159072D@googlemail.com>
 <d9205a43-ebd7-9412-afc6-71fdcf517a32@kernel.dk>
 <CAAss7+ps4xC785yMjXC6u8NiH9PCCQQoPiH+AhZT7nMX7Q_uEw@mail.gmail.com>
 <0fe708e2-086b-94a8-def4-e4ebd6e0b709@kernel.dk>
 <614f8422-3e0e-25b9-4cc2-4f1c07705ab0@kernel.dk>
 <986c85af-bb77-60d4-8739-49b662554157@gmail.com>
 <e88403ad-e272-2028-4d7a-789086e12d8b@kernel.dk>
 <df79018a-0926-093f-b112-3ed3756f6363@gmail.com>
 <CAAss7+peDoeEf8PL_REiU6s_wZ+Z=ZPMcWNdYt0i-C8jUwtc4Q@mail.gmail.com>
 <0fb27d06-af82-2e1b-f8c5-3a6712162178@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <6361f713-2c90-0828-6a8f-72d277320591@gmail.com>
Date:   Sun, 20 Dec 2020 14:19:17 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <0fb27d06-af82-2e1b-f8c5-3a6712162178@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 20/12/2020 13:00, Pavel Begunkov wrote:
> On 20/12/2020 07:13, Josef wrote:
>>> Guys, do you share rings between processes? Explicitly like sending
>>> io_uring fd over a socket, or implicitly e.g. sharing fd tables
>>> (threads), or cloning with copying fd tables (and so taking a ref
>>> to a ring).
>>
>> no in netty we don't share ring between processes
>>
>>> In other words, if you kill all your io_uring applications, does it
>>> go back to normal?
>>
>> no at all, the io-wq worker thread is still running, I literally have
>> to restart the vm to go back to normal(as far as I know is not
>> possible to kill kernel threads right?)
>>
>>> Josef, can you test the patch below instead? Following Jens' idea it
>>> cancels more aggressively when a task is killed or exits. It's based
>>> on [1] but would probably apply fine to for-next.
>>
>> it works, I run several tests with eventfd read op async flag enabled,
>> thanks a lot :) you are awesome guys :)
> 
> Thanks for testing and confirming! Either we forgot something in
> io_ring_ctx_wait_and_kill() and it just can't cancel some requests,
> or we have a dependency that prevents release from happening.
> 
> BTW, apparently that patch causes hangs for unrelated but known
> reasons, so better to not use it, we'll merge something more stable.

I'd really appreciate if you can try one more. I want to know why
the final cleanup doesn't cope  with it.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 941fe9b64fd9..d38fc819648e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8614,6 +8614,10 @@ static int io_remove_personalities(int id, void *p, void *data)
 	return 0;
 }
 
+static void io_cancel_defer_files(struct io_ring_ctx *ctx,
+				  struct task_struct *task,
+				  struct files_struct *files);
+
 static void io_ring_exit_work(struct work_struct *work)
 {
 	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx,
@@ -8627,6 +8631,8 @@ static void io_ring_exit_work(struct work_struct *work)
 	 */
 	do {
 		io_iopoll_try_reap_events(ctx);
+		io_poll_remove_all(ctx, NULL, NULL);
+		io_kill_timeouts(ctx, NULL, NULL);
 	} while (!wait_for_completion_timeout(&ctx->ref_comp, HZ/20));
 	io_ring_ctx_free(ctx);
 }
@@ -8641,6 +8647,7 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 		io_cqring_overflow_flush(ctx, true, NULL, NULL);
 	mutex_unlock(&ctx->uring_lock);
 
+	io_cancel_defer_files(ctx, NULL, NULL);
 	io_kill_timeouts(ctx, NULL, NULL);
 	io_poll_remove_all(ctx, NULL, NULL);
 
-- 
Pavel Begunkov
