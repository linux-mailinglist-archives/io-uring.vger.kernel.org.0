Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B85E4CD795
	for <lists+io-uring@lfdr.de>; Fri,  4 Mar 2022 16:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240231AbiCDPXG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Mar 2022 10:23:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240222AbiCDPXE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Mar 2022 10:23:04 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4B61C4691
        for <io-uring@vger.kernel.org>; Fri,  4 Mar 2022 07:22:16 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id e15so6288638pfv.11
        for <io-uring@vger.kernel.org>; Fri, 04 Mar 2022 07:22:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=OsUqkEvNTnAWkUtyecgtfp65UC70q88b7sUYNrwslM4=;
        b=b75XCGyOkAOXlJ0LK+MGGYBtTY3bH9uC1uC3Z24wp1sqQuyxkHwCxnpsx7yTCq9j44
         oADsoWNVPUQk0oaPWlQC3FaFleI3Vx4yfq3SlNItWgT18ghufljrDxqyX5nrfyQAtfAx
         P0oBLpOrPuICQrHCT/m2Wd2BherLtkVrhg1ktRJa3VDXvCpV67ZGn/AH/PSsA0JU9uI9
         DiV7sM1YMGGxc3dwNGgqwi0kVNI+1AvgkwZWyLJvMJ0GI0I9HsbJuk0mG/iOSVIzUcdQ
         ZwSt0DVdbB9nDUD9CBV0QExQWTOrJ/XWERf5+goRJZEznk+Swwsj7OBMh6iIbhxIgATz
         RAng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OsUqkEvNTnAWkUtyecgtfp65UC70q88b7sUYNrwslM4=;
        b=NX23thdiYrjAiwOXqrngJygPoPTtNJd18C/dCgveZatEEVoEzEz/hAcwYpyQBoVDXK
         f1ZHLFPcHqypOaGDYBq13CGrs23oqnXqdQz037sFnNlbyrDgsg/P4aAM0R+9AMagAfk0
         NXRv5WwFPoe/TU99zL11dn7d0rN0rEP1384NuBneBpVhjdsTuDaU5+ruC5e6+aRv6JaF
         CAnN07cav5lO/HtDTORT6WS/rZCysTJWPGZ4WIoLAJkvr/NzS6mpxF4GK+82H8Oln6WN
         7Wdmg865vsWVopQFZQzvCcr97QtWefhVyOeTcKtnva0i8gxg89d/VjK+4vgbg2qSdLWP
         Rlpw==
X-Gm-Message-State: AOAM531Y6ISwbQh/N+HrA6iVhlmN8vXeW1OuQ+27yO3oHLVFGQeYxEy1
        Eq+2IDmJGvEbuAfMe0M/bYXy5A==
X-Google-Smtp-Source: ABdhPJzu3W/bjhiPNWAH4TUN/eiwW/Q++d5XBBSZ3dIWC6WlYGfrQGDRj4R/lvYxFZplHuR4KgVlZA==
X-Received: by 2002:a05:6a00:189e:b0:4f6:5d32:dc9a with SMTP id x30-20020a056a00189e00b004f65d32dc9amr11981059pfh.28.1646407335644;
        Fri, 04 Mar 2022 07:22:15 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t6-20020a056a0021c600b004f6cd1dc51asm576770pfj.113.2022.03.04.07.22.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Mar 2022 07:22:15 -0800 (PST)
Message-ID: <044ccbcd-2339-dc67-2af5-b599c37b7114@kernel.dk>
Date:   Fri, 4 Mar 2022 08:22:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] io_uring: add io_uring_enter(2) fixed file support
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220303052811.31470-1-xiaoguang.wang@linux.alibaba.com>
 <4f197b0e-6066-b59e-aae0-2218e9c1b643@kernel.dk>
 <528ce414-c0fe-3318-483a-f51aa8a407b9@kernel.dk>
 <040e9262-4ebb-8505-5a14-6f399e40332c@kernel.dk>
 <951ea55c-b6a3-59e4-1011-4f46fae547b3@kernel.dk>
 <66bfc962-b983-e737-7c36-85784c52b7fa@kernel.dk>
 <8466f91e-416e-d53e-8c24-47a0b20412ac@kernel.dk>
 <968510d6-6101-ca0f-95a0-f8cb8807b0da@kernel.dk>
 <6b1a48d5-7991-b686-06fa-22ac23650992@kernel.dk>
 <3a59a3e1-4aa8-6970-23b6-fd331fb2c75c@linux.alibaba.com>
 <43e733d9-f62d-34b5-318c-e1abaf8cc4a3@kernel.dk>
 <b12cd9d2-ee0a-430a-e909-608621c87dcc@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <b12cd9d2-ee0a-430a-e909-608621c87dcc@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

>> I'll take a look at liburing and see what we need to do there. I think
>> the sanest thing to do here is say that using a registered ring fd means
>> you cannot share the ring, ever. And then just have a
>> ring->enter_ring_fd which is normally just set to ring_fd when the ring
>> is setup, and if you register the ring fd, then we set it to whatever
>> the registered value is. Everything calling io_uring_enter() then just
>> needs to be modified to use ->enter_ring_fd instead of ->ring_fd.
> ok, look forward to use this api.

Can you take a look at the registered-ring branch for liburing:

https://git.kernel.dk/cgit/liburing/log/?h=registered-ring

which has the basic plumbing for it. Comments (or patches) welcome!

Few things I don't really love:

1) You need to call io_uring_register_ring_fd() after setting up the
   ring. We could provide init helpers for that, which just do queue
   init and then register ring. Maybe that'd make it more likely to get
   picked up by applications.

2) For the setup where you do share the ring between a submitter and
   reaper, we need to ensure that the registered ring fd is the same
   between both of them. We need a helper for that. It's basically the
   same as io_uring_register_ring_fd(), but we need the specific offset.
   And if that fails with -EBUSY, we should just turn off
   INT_FLAG_RING_REG for the ring and you don't get the registered fd
   for either of them. At least it can be handled transparantly.

>>>> Anyway, current version below. Only real change here is allowing either
>>>> specific offset or generated offset, depending on what the
>>>> io_uring_rsrc_update->offset is set to. If set to -1U, then io_uring
>>>> will find a free offset. If set to anything else, io_uring will use that
>>>> index (as long as it's >=0 && < MAX).
>>> Seems you forgot to attach the newest version, and also don't see a
>>> patch attachment. Finally, thanks for your quick response and many
>>> code improvements, really appreciate it.
>> Oops, below now. How do you want to handle this patch? It's now a bit of
>> a mix of both of our stuff...
> Since you have almost rewritten most of my original patch and now it
> looks much better, so I would suggest just adds my Reported-by :)

OK I'll post it, but Co-developed-by is probably a better one.

-- 
Jens Axboe

