Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B838240A18D
	for <lists+io-uring@lfdr.de>; Tue, 14 Sep 2021 01:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241499AbhIMXYj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Sep 2021 19:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241102AbhIMXYi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Sep 2021 19:24:38 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EDBDC061760
        for <io-uring@vger.kernel.org>; Mon, 13 Sep 2021 16:23:22 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id i7so8329112lfr.13
        for <io-uring@vger.kernel.org>; Mon, 13 Sep 2021 16:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IJIDYZgKiygSSxYRNkxoNXbd0kWV7FZNitdhXxha1Po=;
        b=Y1Aryd99OOGEmuqWogyRK+T349nSzQP6P4/UX3uS7PMAcEJFbHvBDRIf5LR1Egenh2
         ol4VSWTmzAXA6COOrx71hc46fMhwRwKDuLow4/bqyzig2RHEELJ8juuZ9jYdMexSWcaU
         yGMwb0q80yIvlcaZCiZIihGOMNRtw3Xa4sDAE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IJIDYZgKiygSSxYRNkxoNXbd0kWV7FZNitdhXxha1Po=;
        b=YTFKuEqMPBd37Px4zIccRj23LNw68JICbPM7/yuD02+InBMmIitfWBVwrxh709S8Dy
         KwuHfQYEmVaoxysqkJ1xPiljUB6oKKfcwXZmLzQ5wysfu9zhrcvcT5ud+aeBcoAu9O+j
         5IB9s5kuwKErgbwU+Rc9PIQUWpwQHyKUtW442qVQpdoR7tQPD9cJMqwx28Onevxp5KVp
         QUPk7g7GCjolPYMuvpZJRdMn+evhLyEjo0CBPvdFf2Kd4NsZAJyJhpNB5/VN5ZqKRBKP
         whXFWhCDn199fidxvBXK7dnOiYzw+EfgxTzIxqA01r1yAVKKEtnsIXOosTR/2XscxU9n
         o6/A==
X-Gm-Message-State: AOAM533XR9oCz/o5RmIbpbFhGWvuLgi8Hbc+Gc27YbHVh5ThxgfKD1qz
        JlPErsK/+NfEBf/iM2pFw/3F545L4ym2qkARSlA=
X-Google-Smtp-Source: ABdhPJyLoACSPc174lve7aaFgsAu2Q8VR4OxbjG2Tg/XcHGbFu8zpwmV6JfCTfZQh6Z+vDnRwQWlvg==
X-Received: by 2002:a05:6512:689:: with SMTP id t9mr11019416lfe.359.1631575400420;
        Mon, 13 Sep 2021 16:23:20 -0700 (PDT)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com. [209.85.208.174])
        by smtp.gmail.com with ESMTPSA id h3sm98279lfu.3.2021.09.13.16.23.19
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 16:23:20 -0700 (PDT)
Received: by mail-lj1-f174.google.com with SMTP id r3so20208561ljc.4
        for <io-uring@vger.kernel.org>; Mon, 13 Sep 2021 16:23:19 -0700 (PDT)
X-Received: by 2002:a2e:96c7:: with SMTP id d7mr12780196ljj.191.1631575399749;
 Mon, 13 Sep 2021 16:23:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210910182536.685100-1-axboe@kernel.dk> <8a278aa1-81ed-72e0-dec7-b83997e5d801@kernel.dk>
In-Reply-To: <8a278aa1-81ed-72e0-dec7-b83997e5d801@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 13 Sep 2021 16:23:03 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj3Lu=mJ8L7iE0RQXGZVdoSMz6rnPmrWoVNJhTaObOqkA@mail.gmail.com>
Message-ID: <CAHk-=wj3Lu=mJ8L7iE0RQXGZVdoSMz6rnPmrWoVNJhTaObOqkA@mail.gmail.com>
Subject: Re: [PATCHSET 0/3] Add ability to save/restore iov_iter state
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Sep 13, 2021 at 3:43 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> Al, Linus, are you OK with this? I think we should get this in for 5.15.
> I didn't resend the whole series, just a v2 of patch 1/3 to fix that bvec
> vs iovec issue. Let me know if you want the while thing resent.

So I'm ok with the iov_iter side, but the io_uring side seems still
positively buggy, and very confused.

It also messes with the state in bad ways and has internal knowledge.
And some of it looks completely bogus.

For example, I see

        state->count -= ret;
        rw->bytes_done += ret;

and I go "that's BS". There's no way it's ok to start messing with the
byte count inside the state like that. That just means that the state
is now no longer the saved state, and it's some random garbage.

I also think that the "bytes_done += ret" is a big hint there: any
time you restore the iovec state, you should then forward it by
"bytes_done". But that's not what the code does.

Instead, it will now restore the iovec styate with the *wrong* number
of bytes remaining, but will start from the beginning of the iovec.

So I think the fs/io_uring.c use of this state buffer is completely wrong.

What *may* be the right thing to do is to

 (a) not mess with state->count

 (b) when you restore the state you always use

        iov_iter_restore(iter, state, bytes_done);

to actually restore the *correct* state.

Because modifying the iovec save state like that cannot be right, and
if it's right it's still too ugly and fragile for words. That save
state should be treated as a snapshot, not as a random buffer that you
can make arbitrary changes to.

See what I'm saying?

I'd like Al to take a look at the io_uring.c usage too, since this was
just my reaction from looking at that diff a bit more.

           Linus
