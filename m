Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A87C136030B
	for <lists+io-uring@lfdr.de>; Thu, 15 Apr 2021 09:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbhDOHOx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Apr 2021 03:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbhDOHOw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Apr 2021 03:14:52 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA714C061574;
        Thu, 15 Apr 2021 00:14:29 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id o10so25025738ybb.10;
        Thu, 15 Apr 2021 00:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AmSJJ7fxEY1qfYfGbCGKBATmW67qLsXWzf2MAF6GFG8=;
        b=Oyp6JnSut4UGWs81Xjr/IfMcvKPiNWMRVJQsasx4yG0qjhOlEetIuSjXAe3PunijTt
         UXCdtiIBKpjBRHUb8rkQQ2xh172BOO1IBuYXxZsbzUAmsbQPxK2mckIijtoqEp8ylbZ8
         D9ReIkKKfmC/Lbmg1GQt8nwXfNxzBstW2Y9v+nblLlPlOeOwAGLCR5i6dOGeRVS4ogDo
         iW1B4/DVJ7FsyV48cNcMrlqwfGi8uD1NI71GhfRrLB8Te4fBkLSxezacYGD7IEuDKkXv
         prZM9gMkfWugOHzq7W9UO9GT0X4qZSdLripEfSFjK765SzyAQ2FLXISNH8UuA3dOsYEd
         iOWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AmSJJ7fxEY1qfYfGbCGKBATmW67qLsXWzf2MAF6GFG8=;
        b=JH/K8k9Vhx5xWJhETmd8Udyeia+vCdxWDhdcg265gyNBG9R7ZrhBSz+H+ukkADYhJu
         Me5HYRDbx7SoqXzx/pzCP6AOq80QpBRdcDOXwIzMiHP66vLAdFDvh93DySTEh+QRdrrj
         SOVQydpAH/7E8iD7h0yzIv9HW7b4aNDQm8pE2HqcVV6FbOZ7GyAl8iKHIKI+5lTnZ07e
         BWvZrlmwG+fsZIu6HIhscrBwWmzr/14grRgS0qwF3ebhQIxSjmT+//5KxofYyz2MfRrE
         bBrGk4SsfL/b3WHKSsClegluiZJbCfFIfliBLmcTe2KImuy9ygTyqBM7EGgijITWYlrE
         lBHA==
X-Gm-Message-State: AOAM533kuOQh7M7TzFsewQxVgHireonO5DAFfRR9DecK5Lg38RwmJpk7
        pWSZKCNzT44yIlcInVNu6msqWsVGyI7HCDRtlBnk2KIfAj/DSaEH
X-Google-Smtp-Source: ABdhPJy1A38856fQapXQ4ezTSfbE2TMGAWH2/Ef3BCDbt6+udhGvDCq4bLHxHdDymv1LLzPEHoNIKWQ4omQMeDAllM4=
X-Received: by 2002:a25:cb57:: with SMTP id b84mr2431459ybg.167.1618470869088;
 Thu, 15 Apr 2021 00:14:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210330055957.3684579-1-dkadashev@gmail.com> <20210330055957.3684579-2-dkadashev@gmail.com>
 <20210330071700.kpjoyp5zlni7uejm@wittgenstein> <CAOKbgA6spFzCJO+L_uwm9nhG+5LEo_XjVt7R7D8K=B5BcWSDbA@mail.gmail.com>
In-Reply-To: <CAOKbgA6spFzCJO+L_uwm9nhG+5LEo_XjVt7R7D8K=B5BcWSDbA@mail.gmail.com>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Thu, 15 Apr 2021 14:14:17 +0700
Message-ID: <CAOKbgA6Qrs5DoHsHgBvrSGbyzHcaiGVpP+UBS5f25CtdBx3SdA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] fs: make do_mkdirat() take struct filename
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Apr 8, 2021 at 3:45 PM Dmitry Kadashev <dkadashev@gmail.com> wrote:
>
> On Tue, Mar 30, 2021 at 2:17 PM Christian Brauner
> <christian.brauner@ubuntu.com> wrote:
> > The only thing that is a bit unpleasant here is that this change
> > breaks the consistency between the creation helpers:
> >
> > do_mkdirat()
> > do_symlinkat()
> > do_linkat()
> > do_mknodat()
> >
> > All but of them currently take
> > const char __user *pathname
> > and call
> > user_path_create()
> > with that do_mkdirat() change that's no longer true. One of the major
> > benefits over the recent years in this code is naming and type consistency.
> > And since it's just matter of time until io_uring will also gain support
> > for do_{symlinkat,linkat,mknodat} I would think switching all of them to
> > take a struct filename
> > and then have all do_* helpers call getname() might just be nicer in the
> > long run.
>
> So, I've finally got some time to look into this. do_mknodat() and
> do_symlinkat() are easy. But do_linkat() is more complicated, I could use some
> hints as to what's the reasonable way to implement the change.
>
> The problem is linkat() requires CAP_DAC_READ_SEARCH capability if AT_EMPTY_PATH
> flag is passed. Right now do_linkat checks the capability before calling
> getname_flags (essentially). If do_linkat is changed to accept struct filename
> then there is no bulletproof way to force CAP_DAC_READ_SEARCH presence (e.g. if
> for whatever reason AT_EMPTY_PATH is not in flags passed to do_linkat). Also, it
> means that the caller is responsible to process AT_EMPTY_PATH in the first
> place, which means logic duplication.
>
> Any ideas what's the best way to approach this?

Ping. If someone can see how we can avoid making do_linkat() callers
ensure the process has CAP_DAC_READ_SEARCH capability if AT_EMPTY_PATH
was passed then the hints would be really appreciated.

The best I could come up with is something like getname_linkat(), which
could be used by the do_linkat callers, but this sounds error prone and
ugly.

Jens, do you want to keep the mkdir change out of 5.13 because of this?

-- 
Dmitry Kadashev

On Thu, Apr 8, 2021 at 3:45 PM Dmitry Kadashev <dkadashev@gmail.com> wrote:
>
> On Tue, Mar 30, 2021 at 2:17 PM Christian Brauner
> <christian.brauner@ubuntu.com> wrote:
> > The only thing that is a bit unpleasant here is that this change
> > breaks the consistency between the creation helpers:
> >
> > do_mkdirat()
> > do_symlinkat()
> > do_linkat()
> > do_mknodat()
> >
> > All but of them currently take
> > const char __user *pathname
> > and call
> > user_path_create()
> > with that do_mkdirat() change that's no longer true. One of the major
> > benefits over the recent years in this code is naming and type consistency.
> > And since it's just matter of time until io_uring will also gain support
> > for do_{symlinkat,linkat,mknodat} I would think switching all of them to
> > take a struct filename
> > and then have all do_* helpers call getname() might just be nicer in the
> > long run.
>
> So, I've finally got some time to look into this. do_mknodat() and
> do_symlinkat() are easy. But do_linkat() is more complicated, I could use some
> hints as to what's the reasonable way to implement the change.
>
> The problem is linkat() requires CAP_DAC_READ_SEARCH capability if AT_EMPTY_PATH
> flag is passed. Right now do_linkat checks the capability before calling
> getname_flags (essentially). If do_linkat is changed to accept struct filename
> then there is no bulletproof way to force CAP_DAC_READ_SEARCH presence (e.g. if
> for whatever reason AT_EMPTY_PATH is not in flags passed to do_linkat). Also, it
> means that the caller is responsible to process AT_EMPTY_PATH in the first
> place, which means logic duplication.
>
> Any ideas what's the best way to approach this?
>
> Thanks.
>
> --
> Dmitry Kadashev
