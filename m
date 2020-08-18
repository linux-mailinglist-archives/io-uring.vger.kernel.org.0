Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8658248B31
	for <lists+io-uring@lfdr.de>; Tue, 18 Aug 2020 18:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgHRQKQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Aug 2020 12:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727008AbgHRQKH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Aug 2020 12:10:07 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F6EC061389
        for <io-uring@vger.kernel.org>; Tue, 18 Aug 2020 09:10:06 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id j187so18712929qke.11
        for <io-uring@vger.kernel.org>; Tue, 18 Aug 2020 09:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pHbdQqYuuupNBbCiSbzMQMiShUeCYuPOHqYI9Rh+F8k=;
        b=oUWnR6Z8E5Xxjr0NTs2iQ1PNzcVg5G/9VbDbCiOsq5ceGmoQUItYUnx8f5/967l7Jg
         Lzq46wTqbUjCiIv6NYgcPgz0wJ3H1IgvdUurlMjEmsKVn6n7PDbYJw844RrJen85sByz
         R8tgJqSwG58isdJ1dkiXLHPWC0NT8laQyXVJqo/HjEfERGKe5ca5jzlCd5MVMseJSDRD
         Suz4EyXMy6Ae9HbzPmO3tjbIpaToqGH5QtshLGPf711vaFVW6mpEpUL9GvwMKNeIstz6
         bJNa5oY3MAnfBo9jo7prvM1y5z6oEQg20MLEfuBmlG0SZQsTbzf6zLyM6IBHAd91Enre
         8Fdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pHbdQqYuuupNBbCiSbzMQMiShUeCYuPOHqYI9Rh+F8k=;
        b=sP17/0eUCD0XoImod1wFO/Oz0wPYlNGrx2Zv6n5s/45EjolXUlWj+6oiophrFBjnOo
         dSBU1Fl0SsaSr2BpAMh6Wd6jRyG174J3YqCEuRZyMyOgF4HgAYrTgPHsIVx+DMfr01FP
         Lgm3hl/1Z2d9QijfnAu4CN/8hX6/Hl9ZSkcGX2zDHH8h8nk5flbejZCSi65i5qMOk/5t
         3OQZoV8eg4j1VEani5dJyIZ9W6JbOtyzIHJOdsVFgLpp1Xug1QELOlRS37nzKctfXd/7
         CHoEdCkotcIj2JKEKzj2wvR9+3+5ZwxUyqzmfiLoiQX7p/3ORvzfaWIfctlGkPrztfCm
         5ggQ==
X-Gm-Message-State: AOAM530Q5/QvvE/7D3IukD9+/jypW3vwemv/fnDrzi6o7OpZ4gyRvwSE
        lK27XB5+m38J1DNzKAYkYHrR7VwCiJytqyLUfcSqgmRA
X-Google-Smtp-Source: ABdhPJzLJWo1fYH0/iGAHR3N5CSL33vw6JNNgHO0JGOTMCkIKomJmwFKw9j9xzFXeUOVoR24LHYXEjWItLOQokk+dHA=
X-Received: by 2002:a05:620a:12fb:: with SMTP id f27mr17706154qkl.232.1597767005364;
 Tue, 18 Aug 2020 09:10:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAF-ewDrOHDxpSAm8Or37m-k5K4u+b3H2YwnA-KpkFuVa+1vBOw@mail.gmail.com>
 <477c2759-19c1-1cb8-af4c-33f87f7393d7@kernel.dk> <CAF-ewDp5i0MmY8Xw6XZDZZTJu_12EH9BuAFC59pEdhhp57c0dQ@mail.gmail.com>
 <004a0e61-80a5-cba1-0894-1331686fcd1a@kernel.dk>
In-Reply-To: <004a0e61-80a5-cba1-0894-1331686fcd1a@kernel.dk>
From:   Dmitry Shulyak <yashulyak@gmail.com>
Date:   Tue, 18 Aug 2020 19:09:53 +0300
Message-ID: <CAF-ewDqANgn-F=9bQiXZtLyPXOs2Dwi-CHS=80hXpiZYGrJjgg@mail.gmail.com>
Subject: Re: Very low write throughput on file opened with O_SYNC/O_DSYNC
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

it worked, but there are some issues.
with o_dsync and even moderate submission rate threads are stuck in
some cpu task (99.9% cpu consumption), and make very slow progress.
have you expected it? it must be something specific to uring, i can't
reproduce this condition by writing from 2048 threads.




On Mon, 17 Aug 2020 at 19:17, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 8/17/20 8:49 AM, Dmitry Shulyak wrote:
> > With 48 threads i am getting 200 mb/s, about the same with 48 separate
> > uring instances.
> > With single uring instance (or with shared pool) - 60 mb/s.
> > fs - ext4, device - ssd.
>
> You could try something like this kernel addition:
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 4b102d9ad846..8909a1d37801 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1152,7 +1152,7 @@ static void io_prep_async_work(struct io_kiocb *req)
>         io_req_init_async(req);
>
>         if (req->flags & REQ_F_ISREG) {
> -               if (def->hash_reg_file)
> +               if (def->hash_reg_file && !(req->flags & REQ_F_FORCE_ASYNC))
>                         io_wq_hash_work(&req->work, file_inode(req->file));
>         } else {
>                 if (def->unbound_nonreg_file)
>
> and then set IOSQE_IO_ASYNC on your writes. That'll parallelize them in
> terms of execution.
>
> --
> Jens Axboe
>
