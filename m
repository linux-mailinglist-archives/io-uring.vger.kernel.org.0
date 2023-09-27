Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 235467B037A
	for <lists+io-uring@lfdr.de>; Wed, 27 Sep 2023 14:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbjI0MFl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Sep 2023 08:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231500AbjI0MFl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Sep 2023 08:05:41 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB11F193
        for <io-uring@vger.kernel.org>; Wed, 27 Sep 2023 05:05:39 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-98273ae42d0so289469966b.0
        for <io-uring@vger.kernel.org>; Wed, 27 Sep 2023 05:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695816338; x=1696421138; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bf8mzSZ8MQaiNt+VKeK0baxYZaBkpfm4kHq2s/2nbbw=;
        b=cpwTRBxkYl9YjLWKYzGFO7GzuEBorWSUoXJWW1WQE4CVmaFqt1F1l0w4vwSzgp1VR0
         HzvQPHP4xrs9zXHiEJ7Zhch1fuNT9N8g5DnqiRzzLvnf+8fszX0TCSvxwXnGAWJzeEns
         0IjNNF7CpqRSJf8vAMv3I88RZNKI7ovBKxU5V27zY1eDOaAdHF4KW+X6CNI8pZkYwrQZ
         jklOdlrO9O/103GubJh4NTPYbeazTZZvbjSWE+1CWQ962Cs7cbmcoyqvK4dEl95eY0wT
         gq4XeLKTPMk70hSWGsOY/ANQ8dHGe9agvQJkCpR4NjXHQqI2r8MuT1yBcz0/2DLZ8w32
         0pCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695816338; x=1696421138;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bf8mzSZ8MQaiNt+VKeK0baxYZaBkpfm4kHq2s/2nbbw=;
        b=lvq9Y35CiqpTsDPklK4Z/wiWt6a1RWf1b28n7wPcU16+R6xJ0y606NOKbp2rXw5JMT
         lJDMgG/jOBfHP+JxO4uQbxmFFIpOI883VHuNJL+sWrAcn1zPN9PVRkQQVZ3xLN6fYDJd
         CAKV6M1uxDC/9jha25Nyp5d4YO6NH2rHquVnsThJpzbBtX2HAuaMEEApiYQladYM1af4
         K9kd8WQ3LRCv0Bp3w0IorSuuQ89TF5ZKIdrTWu0bFgtFKutvY3N5FWmRSLaOv9vmQ3Hg
         kp7ajxHhHMIm2TVswVLkWDFfduk67jL/aM8bsLPB+mh10l3f8EEwVskK4QIHcQRfXZAh
         O8sw==
X-Gm-Message-State: AOJu0Ywn46zBA8dHy6aPLGalfz0zR4iZr4X6fXsXT4rq6wo30iEleZUZ
        iEHafvL3NV5Y8IFwBa5ToQGmyA==
X-Google-Smtp-Source: AGHT+IHwrckRamzDNbotm+tHKTsseAGRsOc1DVs5MJfuf+aAU20AERmR7hVnP6n6xGGExHPMM3jtLA==
X-Received: by 2002:a17:906:5356:b0:9ad:e1e2:3595 with SMTP id j22-20020a170906535600b009ade1e23595mr1576382ejo.7.1695816338084;
        Wed, 27 Sep 2023 05:05:38 -0700 (PDT)
Received: from [172.20.13.88] ([45.147.210.162])
        by smtp.gmail.com with ESMTPSA id lz1-20020a170906fb0100b0099297782aa9sm9182234ejb.49.2023.09.27.05.05.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Sep 2023 05:05:37 -0700 (PDT)
Message-ID: <3f195f5c-c989-4539-a4e5-62aff89576f5@kernel.dk>
Date:   Wed, 27 Sep 2023 06:05:36 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/8] io_uring: add support for futex wake and wait
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        andres@anarazel.de, tglx@linutronix.de
References: <20230921182908.160080-1-axboe@kernel.dk>
 <20230921182908.160080-5-axboe@kernel.dk>
 <20230927090501.GB21810@noisy.programming.kicks-ass.net>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230927090501.GB21810@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/27/23 3:05 AM, Peter Zijlstra wrote:
