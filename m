Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D831F4B0F
	for <lists+io-uring@lfdr.de>; Wed, 10 Jun 2020 03:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbgFJBwJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Jun 2020 21:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbgFJBwI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Jun 2020 21:52:08 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1DFAC05BD1E
        for <io-uring@vger.kernel.org>; Tue,  9 Jun 2020 18:52:06 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id o6so265299pgh.2
        for <io-uring@vger.kernel.org>; Tue, 09 Jun 2020 18:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=u40D9fLGbbHbMocG51ZyIsizDJNY+PtGd22uoQn6TK0=;
        b=EjA7TyLhP1vllJgp5Fwz4J/OxYluFGePbukKjrCc/BRH71NASuBGRrZkwzpl5vPq20
         DdM4ulK4VRzRX/+W25k/2jWOCfZBHKTCpQRKKO/i9PI3+E5SG3AwDYu4EzY80aNnUxyu
         jMqwZsQUfSa/rkrgaaKng2CXvQXkIsiac7gyYbmhBXM9nQmDEUymT4QZaY2sEx8IoWco
         SIGq6LwcZvtnNtO8KxsRuYlXlyFUkrv0NDl6R5pWgN2AK9YH2PWf+9bmcDFTVVICO/lL
         yyuyRxVj615eYbXz1d7V617W32REgAMGvFmlbBWLkQ5zsOL78JDz4aF5Jb5S4PEqADlW
         nblQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u40D9fLGbbHbMocG51ZyIsizDJNY+PtGd22uoQn6TK0=;
        b=TCEWPTz5N4UdYdtOpEsSObLnbm1OMeHUyjfPO2k2oEwVUq14SwV0YL8kk2m4Vjck/F
         l0Dj6fhP/kpmPYLmutHOxUfDnWj9+t04mblR/kAuDROyYx7KGkfP/4P4EkNXujkCsm0+
         LRkxly3mi/ribFJK5YhBarvEAANLAHtMLBP9eEC/pcAx1cH27p5v7JnViHyMAFtl3tOZ
         jJDLkHp2RV426IdBHFZtb845dJMwLHz3ky0ru3yPhpK82liNgnMf7xAmSCc4idb+QjB2
         l5OMa3gSilxXg5tAMDH2wjHsL2W9kG6IkjsDFATVHURm082E8eTBF1UsgU5Fd0H+alKW
         7YVA==
X-Gm-Message-State: AOAM533HbqzqNZDq5hvmAN5KoDxHiDJFrYRm1IyETJxHw++j+tQOuCLK
        2943vbmgxCNWP87GX/XiMfjYoRSSZuQb4A==
X-Google-Smtp-Source: ABdhPJybyrcAsitu2KufOK/4WhRyQjGK1i3E2rIED+y/zllwOPEwd4tiLZ4ES/8MJkwUG4xo7maFbg==
X-Received: by 2002:a63:5b63:: with SMTP id l35mr728167pgm.34.1591753925119;
        Tue, 09 Jun 2020 18:52:05 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id b23sm9421045pgs.33.2020.06.09.18.52.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jun 2020 18:52:04 -0700 (PDT)
Subject: Re: IORING_OP_CLOSE fails on fd opened with O_PATH
To:     Clay Harris <bugs@claycon.org>
Cc:     io-uring@vger.kernel.org
References: <20200531124740.vbvc6ms7kzw447t2@ps29521.dreamhostps.com>
 <5d8c06cb-7505-e0c5-a7f4-507e7105ce5e@kernel.dk>
 <20200608112135.itxseus73zgqspys@ps29521.dreamhostps.com>
 <4e72f006-418d-91bc-1d6f-c15bce360575@kernel.dk>
 <20200609014014.6njp6fkjrcwrdqbt@ps29521.dreamhostps.com>
 <0cf0596b-4b5c-ddbe-75fa-7914fa995828@kernel.dk>
 <20200609051618.gh3zsgzc6gujsyer@ps29521.dreamhostps.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3d32906d-37c4-bf9b-72b2-67ddaac40440@kernel.dk>
Date:   Tue, 9 Jun 2020 19:52:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200609051618.gh3zsgzc6gujsyer@ps29521.dreamhostps.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/8/20 11:16 PM, Clay Harris wrote:
> On Mon, Jun 08 2020 at 20:14:51 -0600, Jens Axboe quoth thus:
> 
>> On 6/8/20 7:40 PM, Clay Harris wrote:
>>> On Mon, Jun 08 2020 at 14:19:56 -0600, Jens Axboe quoth thus:
>>>
>>>> On 6/8/20 5:21 AM, Clay Harris wrote:
>>>>> On Sun, May 31 2020 at 08:46:03 -0600, Jens Axboe quoth thus:
>>>>>
>>>>>> On 5/31/20 6:47 AM, Clay Harris wrote:
>>>>>>> Tested on kernel 5.6.14
>>>>>>>
>>>>>>> $ ./closetest closetest.c
>>>>>>>
>>>>>>> path closetest.c open on fd 3 with O_RDONLY
>>>>>>>  ---- io_uring close(3)
>>>>>>>  ---- ordinary close(3)
>>>>>>> ordinary close(3) failed, errno 9: Bad file descriptor
>>>>>>>
>>>>>>>
>>>>>>> $ ./closetest closetest.c opath
>>>>>>>
>>>>>>> path closetest.c open on fd 3 with O_PATH
>>>>>>>  ---- io_uring close(3)
>>>>>>> io_uring close() failed, errno 9: Bad file descriptor
>>>>>>>  ---- ordinary close(3)
>>>>>>> ordinary close(3) returned 0
>>>>>>
>>>>>> Can you include the test case, please? Should be an easy fix, but no
>>>>>> point rewriting a test case if I can avoid it...
>>>>>
>>>>> Sure.  Here's a cleaned-up test program.
>>>>> https://claycon.org/software/io_uring/tests/close_opath.c
>>>>
>>>> Thanks for sending this - but it's GPL v3, I can't take that. I'll
>>>> probably just add an O_PATH test case to the existing open-close test
>>>> cases.
>>>
>>> I didn't realize that would be an issue.
>>> I'll change it.  Would you prefer GPL 2, or should I just delete the
>>> license line altogether?
>>
>> It's not a huge deal, but at the same time I see no reason to add GPL
>> v3 unless I absolutely have to (and I don't). So yeah, if you could
>> just post with MIT (like the other test programs), then that'd be
>> preferable.
> 
> * Change license to MIT.
> Done.

Thanks, edited it to turn it into something that can be included as
a liburing regression test case.

-- 
Jens Axboe

