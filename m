Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8997754C85F
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 14:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348459AbiFOMWK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 08:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348025AbiFOMWJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 08:22:09 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A55137BCF
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 05:22:07 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id o8so15147880wro.3
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 05:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=lKFq4vYgxETvQ20GmJsl/ejxfj3m5+IqJ0/nkUPSukI=;
        b=UMnW/7Yt/QcUtG1AxmjRHOwQPfBiZSwvLtZdNIIO6lMhbUzmvgfNRCwUrh36QDyL97
         isdFK6U6phHLEgVnQ7fmhcvOBQyP4BZBILkI28nAdxLP8nswlNHC7idvLDEHSejXwSOE
         7hbkrjtxBid7wrufee3sw6lc+AIP9hTVP/McKa2TjvIGBJqG2p/HEV1Zea016D2mkF2g
         JZ+mEV3pcaRfIp4F3xpFLdDIQeabQW6fi3o/SRETO5x8OY+ORwtnYDwJpREkuaY/WZE/
         +Uu3nmww+fJtG0VeaWuvMh1YExMMpHcV8HmApP2fUkKAyXrfvUH2HmBC4qLbzp7NRX2g
         lSyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lKFq4vYgxETvQ20GmJsl/ejxfj3m5+IqJ0/nkUPSukI=;
        b=rj0w4oClYSlDaVjLRoUuWZMXWB2BSNQY3ONiDbrtBnckEKZRdugeE4f4KOF7cNCgj2
         lepWYN9INr7MbR12i2bTaMsEGXyjzyU3TZsJVD8qGp1gs5v7Rx4FeUOEzpiKP/uH9Uyo
         6HaromSOOq4/hTdVW1jIavA+5EXYp7UgnxJoi9XZ+I52XnmC3BxREK9zLfqrH4wv1b4P
         BsoWnNlRUfxJyNrs/nozV4DtFP6JvSircqeysOZWq5qgo+k7D3Q6EfHx5jRFt5lYZpDs
         ljjXMt0MMYXNFOQmDZ5cXo5ZUQfLB0owfwVbFjvqR7e7SAF1G2QO3EZjxkDX61AlAOm/
         EsMw==
X-Gm-Message-State: AJIora8X4+zT31zBDLYeIi7GVHZ0yjkkK41p+MhSMrYBaovE7YPU2DqB
        iRvNb3DqnBjNK+V4M8SnNbt0xZ36xzj/fA==
X-Google-Smtp-Source: AGRyM1v/1Uxv89ZnQD+PdL9wEdqkHsTh+eSZeYOmQmDY/mujaPa4erTNuFRKsTLFoKbbF03o8z0vew==
X-Received: by 2002:a5d:4310:0:b0:21a:26a5:69b with SMTP id h16-20020a5d4310000000b0021a26a5069bmr4286190wrq.269.1655295725766;
        Wed, 15 Jun 2022 05:22:05 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id v188-20020a1cacc5000000b003973c54bd69sm2330593wme.1.2022.06.15.05.22.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jun 2022 05:22:05 -0700 (PDT)
Message-ID: <b708b629-7d1e-441a-0cf8-395433291e32@gmail.com>
Date:   Wed, 15 Jun 2022 13:21:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.19 0/6] CQE32 fixes
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1655287457.git.asml.silence@gmail.com>
 <52279d69-ee83-c6d4-cf02-7384bf758a9a@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <52279d69-ee83-c6d4-cf02-7384bf758a9a@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/15/22 13:03, Jens Axboe wrote:
> On 6/15/22 4:23 AM, Pavel Begunkov wrote:
>> Several fixes for IORING_SETUP_CQE32
>>
>> Pavel Begunkov (6):
>>    io_uring: get rid of __io_fill_cqe{32}_req()
>>    io_uring: unite fill_cqe and the 32B version
>>    io_uring: fill extra big cqe fields from req
>>    io_uring: fix ->extra{1,2} misuse
>>    io_uring: inline __io_fill_cqe()
>>    io_uring: make io_fill_cqe_aux to honour CQE32
>>
>>   fs/io_uring.c | 209 +++++++++++++++++++-------------------------------
>>   1 file changed, 77 insertions(+), 132 deletions(-)
> 
> Looks good to me, thanks a lot for doing this work. One minor thing that
> I'd like to change, but can wait until 5.20, is the completion spots
> where we pass in both ctx and req. Would be cleaner just to pass in req,
> and 2 out of 3 spots always do (req->ctx, req) anyway.

That's because __io_submit_flush_completions() should already have
ctx in a register and we care about its performance. We can add
a helper if that's an eyesore.

-- 
Pavel Begunkov
