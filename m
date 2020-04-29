Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 847BB1BE77E
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2020 21:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgD2Ti0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Apr 2020 15:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726423AbgD2Ti0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Apr 2020 15:38:26 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C78C03C1AE
        for <io-uring@vger.kernel.org>; Wed, 29 Apr 2020 12:38:26 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id n24so1201354plp.13
        for <io-uring@vger.kernel.org>; Wed, 29 Apr 2020 12:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Oi7zPrZd6t7Bs9iokHjxGsxJ/wumd0x0VUNT31dNcIk=;
        b=qdJEqGuu+ubpGUGX1E5RMY05mqss5/7zBHCE8vFQApI+5RaH23n29TQEQhUL37KdML
         WZCAXxPNIjnUvdu5AA1W49WK1BVm3hBKoj7NaV3m5jbWYmYvE3hEt3h4SQRmSRvbWtRl
         0ZDFAvHQW393EuIEeAoIsRHB0ACCoEa37eASDnQ61P+OYcRZCtLVZbecO5mS36QfKPns
         M55ERHnAuI7Mrr8LYbts7cuCLzuB0WsmGLpa5TE7r6jerjPWRyjIGWipF1aWf+kGBZbC
         j1e06MblPGqpEHC5P3baw0VXZ+qBi/neGlUOUhLdrgMk0iidSN7pT9itCT9WrdVdjobX
         QVbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Oi7zPrZd6t7Bs9iokHjxGsxJ/wumd0x0VUNT31dNcIk=;
        b=o7R6uh6XM0v6BY4rXQlxPoE0LvbIOYJYADyKtpY6r0NEJpkcUyN0okdro1PXV8QMpW
         DI1BKdob6igT0+FOwcnAqO3i2/hlDuuItET/hKTcEBX/0IINlDt+j5LC10JiZ+cExawt
         zAKYTQKxVj6Oqq8aNO0mNjnovYgFHR4bvtQ+MF5ZYCyN13YrQxnAQwE4Eue1TiUOrHM3
         K6lHAmWXF2jSoap8ZzGfhCeUNzJAULgPGBdFtNSh3mzrhZxZzVFvB+8YsyLME+IMz7Mi
         oXSxpzGKJzzWaTFiTLhFi2XcpbbLw3jYKhn0H/k5+OGVijGT1TwnnxxU+vyrvrFmFX86
         Afjw==
X-Gm-Message-State: AGi0PuaWWvTd40l+QflTPULtW27nvaX4251RYrZw3R7rXSFE0jt4rJ5y
        lQ7YytP+y3TrHHrAfDDlB0mk3w==
X-Google-Smtp-Source: APiQypLU+segjfMRPZk3jPvfz4eanoPJTkGhaCdQzmZW+4uEDhvsYrKdypi68/JYfdhokQTiyP6M3Q==
X-Received: by 2002:a17:90a:a484:: with SMTP id z4mr63967pjp.40.1588189105856;
        Wed, 29 Apr 2020 12:38:25 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id j6sm1630264pfe.134.2020.04.29.12.38.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 12:38:25 -0700 (PDT)
Subject: Re: Build 0.6 version fail on musl libc
To:     Jann Horn <jannh@google.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        =?UTF-8?Q?Milan_P=2e_Stani=c4=87?= <mps@arvanta.net>,
        io-uring <io-uring@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
References: <20200428192956.GA32615@arya.arvanta.net>
 <04edfda7-0443-62e1-81af-30aa820cf256@kernel.dk>
 <20200429152646.GA17156@infradead.org>
 <e640dbcc-b25d-d305-ac97-a4724bd958e2@kernel.dk>
 <6528f839-274d-9d46-dea6-b20a90ac8cf8@kernel.dk>
 <CAG48ez2k_CvXxVHW9WB+GV_+41PoKmVk0m_b_1sZaOAbnJUC1A@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <eca672cb-2df3-2274-c97f-c401328a40ce@kernel.dk>
Date:   Wed, 29 Apr 2020 13:38:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAG48ez2k_CvXxVHW9WB+GV_+41PoKmVk0m_b_1sZaOAbnJUC1A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/29/20 1:36 PM, Jann Horn wrote:
> +linux-api
> 
> On Wed, Apr 29, 2020 at 6:14 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 4/29/20 9:29 AM, Jens Axboe wrote:
>>> On 4/29/20 9:26 AM, Christoph Hellwig wrote:
>>>> On Wed, Apr 29, 2020 at 09:24:40AM -0600, Jens Axboe wrote:
>>>>>
>>>>> Not sure what the best fix is there, for 32-bit, your change will truncate
>>>>> the offset to 32-bit as off_t is only 4 bytes there. At least that's the
>>>>> case for me, maybe musl is different if it just has a nasty define for
>>>>> them.
>>>>>
>>>>> Maybe best to just make them uint64_t or something like that.
>>>>
>>>> The proper LFS type would be off64_t.
>>>
>>> Is it available anywhere? Because I don't have it.
>>
>> There seems to be better luck with __off64_t, but I don't even know
>> how widespread that is... Going to give it a go, we'll see.
> 
> If you have questions about how to properly write UAPI headers,
> linux-api@ is probably a good place to ask.

This is in liburing, it's not the kernel side. The kernel side is fine.

-- 
Jens Axboe

