Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98A1025E682
	for <lists+io-uring@lfdr.de>; Sat,  5 Sep 2020 10:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbgIEI04 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 5 Sep 2020 04:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726888AbgIEI04 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 5 Sep 2020 04:26:56 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30983C061244
        for <io-uring@vger.kernel.org>; Sat,  5 Sep 2020 01:26:54 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id g4so9672539wrs.5
        for <io-uring@vger.kernel.org>; Sat, 05 Sep 2020 01:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=/EmD4USsNIAEFnY7a7LkjlJo0a3StvJXmgIucz6Z5kk=;
        b=W1D4qXHDBbjmLcL56N0Y0iJPa/EErsrQaI9XLd56tUnm9lbI45bXbeoYz1DeEeou2+
         JdOjfCHzfGzkYsy+5So77mRIQGGA8n8NXeBJmVryeix3bwfX2T9CDqdB7Evzn6G0olHV
         o6w4289Ho/pWnT4n2Tnqf1Qgq9d4IipQLgvw0czHzmOv7JQeNgskyTEMDr/81JBj7o0c
         /YhX9hAixB03vndiaLgNKXJ1u/D53zYbVSN8I+r6cEwf3YqvUbmNedSwjU84w4ruZrYw
         IaLrA5czk1/Bm0aPQdBbZhc0AZ0c/mVWWnGZgwn18SAuS1zr93YXVQvwxoHRfJiacH2I
         +78Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=/EmD4USsNIAEFnY7a7LkjlJo0a3StvJXmgIucz6Z5kk=;
        b=faUN8LLCOfv6DEN+QxXIo/sUPxtiTSF4Y3Ruwo1y7kNBUwDeshP5l6tCs3VlGaPT7X
         UpEkpcCsHvVVDFP0FlJS6yx3ICVFLraXUZTJU1poqGjJM8IypIKC2ZzZ8hfeeuZiTMpQ
         NH/7B41JrP+AjIRcMLV4dQjNThg4qDGnSx8bq5SVcfyT1vWKiNS+s2ukZExLX2V5QXzG
         8J95Gb/X8qe2UoqfwCvL78TlSlk8zB6BK+wkEzwlKZKG72uygDXgQfofea5yxMe9tjhP
         v5I8ETnu54i3KbgHy6Gpw7WIsrMKxZ1W7V/hvypeSZstuNebJpMQkmIGVLAmgYriSHgr
         mtvg==
X-Gm-Message-State: AOAM531biqhOf94yV7rfN6VeDKXpe+mh2j0gQBRKszpQQnQZlDf9hqHH
        YCl2KHJ+gofY0ScpFwns/wU=
X-Google-Smtp-Source: ABdhPJwUxjMV8wUMwiuYmmK1K3GJ5YbK/RD6oxSGXJpyDCk8zFwBxmqrTPgGZDz6J4o3Gny/ja8hcw==
X-Received: by 2002:adf:f8d0:: with SMTP id f16mr12224612wrq.66.1599294412873;
        Sat, 05 Sep 2020 01:26:52 -0700 (PDT)
Received: from macbook-pro.lan (ip-95-222-154-235.hsi15.unitymediagroup.de. [95.222.154.235])
        by smtp.googlemail.com with ESMTPSA id g2sm17080360wmg.32.2020.09.05.01.26.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Sep 2020 01:26:52 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: WRITEV with IOSQE_ASYNC broken?
From:   Norman Maurer <norman.maurer@googlemail.com>
In-Reply-To: <a7285fbdffcf587a3fc4eb8e75f57da3@nickhill.org>
Date:   Sat, 5 Sep 2020 10:26:51 +0200
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <1BD1ED7B-92E9-4EA9-9002-8F4ECDC1F3C1@googlemail.com>
References: <382946a1d3513fbb1354c8e2c875e036@nickhill.org>
 <bfd153eb-0ab9-5864-ca5d-1bc8298f7a21@kernel.dk>
 <fe3784cf-3389-6096-9dfd-f3aa8cd3a769@kernel.dk>
 <d8404079-fe7e-3f42-4460-22328b12b0fa@kernel.dk>
 <484b5876-a2e6-3e02-a566-10c5a02241e8@gmail.com>
 <a7285fbdffcf587a3fc4eb8e75f57da3@nickhill.org>
