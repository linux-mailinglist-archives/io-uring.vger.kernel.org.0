Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3597D33FBB9
	for <lists+io-uring@lfdr.de>; Thu, 18 Mar 2021 00:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbhCQXMN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 19:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhCQXL5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Mar 2021 19:11:57 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72ACC06174A
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 16:11:56 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id j4-20020a05600c4104b029010c62bc1e20so2236474wmi.3
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 16:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GyDmWLSV4wWkwacuFG7iVhE0MIetkyHDZk38AqQZRuM=;
        b=uICBRok2X7jRaqTuUH3m0oOJPlCfvVb71zv80WSF4oueLzfh5CiHWBtJVin/tz1Vnz
         y4GxC71GwPg+qPzpteC76N44YXRedQMucYa+8MAZSBzkv4q4pmVXB/qAbhsMVUVDqecI
         C6xhNVknqPjCe6JQEdMbXUJtY/CEI9hUaahBokdpw1Nn7TNaa8kC4P95RFkQpcUqo1IC
         U2CIg34Up75D4I+DHzJ3AbyDxXHuIdNWdJcAUZX1BqJeSM9SB2v8lrxDBwiu/hynRbDw
         wsuehRyDq4uldqS8daSYnJ4Sv5TBNd3mYMQMz8XHkK16p5X++d1fPIKVpxljdUVUaGWg
         sUSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GyDmWLSV4wWkwacuFG7iVhE0MIetkyHDZk38AqQZRuM=;
        b=gd9blPyGlTEOgenKukoIEq7FkoKmn4lPnWu8ivkSlq2euD93mPzz4IDl3Au1o5+2AC
         sZmicIZSOrOamh6n+RuPtDYh4GTrZcLg+neruYxrztmGhIlKh6K4cicW+UWidxTTaP40
         drRmFzS4jpMoCKN/G5uqtTQ1iJvptOLAZJVyZVtJfaZ6gDHAxqKkAHZg5dGBGa+HQjgD
         BTol+00A/7mrOD1icw/NQ9VMsFARTVwPy4h5circ1oaeg/djb1qiSoLi09fesiu2jAPr
         TjM3YP2YsxWTX6BWGIR1vLJd/3gBpp1QNuTnS4MFDUAy0746n/T9u2mZIXMpOEWtN0Wc
         mwBw==
X-Gm-Message-State: AOAM533EwBsKi2bLhtgeuhpbIIzlMgYg5XS+M+GuL5lQ90Vm3kN7C8sF
        jIH+I3a5D4V7Q+UPNFEfMah9axQYwjDa7A==
X-Google-Smtp-Source: ABdhPJyjciPOC4R4lFEDXXGCMdrtA+bLhj4eTMA8IeN68GpJb77R+tvCyp7P+tQKKYlLUTy5wSovhA==
X-Received: by 2002:a05:600c:290a:: with SMTP id i10mr904178wmd.91.1616022714605;
        Wed, 17 Mar 2021 16:11:54 -0700 (PDT)
Received: from [192.168.8.168] ([185.69.144.156])
        by smtp.gmail.com with ESMTPSA id n6sm530091wrw.63.2021.03.17.16.11.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Mar 2021 16:11:46 -0700 (PDT)
Subject: Re: [PATCH 0/2] send[msg]()/recv[msg]() fixes/improvements
To:     Jens Axboe <axboe@kernel.dk>, Stefan Metzmacher <metze@samba.org>,
        io-uring@vger.kernel.org
References: <cover.1615908477.git.metze@samba.org>
 <47ae1117-0de3-47a9-26a2-80f92e242426@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <b2f00537-a8a3-9243-6990-d6708e7f7691@gmail.com>
Date:   Wed, 17 Mar 2021 23:07:47 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <47ae1117-0de3-47a9-26a2-80f92e242426@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 17/03/2021 22:36, Jens Axboe wrote:
> On 3/16/21 9:33 AM, Stefan Metzmacher wrote:
>> Hi,
>>
>> here're patches which fix linking of send[msg]()/recv[msg]() calls
>> and make sure io_uring_enter() never generate a SIGPIPE.

1/2 breaks userspace. Sounds like 2/2 might too, does it?

>>
>> Stefan Metzmacher (2):
>>   io_uring: call req_set_fail_links() on short send[msg]()/recv[msg]()
>>     calls
>>   io_uring: imply MSG_NOSIGNAL for send[msg]()/recv[msg]() calls
>>
>>  fs/io_uring.c | 24 ++++++++++++++++--------
>>  1 file changed, 16 insertions(+), 8 deletions(-)
> 
> Applied for 5.12, thanks.
> 

-- 
Pavel Begunkov
