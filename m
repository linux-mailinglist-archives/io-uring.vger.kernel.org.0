Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF3F14CCB79
	for <lists+io-uring@lfdr.de>; Fri,  4 Mar 2022 02:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236454AbiCDB6X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Mar 2022 20:58:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237612AbiCDB6Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Mar 2022 20:58:16 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 333E217CC72
        for <io-uring@vger.kernel.org>; Thu,  3 Mar 2022 17:57:26 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id kt27so14532773ejb.0
        for <io-uring@vger.kernel.org>; Thu, 03 Mar 2022 17:57:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=ywg4Gb/nN/HpsJ+y6zbn9VzEM2YJsD+0EcUkZu0bb1E=;
        b=emAC8z7MkOVXOK4Zm8z4d5hFkmRa84cnvye0i0Tw0vAwPxvrul1eZYncdtmiwVeZwd
         eT9M1OtVUEKZc74Qqbo5Tf2y9aHHGkQkWFCqFmk/cVahap6oYmq4BdHpwICWWd33qeFZ
         NiKCiAAFlYJOf1MSHZW6DqWQa6Sgl0cJ9AkDVVLxGo+/ygIcJUq7XreC2y5hCVkjziim
         5BoGkSDJDtUuVJLdP31EBvVIrP31djNA+xempCkMPaP5MqjiCWQ/QePzu54ZNgmnqATT
         5DMpzzaNuiMYT48n0RzzwZqNkW+TswexCZyn9zha/yj+B3NQVDk4BoKAgVj57wPbCGfo
         a3qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ywg4Gb/nN/HpsJ+y6zbn9VzEM2YJsD+0EcUkZu0bb1E=;
        b=CdkvwOgsKgUtguq75mUfNOJ/CLUTcEkgF2kEGoU0qrM9xuSMx778aW8J7CIf1Jj+az
         M0wMTM2LlF4Glr8KCwG4NUAAc1OMcl3VsNtzJzyJWyLNqHrmYnBpI8xKRqLzxukDCm8E
         2ZUPaUBHdUZ9j1m5iciFWbkAlhBC38hKmmzRoPyIxmnLIs3T52VtW7s1FBAbbr/ljmfe
         w/XLGbYFTZPDn3aKOSNE1lm7vZVgHUIIVc4osmyn73LO9cYcOl1snwL6IwSjtzirkOah
         8WjBtiON6iVA/WhzAo7goiwsXRDp/RPqr//aJgdo/tNLprc68VW9lNXekDUuLqENRjFG
         im0w==
X-Gm-Message-State: AOAM533TkXNJGhAdRKLcVszAibJYWCLx+YCeSxjT/pVIlDIvW0jZXVC2
        JG8FQcnU04lQU82BGUkQEqsn2CDbKyQ=
X-Google-Smtp-Source: ABdhPJztmBEko1m+JrvfS5dlZKybbw0sFeKoAKBG7skqTxPSOS3ztDdvEoG+ROxckC3u755xAcqFig==
X-Received: by 2002:a17:906:d10c:b0:6cd:4aa2:cd62 with SMTP id b12-20020a170906d10c00b006cd4aa2cd62mr30395143ejz.229.1646359044695;
        Thu, 03 Mar 2022 17:57:24 -0800 (PST)
Received: from [192.168.8.198] ([85.255.236.114])
        by smtp.gmail.com with ESMTPSA id l24-20020a170906231800b006d69a771a34sm1248284eja.93.2022.03.03.17.57.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 17:57:24 -0800 (PST)
Message-ID: <8e4ce4da-040f-70e6-8a9d-54e25c71222f@gmail.com>
Date:   Fri, 4 Mar 2022 01:52:52 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH] io_uring: add io_uring_enter(2) fixed file support
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
References: <20220303052811.31470-1-xiaoguang.wang@linux.alibaba.com>
 <4f197b0e-6066-b59e-aae0-2218e9c1b643@kernel.dk>
 <528ce414-c0fe-3318-483a-f51aa8a407b9@kernel.dk>
 <040e9262-4ebb-8505-5a14-6f399e40332c@kernel.dk>
 <951ea55c-b6a3-59e4-1011-4f46fae547b3@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <951ea55c-b6a3-59e4-1011-4f46fae547b3@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/3/22 16:31, Jens Axboe wrote:
