Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFD26CA2C0
	for <lists+io-uring@lfdr.de>; Mon, 27 Mar 2023 13:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbjC0Lqo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Mar 2023 07:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232536AbjC0Lqn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Mar 2023 07:46:43 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1CD149F9
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 04:46:41 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id i5so35111364eda.0
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 04:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679917600;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xOOuI06gs2e1JP534rIJbeaZ1NG1DAvojBCyxSoYbm8=;
        b=q64E5T5IB/OAHhr72h8zUsjS3lYU9mejXk2nWrOpiant4xS1FqRwyW892rCyDA+mZ8
         F/33VMYbs+qbZFKvr94xbNVwREZmUYE3ORGNMxqTZjp6VhuVMLLBgtraNnFo5Z1V4vZa
         iNiE8ilTshA9CViN60q6oyYtAFD/ZjUzIicmIz/4fh1WY6WPuM3hJySxCht72pPTNfDk
         MJ+wesaasz20Tufld+CsR7lhtBHEURR7cLBdKNVhj2C+IHBIP/ASR1pGnOgVQYJoPtRv
         fm8/heQBOUzRfb/47iiMY/QlHRbJqa6yrtenVXxJFOKU0kzL1rK2IC3iwSXnQmfpaEAQ
         0aOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679917600;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xOOuI06gs2e1JP534rIJbeaZ1NG1DAvojBCyxSoYbm8=;
        b=Ye889K0X27ee7IBee8sYeZbH+jC4DISQ+7Ab0SjJpD703tJVRl1cWXcEsYORG4CFbB
         H9ymxYq5LPb8iVUiOtEQKuzyyvdrHz7pTWqITUNTaKtAOPzW7OwiH93i6anXPPPIeCDm
         JPIUxUte4mTOHLeYNNbKQ9b8oALBGDJZd7L5AtKm+Bu6bjnvaCeWa94aqFzHVccCAny2
         NPSbo2qenEFOHdevt5WntQjDeUk7pyPJeDPNg6kvHz+Cq1kZV1bBcH7Y6Jbt87NnJqzO
         /vfd4htN/BVBy44YFXIa4V9C7UrdR7tGPeQAhU2u/03p6+KFM8EUP3rlWx7l7ef/ybIF
         vT7Q==
X-Gm-Message-State: AAQBX9cySGn0H3QXZXgXpHsV5xvuug20dQ/xGPY/PASnUMgqhTAdmv3l
        gVOXCCWkVMLIAG1DtsM6BEc=
X-Google-Smtp-Source: AKy350Z3VI/3Mf1EZSCaCpm9oFqqz32SFnEWGv4gr+9n+WnOx61613BIegc+kul0vwseZZRsaOF0XA==
X-Received: by 2002:a17:906:5010:b0:92a:77dd:f6f with SMTP id s16-20020a170906501000b0092a77dd0f6fmr12686367ejj.73.1679917599754;
        Mon, 27 Mar 2023 04:46:39 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:1063])
        by smtp.gmail.com with ESMTPSA id a27-20020a509b5b000000b00501dd53dbfbsm9189497edj.75.2023.03.27.04.46.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 04:46:39 -0700 (PDT)
Message-ID: <2a836d8e-3a77-496c-7e87-99faff642205@gmail.com>
Date:   Mon, 27 Mar 2023 12:45:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH] io_uring/rw: transform single vector readv/writev into
 ubuf
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <43cb1fb7-b30b-8df1-bba6-e50797d680c6@kernel.dk>
 <ZB4nJStBSrPR9SYk@ovpn-8-20.pek2.redhat.com>
 <9c3473b7-8063-4d14-1f8b-7a0e67979cf4@kernel.dk>
 <ZB4/KLT6XGBPCeYD@ovpn-8-20.pek2.redhat.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZB4/KLT6XGBPCeYD@ovpn-8-20.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/25/23 00:24, Ming Lei wrote:
