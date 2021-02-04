Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC4D30F7C5
	for <lists+io-uring@lfdr.de>; Thu,  4 Feb 2021 17:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236992AbhBDQ06 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Feb 2021 11:26:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237023AbhBDPC6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Feb 2021 10:02:58 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9743C06121D
        for <io-uring@vger.kernel.org>; Thu,  4 Feb 2021 07:00:34 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id p15so3840541wrq.8
        for <io-uring@vger.kernel.org>; Thu, 04 Feb 2021 07:00:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mKgL+6nR7ayMAHLgMxUYEgveEc8Kcliye/W2K9qpAT8=;
        b=JwhQFBYmunhP6zzSNZ0Szhze6hZR0MrLlqjtQtl8OSi8bPq13Gh6eB1AAXbohP0TB3
         kAC9c8r1GnfChL5X0D5/0o+Pcsb6BohGH2bSx3G5jmhXBfePUr4cLFsQKViAIOqpGTCX
         I3AlwQtrxlwUQOYRSD/zD06AXeZ74QVeGitlMuA8VUeWy2liZRdhslNobaZlssbiz3ZK
         9jib7tBjH4hH962qs8w5OEFMBHC4XpG5DDbs+ZwAPx3iRcRIWs5kCOQMHPovUaAlaJ4i
         Bw791RrdSXD0EdimBnCSEyzanP0GAbwUeH+tTzQpCYr2ZGmG7dQBh0z2qEie8BPTt1MQ
         Ol4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mKgL+6nR7ayMAHLgMxUYEgveEc8Kcliye/W2K9qpAT8=;
        b=JPoqcPzlsup624tgRFBE18Ek4of1VkkDPRIlRD3ay5y1F5QiZJ0UxCnMTafxMrktF+
         4KMplC0JmZhKm/ieN6itfqrk2zk00w0x3+j/mb/FZaSNHqpvP3QR/Kz41Cbqry7ijpbm
         Pb2ZCyZKs4GOUqTNepiV/qOUoShs78dzEfbdBfXH58VVyXL5pUZa9EPd7Le00FVF5o85
         Tv8b3lvtNUdetNXpjxEnfrnVFYuIgBdekL0zovOxFMZYo/bRJGNHnvj1Vf2IlJc9Auv8
         VklfOEtM7lN63VLGSQuOkTgumC4qWxy94X3FOUlkq/kSBNfnPkVGwRMT/yaKvuzZvJiY
         2Mmw==
X-Gm-Message-State: AOAM530vytlm6GVKHkk0cLhqdrgD/JUTyLi8CF4XiLCAffKChYPrq11y
        YKi2BaA4mq+i+s9c8CbW3ycF6jWnqFaxww==
X-Google-Smtp-Source: ABdhPJyyw/GEH9n0BjqGzjq9Nm4AS6If07KhF/jga7ZPmz2DEoSe7pKHggY/CKrgSTyZE1CKvDvjjQ==
X-Received: by 2002:adf:c413:: with SMTP id v19mr9847701wrf.158.1612450832927;
        Thu, 04 Feb 2021 07:00:32 -0800 (PST)
Received: from [192.168.8.175] ([148.252.133.145])
        by smtp.gmail.com with ESMTPSA id x13sm1171710wmc.27.2021.02.04.07.00.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 07:00:29 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1612446019.git.asml.silence@gmail.com>
 <014eff28b71c8e5da5edaa4ad9d142916317c839.1612446019.git.asml.silence@gmail.com>
 <8acbd513-531c-0a12-ea3f-ecf0cd94c9e2@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v2 13/13] io_uring/io-wq: return 2-step work swap scheme
Message-ID: <cdce2630-ddc8-a912-4937-147395a6ff54@gmail.com>
Date:   Thu, 4 Feb 2021 14:56:45 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <8acbd513-531c-0a12-ea3f-ecf0cd94c9e2@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 04/02/2021 14:52, Jens Axboe wrote:
> On 2/4/21 6:52 AM, Pavel Begunkov wrote:
>> Saving one lock/unlock for io-wq is not super important, but adds some
>> ugliness in the code. More important, atomic decs not turning it to zero
>> for some archs won't give the right ordering/barriers so the
>> io_steal_work() may pretty easily get subtly and completely broken.
>>
>> Return back 2-step io-wq work exchange and clean it up.
> 
> IIRC, this wasn't done to skip the lock/unlock exchange, which I agree
> doesn't matter, but to ensure that a link would not need another io-wq
> punt. And that is a big deal, it's much faster to run it from that
> same thread, rather than needing a new async queue and new thread grab
> to get there.

Right, we just refer to different patches and moments. This one is fine
in that regard, it just moves returning link from ->do_work() to
->free_work().

> 
> Just want to make sure that's on your mind... Maybe it's still fine
> as-is, didn't look too closely yet or test it.
> 

-- 
Pavel Begunkov
