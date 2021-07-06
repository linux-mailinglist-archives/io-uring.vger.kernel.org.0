Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D87F3BD68E
	for <lists+io-uring@lfdr.de>; Tue,  6 Jul 2021 14:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234181AbhGFMhb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Jul 2021 08:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245468AbhGFMMy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Jul 2021 08:12:54 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE20C028B9F
        for <io-uring@vger.kernel.org>; Tue,  6 Jul 2021 05:06:33 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id g19so33865443ybe.11
        for <io-uring@vger.kernel.org>; Tue, 06 Jul 2021 05:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kIdakPlH/b7B5xIsNT5JW5s+u8yFDPEEw4kN7jHTAOI=;
        b=Ic7glmFver3L7VIUQfAr3Zb8PqvhZZJjNTHRLZTbOJK6CddBy8qzEQa/bwL8bLSfvL
         Kzns+hhOBlC2bB5/W8DQHX52slOhZPGxSMNuUkEhLEFnMaBxBwN2mSKsDkdCwhHwAxd9
         mAB6j/ZmKr9UF/q4MD97QsvNbvyNLiNaB9hwrQLPc4TwluJoKgpXoOs5jKopSEtW0TQa
         cldLJ0cQTUTRDiW3U5BOsvEF/QoE3Xr2Pq5hYEMogor4qqHRAXUgGr3l3DAu1utRzKtI
         z6/9Nao6C/ovtPdMySl7Tt13jxPYsTi/MpfbqLmyuIPiOvaIkFme4Csr2GNn8OY6hgHr
         D61Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kIdakPlH/b7B5xIsNT5JW5s+u8yFDPEEw4kN7jHTAOI=;
        b=uTl0JNRKRNSv5htyrP/yR2Vo+d+bRZWqtPyilbKTG7tQ7FDoz5PrX4sjjjzb4XRLg0
         Wipp4jlKtipGBLFc+p5sy4CtwEZgCku18MLyCEfEhQZqiXyyEDCOqLJ0yYK87R1KpQPF
         RqdIfca4LSDEXtG8Qm4w8ZYjtgbRn+IXZuBNrv23S0ylZ46pti7Me3G8Lre3Tr5ikUKE
         uN7H9g+JC6ql1wtJNCOM8iRWSBZD/tqoKaY9WdH9Qzqqo7zLcjKsXeGF+shrpVv//nOo
         Dw5D/Z+9YlnI3nn3B3FDHfuhr1TxXHco7ej29J7/LrHtnT1zTjNV4Q3wZe7ulNXnQU6E
         623w==
X-Gm-Message-State: AOAM532CPtd+OW/F0V3fA33ZwbfQcXWwk0qdopg+1xHLe27ILIVspBWm
        N3KW5QPGnD5+aHPeLt0j9jdrZesmkgCNU4pCoEA=
X-Google-Smtp-Source: ABdhPJwwXhZbOwN1WYGCgf0K7pKcO9n9Lce5S3U7VzJmNCYF3rr2lXaf3qxCn3ENBP+B/QPoWKZw9h6Gh/W3UKtcU+M=
X-Received: by 2002:a25:dc4d:: with SMTP id y74mr25992601ybe.289.1625573192594;
 Tue, 06 Jul 2021 05:06:32 -0700 (PDT)
MIME-Version: 1.0
References: <c9a79f27-02e9-b0d6-78ae-2e777eed8fe0@kernel.dk>
 <CAHk-=wgCac9hBsYzKMpHk0EbLgQaXR=OUAjHaBtaY+G8A9KhFg@mail.gmail.com>
 <CAOKbgA5iixR+QCuYyzb2UBQGVddQtp0ERKZrKHbrsyWug2yYbQ@mail.gmail.com>
 <CAHk-=wgye_GuQ5cBFC=UOPHkd0o8-Nrau7GNZHTZVuGO2tincw@mail.gmail.com>
 <CAOKbgA6x-qPK4jTmH4AO_GPy=tTRw1uMuD7wyiVFM7q0WQ5WbQ@mail.gmail.com> <CAHk-=wgjvUoOtggcVb7HRAhy2=LfG1+oKrjg5MZh+bSrKDzyAA@mail.gmail.com>
In-Reply-To: <CAHk-=wgjvUoOtggcVb7HRAhy2=LfG1+oKrjg5MZh+bSrKDzyAA@mail.gmail.com>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Tue, 6 Jul 2021 19:06:21 +0700
Message-ID: <CAOKbgA69m7_KbSS-pnEshd9Bp3JEz2QVTOkQ6u--zs5vZobArg@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring updates for 5.14-rc1
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 6, 2021 at 4:40 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> [ back looking at this from doing other merge window stuff ]
>
> On Sat, Jul 3, 2021 at 8:27 AM Dmitry Kadashev <dkadashev@gmail.com> wrote:
> >
> > This is how I originally thought it is going to be, but Al suggested
> > that it eats the name on the failure. Now that I spent slightly
> > more time with it I *suspect* the reason (or a part of it) is making it
> > keep the name on failure would require A LOT of changes, since a lot of
> > functions that __filename_create() calls eat the name on failure.
>
> Ok.
>
> Let's try to keep the changes minimal and simple.
>
> Your original approach with __filename_create() looks reasonable, if
> we then just clean up the end result by making putname() ok with an
> error pointer.
>
> The odd conditional putname() calls were the main issue that made me
> go "this is just very ugly and confusing"
>
> How do the patches end up looking with just that cleanup (and some
> clarifying comment about the very odd "out_putpath" case it had?)

OK, I'll send v7 of the series soon and will CC you.

Also, I've looked at the code again, and I think making
__filename_create() and friends not consume the name (even on error) is
not that much of extra work (but some existing code like
filename_parentat() has to be adjusted, so it's still not completely
trivial). I'll try to do that and will send RFC on top of this series,
so if it turns out to look better / be easier to reason about we can
just switch to that (in another release probably).

Thank you for your help, Linus!

--
Dmitry Kadashev
