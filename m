Return-Path: <io-uring+bounces-1949-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A3C8D8CB449
	for <lists+io-uring@lfdr.de>; Tue, 21 May 2024 21:33:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5402A28515F
	for <lists+io-uring@lfdr.de>; Tue, 21 May 2024 19:33:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5157F433AD;
	Tue, 21 May 2024 19:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MedNJcFp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB6C1DFE8
	for <io-uring@vger.kernel.org>; Tue, 21 May 2024 19:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716320031; cv=none; b=CHLEB/alh+GDxtBHF2SPPCbPfe2AwUGpURgSJDbqH3hLfIuWdIFdORF7Ismzx2PvPlQeIvdz9PYX7kX0rVdIcaNZnABunLS652npxP8J/CTY4oefeNVWNC0MNGUg2MtW7ETY1nAQy805IU2kghRRsPobQOgOZ+EFwT0X4K5k0LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716320031; c=relaxed/simple;
	bh=caXYC9K7SfKrMTNZjtG+6BKzSRj5Du7Cv1BEofe9FWM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a7x5xJhrFDH6RmwAuVGxx72QA2xA005NKwNb4VPFuhRNAW6QlnrG5lQ1Flmd1ARw3qqNjNEclNLoGcTFL9QKaOlT4jMHc1G4s1F+1S5V/g9dQ+I/K/YL7TUx4E2/niH1PBs9KEKdeiOI4vUPCX26eQRQiru79OK0cK1lyEdt3iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MedNJcFp; arc=none smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-4df2fcafc19so19431e0c.0
        for <io-uring@vger.kernel.org>; Tue, 21 May 2024 12:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716320028; x=1716924828; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=caXYC9K7SfKrMTNZjtG+6BKzSRj5Du7Cv1BEofe9FWM=;
        b=MedNJcFpAaJAzmDdUGHk4jxziwphK85iiyr4SpPYFqSyWNTiNTUFj3s+DHrmBJTFmH
         vTtVvcJMt7ffB1BaMj2J/2jo5sP6FxWogcIR7jg1zmX6grdUPwI2asQ9o335MGNrFO9l
         LsAqHdN4l/G+P8HE6xN7xCwluXtfsJCXHmb+NVCJ17qnyMqpzhPNO0/JVG4TzhnMxPX2
         F0XBAFd+YIwnq+/hnyLRIfScljWxKbBS/DX1iUQRXxos/XRh5nPq/pcyp040u+JDeNpA
         KOWcmn9ZhZDndd3No3pmGqk7E9R5qTI3FjmJqGDeRyL/lxlBnZ9vr9ON5V6uWvBzwWNy
         gX7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716320028; x=1716924828;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=caXYC9K7SfKrMTNZjtG+6BKzSRj5Du7Cv1BEofe9FWM=;
        b=sQ2T3Sb83xog49UtoB7+RD12BVFF3OOXBKdH/2MSJZfFHieteY4yzCtun9Nfkttxic
         OVbPikTYvWWA7e9kQmYxnMOE7cQvGHIBzpyDr0TyTq3d3yAbmTlHrDGmBZv9yj566ixd
         lh5AHveYAtKSv25vCVqJA8PG0s2oqCnQWJRBDOTysCY3aWCbUKplZJpvcS1XVHulK32w
         JAQr+NRPP8saxHnGsbd7dW6uDHZpGlCKGH8zBNB+I8M9o3irfSqsT2I4XabVQWe9jpFz
         SSEJWLiqV33Lc9gyiQnlqQSs2AZ1sv+bpmIImJJIABeiM+W3VyrBpG9SHZNZ4Cx/LOe9
         qW5Q==
X-Forwarded-Encrypted: i=1; AJvYcCUOk8rNjeZJwuZ+t7NK/nXCkJ8ETF979lXPmLWAtsTLLqF0/UxnLqw/tIjsa/TMflbTbuGqMRzGeb1Tq1f042IGF+LLaAqat4s=
X-Gm-Message-State: AOJu0Yx5C9mudHbk2trojwLuopE00xnAeNA5Ox0OaSw/aqpbEkH574+R
	Ki+ByMCdMlpzDCyolIWc1H1MG0JOxyEAuGfTjzF544BW8EXqvWn3
X-Google-Smtp-Source: AGHT+IETQWstsM4NahxYMRA587IbBzwrTWN4Cud9qo7baR6TXAjAXk9CAMKICsfqAu3nM6QJ8PVJFA==
X-Received: by 2002:a05:6122:3128:b0:4db:1b9d:c70a with SMTP id 71dfb90a1353d-4df88180aefmr34105249e0c.0.1716320028422;
        Tue, 21 May 2024 12:33:48 -0700 (PDT)
Received: from [192.168.1.101] (syn-142-197-127-150.res.spectrum.com. [142.197.127.150])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-4df7bf9ddeasm3365487e0c.27.2024.05.21.12.33.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 May 2024 12:33:47 -0700 (PDT)
Message-ID: <bcf1e758-66de-47fd-8cfe-ce77c545a8bc@gmail.com>
Date: Tue, 21 May 2024 15:33:47 -0400
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
 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
