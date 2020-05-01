Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0BE1C106F
	for <lists+io-uring@lfdr.de>; Fri,  1 May 2020 11:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728365AbgEAJjx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 May 2020 05:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728236AbgEAJjx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 May 2020 05:39:53 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA55EC08E859;
        Fri,  1 May 2020 02:39:52 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id e26so5398478wmk.5;
        Fri, 01 May 2020 02:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:references:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AY7jQHhwKy0m8fYEfOzQ4txFVzKK3a64+y00TkYY2Vs=;
        b=d9LQZ20ToCDRYxBvGDtlFrz8wUWUDFkzjorQALXBSKkAnvZ7K0Fb3EPSTMUa3JvX1h
         bY0GyRT9kxrjrdRstJLq0Ooyj//h7dDJhxewmYGee8auFnUt5R3VmOWGMeC6ImyDu4Rs
         B0/+wsMOPtRLqQdF2rGxgUg8Ym5rRkxcDcKrzBksoM5BSjoNxHfEwYinIw5INPkzHTtQ
         v52RI574hQ3ZwoOmB53U8OyqVOWwlvMi5rd1LfjuLjCUQEHeiIZ/rX3EsOqFzF4g/ER/
         6Z3dxLcpBDwtBtg2ynb3MF6llR4wXFuQURkPeyfVaKrSoBFe8KmUfYpm4dtfiVvpLcXP
         7Uxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:references:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AY7jQHhwKy0m8fYEfOzQ4txFVzKK3a64+y00TkYY2Vs=;
        b=Q3Gw4MzICOzM20/vdsu9bXGbqu9S2lT9lo7wLyQxol9hDt5PfdZL3e4uPOzJO/wtMr
         hPP8AWJvF9mgoILpkbrNpAy9UXSNgcD3bt6P6SgK/9M31I7xOa6bNOpb5tjnKFgazkND
         YwMM/J8cyZ0FYro2IYXN1wJPhIyNH4bLIaNmZ77OGfeOO48Pdn6pCOPh3t+tlRtEO5P0
         zW1rfyWhJIOdOz/Bq39hSWVF3HRoYil75YBzLcFKFtWp5G95WnPAbkwV7HeUhiCwWlvm
         tu2N+HZh9eR99NSF/glhB1y71qxO6GuqnnezscfTJDJq+xEM0vmYUdIzzITDCvW/vBph
         HBdw==
X-Gm-Message-State: AGi0PuZyS6uvJdtD6JGYRVSKXAY09LqReaKvnIPOHAD3uCM6tZlmLAXl
        EsG41VbjwIipnEZIS+mBssz6ES06
X-Google-Smtp-Source: APiQypIAO27s2GnSljTDihnWml0cPP+DAMFkAPloU+bfIfMxIxhpjiGtWhnLokmX7yvM8i3rHlyaWw==
X-Received: by 2002:a1c:4985:: with SMTP id w127mr3148348wma.100.1588325991213;
        Fri, 01 May 2020 02:39:51 -0700 (PDT)
Received: from [192.168.43.180] ([109.126.131.64])
        by smtp.gmail.com with ESMTPSA id j11sm3501587wrr.62.2020.05.01.02.39.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 May 2020 02:39:50 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1588253029.git.asml.silence@gmail.com>
 <8665e87d-98f8-5973-d11a-03cca3fdf66f@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 0/5] timeout fixes
Message-ID: <8d9b5e06-4100-c49a-c9ca-0efc389edaf3@gmail.com>
Date:   Fri, 1 May 2020 12:38:47 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <8665e87d-98f8-5973-d11a-03cca3fdf66f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 01/05/2020 11:21, Pavel Begunkov wrote:
> On 30/04/2020 22:31, Pavel Begunkov wrote:
>> [1,2] are small random patches.
>> [3,4] are the last 2 timeout patches, but with 1 var renamed.
>> [5] fixes a timeout problem related to batched CQ commits. From
>> what I see, this should be the last fixing timeouts.
> 
> Something gone wrong with testing or rebasing. Never mind this.

io_uring-5.7 hangs the first test in link_timeout.c. I'll debug it today,
but by any chance, does anyone happen to know something?

> 
>>
>> Pavel Begunkov (5):
>>   io_uring: check non-sync defer_list carefully
>>   io_uring: pass nxt from sync_file_range()
>>   io_uring: trigger timeout after any sqe->off CQEs
>>   io_uring: don't trigger timeout with another t-out
>>   io_uring: fix timeout offset with batch CQ commit
>>
>>  fs/io_uring.c | 130 +++++++++++++++++++++-----------------------------
>>  1 file changed, 54 insertions(+), 76 deletions(-)
>>
> 

-- 
Pavel Begunkov
