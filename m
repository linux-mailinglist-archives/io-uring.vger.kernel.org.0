Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8688A14F4C0
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2020 23:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgAaWdH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jan 2020 17:33:07 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45016 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgAaWdH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jan 2020 17:33:07 -0500
Received: by mail-wr1-f65.google.com with SMTP id m16so10441463wrx.11;
        Fri, 31 Jan 2020 14:33:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=TiAWf9D3maXDz8lCmzRbc51wjVLzMk0o0bYijacbOAU=;
        b=sMuL6ZWsd9Qx3ERfJzsJy8wpb8Z8p7V0CYlRdDdrSrsY/ywNuQ83Vj6Nzf4ymTaYpW
         fKml8aPrLGCAqrzkmnOCV5TONeWJo+hAb6EDQRck8sWsgy3mWlskzNgy7Ka8CAmRW8xD
         EtteVue1I/LTjo7j9O15DBJvpH2kyfKyF79uOaRgHBlfVy/l67F+Zn1VYaetTe5l4bce
         uiW4VNCswike2nnEdHkQ6AVr6p5iM8iyhshSkZmwTOWGYHUIq8kk0log/axDdyaPtXN9
         xuhh7Kl2bSuO/aYwg9sez3xvrmF5S7jO86BPnFeTuyVIOHCH0hSNzfU9/1EAC7/oIprj
         29vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=TiAWf9D3maXDz8lCmzRbc51wjVLzMk0o0bYijacbOAU=;
        b=fSsPI/wkgTzx/AQcwkT3NwU8w9O/LNibgLnbL+PNJONUjKUllLUWxAuB0rMNeVcVJr
         RXFIWE1AXEC/yvm30M5rkY8Ph/IdkKDGCVETZV/v+9zLzptdJdMSStEAtbe7vGrw5U9e
         lUdrAGm0OZxhBGgYWCWCUsKVsvL8M1mQXhp6dS+T8eDoMcCRuVaRhzjDHPj4r8p7c/dh
         ohPvtfTlNbmBPRSrSytlwS834g/yZK5fISd7uOg/S70MN5/qBvXyUvuuZorocwn36eDO
         +stkPmDw3f7i9s7qoNUSIRbSvq49LDqEo740fwIfuICaBZasSPgYoJg/IeOs5muvGSB6
         uLYA==
X-Gm-Message-State: APjAAAVZ/y29vW3y9lnzjEc5T4IWGb4u7IVudxPvmv1K1TXJlHdcozg9
        6GxpoXWZZ0nstg4LuiOuUMqod7Uu
X-Google-Smtp-Source: APXvYqzOOtjtrlntj5qTSRh2y/hcpZ9o7udghIDhZdNCzZZOOVv5SzlFamjRCfKNCZ/qXKuP+39kGQ==
X-Received: by 2002:adf:df0f:: with SMTP id y15mr569788wrl.26.1580509984146;
        Fri, 31 Jan 2020 14:33:04 -0800 (PST)
