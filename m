Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EAAB214023
	for <lists+io-uring@lfdr.de>; Fri,  3 Jul 2020 21:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgGCTuk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Jul 2020 15:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgGCTuj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Jul 2020 15:50:39 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 841B0C061794
        for <io-uring@vger.kernel.org>; Fri,  3 Jul 2020 12:50:39 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id g20so28528672edm.4
        for <io-uring@vger.kernel.org>; Fri, 03 Jul 2020 12:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lnxJ1aNd8KPf+1I7crwqfYfmWdl9H3dmzIq6X5gzzD0=;
        b=bao+3sJPDfDTUpyM3MgZv47IuVUr65o3AWqkZugP8ShK084tc/grNd9pnPTzqF+6+a
         +hOowleIr0UEqwg5MLdn9sbr8ow3TptHq5pokbsHzlZgD1fbsyi1qP8fST+mn9CuvYFH
         oXXObXcGe4oIDzXhY/T9lDZKd+KrLEo57SzVqighdCN3IGNfqAtrjNOVFf1866O3XGFh
         l7AU+afy6p60mjoRlLvXcXcMmK9Xr/pSi4HCOsK25V8jHl5hjVOLxABLiGMRXgnYmegt
         rX+7ngaltSUYbo5LmiW28WHCwyj+ztR5HeFyS7AOm7R93FyqqJbUdWY8jef5Ez2Op8um
         kZDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=lnxJ1aNd8KPf+1I7crwqfYfmWdl9H3dmzIq6X5gzzD0=;
        b=sG2LdJXQn0SRskrfCjURKa1ASF2HZmpXJKARj9SddftbVbIJMDArLM3FfyeP3fi3+a
         M4jaKdCfJlig9eBAB5aemQUBBBYw1SMLfno02FQyacaaR+Sqa2atVMQl0H1t0FgdCDFl
         zp01kxPf4A0zAoNCAb+xAEYZuW2EPGlheOswDJaj2gZ0LAeKidLXppT0vk6Ct1PM9yhg
         bo9QoX6CeEcYVq4qKW1Bp7I2zRlI7q3oV7lmtKT0Lcy4qmKiXTJOc8jFQC1p0BbC6znt
         vWvSxnr68WuC60zvqzDjjOVSgN+D3Jw/zUFL1VwrZwoUEw1WlFd+IEAG8YqU+0Dgnj2N
         pXtA==
X-Gm-Message-State: AOAM533ynMWp/CxZvMO5TfLzy1YcvH6DQKDaeiMbimoTNseyPIYyPJsu
        TRTTTP913i/cw8zWvmxbk8yH1rjl
X-Google-Smtp-Source: ABdhPJyFVtzdyhrFxWRaQbnkZbhrjsSo3F34vQw4xWkEWcLEpS4svZPH+nV3kzw+u2IokkOrSMWGeg==
X-Received: by 2002:aa7:dd8e:: with SMTP id g14mr43762240edv.208.1593805838078;
        Fri, 03 Jul 2020 12:50:38 -0700 (PDT)
Received: from [192.168.43.71] ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id x64sm15359310edc.95.2020.07.03.12.50.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2020 12:50:37 -0700 (PDT)
To:     Jann Horn <jannh@google.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <cover.1593424923.git.asml.silence@gmail.com>
 <1221be71ac8977607748d381f90439af4781c1e5.1593424923.git.asml.silence@gmail.com>
 <CAG48ez2yJdH3W_PHzvEuwpORB6MoTf9M5nOm1JL3H-wAnkJBBA@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 5/5] io_uring: fix use after free
Message-ID: <f7f4724d-a869-c867-ad8e-b2a59e89c727@gmail.com>
Date:   Fri, 3 Jul 2020 22:48:58 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CAG48ez2yJdH3W_PHzvEuwpORB6MoTf9M5nOm1JL3H-wAnkJBBA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 03/07/2020 05:39, Jann Horn wrote:
> On Mon, Jun 29, 2020 at 10:44 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>> After __io_free_req() put a ctx ref, it should assumed that the ctx may
>> already be gone. However, it can be accessed to put back fallback req.
>> Free req first and then put a req.
> 
> Please stick "Fixes" tags on bug fixes to make it easy to see when the
> fixed bug was introduced (especially for ones that fix severe issues
> like UAFs). From a cursory glance, it kinda seems like this one
> _might_ have been introduced in 2b85edfc0c90ef, which would mean that
> it landed in 5.6? But I can't really tell for sure without investing
> more time; you probably know that better.

It was there from the beginning,
0ddf92e848ab7 ("io_uring: provide fallback request for OOM situations")

> 
> And if this actually does affect existing releases, please also stick
> a "Cc: stable@vger.kernel.org" tag on it so that the fix can be
> shipped to users of those releases.

As mentioned in the cover letter, it's pretty unlikely to ever happen.
No one seems to have seen it since its introduction in November 2019.
And as the patch can't be backported automatically, not sure it's worth
the effort. Am I misjudging here?

-- 
Pavel Begunkov
