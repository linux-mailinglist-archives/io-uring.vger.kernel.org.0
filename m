Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F16018F0FE
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2020 09:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbgCWIjJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Mar 2020 04:39:09 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37007 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727477AbgCWIjJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Mar 2020 04:39:09 -0400
Received: by mail-wr1-f68.google.com with SMTP id w10so15821788wrm.4
        for <io-uring@vger.kernel.org>; Mon, 23 Mar 2020 01:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=aVcnY+I+l9V2cLPu0WvCqapwmxY3gkc2f3PhkoSOJ8Q=;
        b=OdkCKiRp4V/X2df3Iswd8bbnzoCUHBqkd2KRpR22RcP8IT1eK0BV4xH6YXjdbrz4pn
         dNb84kPglmnvC/PFp3OPQNx7WiZN3HkgyFZ0ssF69ctDutsBNsYbRMNQ8nQPJGJC08u3
         +XwHPyXj0+D3CS6ipPeDraCkCX8DPizmDmLmf05h8cSJ8qJa3AKMX7odBvFep6cHHA+w
         lT8Y5ekHmTLNVlzPNHHFwzaM5zz5BZrMEg7ncqH+xQk5p/UfJxGM2D6M1ceOWRTDXFpr
         pRxkZfUnmvejj9P/oFzzuFWG30EzxbNGSPB34C333+jFDE2dufLRcS7K9nDLVoUOrsN2
         eITQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=aVcnY+I+l9V2cLPu0WvCqapwmxY3gkc2f3PhkoSOJ8Q=;
        b=mCMen3U6kXGQ85vlAQLdaAp4aINP+NCqS1IYZbLcG2gVxSuxoDM+1jlpvMgPYIZaOp
         fzhUtKOKhRnhr0Eiy41MY0HTioX3DQn+z9XVYfLXqld/I7Sxy7WYxV6A4JMr2HJJyBYA
         P8bJEIPZIu960pBfiEpps1GHOaouGjLL3OKAB2YlQgnGx+vxnPcyyVFKFQs0KmpRtMPi
         Jc+c4ZgGk4IaOwNBIKtV7OICyGTHzD6I99v15LFMncSvDUszd8W4Dx8KwiRTH8JjoeGi
         UYP46GTtiC4N/yoGF6DR37Sg7cowkv44a31h/unCOpG4WZrbkCwFvLg22KcEeF987tF7
         w9jQ==
X-Gm-Message-State: ANhLgQ0UgHF93uFVCxt3dHqgObiqRNBq6dIDk4R++FQzCfvrCL6YorYP
        Hdtu9I1jFNvNlAqKIceiUTvG6dSs
X-Google-Smtp-Source: ADFU+vvRBa4PQsV232SDS4F6ClcApxVTPSvI19mCXHzJb6gDR+/nSOH/eYZKFYWDRflbSYja/5BHqQ==
X-Received: by 2002:adf:f503:: with SMTP id q3mr28424698wro.135.1584952744662;
        Mon, 23 Mar 2020 01:39:04 -0700 (PDT)
Received: from [192.168.43.123] ([109.126.140.227])
        by smtp.gmail.com with ESMTPSA id h81sm22594097wme.42.2020.03.23.01.39.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2020 01:39:04 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <ab2e967f-754f-6dcf-95a0-4f24c47a9d5e@kernel.dk>
 <3454f8c1-3d5a-1f94-569a-41e553fc836a@gmail.com>
 <cd8541df-8f97-af3c-ea49-422e546ab648@gmail.com>
 <aa7049a8-179b-7c99-fce3-ac32b3500d31@gmail.com>
 <a6dedf7c-1c62-94f1-0b98-d926af2ea4b9@kernel.dk>
 <b8bc3645-a918-f058-7358-b2a541927202@gmail.com>
 <d2093dbe-7c75-340b-4c99-c88bdae450e6@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v2] io-wq: handle hashed writes in chains
Message-ID: <d316093f-46cd-7ae0-714a-7b90f3df5f1e@gmail.com>
Date:   Mon, 23 Mar 2020 11:38:04 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <d2093dbe-7c75-340b-4c99-c88bdae450e6@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FxI1HWLB8ulzcMhZg69xpg6CLnPQzK1eF"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FxI1HWLB8ulzcMhZg69xpg6CLnPQzK1eF
Content-Type: multipart/mixed; boundary="FfD6x6MiB5WKzp90CkbymDzPbJ4wtjM14";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Message-ID: <d316093f-46cd-7ae0-714a-7b90f3df5f1e@gmail.com>
Subject: Re: [PATCH v2] io-wq: handle hashed writes in chains
References: <ab2e967f-754f-6dcf-95a0-4f24c47a9d5e@kernel.dk>
 <3454f8c1-3d5a-1f94-569a-41e553fc836a@gmail.com>
 <cd8541df-8f97-af3c-ea49-422e546ab648@gmail.com>
 <aa7049a8-179b-7c99-fce3-ac32b3500d31@gmail.com>
 <a6dedf7c-1c62-94f1-0b98-d926af2ea4b9@kernel.dk>
 <b8bc3645-a918-f058-7358-b2a541927202@gmail.com>
 <d2093dbe-7c75-340b-4c99-c88bdae450e6@kernel.dk>