> On Fri, Mar 24, 2023 at 05:06:00PM -0600, Jens Axboe wrote:
>> On 3/24/23 4:41?PM, Ming Lei wrote:
>>> On Fri, Mar 24, 2023 at 08:35:38AM -0600, Jens Axboe wrote:
>>>> It's very common to have applications that use vectored reads or writes,
>>>> even if they only pass in a single segment. Obviously they should be
>>>> using read/write at that point, but...
>>>
>>> Yeah, it is like fixing application issue in kernel side, :-)
>>
>> It totally is, the same thing happens all of the time for readv as well.
>> No amount of informing or documenting will ever fix that...
>>
>> Also see:
>>
>> https://lore.kernel.org/linux-fsdevel/20230324204443.45950-1-axboe@kernel.dk/
>>
>> with which I think I'll change this one to just be:
>>
>> 	if (iter->iter_type == ITER_UBUF) {
>> 		rw->addr = iter->ubuf;
>> 		rw->len = iter->count;
>> 	/* readv -> read distance is the same as writev -> write */
>> 	BUILD_BUG_ON((IORING_OP_READ - IORING_OP_READV) !=
>> 			(IORING_OP_WRITE - IORING_OP_WRITEV));
>> 		req->opcode += (IORING_OP_READ - IORING_OP_READV);
>> 	}
>>
>> instead.
>>
>> We could also just skip it completely and just have liburing do the
>> right thing if io_uring_prep_readv/writev is called with nr_segs == 1.
>> Just turn it into a READ/WRITE at that point. If we do that, and with
>> the above generic change, it's probably Good Enough. If you use
>> READV/WRITEV and you're using the raw interface, then you're on your
>> own.

I like this option but sendmsg and recvmsg probably do need the same
fix up, which is more justified as they can't get converted to
send/recv as this.

Another option is to internally detangle opcodes from iter types.

import() {
     if (req->op == READV)
         import_iovec();
     else
         import_buf();
}

would get replaced with:

prep() {
     if (req->op == READV)
         req->flags = REQ_F_IOVEC;
}

import() {
     if (req->flags & REQ_F_IOVEC)
         import_iovec();
     else
         import_buf();
}


>>>> +	rw->addr = (unsigned long) iter->iov[0].iov_base;
>>>> +	rw->len = iter->iov[0].iov_len;
>>>> +	iov_iter_ubuf(iter, ddir, iter->iov[0].iov_base, rw->len);
>>>> +	/* readv -> read distance is the same as writev -> write */
>>>> +	BUILD_BUG_ON((IORING_OP_READ - IORING_OP_READV) !=
>>>> +			(IORING_OP_WRITE - IORING_OP_WRITEV));
>>>> +	req->opcode += (IORING_OP_READ - IORING_OP_READV);
>>>
>>> It is a bit fragile to change ->opcode, which may need matched
>>> callbacks for the two OPs, also cause inconsistent opcode in traces.
>>>
>>> I am wondering why not play the magic in io_prep_rw() from beginning?
>>
>> It has to be done when importing the vec, we cannot really do it in
>> prep... Well we could, but that'd be adding a bunch more code and
>> duplicating part of the vec import.
> 
> I meant something like the following(un-tested), which at least
> guarantees that op_code, rw->addr/len are finalized since ->prep().

It sounds like a better approach. With opcode machinations it's easy
to forget about some kind of state that could be fatal.

Take IOSQE_ASYNC for example. The core code will allocate
async_data and do io_readv_prep_async() -> import_iovec(), which
inside changes the opcode. It'll be a problem if io_readv_prep_async()
forgets that it might a different opcode with a slightly different req
layout, or even non-vectored read would do sth weird with ->async_data
or mishandle REQ_F_NEED_CLEANUP.

fwiw, needs compat handling, i.e. leave as iovec if compat

> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 0c292ef9a40f..4bf4c3effdac 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -120,6 +120,25 @@ int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>   			return ret;
>   	}
>   
> +	if (req->opcode == IORING_OP_READV && req->opcode == IORING_OP_WRITEV &&
> +			rw->len == 1) {
> +		struct iovec iov;
> +		struct iovec *iovp;
> +
> +		iovp = iovec_from_user(u64_to_user_ptr(rw->addr), 1, 1, &iov,
> +					req->ctx->compat);
> +		if (IS_ERR(iovp))
> +			return PTR_ERR(iovp);
> +
> +		rw->addr = (unsigned long) iovp->iov_base;
> +		rw->len = iovp->iov_len;
> +
> +		/* readv -> read distance is the same as writev -> write */
> +		BUILD_BUG_ON((IORING_OP_READ - IORING_OP_READV) !=
> +				(IORING_OP_WRITE - IORING_OP_WRITEV));
> +		req->opcode += (IORING_OP_READ - IORING_OP_READV);
> +	}
> +
>   	return 0;
>   }

-- 
Pavel Begunkov
