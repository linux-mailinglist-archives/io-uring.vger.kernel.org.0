Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68AC250B867
	for <lists+io-uring@lfdr.de>; Fri, 22 Apr 2022 15:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447803AbiDVN1S (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 09:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447958AbiDVN1Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 09:27:16 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C5C583A2
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 06:24:23 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id n8so10863029plh.1
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 06:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:references
         :in-reply-to:content-transfer-encoding;
        bh=YK0bOj2DOzxK0cvCzFxFmWxB2Yl03jHIa6jai7WOwJc=;
        b=lJjJ1KlrGk4aPpRbmHT4RculBeu8em3BcIgaCR6DhHjxO66VzU1utbHhPHWit9/RVB
         iXeZ878SA+5MepbgU9N+mSybJm3kihIZukbUEbPaTHR9zD0kKP4eXrjn/xifssknRyuJ
         2iGiWI+6nC5dypq0qLHehc65HPlomd+uMlEoJKRDNxmqvDDstkqzKwBscgcQ++6ieXM+
         jsont3Vxe/n6MwI/qTfBujRW1hcGVftvnsh8QbDCtb4tSVjuclq2Jr9V77p5mZ8pD4IF
         tsFZkn4H8M6l1rjIqU65JGhyGc5nNReSBe7J3Ksgn5Oud748UF9QFueMSpYN4PmyVi7g
         B3pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:references:in-reply-to:content-transfer-encoding;
        bh=YK0bOj2DOzxK0cvCzFxFmWxB2Yl03jHIa6jai7WOwJc=;
        b=REdgKgejE6vDCGO19vaTXiPSnHe5g+yi0lsmaSXHVx8m04Pm2omLobeoGe+yvylN7c
         LrZ99n81jUE+XMXtnRHYVJoNFA9xFr2TyhLPXbepG6BKrwRxIBFSZgTAz7dXayIdPuDe
         TIA+sPZivs5TFDzkptJ6wxp5ILjhm6IruxHkaELh0SbudVdC2aJ/75IXo1Bnydf7tMYg
         Sa2NZYfYwJvJoPLPDASchOAoWUI2fi444IW4+Q0B+henLj9VPy79BJzyuVJyKX5AufQK
         T2cR5E1+bXIrK2zEAkIuxvlzj74kKvgv1VSjRCbMkNfq6uC/6JMAASvJC3q3pVeH/5ke
         UmWA==
X-Gm-Message-State: AOAM530NgInDyZmY6YMgow3KCrLG9yvqwWACZUhIJcbm/mYesgHHe2rg
        btAlzOsqF3Gmq9GIYTBE+Ks=
X-Google-Smtp-Source: ABdhPJxwiVaiHGso6K5HQ8kTkzk5LBbd+WHWU0R2jGD7p2+SfQts7VEUUbKbI2BNNptsiSyhWsSXyg==
X-Received: by 2002:a17:90b:4c43:b0:1d2:aa8f:f687 with SMTP id np3-20020a17090b4c4300b001d2aa8ff687mr5389446pjb.230.1650633862557;
        Fri, 22 Apr 2022 06:24:22 -0700 (PDT)
Received: from [192.168.255.10] ([106.53.33.166])
        by smtp.gmail.com with ESMTPSA id o11-20020a62cd0b000000b0050ce8f98136sm2688586pfg.149.2022.04.22.06.24.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Apr 2022 06:24:22 -0700 (PDT)
Message-ID: <afd64981-a9d3-d83f-3f48-90cc4159dd37@gmail.com>
Date:   Fri, 22 Apr 2022 21:24:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
From:   Hao Xu <haoxu.linux@gmail.com>
Subject: Re: memory access op ideas
To:     Avi Kivity <avi@scylladb.com>, io-uring@vger.kernel.org
References: <e2de976d-c3d1-8bd2-72a8-a7e002641d6c@scylladb.com>
 <9fef64ff-d13d-f9ff-a230-0d8fe928097e@gmail.com>
In-Reply-To: <9fef64ff-d13d-f9ff-a230-0d8fe928097e@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



在 4/22/22 8:52 PM, Hao Xu 写道:
> Hi Avi,
> 在 4/13/22 6:33 PM, Avi Kivity 写道:
>> Unfortunately, only ideas, no patches. But at least the first seems 
>> very easy.
>>
>>
>> - IORING_OP_MEMCPY_IMMEDIATE - copy some payload included in the op 
>> itself (1-8 bytes) to a user memory location specified by the op.
>>
>>
>> Linked to another op, this can generate an in-memory notification 
>> useful for busy-waiters or the UMWAIT instruction
>>
>>
>> This would be useful for Seastar, which looks at a timer-managed 
>> memory location to check when to break computation loops.
>>
>>
>> - IORING_OP_MEMCPY - asynchronously copy memory
>>
>>
>> Some CPUs include a DMA engine, and io_uring is a perfect interface 
>> to exercise it. It may be difficult to find space for two iovecs though.
>
> I have a question about the 'DMA' here, do you mean DMA device for
> memory copy? My understanding is you want async memcpy so that the
> cpu can relax when the specific hardware is doing memory copy. the
> thing is for cases like busy waiting or UMAIT, the length of the memory
> to be copied is usually small(otherwise we don't use busy waiting or
> UMAIT, right?). Then making it async by io_uring's iowq may introduce
> much more overhead(the context switch).

Ok, maybe we can leverage task work to avoid context switch but still
unclear how much the overhead is.

>
> Regards,
> Hao
>
>>
>>
>>
>
