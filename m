Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0AE83A19E0
	for <lists+io-uring@lfdr.de>; Wed,  9 Jun 2021 17:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234693AbhFIPhA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Jun 2021 11:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232861AbhFIPg7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Jun 2021 11:36:59 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1ABCC061574
        for <io-uring@vger.kernel.org>; Wed,  9 Jun 2021 08:35:04 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id l1so39126674ejb.6
        for <io-uring@vger.kernel.org>; Wed, 09 Jun 2021 08:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=c5/iYvlDXHOkhzybG+NWeDWFHKeJp7EHL9FL7L25/1o=;
        b=JM+OYEjtpG60fHwlfID+s+eruAc7KaE+z12eblq4tyEqm6Ncg6h/pA/UWJQ2cNty6M
         PFBU61y2Gcjfv2qShBern5E0PbAFYMaB8jWPSfInGVPUSEe8NmwSzEA6Jzvmyn5FWXlO
         LduYYrltLAi/fRln+kEdJnPed3aWcw3LJduJsxDlgcvKr9eIPj83PvEzou+7DOphZqrJ
         gI0quX+BuZ6PVmIg15gAJE5xw4FyFFPtWG6KIv/1ZYg2e4e53JyPZomDFBBiYQbKVM5u
         yi4tziefr9skMPCisbPcGPpzWymYrXfh6whp0y1ByNIwoD7Zztb8SfabzYBhhPVM3AGK
         r1vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c5/iYvlDXHOkhzybG+NWeDWFHKeJp7EHL9FL7L25/1o=;
        b=oI0lkJVDymWnUN8tGHaOnVfba4BvIozbiFlUfsyK7hyIJeWFlcYCTMnxwaGERocUNE
         HShskxX+RGRBZHapu34QI2TmQ8cFoqngcORmdhznCMr3e0VeKe90ahQVEmhI8R80q9Hh
         ihDn1eAATi+9B2Ckq0OAgYjeib1xCELHHxISmDJ5ToHX5ubpnak9kgTbMGXsOMyMe+qw
         m4IjtUDaLhuY8So0C3x6SFdvfSEidVHBmQQq1qB9wGMlTB5PjCEoHgAGpfFdVVOD74/l
         2Uso9+LlykV3Lk5I+oWz7yKmStwiuaa7DzVw8/BKeYERIP+QVI/N3zd40ISpLsKLgHqe
         VMhg==
X-Gm-Message-State: AOAM5310sGOCFc9mlfs1dizoFPRRVPRUS6Uu9SskIhcU9chK40OSi29G
        8qolZLa7SFnv0dqHMNAi6RlFp0OiAGEi5LVC
X-Google-Smtp-Source: ABdhPJyGlYRSFQ68tkvkpDvkxYWLhgRuODpe8P9UUF8fKajfkZN8gJH4RrZOktMyuEgy4ae7V0wCGg==
X-Received: by 2002:a17:906:f111:: with SMTP id gv17mr432394ejb.435.1623252901677;
        Wed, 09 Jun 2021 08:35:01 -0700 (PDT)
Received: from ?IPv6:2620:10d:c096:310::2410? ([2620:10d:c092:600::2:44bc])
        by smtp.gmail.com with ESMTPSA id f18sm26450ejz.119.2021.06.09.08.35.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 08:35:01 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <d60270856b8a4560a639ef5f76e55eb563633599.1623236455.git.asml.silence@gmail.com>
 <e3edab99-624d-6f24-a6ba-63589d00eeee@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH] io_uring: fix blocking inline submission
Message-ID: <e6283f40-52ab-ddcc-131c-309e34321613@gmail.com>
Date:   Wed, 9 Jun 2021 16:34:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <e3edab99-624d-6f24-a6ba-63589d00eeee@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/9/21 4:07 PM, Jens Axboe wrote:
> On 6/9/21 5:07 AM, Pavel Begunkov wrote:
>> There is a complaint against sys_io_uring_enter() blocking if it submits
>> stdin reads. The problem is in __io_file_supports_async(), which
>> sees that it's a cdev and allows it to be processed inline.
>>
>> Punt char devices using generic rules of io_file_supports_async(),
>> including checking for presence of *_iter() versions of rw callbacks.
>> Apparently, it will affect most of cdevs with some exceptions like
>> null and zero devices.
> 
> I don't like this, we really should fix the file types, they are
> broken if they don't honor IOCB_NOWAIT and have ->read_iter() (or
> the write equiv).
> 
> For cases where there is no iter variant of the read/write handlers,
> then yes we should not return true from __io_file_supports_async().

I'm confused. The patch doesn't punt them unconditionally, but make
it go through the generic path of __io_file_supports_async()
including checks for read_iter/write_iter. So if a chrdev has
*_iter() it should continue to work as before.

It fixes the symptom that means the change punts it async, and so
I assume tty doesn't have _iter()s for some reason. Will take a
look at the tty driver soon to stop blind guessing.

-- 
Pavel Begunkov
