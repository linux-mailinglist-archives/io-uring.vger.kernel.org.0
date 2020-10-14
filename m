Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551CC28E7D8
	for <lists+io-uring@lfdr.de>; Wed, 14 Oct 2020 22:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729143AbgJNUY6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Oct 2020 16:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729022AbgJNUY6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Oct 2020 16:24:58 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 025D6C061755
        for <io-uring@vger.kernel.org>; Wed, 14 Oct 2020 13:24:57 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id w21so499420pfc.7
        for <io-uring@vger.kernel.org>; Wed, 14 Oct 2020 13:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Jaq2I+yMoezHZ3z6Gvrf2sPyArwOAyT/d5YHN7JEh20=;
        b=Sk1bEgrVZGdrE/gLb4TV4mGiB5qu2VXai4Tkym53M4CYxSIJx/qvmQBZ0zKldR8/TY
         CsOn31fT+FKzvGgJ9fscI/qB5VX1NGkMO2jvG9WV/U5RWVSwiLbiBqUbAo4xCLfeW6vm
         35EczvqAio/6hEjfe/Kg7ps6lIfOmFekdQcqbyTvvd76vEW4JVlx2bguWAB2Cn1CEuCd
         slZXV22T1+p/lpBolW483iIfqkb/RzX7CBJGG+vu6VwfBvt8RlwsjEJpf6Gw8fEpG7ia
         JbFzmMs7nynCMiLEnAgERZAzqWLSI1opAdTGWkbB3InuLjBIl5VzjyOr0W1vVFS6NEOf
         aGAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Jaq2I+yMoezHZ3z6Gvrf2sPyArwOAyT/d5YHN7JEh20=;
        b=AVxrM65Kl+D6dF/aUzIJHMhKbS2iYqmC1teMPDetAYPKR59CIUl/IVXhiGfg0uhBP9
         nmXGPryOkbgaa+lnWsqGUmcLMs/hUcX/7K2Zo8cGnjEyYOLJYjGlrXWEWtnj24+km7/Y
         NjQV1NBSGLhY7DOsh2Z+kEiQO/fBz21mXmo0ICG3+e8x/JiSFfLC+8cZlTKXZNma1Dio
         i1cndV+dzLtwncSsiX8U/wutOpH5MPJLJfubrCaxgj7NILUhS71T2JQmDvQH50W1y0qu
         k9SyBr6e0L/57GlAyrCQBWfik2F60PI5uU6FjCf10YoxL1MLP+hMFwmDIqjJ/HSFLMMJ
         yu5w==
X-Gm-Message-State: AOAM5316ZohGT5ZwJdoCzj997X1Fh92ttpreoRFwCNw9QCst1lR/Bp85
        UidAPmYzpeH17Wc7flBpK535m7Vv88K9Ygdt
X-Google-Smtp-Source: ABdhPJxxz5R7fnjBeB3DADS5icdMZB3ERZcsf1cEskAoTnBS1Noq6yyKCOEJtXEHP3liDr0L9FLW1g==
X-Received: by 2002:a63:e441:: with SMTP id i1mr563697pgk.221.1602707096108;
        Wed, 14 Oct 2020 13:24:56 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id y27sm482736pfr.122.2020.10.14.13.24.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2020 13:24:55 -0700 (PDT)
Subject: Re: [PATCH 0/2] post F_COMP_LOCKED optimisations
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1602703669.git.asml.silence@gmail.com>
 <ec396af4-d2ec-81d9-3ddd-4d66f22bbf91@kernel.dk>
 <4003979c-f467-316f-cf6f-299dff23d17c@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6da1aa42-a771-7636-b987-588ff6c30ecc@kernel.dk>
Date:   Wed, 14 Oct 2020 14:24:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <4003979c-f467-316f-cf6f-299dff23d17c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/14/20 2:00 PM, Pavel Begunkov wrote:
> On 14/10/2020 20:53, Jens Axboe wrote:
>> On 10/14/20 1:44 PM, Pavel Begunkov wrote:
>>> A naive test with io_uring-bench with [nops, submit/complete batch=32]
>>> shows 5500 vs 8500 KIOPS. Not really representative but might hurt if
>>> left without [1/2].
>>
>> Part of this is undoubtedly that we only use the task_work for things
>> that need signaling, for the deferred put case we should be able to
>> get by with using notfy == 0 for task_work.
>>
>> That said, it's nice to avoid when possible. At this point, I'd like
>> to fold these into the last patch of the original series. What do you
>> think?
> 
> Yep, was thinking the same. It's better to be in 5.10, and that would
> be easier to do by squashing.

OK, done.

-- 
Jens Axboe

