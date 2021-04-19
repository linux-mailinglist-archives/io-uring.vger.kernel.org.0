Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27127364611
	for <lists+io-uring@lfdr.de>; Mon, 19 Apr 2021 16:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239402AbhDSO2F (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Apr 2021 10:28:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239296AbhDSO2F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Apr 2021 10:28:05 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E07C06174A
        for <io-uring@vger.kernel.org>; Mon, 19 Apr 2021 07:27:35 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id 30so16927211qva.9
        for <io-uring@vger.kernel.org>; Mon, 19 Apr 2021 07:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=reduxio-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HZsl47hv3OqJUPa50NSijNJ6NWasIdAv/fvwRrtm4dY=;
        b=PNfGaIBy7I/rbHRUvfVITocKWMPitOroA3mMaLkBjyjEa2xU8saYIn4HSjLFkmoMGV
         ICTeyFOMlN7i+kYIF8xo7zZBKNp+BfRX/sx1OaZza4MfSvt+7I2qaacJn/VbDC8Zr+oI
         5A9g6wULQv6tDdYY2iQNnXUTESVjDltMcM6jKaXNU/Z//pCmiM2nShU5U6/2bIPbM9Fe
         cGO8ej8pz8q9w5Ln1KfOfZQP6DmUXsEZ5ZyUYq9iJXBCJfGzX0KhGBUhEKXpD1DXEG7N
         YOqq+brn/7Nzda9rLzTBhN8N3/Pr0tjbsiRNpj0+vpY78NHnqDHkZF2Eco7SKtKDecLo
         LG6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HZsl47hv3OqJUPa50NSijNJ6NWasIdAv/fvwRrtm4dY=;
        b=pgGzKsswk3WkWutdD0p7xr5C//UpGXbYPaXhXmtMr4ACH4k6qNUeYqOsMCoxidRul+
         EtYz3Qf+dMOiMEpU3FknDuTA0beBmdBNBEv0GV/jBYq4K1AAh/15m8GCG6+llVtKvboO
         N5wJ7yCFFLv4Pj5m7eF+wqlHA8iWDFdnsbViF66KVS46TqIGOIpRt8z/r7b/EiOIjCd5
         Yfj8w6W16DWA0LrcpW/FKLYIDP9gKlSFR5S9eE2ZNi/D9rCELW28JrQVuND3VyhOhd3Q
         U9ukirqdGMrhlJBggPqq/eM1nep8ebA3iNM+hcQCOCBTmmBoEIVlIUyIPqfM2FfP8+8j
         eNQw==
X-Gm-Message-State: AOAM533HbKBAsoTF2ffhpHjF5ZRa5Z2tf+onuKsgtdEyr8k13FkoineJ
        6FKOO4UDYLFcy92TgrcQ9rwCXTWeR8s4rn1O4SBuDJzKWSchJg==
X-Google-Smtp-Source: ABdhPJzTqSW2OEKsyKIf97Zy5227Mz/wCz0Cdsd7Ouh7/20GKp4kSbgUzg1c8TXuYVAwVQ+g9IJd7v66JOE297RlkSw=
X-Received: by 2002:ad4:4ccd:: with SMTP id i13mr22333752qvz.60.1618842454814;
 Mon, 19 Apr 2021 07:27:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAN633em2Kq-F_B_LPWWDpadTYbetRsf9q4Gy6nFgM8BujSueZQ@mail.gmail.com>
 <6d9d2610-e7c0-ad29-fd30-85da8222ab83@gmail.com>
In-Reply-To: <6d9d2610-e7c0-ad29-fd30-85da8222ab83@gmail.com>
From:   Michael Stoler <michaels@reduxio.com>
Date:   Mon, 19 Apr 2021 17:27:23 +0300
Message-ID: <CAN633emhHEo3x6S77ZszzNRr4F6Xt8aP3VDn6w3GSRtNz5Qeww@mail.gmail.com>
Subject: Re: io_uring networking performance degradation
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1)  linux-5.12-rc8 shows generally same picture:

average load, 70-85% CPU core usage, 128 bytes packets
    echo_bench --address '172.22.150.170:7777' --number 10 --duration
60 --length 128`
epoll-echo-server:      Speed: 71513 request/sec, 71513 response/sec
io_uring_echo_server:   Speed: 64091 request/sec, 64091 response/sec
    epoll-echo-server is 11% faster

high load, 95-100% CPU core usage, 128 bytes packets
    echo_bench --address '172.22.150.170:7777' --number 20 --duration
60 --length 128`
epoll-echo-server:      Speed: 130186 request/sec, 130186 response/sec
io_uring_echo_server:   Speed: 109793 request/sec, 109793 response/sec
    epoll-echo-server is 18% faster

