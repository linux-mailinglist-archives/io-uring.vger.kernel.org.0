Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59BAF14F56B
	for <lists+io-uring@lfdr.de>; Sat,  1 Feb 2020 01:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbgBAAcS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jan 2020 19:32:18 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36004 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726264AbgBAAcS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jan 2020 19:32:18 -0500
Received: by mail-wr1-f66.google.com with SMTP id z3so10708116wru.3;
        Fri, 31 Jan 2020 16:32:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:references:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=nClKbpvo7N4EeBPrBoCoNOC/kbhnzVjccKuhK+B/IrI=;
        b=RKwdvxvjRXQ5CjhJCYK5xLUj/bwrgNQfxEZqEqDJyH3giH3cgGIUN0E37UGWr/0i0m
         HgTefiQflJG1Uc/AKWYnq8H8sZtkDgpU3JychNxfhBjy6ijnQacn9ifsNY1w+24iYPy1
         4uqEJ8XpqDOo5zimqvkAPIwucuDoD1x69bEKLs2qeoDpA4BfnG6wEDDawrJKbdTs1cyB
         RCMoQObkOsCteAvueulUFvqbC8D8Ae1Z7WpEvMIwZnENM8vhsbFeuNkG+XilMaVDS9FJ
         PiXzli6TD9p3FtPj8QWfWkoH+ltTP1Rqm98LgTumsSKZigc9DmHc/f3+rXwHA7aeSkXT
         75hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:references:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=nClKbpvo7N4EeBPrBoCoNOC/kbhnzVjccKuhK+B/IrI=;
        b=hho/+mi1aQHfAoGfdwr84vWHSmOinrjJ/1Uij+XoXrBt9nmdgs26qoZiYiNAzZSLp7
         oulXtaPH3bMZCfArpBWAivH3xxi30vguDoFCafmv+J0wrGVfbki5tFZdqwEsPq63uK2m
         Rnh1O7W/Qi62VhQWdXCIuRSMpSReqRAVpThyfYb0BimuNbx1wckGWcb2Jwo2h2FYLAkj
         Lvz6pSl8ZcCtJYDlHrW2qbpP8D5QoPALXk5CAUVuYosTR4WUNVFMPHEG53tEF+2ISrRA
         6Kv4Af0rf2BnJcIgraprbBI5Hbs6YQVWwJuYrPHXpRNWDjlTmQBImH+rYOyNQ/UAhrCJ
         RSNQ==
X-Gm-Message-State: APjAAAWaG1PS3DI4xm+tcga39C6OfJyMs7ci76132P59KlSO+5tnZqv9
        9xRIWMI3r+vp8v8G8/TFRY3VKRUw
X-Google-Smtp-Source: APXvYqwj0P/RAPdmFBWR/8nNQTpNKyHpze1P7juUF25j6ko/WhdkruYq2O1lnDmG/ceVko+D2Npvcg==
X-Received: by 2002:adf:b310:: with SMTP id j16mr961931wrd.361.1580517135378;
        Fri, 31 Jan 2020 16:32:15 -0800 (PST)
Received: from [192.168.43.154] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id v5sm14057864wrv.86.2020.01.31.16.32.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2020 16:32:14 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1580508735.git.asml.silence@gmail.com>
 <6492ccd2-e829-df13-ab6e-e62590375fd1@kernel.dk>
 <199731e7-ca3f-ea6c-0813-6aa5dec6fa66@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v3 0/6] add persistent submission state
Message-ID: <18b43ead-0056-f975-a6ed-35fb645461e9@gmail.com>
Date:   Sat, 1 Feb 2020 03:31:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <199731e7-ca3f-ea6c-0813-6aa5dec6fa66@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9qbBbTO9vuKvGdNLtka83mwq4aSsQPGUJ"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9qbBbTO9vuKvGdNLtka83mwq4aSsQPGUJ
Content-Type: multipart/mixed; boundary="cnCZt9dfTR0Vc4nYrEbEItomcGaJCGDOY";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <18b43ead-0056-f975-a6ed-35fb645461e9@gmail.com>
Subject: Re: [PATCH v3 0/6] add persistent submission state
References: <cover.1580508735.git.asml.silence@gmail.com>
 <6492ccd2-e829-df13-ab6e-e62590375fd1@kernel.dk>
 <199731e7-ca3f-ea6c-0813-6aa5dec6fa66@gmail.com>
