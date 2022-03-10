Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0E04D4D03
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 16:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiCJPh2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 10:37:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232317AbiCJPh1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 10:37:27 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D64516AA60
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 07:36:26 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id n19so10080405lfh.8
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 07:36:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=Ft2gsGyE8/bzygubpB5Z/qiEVZDZceJtWHRdkiOkpc4=;
        b=fOMxpgdpk186P8XmmoziHpNm7PiOZjymN4b0dPyo3vXCE3b1FfvmkITXI8mN08hLAv
         N9pi11IN/a/yGw6a1//4GQDEg6HwKjYPCjn5206mTeOraMaf6BrUbSlUSI4xWLM5ObtK
         /1cV6WwMuXXOCgFO1mPWjH06OZ1/itM1yxEBKXyZMucGx+6TeopUojOioEqbmnQdn0hp
         XiNPJkeG4rJlDCytHCVwVT0fqfQ6qMkWPLXTQqiCnTcpsZkRrB9fHuRoin0/Xwoq2gKg
         Z9CS+TattHpkNBZ2CgRwG/P3i0/i30KKnOxB8FA89PLfYJ6eFk7oMFciAerzGcfU3lKW
         Ecdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Ft2gsGyE8/bzygubpB5Z/qiEVZDZceJtWHRdkiOkpc4=;
        b=LN+xyUss0OqekV+sxV3S9zJAq1B6e0Hlyw37J7uT+rpfQTTIXyrlDM2Fwykqsea1cU
         rWx2X4C/UEpC4GXYAKPqtXbcjLA+ziky/Zh4BWZ9xL8BbS7IfFlEGrSKKmh6/9vkrveA
         S2PScXPsFuJDnLBtiyQ2+V9un9hXS8YesTyjrTBYhlZTkM+5+dGF54lXS+yXBmGoUVHO
         XT2LW1EtERuh6IAc9klcj+KntI2x6ZsCbM4evhdd7ARW+ahmpAkajybj9Z6TvNbNve+g
         gQ6fB6Z75f8P4ueOOhrSKGizhjNZx9oI0wW9Tr2SEAACYcI9pyDDV0RensFDggxrEZ65
         FWCg==
X-Gm-Message-State: AOAM532rg7ts+rBC2rFIy7gtqfr6HNrczd4B0Brhq2/VIMjNg7JBbEQl
        AiBdZ7c2kRzcKhPc+gc57DuBIuw27Q==
X-Google-Smtp-Source: ABdhPJwqb2/RxviuxkJuo76Y1mDHon5ml1oEQCC7f+OeLhdsbTtuzapm/Yp24xDcsjKhMd+AGw8DgQ==
X-Received: by 2002:a05:6512:22d1:b0:447:5fde:a2ee with SMTP id g17-20020a05651222d100b004475fdea2eemr3428107lfu.115.1646926584347;
        Thu, 10 Mar 2022 07:36:24 -0800 (PST)
Received: from [172.31.10.33] ([109.72.231.42])
        by smtp.gmail.com with ESMTPSA id j15-20020a2e3c0f000000b00247e9bafa20sm1123669lja.99.2022.03.10.07.36.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 07:36:23 -0800 (PST)
Message-ID: <0cbbe6d4-048d-9acb-2ea4-599d41f8eb28@gmail.com>
Date:   Thu, 10 Mar 2022 18:36:22 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: Sending CQE to a different ring
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <bf044fd3-96c0-3b54-f643-c62ae333b4db@gmail.com>
 <e31e5b96-5c20-d49b-da90-db559ba44927@kernel.dk>
 <c4a02dbd-8dff-a311-ce4a-e7daffd6a22a@gmail.com>
 <478d1650-139b-f02b-bebf-7d54aa24eae2@kernel.dk>
 <a13e9f56-0f1c-c934-9ca7-07ca8f82c6c8@gmail.com>
 <9f8c753d-fed4-08ac-7b39-aee23b8ba04c@kernel.dk>
 <f12c2f2b-858a-421c-d663-b944b2adb472@kernel.dk>
From:   Artyom Pavlov <newpavlov@gmail.com>
In-Reply-To: <f12c2f2b-858a-421c-d663-b944b2adb472@kernel.dk>
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

After thinking about it a bit, I think this approach has one serious 
disadvantage: you lose successful result value of the initial request. 
Imagine we submit IORING_OP_READ and link IORING_OP_WAKEUP_RING to it. 
If the request is completed successfully, both ring1 and ring2 will lose 
number of read bytes.

10.03.2022 07:14, Jens Axboe wrote:
> On 3/9/22 9:03 PM, Jens Axboe wrote:
>> I'll mull over this a bit...
> 
> One idea... You issue the request as you normally would for ring1, and
> you mark that request A with IOSQE_CQE_SKIP_SUCCESS. Then you link an
> IORING_OP_WAKEUP_RING to request A, with the fd for it set to ring2, and
> also mark that with IOSQE_CQE_SKIP_SUCCESS.
> 
> We'd need to have sqe->addr (or whatever field) in the WAKEUP_RING
> request be set to the user_data of request A, so we can propagate it.
> 
> The end result is that ring1 won't see any completions for request A or
> the linked WAKEUP, unless one of them fails. If that happens, then you
> get to process things locally still, but given that this is a weird
> error case, shouldn't affect things in practice. ring2 will get the CQE
> posted once request A has completed, with the user_data filled in from
> request A. Which is really what we care about here, as far as I
> understand.
> 
> This basically works right now with what I posted, and without needing
> to rearchitect a bunch of stuff. And it's pretty efficient. Only thing
> we'd need to add is passing in the target cqe user_data for the WAKEUP
> request. Would just need to be wrapped in something that allows you to
> do this easily, as it would be useful for others too potentially.
> 
