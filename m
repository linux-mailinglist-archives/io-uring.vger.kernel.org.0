Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C17253BF561
	for <lists+io-uring@lfdr.de>; Thu,  8 Jul 2021 08:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbhGHGIV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Jul 2021 02:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbhGHGIU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Jul 2021 02:08:20 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA66C061574;
        Wed,  7 Jul 2021 23:05:38 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id a16so7127909ybt.8;
        Wed, 07 Jul 2021 23:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mlf3iRZ72+39U7Ow36yxaKTO/ydFaCcKjJcQ3DPlKVk=;
        b=vFKGV7DaP1rn8takaF5L5Rb7WjGO3ASU2IE4auSfbeGJb8nJdqqyvFSnUE4bu7gZR2
         8LIxZWUPjGYjShNXMKJWjuYRQyJNKnRshiK8HAj6oirvVor8QooyCR50GtqDPqqLbITl
         m4hmXRLTWa8NVUY2coAmo+4FMvBCH926dzHuKw4WDDKNcfAqBhBRC1F9dXMx2q0rpAl1
         IiHFpSmZs0WVniZ4RFmkuGqCDMhj0PKxfVYDDCCu30L+rDr6VyuvxL4X0V7xiEZfXSaJ
         QSCCpS7jJtB5nUGJ+zpjwu2K1jAORPqWkMuiveZSOm2oqp29Ikh74vUiTCRTPmfAbq++
         Z5OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mlf3iRZ72+39U7Ow36yxaKTO/ydFaCcKjJcQ3DPlKVk=;
        b=VpHLeD5ZsrrV/W8OWPdek1Z0ZjqoQh6mDKDWtOczAOIdsFr+bKT/0nEUUz+OI73Her
         RlIuc5mzLb0MzJ6VH6NOnR5h1uTF0spQDHS2WxPZn9uslZ0c8BYJjFw+XHrA12JxDBUm
         +McX13qMMBtsfDmtubORHIzonT0U4/j1B+dAMSrMUJGZErobtv+o7THK+xPYdG/UAvhV
         bc4aicVsFGFcCIMdSM/t0+ogDLlG77VzCiRKEp/0/lT1qJcQJFOsaFYQjBRheCW769ze
         XrxE6JJKsKmQcjm9aF25YZNiVPWYqvAjCJhVlwkENqBwc4UeEQFhn1fpQb+iWv/3xNai
         PwCQ==
X-Gm-Message-State: AOAM533FpHmel+cn4+lvYZ5F4h8s+p3ECrSm+ToH0NJupfBnaqkFvUkZ
        xwm8FxQF89c/Rk/4zVCVknm2TiHk5zizLoLmYhQ=
X-Google-Smtp-Source: ABdhPJwgtkiiiuPsB83bKudZvXtPVUeGCFUISRz4Gr7kmPks5hAvgDmUN5yZGB3se1SvXJEW2HwPA0YYX39/tdX40nc=
X-Received: by 2002:a25:9bc4:: with SMTP id w4mr34461308ybo.168.1625724337630;
 Wed, 07 Jul 2021 23:05:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210707122747.3292388-1-dkadashev@gmail.com> <CAHk-=wiTyxUt61NxeMXb2Zn2stDBC7eG82RKj+3jXUORdYQtpg@mail.gmail.com>
In-Reply-To: <CAHk-=wiTyxUt61NxeMXb2Zn2stDBC7eG82RKj+3jXUORdYQtpg@mail.gmail.com>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Thu, 8 Jul 2021 13:05:26 +0700
Message-ID: <CAOKbgA6_eF_jwNHOSXGsSX+WhqKWwfxeYpiSjKvCjqsGiScyOg@mail.gmail.com>
Subject: Re: [PATCH v8 00/11] io_uring: add mkdir and [sym]linkat support
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 8, 2021 at 2:26 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Wed, Jul 7, 2021 at 5:28 AM Dmitry Kadashev <dkadashev@gmail.com> wrote:
> >
> > This started out as an attempt to add mkdirat support to io_uring which
> > is heavily based on renameat() / unlinkat() support.
>
> Ok, sorry for having made you go through all the different versions,
> but I like the new series and think it's a marked improvement.

No worries at all!

> I did send out a few comments to the individual patches that I think
> it can all now be made to be even more legible by avoiding some of the
> goto spaghetti, but I think that would be a series on top.
>
> (And I'd like to note again that I based all that on just reading the
> patches, so there may be something there that makes it not work well).

I'm happy to do that. I suppose it will have to go through Al's tree
rather than Jens' one?

> One final request: can you keep the fs/namei.c patches as one entirely
> separate series, and then do the io_uring parts at the end, rather
> than intermixing them?

Sure. I'm a bit confused if you mean splitting the series into two or
just moving io_uring bits to the end though. I'll send a v9 with
io_uring bits moved to the end of the series and if you prefer it to be
a completely separate series then let me know.

Thank you for the help again, Linus!

-- 
Dmitry Kadashev
