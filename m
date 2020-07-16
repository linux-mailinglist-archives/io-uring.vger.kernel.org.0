Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFFCB222D8E
	for <lists+io-uring@lfdr.de>; Thu, 16 Jul 2020 23:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgGPVQo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jul 2020 17:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgGPVQn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jul 2020 17:16:43 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE50C061755
        for <io-uring@vger.kernel.org>; Thu, 16 Jul 2020 14:16:43 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id s10so8562040wrw.12
        for <io-uring@vger.kernel.org>; Thu, 16 Jul 2020 14:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FyqS69qh4L6ftFRbSa8qXvWSdHxJwEPd0DsocdpdZEU=;
        b=q3i244csWbJDyOxMbq5n1OExMzjoUC+saZJkHkKv5u4yILlzZQtZxHOxO20CwSm1SX
         7GpkxqTBYdpxeVuyms0+JT65C7yF4pc8JtLonqlzDbg/VcJkeg4wzyuxZUoB9odJ2zdA
         ZlVL8D4Q8meOpXuhTOmp8IOEXwklIriiV2//8Hp/V+GS/SonoGrGuKZOYG/KtpNKSGlO
         iHSyVFWJ1mWkn/ES7gUkkpT7IWgj4l/nLRVYUfjwUqpRFRC74wmLmdBIu3+6NyFHXlkz
         dOESnOLNoFG4sgV18sWhlKC5/Bb2giLM/wHV43Nob3pWt4YMjhmweJo+oh1BbitEz+p0
         ZNRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FyqS69qh4L6ftFRbSa8qXvWSdHxJwEPd0DsocdpdZEU=;
        b=puXmCnvodUu21vIjUZCHyNhAa4n5388p/9jXRLra79ClWJg+NYufkyEhCzhPHeopk+
         YSCTpN1GIKkGGXCrSEwuS8uAS6wHXQw1u12tyQIF+UqV/CC8pI2UZFQ2/Iz/FWbpOw9b
         dIYHk+TxWyAzSHFBE17ON3z3oJ9siZ36uz7Sye22jrDWhYsXZBLDbHx1NtBBCxtp97I/
         VN3pzIjYI5kdJXX/czCu0RjqG8egrsSV83zcd5UtIXR29M8WPt2VLiXaabj/7fzrUtdg
         +CsIw7VIc26tNmdazs5S3nOAzjMFOsx9MmGUmH0kZkEsQsLcovNzaKwrbpYyVrBSHqta
         eTtg==
X-Gm-Message-State: AOAM532gh00oUD8JaE9Cf5Pq4Ovk0FNIewJJ8fd6MjM3AMpByTzoCwRZ
        sIVl2Ra8gwXMu1Cd3oZinw/M724f
X-Google-Smtp-Source: ABdhPJxtqA22K3MUN34f90KKjPX+ySjgpwJgQukwDU4uQ4M3MwuA9XCaJ3xXqksHyPDt8VUvZuCQjw==
X-Received: by 2002:adf:f4d1:: with SMTP id h17mr6736988wrp.227.1594934201903;
        Thu, 16 Jul 2020 14:16:41 -0700 (PDT)
Received: from [192.168.43.238] ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id v7sm11201902wrp.45.2020.07.16.14.16.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2020 14:16:41 -0700 (PDT)
Subject: Re: [PATCH 5.9 0/7] recv/rw select-buffer fortifying
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1594930020.git.asml.silence@gmail.com>
 <9a2d155c-ddc9-8c7a-5f9f-87dcaab02693@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <a0e57122-6f67-c44c-1e37-fbecf295d86d@gmail.com>
Date:   Fri, 17 Jul 2020 00:14:55 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <9a2d155c-ddc9-8c7a-5f9f-87dcaab02693@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 17/07/2020 00:13, Jens Axboe wrote:
> On 7/16/20 2:27 PM, Pavel Begunkov wrote:
>> This series makes selected buffer managment more resilient to errors,
>> especially io_recv[msg](). Even though, it makes some small accidential
>> optimisations, I don't think performance difference will be observable
>> at the end.
> 
> I shuffled this a little bit, as it relies on both 5.9 and the leak
> fix from 5.8.
> 
> Also, some of your commit messages use really short lines, just use
> 72 consistently for all of them. Minor detail, just not sure why
> they are different. I fixed them up.

I'll double check the next time, thanks

-- 
Pavel Begunkov
