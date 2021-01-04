Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A85E2E9BF7
	for <lists+io-uring@lfdr.de>; Mon,  4 Jan 2021 18:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbhADR1g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jan 2021 12:27:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbhADR1g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jan 2021 12:27:36 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E257BC061574;
        Mon,  4 Jan 2021 09:26:55 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id c133so19190460wme.4;
        Mon, 04 Jan 2021 09:26:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vhZcYxw85hQr217njjB88qNCX1pBfOIpilSgl/Wkqsk=;
        b=lIvmXiWTK3tUPBqWNrMOzheIsKhz7ZK+Gj2aSDsVfam72rOuxAWCFOkzIuJi0UsLxv
         xkwkBKgOZrfHKM85yWWIlww4h1ZvB7yUwzfOAux3kdtbgfSf7h8ivjwrcNh0p7y4HdNn
         8itAJ2XuJmi6vDeWNuCqW8VYRh4gv8hdJgmnQoEqKbIWb+Z4KEXZAwuMyoNLr4IZR8jI
         aTmi9sZmmEOpaM0ggqRxS6kazZP8OR3uyS96Lq6tPI2PfijJtUEAo1vQIINoegC9aWFy
         S6BEMFntgGhUvDevrkxH3KYGt7t5GANVjxTQL/cE9qrO2Ya1x8yU1lytKf1xWEgbON8c
         rbyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=vhZcYxw85hQr217njjB88qNCX1pBfOIpilSgl/Wkqsk=;
        b=R89yQVPBe9zPNaNQl9mzlOv6HbF/VlmlsMsVggmBS7xVQH/bKDC1G+tB1m6bRG/5Ro
         1aMbVgv/mIHDR2qyfroYXiu/G4Ehe1xSoFe8KTs1JZ28phRzLYTBgyDdjiu91HtSjSa4
         0H5SnLu62t91zlRxs0sq+R6vPhu6eWwSYWS34zjQ98Ag28bNLZsfLmE7F5F1RSNhtdrR
         6XggWy2CI+dZLI3DwbGgNXhhKWnVquN9wXcL9SNrdXTQ89GIdOPfOPDoEWuXWNr3bTVs
         BB+Ot7Q6/LESowPwk/25+6swQLHIh4mrRsikx3dRngz195xeUHVTAEDxlUhdyPYc0Q4Q
         qTdw==
X-Gm-Message-State: AOAM530gbRC2rybgYFCurWYF3oyFzyJSEi67AzJLEgxT/KrsgegYR3gA
        ZkSguTF79uIQd183DS4EAV0eSW+uqZSQr7w0
X-Google-Smtp-Source: ABdhPJwKi+A2PZ7gJsqOn5Ymq1PeYPvYx8txZ71YhsB/T4YTc39zWcuXj3Vp193rQV2REjlyyPEgXQ==
X-Received: by 2002:a7b:cf30:: with SMTP id m16mr27225859wmg.145.1609781214488;
        Mon, 04 Jan 2021 09:26:54 -0800 (PST)
Received: from [192.168.8.190] ([85.255.233.205])
        by smtp.gmail.com with ESMTPSA id n14sm5213wmi.1.2021.01.04.09.26.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jan 2021 09:26:54 -0800 (PST)
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Ming Lei <ming.lei@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org
References: <cover.1609461359.git.asml.silence@gmail.com>
 <b46b8c1943bbefcb90ea5c4dd9beaad8bbc15448.1609461359.git.asml.silence@gmail.com>
 <20210104163755.GA22407@casper.infradead.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v2 2/7] bvec/iter: disallow zero-length segment bvecs
Message-ID: <c535efd4-7c3d-22ab-9519-8bb34a10ae78@gmail.com>
Date:   Mon, 4 Jan 2021 17:23:24 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20210104163755.GA22407@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 04/01/2021 16:37, Matthew Wilcox wrote:
> On Sat, Jan 02, 2021 at 03:17:34PM +0000, Pavel Begunkov wrote:
>> --- a/Documentation/filesystems/porting.rst
>> +++ b/Documentation/filesystems/porting.rst
>> @@ -865,3 +865,10 @@ no matter what.  Everything is handled by the caller.
>>  
>>  clone_private_mount() returns a longterm mount now, so the proper destructor of
>>  its result is kern_unmount() or kern_unmount_array().
>> +
>> +---
>> +
>> +**mandatory**
>> +
>> +zero-length bvec segments are disallowed, they must be filtered out before
>> +passed on to an iterator.
> 
> Why are you putting this in filesystems/porting?  Filesystems don't usually

At least splice and a dozen of others do. As block apriori doesn't have them,
it's mainly addressed to fs + net. 

> generate bvecs ... there's nothing in this current series that stops them.

Yes, just mixing it with splice changes, which did all the work, looks
awkward to me. Would you suggest another segregation for the patches?

> I'd suggest Documentation/block/biovecs.rst or biodoc.rst (and frankly,
> biodoc.rst needs a good cleanup)

I'll add a note to biovecs.rst

-- 
Pavel Begunkov
