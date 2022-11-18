Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0738630044
	for <lists+io-uring@lfdr.de>; Fri, 18 Nov 2022 23:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbiKRWnr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Nov 2022 17:43:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiKRWnp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Nov 2022 17:43:45 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8F677217
        for <io-uring@vger.kernel.org>; Fri, 18 Nov 2022 14:43:44 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id v17so5803977plo.1
        for <io-uring@vger.kernel.org>; Fri, 18 Nov 2022 14:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d/SWj9x7UKPTMfT/d3rLbnuCZWOnRGfyr//T+uQzGu0=;
        b=aN+Q7a5VOFB47JdEZYbC6008Orcv5QlRBsVIdBxoZhHxVRgejezynEukvYU4wqteNv
         M1uhB/oeGGzGiJ0b57JUnQHn2xycsh9rdDuhrYG/EZl9zmaAsa8tkQcTzWz/b4Ek/h0H
         c7lFrLAcyPbwstK6JXIcz9ANMqbnrh0oaNr6R2FAjh+ylgR+VhpH2C7xB1Ulg3gYTJe4
         Yq7vb295a1ZPLT+Ubwr5Q2VuGqCO9UEwDAH8kDORtYLvTR1Rr7KkNA8sltp02HtCy73w
         KyP0jsLN92UKzrKiaCZLoaDMsfOEpGZthMa1zQa1IBECi3n7JEqgX1v4LOmGnvcl+Syr
         S8tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d/SWj9x7UKPTMfT/d3rLbnuCZWOnRGfyr//T+uQzGu0=;
        b=BuiwwANEgaA/uKWRg4dhzx4p6rZbaU9yd0RFiQMD9JGcBow+eyAT48Qyu6R8dmmpt2
         HMcywAx0jh6qK+b6XWwpeGf+F5mJcszJpDrWPAW0GTdl9g1Wg0GolfH79EBx7x+0iPo3
         7zcEP1GaBs99w9Y1K0voVvwYBOEXq9YGdjHwcfP+PHhtdDpmLjg64yl8W9vIlxSaRIyZ
         Wf9pulbl08An4K/DfXKITxm3SOvtpBsjGo+sgSq9djsHSOD9x+p2jWTeNPUt/GyufF9y
         T/LXFC/xnyVJtv+jlQzSFM02vUV0MLxMRaaYIlNhjZU9QfX8SsjCWBtjjrRsepCEZ4tf
         jiFw==
X-Gm-Message-State: ANoB5pkTbwi3uz4QIHl/WFUpypak+cIoDLTypWvx/7mB51fG+6Sxisci
        N9JVCQo1hFDbide9T5tYsCiKq8xi6LM6kg==
X-Google-Smtp-Source: AA0mqf6my10EfnFU3t6Go9445u1IUAzKtVo45KGrm14oMHoB+apvG6NRrUu9KJvXshhp85PXTB+DWw==
X-Received: by 2002:a17:90a:8d13:b0:213:c15:6f08 with SMTP id c19-20020a17090a8d1300b002130c156f08mr9677331pjo.134.1668811424120;
        Fri, 18 Nov 2022 14:43:44 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a13-20020a65640d000000b0043b565cb57csm2065516pgv.73.2022.11.18.14.43.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Nov 2022 14:43:43 -0800 (PST)
Message-ID: <0ceb5339-c84e-dbe4-2a69-9c1bc92c7221@kernel.dk>
Date:   Fri, 18 Nov 2022 15:43:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH for-6.1 v2] io_uring: make poll refs more robust
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Lin Horse <kylin.formalin@gmail.com>
References: <394b02d5ebf9d3f8ec0428bb512e6a8cd4a69d0f.1668802389.git.asml.silence@gmail.com>
 <f95c8321-3f64-4a34-7fdd-343e4a6718d3@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <f95c8321-3f64-4a34-7fdd-343e4a6718d3@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/18/22 3:39 PM, Pavel Begunkov wrote:
> On 11/18/22 20:20, Pavel Begunkov wrote:
>> poll_refs carry two functions, the first is ownership over the request.
>> The second is notifying the io_poll_check_events() that there was an
>> event but wake up couldn't grab the ownership, so io_poll_check_events()
>> should retry.
>>
>> We want to make poll_refs more robust against overflows. Instead of
>> always incrementing it, which covers two purposes with one atomic, check
>> if poll_refs is large and if so set a retry flag without attempts to
>> grab ownership. The gap between the bias check and following atomics may
>> seem racy, but we don't need it to be strict. Moreover there might only
>> be maximum 4 parallel updates: by the first and the second poll entries,
>> __io_arm_poll_handler() and cancellation. From those four, only poll wake
>> ups may be executed multiple times, but they're protected by a spin.
>>
>> Cc: stable@vger.kernel.org
>> Reported-by: Lin Horse <kylin.formalin@gmail.com>
>> Fixes: aa43477b04025 ("io_uring: poll rework")
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
> [...]
>> @@ -590,7 +624,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
>>            * locked, kick it off for them.
>>            */
>>           v = atomic_dec_return(&req->poll_refs);
>> -        if (unlikely(v & IO_POLL_REF_MASK))
>> +        if (unlikely(v & IO_POLL_RETRY_MASK))
> 
> Still no good, this chunk is about ownership and so should use
> IO_POLL_REF_MASK as before. Jens, please drop the patch, needs
> more testing

Bummed - I dropped it for now.

-- 
Jens Axboe


