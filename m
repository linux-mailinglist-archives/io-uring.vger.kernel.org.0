Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 979711C8505
	for <lists+io-uring@lfdr.de>; Thu,  7 May 2020 10:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725862AbgEGIkS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 May 2020 04:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725834AbgEGIkS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 May 2020 04:40:18 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4ECC061A10
        for <io-uring@vger.kernel.org>; Thu,  7 May 2020 01:40:17 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id y3so5322840wrt.1
        for <io-uring@vger.kernel.org>; Thu, 07 May 2020 01:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5QbG01uLgGo/Zc8Tmgm/GlocMah5ZWyk2iWEKwIPQ8M=;
        b=cjz3VXCknZJPOx0J8an8bh742mHNzpny4alfseDw6vWizEDu0x1OkpW7W/0z0Tqpvf
         LAC7Q72zKhlF5bLA7yV4S7hUBgFVciSkesNDYjHznDXzTQZzzGzi3PD1oqoKrFT/RK8U
         3QQRszaDYbgPVCmj13qHkO/B+37A5Kcrw838WcVfeCVX4KOAjpX92Fz6PecihOTzhPGQ
         vShrbUolLyizG0XTmOKJ0YatNR1QZq82yF6i9l16Wv2bntxBlwgVTFKKuCmXbYDj7OzQ
         AS7UnFgKGCsY/digsDqZrtyIhjKdvBPoTIR5OUFsGpSVoD9T5lTxGoTBgVQVTXehvejL
         l29g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=5QbG01uLgGo/Zc8Tmgm/GlocMah5ZWyk2iWEKwIPQ8M=;
        b=Ihusk7Oda755fVO4VjgepczjSI2+GD8MZ5QBGekqkPRjrxPxn7nQTtDPZbia2Lc2+9
         9xr9z+I09Ae1Yha5O5nf4NEqrviRnLtO701y9Vg1JGF5RQnNdJt1ZHo9l/SAFvIwd/hk
         A7Sar5Rf+gGQjJ+XwSwjfN126hJ5l/r89cJ8xAypOT3yZJqvurXXK55n2P7zYbrPb3rM
         HAUrYgeaEATMbkriBrU2wSHCKVlxAikGPaD4VjB70FUJQyy3eqKBwN2OY1g11EoHnUfH
         BNyL8YKBrUriM2riykMH8qQoRH96gvbiWq1Fyh7dKy59nvwwi/oUazD9eYevXZ9Kh/o8
         0QcA==
X-Gm-Message-State: AGi0PuaAT4DRmVfL+PgwBH3ljmHewE1DJ3JSNGUnVhvEFxHQlD+sJ6hD
        /FL/jPPdvaf45ozoG+FsSU42fU9Y
X-Google-Smtp-Source: APiQypK4Qi28YH52ov2p3i0qobQgPj6reisL7DplLf82phouxE5le5oVQ7qN3MT/aRMQal/lBPp8qw==
X-Received: by 2002:a5d:570c:: with SMTP id a12mr14115319wrv.80.1588840816563;
        Thu, 07 May 2020 01:40:16 -0700 (PDT)
Received: from [192.168.43.168] ([46.191.65.149])
        by smtp.gmail.com with ESMTPSA id h1sm6950262wme.42.2020.05.07.01.40.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 01:40:16 -0700 (PDT)
To:     "Bhatia, Sumeet" <sumee@amazon.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Cc:     "Hegde, Pramod" <phegde@amazon.com>, Jens Axboe <axboe@kernel.dk>
References: <1588801562969.24370@amazon.com>
 <62a52be6-d538-b3ee-a071-4ff45da85a87@gmail.com>
 <1588813473189.20383@amazon.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: Non sequential linked chains and IO_LINK support
Message-ID: <39c6c318-e54d-2192-abb9-2b4e8355d3ae@gmail.com>
Date:   Thu, 7 May 2020 11:39:06 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1588813473189.20383@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 07/05/2020 04:04, Bhatia, Sumeet wrote:
> Thank you for the response!
> 
> Unfortunately when the application submits operation_0 it has no way of determining if/when operation_2 would be generated. 
> 
> For now I plan to maintain a list of outstanding operations. If operation_2 gets generated while operation_0 is in flight the application will hold its submission until operation_0 is completed. 

Yes, that's the general workflow. Links in current form are not very helpful for
your case. Those who don't care about latency are trying to throttle requests a
bit, to collect several of them and send at once.

> I wanted to check whether this would be a generic use case and would warrant native support in iouring?

Trying to link to a request that was already submitted, would just complicate
the kernel and userspace as well, I don't think it's viable to support that,
unless there will be huge benefit.

On the other hand, this is an interesting case for our BPF ideas.
E.g. you load a BPF program, which on request completion will poll your internal
queue for a specific disk and submit requests from there. Kind of custom
polling. We don't have BPF in io_uring yet, though.


> Thanks,
> Sumeet
> ________________________________________
> From: Pavel Begunkov <asml.silence@gmail.com>
> Sent: Wednesday, May 6, 2020 6:11 PM
> To: Bhatia, Sumeet; io-uring@vger.kernel.org
> Cc: Hegde, Pramod; Jens Axboe
> Subject: RE: [EXTERNAL] Non sequential linked chains and IO_LINK support
> 
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> 
> 
> 
> On 07/05/2020 00:46, Bhatia, Sumeet wrote:
>> Hello everyone,
>>
>> I've been exploring iouring to submit disk operations. My application generates disk operations based on some events and operations are unknown until those events occur.  Some of these disk operations are interdependent others are not.
>>
>> Example: Following operations are generated and submitted before any of them are complete
>> operation_0 (independent operation)
>> operation_1 (independent operation),​
>> operation_2 (to be issued only if operation_0 was successful),
>> operation_3 (independent operation),
>> operation_4 (to be issued only if operation_1 was successful)
>>
>> In my example I have two independent link chains, (operation_0, operation_2) and (operation_1, operation_4).  iouring documentation suggests IOSQE_IO_LINK expects link chains to be sequential and will not support my use case.
> 
> First of all, there shouldn't be a submission (i.e. io_uring_enter(to_submit>0))
> between adding linked requests to a submission queue (SQ). It'd be racy otherwise.
> 
> E.g. you can't do:
> 
> add_sqe(op0)
> submit(op0)
> add_sqe(op2, linked)
> 
> Though the following is valid, as we don't submit op0:
> 
> add_sqe(opX)
> add_sqe(op0)
> submit(up until opX)
> add_sqe(op2, linked)
> 
> 
> And that means you can reorder them just before submitting, or filing them into
> the SQ in a better order.
> 
> Is it helpful? Let's figure out how to cover your case.
> 
> 
>> I explored creating new iouring context for each of these linked chains. But it turns out depending on disk size there can be somewhere between 500-1000 such chains. I'm not sure whether it is prudent to create that many iouring contexts.
> 
> Then you would need to wait on them (e.g. epoll or 1000 threads), and that would
> defeat the whole idea. In any case even with sharing io-wq and having small CQ
> and SQ, it'd be wasteful keeping many resources duplicated.
> 
>>
>> I am reaching out to check whether there would be a generic need to support nonsequential linked chains on a single iouring context. Would love to hear all your thoughts.
>>
>> Thanks,
>> Sumeet
>>
> 
> --
> Pavel Begunkov
> 

-- 
Pavel Begunkov
