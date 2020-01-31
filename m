Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A817B14EFCB
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2020 16:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729238AbgAaPju (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jan 2020 10:39:50 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:40344 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729160AbgAaPju (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jan 2020 10:39:50 -0500
Received: by mail-il1-f193.google.com with SMTP id i7so6506676ilr.7
        for <io-uring@vger.kernel.org>; Fri, 31 Jan 2020 07:39:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sppSJ27WOAOq8bLtj1YH2mlQeo3KTk4dV43H9seuSsk=;
        b=0uZ77XyQjJrzZ6lHXop39Dcn3D3xJsKbpxm9i9o7khypXNZ0UXMSAlbgU1g1cvpeHk
         mR5uHjydrEPVgdHY8BJf0Xk2AYg/CDn+fEp/IX1+Kggqr9rdP86PuJch7LaYGKR8bm9O
         MjOjpzINv1M/+PQTQoP+lumJeskwJPdaewdYdzju4Mse3+9Z0H1mpo3J3jyQemqL/ve2
         CcU5yO8wXkiWbhl6Ujgs++1spLC7hKJcpGecNQ7qM4wsKSznhTxRviDyhdzRj4t92ve3
         qkRdTg0Kx3bs7kLHQ1kpAMR30UoH6Q2MYgW0XGZcuyLquxL0tEAEN6a0JoDlndYx9OAT
         rUog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sppSJ27WOAOq8bLtj1YH2mlQeo3KTk4dV43H9seuSsk=;
        b=r/RX99yuzncDLWzJEuyIhzmfmqQlM9ozRTlVHYBWiaXl8dhK8WojnnYRxlGBW4A3G9
         fdEhjVfaYjfXdyW6v2hF6M8jT1tLxjh0ZilDZYKCoxAIperO8ryCIdVs6zICriBuXLT4
         AH8UXFRqw3KyUVCCPp7Mk4/ScEoiqTiZHXAbp9rQL/OtVzOZ54Wk4ySmL0EIPxZPH+Jz
         JKYzbwXUVVyZlD1Tew/vyJpPPGv6ynzXGVI+bywd9gzqVf1YDY6LJtL/nH9mOLyTYYem
         rt7mpq8WcFEaeDWxbxrK11pvYoc7iaI2x4N27ZimMwvowUzUcHaoRnVWRbHlQewvH6yk
         YEbg==
X-Gm-Message-State: APjAAAVAn5zhLnrelMYtuu7Z22208eb1/RFxoApeiTOO2wTke6NpEfjC
        g0WNeoLCSaaP42mTxUNSvcdy80llrLM=
X-Google-Smtp-Source: APXvYqzJPXA9+M7o11flsX6E8Taexa2QTUIkYHozFJgT/PdrSjqe4SlmV/J/LxeOs/ePruCdWOceUw==
X-Received: by 2002:a92:cc04:: with SMTP id s4mr3165379ilp.193.1580485188246;
        Fri, 31 Jan 2020 07:39:48 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id f76sm3278848ild.82.2020.01.31.07.39.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2020 07:39:47 -0800 (PST)
Subject: Re: [PATCH liburing v2 0/1] test: add epoll test case
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <20200131142943.120459-1-sgarzare@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ebc2efdb-4e7f-0db9-ef04-c02aac0b08b1@kernel.dk>
Date:   Fri, 31 Jan 2020 08:39:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200131142943.120459-1-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/31/20 7:29 AM, Stefano Garzarella wrote:
> Hi Jens,
> this is a v2 of the epoll test.
> 
> v1 -> v2:
>     - if IORING_FEAT_NODROP is not available, avoid to overflow the CQ
>     - add 2 new tests to test epoll with IORING_FEAT_NODROP
>     - cleanups
> 
> There are 4 sub-tests:
>     1. test_epoll
>     2. test_epoll_sqpoll
>     3. test_epoll_nodrop
>     4. test_epoll_sqpoll_nodrop
> 
> In the first 2 tests, I try to avoid to queue more requests than we have room
> for in the CQ ring. These work fine, I have no faults.

Thanks!

> In the tests 3 and 4, if IORING_FEAT_NODROP is supported, I try to submit as
> much as I can until I get a -EBUSY, but they often fail in this way:
> the submitter manages to submit everything, the receiver receives all the
> submitted bytes, but the cleaner loses completion events (I also tried to put a
> timeout to epoll_wait() in the cleaner to be sure that it is not related to the
> patch that I send some weeks ago, but the situation doesn't change, it's like
> there is still overflow in the CQ).
> 
> Next week I'll try to investigate better which is the problem.

Does it change if you have an io_uring_enter() with GETEVENTS set? I wonder if
you just pruned the CQ ring but didn't flush the internal side.

> I hope my test make sense, otherwise let me know what is wrong.

I'll take a look...

> Anyway, when I was exploring the library, I had a doubt:
> - in the __io_uring_get_cqe() should we call sys_io_uring_enter() also if
>   submit and wait_nr are zero, but IORING_SQ_NEED_WAKEUP is set in the
>   sq.kflags?

It's a submission side thing, the completion side shouldn't care. That
flag is only relevant if you're submitting IO with SQPOLL. Then it tells
you that the thread needs to get woken up, which you need io_uring_enter()
to do. But for just reaping completions and not needing to submit
anything new, we don't care if the thread is sleeping.

-- 
Jens Axboe

