Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 198BF16AA78
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 16:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727299AbgBXPtf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 10:49:35 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40743 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727426AbgBXPtf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 10:49:35 -0500
Received: by mail-wm1-f65.google.com with SMTP id t14so9942312wmi.5
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 07:49:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=eksfxQLHot49O+62I9ntixZzX8PTJ1PGZ+d60PZCxWQ=;
        b=SW1OSs9+sGkOJ9aQgEu6T+4QYdy57Ah/1XYLFZazP7B3V2mQd7Z3V5x/XZ77LLWirH
         S1czsWGTJAfIF6tr0KH2oSBKfyBw9zIMj+Ea6zWeM95oohUyoOy6eIFesLJjopPwlfTM
         VHkMkE5RMsH21U9goh0fdjZdp/nMsBqoqNnRojGe0qyNN6l2avBFtdB1xFJ7p+f8KC6L
         nt7uZip6D+cQ2Fk6M52iEWCjB5Id6WDzoQ9VA8vrJ6UnFvHofrJqvB6A4TEETqcmouBG
         y+L3ccdi7QQbqgWZfkSjRBnbg7BvJQEEdyneMtUuB91jpn+b4MjtLfIVdaxitdmUIun0
         QMkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=eksfxQLHot49O+62I9ntixZzX8PTJ1PGZ+d60PZCxWQ=;
        b=qDDCjzm/dBfGxtMG2Le0B1hSfzT0Hgjbz9M2YKQjdD5FKl9bFufgJsfcuMbcId89i/
         q0w0ohNUnpcjIMKCwb096Ulmov+8e/1anX8wUWkG0rrYVOe1xL9OCBdSu2z5dc3PCDUA
         xbOaFYNV0fIWEnc8pzH/JF0dKBS94dGuygez/Vsl5F53ftU+3zCiqQprUlMypkOLs/g0
         KNPjr9T8ReFk8lBj6zSxSiQrCJ+trDPMD4qHVh/edCbKIPBr4gXoxAvmWUpWkuB7jcQg
         dNTtynl5cncR10FqhkGQXxromUemfYKLQudLMBVSpYDvnhG8/4HDgcF1DksS92r82fT4
         tGIQ==
X-Gm-Message-State: APjAAAUuXC4xWVfRo5hyPycs45YzutK9gBNLf3k0XxAajgYLBfC/SyWD
        SczG4/re1Y+LiBLXBqcjAeNfKjp6
X-Google-Smtp-Source: APXvYqxFOCn1OECqmg4F8uLxLMs6QLe9vSc71gNqQfm4DkCzDFX7Vw8uIWWBvJuirYb3klYoyVLOug==
X-Received: by 2002:a1c:e246:: with SMTP id z67mr23889672wmg.52.1582559372212;
        Mon, 24 Feb 2020 07:49:32 -0800 (PST)
Received: from [192.168.43.177] ([109.126.137.65])
        by smtp.gmail.com with ESMTPSA id e11sm8545325wrm.80.2020.02.24.07.49.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 07:49:31 -0800 (PST)
Subject: Re: [PATCH v3 2/3] io_uring: don't do full *prep_worker() from io-wq
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1582530396.git.asml.silence@gmail.com>
 <ca345ead1a45ce9d2c4f916b07a4a2e8eae328e8.1582530396.git.asml.silence@gmail.com>
 <8c439182-008b-dfe6-82e7-487c849a2092@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <1f2860f8-aff5-972d-a399-6b0f10fd2373@gmail.com>
