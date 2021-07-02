Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 178443BA3FC
	for <lists+io-uring@lfdr.de>; Fri,  2 Jul 2021 20:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbhGBSg2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Jul 2021 14:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbhGBSg2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Jul 2021 14:36:28 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 933B2C061762
        for <io-uring@vger.kernel.org>; Fri,  2 Jul 2021 11:33:55 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id l18so990617ljb.10
        for <io-uring@vger.kernel.org>; Fri, 02 Jul 2021 11:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YkoIuA1X4Q9N3b4+wLQnjRwhmZhChGkm4G/ebDqvhyY=;
        b=Z/86VShsXohUL/FtzYpLA/5vC4Vv23YMNDj6ulaRVCefN6mTyjOsVSKzWXs2jS4dnx
         sLiKSR+MvnFPVYHAzar30gvP8GagajTeLgPVt3oiy8gm7Av7YPGDHZmjTMaLVD2zGWQz
         STsqchuW9Bjz5eAjh/mEcEbpHeabjkWUGfJ0c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YkoIuA1X4Q9N3b4+wLQnjRwhmZhChGkm4G/ebDqvhyY=;
        b=E7jVYHah5AklmflA3XUFePMnDEfn/RUFdBvjRsy5f9yyF+aCg83GsxxVZxOjw+E3KF
         xO9xWR6QEV1VeZopjTZ7EGLq1L4j3ccmskLJCTP2DNJHie6vA0FogdNn+032s/vJl9Dj
         9ZG/u5KTAKI9/Ys6vLrnXx4y9iOfu+cDV+jRIkaEDRy7pSlmugbPb6mGMZdWpz1VrrK0
         9l4a5olrbSPbE9ax6FH/f2YlkqibhOCWFyuX2n2N/ba1GZoLBJC+9mCTLF8MLEctkISu
         41AJzfCSRKfRpzbp808Dmw20pez2jHr21HdWa+1OzYn1N5KEV7dI/N1OhYLrg8dMhmYs
         uecA==
X-Gm-Message-State: AOAM530q8fz1ID8vT4QhesG2Cia/Kgg+FCtg7gHvre1PK0pr+kBudbRH
        IwHQ/eeekeS7Na4ojQjQrIOAdUPqGc9IBbMMfhA=
X-Google-Smtp-Source: ABdhPJxB7WTGmqTNrMUgGFwpe/XVK+yoNOAHHd+IJCNp2uGlbcvepYamYj2crwHXmPPVLE8chVl2aw==
X-Received: by 2002:a2e:8e26:: with SMTP id r6mr599864ljk.313.1625250833776;
        Fri, 02 Jul 2021 11:33:53 -0700 (PDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com. [209.85.167.52])
        by smtp.gmail.com with ESMTPSA id z24sm341922lfr.105.2021.07.02.11.33.52
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jul 2021 11:33:53 -0700 (PDT)
Received: by mail-lf1-f52.google.com with SMTP id a15so19674738lfr.6
        for <io-uring@vger.kernel.org>; Fri, 02 Jul 2021 11:33:52 -0700 (PDT)
X-Received: by 2002:a05:6512:557:: with SMTP id h23mr726753lfl.253.1625250832714;
 Fri, 02 Jul 2021 11:33:52 -0700 (PDT)
MIME-Version: 1.0
References: <c9a79f27-02e9-b0d6-78ae-2e777eed8fe0@kernel.dk>
 <CAHk-=wgCac9hBsYzKMpHk0EbLgQaXR=OUAjHaBtaY+G8A9KhFg@mail.gmail.com> <CAOKbgA5iixR+QCuYyzb2UBQGVddQtp0ERKZrKHbrsyWug2yYbQ@mail.gmail.com>
In-Reply-To: <CAOKbgA5iixR+QCuYyzb2UBQGVddQtp0ERKZrKHbrsyWug2yYbQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 2 Jul 2021 11:33:36 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgye_GuQ5cBFC=UOPHkd0o8-Nrau7GNZHTZVuGO2tincw@mail.gmail.com>
Message-ID: <CAHk-=wgye_GuQ5cBFC=UOPHkd0o8-Nrau7GNZHTZVuGO2tincw@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring updates for 5.14-rc1
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 2, 2021 at 4:32 AM Dmitry Kadashev <dkadashev@gmail.com> wrote:
>
> The problem is we have to keep the filenames around for retries on
> ESTALE. It's not consumed by __filename_create() on success. So it's not
> as simple as setting the name to NULL after calling __filename_create().

I wonder if the semantics couldn't be that __filename_create() never
eats the name, and filename_create() keeps the old semantics?

You kind of made it go halfway, with filename_create() eating it only
on success.

That would make the filename_create() wrapper much simpler too, ie
we'd have it be just

    struct dentry *res = __filename_create(dfd, name, path, lookup_flags);
    putname(name);
    return res;

so it would remove a lot of conditionals, and leave it to callers
whether they want to keep the name live or not.

But I didn't check all the other cases, so maybe that causes its own
set of inconveniences..

            Linus
