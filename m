Return-Path: <io-uring+bounces-1947-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CC498CB43F
	for <lists+io-uring@lfdr.de>; Tue, 21 May 2024 21:30:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52B46284C5F
	for <lists+io-uring@lfdr.de>; Tue, 21 May 2024 19:30:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D008219ED;
	Tue, 21 May 2024 19:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mzXMr2Ii"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3751DFE8
	for <io-uring@vger.kernel.org>; Tue, 21 May 2024 19:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716319827; cv=none; b=ZHxxGtFOFVZH33RIdbg1K6X8hG63SU1uVftPE7QoQx7ibabq7B3gGnZSH+NHIj6DRkvoDocVtykKSucDR+NF0ICKDseHX6v8a0raEVMnbIABx4H58JHg24SniDZEDjF9NLePF88ipN38WH02sGrJidB3f3OZBV5KJ71nwi1l970=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716319827; c=relaxed/simple;
	bh=XtQaC+6enyI9cx5QPU7pupTIkAZ2nJ/HjfwxF4Wd5xg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=em/9kAS8oqpQyKd9YqVW8UvB87Yj6d23wvicJJFK1C0Y02O/1OmAxYe6ZKffZsIQo0/3LrOg9nCL+cAC+7dzKtxZJPc02mOByEXV8thpd4Dvj39z6aDojCdzfYdUk12b6hCUX3KX87gvCkh9kTe7NhvvYtvA910QCMcbwjn//Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mzXMr2Ii; arc=none smtp.client-ip=209.85.222.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-7f18331b308so11934241.0
        for <io-uring@vger.kernel.org>; Tue, 21 May 2024 12:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716319825; x=1716924625; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XtQaC+6enyI9cx5QPU7pupTIkAZ2nJ/HjfwxF4Wd5xg=;
        b=mzXMr2IiGrSpFYhdlUX1xRZMReGI40AErk7sgSrnRDYWYZc8qn0el0yDW+/o9mCchf
         Kh1+xdBcRtbZuzhhHxJ31kVKM5haKB35VIY7gyC1JVLjDo4hW5QJHrqgwEh21Z7MJ4DC
         rwon+n6epqdX+47DW2JiWfvZF4v0dvCnnVNiE3J9S0xw1w5Kh+SMHY8PGysScK8MIIdB
         n+JMRQT+g2u1AKezDZUupWiFDuxNZ24RIGhUgrikkP3h/KX9lPu3Jq+/Zt3v+wo1Y7cO
         6udpCxWA4XQ9H558rhcDWMoxHjjwZTCapTgiebDbct2hl1tYrfV+7lx97Iyk8CaECMq2
         /DJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716319825; x=1716924625;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XtQaC+6enyI9cx5QPU7pupTIkAZ2nJ/HjfwxF4Wd5xg=;
        b=BS4jFBGvkcHLP8bE9YIGEAyl8CU/ITqSY25AjBHsrl1c/tnDjX8DubC370KKnKSQ2t
         TpgPYrp6BXozK5KySN3YM9OCejqj57JQAUTd/IzB/QSOTkXIdK4xJK9oR1Qfns3MHM5Y
         wscKaiOHoikajF6lh1y8wxj48lCdO+gKMYqGYFOaqSQWR/P8dGLMvp33HxAnGAoFu2D8
         xRFacfq3KRYp9hH6IO2+/1BUnzaeuJDILdPTGj+mBbqDQ42E4P8lwaEBNlf/ndkZGD+1
         K2xQy3VpjgXqFzf8yMosxAxedg0mwpnONLpSjqGtV9kmwnZ9TabANv4cvw+e1Xo6WodZ
         BGKg==
X-Forwarded-Encrypted: i=1; AJvYcCXAPYoxubT5u8KUb1yDl/K/XLtZRPSOathyN39mOgO4BqwVeSPKYWzX/pHpq9CrbFNAIjYBqix1Nr4DWtNwhJhU+ZPfcc8D5n8=
X-Gm-Message-State: AOJu0YxuEU5Zrm59m72qjM3pO+MPNzj7rRiQSyJkOcDnGp9G+hnIgUFm
	vdx6vp+It4edo/VCZjv4QKHAHPnbBYjkuWmiGmJ/TWu6uik3Gkqzb2uEFg4KX/g=
