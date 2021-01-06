Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0AD22EC634
	for <lists+io-uring@lfdr.de>; Wed,  6 Jan 2021 23:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbhAFW1K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Jan 2021 17:27:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbhAFW1J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Jan 2021 17:27:09 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889ADC061757
        for <io-uring@vger.kernel.org>; Wed,  6 Jan 2021 14:26:29 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id 3so3905113wmg.4
        for <io-uring@vger.kernel.org>; Wed, 06 Jan 2021 14:26:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rzc66fRl6hW54Pz+r8f5pIdm4IRkpDJkxPXVKiqABjo=;
        b=VICU+DyVLPu+EqP64NdDBYMExWy77K6Ze6vtKIPwXg+16gU6iZbJXaV9s8nBdPjPT9
         3EpvyK63OPh3SD0RwWt8UIHQlOVtFaaRBltvS1LmbiEX7AZe92I/wDRifPXpVGCIU/ey
         IG56y4nh0Gk1a2ORNutc8v1H2vg7JY9DSdiVzqubRPObkpbAG9LTbRLovq/qv7TDaXOC
         Zmc+5UDO1sb5LsqT9hyl9ZttNY5AZpV1x0Dkw7y9pcnlnv9d3YVPvncBnn4+4KzrWWJf
         Zeup2nRecEvNrjLsRl5IpnHZxQnzh2gsJjijA0uNvoeUXgbtdF6J9rJskDgtXJ3O7JUk
         Le1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rzc66fRl6hW54Pz+r8f5pIdm4IRkpDJkxPXVKiqABjo=;
        b=k/YmVjx3s/QhbQfY0nr23cdKL2GCHNdMueyAkIWC8jtQwX3uxoPaDiOFJkziW7HiHT
         FFxy5ueBj9TNdhTC+RrBlnXhCCfiOMguOIcTyWnoJFLE1GB5CtX2YF7nj9I2WHBIoa2G
         ifFNWF+DdWHYE4OylBTxRBsYW7TBMypYy+8f+cDpJJAevjXkt9uoJFilZRYJGNJAxu8G
         yKXCoAcgjSSuxKJuXtd58RrzlyNKX7qiOTBmt/enhI0/RFuLkvUCSKsbC2lUwuTuNAtv
         7z5WOAe3KTmKMdgpHnauixMxt1HEPF1KwDw24sQX8S5APcATcNgKQQtWbbqZ3DoGvwX0
         SRRg==
X-Gm-Message-State: AOAM530htJMqz0Tq/7qB1zTkNrrTLP4b52IW0i49pIPaSBtqnndDosgi
        Q+WA+HBSVI5ZpPxvkL30nmK7s9FXoCUuoQ==
X-Google-Smtp-Source: ABdhPJyTXFk2sRgyewA9Q3xu8AY2Cbb70C4sqqLbG7dycsH3Alo3Vyp8TP0ZpQIxzkEeNsneqSb/XQ==
X-Received: by 2002:a1c:a9c4:: with SMTP id s187mr5557214wme.116.1609971988104;
        Wed, 06 Jan 2021 14:26:28 -0800 (PST)
Received: from [192.168.8.102] ([185.69.144.125])
        by smtp.gmail.com with ESMTPSA id z21sm4494401wmk.20.2021.01.06.14.26.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 14:26:27 -0800 (PST)
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org
References: <1608314848-67329-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1608314848-67329-9-git-send-email-bijan.mottahedeh@oracle.com>
 <f0bff3b0-f27e-80fe-9a58-dfeb347a7e61@gmail.com>
 <c982a4ea-e39f-d8e0-1fc7-27086395ea9a@oracle.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v3 08/13] io_uring: implement fixed buffers registration
 similar to fixed files
Message-ID: <2be9eefb-4353-9951-f6b6-fbd1d9735ae8@gmail.com>
Date:   Wed, 6 Jan 2021 22:22:57 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <c982a4ea-e39f-d8e0-1fc7-27086395ea9a@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 06/01/2021 19:46, Bijan Mottahedeh wrote:
> On 1/4/2021 6:43 PM, Pavel Begunkov wrote:
>> On 18/12/2020 18:07, Bijan Mottahedeh wrote:
>>> Apply fixed_rsrc functionality for fixed buffers support.
>>
>> git generated a pretty messy diff...
> 
> I had tried to break this up a few ways but it didn't work well because I think most of the code changes depend on the io_uring structure changes.  I can look again or if you some idea of how you want to split it, I can do that.

Nah, that's fine, I just may have missed something
without applying it.

> 
>> Because it's do quiesce, fixed read/write access buffers from asynchronous
>> contexts without synchronisation. That won't work anymore, so
>>
>> 1. either we save it in advance, that would require extra req_async
>> allocation for linked fixed rw
>>
>> 2. or synchronise whenever async. But that would mean that a request
>> may get and do IO on two different buffers, that's rotten.
>>
>> 3. do mixed -- lazy, but if do IO then alloc.
>>
>> 3.5 also "synchronise" there would mean uring_lock, that's not welcome,
>> but we can probably do rcu.
> 
> Are you referring to a case where a fixed buffer request can be submitted from async context while those buffers are being unregistered, or something like that?

Yes, io_import_fixed() called from io-wq, and in parallel with
unregister/etc. That may happen in many cases, e.g. linked reqs
or IOSQE_ASYNC.


-- 
Pavel Begunkov
