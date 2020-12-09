Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A39782D41C3
	for <lists+io-uring@lfdr.de>; Wed,  9 Dec 2020 13:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731328AbgLIMHi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Dec 2020 07:07:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730385AbgLIMHh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Dec 2020 07:07:37 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4359DC0613D6;
        Wed,  9 Dec 2020 04:06:57 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id y23so1415933wmi.1;
        Wed, 09 Dec 2020 04:06:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tCwU4zmn0s7cAcxlqvIMqSJutP8C4okN6yr42e+Azek=;
        b=cE8lQiZdcl7R2cfjseeOdM+vKVL503OAxMNMhxQSAEUn1YfanBIJTQIu+O0WDz9SFd
         Xwx8hNVst2wyWHev6z90HeWpO1hoPfB4UHGnhYEEk7bVij62a57Qq8Tn3zm0fCZjpMHO
         H2GQU/hfPbuqISW8V+b7963/fxUV/H97zrM4fosmGJHZWzR15+KCAWmOWDo2cuhQzLN3
         UEB/V2bakFC5ehgw8Ox8yL5hg1176RBnlUhGSWLp0xZWt+pn9OzXj64vTKcoXosF0So+
         icFbnf91Xz2yxK0+i8GOVOYkKmLA/r/XSmfHDRNL3imi5Uv2DRWl1Jf3g/0r1snFQdk2
         +xfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=tCwU4zmn0s7cAcxlqvIMqSJutP8C4okN6yr42e+Azek=;
        b=ZyRRdF3YylAFVForbwf8m9U8hg1g6VgHCVFR0yFxJpcx+4VencsX1M3mdvCIG9vqTJ
         9asjZiTYxaZS1vi/KOR/LyKyBYXrxb8GAVKv8M4nU0FY6+M9qbtz7tcdQkFniaUGXHhr
         P+5ak+3FljJAeDRv3xeYMwRUtirsr/Gg868Q2Q6/123ICk254kRhlbjRCnygKRWVTm+1
         0rzZz/KaqTixMUmRnW2VKei9OQYdFXqZWHAQnWRfzHs/wndMsy1QMldY9AFVuvQf9Xtl
         YSXXKvtmcEPQwz5zQ1LSKLnpoJoFAkhsmwVn6iHDy2TCBaNJYmJxoc5ScYgGdVBdnZEI
         Wn2w==
X-Gm-Message-State: AOAM531BvLbwGa+UjWoS+U34eHnLRl1RrGcPv1now8u438l8Am6qnHr2
        A8zHGLPOqIRqnoqlmReNDMQ=
X-Google-Smtp-Source: ABdhPJzPurYbriT6SxV9WKIwNBdCTkJqLXZNjh6gui+MCardfduv9Y6qrP2kBZTiA+w8vwQGm91sFg==
X-Received: by 2002:a7b:cb82:: with SMTP id m2mr2390583wmi.75.1607515616042;
        Wed, 09 Dec 2020 04:06:56 -0800 (PST)
Received: from [192.168.8.121] ([85.255.233.156])
        by smtp.gmail.com with ESMTPSA id m8sm3103010wmc.27.2020.12.09.04.06.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Dec 2020 04:06:55 -0800 (PST)
Subject: Re: [PATCH 2/2] block: no-copy bvec for direct IO
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Ming Lei <ming.lei@redhat.com>
References: <cover.1607477897.git.asml.silence@gmail.com>
 <51905c4fcb222e14a1d5cb676364c1b4f177f582.1607477897.git.asml.silence@gmail.com>
 <20201209084005.GC21968@infradead.org>
 <63057f61-85e5-4720-3532-1a1ba05ab41a@gmail.com>
 <20201209120531.GA9598@infradead.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <2ec61ac5-6ef8-6d85-263e-917770292480@gmail.com>
Date:   Wed, 9 Dec 2020 12:03:39 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20201209120531.GA9598@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 09/12/2020 12:05, Christoph Hellwig wrote:
> On Wed, Dec 09, 2020 at 12:01:27PM +0000, Pavel Begunkov wrote:
>> On 09/12/2020 08:40, Christoph Hellwig wrote:
>>>> +	/*
>>>> +	 * In practice groups of pages tend to be accessed/reclaimed/refaulted
>>>> +	 * together. To not go over bvec for those who didn't set BIO_WORKINGSET
>>>> +	 * approximate it by looking at the first page and inducing it to the
>>>> +	 * whole bio
>>>> +	 */
>>>> +	if (unlikely(PageWorkingset(iter->bvec->bv_page)))
>>>> +		bio_set_flag(bio, BIO_WORKINGSET);
>>>
>>> IIRC the feedback was that we do not need to deal with BIO_WORKINGSET
>>> at all for direct I/O.
>>
>> I was waiting for the conversation to unfold, i.e. for Johannes to
>> answer. BTW, would the same (skipping BIO_WORKINGSET) stand true for
>> iomap?
> 
> iomap direct I/O: yes.

That one, got it

-- 
Pavel Begunkov
