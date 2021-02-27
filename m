Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4EC326B2E
	for <lists+io-uring@lfdr.de>; Sat, 27 Feb 2021 03:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhB0CtM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Feb 2021 21:49:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbhB0CtK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Feb 2021 21:49:10 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844CCC06174A
        for <io-uring@vger.kernel.org>; Fri, 26 Feb 2021 18:48:30 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id 2so8303427ljr.5
        for <io-uring@vger.kernel.org>; Fri, 26 Feb 2021 18:48:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bx6ATtA2Bfwmyrn60xpBlKt8sNsp0KkQBRC3+WkjKKg=;
        b=ATlvo2ETlycojqqGHPNcF1RSVITz0iIdoNhVT7YfZ6lBQmtE0Z7/2XyL3kIDXk2CGH
         GRCMQkxN4w9yPi/1AiR1cTfbAdSn0rsYRtK3WidklUa1SKwk8gO1vIS/K8hJvRW1dKeU
         J4Jm4QbTECD9Y3CNNTW5bDZkgIOI11WtiK1IM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bx6ATtA2Bfwmyrn60xpBlKt8sNsp0KkQBRC3+WkjKKg=;
        b=V+wQtETGcSLw1ztqSy6wFYADopw/y7743BCIkjtXoln1SIQOVNjQP2hliHI1OpU3ak
         90ZubbK2d+na0kGP17C3zWV8eYcqqRDUBfzdGdEKFHwSOCp5zqmrIlYEep+zmYVcdqSB
         dXm81ncivHP++JheaG0z6/vSLxYSm8ArYoOYnOI65hl6WbVsxE4DxslKW2YcHK9difjX
         xkw3CC5R0dxs+lx8DrtaQ1Ct27lK2+1d40a7rb8KcXmkkj6X8Yj6loNFqA4S1Ubvy71o
         GLLFuwgYkf27IExL8e1Q3XHcbHORT46Ehymni1WzJ4PN/lMdMBWIctMSDJ80K299d8nU
         S27g==
X-Gm-Message-State: AOAM530qW+D2hm6sIprY7ypMyxYms8qrl+9yBR7iKBlTyTuKm5tZJxnZ
        9iMMwQp06InmOwcv0hNf4LL5bc9uIhseUA==
X-Google-Smtp-Source: ABdhPJz2gHNnfnzbUq/4xddoTfX/AMm2yyBOG4hkmBLIZNqotVbX7Cz/1xQqXmRGqNmY518aonUXNQ==
X-Received: by 2002:a2e:8159:: with SMTP id t25mr3302462ljg.84.1614394108514;
        Fri, 26 Feb 2021 18:48:28 -0800 (PST)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com. [209.85.208.181])
        by smtp.gmail.com with ESMTPSA id x6sm271173lfn.11.2021.02.26.18.48.27
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Feb 2021 18:48:27 -0800 (PST)
Received: by mail-lj1-f181.google.com with SMTP id q14so12852715ljp.4
        for <io-uring@vger.kernel.org>; Fri, 26 Feb 2021 18:48:27 -0800 (PST)
X-Received: by 2002:a2e:9bd0:: with SMTP id w16mr3186350ljj.465.1614394107375;
 Fri, 26 Feb 2021 18:48:27 -0800 (PST)
MIME-Version: 1.0
References: <0c142458-9473-9df3-535f-34c06957d464@kernel.dk>
In-Reply-To: <0c142458-9473-9df3-535f-34c06957d464@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 26 Feb 2021 18:48:11 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjWB3+NnWwuwyQofNv=d1kT0j7T6QH-G_yF_fBO52yvag@mail.gmail.com>
Message-ID: <CAHk-=wjWB3+NnWwuwyQofNv=d1kT0j7T6QH-G_yF_fBO52yvag@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring thread worker change
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Reading through this once..

I'll read through it another time tomorrow before merging it, but on
the whole it looks good. The concept certainly is the right now, but I
have a few questions about some of the details..

On Fri, Feb 26, 2021 at 2:04 PM Jens Axboe <axboe@kernel.dk> wrote:
>
>       io-wq: fix races around manager/worker creation and task exit

Where did that

+        __set_current_state(TASK_RUNNING);

in the patch come from? That looks odd.

Is it because io_wq_manager() does a

        set_current_state(TASK_INTERRUPTIBLE);

at one point? Regardless, that code looks very very strange.

>       io_uring: remove the need for relying on an io-wq fallback worker

This is coded really oddly.

+ do {
+     head = NULL;
+     work = READ_ONCE(ctx->exit_task_work);
+ } while (cmpxchg(&ctx->exit_task_work, work, head) != work);

Whaa?

If you want to write

    work = xchg(&ctx->exit_task_work, NULL);

then just do that. Instead of an insane cmpxchg loop that isn't even
well-written.

I say that it isn't even well-written, because when you really do want
a cmpxchg loop, then realize that cmpxchg() returns the old value, so
the proper way to write it is

    new = whatever;
    expect = READ_ONCE(ctx->exit_task_work);
    for (;;) {
          new->next = expect;  // Mumble mumble - this is why you want
the cmpxchg
          was = cmpxchg(&ctx->exit_task_work, expect, new);
          if (was == expect)
                  break;
          expect = was;
    }

IOW, that READ_ONCE() of the old value should happen only once - and
isn't worth a READ_ONCE() in the first place. There's nothing "read
once" about it.

But as mentioned, if all you want is an atomic "get and replace with
NULL", then just a plain "xchg()" is what you should do.

Yes, that cmpxchg loop _works_, but it is really confusing to read
that way, when clearly you don't actually need or really want a
cmpxchg.

(The other cmpxchg loop in the same patch is needed, but does that
unnecessary "re-read the value that cmpxchg just returned").

Please explain.

              Linus
