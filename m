Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B13F642A74A
	for <lists+io-uring@lfdr.de>; Tue, 12 Oct 2021 16:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236637AbhJLOgb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Oct 2021 10:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235294AbhJLOga (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Oct 2021 10:36:30 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA0CC061745
        for <io-uring@vger.kernel.org>; Tue, 12 Oct 2021 07:34:28 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id r10so67654540wra.12
        for <io-uring@vger.kernel.org>; Tue, 12 Oct 2021 07:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=cYp8LZydVcQeykZTnrJO0cZQI3G1oglqNiX7x7/zSLo=;
        b=TCILSzyLPLdFJ8MDw2g8UwLg6XfqC6TrCO9BVQJjrY54DEn5OyeC0tOjyb7UhOtFMR
         Y4GPG/rBE7mjaN3rteKC35oo6LthnAVrAeq44b/fRBkmHYeGdHmUgsGRNiP33JLh7GYA
         O5i8yQQnTZ6KU6HoWKWBY25YldFbdW9skxGAbFWhNc+HGO+LhfWPYes/pQHSFAjf14nP
         CRy5shh3xEpWS1w820sbTTscD3I5H2DJxf4qCCcXJF0yP501jgda0/tu+GlRPOqrLE/V
         ceB9FIwdiusDPXza5Jt4/T5pw188iQUlCYuOFzgnIHsS98dh9Zuf6UlvrGlYR0nYGx3q
         qGnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=cYp8LZydVcQeykZTnrJO0cZQI3G1oglqNiX7x7/zSLo=;
        b=1J27c267e2C6wNcOQT09kc9WYX3sAkCaeWPZ+KD5uDIAEfxf4jfjIzrY7wspnPnR1T
         777SxuBE91qTvzFknOJbsiY+FPJuzWCsqFzA2OMZKZYw3G1lGlik2gRrMViIwC+omBuZ
         mYXJ7SvHoO+nMUPGGcSMie7n17ZY2lpfzKazv1RGLyuXoEKAdyXWsVkFFG0402UgT3yf
         SyCFlesLKFuB1mXReHwVzjmoaQzLRL3Iicg1+v4Qu0790aDkV6mnPwpvbNr27LEv/Xh8
         iW3MFWZrzIPhx/wskD284NEvI7vt9iGBzJ7zBttFxNX+iZ/U/vIXExQKowaiG1wCxTGy
         Umzw==
X-Gm-Message-State: AOAM532cMJ8uxYNmWEuA9thyro1bPog2pJcjeQklfDA7J0veyojUCD7m
        PJdTpBw6y+JW3aeN+urqMZ0=
X-Google-Smtp-Source: ABdhPJyiruwXcPCYGWzEJWww3Y7pyvxtqQpzmqhMEnM9vMdtICRVCSY80gV+Nxqh2sTM86d131hLCw==
X-Received: by 2002:adf:de0e:: with SMTP id b14mr25297816wrm.271.1634049267573;
        Tue, 12 Oct 2021 07:34:27 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.145.223])
        by smtp.gmail.com with ESMTPSA id n12sm3032375wms.27.2021.10.12.07.34.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 07:34:27 -0700 (PDT)
Message-ID: <4211b3d1-42a8-4528-2c72-7fddf3bddcf6@gmail.com>
Date:   Tue, 12 Oct 2021 15:33:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk
References: <20211012084811.29714-1-xiaoguang.wang@linux.alibaba.com>
 <20211012084811.29714-2-xiaoguang.wang@linux.alibaba.com>
 <7899b071-16cf-154d-3354-2211309c2949@gmail.com>
 <b08c5add-96cd-9b1a-0ac5-32a62cace9a4@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [RFC 1/1] io_uring: improve register file feature's usability
In-Reply-To: <b08c5add-96cd-9b1a-0ac5-32a62cace9a4@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/12/21 14:11, Xiaoguang Wang wrote:
>> On 10/12/21 09:48, Xiaoguang Wang wrote:
>>> The idea behind register file feature is good and straightforward, but
>>> there is a very big issue that it's hard to use for user apps. User apps
>>> need to bind slot info to file descriptor. For example, user app wants
>>> to register a file, then it first needs to find a free slot in register
>>> file infrastructure, that means user app needs to maintain slot info in
>>> userspace, which is a obvious burden for userspace developers.
>>
>> Slot allocation is specifically entirely given away to the userspace,
>> the userspace has more info and can use it more efficiently, e.g.
>> if there is only a small managed set of registered files they can
>> always have O(1) slot "lookup", and a couple of more use cases.
> 
> Can you explain more what is slot "lookup", thanks. For me, it seems that

I referred to nothing particular, just a way userspace finds a new index,
can be round robin or "index==fd".

> use fd as slot is the simplest and most efficient way, user does not need to> mange slot info at all in userspace.

As mentioned, it should be slightly more efficient to have a small table,
cache misses. Also, it's allocated with kvcalloc() so if it can't be
allocate physically contig memory it will set up virtual memory.

So, if the userspace has some other way of indexing files, small tables
are preferred. For instance if it operates with 1-2 files, or stores files
in an array and the index in the array may serve the purpose, or any other
way. Also, additional memory for those who care.

>> If userspace wants to mimic a fdtable into io_uring's registered table,
>> it's possible to do as is and without extra fdtable tracking
>>
>> fd = open();
>> io_uring_update_slot(off=fd, fd=fd);
> 
> No, currently it's hard to do above work, unless we register a big number of files initially.

If they intend to use a big number of files that's the way to go. They
can unregister/register if needed, usual grow factor=2  should make
it workable.

We may consider fast growing as a separate feature if really needed,
either as you did it, or even better doing it explicitly and separately
from updates.


> Say we call IORING_REGISTER_FILES to register 1000 files initially, then the io_uring
> 
> io_file_table only supports 1000 files, fd which is greater than 1000 will be not able to
> 
> be registered.
> 
> For safety,  you may need to register the number of getrlimit(RLIMIT_NOFILE) initially,
> 
> but it also may fail, user may change RLIMIT_NOFILE too. This is why I introduce a
> 
> io_uring io_file_table resize feature, but I agree this method may waste memory, for
> 
> example, user app only wants one file registered, but this file's fd is very large.

That's fine as long as it's optional

-- 
Pavel Begunkov
