Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E78B1A8A50
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2020 20:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504508AbgDNSz7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Apr 2020 14:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732445AbgDNSzx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Apr 2020 14:55:53 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9A2C061A0C
        for <io-uring@vger.kernel.org>; Tue, 14 Apr 2020 11:55:53 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id np9so5692462pjb.4
        for <io-uring@vger.kernel.org>; Tue, 14 Apr 2020 11:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=6wv8HlesqshsceO0B8jc95jCIlro5/8/4HQDOxhJH98=;
        b=uxgNpJ+gGrjiyPbEmGylrjkUck2eVu6toLnrqA9xd0XjxrKQQs5AlyBqeEzyYWull8
         NI9mITZZEJ3nvZ2zB4rNv6MuVE5lbn4wE95Jm+4t0WbvKdgtP2BNlJkEx6wU9aIjtVBI
         ebVnbAidXfYlq9ov1MqArpHvCw9eFOWXnmBmpvYZ2UOVihoNeeV3o8FrSkwgCCkBUKhd
         zfdVaDMZdt50XQVSpBaDkQ8Pe67eMcy339Z9b6JxCAFcHcLVqfNjQXoIbMAyGZNRVjrH
         AOCX6XoaKZHWjn0Rd2OPv/Cd3kAro42GNvwXCoCo4OFzyIFooYw37VpcPdDJ0wOmJUBn
         tYbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=6wv8HlesqshsceO0B8jc95jCIlro5/8/4HQDOxhJH98=;
        b=oiQ0CT+d3MS/r3sGenYfFmG8eity8YWvuCCam2fyPKXvC3cBfWmv4ZHoSd+CojQN8I
         hDut/ZSRnepTVbtQpK5jw3Bzw0yqDnle9YbI/aZNNHlBPOKeFBl0lUdvBeYCYQ3xYvdk
         zreTQz11x6+mr4CJV/LNCv/P7UqeCkgOp8zO7pE8GTawFg2ngSiQw0A/5A8r6cnnt26j
         xthn+YQBSzqy20DwfunwSw07B4B/LaPkK3wTOgViPdPTyigBlKMGjdIHBCisHvg7ul9H
         n0iaGDgaXm/1THpaKVBSj+KqzAfWLUBFU4JhdZOvRmeVzO5R5HtcfJ34B5IgdYRscHqV
         62SA==
X-Gm-Message-State: AGi0PuaJxZQ1LCnGrpo2Cho2qyL/+uE0CqR3K92/xfADVWXV9XRi3K7T
        vGhoJMVPzvQCFvG3pfMf5U8=
X-Google-Smtp-Source: APiQypIBJjt4AlLtCWrZsH7OHLFaoVJ6TiUQoXYwrcZar/UDHG/aW6SsV7+Ml/Oc9cofLDXyPxISlQ==
X-Received: by 2002:a17:902:7487:: with SMTP id h7mr1389536pll.25.1586890552779;
        Tue, 14 Apr 2020 11:55:52 -0700 (PDT)
Received: from [192.168.1.32] ([116.88.148.100])
        by smtp.gmail.com with ESMTPSA id h14sm2889090pjc.46.2020.04.14.11.55.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2020 11:55:52 -0700 (PDT)
Subject: Re: Should io_sq_thread belongs to specific cpu, not io_uring
 instance
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org, "axboe@kernel.dk" <axboe@kernel.dk>,
        joseph qi <joseph.qi@linux.alibaba.com>,
        asaf.cidon@columbia.edu, stutsman@cs.utah.edu
References: <16ed5a58-e011-97f3-0ed7-e57fa37cede1@linux.alibaba.com>
From:   Yu Jian Wu <yujian.wu1@gmail.com>
Message-ID: <e876a7e8-982b-a193-f4dc-56e7e990b7c5@gmail.com>
Date:   Tue, 14 Apr 2020 14:55:25 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <16ed5a58-e011-97f3-0ed7-e57fa37cede1@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 4/14/20 9:08 AM, Xiaoguang Wang wrote:
> hi，
>
> Currently we can create multiple io_uring instances which all have SQPOLL
> enabled and make them run in the same cpu core by setting sq_thread_cpu
> argument, but I think this behaviour maybe not efficient. Say we create two
> io_uring instances, which both have sq_thread_cpu set to 1 and sq_thread_idle
> set to 1000 milliseconds, there maybe such scene below:
>   For example, in 0-1s time interval, io_uring instance0 has neither sqes
> nor cqes, so it just busy waits for new sqes in 0-1s time interval, but
> io_uring instance1 have work to do, submitting sqes or polling issued requests,
> then io_uring instance0 will impact io_uring instance1. Of cource io_uring
> instance1 may impact iouring instance0 as well, which is not efficient. I think
> the complete disorder of multiple io_uring instances running in same cpu core is
> not good.
>
> How about we create one io_sq_thread for user specified cpu for multiple io_uring
> instances which try to share this cpu core, that means this io_sq_thread does not
> belong to specific io_uring instance, it belongs to specific cpu and will
> handle requests from mulpile io_uring instance, see simple running flow:
>   1, for cpu 1, now there are no io_uring instances bind to it, so do not create io_sq_thread
>   2, io_uring instance1 is created and bind to cpu 1, then create cpu1's io_sq_thread
>   3, io_sq_thread will handle io_uring instance1's requests
>   4, io_uring instance2 is created and bind to cpu 1, since there are already an
>      io_sq_thread for cpu 1, will not create an io_sq_thread for cpu1.
>   5. now io_sq_thread in cpu1 will handle both io_uring instances' requests.
>
> What do you think about it? Thanks.
>
> Regards,
> Xiaoguang Wang
>
Hi Xiaoguang,

We (a group of researchers at Utah and Columbia) are currently trying that right now.

We have an initial prototype going, and we are assessing the performance impact now to see if we can see gains. Basically, have a rcu-list of io_uring_ctx and then traverse the list and do work in a shared io_sq_thread. We are starting experiments on a machine with fast SSDs where we hope to see some performance benefits.

We will send the list of patches soon, once we are sure the approach works and we finish cleaning it up. (There is a subtlety of what to do with the timeouts and resched() when not pinning.)

We'll keep you in the loop on any updates. Feel free to contact any of us.

Thanks,

Yu Jian Wu

