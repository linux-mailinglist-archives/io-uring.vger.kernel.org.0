Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCDA251E5DE
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 11:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383812AbiEGJQs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 May 2022 05:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbiEGJQs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 May 2022 05:16:48 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB403152E;
        Sat,  7 May 2022 02:13:02 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id l11so2427096pgt.13;
        Sat, 07 May 2022 02:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=bV6Fic4FC7WhnbPqNw/owaN+8XIB8Y3rXX1tGv2mwJc=;
        b=KXjPj+DFEpZNOYusBws3oxjiy2Ifoo/09c8LCm5Zge3K/Su0UFdqDS0hj5fl5OvrfW
         uT4Aeym2wNHGL4HDuIz48Yd2wrgf7p0x/K+VAzpGuVLM0Lk8Q4rjGkf8LhdE3aTSYUib
         OxssIiJ5YhIF6L1hORr9s0NEkmMAhTCCLJGdeP6m5kGbc2a9LsVK4SuJM85CdywiPDhf
         ld6wwGm4CrV26jknvAZX2LeVToSeUHXTiKtmOgpH08P+PT7FkKSonITuovdVKaRXBT7O
         GOoFWZ9euC5SZoiR/lSvKL+zWHGEjXKHz+Wbx6aLJUErVdxA1h22tACfgFxU0HM7oMhh
         nuqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=bV6Fic4FC7WhnbPqNw/owaN+8XIB8Y3rXX1tGv2mwJc=;
        b=LtNih2+RY0SroMAJlFtXVPMJr+TnWRGGW6OY7uViTguu00uidHqc9C3IZjS5p2K1NF
         0h9ZUhzaNeZsd7xxu9eIs1sgXomaH2AhLiSNLYKCqxSUUCegZeZvfcNFpXlY6CrFI7ZT
         pUr6KLwp3oB0zQZYMmXhMxLvuaDOXGELtsXk6rUWaUSp7Xk1KelanDH4iosjUTWykoHV
         NrDUYU353K5+S0/B7QnL9+p6s7zW360j4m0ENCkHclf8OpQRocYTaTu48Sml5AFdDEgV
         JvHeoVcYUAKoep1nXLU2AJb0dQ9Eeco3l8hyYOvwznIJlCRCWMzW+jPilYKbsWn3b7Mm
         kRyA==
X-Gm-Message-State: AOAM532c0tiKeFY+gjoR/PtLgDr7w7sQsSeQBGAzq30y03XPFFqtTMar
        wPTnd/mSRaGw02MVDgKRIdo=
X-Google-Smtp-Source: ABdhPJxtll5dm9eFbbNc1DcqQW32XJOYp3JHlPUPkbuR11b9Ui8z8VJVQhsMGvYmHW7fZ7vkZjxlLA==
X-Received: by 2002:a05:6a00:23ca:b0:50e:827:9253 with SMTP id g10-20020a056a0023ca00b0050e08279253mr7601346pfc.20.1651914781709;
        Sat, 07 May 2022 02:13:01 -0700 (PDT)
Received: from [192.168.255.10] ([106.53.4.151])
        by smtp.gmail.com with ESMTPSA id t12-20020a17090b018c00b001d92e2e5694sm8911919pjs.1.2022.05.07.02.12.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 May 2022 02:13:00 -0700 (PDT)
Message-ID: <8917973f-7286-1023-ad85-9f3d57302dbc@gmail.com>
Date:   Sat, 7 May 2022 17:13:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH 5/5] io_uring: implement multishot mode for accept
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
References: <20220506070102.26032-1-haoxu.linux@gmail.com>
 <20220506070102.26032-6-haoxu.linux@gmail.com>
 <afb1be12-5284-79bf-8006-26448e594443@kernel.dk>
