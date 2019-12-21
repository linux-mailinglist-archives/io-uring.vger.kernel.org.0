Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9FB2128A33
	for <lists+io-uring@lfdr.de>; Sat, 21 Dec 2019 16:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfLUPhC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Dec 2019 10:37:02 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44259 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbfLUPhC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Dec 2019 10:37:02 -0500
Received: by mail-wr1-f66.google.com with SMTP id q10so12232482wrm.11;
        Sat, 21 Dec 2019 07:36:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=cqN6rHMpSSwnYM1gqLCGC2hS4mV8EuwGM4zu/FvHMUk=;
        b=N5f2Kzj93LqP9OhaQQCUp/ix++DhB/rO/mUt4ZfMxT+S1v2ly3RKbmJlUUsevgnoeF
         Y7+M1W+JV1HbokqeQJIy8yLFxXrUZzthIl6IEohWYac1CN76HWaC2I+i5/3omnp8Ngj+
         DI+oKEVm3ZbA8mE8P4vD//ZlWaP+WbezpP0UwGPJZBRC1LcRT1Zw+tSoWknUvXNhbtqP
         i5Y+nf4QayFWCcBtILL6PxHuj8ZXsQFJSPOBqQSzfVNeaby3E1bwepUqRYrmRjPauHVS
         qRbYPNId3OTk4sZKOo80nazFuWxjoON0NuvLgB5OZYpojQiBd1tIkX40WDTAjA07yjep
         Neig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=cqN6rHMpSSwnYM1gqLCGC2hS4mV8EuwGM4zu/FvHMUk=;
        b=qQmuxr0K4sQ5PdxpnQIZRpgxdVR0VwEUFy+Zx0OVjtZGf+/5CFeQMaqHbDiT1XUZaW
         9jdrXWpNOHZx5STam2RrXfb4d7GhgUTtUSvDUoM4Z6Ye0sL2nj4X/SShskYLRmeUenk1
         94DT8Ziu43ITc3ReF/MH8IIRMXLv1h98rjLGJWQId3fBpGc7Uifm8eByk5fixA9KfTep
         qz8zpuKHBzUd7uUSZdAT9GPhbNe9RHAUpwo69QNOYpLHkvsENcv9WIbIZiUnu+zt1Jtv
         rqEYdHh+NPa6B7SaZKuaQYFxAnSL3OUc8btis9nNaWXUgwT8/OJgQNMwDuqKq9/sMoCG
         jBBA==
X-Gm-Message-State: APjAAAVzSpzbOGgsNZ0P8CUpGnYcZQ1sInEUpWaoHDde5QCVnQAEnGoe
        v0ew4j/dSXMgB6W1DEwCYs3BBK4E
X-Google-Smtp-Source: APXvYqzcVIi4XKAQPWQAzfHRv3BqZbqJrkAP32aFpC/gigyKDyR5d6yhWYWJpa1FmcfXC5kaELinFw==
X-Received: by 2002:adf:93c6:: with SMTP id 64mr20128731wrp.212.1576942618287;
        Sat, 21 Dec 2019 07:36:58 -0800 (PST)
Received: from [192.168.43.10] ([109.126.149.134])
        by smtp.gmail.com with ESMTPSA id n8sm14013130wrx.42.2019.12.21.07.36.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Dec 2019 07:36:57 -0800 (PST)
Subject: Re: [PATCH 1/2] pcpu_ref: add percpu_ref_tryget_many()
To:     Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux.com>
References: <cover.1576621553.git.asml.silence@gmail.com>
 <c430d1a603f9ffe01661fc1b3bad6e3101a8b855.1576621553.git.asml.silence@gmail.com>
 <fe13d615-0fae-23e3-f133-49b727973d14@kernel.dk>
 <20191218162642.GC2914998@devbig004.ftw2.facebook.com>
 <20191218174955.GA14991@dennisz-mbp.dhcp.thefacebook.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <e90c5695-0357-a5e0-3c3a-64594c6e55a2@gmail.com>
Date:   Sat, 21 Dec 2019 18:36:32 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191218174955.GA14991@dennisz-mbp.dhcp.thefacebook.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3o66J1ZwYzbZnzQJ7MM5XEiLrkSizyNNG"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3o66J1ZwYzbZnzQJ7MM5XEiLrkSizyNNG
Content-Type: multipart/mixed; boundary="Jx8zujedjt6X5jhErYw1sz4LbnBZNdXBa";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux.com>
Message-ID: <e90c5695-0357-a5e0-3c3a-64594c6e55a2@gmail.com>
Subject: Re: [PATCH 1/2] pcpu_ref: add percpu_ref_tryget_many()
References: <cover.1576621553.git.asml.silence@gmail.com>
 <c430d1a603f9ffe01661fc1b3bad6e3101a8b855.1576621553.git.asml.silence@gmail.com>
 <fe13d615-0fae-23e3-f133-49b727973d14@kernel.dk>
 <20191218162642.GC2914998@devbig004.ftw2.facebook.com>
 <20191218174955.GA14991@dennisz-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191218174955.GA14991@dennisz-mbp.dhcp.thefacebook.com>

