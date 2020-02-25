Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5D2016EA46
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2020 16:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbgBYPlP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Feb 2020 10:41:15 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:33380 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbgBYPlP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Feb 2020 10:41:15 -0500
Received: by mail-io1-f68.google.com with SMTP id z8so2727557ioh.0
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2020 07:41:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j6AC88FeP/VhBk3UpKckcwc7wdsmSDYQSrZrULNrS+c=;
        b=KHVZ2SJN/ybuFuaACzramSyHIQZGTATCy44uyyJrjqY2M08Wv0khXrbcALdvep4xwa
         A+ghyK/7KLTwuT45k0hPauiPJA4AZRmmLGWPRPQWTwJdO3DE4Hpc9WMpT+7GFbFi4kOn
         JWr7qts1aZ8ChMwpOW1gDcyCbncz9Tkv9t7LA+ZfIhlZa3e1vztSpiZViA3irPUkA/LC
         L+B5iKlhqUDt57mPeGXIe0ES+QgmPSAUqa2LJbtoDwV8AnHcgIOBJX6KMAL+wZ6yepDT
         P1gXW/hiMyoDIXCtXW34p/sTOLjOtweklhQTLLYQy2UH2ID4okVSnBcnA9G+olznC2K+
         A34w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j6AC88FeP/VhBk3UpKckcwc7wdsmSDYQSrZrULNrS+c=;
        b=IXrtjMsvj3cAF5/W9DDKgaCCeTEY9mDUINSa49MeO1yySere5paHkdbWukJg/4NlvU
         qx0H0Pd6PsVOwyTJJmlYkFiTlrnvJFYYGOj+hsaMYORK1HJT+N8wQ/vCalxnOP5mJBbT
         DY3UdzS0CSrEl+XsWXgu5/yndGPIpzbWDUFLVBxR42scvdEKPR2v67qv+M3rjWXtSDqe
         CRh0BmCzHfx5cmU3XYaDg0UDXY4+rucArMVkc6xlZ/iklUSWSpKxP6uiSnjrHGVxCSec
         Q0C1ltzwxwy7XuVqHqzDG7pXfTuQJkvkE2qVkIhMQoGd6jLlPDs6oZaW1/RrHTlnArWm
         R98Q==
X-Gm-Message-State: APjAAAUufoaxGECZ8YywPqqmp+km3QSFJrC2rQtmrH2KGg11GM7XWtKa
        GVCQRZSM1RoOLKa7cUyrxZam0g==
X-Google-Smtp-Source: APXvYqzFanFc/pnqXf6jlZ9MBpT9fRNb+JJyuvAu1P8bRuY3odJn0CD0Mq5pgpgReDtwNuqLlK60lQ==
X-Received: by 2002:a02:cdcb:: with SMTP id m11mr60551319jap.125.1582645274742;
        Tue, 25 Feb 2020 07:41:14 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h23sm510424ioh.56.2020.02.25.07.41.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 07:41:14 -0800 (PST)
Subject: Re: [PATCH v4] io_uring: fix poll_list race for
 SETUP_IOPOLL|SETUP_SQPOLL
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, joseph.qi@linux.alibaba.com
References: <20200225141208.4208-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c3d56c85-41a4-099b-f671-7cfbb7a5e664@kernel.dk>
Date:   Tue, 25 Feb 2020 08:41:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200225141208.4208-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/25/20 7:12 AM, Xiaoguang Wang wrote:
> After making ext4 support iopoll method:
>   let ext4_file_operations's iopoll method be iomap_dio_iopoll(),
> we found fio can easily hang in fio_ioring_getevents() with below fio
> job:
>     rm -f testfile; sync;
>     sudo fio -name=fiotest -filename=testfile -iodepth=128 -thread
> -rw=write -ioengine=io_uring  -hipri=1 -sqthread_poll=1 -direct=1
> -bs=4k -size=10G -numjobs=8 -runtime=2000 -group_reporting
> with IORING_SETUP_SQPOLL and IORING_SETUP_IOPOLL enabled.
> 
> There are two issues that results in this hang, one reason is that
> when IORING_SETUP_SQPOLL and IORING_SETUP_IOPOLL are enabled, fio
> does not use io_uring_enter to get completed events, it relies on
> kernel io_sq_thread to poll for completed events.
> 
> Another reason is that there is a race: when io_submit_sqes() in
> io_sq_thread() submits a batch of sqes, variable 'inflight' will
> record the number of submitted reqs, then io_sq_thread will poll for
> reqs which have been added to poll_list. But note, if some previous
> reqs have been punted to io worker, these reqs will won't be in
> poll_list timely. io_sq_thread() will only poll for a part of previous
> submitted reqs, and then find poll_list is empty, reset variable
> 'inflight' to be zero. If app just waits these deferred reqs and does
> not wake up io_sq_thread again, then hang happens.
> 
> For app that entirely relies on io_sq_thread to poll completed requests,
> let io_iopoll_req_issued() wake up io_sq_thread properly when adding new
> element to poll_list, and when io_sq_thread prepares to sleep, check
> whether poll_list is empty again, if not empty, continue to poll.

Thanks for pulling through with this one, queued up for 5.6.

-- 
Jens Axboe

