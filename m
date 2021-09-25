Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4C241851C
	for <lists+io-uring@lfdr.de>; Sun, 26 Sep 2021 01:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbhIYXHC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Sep 2021 19:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbhIYXHB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Sep 2021 19:07:01 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E61DC061570
        for <io-uring@vger.kernel.org>; Sat, 25 Sep 2021 16:05:26 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id g41so57414213lfv.1
        for <io-uring@vger.kernel.org>; Sat, 25 Sep 2021 16:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sbHnE2QDsXnmv6AMlFohUnXs++TcZ00pHfdCA+ql4Xs=;
        b=RNbEAHUh08JhCSlAgnolE9c89iW8+i3m5LVSHfnZSePEd25ZFyjBjBA0lnCaJfcOAw
         jfJb/qUjXua4ANXoYKW/7/6yqK6mM8yPMb1RyNi9NGHQlrOhuhxyNLbajhERBzrsUPAQ
         yjcsvy0hSxEr1kwKxST/HTIXAWtGFUxVTi3sU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sbHnE2QDsXnmv6AMlFohUnXs++TcZ00pHfdCA+ql4Xs=;
        b=NC5HiEg0uVAggvwEpfQNaL0oSP0ge3nYSY+0eOsu/VVGaNCLf/auZhcFvhxvWgXBPJ
         /ICLjx++W+RClYNLzIQtcUWwXL9Me7p1RpWHFZ/6qodB6gdq3qeFkjw7K+gF2YbLvqVg
         FCTlpT+6+mxUmqmGR6QJj+PsH4UBO1odw28fS0QaxV/Vx8eFuJGiOUfxHmFgSlve+zPg
         +CebV7RRIb6W8R6IwAESJlwRcSEOGmVh0Kt72KktYJkVou4YBlqNu7ZvsSVYMsG1tk1t
         zP9QKvM4k5ry6eiLVjBAv+dzpMsmZcLqEXT/2KMyM14NQyJHqc4Fdqu8jMsYkw/WxF3K
         Z3Tw==
X-Gm-Message-State: AOAM533SGy9yZJdfrAArPHK/xapdxbWEGqL4wduo9KCKirnNkaNQBssl
        hEjpjaD065OGwb59dGljujcxMsq2JFziXsDo
X-Google-Smtp-Source: ABdhPJz4pwf/fCnz/xIbmdLRbSdSySKpKRxt/ggdvwb+IvXJYxdikBJFEltjQhQhbl4LvRLv5OvjAQ==
X-Received: by 2002:ac2:4116:: with SMTP id b22mr17314209lfi.587.1632611124266;
        Sat, 25 Sep 2021 16:05:24 -0700 (PDT)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id u7sm1138067lft.79.2021.09.25.16.05.23
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Sep 2021 16:05:23 -0700 (PDT)
Received: by mail-lf1-f42.google.com with SMTP id m3so57776287lfu.2
        for <io-uring@vger.kernel.org>; Sat, 25 Sep 2021 16:05:23 -0700 (PDT)
X-Received: by 2002:a05:6512:12c4:: with SMTP id p4mr17254083lfg.280.1632611123353;
 Sat, 25 Sep 2021 16:05:23 -0700 (PDT)
MIME-Version: 1.0
References: <fb81a0f6-0a9d-6651-88bc-d22e589de0ee@kernel.dk>
In-Reply-To: <fb81a0f6-0a9d-6651-88bc-d22e589de0ee@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 25 Sep 2021 16:05:07 -0700
X-Gmail-Original-Message-ID: <CAHk-=whi3UxvY1C1LQNCO9d2xzX5A69qfzNGbBVGpRE_6gv=9Q@mail.gmail.com>
Message-ID: <CAHk-=whi3UxvY1C1LQNCO9d2xzX5A69qfzNGbBVGpRE_6gv=9Q@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring fixes for 5.15-rc3
To:     Jens Axboe <axboe@kernel.dk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Sep 25, 2021 at 1:32 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> - io-wq core dump exit fix (me)

Hmm.

That one strikes me as odd.

I get the feeling that if the io_uring thread needs to have that
signal_group_exit() test, something is wrong in signal-land.

It's basically a "fatal signal has been sent to another thread", and I
really get the feeling that "fatal_signal_pending()" should just be
modified to handle that case too.

Because what about a number of other situations where we have that
"killable" logic (ie "stop waiting for locks or IO if you're just
going to get killed anyway" - things like lock_page_killable() and
friends)

Adding Eric, Oleg and Al to the participants, so that somebody else can pipe up.

That piping up may quite possibly be to just tell me I'm being stupid,
and that this is just a result of some io_uring thread thing, and
nobody else has this problem.

It's commit 87c169665578 ("io-wq: ensure we exit if thread group is
exiting") in my tree.

Comments?

            Linus
