Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 214253BEA36
	for <lists+io-uring@lfdr.de>; Wed,  7 Jul 2021 17:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbhGGPEc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Jul 2021 11:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbhGGPEb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Jul 2021 11:04:31 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04AB3C061574
        for <io-uring@vger.kernel.org>; Wed,  7 Jul 2021 08:01:50 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id t24-20020a9d7f980000b029046f4a1a5ec4so2518588otp.1
        for <io-uring@vger.kernel.org>; Wed, 07 Jul 2021 08:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6t9MlTexAyqffAg1sXAEFN6t/hS/f3lKajvWWPkbehQ=;
        b=Ez1SiPN5bqU4qzH6upAlgggEoo8Hr9uxj7FQGe/wNrdpxKUq8JpDMyiDsFaPSLktpg
         VAquJ5jcFIarB9IRYrdiWXMqTUPe90Z1BEa+mgKVkdW1pi2Q0S4LRruKdd5qfdOfI9GP
         nkzGAMOJl29PQBuLua3OzmUDHKvqvZrnwa3jQ1iGaM/FH8GYJ0b4eSzZaJT4z/A02tPZ
         AC9jBSBnplNjZ7Ml2MA435x95eyYkpIjMxuR9iG/q+AaG9t7Da3AMPodw2pRCOElEdDt
         GYkqnLkwK2560F6vvSUP8vBOPZbE2x2e9E3T3L1GyPqIoBJ5IIoOf/g0e1SFjwtvb6k5
         NV1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6t9MlTexAyqffAg1sXAEFN6t/hS/f3lKajvWWPkbehQ=;
        b=ADJQjuKtl9ZA0FOpHjKW/yyNfItpGOagKlxAckTPn6GSW/70QnmQQ1RljYa7FIVgJY
         R7JANpvoeGWpRgcI/C87BTDCNd6TA8mdXt8esYPqPTZsNxV7is0+OG/zm/IyEmOpL9KT
         eF2MBWbkezn1GXLpMTi51YLdLAJsyNPcpZlVkhXzIu9nv+IoSZPDRIrcRpKsHJO4VOtt
         bvP0Q6T5dyvJwEt65JjazguENDhKmXqBraxDK6vioyJCBfQoZA9dNZRAHgisMzukdUL+
         xoV1ynhN5NRcxNbXfEhCrwTkk0My3XAa/lE5ZgHUB7fgRW+T8yZzTCKTwcWjWxO9mq8l
         V/Qg==
X-Gm-Message-State: AOAM532Sb7AOb/rnaXI4uqf48xiuL2ZBT79PCzZs4OPDAiqoNheYfPdh
        encwmFaL9nO5TDtFCIKZwlaXNEYAIi4W1Q==
X-Google-Smtp-Source: ABdhPJzjgs126XXFA6BcUwdBhC1gy+5Aw7zbW0VPPx4XILs/RxgDSqtfj5vlx1MaRjNUcz32PPHM9A==
X-Received: by 2002:a9d:6a93:: with SMTP id l19mr19292821otq.223.1625670108830;
        Wed, 07 Jul 2021 08:01:48 -0700 (PDT)
Received: from [192.168.1.170] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id v12sm191478otq.13.2021.07.07.08.01.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jul 2021 08:01:48 -0700 (PDT)
Subject: Re: [RFC 0/4] open/accept directly into io_uring fixed file table
To:     Stefan Metzmacher <metze@samba.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>
References: <cover.1625657451.git.asml.silence@gmail.com>
 <48bd91bc-ba1a-1e69-03a1-3d6f913f96c3@kernel.dk>
 <4accdfa5-36fc-7de8-f4b2-7609b6f9d8ee@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6db18003-bb72-daf7-f5e6-20f9e128ada3@kernel.dk>
Date:   Wed, 7 Jul 2021 09:01:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <4accdfa5-36fc-7de8-f4b2-7609b6f9d8ee@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/7/21 7:59 AM, Stefan Metzmacher wrote:
> Am 07.07.21 um 15:07 schrieb Jens Axboe:
>> On 7/7/21 5:39 AM, Pavel Begunkov wrote:
>>> Implement an old idea allowing open/accept io_uring requests to register
>>> a newly created file as a io_uring's fixed file instead of placing it
>>> into a task's file table. The switching is encoded in io_uring's SQEs
>>> by setting sqe->buf_index/file_index, so restricted to 2^16-1. Don't
>>> think we need more, but may be a good idea to scrap u32 somewhere
>>> instead.
>>>
>>> From the net side only needs a function doing __sys_accept4_file()
>>> but not installing fd, see 2/4.
>>>
>>> Only RFC for now, the new functionality is tested only for open yet.
>>> I hope we can remember the author of the idea to add attribution.
>>
>> Pretty sure the original suggester of this as Josh, CC'ed.
> 
> I also requested it for open :-)

Indeed! I honestly forget the details, as some of it is implementation
detail. I think Josh was the first to suggest a private fd table could
be used, but that's mostly implementation detail as the point was to be
able to know which fd would be assigned.

But I think we're all in agreement here, it's a nifty feature :-)

-- 
Jens Axboe

