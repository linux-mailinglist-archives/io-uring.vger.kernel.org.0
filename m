Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6139D761A72
	for <lists+io-uring@lfdr.de>; Tue, 25 Jul 2023 15:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbjGYNsl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Jul 2023 09:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbjGYNsk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Jul 2023 09:48:40 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 670CD1FC4
        for <io-uring@vger.kernel.org>; Tue, 25 Jul 2023 06:48:33 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-6864c144897so1284148b3a.1
        for <io-uring@vger.kernel.org>; Tue, 25 Jul 2023 06:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690292912; x=1690897712;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cYNQ9/tU8Q/DVLwUCYerCa8otlw800LuRTBmigmmg7Y=;
        b=eURBJe/BUHgcDh423TdsdUU+yNfH2/dYDLARHhSY/hEkdk8v9fQbs216Wv7qrT1men
         lgtytBg1QRDIZBgx6ktIWzW6BPYBbfrSQ9g4Hpl6KgimSH37iHhaLG4zPFMiyBYxUnYg
         DTLuDJf87RgP6EaKjrPgZlRiUKjZ9+c6r4qw1DI/vm/zaRUxnwu0zPgKvHQu0d2l9lAP
         hSv80Kytt7xtNfofztI+pAOJMs1eXAvDtYMDFNRj/f23/fnHLpBjGQPMJ1UGfizF+2qX
         ai2flvc2B2rPMHl1a5ipE69NJFCB44dp04mRhcBAFXnuprXqkO2m4jvq3ldCs4ZfYB37
         pOzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690292912; x=1690897712;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cYNQ9/tU8Q/DVLwUCYerCa8otlw800LuRTBmigmmg7Y=;
        b=alsmY+kkHokGNv26Oun5xEATpTB7kohLjcNGE1R9EhA1jUw0LxhzlOBmU+nrbAyMXK
         a2jcr+UR9gQxwL8W5jssu7W5/+zfJ5JAFTj9B0+jcZS00lQaR0PA2ieFtZEGgq6AGwH+
         Mfqk8t8NFauaMkUz90D4F/2QxcUr3Nsym/DWxSPWdU3WoiuHdjISlxoVugsmF/ZGStIQ
         tV5RgO5TYIPZnSYR561A/Erlo1hBTUNgIEwFit2VuF+NhvVc5BiWgkeliCX1i046SlBP
         nGv4xynwVjRuM1TErT0V6vgW9zRLuXfmfmDj9RdVPeTpi24qLp56pvvzskN4qjzv0vK9
         diAQ==
X-Gm-Message-State: ABy/qLYrYsLfWI3LygelGHTTTbXuBZPrhA7uK8LUcfHkIczvO3d7xKId
        dYBdWUnjsCxQr4vwkfRCoJU7dw==
X-Google-Smtp-Source: APBJJlEdIZxnG9yttEmYEBoaJ9ea9Ei1lGnUsVQ0bGjy8wAA66/C4JGxOyQt24woLg29EoTYaYy1CQ==
X-Received: by 2002:a05:6a20:1586:b0:137:2f8c:fac9 with SMTP id h6-20020a056a20158600b001372f8cfac9mr16270108pzj.4.1690292912588;
        Tue, 25 Jul 2023 06:48:32 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ey1-20020a056a0038c100b00686b649cdd0sm523548pfb.86.2023.07.25.06.48.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jul 2023 06:48:32 -0700 (PDT)
Message-ID: <28a42d23-6d70-bc4c-5abc-0b3cc5d7338d@kernel.dk>
Date:   Tue, 25 Jul 2023 07:48:30 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 06/10] io_uring: add support for futex wake and wait
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        andres@anarazel.de
References: <20230720221858.135240-1-axboe@kernel.dk>
 <20230720221858.135240-7-axboe@kernel.dk>
 <20230721113031.GG3630545@hirez.programming.kicks-ass.net>
 <20230721113718.GA3638458@hirez.programming.kicks-ass.net>
 <d95bfb98-8d76-f0fd-6283-efc01d0cc015@kernel.dk>
 <94b8fcc4-12b5-8d8c-3eb3-fe1e73a25456@kernel.dk>
 <20230725130015.GI3765278@hirez.programming.kicks-ass.net>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230725130015.GI3765278@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/25/23 7:00?AM, Peter Zijlstra wrote:
