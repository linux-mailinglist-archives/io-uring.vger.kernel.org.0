Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F4D1CB50C
	for <lists+io-uring@lfdr.de>; Fri,  8 May 2020 18:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgEHQhw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 May 2020 12:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbgEHQhw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 May 2020 12:37:52 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035E1C061A0C
        for <io-uring@vger.kernel.org>; Fri,  8 May 2020 09:37:51 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id d7so2413160ioq.5
        for <io-uring@vger.kernel.org>; Fri, 08 May 2020 09:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lWEqTNSDmOLrZ4ry3zUVAhoTIEh4VxxVjIsO43fxw6w=;
        b=wZZ+l4Vo/6h0SrgSnz+Z+kq07u2GeDqF3+f7EX/bfbeMxMBvcfkV2Rr1N9J1Lxht62
         3Yn4lbM6/wjO42FJGULXE+VCKTqGc3xaN7Ab8LNcfs4BGCrMwfYh2eOKrkXgCW0LGyEW
         j9Z82uIPKhvbN/axnks9dddYt7kjZFOdgg8sLeD/cnSozLlZEd2tU0zj+mmPiP15hms0
         ojg8HQFqpKk/3f478HSacWpiADEpcAKtaxVM/TD+55QOvNfc+qkEcUTCfL+BEsgMot/3
         2MV5tPT7vgEwm+RDdDeyXkXpytUUhlcqXTUX9pRr1b+xXgPS0xyrq3O+jMOCLmY5cor5
         RglQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lWEqTNSDmOLrZ4ry3zUVAhoTIEh4VxxVjIsO43fxw6w=;
        b=BJfZnvOkTdDBST+xsi++sGKRFSKIdbKn0AA9QmuGuwxutCF0t5KD2lt67Lf1OJ03Vn
         HysCP5vcxHyRQDlXd8QpYKhBsasPVnc0p0q8T+IKvJsQcxCU4nMDUsp1dnqe9UOeaGAj
         mwZYSFoNftifvP1xitZZhsTGq/XXbXhMlhncyAN8iABCebazmrKIyrKeKYFlWUyQaKAi
         SgfYDKgIOmM5QrJ8vWgLOMXyumalX/dp3LhO5QWCODmJaCNo/b1jWMj/TQlCNKv7o14/
         7jQy/2p4a0TlCsocqBg70J17ps5KB3NUm/EkNJR+u+BeggjjTW4M9+ELLROxdDL5Am1h
         VyXA==
X-Gm-Message-State: AGi0PuaqARPwMpGx+h9YG/kuvc1LNm7o8MB7eyDIo4X6rW6PTWJ/kM4F
        fsHs5Y66iIw2nB3Jolt6S4LDvA==
X-Google-Smtp-Source: APiQypIjzEgr7Fal2N0CU8S33MSxdTlCbs95tMQmE0SAMCdwyJO5RheY4soH+votregWujZI5KiNeg==
X-Received: by 2002:a5d:8c81:: with SMTP id g1mr3409074ion.197.1588955870866;
        Fri, 08 May 2020 09:37:50 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id e6sm998579ilg.38.2020.05.08.09.37.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 May 2020 09:37:50 -0700 (PDT)
Subject: Re: Is io_uring framework becoming bloated gradually? and introduces
 performace regression
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        joseph qi <joseph.qi@linux.alibaba.com>,
        Jiufei Xue <jiufei.xue@linux.alibaba.com>
References: <6132351e-75e6-9d4d-781b-d6a183d87846@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5828e2de-5976-20ae-e920-bf185c0bc52d@kernel.dk>
Date:   Fri, 8 May 2020 10:37:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <6132351e-75e6-9d4d-781b-d6a183d87846@linux.alibaba.com>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/8/20 9:18 AM, Xiaoguang Wang wrote:
> hi,
> 
> This issue was found when I tested IORING_FEAT_FAST_POLL feature, with
> the newest upstream codes, indeed I find that io_uring's performace
> improvement is not obvious compared to epoll in my test environment,
> most of the time they are similar.  Test cases basically comes from:
> https://github.com/frevib/io_uring-echo-server/blob/io-uring-feat-fast-poll/benchmarks/benchmarks.md.
> In above url, the author's test results shows that io_uring will get a
> big performace improvement compared to epoll. I'm still looking into
> why I don't get the big improvement, currently don't know why, but I
> find some obvious regression issue.
> 
> I wrote a simple tool based io_uring nop operation to evaluate
> io_uring framework in v5.1 and 5.7.0-rc4+(jens's io_uring-5.7 branch),
> I see a obvious performace regression:
>
> v5.1 kernel:
>      $sudo taskset -c 60 ./io_uring_nop_stress -r 300 # run 300 seconds
>      total ios: 1832524960
>      IOPS:      6108416
> 5.7.0-rc4+
>      $sudo taskset -c 60 ./io_uring_nop_stress -r 300
>      total ios: 1597672304
>      IOPS:      5325574
> it's about 12% performance regression.

For sure there's a bit more bloat in 5.7+ compared to the initial slim
version, and focus has been on features to a certain extent recently.
The poll rework for 5.7 will really improve performance for the
networked side though, so it's not like it's just piling on features
that add bloat.

That said, I do think it's time for a revisit on overhead. It's been a
while since I've done my disk IO testing. The nop testing isn't _that_
interesting by itself, as a micro benchmark it does yield some results
though. Are you running on bare metal or in a VM?

> Using perf can see many performance bottlenecks, for example,
> io_submit_sqes is one.  For now, I did't make many analysis yet, just
> have a look at io_submit_sqes(), there are many assignment operations
> in io_init_req(), but I'm not sure whether they are all needed when
> req is not needed to be punt to io-wq, for example,
> INIT_IO_WORK(&req->work, io_wq_submit_work); # a whole struct
> assignment from perf annotate tool, it's an expensive operation, I
> think reqs that use fast poll feature use task-work function, so the
> INIT_IO_WORK maybe not necessary.

I'm sure there's some low hanging fruit there, and I'd love to take
patches for it.

> Above is just one issue, what I worry is that whether io_uring is
> becoming more bloated gradually, and will not that better to aio. In
> https://kernel.dk/io_uring.pdf, it says that io_uring will eliminate
> 104 bytes copy compared to aio, but see currenct io_init_req(),
> io_uring maybe copy more, introducing more overhead? Or does we need
> to carefully re-design struct io_kiocb, to reduce overhead as soon as
> possible.

The copy refers to the data structures coming in and out, both io_uring
and io_uring inititalize their main io_kiocb/aio_kiocb structure as
well. The io_uring is slightly bigger, but not much, and it's the same
number of cachelines. So should not be a huge difference there. The
copying on the aio side is basically first the pointer copy, then the
user side kiocb structure. io_uring doesn't need to do that. The
completion side is also slimmer. We also don't need as many system calls
to do the same thing, for example.

So no, we should always been substantially slimmer than aio, just by the
very nature of the API.

One major thing I've been thinking about for io_uring is io_kiocb
recycling. We're hitting the memory allocator for alloc+free for each
request, even though that can be somewhat amortized by doing batched
submissions, and polling for instance can also do batched frees. But I'm
pretty sure we can find some gains here by having some io_kiocb caching
that is persistent across operations.

Outside of that, runtime analysis and speeding up the normal path
through io_uring will probably also easily yield us an extra 5% (or
more).

-- 
Jens Axboe

