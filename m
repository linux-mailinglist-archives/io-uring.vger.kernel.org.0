Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF72328F024
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 12:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbgJOKZQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 06:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbgJOKZP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 06:25:15 -0400
X-Greylist: delayed 1115 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 15 Oct 2020 03:25:14 PDT
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2189C0613D2
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 03:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:To:CC;
        bh=jYfSUkd7rE/dxyv673+lN2R59fwQKLG7l9AuOA6yo2A=; b=PT5OcfPJkRnz5rgMls3N5ngnwb
        NQFT++5lYRFgh1UsqJAuMMRCrKIF2Ijos4Bi9gT0PutxmGUTm1YPniLDLnJhjxycvienbHpSDX5kW
        BiJyopjC+ub82lZMMga1fT4SWKAZQIE3wCnzqZXQwwH3iYsgClK5bjFJPpaBBqiKZVaKau0cYeUHj
        N/erkaBdz1RKd43rEsq0SSUHfNK958KZsEz2paPamLWbsc0LMWmHwInkVZ4mDC0+Q4a4GHWot0bO3
        rhgtM4iGLoYMyrebUzZFqb3bzfM9D5/2eC4ACj9LENNLDFyYkGRnUnX/BpEL8DhALTMD7cx40H4NZ
        IaOMUWLz47aNoe9FGThqTKGUvSZ057JMgqtKQhwi7j8FyNNp6Blk0SW7aLznaWTHbObyvxL50rK03
        Px9edUDYE7I1ewrfWOv0kp414LWM5h/GdCLVDSryu4QOvcL7KKgwfXsuomFBud9aoNwCKt5UGqXWk
        0Pt4nmqBw4Fa/WEQPpOQrhyJ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kT09d-00071e-VL; Thu, 15 Oct 2020 10:06:38 +0000
Subject: Re: Samba with multichannel and io_uring
To:     Stefan Metzmacher <metze@samba.org>,
        Samba Technical <samba-technical@lists.samba.org>,
        io-uring <io-uring@vger.kernel.org>
References: <53d63041-5931-c5f2-2f31-50b5cbe09ec8@samba.org>
From:   Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
Message-ID: <b272e0b4-d3f6-700e-d870-2f6a4d73d17f@samba.org>
Date:   Thu, 15 Oct 2020 12:06:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <53d63041-5931-c5f2-2f31-50b5cbe09ec8@samba.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="RW10drWOsQmqaqXZtkUyQZUFGXI9MIdy9"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RW10drWOsQmqaqXZtkUyQZUFGXI9MIdy9
Content-Type: multipart/mixed; boundary="i1Pa8Vbu52aZtyqN76hUV3uSKLSpvkppV"

--i1Pa8Vbu52aZtyqN76hUV3uSKLSpvkppV
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hey metze,

Am 10/15/20 um 11:58 AM schrieb Stefan Metzmacher via samba-technical:
> I'm not sure when all this will be production ready, but it's great to =
know
> the potential we have on a modern Linux kernel!

awesome! Thanks for sharing this!

-slow

--=20
Ralph Boehme, Samba Team                https://samba.org/
Samba Developer, SerNet GmbH   https://sernet.de/en/samba/
GPG-Fingerprint   FAE2C6088A24252051C559E4AA1E9B7126399E46


--i1Pa8Vbu52aZtyqN76hUV3uSKLSpvkppV--

--RW10drWOsQmqaqXZtkUyQZUFGXI9MIdy9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAl+IHywACgkQqh6bcSY5
nkaFJQ//dozVjWRdDdaaH5Is8NfS8odpzw0uL5H6X7/mTP8h0+VduIVCIKrpxdDx
zhRxuKJipFwKhMx8TIICe51vvEhQCbp4aGs6p9K+4IRCbjXlRfjAYc0/xnjsq2yh
VYuWrF6FZ8njtiWhtUDMGA8amSFAnOL6bB3bVmZzUAxtxo8fND0QJ3M0vN+0C1kc
pROHrkbu45ISMZyj0YelitMUCisboRsf7ylfeaEBQKLija7Bpqu7oDkxHNgIixGn
rg/aaHY+znq37WQNu80mKGreal7NbNzn1SoEAffa0TIhe6T0cmEPOqt1skFmmC74
1uq0O0hUp70gSkjonCQuHRftsAmL/Ytca4/IizItbvsd1Dtuce5QzjZz954T1OQM
EVS7b8RF6Zgl1UkNlkUk6XOhYegrcypBQVmTimYPyH9HeRs0Ghf6iZGyecS+B+4L
kuHIAqdXU4N+TMdOA/Aekn6R44MlpOlle/CIXqckB/gzihijv1Wwwjzq5eo4qbQt
81TWMnYxMi6cGhTaK+h+EMjWTMeEAfP2vAPg89PY/tFyeM48PTd4OgurKOTLjdoP
QCz/nEw3Kvt8V1QTongBwTl3b25KfjSFIRre0iNPZ+y5hzjzJ+m29DfEpd1yRwBm
5b3oqmbgn+u1RuzidKFcBrvBL5l/DjuFduJaXTdwZ0ck2UT6qSg=
=3GWD
-----END PGP SIGNATURE-----

--RW10drWOsQmqaqXZtkUyQZUFGXI9MIdy9--
