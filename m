Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D422154A1F
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2020 18:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgBFRRP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Feb 2020 12:17:15 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:43524 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727685AbgBFRRP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Feb 2020 12:17:15 -0500
Received: by mail-ed1-f65.google.com with SMTP id dc19so6746834edb.10;
        Thu, 06 Feb 2020 09:17:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=n6tLusFcTcCrQia8MaGxTBTLWVMhS/op7lcTxBmiCOs=;
        b=PWljFkdR4YJiIw5eTqVWIJ6p6DnYlnxyAozM/eU4duuxbR/8EICtqSWFHZ/YxmwJKD
         PsHMI/hkL55rzb23c+Axuf6nKDf2v4Bdml14WNMXoiSvSswJAk8Zbn5anG6q70C2PqIA
         OJpe9VpJ0Ely59vimvrXO0MmtNRyA0MHbcFBXarD87UArdW6+FVHXC9o5awOuzmnUASN
         AiUKMkzVCWxt/VpowTHNjsvXH6SDfGKqPIP0VfPLNhi2c4jRhZXQ53VDGMrpJcdJEmA9
         NyndSkwlXGRNk2plOItrPJ4qzfi+DyizhTmhzijibUvVTVRrL7EFji0jxbJh48ueV8Fq
         oMpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=n6tLusFcTcCrQia8MaGxTBTLWVMhS/op7lcTxBmiCOs=;
        b=tjNwhIOcTzBK3aU+dBn2naZp4H/8idxCQpEklOjOaXhqcKy0CfYOaoo98jrcp32MH2
         btZOISFbwsL+p65mKgFnrAziNvMr7vVmsgZfL8Oh/iYu1GaF5OqADefFSy9kY6hLeOqB
         x26jcMtgiXqJ7Mt3OTmHgll/Dj/wGiDa7P6bxpaapunwsJOgOLwGxRSXloMpMApDw7Rr
         gS6jbXYlVxpqxVhwiNXGshZq0VRLGq4sJyzpkp9K1AbMRH1sjLGF6o6Gte3kyDrVFRzs
         I5iMGfRnplMjeZcql3FV8fH+pC1S+DBt4eAJDYcbFYvNtdJMwbPytUt9w8KE0akOrVYv
         Ik5A==
X-Gm-Message-State: APjAAAXUCk0SkrClXny1PN3T6fFykcc48kCWe5WnGM6hLrBP5EVt1sUR
        /nTWTdAmeRnF5n2ATuKa+iodnPEs
X-Google-Smtp-Source: APXvYqzFtZTVfMyW1Jhir3qTXUtWYssxIJJXvS3q+4/DLfn6GbiRyFHRO5UmEHu4lp4PZO38CmKZoA==
X-Received: by 2002:a50:cc08:: with SMTP id m8mr4076809edi.263.1581009432173;
        Thu, 06 Feb 2020 09:17:12 -0800 (PST)
Received: from [192.168.43.69] ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id sa9sm14670ejb.28.2020.02.06.09.17.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2020 09:17:11 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix deferred req iovec leak
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <e143e45a34dce9d271fc4a3b32f7620c5a7377c1.1581007844.git.asml.silence@gmail.com>
 <d8486857-ccd3-41bd-2ef7-5ac4781dbd5f@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <f6a1d5aa-f84d-168e-4fdf-6fb895fc09df@gmail.com>
Date:   Thu, 6 Feb 2020 20:16:30 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <d8486857-ccd3-41bd-2ef7-5ac4781dbd5f@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="nlEFCqx3EMLZ7N6f0i3tW86kxkXHeczHF"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nlEFCqx3EMLZ7N6f0i3tW86kxkXHeczHF
Content-Type: multipart/mixed; boundary="6fvX7nXrhSqd0QqyLfGGDzwzCbIoSIHxB";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <f6a1d5aa-f84d-168e-4fdf-6fb895fc09df@gmail.com>
Subject: Re: [PATCH] io_uring: fix deferred req iovec leak
References: <e143e45a34dce9d271fc4a3b32f7620c5a7377c1.1581007844.git.asml.silence@gmail.com>
 <d8486857-ccd3-41bd-2ef7-5ac4781dbd5f@gmail.com>
In-Reply-To: <d8486857-ccd3-41bd-2ef7-5ac4781dbd5f@gmail.com>

