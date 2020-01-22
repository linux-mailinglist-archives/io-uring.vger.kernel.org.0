Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5C65144A4A
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2020 04:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbgAVDRY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jan 2020 22:17:24 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39763 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729191AbgAVDRX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jan 2020 22:17:23 -0500
Received: by mail-wr1-f68.google.com with SMTP id y11so5675824wrt.6;
        Tue, 21 Jan 2020 19:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=qZaKHdf6AtwVH3g0ZcDyF9A3vbnDav4W2l5999jDwEM=;
        b=DxcD7hvc1lmtVGyk5g9TdnZ23WxP29CfifhZR7ekZ3DPIi3EntOvT715CyZ7l8AgEe
         HIEeqa4pIpgcYzR2GZ3pn1dq8b4aSztt2uT3pfVAopTc6DHzP5JWCWIMwb99vfwrBSrq
         zW34nDr0rcRwphrHNH9UKtqgGB3Y9yPfmFBauLF69x06rF/qiEDUXqxyDXG0YYlp1Frm
         Q1yuotqGcZI/C2iCT3QzJt8dQ3cSZrUXgUO8PxYYmsPQBOmA5mbJLJ0jGio/MHr3/RPS
         5Gn9tmPEY/Fog4RX7XV6ShPus5Dorkn/9f4/oHtLNBvlWn0dgz6gvuPM1jrfO32TZIl4
         kFaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=qZaKHdf6AtwVH3g0ZcDyF9A3vbnDav4W2l5999jDwEM=;
        b=I67z0hscFhHcwDt51qniuLh1O/U1H0KSyN6UeN+QdwOtq1zwAGDgXkzYpTHe9wX3dI
         tl0AdO8RPybwrP7jTfVaE21jz9ZJwqv8mAy53qumNL/2qYYiTpelK2a0/UgrDbVSoQoU
         InTdaPWPJw48EJoy5cONa2q3taRFtRdxSHI/6EovvvubA49tCHxA8UtemNgBE7X+OUW0
         b+ySVTbuXugpIfd5YHLDreUkWp0cem66EPj3rtxkZbS2kii4HAr91r/lVNXgW/LxkkF9
         x2FFLHPGUmtEslUJ/eBoX/j/cYItXyQIHXrqQHqQp8iyzmgjrodlsmmayh2cd4K4okaL
         cJnA==
X-Gm-Message-State: APjAAAVpPbRgB+ESc+5IxEnXNgCzj/BjS2uJSsTeaYKzCkzzcdDMPvFV
        BSVlwODQPg2DTjOgwZ1g2ns=
X-Google-Smtp-Source: APXvYqw9oXm3D+DAbpXPqrPgnTIsDuqWsrYwf0hqJc07C6LpC0qbxf8Gx81oCwBjCPjA5ho9+HN7LQ==
X-Received: by 2002:adf:d848:: with SMTP id k8mr8028336wrl.328.1579663040122;
        Tue, 21 Jan 2020 19:17:20 -0800 (PST)
Received: from [192.168.43.234] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id x7sm53795772wrq.41.2020.01.21.19.17.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 19:17:19 -0800 (PST)
Subject: Re: [PATCH 3/3] io_uring: add splice(2) support
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>
References: <cover.1579649589.git.asml.silence@gmail.com>
 <8bfd9a57bf42cfc10ee7195969058d6da277deed.1579649589.git.asml.silence@gmail.com>
 <6d43b9d7-209a-2bbf-e2c2-e125e84b46ab@kernel.dk>
 <14499431-0409-5d57-9b08-aff95b9d2160@gmail.com>
 <b20d33eb-fd88-418c-57b6-32feb84d2373@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <578003e9-1af2-4df6-d9e1-cdbbbb701bf7@gmail.com>
