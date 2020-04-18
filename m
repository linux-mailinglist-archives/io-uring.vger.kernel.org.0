Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D70DB1AED4B
	for <lists+io-uring@lfdr.de>; Sat, 18 Apr 2020 15:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgDRNvE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Apr 2020 09:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726695AbgDRNvC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Apr 2020 09:51:02 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14FC5C061A0C
        for <io-uring@vger.kernel.org>; Sat, 18 Apr 2020 06:51:01 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id j3so4908326ljg.8
        for <io-uring@vger.kernel.org>; Sat, 18 Apr 2020 06:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HV/idx0sQz9HVrMLmTDHDeW7AMJPyB9O8nPRGkqXOe8=;
        b=iSMmYDv2HDEo1oG5UwSfIJ9gktdHdBVmiCPQj9qdzkj8DekiJYS/niBfNPnVK1gn+4
         lyfT4yiSAwM+Ilo4Igsp7nxlnJvcXi1IYYvAXI8fYDV50bgacfnwwsbc3qyJ9Xxa+CW1
         wq56rha4o/OLfmHoh/3KikDyqtasJ6mQKkkKFkpo6/uIXX2WKPgrEcDygdpJZHES191i
         VKJEtozinSUv30z0ZT+LTxycJeC00m2/Ie4kF8uxQyD59yujg+Z3kaS465ys+tG+9iFm
         KCeRmVN+RcM2ARroA3C6WzMgofpnd9FT56mhcMBnfvBIaj0gDFKJsva8aKxcF0hXIhCn
         +4yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HV/idx0sQz9HVrMLmTDHDeW7AMJPyB9O8nPRGkqXOe8=;
        b=TTPQEsUaS8zKEH43T5EzPbaTQLv+P2NeoWVTXjZTE7DZdcfji2Vcnr46lC4+JGUeIV
         z7G3l4ZvT91VmUEketP1TTTo8CAMXTze4JCC6ocPqxwuoJNcJws65TiNwyPU6nrFS6S7
         ek8G64st9lFxDD/3IdBz2aOJZptoZ5628msTPJqf6QbYfhzN/Kg/P8/1JWD3SDnxi8DN
         LcRwYouxJt45lrkMdVcwnp506R5rLbN+McqND5G4UOBPqhaPzaK9nS4GMupr7hiptNQu
         z3OUUF7d03qpj1/BZrvTT1eSHOM9WgGhzEe5VrgIhWJzt+sko4bpo+fNtHcscUYyMEym
         dvqA==
X-Gm-Message-State: AGi0PuYWe3rSuUjqBKoLQH2T1e68qGcuPONdl0MzIOJCy1HncMX9Bcpp
        1CP1N9JIhN/CWFV9yQrlhYicLQrT
X-Google-Smtp-Source: APiQypJ9WPkWNy5pzkhPg/wr5QDFbCDCH6nOxJtCGz89Gahzvg40Ot+1ZrDwhyN2RFnIUMtGQ1N+ew==
X-Received: by 2002:a05:651c:3ce:: with SMTP id f14mr4936422ljp.98.1587217858501;
        Sat, 18 Apr 2020 06:50:58 -0700 (PDT)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id l29sm7470763ljb.95.2020.04.18.06.50.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 06:50:58 -0700 (PDT)
Subject: Re: Suggestion: chain SQEs - single CQE for N chained SQEs
To:     "H. de Vries" <hdevries@fastmail.com>,
        io-uring <io-uring@vger.kernel.org>
Cc:     axboe@kernel.dk
References: <08ef10c8-90f3-4777-89ab-f9245dc03466@www.fastmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <50567b86-fa5d-b8a7-863d-978420b3e0f8@gmail.com>
Date:   Sat, 18 Apr 2020 16:50:56 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <08ef10c8-90f3-4777-89ab-f9245dc03466@www.fastmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/18/2020 3:49 PM, H. de Vries wrote:
> Hi,
> 
> Following up on the discussion from here: https://twitter.com/i/status/1234135064323280897 and https://twitter.com/hielkedv/status/1250445647565729793
> 
> Using io_uring in event loops with IORING_FEAT_FAST_POLL can give a performance boost compared to epoll (https://twitter.com/hielkedv/status/1234135064323280897). However we need some way to manage 'in-flight' buffers, and IOSQE_BUFFER_SELECT is a solution for this. 
> 
> After a buffer has been used, it can be re-registered using IOSQE_BUFFER_SELECT by giving it a buffer ID (BID). We can also initially register a range of buffers, with e.g. BIDs 0-1000 . When buffer registration for this range is completed, this will result in a single CQE. 
> 
> However, because (network) events complete quite random, we cannot re-register a range of buffers. Maybe BIDs 3, 7, 39 and 420 are ready to be reused, but the rest of the buffers is still in-flight. So in each iteration of the event loop we need to re-register the buffer, which will result in one additional CQE for each event. The amount of CQEs to be handled in the event loop now becomes 2 times as much. If you're dealing with 200k requests per second, this can result in quite some performance loss.
> 
> If it would be possible to register multiple buffers by e.g. chaining multiple SQEs that would result in a single CQE, we could save many event loop iterations and increase performance of the event loop.

I've played with the idea before [1], it always returns only one CQE per
link, (for the last request on success, or for a failed one otherwise).
Looks like what you're suggesting. Is that so? As for me, it's just
simpler to deal with links on the user side.

It's actually in my TODO for 5.8, but depends on some changes for
sequences/drains/timeouts, that hopefully we'll push soon. We just need
to be careful to e.g. not lose CQEs with BIDs for IOSQE_BUFFER_SELECT
requests.

[1]
https://lore.kernel.org/io-uring/1a9a6022-7175-8ed3-4668-e4de3a2b9ff7@gmail.com/

-- 
Pavel Begunkov
