Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48FA96E980B
	for <lists+io-uring@lfdr.de>; Thu, 20 Apr 2023 17:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbjDTPIZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Apr 2023 11:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbjDTPIY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Apr 2023 11:08:24 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565C05581
        for <io-uring@vger.kernel.org>; Thu, 20 Apr 2023 08:08:23 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id e9e14a558f8ab-32b625939d4so342305ab.1
        for <io-uring@vger.kernel.org>; Thu, 20 Apr 2023 08:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1682003302; x=1684595302;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V4Op/kcO/VJgWcHDLeHePDT1KID4ulkN/VcM28WJT6o=;
        b=nJUW5gyPjRrNnG/8kYOsioXZXk/kYmV2vwBpWj6OoAnjxXTTNTlY7UZFtGSBjOOKSy
         7gle7CVDjAy27KrasELpM3YoST2S8TiO3Mu/sgDk+fuplOj4Z7ZtF50IynwxsS1roMiI
         X13FwLLKQgk0Jo++S2UVVLMDk0bL+GW19pUFjBLlPek9/mnTnJODMwUkUIR6SrUwAF/N
         towjxzZZmYs9o8iNAO36P7yjcXPRPrC8dovcMRIRB1mMgKKRR82HlZ3xuvVGOUcFohfx
         tE+URHosNn0ts8eXUt2FDtZcv40gBWfuNsPVtHLIegqPiAsBmctiMN7CDOxciuTwNdXX
         6sWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682003302; x=1684595302;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V4Op/kcO/VJgWcHDLeHePDT1KID4ulkN/VcM28WJT6o=;
        b=hu8bBAAU5RIMg6WctxMb4BC4YDY45c2MP/WwwYmdWvePKjdCFdakWvxayZ1vJ/8wcC
         0Q11G9JjZlJDcOpI5OPhdvxWL28SHwrMFCiwFE0yhwy+dfzg/JQO49pM9ux4nPSXpP0I
         FI0CSnh3rMlSzudzzFt4Crh0bd2STQCM6XY+gCnkG68pS0anylZOvXi9KlTNYu44Bsl4
         mrjddHlrsspmVXaHjUPoMhPsDAKvTKbQ7KtCgQxQ18LZIRW3nrX2V8RrYZlq6aO0d5sc
         32mUA6VkGp4dVL9nwYollBXrfFLc+Z5P3DbMU6yE6RBvebYXOF7vQ4x26eIHbnxABTtb
         stMA==
X-Gm-Message-State: AAQBX9fVpjaftVgwcVAHSFbEK/3Mu+xduhMKc/1w6TUCvnsdA/M7HtlL
        M2aU2pqn2W0PyzI99u8j/610/A==
X-Google-Smtp-Source: AKy350biZcBeOd/Rs2WaUm9p60SvyD5Q0ecenZEy2d+6/DN9j9pGHcmucKrBfEPe9leAqDKa+nKVaQ==
X-Received: by 2002:a5d:9d90:0:b0:760:dfd3:208d with SMTP id ay16-20020a5d9d90000000b00760dfd3208dmr1652252iob.0.1682003302615;
        Thu, 20 Apr 2023 08:08:22 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id s19-20020a02cf33000000b0040f7b91108esm566215jar.144.2023.04.20.08.08.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Apr 2023 08:08:22 -0700 (PDT)
Message-ID: <3a273417-762c-da28-b918-e79eae0dc3f4@kernel.dk>
Date:   Thu, 20 Apr 2023 09:08:21 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCHSET 0/6] Enable NO_OFFLOAD support
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     luhongfei@vivo.com
References: <20230419162552.576489-1-axboe@kernel.dk>
 <1f57b637-e0b5-2954-fa34-ff2672f55787@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1f57b637-e0b5-2954-fa34-ff2672f55787@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/19/23 6:43?PM, Pavel Begunkov wrote:
> On 4/19/23 17:25, Jens Axboe wrote:
>> Hi,
>>
>> This series enables support for forcing no-offload for requests that
>> otherwise would have been punted to io-wq. In essence, it bypasses
>> the normal non-blocking issue in favor of just letting the issue block.
>> This is only done for requests that would've otherwise hit io-wq in
>> the offload path, anything pollable will still be doing non-blocking
>> issue. See patch 3 for details.
> 
> That's shooting ourselves in the leg.
> 
> 1) It has never been easier to lock up userspace. They might be able
> to deal with simple cases like read(pipe) + write(pipe), though even
> that in a complex enough framework would cause debugging and associated
> headache.
> 
> Now let's assume that the userspace submits nvme passthrough requests,
> it exhausts tags and a request is left waiting there. To progress
> forward one of the previous reqs should complete, but it's only putting
> task in tw, which will never be run with DEFER_TASKRUN.
> 
> It's not enough for the userspace to be careful, for DEFER_TASKRUN
> there will always be a chance to get locked .
> 
> 2) It's not limited only to requests we're submitting, but also
> already queued async requests. Inline submission holds uring_lock,
> and so if io-wq thread needs to grab a registered file for the
> request, it'll io_ring_submit_lock() and wait until the submission
> ends. Same for provided buffers and some other cases.
> 
> Even task exit will actively try to grab the lock.

One thing I pondered was making the inline submissions similar to io-wq
submissions - eg don't hold uring_lock over them. To make useful, I
suspect we'd want to prep all SQ entries upfront, and then drop for
submission.

We'd also want to make this mutually exclusive with IOPOLL, obviously.
Doesn't make any sense to do anyway for IOPOLL, but it needs to be
explicitly disallowed.

-- 
Jens Axboe

