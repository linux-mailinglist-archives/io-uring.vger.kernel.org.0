Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 832D0439237
	for <lists+io-uring@lfdr.de>; Mon, 25 Oct 2021 11:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbhJYJYe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Oct 2021 05:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbhJYJYe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Oct 2021 05:24:34 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92542C061745
        for <io-uring@vger.kernel.org>; Mon, 25 Oct 2021 02:22:12 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id k2-20020a17090ac50200b001a218b956aaso3716278pjt.2
        for <io-uring@vger.kernel.org>; Mon, 25 Oct 2021 02:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Fn2tCQDCrtoNoz7SONAxXvm7qjF4Xg8lJsTDfxypotQ=;
        b=UdTeuofA1H0B7HxaGe9G+1LfWjE76nfpj0QF/VG3gTtfxLH6nU51jMsZ4jNBcMAGjt
         /uFQHcChxe288m7Rj7pPp3O/ycMczehjSZGgw3oIMcPgKJBIH/yVkCuVR7rwKHkkuUAG
         8ZgUMWffLP4GFuji6PQjiXOihW8/qKZVuiCLDhfJ3KIeO5GNLXb2fHsPVVTAgKcap0GU
         ngDBXrzyY0qDkUuyF14qsignTLV/3g9HcdvCoGBchqxjgBzB9BeSAs44gsgbA4q0FEJN
         Vi3gdyqlA5hqZsFvS+xGaPeVWR1EG2+P45uY0UAuu/wJ/Y1V52qzCAwM3UKC/cAGtSYM
         WSbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Fn2tCQDCrtoNoz7SONAxXvm7qjF4Xg8lJsTDfxypotQ=;
        b=kb10xqWkUeYQfTf8qdHMegEaDh86Ac2ppqpHvxDs6LKLWHP5CiyimZhgrV3Y3tB+Cp
         hKy3F6UTDDm1EKtZcynveexvhOqFiPiKlGnejBOTOSAGVDmSuy03DpA8RYM2Vvq6Ljof
         6dMDK7L8SSNMX98vP93zaAXke3+1hi888Wsmx9kLShycavA6GssSqJIN8aJwRPSJX3ry
         tcz78TRRCtoB9rTJmZrxpc4Txd9eTncQyIzgXCt1pp8F++Z+piiIYkfEI3c4IxHzqOV4
         sSlpEFpiY9DBzAGUIYqCImxrWCEIo4iZlL3MMlYRoCe2dZzYb0HDeZwWGiU7b0XYAbJt
         X3bA==
X-Gm-Message-State: AOAM533KVg8biRjlaITOKkFUzJj531o5hEtruDLD61Qtlb6VD0mKb3PF
        GjPQZ7syEi0u5fG6G3W1XFffnYANIuw=
X-Google-Smtp-Source: ABdhPJxmYQ/WwvAS11raQE8BfkskwE2yDQ5ZWuCFAtsb6Gi6ifYtIHGcMQpmJaLB8QBnFmf46X8Nfg==
X-Received: by 2002:a17:902:8b8b:b0:13d:e91c:a1b9 with SMTP id ay11-20020a1709028b8b00b0013de91ca1b9mr15408602plb.60.1635153732015;
        Mon, 25 Oct 2021 02:22:12 -0700 (PDT)
Received: from [192.168.1.122] ([122.181.48.19])
        by smtp.gmail.com with ESMTPSA id c17sm1613973pfv.145.2021.10.25.02.22.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 02:22:11 -0700 (PDT)
Message-ID: <872f0104-1640-a604-51a3-26162e526c4c@gmail.com>
Date:   Mon, 25 Oct 2021 14:52:08 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: io-uring
Content-Language: en-US
To:     Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
References: <e17b443e-621b-80be-03fd-520139bf3bdd@gmail.com>
 <4a8f1917-e5af-b4a8-9938-e129987adc92@kernel.dk>
 <31ae179c-818e-5232-f035-64047ede0d65@intel.com>
From:   Praveen Kumar <kpraveen.lkml@gmail.com>
In-Reply-To: <31ae179c-818e-5232-f035-64047ede0d65@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 24-10-2021 08:52, Ammar Faizi wrote:
> 
> On Sat, 23 Oct 2021 09:02:24 -0600, Jens Axboe wrote:
>> On 10/23/21 2:08 AM, Praveen Kumar wrote:
>>> Hello,
>>>
>>> I am Praveen and have worked on couple of projects in my professional
>>> experience, that includes File system driver and TCP stack
>>> development. I came across fs/io_uring.c and was interested to know
>>> more in-depth about the same and the use-cases, this solves. In
>>> similar regards, I read https://kernel.dk/io_uring.pdf and going
>>> through liburing. I'm interested to add value to this project.
>>>
>>> I didn't find any webpage or TODO items, which I can start looking
>>> upon. Please guide me and let me know if there are any small items to
>>> start with. Also, is there any irc channel or email group apart from
>>> io-uring@vger.kernel.org, where I can post my queries(design specific
>>> or others).
>>
>> Great that you are interested! It's quite a fast moving project, but
>> still plenty of things to tackle and improve. All discussion happens on
>> the io-uring mailing list, we don't have a more realtime communication
>> channel. Might make sense to setup a slack channel or something... But
>> for now I'd encourage you to just participate on the mailing list, and
>> question there are a good way to do it too.
>>
> 
> Hello,
> 
> We have several unresolved issues on liburing GitHub repo. Maybe they
> can be the TODO list?
> 
> Most of them are kernel side issue, so they need to be resolved from
> io_uring.
> 
> Link: https://github.com/axboe/liburing/issues

This is great info. Thanks.

> 
> I would love to contribute too. But my experience in kernel space
> programming is not yet ready for that. I can test the patches. I
> can also integrate the feature with liburing, create regression test,
> and some userspace stuff work.
> 
> Recently, I nudged this one:
>   https://github.com/axboe/liburing/issues/397
> 
> The work is to add recvfrom() and sendto() operation. You can CC me if
> you're willing to pick up this work. I can do the liburing part and
> create the test.
> 
That's great. Let me give a try to get hold on this specific issue and will CC you once I have some understanding built.

Regards,

~Praveen.

