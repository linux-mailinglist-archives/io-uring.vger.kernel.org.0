Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643F21F9B9C
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2020 17:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730815AbgFOPK2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Jun 2020 11:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729875AbgFOPK1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Jun 2020 11:10:27 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E0CC061A0E
        for <io-uring@vger.kernel.org>; Mon, 15 Jun 2020 08:10:27 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id x6so17469628wrm.13
        for <io-uring@vger.kernel.org>; Mon, 15 Jun 2020 08:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EHItPJOuTgojBN0h8TSDnchogqlJ0iZeauusNvOo/Zg=;
        b=p8cW0iZzjHL/kEejjDdrCdMOrJ0ZwDwc9oLcn9hAvlBjaeKsLLFAqK/oMi8Ug1kFqL
         xhSW3H8znSujWIRLxa3a/uKxFBWT637I7Ui9GjqJ6tGtK/RdW67hseiw+yLVPPo8aC9+
         z7Gawtd8yU0xOxqNTqiMOh3HCDGk4Ti+WZs3wlV7zciJbPBsZzQzSsqXALB3tuD6WrGU
         Q2AcsOtLd2NkFWl3ufLnS44P9Uh2q2LKkL2RPm9Rql1v+tnYvBw0nk54BGXcELFmUaPT
         MWbhD/wilJqgAXpXjZbe5QFv9a/Vp+cTucVpCqIrGvXfABgEAEJ9mCDaewnVSHWc6vv7
         BQIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=EHItPJOuTgojBN0h8TSDnchogqlJ0iZeauusNvOo/Zg=;
        b=SQZyzIGIM/FULkDSaEUHRHjiYgV7OcYRLpVmswqHmpJcVN1it2NtUcOm8/dRsPnpzZ
         6DpClDmFrXf9LqQYGA6dKH6RGQFAt1eRAPbDe3+YS9N6WfWFIdw3JEPM0bSIPVn3LaSK
         nVGkBiv1WmNKpPWFaKaEFSc+QdwX/raX8p9Hh3pZlMCHtI8YVQm4WFY2rbL7wrcpL0Qu
         fIrlmDu1YjJaLF+/EKPPEhbtiUHKgh7IqPQElN8sU6n2CX60ClhP7BIqrET2QXCWvaPY
         UcaSDX4a6ivDX4u1Le810xkbtZzoflSkLj1JPuHVPhQUj830KHQX21qYiZg7C7yU5ZvK
         hWqA==
X-Gm-Message-State: AOAM533o3J+/gh0WK1xtLR13DQRxZUNOjPfA/Z1A0Ed4gPLRVmPrWdTw
        OoqrcYM3T3wVSPzWpUjcjQ7dec0P
X-Google-Smtp-Source: ABdhPJz8gP/I6/t1Mm/nWaRN843GfpgIlVhv6QcaPrby7awJt+BbQyHWHFPQn17yxFzCC3WjQHI6UQ==
X-Received: by 2002:a05:6000:1c7:: with SMTP id t7mr29099723wrx.14.1592233825898;
        Mon, 15 Jun 2020 08:10:25 -0700 (PDT)
Received: from [192.168.43.243] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id l17sm21653676wmi.16.2020.06.15.08.10.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2020 08:10:25 -0700 (PDT)
Subject: Re: [PATCH 2/2] io_uring: add memory barrier to synchronize
 io_kiocb's result and iopoll_completed
To:     Jens Axboe <axboe@kernel.dk>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200615092450.3241-1-xiaoguang.wang@linux.alibaba.com>
 <20200615092450.3241-3-xiaoguang.wang@linux.alibaba.com>
 <a11acc23-1ad6-2281-4712-e78e46f414d7@kernel.dk>
 <e47dd9c1-60a6-8365-6754-88437cf828f5@linux.alibaba.com>
 <97cfe28d-cbbe-680a-2f4f-8794d4f90728@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <dd6482b7-90a4-128c-ce32-63d736895569@gmail.com>
Date:   Mon, 15 Jun 2020 18:09:01 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <97cfe28d-cbbe-680a-2f4f-8794d4f90728@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 15/06/2020 18:02, Jens Axboe wrote:
> On 6/15/20 8:48 AM, Xiaoguang Wang wrote:
>> hi,
>>
>>> On 6/15/20 3:24 AM, Xiaoguang Wang wrote:
>>>> In io_complete_rw_iopoll(), stores to io_kiocb's result and iopoll
>>>> completed are two independent store operations, to ensure that once
>>>> iopoll_completed is ture and then req->result must been perceived by
>>>> the cpu executing io_do_iopoll(), proper memory barrier should be used.
>>>>
>>>> And in io_do_iopoll(), we check whether req->result is EAGAIN, if it is,
>>>> we'll need to issue this io request using io-wq again. In order to just
>>>> issue a single smp_rmb() on the completion side, move the re-submit work
>>>> to io_iopoll_complete().
>>>
>>> Did you actually test this one?
>> I only run test cases in liburing/test in a vm.
>>
>>>
>>>> @@ -1736,11 +1748,20 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
>>>>   {
>>>>   	struct req_batch rb;
>>>>   	struct io_kiocb *req;
>>>> +	LIST_HEAD(again);
>>>> +
>>>> +	/* order with ->result store in io_complete_rw_iopoll() */
>>>> +	smp_rmb();
>>>>   
>>>>   	rb.to_free = rb.need_iter = 0;
>>>>   	while (!list_empty(done)) {
>>>>   		int cflags = 0;
>>>>   
>>>> +		if (READ_ONCE(req->result) == -EAGAIN) {
>>>> +			req->iopoll_completed = 0;
>>>> +			list_move_tail(&req->list, &again);
>>>> +			continue;
>>>> +		}
>>>>   		req = list_first_entry(done, struct io_kiocb, list);
>>>>   		list_del(&req->list);
>>>>   
>>>
>>> You're using 'req' here before you initialize it...
>> Sorry, next time when I submit patches, I'll construct test cases which
>> will cover my codes changes.
> 
> I'm surprised the compiler didn't complain, or that the regular testing
> didn't barf on it.
> 
> Don't think you need a new test case for this, the iopoll test case
> should cover it, if you limit the queue depth on the device by
> setting /sys/block/<dev>/queue/nr_requests to 2 or something like
> that.

Hmm, nice hint. I hooked a dirty ->iopoll in null_blk with fault
injection for that


-- 
Pavel Begunkov
