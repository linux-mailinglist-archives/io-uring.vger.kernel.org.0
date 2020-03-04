Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE9A17980F
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2020 19:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730004AbgCDSht (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Mar 2020 13:37:49 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:33757 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729703AbgCDSht (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Mar 2020 13:37:49 -0500
Received: by mail-io1-f66.google.com with SMTP id r15so3569184iog.0
        for <io-uring@vger.kernel.org>; Wed, 04 Mar 2020 10:37:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wh0qFjW/qHneQSqg+QQx1XFOZYzFNeLir404hhmmk8A=;
        b=iB6D5KmyEc3L8QegN7XRaZrSaz+3zxQkc9SriWcXcKD5qmINgB237OLXeEG3VIIufZ
         FvcVyrcvqBEKHtgKJcOPxk0q0ghNUJPqL6gHXxeQS+vZsIYY1oT2XqA8KYFBZgY7xzlt
         QzDuoRgNtzNN14mC1S1RlEXMdj7luaqoLjH9jbn033e2Yg7yKPLpYDUQ68orP1GLOokD
         HAaRyA4w3EhgOHVDb8fzIQbNZEIKGKas0uXpvco/6TWXkYyYAn4/WQr+1trfzaAyM4Xv
         5UraL+b08FmBCu5kqtheb1dGuTsE8WJEUNQixqV6yuvc4jdNKDeXf+OZVhlQyPtyx8pb
         JkpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wh0qFjW/qHneQSqg+QQx1XFOZYzFNeLir404hhmmk8A=;
        b=f5lcr60lexUh7VRO1Nk2uBYUt9TTAEQ8GzPgvtoqWCpeIvibXscZJk//6Ue+R1qMT2
         URxPrRP548PD4UdxynwBUAiePS04ecD2Z2Vom5JMaStFU0f695lLyubnkzh6+F/lbOPY
         Lls2Q5n1+M1N/3zJU2+3XilKJMAvgB1Q+n7tfOOj2n1l6sWXJ+x89NMGMibC5LbO2DRR
         ONsbUsXrNg/n2E6/Qfgih/9DbnbSJMNmJbNpBPNHMANMJ7ijDZQ4C5QdcaEMC+78TY/5
         rF8OfEqkLHW0uKZlkV9X33vYYwLfoRlQKiJ8zKH/wt5xiW6bis55sKb7LM2hyJG/haDc
         j33Q==
X-Gm-Message-State: ANhLgQ22+R7JxlYbtgZbIpkUKgUpignZwiZvI04KZkf3Ylyr9D2B2mYt
        8RujwIsy2M+ZtrF9D+N3eGlHXQ==
X-Google-Smtp-Source: ADFU+vsarnSkFGccdJ+tjh1uW/LPY+9/izVSa2ywAEhv/Y2brEmeYq0uF0XYMk03CKqAXA5hAXDoOg==
X-Received: by 2002:a02:780f:: with SMTP id p15mr3875002jac.91.1583347066713;
        Wed, 04 Mar 2020 10:37:46 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h14sm2049272iow.23.2020.03.04.10.37.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2020 10:37:46 -0800 (PST)
Subject: Re: [PATCH -next] io_uring: Fix unused function warnings
To:     Stefano Garzarella <sgarzare@redhat.com>,
        YueHaibing <yuehaibing@huawei.com>
Cc:     viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200304075352.31132-1-yuehaibing@huawei.com>
 <20200304164806.3bsr2v7cvpq7sw5e@steredhat>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5a1c612a-9efa-1fc8-e264-1a064d4a4435@kernel.dk>
Date:   Wed, 4 Mar 2020 11:37:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200304164806.3bsr2v7cvpq7sw5e@steredhat>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/4/20 9:48 AM, Stefano Garzarella wrote:
> On Wed, Mar 04, 2020 at 03:53:52PM +0800, YueHaibing wrote:
>> If CONFIG_NET is not set, gcc warns:
>>
>> fs/io_uring.c:3110:12: warning: io_setup_async_msg defined but not used [-Wunused-function]
>>  static int io_setup_async_msg(struct io_kiocb *req,
>>             ^~~~~~~~~~~~~~~~~~
>>
>> There are many funcions wraped by CONFIG_NET, move them
>> together to simplify code, also fix this warning.
>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>> ---
>>  fs/io_uring.c | 98 ++++++++++++++++++++++++++++++++++-------------------------
>>  1 file changed, 57 insertions(+), 41 deletions(-)
>>
> 
> Since the code under the ifdef/else/endif blocks now are huge, would it make
> sense to add some comments for better readability?
> 
> I mean something like this:
> 
> #if defined(CONFIG_NET)
> ...
> #else /* !CONFIG_NET */
> ...
> #endif /* CONFIG_NET */

I applied it with that addition. Also had to adapt it quite a bit, as
the prototypes changed. I'm guessing the branch used was a few days
old?

-- 
Jens Axboe

