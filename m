Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6982B47020F
	for <lists+io-uring@lfdr.de>; Fri, 10 Dec 2021 14:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236077AbhLJNum (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Dec 2021 08:50:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbhLJNul (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Dec 2021 08:50:41 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 935DAC061746
        for <io-uring@vger.kernel.org>; Fri, 10 Dec 2021 05:47:06 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so9472804pjc.4
        for <io-uring@vger.kernel.org>; Fri, 10 Dec 2021 05:47:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/XHNEFU4xNOPB2g5/JDHm28V6shvBN8CfNunFgwpivc=;
        b=It2Z24jJyy3jB0JduETsmmzz8PTMeWG/VcptIGSLuxbllZkfgvPB9qiD+Au7AIaGl8
         akmezun/ZTWWm/5+Tq9934jZZGGYMnRvcAt/GqZYXfepfSWfWJ5OQ07nHJKEzcyHYnoP
         +Wo9wqBeMV9TdG6gWosmR971HyLAjKBlqyRj2sqeyhRagah7vKFovE+xof6JU56UTrq/
         9/hN6ST5fLw3F/BduTX6Xz3jCrsIlLG6uoIuq+X2jS74FK4zD1Z1oIdB+g+0nMn7QIg3
         kVLB4KA4xkOsY38y3YJYI+dOAGKG4LU/767E3bO+pvZoBFv82mypRZsvqw+dEvafZKoN
         LzUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/XHNEFU4xNOPB2g5/JDHm28V6shvBN8CfNunFgwpivc=;
        b=TnZthcr2v0gFmJw8gA/UliHkmn0fOaNbt36LRIFtjeGBir55jDoV4F4Q4SsCuPtN9m
         y/AJjCsblHFGXaYlopRt0/r6odvKuGUxhNWSge0DMebUJINeMl0yXuiVrLgh6gtWlon8
         +0Q8SZDZDa3bOc1levK8XjUwOMnouxupPdZ2VkyePLzFYfrImoJYMIaKa9k6tg5Hl9WI
         Mvu2HJSKuHFykEH9gOKm46A/FhpRpWxp0tqXmtqV8qhpB1+GTz80lVP8ZXBDSHEghhxw
         s+Il5+mvo7su/A1ekZnerfKek6S1m3LHFVV/LWu04etZdBWJ9YAOgU6cuHYt7knJ67M9
         edYg==
X-Gm-Message-State: AOAM530kuiYCwmv0JPt5TkQHz3XFwpHnOS/tT/beva/i2S8oBApY97tl
        tMc8QyLAU7HTReQzER3O0SEuBQ==
X-Google-Smtp-Source: ABdhPJyYnDvY0bYSPGruH7X/OafeDlCTlVwZKCGrzc7iK/3gHpT38apJuzWBsk7vv4UUvgpdUs/QSQ==
X-Received: by 2002:a17:902:a605:b0:143:d289:f3fb with SMTP id u5-20020a170902a60500b00143d289f3fbmr75872436plq.41.1639144026036;
        Fri, 10 Dec 2021 05:47:06 -0800 (PST)
Received: from [172.20.4.26] ([66.185.175.30])
        by smtp.gmail.com with ESMTPSA id p49sm3246530pfw.43.2021.12.10.05.47.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 05:47:05 -0800 (PST)
Subject: Re: [PATCH 1/2] io_uring: check tctx->in_idle when decrementing
 inflight_tracked
To:     Hao Xu <haoxu@linux.alibaba.com>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20211209155956.383317-1-axboe@kernel.dk>
 <20211209155956.383317-2-axboe@kernel.dk>
 <2c527587-36c4-900b-bda6-1357d9bb5ba0@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e93fe3ce-e690-3118-62a3-aeec3bfaadee@kernel.dk>
Date:   Fri, 10 Dec 2021 06:47:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2c527587-36c4-900b-bda6-1357d9bb5ba0@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/10/21 12:21 AM, Hao Xu wrote:
> 
> 在 2021/12/9 下午11:59, Jens Axboe 写道:
>> If we have someone potentially waiting for tracked requests to finish,
>> ensure that we check in_idle and wake them up appropriately.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
> 
> Hi Jens,
> 
> I saw every/several( in batching cases)  io_clean_op() followed by an 
> io_put_task() which does the same thing
> 
> as this patch, so it seems this one is not neccessary? Correct me if I'm 
> wrong since I haven't touch this code for

Hard to deduce as it also depends on whether it's the task itself or not.
Making it explicit is better imho.

-- 
Jens Axboe

