Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD755591763
	for <lists+io-uring@lfdr.de>; Sat, 13 Aug 2022 00:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234156AbiHLWi2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Aug 2022 18:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbiHLWi1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Aug 2022 18:38:27 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95FF75007D
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 15:38:26 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id q7-20020a17090a7a8700b001f300db8677so2077862pjf.5
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 15:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=MY226zd9nwEhD5dcKyqf27buffAuxSF3Wp14FgYS+hI=;
        b=dKkenTtar45jkIEcetfhnTAF/vQHvWHUDh/ZIi6N9+MFcDb5mcIh9PIBIS3zi8EbrB
         H1ywdDdQAZuUk2Lh/ATCFS1AnUTa/3YDAwJAmrML18SqLpbjDjaX0ogCvspQXxKZQj6V
         Bq+AzAM9AiyZ9ksqogkXKaOoHA2YH/OlhsCe+zR489OVBWoOjRPi5eYGDlTn5LlKKYZc
         vZLAgVCClbYhMv/EcLMxCQEaFOnyrm5mD/j0KSu+BEKFPxgNi/rjr3oBf2eEpL0p949z
         uOCCaN/yqkEP4B0YlVtntvWsbmdCczL8cs3v9KlKylEBYxJy9NFRXpwqxHLsaFgf9wZb
         9gtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=MY226zd9nwEhD5dcKyqf27buffAuxSF3Wp14FgYS+hI=;
        b=MSqcRt5vSvWf7tOrGrz9vNV1NevS3QHoJdXI6hVy33Gek65DTNic23qyZPSWcyn7xT
         jOdOfBomfSla3Zt+Fb+e38i4iytlg2bDBnFWWaRQAtcsSIFJf/Jh6CKA+iBEJXWIceFV
         bQmk5dLHotAUMq2XyIYkE93tFu0Ptt4oJsUvUV27bHYzetJqtg2L5aPTIBKUczIPQrZe
         5JFC9z8GeAE/Fo0ZyokqTEknUj5V1S+18niDy1r6LV4zGuUlNx8TW8JEszFttVsOxOHh
         QwnAEww6Fp31dcbBCLUTn6Nzh44Hi7eMFG7JItGbA8i+0P1VXaztO7QTSkmHErnj3wkQ
         UTdA==
X-Gm-Message-State: ACgBeo1nzP3b93gvHazjd8wF6X4pX86neVAeFftJgpKIxmrNjzNW5Wgt
        Y9l+LySxO1/Gw0NRC1kLq4FfxQ==
X-Google-Smtp-Source: AA6agR61ypT2C8qY0SSmdnugRwFHdeRbhn2225NtagEeUxCWeqf04zBhFM3H/Lkey3umJqjLus8afg==
X-Received: by 2002:a17:90b:3848:b0:1f5:63c6:731b with SMTP id nl8-20020a17090b384800b001f563c6731bmr6160770pjb.57.1660343906078;
        Fri, 12 Aug 2022 15:38:26 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id j15-20020a170902da8f00b0016f04c098ddsm2283741plx.226.2022.08.12.15.38.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 15:38:25 -0700 (PDT)
Message-ID: <d5ac5dc5-e477-073d-82cc-a02804c0c827@kernel.dk>
Date:   Fri, 12 Aug 2022 16:38:24 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [GIT PULL] io_uring fixes for 6.0-rc1
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Keith Busch <kbusch@kernel.org>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <CAHk-=wioqj4HUQM_dXdVoSJtPe+z0KxNrJPg0cs_R3j-gJJxAg@mail.gmail.com>
 <D92A7993-60C6-438C-AFA9-FA511646153C@kernel.dk>
 <6458eb59-554a-121b-d605-0b9755232818@kernel.dk>
 <ca630c3c-80ad-ceff-61a9-63b253ba5dbd@kernel.dk>
 <433f4500-427d-8581-b852-fbe257aa6120@kernel.dk>
 <CAHk-=wi_oveXZexeUuxpJZnMLhLJWC=biyaZ8SoiNPd2r=6iUg@mail.gmail.com>
 <CAHk-=wj_2autvtY36nGbYYmgrcH4T+dW8ee1=6mV-rCXH7UF-A@mail.gmail.com>
 <bb3d5834-ebe2-a82d-2312-96282b5b5e2e@kernel.dk>
 <e9747e47-3b2a-539c-c60b-fd9ccfe5c5e4@kernel.dk>
 <YvbS/OHMJowdz+X3@kbusch-mbp.dhcp.thefacebook.com>
 <CAHk-=wg0CjDftjxVDGGwfA+rrBsg-nSOsMRS59fAw54W9N53Pw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHk-=wg0CjDftjxVDGGwfA+rrBsg-nSOsMRS59fAw54W9N53Pw@mail.gmail.com>
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

On 8/12/22 4:35 PM, Linus Torvalds wrote:
> Honestly, I think maybe we should just stop randomizing kiocb.

That'd obviously solve it... Do you want to commit something like that?
Or would you prefer a patch to do so?

-- 
Jens Axboe

