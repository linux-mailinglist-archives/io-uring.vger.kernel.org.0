Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8AED3FFE9C
	for <lists+io-uring@lfdr.de>; Fri,  3 Sep 2021 13:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348477AbhICLDz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Sep 2021 07:03:55 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:60671 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348467AbhICLDz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Sep 2021 07:03:55 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Un5vFBx_1630666973;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Un5vFBx_1630666973)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 03 Sep 2021 19:02:54 +0800
Subject: Re: [RFC 0/6] fast poll multishot mode
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210903110049.132958-1-haoxu@linux.alibaba.com>
Message-ID: <7a15d468-ac1f-c909-7561-70da7003e53c@linux.alibaba.com>
Date:   Fri, 3 Sep 2021 19:02:53 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210903110049.132958-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/9/3 下午7:00, Hao Xu 写道:
> Let multishot support multishot mode, currently only add accept as its

               ^ fast poll
> first comsumer.
> theoretical analysis:
>    1) when connections come in fast
>      - singleshot:
>                add accept sqe(userpsace) --> accept inline
>                                ^                 |
>                                |-----------------|
>      - multishot:
>               add accept sqe(userspace) --> accept inline
>                                                ^     |
>                                                |--*--|
> 
>      we do accept repeatedly in * place until get EAGAIN
> 
>    2) when connections come in at a low pressure
>      similar thing like 1), we reduce a lot of userspace-kernel context
>      switch and useless vfs_poll()
> 
> 
> tests:
> Did some tests, which goes in this way:
> 
>    server    client(multiple)
>    accept    connect
>    read      write
>    write     read
>    close     close
> 
> Basically, raise up a number of clients(on same machine with server) to
> connect to the server, and then write some data to it, the server will
> write those data back to the client after it receives them, and then
> close the connection after write return. Then the client will read the
> data and then close the connection. Here I test 10000 clients connect
> one server, data size 128 bytes. And each client has a go routine for
> it, so they come to the server in short time.
> test 20 times before/after this patchset, time spent:(unit cycle, which
> is the return value of clock())
> before:
>    1930136+1940725+1907981+1947601+1923812+1928226+1911087+1905897+1941075
>    +1934374+1906614+1912504+1949110+1908790+1909951+1941672+1969525+1934984
>    +1934226+1914385)/20.0 = 1927633.75
> after:
>    1858905+1917104+1895455+1963963+1892706+1889208+1874175+1904753+1874112
>    +1874985+1882706+1884642+1864694+1906508+1916150+1924250+1869060+1889506
>    +1871324+1940803)/20.0 = 1894750.45
> 
> (1927633.75 - 1894750.45) / 1927633.75 = 1.65%
> 
> Higher pressure like 10^5 connections causes problems since ports are
> in use.
> I'll test the cancellation path and try to lift pressure to much high
> level to see if numbers get better. Sent this early for comments and
> suggestions.
> 
> Hao Xu (6):
>    io_uring: enhance flush completion logic
>    io_uring: add IORING_ACCEPT_MULTISHOT for accept
>    io_uring: add REQ_F_APOLL_MULTISHOT for requests
>    io_uring: let fast poll support multishot
>    io_uring: implement multishot mode for accept
>    io_uring: enable multishot mode for accept
> 
>   fs/io_uring.c                 | 72 +++++++++++++++++++++++++++++------
>   include/uapi/linux/io_uring.h |  4 ++
>   2 files changed, 64 insertions(+), 12 deletions(-)
> 

