Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48E112DAC05
	for <lists+io-uring@lfdr.de>; Tue, 15 Dec 2020 12:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729070AbgLOL1i (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Dec 2020 06:27:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729063AbgLOL1f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Dec 2020 06:27:35 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93034C06179C;
        Tue, 15 Dec 2020 03:26:55 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id d26so6261533wrb.12;
        Tue, 15 Dec 2020 03:26:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cZpu9JVXhyiWelTl46Pe/xlISF8M49kKFY6TqjVIyqw=;
        b=aXVK4L4avY9bV+Cz/0bzjSeCqzCJaFN0YJu7Etbnuszao4fnxJjx1/XTBjU4wVOd18
         jT1L407QtX3yRZ9cQKwyOaH67FpaP+ZOFhSl1qIWeXvK/Fwk/9nTz27z+4EkvwZncAyL
         TWMmELiBQ5L6VybGZmcESTEZnNdI1dXkbblqyFgyTUspMCKD04dGNy+E82u7lQ0ERuSy
         ezaUwc4KbTbWA2lDEpJzmlM1MATNCPs2fbqbucnS6/+xHCcsMKzH5fdKwyRSuBCbXr87
         ZTrz/n3pet5nUoi+snIqMiulRftnOZ2VW4zNxRFMTvfYgySlgnjNwsMfE+bi3e6OAd+R
         xYdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=cZpu9JVXhyiWelTl46Pe/xlISF8M49kKFY6TqjVIyqw=;
        b=Mn7zzjR2wi+O8WSzt8KYIzOaKpP2i09AzhI1FunGDEpCubSEDm1VvRh7ns6px6AJDR
         G12jdqBdz4soLRzH/oDsAlGH/AtAyHeWTtECbMOYdxGEon3VrOAyxIntZ1QrY3FpSDvM
         EHslFJYGkJDlS3wn/onV0ewPwNPkAbl9BP9RBtW8oIMZVxxfmcha4yXzrUbOhg26FxJz
         irJsuea086DeqHo4HRGCZWd3mWZB71x7SW0lDRfVIXQ7rbfamf7/MhdWEjouBtEAOdhd
         7U6bw0eb5dkfxBu8VBHxIqF8qdCfR1X0RNhCpXlqwQOInLCDotQyNreBYpJkNlwMCvLp
         +UqA==
X-Gm-Message-State: AOAM532c1GrvzI/rOYIlmN5l9IEGB2Oa6QtfAmbDsF0dwCnO6w8g9KuD
        9WcnTewS+w7m2EkHBIH7YiGgTtNszGSg3Drk
X-Google-Smtp-Source: ABdhPJxEug64Og3Z6dTRv7LWKBBzRMmfwovjQ+k+KkNwe51YTNZYqdU/TPzDt3NqBpn2gs92QGbMLw==
X-Received: by 2002:a5d:4d02:: with SMTP id z2mr34466243wrt.109.1608031614170;
        Tue, 15 Dec 2020 03:26:54 -0800 (PST)
Received: from [192.168.8.128] ([185.69.145.6])
        by smtp.gmail.com with ESMTPSA id l7sm35838949wme.4.2020.12.15.03.26.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 03:26:53 -0800 (PST)
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
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v1 2/6] iov_iter: optimise bvec iov_iter_advance()
Message-ID: <d151f81e-ec56-59c0-d2a0-ffd4a269fec1@gmail.com>
Date:   Tue, 15 Dec 2020 11:23:34 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <262132648a8f4e7a9d1c79003ea74b3f@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 15/12/2020 09:37, David Laight wrote:
> From: Pavel Begunkov
>> Sent: 15 December 2020 00:20
>>
>> iov_iter_advance() is heavily used, but implemented through generic
>> iteration. As bvecs have a specifically crafted advance() function, i.e.
>> bvec_iter_advance(), which is faster and slimmer, use it instead.
>>
>>  lib/iov_iter.c | 19 +++++++++++++++++++
[...]
>>  void iov_iter_advance(struct iov_iter *i, size_t size)
>>  {
>>  	if (unlikely(iov_iter_is_pipe(i))) {
>> @@ -1077,6 +1092,10 @@ void iov_iter_advance(struct iov_iter *i, size_t size)
>>  		i->count -= size;
>>  		return;
>>  	}
>> +	if (iov_iter_is_bvec(i)) {
>> +		iov_iter_bvec_advance(i, size);
>> +		return;
>> +	}
>>  	iterate_and_advance(i, size, v, 0, 0, 0)
>>  }
> 
> This seems to add yet another comparison before what is probably
> the common case on an IOVEC (ie normal userspace buffer).

If Al finally takes the patch for iov_iter_is_*() helpers it would
be completely optimised out. 

> 
> Can't the call to bver_iter_advance be dropped into the 'advance'
> path for BVEC's inside iterate_and_advance?

It iterates by page/segment/etc., why would you want to do
bver_iter_advance(i->count) there?

> 
> iterate_and_advance itself has three 'unlikely' conditional tests
> that may be mis-predicted taken before the 'likely' path.
> One is for DISCARD which is checked twice on the object I just
> looked at - the test in iov_iter_advance() is pointless.

And again, both second checks, including for discards, would be
optimised out by the iov_iter_is_* patch.

-- 
Pavel Begunkov
