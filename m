Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D2D43E8C2
	for <lists+io-uring@lfdr.de>; Thu, 28 Oct 2021 21:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbhJ1TGZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Oct 2021 15:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbhJ1TGY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Oct 2021 15:06:24 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7072CC061570
        for <io-uring@vger.kernel.org>; Thu, 28 Oct 2021 12:03:57 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 131-20020a1c0489000000b0032cca9883b5so9024755wme.0
        for <io-uring@vger.kernel.org>; Thu, 28 Oct 2021 12:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=4Or8REu2W9+Bfv6t8aznUDIYDJ6mV6xI858XRPDxqI8=;
        b=ZI2/Bijbl7OBo7jmUJaabWIpBTv1F/Xgr+ZGtBbM8EVJ0t785udePV/9yMhaWhy/0k
         rjuoD1ZiIVbsYvQ+WfQFz1v+O67Bo7GtlheAxBF6taAvPcjKRPQVeY8QFNqz9R5f7spz
         nVQgmvBJWBtwJZzqHPB3cMJq7YmJ2H4kAGLYB3033+w3fPdsvJGgNKQLHsIdW9dcfZh8
         yNrYb7FpML4VVNxiPZkgqRa+MASNnD69IfIv+rnPouN+f6e4EcN3igPuWIvNRTS/DTwj
         sj/y71vvFRhXOsFNYvI9qKVwYO7S94DJPmPHcEDgIhnn6s+FXZzL1IiUgdRWKgNhTYZP
         3c3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4Or8REu2W9+Bfv6t8aznUDIYDJ6mV6xI858XRPDxqI8=;
        b=vByN2lV+LYvTQP36IU0SdHm1jU9dKa8lcTOYFuc7ELneYesouFAdebsuqpbwwIVHKs
         rj/NIjeTsk7NNM8TiyYqYKnQEbkVaacQgmRuWhI5xQHkdT8zsIhVB5GkCYPld2ISmF4L
         dGSNlJRXuEl1a6rvrR+TL38INizMVOvjZG7YRLhPLfhgs88144/dbIa0WoafdRgxAWZv
         JeRJ0LMAaOfyi2EN1KYH2thdhNURMCkiLOWLVaYRrkwi6gjts8684ISrehKumJdUKeMQ
         WSCnV6YR6YPP0iNAROL715M7pw/3FepAYmmNC0HmtfRPy15Kbv6XLIk1n9QG+Vaifzls
         u4dQ==
X-Gm-Message-State: AOAM530vLKmDUpXUDFLwKdIIpCWGpNX0kOlvFpUfFVe2hKCc/MIZu3Ft
        /HsAxTdv/s4ZfSoHGWC9rtz68HjFCcI=
X-Google-Smtp-Source: ABdhPJwy/Y/xNpMLUzBmL0icWbVahbkcEriGdWoONoBIAWmCPKURam+qAizvsCyRkzwEgUwjADdEbw==
X-Received: by 2002:a05:600c:1c23:: with SMTP id j35mr6251222wms.1.1635447835960;
        Thu, 28 Oct 2021 12:03:55 -0700 (PDT)
Received: from [192.168.8.198] ([148.252.129.16])
        by smtp.gmail.com with ESMTPSA id f8sm3680693wrj.41.2021.10.28.12.03.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Oct 2021 12:03:55 -0700 (PDT)
Message-ID: <09e0b364-f0ef-2f81-79b5-84ccf4939e5b@gmail.com>
Date:   Thu, 28 Oct 2021 20:01:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v3 0/3] improvements for multi-shot poll requests
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
References: <20211025053849.3139-1-xiaoguang.wang@linux.alibaba.com>
 <163544517302.151024.5113520590406591053.b4-ty@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <163544517302.151024.5113520590406591053.b4-ty@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/28/21 19:19, Jens Axboe wrote:
> On Mon, 25 Oct 2021 13:38:46 +0800, Xiaoguang Wang wrote:
>> Echo_server codes can be clone from:
>> https://codeup.openanolis.cn/codeup/storage/io_uring-echo-server.git
>> branch is xiaoguangwang/io_uring_multishot. There is a simple HOWTO
>> in this repository.
>>
>> Usage:
>> In server: port 10016, 1000 connections, packet size 16 bytes, and
>> enable fixed files.
>>    taskset -c 10 io_uring_echo_server_multi_shot  -f -p 10016 -n 1000 -l 16
>>
>> [...]
> 
> Applied, thanks!
> 
> [1/3] io_uring: refactor event check out of __io_async_wake()
>        commit: db3191671f970164d0074039d262d3f402a417eb
> [2/3] io_uring: reduce frequent add_wait_queue() overhead for multi-shot poll request
>        commit: 34ced75ca1f63fac6148497971212583aa0f7a87
> [3/3] io_uring: don't get completion_lock in io_poll_rewait()
>        commit: 57d9cc0f0dfe7453327c4c71ea22074419e2e800

Jens, give me time to take a look first. There might be enough of bugs
just because of sheer amount of new code. I also don't like the amount
of overhead it adds to generic paths, hopefully unnecessary

-- 
Pavel Begunkov