Received: from [192.168.43.140] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id t81sm12367112wmg.6.2020.01.31.14.33.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2020 14:33:03 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1580508735.git.asml.silence@gmail.com>
 <6492ccd2-e829-df13-ab6e-e62590375fd1@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 mQINBFmKBOQBEAC76ZFxLAKpDw0bKQ8CEiYJRGn8MHTUhURL02/7n1t0HkKQx2K1fCXClbps
 bdwSHrhOWdW61pmfMbDYbTj6ZvGRvhoLWfGkzujB2wjNcbNTXIoOzJEGISHaPf6E2IQx1ik9
 6uqVkK1OMb7qRvKH0i7HYP4WJzYbEWVyLiAxUj611mC9tgd73oqZ2pLYzGTqF2j6a/obaqha
 +hXuWTvpDQXqcOZJXIW43atprH03G1tQs7VwR21Q1eq6Yvy2ESLdc38EqCszBfQRMmKy+cfp
 W3U9Mb1w0L680pXrONcnlDBCN7/sghGeMHjGKfNANjPc+0hzz3rApPxpoE7HC1uRiwC4et83
 CKnncH1l7zgeBT9Oa3qEiBlaa1ZCBqrA4dY+z5fWJYjMpwI1SNp37RtF8fKXbKQg+JuUjAa9
 Y6oXeyEvDHMyJYMcinl6xCqCBAXPHnHmawkMMgjr3BBRzODmMr+CPVvnYe7BFYfoajzqzq+h
 EyXSl3aBf0IDPTqSUrhbmjj5OEOYgRW5p+mdYtY1cXeK8copmd+fd/eTkghok5li58AojCba
 jRjp7zVOLOjDlpxxiKhuFmpV4yWNh5JJaTbwCRSd04sCcDNlJj+TehTr+o1QiORzc2t+N5iJ
 NbILft19Izdn8U39T5oWiynqa1qCLgbuFtnYx1HlUq/HvAm+kwARAQABtDFQYXZlbCBCZWd1
 bmtvdiAoc2lsZW5jZSkgPGFzbWwuc2lsZW5jZUBnbWFpbC5jb20+iQJOBBMBCAA4FiEE+6Ju
 PTjTbx479o3OWt5b1Glr+6UFAlmKBOQCGwMFCwkIBwIGFQgJCgsCBBYCAwECHgECF4AACgkQ
 Wt5b1Glr+6WxZA//QueaKHzgdnOikJ7NA/Vq8FmhRlwgtP0+E+w93kL+ZGLzS/cUCIjn2f4Q
 Mcutj2Neg0CcYPX3b2nJiKr5Vn0rjJ/suiaOa1h1KzyNTOmxnsqE5fmxOf6C6x+NKE18I5Jy
 xzLQoktbdDVA7JfB1itt6iWSNoOTVcvFyvfe5ggy6FSCcP+m1RlR58XxVLH+qlAvxxOeEr/e
 aQfUzrs7gqdSd9zQGEZo0jtuBiB7k98t9y0oC9Jz0PJdvaj1NZUgtXG9pEtww3LdeXP/TkFl
 HBSxVflzeoFaj4UAuy8+uve7ya/ECNCc8kk0VYaEjoVrzJcYdKP583iRhOLlZA6HEmn/+Gh9
 4orG67HNiJlbFiW3whxGizWsrtFNLsSP1YrEReYk9j1SoUHHzsu+ZtNfKuHIhK0sU07G1OPN
 2rDLlzUWR9Jc22INAkhVHOogOcc5ajMGhgWcBJMLCoi219HlX69LIDu3Y34uIg9QPZIC2jwr
 24W0kxmK6avJr7+n4o8m6sOJvhlumSp5TSNhRiKvAHB1I2JB8Q1yZCIPzx+w1ALxuoWiCdwV
 M/azguU42R17IuBzK0S3hPjXpEi2sK/k4pEPnHVUv9Cu09HCNnd6BRfFGjo8M9kZvw360gC1
 reeMdqGjwQ68o9x0R7NBRrtUOh48TDLXCANAg97wjPoy37dQE7e5Ag0EWYoE5AEQAMWS+aBV
 IJtCjwtfCOV98NamFpDEjBMrCAfLm7wZlmXy5I6o7nzzCxEw06P2rhzp1hIqkaab1kHySU7g
 dkpjmQ7Jjlrf6KdMP87mC/Hx4+zgVCkTQCKkIxNE76Ff3O9uTvkWCspSh9J0qPYyCaVta2D1
 Sq5HZ8WFcap71iVO1f2/FEHKJNz/YTSOS/W7dxJdXl2eoj3gYX2UZNfoaVv8OXKaWslZlgqN
 jSg9wsTv1K73AnQKt4fFhscN9YFxhtgD/SQuOldE5Ws4UlJoaFX/yCoJL3ky2kC0WFngzwRF
 Yo6u/KON/o28yyP+alYRMBrN0Dm60FuVSIFafSqXoJTIjSZ6olbEoT0u17Rag8BxnxryMrgR
 dkccq272MaSS0eOC9K2rtvxzddohRFPcy/8bkX+t2iukTDz75KSTKO+chce62Xxdg62dpkZX
 xK+HeDCZ7gRNZvAbDETr6XI63hPKi891GeZqvqQVYR8e+V2725w+H1iv3THiB1tx4L2bXZDI
 DtMKQ5D2RvCHNdPNcZeldEoJwKoA60yg6tuUquvsLvfCwtrmVI2rL2djYxRfGNmFMrUDN1Xq
 F3xozA91q3iZd9OYi9G+M/OA01husBdcIzj1hu0aL+MGg4Gqk6XwjoSxVd4YT41kTU7Kk+/I
 5/Nf+i88ULt6HanBYcY/+Daeo/XFABEBAAGJAjYEGAEIACAWIQT7om49ONNvHjv2jc5a3lvU
 aWv7pQUCWYoE5AIbDAAKCRBa3lvUaWv7pfmcEACKTRQ28b1y5ztKuLdLr79+T+LwZKHjX++P
 4wKjEOECCcB6KCv3hP+J2GCXDOPZvdg/ZYZafqP68Yy8AZqkfa4qPYHmIdpODtRzZSL48kM8
 LRzV8Rl7J3ItvzdBRxf4T/Zseu5U6ELiQdCUkPGsJcPIJkgPjO2ROG/ZtYa9DvnShNWPlp+R
 uPwPccEQPWO/NP4fJl2zwC6byjljZhW5kxYswGMLBwb5cDUZAisIukyAa8Xshdan6C2RZcNs
 rB3L7vsg/R8UCehxOH0C+NypG2GqjVejNZsc7bgV49EOVltS+GmGyY+moIzxsuLmT93rqyII
 5rSbbcTLe6KBYcs24XEoo49Zm9oDA3jYvNpeYD8rDcnNbuZh9kTgBwFN41JHOPv0W2FEEWqe
 JsCwQdcOQ56rtezdCJUYmRAt3BsfjN3Jn3N6rpodi4Dkdli8HylM5iq4ooeb5VkQ7UZxbCWt
 UVMKkOCdFhutRmYp0mbv2e87IK4erwNHQRkHUkzbsuym8RVpAZbLzLPIYK/J3RTErL6Z99N2
 m3J6pjwSJY/zNwuFPs9zGEnRO4g0BUbwGdbuvDzaq6/3OJLKohr5eLXNU3JkT+3HezydWm3W
 OPhauth7W0db74Qd49HXK0xe/aPrK+Cp+kU1HRactyNtF8jZQbhMCC8vMGukZtWaAwpjWiiH bA==
