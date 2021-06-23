Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F18983B1355
	for <lists+io-uring@lfdr.de>; Wed, 23 Jun 2021 07:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbhFWFsW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Jun 2021 01:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhFWFsW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Jun 2021 01:48:22 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD11C061574;
        Tue, 22 Jun 2021 22:46:04 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id w21so2228466qkb.9;
        Tue, 22 Jun 2021 22:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oO1XdLGpYPMETP7QH3GVJqZimr0vWRbrp26HFwizw5M=;
        b=uQ5bnSWlfXWsymiUebN9fHp1o7hhpPGW5/LL3WgYUa7xdA/65gZH0qQvW3R9zrySUA
         nTX9GRwPuF30GCl+HWXNbPxdSboaHwUIYYVN25fOnKxfr/YUqvnbk2rsiD1/zEc2ZNuw
         d4VES0dyfFc0wrpOep0Myu9tLEz0rpexTABrciH0/g/slEKphgCmfHEuMeuJrTEXl0M2
         ip+JK1wRmY/mCZ2hA2T+bsCs2+lGP8v4tBIbqDQEbZ7IQwGk438gAh0kAecnppuCGP4y
         o68LAFaGxsaahA47gs/c7LsKTQCReHebXTMzPW+B6uaIuCeH7PHSZFl6pN1W+3cvO3Gj
         SWCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oO1XdLGpYPMETP7QH3GVJqZimr0vWRbrp26HFwizw5M=;
        b=ZPS4dvrbFmG4ZMn0z1k0Y8cKVAo7Vkf4t829quxOLT4k/sqMv12F9YLdC4I7FNpL4K
         F8fksYBQWmMOps9cytWFk9mzgndU8oeDZOt0X1AfjULyWAKcvz5zgE2uhIdd4JIfXRMX
         AWWYlp6GMehDtyosCN1L2ur7r/SmgAKxieFNfauZINXuSS+fyk1tzEoahmSyPiSz9wUI
         KZxeiuZ4FQysLs7oPnOeA3ZgNZ3fOj2vP/aOjEtCgakHgJPhmTM9YyxMPFrqKrav5Tgq
         Js9pswuqd/YF7lclM/hzBLlKxmGjhoM4NWNErAeo/LmQNczMVWTJ33KBZyanz4O3bnKT
         69AA==
X-Gm-Message-State: AOAM532//767BwJ5XOanh83iIc0ek+nXoT6bHyYjde7S7cI1zsPNnjse
        TYH/UtAG7TaKjQQzFGWHo4+PJz6xkf/BdEAWj6w=
X-Google-Smtp-Source: ABdhPJzMoM664Wr9HU+7gKVTpsNdSf/SLUfH5IwFh0XEWZncm13jfS5jawXnO6iFkG2Fzqux/JngkRgxb6ZqD/FWSBQ=
X-Received: by 2002:a25:8088:: with SMTP id n8mr9631619ybk.375.1624427163831;
 Tue, 22 Jun 2021 22:46:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210603051836.2614535-1-dkadashev@gmail.com> <20210603051836.2614535-9-dkadashev@gmail.com>
 <14ace9c7-176f-8234-152b-540ea55f695a@gmail.com>
In-Reply-To: <14ace9c7-176f-8234-152b-540ea55f695a@gmail.com>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Wed, 23 Jun 2021 12:45:53 +0700
Message-ID: <CAOKbgA7iZ97jV01f6CqacgF3aJfM2gA4L2o=+gAh2H_S4HfE0Q@mail.gmail.com>
Subject: Re: [PATCH v5 08/10] io_uring: add support for IORING_OP_SYMLINKAT
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-fsdevel@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jun 22, 2021 at 6:37 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 6/3/21 6:18 AM, Dmitry Kadashev wrote:
> > IORING_OP_SYMLINKAT behaves like symlinkat(2) and takes the same flags
> > and arguments.
> >
> > Suggested-by: Christian Brauner <christian.brauner@ubuntu.com>
> > Link: https://lore.kernel.org/io-uring/20210514145259.wtl4xcsp52woi6ab@wittgenstein/
> > Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
> > ---
> >  fs/internal.h                 |  1 +
> >  fs/io_uring.c                 | 64 ++++++++++++++++++++++++++++++++++-
> >  fs/namei.c                    |  3 +-
> >  include/uapi/linux/io_uring.h |  1 +
> >  4 files changed, 66 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/internal.h b/fs/internal.h
> > index 207a455e32d3..3b3954214385 100644
>
> [...]
>
> >
> >  static bool io_disarm_next(struct io_kiocb *req);
> > @@ -3572,7 +3581,51 @@ static int io_mkdirat(struct io_kiocb *req, int issue_flags)
> >
> >       req->flags &= ~REQ_F_NEED_CLEANUP;
> >       if (ret < 0)
> > -             req_set_fail_links(req);
> > +             req_set_fail(req);
>
> This means one of the previous patches doesn't compile. Let's fix it.

This is an artifact from yet another rebase, sorry. This should have been a
part of the MKDIR opcode commit, but got squashed with a wrong one. But I can
see you've already figured that out and sent for Jens to fold it in. Thanks!

-- 
Dmitry Kadashev
