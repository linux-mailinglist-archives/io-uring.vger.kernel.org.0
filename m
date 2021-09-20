Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC3D941154C
	for <lists+io-uring@lfdr.de>; Mon, 20 Sep 2021 15:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233861AbhITNLr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Sep 2021 09:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbhITNLq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Sep 2021 09:11:46 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C56C061574
        for <io-uring@vger.kernel.org>; Mon, 20 Sep 2021 06:10:19 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id h3-20020a17090a580300b0019ce70f8243so667257pji.4
        for <io-uring@vger.kernel.org>; Mon, 20 Sep 2021 06:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=b4rpNHImE8kPPGceBVldLFrAIYOqDcPhB7VweeNrW38=;
        b=Vi5fFAMyaXv+me4ys4r+QcPuYr+5py3vbWGl+kdauMYW50eRgpzeHXDumYA1uTbwVZ
         Ps/IpCabfeMOLMC8tPmQw2syASDJnfLCb05gkge4/Yb2yFyfRrXfQh7fJv40BGG+mt5j
         kdPlviJGeVUcLsqlL7bx07L+W1pK/mi20LK1leFBltuaFQvm3pCdaYu+afOmVxUAzoKH
         Vei1fHLOaVhtTMjx3GpqRqQ+qGDjGe4U+KGNXZIF+OuL1i4FL/1OpeptnznNq9JxoCSO
         kXGDzS12zbVw86ChzSh4lJCsgnX+hxNzOeE9ifWeLCt1LBSz40flHh7hHF9MB2N3cJSo
         cZfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=b4rpNHImE8kPPGceBVldLFrAIYOqDcPhB7VweeNrW38=;
        b=bPfkbSE8CESsIFghM79QKcr3o6M5gvi0n5WscMY0elp/0cur7fngJO2Lau9Os6HNJW
         OpOfAgd5i0b1d29/MctJj7ob1xLzkSq2306/OhUdaF8NNAIgDAn6EMwFrkOiHoomqC9U
         YV3c0OlFfNDONpMs+MpI7RuQ5j4MQTrzEnwkKeuqvaJEfQRMmBI4rhha+poxfUpKctgA
         rezsrGpFseSJuqxi89/41arudf682iMhaBpff59lBGXBf0xQA83kSE1KLwYOoLcgnR8w
         3Z5MvejqKF2A1GnY4zC6ia0ze1O8bOBZYWLKKngMWrKKSccMxXleQ3zBEgFU5b072ucK
         4FEg==
X-Gm-Message-State: AOAM533nym1sLoNe2MwCasrONmVQmpI7Wg7PzwX55RYdPCyXW6pa+TqS
        r+dTySJP+uaib7HJ+CoBzaZ708gqgRJmzw==
X-Google-Smtp-Source: ABdhPJx+nXNEDJCDNvlLpLroqsLZtX0I974fq1ihZu3ABJdNV8nFuSrT16ypTfTknfkcbgLnFkNL8Q==
X-Received: by 2002:a17:90a:d58f:: with SMTP id v15mr28913405pju.28.1632143418744;
        Mon, 20 Sep 2021 06:10:18 -0700 (PDT)
Received: from smtpclient.apple ([2600:380:7548:483d:ecb6:b95b:123f:f702])
        by smtp.gmail.com with ESMTPSA id x13sm14309692pff.70.2021.09.20.06.10.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 06:10:17 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Jens Axboe <axboe@kernel.dk>
Mime-Version: 1.0 (1.0)
Subject: Re: [BUG? liburing] io_uring_register_files_update with liburing 2.0 on 5.13.17
Date:   Mon, 20 Sep 2021 07:10:16 -0600
Message-Id: <D4F0F5A6-736E-4990-A449-0FFB7F505CCB@kernel.dk>
References: <CAM1kxwgayosM7YgPo=OWOG=+RcuYZ7xksUQcd03uOw-RKhxTwQ@mail.gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>
In-Reply-To: <CAM1kxwgayosM7YgPo=OWOG=+RcuYZ7xksUQcd03uOw-RKhxTwQ@mail.gmail.com>
To:     Victor Stewart <v@nametag.social>
X-Mailer: iPhone Mail (18H17)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sep 20, 2021, at 6:51 AM, Victor Stewart <v@nametag.social> wrote:
>=20
> =EF=BB=BFOn Sun, Sep 19, 2021 at 12:40 AM Jens Axboe <axboe@kernel.dk> wro=
te:
>>=20
>> On 9/18/21 5:37 PM, Jens Axboe wrote:
>>>> and it failed with the same as before...
>>>>=20
>>>> io_uring_register(13, IORING_REGISTER_FILES, [-1, -1, -1, 3, 4, 5, 6, 7=
, 8,
>>>> 9, 10, 11, 12, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
>>>> -1, -1, -1, -1,
>>>> -1, ...], 32768) =3D -1 EMFILE (Too many open files)
>>>>=20
>>>> if you want i can debug it for you tomorrow? (in london)
>>>=20
>>> Nah that's fine, I think it's just because you have other files opened
>>> too. We bump the cur limit _to_ 'nr', but that leaves no room for anyone=

>>> else. Would be my guess. It works fine for the test case I ran here, but=

>>> your case may be different. Does it work if you just make it:
>>>=20
>>> rlim.rlim_cur +=3D nr;
>>>=20
>>> instead?
>>=20
>> Specifically, just something like the below incremental. If rlim_cur
>> _seems_ big enough, leave it alone. If not, add the amount we need to
>> cur. And don't do any error checking here, let's leave failure to the
>> kernel.
>>=20
>> diff --git a/src/register.c b/src/register.c
>> index bab42d0..7597ec1 100644
>> --- a/src/register.c
>> +++ b/src/register.c
>> @@ -126,9 +126,7 @@ static int bump_rlimit_nofile(unsigned nr)
>>        if (getrlimit(RLIMIT_NOFILE, &rlim) < 0)
>>                return -errno;
>>        if (rlim.rlim_cur < nr) {
>> -               if (nr > rlim.rlim_max)
>> -                       return -EMFILE;
>> -               rlim.rlim_cur =3D nr;
>> +               rlim.rlim_cur +=3D nr;
>>                setrlimit(RLIMIT_NOFILE, &rlim);
>>        }
>>=20
>=20
> i just tried this patch and same failure. if you intend for this to remain=

> in the code i can debug what's going on?

Yes please do, thanks.=20
