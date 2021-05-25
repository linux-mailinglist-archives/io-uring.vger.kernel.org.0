Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12D78390A6C
	for <lists+io-uring@lfdr.de>; Tue, 25 May 2021 22:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233182AbhEYUZb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 May 2021 16:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232744AbhEYUZa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 May 2021 16:25:30 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63BF6C061756
        for <io-uring@vger.kernel.org>; Tue, 25 May 2021 13:23:59 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id o8so39929576ljp.0
        for <io-uring@vger.kernel.org>; Tue, 25 May 2021 13:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hj6Q582YLSyCLF0bnaerXxki+Pd33TZxYnZYraN74n4=;
        b=TnoK4xpXhETtWOipxAfkDY7xnLfXT0gia75k9ZmZywXVjOgGc0J/k3EO98XDyldCR6
         mzyFCfuCIxdpqJ3tuAfdR9ieAxsWs4ecGpBxIH4fK5glh/G/Ezx78utwePLlMDxRkjJA
         fBhkAcKsA248MrkdVA84JGLbR4TOj/3J1u1IM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hj6Q582YLSyCLF0bnaerXxki+Pd33TZxYnZYraN74n4=;
        b=OrNtXSshQCyc/m8RAf2/28nDCDlopOPmPy+dcfesWzZaVoKL5udxfSn8k8ZmrDjtr+
         f1baJRX6Su7Qprp5tNBTtInwab7/jMRg10y1AvQFosZX2cwA5tBE1UcuR1/P3Zp0M3+O
         Y26V11qnU7M22kwia7xNEagJkJdZgPesqrhq0UVhBSJYZrfQEotMX5ZPF+XaCULSXsya
         ZtI6Y9Fkz41ubDOIXyqmiBtxGKJDLVJRYZGr6IGA+z/4UtQCXB6IhR8kY1YXBpqKGD5M
         fBVJ3aWC5ZsowZDQdS6BS1RST/qCk1gyAbxs1wt8nRR90ImYjXMupJm62tYu+7rn3GNK
         PIKg==
X-Gm-Message-State: AOAM532kFF7U8BpxAmWbcUJZuXJt2MbNXlJL3VC+TsADVIqDfahj1G97
        Y24xSuv60BFArRNirZnJ2gMF87tKZtCBhjzRJ1s=
X-Google-Smtp-Source: ABdhPJyHmI4vwHTbPJSKh3B6Ix3AbBTBU1zXjzIgsQVbFQFQSS4ZfqdiABbz1xXmqI19LpdVB43tXg==
X-Received: by 2002:a2e:b819:: with SMTP id u25mr21496984ljo.182.1621974237342;
        Tue, 25 May 2021 13:23:57 -0700 (PDT)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com. [209.85.208.178])
        by smtp.gmail.com with ESMTPSA id h16sm2194178ljb.128.2021.05.25.13.23.56
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 May 2021 13:23:56 -0700 (PDT)
Received: by mail-lj1-f178.google.com with SMTP id w7so26490667lji.6
        for <io-uring@vger.kernel.org>; Tue, 25 May 2021 13:23:56 -0700 (PDT)
X-Received: by 2002:a05:651c:8f:: with SMTP id 15mr23160163ljq.220.1621974235838;
 Tue, 25 May 2021 13:23:55 -0700 (PDT)
MIME-Version: 1.0
References: <8735v3ex3h.ffs@nanos.tec.linutronix.de> <3C41339D-29A2-4AB1-958F-19DB0A92D8D7@amacapital.net>
 <CAHk-=wh0KoEZXPYMGkfkeVEerSCEF1AiCZSvz9TRrx=Kj74D+Q@mail.gmail.com>
 <CALCETrV9bCenqzzaW6Ra18tCvNP-my09decTjmLDVZZAQxR6VA@mail.gmail.com>
 <CAHk-=wgo6XEz3VQ9ntqzWLR3-hm1YXrXUz4_heDs4wcLe9NYvA@mail.gmail.com>
 <d26e3a82-8a2c-7354-d36b-cac945c208c7@kernel.dk> <CALCETrWmhquicE2C=G2Hmwfj4VNypXVxY-K3CWOkyMe9Edv88A@mail.gmail.com>
 <CAHk-=wgqK0qUskrzeWXmChErEm32UiOaUmynWdyrjAwNzkDKaw@mail.gmail.com>
 <8735v3jujv.ffs@nanos.tec.linutronix.de> <CAHk-=wi4Dyg_Z70J_hJbtFLPQDG+Zx3dP2jB5QrOdZC6W6j4Gw@mail.gmail.com>
 <12710fda-1732-ee55-9ac1-0df9882aa71b@samba.org> <CAHk-=wiR7c-UHh_3Rj-EU8=AbURKchnMFJWW7=5EH=qEUDT8wg@mail.gmail.com>
 <59ea3b5a-d7b3-b62e-cc83-1f32a83c4ac2@kernel.dk> <17471c9fec18765449ef3a5a4cddc23561b97f52.camel@trillion01.com>
 <CAHk-=whoJCocFsQ7+Sqq=dkuzHE+RXxvRdd4ZvyYqnsKBqsKAA@mail.gmail.com>
 <3df541c3-728c-c63d-eaeb-a4c382e01f0b@kernel.dk> <b360ed542526da0a510988ce30545f429a7da000.camel@trillion01.com>
 <4390e9fb839ebc0581083fc4fa7a82606432c0c0.camel@trillion01.com> <d9a12052074ba194fe0764c932603a5f85c5445a.camel@trillion01.com>
In-Reply-To: <d9a12052074ba194fe0764c932603a5f85c5445a.camel@trillion01.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 25 May 2021 10:23:39 -1000
X-Gmail-Original-Message-ID: <CAHk-=whZZ-g6qJ1Epox6c-_U-jSs+syA_7a8QKQkxZaudXXR_Q@mail.gmail.com>
Message-ID: <CAHk-=whZZ-g6qJ1Epox6c-_U-jSs+syA_7a8QKQkxZaudXXR_Q@mail.gmail.com>
Subject: Re: [PATCH] io_thread/x86: don't reset 'cs', 'ss', 'ds' and 'es'
 registers for io_threads
To:     Olivier Langlois <olivier@trillion01.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Stefan Metzmacher <metze@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, May 25, 2021 at 9:40 AM Olivier Langlois <olivier@trillion01.com> wrote:
>
> If I look in the create_io_thread() function, I can see that CLONE_VM
> isn't set...

That would indeed be horribly buggy, but I'm not seeing it:

                .flags          = ((lower_32_bits(flags) | CLONE_VM |
                                    CLONE_UNTRACED) & ~CSIGNAL),

Yeah, it has that odd "first create 'flags' without the CLONE_VM, but
that is only used for that

        lower_32_bits(flags)

thing, and then we explicitly add CLONE_VM in there in the actual
kernel_clone_args.

It's because of how 'kernel_thread()' is written (that has historical
reasons), and the oddity is copied from there.

           Linus
