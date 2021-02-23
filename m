Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4549B3226F5
	for <lists+io-uring@lfdr.de>; Tue, 23 Feb 2021 09:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232027AbhBWIQD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Feb 2021 03:16:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232023AbhBWIPu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Feb 2021 03:15:50 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE91AC06174A
        for <io-uring@vger.kernel.org>; Tue, 23 Feb 2021 00:15:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=cIQWZSGjg4RHskoy41BnD+yxweQfkRfAlPSOFFAtTgE=; b=AXjAjiAP4DnoMSXTlQcQ/MhzeI
        zVuMKsNrK6x8x0UQiR1sEWODeOb0q0SECjR5TQityWVCUlST84RjGmTlFDbNQrBDEKiB/ToxLdCWR
        Vzqcrc8H8YNXTw+6rP2r4eQntQHnM05XBBmDAPWdXn8aHJDNA35J0o2PvwOFVtFYJdvvd9GrrxPGM
        zGk3x0UK8HmKMG2k0NyaksY+3ENP9wqKaxSPaYLHdLVOuO6P1KkYDPwD2Slg3MDGyFRcsZVCiJEm2
        11SA6c9RpvX0Kw9N0XLM6JjqtGeo4i40qyhBfIMSUsCc6fV3zxGKN6SdkABME8Lqz2toDHueXhBk8
        vGF2pmCBD3kWNDBYK+hSOYwsSfWooLMOGFoyNK7q6Fu+mS95clICrmnmkCOQiyh6eY0tWWa2t6xGt
        HLpEpNJ0DYAirlJuJNITfy9tCs8ZMDu5zlV9ph4LAiNY0lh1M6lrWCJStEuW9se6gYbL5u4fujGq1
        3JA41JjIiu42i8qjuTxkVBYw;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lESqX-0002E9-Kf; Tue, 23 Feb 2021 08:15:05 +0000
To:     Jens Axboe <axboe@kernel.dk>, "Darrick J. Wong" <djwong@kernel.org>
Cc:     io-uring@vger.kernel.org
References: <20210127212541.88944-1-axboe@kernel.dk>
 <20210127212541.88944-3-axboe@kernel.dk> <20210128003831.GE7695@magnolia>
 <67627096-6d30-af3a-9545-1446909a38c4@kernel.dk>
 <f8576940-5441-1355-c09e-db60ad0ac889@kernel.dk>
 <81d6c90e-b853-27c0-c4b7-23605bd4abae@samba.org>
 <187cbfad-0dfe-9a16-11f0-bfe18a6c7520@kernel.dk>
 <58fe1e10-ed71-53f9-c47c-5e64066d3290@kernel.dk>
 <bcce9dd6-8222-6dc5-ad4f-5a68ac3ca902@samba.org>
 <6f3bcf67-15e3-f113-486e-b34c6c0df5e3@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
Autocrypt: addr=metze@samba.org; prefer-encrypt=mutual; keydata=
 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
 uAMlsTqBMFOwuvAcYAj2bwl7QQU6yhU=
Subject: Re: [PATCH 2/5] io_uring: add support for IORING_OP_URING_CMD
Message-ID: <c22271fd-85e1-2bc6-0946-ee24885d28ce@samba.org>
Date:   Tue, 23 Feb 2021 09:14:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <6f3bcf67-15e3-f113-486e-b34c6c0df5e3@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="R8gNmOp7AxMeMyjwRaQLzAKUIKXaArX15"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--R8gNmOp7AxMeMyjwRaQLzAKUIKXaArX15
Content-Type: multipart/mixed; boundary="ky1fhJsDwnAKkkzPHr5qPYUzacUvUAkmZ";
 protected-headers="v1"