X-Google-Smtp-Source: AGHT+IEXCjWiUa1QUGY/tzni9Q5JOfa0BmRedvU5PAfC3oLRaIGtulEYfQJYlBdOH+twk/548j49kA==
X-Received: by 2002:a05:6102:3053:b0:47a:22cd:9716 with SMTP id ada2fe7eead31-48077e07a05mr34233373137.17.1716319825175;
        Tue, 21 May 2024 12:30:25 -0700 (PDT)
Received: from [192.168.1.101] (syn-142-197-127-150.res.spectrum.com. [142.197.127.150])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-7f9000e33cesm3537040241.37.2024.05.21.12.30.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 May 2024 12:30:24 -0700 (PDT)
Message-ID: <5a1649cb-2711-4767-8313-0f6bfe0e4cd7@gmail.com>
Date: Tue, 21 May 2024 15:30:23 -0400
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] ETXTBSY when running Yarn (Node) since af5d68f
To: Jens Axboe <axboe@kernel.dk>, Christian Heusel <christian@heusel.eu>
Cc: regressions@lists.linux.dev, io-uring <io-uring@vger.kernel.org>
References: <313824bc-799d-414f-96b7-e6de57c7e21d@gmail.com>
 <8979ae0b-c443-4b45-8210-6394471dddd1@kernel.dk>
 <8de221f7-fe5a-4da9-899e-de2a856a4ddc@kernel.dk>
 <yywbp7fjnwgqxvc66zimea4hgdc2eysjx5nezky3vndr7xw25l@jv76rdseqm3e>
 <b8018270-6e9a-4888-87fd-69620d62c4e5@kernel.dk>
 <0ec1d936-ee3f-4df2-84df-51c15830091b@kernel.dk>
