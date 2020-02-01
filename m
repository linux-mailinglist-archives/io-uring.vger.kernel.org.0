Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A63E914F7A1
	for <lists+io-uring@lfdr.de>; Sat,  1 Feb 2020 12:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgBALax (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 1 Feb 2020 06:30:53 -0500
Received: from mail-wr1-f51.google.com ([209.85.221.51]:38926 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbgBALax (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 1 Feb 2020 06:30:53 -0500
Received: by mail-wr1-f51.google.com with SMTP id y11so11727590wrt.6
        for <io-uring@vger.kernel.org>; Sat, 01 Feb 2020 03:30:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=f1GRx3vB4gpQksg3N9idUR0thDhHfm3loNuGo7UP0mc=;
        b=GewutjqZkuPvvxMrcdl5tCJFenxmGrnLjjSrV+lUT1X1nueHtxwFVp44tcqM83GnC/
         RNdzNPcQpCYtiOeCDxYTrrRFhvf4w70KBR3JyFLqH4IFSP86Ab3DeQAXKKM54vwgaSS9
         1ja9cRIV+3mLcMg6eHnvuUbxeWiqU2Ydqbj7YF3dHKsDM1lCF+GmPc47g+/6AIcMNATk
         crTXf8pRsRA59N/IUmoX9gz9AY8zZme8P7XjLWfP63R4N79ieRkaLCSsouEAxVJBqZTi
         HC7QcV3pOSkumsR40gWaKoGmihuOpkwvYJicFVrUZLQACRsgS/OJDF889c/q7VaX0GgZ
         hvuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=f1GRx3vB4gpQksg3N9idUR0thDhHfm3loNuGo7UP0mc=;
        b=Vf8V0P6VPoBONqaHiXY9tKFeRrhShdYapSMy0cpu4ulUYZ9k2+xxcZKAXCjwLU+oTT
         +wxKtfttkC0kbOTwL572C8FgRfdeARu96+OOV2Nd3fRZ1vji+M6yeHagLg4AGVLM4fsA
         Sx705CsP2i90vhUAJhTQOFbCfUuRR+iHBywc/jtTeiRSIgFuT0KkMEJ5E1yOj1NKoH5r
         DWZOhLfIbvgRsMA8+cxTQP0wTHB9yHXR9cSnu67CM4VarCqBYLnqX9WNTUbiPTVP8bKv
         f9ZHbKf0MvVl9xpvqas6Re44luhyXRkInGWgLo4IruE5T+KFPE9qKRDEpgr321pAbkik
         DKzw==
X-Gm-Message-State: APjAAAWbhZ/j11ByFULj7Mkd2cV4nX3N5N7VjWccvMcd3zwjlc5qTtEJ
        vVyw4qDkRgA7vDwkQi2jVX9S2vGY
X-Google-Smtp-Source: APXvYqxh00SUX0Tlc7jJ7eW4di3ttsMsYMThDUMpWWEE7PiJ+kjx/diqXh7IotPW7FeMhnKKN9bIlw==
X-Received: by 2002:a5d:620b:: with SMTP id y11mr4228625wru.230.1580556650395;
        Sat, 01 Feb 2020 03:30:50 -0800 (PST)
Received: from [192.168.43.154] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id p26sm13998022wmc.24.2020.02.01.03.30.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2020 03:30:49 -0800 (PST)
To:     Andres Freund <andres@anarazel.de>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
References: <20200201091839.eji7fwudvozr3deb@alap3.anarazel.de>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: What does IOSQE_IO_[HARD]LINK actually mean?
Message-ID: <a7d492a6-b8cf-4128-fdde-879371b7913f@gmail.com>
Date:   Sat, 1 Feb 2020 14:30:06 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200201091839.eji7fwudvozr3deb@alap3.anarazel.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7ZZUWIqY1aJnc8JsPIZFepNrSc6huQ6zZ"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7ZZUWIqY1aJnc8JsPIZFepNrSc6huQ6zZ
Content-Type: multipart/mixed; boundary="Hq3yl7KcrtKjLycLjfPJsO4wcRMZgjYDP";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Andres Freund <andres@anarazel.de>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
Message-ID: <a7d492a6-b8cf-4128-fdde-879371b7913f@gmail.com>
Subject: Re: What does IOSQE_IO_[HARD]LINK actually mean?
References: <20200201091839.eji7fwudvozr3deb@alap3.anarazel.de>
In-Reply-To: <20200201091839.eji7fwudvozr3deb@alap3.anarazel.de>

--Hq3yl7KcrtKjLycLjfPJsO4wcRMZgjYDP
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 01/02/2020 12:18, Andres Freund wrote:
> Hi,
>=20
> Reading the manpage from liburing I read:
>        IOSQE_IO_LINK
>               When  this  flag is specified, it forms a link with the n=
ext SQE in the submission ring. That next SQE
>               will not be started before this one completes.  This, in =
effect, forms a chain of SQEs, which  can  be
>               arbitrarily  long. The tail of the chain is denoted by th=
e first SQE that does not have this flag set.
>               This flag has no effect on previous SQE submissions, nor =
does it impact SQEs that are outside  of  the
>               chain  tail.  This  means  that multiple chains can be ex=
ecuting in parallel, or chains and individual
>               SQEs. Only members inside the chain are serialized. Avail=
able since 5.3.
>=20
>        IOSQE_IO_HARDLINK
>               Like IOSQE_IO_LINK, but it doesn't sever regardless of th=
e completion result.  Note that the link will
>               still sever if we fail submitting the parent request, har=
d links are only resilient in the presence of
>               completion results for requests that did submit correctly=
=2E  IOSQE_IO_HARDLINK  implies  IOSQE_IO_LINK.
>               Available since 5.5.
>=20
> I can make some sense out of that description of IOSQE_IO_LINK without
> looking at kernel code. But I don't think it's possible to understand
> what happens when an earlier chain member fails, and what denotes an
> error.  IOSQE_IO_HARDLINK's description kind of implies that
> IOSQE_IO_LINK will not start the next request if there was a failure,
> but doesn't define failure either.
>=20

Right, after a "failure" occurred for a IOSQE_IO_LINK request, all subseq=
uent
requests in the link won't be executed, but completed with -ECANCELED. Ho=
wever,
if IOSQE_IO_HARDLINK set for the request, it won't sever/break the link a=
nd will
continue to the next one.

> Looks like it's defined in a somewhat adhoc manner. For file read/write=

> subsequent requests are failed if they are a short read/write. But
> e.g. for sendmsg that looks not to be the case.
>=20

As you said, it's defined rather sporadically. We should unify for it to =
make
sense. I'd prefer to follow the read/write pattern.

> Perhaps it'd make sense to reject use of IOSQE_IO_LINK outside ops wher=
e
> it's meaningful?

If we disregard it for either length-based operations or the rest ones (o=
r
whatever combination), the feature won't be flexible enough to be useful,=

but in combination it allows to remove much of context switches.

--=20
Pavel Begunkov


--Hq3yl7KcrtKjLycLjfPJsO4wcRMZgjYDP--

--7ZZUWIqY1aJnc8JsPIZFepNrSc6huQ6zZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl41YUMACgkQWt5b1Glr
+6WYQxAAuUVBNx5BcJs7tqLmYwrfmJmEqqBXN4xCjVUvzWTAt1psHqOdiBCidFp7
Zo1FDoXsZxLbwXXAHmBWShTwJZ3l7v5vhs+FZJthsUq1h+A1a7hFs58HBKzPVHR8
o+MiBNnfqIALLp0itHyk5ulO0sQ9f+XsZm2Xv3ziL5gIzTfxWcL5fTs34/1jHonP
ONMUsC7D8Q0yy5tO5XuJIY97wN2EZkKukYhKrgAszdWe7vhm9LUsY7LBcxQYw/zv
ab6qC4pTfcpeLt56kIXL6B7a9+uxMNFKxgLQH/hOxixkcF2susUfsk88NfeTytmv
yhoXhFMW4D67auuQZHV2iVddziU2QJvLFx45QDxiQkM90tztCr1nFdvACPIJbAdJ
ojCRQ8OfYQmeuOvupOenZB5NJq/b7uWS0men5viGrPghoGVTsy04JRi8uSe5kZnX
6VAR1cMQzsCZU0cjrSiZxJmi8MsKgqWnDNB/MsMMWds9lUE3qplumCNu5QwXJZvM
w72U15suKoIP7WU1qYTZlO/hxiEPH+dCWatd6QQK0qWcxuT/O/eBF8kICFh2lqYn
GiuKvXFHwGmlSNqIgM1UaNk9Rv9tZRveI/0WUPAV/dVyGqAlSc/VBSxyb+TdgTgk
bYL1VG9opPD1rb0pw7Wt0QEZjweDunKooDyYXUaE+WU4rfrFAKE=
=wNkz
-----END PGP SIGNATURE-----

--7ZZUWIqY1aJnc8JsPIZFepNrSc6huQ6zZ--