Subject: Re: [PATCH v3 0/6] add persistent submission state
Message-ID: <199731e7-ca3f-ea6c-0813-6aa5dec6fa66@gmail.com>
Date:   Sat, 1 Feb 2020 01:32:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <6492ccd2-e829-df13-ab6e-e62590375fd1@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="zFbuuAtZIDTsd9td9PgiX1fYWVRlYecC2"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--zFbuuAtZIDTsd9td9PgiX1fYWVRlYecC2
Content-Type: multipart/mixed; boundary="ZcQARdBLy99D7KSL9BSGJCwAyRXUqPUay";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <199731e7-ca3f-ea6c-0813-6aa5dec6fa66@gmail.com>
Subject: Re: [PATCH v3 0/6] add persistent submission state
References: <cover.1580508735.git.asml.silence@gmail.com>
 <6492ccd2-e829-df13-ab6e-e62590375fd1@kernel.dk>
In-Reply-To: <6492ccd2-e829-df13-ab6e-e62590375fd1@kernel.dk>

--ZcQARdBLy99D7KSL9BSGJCwAyRXUqPUay
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 01/02/2020 01:22, Jens Axboe wrote:
> On 1/31/20 3:15 PM, Pavel Begunkov wrote:
>> Apart from unrelated first patch, this persues two goals:
>>
>> 1. start preparing io_uring to move resources handling into
>> opcode specific functions
>>
>> 2. make the first step towards long-standing optimisation ideas
>>
>> Basically, it makes struct io_submit_state embedded into ctx, so
>> easily accessible and persistent, and then plays a bit around that.
>=20
> Do you have any perf/latency numbers for this? Just curious if we
> see any improvements on that front, cross submit persistence of
> alloc caches should be a nice sync win, for example, or even
> for peak iops by not having to replenish the pool for each batch.
>=20
> I can try and run some here too.
>=20

I tested the first version, but my drive is too slow, so it was only nops=
 and
hence no offloading. Honestly, there waren't statistically significant re=
sults.
I'll rerun anyway.

I have a plan to reuse it for a tricky optimisation, but thinking twice, =
I can
just stash it until everything is done. That's not the first thing in TOD=
O and
will take a while.


--=20
Pavel Begunkov


--ZcQARdBLy99D7KSL9BSGJCwAyRXUqPUay--

--zFbuuAtZIDTsd9td9PgiX1fYWVRlYecC2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl40qvoACgkQWt5b1Glr
+6Wy8hAAtFfLAfTBY+AYB8/mkvlQfZkKt3Cbz/kwwEVnQ2GON/RwE+0WtpelM+ZW
U61TE8zYjn7DE9XNCoIhXfSkC2uE81TvgW4LDTmGVgylQ+AXrthYP8pQaWHl9CIE
WE1OrP6wdWeMIX/xJVI51gqX6o/zS+PI2ARNyKcfc52bGernIHYii4nRX8Gg1q/0
AWl+dfxBJyCcT3br/a/hzGUi7tXIztDmE9sy5JwByjNMuZyjmYFCVM8Fh1l8igJm
hno7oYvU+VenALpUr14iqSSRJkGWgA0+gBwzMQa57xTsmcyLcltpoyBDEvjVrysM
Eju7MCRJ7hB3JSFXM+BLELQZ5gyqJBJ7CGh266AnOvLLTXjHHKW1CB3VBNxOkX5A
Ycc4KWc70p7+Fvr4I9715mPD82+hyPUW7m18+7YpULWRBQICvdORLYs8E/KG+spH
RvsWIwdRA3RmkC2Q4BaVnOsk2bPDxw5vr5niFJZUso+0kGDe9eZ5pjgT0jVS2BxE
jfsvN9yDVFa9qmuz/l9G/T2I9vhjwXCXKklZ6F6qdLme3n9FYWEVYRxoQbdZdl3X
IBDCGwuAX6vjsQdycEPBgumQtUfdLTkEOw/omcpGoyxhHgyCL+63RRNo0XmGmo4a
WJ9+ZF6vRIUDraBswIByYSaP8A/BT9zEYlYgxyWlELUjEzMNL14=
=py59
-----END PGP SIGNATURE-----

--zFbuuAtZIDTsd9td9PgiX1fYWVRlYecC2--
