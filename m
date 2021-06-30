Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9459E3B8A17
	for <lists+io-uring@lfdr.de>; Wed, 30 Jun 2021 23:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233861AbhF3VXm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Jun 2021 17:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhF3VXl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Jun 2021 17:23:41 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE84BC061756
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 14:21:10 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id j1so5327670wrn.9
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 14:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=+l2ISlj/IU6LhxsZlRmIvmLgOdoN8vTT7kkHYS1g1H4=;
        b=YUAPhmgeybrOXdfAjpCPw0Ho5EhiTqvhp8RQKeHeBmYPsO8N0I9Pg4M4vI3esPBH7s
         q3zieSCigLdnN1yYSsEjbuVZaUDo6bpySLGsog02RUEZdugMYIRNRb0OUiHzdNa5pPdV
         PUSWF9qkb7p/wf7NVfWJ83z4E95+4mRGphobd5irhxYyssQwQAH3FTDbteS6vukLV91r
         iRz2YSyWXH9edjb8FVQmvVEFmtalruI/D/A4MItwMbC5r3y0/tie70IOx1ubn7we08hn
         /ZD6fwI1GaFLTh8G4NBNTbox47+OXUK2xAIKRAD96Zz7WC+rYqcHpaL9z0RtXUYsy+91
         h+ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+l2ISlj/IU6LhxsZlRmIvmLgOdoN8vTT7kkHYS1g1H4=;
        b=LVQWDDRQzpQitrlIF7wJpMzK0pQZ8i+yy+eYftPsuNWGGucrqF4ki4OmwzWedyGSHi
         YD0MTeOXD/+L0M1TdO1JROKI/s7ZcE3Ow0iVv6QnIsNxpzxWFElfJUid3EOAxIO3i0Fe
         B8cIxo28WTZjDfNwqZWTCxtCpOwcnfmHM5L2K5TZxY6dW49Bru5yl0yTgZ4M8E3mY6Y3
         O7Z/7wFsB+abo4EgPrrbe86WGMYaRshHrThVvRBRMLu0e+2Ae1B6TBDAQxo69fNc20wp
         mwrqT3tG/UUFK/eyNtKpsFAsa9wGYOGcyKW5yv/Ztr/u3CYCjg+8dVUC6EJf93Tv7V5Y
         kv1Q==
X-Gm-Message-State: AOAM532WGnyOOIUeX3KLLF6Py0p99Ccb9S53vydyjixwWy7MI0LsWOQT
        RwkNM/cDBZez8UFLbll/XGH3GaS4vIpM+7pf
X-Google-Smtp-Source: ABdhPJw1o87fRK3eG916D82yeEnZzmE3F6rBg17tLLb1LCpjdN8prQHBKTBcUQ9kJoJ42S4l7OmA/g==
X-Received: by 2002:adf:e101:: with SMTP id t1mr6252707wrz.215.1625088068821;
        Wed, 30 Jun 2021 14:21:08 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.185])
        by smtp.gmail.com with ESMTPSA id m184sm21711324wmm.26.2021.06.30.14.21.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 14:21:08 -0700 (PDT)
Subject: Re: [PATCH 5.14 0/3] fallback fix and task_work cleanup
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1625086418.git.asml.silence@gmail.com>
 <d9368ce8-954e-794a-ec77-0cf6f38a884a@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <ca305733-08d6-66d1-4b91-61075893a4d9@gmail.com>
Date:   Wed, 30 Jun 2021 22:20:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <d9368ce8-954e-794a-ec77-0cf6f38a884a@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/30/21 10:18 PM, Jens Axboe wrote:
> On 6/30/21 2:54 PM, Pavel Begunkov wrote:
>> Haven't see the bug in 1/3 in the wild, but should be possible, and so
>> I'd like it for 5.14. Should it be stable? Perhaps, others may go 5.14
>> as well.
>>
>> Pavel Begunkov (3):
>>   io_uring: fix stuck fallback reqs
>>   io_uring: simplify task_work func
>>   io_uring: tweak io_req_task_work_add
>>
>>  fs/io_uring.c | 131 +++++++++++++++++---------------------------------
>>  1 file changed, 45 insertions(+), 86 deletions(-)
> 
> Applied 1-2, thanks.

Ah, you already did drop, thanks

-- 
Pavel Begunkov
