Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B46701A2722
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2020 18:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730226AbgDHQ0L (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Apr 2020 12:26:11 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37781 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727931AbgDHQ0L (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Apr 2020 12:26:11 -0400
Received: by mail-pl1-f196.google.com with SMTP id x1so2695808plm.4
        for <io-uring@vger.kernel.org>; Wed, 08 Apr 2020 09:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gpmf4NB3/fbFPGGqIMoAxbwYWUITUwMfuGfQxKGNHzU=;
        b=xBBPMK5DNlX+dzy8cZY+HOF4l4ZJiT+psxcO5lthVL37BonMh9H7zLXGpYbk4UQr19
         f4zFa+Pl0vvNb58OdBDBEYSNLT1Yw3S6x8jmEuHU8bukWCoLG9pPb0Vyu2Lzlxa/KufG
         bMZpPfVIxo6y1h4zoMepYczaJaYOb+SI+uoBEqFnlXEAUoONbHn9EJ+6zpIPO0mGQOaf
         890JSUwoZSiiz9CHbSc4uUyjeaOC41WI8nwnsGYwgOQHS338BlAsOo+gAImkFz2gCT3F
         CrUORudjycVDlGSUfHmCxh44bnCNoKTmcA4ylOBBtrE1ByeSdhTLxXUCNOJylfKgZGvm
         2N+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gpmf4NB3/fbFPGGqIMoAxbwYWUITUwMfuGfQxKGNHzU=;
        b=tmc69+7nM0DvSZb1Ylq/r6bj6a3EDWyywdl+wmywJH0qIHhHQhNeWj1LtJs05aGpqC
         Lzv+fu3Muq5d6JKBAOJ8+dioTvKG6KO4iQ+cWVM5htv5B0KYp+9p9Lt9iTE3tuDWPhvk
         o+lwEQmzJcQ9b9BDCXbdjvVIDxzH9+0PMvxJul7RXMoD+QgmJWGCUbsRdBme+seoEIfj
         CH1rAaWMMEq6Re/CzZBOdE/iSn6XPW/z4+z0/8TecG7AMmFQRZXCsJTqSeHCiSKdTD6X
         6qDIsM3hDRqfqCLIx5NzKJpan31c2twa9qvtqgm/gFGdN2Cm4cPn2YjTfBwCqtur8/w8
         +NpQ==
X-Gm-Message-State: AGi0Puav5K34FxzduMXjIFiDhhzIvow/aoDncF65rBW0mw6OVbni4dll
        JwoaxlC4y8lw8WPzTrPvcVvHgiOV/9/HgA==
X-Google-Smtp-Source: APiQypJrqvQT8LMAWkr4Fhi8wJy5aHqRCaFOW6gkMu5CWdt/VFueA7i8n7+JTh9no34kjmb+ebpmkA==
X-Received: by 2002:a17:902:8bc3:: with SMTP id r3mr7891788plo.220.1586363169820;
        Wed, 08 Apr 2020 09:26:09 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21c8::12dd? ([2620:10d:c090:400::5:607f])
        by smtp.gmail.com with ESMTPSA id y28sm17061119pfp.128.2020.04.08.09.26.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2020 09:26:09 -0700 (PDT)
Subject: Re: io_uring's openat doesn't work with large (2G+) files
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <CAOKbgA4K4FzxTEoHHYcoOAe6oNwFvGbzcfch2sDmicJvf3Ydwg@mail.gmail.com>
 <3a70c47f-d017-9f11-a41b-fa351e3906dc@kernel.dk>
 <CAOKbgA7Pf2K5o_CkAs2ShcNbV8dx75xZBfM8D1xZcLm5RjmLXA@mail.gmail.com>
 <cc076d44-8cd0-1f19-2e79-45d2f0c5ace3@kernel.dk>
 <CAOKbgA4xX60X+SCMZFL76u86Nyi0Gfe25BGJaqR700+-zw72Xw@mail.gmail.com>
 <47ce7e4b-42d9-326d-f15e-8273a7edda7a@kernel.dk>
 <CAOKbgA5BKLNMzam+tDCTames0=LwJmSX-_s=dwceAq-kcvwF6g@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7e3a9783-c124-4672-aab1-6ae7ce409887@kernel.dk>
Date:   Wed, 8 Apr 2020 09:26:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAOKbgA5BKLNMzam+tDCTames0=LwJmSX-_s=dwceAq-kcvwF6g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/8/20 9:12 AM, Dmitry Kadashev wrote:
> On Wed, Apr 8, 2020 at 10:49 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 4/8/20 8:41 AM, Dmitry Kadashev wrote:
>>> On Wed, Apr 8, 2020 at 10:36 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On 4/8/20 8:30 AM, Dmitry Kadashev wrote:
>>>>> On Wed, Apr 8, 2020 at 10:19 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>
>>>>>> On 4/8/20 7:51 AM, Dmitry Kadashev wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> io_uring's openat seems to produce FDs that are incompatible with
>>>>>>> large files (>2GB). If a file (smaller than 2GB) is opened using
>>>>>>> io_uring's openat then writes -- both using io_uring and just sync
>>>>>>> pwrite() -- past that threshold fail with EFBIG. If such a file is
>>>>>>> opened with sync openat, then both io_uring's writes and sync writes
>>>>>>> succeed. And if the file is larger than 2GB then io_uring's openat
>>>>>>> fails right away, while the sync one works.
>>>>>>>
>>>>>>> Kernel versions: 5.6.0-rc2, 5.6.0.
>>>>>>>
>>>>>>> A couple of reproducers attached, one demos successful open with
>>>>>>> failed writes afterwards, and another failing open (in comparison with
>>>>>>> sync  calls).
>>>>>>>
>>>>>>> The output of the former one for example:
>>>>>>>
>>>>>>> *** sync openat
>>>>>>> openat succeeded
>>>>>>> sync write at offset 0
>>>>>>> write succeeded
>>>>>>> sync write at offset 4294967296
>>>>>>> write succeeded
>>>>>>>
>>>>>>> *** sync openat
>>>>>>> openat succeeded
>>>>>>> io_uring write at offset 0
>>>>>>> write succeeded
>>>>>>> io_uring write at offset 4294967296
>>>>>>> write succeeded
>>>>>>>
>>>>>>> *** io_uring openat
>>>>>>> openat succeeded
>>>>>>> sync write at offset 0
>>>>>>> write succeeded
>>>>>>> sync write at offset 4294967296
>>>>>>> write failed: File too large
>>>>>>>
>>>>>>> *** io_uring openat
>>>>>>> openat succeeded
>>>>>>> io_uring write at offset 0
>>>>>>> write succeeded
>>>>>>> io_uring write at offset 4294967296
>>>>>>> write failed: File too large
>>>>>>
>>>>>> Can you try with this one? Seems like only openat2 gets it set,
>>>>>> not openat...
>>>>>
>>>>> I've tried specifying O_LARGEFILE explicitly, that did not change the
>>>>> behavior. Is this good enough? Much faster for me to check this way
>>>>> that rebuilding the kernel. But if necessary I can do that.
>>>>
>>>> Not sure O_LARGEFILE settings is going to do it for x86-64, the patch
>>>> should fix it though. Might have worked on 32-bit, though.
>>>
>>> OK, will test.
>>
>> Great, thanks. FWIW, tested here, and it works for me.
> 
> Great, will post results tomorrow.

Thanks!

>> Any objection to adding your test cases to the liburing regression
>> suite?
> 
> Feel free to!

Great, done!

-- 
Jens Axboe

