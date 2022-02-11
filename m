Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E81984B2B0F
	for <lists+io-uring@lfdr.de>; Fri, 11 Feb 2022 17:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343720AbiBKQza (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Feb 2022 11:55:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233971AbiBKQza (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Feb 2022 11:55:30 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED3813A
        for <io-uring@vger.kernel.org>; Fri, 11 Feb 2022 08:55:28 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id w7so12147767ioj.5
        for <io-uring@vger.kernel.org>; Fri, 11 Feb 2022 08:55:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4oHs9m/NA+51VKyJa7s9qUDgkydBo44wPQAKLYmMI+I=;
        b=vwA5toYFT174Ht7jS9MnmhF54vNWPCbbC+v31EN0ny154g7aNuAU4nrIjzDD8euXrX
         l7V6Es3MCBCQ8HcTlMnstP4mvWXV9PhzGTfr42A+Cdj3R/AskAaG6foDsUhfy1z4NKGW
         tW5a6PihNknvB9NDdxBTHL1XHwU3JPa74lUTBjvEGXDwiwqU1nUnULLRiizvHU518egY
         KLyrhCF8BV34hjvC0deHV3NEBS5tEEmr8xEhmhqyTDTN8eb1ZNkbJ9g7TorpCGct8Vtk
         fNQiBuhaGERSK65BYLfSeSbddXmzIbwvfVls93IJ3xG24CLXwwnPl+8rYGceOT+6kL3v
         wzxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4oHs9m/NA+51VKyJa7s9qUDgkydBo44wPQAKLYmMI+I=;
        b=IBMveoyPrKwPHLDzYskd0P+Xr0SYPFFPEV7q4emBCcFsk6TqWPdD4ZtQ+yRerM7WPu
         AtYFvjCzXygux5EAa5tY5Cc6+y760betqiqsXU6YQ6DV/xsQ/Wulb3zVKE6/g5LgV1Fz
         airXF4Tbyi5U4y2c/532wpeKv3lumNRbAsd/6TEuCsSTXF3R+pr/X0GY+dIiKP+Vq0xi
         if96SzPiP9B6eV0g/nw+9NzvJ+d41Pcogwi2/K7Yt9aR0TV2j3I1pdkoNXACy4U8rK1D
         GvX8zWvW/VxUy/VNYRQK9KvtF57TbQm7TZ9ZHJvTa28p15V9uYQBUMMPfAI+FNUklKMK
         HGvg==
X-Gm-Message-State: AOAM531NGPKYE8BOWU4GyxgKJaFXCMwcDFKQ7UbgC1uQl4eQS62WPtpS
        vIi6dMP4407A5wJv+vv0/oK7QQ==
X-Google-Smtp-Source: ABdhPJz1lV+7z54hi3NCM8u72i9fR2+D9mlWUQQXkTwrMmqPw8YpUHBGE9eUu7pHUnwgEEIAlqijlw==
X-Received: by 2002:a05:6638:14ca:: with SMTP id l10mr1322700jak.39.1644598527437;
        Fri, 11 Feb 2022 08:55:27 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id b24sm14147190ioc.24.2022.02.11.08.55.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Feb 2022 08:55:26 -0800 (PST)
Subject: Re: [PATCH 0/3] decouple work_list protection from the big wqe->lock
To:     Hao Xu <haoxu@linux.alibaba.com>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20220206095241.121485-1-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <43f8ca19-fa38-929b-88c8-cfff565fbb16@kernel.dk>
Date:   Fri, 11 Feb 2022 09:55:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20220206095241.121485-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/6/22 2:52 AM, Hao Xu wrote:
> wqe->lock is abused, it now protects acct->work_list, hash stuff,
> nr_workers, wqe->free_list and so on. Lets first get the work_list out
> of the wqe-lock mess by introduce a specific lock for work list. This
> is the first step to solve the huge contension between work insertion
> and work consumption.
> good thing:
>   - split locking for bound and unbound work list
>   - reduce contension between work_list visit and (worker's)free_list.
> 
> For the hash stuff, since there won't be a work with same file in both
> bound and unbound work list, thus they won't visit same hash entry. it
> works well to use the new lock to protect hash stuff.
> 
> Results:
> set max_unbound_worker = 4, test with echo-server:
> nice -n -15 ./io_uring_echo_server -p 8081 -f -n 1000 -l 16
> (-n connection, -l workload)
> before this patch:
> Samples: 2M of event 'cycles:ppp', Event count (approx.): 1239982111074
> Overhead  Command          Shared Object         Symbol
>   28.59%  iou-wrk-10021    [kernel.vmlinux]      [k] native_queued_spin_lock_slowpath
>    8.89%  io_uring_echo_s  [kernel.vmlinux]      [k] native_queued_spin_lock_slowpath
>    6.20%  iou-wrk-10021    [kernel.vmlinux]      [k] _raw_spin_lock
>    2.45%  io_uring_echo_s  [kernel.vmlinux]      [k] io_prep_async_work
>    2.36%  iou-wrk-10021    [kernel.vmlinux]      [k] _raw_spin_lock_irqsave
>    2.29%  iou-wrk-10021    [kernel.vmlinux]      [k] io_worker_handle_work
>    1.29%  io_uring_echo_s  [kernel.vmlinux]      [k] io_wqe_enqueue
>    1.06%  iou-wrk-10021    [kernel.vmlinux]      [k] io_wqe_worker
>    1.06%  io_uring_echo_s  [kernel.vmlinux]      [k] _raw_spin_lock
>    1.03%  iou-wrk-10021    [kernel.vmlinux]      [k] __schedule
>    0.99%  iou-wrk-10021    [kernel.vmlinux]      [k] tcp_sendmsg_locked
> 
> with this patch:
> Samples: 1M of event 'cycles:ppp', Event count (approx.): 708446691943
> Overhead  Command          Shared Object         Symbol
>   16.86%  iou-wrk-10893    [kernel.vmlinux]      [k] native_queued_spin_lock_slowpat
>    9.10%  iou-wrk-10893    [kernel.vmlinux]      [k] _raw_spin_lock
>    4.53%  io_uring_echo_s  [kernel.vmlinux]      [k] native_queued_spin_lock_slowpat
>    2.87%  iou-wrk-10893    [kernel.vmlinux]      [k] io_worker_handle_work
>    2.57%  iou-wrk-10893    [kernel.vmlinux]      [k] _raw_spin_lock_irqsave
>    2.56%  io_uring_echo_s  [kernel.vmlinux]      [k] io_prep_async_work
>    1.82%  io_uring_echo_s  [kernel.vmlinux]      [k] _raw_spin_lock
>    1.33%  iou-wrk-10893    [kernel.vmlinux]      [k] io_wqe_worker
>    1.26%  io_uring_echo_s  [kernel.vmlinux]      [k] try_to_wake_up
> 
> spin_lock failure from 25.59% + 8.89% =  34.48% to 16.86% + 4.53% = 21.39%
> TPS is similar, while cpu usage is from almost 400% to 350%

I think this looks like a good start to improving the io-wq locking. I
didnt spot anything immediately wrong with the series, my only worker
was worker->flags protection, but I _think_ that looks OK to in terms of
the worker itself doing the manipulations.

Let's queue this up for 5.18 testing, thanks!

-- 
Jens Axboe

