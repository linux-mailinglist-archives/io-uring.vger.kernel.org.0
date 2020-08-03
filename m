Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6BA23B139
	for <lists+io-uring@lfdr.de>; Tue,  4 Aug 2020 01:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbgHCXtW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 Aug 2020 19:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726350AbgHCXtW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 Aug 2020 19:49:22 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3758FC06174A
        for <io-uring@vger.kernel.org>; Mon,  3 Aug 2020 16:49:22 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id h19so41550006ljg.13
        for <io-uring@vger.kernel.org>; Mon, 03 Aug 2020 16:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rjFfxbNIZeER3lRkzTq/8A/E4palbhToV4FcRoDFDQU=;
        b=LNPbu/JBr7LgWvqrpga5bSNfG5kG5Dh4SimAjNbTedFwlm+C/trvigNb3I6cdGQ882
         Fbm0TrpGSScd8f4TgWHJHzAeG+mCgZcpSLPb2IVy7HUG5YLlb4X7yAOjFcKUNet8QOy2
         qCeVQZwqcCRne91hfASqgpVkhmO1QTjnKHD04=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rjFfxbNIZeER3lRkzTq/8A/E4palbhToV4FcRoDFDQU=;
        b=AG9l4JvrB5RtRcJeuIEN9KURJoxWsa6ICfKi9F44b77/ABko1dqQID9ISXCCtS3VxZ
         lN4QE+2BjzxcX03cFAl0/9xTpaTivk0ZmR9ICy8GtlCLVeQ50e1V3Tl2d+w5LJNwtWwa
         Ky2fdlyu3C0npnwfJKZj9RMck0knMo9eFykJhZ9QBq6vLboilcKACBsHer7NiN5Y4Bd1
         UE4mPTf1LC03BIokInCKDa2oR21QsPpqxyFUm1NpiPNBJ456SCvx7UmeIk6AxTqAWElN
         RCUPDGMPDpmXOIAljdgjhFgnK07FO6fwiOkAbT1rkDk05By/vLNOhH27FF9q9nt9XpWF
         IQmw==
X-Gm-Message-State: AOAM533I4ShJjTdDHHC9RD2CwP4WfKQZtqEhtHMxhpkijfAJzG/bqaOC
        5ZyhiFdxy/jVe1AWqe5ldKRSCwnAHBQ=
X-Google-Smtp-Source: ABdhPJxU8i4/3ah/oybfUCgnLXXnZ38Ld5FY37JOCiqyLV5mMtZvw6LIzaS+gF0P5pgLfp9s2XdqKw==
X-Received: by 2002:a2e:8105:: with SMTP id d5mr8876000ljg.299.1596498560320;
        Mon, 03 Aug 2020 16:49:20 -0700 (PDT)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id 80sm4756472ljf.38.2020.08.03.16.49.19
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 16:49:19 -0700 (PDT)
Received: by mail-lf1-f42.google.com with SMTP id i80so21364032lfi.13
        for <io-uring@vger.kernel.org>; Mon, 03 Aug 2020 16:49:19 -0700 (PDT)
X-Received: by 2002:a05:6512:241:: with SMTP id b1mr9664740lfo.125.1596498559171;
 Mon, 03 Aug 2020 16:49:19 -0700 (PDT)
MIME-Version: 1.0
References: <50466810-9148-e245-7c1e-e7435b753582@kernel.dk>
 <CAHk-=wgaxWMA7DVTQq+KxqaWHPDrXDuScX9orzRgxdi7SBfmoA@mail.gmail.com>
 <cd478521-e6ec-a1aa-5f93-29ad13d2a8bb@kernel.dk> <56cb11b1-7943-086e-fb31-6564f4d4d089@kernel.dk>
 <025dcd45-46df-b3fa-6b4a-a8c6a73787b0@kernel.dk>
In-Reply-To: <025dcd45-46df-b3fa-6b4a-a8c6a73787b0@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 3 Aug 2020 16:49:03 -0700
X-Gmail-Original-Message-ID: <CAHk-=whZYCK2eNEcTvKWgBvoSL8YLT6G0dexVkFbDiVCLN3zBQ@mail.gmail.com>
Message-ID: <CAHk-=whZYCK2eNEcTvKWgBvoSL8YLT6G0dexVkFbDiVCLN3zBQ@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring changes for 5.9-rc1
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Aug 3, 2020 at 4:31 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> Updated to honor exclusive return value as well:

See my previous email, You're just adding code that makes no sense,
because your wait entry fundamentally isn't an exclusive one.

So all that code is a no-op and only makes it more confusing to read.

Your wakeup handler has _nothing_ to do with the generic
wake_page_function(). There is _zero_ overlap. Your wakeup handler
gets called only for the wait entries _you_ created.

Trying to use the wakeup logic from wake_page_function() makes no
sense, because the rules for wake_page_function() are entirely
different. Yes, they are called for the same thing (somebody unlocked
a page and is waking up waiters), but it's using a completely
different sleeping logic.

See? When wake_page_function() does that

        wait->flags |= WQ_FLAG_WOKEN;

and does something different (and returns different values) depending
on whether WQ_FLAG_EXCLUSIVE was set, that is all because
wait_on_page_bit_common() entry set yo that wait entry (on its stack)
with those exact rules in mind.

So the wakeup function is 1:1 tied to the code that registers the wait
entry. wait_on_page_bit_common() has one set of rules, that are then
honored by the wakeup function it uses. But those rules have _zero_
impact on your use. You can have - and you *do* have - different sets
of rules.

For example, none of your wakeups are ever exclusive. All you do is
make a work runnable - that doesn't mean that other people shouldn't
do other things when they get a "page was unlocked" wakeup
notification.

Also, for you "list_del_init()" is fine, because you never do the
unlocked "list_empty_careful()" on that wait entry.  All the waitqueue
operations run under the queue head lock.

So what I think you _should_ do is just something like this:

    diff --git a/fs/io_uring.c b/fs/io_uring.c
    index 2a3af95be4ca..1e243f99643b 100644
    --- a/fs/io_uring.c
    +++ b/fs/io_uring.c
    @@ -2965,10 +2965,10 @@ static int io_async_buf_func(struct
wait_queue_entry *wait, unsigned mode,
            if (!wake_page_match(wpq, key))
                    return 0;

    -       /* Stop waking things up if the page is locked again */
    -       if (test_bit(key->bit_nr, &key->page->flags))
    -              return -1;
    -
    +       /*
    +        * Somebody unlocked the page. Unqueue the wait entry
    +        * and run the task_work
    +        */
             list_del_init(&wait->entry);

             init_task_work(&req->task_work, io_req_task_submit);

because that matches what you're actually doing.

There's no reason to stop waking up others because the page is locked,
because you don't know what others want.

And there's never any reason for the exclusive thing, b3ecause none of
what you do guarantees that you take exclusive ownership of the page
lock. Running the work *may* end up doing a "lock_page()", but you
don't actually guarantee that.

                Linus
