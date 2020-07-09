Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0DA921A75D
	for <lists+io-uring@lfdr.de>; Thu,  9 Jul 2020 20:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgGISze (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jul 2020 14:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbgGISzd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jul 2020 14:55:33 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 438E2C08C5CE;
        Thu,  9 Jul 2020 11:55:33 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id z2so3497244wrp.2;
        Thu, 09 Jul 2020 11:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZWQkR/cdHEX/idT93FTs7op9XG66/r1l68vwm8AtW4Q=;
        b=t8VQvHq2IsjyH+L982eXLkXjoVH8HbAvy3seVHWfY6AyMt4HmMFZrtpM797p+WsM2h
         4Lvc4Lq3mt0M9ZfNStD/pPoHqhpia5K1WP70dyOErorAkakukyUGF3XVHSzBKytG+gYp
         hzDZS/mTCzPGv/J1RibqWdYp3NA/I90gLVwl21d1CFVDPBvgRB+30I+z524r1e/t4m5B
         X0v5wHh4JJclRqmlvDN2kTUgHh56TZP1VG3uMMTcg9++sCbDBef/VB+BtP+H79853VKh
         wLuQcZGndpa7uax+9UmNisdWx0Ohv6JrwyaZ/q/Pr+DE7i0kw7UAPMHMC9ovdxOdBrDD
         1/og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ZWQkR/cdHEX/idT93FTs7op9XG66/r1l68vwm8AtW4Q=;
        b=LdBdRVUHJH5IbxPlLRIzaFN1Zpg9HY5oKt33LXNtsw+Z4gTkS4uEwEBf/ZB6iyUyzA
         9sh1SK8ueeclxlJkcA4ViP/B1fjQOG+3l2YIM7IVkgo/qk89LbiSh5tQ+NqhaBmBv2SO
         0G6Ws17YPJ2ONvXZovngG8VLaS2ZsqLeAkhq6AbhS9SaAlLqlPXe/+ZxZM6cIGYPeOlN
         JOTEMoc+l4KfKHj1OBd9xKNb+LYL3VVuxvX4dma1n+Foeqd0linPJzrUCVmGoEZZjwi6
         x+d81RXVLtAAp3/zAYCd2E1513eoHqkUvycDiND4m0rOLSdUiFknriSf43GAAsNzlhiH
         7W0w==
X-Gm-Message-State: AOAM533hsvE8swBu5tk4TIggl2OcFOY3TRwp2AfXLCcZUJbEgBUhVl3u
        BW0rFJqSFcZ4fV2bFrFljz8=
X-Google-Smtp-Source: ABdhPJzCf8MphNlRjb3U5R+NihXICQOcT4MESC9eb0AG6V3FeuPjSDgpMDekaHvTi3Uc3ahAlBtAqg==
X-Received: by 2002:adf:efcc:: with SMTP id i12mr63734846wrp.349.1594320931977;
        Thu, 09 Jul 2020 11:55:31 -0700 (PDT)
Received: from [192.168.43.42] ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id u186sm6456409wmu.10.2020.07.09.11.55.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 11:55:31 -0700 (PDT)
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Kanchan Joshi <joshiiitr@gmail.com>, Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Kanchan Joshi <joshi.k@samsung.com>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, Damien.LeMoal@wdc.com,
        linux-fsdevel@vger.kernel.org,
        =?UTF-8?Q?Matias_Bj=c3=b8rling?= <mb@lightnvm.io>,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
References: <1593974870-18919-1-git-send-email-joshi.k@samsung.com>
 <CGME20200705185227epcas5p16fba3cb92561794b960184c89fdf2bb7@epcas5p1.samsung.com>
 <1593974870-18919-5-git-send-email-joshi.k@samsung.com>
 <fe0066b7-5380-43ee-20b2-c9b17ba18e4f@kernel.dk>
 <20200709085501.GA64935@infradead.org>
 <adc14700-8e95-10b2-d914-afa5029ae80c@kernel.dk>
 <20200709140053.GA7528@infradead.org>
 <2270907f-670c-5182-f4ec-9756dc645376@kernel.dk>
 <CA+1E3r+H7WEyfTufNz3xBQQynOVV-uD3myYynkfp7iU+D=Svuw@mail.gmail.com>
 <4c26deb4-65c6-57c0-2b51-02861ef8558c@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <a8af4a0e-f18e-2d5f-17a3-3bbc546559e3@gmail.com>
Date:   Thu, 9 Jul 2020 21:53:47 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <4c26deb4-65c6-57c0-2b51-02861ef8558c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 09/07/2020 21:50, Pavel Begunkov wrote:
> On 09/07/2020 21:36, Kanchan Joshi wrote:
>> On Thu, Jul 9, 2020 at 7:36 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> On 7/9/20 8:00 AM, Christoph Hellwig wrote:
>>>> On Thu, Jul 09, 2020 at 07:58:04AM -0600, Jens Axboe wrote:
>>>>>> We don't actually need any new field at all.  By the time the write
>>>>>> returned ki_pos contains the offset after the write, and the res
>>>>>> argument to ->ki_complete contains the amount of bytes written, which
>>>>>> allow us to trivially derive the starting position.
>>
>> Deriving starting position was not the purpose at all.
>> But yes, append-offset is not needed, for a different reason.
>> It was kept for uring specific handling. Completion-result from lower
>> layer was always coming to uring in ret2 via ki_complete(....,ret2).
>> And ret2 goes to CQE (and user-space) without any conversion in between.
>> For polled-completion, there is a short window when we get ret2 but cannot
>> write into CQE immediately, so thought of storing that in append_offset
>> (but should not have done, solving was possible without it).
> 
> fwiw, there are more cases when it's postponed.
> 
>> FWIW, if we move to indirect-offset approach, append_offset gets
>> eliminated automatically, because there is no need to write to CQE
>> itself.
> 
> Right, for the indirect approach we can write offset right after getting it.

Take it back, as you mentioned with task_work, we may need the right context.

BTW, there is one more way to get space for it, and it would also shed 8 bytes
from io_kiocb, but that would need some work to be done.

> If not, then it's somehow stored in an CQE, so may be placed into
> existing req->{result,cflags}, which mimic CQE's fields.
> 
>>
>>>>> Then let's just do that instead of jumping through hoops either
>>>>> justifying growing io_rw/io_kiocb or turning kiocb into a global
>>>>> completion thing.
>>>>
>>>> Unfortunately that is a totally separate issue - the in-kernel offset
>>>> can be trivially calculated.  But we still need to figure out a way to
>>>> pass it on to userspace.  The current patchset does that by abusing
>>>> the flags, which doesn't really work as the flags are way too small.
>>>> So we somewhere need to have an address to do the put_user to.
>>>
>>> Right, we're just trading the 'append_offset' for a 'copy_offset_here'
>>> pointer, which are stored in the same spot...
>>
>> The address needs to be stored somewhere. And there does not seem
>> other option but to use io_kiocb?
>> The bigger problem with address/indirect-offset is to be able to write to it
>> during completion as process-context is different. Will that require entering
>> into task_work_add() world, and may make it costly affair?
>>
>> Using flags have not been liked here, but given the upheaval involved so
>> far I have begun to feel - it was keeping things simple. Should it be
>> reconsidered?
>>
>>
>> --
>> Joshi
>>
> 

-- 
Pavel Begunkov