From: Stefan Metzmacher <metze@samba.org>
To: Jens Axboe <axboe@kernel.dk>, "Darrick J. Wong" <djwong@kernel.org>
Cc: io-uring@vger.kernel.org
Message-ID: <c22271fd-85e1-2bc6-0946-ee24885d28ce@samba.org>
Subject: Re: [PATCH 2/5] io_uring: add support for IORING_OP_URING_CMD
References: <20210127212541.88944-1-axboe@kernel.dk>
 <20210127212541.88944-3-axboe@kernel.dk> <20210128003831.GE7695@magnolia>
 <67627096-6d30-af3a-9545-1446909a38c4@kernel.dk>
 <f8576940-5441-1355-c09e-db60ad0ac889@kernel.dk>
 <81d6c90e-b853-27c0-c4b7-23605bd4abae@samba.org>
 <187cbfad-0dfe-9a16-11f0-bfe18a6c7520@kernel.dk>
 <58fe1e10-ed71-53f9-c47c-5e64066d3290@kernel.dk>
 <bcce9dd6-8222-6dc5-ad4f-5a68ac3ca902@samba.org>
 <6f3bcf67-15e3-f113-486e-b34c6c0df5e3@kernel.dk>
In-Reply-To: <6f3bcf67-15e3-f113-486e-b34c6c0df5e3@kernel.dk>

--ky1fhJsDwnAKkkzPHr5qPYUzacUvUAkmZ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Am 22.02.21 um 21:14 schrieb Jens Axboe:
> On 2/22/21 1:04 PM, Stefan Metzmacher wrote:
>> Hi Jens,
>>
>>>> I've been thinking along the same lines, because having a sparse sqe=
 layout
>>>> for the uring cmd is a pain. I do think 'personality' is a bit too s=
pecific
>>>> to be part of the shared space, that should probably belong in the p=
du
>>>> instead if the user needs it. One thing they all have in common is t=
hat they'd
>>>> need a sub-command, so why not make that u16 that?
>>>>
>>>> There's also the option of simply saying that the uring_cmd sqe is j=
ust
>>>> a different type, ala:
>>>>
>>>> struct io_uring_cmd_sqe {
>>>> 	__u8	opcode;		/* IO_OP_URING_CMD */
>>>> 	__u8	flags;
>>>> 	__u16	target_op;
>>>> 	__s32	fd;
>>>> 	__u64	user_data;
>>>> 	strut io_uring_cmd_pdu cmd_pdu;
>>>> };
>>>>
>>>> which is essentially the same as your suggestion in terms of layout
>>>> (because that is the one that makes the most sense), we just don't t=
ry
>>>> and shoe-horn it into the existing sqe. As long as we overlap
>>>> opcode/flags, then init is fine. And past init, sqe is already consu=
med.
>>>>
>>>> Haven't tried and wire that up yet, and it may just be that the simp=
le
>>>> layout change you did is just easier to deal with. The important par=
t
>>>> here is the layout, and I certainly think we should do that. There's=

>>>> effectively 54 bytes of data there, if you include the target op and=
 fd
>>>> as part of that space. 48 fully usable for whatever.
>>>
>>> OK, folded in some of your stuff, and pushed out a new branch. Find i=
t
>>> here:
>>>
>>> https://git.kernel.dk/cgit/linux-block/log/?h=3Dio_uring-fops.v3
>>>
>>> I did notice while doing so that you put the issue flags in the cmd,
>>> I've made them external again. Just seems cleaner to me, otherwise
>>> you'd have to modify the command for reissue rather than just
>>> pass in the flags directly.
>>
>> I think the first two commits need more verbose comments, which clearl=
y
>> document the uring_cmd() API.
>=20
> Oh for sure, I just haven't gotten around to it yet :-)
>=20
>> Event before uring_cmd(), it's really not clear to me why we have
>> 'enum io_uring_cmd_flags', as 'enum'.
>> As it seems to be use it as 'flags' (IO_URING_F_NONBLOCK|IO_URING_F_CO=
MPLETE_DEFER).
>=20
> They could be unsigned in too, but not really a big deal imho.
>=20
>> With uring_cmd() it's not clear what the backend is supposed to do
>> with these flags.
>=20
> IO_URING_F_NONBLOCK tells the lower layers that the operation should be=