Content-Language: en-GB
From: Andrew Udvare <audvare@gmail.com>
Autocrypt: addr=audvare@gmail.com; keydata=
 xsFNBFOdSyUBEAChmGHO21xk44a8sZTjAMK2G6NZpson6ekB6sGriYgFApDAEQGvnd5btdRH
 aObx8whfPb+NB2QshEKyBsRTtpwSfePuMzcNEYFVJGiuOH2EGx73zRmydpZxetBJaba3oWMY
 ivZ7MhoNsBO1bEYvyrmtXJBrotnMfMAH4HDIkRwEES4KtGXpNK6rVCXFiRNtwqaqeOmGPzEG
 soESrmi3hAFm4QUB0KAsvdQ49siFbZFZFNbVGAv1wqQa6xrTaNK3sw3rsRmj45wsMY/agWZC
 M6Jh9X9R2OMFV2ypqLCOOMF31Jiv/wV7i739EE8F9u2rCITa/ATC+0+9Lr22rcKudrkkY4Wg
 CMaKkmm619Edd5arDPo8GCCTqKNQjArvcl5jQHyxMsmiSFKG1MlhoFSeVCC/c0ScvEeziErn
 AuEvs9vjiNWwHN8+mXJMULi999Pqu85itjDc7OgyUSXY2ZvuDBimxOEN07Tfy4aoVov7Ulls
 l23XvRoHSD1h2SfJTqEJTu88s5P6TVgpszcaFpxuC8KS6guwW6s7SMkG4ujAdlowx0+MKs2Q
 /wiNYT4XcNmF8XBTrEgiIfVewxKgfthAWUCHNEJFrZpvruJxt31YuGPPp8CkhxxHTYMsyRpO
 7RcRYGGNsgzXxLMX5zqbjqdUtns4p+6DKd4lhmYMcybOxb+ypwARAQABzSFBbmRyZXcgVWR2
 YXJlIDxhdWR2YXJlQGdtYWlsLmNvbT7CwZMEEwEKAD0CGwMHCwkIBwMCAQYVCAIJCgsEFgID
 AQIeAQIXgAIZARYhBGCvdPOI709JMcCOOBr9mvwSDCbdBQJbJxjGAAoJEBr9mvwSDCbdH3wP
 +wcFbqwkmbusNdIpjjWEKlPj1spnU3oGr9ikByJUg5qKHDSwlCIaZAVqbIh0SD1DZvAami1P
 LUh0684MTf6HKs/+EPiy/7GqWpXihXw1wSawnPqmCqC91Vtd1+peXyMZCi7dx8PH/SSpnLmm
 jxtbMmn/qesxpTms+qEc+gksfu5F9mQ2RS1sazTCIf7eBgdNgq/beykXa8lZU9Ek9NjbG1pk
 Sq9hXgA/AUlaAFAXX80dvNkCYvVrgq8ucdfcbvESudBDr8Nt6eXeWOcwTYvJ2h7jetavqpZz
 rCu7SbL2tmVnj0uBgpkmdmOudU5OMw3M5f/y4PhnXGuwu4su43NRP7gyOVmItc36HEXSXwM8
 tMbiHV/Rv1FdNxqf7OfKOimlYp8Psu7Ntd62byxuvyLSie4EUNBj0StxaNHUQ1FCiG7si4jE
 2szWoRRUQDpPLe0PYfJQsCF7YXoEfrjUVRqqTGpDWovZ5SLlFx6TZpGSyYQBgJxfWXor/mcM
 i+nSfTUKFCFVNJObadpppgHVrT1HUGLy20dq3CLNwG8mAvYRMAUS51Q7ssIn/Rrd/ManSNa8
 eDzfxSWD5L3gdYfluJeaaT9gCz/v7Q2wt80+Bpz1shDzqC524YAGtXhLJ680z9z8wpJwfr8p
 KD+3AA7Z5P9Z/e3jzdAXm7j3AXiLDJLgoRFRzsFNBFOdSyUBEADHokxkZ4FwDIqyf1ZULG/b
 vwEvK4UWqP0QmUTSHBdd+bgPWFT4YvUurFftgZaYay1GJaOPjYTy6+oeYFwIrb8RqKhcAR9l
 4+U4MSlZniuxc1l8xVDUdX0zw6rP/L9wsDdW2lmnlNuOD7ZybwekeBp5N4on317r4TuetdFV
 IEDT+LrtJFl5FYU76Ru9l6g3M3HkLWFYocwsgyyAS7dZHXS4KXDZ96H9a9IVtxTh/XAJl/7x
 395A0Nvjp8+cYvYm+pravw8ByF1UJ4PfqIMkwV8YwvCt185kvQXrBBgooozk4ryuSFzGlTkA
 jtrhJxnIZfzIaahyCd1ju/zbxmIwY5nfZVnCX4+dM9t7ei5iUZ1Qxhkf6Tl8gRwoKrKjjEay
 x7S5ob5Du3tOeyFInuOEjxtIRYcplCSy1Qb3jcGDF5osXugVxaxfwOJi1hRu1ntFHy7J3ibX
 cfYuBaruzT8OP9DVLWCyS/D8JQJ7PiRkMiNiITDilzK0hZo2i6oA0R7WNnqypeaZq+avQpAt
 rVwkK1wZApfxwjmBSngM6VTGCzOefvE8PNCd55UmT9tkByZq5iknCWF7rbie1wD6s9x5bwLX
 uK0Es5UV4lBOa4aSyW5hhFe0OFwflrVpKYC56yopHyUFVhx4BA31MsVNNmb0JUfZJ+blDhsP
 +ll+P8BzqF13tQARAQABwsF2BBgBAgAgAhsMFiEEYK9084jvT0kxwI44Gv2a/BIMJt0FAlsi
 aocACgkQGv2a/BIMJt3rcw/+Ku0d1/IAz4l+3wy6inDz/0bNBO7V7tXPydVgZOe1LwbCwMuk
 SN+rq9qhgCAM+A/5lwdRcmIlfbGTy9AyFc19p8yiIgksR0t0i8gqbu4Xs+RrQcFmZurBXoFc
 s28gOZI2/t5Tj455dET2amLZ2aiTDaYBbqxZa9vfS5alfWsnvd4fjW4Kr1rEstTFdfubCX/N
 BYsSiXSzfGkLgOjuiLDBA3TYtaTTNPC3mx8wC9wq80aF2xiZoGeUW2ecrBohmksgdgkcqqGk
 iG0cRDZX5O+h1RJ2gZu90MXIThxJmi0ne1c+oGpZfRkNSteDK/mFeK7RJTb9XrBiZuWOIjf7
 dpMoQfGN4yjEqOvedFZeg6jE6wZiEzdCIwOJkf/uOtr2Ohd18hek4evdMzGzUVv4JzA/l8pg
 9tIHf7d/7Am0aAbSMXv+TECKxLHDoOI7KQL/flgTy1Vdw4q/WJB8yirhoSng5XgrB1A3W8Fo
 8m/G/Il9R5VGTPTMn4xe+UbMCBbLqoNfr5p3KWqSgqLQkP0YSt4G/Rcw5mJnbgGyw9UAM5wT
 PDT/BYzFQzmsk6467hsTjMBK3ka0VjKAJQ/AMfUgY9cLp4M/agkxDb0cKagvy0mf8argIgM0
 005cauU1nTb0v+L9S9sDcVvHOjRVDBR9mRzRpoxbGiAcBObVqtMByta0tuA=