From:   Hao Xu <haoxu.linux@gmail.com>
In-Reply-To: <afb1be12-5284-79bf-8006-26448e594443@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2022/5/6 下午10:42, Jens Axboe 写道:
> On 5/6/22 1:01 AM, Hao Xu wrote:
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 0a83ecc457d1..9febe7774dc3 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -1254,6 +1254,7 @@ static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags);
>>   static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer);
>>   static void io_eventfd_signal(struct io_ring_ctx *ctx);
>>   static void io_req_tw_post_queue(struct io_kiocb *req, s32 res, u32 cflags);
>> +static void io_poll_remove_entries(struct io_kiocb *req);
>>   
>>   static struct kmem_cache *req_cachep;
>>   
>> @@ -5690,24 +5691,29 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
>>   static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>   {
>>   	struct io_accept *accept = &req->accept;
>> +	bool multishot;
>>   
>>   	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>>   		return -EINVAL;
>> -	if (sqe->ioprio || sqe->len || sqe->buf_index)
>> +	if (sqe->len || sqe->buf_index)
>>   		return -EINVAL;
>>   
>>   	accept->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
>>   	accept->addr_len = u64_to_user_ptr(READ_ONCE(sqe->addr2));
>>   	accept->flags = READ_ONCE(sqe->accept_flags);
>>   	accept->nofile = rlimit(RLIMIT_NOFILE);
>> +	multishot = !!(READ_ONCE(sqe->ioprio) & IORING_ACCEPT_MULTISHOT);
> 
> I tend to like:
> 
> 	multishot = READ_ONCE(sqe->ioprio) & IORING_ACCEPT_MULTISHOT) != 0;
> 
> as I think it's more readable. But I think we really want it ala:
> 
> 	u16 poll_flags;
> 
> 	poll_flags = READ_ONCE(sqe->ioprio);
> 	if (poll_flags & ~IORING_ACCEPT_MULTISHOT)
> 		return -EINVAL;
> 
> 	...
> 
> to ensure that we can add more flags later, hence only accepting this
> single flag right now.
> 
> Do we need REQ_F_APOLL_MULTI_POLLED, or can we just store whether this
> is a multishot request in struct io_accept?
I think we can do it in this way, but it may be a bit inconvenient if we
add other multishot OPCODE. With REQ_F_APOLL_MULTI_POLLED we can just
check req->flags in the poll arming path, which keeps it op unrelated.
> 
>> @@ -5760,7 +5774,35 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
>>   		ret = io_install_fixed_file(req, file, issue_flags,
>>   					    accept->file_slot - 1);
>>   	}
>> -	__io_req_complete(req, issue_flags, ret, 0);
>> +
>> +	if (req->flags & REQ_F_APOLL_MULTISHOT) {
>> +		if (ret >= 0) {
>> +			bool filled;
>> +
>> +			spin_lock(&ctx->completion_lock);
>> +			filled = io_fill_cqe_aux(ctx, req->cqe.user_data, ret,
>> +						 IORING_CQE_F_MORE);
>> +			io_commit_cqring(ctx);
>> +			spin_unlock(&ctx->completion_lock);
>> +			if (unlikely(!filled)) {
>> +				io_poll_clean(req);
>> +				return -ECANCELED;
>> +			}
>> +			io_cqring_ev_posted(ctx);
>> +			goto retry;
>> +		} else {
>> +			/*
>> +			 * the apoll multishot req should handle poll
>> +			 * cancellation by itself since the upper layer
>> +			 * who called io_queue_sqe() cannot get errors
>> +			 * happened here.
>> +			 */
>> +			io_poll_clean(req);
>> +			return ret;
>> +		}
>> +	} else {
>> +		__io_req_complete(req, issue_flags, ret, 0);
>> +	}
>>   	return 0;
>>   }
> 
> I'd probably just make that:
> 
> 	if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
> 		__io_req_complete(req, issue_flags, ret, 0);
> 		return 0;
> 	}
> 	if (ret >= 0) {
> 		bool filled;
> 
> 		spin_lock(&ctx->completion_lock);
> 		filled = io_fill_cqe_aux(ctx, req->cqe.user_data, ret,
> 					 IORING_CQE_F_MORE);
> 		io_commit_cqring(ctx);
> 		spin_unlock(&ctx->completion_lock);
> 		if (filled) {
> 			io_cqring_ev_posted(ctx);
> 			goto retry;
> 		}
> 		/* fall through to error case */
> 		ret = -ECANCELED;
> 	}
> 
> 	/*
> 	 * the apoll multishot req should handle poll
> 	 * cancellation by itself since the upper layer
> 	 * who called io_queue_sqe() cannot get errors
> 	 * happened here.
> 	 */
> 	io_poll_clean(req);
> 	return ret;
> 
> which I think is a lot easier to read and keeps the indentation at a
> manageable level and reduces duplicate code.
Great, thanks, it's better.
> 

