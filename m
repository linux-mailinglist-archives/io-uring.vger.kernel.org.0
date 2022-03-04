Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45A5A4CCB70
	for <lists+io-uring@lfdr.de>; Fri,  4 Mar 2022 02:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbiCDBy2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Mar 2022 20:54:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbiCDBy2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Mar 2022 20:54:28 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC5413D553
        for <io-uring@vger.kernel.org>; Thu,  3 Mar 2022 17:53:41 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id r13so14436311ejd.5
        for <io-uring@vger.kernel.org>; Thu, 03 Mar 2022 17:53:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=xp4bM1Hg4bo73DnW6mSf8uz4RU9TSIHRvWpWCDZBvaU=;
        b=f2+2PuwybBkInwx57X6xOZ1eLnFy/SdB8GaCFaNhWomCttpH1cuBUVcsyGGwoRcDqZ
         jHbSI2D3zVUnsX9O4vetr7vj5ncLLWXT8Qr9e0eRC0/N9x/s+gbC5IVhr7iPZz5vwdYh
         OgTShddQBMYdIfO/J1OmN/pUHJZ99hM6gUqf1AlS+LsnZN0z1Igw7JE4cEbdjyWgjnQs
         pZMbDJliIxkT2TQ25B9oalRsVsXg/FQ+WsqUPPAyJwGlu4qfBMkj/98Zud/rcXJjKS/6
         ARGFqTh9V5YjtvnNmx8BeMhV4uiTscv+esYySB+9LDV6WKAaBBEicShNXzIAs2tTmj5J
         vjLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xp4bM1Hg4bo73DnW6mSf8uz4RU9TSIHRvWpWCDZBvaU=;
        b=7ORykcdzTyextou91XZktiSJ9ZBSQkOz9gDNcrZqYp3YKcqT7ncfwRjqirXYt9fX5l
         YAwukpgcHBxmeW5+xA37PakfM8dA+UZRjgjpgVMGA+lDGtzJaQ9SRWVQCvscI7nZlSs2
         pOuhj4/1wneMIiXMxSRceWnm7wCx9axSeUVXmLSLrb45jnXwRzCsLyI0tvx/kb3aDJtz
         iYQb3C/KJ2IgRlMd3B/TzLzNYN5OScZiebeo86nHoAFNjCio14HhiIEERpHdObPUTJUN
         /YoDwsrtEgVmnA3Ol1ubLddXy3EoJx9KehLD4JCONKqnNUtHJsPwCUzMm20Sv2Ja6By8
         reVg==
X-Gm-Message-State: AOAM532WM8bgthNR0LqKjc7awwtM9h/HzJ/kX1WHyjMKsmnn6XhUEyq0
        P8f0tAE8q80DsdiCRjAobiQ=
X-Google-Smtp-Source: ABdhPJy68kr2iklLx/OeCnt3laKl5oGblgEmQKEAsQOaa8ZLKRF90y0pW9Xab7mxZhM0QwnKh4BLqw==
X-Received: by 2002:a17:907:3da6:b0:6da:8dde:a4aa with SMTP id he38-20020a1709073da600b006da8ddea4aamr5034095ejc.209.1646358819815;
        Thu, 03 Mar 2022 17:53:39 -0800 (PST)
Received: from [192.168.8.198] ([85.255.236.114])
        by smtp.gmail.com with ESMTPSA id vw19-20020a170907059300b006ba4e0f2046sm1240691ejb.137.2022.03.03.17.53.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 17:53:39 -0800 (PST)
Message-ID: <559685fd-c8aa-d2d4-d659-f4b0ffc840d4@gmail.com>
Date:   Fri, 4 Mar 2022 01:49:08 +0000
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

Is the bench single threaded (including io-wq)? Because if it
is, get/put shouldn't do any atomics and I don't see where the
result comes from.

static unsigned long __fget_light(unsigned int fd, fmode_t mask)
{
	struct files_struct *files = current->files;
	struct file *file;

	if (atomic_read(&files->count) == 1) {
		file = files_lookup_fd_raw(files, fd);
		if (!file || unlikely(file->f_mode & mask))
			return 0;
		return (unsigned long)file;
	} else {
		file = __fget(fd, mask, 1);
		if (!file)
			return 0;
		return FDPUT_FPUT | (unsigned long)file;
	}
}

-- 
Pavel Begunkov