In-Reply-To: <0ec1d936-ee3f-4df2-84df-51c15830091b@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------kFUVciyrMP9rVm5nmoFCeusz"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------kFUVciyrMP9rVm5nmoFCeusz
Content-Type: multipart/mixed; boundary="------------do8ZyUJLCfHz03kbNMNhYbZQ";
 protected-headers="v1"
From: Andrew Udvare <audvare@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, Christian Heusel <christian@heusel.eu>
Cc: regressions@lists.linux.dev, io-uring <io-uring@vger.kernel.org>
Message-ID: <5a1649cb-2711-4767-8313-0f6bfe0e4cd7@gmail.com>
Subject: Re: [REGRESSION] ETXTBSY when running Yarn (Node) since af5d68f
References: <313824bc-799d-414f-96b7-e6de57c7e21d@gmail.com>
 <8979ae0b-c443-4b45-8210-6394471dddd1@kernel.dk>
 <8de221f7-fe5a-4da9-899e-de2a856a4ddc@kernel.dk>
 <yywbp7fjnwgqxvc66zimea4hgdc2eysjx5nezky3vndr7xw25l@jv76rdseqm3e>
 <b8018270-6e9a-4888-87fd-69620d62c4e5@kernel.dk>
 <0ec1d936-ee3f-4df2-84df-51c15830091b@kernel.dk>
In-Reply-To: <0ec1d936-ee3f-4df2-84df-51c15830091b@kernel.dk>

--------------do8ZyUJLCfHz03kbNMNhYbZQ
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjEvMDUvMjAyNCAxNDoyOSwgSmVucyBBeGJvZSB3cm90ZToNCj4gT24gNS8yMS8yNCAx
MjoyNSBQTSwgSmVucyBBeGJvZSB3cm90ZToNCj4+IE91dHNpZGUgb2YgdGhhdCwgb25seSBv
dGhlciB0aGluZyBJIGNhbiB0aGluayBvZiBpcyB0aGF0IHRoZSBmaW5hbA0KPj4gY2xvc2Ug
d291bGQgYmUgcHVudGVkIHRvIHRhc2tfd29yayBieSBmcHV0KCksIHdoaWNoIG1lYW5zIHRo
ZXJlJ3MgYWxzbw0KPj4gYSBkZXBlbmRlbmN5IG9uIHRoZSB0YXNrIGhhdmluZyBydW4gaXRz
IGtlcm5lbCB0YXNrX3dvcmsgYmVmb3JlIGl0J3MNCj4+IGZ1bGx5IGNsb3NlZC4NCj4gDQo+
IFllcCBJIHRoaW5rIHRoYXQncyBpdCwgdGhlIGJlbG93IHNob3VsZCBmaXggaXQuDQo+IA0K
PiANCj4gZGlmZiAtLWdpdCBhL2lvX3VyaW5nL3NxcG9sbC5jIGIvaW9fdXJpbmcvc3Fwb2xs
LmMNCj4gaW5kZXggNTU0YzcyMTJhYTQ2Li42OGEzZTMyOTA0MTEgMTAwNjQ0DQo+IC0tLSBh
L2lvX3VyaW5nL3NxcG9sbC5jDQo+ICsrKyBiL2lvX3VyaW5nL3NxcG9sbC5jDQo+IEBAIC0y
NDEsNiArMjQxLDggQEAgc3RhdGljIHVuc2lnbmVkIGludCBpb19zcV90dyhzdHJ1Y3QgbGxp
c3Rfbm9kZSAqKnJldHJ5X2xpc3QsIGludCBtYXhfZW50cmllcykNCj4gICAJCQlyZXR1cm4g
Y291bnQ7DQo+ICAgCQltYXhfZW50cmllcyAtPSBjb3VudDsNCj4gICAJfQ0KPiArCWlmICh0
YXNrX3dvcmtfcGVuZGluZyhjdXJyZW50KSkNCj4gKwkJdGFza193b3JrX3J1bigpOw0KPiAg
IA0KPiAgIAkqcmV0cnlfbGlzdCA9IHRjdHhfdGFza193b3JrX3J1bih0Y3R4LCBtYXhfZW50
cmllcywgJmNvdW50KTsNCj4gICAJcmV0dXJuIGNvdW50Ow0KPiANCg0KVGhpcyBwYXRjaCB3
b3JrcyBmb3IgbWUgb24gNi45LjEuDQoNCiAgJCB5YXJuDQp5YXJuIGluc3RhbGwgdjEuMjIu
MjINCndhcm5pbmcgcGFja2FnZS5qc29uOiAidGVzdCIgaXMgYWxzbyB0aGUgbmFtZSBvZiBh
IG5vZGUgY29yZSBtb2R1bGUNCmluZm8gTm8gbG9ja2ZpbGUgZm91bmQuDQp3YXJuaW5nIHRl
c3RAMS4wLjA6ICJ0ZXN0IiBpcyBhbHNvIHRoZSBuYW1lIG9mIGEgbm9kZSBjb3JlIG1vZHVs
ZQ0KWzEvNF0gUmVzb2x2aW5nIHBhY2thZ2VzLi4uDQpbMi80XSBGZXRjaGluZyBwYWNrYWdl
cy4uLg0KWzMvNF0gTGlua2luZyBkZXBlbmRlbmNpZXMuLi4NCls0LzRdIEJ1aWxkaW5nIGZy
ZXNoIHBhY2thZ2VzLi4uDQpzdWNjZXNzIFNhdmVkIGxvY2tmaWxlLg0KRG9uZSBpbiAzLjMy
cy4NCg0KICAkIHVuYW1lIC1hDQpMaW51eCBsaW1lbGlnaHQgNi45LjEtZ2VudG9vLWxpbWVs
aWdodCAjMiBTTVAgUFJFRU1QVF9EWU5BTUlDIFRLRyBUdWUgDQpNYXkgMjEgMTU6MjE6MzMg
RURUIDIwMjQNCg0KLS0NCkFuZHJldw0K

