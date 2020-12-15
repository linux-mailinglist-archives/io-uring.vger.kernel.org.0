Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F40E52DAE71
	for <lists+io-uring@lfdr.de>; Tue, 15 Dec 2020 15:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729134AbgLOOAh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Dec 2020 09:00:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727200AbgLOOA1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Dec 2020 09:00:27 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D33FC0617A6;
        Tue, 15 Dec 2020 05:59:47 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id e25so18588491wme.0;
        Tue, 15 Dec 2020 05:59:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xzFQ3fAAmyTrUxg6AtOBJwbOPrlweQwSN+UmczMjICw=;
        b=enJXGu6bN1ze2eKV1slYMB62l6gxp4DbOYF2ruxOTHRHRY+0PXa5OJLd5bPstfCZSA
         zyLBauA9dq7SgXfTH/wBwv/1HvkzxVx7bVmirWkQoZ+Fdq5u/dL3Kvy7Go09T5sbtWVV
         58MZy3owhyRxJ89VRTjachdprvecnW+w8zSsC7vphjEY/Pvw1Ff8mvUDfjvvquqSbNlF
         dVgAg3WCUdM5IJ9zC82N1T89U4MKuwlh5rc06WgJI7hcCU6c7y3S5X40k+a6qtH0M0iG
         wP3KlhkXivgMMi7MZXY+3Cvu/Q+0+aZexEr7AqZi7tl2i4HJ/AkmL7UgQ7Fjodh39mqY
         kzkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=xzFQ3fAAmyTrUxg6AtOBJwbOPrlweQwSN+UmczMjICw=;
        b=W9fUXsfU07qRbLYcFyIJ1KMrLQ3trH10IKdGLYe/HxV0b22YVoYZI5Ovga4zn3i9ly
         buqWc1d8FxRRdzcf2qSHbMrBgI+C5EKXMFQ/uqJvHQiNEnQZR1C0CXanVY0sEBejuQeY
         pXaVcgNgAilT136YD0OFGyV1/cOe6hfJ6ut2DwTYQyWY4NItp9GjepP8k6DHZYpSX2CA
         XgTTtMkmUQvCNogedVcMUycEHbcYc1gSLWceZ1ehFvWaT/mZ2EZ/1s52yfQ9IHtZZ4Ub
         XalNuy21R6Ax+M1WDYraZMFgz0n6Ma2JtWnDcCW1KQOH6Nm18OlX/mvIMxRETgJK83r9
         qYRw==
X-Gm-Message-State: AOAM533tR9LJNzXEbsimRDgaFVpiVqWd73tZiDwa550R+bzfDD+Zp77G
        VeqjgzS9aICk9oA6oUYEikLUe/0KjWPrFajG
X-Google-Smtp-Source: ABdhPJw09wd7odQNp6dejR+hFMlJ9y4tAGzkhuSzXXzbmuLWuxdwCJaNqV8exIq1nWVIqPRrGFsJFQ==
X-Received: by 2002:a1c:e084:: with SMTP id x126mr32733413wmg.109.1608040785708;
        Tue, 15 Dec 2020 05:59:45 -0800 (PST)
Received: from [192.168.8.128] ([185.69.144.228])
        by smtp.gmail.com with ESMTPSA id a12sm11925845wrh.71.2020.12.15.05.59.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 05:59:44 -0800 (PST)
Subject: Re: [PATCH v1 2/6] iov_iter: optimise bvec iov_iter_advance()
To:     David Laight <David.Laight@ACULAB.COM>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Ming Lei <ming.lei@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
References: <cover.1607976425.git.asml.silence@gmail.com>
 <5c9c22dbeecad883ca29b31896c262a8d2a77132.1607976425.git.asml.silence@gmail.com>
 <262132648a8f4e7a9d1c79003ea74b3f@AcuMS.aculab.com>
 <d151f81e-ec56-59c0-d2a0-ffd4a269fec1@gmail.com>
 <c5f54cb816564f2b96f5d7a0f85fdc4a@AcuMS.aculab.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <2d45795e-c077-2ea0-c38d-f9a4736bccd7@gmail.com>
Date:   Tue, 15 Dec 2020 13:56:25 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <c5f54cb816564f2b96f5d7a0f85fdc4a@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 15/12/2020 13:54, David Laight wrote:
> From: Pavel Begunkov
>> Sent: 15 December 2020 11:24
>>
>> On 15/12/2020 09:37, David Laight wrote:
>>> From: Pavel Begunkov
>>>> Sent: 15 December 2020 00:20
>>>>
>>>> iov_iter_advance() is heavily used, but implemented through generic
>>>> iteration. As bvecs have a specifically crafted advance() function, i.e.
>>>> bvec_iter_advance(), which is faster and slimmer, use it instead.
>>>>
>>>>  lib/iov_iter.c | 19 +++++++++++++++++++
>> [...]
>>>>  void iov_iter_advance(struct iov_iter *i, size_t size)
>>>>  {
>>>>  	if (unlikely(iov_iter_is_pipe(i))) {
>>>> @@ -1077,6 +1092,10 @@ void iov_iter_advance(struct iov_iter *i, size_t size)
>>>>  		i->count -= size;
>>>>  		return;
>>>>  	}
>>>> +	if (iov_iter_is_bvec(i)) {
>>>> +		iov_iter_bvec_advance(i, size);
>>>> +		return;
>>>> +	}
>>>>  	iterate_and_advance(i, size, v, 0, 0, 0)
>>>>  }
>>>
>>> This seems to add yet another comparison before what is probably
>>> the common case on an IOVEC (ie normal userspace buffer).
>>
>> If Al finally takes the patch for iov_iter_is_*() helpers it would
>> be completely optimised out.
> 
> I knew I didn't have that path - the sources I looked at aren't that new.
> Didn't know its state.
> 
> In any case that just stops the same test being done twice.
> In still changes the order of the tests.
> 
> The three 'unlikely' cases should really be inside a single
> 'unlikely' test for all three bits.
> Then there is only one mis-predictable jump prior to the usual path.
> 
> By adding the test before iterate_and_advance() you are (effectively)
> optimising for the bvec (and discard) cases.

Take a closer look, bvec check is already first in iterate_and_advance().
Anyway, that all is an unrelated story.

> Adding 'unlikely()' won't make any difference on some architectures.
> IIRC recent intel x86 don't have a 'static prediction' for unknown
> branches - they just use whatever in is the branch predictor tables.

-- 
Pavel Begunkov
