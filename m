Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1CB50A898
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 20:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243292AbiDUTBS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 15:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233912AbiDUTBS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 15:01:18 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 832A62194
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 11:58:27 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id k22so7957912wrd.2
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 11:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=H4pL+I5sUavH4fjQAiYnlBpPp9Hp0v8kzHZPGTPV+h8=;
        b=TsQY/JyXiDP5kx3pDMUPayLBrV0R6AYr8f5zeKKwJxegyLkHCL6ulBm3NuVZ9gmheP
         7C4D2tQxybwxUTBjiCE1EH8MlFrKL/1gxsS1JPpchQO0NlOGmUfskvmSGySZlBZ6XgTP
         JvlRVW6Sp8C0dEMV8ty+TCscoO3HkZjX/XajRQnrw6XM9fPZXDF374AnrzEPVccr3t25
         QFi5Xrx1kjFUnTmgK2HM/RBEQqwM9i571TXEUpTSorcO7/u4JTKsPe2xQnJUzNftokKV
         pNJlN7DEEsgfPtiasL+NnJi+q9M8ws+LPBjH9rjkKZEI6ewKy/95H+57Dz8LwXZ3TqD3
         oZcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=H4pL+I5sUavH4fjQAiYnlBpPp9Hp0v8kzHZPGTPV+h8=;
        b=HuxcBWVbJgIonAdxVe35RBG52cGX1NS8CD74NiOzUoNsZE6SsB2xN58DdNltHxsWlQ
         pkWLMBhmqDRj+pbfbDvEbUE9+EQD3b34E91cx3jcsRCNBAToOiRSwxPDkm5mul3tw/UN
         AzJsKL8dAO4tocYNdsDlgvzJj5DjWBk1bKtknZeJla9I6/51g2WLht1LG7/FgJ3vKsdF
         o/9sJar1NFK1Rd5gF7G4ug/Oy0p5Y6MUqtoA2Ui7ejDk0Y35UxZW/5GVdkGxIyLNcC96
         stykOWVltEbI7r4t8N1tBCIM179M+F9mIhf0VRUpDLVZm2EiHiYbmPWmHYzPmXSR9Xyj
         n30A==
X-Gm-Message-State: AOAM532+M07rEtbFkPpzdWaEMGOoPN0Z2MnAkYZRAP37yjQ8pwZ9A5iR
        sAH/cgmO8EN/+aQuyv88sDf3wGqUYnw=
X-Google-Smtp-Source: ABdhPJyUoqpPBE2s+Q98WVY6+r0kOIUgp2581hxP0G4xKIsy1VZZ/UBKEG98ooR44x1aOpRLdVCmyQ==
X-Received: by 2002:a5d:5603:0:b0:207:b0f4:6b07 with SMTP id l3-20020a5d5603000000b00207b0f46b07mr772169wrv.283.1650567506032;
        Thu, 21 Apr 2022 11:58:26 -0700 (PDT)
Received: from [192.168.8.198] ([148.252.129.201])
        by smtp.gmail.com with ESMTPSA id m7-20020adfe0c7000000b002060e7bbe49sm3487216wri.45.2022.04.21.11.58.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Apr 2022 11:58:25 -0700 (PDT)
Message-ID: <5008091b-c0c7-548b-bfd4-af33870b8886@gmail.com>
Date:   Thu, 21 Apr 2022 19:57:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2 00/12] add large CQE support for io-uring
Content-Language: en-US
To:     Stefan Roesch <shr@fb.com>, Jens Axboe <axboe@kernel.dk>,
        kernel-team@fb.com, io-uring@vger.kernel.org
References: <20220420191451.2904439-1-shr@fb.com>
 <165049508483.559887.15785156729960849643.b4-ty@kernel.dk>
 <5676b135-b159-02c3-21f8-9bf25bd4e2c9@gmail.com>
 <2fa5238c-6617-5053-7661-f2c1a6d70356@fb.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <2fa5238c-6617-5053-7661-f2c1a6d70356@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/21/22 19:49, Stefan Roesch wrote:
> On 4/21/22 11:42 AM, Pavel Begunkov wrote:
>> On 4/20/22 23:51, Jens Axboe wrote:
>>> On Wed, 20 Apr 2022 12:14:39 -0700, Stefan Roesch wrote:
>>>> This adds the large CQE support for io-uring. Large CQE's are 16 bytes longer.
>>>> To support the longer CQE's the allocation part is changed and when the CQE is
>>>> accessed.
>>>>
>>>> The allocation of the large CQE's is twice as big, so the allocation size is
>>>> doubled. The ring size calculation needs to take this into account.
>>
>> I'm missing something here, do we have a user for it apart
>> from no-op requests?
>>
> 
> Pavel, what started this work is the patch series "io_uring passthru over nvme" from samsung.
> (https://lore.kernel.org/io-uring/20220308152105.309618-1-joshi.k@samsung.com/)
> 
> They will use the large SQE and CQE support.

I see, thanks for clarifying. I saw it used in passthrough
patches, but it only got me more confused why it's applied
aforehand separately from the io_uring-cmd and passthrough


>>> Applied, thanks!
>>>
>>> [01/12] io_uring: support CQE32 in io_uring_cqe
>>>           commit: be428af6b204c2b366dd8b838bea87d1d4d9f2bd
>>> [02/12] io_uring: wire up inline completion path for CQE32
>>>           commit: 8fc4fbc38db6538056498c88f606f958fbb24bfd
>>> [03/12] io_uring: change ring size calculation for CQE32
>>>           commit: d09d3b8f2986899ff8f535c91d95c137b03595ec
>>> [04/12] io_uring: add CQE32 setup processing
>>>           commit: a81124f0283879a7c5e77c0def9c725e84e79cb1
>>> [05/12] io_uring: add CQE32 completion processing
>>>           commit: c7050dfe60c484f9084e57c2b1c88b8ab1f8a06d
>>> [06/12] io_uring: modify io_get_cqe for CQE32
>>>           commit: f23855c3511dffa54069c9a0ed513b79bec39938
>>> [07/12] io_uring: flush completions for CQE32
>>>           commit: 8a5be11b11449a412ef89c46a05e9bbeeab6652d
>>> [08/12] io_uring: overflow processing for CQE32
>>>           commit: 2f1bbef557e9b174361ecd2f7c59b683bbca4464
>>> [09/12] io_uring: add tracing for additional CQE32 fields
>>>           commit: b4df41b44f8f358f86533148aa0e56b27bca47d6
>>> [10/12] io_uring: support CQE32 in /proc info
>>>           commit: 9d1b8d722dc06b9ab96db6e2bb967187c6185727
>>> [11/12] io_uring: enable CQE32
>>>           commit: cae6c1bdf9704dee2d3c7803c36ef73ada19e238
>>> [12/12] io_uring: support CQE32 for nop operation
>>>           commit: 460527265a0a6aa5107a7e4e4640f8d4b2088455
>>>
>>> Best regards,
>>

-- 
Pavel Begunkov
