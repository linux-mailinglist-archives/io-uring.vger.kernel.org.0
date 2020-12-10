Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11A7B2D65B0
	for <lists+io-uring@lfdr.de>; Thu, 10 Dec 2020 19:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390284AbgLJS5J (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Dec 2020 13:57:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390799AbgLJS45 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Dec 2020 13:56:57 -0500
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5E0C0613CF
        for <io-uring@vger.kernel.org>; Thu, 10 Dec 2020 10:56:17 -0800 (PST)
Received: by mail-lj1-x244.google.com with SMTP id n11so3067162lji.5
        for <io-uring@vger.kernel.org>; Thu, 10 Dec 2020 10:56:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BhQhWVHS9WJ7RClXHrmMk9OlxviP3JR/Irk+gjc31gc=;
        b=W6qlnGM8IOaEbAQLPDYX4opICBemo1Pvp2vQqXdKZN63cwRm/l9uPsqayXYeCjJUR8
         hMMQnjzcZBnIMraD951VYQv8Y4mVhieZNxavaXLyCdxl1dmtMuFde4AguhqVwOFlX4y9
         r7+gvnBEA4cyhttfb60lQlOnSd0tgt8o+HX4E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BhQhWVHS9WJ7RClXHrmMk9OlxviP3JR/Irk+gjc31gc=;
        b=sT4fhN3JbIdDJ18+OC23hndqJMWaWWKhLVnr38z+sxPstNaIOEYWr8YWQge3e+PcYi
         VbJgdNHNpmazkFvOqJQjodNkCKw30sNVDLBP7KJIorh08cGLtykALaf14y7jPqdOx1p4
         y9auzrrJEp1gHNvpHdzzIrWAfpmT+bbgp6JGWen/M4Un5VBJEL7f7BkY70AD3QlJLge7
         nnj34HSYKysnHjcqoMnGFz/mpQsNt/2IL9UkSHStyb5WccCfIIDP4GCxzizMC5RkZpz5
         ODmGrxG69gUAGblulbUr2/O7vPwEglGzpihQsptJh8+eoRQcBVY5a2Oylhfz4/0BAsNE
         fprw==
X-Gm-Message-State: AOAM531rVHmw9Pb4xwk/jHM4ft+yD3BwXCjfgY4ryku0tLSHLd0YdMoC
        2pXrZ168fz4LXISgU8F4L2HSDsEiZwv2jQ==
X-Google-Smtp-Source: ABdhPJzFT+GaHd5QfXeyEnXA89/H7QI1bzjYcrxgPBEd0/3/HCn9e3N/+FWt3u5ZFEDYVAq9SmneWA==
X-Received: by 2002:a05:651c:101:: with SMTP id a1mr1321018ljb.277.1607626575616;
        Thu, 10 Dec 2020 10:56:15 -0800 (PST)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com. [209.85.208.177])
        by smtp.gmail.com with ESMTPSA id o3sm615531lfo.217.2020.12.10.10.56.14
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Dec 2020 10:56:14 -0800 (PST)
Received: by mail-lj1-f177.google.com with SMTP id f11so7943274ljn.2
        for <io-uring@vger.kernel.org>; Thu, 10 Dec 2020 10:56:14 -0800 (PST)
X-Received: by 2002:a2e:9b13:: with SMTP id u19mr3459663lji.48.1607626574116;
 Thu, 10 Dec 2020 10:56:14 -0800 (PST)
MIME-Version: 1.0
References: <6535286b-2532-dc86-3c6e-1b1e9bce358f@kernel.dk>
 <CAHk-=wjrayP=rOB+v+2eTP8micykkM76t=6vp-hyy+vWYkL8=A@mail.gmail.com>
 <4bcf3012-a4ad-ac2d-e70b-17f17441eea9@kernel.dk> <CAHk-=wimYoUtY4ygMNknkKZHqgYBZbkU4Koo5cE6ar8XjHkzGg@mail.gmail.com>
 <ad8db5d0-2fac-90b6-b9e4-746a52b8ac57@kernel.dk> <d7095e1d-0363-0aad-5c13-6d9bb189b2c8@kernel.dk>
 <CAHk-=wgyRpBW_NOCKpJ1rZGD9jVOX80EWqKwwZxFeief2Khotg@mail.gmail.com>
 <87f88614-3045-89bb-8051-b545f5b1180a@kernel.dk> <a522a422-92e3-6171-8a2e-76a5c7e21cfc@kernel.dk>
In-Reply-To: <a522a422-92e3-6171-8a2e-76a5c7e21cfc@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 10 Dec 2020 10:55:58 -0800
X-Gmail-Original-Message-ID: <CAHk-=wicKF87YsiQpdK0B26Mk3UhRNrBEcOv7h=ohFKLjRM4DQ@mail.gmail.com>
Message-ID: <CAHk-=wicKF87YsiQpdK0B26Mk3UhRNrBEcOv7h=ohFKLjRM4DQ@mail.gmail.com>
Subject: Re: namei.c LOOKUP_NONBLOCK (was "Re: [GIT PULL] io_uring fixes for 5.10-rc")
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Dec 10, 2020 at 9:32 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> Here's a potentially better attempt - basically we allow LOOKUP_NONBLOCK
> with LOOKUP_RCU, and if we end up dropping LOOKUP_RCU, then we generally
> return -EAGAIN if LOOKUP_NONBLOCK is set as we can no longer guarantee
> that we won't block.

Looks sane to me.

I don't love the "__unlazy_walk vs unlazy_walk" naming - I think it
needs to be more clear about what the difference is, but I think the
basic patch looks sane, and looks about as big as I would have
expected it to be.

But yes, I'll leave it to Al.

And if we do this - and I think we should - I'd also love to see a new
flag in 'struct open_how' to openat2(), even if it's only to enable
tests. RESOLVE_NONBLOCK?

               Linus
