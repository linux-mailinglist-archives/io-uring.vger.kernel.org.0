Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4547C4114DA
	for <lists+io-uring@lfdr.de>; Mon, 20 Sep 2021 14:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbhITMuI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Sep 2021 08:50:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231562AbhITMuH (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 20 Sep 2021 08:50:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D7D360F58;
        Mon, 20 Sep 2021 12:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632142120;
        bh=uDVTxCSXE+yHYLu/iESiPaKnuDHGQfKwfG1eTxgqqGQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=gVcmxjFJGE/rtnz9rkG20UGxetpgieI4SCQl+tob/UU+eqXS8BLqlYFIIFXJITeNV
         c4QMWXTxMdtpsUJ1gecARvJregJ4egv93bNdIvvW6l6jlzLvtVG4xoIM7yGIu5bcTF
         QHMxDqZMTXHY8TJj/tOXd706JjHcPkNWgAnM46aX3E4GnwCfvhBhK60JaFzWmY28wg
         B/ngrIdW6+ZPDypzEU1uMjMpPHP7n5AjVb2HnRoV7OJKkocvSqMFt6mg4cPFv5nTs0
         /PV+m1AXs5nVz0kBc7YaScjKHIDtPS4LTcv3qoXlFM3S7xMGzB7t4qbl8d7JXmlChZ
         euAgXkWypcesQ==
Received: by mail-wr1-f43.google.com with SMTP id w17so21189044wrv.10;
        Mon, 20 Sep 2021 05:48:40 -0700 (PDT)
X-Gm-Message-State: AOAM5330SESGml4IsQqkqi4praUAxeeu/T2TAdMi1q1E+mTZqCLZ8YNk
        NfT5z9U99rB7XE1z+N79jgCkn44pAVIUmJO15F0=
X-Google-Smtp-Source: ABdhPJwRdEZyv4hk1W4Hm33Dq4r+PG/EsgnTk8+o80Hh9ItwUOHBLZ7+kcad5imJclI1fxlvqCXT6RhDO7gETsIHGjE=
X-Received: by 2002:a05:6000:1561:: with SMTP id 1mr18403327wrz.369.1632142119203;
 Mon, 20 Sep 2021 05:48:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210920121352.93063-1-arnd@kernel.org> <YUh8Mj59BtyBdTRH@infradead.org>
In-Reply-To: <YUh8Mj59BtyBdTRH@infradead.org>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Mon, 20 Sep 2021 14:48:23 +0200
X-Gmail-Original-Message-ID: <CAK8P3a30a1SKh+71+EgPmsJ1FKJTPKYQuAFUebwKKrhuVzBh3Q@mail.gmail.com>
Message-ID: <CAK8P3a30a1SKh+71+EgPmsJ1FKJTPKYQuAFUebwKKrhuVzBh3Q@mail.gmail.com>
Subject: Re: [PATCH] [RFC] io_uring: warning about unused-but-set parameter
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, io-uring@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Sep 20, 2021 at 2:18 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Mon, Sep 20, 2021 at 02:13:44PM +0200, Arnd Bergmann wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > When enabling -Wunused warnings by building with W=1, I get an
> > instance of the -Wunused-but-set-parameter warning in the io_uring code:
> >
> > fs/io_uring.c: In function 'io_queue_async_work':
> > fs/io_uring.c:1445:61: error: parameter 'locked' set but not used [-Werror=unused-but-set-parameter]
> >  1445 | static void io_queue_async_work(struct io_kiocb *req, bool *locked)
> >       |                                                       ~~~~~~^~~~~~
> >
> > There are very few warnings of this type, so it would be nice to enable
> > this by default and fix all the existing instances. I was almost
> > done, but this was added recently as a precaution to prevent code
> > from using the parameter, which could be done by either removing
> > the initialization, or by adding a (fake) use of the variable, which
> > I do here with the cast to void.
>
> Please don't.  These warning are utterly stupid and should not be
> enabled.  For anything that is a "method" of sorts (that is assigned
> to a function pointer), unused argument are perfectly normal.

I'm not suggesting to enable -Wunused-parameter, which would be
complete madness of crouse, only -Wunused-but-set-parameter,
which is already part of W=1 and has the potential of catching
actual bugs such as

int f(int val)
{
      if (val = 1)
            return 0;

       return -1;
}

          Arnd