To:     Nick Hill <nick@nickhill.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Yes =E2=80=A6 I will :) I am already compiling the kernel as we speak =
with the patch applied. Will report back later today.=20



> On 5. Sep 2020, at 10:24, nick@nickhill.org wrote:
>=20
> On 2020-09-04 22:50, Pavel Begunkov wrote:
>> On 05/09/2020 07:35, Jens Axboe wrote:
>>> On 9/4/20 9:57 PM, Jens Axboe wrote:
>>>> On 9/4/20 9:53 PM, Jens Axboe wrote:
>>>>> On 9/4/20 9:22 PM, nick@nickhill.org wrote:
>>>>>> Hi,
>>>>>> I am helping out with the netty io_uring integration, and came =
across
>>>>>> some strange behaviour which seems like it might be a bug related =
to
>>>>>> async offload of read/write iovecs.
>>>>>> Basically a WRITEV SQE seems to fail reliably with -BADADDRESS =
when the
>>>>>> IOSQE_ASYNC flag is set but works fine otherwise (everything else =
the
>>>>>> same). This is with 5.9.0-rc3.
>>>>> Do you see it just on 5.9-rc3, or also 5.8? Just curious... But =
that is
>>>>> very odd in any case, ASYNC writev is even part of the regular =
tests.
>>>>> Any sort of deferral, be it explicit via ASYNC or implicit through
>>>>> needing to retry, saves all the needed details to retry without
>>>>> needing any of the original context.
>>>>> Can you narrow down what exactly is being written - like file =
type,
>>>>> buffered/O_DIRECT, etc. What file system, what device is hosting =
it.
>>>>> The more details the better, will help me narrow down what is =
going on.
>>>> Forgot, also size of the IO (both total, but also number of iovecs =
in
>>>> that particular request.
>>>> Essentially all the details that I would need to recreate what =
you're
>>>> seeing.
>>> Turns out there was a bug in the explicit handling, new in the =
current
>>> -rc series. Can you try and add the below?
>> Hah, absolutely the same patch was in a series I was going to send
>> today, but with a note that it works by luck so not a bug. =
Apparently,
>> it is :)
>> BTW, const in iter->iov is guarding from such cases, yet another =
proof
>> that const casts are evil.
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 0d7be2e9d005..000ae2acfd58 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -2980,14 +2980,15 @@ static inline int io_rw_prep_async(struct =
io_kiocb *req, int rw,
>>> 				   bool force_nonblock)
>>> {
>>> 	struct io_async_rw *iorw =3D &req->io->rw;
>>> +	struct iovec *iov;
>>> 	ssize_t ret;
>>> -	iorw->iter.iov =3D iorw->fast_iov;
>>> -	ret =3D __io_import_iovec(rw, req, (struct iovec **) =
&iorw->iter.iov,
>>> -				&iorw->iter, !force_nonblock);
>>> +	iorw->iter.iov =3D iov =3D iorw->fast_iov;
>>> +	ret =3D __io_import_iovec(rw, req, &iov, &iorw->iter, =
!force_nonblock);
>>> 	if (unlikely(ret < 0))
>>> 		return ret;
>>> +	iorw->iter.iov =3D iov;
>>> 	io_req_map_rw(req, iorw->iter.iov, iorw->fast_iov, &iorw->iter);
>>> 	return 0;
>>> }
>=20
> Thanks for the speedy replies and finding/fixing this so fast! I'm new =
to kernel dev and haven't built my own yet but I think Norman is going =
to try out your patch soon.
>=20
> Nick

