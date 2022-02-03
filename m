Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9A764A8A71
	for <lists+io-uring@lfdr.de>; Thu,  3 Feb 2022 18:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353018AbiBCRmj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 12:42:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242399AbiBCRmj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 12:42:39 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7B9C061714
        for <io-uring@vger.kernel.org>; Thu,  3 Feb 2022 09:42:38 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id l12-20020a7bc34c000000b003467c58cbdfso7713556wmj.2
        for <io-uring@vger.kernel.org>; Thu, 03 Feb 2022 09:42:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EyQ3SSZvN2IJcNCZXWQlxMc6hz5l3B9sP2KWMPe8f/s=;
        b=3GuGRfzx9kqB0UG895aLOKeX7j+CTmBLbeVt0s8w+w/X80aOiW2i7baXC4AfBAFmQ4
         D1tB6azicXAzvwEvGlC3pKdbBid+AEajWmF6oEVbJi/pJkE4sYhdht9Ta7SvU0yawqFm
         1hF5EAKCqp3YSyJRG45WVNUJocEyFCK7q/KIFRj2cSQWvHJKSKnkUC7Afhpke/fNdScA
         3COCmazmdkM0bvLS5JI8jk+XNocl96M8UMiZDdYMXG/5WBxjpkuQq1HxgewwjJn9SVox
         nLAM+BxxYvOgKF+Jx+Qdr7Ev3sfDrF0C0cDF25/qLWGFb8/ETZf6US/BVw1PczOSrsE5
         B1fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EyQ3SSZvN2IJcNCZXWQlxMc6hz5l3B9sP2KWMPe8f/s=;
        b=gZMkEPXEzxYZi60Bv3IfWZKnavhmYI1I24xpUQ0zLbfL8m5bKq3HpPfDdzxxjMfyQj
         4EcoRvA9Kw1shSl/bb97Ut0e47AdzDk2Bj+Qkm4T/8+hJnz5MmD1S3Ij6uEIe0m0t+Vh
         dfjF+1JA9zu31A7hrlQ7MNOoyomT0NepmKq8P5u4uw0PKYu7jIXX40HS6HTk/5lyRQEI
         o91s/Tr0cy+LZZqrRyahpHUOc3BZG7PWIhEGFh+gd2AeyfBE0f1W5I5WhVVNI7Q8BiVy
         IQj3HfqVSGEJ73SVr2qxuKkg22ILd6PmFE2nSpvoBO1MhDiSiN0bHKwi8Ushyz/eU+0/
         CcKg==
X-Gm-Message-State: AOAM532eqf4HcXqbku0Nb0l/I0+DiukQ9QAjyq/TiGRMrzPhIBDIkt8l
        OvTiQwEjNXwnN7RGYxlmFaqIoA==
X-Google-Smtp-Source: ABdhPJyaLdjanXXFwYVTxWDdtkErYlNoQ4Fef9RB65qhOxqkbqONihRA2B0rm4QDzbvASTKnqAH4mw==
X-Received: by 2002:a05:600c:3229:: with SMTP id r41mr11396464wmp.181.1643910157535;
        Thu, 03 Feb 2022 09:42:37 -0800 (PST)
Received: from ?IPv6:2a02:6b6d:f804:0:28c2:5854:c832:e580? ([2a02:6b6d:f804:0:28c2:5854:c832:e580])
        by smtp.gmail.com with ESMTPSA id t5sm21575649wrw.92.2022.02.03.09.42.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 09:42:37 -0800 (PST)
Subject: Re: [External] Re: [PATCH 1/2] io_uring: avoid ring quiesce while
 registering/unregistering eventfd
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        asml.silence@gmail.com, linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com
References: <20220203151153.574032-1-usama.arif@bytedance.com>
 <20220203151153.574032-2-usama.arif@bytedance.com>
 <87fca94e-3378-edbb-a545-a6ed8319a118@kernel.dk>
 <62f59304-1a0e-1047-f474-94097cb8b13e@bytedance.com>
 <da09cb46-9d60-71a3-a758-46d082989bae@kernel.dk>
From:   Usama Arif <usama.arif@bytedance.com>
Message-ID: <b80ee8ae-2150-ac96-ccf5-0905f313751f@bytedance.com>
Date:   Thu, 3 Feb 2022 17:42:36 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <da09cb46-9d60-71a3-a758-46d082989bae@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 03/02/2022 16:58, Jens Axboe wrote:
> On 2/3/22 9:49 AM, Usama Arif wrote:
>>> One thing that both mine and your version suffers from is if someone
>>> does an eventfd unregister, and then immediately does an eventfd
>>> register. If the rcu grace period hasn't passed, we'll get -EBUSY on
>>> trying to do that, when I think the right behavior there would be to
>>> wait for the grace period to pass.
>>>
>>> I do think we need to handle that gracefully, spurious -EBUSY is
>>> impossible for an application to deal with.
>>
>> I don't think my version would suffer from this as its protected by
>> locks? The mutex_unlock on ev_fd_lock in unregister happens only after
>> the call_rcu. And the mutex is locked in io_eventfd_register at the
>> start, so wouldnt get the -EBUSY if there is a register immediately
>> after unregister?
> 
> The call_rcu() just registers it for getting the callback when the grace
> period has passed, it doesn't mean it's done by the time it returns.
> Hence there's definitely a window where you can enter
> io_uring_register() with the callback still being pending, and you'd get
> -EBUSY from that.
> 

Does using synchronize_rcu make sense? I have sent v3 with how that 
would look. I have kept cq_ev_fd under io_ev_fd as it will be useful in 
patch 3 when eventfd_async is added.

Thanks,
Usama
