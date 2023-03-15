Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3F66BBED6
	for <lists+io-uring@lfdr.de>; Wed, 15 Mar 2023 22:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbjCOVTJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Mar 2023 17:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232702AbjCOVTC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Mar 2023 17:19:02 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB7CA42E1
        for <io-uring@vger.kernel.org>; Wed, 15 Mar 2023 14:18:21 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id v10so1917725iol.9
        for <io-uring@vger.kernel.org>; Wed, 15 Mar 2023 14:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678915099; x=1681507099;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bIYT0+xpR5tsbj3ao3uKxtJchSvPWHkBhoXmIa1p4zo=;
        b=11LZD0Qks6sw+dbM9c0pgauuBpE09KhUG3C/dDSq62Luh2rciS0o+xF8RGqAiPGzOR
         kZHxUZPPdvsvcxDfTTr2iKwHcQNB3zj2acdQWg/2HyIkOlESLKTNf6AFXchQpTpNaOC/
         ohr40f8VSVU7mNzCp6zfd+rarv/cCP1cvHUvjlab1WITlcVxoBEIDMVLUNr79PoR4wNT
         cbq7QwISjOleqPfC4XC/SMBrOL+VEhEv8HVO8CeQtJrE+vLVLjY1qCTaR/Ue6JvgA1SW
         9Nu+pxmdPn4voTt7Q8LT2uTNjYN9riv438wjP0z8MRSkZu+xOrzWVPts1CBpa5zrsFU5
         OC7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678915099; x=1681507099;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bIYT0+xpR5tsbj3ao3uKxtJchSvPWHkBhoXmIa1p4zo=;
        b=pPEnnye6U2JxJDodqxpkpXF9sSetbxyqqnBmq4DVVCHShKCujh1NBEVKZfB6Q7DT6l
         zsNefmMBPK6Z4kQkG1X0Qz2eYRAvowK5sgGJ1mV00o2mGNkXb+w48AmIKKuL4PsSqMpQ
         /5wyfOIDovVfXd8mYmUeJ3qVg+mrusTgVQy0xI/Gyv4ClOpSn/FPt5cFcTY6ElRNHZiJ
         KPpIKqk5Zbef5iPMGNIuHdNrmfHrqGMdcQYv6nmdFNvGeEP//gpZI4i0kb4VSGjPKXyL
         qikXONU/08qkRpx3yF+9cmGjJWm7k5jHNWpEwRY38m97g2AlyZh1etzWY3ligV7xp8ej
         nKPw==
X-Gm-Message-State: AO0yUKVWIgRIp+x3fjh6oFKlG60DB00yMnKFYGQhM7gahrxr6jajYDZr
        GFWOb8OwWCbmBUawcHEMeourOw==
X-Google-Smtp-Source: AK7set8gX9O74rpxEHPRf9c1w7stw5AnCzT69Ml4fEIqH6vTJqNFNcu3NZaeVDBmU/A8VO+PJKGinw==
X-Received: by 2002:a5e:a50d:0:b0:74c:9cc4:647 with SMTP id 13-20020a5ea50d000000b0074c9cc40647mr434300iog.1.1678915099091;
        Wed, 15 Mar 2023 14:18:19 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id r1-20020a6bd901000000b007407cafe4desm782157ioc.21.2023.03.15.14.18.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 14:18:18 -0700 (PDT)
Message-ID: <41a23244-a77a-01c4-46de-76b85a6f4d63@kernel.dk>
Date:   Wed, 15 Mar 2023 15:18:16 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCHSET 0/5] User mapped provided buffer rings
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Helge Deller <deller@gmx.de>, io-uring@vger.kernel.org,
        linux-parisc <linux-parisc@vger.kernel.org>
References: <20230314171641.10542-1-axboe@kernel.dk>
 <0eeed691-9ea1-9516-c403-5ba22554f8e7@gmx.de>
 <3dcf3e0c-d393-cb95-86ab-00b4d8cf3c75@gmx.de>
 <88b273f6-a747-7d2e-7981-3d224fdac7be@kernel.dk>
In-Reply-To: <88b273f6-a747-7d2e-7981-3d224fdac7be@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/15/23 2:38 PM, Jens Axboe wrote:
> On 3/15/23 2:07?PM, Helge Deller wrote:
>> On 3/15/23 21:03, Helge Deller wrote:
>>> Hi Jens,
>>>
>>> Thanks for doing those fixes!
>>>
>>> On 3/14/23 18:16, Jens Axboe wrote:
>>>> One issue that became apparent when running io_uring code on parisc is
>>>> that for data shared between the application and the kernel, we must
>>>> ensure that it's placed correctly to avoid aliasing issues that render
>>>> it useless.
>>>>
>>>> The first patch in this series is from Helge, and ensures that the
>>>> SQ/CQ rings are mapped appropriately. This makes io_uring actually work
>>>> there.
>>>>
>>>> Patches 2..4 are prep patches for patch 5, which adds a variant of
>>>> ring mapped provided buffers that have the kernel allocate the memory
>>>> for them and the application mmap() it. This brings these mapped
>>>> buffers in line with how the SQ/CQ rings are managed too.
>>>>
>>>> I'm not fully sure if this ONLY impacts archs that set SHM_COLOUR,
>>>> of which there is only parisc, or if SHMLBA setting archs (of which
>>>> there are others) are impact to any degree as well...
>>>
>>> It would be interesting to find out. I'd assume that other arches,
>>> e.g. sparc, might have similiar issues.
>>> Have you tested your patches on other arches as well?
>>
>> By the way, I've now tested this series on current git head on an
>> older parisc box (with PA8700 / PCX-W2 CPU).
>>
>> Results of liburing testsuite:
>> Tests timed out (1): <send-zerocopy.t> - (may not be a failure)
>> Tests failed (5): <buf-ring.t> <file-verify.t> <poll-race-mshot.t> <ringbuf-read.t> <send_recvmsg.t>

If you update your liburing git copy, switch to the ring-buf-alloc branch,
then all of the above should work:

axboe@c8000 ~/g/liburing (ring-buf-alloc)> test/buf-ring.t
axboe@c8000 ~/g/liburing (ring-buf-alloc)> test/send_recvmsg.t 
axboe@c8000 ~/g/liburing (ring-buf-alloc)> test/ringbuf-read.t 
axboe@c8000 ~/g/liburing (ring-buf-alloc)> test/poll-race-mshot.t 
axboe@c8000 ~/g/liburing (ring-buf-alloc)> git describe
liburing-2.3-245-g8534193

-- 
Jens Axboe


