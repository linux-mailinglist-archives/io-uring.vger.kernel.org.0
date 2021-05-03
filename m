Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF9C0372388
	for <lists+io-uring@lfdr.de>; Tue,  4 May 2021 01:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbhECXUu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 May 2021 19:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbhECXUt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 May 2021 19:20:49 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F8FBC06174A
        for <io-uring@vger.kernel.org>; Mon,  3 May 2021 16:19:54 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id p12so8923642ljg.1
        for <io-uring@vger.kernel.org>; Mon, 03 May 2021 16:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0FtWWY4fmD6WRB9NPPZH54mCyUXdEKHNKiJkPNTthSs=;
        b=YTSJyNPsF4SuX8si33iysNtNVQ17vvy6CH1XN0+xVLJ4Am0L24sPQWs+u7O32+eW4b
         KVy+tXKv0wu0UENmRhWTAUxvGV37YYlqLH2LJm6MeIC6OE4qJYMWgCFuZCaXe5EE0R8F
         e90GPaqDfOXzM2vnc3ipJnsj/C4n713z4wWiM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0FtWWY4fmD6WRB9NPPZH54mCyUXdEKHNKiJkPNTthSs=;
        b=TMNqdi7S09iBmeG1z0BX3eDLcvaAbjlpIe+/rG2mmQsvu9t5o5bk+Nj6AusSBEUB0K
         sEOcVcbrTZ5oy/EuKQhkxOI6rbBZTigopTptCjD0D+pMB4qpGTVFxyfxATseDY3ZT5UU
         PAhEd+XqkUSECzyIKgphVDTKp6fz6YAHBXcmXqm5rMy5R2firmwOD7FO9DdgtUIudejJ
         eC/aeV4rwX1QUYLxI+tk0Kozv1x1vKA+D1/CEvYksNwWLTfA1gmGcLocAt0B0RICg8yn
         3FdJTObECka3m57x1becK/xNoK31YImYMZL68MvTLRyy1zulSfOTgq22B+M1gasQY7OF
         5aGA==
X-Gm-Message-State: AOAM5328zVF+9aj/t2qn3xB6Mebr7VqVbY7aqasMBurW4bMRTLgYQMqh
        gJspCSCKWxtgGVRJD5oQxmNwk1A/aNIUjM1/
X-Google-Smtp-Source: ABdhPJw66fswAha8ptQTPwcvw24f9bqHxKC+Cxk6uxPADC2dPRwhtVygMVvngNPyBqTPgeFhLfeuhg==
X-Received: by 2002:a2e:154e:: with SMTP id 14mr15340531ljv.217.1620083992865;
        Mon, 03 May 2021 16:19:52 -0700 (PDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id z23sm88592lfq.241.2021.05.03.16.19.51
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 16:19:51 -0700 (PDT)
Received: by mail-lf1-f41.google.com with SMTP id h4so2911231lfv.0
        for <io-uring@vger.kernel.org>; Mon, 03 May 2021 16:19:51 -0700 (PDT)
X-Received: by 2002:ac2:5f92:: with SMTP id r18mr15048326lfe.253.1620083991473;
 Mon, 03 May 2021 16:19:51 -0700 (PDT)
MIME-Version: 1.0
References: <8735v3ex3h.ffs@nanos.tec.linutronix.de> <3C41339D-29A2-4AB1-958F-19DB0A92D8D7@amacapital.net>
 <CAHk-=wh0KoEZXPYMGkfkeVEerSCEF1AiCZSvz9TRrx=Kj74D+Q@mail.gmail.com>
 <CALCETrV9bCenqzzaW6Ra18tCvNP-my09decTjmLDVZZAQxR6VA@mail.gmail.com>
 <CAHk-=wgo6XEz3VQ9ntqzWLR3-hm1YXrXUz4_heDs4wcLe9NYvA@mail.gmail.com>
 <d26e3a82-8a2c-7354-d36b-cac945c208c7@kernel.dk> <CALCETrWmhquicE2C=G2Hmwfj4VNypXVxY-K3CWOkyMe9Edv88A@mail.gmail.com>
 <CAHk-=wgqK0qUskrzeWXmChErEm32UiOaUmynWdyrjAwNzkDKaw@mail.gmail.com>
 <8735v3jujv.ffs@nanos.tec.linutronix.de> <CAHk-=wi4Dyg_Z70J_hJbtFLPQDG+Zx3dP2jB5QrOdZC6W6j4Gw@mail.gmail.com>
In-Reply-To: <CAHk-=wi4Dyg_Z70J_hJbtFLPQDG+Zx3dP2jB5QrOdZC6W6j4Gw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 3 May 2021 16:19:35 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj+njBWpgFqueHMVk1U8-APxZsgRsrOvhybcBEjspzGSg@mail.gmail.com>
Message-ID: <CAHk-=wj+njBWpgFqueHMVk1U8-APxZsgRsrOvhybcBEjspzGSg@mail.gmail.com>
Subject: Re: [PATCH] io_thread/x86: don't reset 'cs', 'ss', 'ds' and 'es'
 registers for io_threads
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Andy Lutomirski <luto@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Stefan Metzmacher <metze@samba.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, May 3, 2021 at 4:16 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> These days they really are fully regular user threads, they just don't
> return to user space because they continue to do the IO work that they
> were created for.

IOW, you should think of them as "io_uring does an interface clone()
to generate an async thread, it does the work and then exits".

Now, that's the conceptual thing - in reality one thread can do
multiple async things - but it's the mental image you should have.

Don't think of them as kernel threads. Yes, that's how it started, but
that really ended up being very very painful indeed.

            Linus
