Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8593A31156C
	for <lists+io-uring@lfdr.de>; Fri,  5 Feb 2021 23:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbhBEWb1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Feb 2021 17:31:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbhBEORn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Feb 2021 09:17:43 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF38BC06121C
        for <io-uring@vger.kernel.org>; Fri,  5 Feb 2021 07:46:57 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id j11so6385151wmi.3
        for <io-uring@vger.kernel.org>; Fri, 05 Feb 2021 07:46:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XxnI7IbvrX6SA3yfl9clubZcoBGS4fmVLBKRx3Yy6uQ=;
        b=RKacj99q9NG1gtPIRQUEsyIA35+h2ARMefoERrd5n0MGz0P39p0hzd8VYGm0D4VFEx
         ApixphqkOlBd7px9SrMI63PZp/hPGjIk0DJfVkuGBLZmtqnpjwcNTxAj2PetFl/gTCUk
         bRYmyfrpC1EFmh3WcnaleHyxQoGfBs7cc8ZrBx4ssJo+7zxSoAH91DayF4JDR1RnUMWv
         ruOO3xVoocx8krSl7rErl7hhVaHUJLoC6OqnH4WUIX0p4MXV8dgfXa6Ti58j9cdBJPL0
         cXAm8aPV6Qzjf4oW8u4la78zyhPIYlkDfXq1sx1m5hUdlwEMfuMZNFEAlsNZORlrNL3p
         HNoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=XxnI7IbvrX6SA3yfl9clubZcoBGS4fmVLBKRx3Yy6uQ=;
        b=JPO1yq1BBbyRF4Bp+GdHTy5YAuZZy1UBhimhnLHpQ5rHPjqXGa83o6xeRI+0cYxj9X
         Hppty5kmitf6ilSVKfx8ey1YNsdNqNb3MmZAmavxxq/vYGNXBQ3394QzC2F1Zr62MC70
         n0SgPE2Kyxw7D8AafN+hc06/KLl4+miMdo/fraUTg4Bnf9VSHKetjt8sdgZLPTDHEJha
         9vJmcPnYufDUb6HpXVIJfzdlCE2c8yOHvz4tibT/eidOJ/ex37pmI4/PpooGJU9I+Yj1
         O+pI0+zanJvH3KnrQyoW6nMAngMc4z01QbaRQmCROGIaQ4DqvXKgDGKVCalfqJucpGMv
         QYhg==
X-Gm-Message-State: AOAM531ED8D4GY9ubPrEYVOg/OS+1JWrpemedV9cLzEaKslJTUPtLsSA
        BJjWv+Xbrkly8KzrcnXehAvfSjTSuFzHZg==
X-Google-Smtp-Source: ABdhPJwfz4e/2LbhW/dWpua+R3CGHFvXDKj0+hhfPxVie51Qhr4N2RR5GRqzjvuXkSSlkNB0upTRaQ==
X-Received: by 2002:a1c:b782:: with SMTP id h124mr3964965wmf.67.1612536815247;
        Fri, 05 Feb 2021 06:53:35 -0800 (PST)
