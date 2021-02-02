Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E5B30CD48
	for <lists+io-uring@lfdr.de>; Tue,  2 Feb 2021 21:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbhBBUtD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Feb 2021 15:49:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbhBBUtC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Feb 2021 15:49:02 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B55B1C0613D6
        for <io-uring@vger.kernel.org>; Tue,  2 Feb 2021 12:48:21 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id w14so15183329pfi.2
        for <io-uring@vger.kernel.org>; Tue, 02 Feb 2021 12:48:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CHepPzYA1uYs3L35Qk+fMUz2e+B+JWiYpKdAjNek53I=;
        b=SMzQl7kYsNq3W5b6dTXQaVrd2UoMblgfb2UtEIo5lwhAtDVI5K1ljLLfCaGtpl6HqJ
         nG/TfsvCi+taVcF2L+8Eb8uGN2PWx0Y59bwtwgqOmA40n9GBWJNiOXPSzUkTWIhe5Ubg
         3J6/QLwKWcBVPGY5CRymwPPJeaoz1e5KQEEXzo+/byZK9IizYVs7JJuo9xnPRGlFacCy
         +PNVrcVwMgeMVUz9rp7TSDV+tcOJ3lVIK3ZIz1SXlv5Zlt7G/hNW1Ln3wVp0LbNEBLVv
         /QGmxn9WzRtvqNjp4sBlC1dWzLZYEKFt1QV8w3GipVXvWs/SZae+PTyWLo1Mlj03AcBq
         Rd2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CHepPzYA1uYs3L35Qk+fMUz2e+B+JWiYpKdAjNek53I=;
        b=YGGPyRnC3ixtpfcbipUX9Vwc4EZSxLFN9UhpTagYzidgduEz4GXT91dhCVI0stiZPd
         C04EtY4B5abPi4zzqkI2Tbhr9leL64TpsRX0QTBpEbTg9+zbRao65bHWGQ1aydva+JJ4
         35b5aHViYXLEmqpjuYZLZFDArEWRlOSoRr43vJDAkad+ZX2PO6UuRbcHI3QlrfN94emo
         DTEhQBrRH/KhyfC575xVF8vnxwfdfxTSuofGAsJTU9U7VeP279e0gQHbPlsP8JGXbqyj
         bHymY851BvWZ9IeNh58jYujIddw1mmCJ8gZcX2369F6p29e7puD7608LcxuN1YyMKlX5
         Aedg==
X-Gm-Message-State: AOAM5333kB271eZ7vvxH+gtUHMTVfVshLFhPBdZ0JL7aqsA5pHqFakWh
        s8ALPqt+SF7GGiyKM1cxptarKucld7Z6xg==
X-Google-Smtp-Source: ABdhPJzc7sVssfUCccRVaAiwtkeFkrLmX24y7dAcJohyu3LIClaYjCieanFD4c8wX2dj+qS99IpEgQ==
X-Received: by 2002:a62:7c4e:0:b029:1b6:8641:1fb2 with SMTP id x75-20020a627c4e0000b02901b686411fb2mr23694761pfc.10.1612298900852;
        Tue, 02 Feb 2021 12:48:20 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id q132sm5116267pfq.171.2021.02.02.12.48.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 12:48:20 -0800 (PST)
Subject: Re: bug with fastpoll accept and sqpoll + IOSQE_FIXED_FILE
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Victor Stewart <v@nametag.social>
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
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <725fa06a-da7e-9918-49b4-7489672ff0b4@kernel.dk>
Date:   Tue, 2 Feb 2021 13:48:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <bb75dec2-2700-58ed-065e-a533994d3df7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/2/21 1:34 PM, Pavel Begunkov wrote:
> On 02/02/2021 17:41, Pavel Begunkov wrote:
>> On 02/02/2021 17:24, Jens Axboe wrote:
>>> On 2/2/21 10:10 AM, Victor Stewart wrote:
>>>>> Can you send the updated test app?
>>>>
>>>> https://gist.github.com/victorstewart/98814b65ed702c33480487c05b40eb56
>>>>
>>>> same link i just updated the same gist
>>>
>>> And how are you running it?
>>
>> with SQPOLL    with    FIXED FLAG -> FAILURE: failed with error = ???
>> 	-> io_uring_wait_cqe_timeout() strangely returns -1, (-EPERM??)
> 
> Ok, _io_uring_get_cqe() is just screwed twice
> 
> TL;DR
> we enter into it with submit=0, do an iteration, which decrements it,
> then a second iteration passes submit=-1, which is returned back by
> the kernel as a result and propagated back from liburing...

Yep, that's what I came up with too. We really just need a clear way
of knowing when to break out, and when to keep going. Eg if we've
done a loop and don't end up calling the system call, then there's
no point in continuing.

-- 
Jens Axboe

