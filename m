Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E239C266A7A
	for <lists+io-uring@lfdr.de>; Fri, 11 Sep 2020 23:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725880AbgIKV6N (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Sep 2020 17:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbgIKV6M (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Sep 2020 17:58:12 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75F5C061573
        for <io-uring@vger.kernel.org>; Fri, 11 Sep 2020 14:58:11 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id n13so11612924edo.10
        for <io-uring@vger.kernel.org>; Fri, 11 Sep 2020 14:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JWCcoFgO4vO+pjrZ6o0mM8b4O9fIV0HjL970JYM9ShI=;
        b=ihVI5QeE0m1B4FSqpLld5Ydju8/EE8lA9X2NKcgGMKacQThvRZ14Dwmy5tOS249Dau
         ihYG2SKfkKhTmz0IklcNgHEd1L3TEDA0jaEaOC4xKvOhB/nXBO99BWlSVyVpNUrqXCZ2
         o6y9njgBFBBOi9GUFmpIJQXVpq6VVxOrxjRd1E54fBVuQZRgZrytEvwdnZc4mjTWvpLN
         yC1xybeMsX6/xO+Ihq29xHKiQBuFWadrFZeNSwuTIa8YVqGv5ZdE0cmI48CP/mGiB+ZU
         6xpRyAMAgIcot0X+UCR3f09hffdC/I+C8MSbeM+x14t1n9+dhd+e5Q7PsUdRsfzTkEvW
         MpRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JWCcoFgO4vO+pjrZ6o0mM8b4O9fIV0HjL970JYM9ShI=;
        b=WEV29AVzkXdFpO5KhliNNfIw+Zp9wE2ExNfL1LIMb3b3GPgolzyhUi+wfwRO21FDrx
         SCdoZ5VZ3aCIT9MXH8kihhlDeMx21Qhl4jKyz7vg8rzjVqeBuydKXsDu2j+w7fBxWLBi
         Y/noL3WW2h9TT8mZnV7i2f/9WzdXowBGbDkt8C5pF1qWxWT5FEodYE0u8s+h3hB/dNCo
         Pp2SF2oaooh+yFBRwztPS7c6zYOeth3NZKLLWMf86DjluHujPG0pVHd/z5YL/a4/LGI9
         KuNefnOfiWxpA2Gv0o0PZzGAKJCHVURhqV9PXmNGpArNN8EPOLE1ZMGKXMmUPTHV1Ib3
         xaTA==
X-Gm-Message-State: AOAM530N6fHtG/MrW351dflVaZW7l0fhVaiOMBNASJukUQeUoaarJT8u
        DkeRlbWmrr0NNyfdJwVPqhdQ5y5TJJ+QiyTzBEtyqA==
X-Google-Smtp-Source: ABdhPJwFVwEl3LL/OSR2GRpliTAtJjrtSmn8o8ct+2ks1UJUWisnPu3LVPbbEOwIgYeaEU3zOzzR45w9SZZ6MfWnBX0=
X-Received: by 2002:a05:6402:176c:: with SMTP id da12mr4818246edb.386.1599861490298;
 Fri, 11 Sep 2020 14:58:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200911212625.630477-1-axboe@kernel.dk> <20200911212625.630477-3-axboe@kernel.dk>
In-Reply-To: <20200911212625.630477-3-axboe@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Fri, 11 Sep 2020 23:57:43 +0200
Message-ID: <CAG48ez06Pm1h7CH3nYojwqnSFrHhfrn1tcFxRrpu68Da=6tCGQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] io_uring: implement ->flush() sequence to handle
 ->files validity
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Sep 11, 2020 at 11:28 PM Jens Axboe <axboe@kernel.dk> wrote:
> The current scheme stashes away ->ring_fd and ->ring_file, and uses
> that to check against whether or not ->files could have changed. This
> works, but doesn't work so well for SQPOLL. If the application does
> close the ring_fd, then we require that applications enter the kernel
> to refresh our state.

I don't understand the intent; please describe the scenario this is
trying to fix. Is this something about applications that call dup()
and close() on the uring fd, or something like that?

> Add an atomic sequence for the ->flush() count on the ring fd, and if
> we get a mismatch between checking this sequence before and after
> grabbing the ->files, then we fail the request.

Is this expected to actually be possible during benign usage?

> This should offer the same protection that we currently have, with the
> added benefit of being able to update the ->files automatically.

Please clarify what "update the ->files" is about.

> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/io_uring.c | 137 ++++++++++++++++++++++++++++++--------------------
>  1 file changed, 83 insertions(+), 54 deletions(-)
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 4958a9dca51a..49be5e21f166 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -308,8 +308,11 @@ struct io_ring_ctx {
>          */
>         struct fixed_file_data  *file_data;
>         unsigned                nr_user_files;
> -       int                     ring_fd;
> -       struct file             *ring_file;
> +
> +       /* incremented when ->flush() is called */
> +       atomic_t                files_seq;

If this ends up landing, all of this should probably use 64-bit types
(atomic64_t and s64). 32-bit counters in fast syscalls can typically
be wrapped around in a reasonable amount of time. (For example, the
VMA cache sequence number wraparound issue
<https://googleprojectzero.blogspot.com/2018/09/a-cache-invalidation-bug-in-linux.html>
could be triggered in about an hour according to my blogpost from back
then. For this sequence number, it should be significantly faster, I
think.)

(I haven't properly looked at the rest of this patch so far - I stared
at it for a bit, but wasn't able to immediately figure out what's
actually going on. So I figured I'd ask the more fundamental questions
first.)
