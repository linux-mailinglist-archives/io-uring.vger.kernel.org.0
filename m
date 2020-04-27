Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B88DB1BAC62
	for <lists+io-uring@lfdr.de>; Mon, 27 Apr 2020 20:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgD0SWs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Apr 2020 14:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726162AbgD0SWr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Apr 2020 14:22:47 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751E1C0610D5
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2020 11:22:47 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id g4so18681752ljl.2
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2020 11:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+u4o6Ie4+Kl1Tjyvtpmep/uLVhNOyU/x4KCAgamW1t8=;
        b=jzOYujv76tY/9n3roJKtNrgoTSdxhwXgiVrKu4gnrK66Lst8B0jRYKoCg5XPX9CCD7
         RWtocBOaya924d2oclqGIavLaZpso2DZUCt0m61MZDdcR5jcRAA7QExEv5gXeMRQFHxx
         02GZMK/nWfmVOdTeiLT8cP0eacoS3HTi+rFfbdJtg3r2ncbX8iGomFjqWiM0nyJO8eSF
         +IBv+mKURXy2SmFEKj7uortrq7ZjgF6v9N0eq7VDKTQgEOeK+JcSCn/KRXNRg7M48kQk
         Ul1h5pXV1jmVCoESnKVPd8TEb0en7MJ1+2LtO9TYSbh7McmN4EXL5UxQzSMXcOVqQw96
         T/Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+u4o6Ie4+Kl1Tjyvtpmep/uLVhNOyU/x4KCAgamW1t8=;
        b=iOjD6rOJn2cbydGj8sUR21Sw6Laeq2StD2ydGAlV6kL99hUnFSmk/94h6qt5X7i8Du
         YBCUnb+cerllTvoIJx6xBGJijA7++e9gOvhI3t6dp43VbHhVnoeAf5DyYryWHY8POa5s
         D5ug0fgRcfHMliEKHZOtI1FliOJsrHy93NvmXjysdCpxX/5WKKAKaDOVmGHmiYwpVmID
         YwIy3YDOW83786WQle9zqIHQWIov8ZAllvrUvSjlJeT9s8soF7XpW7l2mIOMA5OQH8i7
         wBAvaKfQKYuXEVw/G2a4x23BIH8BCSAWV66KfDxI+LdSDs0tgVmOFFriyKxOkXsJ5hR1
         8JUQ==
X-Gm-Message-State: AGi0PuYapVkwR63miyiwj/VziQc8NQItGaFdEThENsnm/ZP2VoPaP4OW
        R6SL6kbgpeBMhElMtyg1HtEgdQQKubSwJl+IXZZXgA==
X-Google-Smtp-Source: APiQypJIvhRMhWqECkOD89ih+lkJhdoibpGFIXRyjldXh4VfOdKhD2us46rCJ4oXG7VzjkWdj4hei/bKlzIP2eGnSsk=
X-Received: by 2002:a2e:8087:: with SMTP id i7mr13863204ljg.99.1588011765678;
 Mon, 27 Apr 2020 11:22:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200427154031.n354uscqosf76p5z@ps29521.dreamhostps.com> <c76b09f0-3437-842e-7106-efb2cac38284@kernel.dk>
In-Reply-To: <c76b09f0-3437-842e-7106-efb2cac38284@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Mon, 27 Apr 2020 20:22:18 +0200
Message-ID: <CAG48ez1fc1_U7AtWAM+Jh6QjV-oAtAW2sQ2XSz9s+53SN_wSFg@mail.gmail.com>
Subject: Re: Feature request: Please implement IORING_OP_TEE
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Clay Harris <bugs@claycon.org>,
        io-uring <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Apr 27, 2020 at 5:56 PM Jens Axboe <axboe@kernel.dk> wrote:
> On 4/27/20 9:40 AM, Clay Harris wrote:
> > I was excited to see IORING_OP_SPLICE go in, but disappointed that tee
> > didn't go in at the same time.  It would be very useful to copy pipe
> > buffers in an async program.
>
> Pavel, care to wire up tee? From a quick look, looks like just exposing
> do_tee() and calling that, so should be trivial.

Just out of curiosity:

What's the purpose of doing that via io_uring? Non-blocking sys_tee()
just shoves around some metadata, it doesn't do any I/O, right? Is
this purely for syscall-batching reasons? (And does that mean that you
would also add syscalls like epoll_wait() and futex() to io_uring?) Or
is this because you're worried about blocking on the pipe mutex?
