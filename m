Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2464E5960
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 20:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243573AbiCWTuz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Mar 2022 15:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241263AbiCWTuz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Mar 2022 15:50:55 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561008B6D1
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 12:49:24 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id c62so3141710edf.5
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 12:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=O2tnpJjPT2iGsNTpJAEYULXgRpbmBGbRFw2jgXzmuEw=;
        b=ICIl08OEWI3pskQqocFoRANuQDePuajdM+vvNFlfpX6ecsOH2E0CkcXmmLba45pj18
         ePggfCYyYlsDdnS/D3QOEugAcP50tILkzOqqUtb8Ewvjass6cEn6Rj3858dOEJje8dD+
         ngUepGOZPUKZAK6fBm2BzgZ0UKe/5c8GYj03oH4Yjf627x19mW+PBrJlxiSmiGx4+eGt
         GLkxa+vjGrhAH/yiQhpRB0vK4EVJJVaPK/KRBMXo9Da8r5y1+BflAaVL1N5ky6uoh2va
         R8+mWp1HfhMHEP/o6WhA0glvKBYjb/UMRMRsaUymftLdG0SgvuoBSVpv1+DD1rIHDTVY
         ViVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=O2tnpJjPT2iGsNTpJAEYULXgRpbmBGbRFw2jgXzmuEw=;
        b=VOZ4I1iVkdjHxqk5Z9SpwEy/RZEUZBqmvMwKwBbvP/XNc8MITERetEL2IWAryMUNw3
         N6UIHC0K6upqbANv8/WlMkosK17exsWTLRg5ly7zaIR5/0/2BRQw9Cekm2XohFa7ICRz
         bO5qFtDafjDDcCrYypCZ96cbMKq7mCD5fW3q+02bs+DHknvIoXJ93KaKWU4l2JoIqsT1
         yD5eO35XFFSQuiUbK636RHiifpe8AK9C150GXa5Q6cEP3fzTANbNwQ8ztoAAIaaZcxMa
         x802/4RLxf5ar7+VGgu1zuYRas0sEl2xsmuTF1gvIXGkHvAbH8GSvxyF4CTuYKZHm1Fj
         K37Q==
X-Gm-Message-State: AOAM531l2D7Vf/D/Ygkkgi8+yOhCbyn8KigllA6SH9YCgBFI8byw4eRe
        KH7TzWybKVqw2rULQRdbXN8=
X-Google-Smtp-Source: ABdhPJwT7q4Qv6QYRsPX3kGXFCOXVtZVYc3kByVa9eDOT5v/bl8LkxDZkR+PiH1x9KJkGe80gkFY3g==
X-Received: by 2002:aa7:cd81:0:b0:410:d64e:aa31 with SMTP id x1-20020aa7cd81000000b00410d64eaa31mr2295536edv.167.1648064962787;
        Wed, 23 Mar 2022 12:49:22 -0700 (PDT)
Received: from [192.168.1.114] ([85.105.239.232])
        by smtp.gmail.com with ESMTPSA id i11-20020a50fd0b000000b0041936bc0f7esm391449eds.52.2022.03.23.12.49.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Mar 2022 12:49:22 -0700 (PDT)
Message-ID: <a67eea3f-f500-1a9a-69d1-b63d02142141@gmail.com>
Date:   Wed, 23 Mar 2022 19:48:12 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH] io_uring: add overflow checks for poll refcounting
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Cc:     "axboe@kernel.dk" <axboe@kernel.dk>
References: <0727ecf93ec31776d7b9c3ed6a6a3bb1b9058cf9.1648033233.git.asml.silence@gmail.com>
 <4e8bcd464b1c97c4bab9e9802f5a6792e8f68229.camel@fb.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <4e8bcd464b1c97c4bab9e9802f5a6792e8f68229.camel@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/23/22 15:07, Dylan Yudaken wrote:
> On Wed, 2022-03-23 at 11:14 +0000, Pavel Begunkov wrote:
>>
> ...
>>   
>> -#define IO_POLL_CANCEL_FLAG    BIT(31)
>> -#define IO_POLL_REF_MASK       GENMASK(30, 0)
>> +/* keep the sign bit unused to improve overflow detection */
>> +#define IO_POLL_CANCEL_FLAG    BIT(30)
>> +#define IO_POLL_REF_MASK       GENMASK(29, 0)
>> +
>> +/* 2^16 is choosen arbitrary, would be funky to have more than that
>> */
>> +#define io_poll_ref_check_overflow(refs) ((unsigned int)refs >=
>> 65536u)
>> +#define io_poll_ref_check_underflow(refs) ((int)refs < 0)
>>   
> 
> I believe if the cancel flag is set, then this will not catch an
> underflow but the result will be the cancel flag unset. You could fix
> by also checking for overflow on the masked bits.

Good point. I'm thinking now about using bit(0) for IO_POLL_CANCEL_FLAG
and 1-31 for refs. We'd need to do +2 in io_poll_get_ownership() but
the sign logic should work w/o extra weirdness.

-- 
Pavel Begunkov
