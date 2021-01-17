Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 972982F9260
	for <lists+io-uring@lfdr.de>; Sun, 17 Jan 2021 13:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbhAQMwr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Jan 2021 07:52:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726209AbhAQMwr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Jan 2021 07:52:47 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6F6C061573
        for <io-uring@vger.kernel.org>; Sun, 17 Jan 2021 04:52:07 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id 143so16281804qke.10
        for <io-uring@vger.kernel.org>; Sun, 17 Jan 2021 04:52:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o68P+mjpDaBCQHDzgKuTsVaaguRgyHOrRasTuGTMNLg=;
        b=HO85Ois7WxBRYN87VZhXPL4eMzxHp5AiX0Ndc9XdHde1E33S6jfnN/js3YzxKvpkjJ
         CHtG8bawUej8VYfmifdlU+QpycZHbIhptGIOGVMRFdPSk26KUWbMB6l54XuBe+aQySFQ
         I4OjJpk0ld3IxQPgJrlg2YMDjBnF4KBS+pIqMLZA/qklLUdOMbBroFjbwdBHxmBHL6/b
         iQuMT2xscy3v85GrmMJR7a1wZxqQSQ6+oYjrc2G3GGxRCS50noqZAhmxWkq9yJuj1Rp5
         STRwxlmBHoOi2dwT1CEXrPSTqLPXrMku9mA3vAf79rO5NugSYvyx13zqnD5wcx9c3q4P
         z1Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o68P+mjpDaBCQHDzgKuTsVaaguRgyHOrRasTuGTMNLg=;
        b=fszS1fdP4mR0tmwXX7uBSK731VDAMsPn08AMXtzruq80tV7pthPSDvqZkaQ7+Qwo2k
         MnHokgqp7eMl3ngKGCxETOHkfhpqpqhJoliliGm22qcm+czlSeBsBMKrB58859ANfF+E
         baswE7WmU87KfBiCGzbCqoHgwvdp5C9MlbBNoiy3wnVpsBtnsdK20Pd5/6f8kAIUxV+a
         XFOFjnpDvwRsLqNs/XXxxJEuSiISPTkoKRVIte+koJLAmhGy0TDrwyty5YkSG83sBYu8
         1OvQnFYHw8EANqQUgRCkOnQs1xgpVmqowbKo7bweYxyS5FvLskCcdIr5/T/v1DbDIjE3
         96tg==
X-Gm-Message-State: AOAM530ZnecvIKX3yo1RCP7EVz6hJeTpPz96+uGJUBK/6baaa9DE17b3
        3hjB3ND2eKWpHYdDlinbKdbqpvA+jD5ORtsbQuo=
X-Google-Smtp-Source: ABdhPJx6I5+SWsoMHSsQAz7IkhFY7xn7/w59+cgc/9wpDGB/fTTm3knMQpbj5tBI8qRV3cfVseGHoWUI1bgOZ2ps/ms=
X-Received: by 2002:a37:6245:: with SMTP id w66mr20028661qkb.422.1610887926415;
 Sun, 17 Jan 2021 04:52:06 -0800 (PST)
MIME-Version: 1.0
References: <4d22e80b-0767-3e14-fc13-5eca9b1816fc@kernel.dk> <c41079a5-5f5f-ac58-e01d-792e4f007611@gmail.com>
In-Reply-To: <c41079a5-5f5f-ac58-e01d-792e4f007611@gmail.com>
From:   Josef <josef.grieb@gmail.com>
Date:   Sun, 17 Jan 2021 13:51:55 +0100
Message-ID: <CAAss7+q5=W94YF+6Ts+jyJSNbs=2hD+OMbY5zZtZNkrJfMWjpw@mail.gmail.com>
Subject: Re: [PATCH] io_uring: cancel all requests on task exit
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

thanks :) I ran several tests, I can confirm this fixed the issue.
Tested-by: Josef Grieb <josef.grieb@gmail.com>

On Sun, 17 Jan 2021 at 12:00, Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 17/01/2021 04:04, Jens Axboe wrote:
> > We used to have task exit tied to canceling files_struct ownership, but we
> > really should just simplify this and cancel any request that the task has
> > pending when it exits. Instead of handling files ownership specially, we
> > do the same regardless of request type.
> >
> > This can be further simplified in the next major kernel release, unifying
> > how we cancel across exec and exit.
>
> Looks good in general. See a comment below, but otherwise
> Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
>
> btw, I wonder if we can incite syzbot to try to break it.
>
> >
> > Cc: stable@vger.kernel.org # 5.9+
> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >
> > ---
> >
> > diff --git a/fs/io_uring.c b/fs/io_uring.c
> > index 383ff6ed3734..1190296fc95f 100644
> > --- a/fs/io_uring.c
> > +++ b/fs/io_uring.c
> > @@ -9029,7 +9029,7 @@ static void io_uring_remove_task_files(struct io_uring_task *tctx)
> >               io_uring_del_task_file(file);
> >  }
> >
> > -void __io_uring_files_cancel(struct files_struct *files)
> > +static void __io_uring_files_cancel(void)
> >  {
> >       struct io_uring_task *tctx = current->io_uring;
> >       struct file *file;
> > @@ -9038,11 +9038,10 @@ void __io_uring_files_cancel(struct files_struct *files)
> >       /* make sure overflow events are dropped */
> >       atomic_inc(&tctx->in_idle);
> >       xa_for_each(&tctx->xa, index, file)
> > -             io_uring_cancel_task_requests(file->private_data, files);
> > +             io_uring_cancel_task_requests(file->private_data, NULL);
> >       atomic_dec(&tctx->in_idle);
> >
> > -     if (files)
> > -             io_uring_remove_task_files(tctx);
> > +     io_uring_remove_task_files(tctx);
>
> This restricts cancellations to only one iteration. Just delete it,
> __io_uring_task_cancel() calls it already.
>
> --
> Pavel Begunkov



-- 
Josef
