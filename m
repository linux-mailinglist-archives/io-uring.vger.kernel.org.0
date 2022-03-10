Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA0B4D4F53
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 17:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237227AbiCJQbH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 11:31:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242062AbiCJQbG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 11:31:06 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 184B385978
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 08:30:05 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id x4so7059162iop.7
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 08:30:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=AL02QRBFRVERn9FfzhUwtGFlFWL+YEujK1qjXZCc184=;
        b=Wwzx9V0tMWM2x484tV2pDRu3CW93VBe4RKC6KjtxtgiHI/Y2iU5uLlnv0DzozuKW8W
         yfrRb5ykSjJ0T6u6aJT93hWFjlvCx2gezjw092I+6ZjiwX3pODj8dzuZiBF+cCD3hRNo
         0ArtPbF+ay+9oFAdFMCEPBWPlyh5HLUpj5MzWRpkO17iS6M8UPwPuZAnE4Rx8TpjLTwS
         ChRvTkPggeNA90k/edVNrdBrMFgdEX7fpQOrE/Ct2kmyL+PldAZ5kk8R3NBrhEf/aZ8N
         OtDqnqVVtph4vg295vuCyvDT8PNJpjl2pwuv0s0OLm+DgyL2dkpvJ6qHsEQVpT5FdFx/
         Jfzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AL02QRBFRVERn9FfzhUwtGFlFWL+YEujK1qjXZCc184=;
        b=6EsqMojZ/XS4hFaSdwEgv5muTYBwouo+andQRt2tyZhGxlU5nlega2H2TQGrrPcYmN
         XMQbhhqmDB8rIEOw0wnQdkzhwX3NqgZMROozCc574RIR4nC7DcOV0qgXhquQ545LohFF
         As6j/H33/XJZql+4bo4oDYoJeoN7DQBk7nb8VA8NOykR7qYo57oceDLYWQ2/zaeTIJR9
         UJ/DgbA2kOiRZQ0oHy6FcT9+Gov4kbFKPA9JQBUTgM+23sccslYnhf/9S84hij+eGctL
         /2GqU7+ADR3xRBoFxefwAp0Wsiaus1h3c/uN2gFz5AGYqalLkaNReUHZwiKJTkJSDz6o
         3wzA==
X-Gm-Message-State: AOAM530aBeaEPaQHx5iTPMOJFJuEmPxZ1/MII7uC1JP+sMEUn0m2eUer
        oxy3NqWlCJT177mE8P1+h0Fjrw==
X-Google-Smtp-Source: ABdhPJwA612fVIGP3Z33/xmruewwsTUZ1F8b8z+crG1VfacuHfvbqqnZLtScKa9RGdFbypQAdejK0w==
X-Received: by 2002:a05:6638:531:b0:317:af7d:d934 with SMTP id j17-20020a056638053100b00317af7dd934mr4453369jar.307.1646929804423;
        Thu, 10 Mar 2022 08:30:04 -0800 (PST)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id r2-20020a92d442000000b002c62b540c85sm2923855ilm.5.2022.03.10.08.30.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 08:30:04 -0800 (PST)
Message-ID: <e0b72d3e-5055-d998-6555-53c6475f38c6@kernel.dk>
Date:   Thu, 10 Mar 2022 09:30:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: Sending CQE to a different ring
Content-Language: en-US
To:     Artyom Pavlov <newpavlov@gmail.com>, io-uring@vger.kernel.org
References: <bf044fd3-96c0-3b54-f643-c62ae333b4db@gmail.com>
 <e31e5b96-5c20-d49b-da90-db559ba44927@kernel.dk>
 <c4a02dbd-8dff-a311-ce4a-e7daffd6a22a@gmail.com>
 <478d1650-139b-f02b-bebf-7d54aa24eae2@kernel.dk>
 <a13e9f56-0f1c-c934-9ca7-07ca8f82c6c8@gmail.com>
 <9f8c753d-fed4-08ac-7b39-aee23b8ba04c@kernel.dk>
 <f12c2f2b-858a-421c-d663-b944b2adb472@kernel.dk>
 <0cbbe6d4-048d-9acb-2ea4-599d41f8eb28@gmail.com>
 <1bfafa03-8f5f-be7a-37a5-f3989596ff5a@kernel.dk>
 <9a23cd0e-b7eb-6a5c-a08d-14d63f47bb05@kernel.dk>
 <22ed0dd2-9389-0468-cd92-705535b756bb@gmail.com>
 <21c3b3b6-31bb-1183-99b7-7c8ab52e953d@kernel.dk>
 <4b2ee3a3-d745-def3-8a15-eb8840301247@gmail.com>
 <2ba7fb27-0eec-e2a2-c986-529175c79cbe@kernel.dk>
 <0b9831d8-0597-9d17-e871-e964e257e8a7@gmail.com>
 <93fa6d65-164c-3956-b143-9b3fb88a391a@kernel.dk>
 <ccdc456d-05d0-15f5-2175-3ee8e73260a1@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ccdc456d-05d0-15f5-2175-3ee8e73260a1@gmail.com>
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

On 3/10/22 9:28 AM, Artyom Pavlov wrote:
>>> It looks like we have 3 options:
>>> 1) Copy sqe->len to cqe->result without any checks. Disadvantage:
>>> user-provided value may collide with EBADFD and EOVERFLOW.
>>> 2) Submit error CQE to the submitter ring.
>>> 3) Submit error CQE to the receiver ring (cqe->result will contain
>>> error code).
>>
>> #1 should not be an issue, as cqe->result for those values is the
>> original ring result code, not the target ring.
>>
>> I'd say the application should just case it to u32 and intepret it like
>> that, if it's worried about the signed nature of it?
> 
> Ah, indeed. I've missed that EBADFD and EOVERFLOW errors only can
> happen in the submitter ring, so the receiver ring can always
> interpret CQE with the IORING_CQE_F_MSG flag as a successfully
> received message from another ring.

Yes, so I don't think there's any confusion there. I did just make the
prep helper in liburing take an unsigned, and I did test that we don't
have any issues on that front.

Posted v2, passes testing too. I actually think this is quite a nifty
feature, and can be used quite flexibly to communicate between rings.

-- 
Jens Axboe

