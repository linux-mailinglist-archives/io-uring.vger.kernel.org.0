Return-Path: <io-uring+bounces-9477-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 989ECB3C062
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 18:12:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A52C3BB398
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 16:12:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB97C321F23;
	Fri, 29 Aug 2025 16:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=daniel.almeida@collabora.com header.b="TiLt8z/J"
X-Original-To: io-uring@vger.kernel.org
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35173043B7;
	Fri, 29 Aug 2025 16:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756483928; cv=pass; b=jRJKWdasuVBMjf+ei9qe+lQQiG4PJ0heFK1Uf1LdojJwTvwHDdw9YzN0YKFsh/7lf6gvl/8P7EyNhV9hRaETIqjbW9J2JrWvL5PbBbjO2KbMLlJXRbgxty3bPTTeNjUTcqBFCBKynqjdaZfUQfNrQgU7stk6gHVPLd88xb33Zck=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756483928; c=relaxed/simple;
	bh=sNZzeBv7GmmAKJ+KJKP+vXL/ceDc5cVah5m6u5INbt0=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=l2DWqBX0jdx9k0hqidbDlifdJrg+JX1DQrl5hVumdCeRY0wsK9mMM9iw7B6NNU2wBUa+Ml3FVsapdOrXdbwBWjjukSgqsXURTert9dkB1WYX8WKaxrrborp3yYGE1iehWo5Ksl8vHnt6Fjz/B4btrsxKnQT4uASmlk5iNu6x9Qs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=daniel.almeida@collabora.com header.b=TiLt8z/J; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
ARC-Seal: i=1; a=rsa-sha256; t=1756483913; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=lJQ1bBNnbt7CJ00Qvccdp6zMxQmHrocNAGyyA8i6q/29mELnGoiJCf6YZjW4imOtIf+zUEsxvU8QQr9eIajgyMWxUYbZFPg+Z3tJmfiFEDNmXg0tX7eVwNvjt9095D69x9/LAq4Im48w/kz3Ts/6Cwz+rVIfiLVFxHHw0IpKfnI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1756483913; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=XZngc+3mvJ49Q5Ax2kQP9dlPZisbvVLik+5WLuCV0y8=; 
	b=SW5d0DbNMRIun8qkfqyz3BobSQTb3ZfEBZdqZVNNtIBYDc/+2QrWECXCN7jk3md4zHz20FnLHpC3Jl4TqlpGyWMPSbZEDT2V8HjYXdi3Nm1H0Pwofg7CYY/cBR0LOD0O/iau7EYmlorvjuPXYbWLsuh6gw8TkYeDdekNwFlW7kg=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1756483913;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:References:To:To:Reply-To;
	bh=XZngc+3mvJ49Q5Ax2kQP9dlPZisbvVLik+5WLuCV0y8=;
	b=TiLt8z/JfeB5N2MfzNDd4uYlfXo9pezYiw7J8lME8up6WYQE2ewoPLyaUHR9MYj6
	q/q5bDUR9D9p8Q8QsK7LTnlacJlzZYR47MtJ4ZyvFOa6mKSJ4Kh8LAlm6nGjQoSdPCK
	Wjpb94nhZt95flvrKMLxq/O+R17rOyb6B/XkU6uM=
Received: by mx.zohomail.com with SMTPS id 1756483911261511.1260565301486;
	Fri, 29 Aug 2025 09:11:51 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [RFC PATCH v3 3/5] rust: io_uring: introduce rust abstraction for
 io-uring cmd
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <aLHKvjBZYJk2Ci34@sidongui-MacBookPro.local>
Date: Fri, 29 Aug 2025 13:11:35 -0300
Cc: Jens Axboe <axboe@kernel.dk>,
 Caleb Sander Mateos <csander@purestorage.com>,
 Benno Lossin <lossin@kernel.org>,
 Miguel Ojeda <ojeda@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <B0A69ADA-8186-4BCF-9C8C-F49F1D49D603@collabora.com>
References: <20250822125555.8620-1-sidong.yang@furiosa.ai>
 <20250822125555.8620-4-sidong.yang@furiosa.ai>
 <713667D6-8001-408D-819D-E9326FC3AFD5@collabora.com>
 <aLHKvjBZYJk2Ci34@sidongui-MacBookPro.local>
To: Sidong Yang <sidong.yang@furiosa.ai>
X-Mailer: Apple Mail (2.3826.700.81)
X-ZohoMailClient: External

[=E2=80=A6]

>>=20
>>> +    #[inline]
>>> +    pub unsafe fn from_raw<'a>(ptr: *const bindings::io_uring_sqe) =
-> &'a IoUringSqe {
>>=20
>> Private or pub(crate) at best.
>=20
> Okay. pub(crate)

Try to make things private and reach for pub(crate) here only when =
it=E2=80=99s actually needed.

=E2=80=94 Daniel