average load, 70-85% CPU core usage, 2048 bytes packets
    echo_bench --address '172.22.150.170:7777' --number 10 --duration
60 --length 2048`
epoll-echo-server:      Speed: 63082 request/sec, 63082 response/sec
io_uring_echo_server:   Speed: 59449 request/sec, 59449 response/sec
    epoll-echo-server is 6% faster

high load, 95-100% CPU core usage, 2048 bytes packets
    echo_bench --address '172.22.150.170:7777' --number 20 --duration
60 --length 2048`
epoll-echo-server:      Speed: 110402 request/sec, 110402 response/sec
io_uring_echo_server:   Speed: 88718 request/sec, 88718 response/sec
    epoll-echo-server is 24% faster


2-3) The "perf top" doesn't work stable with Ubuntu over AWS. All the
time it shows errors: "Uhhuh. NMI received for unknown reason", "Do
you have a strange power saving mode enabled?",  "Dazed and confused,
but trying to continue".

Regards
    Michael Stoler

On Mon, Apr 19, 2021 at 1:20 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 4/19/21 10:13 AM, Michael Stoler wrote:
> > We are trying to reproduce reported on page
> > https://github.com/frevib/io_uring-echo-server/blob/master/benchmarks/benchmarks.md
> > results with a more realistic environment:
> > 1. Internode networking in AWS cluster with i3.16xlarge nodes type(25
> > Gigabit network connection between client and server)
> > 2. 128 and 2048 packet sizes, to simulate typical payloads
> > 3. 10 clients to get 75-95% CPU utilization by server to simulate
> > server's normal load
> > 4. 20 clients to get 100% CPU utilization by server to simulate
> > server's hard load
> >
> > Software:
> > 1. OS: Ubuntu 20.04.2 LTS HWE with 5.8.0-45-generic kernel with latest liburing
> > 2. io_uring-echo-server: https://github.com/frevib/io_uring-echo-server
> > 3. epoll-echo-server: https://github.com/frevib/epoll-echo-server
> > 4. benchmark: https://github.com/haraldh/rust_echo_bench
> > 5. all commands runs with "hwloc-bind os=eth1"
> >
> > The results are confusing, epoll_echo_server shows stable advantage
> > over io_uring-echo-server, despite reported advantage of
> > io_uring-echo-server:
> >
> > 128 bytes packet size, 10 clients, 75-95% CPU core utilization by server:
> > echo_bench --address '172.22.117.67:7777' -c 10 -t 60 -l 128
> > epoll_echo_server:      Speed: 80999 request/sec, 80999 response/sec
> > io_uring_echo_server:   Speed: 74488 request/sec, 74488 response/sec
> > epoll_echo_server is 8% faster
> >
> > 128 bytes packet size, 20 clients, 100% CPU core utilization by server:
> > echo_bench --address '172.22.117.67:7777' -c 20 -t 60 -l 128
> > epoll_echo_server:      Speed: 129063 request/sec, 129063 response/sec
> > io_uring_echo_server:    Speed: 102681 request/sec, 102681 response/sec
> > epoll_echo_server is 25% faster
> >
> > 2048 bytes packet size, 10 clients, 75-95% CPU core utilization by server:
> > echo_bench --address '172.22.117.67:7777' -c 10 -t 60 -l 2048
> > epoll_echo_server:       Speed: 74421 request/sec, 74421 response/sec
> > io_uring_echo_server:    Speed: 66510 request/sec, 66510 response/sec
> > epoll_echo_server is 11% faster
> >
> > 2048 bytes packet size, 20 clients, 100% CPU core utilization by server:
> > echo_bench --address '172.22.117.67:7777' -c 20 -t 60 -l 2048
> > epoll_echo_server:       Speed: 108704 request/sec, 108704 response/sec
> > io_uring_echo_server:    Speed: 85536 request/sec, 85536 response/sec
> > epoll_echo_server is 27% faster
> >
> > Why io_uring shows consistent performance degradation? What is going wrong?
>
> 5.8 is pretty old, and I'm not sure all the performance problems were
> addressed there. Apart from missing common optimisations as you may
> have seen in the thread, it looks to me it doesn't have sighd(?) lock
> hammering fix. Jens, knows better it has been backported or not.
>
> So, things you can do:
> 1) try out 5.12
> 2) attach `perf top` output or some other profiling for your 5.8
> 3) to have a more complete picture do 2) with 5.12
>
> Let's find what's gone wrong
>
> --
> Pavel Begunkov



-- 
Michael Stoler
