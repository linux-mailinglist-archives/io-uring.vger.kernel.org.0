Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFC37141414
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2020 23:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbgAQW2f (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jan 2020 17:28:35 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45909 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgAQW2e (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jan 2020 17:28:34 -0500
Received: by mail-wr1-f65.google.com with SMTP id j42so24115686wrj.12;
        Fri, 17 Jan 2020 14:28:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=8JPjIxD10BTQb1e/iWLXlur2yHk2O/VzlHp27Zd/HJs=;
        b=DMsTOGZwyughl1o0lXhD/85M9Q3yWijyN8lJwVjsWLLHe6no5/qhMy73mi4M000Htc
         23Wy6hXVBbs7cCqryvkhMav9WLWJ3eLWx9AO2o9b54zAHkqiLkSxVdGsxwp0HGL9QPFN
         c09VHCtkeNicP1iEprEucTyqzVUxpcKndixe+9IM99osOcXxqGfRm6owfYF+qRsVkrbH
         0vGhZybq6LSKS3qvkGZAhldnkiwDIHPuHTWR/jFRARZCl8Dg04MO0we26OOyo/NYsmV5
         XB1MOFYAO/uvI5aQPMPBaWXC4poFHyqf/iY4rXtUyoywxRFJZyWrY8U0wiVcNvk+ZBwX
         rUAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=8JPjIxD10BTQb1e/iWLXlur2yHk2O/VzlHp27Zd/HJs=;
        b=t+t/woM5riG9gkDx27eRKAzJO3k8N4rnRMdaXrGVhbg1nXSGMFFRcXeQRCLpERwST0
         ITLU0RdOEw2rQ8Qbdm9HlouYdV80gGVsTxNxsEpuIzwF9unLK59V+L7mxROBAbAFENkM
         zl0679RmSuOR90WlqL9Kb2InwD+wU3IjNiI7vtDs8URKh9SC2INf7P4dt3aht3b7yInQ
         L1eGKtS0JXvY6O7w6Spv5ZGEItvzfk3AuRqm7bIa51y+XcLtjqfnRY4fqIyafuzK2BTK
         BLeiYHmLQXhgR7Va/2MqbPQyVwb9SND2BU41t8Rhp43TEe6CbjylQqv9+wSbGd+kAiad
         ycHQ==
X-Gm-Message-State: APjAAAVnC8nKAqCqZgaA3i1FRKDK2Y5BILhQWKxtnlT+MnvQ0niZJ4ww
        g414lN5eHfOAqH4/7jAH+6EtkQwns6s=
X-Google-Smtp-Source: APXvYqwEWbrdbeXQFO3shXbcYptLKb0X9680xsUI1My//MSwsyDdPBQh1JJD0jOR4TsSwlcSbE8qGA==
X-Received: by 2002:a5d:6a10:: with SMTP id m16mr5261902wru.411.1579300111596;
        Fri, 17 Jan 2020 14:28:31 -0800 (PST)
Received: from [192.168.43.134] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id f12sm952792wmf.28.2020.01.17.14.28.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2020 14:28:31 -0800 (PST)
Subject: Re: [PATCHSET v2 0/6] io_uring: add support for open/close
To:     Jens Axboe <axboe@kernel.dk>, Colin Walters <walters@verbum.org>,
        Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org
References: <20200107170034.16165-1-axboe@kernel.dk>
 <e4fb6287-8216-529e-9666-5ec855db02fb@samba.org>
 <4adb30f4-2ab3-6029-bc94-c72736b9004a@kernel.dk>
 <4dffd58e-5602-62d5-d1af-343c4a091ed9@samba.org>
 <eb99e387-f385-c36d-b1d9-f99ec470eba6@kernel.dk>
 <9a407238-5505-c446-80b7-086646dd15be@kernel.dk>
 <d4d3fa40-1c59-a48a-533b-c8b221e0f221@samba.org>
 <1e8a9e98-67f8-4e2f-8185-040b9979bc1a@www.fastmail.com>
 <964c01cc-94f5-16b2-cc61-9ee5789b1f43@gmail.com>
 <cbdb0621-3bc8-fc41-a365-56b2639e39a0@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <991faae8-909c-0aed-a9ee-aab01f8db8e9@gmail.com>
Date:   Sat, 18 Jan 2020 01:27:52 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <cbdb0621-3bc8-fc41-a365-56b2639e39a0@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="jrmhkb4217JCqyjHK9VDtwUxDX7rLuw1m"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jrmhkb4217JCqyjHK9VDtwUxDX7rLuw1m
Content-Type: multipart/mixed; boundary="sIKRKxNYilBHMMIeIh2iO9vPEjp15S5Jt";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, Colin Walters <walters@verbum.org>,
 Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Message-ID: <991faae8-909c-0aed-a9ee-aab01f8db8e9@gmail.com>
Subject: Re: [PATCHSET v2 0/6] io_uring: add support for open/close
References: <20200107170034.16165-1-axboe@kernel.dk>
 <e4fb6287-8216-529e-9666-5ec855db02fb@samba.org>
 <4adb30f4-2ab3-6029-bc94-c72736b9004a@kernel.dk>
 <4dffd58e-5602-62d5-d1af-343c4a091ed9@samba.org>
 <eb99e387-f385-c36d-b1d9-f99ec470eba6@kernel.dk>
 <9a407238-5505-c446-80b7-086646dd15be@kernel.dk>
 <d4d3fa40-1c59-a48a-533b-c8b221e0f221@samba.org>
 <1e8a9e98-67f8-4e2f-8185-040b9979bc1a@www.fastmail.com>
 <964c01cc-94f5-16b2-cc61-9ee5789b1f43@gmail.com>
 <cbdb0621-3bc8-fc41-a365-56b2639e39a0@kernel.dk>
In-Reply-To: <cbdb0621-3bc8-fc41-a365-56b2639e39a0@kernel.dk>

--sIKRKxNYilBHMMIeIh2iO9vPEjp15S5Jt
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 17/01/2020 18:21, Jens Axboe wrote:
> On 1/17/20 2:32 AM, Pavel Begunkov wrote:
>> On 1/17/2020 3:44 AM, Colin Walters wrote:
>>> On Thu, Jan 16, 2020, at 5:50 PM, Stefan Metzmacher wrote:
>>>> The client can compound a chain with open, getinfo, read, close
>>>> getinfo, read and close get an file handle of -1 and implicitly
>>>> get the fd generated/used in the previous request.
>>>
>>> Sounds similar to  https://capnproto.org/rpc.html too.
>>>
>> Looks like just grouping a pack of operations for RPC.
>> With io_uring we could implement more interesting stuff. I've been
>> thinking about eBPF in io_uring for a while as well, and apparently it=

>> could be _really_ powerful, and would allow almost zero-context-switch=
es
>> for some usecases.
>>
>> 1. full flow control with eBPF
>> - dropping requests (links)
>> - emitting reqs/links (e.g. after completions of another req)
>> - chaining/redirecting
>> of course, all of that with fast intermediate computations in between
>>
>> 2. do long eBPF programs by introducing a new opcode (punted to async)=
=2E
>> (though, there would be problems with that)
>>
>> Could even allow to dynamically register new opcodes within the kernel=

>> and extend it to eBPF, if there will be demand for such things.
>=20
> We're also looking into exactly that at Facebook, nothing concrete yet
> though. But it's clear we need it to take full advantage of links at
> least, and it's also clear that it would unlock a lot of really cool
> functionality once we do.
>=20
> Pavel, I'd strongly urge you to submit a talk to LSF/MM/BPF about this.=

> It's the perfect venue to have some concrete planning around this topic=

> and get things rolling.

Sounds interesting, I'll try this, but didn't you intend to do it yoursel=
f?
And thanks for the tip!

>=20
> https://lore.kernel.org/bpf/20191122172502.vffyfxlqejthjib6@macbook-pro=
-91.dhcp.thefacebook.com/
>=20

--=20
Pavel Begunkov


--sIKRKxNYilBHMMIeIh2iO9vPEjp15S5Jt--

--jrmhkb4217JCqyjHK9VDtwUxDX7rLuw1m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4iNOgACgkQWt5b1Glr
+6Xdcg/+NRft3M29OZEuBnldQz8531DA1mDvK9jt8hqEMq8Ki9dwLjxo0A8liPAA
naIcQ7mea9CaYEwScvTIi+jhrNHEhgnyLACS7gnOy0yXyxyI66z8uqHiwj6yo05V
DXs6G5V504ndEHH/BhcEV6TGzw1dY8n6RE01vWzH/X1t15RN3os19RjEvCIpUjja
a3YxWbza8JmUGFSfuymj655IuLnimTXQcWm77epNKzrP97O1pmlmJ0HdF2tzG2gZ
6+mFRwZS+No0SN6E5M8ITnZBaadyVHZJoJ4FROvdtVwW9N5VKv/UQb2UrJtJ4lkO
5TjMxm35a19V1AsnJOSkPUJoqq1IxvZLwMlvJazDIn+Wrl3X/oge0z1SsTURGtfZ
vAfSHylKXNZN8XzQEv5BFEmtDnOammYh5Js/FG2T/Mn5Rdl6STrr5GmtgVPGloc7
goehgnxQAR6E40D214SZLgQoRYyf/wdXUn4Y77W/MUVf0g4NpwDiNSCSWaXMcVdE
gZnC9roF2hl0GWD+mFgqc6u7yqXJj1CM5V8rkralM7P8U3j3U8Lrk9y6Nciasbk2
v1S1SQvGt7a3nfTiXwpz/2EenL2q9ZW2eNpUPxoGCGTWQ0nfve/DeKurolh18AcY
xEQnBDHGrNIvNBFLTEnEHyKy7bbcwMoWxM2deUhC7vnyeBU3tG4=
=WrdO
-----END PGP SIGNATURE-----

--jrmhkb4217JCqyjHK9VDtwUxDX7rLuw1m--
