Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34AE325E59F
	for <lists+io-uring@lfdr.de>; Sat,  5 Sep 2020 07:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbgIEFwl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 5 Sep 2020 01:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbgIEFwk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 5 Sep 2020 01:52:40 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C309C061244
        for <io-uring@vger.kernel.org>; Fri,  4 Sep 2020 22:52:40 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id e16so9471891wrm.2
        for <io-uring@vger.kernel.org>; Fri, 04 Sep 2020 22:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ffWVaj43R8vpVedSFGLJ8Z14LtCqGU8OYRytG+5thvY=;
        b=b52zQxR5n2blzjAungItZzO7shsI0OuiA4mfpdzNdnBhL1QU4AZNaOCtPKw5tYeCuL
         vazufoEveZWeKnzqUAWWK3Po/KSDFdidQR7VLRKVn6OlZsx0hQcq+Wxydyndrg52jFLp
         GkAIn69OeN9v4DgGWRsL1RRz1l8MwLr8nYezoJHyV5v/WFYadJpsDREH5w0ve8a2Mstn
         HFQPb8lnjXX/r/Cd52ejwl7JTZKKeM9YoV7pcHKBBDuArzrHV7ZaL3Z2LlsnkRcBElee
         bv+X4ouV1F0yS0iT7PEUzHo4z+6Zris3/updfOJxBgnfp76KfCbQ/z5cVTzUWE5COdf9
         /Flw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ffWVaj43R8vpVedSFGLJ8Z14LtCqGU8OYRytG+5thvY=;
        b=quAmnq3iSspu/a8uCP+9nEBDsKinBBN1BzYUqomaiY+zKnSR5f4v2oggw32XgaHs+5
         n738PZedU/71ciN2InplrtwjgMtfQt4dRNexaP9KWXnRScZz0FPP3dpJ1VsjDRC9O0+u
         K2/sDd7z7iKcBZlSlEHJWefWm+yUwbElxI8ZFQIDqXlxSvauTd7vzXeCHtb+0pJ/Wld7
         I53TmXEYl8s9RLQYkFjkN9EjS+EHQT5rwENhXasyEStuTY97zVme1AphKc3Q9wiSm8Qa
         pW1Vbf2GNCfXFSVJUPtavx/RE2xuaObM1Av+u4NbEZxVZiutEO2f5xCrxeSDrxSIgYZI
         I3Jw==
X-Gm-Message-State: AOAM530YtjyJICKexvnBmIPsy+ICe2BGJ9CAN2HHrpuAzU5uY/MB/7Vf
        ylR8i58dn7wTL4idv+mtztAl2L6jSbc=
X-Google-Smtp-Source: ABdhPJy0HQ0yPZPwRh3c8Eu1b1HkEmdZJxt6IZKx0xD+HdBK3VE3AQfIh42rAZ1qPRwEuQnQvyXjsA==
X-Received: by 2002:a5d:4fcc:: with SMTP id h12mr10837427wrw.199.1599285158434;
        Fri, 04 Sep 2020 22:52:38 -0700 (PDT)
Received: from [192.168.43.65] ([5.100.192.56])
        by smtp.gmail.com with ESMTPSA id x16sm14753947wrq.62.2020.09.04.22.52.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2020 22:52:37 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, nick@nickhill.org,
        io-uring@vger.kernel.org
References: <382946a1d3513fbb1354c8e2c875e036@nickhill.org>
 <bfd153eb-0ab9-5864-ca5d-1bc8298f7a21@kernel.dk>
 <fe3784cf-3389-6096-9dfd-f3aa8cd3a769@kernel.dk>
 <d8404079-fe7e-3f42-4460-22328b12b0fa@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: WRITEV with IOSQE_ASYNC broken?
Message-ID: <484b5876-a2e6-3e02-a566-10c5a02241e8@gmail.com>
Date:   Sat, 5 Sep 2020 08:50:14 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <d8404079-fe7e-3f42-4460-22328b12b0fa@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 05/09/2020 07:35, Jens Axboe wrote:
> On 9/4/20 9:57 PM, Jens Axboe wrote:
>> On 9/4/20 9:53 PM, Jens Axboe wrote:
>>> On 9/4/20 9:22 PM, nick@nickhill.org wrote:
>>>> Hi,
>>>>
>>>> I am helping out with the netty io_uring integration, and came across 
>>>> some strange behaviour which seems like it might be a bug related to 
>>>> async offload of read/write iovecs.
>>>>
>>>> Basically a WRITEV SQE seems to fail reliably with -BADADDRESS when the 
>>>> IOSQE_ASYNC flag is set but works fine otherwise (everything else the 
>>>> same). This is with 5.9.0-rc3.
>>>
>>> Do you see it just on 5.9-rc3, or also 5.8? Just curious... But that is
>>> very odd in any case, ASYNC writev is even part of the regular tests.
>>> Any sort of deferral, be it explicit via ASYNC or implicit through
>>> needing to retry, saves all the needed details to retry without
>>> needing any of the original context.
>>>
>>> Can you narrow down what exactly is being written - like file type,
>>> buffered/O_DIRECT, etc. What file system, what device is hosting it.
>>> The more details the better, will help me narrow down what is going on.
>>
>> Forgot, also size of the IO (both total, but also number of iovecs in
>> that particular request.
>>
>> Essentially all the details that I would need to recreate what you're
>> seeing.
> 
> Turns out there was a bug in the explicit handling, new in the current
> -rc series. Can you try and add the below?

Hah, absolutely the same patch was in a series I was going to send
today, but with a note that it works by luck so not a bug. Apparently,
it is :)

BTW, const in iter->iov is guarding from such cases, yet another proof
that const casts are evil.

> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 0d7be2e9d005..000ae2acfd58 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2980,14 +2980,15 @@ static inline int io_rw_prep_async(struct io_kiocb *req, int rw,
>  				   bool force_nonblock)
>  {
>  	struct io_async_rw *iorw = &req->io->rw;
> +	struct iovec *iov;
>  	ssize_t ret;
>  
> -	iorw->iter.iov = iorw->fast_iov;
> -	ret = __io_import_iovec(rw, req, (struct iovec **) &iorw->iter.iov,
> -				&iorw->iter, !force_nonblock);
> +	iorw->iter.iov = iov = iorw->fast_iov;
> +	ret = __io_import_iovec(rw, req, &iov, &iorw->iter, !force_nonblock);
>  	if (unlikely(ret < 0))
>  		return ret;
>  
> +	iorw->iter.iov = iov;
>  	io_req_map_rw(req, iorw->iter.iov, iorw->fast_iov, &iorw->iter);
>  	return 0;
>  }
> 

-- 
Pavel Begunkov
