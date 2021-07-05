Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929E53BC3BD
	for <lists+io-uring@lfdr.de>; Mon,  5 Jul 2021 23:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbhGEVnM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Jul 2021 17:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbhGEVnL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Jul 2021 17:43:11 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E8AFC061574
        for <io-uring@vger.kernel.org>; Mon,  5 Jul 2021 14:40:34 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id r26so17154600lfp.2
        for <io-uring@vger.kernel.org>; Mon, 05 Jul 2021 14:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BjoAAwTnNum/0nCy5YDXV5m/FjL9PzrqqQVA0UtrjTk=;
        b=CvioH+4nfOmvfd+dy8MKujYi/Y33MY0ZlhS1rpZdolMn5UZrvLNAhHhZclr/e6ASGT
         hFUHKAZGWjTUdqJJB8nMWLphxxlAAo437ZpR4zBeJE8KeK4YGi21azRazo1Wl5e9sRFO
         PSSlbyXpshCP3EmARHzz1qUnubC3vNDolT1LY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BjoAAwTnNum/0nCy5YDXV5m/FjL9PzrqqQVA0UtrjTk=;
        b=Ts8BC6DXvIMTExw43vFS1RMIMFUk0PayjxYaM6eH32BWNmllimZ9NINb1OlNySgTO2
         SLVy0YKW3G2RfJpSu1mhuyZaiKwbjJ1dw76HEyRY5mozO9Y2cpHJMWkVZqmVRwPqcvXT
         PmBZy7LAhI3oFtDgTfhK5H5rB8Vlb8DYd1Xe4RnyrxPKDrIGNrc7kB+kcnfMpn0V3DVG
         ob+XRaIHT+3o3NZ3FMGVpmhjnC9WmqCygbKZjXw8Iu70ZoZD8H4Ndzpm+6RzZLuKuISS
         mKvWeAwA9wKvfn8pfYQ51SuSkfwUEkTscwqoHnaK0rXPdyFvl77thD3V/QzoBelkMzMm
         OXpw==
X-Gm-Message-State: AOAM533/ZEAO0CjK3t9T3K+5G7SKRsFrAxYrNLZDoqGedZ5A2w3tXOsn
        uvshhD9QZuhAClQ0PjZ7cZEr16Hilwys4s1o
X-Google-Smtp-Source: ABdhPJw+jpuAmiaz4DBXUAePaIT+Nk/EwoJM/llzBKS2Nh2ljll7JYM4unburQnuoPrB4nrizRLbPQ==
X-Received: by 2002:ac2:48a2:: with SMTP id u2mr11859016lfg.15.1625521232321;
        Mon, 05 Jul 2021 14:40:32 -0700 (PDT)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com. [209.85.167.44])
        by smtp.gmail.com with ESMTPSA id k21sm1465196lji.107.2021.07.05.14.40.31
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jul 2021 14:40:31 -0700 (PDT)
Received: by mail-lf1-f44.google.com with SMTP id r26so17154537lfp.2
        for <io-uring@vger.kernel.org>; Mon, 05 Jul 2021 14:40:31 -0700 (PDT)
X-Received: by 2002:a19:7d04:: with SMTP id y4mr11716122lfc.201.1625521231324;
 Mon, 05 Jul 2021 14:40:31 -0700 (PDT)
MIME-Version: 1.0
References: <c9a79f27-02e9-b0d6-78ae-2e777eed8fe0@kernel.dk>
 <CAHk-=wgCac9hBsYzKMpHk0EbLgQaXR=OUAjHaBtaY+G8A9KhFg@mail.gmail.com>
 <CAOKbgA5iixR+QCuYyzb2UBQGVddQtp0ERKZrKHbrsyWug2yYbQ@mail.gmail.com>
 <CAHk-=wgye_GuQ5cBFC=UOPHkd0o8-Nrau7GNZHTZVuGO2tincw@mail.gmail.com> <CAOKbgA6x-qPK4jTmH4AO_GPy=tTRw1uMuD7wyiVFM7q0WQ5WbQ@mail.gmail.com>
In-Reply-To: <CAOKbgA6x-qPK4jTmH4AO_GPy=tTRw1uMuD7wyiVFM7q0WQ5WbQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 5 Jul 2021 14:40:15 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgjvUoOtggcVb7HRAhy2=LfG1+oKrjg5MZh+bSrKDzyAA@mail.gmail.com>
Message-ID: <CAHk-=wgjvUoOtggcVb7HRAhy2=LfG1+oKrjg5MZh+bSrKDzyAA@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring updates for 5.14-rc1
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

[ back looking at this from doing other merge window stuff ]

On Sat, Jul 3, 2021 at 8:27 AM Dmitry Kadashev <dkadashev@gmail.com> wrote:
>
> This is how I originally thought it is going to be, but Al suggested
> that it eats the name on the failure. Now that I spent slightly
> more time with it I *suspect* the reason (or a part of it) is making it
> keep the name on failure would require A LOT of changes, since a lot of
> functions that __filename_create() calls eat the name on failure.

Ok.

Let's try to keep the changes minimal and simple.

Your original approach with __filename_create() looks reasonable, if
we then just clean up the end result by making putname() ok with an
error pointer.

The odd conditional putname() calls were the main issue that made me
go "this is just very ugly and confusing"

How do the patches end up looking with just that cleanup (and some
clarifying comment about the very odd "out_putpath" case it had?)

               Linus
