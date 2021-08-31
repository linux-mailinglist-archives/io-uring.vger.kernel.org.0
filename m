Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C34B3FCE2E
	for <lists+io-uring@lfdr.de>; Tue, 31 Aug 2021 22:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240355AbhHaUJL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Aug 2021 16:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240331AbhHaUJK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Aug 2021 16:09:10 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB5AC061575
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 13:08:15 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id u9so944396wrg.8
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 13:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=jLMnLWWf+VnmX5DJBITtmnDPdn6Z+tvEuP/WXMp0yKw=;
        b=TKoCG7mX2599WiLI62CEfdPLnLOQYvAe5jkIQFF+vi7VS8lwlZXXytAMxd+Dm2DX2g
         GL8YG0IL79I4P2uGFjAKdX49R32XKXFJmFcwxAM5WQ2518DywIfJ3Rv/krLoDkHHPNHM
         +ABWWuQEDRNj9KKp7RZKzzP8dxr4RuwzCn6aJGpKVXkkbG/m+GaxZ5JQMIGkATO5KKpV
         rMav9IdP4/e8VrCniOqqnYGIBxUOCP1wxhRO0LBHzDZzgAiZwk0ZNGgAmBjXQHMnpI/g
         Grxwe4skl2uJCMxW9mJ3FnB8kTmXfsg1AiDwEPgqpWXvgo/Dk2w3H9+KuJFC2a5hWVYl
         NHgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jLMnLWWf+VnmX5DJBITtmnDPdn6Z+tvEuP/WXMp0yKw=;
        b=TP5E6m01m+tK2lCRoFlfujmDYMG577jGXf7cc5w1VQPQXZSES2x5+DRxtTWuEmYznc
         Pt8uMwRfpVCUNgifazY4oK4TsEerUzYlvI2pPkBl6dMaDHXb3MGSV9B4LHVHJmQDnzha
         Ov7E6e4IDQhG/CFN7EjFsFawTIJsZG7ORTuup69HP2wHLTlxZogvfLBXBHrVFoKQTec/
         Ce+hotSWQgbeuUofjGIIAJwcOlO0jS4sppJDuEQXElUtf/5iedP50W6P71bYfjmI1Uec
         Dbu5P9wGM7HPFB+Ju1lHHzi0xJFIzF7gvj4YCxdb+zNl9P+n6h6tss0Opx1PuHL5AJfT
         HMRA==
X-Gm-Message-State: AOAM5314Y65x4FgPCiU68Sf7f5cFsclzhoq/rxDFDSaK6Vngl6N05tmr
        01lSiY271NvIeEp+OOMjVy8c97ZQj/8=
X-Google-Smtp-Source: ABdhPJxoQhCJSJmIz/29G1gMj+qDAXv62FSRKAOWj8hFPowVQ/Ozc56hJgQi721WNA48uvIyhSWZxw==
X-Received: by 2002:adf:efc2:: with SMTP id i2mr33980186wrp.94.1630440493501;
        Tue, 31 Aug 2021 13:08:13 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.138])
        by smtp.gmail.com with ESMTPSA id v5sm20129489wru.37.2021.08.31.13.08.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 13:08:13 -0700 (PDT)
Subject: Re: [PATCH liburing] man/io_uring_enter.2: add notes about direct
 open/accept
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <e4b7c0f9b585307ac542470c535ef54e419157e0.1630439510.git.asml.silence@gmail.com>
 <8f82a074-1597-1796-2e26-da3abe722806@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <ded8e138-2870-a69d-9dd7-f13f15a24e54@gmail.com>
Date:   Tue, 31 Aug 2021 21:07:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <8f82a074-1597-1796-2e26-da3abe722806@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/31/21 9:04 PM, Jens Axboe wrote:
> On 8/31/21 1:52 PM, Pavel Begunkov wrote:
>> Add a few lines describing openat/openat2/accept bypassing normal file
>> tables and installing files right into the fixed file table.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>  man/io_uring_enter.2 | 36 ++++++++++++++++++++++++++++++++++++
>>  1 file changed, 36 insertions(+)
>>
>> diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
>> index 9ccedef..52a5e13 100644
>> --- a/man/io_uring_enter.2
>> +++ b/man/io_uring_enter.2
>> @@ -511,6 +511,18 @@ field. See also
>>  .BR accept4(2)
>>  for the general description of the related system call. Available since 5.5.
>>  
>> +If the
>> +.I file_index
>> +field is set to a non-negative number, the file won't be installed into the
>> +normal file table as usual but will be placed into the fixed file table at index
>> +.I file_index - 1.
>> +In this case, instead of returning a file descriptor, the result will contain
>> +0 on success or an error. If there is already a file registered at this index,
> 
> I don't think non-negative is correct, it has to be set to a positive
> number. non-negative would include 0, which isn't correct.

Oh, right, should have been non-zero

> Should also include a note on if these types of file are used, they
> won't work in anything but io_uring. That's obvious to us, but should be
> noted that they then only live within the realm of the ring itself, not
> the system as a whole.

Will send a v2


-- 
Pavel Begunkov
