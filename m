Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC89E32F648
	for <lists+io-uring@lfdr.de>; Sat,  6 Mar 2021 00:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbhCEXEL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Mar 2021 18:04:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhCEXEK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Mar 2021 18:04:10 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D603AC06175F
        for <io-uring@vger.kernel.org>; Fri,  5 Mar 2021 15:04:09 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id 18so6432241lff.6
        for <io-uring@vger.kernel.org>; Fri, 05 Mar 2021 15:04:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N/LkDNxO8O88KRPSPXME3KWCrGFBruZJ0x8spdMgVWo=;
        b=OW8mrF/FPschlqIKkB/F115ia/+L8r7gfMZi+TnS4C1K893jJeFMFy/q4Lwngj/ErX
         +shsPba4AVFAGQFaFZV5U3vaG9R3mgwkNrw6+zxnYLL6CG0NvOo9Q6M6nDaTzWdKEtTC
         ERWS73H40+PmlnzY6F/y0aOGe6Z08vSI7Y358=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N/LkDNxO8O88KRPSPXME3KWCrGFBruZJ0x8spdMgVWo=;
        b=j8YLgK573oK6JSsKVryKIzxzPG60gh4U2zKJLdpvVMbyNjG1c47/Kye9pZmHNm319s
         wSaeFW+LgKOXew/IoaSyb9iVz4dyBGNxJ3Fxii7Rb934CaV0xtU9oey/kXl79AUwnNEQ
         zWMra48RoybShvoiz09exIvrj7vWhFgllPTj7dp+7RPDB3Twnk0Y2dwSj6z8cz3GuSJ1
         n0r/wYPtE+oPCwp2PMO1Km5CrG3yNSXtDguoY0JlLrL9trCFrCFlX3v1bKz8m4MfKgim
         iB/YlLa/nV3jpdw/LhNj9/IkFKmEe/yg6uWQGRL8dOE1NbifBDIKZZXJwXRkCUVnjKKn
         LtLw==
X-Gm-Message-State: AOAM5324wcgwi1sRctPxs2yK7OSfaXd9vSf/PXRdJ3l3qmrbcsuIjUq2
        rkuqcVj+ggCFVAnsdBhEMQxINtp+3ym7cg==
X-Google-Smtp-Source: ABdhPJw+6mNLnE5WWeyzEyU5xFjlcUKu7LrULDoltUnj3PWP5Ero6dNbDZVo+47HMxO2sKLC5hPzlQ==
X-Received: by 2002:a05:6512:2026:: with SMTP id s6mr6729850lfs.43.1614985448094;
        Fri, 05 Mar 2021 15:04:08 -0800 (PST)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id h24sm485492lji.35.2021.03.05.15.04.06
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Mar 2021 15:04:07 -0800 (PST)
Received: by mail-lj1-f182.google.com with SMTP id t9so4901989ljt.8
        for <io-uring@vger.kernel.org>; Fri, 05 Mar 2021 15:04:06 -0800 (PST)
X-Received: by 2002:a05:651c:3c1:: with SMTP id f1mr6552083ljp.507.1614985445905;
 Fri, 05 Mar 2021 15:04:05 -0800 (PST)
MIME-Version: 1.0
References: <88ef6732-3800-a563-868d-8c1e5545c8fa@kernel.dk>
 <CAHk-=wjAASE-FhpGqrDoa-u5gktgW0=4q2V9+i7B93HTEf3cbg@mail.gmail.com> <7018071c-6f63-1e8c-3874-8ad643bad155@kernel.dk>
In-Reply-To: <7018071c-6f63-1e8c-3874-8ad643bad155@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 5 Mar 2021 15:03:50 -0800
X-Gmail-Original-Message-ID: <CAHk-=whjh_cow+gCQMCnS0NdxTqumtCgEDth+QLTjpYpOaOETQ@mail.gmail.com>
Message-ID: <CAHk-=whjh_cow+gCQMCnS0NdxTqumtCgEDth+QLTjpYpOaOETQ@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring fixes for 5.12-rc2
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Mar 5, 2021 at 1:58 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> But it pertains to the problem in general, which is how do we handle
> when the original task sets up a ring and then goes and does
> unshare(FILES) or whatever. It then submits a new request that just
> happens to go async, which is oblivious to this fact. Same thing that
> would happen in userspace if you created a thread pool and then did
> unshare, and then had your existing threads handle work for you. Except
> here it just kind of happens implicitly, and I can see how that would be
> confusing or even problematic.

Honestly, I'd aim for a "keep a cred per request".  And if that means
that then the async worker thread has to check that it matches the
cred it already has, then so be it.

Otherwise, you'll always have odd situations where "synchronous
completion gets different results than something that was kicked off
to an async thread".

But I don't think this has anything to do with unshare() per se. I
think this is a generic "hey, the process can change creds between
ring creation - and thread creation - and submission of an io_ring
command".

No? Or am I misunderstanding what you're thinking of?

        Linus
