Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A97DE181921
	for <lists+io-uring@lfdr.de>; Wed, 11 Mar 2020 14:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729435AbgCKNGJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Mar 2020 09:06:09 -0400
Received: from mail-il1-f193.google.com ([209.85.166.193]:32976 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729345AbgCKNGJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Mar 2020 09:06:09 -0400
Received: by mail-il1-f193.google.com with SMTP id k29so1929641ilg.0
        for <io-uring@vger.kernel.org>; Wed, 11 Mar 2020 06:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cZ/TaX4UK7w0MY0cuNWl5vlnSN43tf6Yl1C7KdfUKZI=;
        b=e3FILmQXqulGfBwCmwhpTTSvPtadACfiW7Rlg9aH2HPsuzJQW7Neliv/nqie/yZGzI
         qQKui9KBVvhE5WKH3BGabWh7IeiIElchP1K71oWF5irmbicrob4Cjz3EZH1lI/fFxTpG
         Kw6jSTb2Xt7orG74IvOOQsPoSkw8fv8vyCC8NpRTRDZxQk2VvjmA6MZX2p3QIvoWi7pV
         bHi7/jOn12Rw+W6CBdXylOn1kVDHOqgHQWgMdPmjsrv2Ddvt5moXOsF6ItFuYRs+SEgH
         /Z6gBjGAnmSHm1ZXHghQ1Nj12M48Q9thzi3IbxaQAh6UPxJtXjuQf4dDCRHcV3j0Ibvc
         zKCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cZ/TaX4UK7w0MY0cuNWl5vlnSN43tf6Yl1C7KdfUKZI=;
        b=FS0qKXOcF7TKth9mDdQzYV5Onys7M9g/PyMDrsWGe1vGgoIyuIZngzMRtmAM7tdSkz
         wIrF6yLKYZdzDkUxVuos8MGjuO2HxThQngjEWYBpZUOB772Qm519ntahW/eTtdn/Obs0
         TbhofRW8S+MqMjZ9F7COm9MyafTUf0dYLJCxRVMextPtVgCcMBqrCPQQFoLFLQdFJBUB
         Z+EkAQUmxIyfQ+T/FFoMc3xnhyUzKqbUoX62WupA2aQfXqDx8G5xjgEvP8/ksmMkbSBP
         6tgE+HwoyOzZy0/U4q0uNETnRJpowmHCOAj4M4UzsQd6EjyjitEN2g/7Iw57UsiTEGCo
         p9nw==
X-Gm-Message-State: ANhLgQ2Wt28X3spPUPaQ2ViuhCNctwUFOqnRJWpPkjKq89R5MBbomEqi
        MRryHViVUE3GAYmHonB03vGmHN0YKimOyQ==
X-Google-Smtp-Source: ADFU+vsuB4Wcb/MlMAllIRNP5+xapwvLahXm3+xV4MbBVF0l7MHOWVLp5MIDAr0NV2YZE3PB50XnKQ==
X-Received: by 2002:a92:5a88:: with SMTP id b8mr3057342ilg.206.1583931966961;
        Wed, 11 Mar 2020 06:06:06 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k13sm4218454ioj.31.2020.03.11.06.06.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2020 06:06:05 -0700 (PDT)
Subject: Re: [PATCH] io_uring: io_uring_enter(2) don't poll while
 SETUP_IOPOLL|SETUP_SQPOLL enabled
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200311012609.35482-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c51ba29e-14ce-c811-d4c1-344d9ea1258d@kernel.dk>
Date:   Wed, 11 Mar 2020 07:06:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200311012609.35482-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/10/20 7:26 PM, Xiaoguang Wang wrote:
> When SETUP_IOPOLL and SETUP_SQPOLL are both enabled, applications don't need
> to do io completion events polling again, they can rely on io_sq_thread to do
> polling work, which can reduce cpu usage and uring_lock contention.
> 
> I modify fio io_uring engine codes a bit to evaluate the performance:
> static int fio_ioring_getevents(struct thread_data *td, unsigned int min,
>                         continue;
>                 }
> 
> -               if (!o->sqpoll_thread) {
> +               if (o->sqpoll_thread && o->hipri) {
>                         r = io_uring_enter(ld, 0, actual_min,
>                                                 IORING_ENTER_GETEVENTS);
>                         if (r < 0) {
> 
> and use "fio  -name=fiotest -filename=/dev/nvme0n1 -iodepth=$depth -thread
> -rw=read -ioengine=io_uring  -hipri=1 -sqthread_poll=1  -direct=1 -bs=4k
> -size=10G -numjobs=1  -time_based -runtime=120"
> 
> original codes
> --------------------------------------------------------------------
> iodepth       |        4 |        8 |       16 |       32 |       64
> bw            | 1133MB/s | 1519MB/s | 2090MB/s | 2710MB/s | 3012MB/s
> fio cpu usage |     100% |     100% |     100% |     100% |     100%
> --------------------------------------------------------------------
> 
> with patch
> --------------------------------------------------------------------
> iodepth       |        4 |        8 |       16 |       32 |       64
> bw            | 1196MB/s | 1721MB/s | 2351MB/s | 2977MB/s | 3357MB/s
> fio cpu usage |    63.8% |   74.4%% |    81.1% |    83.7% |    82.4%
> --------------------------------------------------------------------
> bw improve    |     5.5% |    13.2% |    12.3% |     9.8% |    11.5%
> --------------------------------------------------------------------
> 
> From above test results, we can see that bw has above 5.5%~13%
> improvement, and fio process's cpu usage also drops much. Note this
> won't improve io_sq_thread's cpu usage when SETUP_IOPOLL|SETUP_SQPOLL
> are both enabled, in this case, io_sq_thread always has 100% cpu usage.
> I think this patch will be friendly to applications which will often use
> io_uring_wait_cqe() or similar from liburing.

I think this looks reasonable, and true to the spirit of how polling
should work when SQPOLL is used. I'll apply this for 5.7, thanks.

-- 
Jens Axboe