> On Fri, Jul 21, 2023 at 09:29:14AM -0600, Jens Axboe wrote:
> 
>> FWIW, here's the io_uring incremental after that rebase. Update the
>> liburing futex branch as well, updating the prep helpers to take 64 bit
>> values for mask/val and also add the flags argument that was missing as
>> well. Only other addition was adding those 4 new patches instead of the
>> old 3 ones, and adding single patch that just moves FUTEX2_MASK to
>> futex.h.
>>
>> All checks out fine, tests pass and it works.
>>
>>
>> diff --git a/io_uring/futex.c b/io_uring/futex.c
>> index 93df54dffaa0..4c9f2c841b98 100644
>> --- a/io_uring/futex.c
>> +++ b/io_uring/futex.c
>> @@ -18,11 +18,11 @@ struct io_futex {
>>  		u32 __user			*uaddr;
>>  		struct futex_waitv __user	*uwaitv;
>>  	};
>> +	unsigned long	futex_val;
>> +	unsigned long	futex_mask;
>>  	unsigned long	futexv_owned;
>> +	u32		futex_flags;
>> +	unsigned int	futex_nr;
>>  };
>>  
>>  struct io_futex_data {
>> @@ -171,15 +171,28 @@ bool io_futex_remove_all(struct io_ring_ctx *ctx, struct task_struct *task,
>>  int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>  {
>>  	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
>> +	u32 flags;
>>  
>> +	if (unlikely(sqe->fd || sqe->buf_index || sqe->file_index))
>>  		return -EINVAL;
>>  
>>  	iof->uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
>> +	iof->futex_val = READ_ONCE(sqe->addr2);
>> +	iof->futex_mask = READ_ONCE(sqe->addr3);
>> +	iof->futex_nr = READ_ONCE(sqe->len);
>> +	if (iof->futex_nr && req->opcode != IORING_OP_FUTEX_WAITV)
>> +		return -EINVAL;
>> +
> 
> Hmm, would something like:
> 
> 	if (req->opcode == IORING_OP_FUTEX_WAITV) {
> 		if (iof->futex_val && iof->futex_mask)
> 			return -EINVAL;
> 
> 		/* sys_futex_waitv() doesn't take @flags as of yet */
> 		if (iof->futex_flags)
> 			return -EINVAL;
> 
> 		if (!iof->futex_nr)
> 			return -EINVAL;
> 
> 	} else {
> 		/* sys_futex_{wake,wait}() don't take @nr */
> 		if (iof->futex_nr)
> 			return -EINVAL;
> 
> 		/* both take @flags and @mask */
> 		flags = READ_ONCE(sqe->futex_flags);
> 		if (flags & ~FUTEX2_MASK)
> 			return -EINVAL;
> 
> 		iof->futex_flags = futex2_to_flags(flags);
> 		if (!futex_flags_valid(iof->futex_flags))
> 			return -EINVAL;
> 
> 		if (!futex_validate_input(iof->futex_flags, iof->futex_mask))
> 			return -EINVAL;
> 
> 		/* sys_futex_wait() takes @val */
> 		if (req->iocode == IORING_OP_FUTEX_WAIT) {
> 			if (!futex_validate_input(iof->futex_flags, iof->futex_val))
> 				return -EINVAL;
> 		} else {
> 			if (iof->futex_val)
> 				return -EINVAL;
> 		}
> 	}
> 
> work? The waitv thing is significantly different from the other two.

I think I'll just have prep and prepv totally separate. It only makes
sense to share parts of them if one is a subset of the other. That'll
get rid of the odd conditionals and sectioning of it.

-- 
Jens Axboe

