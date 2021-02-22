Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C7D3219D3
	for <lists+io-uring@lfdr.de>; Mon, 22 Feb 2021 15:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbhBVOKT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Feb 2021 09:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbhBVOJj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Feb 2021 09:09:39 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37632C06174A
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 06:08:59 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id u14so19239642wri.3
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 06:08:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JAaod2qlSs1ZczusMlTLCF8lxWCv/VZy4LfoYpgUQSE=;
        b=p+ku9t1vlFnnEmtWCofuUr4/PeQzIQHZ1MWewG26BMFKDvhH6V8KQ8O/X9b+rtWGeE
         +6rpr2msF9BsC3pJKwbl4FLBIFB1txfIYiT6+8jXhblOUvYuz3gCejioIL2Saq5x8v1S
         6SkTFhZ49JXjLrlB8C20cHdu4I5ppUjBfB0b+BqM2cQzRxgEPg5HQ9PqsSFddGADzNyb
         PRKpnef0xtnbLFo79OLgWyWwy/iMNcbcC+tVcAKl40pm21gmCd7RimsX3TWWUIKCUaMz
         LA2/JdVn/uq+ui/NlxYLXulPiSA2LlnXDLnu/iT+zNSymMAqNnH8mDnMU8/OTQ0yzvYe
         +Rzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JAaod2qlSs1ZczusMlTLCF8lxWCv/VZy4LfoYpgUQSE=;
        b=l8RasiGJFzvI3AXnAyieI5hGVQY1qmtW9+4DQNxMDS9hPEuvy2Zvh+yEowYxq5+2lu
         xI33V3a5Iigqw4d0qH0HwVoI7VGoN4bx91c1mxM4+qylE2B2KHbgJkWhaUz8YTeUkTzQ
         HwCQEu7cz3cARPflfggkN+xJullIpHsuDaTg5BaAUvl0gpcBD8NozfEIxEpcY27vLu8z
         wLTjkPi5knzqKkPZqjNSatK1bj56M5pA8VkbabmvrLr6FY9iihCTug6ia1yNwir6nWZp
         FgIg3JFJ/fn9aDPsdLFExFDn25ZXTsc2DKbhcGWPO8cBdlnsbe1FrorvE2PidymfMjyB
         +17g==
X-Gm-Message-State: AOAM533WD2eI5rb2LEN3eGNIdVxyU/4aAJMNEAmGTq9PU7czWBCE7PrS
        mpNIzbygVbeo7bDT0SfJHd+AQRmTtKDTGA==
X-Google-Smtp-Source: ABdhPJyqfg5mV9i/Y+GGw2PfOySFqxd9RmZhzy8X5rcIvMfDmrEu8swo0qArKIZ6gXN8k7yewp14gA==
X-Received: by 2002:a5d:5010:: with SMTP id e16mr4308006wrt.59.1614002937804;
        Mon, 22 Feb 2021 06:08:57 -0800 (PST)
Received: from [192.168.8.146] ([148.252.132.56])
        by smtp.gmail.com with ESMTPSA id p13sm16021525wrj.52.2021.02.22.06.08.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Feb 2021 06:08:57 -0800 (PST)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
References: <cover.1613844023.git.asml.silence@gmail.com>
 <c8248b0f-eab9-9c63-9571-a31de9a6e6a4@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v2 0/4] rsrc quiesce fixes/hardening v2
Message-ID: <cf3de0e1-5983-57e4-3674-af231543677a@gmail.com>
Date:   Mon, 22 Feb 2021 14:05:08 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <c8248b0f-eab9-9c63-9571-a31de9a6e6a4@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 21/02/2021 13:22, Hao Xu wrote:
> 在 2021/2/21 上午2:03, Pavel Begunkov 写道:
>> v2: concurrent quiesce avoidance (Hao)
>>      resurrect-release patch
>>
>> Pavel Begunkov (4):
>>    io_uring: zero ref_node after killing it
>>    io_uring: fix io_rsrc_ref_quiesce races
>>    io_uring: keep generic rsrc infra generic
>>    io_uring: wait potential ->release() on resurrect
>>
>>   fs/io_uring.c | 96 ++++++++++++++++++++++++---------------------------
>>   1 file changed, 45 insertions(+), 51 deletions(-)
>>
> I tested this patchset with the same tests
> for "io_uring: don't hold uring_lock ..."
> 
> Tested-by: Hao Xu <haoxu@linux.alibaba.com>

Great, thanks

FYI, looks like your emails have a strange encoding. It's
readable, but at least for me shows "undefined encoding".

-- 
Pavel Begunkov