--6fvX7nXrhSqd0QqyLfGGDzwzCbIoSIHxB
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 06/02/2020 20:04, Pavel Begunkov wrote:
> On 06/02/2020 19:51, Pavel Begunkov wrote:
>> After defer, a request will be prepared, that includes allocating iove=
c
>> if needed, and then submitted through io_wq_submit_work() but not cust=
om
>> handler (e.g. io_rw_async()/io_sendrecv_async()). However, it'll leak
>> iovec, as it's in io-wq and the code goes as follows:
>>
>> io_read() {
>> 	if (!io_wq_current_is_worker())
>> 		kfree(iovec);
>> }
>>
>> Put all deallocation logic in io_{read,write,send,recv}(), which will
>> leave the memory, if going async with -EAGAIN.
>>
> Interestingly, this will fail badly if it returns -EAGAIN from io-wq co=
ntext.
> Apparently, I need to do v2.
>=20
Or not...
Jens, can you please explain what's with the -EAGAIN handling in
io_wq_submit_work()? Checking the code, it seems neither of
read/write/recv/send can return -EAGAIN from async context (i.e.
force_nonblock=3Dfalse). Are there other ops that can do it?


>> It also fixes a leak after failed io_alloc_async_ctx() in
>> io_{recv,send}_msg().
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>  fs/io_uring.c | 47 ++++++++++++-----------------------------------
>>  1 file changed, 12 insertions(+), 35 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index bff7a03e873f..ce3dbd2b1b5c 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -2143,17 +2143,6 @@ static int io_alloc_async_ctx(struct io_kiocb *=
req)
>>  	return req->io =3D=3D NULL;
>>  }
>> =20
>> -static void io_rw_async(struct io_wq_work **workptr)
>> -{
>> -	struct io_kiocb *req =3D container_of(*workptr, struct io_kiocb, wor=
k);
>> -	struct iovec *iov =3D NULL;
>> -
>> -	if (req->io->rw.iov !=3D req->io->rw.fast_iov)
>> -		iov =3D req->io->rw.iov;
>> -	io_wq_submit_work(workptr);
>> -	kfree(iov);
>> -}
>> -
>>  static int io_setup_async_rw(struct io_kiocb *req, ssize_t io_size,
>>  			     struct iovec *iovec, struct iovec *fast_iov,
>>  			     struct iov_iter *iter)
>> @@ -2166,7 +2155,6 @@ static int io_setup_async_rw(struct io_kiocb *re=
q, ssize_t io_size,
>> =20
>>  		io_req_map_rw(req, io_size, iovec, fast_iov, iter);
>>  	}
>> -	req->work.func =3D io_rw_async;
>>  	return 0;
>>  }
>> =20
>> @@ -2253,8 +2241,7 @@ static int io_read(struct io_kiocb *req, struct =
io_kiocb **nxt,
>>  		}
>>  	}
>>  out_free:
>> -	if (!io_wq_current_is_worker())
>> -		kfree(iovec);
>> +	kfree(iovec);
>>  	return ret;
>>  }
>> =20
>> @@ -2359,8 +2346,7 @@ static int io_write(struct io_kiocb *req, struct=
 io_kiocb **nxt,
>>  		}
>>  	}
>>  out_free:
>> -	if (!io_wq_current_is_worker())
>> -		kfree(iovec);
>> +	kfree(iovec);
>>  	return ret;
>>  }
>> =20
>> @@ -2955,19 +2941,6 @@ static int io_sync_file_range(struct io_kiocb *=
req, struct io_kiocb **nxt,
>>  	return 0;
>>  }
>> =20
>> -#if defined(CONFIG_NET)
>> -static void io_sendrecv_async(struct io_wq_work **workptr)
>> -{
>> -	struct io_kiocb *req =3D container_of(*workptr, struct io_kiocb, wor=
k);
>> -	struct iovec *iov =3D NULL;
>> -
>> -	if (req->io->rw.iov !=3D req->io->rw.fast_iov)
>> -		iov =3D req->io->msg.iov;
>> -	io_wq_submit_work(workptr);
>> -	kfree(iov);
>> -}
>> -#endif
>> -
>>  static int io_sendmsg_prep(struct io_kiocb *req, const struct io_urin=
g_sqe *sqe)
>>  {
>>  #if defined(CONFIG_NET)
>> @@ -3036,17 +3009,19 @@ static int io_sendmsg(struct io_kiocb *req, st=
ruct io_kiocb **nxt,
>>  		if (force_nonblock && ret =3D=3D -EAGAIN) {
>>  			if (req->io)
>>  				return -EAGAIN;
>> -			if (io_alloc_async_ctx(req))
>> +			if (io_alloc_async_ctx(req)) {
>> +				if (kmsg && kmsg->iov !=3D kmsg->fast_iov)
>> +					kfree(kmsg->iov);
>>  				return -ENOMEM;
>> +			}
>>  			memcpy(&req->io->msg, &io.msg, sizeof(io.msg));
>> -			req->work.func =3D io_sendrecv_async;
>>  			return -EAGAIN;
>>  		}
>>  		if (ret =3D=3D -ERESTARTSYS)
>>  			ret =3D -EINTR;
>>  	}
>> =20
>> -	if (!io_wq_current_is_worker() && kmsg && kmsg->iov !=3D kmsg->fast_=
iov)
>> +	if (kmsg && kmsg->iov !=3D kmsg->fast_iov)
>>  		kfree(kmsg->iov);
>>  	io_cqring_add_event(req, ret);
>>  	if (ret < 0)
>> @@ -3180,17 +3155,19 @@ static int io_recvmsg(struct io_kiocb *req, st=
ruct io_kiocb **nxt,
>>  		if (force_nonblock && ret =3D=3D -EAGAIN) {
>>  			if (req->io)
>>  				return -EAGAIN;
>> -			if (io_alloc_async_ctx(req))
>> +			if (io_alloc_async_ctx(req)) {
>> +				if (kmsg && kmsg->iov !=3D kmsg->fast_iov)
>> +					kfree(kmsg->iov);
>>  				return -ENOMEM;
>> +			}
>>  			memcpy(&req->io->msg, &io.msg, sizeof(io.msg));
>> -			req->work.func =3D io_sendrecv_async;
>>  			return -EAGAIN;
>>  		}
>>  		if (ret =3D=3D -ERESTARTSYS)
>>  			ret =3D -EINTR;
>>  	}
>> =20
>> -	if (!io_wq_current_is_worker() && kmsg && kmsg->iov !=3D kmsg->fast_=
iov)
>> +	if (kmsg && kmsg->iov !=3D kmsg->fast_iov)
>>  		kfree(kmsg->iov);
>>  	io_cqring_add_event(req, ret);
>>  	if (ret < 0)
>>
>=20

--=20
Pavel Begunkov


--6fvX7nXrhSqd0QqyLfGGDzwzCbIoSIHxB--

--nlEFCqx3EMLZ7N6f0i3tW86kxkXHeczHF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl48Se4ACgkQWt5b1Glr
+6WDGBAAiLsrwv5Xene66AngmHzs9cwYCdb1CXMYySSl38p4+9a8dmzQDzT3ht7l
TAgMjVOHrscnF7x22+vPBVJHEco0iibujb5/97DQLcXIhELkqd5+G29k2HZjgOfP
g5mPMDjgT54+5Y18AZxRCWZLeY8k8lAaSqvQrXaRau2lKlFMBT0XRksS+J4I7y8E
sftOoQqSvt+Q14xcXSZNwGQliI2g7dLQriByL1s9IJa+OK2QdiCGKdC3adA03vdT
z711nPtcPRR+7fz1UlmlEvdLBpH4OhNGeKWW5+dWHjmD+aodK4ih0Mws1zhIkJ3G
eXXe6t6hTEbGzqUPLKljOZsWrDJr3fatKhWRJlH7m36uVZ7w6KyoBue2ntHT8Rin
7d6E/3zfaKYTtGR01Slfoy8gYRsU+mhpDe+n28sLuBt4d7tQh63tXAc+oYLqmHWa
sfhGU9uYcYW1ZR+rXxvRM215l2IjFVSxbAKRXdTUqiTcctV8m7w0H+nTgiU3l+A4
Tfw8FMSos5NhhskjkTEOi72r17/hXPohHu4X3gAf7LX654eFYYwGhhSzIkJh1set
lLDHsp87F7w1G6ASakh6PYq/i6HBA6fFiUUfojTf3DwiJ00no9TlLa9vQ5UF8b4T
PTc4hfDOXxKhCuJ8XbM8CB/LF1LXIRwExotZSY3V0GlDb3AhHqg=
=bHCc
-----END PGP SIGNATURE-----

--nlEFCqx3EMLZ7N6f0i3tW86kxkXHeczHF--
