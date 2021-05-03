Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2253723B4
	for <lists+io-uring@lfdr.de>; Tue,  4 May 2021 01:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbhECXtW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 May 2021 19:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhECXtV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 May 2021 19:49:21 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F77C06174A
        for <io-uring@vger.kernel.org>; Mon,  3 May 2021 16:48:26 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id c3so6574692lfs.7
        for <io-uring@vger.kernel.org>; Mon, 03 May 2021 16:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8cxTD+RC9r0CXS9dr55V7a29XytNEKtivWFE6svy/UU=;
        b=KrSrP6H1kg0Ou7qIlA2hC/fEOBjjQfOdxSm1qFRBv7hG/LVf94xY1oTR/3v8qlxSNU
         Y5cJkh+yGLgafUhxEeFCJZpZ0CpYr0JoegHkOpGzvdxEaFsNlt8k0Dih/m8mzHTSjesG
         XgRhnzhg3g7Qy7Lf0CH85Q//wk+LxtHK1uwqw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8cxTD+RC9r0CXS9dr55V7a29XytNEKtivWFE6svy/UU=;
        b=JLdxxGM2nWhPr+CIlImGDxVwmRo4rk+dRySjQdVUt5lHPUISFFAqkiAtR7dw/oi/l6
         tzJPmPpr0ucGQzajqnxR5Bs0nTkpNoo9jgWpZKkNEQW+NWcPjt8THYBlYvc4wZe0MiQz
         cW3R6+rX5wDFJVriyiaNqUHMasTLJWs5H1DRxhaYIi6DnWJbvmYNMvt1ykr0XXma3Aqb
         1W+JFddGQsrE7m1TEDfbgb2flvqEuHCx9cEIkREhwgA4lL7UA4IokSLye04eSGpF6IWG
         pUGQNRZ+kezbv02ITrBb+TrXRZMjAU83n4Z6uDvswM+AkexNQjbSG9bRC/VzvfjXs8hV
         HZrg==
X-Gm-Message-State: AOAM532MDGAYrkkzNB/oV6EQdFkR+7m/gq9SvzY1uyAZXqC7cBHZK5Vg
        SnsDTXiJCKVWtjQ/z4d49An396AScEuiY0LC
X-Google-Smtp-Source: ABdhPJx/wlGjDXxXWjC4oqlahdm0Ctn9aAw3tWNXk2tMkulRWzM99hqHJJBcGGJcIOTFjqXBS8m3wQ==
X-Received: by 2002:ac2:5a01:: with SMTP id q1mr10897359lfn.148.1620085705084;
        Mon, 03 May 2021 16:48:25 -0700 (PDT)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com. [209.85.208.170])
        by smtp.gmail.com with ESMTPSA id r1sm46639ljj.21.2021.05.03.16.48.23
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 16:48:23 -0700 (PDT)
Received: by mail-lj1-f170.google.com with SMTP id b21so8913991ljf.11
        for <io-uring@vger.kernel.org>; Mon, 03 May 2021 16:48:23 -0700 (PDT)
X-Received: by 2002:a05:651c:3de:: with SMTP id f30mr344166ljp.251.1620085703543;
 Mon, 03 May 2021 16:48:23 -0700 (PDT)
MIME-Version: 1.0
References: <8735v3ex3h.ffs@nanos.tec.linutronix.de> <3C41339D-29A2-4AB1-958F-19DB0A92D8D7@amacapital.net>
 <CAHk-=wh0KoEZXPYMGkfkeVEerSCEF1AiCZSvz9TRrx=Kj74D+Q@mail.gmail.com>
 <CALCETrV9bCenqzzaW6Ra18tCvNP-my09decTjmLDVZZAQxR6VA@mail.gmail.com>
 <CAHk-=wgo6XEz3VQ9ntqzWLR3-hm1YXrXUz4_heDs4wcLe9NYvA@mail.gmail.com>
 <d26e3a82-8a2c-7354-d36b-cac945c208c7@kernel.dk> <CALCETrWmhquicE2C=G2Hmwfj4VNypXVxY-K3CWOkyMe9Edv88A@mail.gmail.com>
 <CAHk-=wgqK0qUskrzeWXmChErEm32UiOaUmynWdyrjAwNzkDKaw@mail.gmail.com>
 <8735v3jujv.ffs@nanos.tec.linutronix.de> <CAHk-=wi4Dyg_Z70J_hJbtFLPQDG+Zx3dP2jB5QrOdZC6W6j4Gw@mail.gmail.com>
 <12710fda-1732-ee55-9ac1-0df9882aa71b@samba.org>
In-Reply-To: <12710fda-1732-ee55-9ac1-0df9882aa71b@samba.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 3 May 2021 16:48:07 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiR7c-UHh_3Rj-EU8=AbURKchnMFJWW7=5EH=qEUDT8wg@mail.gmail.com>
Message-ID: <CAHk-=wiR7c-UHh_3Rj-EU8=AbURKchnMFJWW7=5EH=qEUDT8wg@mail.gmail.com>
Subject: Re: [PATCH] io_thread/x86: don't reset 'cs', 'ss', 'ds' and 'es'
 registers for io_threads
To:     Stefan Metzmacher <metze@samba.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, May 3, 2021 at 4:27 PM Stefan Metzmacher <metze@samba.org> wrote:
>
> If I remember correctly gdb showed bogus addresses for the backtraces of the io_threads,
> as some regs where not cleared.

Yeah, so that patch will make the IO thread have the user stack
pointer point to the original user stack, but that stack will
obviously be used by the original thread which means that it will
contain random stuff on it.

Doing a

        childregs->sp = 0;

is probably a good idea for that PF_IO_WORKER case, since it really
doesn't have - or need - a user stack.

Of course, it doesn't really have - or need - any of the other user
registers either, but once you fill in the segment stuff to make gdb
happy, you might as well fill it all in using the same code that the
regular case does.

          Linus
