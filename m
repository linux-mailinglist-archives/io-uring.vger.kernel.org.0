Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A073436A658
	for <lists+io-uring@lfdr.de>; Sun, 25 Apr 2021 11:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbhDYJxJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Apr 2021 05:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhDYJxI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Apr 2021 05:53:08 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F26C061574
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 02:52:28 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id c6so39608912qtc.1
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 02:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=reduxio-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LMBNtwNdsegOtzvgkIzFGnumPYe/dlYwir60acgKtks=;
        b=YjXwzamewNotcANQRvKL9mpcMFEj8be8D4TCKP5zVpo7eHxcVMdhLAwGQuJka4AkVx
         Qki20NyT3LcD8wHbjIXWlp4ir4q8iHy+tn/uIkh/eBpdsEMhPpFVun5+Zv7ZW4KCoOeB
         VfXGSt8NYB5Eh7CV3ya7v8jApeYNCxrVnJN61wRwePIcF/NnQtVjOQmgaBl/TcpXiszL
         D13dLh+pe/Gyf5DyhYNh6jIXOKy4bPne1DIDGXXTUvXYHKNa+Vuf+gsRr89q8tszMK2Y
         Pkfdz8fZ2pqJ6ohM4cZW2AZEOVjah9jBmEERJDq1YcW/+vUlBlSI+p/F/Nt9z76mUzuB
         ECFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LMBNtwNdsegOtzvgkIzFGnumPYe/dlYwir60acgKtks=;
        b=AQxpChtFrON77YB12DTmPhLgLkQnhpNxJMmbRjffw1GjXl5UzKkBKiE3KrQGN4jtQ0
         fRUxkkPkLiG93W/UPO7gqCeeH0KVbh6S7YWU2/gE8DJ7y7txR89SU2L5EwqbogHGjRJ0
         6Ri6A3AP3u0512Bxvzpf7g+rRQ4+qYeOuQ9fv+M+a/HqasnZYMtQOtrd+4sbdmfyXsAP
         zPmTuTM5Y83SxaXNs7qpjb2A1L4EaDPw6SBBKdzRmTxwwPLyLn7A6Arw2Azy1oJyqznw
         6SdMUDHnZyXwalEOdxVPAEcfZfqGmZhFFYYOkzswxgaNjsBGnT8W1qLGzKJ5F1iqJ8Eu
         KKMw==
X-Gm-Message-State: AOAM532wG6FX+b8t7l8SqeLQzSmd4yWld2Idsff85W1m+YUSIP9cAUgT
        kiFNYXet75TCM4WnDSH/v3dZ8htLbOFJudqd7Y+9zQ==
X-Google-Smtp-Source: ABdhPJxJzVfrp+lMi+b8jRupdu/TpZz1C8tRB+pxriFxxprlqsd+FSQpHwfP4yBuygB3juYO7Hre1xWpSjO4SrQ3Hos=
X-Received: by 2002:a05:622a:6:: with SMTP id x6mr11641433qtw.1.1619344347259;
 Sun, 25 Apr 2021 02:52:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAN633em2Kq-F_B_LPWWDpadTYbetRsf9q4Gy6nFgM8BujSueZQ@mail.gmail.com>
 <6d9d2610-e7c0-ad29-fd30-85da8222ab83@gmail.com> <CAN633emhHEo3x6S77ZszzNRr4F6Xt8aP3VDn6w3GSRtNz5Qeww@mail.gmail.com>
 <CAN633emWn60bbFqCF7Yxu4XDFiBXq5Z_BE5NZdX2qwQP8ju=_A@mail.gmail.com>
In-Reply-To: <CAN633emWn60bbFqCF7Yxu4XDFiBXq5Z_BE5NZdX2qwQP8ju=_A@mail.gmail.com>
From:   Michael Stoler <michaels@reduxio.com>
Date:   Sun, 25 Apr 2021 12:52:16 +0300
Message-ID: <CAN633e=OkHW-hYNhCgQLakRu4SjUXD5Ut8UYsrvTzwH54U4mzA@mail.gmail.com>
Subject: Re: io_uring networking performance degradation
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Because of unstable working of perf over AWS VM I recheck test on
physical machine: Ubuntu 20.04, 5.8.0-50-generic kernel, CPU AMD EPYC
7272 12-Core Processor 3200MHz, BogoMIPS 5789.39, NIC melanox 5,
Speed: 25000Mb/s Full Duplex.
Over physical machine performance degradation is much less pronounced
but still exists:
io_uring-echo-server    Speed: 143081 request/sec, 143081 response/sec
epoll-echo-server   Speed: 150692 request/sec, 150692 response/sec
epoll-echo-server is 5% faster

