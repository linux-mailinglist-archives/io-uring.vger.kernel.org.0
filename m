Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C96A21E1A0
	for <lists+io-uring@lfdr.de>; Mon, 13 Jul 2020 22:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgGMUrZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jul 2020 16:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgGMUrX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jul 2020 16:47:23 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D61BC061755
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 13:47:23 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id rk21so18969244ejb.2
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 13:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=w5RfTdmvihAQ+Btjumha1D1HMdCh7SQ4Dyp+UoBX2ho=;
        b=kD7IWzL+AiXVU1gIpC6KHsIxNj2+XVEL7yxhvx8WneMiYGG6z8ypzIJYsxrBLzibwH
         9RWDi/3vmQR6UXq7Lm1d7D5npX1C4YBH4Zcij8dVz43cx6v7RC+FArnOXJmBPZYZeLso
         uyw+h604l5m88aBMimogJdnwttPkIEPZqQ1RN34ptrAJmxADRb3dNdy8mbz15Xp8NCyI
         837s6xm6er11IH5bJzsMmHEM1Pn7KZgGi9Rbk93gqc89LT7N4GPPR0xiDQ2gT4sVbitL
         3FweNxLDM030vLzsREc+WxP2krfYBfxDNW4eTe4nAqTxHw8LmMFJoKAjHm2reRtkTZUL
         IQLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w5RfTdmvihAQ+Btjumha1D1HMdCh7SQ4Dyp+UoBX2ho=;
        b=T+eL/01GP4p1IFMbOTdrVIJGLoLUnN4e0rCTS2EWSBhV2IglvPATJjUTmJPKOAx+d1
         LGuT0ANsbDBZ5nCaZz8kfm17tWGwvkaUBc7OKdD2u2ZJUlBVtdy1JrtZYXT1QbL9Hu/M
         2dWV+Nawdxfm4Y9MuhK6nzkaa9TbC3nJYB2Wj8FUnUR0fhwJVkHz/rlQH8ivbNS5kTUU
         MGOHcEEHOvtuwsipu4/0LJDMQUQFRdySNzLUH+/gSyY0pNJCzFUKz7trTyKI69dXOpjU
         YaCksu9uvSAbiyV6sQm+Imb1QpSopcF7aew+Wxl8nsQJogX1qbHIoTyrdUgGn+3F4x8i
         6FqA==
X-Gm-Message-State: AOAM533ISITCu3j1+q/gO836uijEzMAjqmTBgTZqJTvLtohQmRsk2z02
        zhZ24usV/j9IvbxbOYQrLlKrLFo9
X-Google-Smtp-Source: ABdhPJzWfbbiN/KLtWA0SZpd3JQYYruioXNUY89TtYDDaJGflPBPXKNKbGycQkmxzUKn8x3mA6Yf9g==
X-Received: by 2002:a17:907:20ba:: with SMTP id pw26mr1432872ejb.425.1594673241759;
        Mon, 13 Jul 2020 13:47:21 -0700 (PDT)
Received: from [192.168.43.133] ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id p14sm12559675edr.23.2020.07.13.13.47.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2020 13:47:21 -0700 (PDT)
Subject: Re: [RFC 0/9] scrap 24 bytes from io_kiocb
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1594546078.git.asml.silence@gmail.com>
 <edfa9852-695d-d122-91f8-66a888b482c0@kernel.dk>
 <618bc9a5-420c-b176-df86-260734270f56@gmail.com>
 <3b3ee104-ee6b-7147-0677-bd0eb4efe76e@kernel.dk>
 <7368254d-1f2c-2cc9-1198-8a666f7f8864@gmail.com>
 <e1e53293-c57a-6c65-0e88-eb4414783f05@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <8776cf1b-c00d-26c3-7807-f76f8d9843de@gmail.com>
Date:   Mon, 13 Jul 2020 23:45:35 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <e1e53293-c57a-6c65-0e88-eb4414783f05@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 13/07/2020 17:12, Jens Axboe wrote:
> On 7/13/20 2:17 AM, Pavel Begunkov wrote:
>> On 12/07/2020 23:32, Jens Axboe wrote:
>>> On 7/12/20 11:34 AM, Pavel Begunkov wrote:
>>>> On 12/07/2020 18:59, Jens Axboe wrote:
>>>>> On 7/12/20 3:41 AM, Pavel Begunkov wrote:
>>>>>> Make io_kiocb slimmer by 24 bytes mainly by revising lists usage. The
>>>>>> drawback is adding extra kmalloc in draining path, but that's a slow
>>>>>> path, so meh. It also frees some space for the deferred completion path
>>>>>> if would be needed in the future, but the main idea here is to shrink it
>>>>>> to 3 cachelines in the end.
>>>>>>
>>>>>> I'm not happy yet with a few details, so that's not final, but it would
>>>>>> be lovely to hear some feedback.
>>>>>
>>>>> I think it looks pretty good, most of the changes are straight forward.
>>>>> Adding a completion entry that shares the submit space is a good idea,
>>>>> and really helps bring it together.
>>>>>
>>>>> From a quick look, the only part I'm not super crazy about is patch #3.
>>>>
>>>> Thanks!
>>>>
>>>>> I'd probably rather use a generic list name and not unionize the tw
>>>>> lists.
>>>>
>>>> I don't care much, but without compiler's help always have troubles
>>>> finding and distinguishing something as generic as "list".
>>>
>>> To me, it's easier to verify that we're doing the right thing when they
>>> use the same list member. Otherwise you have to cross reference two
>>> different names, easier to shoot yourself in the foot that way. So I'd
>>> prefer just retaining it as 'list' or something generic.
>>
>> If you don't have objections, I'll just leave it "inflight_entry". This
>> one is easy to grep.
> 
> Sure, don't have strong feelings on the actual name.
> 
>>>> BTW, I thought out how to bring it down to 3 cache lines, but that would
>>>> require taking io_wq_work out of io_kiocb and kmalloc'ing it on demand.
>>>> And there should also be a bunch of nice side effects like improving apoll.
>>>
>>> How would this work with the current use of io_wq_work as storage for
>>> whatever bits we're hanging on to? I guess it could work with a prep
>>> series first more cleanly separating it, though I do feel like we've
>>> been getting closer to that already.
>>
>> It's definitely not a single patch. I'm going to prepare a series for
>> discussion later, and then we'll see whether it worth it.
> 
> Definitely not. Let's flesh this one out first, then we can move on.

But not a lot of work either.
I've got a bit lost, do you mean to flesh out the idea or this
"loose 24 bytes" series?

-- 
Pavel Begunkov
