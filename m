Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5920F430597
	for <lists+io-uring@lfdr.de>; Sun, 17 Oct 2021 01:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241088AbhJPXUK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Oct 2021 19:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235619AbhJPXUJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 Oct 2021 19:20:09 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9DBC061765
        for <io-uring@vger.kernel.org>; Sat, 16 Oct 2021 16:18:00 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id r18so53964170edv.12
        for <io-uring@vger.kernel.org>; Sat, 16 Oct 2021 16:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=WdlsgNza1hG7LlY5h1e0QpIEg0NnCeW6ZJvja2nshDg=;
        b=YTqjHdZSk0JnucPJ+bFhBoZ6xOdFKldhWyYSjFYRbZNkC6AKH+ofacCYM70LzWbaKS
         qpoBPYiML6YQMq90VoaXtCOHp9K0OsDW0kTK3XqmBuJCC2FtY2DoEN7eydi6O8zeQp5z
         hhcuCf8hRFcyyJOz7MGG6Sz27JNPiEW1OnC3uj6XA4uFhp8S+NpTGifPtSUYcFXyzMdZ
         9R9CGUid0M5TfrYmN/H6+usK3fLXZcel91/52pH5V48pW/WcuAC33g+LgMiUdxDK+3tw
         VuEC+ASAqyFfaigvPZuW/sMl3oGes9jOI93Wdil2Dg1q1TDUNO6Rg+X+ZsWfAH6585SY
         jzdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=WdlsgNza1hG7LlY5h1e0QpIEg0NnCeW6ZJvja2nshDg=;
        b=Qq5Te6Sc3gPrYHExb6ehhOu+Nfx6mtR6+aEiLpAuVbqLSDElSxyNE6NMOOow0IBHPl
         gJ+qLgYpUH7VXb2QzCz9sHXBDyNqZdLEaAh3I0/48X663zMSwD1zxXSgkAQPgu57Elz+
         roCcLp4yHNdfKJx9UwJ5fedVgUsBhz1AT5ZoEhmJKzEsKc6o/wnw5+LQmHV5FbXpeBeD
         Libds2NaZPJt7MD+A2YiiS+xHvvRfZTMheoGLqgaZC7JSyMGG8unY0Z8VyBp6cE5n2ZW
         KrGvatsQAFJqs4Hh/rsbYIXjjMZhggoysPC+rAXFV7EQ0j5RstQPeDO91UEpdUyXPij5
         +YVQ==
X-Gm-Message-State: AOAM530rLXNgQ2RGVqxSRunvnm4rAnubM/c9eJpBPZ4HFI66BaUm2L1X
        GVpN3pSrWBMmBD/4TbQuriSlw3L8K3fkMg==
X-Google-Smtp-Source: ABdhPJyOg0MuY5+5v+FaPAHmk+u7YKGPcTbRqSHp9+bPaA6b9lrDUBBMx80m0cX9Kt84+IG7+5MJCw==
X-Received: by 2002:a05:6402:410:: with SMTP id q16mr31536543edv.286.1634426279268;
        Sat, 16 Oct 2021 16:17:59 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.145.201])
        by smtp.gmail.com with ESMTPSA id nb42sm6729972ejc.23.2021.10.16.16.17.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Oct 2021 16:17:59 -0700 (PDT)
Message-ID: <1328bc6a-fed8-34ef-cae6-8debfa5dda96@gmail.com>
Date:   Sun, 17 Oct 2021 00:17:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [PATCH 0/3] rw optimisation partial resend
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1634425438.git.asml.silence@gmail.com>
 <3407648c-f183-f6b5-9a13-4586137e905a@gmail.com>
In-Reply-To: <3407648c-f183-f6b5-9a13-4586137e905a@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/17/21 00:11, Pavel Begunkov wrote:
> On 10/17/21 00:07, Pavel Begunkov wrote:
>> Screwed commit messages with rebase, it returns back the intended
>> structure: splitting 1/3 as a separate patch, 2/3 gets an actual
>> explanation.
> 
> Ok, let me resend it with changes Noah mentioned

not for this series though, iow good to go

> 
> 
>> Also, merge a change reported by kernel test robot about
>> set but not used variable rw.
>>
>> Pavel Begunkov (3):
>>    io_uring: arm poll for non-nowait files
>>    io_uring: combine REQ_F_NOWAIT_{READ,WRITE} flags
>>    io_uring: simplify io_file_supports_nowait()
>>
>>   fs/io_uring.c | 88 +++++++++++++++++++++------------------------------
>>   1 file changed, 36 insertions(+), 52 deletions(-)
>>
> 

-- 
Pavel Begunkov
