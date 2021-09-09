Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78530405A4D
	for <lists+io-uring@lfdr.de>; Thu,  9 Sep 2021 17:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231918AbhIIPnE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Sep 2021 11:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231556AbhIIPnD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Sep 2021 11:43:03 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681EDC061574
        for <io-uring@vger.kernel.org>; Thu,  9 Sep 2021 08:41:54 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id j18so2847933ioj.8
        for <io-uring@vger.kernel.org>; Thu, 09 Sep 2021 08:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=X/uo2utPcbYrm0XUdYhBhUztRwHOhZdL/5hIqwmPlxc=;
        b=FANyYc/+K3WO+kgZtXyz0b7ZhZTE0pRFVwmjBmaSxRh3TkOfSZkBNSHLwTFl9Fa0Ms
         xPOGonPAazgyn7yiFm6baWU4MFWu7XhR8y4d+z+Uyu6kx8FqzhFzx/qO0lIWTNFRTXsG
         RZNBgt9Ex2npPHL9+79E7jD7whgyo/iEfRjUunHTWjxCv4iE3h/WwGA9mUSdSiXQ4MU1
         nWvmRP65NmbPbTJbfsLFj/bnctTR2thWDEirZuryKLNsJO3Yt8AXijMoFn6BWJPHseSJ
         m11xwWQ1KX48drTFcR53zbGefWs198QV7vWQGfo7Y6yY06/SLk00np+LoendR64T0CUY
         wfOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X/uo2utPcbYrm0XUdYhBhUztRwHOhZdL/5hIqwmPlxc=;
        b=NYDzFqu7VLCi7mbhpyS6UV9MZJoSkNQ3k49NQWfT7tUm8Jf9qUuDVRBTTEhWhmvTzy
         vT/UR4lkcTLf/jhEY/kUJueSWi1jxh+S20QNnA+ohIXdFkbbQnMrs3S3KjjywJyYwmpi
         OzaOTk/apg9aasikhH/qbiZGDd0pKMh08IHTv6qysH/6AU1+iD2w0vgUdgYTXRYL9p7R
         y27TDdlBNrr17oPYgk0S+2Tu3glohsXq6EHnqBxWZXkgV4MKoYkD6Q6rL4PwmevZCbHb
         7bXiHCHz0g09MWRvOaI9cco+i4qdVFrMV53oN76wFK7NULapEoX9nUUQ4HAZqobhOsca
         adMQ==
X-Gm-Message-State: AOAM531TOXFKKXx7f0zFm7pn5wChzXyUCA5Dqnl25i5NXqRFPZAoZzh9
        yMXyWUvzF4L6L2dk9uPjYQ9Xv+aH/0iFzw==
X-Google-Smtp-Source: ABdhPJzi5F/vdA0FnSTsjn++jgV8ZKQ8O+hnG7DeWkNMDi6p7yxI5qAZfST/tuwrs5TxPQbugNwVog==
X-Received: by 2002:a05:6638:3eb:: with SMTP id s11mr379811jaq.67.1631202113521;
        Thu, 09 Sep 2021 08:41:53 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id t11sm1029015ilf.16.2021.09.09.08.41.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Sep 2021 08:41:53 -0700 (PDT)
Subject: Re: [PATCH] io-wq: fix memory leak in create_io_worker()
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210909040507.82711-1-haoxu@linux.alibaba.com>
 <d3351ea9-5389-1cd9-ba11-5df4c030f87b@kernel.dk>
 <574bb7cd-c0e4-14d3-8afa-2f892a7b78bd@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a43c7b2d-5efe-97df-d271-26611bc84a05@kernel.dk>
Date:   Thu, 9 Sep 2021 09:41:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <574bb7cd-c0e4-14d3-8afa-2f892a7b78bd@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/9/21 7:00 AM, Hao Xu wrote:
> 在 2021/9/9 下午8:57, Jens Axboe 写道:
>> On 9/8/21 10:05 PM, Hao Xu wrote:
>>> We should free memory the variable worker point to in fail path.
>>
>> I think this one is missing a few paths where it can also happen, once
>> punted.
> True. I browse the code again and I think Qiang.zhang's patch should be
> fine.

Yes agree, that one looks complete. I have applied it.

-- 
Jens Axboe

