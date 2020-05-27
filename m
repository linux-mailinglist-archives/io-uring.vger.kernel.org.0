Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3698B1E4CAE
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2020 20:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388968AbgE0SEq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 May 2020 14:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388950AbgE0SEq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 May 2020 14:04:46 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53E3FC03E97D
        for <io-uring@vger.kernel.org>; Wed, 27 May 2020 11:04:45 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id a25so18445923ljp.3
        for <io-uring@vger.kernel.org>; Wed, 27 May 2020 11:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0c74dA5VYboUTOhjdtG7MVseKHCZzezIXWTgl4CeypA=;
        b=SkXYZgSHYU8tF1O44dxzOPJ1yt3h5TPc/Q2FARb/Whl1nCnkyPYVXPnREuDzVU/c4b
         7wyYE4zJClTQR5D1a/pc2Y0NrdqPCDgPShCmC+4Zwm72cS/E4NCsFScdrS3b4JMgKNs7
         n4N0wikAAdTL+BdQD3R9WthkPpKA8ZKj2uw/13sWv2MR7c/SeaX4FCcnLRvUqBbajVns
         S2txhoUWx6F+UkHXNSupni0epMgNBLQHPBO70+IW/WCalUG3Hici0OgmqaIbFxlJKhUl
         KxEfxVYHTw64lYTsTZyX03a36ov/A8MDkYE12FGPdu4XABWoZAyNRdlS4GRK21FMak84
         erzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0c74dA5VYboUTOhjdtG7MVseKHCZzezIXWTgl4CeypA=;
        b=tRkPR9Ohs7jIkL/+JwNZKNRsKGoi7atc3j8kbegcIs3203tb0sJCBX7+keWMaaK9og
         dg3YFlJMOUVYZqohCDbsKBusZO1kVDs+Lkw2f32BnUhbExg/4KAVCfbtMssNbdOU3aKG
         ak+obHM+fKYDv38EkYrNDpaV1qQ274oQMNcBUQAWmkR/sF+sPQ3VxJ/NQrhSnIdhZjbN
         jJeXtCGpSEn78iqDGzVcHQm+GVsK5w4aC9pxnziEk+Y36H5TQpodKT4mqaKuQgfhp5B2
         cZOcwqHjW8bLh1JeLwtdJ33v8edJD4taHJll/ejFkamDyb0uJjxkVb/meR3OVXo8MOBr
         SKdw==
X-Gm-Message-State: AOAM5324iehQWDtZSC5X3qgCQ0qNEXR+3l99TZkzKoNaKrs6utOvN2KD
        r4XdIVdAf+X69bZe2i7OYpZ73719xzB/N31w5fJIH95el4s=
X-Google-Smtp-Source: ABdhPJyR3ZBSaSf5/C+DZSmFMFQVDFMTBbzgyzkiIKrx0e2aIzwl0cKBcueAb8riuQjbvrtTyliuZmn0PlPYC1Sq4Zw=
X-Received: by 2002:a2e:1f02:: with SMTP id f2mr3303635ljf.156.1590602683337;
 Wed, 27 May 2020 11:04:43 -0700 (PDT)
MIME-Version: 1.0
References: <94f75705-3506-4c58-c1ff-cced9c045956@gmail.com>
 <CAG48ez24_NGyYEXyO+AaWZNEkK=CVmvOQDoGUoaJxtORoLU=OA@mail.gmail.com> <ab91ac71-def9-9e78-539d-05aebe7eda67@gmail.com>