Date:   Wed, 22 Jan 2020 06:16:40 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <b20d33eb-fd88-418c-57b6-32feb84d2373@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="nxVirGMUqE7BJEKscjFSeSPU3sU9IUgLs"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nxVirGMUqE7BJEKscjFSeSPU3sU9IUgLs
Content-Type: multipart/mixed; boundary="I1dRQRmOsgC8CQx7IPXAJUKCb7etVIZmJ";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Message-ID: <578003e9-1af2-4df6-d9e1-cdbbbb701bf7@gmail.com>
Subject: Re: [PATCH 3/3] io_uring: add splice(2) support
References: <cover.1579649589.git.asml.silence@gmail.com>
 <8bfd9a57bf42cfc10ee7195969058d6da277deed.1579649589.git.asml.silence@gmail.com>
 <6d43b9d7-209a-2bbf-e2c2-e125e84b46ab@kernel.dk>
 <14499431-0409-5d57-9b08-aff95b9d2160@gmail.com>
 <b20d33eb-fd88-418c-57b6-32feb84d2373@kernel.dk>
In-Reply-To: <b20d33eb-fd88-418c-57b6-32feb84d2373@kernel.dk>

--I1dRQRmOsgC8CQx7IPXAJUKCb7etVIZmJ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 22/01/2020 05:47, Jens Axboe wrote:
> On 1/21/20 7:40 PM, Pavel Begunkov wrote:
>>>> @@ -719,6 +730,11 @@ static const struct io_op_def io_op_defs[] =3D =
{
>>>>  		.needs_file		=3D 1,
>>>>  		.fd_non_neg		=3D 1,
>>>>  	},
>>>> +	[IORING_OP_SPLICE] =3D {
>>>> +		.needs_file		=3D 1,
>>>> +		.hash_reg_file		=3D 1,
>>>> +		.unbound_nonreg_file	=3D 1,
>>>> +	}
>>>>  };
>>>> =20
>>>>  static void io_wq_submit_work(struct io_wq_work **workptr);
>>>
>>> I probably want to queue up a reservation for the EPOLL_CTL that I
>>> haven't included yet, but which has been tested. But that's easily
>>> manageable, so no biggy on my end.
>>
>> I didn't quite get it. Do you mean collision of opcode numbers?
>=20
> Yeah that's all I meant, sorry wasn't too clear. But you can disregard,=

> I'll just pop a reservation in front if/when this is ready to go in if
> it's before EPOLL_CTL op.
>=20
>>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_u=
ring.h
>>>> index 57d05cc5e271..f234b13e7ed3 100644
>>>> --- a/include/uapi/linux/io_uring.h
>>>> +++ b/include/uapi/linux/io_uring.h
>>>> @@ -23,8 +23,14 @@ struct io_uring_sqe {
>>>>  		__u64	off;	/* offset into file */
>>>>  		__u64	addr2;
>>>>  	};
>>>> -	__u64	addr;		/* pointer to buffer or iovecs */
>>>> -	__u32	len;		/* buffer size or number of iovecs */
>>>> +	union {
>>>> +		__u64	addr;		/* pointer to buffer or iovecs */
>>>> +		__u64	off_out;
>>>> +	};
>>>> +	union {
>>>> +		__u32	len;	/* buffer size or number of iovecs */
>>>> +		__s32	fd_out;
>>>> +	};
>>>>  	union {
>>>>  		__kernel_rwf_t	rw_flags;
>>>>  		__u32		fsync_flags;
>>>> @@ -37,10 +43,12 @@ struct io_uring_sqe {
>>>>  		__u32		open_flags;
>>>>  		__u32		statx_flags;
>>>>  		__u32		fadvise_advice;
>>>> +		__u32		splice_flags;
>>>>  	};
>>>>  	__u64	user_data;	/* data to be passed back at completion time */
>>>>  	union {
>>>>  		__u16	buf_index;	/* index into fixed buffers, if used */
>>>> +		__u64	splice_len;
>>>>  		__u64	__pad2[3];
>>>>  	};
>>>>  };
>>>
>>> Not a huge fan of this, also mean splice can't ever used fixed buffer=
s.
>>> Hmm...
>>
>> But it's not like splice() ever uses user buffers. Isn't it? vmsplice
>> does, but that's another opcode.
>=20
> I guess that's true, I had vmsplice on my mind for this as well. But
> won't be a problem there, since it doesn't take 6 arguments like splice=

