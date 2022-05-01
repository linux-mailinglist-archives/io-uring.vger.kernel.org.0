Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 083245164DA
	for <lists+io-uring@lfdr.de>; Sun,  1 May 2022 17:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbiEAPEE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 May 2022 11:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347897AbiEAPDu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 May 2022 11:03:50 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 254A86547
        for <io-uring@vger.kernel.org>; Sun,  1 May 2022 08:00:23 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 15so10012633pgf.4
        for <io-uring@vger.kernel.org>; Sun, 01 May 2022 08:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:references:in-reply-to:content-transfer-encoding;
        bh=8G2C9emCXDfVJuBrzWPJ7SMvH1mmb2+VFwsM3bLzvME=;
        b=YYmHcXb4f5LZ6RFJHqMl441o3ewu2WlPeYnziBtl9d17WBuY+sYBnLWwUfZYakkRuN
         P/6vfie4mUfdqT/0B7YLbpYcuCKLJ/qTKVqBDrmFZlbGTveShQNZ4TjmHOmqHMFGG4Gy
         Qy0S6X6/WBZbFSLqtiHQQJSliXt7VGHB6dq8TpVsjTqtLqyn/qpJDhdvtzFMLDFY+YzJ
         awsD5fovFS5xHWuw5yFRNQ0enNg4DQdkEqYTTFJjxBLpZrerZg7/XSqd7nzmi4GVr+Hd
         ntCjZs1LLjb0VXXZU9xmUW2o55oocK4USywRAFvE4CIJcSSkT5GYUhtImVKsWFW3BhHt
         9IHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:in-reply-to
         :content-transfer-encoding;
        bh=8G2C9emCXDfVJuBrzWPJ7SMvH1mmb2+VFwsM3bLzvME=;
        b=GTS7dkTxMEPJdu32+bOr1Aisj8WrdjQNaaLVQiuTSxP7NwRP2CbnGd+szFeKRHTZhz
         eBMtLpNbMXl8rW1SrjZsBXyJ1Yg5joX1ENS7Pa2fz1BbTAF6pHoXwZkkgjYLAt0U/agK
         kJ28XJ9EV/UV905ETiWtxkCwbX2Y0wWXJlHnUln+zkpaNwKI52qUXQ2KuBi5NTc+pWpe
         uvcvqB7SKoeYv0g4+BZDrXEKOJVkN4yc/bcG8Hdle8pHC0fZK2BSYKmwTjAb1l593PzD
         PwUlF8ZQ9/vqbhHEm+yihjXXJRqxvDx/4ZwxKMdtBgCn9+37fJi/cYjVMDq4ELQHof03
         BDLg==
X-Gm-Message-State: AOAM533ejP68WR/FTsFhfFPg40VWQP8yHmxdp3i1G7GCMfj6dOGYwZwL
        AzUdMD31w06vIW8/JT6NkD0hkC0EAI7putg+
X-Google-Smtp-Source: ABdhPJypiaLNvrG9oWTXORIw4tj943/mnrwJ7H0Z8wn2rrnDZaiFr2XVGPrQ2nSjPFRNNOw5V/EQew==
X-Received: by 2002:aa7:9472:0:b0:50d:cc22:5269 with SMTP id t18-20020aa79472000000b0050dcc225269mr6553071pfq.58.1651417222533;
        Sun, 01 May 2022 08:00:22 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id g18-20020a62e312000000b0050dc7628195sm2980090pfh.111.2022.05.01.08.00.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 May 2022 08:00:21 -0700 (PDT)
Message-ID: <26ffce05-5e49-9d4b-79bf-bade48a7aa8a@kernel.dk>
Date:   Sun, 1 May 2022 09:00:20 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCHSET v2 RFC 0/11] Add support for ring mapped provided
 buffers
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20220429175635.230192-1-axboe@kernel.dk>
 <69fc3830-8b2e-7b40-ad68-394c7c9fbf60@gmail.com>
 <f7e46c2f-5f38-5d9a-9e29-d04363961a97@kernel.dk>
 <170e4200-fb7b-9496-4fcf-48d64212702e@gmail.com>
 <f7e7a485-7bc3-bf7c-3c05-73e356608913@kernel.dk>
In-Reply-To: <f7e7a485-7bc3-bf7c-3c05-73e356608913@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/1/22 8:25 AM, Jens Axboe wrote:
> On 5/1/22 7:39 AM, Pavel Begunkov wrote:
>> I'd suggest for mapped pbuffers to have an old plain array with
>> sequential indexing, just how we do it for fixed buffers. Do normal
>> and mapped pbuffers share something that would prevent it?
> 
> Ah yes, we could do that. Registering it returns the group ID instead of
> providing it up front.

Actually I'd rather just have the app provide it, but recommendations
can be made in terms of using mostly sequential indexes. I suspect
that's what most would naturally do anyway.

I'm thinking just straight array of X entries, and then a fallback to
xarray if we go beyond that to ensure we don't grow the buffer group
array to crazy values.

I'll do this as a prep patch, not really related to the actual change
here, but will benefit both the classic and ring buffers alike.

-- 
Jens Axboe