In-Reply-To: <0ec1d936-ee3f-4df2-84df-51c15830091b@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------jANbLvAsASxuFtCC7tX4mIeP"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------jANbLvAsASxuFtCC7tX4mIeP
Content-Type: multipart/mixed; boundary="------------obbp0xnQO9eAsoWeHDHQBnIR";
 protected-headers="v1"
From: Andrew Udvare <audvare@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, Christian Heusel <christian@heusel.eu>
Cc: regressions@lists.linux.dev, io-uring <io-uring@vger.kernel.org>
Message-ID: <bcf1e758-66de-47fd-8cfe-ce77c545a8bc@gmail.com>
Subject: Re: [REGRESSION] ETXTBSY when running Yarn (Node) since af5d68f
References: <313824bc-799d-414f-96b7-e6de57c7e21d@gmail.com>
 <8979ae0b-c443-4b45-8210-6394471dddd1@kernel.dk>
 <8de221f7-fe5a-4da9-899e-de2a856a4ddc@kernel.dk>
 <yywbp7fjnwgqxvc66zimea4hgdc2eysjx5nezky3vndr7xw25l@jv76rdseqm3e>
 <b8018270-6e9a-4888-87fd-69620d62c4e5@kernel.dk>
 <0ec1d936-ee3f-4df2-84df-51c15830091b@kernel.dk>
In-Reply-To: <0ec1d936-ee3f-4df2-84df-51c15830091b@kernel.dk>

--------------obbp0xnQO9eAsoWeHDHQBnIR
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjEvMDUvMjAyNCAxNDoyOSwgSmVucyBBeGJvZSB3cm90ZToNCj4gT24gNS8yMS8yNCAx
MjoyNSBQTSwgSmVucyBBeGJvZSB3cm90ZToNCj4+IE91dHNpZGUgb2YgdGhhdCwgb25seSBv
dGhlciB0aGluZyBJIGNhbiB0aGluayBvZiBpcyB0aGF0IHRoZSBmaW5hbA0KPj4gY2xvc2Ug
d291bGQgYmUgcHVudGVkIHRvIHRhc2tfd29yayBieSBmcHV0KCksIHdoaWNoIG1lYW5zIHRo
ZXJlJ3MgYWxzbw0KPj4gYSBkZXBlbmRlbmN5IG9uIHRoZSB0YXNrIGhhdmluZyBydW4gaXRz
IGtlcm5lbCB0YXNrX3dvcmsgYmVmb3JlIGl0J3MNCj4+IGZ1bGx5IGNsb3NlZC4NCj4gDQo+
IFllcCBJIHRoaW5rIHRoYXQncyBpdCwgdGhlIGJlbG93IHNob3VsZCBmaXggaXQuDQoNClRl
c3RlZC1ieTogQW5kcmV3IFVkdmFyZSA8YXVkdmFyZUBnbWFpbC5jb20+DQo=

--------------obbp0xnQO9eAsoWeHDHQBnIR--

--------------jANbLvAsASxuFtCC7tX4mIeP
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEYK9084jvT0kxwI44Gv2a/BIMJt0FAmZM9xsFAwAAAAAACgkQGv2a/BIMJt1C
vg//ebODUzu+HfFk/EUw9RXkyb1D2YihCNlgD8pSzUiuSCqLaQ7+W0lz12kfwiXTwSfriVzrShLn
EPKyebTATmLzOOknFgiiP7s79u6w1rbkybRlpNxsLuHg6fgFukQjZeFVySTbQPktXgHiuThb3w9e
ktU0xbvPoFCSj4BnlU5qACu6louu2HNxz/3jDkQTEM2WqgijnzrEr295CuvS9paHuLP1r9ceT1/d
O5einBPj3cnmCCsf7B2qgvId/YL/A/8kAJb9A43rCyHf+EWQfsfYPe+glNJXR2hxzEv3YS9PvVOO
JX3QoJRjpv9pwnwRi7db/+6bORpQoBf6c8XGea0b5gXXsKITWKAAFIJP8f2tE5SZy69fkbaZJJTl
0YuR7KTeoaVlHKYaMki5pD2ej2LEuakZF/S0DWpbgy/Io0d+TFPFVhDE1DxTBZAtsSAAfUUjrOpw
BJv2SO24VsGCgYX/yS5O2rP+ld7UtygXFz8hre0VXMpUsVofwoj4nJrkOvpb09ttcVTW/Q44lNit
iOK1gX2/8Kv2nuQv8M0vVvf4kolGmBKVub3gp5l4ZpcRgoUwlNQ5KaKAHw06SR2EdRv+HOrfF5nV
FRa1JZ3T6MLNTD7biifJ//WhRjUYRQAAWpX6wzKvBohUUTArpmOBm2uJf0G+djv7fVckyFMC0hTP
650=
=QqaA
-----END PGP SIGNATURE-----

--------------jANbLvAsASxuFtCC7tX4mIeP--

