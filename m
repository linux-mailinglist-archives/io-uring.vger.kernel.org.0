Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAFF1687CE
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2020 20:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbgBUTvU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Feb 2020 14:51:20 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:36748 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbgBUTvT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Feb 2020 14:51:19 -0500
Received: by mail-lj1-f193.google.com with SMTP id r19so3429389ljg.3
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2020 11:51:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sMlcwb0qfIxnB54OxkPZBnuY7PlSu9icYXwWS1cku5A=;
        b=Rh2Kvn/9O0K9XO9mVOBJUs1rDc0j8FDrDRWNRmPKu45AX7ronnE/BkbYyLcWcXqSkX
         JLdzE2oQyRDKQQ+vCj8PUdJcbJyoTnK4emYqKt4cjXTOwt0/nRqER3WCJl9HXYzgiJoa
         YJEtgeek6kjIz/MkuiymgS5DfdSBLCYuH6fuExgZtmE1egkrX0W72J5Tkj6B+yJk1ij0
         XSUntlnyC2VnmUc43Tv7Rx7zywQZ5D3g4rIm9401iAgXEGDK2HE726vOMqYrHuU/zGep
         exrhURsFl1Iuk3sybeNlvSOO7wswHMq0nQxssCCZrNS+nF/dIKcul55GXiXXFDY9FQ2s
         EGYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sMlcwb0qfIxnB54OxkPZBnuY7PlSu9icYXwWS1cku5A=;
        b=LPVfNfdfMU99OYXS9HUL7Cw72uUcuWsTX7H0ZjmYigg04Qp+73T1Lfwg8r2EH3n+wy
         vOmQ9zflPQ65rEcPCT6dOYJgtJNx0IMbHnXvZcM8cC8xRaJ626r2dPThV/JkxREy2p7O
         mONkZuAXxK1oZHudt43ktUFWj64N3p2v5ovwlJXs/X+13uBPR3fXeedSa5FPycw8zxji
         bkvYOnGE+PTlmT7PP2V2Mlih2Cob45AC3x1mKF1uM0/V4wyQY18lmTKn3LFaYf6HQDng
         CzcWAVHwov+2v1ktjKZVw/6S7D+mK7YGYTbQYV/fCYUK4ResoCn6lghaL5hbK/kR6OZe
         SZoQ==
X-Gm-Message-State: APjAAAVZlAr3xquRpLnroYyr8QtiV5G+XHPAQgDvTGtEXwVcWTIOs/Gj
        D85eK+pVcpP5CIiqHooyfs7AVa4UsnjDFS8uM+7tdw==
X-Google-Smtp-Source: APXvYqzn41UANiHPmfgBoBhKQhlyexhgPiwxthX5WyEoepVm/yy/AAeYwvn6UEINfiFpNd69cLwFEXbhYX6kANilgnE=
X-Received: by 2002:a05:651c:1049:: with SMTP id x9mr23440204ljm.233.1582314677966;
 Fri, 21 Feb 2020 11:51:17 -0800 (PST)
MIME-Version: 1.0
References: <CAD-J=zbKXuF1HCd5yG0oNaizNWZTD3248Oii7xoofQ--EqO3dw@mail.gmail.com>
 <97074e5b-896e-6bd5-3c6e-bfa38bf522c4@kernel.dk> <c5e2ee4f-0934-c365-343f-867c18021c80@kernel.dk>
In-Reply-To: <c5e2ee4f-0934-c365-343f-867c18021c80@kernel.dk>
From:   Glauber Costa <glauber@scylladb.com>
Date:   Fri, 21 Feb 2020 14:51:06 -0500
Message-ID: <CAD-J=zbKMHgnt+Tp0E5+hxt5BWP-uMuh1=HDCzcT8Aer9vhz+A@mail.gmail.com>
Subject: Re: Crash on using the poll ring
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Avi Kivity <avi@scylladb.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 21, 2020 at 2:04 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 2/21/20 7:51 AM, Jens Axboe wrote:
> > On 2/21/20 6:17 AM, Glauber Costa wrote:
> >> Hi
> >>
> >> Today I found a crash when adding code for the poll ring to my implementation.
> >> Kernel is 2b58a38ef46e91edd68eec58bdb817c42474cad6
> >>
> >> Here's how to reproduce:
> >>
> >> code at
> >> https://github.com/glommer/seastar.git branch poll-ring
> >>
> >> 1. same as previous steps to configure seastar, but compile with:
> >> ninja -C build/release apps/io_tester/io_tester
> >>
> >> 2. Download the yaml file attached
> >>
> >> 3. Run with:
> >>
> >> ./build/release/apps/io_tester/io_tester --conf ~/test.yaml --duration
> >> 15 --directory /var/disk1  --reactor-backend=uring --smp 1
> >>
> >> (directory must be on xfs because we do c++ but we're not savages)
> >
> > This is due to killing the dummy callback function on the task work.
> > I'll play with this a bit and see how we can fix it.
>
> I re-did the code to use task_works instead, can you try the current
> one? Same branch, sha is currently 9ba3cd1b8923.

Tnx. I don't see a crash any longer.


>
> --
> Jens Axboe
>
