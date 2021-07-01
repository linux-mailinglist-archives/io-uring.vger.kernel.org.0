Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDFFE3B9360
	for <lists+io-uring@lfdr.de>; Thu,  1 Jul 2021 16:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232845AbhGAOek (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Jul 2021 10:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232842AbhGAOek (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Jul 2021 10:34:40 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D88C061762
        for <io-uring@vger.kernel.org>; Thu,  1 Jul 2021 07:32:08 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id a13so8494288wrf.10
        for <io-uring@vger.kernel.org>; Thu, 01 Jul 2021 07:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vZPfu+McdUJJnbeqO1HPPa87zFjsLX9qdlich32wBKU=;
        b=Eth7oQ/GvFdrzDVdfFaHa4EDjl6T3P99tLDa7EWjB1n9QuxzoMkEC/I+C6r6JeBlQO
         MMiLkaA6M+JB45c/kuLNn1hfgSlRi7wIC0kYAveKdbwfO3V5Yd7PApf7UrpnYrjBl3km
         xOHiXOHrBDqMqxguW8HtZZjx8lOUV+FIK3ii7OO00x4T55Mxpgbc/H1ivh3sq6YRNOb4
         r36qNF4LRoJHDD1NFsx1Y1AoCc9MmPQUHMDUJ6aNJYIVBNqL9oAy22ACa1T2mAmfU3RS
         Jh/q2IoRtik/d+T5o9RlOUF30FOXx6YlmGWw0qzVoxfWp50rKki+1KsC8GCRNZP8xyDs
         +tHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vZPfu+McdUJJnbeqO1HPPa87zFjsLX9qdlich32wBKU=;
        b=Ee/CGE798Va4+ATNlFDMvXgGf5ivgYJGRDPcXqewvG3BcpKQeRcE5a4FZ3iToAeFIE
         9If+1oNUFH7W5SnLYV5MbXTcP2edP3ftpl9KwcBqo8CWmafcgjx/TFT7Z0HNcHT/BFZ5
         h/Pp/NSddOFZja4Liap3mlDdCCpuc+Fc5ik+ifmLts5JZHBBObLEgvMtxv1kurZpxmQR
         u92EawLe/q6RQINq46wldPGE9f4/3OHdrHoa939yF3CcL0vjDuDgYmkHzfnHr+T8Tz6w
         CbKQ/PHNJErlge0JSQTwHnimlCaryWhTobEyJEKU91MqguVFn4pWTclgtwhI+MP0APFy
         h2eA==
X-Gm-Message-State: AOAM532DGORA7/wupVcF4tc0fCRoGdLGLY2uKKXrUQozquIaBVIeeXDh
        2ybqYz09+L8ulb22lMnY2okhvT050oBCICDT
X-Google-Smtp-Source: ABdhPJyOJn9s0OgTsp69yntZq5HeX7lcKUaex1ZhIdBRZXJsUh22cUtt9hlT7454847Ka6pVkNVAYQ==
X-Received: by 2002:adf:ba07:: with SMTP id o7mr45867461wrg.160.1625149926891;
        Thu, 01 Jul 2021 07:32:06 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.185])
        by smtp.gmail.com with ESMTPSA id s8sm183557wmh.36.2021.07.01.07.32.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jul 2021 07:32:06 -0700 (PDT)
To:     Daniele Salvatore Albano <d.albano@gmail.com>
Cc:     Victor Stewart <v@nametag.social>,
        io-uring <io-uring@vger.kernel.org>
References: <CAM1kxwgU2V0RsE+77mRUg+mr6WL5PJpbFKh4FrEGOnfzZ5vZ3A@mail.gmail.com>
 <89a4bff4-958b-d1c0-8dc3-01aface97011@gmail.com>
 <CAKq9yRgJFU84ZqjA_05WBs9J5NQnH1c4G+NUXj41mV_v+wDJ5Q@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [Bug] io_uring_register_files_update broken
Message-ID: <5a3a7d8f-4719-8a36-d716-2a3a3bcee786@gmail.com>
Date:   Thu, 1 Jul 2021 15:31:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAKq9yRgJFU84ZqjA_05WBs9J5NQnH1c4G+NUXj41mV_v+wDJ5Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/1/21 3:01 PM, Daniele Salvatore Albano wrote:
> On Thu, 1 Jul 2021 at 00:28, Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 6/30/21 10:14 PM, Victor Stewart wrote:
>>> i'm fairly confident there is something broken with
>>> io_uring_register_files_update,
>>> especially the offset parameter.
>>>
>>> when trying to update a single fd, and getting a successful result of
>>> 1, proceeding
>>> operations with IOSQE_FIXED_FILE fail with -9. but if i update all of
>>> the fds with
>>> then my recv operations succeed, but close still fails with -9.
>>>
>>> on Clear LInux 5.12.13-1050.native
>>
>> Thanks for letting know, I'll take a look
>>

[...]

> I sent an email a while ago to raise a question about a potential bug
> related to close.
> 
> Looks like the close doesn't support registered files (although I saw
> some code within a patch from Jens to fix it while I was
> investigating).

It have never been supported, don't remember it being discussed to
be implemented at any point, and the links below are about
unrelated things.

If you want to close a fixed file, you can use
IORING_OP_FILES_UPDATE with fd=-1 instead. Easy enough to
add it to close, but not sure I see the reason for that considering
existence of IORING_OP_FILES_UPDATE.

fwiw, it doesn't sound related to Victor's report, but still need
to look at it.

> Attached below
> 
> On Fri, 21 May 2021 at 21:28, Daniele Salvatore Albano
> <d.albano@gmail.com> wrote:
>>
>> Hi,
>>
>> Is there any specific reason for which io_close_prep returns EBADF if
>> using REQ_F_FIXED_FILE?
>>
>> I discovered my software was failing to close sockets when using fixed
>> files a while ago but I put it to the side, initially thinking it was
>> a bug I introduced in my code.
>> In recent days I picked it up again and after investigating it, it
>> looks like that, instead, that's the expected behaviour.
>>
>> From what I see, although the behaviour was slightly changed with a
>> couple of commits (ie. with
>> https://github.com/torvalds/linux/commit/cf3040ca55f2085b0a372a620ee2cb93ae19b686
>> ) the io_close_prep have had this behaviour from the very beginning
>> https://github.com/torvalds/linux/commit/b5dba59e0cf7e2cc4d3b3b1ac5fe81ddf21959eb
>> .
>>
>> @Jens during my researches I have also found
>> https://lkml.org/lkml/2020/5/7/1575 where there is a patch that
>> allows, at least from what it looks like at a first glance, fixed
>> files with io_close_prep but seems that the email thread died there.
>>
>> Shouldn't the close op match the behaviour of the other I/O related
>> ops when it comes to fds?
>>
>> If there aren't specific reasons, happy to look into it and write a patch.
>>
>>
>> Thanks,
>> Daniele

-- 
Pavel Begunkov
