Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72F0B1A2528
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2020 17:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728281AbgDHPa2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Apr 2020 11:30:28 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:44634 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727049AbgDHPa1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Apr 2020 11:30:27 -0400
Received: by mail-il1-f196.google.com with SMTP id i14so2011637ilr.11
        for <io-uring@vger.kernel.org>; Wed, 08 Apr 2020 08:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7APp0KfXwU/pLJcbpFhn/1PVE3vpXS25Kuz/cTYHY10=;
        b=M3U7YZ7LMWaPsEyq3melfGdfT7f4FYufXFFn7EQtqMGc8jm+Icdsmy7Po/AYtObEHu
         mqJlXr+PcgscIi4sq46QuN2ziceVWJhGRuLqtfw7UiMujQJoFnb7uMoKRRIfmzCDLDPj
         OSyZbL2s5hgXVnUq0hZDqkKeK3yWeqlw9ss8enGJ6bCwm4hy18Zki5wU0/AVvLk9hxI/
         cqGK7SJFNnXw5plJVIDklSz7azDnkxTYORgPLMSzKzFyY6p13xqK6+k7Vbjdqmh9jOlb
         L7ymzXzLSwoEd3BQ5c3cSO5l5x6SQfiiQqu+wxygHLL1trX/dkl0avM+MKAwSiJXUcqG
         12mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7APp0KfXwU/pLJcbpFhn/1PVE3vpXS25Kuz/cTYHY10=;
        b=WrDSkl47Z0RDvEZvMeR7Dlr9zb9s76xFLhps62UfTanrrpRoacvhP/Z4/W5HLW02F2
         eIVaV0rbeGcmh/aEZQ3uee6VrOGLT5FfHkFxzoAgO7FN0GEYRZnAVGr7uodKFG+gPR8L
         YIC9OiWeB7MXC3cAJP0dFCn88UvZri7vRGNg1+o3shVIhO8OU5q752irz1Q+0uvljmKF
         66NlpJi2w8/fpKJdqfaaWTniipmt2au2TLO1uZ7Yr2dBeJQZ0c2aHK/iUP8btNb0RSc3
         0kFsIn1QzZ977a8J7geRJ2AYaAav7/xs5O/k+Hd/oXXGcLf6ad3nYlK4HTxOrGqavgop
         s9pQ==
X-Gm-Message-State: AGi0PuY5XcPxl8cIAzgoJBW/cs2aE3O8KpUhrqsLhi/4ZNpfyJsPNT02
        3e5dn17HUD3jvjV7P8oVHWp/V+QDwtUjBc745gg=
X-Google-Smtp-Source: APiQypJfw61KK+mklPvqcTf3UP2MewLDXc1eQmrNgVBMyFXTTuBVHTvhojN+0RQNG/Y+IpZW0FNF4ek6vY0OgHWPc8Q=
X-Received: by 2002:a05:6e02:be7:: with SMTP id d7mr8634830ilu.238.1586359826085;
 Wed, 08 Apr 2020 08:30:26 -0700 (PDT)
MIME-Version: 1.0
References: <CAOKbgA4K4FzxTEoHHYcoOAe6oNwFvGbzcfch2sDmicJvf3Ydwg@mail.gmail.com>
 <3a70c47f-d017-9f11-a41b-fa351e3906dc@kernel.dk>
In-Reply-To: <3a70c47f-d017-9f11-a41b-fa351e3906dc@kernel.dk>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Wed, 8 Apr 2020 22:30:13 +0700
Message-ID: <CAOKbgA7Pf2K5o_CkAs2ShcNbV8dx75xZBfM8D1xZcLm5RjmLXA@mail.gmail.com>
Subject: Re: io_uring's openat doesn't work with large (2G+) files
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Apr 8, 2020 at 10:19 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 4/8/20 7:51 AM, Dmitry Kadashev wrote:
> > Hi,
> >
> > io_uring's openat seems to produce FDs that are incompatible with
> > large files (>2GB). If a file (smaller than 2GB) is opened using
> > io_uring's openat then writes -- both using io_uring and just sync
> > pwrite() -- past that threshold fail with EFBIG. If such a file is
> > opened with sync openat, then both io_uring's writes and sync writes
> > succeed. And if the file is larger than 2GB then io_uring's openat
> > fails right away, while the sync one works.
> >
> > Kernel versions: 5.6.0-rc2, 5.6.0.
> >
> > A couple of reproducers attached, one demos successful open with
> > failed writes afterwards, and another failing open (in comparison with
> > sync  calls).
> >
> > The output of the former one for example:
> >
> > *** sync openat
> > openat succeeded
> > sync write at offset 0
> > write succeeded
> > sync write at offset 4294967296
> > write succeeded
> >
> > *** sync openat
> > openat succeeded
> > io_uring write at offset 0
> > write succeeded
> > io_uring write at offset 4294967296
> > write succeeded
> >
> > *** io_uring openat
> > openat succeeded
> > sync write at offset 0
> > write succeeded
> > sync write at offset 4294967296
> > write failed: File too large
> >
> > *** io_uring openat
> > openat succeeded
> > io_uring write at offset 0
> > write succeeded
> > io_uring write at offset 4294967296
> > write failed: File too large
>
> Can you try with this one? Seems like only openat2 gets it set,
> not openat...

I've tried specifying O_LARGEFILE explicitly, that did not change the
behavior. Is this good enough? Much faster for me to check this way
that rebuilding the kernel. But if necessary I can do that.

Also, forgot to mention, this is on x86_64, not sure if O_LARGEFILE is
necessary to do 2G+ files there?

>
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 79bd22289d73..63eb7efe10f2 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2957,6 +2957,8 @@ static int io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>         req->open.how.mode = READ_ONCE(sqe->len);
>         fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
>         req->open.how.flags = READ_ONCE(sqe->open_flags);
> +       if (force_o_largefile())
> +               req->open.how.flags |= O_LARGEFILE;
>
>         req->open.filename = getname(fname);
>         if (IS_ERR(req->open.filename)) {
>
> --
> Jens Axboe
>

-- 
Dmitry
