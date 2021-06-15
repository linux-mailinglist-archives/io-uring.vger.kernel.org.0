Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 822483A7D25
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 13:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbhFOLdQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Jun 2021 07:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbhFOLdQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Jun 2021 07:33:16 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F028C061574;
        Tue, 15 Jun 2021 04:31:10 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id l7-20020a05600c1d07b02901b0e2ebd6deso1809903wms.1;
        Tue, 15 Jun 2021 04:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N1C/J3aRjbR/ZolRyFAIhx68qQRVAv2EFJL1ksmo1x0=;
        b=cZ60D6g21RlohcFiobSLcexKCU+uwv8zDOE1l5oU8amRkj31lBzmFNtjSGq7YNguL1
         WJGyqewIa/wOzS7cw1kaMOyt0El0LlzA9HHJl78VOkz2Q8256OJUpNYWjBmKZvrzqx6B
         xqyqtlq0Ketop4YId9SMJFFvoWUH9B2R9dqc6K6qB/vMZ2VNDxJvIhis822Bp98FGep3
         /vaIN+ptRPy8u7vdNijcRGWs+Dg18FtFzUWX+UwdpcWoanorh/Rw0BKrycS2BDKRwHzH
         uP8wLXMyolcSdmdTmlweJ3mabsSx5l8cNa8yP0SBWxVPZlBliMxpc+DjdjociJ9NE08d
         1WFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N1C/J3aRjbR/ZolRyFAIhx68qQRVAv2EFJL1ksmo1x0=;
        b=FrYk6LutYOo25o5RCCL6mMfNTDhxgR6n70WufQhESU9pFK7Jj/sU5oqagn32RW3+Z/
         u88MciQD/cGKkbvgJjV3UEX9+qElNr4y6hD1sHwblN+TnTWVJUa68gB9llW4YVQqY5Jl
         MCceTFqYgp5nkKipZmKtuYfW1RsgKKweBMH1Fkt6cm3jCuMg1m+kIuGXe161x2FeIdN/
         EFZlnAtknwNu0owNNqHgNATFSRzCt3bPousz3tWjopf/8Bw4oq8eryx6NSvL4VuHQCOm
         fO/45dFr38bT3hjjwXI8CgptlDW3C5VPxjXZ9rN8tBnrw+51WBci3MIrTJhCah1VIr21
         L00A==
X-Gm-Message-State: AOAM530/Om1efdCQwAxtgo8drJHagnB3NjmVYJaqK9Ymr9W4mJ135Fyf
        FEl7rjcMNjqziaYBP9sJOoBOJ/zeavKsEkQe
X-Google-Smtp-Source: ABdhPJz2HPjmj8XQJmXAcfbdJgy/s2ksVMuide9fKmth82w3JMPhzNDQTlY1WVzGgJ/nk5dT3AlSMA==
X-Received: by 2002:a05:600c:1c28:: with SMTP id j40mr4737011wms.102.1623756668803;
        Tue, 15 Jun 2021 04:31:08 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.209])
        by smtp.gmail.com with ESMTPSA id l5sm1902320wmi.46.2021.06.15.04.31.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 04:31:07 -0700 (PDT)
Subject: Re: [PATCH][next] io_uring: Fix incorrect sizeof operator for
 copy_from_user call
To:     Colin Ian King <colin.king@canonical.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210615104541.50529-1-colin.king@canonical.com>
 <3dcc6900-8361-d52c-003d-21318aa80156@canonical.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <d606818f-2e13-fbea-970b-eab9080d7f15@gmail.com>
Date:   Tue, 15 Jun 2021 12:30:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <3dcc6900-8361-d52c-003d-21318aa80156@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/15/21 11:47 AM, Colin Ian King wrote:
> On 15/06/2021 11:45, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> Static analysis is warning that the sizeof being used is should be
>> of *data->tags[i] and not data->tags[i]. Although these are the same
>> size on 64 bit systems it is not a portable assumption to assume
>> this is true for all cases.
>>
>> Addresses-Coverity: ("Sizeof not portable")
>> Fixes: d878c81610e1 ("io_uring: hide rsrc tag copy into generic helpers")
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> ---
>>  fs/io_uring.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index d665c9419ad3..6b1a70449749 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -7231,7 +7231,7 @@ static int io_rsrc_data_alloc(struct io_ring_ctx *ctx, rsrc_put_fn *do_put,
>>  		ret = -EFAULT;
>>  		for (i = 0; i < nr; i++) {
>>  			if (copy_from_user(io_get_tag_slot(data, i), &utags[i],
>> -					   sizeof(data->tags[i])))
>> +					   sizeof(*data->tags[i])))
>>  				goto fail;
>>  		}
>>  	}
>>

Yep, thanks Colin. I think `sizeof(io_get_tag_slot(data, i))`
would be less confusing. Or

u64 *tag_slot = io_get_tag_slot(data, i);
copy_from_user(tag_slot, ..., sizeof(*tag_slot));

-- 
Pavel Begunkov