In-Reply-To: <199731e7-ca3f-ea6c-0813-6aa5dec6fa66@gmail.com>

--cnCZt9dfTR0Vc4nYrEbEItomcGaJCGDOY
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 01/02/2020 01:32, Pavel Begunkov wrote:
> On 01/02/2020 01:22, Jens Axboe wrote:
>> On 1/31/20 3:15 PM, Pavel Begunkov wrote:
>>> Apart from unrelated first patch, this persues two goals:
>>>
>>> 1. start preparing io_uring to move resources handling into
>>> opcode specific functions
>>>
>>> 2. make the first step towards long-standing optimisation ideas
>>>
>>> Basically, it makes struct io_submit_state embedded into ctx, so
>>> easily accessible and persistent, and then plays a bit around that.
>>
>> Do you have any perf/latency numbers for this? Just curious if we
>> see any improvements on that front, cross submit persistence of
>> alloc caches should be a nice sync win, for example, or even
>> for peak iops by not having to replenish the pool for each batch.
>>
>> I can try and run some here too.
>>
>=20
> I tested the first version, but my drive is too slow, so it was only no=
ps and
> hence no offloading. Honestly, there waren't statistically significant =
results.
> I'll rerun anyway.
>=20
> I have a plan to reuse it for a tricky optimisation, but thinking twice=
, I can
> just stash it until everything is done. That's not the first thing in T=
ODO and
> will take a while.
>=20

I've got numbers, but there is nothing really interesting. Throughput is
insignificantly better with the patches, but I'd need much more experimen=
ts
across reboots to confirm that.

Let's postpone the patchset for later

--=20
Pavel Begunkov


--cnCZt9dfTR0Vc4nYrEbEItomcGaJCGDOY--

--9qbBbTO9vuKvGdNLtka83mwq4aSsQPGUJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl40xuoACgkQWt5b1Glr
+6WJzRAAp6ZiD6oT1kfCj3dtT1jZOT1dYVmuEnzpXGqDYbI2VsgTmCTMUbIALQWq
f03If6bPaCTIrMN+KMKN1XYwwI2RtCc3ddFLFyNxf1M7A3PEcnJ3lDXgJPdmficL
UiIugHz5AYTwArin0fCKMtRVB5i9D59G1O1q6t4FRjW/M+eS/Ss+yxkkgVWdFgFV
yAzBHuALw87pVdTdx70vr7nFuKTivY4aWLLrZcQaIfw5uE+NCKbIUFdgjtHhqxHw
Jqa67u7Clqu1zeJYSOOefB7v+AlPFS801GOUyxoI9f6qCIG6qlcfEvWYrtuG76Sf
HZEMh/Hw6Lo2UlPWAMMbHG7ukCMLE/YEasWufNi5MjbPAAh/xytkKU+4+6bIg3IC
23ZjR3yov2vlxQ9h1mCc7MOiDCtUQz5YTL3TMu8+WTBhH9tPS+fjyXCTy0UFnFJS
9WHv99AuR9zQwN/5RNrNxi2HWRdmzY3dJEehdo6H6JaiOHycjcDTn9Fwhha51MZf
yX3Pf9ejQccwa1810jAPkbPmPerjiSprVpmpGWD4W1CO24j6Lf17dHjq/y5F25mM
QBJ5lbQXd8ferBomfK0LI0U3szqvhwr/qZZjMnzheaySNCKjq3LkyUVEShcXBGDP
fBqWZuK6Bjx1aLNiUIXEWXednYDSJc6EtEhwwUGt8R3k78cM7Mo=
=iian
-----END PGP SIGNATURE-----

--9qbBbTO9vuKvGdNLtka83mwq4aSsQPGUJ--