> On 3/3/22 7:40 AM, Jens Axboe wrote:
>> On 3/3/22 7:36 AM, Jens Axboe wrote:
>>> The only potential oddity here is that the fd passed back is not a
>>> legitimate fd. io_uring does support poll(2) on its file descriptor, so
>>> that could cause some confusion even if I don't think anyone actually
>>> does poll(2) on io_uring.
>>
>> Side note - the only implication here is that we then likely can't make
>> the optimized behavior the default, it has to be an IORING_SETUP_REG
>> flag which tells us that the application is aware of this limitation.
>> Though I guess close(2) might mess with that too... Hmm.
> 
> Not sure I can find a good approach for that. Tried out your patch and
> made some fixes:
> 
> - Missing free on final tctx free
> - Rename registered_files to registered_rings
> - Fix off-by-ones in checking max registration count
> - Use kcalloc
> - Rename ENTER_FIXED_FILE -> ENTER_REGISTERED_RING
> - Don't pass in tctx to io_uring_unreg_ringfd()
> - Get rid of forward declaration for adding tctx node
> - Get rid of extra file pointer in io_uring_enter()
> - Fix deadlock in io_ringfd_register()
> - Use io_uring_rsrc_update rather than add a new struct type
> 
> Patch I ran below.
> 
> Ran some testing here, and on my laptop, running:
> 
> axboe@m1pro-kvm ~/g/fio (master)> t/io_uring -N1 -s1 -f0
> polled=1, fixedbufs=1/0, register_files=1, buffered=0, QD=128
> Engine=io_uring, sq_ring=128, cq_ring=128
> submitter=0, tid=673
> IOPS=6627K, IOS/call=1/1, inflight=()
> IOPS=6995K, IOS/call=1/1, inflight=()
> IOPS=6992K, IOS/call=1/1, inflight=()
> IOPS=7005K, IOS/call=1/1, inflight=()
> IOPS=6999K, IOS/call=1/1, inflight=()
> 
> and with registered ring
> 
> axboe@m1pro-kvm ~/g/fio (master)> t/io_uring -N1 -s1 -f1
> polled=1, fixedbufs=1/0, register_files=1, buffered=0, QD=128
> Engine=io_uring, sq_ring=128, cq_ring=128
> submitter=0, tid=687
> ring register 0
> IOPS=7714K, IOS/call=1/1, inflight=()
> IOPS=8030K, IOS/call=1/1, inflight=()
> IOPS=8025K, IOS/call=1/1, inflight=()
> IOPS=8015K, IOS/call=1/1, inflight=()
> IOPS=8037K, IOS/call=1/1, inflight=()
> 
> which is about a 15% improvement, pretty massive...
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index ad3e0b0ab3b9..8a1f97054b71 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
[...]
>   static void *io_uring_validate_mmap_request(struct file *file,
>   					    loff_t pgoff, size_t sz)
>   {
> @@ -10191,12 +10266,23 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>   	io_run_task_work();
>   
>   	if (unlikely(flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP |
> -			       IORING_ENTER_SQ_WAIT | IORING_ENTER_EXT_ARG)))
> +			       IORING_ENTER_SQ_WAIT | IORING_ENTER_EXT_ARG |
> +			       IORING_ENTER_REGISTERED_RING)))
>   		return -EINVAL;
>   
> -	f = fdget(fd);
> -	if (unlikely(!f.file))
> -		return -EBADF;
> +	if (flags & IORING_ENTER_REGISTERED_RING) {
> +		struct io_uring_task *tctx = current->io_uring;
> +
> +		if (fd >= IO_RINGFD_REG_MAX || !tctx)
> +			return -EINVAL;
> +		f.file = tctx->registered_rings[fd];

btw, array_index_nospec(), possibly not only here.

-- 
Pavel Begunkov