> does.
>=20
> Another option is to do an indirect for splice, stuff the arguments in =
a
> struct that's passed in as a pointer in ->addr. A bit slower, but
> probably not a huge deal.
>=20
>>>> @@ -67,6 +75,9 @@ enum {
>>>>  /* always go async */
>>>>  #define IOSQE_ASYNC		(1U << IOSQE_ASYNC_BIT)
>>>> =20
>>>> +/* op custom flags */
>>>> +#define IOSQE_SPLICE_FIXED_OUT	(1U << 16)
>>>> +
>>>
>>> I don't think it's unreasonable to say that if you specify
>>> IOSQE_FIXED_FILE, then both are fixed. If not, then none of them are.=

>>> What do you think?
>>>
>>
>> It's plausible to register only one end for splicing, e.g. splice from=

>> short-lived sockets to pre-registered buffers-pipes. And it's clearer
>> do it now.
>=20
> You're probably right, though it's a bit nasty to add an unrelated flag=

> in the splice flag space... We should probably reserve it in splice
> instead, and just not have it available from the regular system call.
>=20
Agree, it looks bad. I don't want to add it into sqe->splice_flags to not=
 clash
with splice(2) in the future, but could have a separate field in @sqe...
or can leave in in sqe->flags, as it's done in the patch, but that's like=
 a
portion of bits would be opcode specific and we would need to set rules f=
or
their use.

--=20
Pavel Begunkov


--I1dRQRmOsgC8CQx7IPXAJUKCb7etVIZmJ--

--nxVirGMUqE7BJEKscjFSeSPU3sU9IUgLs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIyBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4nvpkACgkQWt5b1Glr
+6Uqyw/2Pk7cle/Z6cJIzs3D+3fH7nMsze4hxd3gMpFDr4dn1mddynQ9HW36W+6Z
2YBrrHUr1lhir8CnPg7Ef8xIzYrKwW222gu+75FHXzcBEQF3o63KMeqigqeX6Ycb
UR1QcCZrV8CkI9AAGqF+y+lxie84TFdv9nnWlsZ8PEW290ioNhuABIfPxtXMC8oV
jcaa0OIh8ciHFila7Gm8kNoauuQZKwMmguz6kp8mv9kLHuU2iKQyNKff2rTslHFx
3U4Z1CZEZwJKvOKcTKME4BmEgYHFSbbANOlP7s1iW0gQkwVG1JqBeVNTR3UzfnpJ
YBxT2rSiUIsaN+ZHXh17L71EjJnS0j8rRqY8cmEgVBggtlmow32gF8Q64ugqRRcb
LrTqnkxmoKWW2+6RfrlOEUugNn2EkubY435YqVGKyr1gn1f8XSO5cJdDLcva2Ccs
UGz56zMrxdZYMSfBfaoIIoxMCdLjyd4Yx7FgaD0D05+kROr4EQcjmlsSVvmiageQ
MxPbxpCRCFRuIUUBWSHMtSiiojnrG1Tafytd+eIc5M1Gu22ElFiX1geaP6AuQAcd
8gDoC3kNlThpIFxrTD1k/gk69Pgbu9y5ESeEatDfA0MuJ2HZpd28n9/NQ05PV3mX
8TDSrw0YNd8ft9dvQjqPH5di/DDGRoWka+2VmVYVrQmECuJKXw==
=6T65
-----END PGP SIGNATURE-----

--nxVirGMUqE7BJEKscjFSeSPU3sU9IUgLs--