> On Thu, Sep 21, 2023 at 12:29:04PM -0600, Jens Axboe wrote:
> 
>> +int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>> +{
>> +	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
>> +	u32 flags;
>> +
>> +	if (unlikely(sqe->fd || sqe->len || sqe->buf_index || sqe->file_index))
>> +		return -EINVAL;
>> +
>> +	iof->uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
>> +	iof->futex_val = READ_ONCE(sqe->addr2);
>> +	iof->futex_mask = READ_ONCE(sqe->addr3);
>> +	flags = READ_ONCE(sqe->futex_flags);
>> +
>> +	if (flags & ~FUTEX2_VALID_MASK)
>> +		return -EINVAL;
>> +
>> +	iof->futex_flags = futex2_to_flags(flags);
> 
> So prep does the flags conversion..
> 
>> +	if (!futex_flags_valid(iof->futex_flags))
>> +		return -EINVAL;
>> +
>> +	if (!futex_validate_input(iof->futex_flags, iof->futex_val) ||
>> +	    !futex_validate_input(iof->futex_flags, iof->futex_mask))
>> +		return -EINVAL;
>> +
>> +	return 0;
>> +}
> 
>> +int io_futex_wait(struct io_kiocb *req, unsigned int issue_flags)
>> +{
>> +	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
>> +	struct io_ring_ctx *ctx = req->ctx;
>> +	struct io_futex_data *ifd = NULL;
>> +	struct futex_hash_bucket *hb;
>> +	int ret;
>> +
>> +	if (!iof->futex_mask) {
>> +		ret = -EINVAL;
>> +		goto done;
>> +	}
>> +
>> +	io_ring_submit_lock(ctx, issue_flags);
>> +	ifd = io_alloc_ifd(ctx);
>> +	if (!ifd) {
>> +		ret = -ENOMEM;
>> +		goto done_unlock;
>> +	}
>> +
>> +	req->async_data = ifd;
>> +	ifd->q = futex_q_init;
>> +	ifd->q.bitset = iof->futex_mask;
>> +	ifd->q.wake = io_futex_wake_fn;
>> +	ifd->req = req;
>> +
>> +	ret = futex_wait_setup(iof->uaddr, iof->futex_val,
>> +			       futex2_to_flags(iof->futex_flags), &ifd->q, &hb);
> 
> But then wait and..
> 
>> +	if (!ret) {
>> +		hlist_add_head(&req->hash_node, &ctx->futex_list);
>> +		io_ring_submit_unlock(ctx, issue_flags);
>> +
>> +		futex_queue(&ifd->q, hb);
>> +		return IOU_ISSUE_SKIP_COMPLETE;
>> +	}
>> +
>> +done_unlock:
>> +	io_ring_submit_unlock(ctx, issue_flags);
>> +done:
>> +	if (ret < 0)
>> +		req_set_fail(req);
>> +	io_req_set_res(req, ret, 0);
>> +	kfree(ifd);
>> +	return IOU_OK;
>> +}
>> +
>> +int io_futex_wake(struct io_kiocb *req, unsigned int issue_flags)
>> +{
>> +	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
>> +	int ret;
>> +
>> +	ret = futex_wake(iof->uaddr, futex2_to_flags(iof->futex_flags),
> 
> ... wake do it both again?

Oops good catch, yes just the prep side should do it of course. I'll fix
that up.

> Also, I think we want wake to have wake do: 
> 
>   'FLAGS_STRICT | iof->futex_flags'
> 
> See 43adf8449510 ("futex: FLAGS_STRICT"), I'm thinking that waking 0
> futexes should honour that request by waking 0, not 1 :-)

Thanks for the pointer, yeah agree that sounds sane. Most syscalls that
take an number/size that is zero will indeed return zero. I'll add a
test case for that too.

-- 
Jens Axboe

