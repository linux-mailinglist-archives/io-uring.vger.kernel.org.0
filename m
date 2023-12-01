Return-Path: <io-uring+bounces-194-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF47880106F
	for <lists+io-uring@lfdr.de>; Fri,  1 Dec 2023 17:41:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C1A01C20C11
	for <lists+io-uring@lfdr.de>; Fri,  1 Dec 2023 16:41:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AD7925747;
	Fri,  1 Dec 2023 16:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="znacTWRI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEAEE196
	for <io-uring@vger.kernel.org>; Fri,  1 Dec 2023 08:41:52 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-548ae9a5eeaso12012a12.1
        for <io-uring@vger.kernel.org>; Fri, 01 Dec 2023 08:41:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701448911; x=1702053711; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wJ6qDwmyRvhNqpylX9f8LuOmYLWmceoEf5k8FTfkzPU=;
        b=znacTWRINH7bjtkr56UNC1pMzBG1MLZZtyC3HCMP9cD00i5ttvvAjA8JXDV9KPTBrR
         5qa/JAljXjWikCWHzhvSQ04Sjw5xpx9NNC5ghPD9YxPG9QeQmWFXY0Vh7+USxBu7jQvX
         NS4cp9Vau1PE4dKvSOv1f0Xm+RpBWpJ5V2w3xQVKo3X35Mq5bA7J3KNF1RLZWA0s4lqD
         05niG2hrDQFHeLj1T5bbQAFIWNTxN4xP3dbfe6A6scvIUXE0VsBIX02ntC+OHA46EAbu
         ZBeHwB+QSie0WqcXfuX3BxkbjLSyTpevAILf4mWH/HZnnVbHUy3sk4qW5gCUZYckEAn+
         eoeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701448911; x=1702053711;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wJ6qDwmyRvhNqpylX9f8LuOmYLWmceoEf5k8FTfkzPU=;
        b=wxJSVXRIUqdRp9cTp2RNzHl7vonIy4QzpUOiD/1OWdOTbcq9ZZ/DMP5nAUs8WrxHei
         v7ePH9D+6A02aavtDpql6z2XI3a/caCKd1RvfTCr7rPhiWoVk3J2BOkmI6J/NayxpZbI
         azbzZj2OtX2ZOY8wlME4liImV4pXp8zTG84LTDg/Tacr0Ui0XoVzWklkCAwlSA9fve9G
         retZ81I631XQeP9w8lqPf1U3i829OT759dfKAYYNPlfaISC+XdvQ/1Uv7/gDYG4p3BNU
         Fx3w2+rN3tI0iawLUPYgBKhQEYijU8ATmjYF9/4ehHh9xsRBD/a9O9ZWcMobMHjD5xyc
         lwGg==
X-Gm-Message-State: AOJu0YzU7ME6kSxjRIkJaYApoexEPmp2hfHP4rY1TCZR941WGTfKm8GT
	W0ae40WPDg8Ao9R+bhP+5JVDywc7xBkeNo7jBdbDug==
X-Google-Smtp-Source: AGHT+IEBCEUy8WWjrEzQFzI0bb+4iHE3xDO/M7JSFQnRwhSwXTDZWgI6uFpXx2LfPxgJyDBAytWfBT1XfxCuFPcOOzo=
X-Received: by 2002:a50:aade:0:b0:54a:ee8b:7a8c with SMTP id
 r30-20020a50aade000000b0054aee8b7a8cmr168518edc.0.1701448911052; Fri, 01 Dec
 2023 08:41:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Jann Horn <jannh@google.com>
Date: Fri, 1 Dec 2023 17:41:13 +0100
Message-ID: <CAG48ez3xSoYb+45f1RLtktROJrpiDQ1otNvdR+YLQf7m+Krj5Q@mail.gmail.com>
Subject: io_uring: incorrect assumption about mutex behavior on unlock?
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	io-uring <io-uring@vger.kernel.org>
Cc: kernel list <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, Waiman Long <longman@redhat.com>
Content-Type: text/plain; charset="UTF-8"

mutex_unlock() has a different API contract compared to spin_unlock().
spin_unlock() can be used to release ownership of an object, so that
as soon as the spinlock is unlocked, another task is allowed to free
the object containing the spinlock.
mutex_unlock() does not support this kind of usage: The caller of
mutex_unlock() must ensure that the mutex stays alive until
mutex_unlock() has returned.
(See the thread
<https://lore.kernel.org/all/20231130204817.2031407-1-jannh@google.com/>
which discusses adding documentation about this.)
(POSIX userspace mutexes are different from kernel mutexes, in
userspace this pattern is allowed.)

io_ring_exit_work() has a comment that seems to assume that the
uring_lock (which is a mutex) can be used as if the spinlock-style API
contract applied:

    /*
    * Some may use context even when all refs and requests have been put,
    * and they are free to do so while still holding uring_lock or
    * completion_lock, see io_req_task_submit(). Apart from other work,
    * this lock/unlock section also waits them to finish.
    */
    mutex_lock(&ctx->uring_lock);

I couldn't find any way in which io_req_task_submit() actually still
relies on this. I think io_fallback_req_func() now relies on it,
though I'm not sure whether that's intentional. ctx->fallback_work is
flushed in io_ring_ctx_wait_and_kill(), but I think it can probably be
restarted later on via:

io_ring_exit_work -> io_move_task_work_from_local ->
io_req_normal_work_add -> io_fallback_tw(sync=false) ->
schedule_delayed_work

I think it is probably guaranteed that ctx->refs is non-zero when we
enter io_fallback_req_func, since I think we can't enter
io_fallback_req_func with an empty ctx->fallback_llist, and the
requests queued up on ctx->fallback_llist have to hold refcounted
references to the ctx. But by the time we reach the mutex_unlock(), I
think we're not guaranteed to hold any references on the ctx anymore,
and so the ctx could theoretically be freed in the middle of the
mutex_unlock() call?

I think that to make this code properly correct, it might be necessary
to either add another flush_delayed_work() call after ctx->refs has
dropped to zero and we know that the fallback work can't be restarted
anymore, or create an extra ctx->refs reference that is dropped in
io_fallback_req_func() after the mutex_unlock(). (Though I guess it's
probably unlikely that this goes wrong in practice.)

