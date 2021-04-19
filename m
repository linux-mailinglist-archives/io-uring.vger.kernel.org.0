Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84908363F6E
	for <lists+io-uring@lfdr.de>; Mon, 19 Apr 2021 12:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236493AbhDSKVa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Apr 2021 06:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232245AbhDSKVX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Apr 2021 06:21:23 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2554CC06174A
        for <io-uring@vger.kernel.org>; Mon, 19 Apr 2021 03:20:38 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id w186so13333848wmg.3
        for <io-uring@vger.kernel.org>; Mon, 19 Apr 2021 03:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=zDOgm7QQJiSgmZosQ/GCHUzYFU6WfA4mTlruenthzJI=;
        b=YfQC3Rr8CfylmX5YbevF3j+SnU9RbHGzMnEA8cHNVCwX1Rmsrtl6PVTxa6u/pLX1GN
         3asMKeIiPDGHEPxHhDVUtuDAawXKOYwrUr+tV1a7SnxH0EqvDnm/Gw2T8ylrmgvJhYKa
         Fk9vyfKF60yYUss07qQrtO0+R3FxnnbhmvilJh86f4wcmtFMHxDfEIifrl3rSHv+y0Ry
         Ws3Wul9PDAt6mmbYxI458kLoq8NDh/DktJFOWlIQkk+n3B5k4n1gYOEUUi+vkifst+b6
         VthWyUr/11f2Af/8K0M44wAYBtISRI+WUapoOJUWmpm5NLUGdSaar4N/Wj4cgV/fsT2c
         P1Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zDOgm7QQJiSgmZosQ/GCHUzYFU6WfA4mTlruenthzJI=;
        b=NXii+26G+fnGl+tWCOz7Ym8RhIuYRDjZffm+VeSxJnX8AOSiy2verTZb82tg8M42sG
         DRwWFZCSApP8JvsW9yGRKEd3xTlyW2DA+1iGrA6Gw2wl+/pPo2u46CGYZnWJQVF0N8bD
         U0DtE7LT7q5e92WabgxWYa2mwUxLhgWkZJFU3UG6inXZel5f4qZvh1M+d2+e4ORiz6MW
         dS/Unf4xlmt/hqt+VAK4NmHlP0Xge4J8MQGME5jY3bXYZa8xgjMhp/tRCYDU9oaerit7
         w7wi+N3BlTCMLlbSBCx2M2BJSqWZBt2eXxR9ye025yTUcZ6QJx5xBdVhIlWX/qBMv42P
         9OVQ==
X-Gm-Message-State: AOAM533ULLRfcqdyvLNWm/6KB6XamQvs/giDwGnPSLypVDwe475/YwqS
        5jtLJz4OOsYzPSMBF7nhXthdgQ+tGwnGQg==
X-Google-Smtp-Source: ABdhPJx8sz8gYiA7jzWPaohgPnaoDsPCwT6xwa4FHeAWkh0lWkLFg7T8/1FCRH0IAvB0QeaiQtxE7Q==
X-Received: by 2002:a1c:a9d5:: with SMTP id s204mr21147580wme.24.1618827636717;
        Mon, 19 Apr 2021 03:20:36 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.232.103])
        by smtp.gmail.com with ESMTPSA id h63sm19388351wmh.13.2021.04.19.03.20.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 03:20:36 -0700 (PDT)
Subject: Re: io_uring networking performance degradation
To:     Michael Stoler <michaels@reduxio.com>, io-uring@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
References: <CAN633em2Kq-F_B_LPWWDpadTYbetRsf9q4Gy6nFgM8BujSueZQ@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <6d9d2610-e7c0-ad29-fd30-85da8222ab83@gmail.com>
Date:   Mon, 19 Apr 2021 11:20:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <CAN633em2Kq-F_B_LPWWDpadTYbetRsf9q4Gy6nFgM8BujSueZQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/19/21 10:13 AM, Michael Stoler wrote:
> We are trying to reproduce reported on page
> https://github.com/frevib/io_uring-echo-server/blob/master/benchmarks/benchmarks.md
> results with a more realistic environment:
> 1. Internode networking in AWS cluster with i3.16xlarge nodes type(25
> Gigabit network connection between client and server)
> 2. 128 and 2048 packet sizes, to simulate typical payloads
> 3. 10 clients to get 75-95% CPU utilization by server to simulate
> server's normal load
> 4. 20 clients to get 100% CPU utilization by server to simulate
> server's hard load
> 
> Software:
> 1. OS: Ubuntu 20.04.2 LTS HWE with 5.8.0-45-generic kernel with latest liburing
> 2. io_uring-echo-server: https://github.com/frevib/io_uring-echo-server
> 3. epoll-echo-server: https://github.com/frevib/epoll-echo-server
> 4. benchmark: https://github.com/haraldh/rust_echo_bench
> 5. all commands runs with "hwloc-bind os=eth1"
> 
> The results are confusing, epoll_echo_server shows stable advantage
> over io_uring-echo-server, despite reported advantage of
> io_uring-echo-server:
> 
> 128 bytes packet size, 10 clients, 75-95% CPU core utilization by server:
> echo_bench --address '172.22.117.67:7777' -c 10 -t 60 -l 128
> epoll_echo_server:      Speed: 80999 request/sec, 80999 response/sec
> io_uring_echo_server:   Speed: 74488 request/sec, 74488 response/sec
> epoll_echo_server is 8% faster
> 
> 128 bytes packet size, 20 clients, 100% CPU core utilization by server:
> echo_bench --address '172.22.117.67:7777' -c 20 -t 60 -l 128
> epoll_echo_server:      Speed: 129063 request/sec, 129063 response/sec
> io_uring_echo_server:    Speed: 102681 request/sec, 102681 response/sec
> epoll_echo_server is 25% faster
> 
> 2048 bytes packet size, 10 clients, 75-95% CPU core utilization by server:
> echo_bench --address '172.22.117.67:7777' -c 10 -t 60 -l 2048
> epoll_echo_server:       Speed: 74421 request/sec, 74421 response/sec
> io_uring_echo_server:    Speed: 66510 request/sec, 66510 response/sec
> epoll_echo_server is 11% faster
> 
> 2048 bytes packet size, 20 clients, 100% CPU core utilization by server:
> echo_bench --address '172.22.117.67:7777' -c 20 -t 60 -l 2048
> epoll_echo_server:       Speed: 108704 request/sec, 108704 response/sec
> io_uring_echo_server:    Speed: 85536 request/sec, 85536 response/sec
> epoll_echo_server is 27% faster
> 
> Why io_uring shows consistent performance degradation? What is going wrong?

5.8 is pretty old, and I'm not sure all the performance problems were
addressed there. Apart from missing common optimisations as you may
have seen in the thread, it looks to me it doesn't have sighd(?) lock
hammering fix. Jens, knows better it has been backported or not.

So, things you can do:
1) try out 5.12
2) attach `perf top` output or some other profiling for your 5.8
3) to have a more complete picture do 2) with 5.12

Let's find what's gone wrong

-- 
Pavel Begunkov
