Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0973205A9
	for <lists+io-uring@lfdr.de>; Sat, 20 Feb 2021 15:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbhBTOSz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Feb 2021 09:18:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbhBTOSx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Feb 2021 09:18:53 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00326C061574
        for <io-uring@vger.kernel.org>; Sat, 20 Feb 2021 06:18:12 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id l17so9503589wmq.2
        for <io-uring@vger.kernel.org>; Sat, 20 Feb 2021 06:18:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kIOCos7oISwc+W8cbaHeoAvNvFm0Zb2bKRtcYXhk7NQ=;
        b=ZIAwwbXgge9Tx5yLd5qnET4dA3MigggH+9SlCEbdCjVfcjBcytNaYpYXaQ0yZKTx45
         1txnTosyiloJLYUXhAZx/Y45V6s8SY+EIMfCsub0h68b0bYg0441Yu7tFgv9WMqN+FwZ
         FSa6/dk4dKf73urmalWjnEDej7cXA5ZjSepaba18KOxP4wTZzyZdwtlh/dwBgIuB5axD
         Jb1+HHpet8RsK4uATuVkY652ToVZ+zAxip02CXxLjiVRgBjCwdOuRvIb2A8Alj3Q/kML
         VegaeM7xXR0ZXp81qXJV/0F0G/XffbWLQk5IS9LOklLU3xNxuQc6FYBUiux2u97cpaTR
         tnWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kIOCos7oISwc+W8cbaHeoAvNvFm0Zb2bKRtcYXhk7NQ=;
        b=GIo3kg3H4e5LIIaN8JY/aRz9pcj51SKBR2aZhn0mBH7PbupBhHT3lRhgZ0Qd6fsAh6
         Xi2ej/P2OCO+C76rsZKKwPz61icIqsexkBRM195jojSDPzz4qy5fTYFDNUskWl7MzkI7
         iUUXcpzftC9HFlqVO/9q6/Zb75PGqpcO34fJwtvxvFfnXxYCimkXZGbJvsWTBBiaHGh9
         WqisJ6ZbraKQfUFPaQ8HghR/5EwgRm6KR4N4tL8mkIFZLByXWh4DWzcv63xzNq7MzxnC
         oMEphisBUr0b0d+vhDdTiBY25uWNJuVx5OWlt5SHP5bgZl08/Fa+RtduCEMK5HCjRkly
         kY1Q==
X-Gm-Message-State: AOAM5324BhYTYv2MfVSmkIV8h2rgO4KTtctq81vjvCp2kcMtPhCXfZuC
        Nf6SXKSxb0tSJkihoGr9MvMMaWs0wZELjw==
X-Google-Smtp-Source: ABdhPJxVQu2xxIBW+E/0hPBWN2MtzLYHwnUT82yj2VBP5CCR44Ob9OpCwTOwiTCYi5lVR3Z7dszr3Q==
X-Received: by 2002:a1c:988c:: with SMTP id a134mr12326356wme.102.1613830691379;
        Sat, 20 Feb 2021 06:18:11 -0800 (PST)
Received: from [192.168.8.141] ([148.252.132.56])
        by smtp.gmail.com with ESMTPSA id c14sm4337933wrp.14.2021.02.20.06.18.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Feb 2021 06:18:10 -0800 (PST)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
References: <cover.1613767375.git.asml.silence@gmail.com>
 <1253a9e9-fbf4-4289-ae36-2768c682d6b5@gmail.com>
 <52268a17-d8cc-7a6d-258c-beb9fe9eff30@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 0/3] rsrc quiesce fixes/hardening
Message-ID: <003716d8-44da-a360-2631-7090d745cbf9@gmail.com>
Date:   Sat, 20 Feb 2021 14:14:21 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <52268a17-d8cc-7a6d-258c-beb9fe9eff30@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 20/02/2021 06:32, Hao Xu wrote:
> 在 2021/2/20 上午4:49, Pavel Begunkov 写道:
>> On 19/02/2021 20:45, Pavel Begunkov wrote:
>>> 1/3 addresses new races in io_rsrc_ref_quiesce(), others are hardenings.
>>
>> s/1/2/
>>
>> Hao, any chance you guys can drag these patches through the same
>> tests you've done for "io_uring: don't hold uring_lock ..."?
>>
> gotcha, will test it soon.

awesome, thanks

>>>
>>> Pavel Begunkov (3):
>>>    io_uring: zero ref_node after killing it
>>>    io_uring: fix io_rsrc_ref_quiesce races
>>>    io_uring: keep generic rsrc infra generic
>>>
>>>   fs/io_uring.c | 65 +++++++++++++++++----------------------------------
>>>   1 file changed, 21 insertions(+), 44 deletions(-)
>>>
>>
> 

-- 
Pavel Begunkov
