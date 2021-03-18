Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 710A733FF6F
	for <lists+io-uring@lfdr.de>; Thu, 18 Mar 2021 07:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhCRGPg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Mar 2021 02:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbhCRGPG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Mar 2021 02:15:06 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F37AC06174A
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 23:15:06 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id j18so4222163wra.2
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 23:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nCsEa7rjIzQDtOdxS9bWwujiQOvTTGKfa9YG/w1Lgg0=;
        b=cLy1GCebIL5SFcSud4WCZMPg2kwGvqD2AAE0OFZinDA4OigCUKemHipOMxHHkT01Zn
         MgEz70eulLDLt7cZBkuiIuw2KCmIdaHm+jWom+rwU4msglUoRIqBFHyoc2aHj2MjPsie
         SSvKSGNjon6Z7+3T6Pw72hUKfKvFeQIuYxlWv0EtQPbMuRok2fO62D9DMI/SzviCaT8f
         zWr8CMDKf9rHv5usHk1VE9pCZ2jIWQ1ltjYWgqsof04YVjuco41MJdHn0meVCidAF40u
         9SQGBKZ2wGkJPvm18b/US8ZxrDncO7R+rCc00oGBnLJBbvRVOWxJqWeVq1JdoyUTaq9C
         6iKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nCsEa7rjIzQDtOdxS9bWwujiQOvTTGKfa9YG/w1Lgg0=;
        b=LVajNR15lbQs5xlDiWjGP+tLlIAHrq/+8Rz/D7ZeGeDMUnEGI1vPieIxGA4NPERDb0
         zL9fmXLlsUDhI+AkqDdJPZWGC7iQ76Lv+u+DhNRn0PjNB7lVhmQqs0KwL2mxJdPaav4d
         +FgRPkH1lxsRAUtbjtg4/CLrNKUvUVCLg9P6nEqoh6KE5VhUzJvsdu3ymwOuw/62W4FN
         2lNMjPITCZbZHHFG4p5Ln0I0WZM+iFNzVsMpt/VmFt3i/5PuuiUpsYbEL52O/bzWHMCy
         VWfFC9A7pF6gq3tMCz4cuthk5CjH0fT271kj3D+rAfKUQNj3SATsntONypGp9GAqW0yZ
         wwdg==
X-Gm-Message-State: AOAM532dYyMKnO3ZM4jxIdmNBBJ4mufz3td119Db7n7RzQbw/NiwoezX
        sTKjCdax2DbYyNkZQiXC3ftoRyU2pIW6tBdYb3o=
X-Google-Smtp-Source: ABdhPJxQ66k893grC+tyfnJy+8q1d9Rw/d7KjcHEtAgzHlLJITbwHmBrfit/xqLii6Xf6ZqyzHXFll/il0lXRYaP3S0=
X-Received: by 2002:a05:6000:2c8:: with SMTP id o8mr7854769wry.407.1616048105247;
 Wed, 17 Mar 2021 23:15:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210316140126.24900-1-joshi.k@samsung.com> <CGME20210316140233epcas5p372405e7cb302c61dba5e1094fa796513@epcas5p3.samsung.com>
 <20210316140126.24900-2-joshi.k@samsung.com> <05a91368-1ba8-8583-d2ab-8db70b92df76@kernel.dk>
 <CA+1E3r+Mt7KKeFeYf7WY3CoKwnkXT-jE2EgJSTE6zaAfJX0dzQ@mail.gmail.com> <20210318054807.GA28576@lst.de>
In-Reply-To: <20210318054807.GA28576@lst.de>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Thu, 18 Mar 2021 11:44:38 +0530
Message-ID: <CA+1E3rKfKaJ7Vi78o5nrG6BCpUf2zvoi8Y_=5GXhum8cBqPCzg@mail.gmail.com>
Subject: Re: [RFC PATCH v3 1/3] io_uring: add helper for uring_cmd completion
 in submitter-task
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>,
        Keith Busch <kbusch@kernel.org>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        anuj20.g@samsung.com, Javier Gonzalez <javier.gonz@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Selvakumar S <selvakuma.s1@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Mar 18, 2021 at 11:18 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Thu, Mar 18, 2021 at 10:55:55AM +0530, Kanchan Joshi wrote:
> > I started with that, but the problem was implementing the driver callback .
> > The callbacks receive only one argument which is "struct callback_head
> > *", and the driver needs to extract "io_uring_cmd *" out of it.
> > This part -
> > +static void uring_cmd_work(struct callback_head *cb)
> > +{
> > +     struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
> > +     struct io_uring_cmd *cmd = &req->uring_cmd;
> >
> > If the callback has to move to the driver (nvme), the driver needs
> > visibility to "struct io_kiocb" which is uring-local.
> > Do you see a better way to handle this?
>
> Can't you just add a helper in io_uring.c that does something like this:
>
> struct io_uring_cmd *callback_to_io_uring_cmd(struct callback_head *cb)
> {
>         return &container_of(cb, struct io_kiocb, task_work)->uring_cmd;
> }
> EXPORT_SYMBOL_GPL(callback_to_io_uring_cmd);

That solves it, thanks.


--
Kanchan