--------------do8ZyUJLCfHz03kbNMNhYbZQ--

--------------kFUVciyrMP9rVm5nmoFCeusz
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEYK9084jvT0kxwI44Gv2a/BIMJt0FAmZM9k8FAwAAAAAACgkQGv2a/BIMJt2u
VA//Q3WlBnSoeYOvjzcltC8GufmfW32tLMEgxYGYPtTs5697dQYBFZpGjEFNWJS2Ob5GIjPY3Lx6
bblI6r2G+ntEZ6F/LWZ9zg7TFZlRk8QNgzpJbyJiTiy9bFZBwPNBNjRucNWxAXUPlfTTs61dskO6
tisjaffpI3gZpmBSj8VVXip7a519GgUUkMZtyGY7P5RVagnaERNCv23qniRAjujepdZAB1jWUrVY
4v9HrS2S7/wL/fPKeCNKnF2o32PuW+NJZ//8xisDP9/w2BYEdQi+WmCz0DojtofxqL+uxxrMW12Z
8zdODT5Ez2bxjf6ZTyvqRVgK3ul0oBNPjarFUOKEm+vaIj7L+70ecJIzmTFxVpp3OGCDJPxtRF9U
ASYqlcapXdD6L12FgF9WpQZmQH6fdJ2Js9JwDQmoncPdGd8Edutb7QCdhHqJcER+X3dE1J4eo5ZB
b/PkYzfdylSNa/W6/XYY185zuOVkUwe0LFGrSxyxeR3CVXJh7a7UNwbE0/h1WUHTjEiMT/9151w/
taFw2WOuRuA8wT5/uymTudMtZmvHOKZ50OLQyWW+FWtJ+gPez6brxQ77l2zi+/7OL9tTEJrXJ2Iy
uJRq2kL76MFpw0ETldv8CDKKb7v49+CQJitEWiN9BtH/viS5mQ+awKU7KicDWPhAYTdvYJHj7NWf
P/8=
=g5El
-----END PGP SIGNATURE-----

--------------kFUVciyrMP9rVm5nmoFCeusz--

