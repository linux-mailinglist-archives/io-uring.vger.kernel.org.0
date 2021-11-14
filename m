Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 785AD44FB95
	for <lists+io-uring@lfdr.de>; Sun, 14 Nov 2021 21:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236201AbhKNUgo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 14 Nov 2021 15:36:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234970AbhKNUgm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 14 Nov 2021 15:36:42 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D918FC061746
        for <io-uring@vger.kernel.org>; Sun, 14 Nov 2021 12:33:45 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id b15so62200128edd.7
        for <io-uring@vger.kernel.org>; Sun, 14 Nov 2021 12:33:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mariadb.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FtN0fh6H4C16icsZhgHAYB3+VBhG91m0rQocjJHzONI=;
        b=APBsZkWBFt56Raz0u1lXNZ02U1/kqeW1r752dTElA2IwTyarebhrvC/0R2ukCYa1kC
         U1AiEkqDNV7BYHWOa0mSIXdmdFXuGAifpIshM3XOSULne0M+wsXVg0a2xJi124ssRQeC
         elcvkCDGa1bHyZLj7vlvB2EJOqQezFJ1S1/P6ViamKA79lEdcclNdoKLvHZGKEP38Jki
         5gs7ReV1UZwsK/o89wKk7ZYszLRSX5HOIe1zLLcudJFStS5CHvS0Sckm33pPI3wGU61z
         AsyEGqScP5pdwSQTW6AL4JP9qt4u3dN+xpW1GLTZEwb2DSa5vqvZQKv1T2QHjCSQtzlI
         UhEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FtN0fh6H4C16icsZhgHAYB3+VBhG91m0rQocjJHzONI=;
        b=eGH7sxQXYUw5phzLhO19OSl6p4PE6cyv7myn1lxUr4xKjchaIF3vZnkM2stHjpdZF7
         7OPGUnep/EYu84Ax/vsAKiVbUB9CsrMQR66W5PnZzHv5A27j6CRsSS//DXg6RpNtzM9x
         +YgJJzCxliHbQ6uL549fhsVqTnrGz2SZ5XtH0ZecpbB8IXK6xMbGl/zNmG1hFrcBjOcv
         q54YjKYKY5zi2GirsZV8sgWw4oSXr1FOBrPfcYzdZOwD/errL57jZ6mMzIv9d8NgOEh1
         D4r+jGAfhw5InqyOSrEZJZvp9G2kWbYnBfSPVrlqJ2SKOFD6HkIYydlu+QsWpKEhSufM
         n2nA==
X-Gm-Message-State: AOAM530od+09MTqFbtsyvv6behXLDp97BOAQV8Y1z0QmxMvD82uQHbZa
        1BOI14fJmjN9+3Aczw+N/qM0HfF8oRguOnpvESDVPg==
X-Google-Smtp-Source: ABdhPJxq11ysxdTBdauVuZV4JYTyah4JmuH0XIEQIrQchgljPnRKKL1sFro2K+4CzVNJh5sePQGQQ7KS/BhzLINwmGg=
X-Received: by 2002:a17:906:8256:: with SMTP id f22mr36751059ejx.207.1636922024419;
 Sun, 14 Nov 2021 12:33:44 -0800 (PST)
MIME-Version: 1.0
References: <CABVffENnJ8JkP7EtuUTqi+VkJDBFU37w1UXe4Q3cB7-ixxh0VA@mail.gmail.com>
 <77f9feaa-2d65-c0f5-8e55-5f8210d6a4c6@gmail.com> <8cd3d258-91b8-c9b2-106c-01b577cc44d4@gmail.com>
 <CABVffEOMVbQ+MynbcNfD7KEA5Mwqdwm1YuOKgRWnpySboQSkSg@mail.gmail.com>
 <23555381-2bea-f63a-1715-a80edd3ee27f@gmail.com> <YXz0roPH+stjFygk@eldamar.lan>
 <CABVffEO4mBTuiLzvny1G1ocO7PvTpKYTCS5TO2fbaevu2TqdGQ@mail.gmail.com>
 <CABVffEMy+gWfkuEg4UOTZe3p_k0Ryxey921Hw2De8MyE=JafeA@mail.gmail.com>
 <f4f2ff29-abdd-b448-f58f-7ea99c35eb2b@kernel.dk> <ef299d5b-cc48-6c92-024d-27024b671fd3@kernel.dk>
 <CABVffEOpuViC9OyOuZg28sRfGK4GRc8cV0CnkOU2cM0RJyRhPw@mail.gmail.com>
 <e9b4d07e-d43d-9b3c-ac4c-f8b88bb987d4@kernel.dk> <1bd48c9b-c462-115c-d077-1b724d7e4d10@kernel.dk>
 <c6d6bffe-1770-c51d-11c6-c5483bde1766@kernel.dk> <bd7289c8-0b01-4fcf-e584-273d372f8343@kernel.dk>
 <6d0ca779-3111-bc5e-88c0-22a98a6974b8@kernel.dk> <281147cc-7da4-8e45-2d6f-3f7c2a2ca229@kernel.dk>
 <c92f97e5-1a38-e23f-f371-c00261cacb6d@kernel.dk>
