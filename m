Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D22902215CB
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2020 22:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgGOUKK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jul 2020 16:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbgGOUKI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jul 2020 16:10:08 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69B1C08C5DD
        for <io-uring@vger.kernel.org>; Wed, 15 Jul 2020 13:10:06 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id dg28so2624144edb.3
        for <io-uring@vger.kernel.org>; Wed, 15 Jul 2020 13:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NBZwz/iJDyturYfYwj1u5a/ly72Q32flNreT+u4AFMs=;
        b=oZxSTMfMImLKJUtIiMgUf5gj0cNhaT6bR7vnph9913MaReYlVEart7NBd42sLC0ROc
         KBhL/e4b6KJXNBPowk8KgMKzFPs37ZxVr9V7P2136toqRe8FJ3BrPPUVqJR2abR1Fj60
         ycFHshZU5Shfy9PmwmEgB16QqoRI0ZTGrJsdM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NBZwz/iJDyturYfYwj1u5a/ly72Q32flNreT+u4AFMs=;
        b=nfV1ArcBmj8PtXWyKEohGBh4auJD1noTqwPQPuu+6nXehtHEHWJZLdO/0MCw0gxQLg
         qD4Iwz7Pgf3xGkzDOHUngtKdEMeg648OoZLtN0JLFZlWQhZzBSjB6y1FkjD5eWb8cpYK
         aBr+V/Fwuw5yTFpfRrxZKa0/oqVm8K5b9X+rHvU7z7qhCWjDowJJRwIQIPyfINpJs82I
         ZOULlj8O4gSAlRzWCdm2GqTNschelCvci4cG7I5sZzQwv80DTupYNrLdONx8LFJ+bxgY
         bCOKqAQ/0QUzLrgQErpH2l4bcjW6ghIWT/ikux3orL0Uzp4ZathCr/2Pn1pJe8sslUUh
         NMsw==
X-Gm-Message-State: AOAM532+7XgTO0U+ZP9ogjkFasIOQwR5Mn3XczmM5VcxumXOKR2aJ2kW
        cPZm4pEwrVK3OlKVc6eVwfX7LheOm7LKT/50lpDrIw==
X-Google-Smtp-Source: ABdhPJxmiwfGPdXuAL/Cm/iBN4GQDNpUgVqb1mhfqKEEu8zlIX3pRbGp59TjObNIRuwsiYpzoCYIpAxQXU0MuNuaGEM=
X-Received: by 2002:aa7:d04e:: with SMTP id n14mr1329981edo.161.1594843805238;
 Wed, 15 Jul 2020 13:10:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAJfpegu3EwbBFTSJiPhm7eMyTK2MzijLUp1gcboOo3meMF_+Qg@mail.gmail.com>
 <D9FAB37B-D059-4137-A115-616237D78640@amacapital.net> <20200715171130.GG12769@casper.infradead.org>
 <7c09f6af-653f-db3f-2378-02dca2bc07f7@gmail.com>
In-Reply-To: <7c09f6af-653f-db3f-2378-02dca2bc07f7@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 15 Jul 2020 22:09:54 +0200
Message-ID: <CAJfpegt9=p4uo5U2GXqc-rwqOESzZCWAkGMRTY1r8H6fuXx96g@mail.gmail.com>
Subject: Re: strace of io_uring events?
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        strace-devel@lists.strace.io, io-uring@vger.kernel.org,
        Linux API <linux-api@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jul 15, 2020 at 9:43 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> To clear details for those who are not familiar with io_uring:
>
> io_uring has a pair of queues, submission (SQ) and completion queues (CQ),
> both shared between kernel and user spaces. The userspace submits requests
> by filling a chunk of memory in SQ. The kernel picks up SQ entries in
> (syscall io_uring_enter) or asynchronously by polling SQ.
>
> CQ entries are filled by the kernel completely asynchronously and
> in parallel. Some users just poll CQ to get them, but also have a way
> to wait for them.
>
> >>>
> >>> What do people think?
> >>>
> >>> From what I can tell, listing the submitted requests on
> >>> io_uring_enter() would not be hard.  Request completion is
> >>> asynchronous, however, and may not require  io_uring_enter() syscall.
> >>> Am I correct?
>
> Both, submission and completion sides may not require a syscall.

Okay.

> >>> Is there some existing tracing infrastructure that strace could use to
> >>> get async completion events?  Should we be introducing one?
>
> There are static trace points covering all needs.

This needs to be unprivileged, or its usefulness is again compromized.

>
> And if not used the whole thing have to be zero-overhead. Otherwise
> there is perf, which is zero-overhead, and this IMHO won't fly.

Obviously it needs to be zero overhead if not tracing.

What won't fly?

Thanks,
Miklos
