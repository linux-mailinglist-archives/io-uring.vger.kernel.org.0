Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FDFF3B9FD4
	for <lists+io-uring@lfdr.de>; Fri,  2 Jul 2021 13:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbhGBLeo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Jul 2021 07:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231848AbhGBLeo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Jul 2021 07:34:44 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03FECC061762
        for <io-uring@vger.kernel.org>; Fri,  2 Jul 2021 04:32:12 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id r135so15970636ybc.0
        for <io-uring@vger.kernel.org>; Fri, 02 Jul 2021 04:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/hQuHtA8W3ADxj2Z0wk50gSPlfWO37Io8es3CMLf8/I=;
        b=q6V62JojdN99zppDX2A0S4dXDIjfi/Chu3Xv6L9iw9CpFQ4DCGxkNE5b/D8I2HuP3w
         /ppgZvTs7Qc0pHKKLnfTka9LbTcGFA6OPWL/gxFp26Sfwx0OhhXXbL+B/zgEL20FhcwH
         zx5UMC6liNY103+CqKSwD/jGabs/4SViXiivVWyKUk+rIshjtJI5F154itzKVrqc7cpr
         /cqEPGUGC0nPjmLG50StB/XalNCwsBxmr44N/2hXxzuhn4ptJ9RegsCuDRuR24qng+hd
         Avk+5gSXWlwpkvS87EYwwWoICR0n1WWUyoGtIW5KlhEIupw64QCyRCX4Cfxz2YZWudTa
         JCCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/hQuHtA8W3ADxj2Z0wk50gSPlfWO37Io8es3CMLf8/I=;
        b=H6pETiwK8Yi+cyR5ABe+dwmT8RedCPF9Ih6mzI14+GpbId4xL0qsgNxuW63ilIT3kD
         K7yP/nyyKRIkLz8sxz3iSS4p4oAy47qe9hx70SNYTHdjUrbsnbWdmJ57mCezbHgCoTOj
         Dgtx+MtwG4KEhnPgTBr5O8YAGLIazXs7Lr9h8laY+mQoz4KWS5xE7cYp9pa65kMKFB/X
         /OT1HwN72axFPlC/6vQcu5XJu2xzFmnW46Pbw8PftQgIac7YVM6lqcCQ4dAt6qx8TsPM
         XT3MMrq8+fhFq9/ov1RjUt+KJCVuk/7qFNtHn8R53vastXTAZkcmVo+k/LO1g0ZQgj2N
         /feQ==
X-Gm-Message-State: AOAM530heJ3peB/1dan7XROFkE8tLhrH0dJGcRLxmwCejJl/qNxa3oOV
        FZq42Q4cG8m6mRnuUERI66bRJJHPeYwkrXuvPI8=
X-Google-Smtp-Source: ABdhPJy83rR6VdDLFkEWxI/uRrcoOz/Oh9/qevxJEv6zuSI2PMsWrpm5pjyCl9NEAHl82pAikX9AkhPMumjb2fNaMnM=
X-Received: by 2002:a25:9bc4:: with SMTP id w4mr5668971ybo.168.1625225531304;
 Fri, 02 Jul 2021 04:32:11 -0700 (PDT)
MIME-Version: 1.0
References: <c9a79f27-02e9-b0d6-78ae-2e777eed8fe0@kernel.dk> <CAHk-=wgCac9hBsYzKMpHk0EbLgQaXR=OUAjHaBtaY+G8A9KhFg@mail.gmail.com>
In-Reply-To: <CAHk-=wgCac9hBsYzKMpHk0EbLgQaXR=OUAjHaBtaY+G8A9KhFg@mail.gmail.com>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Fri, 2 Jul 2021 18:32:00 +0700
Message-ID: <CAOKbgA5iixR+QCuYyzb2UBQGVddQtp0ERKZrKHbrsyWug2yYbQ@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring updates for 5.14-rc1
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 1, 2021 at 3:06 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Tue, Jun 29, 2021 at 1:43 PM Jens Axboe <axboe@kernel.dk> wrote:
> >
> > - Support for mkdirat, symlinkat, and linkat for io_uring (Dmitry)
>
> I pulled this, and then I unpulled it again.

First of all, I totally agree that parts of it are ugly. And I'm happy
to work on improving it with some guidance. But it's been sort of hard
getting feedback on the namei part of things (Christian Brauner was very
supportive though), and in cases where I was not sure what's the best
way to do something I just went with the "pick the least ugly way I can
see at the moment and collect the feedback" approach. And yes, in some
cases "least ugly" is still very ugly.

Part of the issue is I'm very new to the kernel code, I've seen the
unlinkat / renameat changes and thought that surely I can do the same
for mkdirat. It turned out to be much larger and not just about mkdirat
in the end.

> I hate how makes the rules for when "putname()" is called completely
> arbitrary and very confusing.

In my opinion, this is because of the "consume the name on error, but
not on success" logic in __filename_create / __filename_lookup. This
behavior was in fact suggested by Al back in January:
https://lore.kernel.org/io-uring/20210201150042.GQ740243@zeniv-ca/

And it works reasonably well when there is just one struct filename
passed in. But when there are two the state potentially becomes very
confusing: we might end up with cases like the second filename was
freed, but the first was not (which is basically where the hacks below
live).

> It ends up with multiple cases of something like
>
>         error = -ENOENT;
>         goto out_putnames;
>
> that didn't exist before.

Before it was just "return -ENOENT". But now there are two filenames
passed in that the function is responsible for freeing. I'm not sure how
this can be avoided.

> And worse still ends up being that unbelievably ugly hack with
>
>         // On error `new` is freed by __filename_create, prevent extra freeing
>         // below
>         new = ERR_PTR(error);
>         goto out_putpath;
>
> that ends up intentionally undoing one of the putnames because the
> name has already been used.

Yes, this is ugly, and teaching putname to deal with NULLs would mean we
could just set it to NULL here, but we can't just set it to NULL when it
was used, see below.

> And none of the commits have acks by Al. I realize that he can
> sometimes be a bit unresponsive, but this is just *UGLY*. And we've
> had too many io_uring issues for me to just say "I'm sure it's fine".
>
> I can see a few ways to at least de-uglify things:
>
>  - Maybe we can make putname() just do nothing for IS_ERR_OR_NULL() names.
>
>    We have that kind of rules for a number of path walking things,
> where passing in an error pointer is fine. Things like
> link_path_walk() or filename_lookup() act that way very much by
> design, exactly to make it easy to handle error conditions.

This sounds great to me, will make some paths much cleaner. But will
help with "new = ERR_PTR(error);" only partially (by using NULL instead
of ERR_PTR(error)).

>  - callers of __filename_create() and similar thar eat the name (and
> return a dentry or whatever) could then set the name to NULL, not as
> part of the error handling, but unconditionally as a "it's been used".

The problem is we have to keep the filenames around for retries on
ESTALE. It's not consumed by __filename_create() on success. So it's not
as simple as setting the name to NULL after calling __filename_create().
If it was not for ESTALE it'd be possible just to use filename_create()
that consumes the name passed to it unconditionally and it'd make the
logic much simpler indeed.

I'll do my best to improve things, but if there are any suggestions
they'd be appreciated.

-- 
Dmitry Kadashev
