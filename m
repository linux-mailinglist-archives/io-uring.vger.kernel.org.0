Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E9B3C9CFD
	for <lists+io-uring@lfdr.de>; Thu, 15 Jul 2021 12:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240540AbhGOKnC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jul 2021 06:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234408AbhGOKnC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jul 2021 06:43:02 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A723C06175F;
        Thu, 15 Jul 2021 03:40:08 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id c16so1539210ybl.9;
        Thu, 15 Jul 2021 03:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XG3h4fo+usH9EmMktD/MVE4ztOOycppY+Co84GyOUOs=;
        b=pdagtdKHmHOSIIiz1WwH+3wqqPHYPV0Q0Ee/e/jNgu80sS6WAtFPLUL1A8Aq8HCCQi
         gM809jZ8O8Z2r8Q8Va179b6E5XiCb4WeHX1Ftz6Lx2QcFItV4MnC57IVQjXRU4FNqcZ9
         q0o7bxWvpaPQ8e/hW9y+1nFYW4uoRWW1pnfJZk6b7+GYukeHlIg8hTBBUQRAg/NOjdVB
         h4rEp1b6J+deWB/Q894rOv5jNvHcxoUcvncv9SqCwQs5O2N26SbivoUP/ovSDv9NYlNK
         NdD8Ljr94IsaOmRm/NlNJg0G8jyt6v5k6wFrD0DNarsuFFpZ+hMfTCaoJI1ooSvJQRA7
         jzMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XG3h4fo+usH9EmMktD/MVE4ztOOycppY+Co84GyOUOs=;
        b=RelDFql38u5yF57qLezFG896ZOhHpcmrQxk76ttb2AFkyFfZg7yRKepeys33rYBJHP
         OdWNSDftddC35j3HArW0k3OPfoqmPjVW5JEpQsZcJNE9DC9AOHKcj85VYV8q0g3ZF01t
         2cM4lzWsrNK/97iXNe1lb5H9HbLXB8C8FycV8r7SB3ljQb4gG/HhKOD7o/POllzhaAFu
         waIxP3eR14+AOi0K6DuytFqih8VzLzlEjJQcoMoVSfD0MDFUqWf0X2tuzm4+Bi8HpFPN
         H1vxpxvllyhCxJ+xiImaTVoLPXyxtebuhJdqpMUPJDwxXDQoUSeO5E/W+psKIwH4lOdv
         371w==
X-Gm-Message-State: AOAM532P7SJ5ekcKwS542uLhyLefdSIHbuuZzIFBoG0plWEsWS8qdulF
        LF4tnpx+vJuH61YsH3bCDPlipHIuKqMN3tZD92g=
X-Google-Smtp-Source: ABdhPJxEHIIx8BepEw32LyWoQPJcI7+GIFEqWMvndEKeLI4Uq9PxLCOo3xnKzFhPG09tsGp8poJ6708ouz8Yp+V/zYE=
X-Received: by 2002:a25:e08a:: with SMTP id x132mr4560012ybg.511.1626345608000;
 Thu, 15 Jul 2021 03:40:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210715103600.3570667-1-dkadashev@gmail.com>
In-Reply-To: <20210715103600.3570667-1-dkadashev@gmail.com>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Thu, 15 Jul 2021 17:39:57 +0700
Message-ID: <CAOKbgA44oB5TXyT0GJbUYnXx80e0jFp=z3oR_ByuWqkeO-Q_=w@mail.gmail.com>
Subject: Re: [PATCH 00/14] namei: clean up retry logic in various do_* functions
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 15, 2021 at 5:36 PM Dmitry Kadashev <dkadashev@gmail.com> wrote:
>
> Suggested by Linus in https://lore.kernel.org/io-uring/CAHk-=wh=cpt_tQCirzFZRPawRpbuFTZ2MxNpXiyUF+eBXF=+sw@mail.gmail.com/
>
> This patchset does all the do_* functions one by one. The idea is to
> move the main logic to a helper function and handle stale retries /
> struct filename cleanups outside, which makes the logic easier to
> follow.
>
> There are a few minor changes in behavior:
>
> 1. filename_lookup() / filename_parentat() / filename_create() do their
> own retries on ESTALE (regardless of flags), and previously they were
> exempt from retries in the do_* functions (but they *were* called on
> retry - it's just the return code wasn't checked for ESTALE). And
> now the retry is done on the upper level, and so technically it could be
> called a behavior change. Hopefully it's an edge case where an
> additional check does not matter.
>
> 2. Some safety checks like may_mknod() / flags validation are now
> repeated on retry. Those are mostly trivial and retry is a slow path, so
> that should be OK.
>
> 3. retry_estale() is wrapped into unlikely() now
>
> On top of https://lore.kernel.org/io-uring/20210708063447.3556403-1-dkadashev@gmail.com/
>
> v2:
>
> - Split flow changes and code reorganization to different commits;
>
> - Move more checks into the new helpers, to avoid gotos in the touched
>   do_* functions completely;
>
> - Add unlikely() around retry_estale();
>
> - Name the new helper functions try_* instead of *_helper;
>
> Dmitry Kadashev (14):
>   namei: prepare do_rmdir for refactoring
>   namei: clean up do_rmdir retry logic
>   namei: prepare do_unlinkat for refactoring
>   namei: clean up do_unlinkat retry logic
>   namei: prepare do_mkdirat for refactoring
>   namei: clean up do_mkdirat retry logic
>   namei: prepare do_mknodat for refactoring
>   namei: clean up do_mknodat retry logic
>   namei: prepare do_symlinkat for refactoring
>   namei: clean up do_symlinkat retry logic
>   namei: prepare do_linkat for refactoring
>   namei: clean up do_linkat retry logic
>   namei: prepare do_renameat2 for refactoring
>   namei: clean up do_renameat2 retry logic
>
>  fs/namei.c | 252 +++++++++++++++++++++++++++++------------------------
>  1 file changed, 140 insertions(+), 112 deletions(-)

Ooops, the subject misses "v2", I'll resend.

-- 
Dmitry Kadashev