--Jx8zujedjt6X5jhErYw1sz4LbnBZNdXBa
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 18/12/2019 20:49, Dennis Zhou wrote:
> On Wed, Dec 18, 2019 at 08:26:42AM -0800, Tejun Heo wrote:
>> (cc'ing Dennis and Christoph and quoting whole body)
>>
>> Pavel, can you please cc percpu maintainers on related changes?

My bad, lost cc's in the way.

>>
>> The patch looks fine to me.  Please feel free to add my acked-by.
>>
>> On Tue, Dec 17, 2019 at 04:42:59PM -0700, Jens Axboe wrote:
>>> CC Tejun on this one. Looks fine to me, and matches the put path.

Thanks both for taking a look!

>>>
>>>
>>> On 12/17/19 3:28 PM, Pavel Begunkov wrote:
>>>> Add percpu_ref_tryget_many(), which works the same way as
>>>> percpu_ref_tryget(), but grabs specified number of refs.
>>>>
>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>> ---
>>>>  include/linux/percpu-refcount.h | 24 ++++++++++++++++++++----
>>>>  1 file changed, 20 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-=
refcount.h
>>>> index 390031e816dc..19079b62ce31 100644
>>>> --- a/include/linux/percpu-refcount.h
>>>> +++ b/include/linux/percpu-refcount.h
>>>> @@ -210,15 +210,17 @@ static inline void percpu_ref_get(struct percp=
u_ref *ref)
>>>>  }
>>>> =20
>>>>  /**
>>>> - * percpu_ref_tryget - try to increment a percpu refcount
>>>> + * percpu_ref_tryget_many - try to increment a percpu refcount
>>>>   * @ref: percpu_ref to try-get
>>>> + * @nr: number of references to get
>>>>   *
>>>>   * Increment a percpu refcount unless its count already reached zer=
o.
>>>>   * Returns %true on success; %false on failure.
>=20
> Minor nit: would be nice to change this so the two don't have identical=

> comments. (eg: Increment a percpu refcount by @nr unless...)
>>>>   *
>>>>   * This function is safe to call as long as @ref is between init an=
d exit.
>>>>   */
>>>> -static inline bool percpu_ref_tryget(struct percpu_ref *ref)
>>>> +static inline bool percpu_ref_tryget_many(struct percpu_ref *ref,
>>>> +					  unsigned long nr)
>>>>  {
>>>>  	unsigned long __percpu *percpu_count;
>>>>  	bool ret;
>>>> @@ -226,10 +228,10 @@ static inline bool percpu_ref_tryget(struct pe=
rcpu_ref *ref)
>>>>  	rcu_read_lock();
>>>> =20
>>>>  	if (__ref_is_percpu(ref, &percpu_count)) {
>>>> -		this_cpu_inc(*percpu_count);
>>>> +		this_cpu_add(*percpu_count, nr);
>>>>  		ret =3D true;
>>>>  	} else {
>>>> -		ret =3D atomic_long_inc_not_zero(&ref->count);
>>>> +		ret =3D atomic_long_add_unless(&ref->count, nr, 0);
>>>>  	}
>>>> =20
>>>>  	rcu_read_unlock();
>>>> @@ -237,6 +239,20 @@ static inline bool percpu_ref_tryget(struct per=
cpu_ref *ref)
>>>>  	return ret;
>>>>  }
>>>> =20
>>>> +/**
>>>> + * percpu_ref_tryget - try to increment a percpu refcount
>>>> + * @ref: percpu_ref to try-get
>>>> + *
>>>> + * Increment a percpu refcount unless its count already reached zer=
o.
>>>> + * Returns %true on success; %false on failure.
>>>> + *
>>>> + * This function is safe to call as long as @ref is between init an=
d exit.
>>>> + */
>>>> +static inline bool percpu_ref_tryget(struct percpu_ref *ref)
>>>> +{
>>>> +	return percpu_ref_tryget_many(ref, 1);
>>>> +}
>>>> +
>>>>  /**
>>>>   * percpu_ref_tryget_live - try to increment a live percpu refcount=

>>>>   * @ref: percpu_ref to try-get
>>>>
>>>
>>>
>>> --=20
>>> Jens Axboe
>>>
>>
>> --=20
>> tejun
>=20
> Acked-by: Dennis Zhou <dennis@kernel.org>
>=20
> Thanks,
> Dennis
>=20

--=20
Pavel Begunkov


--Jx8zujedjt6X5jhErYw1sz4LbnBZNdXBa--

--3o66J1ZwYzbZnzQJ7MM5XEiLrkSizyNNG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl3+PAAACgkQWt5b1Glr
+6Xjog//X7kw1OUa2qr1kVtmvkQFCER2aJ3gmT7aYGI4gnTJQvDFryefpqi9Vvoa
UCt9uahVMMaeaSeIvOY6Ol9iwVNVwTqj9hFr3ZTpVW+3MfdPR5LNQUf1RCd2Oyqq
0d09jnChLfUGFhiSPBQLKAYkxGTxFGjworgpONe3nrwDKg7foPvpNMjnP79DIpZ5
JpwHiachIEi2tDpjtgD4ZbBkLMydE4rQWfFg1/7QAUAPFlGmN7KqhYaNaLumj74r
CJk5B2IzlTmjJE4CxGJl0la23TdCRd1yFRda5hRfXkVmvPgQtIkLbgcJAhADx9h1
FPvWS8AZbZLYmxOm0eWi38Rw/KcY234gL8vTgy7215i/oE8WrVlSbgfZBioL3wgM
VJrhZZcFHQ4EbrR2lt5//lF5Zy/2WO2sTZZeib0SgOSn7xt5a3WnK+NzcorRiqL6
wEIq3UN4/drz7pV80v0akG09uVXU5xxZTU5L2LeDJiwRYtO94dURSkkZYxvxkXv2
pjOUiPLlm47b2ZecLzpJdhPxLoWCQLtsJl3H+HeniL0r78a9Yrzj0ku/Ye4yp8YI
VgzZuGX6s/B+vZ7mSC7jMek2M3ud4dS3O5vuq3cjnlxy68N3V8w4PWgt9S33qs3F
xSuZPw+17ECq1fdtz9oex1/0J/9VekYa+RG4cFtI9SoNMe8+YJg=
=RMCN
-----END PGP SIGNATURE-----

--3o66J1ZwYzbZnzQJ7MM5XEiLrkSizyNNG--
