Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0EC3031E9
	for <lists+io-uring@lfdr.de>; Tue, 26 Jan 2021 03:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729949AbhAYRKy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jan 2021 12:10:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729298AbhAYRKQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jan 2021 12:10:16 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C51F0C06174A
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 09:09:34 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id e15so11925828wme.0
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 09:09:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VXOFqi/7ENfB5bGhqJER2VyiAtbKRlsle/ALl/THCkA=;
        b=cXZxqF+JRTaEvAx3f8l97eYTClccR+xvlEue3QsBWazMuiz/vmr4xFpIckZ9ttKB7v
         J2uNbGXPwlfuLfY4VhFP/XnWq/hvR5UUPFW4Dg0WVOyBXodPKTRib/CIEQJJFSrFqTJn
         5XE6W5Kjb7wF9x+QWFPtA/WuhjQGmZIUjx+o4XtqWVqRlqm10HW8V2xyDxTjPLlbnKNV
         BHwXGIFqbUS6F2aq0V+Ok6h3NyhGxNyIRNzwq7e6LS4pFXBm0qqCPmFuptD97+9dAPoZ
         ScFsSf7Rldgz15FVYa46sUgM7nmcglxSP9qmc/Lwo6E36loVXXTBt+lnu/uOkk2b6ZH1
         WuSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VXOFqi/7ENfB5bGhqJER2VyiAtbKRlsle/ALl/THCkA=;
        b=TEXAQQPff7m5fijMIXR4GW8JNl3lTaN9IuixPXY/VEip5CICKGLLWfAYJ1yIlSAL/j
         wdGVFkFDGjHs3TiMuM0RnFOzSSNMwu3MfmdyXkVq/vXAJpsLNyAtTEjKMdrQm+JmANmn
         nJquWsVkQBzVf/34CtpDMVJgq/6Q8SE3z3/3xq1uU0IUQrNqPkoALs63HZQSsEudCye3
         tCsLBZKYxg3CkkfZ53k4Rwpoj4V8nOem6ByFpUPWL40zyCy63GRNtHfq4NzwAr056pOX
         x55Lii5nQEHZunn/Uj22azE726RoN/xAZx/BOje0Fx70ArYAwhQhN7FJuVh6hX1gNV5f
         sTng==
X-Gm-Message-State: AOAM530HWf7nBt/1ZNoD9uB2+gPKZH1KNsolfRsHjeq1yhlPTzfjavGK
        2Mn8FwaqvvrXjoqZ9aPcrL7gfA8X31aHaw==
X-Google-Smtp-Source: ABdhPJxa4aqA1BJjBJ9S9O7vNzBK9SLZB/u3lvjm7DQEESAdX7cuy/SQkOZidt07XH6gos+cT42JyA==
X-Received: by 2002:a1c:e919:: with SMTP id q25mr1027214wmc.57.1611594572979;
        Mon, 25 Jan 2021 09:09:32 -0800 (PST)
Received: from [192.168.8.154] ([85.255.234.28])
        by smtp.gmail.com with ESMTPSA id f189sm12036582wmf.45.2021.01.25.09.09.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 09:09:31 -0800 (PST)
Subject: Re: [PATCH 0/8] second part of 5.12 patches
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1611573970.git.asml.silence@gmail.com>
 <f10dc4a5-9b2c-da65-bb62-00352aff3926@kernel.dk>
 <5b3cfdda-b16c-5dca-da9a-1c034571f91f@gmail.com>
 <add73cdc-34f2-b5cb-2e64-ad48808e170b@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <35b72b3c-dd58-80f8-0f8b-fb5aca980e3c@gmail.com>
Date:   Mon, 25 Jan 2021 17:05:52 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <add73cdc-34f2-b5cb-2e64-ad48808e170b@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 25/01/2021 17:04, Jens Axboe wrote:
> On 1/25/21 9:56 AM, Pavel Begunkov wrote:
>> On 25/01/2021 16:08, Jens Axboe wrote:
>>> On 1/25/21 4:42 AM, Pavel Begunkov wrote:
>>>
>>> Applied 1-2 for now. Maybe the context state is workable for the
>>> state, if the numbers are looking this good. I'll try and run
>>> it here too and see what I find.
>>
>> I believe I've seen it jumping from ~9.5M to 14M with turbo boost
>> and not so strict environment, but this claim is not very reliable.
> 
> Would be nice to see some numbers using eg a network echo bench,
> or storage that actually does IO. Even null_blk is better than just
> a nop benchmark, even if that one is nice to use as well. But better
> as a complement than the main thing.

I think direct I/O null_blk won't cut because it completes through a
callback, but maybe some buffered rw. Yeah, good idea to try something
more realistic.

-- 
Pavel Begunkov
