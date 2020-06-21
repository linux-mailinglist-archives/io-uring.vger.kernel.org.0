Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2682A202C82
	for <lists+io-uring@lfdr.de>; Sun, 21 Jun 2020 21:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730551AbgFUTzv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Jun 2020 15:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730288AbgFUTzu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Jun 2020 15:55:50 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51BE1C061794
        for <io-uring@vger.kernel.org>; Sun, 21 Jun 2020 12:55:50 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id w6so4482958ejq.6
        for <io-uring@vger.kernel.org>; Sun, 21 Jun 2020 12:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LyazIHXQw0htcJung7QL4RtbQl9kP9xDf3yVPMII3Ds=;
        b=o24a57UeYnCv4zo7lMjY92KMPPT2cIQSjINaJT9+auNzVRNgTKZtyf9CVZLZmKvhh9
         cz8zKT4NFOKtTtiHI42JtsUpssdK2gS6hpetziK8KppJMF5cmP8gfbiOAnAUA/gcFy6u
         LAFmlhVzGeFnZ8eTS6W0lrJcbJ2U2QsVYi9CrIv1XTeNTAeWp/xg1zqQvsO5h+3XfdKp
         Nrw4wKH75lQmz0OurAZ0odirDUHaUwASehflLDLJJbFuIUKC9n5u6sjl5UTlneRMoUn8
         431GfQ2/9ttsXwEGnc1+gGbqzKI6MyUVdROAFm4KIDgRvepCRIzwXzKWw6qk77kUpW6R
         7ULQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LyazIHXQw0htcJung7QL4RtbQl9kP9xDf3yVPMII3Ds=;
        b=WAi3rzEas6SWDEpWb5C+yGBiBx/OoStjSENi0Ko7ZAQ5VWfC/juOWPO0JP28+x56+T
         bjGOz43puV3rXkSqaXzvKWsDLfacK71yjtp9RDfRwexBgWJwhua6aOm22HPmTH3nEIwu
         GxrzSEor+CkTk5lhOSNoPbyreSLhyaVMWlPZvMoWlEzgj4XnEsvi+0+ZaxPnPx7OhF6p
         RNhT/r+g7CrCVLLrGKYotDcksAEpQ6UAbZMc0gZqGRSaiYSrwH/70BLGFTXgwLdsMNpv
         R6eWIzxeUpmbuWTlpj9yuU+bAe4/a0slEoNlOmLvFwhrKninyV47DVDoJ2ibdW7zEfpo
         R+4Q==
X-Gm-Message-State: AOAM533pouTM/guOoKEwN0DoDIAoikjrjOH2OVVup71VoanyCAB2k2iJ
        c9t1/ITy9N3znKsHbk4CAtWxi4mC
X-Google-Smtp-Source: ABdhPJyYUJOdTUnWrS2AnJt+5UgNzYXSrS+3e2UG1Ndoqn+NeKI3Mqvv7O2F8S/kD3x2O3Sc1c/VWQ==
X-Received: by 2002:a17:906:4b54:: with SMTP id j20mr8484156ejv.259.1592769348688;
        Sun, 21 Jun 2020 12:55:48 -0700 (PDT)
Received: from [192.168.43.206] ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id k23sm10056237ejo.120.2020.06.21.12.55.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Jun 2020 12:55:48 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1592755912.git.asml.silence@gmail.com>
 <9c8d6bdd-ff6a-5044-1a5c-c0152f291dc4@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v2 0/2] Fix hang in io_uring_get_cqe() with iopoll
Message-ID: <87153777-5129-0835-ab29-b33a7d0f04ab@gmail.com>
Date:   Sun, 21 Jun 2020 22:54:18 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <9c8d6bdd-ff6a-5044-1a5c-c0152f291dc4@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 21/06/2020 21:48, Jens Axboe wrote:
> On 6/21/20 10:14 AM, Pavel Begunkov wrote:
>> v2: use relaxed load
>>     fix errata
>>
>> Pavel Begunkov (2):
>>   barriers: add load relaxed
>>   Fix hang in io_uring_get_cqe() with iopoll
>>
>>  src/include/liburing/barrier.h |  4 ++++
>>  src/queue.c                    | 16 +++++++++++++++-
>>  2 files changed, 19 insertions(+), 1 deletion(-)
> 
> After checking again, I think your liburing is quite a bit out-of-date.

It is. Apparently I checked out something old, my apologies.

> Can you check if the issue still exists in the current git tree?

This one is plumbed, though from a glance there is a similar problem
with non-iopoll mode and early wake by a timeout, rendering it to
idle-loop instead of sleeping. I'll leave it for a bit later.

-- 
Pavel Begunkov
