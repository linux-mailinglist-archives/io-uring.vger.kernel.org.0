Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9FF61FEE06
	for <lists+io-uring@lfdr.de>; Thu, 18 Jun 2020 10:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbgFRIqv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Jun 2020 04:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728496AbgFRIqu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Jun 2020 04:46:50 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3AC1C06174E
        for <io-uring@vger.kernel.org>; Thu, 18 Jun 2020 01:46:49 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id r7so5166460wro.1
        for <io-uring@vger.kernel.org>; Thu, 18 Jun 2020 01:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lightnvm-io.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=pGnDJXtKWLgnAg2IYpy2p8BjxoQVNW7qIESt0st593I=;
        b=LmlpGVuN7mlTuO3Dr+tB3GDPKZgd7JsDvzZm8m/ZHSzntyuHkVmvAluS2YgrLnz1ga
         SCCXvCLLjEwnDveNhuJZXkHYRzEIwz6hFT2R1Aqrs2CoRp7vc0+tDn6I8b3JMz9OtVAw
         VBO/nk0Kho//o0jbSKAEuQde0cM+Y4nJGotjtukPZ2OnJYQNQAyhQt3iURJ9fUCRNcMY
         OQcyQxqZEdzCzPXG2nsq/k0wrRQm4Vws1MeH7Mz2AzOSXZSQVUmkfV0Ko5fFs/36fkdV
         Ts01XGXDvfWPL9P8TZU5oSTeGJOqZcI0AkVsZ+IMxaaVB1eb9YjhyiWsC4g6mKUA0z6u
         TUhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=pGnDJXtKWLgnAg2IYpy2p8BjxoQVNW7qIESt0st593I=;
        b=ThBhT9cgKYFPYIQMUmBIDt7mHHx0z6B2OpK14NIpA87NBGphYKX8gN4TU/Zkxh+NBu
         ULqFXYd5KHyZgD9rpgTzU4caW7cOoVxTgphS9FPQboOcwUIA6RgFbD/kTklG9s2imDUR
         MneiHzKe6axveaJTtczBr6XDbZfcyPHjKK2F8YqR1vLlLqERNalW68SCzU/8MxBKygil
         edF34v6B30no69YyGsnW+qi3N1NPiCpqnv6J+ZHEY6HTbd13IftQgCjTMC/VbGe3Rw4G
         IE9pquZuqujtKmY4jcU43u8KNoZPjyqmqGPhoHG0TWbsareCZuf5QXk2y5jJSaTzBbZs
         UqgA==
X-Gm-Message-State: AOAM532TOa9luTTDpV+ncnaxqXrUQSZf0G8bxIIp/6xZsO0wENvfxzdF
        V7rU5oJLOp85PS7RBY2DWq6BIg==
X-Google-Smtp-Source: ABdhPJwQKmr23B3EQGx+XylxHf9s5hvzqsXABEc1zdAsSvZlNgi68eOepgXEvF/Hz0HTAF8tD5aQQw==
X-Received: by 2002:a5d:55c2:: with SMTP id i2mr3423049wrw.225.1592470008628;
        Thu, 18 Jun 2020 01:46:48 -0700 (PDT)
Received: from [10.0.0.6] (xb932c246.cust.hiper.dk. [185.50.194.70])
        by smtp.gmail.com with ESMTPSA id m65sm2114654wmf.17.2020.06.18.01.46.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2020 01:46:48 -0700 (PDT)
Subject: Re: [PATCH 0/3] zone-append support in aio and io-uring
To:     =?UTF-8?Q?Javier_Gonz=c3=a1lez?= <javier@javigon.com>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, bcrl@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, selvakuma.s1@samsung.com,
        nj.shetty@samsung.com, Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <keith.busch@wdc.com>,
        Christoph Hellwig <hch@lst.de>
References: <CGME20200617172653epcas5p488de50090415eb802e62acc0e23d8812@epcas5p4.samsung.com>
 <1592414619-5646-1-git-send-email-joshi.k@samsung.com>
 <f503c488-fa00-4fe2-1ceb-7093ea429e45@lightnvm.io>
 <20200618082740.i4sfoi54aed6sxnk@mpHalley.local>
 <f9b820af-2b23-7bb4-f651-e6e1b3002ebf@lightnvm.io>
 <20200618083940.jzjtbfwwyyyhpnhs@mpHalley.local>
From:   =?UTF-8?Q?Matias_Bj=c3=b8rling?= <mb@lightnvm.io>
Message-ID: <01581df5-d1d0-2375-23b2-20fc34dcdefd@lightnvm.io>
Date:   Thu, 18 Jun 2020 10:46:48 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200618083940.jzjtbfwwyyyhpnhs@mpHalley.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 18/06/2020 10.39, Javier González wrote:
> On 18.06.2020 10:32, Matias Bjørling wrote:
>> On 18/06/2020 10.27, Javier González wrote:
>>> On 18.06.2020 10:04, Matias Bjørling wrote:
>>>> On 17/06/2020 19.23, Kanchan Joshi wrote:
>>>>> This patchset enables issuing zone-append using aio and io-uring 
>>>>> direct-io interface.
>>>>>
>>>>> For aio, this introduces opcode IOCB_CMD_ZONE_APPEND. Application 
>>>>> uses start LBA
>>>>> of the zone to issue append. On completion 'res2' field is used to 
>>>>> return
>>>>> zone-relative offset.
>>>>>
>>>>> For io-uring, this introduces three opcodes: 
>>>>> IORING_OP_ZONE_APPEND/APPENDV/APPENDV_FIXED.
>>>>> Since io_uring does not have aio-like res2, cqe->flags are 
>>>>> repurposed to return zone-relative offset
>>>>
>>>> Please provide a pointers to applications that are updated and 
>>>> ready to take advantage of zone append.
>>>
>>> Good point. We are posting a RFC with fio support for append. We wanted
>>> to start the conversation here before.
>>>
>>> We can post a fork for improve the reviews in V2.
>>
>> Christoph's response points that it is not exactly clear how this 
>> matches with the POSIX API.
>
> Yes. We will address this.
>>
>> fio support is great - but I was thinking along the lines of 
>> applications that not only benchmark performance. fio should be part 
>> of the supported applications, but should not be the sole reason the 
>> API is added.
>
> Agree. It is a process with different steps. We definitely want to have
> the right kernel interface before pushing any changes to libraries and /
> or applications. These will come as the interface becomes more stable.
>
> To start with xNVMe will be leveraging this new path. A number of
> customers are leveraging the xNVMe API for their applications already.

Heh, let me be even more specific - open-source applications, that is 
outside of fio (or any other benchmarking application), and libraries 
that acts as a mediator between two APIs.


