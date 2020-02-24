Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 329B616AA85
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 16:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbgBXPxq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 10:53:46 -0500
Received: from mail-il1-f174.google.com ([209.85.166.174]:32877 "EHLO
        mail-il1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727797AbgBXPxq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 10:53:46 -0500
Received: by mail-il1-f174.google.com with SMTP id s18so8126224iln.0
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 07:53:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SkkaG/HKG33UHMUOymAz3SvCmzZUIkPDCk1MbwygFZo=;
        b=JLMP7tNclDjObVFWCS6kno4qWZf48EwYdNp4z06uPD0NpPLjYl365Z4iDhfrTmR3BZ
         AxkZX0lzwUjtRzv4k43Mm3ElrETjab1liN44LZVA1lJ79DBohJAF72pxXfs5VJYH+VVU
         omvJ1bEKWhdYFO66GbBsRJao9TmOjis7I+erWfzaG+dUb9a+KsKbJAEAr6LqsmsQe1wV
         uUbHKnaMn8ywMdcxWE4v7KNwErvtZF24uAlRmUAOY8gveZkMN5qpJwdqgxouNXCMkH4k
         7Ege0Rvt+MTdql2lhMFYXEnezH4jdAahCUjNoWl9FRzAAaPinz8SRDvLqLdAQ71/Ezmv
         m5mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SkkaG/HKG33UHMUOymAz3SvCmzZUIkPDCk1MbwygFZo=;
        b=X7p+unHsYAiToq1wEaq/voHJC07vg+lPQnCzAmMDSzLYX9Ulw+ULhfF5NGk59a1Wx5
         kp2GUujalN6s2LY3r3kYJ2SNt430BkpJdUQ60ef23Fuv6yxVL7E3WZXeeaNYMPYJR3DK
         NtgYV5WRW8TE1m5TEykjNqRdm0hf4KWaQRn3Rt6FnNbjegaFllNThGhFfdlK0OyembH9
         bphu9RIkKU1v3IByU2Ot3ZmP7JnbTxUByH6GfVx8rw/lLy+rzJrqm9SxK1Tmlp2onJzo
         GD2biX5IGSAmHjiE9ypwhChnbd49fQxXl9GCD4697cdl2XC2AKqHk8qQ/BgIvFtAhxDt
         dhrQ==
X-Gm-Message-State: APjAAAWamCzqc4o75uumLgxL2duvFDavM/JaaIOEnxB6b9+HobEnQonf
        /eT16mA+GrIDBWc70l3RFng4xecvvs4=
X-Google-Smtp-Source: APXvYqxEJBTwQH871mjfy1lMP9GWXpyEQFhfsFe7vDySsnp7y4eDVj0XMORXu9RQen6EqyJn9VSwEw==
X-Received: by 2002:a92:844b:: with SMTP id l72mr58934515ild.262.1582559623869;
        Mon, 24 Feb 2020 07:53:43 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id i83sm4481057ilf.65.2020.02.24.07.53.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 07:53:43 -0800 (PST)
Subject: Re: Deduplicate io_*_prep calls?
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Andres Freund <andres@anarazel.de>
Cc:     io-uring@vger.kernel.org
References: <20200224010754.h7sr7xxspcbddcsj@alap3.anarazel.de>
 <b3c1489a-c95d-af41-3369-6fd79d6b259c@kernel.dk>
 <20200224033352.j6bsyrncd7z7eefq@alap3.anarazel.de>
 <90097a02-ade0-bc9a-bc00-54867f3c24bc@kernel.dk>
 <20200224071211.bar3aqgo76sznqd5@alap3.anarazel.de>
 <933f2211-d395-fa84-59ae-0b2e725df613@kernel.dk>
 <23a49bca-26a6-ddbd-480b-d7f3caa16c29@gmail.com>
 <065ee992-7eaf-051a-e8c5-9e0e8731b3f1@kernel.dk>
 <746b93f0-d0b5-558a-28c7-a614b2367d91@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c17acad2-89f6-b312-f591-c9e887b4fc2b@kernel.dk>
Date:   Mon, 24 Feb 2020 08:53:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <746b93f0-d0b5-558a-28c7-a614b2367d91@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/24/20 8:50 AM, Pavel Begunkov wrote:
> On 24/02/2020 18:46, Jens Axboe wrote:
>> On 2/24/20 8:44 AM, Pavel Begunkov wrote:
>>>> Fine like this, though easier if you inline the patches so it's easier
>>>> to comment on them.
>>>>
>>>> Agree that the first patch looks fine, though I don't quite see why
>>>> you want to pass in opcode as a separate argument as it's always
>>>> req->opcode. Seeing it separate makes me a bit nervous, thinking that
>>>> someone is reading it again from the sqe, or maybe not passing in
>>>> the right opcode for the given request. So that seems fragile and it
>>>> should go away.
>>>
>>> I suppose it's to hint a compiler, that opcode haven't been changed
>>> inside the first switch. And any compiler I used breaks analysis there
>>> pretty easy.  Optimising C is such a pain...
>>
>> But if the choice is between confusion/fragility/performance vs obvious
>> and safe, then I'll go with the latter every time. We should definitely
>> not pass in req and opcode separately.
> 
> Yep, and even better to go with the latter, and somehow hint, that it won't
> change. Though, never found a way to do that. Have any tricks in a sleeve?

We could make it const and just make the assignment a bit hackier... Apart
from that, don't have any tricks up my sleeve.

-- 
Jens Axboe