In-Reply-To: <c92f97e5-1a38-e23f-f371-c00261cacb6d@kernel.dk>
From:   Daniel Black <daniel@mariadb.org>
Date:   Mon, 15 Nov 2021 07:33:33 +1100
Message-ID: <CABVffEN0LzLyrHifysGNJKpc_Szn7qPO4xy7aKvg7LTNc-Fpng@mail.gmail.com>
Subject: Re: uring regression - lost write request
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Salvatore Bonaccorso <carnil@debian.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Nov 12, 2021 at 10:44 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> Alright, give this one a go if you can. Against -git, but will apply to
> 5.15 as well.


Works. Thank you very much.

https://jira.mariadb.org/browse/MDEV-26674?page=3Dcom.atlassian.jira.plugin=
.system.issuetabpanels:comment-tabpanel&focusedCommentId=3D205599#comment-2=
05599

Tested-by: Marko M=C3=A4kel=C3=A4 <marko.makela@mariadb.com>


>
>
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index afd955d53db9..88202de519f6 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -423,9 +423,10 @@ static inline unsigned int io_get_work_hash(struct i=
o_wq_work *work)
>         return work->flags >> IO_WQ_HASH_SHIFT;
>  }
>
> -static void io_wait_on_hash(struct io_wqe *wqe, unsigned int hash)
> +static bool io_wait_on_hash(struct io_wqe *wqe, unsigned int hash)
>  {
>         struct io_wq *wq =3D wqe->wq;
> +       bool ret =3D false;
>
>         spin_lock_irq(&wq->hash->wait.lock);
>         if (list_empty(&wqe->wait.entry)) {
> @@ -433,9 +434,11 @@ static void io_wait_on_hash(struct io_wqe *wqe, unsi=
gned int hash)
>                 if (!test_bit(hash, &wq->hash->map)) {
>                         __set_current_state(TASK_RUNNING);
>                         list_del_init(&wqe->wait.entry);
> +                       ret =3D true;
>                 }
>         }
>         spin_unlock_irq(&wq->hash->wait.lock);
> +       return ret;
>  }
>
>  static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
> @@ -475,14 +478,21 @@ static struct io_wq_work *io_get_next_work(struct i=
o_wqe_acct *acct,
>         }
>
>         if (stall_hash !=3D -1U) {
> +               bool unstalled;
> +
>                 /*
>                  * Set this before dropping the lock to avoid racing with=
 new
>                  * work being added and clearing the stalled bit.
>                  */
>                 set_bit(IO_ACCT_STALLED_BIT, &acct->flags);
>                 raw_spin_unlock(&wqe->lock);
> -               io_wait_on_hash(wqe, stall_hash);
> +               unstalled =3D io_wait_on_hash(wqe, stall_hash);
>                 raw_spin_lock(&wqe->lock);
> +               if (unstalled) {
> +                       clear_bit(IO_ACCT_STALLED_BIT, &acct->flags);
> +                       if (wq_has_sleeper(&wqe->wq->hash->wait))
> +                               wake_up(&wqe->wq->hash->wait);
> +               }
>         }
>
>         return NULL;
> @@ -564,8 +574,11 @@ static void io_worker_handle_work(struct io_worker *=
worker)
>                                 io_wqe_enqueue(wqe, linked);
>
>                         if (hash !=3D -1U && !next_hashed) {
> +                               /* serialize hash clear with wake_up() */
> +                               spin_lock_irq(&wq->hash->wait.lock);
>                                 clear_bit(hash, &wq->hash->map);
>                                 clear_bit(IO_ACCT_STALLED_BIT, &acct->fla=
gs);
> +                               spin_unlock_irq(&wq->hash->wait.lock);
>                                 if (wq_has_sleeper(&wq->hash->wait))
>                                         wake_up(&wq->hash->wait);
>                                 raw_spin_lock(&wqe->lock);
>
> --
> Jens Axboe
>