"perf top" with io_uring-echo-server:
PerfTop:   16481 irqs/sec  kernel:98.5%  exact: 99.8% lost: 0/0 drop:
0/0 [4000Hz cycles],  (all, 24 CPUs)
-------------------------------------------------------------------------------
     8.66%  [kernel]          [k] __x86_indirect_thunk_rax
     8.49%  [kernel]          [k] copy_user_generic_string
     5.57%  [kernel]          [k] memset
     2.81%  [kernel]          [k] tcp_rate_skb_sent
     2.32%  [kernel]          [k] __alloc_skb
     2.16%  [kernel]          [k] __check_object_size
     1.44%  [unknown]         [k] 0xffffffffc100c296
     1.28%  [kernel]          [k] tcp_write_xmit
     1.22%  [kernel]          [k] iommu_dma_map_page
     1.16%  [kernel]          [k] kmem_cache_free
     1.14%  [kernel]          [k] __softirqentry_text_start
     1.06%  [unknown]         [k] 0xffffffffc1008a7e
     1.03%  [kernel]          [k] __skb_datagram_iter
     0.97%  [kernel]          [k] __dev_queue_xmit
     0.86%  [kernel]          [k] ipv4_mtu
     0.85%  [kernel]          [k] tcp_schedule_loss_probe
     0.80%  [kernel]          [k] tcp_release_cb
     0.78%  [unknown]         [k] 0xffffffffc100c290
     0.77%  [unknown]         [k] 0xffffffffc100c295
     0.76%  perf              [.] __symbols__insert

"perf top" with epoll-echo-server:
PerfTop:   24255 irqs/sec  kernel:98.3%  exact: 99.6% lost: 0/0 drop:
0/0 [4000Hz cycles],  (all, 24 CPUs)
-------------------------------------------------------------------------------
     8.77%  [kernel]          [k] __x86_indirect_thunk_rax
     7.50%  [kernel]          [k] copy_user_generic_string
     4.10%  [kernel]          [k] memset
     2.70%  [kernel]          [k] tcp_rate_skb_sent
     2.18%  [kernel]          [k] __check_object_size
     2.09%  [kernel]          [k] __alloc_skb
     1.61%  [unknown]         [k] 0xffffffffc100c296
     1.47%  [kernel]          [k] __virt_addr_valid
     1.40%  [kernel]          [k] iommu_dma_map_page
     1.37%  [unknown]         [k] 0xffffffffc1008a7e
     1.22%  [kernel]          [k] tcp_poll
     1.16%  [kernel]          [k] __softirqentry_text_start
     1.15%  [kernel]          [k] tcp_stream_memory_free
     1.07%  [kernel]          [k] tcp_write_xmit
     1.06%  [kernel]          [k] kmem_cache_free
     1.03%  [kernel]          [k] tcp_release_cb
     0.96%  [kernel]          [k] syscall_return_via_sysret
     0.90%  [kernel]          [k] __lock_text_start
     0.82%  [kernel]          [k] __copy_skb_header
     0.81%  [kernel]          [k] amd_iommu_map

Regards
    Michael Stoler