> non-blocking, and if that isn't possible, then it must return -EAGAIN.
> If that happens, then the operation will be retried from a context wher=
e
> IO_URING_F_NONBLOCK isn't set.
>=20
> IO_URING_F_COMPLETE_DEFER is just part of the flags that should be
> passed to the completion side, the handler need not do anything else.
> It's only used internally, but allows fast processing if the completion=

> occurs off the IO_URING_F_NONBLOCK path.
>=20
> It'll get documented... But the above is also why it should get passed
> in, rather than stuffed in the command itself.

Thanks!

>> I'd assume that uring_cmd() would per definition never block and go
>> async itself, by returning -EIOCBQUEUED. And a single &req->uring_cmd
>> is only ever passed once to uring_cmd() without any retry.
>=20
> No, -EIOCBQUEUED would mean "operation is queued, I'll call the
> completion callback for it later".

That's what I meant with async here.

> For example, you start the IO operation and you'll get a notification (=
eg IRQ) later on which allows
> you to complete it.

Yes, it's up to the implementation of uring_cmd() to do the processing an=
d waiting
in the background, based on timers, hardware events or whatever and final=
ly call
io_uring_cmd_done().

But with this:

        ret =3D file->f_op->uring_cmd(&req->uring_cmd, issue_flags);
        /* queued async, consumer will call io_uring_cmd_done() when comp=
lete */
        if (ret =3D=3D -EIOCBQUEUED)
                return 0;
        io_uring_cmd_done(&req->uring_cmd, ret);
        return 0;

I don't see where -EAGAIN would trigger a retry in a io-wq worker context=
=2E
Isn't -EAGAIN exposed to the cqe. Similar to ret =3D=3D -EAGAIN && req->f=
lags & REQ_F_NOWAIT.

>> It's also not clear if IOSQE_ASYNC should have any impact.
>=20
> Handler doesn't need to care about that, it'll just mean that the
> initial queue attempt will not have IO_URING_F_NONBLOCK set.

Ok, because it's done from the io-wq worker, correct?

>> I think we also need a way to pass IORING_OP_ASYNC_CANCEL down.
>=20
> Cancelation indeed needs some thought. There are a few options:
>=20
> 1) Request completes sync, obviously no cancelation needed here as the
>    request is never stuck in a state that requires cancelation.
>=20
> 2) Request needs blocking context, and hence an async handler is doing
>    it. The regular cancelation already works for that, nothing is neede=
d
>    here. Would probably be better handled with a cancel handler.
>
> 3) uring_cmd handler returns -EIOCBQUEUED. This is the only case that
>    needs active cancelation support. Only case where that would
>    currently happen are things like block IO, where we don't support
>    cancelation to begin with (insert long rant on inadequate hw
>    support).
>=20
> So tldr here is that 1+2 is already there, and 3 not being fixed leaves=

> us no different than the existing support for cancelation. IOW, I don't=

> think this is an initial requirement, support can always be expanded
> later.

Given that you list 2) here again, I get the impression that the logic sh=
ould be:

        ret =3D file->f_op->uring_cmd(&req->uring_cmd, issue_flags);
        /* reschedule in io-wq worker again */
        if (ret =3D=3D -EAGAIN)
                return ret;
        /* queued async, consumer will call io_uring_cmd_done() when comp=
lete */
        if (ret =3D=3D -EIOCBQUEUED)
                return 0;
        io_uring_cmd_done(&req->uring_cmd, ret);
        return 0;

With that the above would make sense and seems to make the whole design m=
ore flexible
for the uring_cmd implementers.

However my primary use case would be using the -EIOCBQUEUED logic.
And I think it would be good to have IORING_OP_ASYNC_CANCEL logic in plac=
e for that,
as it would simplify the userspace logic to single io_uring_opcode_suppor=
ted(IO_OP_URING_CMD).

I also noticed that some sendmsg/recvmsg implementations support -EIOCBQU=
EUED, e.g. _aead_recvmsg(),
I guess it would be nice to support that for IORING_OP_SENDMSG and IORING=
_OP_RECVMSG as well.
It uses struct kiocb and iocb->ki_complete().

