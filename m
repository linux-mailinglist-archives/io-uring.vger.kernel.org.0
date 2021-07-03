Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D37E83BA93A
	for <lists+io-uring@lfdr.de>; Sat,  3 Jul 2021 17:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbhGCP3g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 3 Jul 2021 11:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbhGCP3g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 3 Jul 2021 11:29:36 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF5DC061762
        for <io-uring@vger.kernel.org>; Sat,  3 Jul 2021 08:27:02 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id m9so21450234ybo.5
        for <io-uring@vger.kernel.org>; Sat, 03 Jul 2021 08:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wzJEYxskqIOfF8aqxVK/KXSw7Uwopec39DS3Bre09aM=;
        b=e6DGhfsG8L1DOLEEy8W3DMrvxFu30810a7S/Io+rqqX1o4OfqdzhTXPP3IEAu22TBa
         gKoRzcZXZPtekHmg86MOhgpbSLLxRMYaERyp5rMRsKMlzAQ93GgIquyt0rJBcO70Hdpd
         +mkSdIRts4pD/InEjLcDWPCuBi9tHK5BpPu4ySmvqpNFjZFzAabVJSJYLcJyOxGCr6Rh
         EiIrxeOGtiGLSUtsfDH3pvauznI6l8PqE+TYLQd530nx9jZbd1VJQR57sB499qzA9t/u
         wS1Zw+PQfGTQXv3ZBu52uJM2gS6bv0kQILv/bZVSI59b+9LH9RGRBsfdiF/yP3UZhcFE
         HB2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wzJEYxskqIOfF8aqxVK/KXSw7Uwopec39DS3Bre09aM=;
        b=MbTLMjEwTuVhKKCbdJzb8ediSk22cPE30axpiAY6g5CXDUV3lsgg2i7FOroE6I/YX2
         XwP6cW+9lLs4cyP7Cy+mDbGS/9QCf6e+xOa7Y0yrMkLs1IPon+oYjOJ/f0n8qaR+iUIb
         Pp0ySX/SLnQ/NvMBxmoM0ub8XUAR7iKLguepWb4bGMh2+ycYqmOdRH3Lj/9Z2k5ydHn5
         41NMkAOcDYuRbdxsese7WJOok19PEu3NGM0SCQ4MskWexCHP+ZVNOLv6q1uG5gIXth42
         FLPlf+BwvBZuSzjfqL6F6XJsT52yK2wqtfqqrSthskcGC1lN1SKlLVLOb6eceY0rUW/N
         /Ddw==
X-Gm-Message-State: AOAM5338SijE8ORyxAt4x2HNALxvd+6q0hX8vZqye78bCzEzGTp+EW61
        zxe+6XBufAeslkKDFD6xsdqSE57FJlGIxSR/TgA=
X-Google-Smtp-Source: ABdhPJxzTLVHmjNF0HNdXhkC3tyAl/fkMzK/CrSQGhkCd9jC42A1RMJFijxBU086FIOBp5j6ayJAVvsKX3MnnpClu9Q=
X-Received: by 2002:a5b:405:: with SMTP id m5mr6059044ybp.311.1625326021423;
 Sat, 03 Jul 2021 08:27:01 -0700 (PDT)
MIME-Version: 1.0
References: <c9a79f27-02e9-b0d6-78ae-2e777eed8fe0@kernel.dk>
 <CAHk-=wgCac9hBsYzKMpHk0EbLgQaXR=OUAjHaBtaY+G8A9KhFg@mail.gmail.com>
 <CAOKbgA5iixR+QCuYyzb2UBQGVddQtp0ERKZrKHbrsyWug2yYbQ@mail.gmail.com> <CAHk-=wgye_GuQ5cBFC=UOPHkd0o8-Nrau7GNZHTZVuGO2tincw@mail.gmail.com>
In-Reply-To: <CAHk-=wgye_GuQ5cBFC=UOPHkd0o8-Nrau7GNZHTZVuGO2tincw@mail.gmail.com>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Sat, 3 Jul 2021 22:26:50 +0700
Message-ID: <CAOKbgA6x-qPK4jTmH4AO_GPy=tTRw1uMuD7wyiVFM7q0WQ5WbQ@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring updates for 5.14-rc1
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Jul 3, 2021 at 1:33 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I wonder if the semantics couldn't be that __filename_create() never
> eats the name, and filename_create() keeps the old semantics?

This is how I originally thought it is going to be, but Al suggested
that it eats the name on the failure. Now that I spent slightly
more time with it I *suspect* the reason (or a part of it) is making it
keep the name on failure would require A LOT of changes, since a lot of
functions that __filename_create() calls eat the name on failure.

How about we change the functions (__filename_create(),
__filename_lookup()) to do what filename_parentat() does since
5c31b6cedb675 ("namei: saner calling conventions for
filename_parentat()"), namely return struct filename *.

The nice thing here is we end up having the functions working the same
way, so it's much easier to reason about. In particular, all of the
functions seem to be expected to consume struct filename that was passed
to it. And it is going to be the same with these two new ones instead of
introducing a class of functions that do not do that.

The not-so-nice thing is for __filename_create we'd have to move struct
dentry to args. But as far as I can see there are quite a few "out" args
anyway, and struct path is an "out" arg already. So maybe it's not a big
deal. Maybe it is. Comments are welcome.

The code in question then will look like this:

    old = __filename_lookup(olddfd, old, how, &old_path, NULL);
    if (IS_ERR(old))
        goto out_putnames;

    new = __filename_create(newdfd, new, &new_path, &new_dentry,
                    (how & LOOKUP_REVAL));
    if (IS_ERR(new))
        goto out_putpath;

Thoughts?

-- 
Dmitry Kadashev
