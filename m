Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C77324D4E23
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 17:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240576AbiCJQIR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 11:08:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240596AbiCJQIR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 11:08:17 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E0A186466
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 08:07:14 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id v28so8368480ljv.9
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 08:07:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=U/9GzjtD6fIdnsJMO8Qq90rnrvRkfG6DfN9Warj4uuw=;
        b=Ogv9nOkKQnTi5mB8lZ/za+soYYj4tFsQ4dZqGknnR98MlIwQaE7evIhSfeKpsX44Kb
         ubSq3wdlUk2Ssh5l7T9AMkJ/2PSdJIIvP+afMRimjy/EermnuIoBXXXa6fOwcIyIrFyg
         m0qmr8X5YS2J3hlQ7BBn3FbzeNSMvXK6yBKmtUGClAcQGfN0TZ4uLYPT6UcrfHsRDhW3
         b7u92+ZuzqcvNjFZFJf9Mg6Ywxhp6WrRiCTffoGynZWlxTDA1YT+xlG73snxCR0oBMHc
         cUbXMdVItOR+loHk+OH5abhxDQWMjaRl3p309PvCmjH6atRJujEvEioHZ/Cka4g+92yS
         v9tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=U/9GzjtD6fIdnsJMO8Qq90rnrvRkfG6DfN9Warj4uuw=;
        b=X+kbw7GATmbekBWIqk9qeiMmS9UEUSlNOQ6OLn8Ferr53Of4F1mlFsZ442e91j2hRU
         pSDidh2HE6OwB4dysRbqVLcwP98qZLnz3kc62AO9oYL+bam6ulBqMmoJyJAnJCiEXMGh
         tD0gjhlqCWaL8ywVwKGSNCSVGD2XJJUxb9hAICEnLa6Ld1IxOznuxFJ0yk2EsI+FvK7q
         blL6KEUxKy4B+gD4/kg9LSgZKYpicyBuzxi7UUwb8nP/HMnVl8nNqs1mWON96BOCodhV
         qGWpVasS5Kh8uRN1gw/6YIzDk87timw6etsM3p2Kmo35UMbIm9h/JDYNPNhX0Mmmsey6
         J2CQ==
X-Gm-Message-State: AOAM5304sFcnFH+I1oBWaIoP8zaob/TtcSxFa692XOdaMupnbcidfGfn
        i5A0WB6E+ewB5yEcSVFGWQ==
X-Google-Smtp-Source: ABdhPJwp7ahBLPKA+CYHuvhUjaHHn7kjclLWnOxzJBlDjSkzv9Jqr1jgX4ri4gd7q9a8ry+CWFLQOw==
X-Received: by 2002:a2e:980a:0:b0:241:c1e6:2664 with SMTP id a10-20020a2e980a000000b00241c1e62664mr3510008ljj.320.1646928433073;
        Thu, 10 Mar 2022 08:07:13 -0800 (PST)
Received: from [172.31.10.33] ([109.72.231.42])
        by smtp.gmail.com with ESMTPSA id be14-20020a05651c170e00b00247e88d9c99sm1137232ljb.91.2022.03.10.08.07.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 08:07:12 -0800 (PST)
Message-ID: <4b2ee3a3-d745-def3-8a15-eb8840301247@gmail.com>
Date:   Thu, 10 Mar 2022 19:07:11 +0300
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
 <0cbbe6d4-048d-9acb-2ea4-599d41f8eb28@gmail.com>
 <1bfafa03-8f5f-be7a-37a5-f3989596ff5a@kernel.dk>
 <9a23cd0e-b7eb-6a5c-a08d-14d63f47bb05@kernel.dk>
 <22ed0dd2-9389-0468-cd92-705535b756bb@gmail.com>
 <21c3b3b6-31bb-1183-99b7-7c8ab52e953d@kernel.dk>
From:   Artyom Pavlov <newpavlov@gmail.com>
In-Reply-To: <21c3b3b6-31bb-1183-99b7-7c8ab52e953d@kernel.dk>
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

>> Yes, passing positive result value would make more sense than PID of
>> submitter, which is rarely, if ever, needed. IIUC we would not be able
>> to use linking with such approach, since sqe->len has to be set in
>> user code based on a received CQE, but I guess it should be fine in
>> practice.
> 
> Right, and using sqe->len and passing it through makes a lot more sense
> in general as you can pass whatever you want there. If you want to use
> the pid, you can use it like that. Or for whatever else you'd want. That
> gives you both 'len' and 'user_data' as information you can pass between
> the rings.
> 
> It could also be used as `len` holding a message type, and `user_data`
> holding a pointer to a struct. For example.

I like IORING_OP_WAKEUP_RING with sqe->len being copied to cqe->result. 
The only question I have is how should "negative" (i.e. bigger or equal 
to 2^31) lengths be handled. They either should be copied similarly to 
positive values or we should get an error.

Also what do you think about registering ring fds? Could it be beneficial?
