Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C572733C954
	for <lists+io-uring@lfdr.de>; Mon, 15 Mar 2021 23:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbhCOWZh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Mar 2021 18:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbhCOWZa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Mar 2021 18:25:30 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23334C06174A
        for <io-uring@vger.kernel.org>; Mon, 15 Mar 2021 15:25:30 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id p8so68924732ejb.10
        for <io-uring@vger.kernel.org>; Mon, 15 Mar 2021 15:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JHuD9L12GwXv9CMjuewy7NJi4UEeZj8gMIMY0fXoMjo=;
        b=S+PBvkiNvoS7h8zAD5cjsSRJz4FVPn0bUbOW1vAx3cSOxv0XYlgWOMD63ht2EW+UvG
         WqRwvdt1hEocnp30SVofJDviTh5NFMlDuAZFdZ0CFQTPQzKAvpCn4FZXTYX5F2Q7x0TA
         w6hkZe/5rBy3BNMBjtwIU8r7P3WUEjnalDrr4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JHuD9L12GwXv9CMjuewy7NJi4UEeZj8gMIMY0fXoMjo=;
        b=hAEZLwXW9N5r8mnhx7yYEe4MWuhgMPI5ir6/Nqml1+/CUcvBB1sPw8Vih6Rv352KY+
         FQgUumZ4vCAUjfbbYA+ObT12fpfs0uXYnc7XHb18TAKYKBS2J/Xw4aAp6hL2ZRtzcGM/
         fu3n/UWpaJYyQuo9AZrRJMawcvKyNiDRKdZiM85rd1Q7N8NZrqHbkXkcqOWYnzRzH2Fq
         MJnVXKdxJeQPixAPJBBoIdThvD8mLVP1+basFVee2WmDlKyt39ydUANi238la0lMCMwa
         cknZQ1mwZNpQcVIpZa0CMHGPWJW7kHXzgjFrzRucfOG31usVCzFZuBJ/B11aBuUwfPvr
         yZBw==
X-Gm-Message-State: AOAM530P1wgZrbCzivy465iWpH8/q+J3YvAi1Eib8nolfNlob3AJCJDy
        OdtU4TfvMynAkbYV5qY+X5StHy3+ARd6nQ==
X-Google-Smtp-Source: ABdhPJwZhGCnbrw5quvN8IdrobM3QFPN0fjINFXEG6lUWuBcRSn5J4WVaxReg0X7tB8Cr32ZB2A0hA==
X-Received: by 2002:a17:906:cc89:: with SMTP id oq9mr25923195ejb.258.1615847128663;
        Mon, 15 Mar 2021 15:25:28 -0700 (PDT)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com. [209.85.221.54])
        by smtp.gmail.com with ESMTPSA id l10sm9025183edr.87.2021.03.15.15.25.28
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Mar 2021 15:25:28 -0700 (PDT)
Received: by mail-wr1-f54.google.com with SMTP id o16so6466735wrn.0
        for <io-uring@vger.kernel.org>; Mon, 15 Mar 2021 15:25:28 -0700 (PDT)
X-Received: by 2002:a2e:a589:: with SMTP id m9mr729361ljp.220.1615846773296;
 Mon, 15 Mar 2021 15:19:33 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1615372955.git.gladkov.alexey@gmail.com>
 <59ee3289194cd97d70085cce701bc494bfcb4fd2.1615372955.git.gladkov.alexey@gmail.com>
 <202103151426.ED27141@keescook>
In-Reply-To: <202103151426.ED27141@keescook>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 15 Mar 2021 15:19:17 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjYOCgM+mKzwTZwkDDg12DdYjFFkmoFKYLim7NFmR9HBg@mail.gmail.com>
Message-ID: <CAHk-=wjYOCgM+mKzwTZwkDDg12DdYjFFkmoFKYLim7NFmR9HBg@mail.gmail.com>
Subject: Re: [PATCH v8 3/8] Use atomic_t for ucounts reference counting
To:     Kees Cook <keescook@chromium.org>
Cc:     Alexey Gladkov <gladkov.alexey@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        Alexey Gladkov <legion@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Jann Horn <jannh@google.com>, Jens Axboe <axboe@kernel.dk>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Mar 15, 2021 at 3:03 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Wed, Mar 10, 2021 at 01:01:28PM +0100, Alexey Gladkov wrote:
> > The current implementation of the ucounts reference counter requires the
> > use of spin_lock. We're going to use get_ucounts() in more performance
> > critical areas like a handling of RLIMIT_SIGPENDING.
>
> This really looks like it should be refcount_t.

No.

refcount_t didn't have the capabilities required.

It just saturates, and doesn't have the "don't do this" case, which
the ucounts case *DOES* have.

In other words, refcount_t is entirely misdesigned for this - because
it's literally designed for "people can't handle overflow, so we warn
and saturate".

ucounts can never saturate, because they replace saturation with
"don't do that then".

In other words, ucounts work like the page counts do (which also don't
saturate, they just say "ok, you can't get a reference".

I know you are attached to refcounts, but really: they are not only
more expensive, THEY LITERALLY DO THE WRONG THING.

           Linus