Received: from [192.168.8.177] ([85.255.234.168])
        by smtp.gmail.com with ESMTPSA id i15sm8238425wmq.26.2021.02.05.06.53.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Feb 2021 06:53:34 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, Victor Stewart <v@nametag.social>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <CAM1kxwhCXpTCRjZ5tc_TPADTK3EFeWHD369wr8WV4nH8+M_thg@mail.gmail.com>
 <49743b61-3777-f152-e1d5-128a53803bcd@gmail.com>
 <c41e9907-d530-5d2a-7e1f-cf262d86568c@gmail.com>
 <CAM1kxwj6Cdqi0hJFNtGFvK=g=KoNRPMmLVoxtahFKZsjOkcTKQ@mail.gmail.com>
 <CAM1kxwg7wkB7Sj8CDi9RkssM5DwFXEFWeUcakUkpKtKVCOUSJQ@mail.gmail.com>
 <4b44f4e1-c039-a6b6-711f-22952ce1abfb@kernel.dk>
 <CAM1kxwgPW5Up-YqQWdh_cG4jvc5RWsD4UYNWN-jRRbWq5ide5g@mail.gmail.com>
 <06ceae30-7221-80e9-13e3-148cdf5e3c9f@kernel.dk>
 <8d75bf78-7361-0649-e5a3-1288fea1197f@gmail.com>
 <bb75dec2-2700-58ed-065e-a533994d3df7@gmail.com>
 <725fa06a-da7e-9918-49b4-7489672ff0b4@kernel.dk>
 <5c3d084f-88e4-3e86-3560-95d90bb9ffcd@gmail.com>
 <39bc0ff3-db02-8fc7-da5c-b2f5f0fc715e@gmail.com>
 <ab870cb5-513d-420e-6438-b918f9f6c453@kernel.dk>
 <c9550dcf-ce53-c214-8c4b-6165ad6605a9@gmail.com>
 <8349a07b-6975-dc55-dc0a-a4228f913af3@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: bug with fastpoll accept and sqpoll + IOSQE_FIXED_FILE
Message-ID: <3ec34352-5f75-85cd-6b9c-52b45f534263@gmail.com>
Date:   Fri, 5 Feb 2021 14:49:50 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <8349a07b-6975-dc55-dc0a-a4228f913af3@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 05/02/2021 14:42, Jens Axboe wrote:
> On 2/5/21 5:46 AM, Pavel Begunkov wrote:
>> On 04/02/2021 16:50, Jens Axboe wrote:
[...]
>>> Hence my suggestion is to just patch this in a trivial kind of fashion,
>>> even if it doesn't really make the function any prettier. But it'll be
>>> safer for a release, and then we can rework the function after.
>>>	
>>> With that in mind, here's my suggestion. The premise is if we go through
>>> the loop and don't do io_uring_enter(), then there's no point in
>>> continuing. That's the trivial fix.
>>
>> Your idea but imho cleaner below.
>> +1 comment inline
> 
> Shouldn't be hard, it was just a quick hack :-)

Yes, hopefully. That comment came straight from my ever failing
attempts to clean it up :) We will need to test well the final
version -- with and without IORING_FEAT_EXT_ARG.

[...]
>> diff --git a/src/queue.c b/src/queue.c
>> index 94f791e..7d6f31d 100644
>> --- a/src/queue.c
>> +++ b/src/queue.c
>> @@ -112,11 +112,15 @@ static int _io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_pt
>>  			flags = IORING_ENTER_GETEVENTS | data->get_flags;
>>  		if (data->submit)
>>  			sq_ring_needs_enter(ring, &flags);
>> -		if (data->wait_nr > nr_available || data->submit ||
>> -		    cq_overflow_flush)
>> -			ret = __sys_io_uring_enter2(ring->ring_fd, data->submit,
>> -					data->wait_nr, flags, data->arg,
>> -					data->sz);
>> +
>> +		if (data->wait_nr <= nr_available && !data->submit &&
>> +		    !cq_overflow_flush) {
>> +			err = ?;
> 
> which I guess is the actual error missing from here?

As a way to say "not tested at all". I just believe it's not all to that.

e.g. user calls wait/peek(nr=1, cqe);
__io_uring_peek_cqe() well succeeds, then

if (data->wait_nr && cqe)
	data->wait_nr--;

That might make us to skip enter, and we return -EAGAIN. 


> 
>> +			break;
>> +		}
>> +		ret = __sys_io_uring_enter2(ring->ring_fd, data->submit,
>> +				data->wait_nr, flags, data->arg,
>> +				data->sz);
>>  		if (ret < 0) {
>>  			err = -errno;
>>  		} else if (ret == (int)data->submit) {
>>

-- 
Pavel Begunkov
