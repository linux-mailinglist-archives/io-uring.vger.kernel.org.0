Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00FDA58BC8F
	for <lists+io-uring@lfdr.de>; Sun,  7 Aug 2022 20:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235629AbiHGSqt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Aug 2022 14:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235627AbiHGSqs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Aug 2022 14:46:48 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE7D2BD7
        for <io-uring@vger.kernel.org>; Sun,  7 Aug 2022 11:46:47 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d16so6737682pll.11
        for <io-uring@vger.kernel.org>; Sun, 07 Aug 2022 11:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=fRF6tDwiED09Qm8+jjF0m2XwEBk/N1T42MZbGGhUU2s=;
        b=sUfIjnfFg6C7BTgJCAUiobCnbcymxCqjth0VgNCg5PRpdOLoFXN06GP/722jVG/hut
         4X/7qgNXMYcShr8q27lbxVxfQ21iOwZdtwyZmgX8B72vmSMeYt2fLKSFupJubJr7uXAz
         bIz7blhJEPqDbCHiBgiaBkm9/9AiWj1jDbf2w0cgyUeGKRlvs72m0HeNSYhJBhb06cru
         GAJV2EIdUH2dYA6Vj1qmWmrRyWb2wpxuW9W2/7qjWeavx9CM5E59Ip9GnyxEE0GLELSd
         QQuhncoy6aalVGBpadAattGstyajxkl5ceqlxvc/h1nN4eA8unicErsc1OGzuRb8ytB2
         Yjbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=fRF6tDwiED09Qm8+jjF0m2XwEBk/N1T42MZbGGhUU2s=;
        b=j5dgy7dV4Fnn0Ufwia1mWiJZAGa3/x9QVn7ctQdcHGMJE5b32PFHK/lwgWdX56SO4i
         qYtLrVtqcOKwUxjBuGwlJXfAELlsOOGjnO3vw79ZnYgSk28QQXnhRPm+tCNRHzjbMWP/
         61LMG1s6ge7zIAcntSgRwUwYnH6JwM1jAV3HK++Jk7/aJaqu3/kLkub57hJrvNrfKJM8
         TOuwvvA4U4LsvvmSl3WU6Ds/rVJLmj/FBPZlrbT7WySFew68Nl7vipxVSZhz/bEFkk+7
         nP79VPaGKuT8Lvye+3qqXSDeoUwZq4jhm4OtKbfUZURC0eyBSqd0A72pqVUuxkDsJylR
         01Zw==
X-Gm-Message-State: ACgBeo1F1RrVXq2agXv7edqFi6QrUUAJU+OGHES0m76U2o8GMa38w8UB
        m5iaJGRG8sxwpC2jjz7wOYuIGQ==
X-Google-Smtp-Source: AA6agR52R7nPXz6hA/NEJIpwExQy73zN+UQ2YPf1Pb4UGZRqFX/ApCGAZKP7G39++6dymp7prQKsLg==
X-Received: by 2002:a17:902:c40a:b0:16e:cc02:b9ab with SMTP id k10-20020a170902c40a00b0016ecc02b9abmr15621295plk.81.1659898006947;
        Sun, 07 Aug 2022 11:46:46 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i25-20020a635419000000b0041c89bba5a8sm4787876pgb.25.2022.08.07.11.46.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Aug 2022 11:46:46 -0700 (PDT)
Message-ID: <068737bb-7729-decd-bd3b-60380c6443fc@kernel.dk>
Date:   Sun, 7 Aug 2022 12:46:45 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 0/4] iopoll support for io_uring/nvme passthrough
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     Keith Busch <kbusch@kernel.org>, hch@lst.de,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, ming.lei@redhat.com,
        joshiiitr@gmail.com, gost.dev@samsung.com
References: <CGME20220805155300epcas5p1b98722e20990d0095238964e2be9db34@epcas5p1.samsung.com>
 <20220805154226.155008-1-joshi.k@samsung.com>
 <78f0ac8e-cd45-d71d-4e10-e6d2f910ae45@kernel.dk>
 <a2a5184d-f3ab-0941-6cc4-87cf231d5333@kernel.dk>
 <Yu1dTRhrcOSXmYoN@kbusch-mbp.dhcp.thefacebook.com>
 <6bd091d6-e0e6-3095-fc6b-d32ec89db054@kernel.dk>
 <20220807175803.GA13140@test-zns>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220807175803.GA13140@test-zns>
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

On 8/7/22 11:58 AM, Kanchan Joshi wrote:
> On Fri, Aug 05, 2022 at 12:15:24PM -0600, Jens Axboe wrote:
>> On 8/5/22 12:11 PM, Keith Busch wrote:
>>> On Fri, Aug 05, 2022 at 11:18:38AM -0600, Jens Axboe wrote:
>>>> On 8/5/22 11:04 AM, Jens Axboe wrote:
>>>>> On 8/5/22 9:42 AM, Kanchan Joshi wrote:
>>>>>> Hi,
>>>>>>
>>>>>> Series enables async polling on io_uring command, and nvme passthrough
>>>>>> (for io-commands) is wired up to leverage that.
>>>>>>
>>>>>> 512b randread performance (KIOP) below:
>>>>>>
>>>>>> QD_batch    block    passthru    passthru-poll   block-poll
>>>>>> 1_1          80        81          158            157
>>>>>> 8_2         406       470          680            700
>>>>>> 16_4        620       656          931            920
>>>>>> 128_32      879       1056        1120            1132
>>>>>
>>>>> Curious on why passthru is slower than block-poll? Are we missing
>>>>> something here?
>>>>
>>>> I took a quick peek, running it here. List of items making it slower:
>>>>
>>>> - No fixedbufs support for passthru, each each request will go through
>>>>   get_user_pages() and put_pages() on completion. This is about a 10%
>>>>   change for me, by itself.
>>>
>>> Enabling fixed buffer support through here looks like it will take a
>>> little bit of work. The driver needs an opcode or flag to tell it the
>>> user address is a fixed buffer, and io_uring needs to export its
>>> registered buffer for a driver like nvme to get to.
>>
>> Yeah, it's not a straight forward thing. But if this will be used with
>> recycled buffers, then it'll definitely be worthwhile to look into.
> 
> Had posted bio-cache and fixedbufs in the initial round but retracted
> to get the foundation settled first.
> https://lore.kernel.org/linux-nvme/20220308152105.309618-1-joshi.k@samsung.com/
> 
> I see that you brought back bio-cache already. I can refresh fixedbufs.

Excellent, yes please bring back the fixedbufs. It's a 5-10% win,
nothing to sneeze at.

> Completion-batching seems too tightly coupled to block-path.

It's really not, in fact it'd be even simpler to do for passthru. The
rq->end_io handler just needs to know about it.

-- 
Jens Axboe

