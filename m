Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 526801449F9
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2020 03:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbgAVCky (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jan 2020 21:40:54 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35631 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728809AbgAVCky (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jan 2020 21:40:54 -0500
Received: by mail-wr1-f66.google.com with SMTP id g17so5664425wro.2;
        Tue, 21 Jan 2020 18:40:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=uv0JVeWuLnuWw4cunSWaOie7iTDt8ewQ9xGZK29HPCQ=;
        b=nKJTMzQ8dCY5d69TPFux8eXp6u0o0piQex4UF8NYQVeOyd8wsb8AfTVZ44s33hgAsO
         oGawd/ciu9wZ2YP/sTrV9eQTbUnE0iZo2TKn8dxrgahfHZwYkf4ncJ+ih+CB0RgwhhzK
         pazeyZHyJYWI+y17b8UwesMVaJfEipi8ziwx5oJlw3V3QrO/YxePH1P/3zAXUTeV9VlR
         rrVqI/PJjRDZT9mAt21q5s9yWvrsEZ7fJo30v1RWJh7I5+7IH9B9jekC5mezbNUG7VZ+
         prQ0bI7zNERrPbweQ1VluagA5g7+16wrdoUJP6p9rY31v/Umh7VvplJB2SIHfJ0R5eo+
         P3sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=uv0JVeWuLnuWw4cunSWaOie7iTDt8ewQ9xGZK29HPCQ=;
        b=l5ipPsqhKNyv1YjIRIGgw9Xgi9B1UfxA58R61m/7xxScIThBhK4rOgy1+3gFB170Fz
         ehZSU34OJPwdusTmcnS/TsuGVvebzBC0fpUOGO7NJ3zh5iTGGnp5YHXshyiZ8k4AiYgR
         GRmY5wERUi3PusdK596SQASjIs6FMam2Ux1eMmEU4mqpaJyIjsOJGZdZKZSPH6df3ghd
         aodv7y2UD4l55CIn3BUGL4Tgb0gpeLdVpSc37HaY9fZO8oaEyDuXCvwy5KPkoi8ej48i
         pw0KyCOqP+bOUDHhOhOVRS5bHCQ73XmWlkLNWbzMVucblDAa78JHbQozDfcUAKnwvA4/
         lJoA==
X-Gm-Message-State: APjAAAWKni9O7B9B922BdOxjerffvLZA633S1zZXr85TFH4hnI8HhG2w
        0X4z//uKJDeMdtudmsJcRuhZG4sY
X-Google-Smtp-Source: APXvYqzKteRCkpqRYp5HvcnHloYJ4tQULLMXpq5zFig228mEiIVnqlx7uGGpZY+eA+XZ8Rxng29qZg==
X-Received: by 2002:a5d:6a52:: with SMTP id t18mr8246539wrw.391.1579660850866;
        Tue, 21 Jan 2020 18:40:50 -0800 (PST)
Received: from [192.168.43.234] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id s65sm1905292wmf.48.2020.01.21.18.40.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 18:40:50 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>
References: <cover.1579649589.git.asml.silence@gmail.com>
 <8bfd9a57bf42cfc10ee7195969058d6da277deed.1579649589.git.asml.silence@gmail.com>
 <6d43b9d7-209a-2bbf-e2c2-e125e84b46ab@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 3/3] io_uring: add splice(2) support
Message-ID: <14499431-0409-5d57-9b08-aff95b9d2160@gmail.com>
Date:   Wed, 22 Jan 2020 05:40:10 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <6d43b9d7-209a-2bbf-e2c2-e125e84b46ab@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="lXivEkH9QzUixuS26PH3THlvzjFl094n7"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lXivEkH9QzUixuS26PH3THlvzjFl094n7
Content-Type: multipart/mixed; boundary="jyfqLxBUjXdw9UVZPL2uP1KgdFvKUCEdd";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Message-ID: <14499431-0409-5d57-9b08-aff95b9d2160@gmail.com>
Subject: Re: [PATCH 3/3] io_uring: add splice(2) support
References: <cover.1579649589.git.asml.silence@gmail.com>
 <8bfd9a57bf42cfc10ee7195969058d6da277deed.1579649589.git.asml.silence@gmail.com>
 <6d43b9d7-209a-2bbf-e2c2-e125e84b46ab@kernel.dk>
In-Reply-To: <6d43b9d7-209a-2bbf-e2c2-e125e84b46ab@kernel.dk>

--jyfqLxBUjXdw9UVZPL2uP1KgdFvKUCEdd
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 22/01/2020 05:03, Jens Axboe wrote:
> On 1/21/20 5:05 PM, Pavel Begunkov wrote:
>> @@ -373,6 +374,15 @@ struct io_rw {
>>  	u64				len;
>>  };
>> =20
>> +struct io_splice {
>> +	struct file			*file_in;
>> +	struct file			*file_out;
>> +	loff_t __user			*off_in;
>> +	loff_t __user			*off_out;
>> +	u64				len;
>> +	unsigned int			flags;
>> +};
>> +
>>  struct io_connect {
>>  	struct file			*file;
>>  	struct sockaddr __user		*addr;
>=20
> Probably just make that len u32 as per previous email.

Right, I don't want to have multiple types and names for it myself.

>=20
>> @@ -719,6 +730,11 @@ static const struct io_op_def io_op_defs[] =3D {
>>  		.needs_file		=3D 1,
>>  		.fd_non_neg		=3D 1,
>>  	},
>> +	[IORING_OP_SPLICE] =3D {
>> +		.needs_file		=3D 1,
>> +		.hash_reg_file		=3D 1,
>> +		.unbound_nonreg_file	=3D 1,
>> +	}
>>  };
>> =20
>>  static void io_wq_submit_work(struct io_wq_work **workptr);
>=20
> I probably want to queue up a reservation for the EPOLL_CTL that I
> haven't included yet, but which has been tested. But that's easily
> manageable, so no biggy on my end.

I didn't quite get it. Do you mean collision of opcode numbers?

>=20
>> +static bool io_splice_punt(struct file *file)
>> +{
>> +	if (get_pipe_info(file))
>> +		return false;
>> +	if (!io_file_supports_async(file))
>> +		return true;
>> +	return !(file->f_mode & O_NONBLOCK);
>> +}
>> +
>> +static int io_splice(struct io_kiocb *req, struct io_kiocb **nxt,
>> +		     bool force_nonblock)
>> +{
>> +	struct io_splice* sp =3D &req->splice;
>> +	struct file *in =3D sp->file_in;
>> +	struct file *out =3D sp->file_out;
>> +	unsigned int flags =3D sp->flags;
>> +	long ret;
>> +
>> +	if (force_nonblock) {
>> +		if (io_splice_punt(in) || io_splice_punt(out)) {
>> +			req->flags |=3D REQ_F_MUST_PUNT;
>> +			return -EAGAIN;
>> +		}
>> +		flags |=3D SPLICE_F_NONBLOCK;
>> +	}
>> +
>> +	ret =3D do_splice(in, sp->off_in, out, sp->off_out, sp->len, flags);=

>> +	if (force_nonblock && ret =3D=3D -EAGAIN)
>> +		return -EAGAIN;
>> +
>> +	io_put_file(req->ctx, out, (flags & IOSQE_SPLICE_FIXED_OUT));
>> +	io_cqring_add_event(req, ret);
>> +	if (ret !=3D sp->len)
>> +		req_set_fail_links(req);
>> +	io_put_req_find_next(req, nxt);
>> +	return 0;
>> +}
>=20
> This looks good. And this is why the put_file() needs to take separate
> arguments...
>=20
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uri=
ng.h
>> index 57d05cc5e271..f234b13e7ed3 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -23,8 +23,14 @@ struct io_uring_sqe {
>>  		__u64	off;	/* offset into file */
>>  		__u64	addr2;
>>  	};
>> -	__u64	addr;		/* pointer to buffer or iovecs */
>> -	__u32	len;		/* buffer size or number of iovecs */
>> +	union {
>> +		__u64	addr;		/* pointer to buffer or iovecs */
>> +		__u64	off_out;
>> +	};
>> +	union {
>> +		__u32	len;	/* buffer size or number of iovecs */
>> +		__s32	fd_out;
>> +	};
>>  	union {
>>  		__kernel_rwf_t	rw_flags;
>>  		__u32		fsync_flags;
>> @@ -37,10 +43,12 @@ struct io_uring_sqe {
>>  		__u32		open_flags;
>>  		__u32		statx_flags;
>>  		__u32		fadvise_advice;
>> +		__u32		splice_flags;
>>  	};
>>  	__u64	user_data;	/* data to be passed back at completion time */
>>  	union {
>>  		__u16	buf_index;	/* index into fixed buffers, if used */
>> +		__u64	splice_len;
>>  		__u64	__pad2[3];
>>  	};
>>  };
>=20
> Not a huge fan of this, also mean splice can't ever used fixed buffers.=

> Hmm...

But it's not like splice() ever uses user buffers. Isn't it? vmsplice doe=
s, but
that's another opcode.

>=20
>> @@ -67,6 +75,9 @@ enum {
>>  /* always go async */
>>  #define IOSQE_ASYNC		(1U << IOSQE_ASYNC_BIT)
>> =20
>> +/* op custom flags */
>> +#define IOSQE_SPLICE_FIXED_OUT	(1U << 16)
>> +
>=20
> I don't think it's unreasonable to say that if you specify
> IOSQE_FIXED_FILE, then both are fixed. If not, then none of them are.
> What do you think?
>=20

It's plausible to register only one end for splicing, e.g. splice from
short-lived sockets to pre-registered buffers-pipes. And it's clearer do =
it now.

--=20
Pavel Begunkov


--jyfqLxBUjXdw9UVZPL2uP1KgdFvKUCEdd--

--lXivEkH9QzUixuS26PH3THlvzjFl094n7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4ntgoACgkQWt5b1Glr
+6X8dg/+Orms56JFFtoCVVv0W3CPexJGtgCppXvNQbOxs2PjFPPXaAyRRith3psO
PbDsp6l3lOhbbNhiBjijXy1JZ9gAniioDX42iXmenv/Jo97EaD140yU9ZFpzSV/S
QDQidsk9aG+f6/ELIZN4C4z/h39DAe0ZyelG/XZHnO0ynGOSaNA+FEMW9P3rYH4f
UKxpj/70GBJ3/mzVWx1unzyniyOIPgl+t+1sm6HRNc1nc2Ke6tbq9z0I1DgicsnO
lPd/R0EuCVNoE/6hdOqNbJIQZPoJz+Y0yFYz0jb/U8kB6XBqqhUMy57pMmpcK0Vh
Yre+gy4wI6mu6JzxQQqiuldfWZA0c7FxH0I/zYuZw+epnggOB2OaTXfTynVDLSDh
/b0kEnkzy5mf+saNa8pEjtGVUsuakLMNpjNj1CltANub1UKWujNtHg9JYL5saRHJ
DHmMQCHSO3IC4prbrmQCk1uqsBU0rB6MaG/Qte/QzPEUgnAwfDlOT3+AHoiOmHC8
+jjR3E436GAyA3FtbyerHqT2RatjSg8/oaHw8zaZEQOS63syIYJpIY/r96ATrdF0
L5uywKAN1uhYtULQZwjSVsnXeeR89o4TzUoARI2o2wWzuDlwQFNz4/NoDZwPyzZk
dqr7NOwxSHOc0Xqi95ZgWWdrFZ2/pvQaZp0R4qVVHpJG4Y81rxM=
=JLeC
-----END PGP SIGNATURE-----

--lXivEkH9QzUixuS26PH3THlvzjFl094n7--