Would it make sense to also use struct kiocb and iocb->ki_complete() inst=
ead of
a custom io_uring_cmd_done()?

Maybe it would be possible to also have a common way to cancel an struct =
kiocb request...

>>> Since we just need that one branch in req init, I do think that your
>>> suggestion of just modifying io_uring_sqe is the way to go. So that's=

>>> what the above branch does.
>>
>> Thanks! I think it's much easier to handle the personality logic in
>> the core only.
>>
>> For fixed files or fixed buffers I think helper functions like this:
>>
>> struct file *io_uring_cmd_get_file(struct io_uring_cmd *cmd, int fd, b=
ool fixed);
>>
>> And similar functions for io_buffer_select or io_import_fixed.
>=20
> I did end up retaining that, at least in its current state it's like yo=
u
> proposed. Only change is some packing on that very union, which should
> not be necessary, but due to fun arm reasons it is.

I noticed that thanks!

Do you also think a io_uring_cmd_get_file() would be useful?
My uring_cmd() implementation would need a 2nd struct file in order to
do something similar to a splice operation. And it might be good to
allow also fixed files to be used.

Referencing fixed buffer may also be useful, I'm not 100% sure I'll need =
them,
but it would be good to be flexible and prototype various solutions.

>>> I tested the block side, and it works for getting the bs of the
>>> device. That's all the testing that has been done so far :-)
>>
>> I've added EXPORT_SYMBOL(io_uring_cmd_done); and split your net patch,=

>> similar to the two block patches. So we can better isolate the core
>> from the first consumers.
>>
>> See https://git.samba.org/?p=3Dmetze/linux/wip.git;a=3Dshortlog;h=3Dre=
fs/heads/io_uring-fops.v3
>=20
> Great thanks, I'll take a look and fold back. I'll also expand those
> commit messages :-)

Thanks!




--ky1fhJsDwnAKkkzPHr5qPYUzacUvUAkmZ--

--R8gNmOp7AxMeMyjwRaQLzAKUIKXaArX15
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEfFbGo3YXpfgryIw9DbX1YShpvVYFAmA0uYAACgkQDbX1YShp
vVbPyQ//ULXeUDIPlSiDHH0Z/nl4mvXPax0uOMmkmQDvTqntwpmdUs1VGrvZNOVQ
hGraLRt6cxN/LMQYtlNWUUU7xpzCbeRQxaJCfGhymCrE6zsLM0WkM8WASNlhN7xv
twAAyH1tb/cMMwIhXnyJIRBN1mRZ/SWY8JolC3z8gnGa8PLGNf0TRmyF+vVMlssm
7shxgapk8o20/iQ/Kyqp+HHC9UMwwyAFd5c9Q9Gwa0ouRnwDhjMV/FAEyemTMD38
DED3FbUFqS4ioObV9eGFwMpHz/L2PKMtwFeQyiR5lwvFD6rKXzlDV55hTzJ75WAr
dd31YfuxBMByE9npc5gDzKG8cJRkHR/jV6S2EYYzgy8LoYsRFa/6qrpd94Y96ggE
ZRvn6yLSaEcKWQsSTXetqRdWMdWtWvTy/0KJtIbx0GKiwmprh/rMKVRHoHaPH7sn
Y1pfW7ayUeh977IZiMlSKipmLUpVG5UVG5zH9TcDNDEWKSqtOZsH99v0fky7I/8P
PkB1sAssvnqqs+3hBGdadQkKH5LuntW4SXOJNfjmsS0fp+rJurhd0ULXDKSiGxcT
0+mCtP1p24ilojWfwlkQwrG8dU9gNmy1RQcpQ4v5Wl7nzgKBrwOlXBzxdPTO+Obr
3qk7jLYusAN6zp0ueiIV281jh3lwS4CBxCFoeJVaAYuiMyXFW8I=
=5xeI
-----END PGP SIGNATURE-----

--R8gNmOp7AxMeMyjwRaQLzAKUIKXaArX15--
