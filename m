Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74B575AD62F
	for <lists+io-uring@lfdr.de>; Mon,  5 Sep 2022 17:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237835AbiIEPTU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 11:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238704AbiIEPTP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 11:19:15 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164291EEF2
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 08:19:13 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id og21so17771427ejc.2
        for <io-uring@vger.kernel.org>; Mon, 05 Sep 2022 08:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=GsCy44wdMFCuadHqTui9YjzW4+OMVccBA+mChcrb/98=;
        b=qU5ZbaqZFpHpiG6lBUgyVjC3zHTZcibH8G+BMsWCllDxKkrdTJgLxsdFNwiAvFbkf0
         H6eFRU44jhOWAS5B6m8KrRQFwZEoQrap98sSjwMA9mZ57LuLkTbg1Rdw3cd6Z92hw6cb
         LQHQFoBxXkJiZ6rLGEnEDmMP7ITUtZh2DrPY8pMkXYs5Yl07+5ZKKJyKaVzDUSO8XXhW
         BXZL5SWdfXARn7lELkB8Vbe5Xh2/OC1F8cTg4Zr6WwtzATeApHKmIGr/gYlkyDaFL/Om
         djpDlUmsxK1DHNEWWOPDVXxJQHRWUqh92i67b6BuBXv41qmyxwTHS/vvhss/Sws0XaBd
         LNLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=GsCy44wdMFCuadHqTui9YjzW4+OMVccBA+mChcrb/98=;
        b=vB+q+mkoDW7bDhf1Z7MLEHNjoK+Q/3S1wq4bmA3DqVLmlO4kDD4A3mqVEbZa/oSmxf
         y9TR0Mp5NdsCdDCoUeP0y4pGl/lPjkIfxsa5lEbG7bUiBy4j0TBidBm7E0OioNx6Dp20
         mvSPYSbQ1qfRSbpk5FJIDufmCB3yhOwT3K91ZgW6+TXlFByczv2PXJox/PSKTB5nHXSd
         aMrKRHupjjo1MsMLMb9LvoZAvq9GlC8BYyqtGA4DVaQU90/hV6t0tPCsZj3VHGkuw9TQ
         hvEjN4aln+YijN3lR9geqNKC/lHIaT2bfbvXJRugT+1bms3XCbr0EJS3qf8k4wT3OawB
         8mQA==
X-Gm-Message-State: ACgBeo3WildfyobAjL535nJqN95/Uf4akbcR+KpsrDMdSpm815iwZj5G
        PokpeBVWVcmZVPbG8w94QAXfxceVfXM=
X-Google-Smtp-Source: AA6agR73no8X9eobVcqNctMZ+sdDEIW9B21Vd0Vq8kOFtAZmOAvEEEyC3ozNdkaZqyVZl2HCMAKXlw==
X-Received: by 2002:a17:906:2245:b0:715:7c81:e39d with SMTP id 5-20020a170906224500b007157c81e39dmr37652225ejr.262.1662391152417;
        Mon, 05 Sep 2022 08:19:12 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:a118])
        by smtp.gmail.com with ESMTPSA id j2-20020a17090623e200b0072b33e91f96sm5262018ejg.190.2022.09.05.08.19.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Sep 2022 08:19:12 -0700 (PDT)
Message-ID: <c625ed9d-07b4-65c6-f318-a5233e0b667e@gmail.com>
Date:   Mon, 5 Sep 2022 16:17:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH liburing 4/4] tests/zc: name buffer flavours
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Cc:     "axboe@kernel.dk" <axboe@kernel.dk>
References: <cover.1662387423.git.asml.silence@gmail.com>
 <f4ceecede6399ba722c8e73312e0e0755f53a8a6.1662387423.git.asml.silence@gmail.com>
 <87e297ef0a2bef869c890bda92c0a07fee171f43.camel@fb.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <87e297ef0a2bef869c890bda92c0a07fee171f43.camel@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/5/22 16:00, Dylan Yudaken wrote:
> On Mon, 2022-09-05 at 15:21 +0100, Pavel Begunkov wrote:
>> Remove duplicating tests and pass a buf index instead of dozens of
>> flags to specify the buffer we want to use.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   test/send-zerocopy.c | 60 +++++++++++++++++++++++-------------------
>> --
>>   1 file changed, 32 insertions(+), 28 deletions(-)
>>
>> diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
>> index bfe4cf7..2efbcf9 100644
>> --- a/test/send-zerocopy.c
>> +++ b/test/send-zerocopy.c
>> @@ -51,8 +51,16 @@
>>          #define ARRAY_SIZE(a) (sizeof(a)/sizeof((a)[0]))
>>   #endif
>>   
>> +enum {
>> +       BUF_T_NORMAL,
>> +       BUF_T_SMALL,
>> +       BUF_T_NONALIGNED,
>> +       BUF_T_LARGE,
>> +       __BUT_T_MAX,
> 
> __BUF_T_MAX?

eh, should've been. I think I'll just kill it in a resend.

-- 
Pavel Begunkov
