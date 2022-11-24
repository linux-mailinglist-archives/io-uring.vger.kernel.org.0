Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CEF3637F4D
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 19:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbiKXSrq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 13:47:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiKXSrX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 13:47:23 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B48434EC13
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 10:46:28 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id q71so2149694pgq.8
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 10:46:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cUaDUSHsxSUVHWe27VHElwDrs/W+sTP0yRGfF5T151k=;
        b=YPuyZltSbvUHWZqOyz1MT9Q85Dq+4Tj9tvj447pscgPzag5xNw9uXofzZlWAaI1oja
         4yrjF4/CL1uMs90RBaHLNrtMzvHAvKKxsARbZZkqetJnufmCN0PsE/gwfT1lvJvhzsQ0
         4hpIUvXFnPjQs5rqdRHGgYhmQzQIzyHtygDKeTXJsKN6Jd1Jy8k/Lg0j8xVC2uQI/i7Q
         oUDg+2xDx3KZynSvkyXBnpPrYktTHhoJsXfmxXmnHkCycaiD2bXxNyM79/kmX1y8ePtP
         UgW36pOzfBZYur+t4SN193EgCMo3ZNjGy7FBOUMUkuIwgZ1Mcq+uopmDq5GaaCO6y6hF
         l7Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cUaDUSHsxSUVHWe27VHElwDrs/W+sTP0yRGfF5T151k=;
        b=sWHU+SFV1lCWe8FOZ/3roaUEIL+mrQedgkIytPNSVrVox/XIcwdWHjPu9paIggxuBQ
         BiBA2g62+pIFpbb4P6HRWL0W8AI4wUJQrnUQohy3HWvP9VOQH9d/YXaUE6gmt67/I4Qf
         XagpdqgcXndZiOGT9yHIWfmcyc8pDyEAUfw39gBhmqqnnFKPaXhlOnGh2TJnM2oDVhe9
         9cr9Ep6CFbqGbNudcrygyAGTJwQIr8r3IF9OrDsajat+rged8fPJg3/dxjvkhjo7Fyx2
         c8aHw0k74/u3+JWbCvfeMiyHxnQXmzZfBe6uGATRtVXN8/TTTWUH2jPLi1pQkVAZL6cZ
         iiKQ==
X-Gm-Message-State: ANoB5plw4jQJJjBySS/jheYyKM8dUNXtbJbk12qgHMFHhxakU17jKjZu
        RvUEhRaJWflBel0U2Ma+eRBGSDMlLPcFIkZ3
X-Google-Smtp-Source: AA0mqf70m/jz/4Px4vPIkwGhfk6DIi0m6f4V0OhZagkAXASrMwly1lplzOPwVlLt6mUYtFL1Z3vCUA==
X-Received: by 2002:a65:560a:0:b0:477:382d:dd38 with SMTP id l10-20020a65560a000000b00477382ddd38mr13392899pgs.264.1669315588092;
        Thu, 24 Nov 2022 10:46:28 -0800 (PST)
Received: from [192.168.4.201] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id x22-20020a170902821600b0017f48a9e2d6sm1599224pln.292.2022.11.24.10.46.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Nov 2022 10:46:27 -0800 (PST)
Message-ID: <bd80da09-a433-1ea6-6a0c-bbb335b5187d@kernel.dk>
Date:   Thu, 24 Nov 2022 11:46:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] io_uring: kill io_cqring_ev_posted() and
 __io_cq_unlock_post()
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <c09446bd-faca-13cc-97af-c06fa324e798@kernel.dk>
 <c03977b8-85a1-5984-ebda-8a0c7d0087d2@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c03977b8-85a1-5984-ebda-8a0c7d0087d2@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/24/22 9:16?AM, Pavel Begunkov wrote:
> On 11/21/22 14:52, Jens Axboe wrote:
>> __io_cq_unlock_post() is identical to io_cq_unlock_post(), and
>> io_cqring_ev_posted() has a single caller so migth as well just inline
>> it there.
> 
> It was there for one purpose, to inline it in the hottest path,
> i.e. __io_submit_flush_completions(). I'll be reverting it back

The compiler is most certainly already doing that, in fact even
__io_submit_flush_completions() is inlined in
io_submit_flush_completions() for me here.

-- 
Jens Axboe
