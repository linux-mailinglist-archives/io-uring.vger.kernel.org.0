Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7923B1962
	for <lists+io-uring@lfdr.de>; Wed, 23 Jun 2021 13:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbhFWL4Y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Jun 2021 07:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbhFWL4X (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Jun 2021 07:56:23 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 942D8C061756;
        Wed, 23 Jun 2021 04:54:05 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id hc16so3524472ejc.12;
        Wed, 23 Jun 2021 04:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=R2h4XpSKSS67sYabyHcDisDI+CFYO4VbbBDbiW1htaE=;
        b=avgTW62safljG/k47PwBfBAigVSyrE0wzMpxgfr5VQuaU6MIOJ7l5Q/0rAJqjoBL/a
         1a9APtars4luYkoEkuwf1skLfJmuI50xh/VEgleYFhm8nkPmhEUvTnOeIvrBPaIWQhq1
         xwYmt3yPtlqcw5uZHm0GrXoevmpG0zAJAY3OGIFHDzL5BrjrduDXkFhs5oYJc3jzt2LZ
         haSjYc5SFhTqzXlqOy4fsU5iiXs8iWewf6u+UBiTfcT/4JjDD2+4Dl2GYMGpvLDa/EB0
         Z/ewjnDFWBJRK+fifm0P8KEIksqY4G1ITbFJlnW1BTGH37xrAh1SXBI9bxBaePdoiWEk
         KdIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R2h4XpSKSS67sYabyHcDisDI+CFYO4VbbBDbiW1htaE=;
        b=dIFhspWtx0Pj/jMfeUPRbPsyay2erpEfBX+abeXmqE+6z/Ci3IzvFwzOkd/zZ8yMt+
         QO9uneZ6/mlhTtOUUcxOQGeITWLjpB5EqyZIvxcHcb/AVCePPDJrf72whnENLWsWIr5l
         d7bFnhqJNFHccTMTEO/dWROxBLkUG7G77a3D7wBmx0lhRIwyMqt2hTx9bXqYEMY0zq4l
         BCQWxjR0ypYxmLnOC0colM0cZZZEuw/TCfv0feb6hiKWvFBKtVe0PpjM868N/+m9Tw0O
         DfJcQ9ClRpR12sWnQ5YbDWcbxN1DupZYszmlyhQ/hzH3r9Fpx27ItZAnc2Bo8osrYttk
         fqQA==
X-Gm-Message-State: AOAM530DX3eBYIqESB2u0wRrOWWp2D4YTELrBTgso4GkVzn4JfUgkOC0
        lctTn2j4HB3M3S080gMC9HXSpY9lD+vQNNQ2
X-Google-Smtp-Source: ABdhPJyqJafkjBZbp2nZsF8ZJQb3se8re6xqBOowqi3SqPGqpuScoOUvyuMJSTzc1XGl2bOthrmW9A==
X-Received: by 2002:a17:906:919:: with SMTP id i25mr9328194ejd.171.1624449243984;
        Wed, 23 Jun 2021 04:54:03 -0700 (PDT)
Received: from ?IPv6:2620:10d:c096:310::2410? ([2620:10d:c092:600::2:ccb1])
        by smtp.gmail.com with ESMTPSA id j22sm7383281ejt.11.2021.06.23.04.54.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 04:54:03 -0700 (PDT)
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-fsdevel@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
References: <20210603051836.2614535-1-dkadashev@gmail.com>
 <20210603051836.2614535-3-dkadashev@gmail.com>
 <c079182e-7118-825e-84e5-13227a3b19b9@gmail.com>
 <4c0344d8-6725-84a6-b0a8-271587d7e604@gmail.com>
 <CAOKbgA4ZwzUxyRxWrF7iC2sNVnEwXXAmrxVSsSxBMQRe2OyYVQ@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH v5 02/10] io_uring: add support for IORING_OP_MKDIRAT
Message-ID: <15a9d84b-61df-e2af-0c79-75b54d4bae8f@gmail.com>
Date:   Wed, 23 Jun 2021 12:53:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOKbgA4ZwzUxyRxWrF7iC2sNVnEwXXAmrxVSsSxBMQRe2OyYVQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/23/21 7:41 AM, Dmitry Kadashev wrote:
> On Tue, Jun 22, 2021 at 6:50 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 6/22/21 12:41 PM, Pavel Begunkov wrote:
>>> On 6/3/21 6:18 AM, Dmitry Kadashev wrote:
>>>> IORING_OP_MKDIRAT behaves like mkdirat(2) and takes the same flags
>>>> and arguments.
>>>>
>>>> Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
>>>> ---

[...]

>>> We have to check unused fields, e.g. buf_index and off,
>>> to be able to use them in the future if needed.
>>>
>>> if (sqe->buf_index || sqe->off)
>>>       return -EINVAL;
>>>
>>> Please double check what fields are not used, and
>>> same goes for all other opcodes.
> 
> This changeset is based on some other ops that were added a while ago
> (renameat, unlinkat), which lack the check as well. I guess I'll just go over

That's not great... Thanks for letting know

> all of them and add the checks in a single patch if that's OK.

For newly added opcodes a single patch on top is ok, rename and
unlink should be patched separately.

> I'd imagine READ_ONCE is to be used in those checks though, isn't it? Some of
> the existing checks like this lack it too btw. I suppose I can fix those in a
> separate commit if that makes sense.

When we really use a field there should be a READ_ONCE(),
but I wouldn't care about those we check for compatibility
reasons, but that's only my opinion.

>> + opcode specific flags, e.g.
>>
>> if (sqe->rw_flags)
>>         return -EINVAL;
> 

-- 
Pavel Begunkov
