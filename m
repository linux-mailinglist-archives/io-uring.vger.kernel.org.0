Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F1524FC4E
	for <lists+io-uring@lfdr.de>; Mon, 24 Aug 2020 13:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgHXLJs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Aug 2020 07:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgHXLJp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Aug 2020 07:09:45 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B061FC061573
        for <io-uring@vger.kernel.org>; Mon, 24 Aug 2020 04:09:45 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id x12so5827445qtp.1
        for <io-uring@vger.kernel.org>; Mon, 24 Aug 2020 04:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=52P7UXXLtXKJ+O/rtTsjXBA2eegnF63DfdlzbqG005M=;
        b=WrYc4/Kx8PJaBaEpHkQksXKE59J1FxQG5vO9LgvG/N0OGz3fNG55OM9FFN6RKCkxzf
         KtI9ZVeTA4u0gnj7Kq+sNQLLgChzD4kYKkT+auckfnPX9R6OnSczcJDo2GNvqa/qZ11+
         i6yojIwAFa5/QD0mwr09bUdsp4zrOL0Q3aIL6SOH1SOltoWGgRfEdA2mobv0bKBoQcsU
         oY6eS4Wd9uXl5uXu2NA6Eh2CYej/zVtn6g6M7hr+ogTwX9vbUfqkL9pDqrsSLxVOFDg/
         IJSQMxsL7x+vL8wNP7lLbSLltgSwiuBe8IX3I+IxJRANqQy6JG52NBtFafxZUYqdHnq1
         n+gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=52P7UXXLtXKJ+O/rtTsjXBA2eegnF63DfdlzbqG005M=;
        b=CX/87k0ltpEW/HAW54AR5Xz+wfSKvbyPebXxAdb0p/pbBVw0/jlqIn5EBAJYNmwYLQ
         8u8sbnQFMK5rwDKh+vSK69LXJ7DaLs8Xl/iTOyzPGWDHPq8vOwAgsxFdkkqnBpJtrQ7X
         Q/xVcXcj9wsjAEXglTZRqNIrrqijMjwvwMoUvvD5v9vuVwAaIMzpsiKsx2n8cMLrNhzr
         fqZN0L5ks7Oj91k+Irc9wO8JSEj8Qg3z5FJqo3Ax9M1fWtW4dK4+M1KolLp5uSTARAkZ
         0C+5r6GmuCv3c768a8DnLLe0gFUl19fSiYWgVc+uhUYv16ih5naeglEvT2xjqbDfsY9G
         EuPQ==
X-Gm-Message-State: AOAM532jmy5Thx9saIMWy/N1ajer65ZziIpEgX5+SVZ/f534Fd0Cej2e
        B/LIkh46lhnN8UJRJEc+7vCDaL8DYbtv47csqi54Jc/sV8G/Dw==
X-Google-Smtp-Source: ABdhPJzKVVzUKdr3m3qByoFOCvf8ZOE5TVXhgVLduELumY8VnYER63GQ4UYeCdOMopv3x7v9tSpYW1+hC9Dz5lhorfY=
X-Received: by 2002:ac8:70cd:: with SMTP id g13mr4221619qtp.53.1598267384432;
 Mon, 24 Aug 2020 04:09:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAF-ewDqBd4gSLGOdHE8g57O_weMTH0B-WbfobJud3h6poH=fBg@mail.gmail.com>
 <7a148c5e-4403-9c8e-cc08-98cd552a7322@kernel.dk>
In-Reply-To: <7a148c5e-4403-9c8e-cc08-98cd552a7322@kernel.dk>
From:   Dmitry Shulyak <yashulyak@gmail.com>
Date:   Mon, 24 Aug 2020 14:09:33 +0300
Message-ID: <CAF-ewDpvLwkiZ3sJMT64e=efCRFYVkt2Z71==1FztLg=vZN8fg@mail.gmail.com>
Subject: Re: Large number of empty reads on 5.9-rc2 under moderate load
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

library that i am using https://github.com/dshulyak/uring
It requires golang 1.14, if installed, benchmark can be run with:
go test ./fs -run=xx -bench=BenchmarkReadAt/uring_8 -benchtime=1000000x
go test ./fs -run=xx -bench=BenchmarkReadAt/uring_5 -benchtime=8000000x

note that it will setup uring instance per cpu, with shared worker pool.
it will take me too much time to implement repro in c, but in general
i am simply submitting multiple concurrent
read requests and watching read rate.



On Mon, 24 Aug 2020 at 13:46, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 8/24/20 4:40 AM, Dmitry Shulyak wrote:
> > In the program, I am submitting a large number of concurrent read
> > requests with o_direct. In both scenarios the number of concurrent
> > read requests is limited to 20 000, with only difference being that
> > for 512b total number of reads is 8millions and for 8kb - 1million. On
> > 5.8.3 I didn't see any empty reads at all.
> >
> > BenchmarkReadAt/uring_512-8              8000000              1879
> > ns/op         272.55 MB/s
> > BenchmarkReadAt/uring_8192-8             1000000             18178
> > ns/op         450.65 MB/s
> >
> > I am seeing the same numbers in iotop, so pretty confident that the
> > benchmark is fine. Below is a version with regular syscalls and
> > threads (note that this is with golang):
> >
> > BenchmarkReadAt/os_512-256               8000000              4393
> > ns/op         116.55 MB/s
> > BenchmarkReadAt/os_8192-256              1000000             18811
> > ns/op         435.48 MB/s
> >
> > I run the same program on 5.9-rc.2 and noticed that for workload with
> > 8kb buffer and 1mill reads I had to make more than 7 millions retries,
> > which obviously makes the program very slow. For 512b and 8million
> > reads there were only 22 000 retries, but it is still very slow for
> > some other reason.
> >
> > BenchmarkReadAt/uring_512-8  8000000       8432 ns/op   60.72 MB/s
> > BenchmarkReadAt/uring_8192-8 1000000      42603 ns/op 192.29 MB/s
> >
> > In iotop i am seeing a huge increase for 8kb, actual disk read goes up
> > to 2gb/s, which looks somewhat suspicious given that my ssd should
> > support only 450mb/s. If I will lower the number of concurrent
> > requests to 1000, then there are almost no empty reads and numbers for
> > 8kb go back to the same level I saw with 5.8.3.
> >
> > Is it a regression or should I throttle submissions?
>
> Since it's performing worse than 5.8, sounds like there is. How can we
> reproduce this?
>
> --
> Jens Axboe
>
