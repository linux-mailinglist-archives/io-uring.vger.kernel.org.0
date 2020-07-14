Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9503521EFD5
	for <lists+io-uring@lfdr.de>; Tue, 14 Jul 2020 13:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgGNL4E (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jul 2020 07:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgGNL4D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jul 2020 07:56:03 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5B65C061755
        for <io-uring@vger.kernel.org>; Tue, 14 Jul 2020 04:56:02 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id h28so16794299edz.0
        for <io-uring@vger.kernel.org>; Tue, 14 Jul 2020 04:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+sjMIjM2/JFepdRAXpOHb7ghC5LhQeVZQ0Kayo5azeY=;
        b=BWruN3AFlA46ZLoJRaXr2SIqdS24ok0rzjPKi9syKMhMKh0JxzioNs8EdhKj+fmaW8
         LtFlAX3lpklg05W9WQ2EZYCE821vzWc7x2++w2jVILwn2boWbSBMsrC6/5ApTmFgISg3
         lazdTrnPmPdLzow7yla7Nzl2D4pVlMvE8cJJk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+sjMIjM2/JFepdRAXpOHb7ghC5LhQeVZQ0Kayo5azeY=;
        b=gnfV4I5Lg5EHadotU5zDdKkM9c5Y417+Hy4owI8jm/uuYeUK4D2kqZMmLuPZvDCMya
         jspmy8yZAQGqazNBZLyKJV1SDLezhYD5MPuu0in7wzG/FpeGrfttAmBTH2wY1VrfX6Qd
         gMW5BhOWlhUfVlDmP4fSd9HmCA39FcFqWjGO2CY3wioFtCKrgDYZHowC2yk0XuGVXbYT
         aAOM5gJ4Y2LIg/Lbi1vTrYgYKEFo12lYZ5CQdLg2bd2atZ/SDIGn1PiZsJsn+kzS+RUy
         gqAHAvUY4eiKYwvG2KqDpkUeG4bbPDieNkicJvV0VGrSw6X4hKE2HxxWD4sYCSOO5lup
         wJ3w==
X-Gm-Message-State: AOAM532Zc6b49ybE3sili3TjPyJ+Sd6paoPxd8VeKcUIigzQe/bGeFls
        9kAywg12OM8tP4yH4vxT9MC0beXRIcS3ZVaZv9eKYg==
X-Google-Smtp-Source: ABdhPJx7T4CbUMQ5B2n8Maq8US8S/XJNlgydPVNLLLOLr6IH9mheDQ+RV1Tk59Uievz5SqNyI1kTrxdL9hey9Cb11rE=
X-Received: by 2002:a05:6402:1d0b:: with SMTP id dg11mr3988736edb.212.1594727761659;
 Tue, 14 Jul 2020 04:56:01 -0700 (PDT)
MIME-Version: 1.0
References: <CAODFU0q6CrUB_LkSdrbp5TQ4Jm6Sw=ZepZwD-B7-aFudsOvsig@mail.gmail.com>
 <20200705115021.GA1227929@kroah.com> <20200714065110.GA8047@amd>
 <CAJfpegu8AXZWQh3W39PriqxVna+t3D2pz23t_4xEVxGcNf1AUA@mail.gmail.com> <4e92b851-ce9a-e2f6-3f9a-a4d47219d320@gmail.com>
In-Reply-To: <4e92b851-ce9a-e2f6-3f9a-a4d47219d320@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 14 Jul 2020 13:55:50 +0200
Message-ID: <CAJfpegvroouw5ndHv+395w5PP1c+pUyp=-T8qhhvSnFbhbRehg@mail.gmail.com>
Subject: Re: [PATCH 0/3] readfile(2): a new syscall to make open/read/close faster
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Pavel Machek <pavel@denx.de>, Greg KH <gregkh@linuxfoundation.org>,
        Jan Ziak <0xe2.0x9a.0x9b@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        linux-man <linux-man@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>, shuah@kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 14, 2020 at 1:36 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 14/07/2020 11:07, Miklos Szeredi wrote:
> > On Tue, Jul 14, 2020 at 8:51 AM Pavel Machek <pavel@denx.de> wrote:
> >>
> >> Hi!
> >>
> >>>> At first, I thought that the proposed system call is capable of
> >>>> reading *multiple* small files using a single system call - which
> >>>> would help increase HDD/SSD queue utilization and increase IOPS (I/O
> >>>> operations per second) - but that isn't the case and the proposed
> >>>> system call can read just a single file.
> >>>
> >>> If you want to do this for multple files, use io_ring, that's what it
> >>> was designed for.  I think Jens was going to be adding support for the
> >>> open/read/close pattern to it as well, after some other more pressing
> >>> features/fixes were finished.
> >>
> >> What about... just using io_uring for single file, too? I'm pretty
> >> sure it can be wrapped in a library that is simple to use, avoiding
> >> need for new syscall.
> >
> > Just wondering:  is there a plan to add strace support to io_uring?
> > And I don't just mean the syscalls associated with io_uring, but
> > tracing the ring itself.
>
> What kind of support do you mean? io_uring is asynchronous in nature
> with all intrinsic tracing/debugging/etc. problems of such APIs.
> And there are a lot of handy trace points, are those not enough?
>
> Though, this can be an interesting project to rethink how async
> APIs are worked with.

Yeah, it's an interesting problem.  The uring has the same events, as
far as I understand, that are recorded in a multithreaded strace
output (syscall entry, syscall exit); nothing more is needed.

I do think this needs to be integrated into strace(1), otherwise the
usefulness of that tool (which I think is *very* high) would go down
drastically as io_uring usage goes up.

Thanks,
Miklos
