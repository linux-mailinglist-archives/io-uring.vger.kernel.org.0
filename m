Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B36A1B16C0
	for <lists+io-uring@lfdr.de>; Mon, 20 Apr 2020 22:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbgDTUQd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Apr 2020 16:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbgDTUQd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Apr 2020 16:16:33 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 493C0C061A0C;
        Mon, 20 Apr 2020 13:16:32 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id 188so998108wmc.2;
        Mon, 20 Apr 2020 13:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PbYGmwk9aMs7i+WwwNHmn4efpeSeAZPf38VRz09zQQ0=;
        b=XXEuLCLCsjExglYaAm+dOqTSF09ybcDH4kP4NAl3yReg8aW8lRQ15bIoWeKmtLuD77
         yvVglLpT3/R7zP5o7eg3UlosITXtjTIsyHMlMvfAbGZo4Xqf27U1CuUthuQpLb3w6B91
         f7IlkH7kVtm+8w0OcN3C4EFFaPdBEX/TLwlwDWakig2Rrm4aXihEJwZj9GYlAXmHachG
         FC75lQd5dIa56N1Jxy656JK6X0CzuAsxDujYyBK+f9AYbs46tQtAJz++5TfVok5+EP1C
         kPIyo/rXtI1VszVxuBO4pIWpQgoXgrifqcJIfdq9E0bbBe87AwrifioKQZYRAjHzf8zJ
         81HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PbYGmwk9aMs7i+WwwNHmn4efpeSeAZPf38VRz09zQQ0=;
        b=E46vYKFwtjErf+as5jYCe0d4zYU8RQv0HNXe29bq9kPNvlMGkDIpmzNH4HjYy6PK7x
         InfJLoQ4nzgdWZn77+QlNwj4QXBD3n7WXojrc+iJyQ8EFDIKJfZH1+DGJmlsK8Gh0z3J
         i1Xw5cZ1dgUMJ5lfIwDHSrpzt+EuQrI6cG09Nmnhenr5S2qd9RQFvtGT0B+Qm5bJLHLp
         cN7qhWnWD9DWks5/b0Otjplh9s7t7fudAmZkbF5xwjtwiC9be5h+Ps+zxSnOfUNOQsHz
         bKkJho9OIypY1YgywVDse9xx68vpW0fop7XQ4xXcHCm7p9B4voLMQZjPCt6eVk4HUsHK
         fqDQ==
X-Gm-Message-State: AGi0PuZpRdbTT11xmgT6eSEPM9yaU3YVCWAsPJV9fPkspey0LKo38F+z
        PljPLug+N/RDjK3VTel7HhRfuoNq
X-Google-Smtp-Source: APiQypKA/WbkFBiROj8Sx8BAZ1MNEINYp1IXBM4RGEprEMHflyIphEM7jSknsZh4fRA+f29CVjBu9A==
X-Received: by 2002:a1c:8106:: with SMTP id c6mr1130558wmd.88.1587413790528;
        Mon, 20 Apr 2020 13:16:30 -0700 (PDT)
Received: from [192.168.43.25] ([109.126.129.227])
        by smtp.gmail.com with ESMTPSA id n6sm740640wrs.81.2020.04.20.13.16.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2020 13:16:29 -0700 (PDT)
Subject: Re: [PATCH 1/2] io_uring: trigger timeout after any sqe->off CQEs
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1587229607.git.asml.silence@gmail.com>
 <28005ea0de63e15dbffd87a49fe9b671f1afa87e.1587229607.git.asml.silence@gmail.com>
 <88cbde3c-52a1-7fb3-c4a7-b548beaa5502@kernel.dk>
 <f9c1492c-a0f6-c6ec-ec2e-82a5894060f6@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <3fe32d07-10e6-4a5a-1390-f03ec4a09c6f@gmail.com>
Date:   Mon, 20 Apr 2020 23:15:30 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <f9c1492c-a0f6-c6ec-ec2e-82a5894060f6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 20/04/2020 23:12, Pavel Begunkov wrote:
> On 20/04/2020 22:40, Jens Axboe wrote:
>> On 4/18/20 11:20 AM, Pavel Begunkov wrote:
>>> +static void __io_flush_timeouts(struct io_ring_ctx *ctx)
>>> +{
>>> +	u32 end, start;
>>> +
>>> +	start = end = ctx->cached_cq_tail;
>>> +	do {
>>> +		struct io_kiocb *req = list_first_entry(&ctx->timeout_list,
>>> +							struct io_kiocb, list);
>>> +
>>> +		if (req->flags & REQ_F_TIMEOUT_NOSEQ)
>>> +			break;
>>> +		/*
>>> +		 * multiple timeouts may have the same target,
>>> +		 * check that @req is in [first_tail, cur_tail]
>>> +		 */
>>> +		if (!io_check_in_range(req->timeout.target_cq, start, end))
>>> +			break;
>>> +
>>> +		list_del_init(&req->list);
>>> +		io_kill_timeout(req);
>>> +		end = ctx->cached_cq_tail;
>>> +	} while (!list_empty(&ctx->timeout_list));
>>> +}
>>> +
>>>  static void io_commit_cqring(struct io_ring_ctx *ctx)
>>>  {
>>>  	struct io_kiocb *req;
>>>  
>>> -	while ((req = io_get_timeout_req(ctx)) != NULL)
>>> -		io_kill_timeout(req);
>>> +	if (!list_empty(&ctx->timeout_list))
>>> +		__io_flush_timeouts(ctx);
>>>  
>>>  	__io_commit_cqring(ctx);
>>>  
>>
>> Any chance we can do this without having to iterate timeouts on the
>> completion path?
>>
> 
> If you mean the one in __io_flush_timeouts(), then no, unless we forbid timeouts
> with identical target sequences + some extra constraints. The loop there is not
> new, it iterates only over timeouts, that need to be completed, and removes
> them. That's amortised O(1).

We can think about adding unlock/lock, if that's what you are thinking about.


> On the other hand, there was a loop in io_timeout_fn() doing in total O(n^2),
> and it was killed by this patch.

-- 
Pavel Begunkov