In-Reply-To: <d2093dbe-7c75-340b-4c99-c88bdae450e6@kernel.dk>

--FfD6x6MiB5WKzp90CkbymDzPbJ4wtjM14
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 23/03/2020 04:37, Jens Axboe wrote:
> On 3/22/20 2:25 PM, Pavel Begunkov wrote:
>> On 22/03/2020 22:51, Jens Axboe wrote:
>>> commit f1d96a8fcbbbb22d4fbc1d69eaaa678bbb0ff6e2
>>> Author: Pavel Begunkov <asml.silence@gmail.com>
>>> Date:   Fri Mar 13 22:29:14 2020 +0300
>>>
>>>     io_uring: NULL-deref for IOSQE_{ASYNC,DRAIN}
>>>
>>> which is what I ran into as well last week...
>>
>> I picked it before testing
>>
>>> The extra memory isn't a bit deal, it's very minor. My main concern
>>> would be fairness, since we'd then be grabbing non-contig hashed chun=
ks,
>>> before we did not. May not be a concern as long as we ensure the
>>> non-hasned (and differently hashed) work can proceed in parallel. For=
 my
>>> end, I deliberately added:
>>
>> Don't think it's really a problem, all ordering/scheduling is up to
>> users (i.e.  io_uring), and it can't infinitely postpone a work,
>> because it's processing spliced requests without taking more, even if
>> new ones hash to the same bit.
>=20
> I don't disagree with you, just wanted to bring it up!

Sure, there is a lot to think about. E.g. I don't like this reenqueueing,=

and if all other thread have enough work to do, then it can avoided, but =
don't
want to over-complicate.


>=20
>>> +	/* already have hashed work, let new worker get this */
>>> +	if (ret) {
>>> +		struct io_wqe_acct *acct;
>>> +
>>> +		/* get new worker for unhashed, if none now */
>>> +		acct =3D io_work_get_acct(wqe, work);
>>> +		if (!atomic_read(&acct->nr_running))
>>> +			io_wqe_wake_worker(wqe, acct);
>>> +		break;
>>> +	}
>>>
>>> to try and improve that.
>>
>> Is there performance problems with your patch without this chunk? I
>> may see another problem with yours, I need to think it through.
>=20
> No, and in fact it probably should be a separate thing, but I kind of
> like your approach so not moving forward with mine. I do think it's
> worth looking into separately, as there's no reason why we can't wake a=

> non-hashed worker if we're just doing hashed work from the existing
> thread. If that thread is just doing copies and not blocking, the
> unhashed (or next hashed) work is just sitting idle while it could be
> running instead.

Then, I'll clean the diff, hopefully soon. Could I steal parts of your pa=
tch
description?

>=20
> Hence I added that hunk, to kick a new worker to proceed in parallel.

It seems, I need to take a closer look at this accounting in general.


--=20
Pavel Begunkov


--FfD6x6MiB5WKzp90CkbymDzPbJ4wtjM14--

--FxI1HWLB8ulzcMhZg69xpg6CLnPQzK1eF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl54dXMACgkQWt5b1Glr
+6XOMBAAhsLkIqBK1we2IWHCbK99MwN93jd+RXuBMIKZtDIRKHW5+0el6CaULzNm
OX5lwDZDWsDlbeoIxj6lHIukuUUU2gGoeQHlDwHO5CatRPq5L98LCgBd+qxei0Bv
fwgRk/Dfzr+/anct3sRhp5lzYIVXSrEhb34DRzlFT7omm7qgeq4RexE1eqxb+gWL
D+wVhvJsQOHUC/HlXWYNFBmhHQGzaJKGOLXEzWeXbN7pLH1GBJnD+EVwbCPq5gp7
XI/N0QEXyjDzAjmlOfbcqrQ5lz9Ouu3QCRBCXGeHzmHxBA9jGzD9YA6j8DjlokgI
oCl9O/LtJ9sbxSK9VvS9ornqb+ieD4ux4t6GcfzvyDJRw9Vd6QSWdGp3TINGFxKM
pWMd1fXPLAgKK6m+NeZtm7kK0Z3R7ER7HshW8fbmtUwKH+KwqsBjg3A1TzPliLvo
KlduziSYgaHuZ+viIdnMjMQskS41WJSAMM4li+76sNhFCDzCHE5g7/oGKel0avBH
+iqBi4sX3g+37YZPVfmVSfjaBza0Q+IhKJR5ROm+o1GE68HxDoV1T8A7ECjGA21A
bIKgyhAVNP88Rt/GsdY62Tx7l8GW2pZOyrK+z8W5qq6wPGt/vk1jREG+/Lg0eM07
rgijyaCvuFA1d6mdaXWKJP7GtnvUujBDxN+UQZLkoQiy+J5kHqE=
=MIPX
-----END PGP SIGNATURE-----

--FxI1HWLB8ulzcMhZg69xpg6CLnPQzK1eF--
