Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A992414C312
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2020 23:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgA1Wjd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jan 2020 17:39:33 -0500
Received: from mail-wm1-f50.google.com ([209.85.128.50]:32837 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbgA1Wjc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jan 2020 17:39:32 -0500
Received: by mail-wm1-f50.google.com with SMTP id m10so2775467wmc.0;
        Tue, 28 Jan 2020 14:39:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=EESes6cMHRph/qkhLWT90QyBlZRSI6qQVGv7ZTuj83E=;
        b=ZnwGqgp0r9HFKnbaz9lyQqbzomcVwaZRHsTd9sGmvE1k0DgwByF7BuyD/Nv/CBW4zI
         HWgNkWVAfp0Ne5BJseelv21iQEvafA/PFr3mCPhRl/8ZQq7/WA4j2avXPzvd8xg+PrNk
         IFOwBPJDaBBxftajGG5rqWShaE2B9JD4h7T6IW6IrHucbScq9McnilyOWYFy28rEy/yg
         +lE11K5r0iVQbSikWduHkxOHsUeO7Mtjzxfdu1xtFrn13K3U+gMrp13vs96U6SfXW/8w
         ttRnlfOMaMk63SYvr/hcRkGrMW0eZuzTAlrIRZx2b7D+X9+Ijr1xAxSSMTb/sikVPTAv
         sKgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=EESes6cMHRph/qkhLWT90QyBlZRSI6qQVGv7ZTuj83E=;
        b=UCFHEiHipVDNcwpg8j66lA13F1I+XUhVebKe6RQA+3xa42Z5qoTTRCTR2lJjscOmO8
         D+QMlnh/x7HXibo+k0UoUVzT4ovusbw3HqKlepamtqF7sVFTVCU9Zl5VgN3ox1bUpzKl
         VDO/X/9+2HaOVUbLm4fGFJJEWopmy2R342igxILYevX4rtKswvhW6wb5JbeNRgb9z/Eb
         4sMvCjzgFYvw4QWfwiJRSA+Ne2LcZqCbTwPX9nKHeq1y5lwewsTpqUjmg99R9u89y/nW
         8wtxd7DYmpJq7vzayhKcLKu6OS80otdGnjQGbHug4hu42rpp/DdvM39iHZbTmkKF4QKH
         20Fg==
X-Gm-Message-State: APjAAAVOsITm1XbBQl4opJehe5qOg7wiDQJBME99UG/PbICWmghkC5uV
        +FEbPE0KnuMo34Ou9Hyoxx6uDHgZ
X-Google-Smtp-Source: APXvYqzAujTGZxewBQEg2M3Zm6qB/28qql53Qwn5XNEuqk+6qhQuImr2Btx8QyhiKEMgXhSdwBLFWQ==
X-Received: by 2002:a1c:e388:: with SMTP id a130mr7168800wmh.176.1580251169288;
        Tue, 28 Jan 2020 14:39:29 -0800 (PST)
Received: from [192.168.43.59] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id h17sm233107wrs.18.2020.01.28.14.39.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2020 14:39:28 -0800 (PST)
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
To:     Christian Brauner <christian.brauner@ubuntu.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>
References: <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7@kernel.dk>
 <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
 <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
 <15ca72fd-5750-db7c-2404-2dd4d53dd196@gmail.com>
 <82b20ec2-ceaa-93f1-4cce-889a933f2c7a@kernel.dk>
 <60253bd9-93a7-4d76-93b6-586e4f55138c@gmail.com>
 <43a57f2a-16da-e657-3dca-5aa3afe31318@kernel.dk>
 <20200128212533.snjm34gct3kmfxfi@wittgenstein>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <23cf858a-389e-676d-b239-155284eec6e3@gmail.com>
Date:   Wed, 29 Jan 2020 01:38:50 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200128212533.snjm34gct3kmfxfi@wittgenstein>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3eYLF71RS5ivj7kVym3U6jqyooSj8n90X"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3eYLF71RS5ivj7kVym3U6jqyooSj8n90X
Content-Type: multipart/mixed; boundary="oVTFtXAUhKVmeJ9ryUAJuOEX8IAytDe0f";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Christian Brauner <christian.brauner@ubuntu.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: Stefan Metzmacher <metze@samba.org>, io-uring <io-uring@vger.kernel.org>,
 Linux API Mailing List <linux-api@vger.kernel.org>
Message-ID: <23cf858a-389e-676d-b239-155284eec6e3@gmail.com>
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
References: <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7@kernel.dk>
 <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
 <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
 <15ca72fd-5750-db7c-2404-2dd4d53dd196@gmail.com>
 <82b20ec2-ceaa-93f1-4cce-889a933f2c7a@kernel.dk>
 <60253bd9-93a7-4d76-93b6-586e4f55138c@gmail.com>
 <43a57f2a-16da-e657-3dca-5aa3afe31318@kernel.dk>
 <20200128212533.snjm34gct3kmfxfi@wittgenstein>
In-Reply-To: <20200128212533.snjm34gct3kmfxfi@wittgenstein>

--oVTFtXAUhKVmeJ9ryUAJuOEX8IAytDe0f
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 29/01/2020 00:25, Christian Brauner wrote:
> I've been reading along quietly. In addition to what Jens said, to ease=

> everyone's mind: pidfd_getfd() doesn't allow to unconditionally grab
> file descriptors for any task. That would be crazy. The calling task
> needs ptrace_may_access() permissions on the target task, i.e. the task=

> from which you want to grab the io_uring file descriptor. And any
> calling task that has ptrace_may_access() permissions on the target can=

> do much worse than just grabbing an fd.

Good to know, thanks!

--=20
Pavel Begunkov


--oVTFtXAUhKVmeJ9ryUAJuOEX8IAytDe0f--

--3eYLF71RS5ivj7kVym3U6jqyooSj8n90X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4wt/0ACgkQWt5b1Glr
+6Vd3A/9GISP7sSN8O0lTDXoPvR6y29W8LT9KsLDopisUherenZqMAAze+PtVaF+
ezW+W2zcSUA0EpyfeQkxEy8PM5iNuXp3RQ68LveCpX+Kaj6AJTogu0rFJ2U4ipLR
Xjw+C8X0RbOcA1jsQqikJT6myddh1IrbWQpg0xFRRwJNQHJreZa/VyJ5rUJkbTWH
oQNnIW/2jFvY3Z5dwEtqusBRhKkbvna5JaKa5px/nO5f96G1r+f6sqpB4dap57xA
tUVurLNkdODC708Cg4DAGSrNOJXGY+89FOHmKkQ5jECiNvcjrLE7EVX5o+MU75Qi
H89Hy3bOQbyQzzhy6R41xQ9uNv55nhN+5Qbk0C1qTtVw3JM/N99ST9p3ONqLKSGM
o3siMZ1XCzsO46nZF8zsScIQvMdpkPFsW6C5320T7AI1i3BolLyRW3dVn2jMJgLt
5rL0bKJyu78AhjHGBS+0hnOTte6hionDF4FOriIiPNW69OjH9XcmNF1U/Wdj+bYu
YoFD4bJXCCCNB+CXljOC03jn3XwGId4A7LjlyOn6QpL2omKnavhbC8K15CxWWX2i
xVhPAgG3BkY4IkUy6DZlpZqZ4Ku84c9lbRqmNIyoTHU9+jj3sV5SB8Gd+UR+VA0T
zg6n4yuRxrsmQ/wCZ+jWrHm7rE5PZ3+3+xfQSYUkCQXVjP+e75g=
=xfEc
-----END PGP SIGNATURE-----

--3eYLF71RS5ivj7kVym3U6jqyooSj8n90X--
