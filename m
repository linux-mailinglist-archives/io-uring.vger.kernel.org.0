Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6A4B25EB98
	for <lists+io-uring@lfdr.de>; Sun,  6 Sep 2020 00:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728824AbgIEWwE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 5 Sep 2020 18:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728589AbgIEWv7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 5 Sep 2020 18:51:59 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75641C061244
        for <io-uring@vger.kernel.org>; Sat,  5 Sep 2020 15:51:58 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id a8so2781988plm.2
        for <io-uring@vger.kernel.org>; Sat, 05 Sep 2020 15:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=UOByyKYhol00Aqzb8nr0B2ztGFXNVONglKMH3m1ZPO8=;
        b=qPvZRdW4VxYYBPA/C/nj8eIxzQvm69Rl7WNweLUQwyLETIuQFQPNA5szhMGvGY6lP3
         aM6wuWB+d1GFtZv30UUFbOE5WAR4Ek8uba1BtUyRd3ya7YkmgVNu0ewu6+MhsX6rqnGW
         LJLCH87RC+ZCKpW+KnSAQgx82VT9warM/gyioXA9cr6xrjwGiqXRiBnBgTiE/abSZxFj
         GPUg616Zt64/pAEWOgoJrFQPZnfpodUQ6iHmjhYaN2yxzEhFvzFHnCatmis7tVqeu/p5
         PoJ/9Mr1eJc01WzoQWV61T8D/ULzgPbkk8+M1jeyHjNSsuGOM1L84BvYEW2ibLB39Qz+
         P37A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UOByyKYhol00Aqzb8nr0B2ztGFXNVONglKMH3m1ZPO8=;
        b=FrMvmOge3dML9twXZuzpPq2yfakAo5K2av2YxkEJnYl9TZHnZr7MjOcIxQ1PMEUaRV
         TPPdOLU79Q101YJOMmZV2AsFWpvKuO0WPAPnzJKp0Cezt7/h0Tb9AXFByWvg2IMY61rC
         hvkg9ww3BjidtdBMPwzStgHNnSdSRNeXsZY6pXfqXrfE+8Ipi1tX8jXq8JXewH4FEpd8
         HqaJqWyE5K/cwDLRQ6APahQUOPOXQBqF/S7BOk/RKZAsgzRHYCmcgigehMa3VAh9EReE
         ZLCBrRT2Fi/E8DdMSymYD6qctcAKS+LZPFZbbfubIZOKNmA0Q0UHrC3SFsxc+gdDbWfw
         4+0Q==
X-Gm-Message-State: AOAM530ZUyf1XcRdY7xn9N3HCps3eMX4oJhAmWBhIOlD8yuTJl2p7Y6X
        wb0Gz9t5bOjHbSmIqtGrZfgb8J5R2rhu0HX2
X-Google-Smtp-Source: ABdhPJx42Y57tf4P+OBMGxw0yAGSj0Ro+TxqJ7DcrqfV3HBwGyY+XbRskIAHTCMjIVQqRiF35u/GiQ==
X-Received: by 2002:a17:902:b081:: with SMTP id p1mr13979588plr.195.1599346317705;
        Sat, 05 Sep 2020 15:51:57 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id p184sm10675920pfb.47.2020.09.05.15.51.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Sep 2020 15:51:57 -0700 (PDT)
Subject: Re: [PATCH 0/4] iov remapping hardening
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1599341028.git.asml.silence@gmail.com>
 <8381061c-e2e8-6550-9537-2d3f7a759e92@kernel.dk>
 <4140076d-9aa6-ffb8-81a1-f8c1820ebfd2@gmail.com>
 <2203dd86-b639-9978-11e2-4c3c7282f048@kernel.dk>
Message-ID: <9b5fad4a-e4c7-f384-5842-793c7ee9770e@kernel.dk>
Date:   Sat, 5 Sep 2020 16:51:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2203dd86-b639-9978-11e2-4c3c7282f048@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/5/20 4:34 PM, Jens Axboe wrote:
> On 9/5/20 4:15 PM, Pavel Begunkov wrote:
>> On 06/09/2020 00:58, Jens Axboe wrote:
>>> On 9/5/20 3:45 PM, Pavel Begunkov wrote:
>>>> This cleans bits around iov remapping. The patches were initially
>>>> for-5.9, but if you want it for 5.10 let me know, I'll rebase.
>>>
>>> Yeah let's aim these for 5.10 - look fine to me, but would rather avoid
>>> any extra churn if at all possible.
>>
>> These applies cleanly for-5.10/io_uring. It should conflict with
> 
> Great, I'll queue them up then.
> 
>> yours req->io shrinking patches, but it seems you haven't queued
>> them yet.
> 
> Which ones?

Ah yes, totally forgot to queue that... Doesn't matter with the conflicts,
some of the others caused an issue or two as well. I've queued it for
testing.

Thanks for the reminder :-)

-- 
Jens Axboe