In-Reply-To: <ab91ac71-def9-9e78-539d-05aebe7eda67@gmail.com>
From:   Jann Horn <jannh@google.com>
Date:   Wed, 27 May 2020 20:04:16 +0200
Message-ID: <CAG48ez0-2jcGk3qTqQqrDr+j1UWv4K4wF6rm0xkifVtkFz76Wg@mail.gmail.com>
Subject: Re: [RFC] .flush and io_uring_cancel_files
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, May 27, 2020 at 12:14 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
> On 27/05/2020 01:04, Jann Horn wrote:
> > On Tue, May 26, 2020 at 8:11 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
> >> It looks like taking ->uring_lock should work like kind of grace
> >> period for struct files_struct and io_uring_flush(), and that would
> >> solve the race with "fcheck(ctx->ring_fd) == ctx->ring_file".
> >>
> >> Can you take a look? If you like it, I'll send a proper patch
> >> and a bunch of cleanups on top.
> >>
> >>
> >> diff --git a/fs/io_uring.c b/fs/io_uring.c
> >> index a3dbd5f40391..012af200dc72 100644
> >> --- a/fs/io_uring.c
> >> +++ b/fs/io_uring.c
> >> @@ -5557,12 +5557,11 @@ static int io_grab_files(struct io_kiocb *req)
> >>          * the fd has changed since we started down this path, and disallow
> >>          * this operation if it has.
> >>          */
> >> -       if (fcheck(ctx->ring_fd) == ctx->ring_file) {
> >> -               list_add(&req->inflight_entry, &ctx->inflight_list);
> >> -               req->flags |= REQ_F_INFLIGHT;
> >> -               req->work.files = current->files;
> >> -               ret = 0;
> >> -       }
> >> +       list_add(&req->inflight_entry, &ctx->inflight_list);
> >> +       req->flags |= REQ_F_INFLIGHT;
> >> +       req->work.files = current->files;
> >> +       ret = 0;
> >> +
> >>         spin_unlock_irq(&ctx->inflight_lock);
> >>         rcu_read_unlock();
> >>
> >> @@ -7479,6 +7478,10 @@ static int io_uring_release(struct inode *inode, struct
> >> file *file)
> >>  static void io_uring_cancel_files(struct io_ring_ctx *ctx,
> >>                                   struct files_struct *files)
> >>  {
> >> +       /* wait all submitters that can race for @files */
> >> +       mutex_lock(&ctx->uring_lock);
> >> +       mutex_unlock(&ctx->uring_lock);
> >> +
> >>         while (!list_empty_careful(&ctx->inflight_list)) {
> >>                 struct io_kiocb *cancel_req = NULL, *req;
> >>                 DEFINE_WAIT(wait);
> >
> > First off: You're removing a check in io_grab_files() without changing
> > the comment that describes the check; and the new comment you're
> > adding in io_uring_cancel_files() is IMO too short to be useful.
>
> Obviously, it was stripped down to show the idea, nobody is talking about
> commiting it as is. I hoped Jens remembers it well enough to understand.
> Let me describe it in more details then:
>
> >
> > I'm trying to figure out how your change is supposed to work, and I
> > don't get it. If a submitter is just past fdget() (at which point no
> > locks are held), the ->flush() caller can instantly take and drop the
> > ->uring_lock, and then later the rest of the submission path will grab
> > an unprotected pointer to the files_struct. Am I missing something?
>
> old = tsk->files;
> task_lock(tsk);
> tsk->files = files;
> task_unlock(tsk);
> put_files_struct(old); (i.e. ->flush(old))
>
> It's from reset_files_struct(), and I presume the whole idea of
> io_uring->flush() is to protect against racing for similarly going away @old
> files. I.e. ensuring of not having io_uring requests holding @old files.

Kind of. We use the ->flush() handler to be notified when the
files_struct goes away, so that instead of holding a reference to the
files_struct (which would cause a reference loop), we can clean up our
references when it goes away.

> The only place, where current->files are accessed and copied by io_uring, is
> io_grab_files(), which is called in the submission path. And the whole
> submission path is done under @uring_mtx.

No it isn't. We do fdget(fd) at the start of the io_uring_enter
syscall, and at that point we obviously can't hold the uring_mtx yet.

> For your case, the submitter will take @uring_mtx only after this lock/unlock
> happened, so it won't see old files (happens-before by locking mutex).

No, it will see the old files. The concurrent operation we're worried
about is not that the files_struct goes away somehow (that can't
happen); what we want to guard against is a concurrent close() or
dup2() or so removing the uring fd from the files_struct, because if
someone calls close() before we stash a pointer to current->files,
that pointer isn't protected anymore.


> The thing I don't know is why current->files is originally accessed without
> protection in io_grab_files(), but presumably rcu_read_lock() there is for that
> reason.

No, it's because current->files can never change under you; pretty
much the only places where current->files can change are unshare() and
execve().
