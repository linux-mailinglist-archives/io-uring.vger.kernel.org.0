Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3E351E7A1
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 16:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236738AbiEGOJn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 May 2022 10:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236292AbiEGOJn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 May 2022 10:09:43 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A755512778;
        Sat,  7 May 2022 07:05:56 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id g3so8367514pgg.3;
        Sat, 07 May 2022 07:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:from:to:cc
         :references:in-reply-to:content-transfer-encoding;
        bh=cYM47d8EYCr6kgSyRxUs8+znzo+tJarrlqS+3vCQEHQ=;
        b=N8MI8y9E/o4uYBrh0Q603lh8OSm2Z1K96QRgRD1svrk86lJkHib57kFGtLGfy/ou04
         rwXFEdHXqVsGn5K5QHh5IPowLGpKh0+iHSqqT6hBowxHurkQgr//OYlpTQg5EIPk+XVi
         feKb2yBW9IJEZ/OcE9yUDeORx0Cz53ud1X42IflOfzng1OV0dA22c1yC12abOP6EmQ4m
         9/0bC8Y5yi+M468qPkyc23bjRKflPuTkWjOK7W3hrtsWeN6vMW0Z6jEbTw+MZ1ZFqKcD
         wfS+oL9RtV1kc2xELLX0fHavnIaNt2vJprp29da45SvQeCDHZYE989K+kPUY/bEeu2NT
         ZT0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=cYM47d8EYCr6kgSyRxUs8+znzo+tJarrlqS+3vCQEHQ=;
        b=THSxkVK5VMPqgAQGOvuIdlynZg54v7jCVEmchG/R3QkCJDwV27S/up607eSHWEU6vH
         J9P8xlXByaJpoKThrf+RMGSJdSdmKnqnZWdfC/+beW8Ffxgqm4rAHfYu37cqlOOPIkDX
         aLTtRvCnYy6v6Lf49pfWjsBv6lFRhsH+o5VLDvS+ZLKFM218HCMoqdj7Ajzs0M/xYEqe
         pzGwM0mPuhNAOKeynVXprflDt1Q/3uWmVMyfUZVqu6jXEU/APiJ+apNIl1jpeGG3Y2rt
         rgf5lRT82Da1GabUt68IT+QAoG5hGEipJxXYQ+uac1akOwNtHV007vLn890Zc9tzX7Cy
         8xYg==
X-Gm-Message-State: AOAM533szho1TBVe2CZyqfZ0gyACeRQDkEZYx7Gz5nYO2W7Ebghk7tjB
        YX0siQyChg1BNTDTcaG8WRrsjGNHpqE0dA==
X-Google-Smtp-Source: ABdhPJyBwNuQIYbM5B10J6CStxAhySioQ1zC/RJcD76+OeQGTWwg/AVwEnSzdzDf3kyJY0FtDOM6bA==
X-Received: by 2002:a05:6a00:1687:b0:4e1:45d:3ded with SMTP id k7-20020a056a00168700b004e1045d3dedmr8312172pfc.0.1651932356096;
        Sat, 07 May 2022 07:05:56 -0700 (PDT)
Received: from [192.168.255.10] ([106.53.4.151])
        by smtp.gmail.com with ESMTPSA id b9-20020a170902d40900b0015e9f45c1f4sm3680028ple.186.2022.05.07.07.05.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 May 2022 07:05:55 -0700 (PDT)
Message-ID: <46f0d5a2-86f5-be19-60a8-050dc7edafb0@gmail.com>
Date:   Sat, 7 May 2022 22:06:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH v3 0/4] fast poll multishot mode
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
References: <20220507123828.76985-1-haoxu.linux@gmail.com>
In-Reply-To: <20220507123828.76985-1-haoxu.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Something wrong with my git sendemail, trying to fix it. Please ignore 
this...

在 2022/5/7 下午8:38, Hao Xu 写道:
> Let multishot support multishot mode, currently only add accept as its
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
> 
> A liburing test is here:
> https://github.com/HowHsu/liburing/blob/multishot_accept/test/accept.c
> 
> v1->v2:
>   - re-implement it against the reworked poll code
> 
> v2->v3:
>   - fold in code tweak and clean from Jens
>   - use io_issue_sqe rather than io_queue_sqe, since the former one
>     return the internal error back which makes more sense
>   - remove io_poll_clean() and its friends since they are not needed
> 
> 
> Hao Xu (4):
>    io_uring: add IORING_ACCEPT_MULTISHOT for accept
>    io_uring: add REQ_F_APOLL_MULTISHOT for requests
>    io_uring: let fast poll support multishot
>    io_uring: implement multishot mode for accept
> 
>   fs/io_uring.c                 | 94 +++++++++++++++++++++++++++--------
>   include/uapi/linux/io_uring.h |  5 ++
>   2 files changed, 79 insertions(+), 20 deletions(-)
> 
> 
> base-commit: 0a194603ba7ee67b4e39ec0ee5cda70a356ea618

