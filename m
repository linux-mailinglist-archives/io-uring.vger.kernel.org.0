Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 499AF1D3881
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2020 19:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbgENRlJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 May 2020 13:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725975AbgENRlJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 May 2020 13:41:09 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD86C061A0C
        for <io-uring@vger.kernel.org>; Thu, 14 May 2020 10:41:08 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id k19so1422036pll.9
        for <io-uring@vger.kernel.org>; Thu, 14 May 2020 10:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=W3aKIAFOw67/xmcqZ2rtzYLkRbcXGxM62uc8hJtDEjM=;
        b=j1nWpicmqaZ/HvNkNh6/N6gEyCM9DCEwNoZxYlABy/7IeM+Bgk62Ws1nhjCyDhnOqq
         k+2dlfjjEm1RIteD9y90teZr/Kd08WOr3RmEj4C/sISV4tlq73MUi09q+rKJ6y/59qeX
         ElcHL2J53FeeiQHDtaAgglTimv3CQAg8LJwznt789IYPme5nkMp2N2QHDOLMGeHmQzSQ
         SRgr626RhMdL4DWDZa9aWIiUnSp+Kq6AwTuRRSpn6Kk143xD3E54aEanV9pLNK96Fct5
         ro1f1ZIoXKHP7B9MpkHyQSxxC1olLcfNkjaKqUn+3EjHwDN5qAkUR7FLMGH9wTmKkz0e
         X+iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W3aKIAFOw67/xmcqZ2rtzYLkRbcXGxM62uc8hJtDEjM=;
        b=iOPUE0PINMa+McZNDIFgyT/xhyrOLELGj6WK/LZn/jFxUCExFVjY4f7h+pFSNI33zW
         Og4dgvuLn8HQyIQdbG4v3zQowqqiM73Edga5BAeMp3WAUBecEEvLe8xz2KW5lvZbJ6fn
         qq5ZInffsPCjcU2HlsIm6R3LGweuVIJR7oVH3u+hxGlKhfQ1ex8AwsLLT1+SpCLbYdTD
         C5OYpeoL4QdsrRCt9tIpaZYx7Oka5xWa9yswEIRdxC5/SXWXIf5KdTzfDKMJJWepAyl/
         qVYDAqhieaQJRiwW00/8qV4nK2XFH/hkWT8A2nBSKrH9Vzw5bUnrTp764cTUp4xhhkcu
         sc9Q==
X-Gm-Message-State: AGi0PuYVlCLCnDEwj78WJ46Lyi501fxofBJJX8djD/8vyaMBxtRgEPCa
        EOIX9jpyZTrJwHOaorJd6CSPU6SRkzs=
X-Google-Smtp-Source: APiQypKLuOOIjm3Y8dylY2QSkF4ZbB1eky1zA/IVTVQ3HIRVfrxnTrWdEWiqWWVF50Krkz4wFxTxKg==
X-Received: by 2002:a17:90a:a893:: with SMTP id h19mr41073050pjq.138.1589478067404;
        Thu, 14 May 2020 10:41:07 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21cf::15f4? ([2620:10d:c090:400::5:85d5])
        by smtp.gmail.com with ESMTPSA id r31sm2554135pgl.86.2020.05.14.10.41.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2020 10:41:06 -0700 (PDT)
Subject: Re: [PATCH RFC} io_uring: io_kiocb alloc cache
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>
Cc:     joseph qi <joseph.qi@linux.alibaba.com>,
        Jiufei Xue <jiufei.xue@linux.alibaba.com>
References: <492bb956-a670-8730-a35f-1d878c27175f@kernel.dk>
 <dc5a0caf-0ba4-bfd7-4b6e-cbcb3e6fde10@linux.alibaba.com>
 <70602a13-f6c9-e8a8-1035-6f148ba2d6d7@kernel.dk>
 <a68bbc0a-5bd7-06b6-1616-2704512228b8@kernel.dk>
 <0ec1b33d-893f-1b10-128e-f8a8950b0384@gmail.com>
 <a2b5e500-316d-dc06-1a25-72aaf67ac227@kernel.dk>
 <d6206c24-8b4d-37d3-56bd-eac752151de9@gmail.com>
 <b7e7eb5e-cbea-0c59-38b1-1043b5352e4d@kernel.dk>
 <8ddf1d04-aa4a-ee91-72fa-59cb0081695c@gmail.com>
 <642c24dd-19e7-1332-f31e-04a8f0f81c3a@gmail.com>
 <73b95bff-6f08-16f7-7fa8-7552a8dadb63@kernel.dk>
Message-ID: <d0422cbc-9b4f-4540-fa17-a4039037f1ed@kernel.dk>
Date:   Thu, 14 May 2020 11:41:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <73b95bff-6f08-16f7-7fa8-7552a8dadb63@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/14/20 11:01 AM, Jens Axboe wrote:
> On 5/14/20 10:25 AM, Pavel Begunkov wrote:
>> On 14/05/2020 19:18, Pavel Begunkov wrote:
>>> On 14/05/2020 18:53, Jens Axboe wrote:
>>>> On 5/14/20 9:37 AM, Pavel Begunkov wrote:
>>>> Hmm yes good point, it should work pretty easily, barring the use cases
>>>> that do IRQ complete. But that was also a special case with the other
>>>> cache.
>>>>
>>>>> BTW, there will be a lot of problems to make either work properly with
>>>>> IORING_FEAT_SUBMIT_STABLE.
>>>>
>>>> How so? Once the request is setup, any state should be retained there.
>>>
>>> If a late alloc fails (e.g. in __io_queue_sqe()), you'd need to file a CQE with
>>> an error. If there is no place in CQ, to postpone the completion it'd require an
>>> allocated req. Of course it can be dropped, but I'd prefer to have strict
>>> guarantees.
>>
>> I know how to do it right for my version.
>> Is it still just for fun thing, or you think it'll be useful for real I/O?
> 
> We're definitely spending quite a bit of time on alloc+free and the atomics
> for the refcount. Considering we're core limited on some workloads, any
> cycles we can get back will ultimately increase the performance. So yeah,
> definitely worth exploring and finding something that works.

BTW, one oddity of the NOP microbenchmark that makes it less than useful
as a general test case is the fact that any request will complete immediately.
The default settings of that test is submitting batches of 16, which means
that we'll bulk allocate 16 io_kiocbs when we enter. But we only ever really
need one, as by the time we get to request #2, we've already freed the first
request (and so forth). 

I kind of like the idea of recycling requests. If the completion does happen
inline, then we're cache hot for the next issue. Right now we go through
a new request every time, regardless of whether or not the previous one just
got freed.

-- 
Jens Axboe

