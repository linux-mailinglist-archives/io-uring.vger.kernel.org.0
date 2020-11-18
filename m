Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72E4F2B8140
	for <lists+io-uring@lfdr.de>; Wed, 18 Nov 2020 16:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgKRPzP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Nov 2020 10:55:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbgKRPzP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Nov 2020 10:55:15 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA61CC0613D4
        for <io-uring@vger.kernel.org>; Wed, 18 Nov 2020 07:55:14 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id c17so2636179wrc.11
        for <io-uring@vger.kernel.org>; Wed, 18 Nov 2020 07:55:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zbuM/1c1zn1MblhGXJPh76mXkTeNfg1MOcZAXA+EP+A=;
        b=SECENYWFqQPFV2++miRuLOtnE4W2CYKXV9gA8jTzph6OFBQjOcMp7IJv+XdFrJxC/q
         IEOzeURCvVRvZEhbOIzry9EbzKp6kaK5flP9DP4lJv0mdfFWa0D1MreYXVhf6PbaaqTn
         1YxfpEWTfWuha3H8iTULC9vRvwzadCFPpk+RqtoqNLC+C/RvMSvbSJibdGWktkZFupEW
         hcVIPKWp6qz6r3K8mFZXI5aAINGOQtbv8RbfBN2dEVTdvQ4N1crYih+109PyFwv3m0mW
         NBPrd+rh7IpjxJyotoxzO3RuJuxnOmwcJySD3Y9QpXB7fCLpW0KZQMWoNvUpdmWt4E55
         NRiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=zbuM/1c1zn1MblhGXJPh76mXkTeNfg1MOcZAXA+EP+A=;
        b=cvUuUUmeiVGx6bljDdoTlUpq5dCrScqE62q1vVPbUycOktWPIjKhvV9nxh6GYAxraR
         bNHKZuYa9g3scc23rEUsdr/aKOa53ApA3o6TAotvxEXgF0yPfzC9a0zSAQATWw6CtKBP
         yldL4QDszfMx/Jg7M2wL3MClnMqnO7IKPjIq795MT3xTCrU95SFR7KjNqyqbWvI3ZXki
         3zouDm0JmlrtSHUrf8xgMovGll/h/07+5beF2xFd+HePHLKvcmhfeFtiiUh0LnW6y5ud
         /caRUeK3rufyT0YLVVZGKStI5LKuN+VKcaokPmw4Afo+fWsDAlhe7N8XRFCX+ye+HQK9
         qvGg==
X-Gm-Message-State: AOAM533ctswvwKttbmd+biidnGvwSK34wb9V+g8PZ2JEGn4O8ZyXG9aY
        ArHOt9TrNeqtsvx053uVXVtFsBBJTUrPdA==
X-Google-Smtp-Source: ABdhPJzzrYmJbI9In1QcZ3xjf36BO99PczvFOTulWIVwpyLncI9N09DiHIdSwq9dSY0gEj6Mb2I6Ww==
X-Received: by 2002:adf:814f:: with SMTP id 73mr5408162wrm.174.1605714913530;
        Wed, 18 Nov 2020 07:55:13 -0800 (PST)
Received: from [192.168.1.144] (host109-152-100-135.range109-152.btcentralplus.com. [109.152.100.135])
        by smtp.gmail.com with ESMTPSA id b8sm4128083wmj.9.2020.11.18.07.55.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 07:55:12 -0800 (PST)
Subject: Re: [PATCH 5.11 2/2] io_uring: don't take percpu_ref operations for
 registered files in IOPOLL mode
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20201117061723.18131-1-xiaoguang.wang@linux.alibaba.com>
 <20201117061723.18131-3-xiaoguang.wang@linux.alibaba.com>
 <8e597c50-b6f4-ea08-0885-56d5a608a4ca@gmail.com>
 <9713dc32-8aea-5fd2-8195-45ceedcb74dd@kernel.dk>
 <82116595-2e57-525b-0619-2d71e874bd88@gmail.com>
 <148a36f1-ff60-4af6-7683-8849c9973010@kernel.dk>
 <f8e59ed9-4329-dada-cf16-329bdb7335be@gmail.com>
 <12c010e5-d298-c48a-1841-ff0da39e2306@kernel.dk>
 <2a1f4d77-87f4-fe50-b747-8f1be1945b55@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <9e325c66-1b55-6ef9-6fac-cca7b00cda1f@gmail.com>
Date:   Wed, 18 Nov 2020 15:52:05 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <2a1f4d77-87f4-fe50-b747-8f1be1945b55@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 18/11/2020 15:36, Xiaoguang Wang wrote:
>> On 11/18/20 6:59 AM, Pavel Begunkov wrote:
>> Ran it through the polled testing which is core limited, and I didn't
>> see any changes...
> Jens and Pavel, sorry for the noise...

Not at all, that's great you're trying all means to improve performance,
some are just don't worth the effort.

> I also have some tests today, in upstream kernel, I also don't see any changes,
> but in our internal 4.19 kernel, I got a steady about 1% iops improvement, and

hmm, 1% is actually a good result

> our kernel don't include Ming Lei's patch "2b0d3d3e4fcf percpu_ref: reduce memory
> footprint of percpu_ref in fast path".

-- 
Pavel Begunkov
