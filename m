Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A55294D18C3
	for <lists+io-uring@lfdr.de>; Tue,  8 Mar 2022 14:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244140AbiCHNLJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Mar 2022 08:11:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238653AbiCHNLJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Mar 2022 08:11:09 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3772483A7
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 05:10:12 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id c11so4020389pgu.11
        for <io-uring@vger.kernel.org>; Tue, 08 Mar 2022 05:10:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=MNvsxHdJAYYMhlFTkMQcoV/QsSkcancec1z2wi50Rpc=;
        b=6N1UImQF5+6ArvkDOyGAGVGeJB/jViig8IheXGQBLKMhwUvvXyRvObVvR3DZuAKgE6
         P80P72r1BoiQBcEAsoTeTHw0dJ87q/Ta5YBuCFi+lc9PNs+bP7SZmnxycP1nPmpCItBE
         LOz9BH5EEb7hmGM42MqTy1r3YQYREhHDkZAhTcMbx+JgHb+I3YtGXX8LNH4Ll8n3bs1u
         beHe/QQG7U7ptKkAsiLZ8g58QeF+Pc0lbwpNafTdC7KFHSVwiUte5B/wkaxSzqxajEmE
         +CXH8/MKt6Bl0ysC2mzxgEh4t5QmESKa21ikC4NEgiZACCdI/dludNdgeMgrTcp1DYyj
         k5Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MNvsxHdJAYYMhlFTkMQcoV/QsSkcancec1z2wi50Rpc=;
        b=ELIkdeTUFS5oHaYlF7skrMesM1ROPue8rXxRv1dAmdp67Ad1zkPw/Tclgu3XWO/aPE
         JYzpayJh7YXhxt0DSeMewEc3KIIzZhbzqLTwD9K9SF1P7EYyONXpEXNpfCE660ufXfna
         zqRf9WEKHtaT3Q7klfC41lUVfLdMuvZkfBYth8/2fW3+f/TtYWjrWE/Gp8DJkSuYqpHO
         TjkEIM+cDkSR8IwiVGON/asIlYyBr0OSM5+V/RckEtG74yxnyA/cMMs+OcxWWl3FtFe9
         fVflUZCfO9LcJ6KXYKop3MAbLzzkK2Vy60WR9KeLoWRF1AYRFyjVWmEOWfqLrUpvJlmC
         kjXg==
X-Gm-Message-State: AOAM532245/JfC27fS5QyDOuAIMKnkRw0k0DWPTwgBPa1aIBHBc12YiR
        Qop+7BrD/Dtp5REIy6vWXBVokSNcAQw+azLy
X-Google-Smtp-Source: ABdhPJxflpRIflM0+WP1/mnZQPEZyS4zV4JjS6bunHAa7G23KMtpoXsPxevyAz/khhmApj6lGvx79g==
X-Received: by 2002:a05:6a00:1806:b0:4f6:f3e8:b3a0 with SMTP id y6-20020a056a00180600b004f6f3e8b3a0mr11841960pfa.43.1646745012145;
        Tue, 08 Mar 2022 05:10:12 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q9-20020a056a00088900b004e03b051040sm20766595pfj.112.2022.03.08.05.10.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 05:10:11 -0800 (PST)
Message-ID: <0a735dee-dc6f-f3e4-21c0-ad856b658331@kernel.dk>
Date:   Tue, 8 Mar 2022 06:10:09 -0700
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
 <044ccbcd-2339-dc67-2af5-b599c37b7114@kernel.dk>
 <9938e76f-420d-c20e-fb46-a75fa960f284@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <9938e76f-420d-c20e-fb46-a75fa960f284@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/8/22 1:38 AM, Xiaoguang Wang wrote:
> hi,
> 
>>>> I'll take a look at liburing and see what we need to do there. I think
>>>> the sanest thing to do here is say that using a registered ring fd means
>>>> you cannot share the ring, ever. And then just have a
>>>> ring->enter_ring_fd which is normally just set to ring_fd when the ring
>>>> is setup, and if you register the ring fd, then we set it to whatever
>>>> the registered value is. Everything calling io_uring_enter() then just
>>>> needs to be modified to use ->enter_ring_fd instead of ->ring_fd.
>>> ok, look forward to use this api.
>> Can you take a look at the registered-ring branch for liburing:
>>
>> https://git.kernel.dk/cgit/liburing/log/?h=registered-ring
>>
>> which has the basic plumbing for it. Comments (or patches) welcome!
> Sorry for late reply, spend time to read your patch today. Basically it looks ok,
> there is one minor issue in "Add preliminary support for using a registered ring fd":
> @@ -417,6 +425,10 @@ struct io_uring_sqe *io_uring_get_sqe(struct io_uring *ring)
> 
>  int __io_uring_sqring_wait(struct io_uring *ring)
>  {
> -    return  ____sys_io_uring_enter(ring->ring_fd, 0, 0,
> -                       IORING_ENTER_SQ_WAIT, NULL);
> +    int flags = IORING_ENTER_SQ_WAIT;
> +
> +    if (ring->int_flags & INT_FLAG_REG_RING)
> +        flags |= IORING_ENTER_REGISTERED_RING;
> +
> +    return  ____sys_io_uring_enter(ring->ring_fd, 0, 0, flags, NULL);
>  }
> 
> Here it should be enter_ring_fd.

Ah good catch, I've fixed that up.

>> Few things I don't really love:
>>
>> 1) You need to call io_uring_register_ring_fd() after setting up the
>>     ring. We could provide init helpers for that, which just do queue
>>     init and then register ring. Maybe that'd make it more likely to get
>>     picked up by applications.
> Agree, that'd be better in some cases, but consider that currently the
> capacity of ring fd cache is just 16, I'd suggest to let users make
> their own decisions, in case some ring fds could not allocate one
> empty slot, but some ring fds don't need them at all, for example,
> ring fd which enable sqpoll may no need this feature.

Agree, that's the route I ended up taking too.

>> 2) For the setup where you do share the ring between a submitter and
>>     reaper, we need to ensure that the registered ring fd is the same
>>     between both of them. We need a helper for that. It's basically the
>>     same as io_uring_register_ring_fd(), but we need the specific offset.
>>     And if that fails with -EBUSY, we should just turn off
>>     INT_FLAG_RING_REG for the ring and you don't get the registered fd
>>     for either of them. At least it can be handled transparantly.
> Storing enter_ring_fd in struct io_uring seems not good, struct
> io_uring is a shared struct, as what you say, different threads that
> share one ring fd may have differed offset in ring fd cache. I have
> two suggestions:
> 1) Threads keep their offset in ring fd cache alone, and pass it to
> io_uring_submit, which may look ugly :)
> 2) define enter_ring_fd in struct io_ring to be a thread_local type,
> then your patches don't need to do any modifications.

Maybe I'm missing something here, but I don't see how your number 2 is
possible?

I think for now I'll just keep it as-is. Yes, then you can't use a
registered ring fd if you share the ring betwen threads, but so be it.

-- 
Jens Axboe