On Tue, Apr 20, 2021 at 1:44 PM Michael Stoler <michaels@reduxio.com> wrote:
>
> Hi, perf data and tops for linux-5.8 are here:
> http://rdxdownloads.rdxdyn.com/michael_stoler_perf_data.tgz
>
> Regards
>     Michael Stoler
>
> On Mon, Apr 19, 2021 at 5:27 PM Michael Stoler <michaels@reduxio.com> wrote:
> >
> > 1)  linux-5.12-rc8 shows generally same picture:
> >
> > average load, 70-85% CPU core usage, 128 bytes packets
> >     echo_bench --address '172.22.150.170:7777' --number 10 --duration
> > 60 --length 128`
> > epoll-echo-server:      Speed: 71513 request/sec, 71513 response/sec
> > io_uring_echo_server:   Speed: 64091 request/sec, 64091 response/sec
> >     epoll-echo-server is 11% faster
> >
> > high load, 95-100% CPU core usage, 128 bytes packets
> >     echo_bench --address '172.22.150.170:7777' --number 20 --duration
> > 60 --length 128`
> > epoll-echo-server:      Speed: 130186 request/sec, 130186 response/sec
> > io_uring_echo_server:   Speed: 109793 request/sec, 109793 response/sec
> >     epoll-echo-server is 18% faster
> >
> > average load, 70-85% CPU core usage, 2048 bytes packets
> >     echo_bench --address '172.22.150.170:7777' --number 10 --duration
> > 60 --length 2048`
> > epoll-echo-server:      Speed: 63082 request/sec, 63082 response/sec
> > io_uring_echo_server:   Speed: 59449 request/sec, 59449 response/sec
> >     epoll-echo-server is 6% faster
> >
> > high load, 95-100% CPU core usage, 2048 bytes packets
> >     echo_bench --address '172.22.150.170:7777' --number 20 --duration
> > 60 --length 2048`
> > epoll-echo-server:      Speed: 110402 request/sec, 110402 response/sec
> > io_uring_echo_server:   Speed: 88718 request/sec, 88718 response/sec
> >     epoll-echo-server is 24% faster
> >
> >
> > 2-3) The "perf top" doesn't work stable with Ubuntu over AWS. All the
> > time it shows errors: "Uhhuh. NMI received for unknown reason", "Do
> > you have a strange power saving mode enabled?",  "Dazed and confused,
> > but trying to continue".
> >
> > Regards
> >     Michael Stoler
> >
> > On Mon, Apr 19, 2021 at 1:20 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
> > >
> > > On 4/19/21 10:13 AM, Michael Stoler wrote:
> > > > We are trying to reproduce reported on page
> > > > https://github.com/frevib/io_uring-echo-server/blob/master/benchmarks/benchmarks.md
> > > > results with a more realistic environment:
> > > > 1. Internode networking in AWS cluster with i3.16xlarge nodes type(25
> > > > Gigabit network connection between client and server)
> > > > 2. 128 and 2048 packet sizes, to simulate typical payloads
> > > > 3. 10 clients to get 75-95% CPU utilization by server to simulate
> > > > server's normal load
> > > > 4. 20 clients to get 100% CPU utilization by server to simulate
> > > > server's hard load
> > > >
> > > > Software:
> > > > 1. OS: Ubuntu 20.04.2 LTS HWE with 5.8.0-45-generic kernel with latest liburing
> > > > 2. io_uring-echo-server: https://github.com/frevib/io_uring-echo-server
> > > > 3. epoll-echo-server: https://github.com/frevib/epoll-echo-server
> > > > 4. benchmark: https://github.com/haraldh/rust_echo_bench
> > > > 5. all commands runs with "hwloc-bind os=eth1"
> > > >
> > > > The results are confusing, epoll_echo_server shows stable advantage
> > > > over io_uring-echo-server, despite reported advantage of
> > > > io_uring-echo-server:
> > > >
> > > > 128 bytes packet size, 10 clients, 75-95% CPU core utilization by server:
> > > > echo_bench --address '172.22.117.67:7777' -c 10 -t 60 -l 128
> > > > epoll_echo_server:      Speed: 80999 request/sec, 80999 response/sec
> > > > io_uring_echo_server:   Speed: 74488 request/sec, 74488 response/sec
> > > > epoll_echo_server is 8% faster
> > > >
> > > > 128 bytes packet size, 20 clients, 100% CPU core utilization by server:
> > > > echo_bench --address '172.22.117.67:7777' -c 20 -t 60 -l 128
> > > > epoll_echo_server:      Speed: 129063 request/sec, 129063 response/sec
> > > > io_uring_echo_server:    Speed: 102681 request/sec, 102681 response/sec
> > > > epoll_echo_server is 25% faster
> > > >
> > > > 2048 bytes packet size, 10 clients, 75-95% CPU core utilization by server:
> > > > echo_bench --address '172.22.117.67:7777' -c 10 -t 60 -l 2048
> > > > epoll_echo_server:       Speed: 74421 request/sec, 74421 response/sec
> > > > io_uring_echo_server:    Speed: 66510 request/sec, 66510 response/sec
> > > > epoll_echo_server is 11% faster
> > > >
> > > > 2048 bytes packet size, 20 clients, 100% CPU core utilization by server:
> > > > echo_bench --address '172.22.117.67:7777' -c 20 -t 60 -l 2048
> > > > epoll_echo_server:       Speed: 108704 request/sec, 108704 response/sec
> > > > io_uring_echo_server:    Speed: 85536 request/sec, 85536 response/sec
> > > > epoll_echo_server is 27% faster
> > > >
> > > > Why io_uring shows consistent performance degradation? What is going wrong?
> > >
> > > 5.8 is pretty old, and I'm not sure all the performance problems were
> > > addressed there. Apart from missing common optimisations as you may
> > > have seen in the thread, it looks to me it doesn't have sighd(?) lock
> > > hammering fix. Jens, knows better it has been backported or not.
> > >
> > > So, things you can do:
> > > 1) try out 5.12
> > > 2) attach `perf top` output or some other profiling for your 5.8
> > > 3) to have a more complete picture do 2) with 5.12
> > >
> > > Let's find what's gone wrong
> > >
> > > --
> > > Pavel Begunkov
> >
> >
> >
> > --
> > Michael Stoler
>
>
>
> --
> Michael Stoler



-- 
Michael Stoler