Date:   Mon, 24 Feb 2020 18:48:47 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <8c439182-008b-dfe6-82e7-487c849a2092@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cTsrNhaJ3YdWDukqEGVMPhX5Vk1JcogAT"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cTsrNhaJ3YdWDukqEGVMPhX5Vk1JcogAT
Content-Type: multipart/mixed; boundary="AZx12qD7hRDHgatM6GS1AI1O75TEYx3uc";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Message-ID: <1f2860f8-aff5-972d-a399-6b0f10fd2373@gmail.com>
Subject: Re: [PATCH v3 2/3] io_uring: don't do full *prep_worker() from io-wq
References: <cover.1582530396.git.asml.silence@gmail.com>
 <ca345ead1a45ce9d2c4f916b07a4a2e8eae328e8.1582530396.git.asml.silence@gmail.com>
 <8c439182-008b-dfe6-82e7-487c849a2092@kernel.dk>
In-Reply-To: <8c439182-008b-dfe6-82e7-487c849a2092@kernel.dk>

--AZx12qD7hRDHgatM6GS1AI1O75TEYx3uc
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 24/02/2020 18:30, Jens Axboe wrote:
> On 2/24/20 1:30 AM, Pavel Begunkov wrote:
>> io_prep_async_worker() called io_wq_assign_next() do many useless chec=
ks:
>> io_req_work_grab_env() was already called during prep, and @do_hashed
>> is not ever used. Add io_prep_next_work() -- simplified version, that
>> can be called io-wq.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>  fs/io_uring.c | 13 ++++++++++++-
>>  1 file changed, 12 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 819661f49023..3003e767ced3 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -955,6 +955,17 @@ static inline void io_req_work_drop_env(struct io=
_kiocb *req)
>>  	}
>>  }
>> =20
>> +static inline void io_prep_next_work(struct io_kiocb *req,
>> +				     struct io_kiocb **link)
>> +{
>> +	const struct io_op_def *def =3D &io_op_defs[req->opcode];
>> +
>> +	if (!(req->flags & REQ_F_ISREG) && def->unbound_nonreg_file)
>> +			req->work.flags |=3D IO_WQ_WORK_UNBOUND;
>=20
> Extra tab?

Yep. Would resending [2/3] be enough?


> Otherwise looks fine.
>=20

--=20
Pavel Begunkov


--AZx12qD7hRDHgatM6GS1AI1O75TEYx3uc--

--cTsrNhaJ3YdWDukqEGVMPhX5Vk1JcogAT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl5T8F8ACgkQWt5b1Glr
+6V9Tg/5ARNCg5EBm7iGJVCyZhBatSJyQzjUTmU/dvnIYqwWLZes9ouv5h+dOOk0
69Q4ScWadOUUe2G73LrLTzNnDYa3nQd/EFw3FKwbk6mzRrad7zyRKjGYceKoUm7C
FVglQhNOyOe7xlCLpOOmr3hASmJEo9Oust4fiDJEDvxW/Llx5+fsNkEuBto6XO/a
d8Jbpygqq3Kfnl5IfdD59HIqSjkgPa1jp0SdjGKMsWbUDfVlmx8btC3vbP5rFhif
DaaZH+aCdadbr9GPme9/HkLT5z/VFDpLR+MAbPhMi2j03+T0/Kj89i0mLuNQ40kM
/iitgs8JY8Q3Jnjb0uhLP2hi8QdvcDRFUaSTWky8ST6vI8TzCIe/fD1xF0EDQYek
sULCExcybZGeNTY2VyAGnDmEtmpaaYOz1ToAL5gTmgOQJBN5z9SY2ymxyI0IznSZ
PYeCRQ5coXVfh7X9T3wlDZ0+R3IB6dl2aumMzlXI0ljN5azI7yVHRo6gzM+eMqSG
yOMkabeSfKIksTpl2ctLig8ZCcgKx7hQTDy73frUuQx6lgtrlUooYNyRobP9XQq5
9E5HZzppdrmtsEgMCMSE2YArCqYPi0FIov+q9G1vpP4HIP6LZYUfhjL3SuQ+jV7I
KojIMrjZSyF5T/tw+yAaZEJYAukLL8sd4pQcO28Jd8ugz9vA6gY=
=EENk
-----END PGP SIGNATURE-----

--cTsrNhaJ3YdWDukqEGVMPhX5Vk1JcogAT--
