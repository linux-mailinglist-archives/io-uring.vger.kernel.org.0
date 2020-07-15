Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9F00220795
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2020 10:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730327AbgGOIlg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jul 2020 04:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729373AbgGOIlf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jul 2020 04:41:35 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6434C08C5C1
        for <io-uring@vger.kernel.org>; Wed, 15 Jul 2020 01:41:34 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id d16so973471edz.12
        for <io-uring@vger.kernel.org>; Wed, 15 Jul 2020 01:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J4RPEf69RMf6fMrFPs7gvn650I5l4fPXkmLiZzrYicg=;
        b=joTTxszSLFMvayIfPbb55BXWK7XCzUWZDla2m5tAeog6qXLfmJE5dj+uRo2NBF9wZ/
         F7i8zd8hr0+Qxym6zB6l97h72NSaZ/5NKdHBEnj5J1feDVUpr1YfOMLXfk4KLNiTdWYK
         3mrklvsXTJ1W+NqzIijFYhkfbdrl3pBNpY49Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J4RPEf69RMf6fMrFPs7gvn650I5l4fPXkmLiZzrYicg=;
        b=q7kCgRpONl0g5mgUFFzLqPuPHt8qtHFfmGj3IaUSQhmyzw38Tk/iHE9+vjN1vHzh7a
         0xH87FC6rw4d6Koerj7D1oN3MUERpbWKCGuKc7iR7v7UNDmjTZX3WEn2hV3FVnJpOXs6
         Qt/QtYrceknRxkNdjzlIn/hzLJ3Wu4GOCPs2Y/pv2YQRgGa9gyuxemRbYT7UV7/p4SwW
         GZIxqUso0bCN7pbbQo4jl18CEQT6rN25ZvNm14DFKNmPFQJ911R7tZUuPPHt39VLvCoC
         G+6NhOjfnfm2elgjQ+/2TnPw0XlWelj6OqA9+uKJQQI71bEvQP9b8IRbZIR6lSvxEK90
         jqcg==
X-Gm-Message-State: AOAM533JMFMxGMtLH78JJXbeWYS+HMOftL46u3Y8w8eZw4pKDKvXUvMO
        HALamlZH6SHYNAw66HWQuF4bfJ8BvZcwmNP5XSqjcA==
X-Google-Smtp-Source: ABdhPJxiUoXSY8oQTuQyEBhp5lraS2n1iwGYDCrETHXVLFmYYXHH1CsTFd5Uc/EepPXHKcXFh5OP0Y7UW1nxbUoUAJg=
X-Received: by 2002:a05:6402:1687:: with SMTP id a7mr8448226edv.358.1594802493290;
 Wed, 15 Jul 2020 01:41:33 -0700 (PDT)
MIME-Version: 1.0
References: <CAODFU0q6CrUB_LkSdrbp5TQ4Jm6Sw=ZepZwD-B7-aFudsOvsig@mail.gmail.com>
 <20200705115021.GA1227929@kroah.com> <20200714065110.GA8047@amd>
 <CAJfpegu8AXZWQh3W39PriqxVna+t3D2pz23t_4xEVxGcNf1AUA@mail.gmail.com>
 <4e92b851-ce9a-e2f6-3f9a-a4d47219d320@gmail.com> <CAJfpegvroouw5ndHv+395w5PP1c+pUyp=-T8qhhvSnFbhbRehg@mail.gmail.com>
 <7584d754-2044-a892-cf29-65259b9c4eb1@gmail.com>
In-Reply-To: <7584d754-2044-a892-cf29-65259b9c4eb1@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 15 Jul 2020 10:41:22 +0200
Message-ID: <CAJfpegvkw5Exptz=gY5bRy2U8GjvTo+muBHsgdF_PA5=hyhmSA@mail.gmail.com>
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

On Wed, Jul 15, 2020 at 10:33 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 14/07/2020 14:55, Miklos Szeredi wrote:
> > On Tue, Jul 14, 2020 at 1:36 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
> >>
> >> On 14/07/2020 11:07, Miklos Szeredi wrote:
> >>> On Tue, Jul 14, 2020 at 8:51 AM Pavel Machek <pavel@denx.de> wrote:
> >>>>
> >>>> Hi!
> >>>>
> >>>>>> At first, I thought that the proposed system call is capable of
> >>>>>> reading *multiple* small files using a single system call - which
> >>>>>> would help increase HDD/SSD queue utilization and increase IOPS (I/O
> >>>>>> operations per second) - but that isn't the case and the proposed
> >>>>>> system call can read just a single file.
> >>>>>
> >>>>> If you want to do this for multple files, use io_ring, that's what it
> >>>>> was designed for.  I think Jens was going to be adding support for the
> >>>>> open/read/close pattern to it as well, after some other more pressing
> >>>>> features/fixes were finished.
> >>>>
> >>>> What about... just using io_uring for single file, too? I'm pretty
> >>>> sure it can be wrapped in a library that is simple to use, avoiding
> >>>> need for new syscall.
> >>>
> >>> Just wondering:  is there a plan to add strace support to io_uring?
> >>> And I don't just mean the syscalls associated with io_uring, but
> >>> tracing the ring itself.
> >>
> >> What kind of support do you mean? io_uring is asynchronous in nature
> >> with all intrinsic tracing/debugging/etc. problems of such APIs.
> >> And there are a lot of handy trace points, are those not enough?
> >>
> >> Though, this can be an interesting project to rethink how async
> >> APIs are worked with.
> >
> > Yeah, it's an interesting problem.  The uring has the same events, as
> > far as I understand, that are recorded in a multithreaded strace
> > output (syscall entry, syscall exit); nothing more is needed>
> > I do think this needs to be integrated into strace(1), otherwise the
> > usefulness of that tool (which I think is *very* high) would go down
> > drastically as io_uring usage goes up.
>
> Not touching the topic of usefulness of strace + io_uring, but I'd rather
> have a tool that solves a problem, than a problem that created and honed
> for a tool.

Sorry, I'm not getting the metaphor.  Can you please elaborate?

Thanks,
Miklos
