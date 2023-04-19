Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBB56E7AE9
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 15:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbjDSNdE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 09:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232327AbjDSNdC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 09:33:02 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 705A21560B
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 06:32:46 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-63b621b1dabso1480648b3a.0
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 06:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1681911166; x=1684503166;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G/UiIqApzZCh3GruA0dkxIjE0NAc2ncybgxG1gKM3mA=;
        b=gydVd61WyUdaiEtLuaDmWtWDu+zRfpFPlOTjvI2v5PXLk4j6ZPvDuSEzpZZv7q87Dp
         KFwXYaG+Xl/7XVVK97DrBpdvqq3Dmsv+FDRpTmjMjNK/yulSEwrd3wS7nvQlAmKUu5jD
         aeGrxs4JzVETidjYSHkvxO+xzB3rLibnIxWhs6fmN2to43fo5DClFUE0GhiWHJlCcgyJ
         udnlvEoQYIQGdPUJa9/S/PwOwHtbQ+KPvspypla+dZ5nph/GsPcvpwnGngLJjGUpnan4
         V2rkF1DZ49BU1tyobEecZpGLApUnGbOQvOsJZ/NVHa6S+cGOsQZgg6IgZyGvEiYdtlP7
         Nhzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681911166; x=1684503166;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G/UiIqApzZCh3GruA0dkxIjE0NAc2ncybgxG1gKM3mA=;
        b=eRrBBnWQXih579MqMsxxCMX6LvhGc9sAd51nYqFMki9+0Ld7qveZwzHsxy0EkuH74N
         JeHgDakkveCUf3zn09sCS0Lsp9SoXBD3iI+C5D2aTcLNYVzYBIjj00Tdl+OabDR1PRij
         eDV14wbDO9adE5VzDcSYgnj77Hl8C2kb+nvY+fvjOXC33d72tRaN6TA/bxFeTF8+3IUM
         1SpxvnxquMVA93s3P1UbyXbXZGdFS9unYkPXbP5dzkz5Sn0v92pnDsTkM6gWYJEiFNbZ
         QC/4QXYnI24dmaEAlytDSyMuKbkSDeaOLCrTGeLYFWz82ljTaVWydeKrWCkWaeVO5PZc
         8KQA==
X-Gm-Message-State: AAQBX9ftXb1/lz9h44DBsTYdaii4VL3qdyANs1lhRNgOyVC/6zYh7+Sd
        IkmZIy9GtnZsbwEuWVMOMmMbfA==
X-Google-Smtp-Source: AKy350aai8Nuv0pYHhrB7DaxdiWCZd/shS7Q02IByHNUbb8oWjzOoDqsTF95dY1bqhmNhbAsM/44iA==
X-Received: by 2002:a05:6a20:7f99:b0:eb:88d9:120d with SMTP id d25-20020a056a207f9900b000eb88d9120dmr20279846pzj.6.1681911165719;
        Wed, 19 Apr 2023 06:32:45 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s26-20020a65645a000000b0051b83881682sm7530428pgv.66.2023.04.19.06.32.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 06:32:45 -0700 (PDT)
Message-ID: <30cf5639-ff99-9e73-42cd-21955088c283@kernel.dk>
Date:   Wed, 19 Apr 2023 07:32:44 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] io_uring: Optimization of buffered random write
Content-Language: en-US
To:     luhongfei <luhongfei@vivo.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "open list:IO_URING" <io-uring@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Cc:     opensource.kernel@vivo.com
References: <20230419092233.56338-1-luhongfei@vivo.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230419092233.56338-1-luhongfei@vivo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/19/23 3:22?AM, luhongfei wrote:
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 4a865f0e85d0..64bb91beb4d6
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -2075,8 +2075,23 @@ static inline void io_queue_sqe(struct io_kiocb *req)
>  	__must_hold(&req->ctx->uring_lock)
>  {
>  	int ret;
> +	bool is_write;
>  
> -	ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
> +	switch (req->opcode) {
> +	case IORING_OP_WRITEV:
> +	case IORING_OP_WRITE_FIXED:
> +	case IORING_OP_WRITE:
> +		is_write = true;
> +		break;
> +	default:
> +		is_write = false;
> +		break;
> +	}
> +
> +	if (!is_write || (req->rw.kiocb.ki_flags & IOCB_DIRECT))
> +		ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
> +	else
> +		ret = io_issue_sqe(req, 0);
>  
>  	/*
>  	 * We async punt it if the file wasn't marked NOWAIT, or if the file

We really can't just do that, implicitly. What you are doing is making
any of write synchronous. What are you writing to in terms of device or
file? If file, what file system is being used? Curious if the target
supports async buffered writes, guessing it does not which is why you
see io-wq activity for all of them.

That said, I did toss out a test patch a while back that explicitly sets
up the ring such that we'll do blocking IO rather than do a non-blocking
attempt and then punt it if that fails. And I do think there's a use
case for that, in case you just want to use io_uring for batched
syscalls and don't care about if you end up blocking for some IO.

Let's do a primer on what happens for io_uring issue:

1) Non-blocking issue is attempted for IO. If successful, we're done for
   now.

2) Case 1 failed. Now we have two options
	a) We can poll the file. We arm poll, and we're done for now
	   until that triggers.
	b) File cannot be polled, we punt to io-wq which then does a
	   blocking attempt.

For case 2b, this is the one where we could've just done a blocking
attempt initially if the ring was setup with a flag explicitly saying
that's what the application wants. Or io_uring_enter() had a flag passed
in that explicitly said this is what the applications wants. I suspect
we'll want both, to cover both SQPOLL and !SQPOLL.

I'd recommend we still retain non-blocking issue for pollable files, as
you could very quickly block forever otherwise. Imagine an empty pipe
and a read issued to it in the blocking mode.

A solution like that would cater to your case too, without potentially
breaking a lot of things like your patch could. The key here is the
explicit nature of it, we cannot just go and make odd assumptions about
a particular opcode type (writes) and ring type (SQPOLL) and say "oh
this one is fine for just ignoring blocking off the issue path".

-- 
Jens Axboe

