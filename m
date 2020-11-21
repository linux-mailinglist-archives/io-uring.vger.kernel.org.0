Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A66F32BC155
	for <lists+io-uring@lfdr.de>; Sat, 21 Nov 2020 19:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727311AbgKUSHg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Nov 2020 13:07:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727181AbgKUSHg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Nov 2020 13:07:36 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D698DC0613CF
        for <io-uring@vger.kernel.org>; Sat, 21 Nov 2020 10:07:35 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id d20so2199892lfe.11
        for <io-uring@vger.kernel.org>; Sat, 21 Nov 2020 10:07:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vbDKuZb+4Xb0jnFLMLI8Wgp1RRr72QWDPW82I4gNVQ8=;
        b=EOxOPwqq1GcYc9TUwp2yv+S/40fBT3XQ6H4HT/ScAtNnRpMAsn/+yLf4uXUS8tYg/A
         KtUZ3nka7qWypTUKfVYmU7PlM6lJaw733/dbOueSWHEUqI8+yImVfzbF/XURUEqf/NnS
         EN7t2k+XkIuK+a6+4jG/PtOBQjpYB7DAMlI+w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vbDKuZb+4Xb0jnFLMLI8Wgp1RRr72QWDPW82I4gNVQ8=;
        b=hAQtLHUK0s7t679xxraAJ66uqMYiZHM+PQKXxYbuliMRsk0r7pUq3/ApX+e4rIU+83
         epBqdpnwHCjVuKRmDoDArYWdp/jp5ZUo8UIbUH+SAYGIultmVlb9yUkyg1iOUntB+5qN
         vXCCIeI7Ca6Bd4SdEGRfg4TuRvxHL3i/Z/TJEsshIdY1l7jL1HrQ7Fo0booQnR/hw2RD
         enUJud0MBUMIOPPsSQpziMlENTkIlv9Myt0juI+1oww9P7iIUyYSB6NeP8V4lZdTIo0g
         6I87TszBYJk4YyOc1qr6ywyLnHPeYH1jxkFPluvGw7qDL9/wwQgxlF5G4bS+/vFdVnCV
         xLMA==
X-Gm-Message-State: AOAM532h+yDME7MsRCetMNaCjQFjE4cdxXRnhZ7WijCB+3BsoNAaGuAx
        t4TtkSkOv9rD/h9HJrJam97f259tLt1DJA==
X-Google-Smtp-Source: ABdhPJxTzJpXyHip6BO4q20y5cJr6YcQYlpUbMlYlnAR90epINnK3aO/KQQN8KjkYYne50F1T0OnWA==
X-Received: by 2002:a05:6512:3054:: with SMTP id b20mr10527479lfb.130.1605982053894;
        Sat, 21 Nov 2020 10:07:33 -0800 (PST)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com. [209.85.208.171])
        by smtp.gmail.com with ESMTPSA id o4sm779361lfo.229.2020.11.21.10.07.32
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Nov 2020 10:07:32 -0800 (PST)
Received: by mail-lj1-f171.google.com with SMTP id o24so13515867ljj.6
        for <io-uring@vger.kernel.org>; Sat, 21 Nov 2020 10:07:32 -0800 (PST)
X-Received: by 2002:a05:651c:2cb:: with SMTP id f11mr9706686ljo.371.1605982052487;
 Sat, 21 Nov 2020 10:07:32 -0800 (PST)
MIME-Version: 1.0
References: <6535286b-2532-dc86-3c6e-1b1e9bce358f@kernel.dk>
 <CAHk-=wjrayP=rOB+v+2eTP8micykkM76t=6vp-hyy+vWYkL8=A@mail.gmail.com>
 <4bcf3012-a4ad-ac2d-e70b-17f17441eea9@kernel.dk> <CAHk-=wimYoUtY4ygMNknkKZHqgYBZbkU4Koo5cE6ar8XjHkzGg@mail.gmail.com>
 <ad8db5d0-2fac-90b6-b9e4-746a52b8ac57@kernel.dk> <d7095e1d-0363-0aad-5c13-6d9bb189b2c8@kernel.dk>
In-Reply-To: <d7095e1d-0363-0aad-5c13-6d9bb189b2c8@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 21 Nov 2020 10:07:16 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgyRpBW_NOCKpJ1rZGD9jVOX80EWqKwwZxFeief2Khotg@mail.gmail.com>
Message-ID: <CAHk-=wgyRpBW_NOCKpJ1rZGD9jVOX80EWqKwwZxFeief2Khotg@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring fixes for 5.10-rc
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Nov 20, 2020 at 7:00 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> Actually, I think we can do even better. How about just having
> do_filp_open() exit after LOOKUP_RCU fails, if LOOKUP_RCU was already
> set in the lookup flags? Then we don't need to change much else, and
> most of it falls out naturally.

So I was thinking doing the RCU lookup unconditionally, and then doing
the nn-RCU lookup if that fails afterwards.

But your patch looks good to me.

Except for the issue you noticed.

> Except it seems that should work, except LOOKUP_RCU does not guarantee
> that we're not going to do IO:

Well, almost nothing guarantees lack of IO, since allocations etc can
still block, but..

> [   20.463195]  schedule+0x5f/0xd0
> [   20.463444]  io_schedule+0x45/0x70
> [   20.463712]  bit_wait_io+0x11/0x50
> [   20.463981]  __wait_on_bit+0x2c/0x90
> [   20.464264]  out_of_line_wait_on_bit+0x86/0x90
> [   20.464611]  ? var_wake_function+0x30/0x30
> [   20.464932]  __ext4_find_entry+0x2b5/0x410
> [   20.465254]  ? d_alloc_parallel+0x241/0x4e0
> [   20.465581]  ext4_lookup+0x51/0x1b0
> [   20.465855]  ? __d_lookup+0x77/0x120
> [   20.466136]  path_openat+0x4e8/0xe40
> [   20.466417]  do_filp_open+0x79/0x100

Hmm. Is this perhaps an O_CREAT case? I think we only do the dcache
lookups under RCU, not the final path component creation.

And there are probably lots of other situations where we finish with
LOOKUP_RCU (with unlazy_walk()), and then continue.

Example: look at "may_lookup()" - if inode_permission() says "I can't
do this without blocking" the logic actually just tries to validate
the current state (that "unlazy_walk()" thing), and then continue
without RCU.

It obviously hasn't been about lockless semantics, it's been about
really being lockless. So LOOKUP_RCU has been a "try to do this
locklessly" rather than "you cannot take any locks".

I guess we would have to add a LOOKUP_NOBLOCK thing to actually then
say "if the RCU lookup fails, return -EAGAIN".

That's probably not a huge undertaking, but yeah, I didn't think of
it. I think this is a "we need to have Al tell us if it's reasonable".

                Linus
