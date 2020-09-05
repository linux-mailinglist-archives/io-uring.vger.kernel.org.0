Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9B925E859
	for <lists+io-uring@lfdr.de>; Sat,  5 Sep 2020 16:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbgIEO2y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 5 Sep 2020 10:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgIEO2x (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 5 Sep 2020 10:28:53 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A92A3C061244
        for <io-uring@vger.kernel.org>; Sat,  5 Sep 2020 07:28:52 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id w2so9303138wmi.1
        for <io-uring@vger.kernel.org>; Sat, 05 Sep 2020 07:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=/8aH47qEKvqHjHscH5eihx99yf7aocCpcZrNwjHcgV0=;
        b=EXw836ImoPHkOYf9di6qkM5sW05ZMJ/mqUhHqxlnyVvT4mMtHGMOS+AsSILEuxP1ZZ
         1koR6zCNzcPj3WNBl5hwUPW94qcyllgzvDJmcaPgQpOe/C3Kic6trn/JwWhpfeMh0YXL
         2JxqV1bwYP6S8V57ujv+ZdRXpF7fyy5ty6BicO8G929j4om1hY1ubkhq6BjCRK+ohrHj
         AsqpMyX/+peIkJw3j6WiRo1GkcYoquTFKPOu6FVm9QRdLMJ1ewX77y9zfO3ql1UNI5rh
         0XctAGIK/iVFJBwZzazFmSe2jfoKTYsE2b1fO9rvDad8pAG/0HbSvOFW0a9yh+zYUh7z
         8MTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=/8aH47qEKvqHjHscH5eihx99yf7aocCpcZrNwjHcgV0=;
        b=qPBTy3qybQMSfXRCijWt4y26LMq5Ut5/Y9Z8gel2a0CqXYVYdOwoYjYyfoaRwAbnwD
         h0IiYjEhXFSsubOdxMQ/YL7NDSDYYIQvgoijsq9lkLWjmitczjeYMEa/2WfOlRmvDyWL
         qJdiGfLh48/MRvgWEXKV4w1Snj7nzHSnOPHGEP/3bdwkxZeUuc5hImib4WA8wYvueI73
         dcMcciYstqHm7J52scazZyU22R7WjoiWr0LLaYvoNa17cDhSs2IUjj6E8Poff3KR14wt
         sLubOzoc0hcW1pYQsbI6C6ScRbxQaJs/NlWlYtooteIefPPaPUcJnmIPH1hewKPZE4cp
         b0YQ==
X-Gm-Message-State: AOAM533+jZW3tE2jURqFgi83vJkm39DyV0yNRmUpvjpQrB3XyaKHkdK0
        DW4dOniFISsEGMbd9weLN4R9lMyp9nnqGA==
X-Google-Smtp-Source: ABdhPJxoQ+7rMCO0uKe4fjcirDLkv3qR/BbmmQCVJtYyN8Red/mCH/k6P1D0gdWyl8rjn2ypavCtAw==
X-Received: by 2002:a1c:2d95:: with SMTP id t143mr11987612wmt.44.1599316131008;
        Sat, 05 Sep 2020 07:28:51 -0700 (PDT)
Received: from macbook-pro.lan (ip-95-222-154-235.hsi15.unitymediagroup.de. [95.222.154.235])
        by smtp.googlemail.com with ESMTPSA id f6sm24023827wme.32.2020.09.05.07.28.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Sep 2020 07:28:50 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: WRITEV with IOSQE_ASYNC broken?
From:   Norman Maurer <norman.maurer@googlemail.com>
In-Reply-To: <1BD1ED7B-92E9-4EA9-9002-8F4ECDC1F3C1@googlemail.com>
Date:   Sat, 5 Sep 2020 16:28:49 +0200
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <2AB36FB2-B50F-4313-9C57-5E131D16E337@googlemail.com>
References: <382946a1d3513fbb1354c8e2c875e036@nickhill.org>
 <bfd153eb-0ab9-5864-ca5d-1bc8298f7a21@kernel.dk>
 <fe3784cf-3389-6096-9dfd-f3aa8cd3a769@kernel.dk>
 <d8404079-fe7e-3f42-4460-22328b12b0fa@kernel.dk>
 <484b5876-a2e6-3e02-a566-10c5a02241e8@gmail.com>
 <a7285fbdffcf587a3fc4eb8e75f57da3@nickhill.org>
 <1BD1ED7B-92E9-4EA9-9002-8F4ECDC1F3C1@googlemail.com>
To:     Nick Hill <nick@nickhill.org>, Jens Axboe <axboe@kernel.dk>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I can confirm this fixed the problem for us.

Thanks a lot of the quick turnaround (as always!).

Bye
Norman


> On 5. Sep 2020, at 10:26, Norman Maurer <norman.maurer@googlemail.com> =
wrote:
>=20
> Yes =E2=80=A6 I will :) I am already compiling the kernel as we speak =
with the patch applied. Will report back later today.=20
>=20
>=20
>=20
>> On 5. Sep 2020, at 10:24, nick@nickhill.org wrote:
>>=20
>> On 2020-09-04 22:50, Pavel Begunkov wrote:
>>> On 05/09/2020 07:35, Jens Axboe wrote:
>>>> On 9/4/20 9:57 PM, Jens Axboe wrote:
>>>>> On 9/4/20 9:53 PM, Jens Axboe wrote:
>>>>>> On 9/4/20 9:22 PM, nick@nickhill.org wrote:
>>>>>>> Hi,
>>>>>>> I am helping out with the netty io_uring integration, and came =
across
>>>>>>> some strange behaviour which seems like it might be a bug =
related to
>>>>>>> async offload of read/write iovecs.
>>>>>>> Basically a WRITEV SQE seems to fail reliably with -BADADDRESS =
when the
>>>>>>> IOSQE_ASYNC flag is set but works fine otherwise (everything =
else the
>>>>>>> same). This is with 5.9.0-rc3.
>>>>>> Do you see it just on 5.9-rc3, or also 5.8? Just curious... But =
that is
>>>>>> very odd in any case, ASYNC writev is even part of the regular =
tests.
>>>>>> Any sort of deferral, be it explicit via ASYNC or implicit =
through
>>>>>> needing to retry, saves all the needed details to retry without
>>>>>> needing any of the original context.
>>>>>> Can you narrow down what exactly is being written - like file =
type,
>>>>>> buffered/O_DIRECT, etc. What file system, what device is hosting =
it.
>>>>>> The more details the better, will help me narrow down what is =
going on.
>>>>> Forgot, also size of the IO (both total, but also number of iovecs =
in
>>>>> that particular request.
>>>>> Essentially all the details that I would need to recreate what =
you're
>>>>> seeing.
>>>> Turns out there was a bug in the explicit handling, new in the =
current
>>>> -rc series. Can you try and add the below?
>>> Hah, absolutely the same patch was in a series I was going to send
>>> today, but with a note that it works by luck so not a bug. =
Apparently,
>>> it is :)
>>> BTW, const in iter->iov is guarding from such cases, yet another =
proof
>>> that const casts are evil.
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>> index 0d7be2e9d005..000ae2acfd58 100644
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>>> @@ -2980,14 +2980,15 @@ static inline int io_rw_prep_async(struct =
io_kiocb *req, int rw,
>>>> 				   bool force_nonblock)
>>>> {
>>>> 	struct io_async_rw *iorw =3D &req->io->rw;
>>>> +	struct iovec *iov;
>>>> 	ssize_t ret;
>>>> -	iorw->iter.iov =3D iorw->fast_iov;
>>>> -	ret =3D __io_import_iovec(rw, req, (struct iovec **) =
&iorw->iter.iov,
>>>> -				&iorw->iter, !force_nonblock);
>>>> +	iorw->iter.iov =3D iov =3D iorw->fast_iov;
>>>> +	ret =3D __io_import_iovec(rw, req, &iov, &iorw->iter, =
!force_nonblock);
>>>> 	if (unlikely(ret < 0))
>>>> 		return ret;
>>>> +	iorw->iter.iov =3D iov;
>>>> 	io_req_map_rw(req, iorw->iter.iov, iorw->fast_iov, &iorw->iter);
>>>> 	return 0;
>>>> }
>>=20
>> Thanks for the speedy replies and finding/fixing this so fast! I'm =
new to kernel dev and haven't built my own yet but I think Norman is =
going to try out your patch soon.
>>=20
>> Nick
>=20

