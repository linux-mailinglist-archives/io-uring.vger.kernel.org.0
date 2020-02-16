Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB861605AD
	for <lists+io-uring@lfdr.de>; Sun, 16 Feb 2020 20:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbgBPTJo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 Feb 2020 14:09:44 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43661 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbgBPTJo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 Feb 2020 14:09:44 -0500
Received: by mail-wr1-f68.google.com with SMTP id r11so17018234wrq.10;
        Sun, 16 Feb 2020 11:09:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=xjOJBvExwbLuUAaHs7cmXVY2L5vvN42WLt6a7/VKFUk=;
        b=MdCOW+h2YbN6/eSjuo1ejv1p8hAt/Ty+1t0EPv3dplUdw598zdzrnAx8dZJOGTklMf
         8ARf+GDRdwSgzZGxISaIIRVbHrpnkMl1UrDebRpclmaUNx87igazjQd4xaH0Q0rXzJSo
         KQEf2BNEkIC3EhW1TUQJ7is1XA3BSmowH+9wG8vuH+VWA9nALa6+NCcnBJ+hr1E+GLd8
         QlOoacoy1oyT2cEkQMFmkZLkLpIqaEnrtB7Adn8xtsPs0IO9wyJ1Udy0Cz4MbxVMo8w1
         D3M0BdMYGkoM8Nvk7BKNQqZnZ8RkE5J1cfZhSBBMOOb3zk4SWrjBveTRCEcQtFtnBiAZ
         dQSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=xjOJBvExwbLuUAaHs7cmXVY2L5vvN42WLt6a7/VKFUk=;
        b=WAUBkm4Na4g0YSfUVlBZ5kQdZwHulgIA8CV/3rn/dsrzhYxGLGt0XeCmWR17dVBnAJ
         3ZYFlYaCz9+OefLxeV6kXVFiW1screlBwnBdb8ctZxVgNc9iLu6x9gVFTI3TKLNPB5rU
         VUb6g+upo1N91ZZvfRZigHobxrG8/L7CKynfp8Qu2L1WFOCaDZYr9awgEpy4mhuIerw/
         iiqjYZg2eMPNcUDCfAdKlAgli8cBACgTqdo4t7kh1f4CWdq+u+Boj+fhPrz3IXyn5o5+
         WBWpPzi7wiI5vPB6WVAzeGUH9Q11Ru7g+ch0jza9K9TD5FkLOQSPdHovDM62YmTV4E7W
         7EhQ==
X-Gm-Message-State: APjAAAXmfuyb5MWr3jmY8zsq2VtwcOtdKF3hDqHhCRmbuaPoEYJgSNHn
        OQQBjhQcF+5WSRoplAMxaBW9nWNa
X-Google-Smtp-Source: APXvYqwECRcvJeuxRN5PmrVJG5knZDpURswEBT9a68gJl6rW2wAMYx4OBsqSbxf2S5Ss5FXEoRSoqQ==
X-Received: by 2002:adf:dfce:: with SMTP id q14mr17375227wrn.324.1581880181955;
        Sun, 16 Feb 2020 11:09:41 -0800 (PST)
Received: from [192.168.43.97] ([109.126.145.198])
        by smtp.gmail.com with ESMTPSA id x11sm17169294wmg.46.2020.02.16.11.09.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Feb 2020 11:09:41 -0800 (PST)
Subject: Re: [PATCH v2 1/5] io_uring: add missing io_req_cancelled()
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1581785642.git.asml.silence@gmail.com>
 <da924cbc76ca1e5b2d1528ffd88bcb180704e531.1581785642.git.asml.silence@gmail.com>
 <879b7984-c45b-6bf5-9e15-ee4b744e47f2@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <7f5fb8fd-6162-38a7-fbf1-00c8debfcceb@gmail.com>
Date:   Sun, 16 Feb 2020 22:09:01 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <879b7984-c45b-6bf5-9e15-ee4b744e47f2@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="iIpd5EcSXfT43WAoiPJOgKV3Kw6r2eXOG"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iIpd5EcSXfT43WAoiPJOgKV3Kw6r2eXOG
Content-Type: multipart/mixed; boundary="oCoLmO3fmwHPAruBElyejFIvvfkzXRA2G";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <7f5fb8fd-6162-38a7-fbf1-00c8debfcceb@gmail.com>
Subject: Re: [PATCH v2 1/5] io_uring: add missing io_req_cancelled()
References: <cover.1581785642.git.asml.silence@gmail.com>
 <da924cbc76ca1e5b2d1528ffd88bcb180704e531.1581785642.git.asml.silence@gmail.com>
 <879b7984-c45b-6bf5-9e15-ee4b744e47f2@kernel.dk>
In-Reply-To: <879b7984-c45b-6bf5-9e15-ee4b744e47f2@kernel.dk>

--oCoLmO3fmwHPAruBElyejFIvvfkzXRA2G
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 16/02/2020 20:15, Jens Axboe wrote:
> On 2/15/20 3:01 PM, Pavel Begunkov wrote:
>> fallocate_finish() is missing cancellation check. Add it.
>> It's safe to do that, as only flags setup and sqe fields copy are done=

>> before it gets into __io_fallocate().
>=20
> Thanks, I added this one to the 5.6 mix.
>=20
> Going to be sporadic this next week, but I hope I can get to your
> 5.7 material anyway.
>=20

Sure, there is plenty of time

--=20
Pavel Begunkov


--oCoLmO3fmwHPAruBElyejFIvvfkzXRA2G--

--iIpd5EcSXfT43WAoiPJOgKV3Kw6r2eXOG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl5Jk00ACgkQWt5b1Glr
+6X5zRAAn3btzgQsP9Mmgm61KMi6BBFwQYxCSpKDYdTdkGno++d+ACtb77eH6CnO
kQuromCtQO0gan0GZ6lO+ykucfrHq6cWpiLd2bpEdzMbzZCfnUMn89fWYJIKGc/W
z0qfMCGY1XNg8lNOM1ApvoFyIE8nBg2hXntdUEREX4qaxZASLcyviLT26a9mtPrk
jhxoc4WEFyPk510MnBxcWjgeB/zsLKnwZXV0Z8iysHhXEZZ1gpR9wLbkfwZJWDzQ
2sRx2Zy6qmQE+1PrAm67FW0FxZwqI64KtNUs9EyAF1tsk2aaBHA1whFho6ckjj/H
7PTlLrvXDcnKbo1nxKEzYVDNzaDVP6ewz5Wk0fAriisPihYTHrF5wbBggw1qQ9l1
JIpIp/S/nZ6t1GdJAKMdNE1kYXijtARexEFz4gPtddlNW+kaBIrySlNFsIfKkMmo
tZkXtdujXbgH+pPfVjNfCSO5jQIvaGwHePs2QsCS5Pv1VG88KYwI9yIo/Td4QHle
0izlAhmMXSJgeFjLJKP2x0UMaAm1DNOBiTssul7ZJLxU6oFkcL2m2Irl0kWm2wIy
R5LcHcLPDM0h+BOWbVdU+hecLV2eI6zcqFYFg9oJFysQjYMSm5M3T/hLRKYtgAED
YBHCHLfny11SuTH0hYilXOsKtygjOufFcTLoALgWv2GZD+sV6RM=
=Hnuo
-----END PGP SIGNATURE-----

--iIpd5EcSXfT43WAoiPJOgKV3Kw6r2eXOG--
