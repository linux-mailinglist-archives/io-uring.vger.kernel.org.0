Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 924B53203A0
	for <lists+io-uring@lfdr.de>; Sat, 20 Feb 2021 04:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhBTD6l (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 22:58:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhBTD6k (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 22:58:40 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F903C061574
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 19:57:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=LzDggbAvlqCMNN6PZNMBSn+AA//Zu3EwK3eUcTYFhIk=; b=QEuwQJJPzyQtbXQKhFcRuhfN45
        6uhmut/TipTCHYKfcGF+HpYXD9rB3bKWf1MGUUEpqLimiEMTpR+KHg7EGqXRvt/NzoRnt+iB+C1Ps
        mrraxaRT+jrpHilfj9OSR2F5z65mKtw6QusYRDFWe1XV58VdqOSxFkc6K3yPiGLQqQvhqDj8LhQbs
        XjtokXwq9OltMf7qCNE/CZOPzAGKL//7FQAP2HmXZLWqAQI6R/WNwhGf3wJZoqjHGmIUPpygaYfRo
        +uL6Akn1N+Z02KRQVFd6hW8QKFdjHsoh4QzzyCOBNKiaoDIyEtVcU5Sy2sGfVhJYbLMR9n+u9pSgD
        QQ/DLN0eSItUvYEcTVqgyRmNqw6m07j7wHj6oM+NZgtjUeyWC+C4IIdjGDKyIRbDNh88i9MltIrk0
        A2oH+/bf/KkKfASdHJsh/FZ0ioh0KVktJrZu6WdyZxQblUyz8wGN9e0RmWAyB9WtVCx6Y/h6gpC7Z
        HIQ8hRm4AlOH5YyrJPSrrQl5;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lDJP3-0002p4-BF; Sat, 20 Feb 2021 03:57:57 +0000
To:     Jens Axboe <axboe@kernel.dk>, "Darrick J. Wong" <djwong@kernel.org>
Cc:     io-uring@vger.kernel.org
References: <20210127212541.88944-1-axboe@kernel.dk>
 <20210127212541.88944-3-axboe@kernel.dk> <20210128003831.GE7695@magnolia>
 <67627096-6d30-af3a-9545-1446909a38c4@kernel.dk>
 <f8576940-5441-1355-c09e-db60ad0ac889@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
Autocrypt: addr=metze@samba.org; prefer-encrypt=mutual; keydata=
 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
 uAMlsTqBMFOwuvAcYAj2bwl7QQU6yhU=
Subject: Re: [PATCH 2/5] io_uring: add support for IORING_OP_URING_CMD
Message-ID: <81d6c90e-b853-27c0-c4b7-23605bd4abae@samba.org>
Date:   Sat, 20 Feb 2021 04:57:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f8576940-5441-1355-c09e-db60ad0ac889@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="2SK7RlM7LEeBLdC7Vos0T3YsYtQYsp9pc"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2SK7RlM7LEeBLdC7Vos0T3YsYtQYsp9pc
Content-Type: multipart/mixed; boundary="3ysAzCUcTp80QNpAuw7eAOOkeRdskGqUd";
 protected-headers="v1"
From: Stefan Metzmacher <metze@samba.org>
To: Jens Axboe <axboe@kernel.dk>, "Darrick J. Wong" <djwong@kernel.org>
Cc: io-uring@vger.kernel.org
Message-ID: <81d6c90e-b853-27c0-c4b7-23605bd4abae@samba.org>
Subject: Re: [PATCH 2/5] io_uring: add support for IORING_OP_URING_CMD
References: <20210127212541.88944-1-axboe@kernel.dk>
 <20210127212541.88944-3-axboe@kernel.dk> <20210128003831.GE7695@magnolia>
 <67627096-6d30-af3a-9545-1446909a38c4@kernel.dk>
 <f8576940-5441-1355-c09e-db60ad0ac889@kernel.dk>
In-Reply-To: <f8576940-5441-1355-c09e-db60ad0ac889@kernel.dk>

--3ysAzCUcTp80QNpAuw7eAOOkeRdskGqUd
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Am 28.01.21 um 03:19 schrieb Jens Axboe:
>>> Assuming that I got that right, that means that the pdu information
>>> doesn't actually go all the way to the end of the sqe, which currentl=
y
>>> is just a bunch of padding.  Was that intentional, or does this mean
>>> that io_uring_pdu could actually be 8 bytes longer?
>>
>> Also correct. The reason is actually kind of stupid, and I think we
>> should just fix that up. struct io_uring_cmd should fit within the fir=
st
>> cacheline of io_kiocb, to avoid bloating that one. But with the member=
s
>> in there, it ends up being 8 bytes too big, if we grab those 8 bytes.
>> What I think we should do is get rid of ->done, and just have drivers
>> call io_uring_cmd_done() instead. We can provide an empty hook for tha=
t.
>> Then we can reclaim the 8 bytes, and grow the io_uring_cmd to 56 bytes=
=2E
>=20
> Pushed out that version:
>=20
> https://git.kernel.dk/cgit/linux-block/log/?h=3Dio_uring-fops.v2
>=20
> which gives you the full 56 bytes for the payload command.

I think we only have 48 bytes for the payload.

I've rebased and improved your io_uring-fops.v2 on top of your io_uring-w=
orker.v3.

See https://git.samba.org/?p=3Dmetze/linux/wip.git;a=3Dshortlog;h=3Drefs/=
heads/io_uring-fops

I've changed the layout like this:

struct io_uring_sqe {
        __u8    opcode;         /* type of operation for this sqe */
        __u8    flags;          /* IOSQE_ flags */
        union {
                __u16   ioprio;         /* ioprio for the request */
                __u16   cmd_personality; /* IORING_OP_URING_CMD */
        };
        __s32   fd;             /* file descriptor to do IO on */
        union {
                __u64   off;    /* offset into file */
                __u64   addr2;
                __u64   cmd_user_data; /* IORING_OP_URING_CMD: data to be=
 passed back at completion time */
        };
        union {
                __u64   addr;   /* pointer to buffer or iovecs */
                __u64   splice_off_in;
                __u64   cmd_pdu_start; /* IORING_OP_URING_CMD: this is th=
e start for the remaining 48 bytes */
        };

And then use:

struct io_uring_cmd_pdu {
       __u64 data[6]; /* 48 bytes available for free use */
};

So we effectively have this:

struct io_uring_cmd_sqe {
        __u8    opcode;         /* type of operation for this sqe */
        __u8    flags;          /* IOSQE_ flags */
        __u16   cmd_personality; /* IORING_OP_URING_CMD */
        __s32   fd;             /* file descriptor to do IO on */
        __u64   cmd_user_data; /* IORING_OP_URING_CMD: data to be passed =
back at completion time */
        union {
                __u64   cmd_pdu_start; /* IORING_OP_URING_CMD: this is th=
e start for the remaining 48 bytes */
                struct io_uring_cmd_pdu cmd_pdu;
        };
}

I think it's saner to have a complete block of 48 bytes available for the=
 payload
and move personality and user_data to to top if opcode is IORING_OP_URING=
_CMD
instead of having a hole that can't be touched.

I also finished the socket glue from struct file -> struct socket -> stru=
ct sock

I think it compiles, but I haven't done any tests.

What do you think?
metze


--3ysAzCUcTp80QNpAuw7eAOOkeRdskGqUd--

--2SK7RlM7LEeBLdC7Vos0T3YsYtQYsp9pc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEfFbGo3YXpfgryIw9DbX1YShpvVYFAmAwiMAACgkQDbX1YShp
vVYWuw//a6uF2OpPVJcJjRBBCmH/yZAst52O36fkg+n7qr3y7KmSi9Z3eumfxh49
u9N1qyuw/k68ofemlDeEewiCaoxs+7ulzy9R/ULbCgIqSbsEaRKnXU8owPRTUDp+
0LO4Kf/yrBVyZwJpnewAJb8QaZelHsilJx7OR41fYixFGm/WMAE9ZuQqTT9iRuH4
7PpFO4jODFvsduQcQqw7oNaVqyqwnCDOVf6vqmqoVen+S7RhXnS+Gih7ydb2BogW
LjiR2oKwxPKRsmhZWywNjLhhqR+Zu6ZSgoS6h/R3IR5y82jwiPdaksVCbz5cnsR8
V/PcAIaU1DPoMPBQgQOFQlNjYEjIDOw2q5AVhkWQtqrXfg5WUaCUGkUcUq3cA229
AMk6dL4x8mGuCc+FG6Zx7FFddy+QDBXyHIdoUToCUxZyTzszaMyayPAXY/N9kswv
NX7XgoDIHAjBpDSLC0IL0Gx04qRimif715WBOzWHmdbeF8PgVBcIu+MinKjD1DrV
/V2sayEX307UYpmF+mE4P+nPcL3BNzf+17hcj6jlfU4pOf2y0Zg/A2R41bKmozEA
MQdt18PFpnh0lYhirkyR7s7Dn5n4RXCQTYM2SsGbQ068s0yZ252byLPK/tjotoyu
nbJFd4j00EojV3Xf4VNZDclH4XhQbuEyU1UfAoMqwtz6K7Rnr2w=
=TVyz
-----END PGP SIGNATURE-----

--2SK7RlM7LEeBLdC7Vos0T3YsYtQYsp9pc--
