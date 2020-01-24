Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 813A91486ED
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2020 15:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391782AbgAXOTd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jan 2020 09:19:33 -0500
Received: from mail-wr1-f52.google.com ([209.85.221.52]:34419 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391701AbgAXOTb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jan 2020 09:19:31 -0500
Received: by mail-wr1-f52.google.com with SMTP id t2so2191562wrr.1;
        Fri, 24 Jan 2020 06:19:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:autocrypt:message-id:date:user-agent
         :mime-version;
        bh=9IdvFKBgHlNKMFuTIp4yFKU8c0Hp1QIXC5BzDAkguRo=;
        b=IBP6TxWNkQL9ptXI0JWsAVzjTjnhh5h9B0xJDRfmqwZRgJP7lxciNaSp5IjOQpoE2H
         WZ/ZqiSdPk1wbR2L8sfNTG6T1PPG7G/BrUQM6DUhq7NVvr7kxE6eUB9HkCVoTF4vVECD
         vJXDXLBOMQddymi5Ak/I9sCeKPt0eC8y9I6nK9dyiacRfZ6RwTHNYC3L3DHGV/CTMy6X
         AwTjmj5lz/0wAuqZA++IL6vMSEh2wDjxcPAeI5wDL1pX1de9h06hrg91rSMOV4RE9Ss/
         oF2rR3VVFOouBjo9Zd22Hx2sxIEL9jfLCAJeqHdkmggk5fvvLe0OsCKR3EVz6UoOn05x
         eiCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:autocrypt:message-id:date
         :user-agent:mime-version;
        bh=9IdvFKBgHlNKMFuTIp4yFKU8c0Hp1QIXC5BzDAkguRo=;
        b=qgL7XkdZCtEVTCYC/3kHNpb/Ht7QasJ6N7/5ub+pERP/bDB3BsIuT9C/l/xbHVDpQ9
         6+SehaJZHjF6F7t3sGk43990yK+Hiey1+NuDPfmd0QsOjQ5648lMW3Km/1k66xl6ACEv
         ns7OrZWyaKk0RBWsjIGFmGXZxEe5ECBKBMKqpYMd8lUZ1dT+CaGMIDcRdpT2ZLpx5GFH
         hI9JnPfLigqU5CfjCfrHTagx7EGnOyAU6kIabxdTX/WGEUgEXgZpkYndTIIzqoeQrWo6
         NcobeVIO7cU8HbAgiBAg/mXevWzXQvdqqckA4NJ7Y0axzhg+I8MlKh5ielFseNEGs9G/
         KrUg==
X-Gm-Message-State: APjAAAWMuY4Ul1uT3MOA8rYjBTfdlhEtxsMf2KfOn8FxkPtTPdiJKtAf
        zSzJcvAGxDdn5e5MHQKA6kcTcT3D
X-Google-Smtp-Source: APXvYqysF6wDSLSLIQ/e7/IHb3oPUWoOjZwXbvpN07LcycFUAjW5Hjr2+1gp5QyVehWYKN3Ps0bQhQ==
X-Received: by 2002:a5d:5487:: with SMTP id h7mr4637023wrv.18.1579875568274;
        Fri, 24 Jan 2020 06:19:28 -0800 (PST)
Received: from [192.168.43.234] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id 18sm6520787wmf.1.2020.01.24.06.19.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2020 06:19:27 -0800 (PST)
To:     lsf-pc@lists.linux-foundation.org
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: [LSF/MM/BPF TOPIC] programmable IO control flow with io_uring and BPF
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <e25f7a09-96b2-2288-4777-9f728a8b2c23@gmail.com>
Date:   Fri, 24 Jan 2020 17:18:51 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="0LV8n20qL5EK3u7w5gCE2tBF4ac0MbLrp"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0LV8n20qL5EK3u7w5gCE2tBF4ac0MbLrp
Content-Type: multipart/mixed; boundary="rHfM5TTORUYfRdCkqQS3U5Fn1pICpC3yH";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: lsf-pc@lists.linux-foundation.org
Cc: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
 linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <e25f7a09-96b2-2288-4777-9f728a8b2c23@gmail.com>
Subject: [LSF/MM/BPF TOPIC] programmable IO control flow with io_uring and BPF

--rHfM5TTORUYfRdCkqQS3U5Fn1pICpC3yH
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Apart from concurrent IO execution, io_uring allows to issue a sequence
of operations, a.k.a links, where requests are executed sequentially one
after another. If an "error" happened, the rest of the link will be
cancelled.

The problem is what to consider an "error". For example, if we
read less bytes than have been asked for, the link will be cancelled.
It's necessary to play safe here, but this implies a lot of overhead if
that isn't the desired behaviour. The user would need to reap all
cancelled requests, analyse the state, resubmit them and suffer from
context switches and all in-kernel preparation work. And there are
dozens of possibly desirable patterns, so it's just not viable to
hard-code them into the kernel.

The other problem is to keep in running even when a request depends on
a result of the previous one. It could be simple passing return code or
something more fancy, like reading from the userspace.

And that's where BPF will be extremely useful. It will control the flow
and do steering.

The concept is to be able run a BPF program after a request's
completion, taking the request's state, and doing some of the following:
1. drop a link/request
2. issue new requests
3. link/unlink requests
4. do fast calculations / accumulate data
5. emit information to the userspace (e.g. via ring's CQ)

With that, it will be possible to have almost context-switch-less IO,
and that's really tempting considering how fast current devices are.

What to discuss:
1. use cases
2. control flow for non-privileged users (e.g. allowing some popular
   pre-registered patterns)
3. what input the program needs (e.g. last request's
   io_uring_cqe) and how to pass it.
4. whether we need notification via CQ for each cancelled/requested
   request, because sometimes they only add noise
5. BPF access to user data (e.g. allow to read only registered buffers)
6. implementation details. E.g.
   - how to ask to run BPF (e.g. with a new opcode)
   - having global BPF, bound to an io_uring instance or mixed
   - program state and how to register
   - rework notion of draining and sequencing
   - live-lock avoidance (e.g. double check io_uring shut-down code)


--=20
Pavel Begunkov


--rHfM5TTORUYfRdCkqQS3U5Fn1pICpC3yH--

--0LV8n20qL5EK3u7w5gCE2tBF4ac0MbLrp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4q/MsACgkQWt5b1Glr
+6UA2w//V5C2WFhXICVCY+8EzfRtlfmBW9dKejAbl/L/7YjDlzrFlO1SidaEw81x
RyVQNzH1WMomxHmePO0KHdbAr4UlN5Rzx0B/hWAg93wUStYSvX5qhJ6he96wNxpm
QltbgoiEhBfTu8C2ouM2tneY0AEg1T76Y4TNsbVhk2EOzVVlCCAPGK0SdaIUMIH1
A79CBZPcoFf8Q1Uiy+4xKSgVaTVjVXOTOn6j7ECweHamHuISWkxbYX9t27S/g3f4
O01TNPSJOqoqsD0O7WpTawZZ8+qek89Pq5Q2WUKT90ncvprA6H0PvL5tBMPtMtK5
Eg1a3QIkjQLL/HmXxyS9QYbzpE9JT8pP9JabL+U45GJUc9AK7MwDglkALidoOYNY
1dilgS844sS5GB5JrhuooBFQQzBiTVRM70D8b4xDAyJUr3qE0dlbee4ar0SwKNlI
fZrXO60EgHbL2jADkHSduuRVSpeGu6upRbadDgu4mVwXgytEVDX2Jo0LiQDT3jzE
RxFxEOyARQ5J0DoPsyjDHhCKIfsxwXcp+kVRPG4axhUkQcYVRpkhkKe8YIGUVRX4
SHjkFTTgnxPhZlNk3zijLNI18m+/pw33OfnfhDxUMy9Tma/E6cDwbznbjkL1Obhb
4413QGRZtXZzVhNxY/tOmTZt0CCs2En0533zuVZDyKA8/TWGN5U=
=jWNI
-----END PGP SIGNATURE-----

--0LV8n20qL5EK3u7w5gCE2tBF4ac0MbLrp--
