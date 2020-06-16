Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBFE1FBF11
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2020 21:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728518AbgFPTfM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Jun 2020 15:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730393AbgFPTfL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Jun 2020 15:35:11 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A48C061573
        for <io-uring@vger.kernel.org>; Tue, 16 Jun 2020 12:35:09 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id k2so1888599pjs.2
        for <io-uring@vger.kernel.org>; Tue, 16 Jun 2020 12:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tE4hPHxedlBS9ygtlM030SerijGFDoZR98QJ3DtVf4c=;
        b=RkG7JdM562/xJ4HW5bZac09tC1ZY7AEH+G/4+CPwXzPvKVg3ZbvCixZtOeORoZhi5r
         lbTDfr4d+ta68CWJKgEu5jC87nB2SvhZz2DVled3XAqZaQIiB7DUAVtTvgSw2v+zV3re
         SelF6quhb3amgkGrXoCwBcrOK7GdXhyqwRx1JszVDCho3rlZvwgtJf2oa3V6AL54xUSy
         y7Dksixtg1/vMbOCRd66dfwcbHN/2+AoIvGHJ++UraPnIKzTODZw0zbaplburmoqNnyG
         WEii1txKuSMlZ46wjGpdwKn/+hAl40Y1E/khnPrHRHkqh2mLa5kwHIBrX6kSytuFETAZ
         ePcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tE4hPHxedlBS9ygtlM030SerijGFDoZR98QJ3DtVf4c=;
        b=RXuk1HPH5920D4jR5QXTpjhIYE5nEcvn5vjI1DTH5CjKtHgGCTx0R8dClIRP1gKIrr
         Fy3dUvLXrK67ewG32qX0u4myjKnVs7J0dfenMj1wfAkzdQNVFWT1Srtp6PsiH14AE6VF
         rZLWovBUDr5mLZFSMjQUQa8zYnFCm1TMfRk1QAyQw2PflkH+kb256JwP4dE/VR00vAvG
         F3B7nE40o2faf519qgh1Kblt1r6lsvItxgUQvs3BkRhEcW9coMhtGGQwK5RbB8BVjMw1
         aPlLho8D+cvIkCgTiWhL0YtAAYOGz/PmMJ3x13fiZLRREtAdQEevnQl2ZtA0eRFAaGpW
         r5TQ==
X-Gm-Message-State: AOAM533cDeKO1SEAANUhyN6nX3aOIgTiImp5ZCR4BgF4j9p9/GzzjKOw
        Q0fzRchw7jJ9MXTJiKEFktWXekjq84zwaw==
X-Google-Smtp-Source: ABdhPJxLSgeZCYdhV0aLa/FAnNyIZ4PQerPzEJ6VVVU+GuDxD+f0cwxLBEPf0nvZodH+Kf5ju+dmAA==
X-Received: by 2002:a17:90a:7806:: with SMTP id w6mr4241964pjk.24.1592336108697;
        Tue, 16 Jun 2020 12:35:08 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id a12sm3193360pjw.35.2020.06.16.12.35.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jun 2020 12:35:08 -0700 (PDT)
Subject: Re: Does need memory barrier to synchronize req->result with
 req->iopoll_completed
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <dc28ff4f-37cf-03cb-039e-f93fefef8b96@linux.alibaba.com>
 <fdbe0ddc-7fa8-f7df-2e49-bfcea00673d0@kernel.dk>
 <0c0ec588-9fc7-1f97-7e52-80d368f8146d@oracle.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ce6b75a3-533c-e621-651e-1b29797ce50c@kernel.dk>
Date:   Tue, 16 Jun 2020 13:35:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <0c0ec588-9fc7-1f97-7e52-80d368f8146d@oracle.com>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/16/20 11:31 AM, Bijan Mottahedeh wrote:
> On 6/14/2020 8:36 AM, Jens Axboe wrote:
>> On 6/14/20 8:10 AM, Xiaoguang Wang wrote:
>>> hi,
>>>
>>> I have taken some further thoughts about previous IPOLL race fix patch,
>>> if io_complete_rw_iopoll() is called in interrupt context, "req->result = res"
>>> and "WRITE_ONCE(req->iopoll_completed, 1);" are independent store operations.
>>> So in io_do_iopoll(), if iopoll_completed is ture, can we make sure that
>>> req->result has already been perceived by the cpu executing io_do_iopoll()?
>> Good point, I think if we do something like the below, we should be
>> totally safe against an IRQ completion. Since we batch the completions,
>> we can get by with just a single smp_rmb() on the completion side.
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 155f3d830ddb..74c2a4709b63 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -1736,6 +1736,9 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
>>   	struct req_batch rb;
>>   	struct io_kiocb *req;
>>   
>> +	/* order with ->result store in io_complete_rw_iopoll() */
>> +	smp_rmb();
>> +
>>   	rb.to_free = rb.need_iter = 0;
>>   	while (!list_empty(done)) {
>>   		int cflags = 0;
>> @@ -1976,6 +1979,8 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
>>   	if (res != req->result)
>>   		req_set_fail_links(req);
>>   	req->result = res;
>> +	/* order with io_poll_complete() checking ->result */
>> +	smp_wmb();
>>   	if (res != -EAGAIN)
>>   		WRITE_ONCE(req->iopoll_completed, 1);
>>   }
>>
> I'm just trying to understand how the above smp_rmb() works. When 
> io_complete_rw_iopoll() is called, all requests on the done list have 
> already had ->iopoll_completed checked, and given the smp_wmb(),we know 
> the two writes were ordered, so what does the smp_rmb() achieve here 
> exactly? What ordering does it perform?

Documentation/memory-barriers.txt actually has a good example of that,
skip to line 2219 or so.

-- 
Jens Axboe

