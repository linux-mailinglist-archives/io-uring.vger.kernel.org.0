Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA6221A130
	for <lists+io-uring@lfdr.de>; Thu,  9 Jul 2020 15:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbgGINvh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jul 2020 09:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbgGINvg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jul 2020 09:51:36 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65729C08C5CE;
        Thu,  9 Jul 2020 06:51:36 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id z13so2458666wrw.5;
        Thu, 09 Jul 2020 06:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VhzrIAirWE0Lj3KW7RdAitzVFbxou3NXZT0xUySjqho=;
        b=ilimIdsqXsA+03iTdn6Q5Kq/rFjVMMMD81ULVHuIE9iOgm+EXdf2wD1B2PNjaOOkR2
         uMsrT12gdpx7bh9zyxr/dDtcdQbFUvp8itolfOqH4DtbzN61bZcC0CPz4u39dM9J7dsF
         6dcHSyKH08miBH6xlwKOwqmDpXpwxLW2A2DC16zV3aqMQ97L7C1Z7DciVFsag+AVuZK6
         pA8OrtEpZj+8MKzh7aVMJkXLHZwsNCicCNcce0ykseFk3U2gojQVjqqhLdpFIGoJrxXa
         haykJ4UXrRHvc6tJ7BWNVo1fpUNPDxGCJzhlN7N8ZejFKHepAWwUIxs2gzQHmhWrBKD3
         f59w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=VhzrIAirWE0Lj3KW7RdAitzVFbxou3NXZT0xUySjqho=;
        b=CMvVdktgORFYdNdccHxelfj9WRh9gMRoaG2SJmFp/idoFvRDj1pz6L4pSYBdyHn6NC
         gymJkQoEAnYEiVI8CykhDbgUki8iWaAswuQuHgY9nuOQKyhrpJBiYT+GdoT+FB0Waj8v
         LC4KeDpkmkJ68/r1G92R429GUjNjWOXrNCUCMU9INcVaIJscV4EC8R43ud11v3BiykC2
         fl2CM7Z4j13ltKLhounFuHd4ktYLtWVhTwzh+GdyJRLSlWM3YPCwi6/wn6NZyjhTyDNN
         qxI4CqNnV1w0vcYJsiaEkYXTzUNrIq5+rnp7c3GzmQ12g+DTSnexKk7wp6v5N/F4i9vR
         qDaQ==
X-Gm-Message-State: AOAM533f0L2PSjml+2Nc/e7KEcT9j+VJiBs9X9AUDqPxFZhG2TvzaSVF
        n8gI+Ump4xQfc3W6JucvEM0=
X-Google-Smtp-Source: ABdhPJwYp/6/MJIHI2x9vqD7B+NdBufN0ctTFJL8RA3ed6TyyPlcpLgKx7Mz2FJ9rpgaN7Y9Gvh5dA==
X-Received: by 2002:adf:efc9:: with SMTP id i9mr67264354wrp.77.1594302695111;
        Thu, 09 Jul 2020 06:51:35 -0700 (PDT)
Received: from [192.168.43.42] ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id q7sm6021020wrs.27.2020.07.09.06.51.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 06:51:34 -0700 (PDT)
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kanchan Joshi <joshi.k@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
References: <20200708222637.23046-1-willy@infradead.org>
 <20200709101705.GA2095@infradead.org>
 <20200709111036.GA12769@casper.infradead.org>
 <20200709132611.GA1382@infradead.org>
 <ffbd272c-32f3-8c8c-6395-5eab47725929@gmail.com>
 <20200709134319.GD12769@casper.infradead.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 0/2] Remove kiocb ki_complete
Message-ID: <ce7d999e-1629-c70d-8bb9-59d7db41a11e@gmail.com>
Date:   Thu, 9 Jul 2020 16:49:51 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200709134319.GD12769@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 09/07/2020 16:43, Matthew Wilcox wrote:
> On Thu, Jul 09, 2020 at 04:37:59PM +0300, Pavel Begunkov wrote:
>> On 09/07/2020 16:26, Christoph Hellwig wrote:
>>> On Thu, Jul 09, 2020 at 12:10:36PM +0100, Matthew Wilcox wrote:
>>>> On Thu, Jul 09, 2020 at 11:17:05AM +0100, Christoph Hellwig wrote:
>>>>> I really don't like this series at all.  If saves a single pointer
>>>>> but introduces a complicated machinery that just doesn't follow any
>>>>> natural flow.  And there doesn't seem to be any good reason for it to
>>>>> start with.
>>>>
>>>> Jens doesn't want the kiocb to grow beyond a single cacheline, and we
>>>> want the ability to set the loff_t in userspace for an appending write,
>>>> so the plan was to replace the ki_complete member in kiocb with an
>>>> loff_t __user *ki_posp.
>>>>
>>>> I don't think it's worth worrying about growing kiocb, personally,
>>>> but this seemed like the easiest way to make room for a new pointer.
>>>
>>> The user offset pointer has absolutely no business in the the kiocb
>>> itself - it is a io_uring concept which needs to go into the io_kiocb,
>>> which has 14 bytes left in the last cache line in my build.  It would
>>> fit in very well there right next to the result and user pointer.
>>
>> After getting a valid offset, io_uring shouldn't do anything but
>> complete the request. And as io_kiocb implicitly contains a CQE entry,
>> not sure we need @append_offset in the first place.
>>
>> Kanchan, could you take a look if you can hide it in req->cflags?
> 
> No, that's not what cflags are for.  And besides, there's only 32 bits
> there.

It's there to temporarily store cqe->cflags, if a request can't completed
right away. And req->{result,user_data,cflags} are basically an CQE inside
io_kiocb.

So, it is there exactly for that reason, and whatever way it's going to be
encoded in an CQE, io_kiocb can fit it. That was my point.

-- 
Pavel Begunkov
