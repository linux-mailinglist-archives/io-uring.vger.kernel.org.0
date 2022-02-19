Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAA784BCABD
	for <lists+io-uring@lfdr.de>; Sat, 19 Feb 2022 22:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbiBSVnJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 19 Feb 2022 16:43:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiBSVnJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 19 Feb 2022 16:43:09 -0500
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664D41DA65;
        Sat, 19 Feb 2022 13:42:45 -0800 (PST)
Received: from [45.44.224.220] (port=44658 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1nLXV5-0002qF-Eg; Sat, 19 Feb 2022 16:42:43 -0500
Message-ID: <cbf791fb3cd495f156eb4aeb4dd01c42fca22cd4.camel@trillion01.com>
Subject: Re: [PATCH v1] io_uring: Add support for napi_busy_poll
From:   Olivier Langlois <olivier@trillion01.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <haoxu@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sat, 19 Feb 2022 16:42:42 -0500
In-Reply-To: <d11e31bd59c75b2cce994dd90a07e769d4e039db.1645257310.git.olivier@trillion01.com>
References: <d11e31bd59c75b2cce994dd90a07e769d4e039db.1645257310.git.olivier@trillion01.com>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.42.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

One side effect that I have discovered from testing the napi_busy_poll
patch, despite improving the network timing of the threads performing
the busy poll, it is the networking performance degradation that it has
on the rest of the system.

I dedicate isolated CPUS to specific threads of my program. My kernel
is compiled with CONFIG_NO_HZ_FULL. One thing that I have never really
understood is why there were still kernel threads assigned to the
isolated CPUs.

$ CORENUM=2; ps -L -e -o pid,psr,cpu,cmd | grep -E 
"^[[:space:]]+[[:digit:]]+[[:space:]]+${CORENUM}"
     24   2   - [cpuhp/2]
     25   2   - [idle_inject/2]
     26   2   - [migration/2]
     27   2   - [ksoftirqd/2]
     28   2   - [kworker/2:0-events]
     29   2   - [kworker/2:0H]
     83   2   - [kworker/2:1-mm_percpu_wq]

It is very hard to keep the CPU 100% tickless if there are still tasks
assigned to isolated CPUs by the kernel.

This question isn't really answered anywhere AFAIK:
https://www.kernel.org/doc/html/latest/timers/no_hz.html
https://jeremyeder.com/2013/11/15/nohz_fullgodmode/

Those threads running on their dedicated CPUS are the ones doing the
NAPI busy polling. Because of that, those CPUs usage ramp up to 100%
and running ping on the side is now having horrible numbers:

[2022-02-19 07:27:54] INFO SOCKPP/ping ping results for 10 loops:
0. 104.16.211.191 rtt min/avg/max/mdev = 9.926/34.987/80.048/17.016 ms
1. 104.16.212.191 rtt min/avg/max/mdev = 9.861/34.934/79.986/17.019 ms
2. 104.16.213.191 rtt min/avg/max/mdev = 9.876/34.949/79.965/16.997 ms
3. 104.16.214.191 rtt min/avg/max/mdev = 9.852/34.927/79.977/17.019 ms
4. 104.16.215.191 rtt min/avg/max/mdev = 9.869/34.943/79.958/16.997 ms

Doing this:
echo 990000 > /proc/sys/kernel/sched_rt_runtime_us

as instructed here:
https://www.kernel.org/doc/html/latest/scheduler/sched-rt-group.html

fix the problem:

$ ping 104.16.211.191
PING 104.16.211.191 (104.16.211.191) 56(84) bytes of data.
64 bytes from 104.16.211.191: icmp_seq=1 ttl=62 time=1.05 ms
64 bytes from 104.16.211.191: icmp_seq=2 ttl=62 time=0.812 ms
64 bytes from 104.16.211.191: icmp_seq=3 ttl=62 time=0.864 ms
64 bytes from 104.16.211.191: icmp_seq=4 ttl=62 time=0.846 ms
64 bytes from 104.16.211.191: icmp_seq=5 ttl=62 time=1.23 ms
64 bytes from 104.16.211.191: icmp_seq=6 ttl=62 time=0.957 ms
64 bytes from 104.16.211.191: icmp_seq=7 ttl=62 time=1.10 ms
^C
--- 104.16.211.191 ping statistics ---
7 packets transmitted, 7 received, 0% packet loss, time 6230ms
rtt min/avg/max/mdev = 0.812/0.979/1.231/0.142 ms

If I was to guess, I would say that it is ksoftirqd on those CPUs that
is starving and is not servicing the network packets but I wish that I
had a better understanding of what is really happening and know if it
would be possible to keep 100% those processors dedicated to my tasks
and have the network softirqs handled somewhere else to not have to
tweak /proc/sys/kernel/sched_rt_runtime_us to fix the issue...

