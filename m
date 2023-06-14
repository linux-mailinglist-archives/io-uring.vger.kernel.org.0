Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF6B73063B
	for <lists+io-uring@lfdr.de>; Wed, 14 Jun 2023 19:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbjFNRpf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Jun 2023 13:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233267AbjFNRpP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Jun 2023 13:45:15 -0400
Received: from mail-vk1-xa31.google.com (mail-vk1-xa31.google.com [IPv6:2607:f8b0:4864:20::a31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FB11FC4
        for <io-uring@vger.kernel.org>; Wed, 14 Jun 2023 10:45:14 -0700 (PDT)
Received: by mail-vk1-xa31.google.com with SMTP id 71dfb90a1353d-46e7b04a561so378484e0c.2
        for <io-uring@vger.kernel.org>; Wed, 14 Jun 2023 10:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1686764713; x=1689356713;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rlCqyg/Yc+HEJru3BcMV2FLXrQMFTyeLgIEwLJkjWNQ=;
        b=Ozqa/7gOuJsY9IASinCGkUWD/RvzMZZH+rjRKiN1bKGcQKulIzLJdHR3tF1/crO/1w
         ABhrDG/rnmqa6FeHAWg3w0+LKRimq34d+fx9Y8YKraZWXsAYp+824/1FL6SoUkvj7h4P
         QVzjv7b1G1R7MebLEMDcKJAEDo5ha5Jirz3yQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686764713; x=1689356713;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rlCqyg/Yc+HEJru3BcMV2FLXrQMFTyeLgIEwLJkjWNQ=;
        b=NA9wWtFCviWRe7MGm+2mpxVcIIy8Gj5J5MSwXOeg6+u8z3gJ0rwr9Q2ePo32C8LtVt
         X8XQ0KJn1bteXawj1DwNp/UCNwpcjhlvXweTtErRicO2heBBvW7FnFrv+eWBfCI6ZQkj
         7tNrFLMvzib/3UIuiSqrm+9vRfV7W9p4KGUDz2QcrYiCdtjM05ebhbLIosXkcbzwecxT
         hMimcqjzFYFiNR80p0ezWxNE5O1NY0wfqyNE9g9Kv7vdTHTcIBvwLTb26Us0TKpsbD2F
         7RYZasoqpOcc9V7NNTHpLtgS5YVPlXGlg3ne4vyXySvTNP/FRiFXbDZaPD9DVtsFwRNy
         e5Sw==
X-Gm-Message-State: AC+VfDwZpLhnB8TjsjmnTF58JkUHiYQye7ekR49qvSJpLC5QWOn2p8UG
        jyvUz7C4mJC2aZuVMmanBard0iNJae4POVMMrvNJr6Ii
X-Google-Smtp-Source: ACHHUZ78EGlAw+LGpTHfDbh9XE9TuzXG5Xlt4n5zUN3oW69zfN104nAbdh+mwjBOmNlDc1kCIK1Afg==
X-Received: by 2002:a1f:bd0e:0:b0:46e:9c55:e800 with SMTP id n14-20020a1fbd0e000000b0046e9c55e800mr1018432vkf.16.1686764712941;
        Wed, 14 Jun 2023 10:45:12 -0700 (PDT)
Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com. [209.85.222.51])
        by smtp.gmail.com with ESMTPSA id d85-20020a1f9b58000000b004532e881807sm2285218vke.18.2023.06.14.10.45.12
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jun 2023 10:45:12 -0700 (PDT)
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-78a1e095508so913855241.0
        for <io-uring@vger.kernel.org>; Wed, 14 Jun 2023 10:45:12 -0700 (PDT)
X-Received: by 2002:a67:e913:0:b0:43b:4a1e:b15b with SMTP id
 c19-20020a67e913000000b0043b4a1eb15bmr6906150vso.2.1686764712050; Wed, 14 Jun
 2023 10:45:12 -0700 (PDT)
MIME-Version: 1.0
References: <2392dcb4-71f4-1109-614b-4e2083c0941e@kernel.dk>
 <20230614005449.awc2ncxl5lb2eg6m@zlang-mailbox> <5d5ccbb1-784c-52b3-3748-2cf7b5cf01ef@kernel.dk>
In-Reply-To: <5d5ccbb1-784c-52b3-3748-2cf7b5cf01ef@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 14 Jun 2023 10:44:53 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiotpcKvBWGneGjNA4eOGUsY+KTMCVsMxsGhXGCg=n=bA@mail.gmail.com>
Message-ID: <CAHk-=wiotpcKvBWGneGjNA4eOGUsY+KTMCVsMxsGhXGCg=n=bA@mail.gmail.com>
Subject: Re: [PATCH] io_uring/io-wq: don't clear PF_IO_WORKER on exit
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Zorro Lang <zlang@redhat.com>, io-uring <io-uring@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 13 Jun 2023 at 18:14, Jens Axboe <axboe@kernel.dk> wrote:
>
> +       preempt_disable();
> +       current->worker_private = NULL;
> +       preempt_enable();

Yeah, that preempt_disable/enable cannot possibly make a difference in
any sane situation.

If you want to make clear that it should be one single write, do it
with WRITE_ONCE().

But realistically, that won't matter either. There's just no way a
sane compiler can make it do anything else, and just the plain

        current->worker_private = NULL;

will be equivalent.

If there are ordering concerns, then neither preemption nor
WRITE_ONCE() matter, but "smp_store_release()" would.

But then any readers should use "smp_load_acquire()" too.

However, in this case, I don't think any of that matters.

The actual backing store is free'd with kfree_rcu(), so any ordering
would be against the RCU grace period anyway. So the only ordering
that matters is, I think, that you set it to NULL *before* that
kfree_rcu() call, so that we know that "if somebody has seen a
non-NULL worker_private, then you still have a full RCU grace period
until it is gone".

Of course, that all still assumes that any read of worker_private
(from outside of 'current') is inside an RCU read-locked region. Which
isn't actually obviously true.

But at least for the case of io_wq_worker_running() and
io_wq_worker_sleeping, the call is always just for the current task.
So there are no ordering constraints at all. Not for preemption, not
for SMP, not for RCU. It's all entirely thread-local.

(That may not be obvious in the source code, since
io_wq_worker_sleeping/running gets a 'tsk' argument, but in the
context of the scheduler, 'tsk' is always just a cached copy of
'current').

End result: just do it as a plain store.  And I don't understand why
the free'ing of that data structure is RCU-delayed at all. There does
not seem to be any non-synchronous users of the worker_private pointer
at all. So I *think* that

        kfree_rcu(worker, rcu);

should just be

        kfree(worker);

and I wonder if that rcu-freeing was there to try to hide the bug.

But maybe I'm missing something.

            Linus
