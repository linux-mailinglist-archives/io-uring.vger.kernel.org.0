Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C34DF156030
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2020 21:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbgBGUxa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Feb 2020 15:53:30 -0500
Received: from mail-ed1-f53.google.com ([209.85.208.53]:36847 "EHLO
        mail-ed1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbgBGUx3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Feb 2020 15:53:29 -0500
Received: by mail-ed1-f53.google.com with SMTP id j17so996144edp.3
        for <io-uring@vger.kernel.org>; Fri, 07 Feb 2020 12:53:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:autocrypt:subject:message-id:date:user-agent:mime-version;
        bh=p+2uFoLXelvqXf1KYHxytZzJWUMavE1z0wLMy6oY0dQ=;
        b=gnxVJuJptQ+4eA5lc+Xel/hBsCzrk69ethkP0zsMHZiFKbkCHwIgdkANChZkoHzKSY
         trYRjMIlfBVE2cuDZwTYQ1PEscqRRpE+Uf8oGTf0OsI6nsY0u4m0wp7HjjvpGzhUykiu
         16rtEYHqaTiv70Cjni1FL2/wcFeyRrcz2tP1lzQfleGO6t2SA0tQJpQkPWHOYSmIdF6k
         yMoWB548AoKpdkYPQ83hZxZW4Li6+WtdvSmGTmt1c59ln9XbvT9nGIJjvx41S7H4w+3u
         iwGGTA8jTEMRvaqRSQIZrLvyQ9m4hlV4XE13QCe3WXZs1elmz1A5qIIUhxd+9QTi5+FU
         jJSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:autocrypt:subject:message-id:date
         :user-agent:mime-version;
        bh=p+2uFoLXelvqXf1KYHxytZzJWUMavE1z0wLMy6oY0dQ=;
        b=dVmML90E12RF3pJsMg0aZaXpYGaqMmEngttX/ZvdWjy1Y43tMfaKZYSi+kIRP1yHdk
         v+UJzT5aw5OJXKzxkEfyFPQEv7idqEj8knE92KHPndQU8DecWaW3rVfoqYl33KbAu8gk
         5rGWzF6Lyle3GMPW6vqyzypCGCkxkCe5JLZFiSjdT/SKlBavnEPzYARYuY9cabBtTeuT
         NHdxD6ZxLL1WmgaahQeDd6bfeqUTvQ1KBebYPF7hWLU3jU+63clj19+Ho5IM8DZ8x5CK
         qU0VO7wmkKkOA0mRY6/N0M90PQW0wGYVQ2SfeqbIE+Ko+IIpnY8G0ac0GOE+fmjqSio1
         eKqw==
X-Gm-Message-State: APjAAAXmbiocmreK2hsiKQayTzXCnyHvLn6C02L3q0jf+QL+FUbHW4/5
        OkIBHSGAi2VfUB20b0bW+F1dWoop
X-Google-Smtp-Source: APXvYqxD7b2tmVBYOuG37iWCHAI56cCQdOK052BaWNdignG2SPwHr4QUxUPlVrGh9+ez/j9pwo317A==
X-Received: by 2002:a17:906:3ec4:: with SMTP id d4mr1036295ejj.173.1581108807035;
        Fri, 07 Feb 2020 12:53:27 -0800 (PST)
Received: from [192.168.43.117] ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id lc20sm481729ejb.78.2020.02.07.12.53.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Feb 2020 12:53:26 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: io_close()
Message-ID: <45f22c50-1ffe-4b73-f213-08dd49233597@gmail.com>
Date:   Fri, 7 Feb 2020 23:52:34 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cWb018YvvgsxMQzfzjhqlXxtsVa5pLkIZ"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cWb018YvvgsxMQzfzjhqlXxtsVa5pLkIZ
Content-Type: multipart/mixed; boundary="8eYfPbq0Y048gZyPAnWhHXiNNcQJXvP8y";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Message-ID: <45f22c50-1ffe-4b73-f213-08dd49233597@gmail.com>
Subject: io_close()

--8eYfPbq0Y048gZyPAnWhHXiNNcQJXvP8y
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi,

I noticed, that io_close() is broken for some use cases, and was thinking=
 about
the best way to fix it. Is fput(req->close.put_file) really need to be do=
ne in
wq? It seems, fput_many() implementation just calls schedule_delayed_work=
(), so
it's already delayed.

--=20
Pavel Begunkov


--8eYfPbq0Y048gZyPAnWhHXiNNcQJXvP8y--

--cWb018YvvgsxMQzfzjhqlXxtsVa5pLkIZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl49ziAACgkQWt5b1Glr
+6XaXxAAjyzEvDnpTaQDcHfI7JqsTWt7b47GyyTpHRgi1h9saMS1W9x4nNrOMHT6
dDzHVXEn11dj5hT3kZgZfhrCC91UvLfgTAy1a28+lWPJcNyrYsFnyqQt74G1qBsA
+6EBjOJHPP/X8QfnCVu+LVqzLBtnjkh7TNBX2fSodLrzs3QxgaxMcQ/ih250QlBC
ATXmAjrtplRq5l2ubHQ9cqWoTrI0GqtcurH30GdZ/wGXCQWYSjFe+QDCSMOPQD1s
psyn4PHdchf/Hhay3Cku3g/z5dsfzjLM6smsq/VOG+hBV5AfT28YOBqwn3UI+QpF
7vmdWiGSdN/bNd0VlhyNFZKCzL015xj0+vm5XEpokuPpUvdH1FZvlNDsVgfJkhCm
tzechHMGk1F8wSNFndC7JpvjfIujN0y6Bq6OSE+dvNzfRJfVnnrVSM/2I2e6gk7K
wAAtmCEmP0iWIe5oT1tEDPf1zYxNdOmOgVWOAmbCnJbfli9qz7BaFyCYqhXBOgN8
zrTJCHcivMCEV9CBw61iEOjxsc6Tdnt/c0RJD/W5yr010g7Zxkf3Og7YgVnqkNIP
qG0ex5w3FxgP2XlfTY/fqCVoVnXjwJpA3bPqjutpX4vk1XCUICL7T9Epsx/IGu/f
2Nc15VGkttr8Py1ks3h/9FWOmskmVbvPfUV1Ow6ZX9DxKlFwTiA=
=8CUI
-----END PGP SIGNATURE-----

--cWb018YvvgsxMQzfzjhqlXxtsVa5pLkIZ--
