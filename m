Return-Path: <io-uring+bounces-8888-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D92CB1C60E
	for <lists+io-uring@lfdr.de>; Wed,  6 Aug 2025 14:39:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 06C75563882
	for <lists+io-uring@lfdr.de>; Wed,  6 Aug 2025 12:39:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB29C28B7FC;
	Wed,  6 Aug 2025 12:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=daniel.almeida@collabora.com header.b="LiNE6aQT"
X-Original-To: io-uring@vger.kernel.org
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197D1274FFE;
	Wed,  6 Aug 2025 12:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754483938; cv=pass; b=OErruVie09mVe+uKFKlNMJMxrHkwaNaDEydPE9acbPPsOdtACm6rP1t/O32BVIblW6az+Xuogxgtm25aj7uNxYFFCo+6tKPTOBtLc0INy6KmANk6Le8wwvr1pC1uZJ17ESgewAOEm0SR/Qiced4Ms+Qdmgz6eivCOcULCdOldPQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754483938; c=relaxed/simple;
	bh=ul4jt73laQuUUeS57wBdx0u9qiIGtkm72JDJIULLJ5o=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=r1fmBfyEJ3tfuJikEM9gaEv0IC8UDSSs6Y+jPs2opmY1jrsqw8yCQ5MOfjr3KAMBXkitC+UUDayLYWXvciRVrPqDSTgLtxOSGG0jvKZlqrl+sChJH65ietTufwfbo5Ljb/12jTJbpJ5WUzamfFBCVZm6Pj4KLlk4Q2ES4iJQXrs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=daniel.almeida@collabora.com header.b=LiNE6aQT; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
ARC-Seal: i=1; a=rsa-sha256; t=1754483923; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Ygvyy5nOVvE+lE9Gom1RsNmzjqUlaxHap58D8rp81Dbs7QMSZ8PJDJb9mckH8Xq7riuw+eaUWrHwIT24z8pOHs+C8NiHE7goCtF9aNKEWhi7q8V7QAsqIRPqqXB3z7GPr5HfHqadfq1rzHNvBosxl5gPEXBuLnPvDXtIBriWBn0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1754483923; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=o2qE/1romGU48U4T9i8557cOr/JyU6sS9Hngmv6iYfE=; 
	b=KgkjNG/m0oAPX/wmuaPwAhLxf8xiEnMmsFIwR/xYE9B8/jlfKXco1jfykG6pNC/G7FDquicca2mC0R2Xx8oGf3uFC4KL4XDI330ibL9EzIroycsR28WYyiYqHwuB+MN0ytEdb/eW7vWdC75tyqLFuZ++gg8qO0IdXGlk34VrfFY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1754483923;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:References:To:To:Reply-To;
	bh=o2qE/1romGU48U4T9i8557cOr/JyU6sS9Hngmv6iYfE=;
	b=LiNE6aQTVfiw6tWqjJ4e+l5oKkQ2u8rE7LiRqM+83Ux+KNJe79EIEUk6SY3S3IUh
	0adGcefu1t9GstHHFblk+ey5f0QO4a/GqM5JodRSAKNKPKm24DJFeI/cV1dq0M46SNB
	N7PEh2oSELyqc6vjjxkQ5sB5h6Wj+n3EzDLOXg7A=
Received: by mx.zohomail.com with SMTPS id 1754483919865747.4839862466861;
	Wed, 6 Aug 2025 05:38:39 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: [RFC PATCH v2 2/4] rust: io_uring: introduce rust abstraction for
 io-uring cmd
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <DBRVVTJ5LDV2.2NHTJ4S490N8@kernel.org>
Date: Wed, 6 Aug 2025 09:38:25 -0300
Cc: Sidong Yang <sidong.yang@furiosa.ai>,
 Caleb Sander Mateos <csander@purestorage.com>,
 Miguel Ojeda <ojeda@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>,
 Jens Axboe <axboe@kernel.dk>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <949A27C5-1535-48D1-BE7E-F7E366A49A52@collabora.com>
References: <20250727150329.27433-1-sidong.yang@furiosa.ai>
 <20250727150329.27433-3-sidong.yang@furiosa.ai>
 <D6CDE1A5-879F-49B1-9E10-2998D04B678F@collabora.com>
 <DBRVVTJ5LDV2.2NHTJ4S490N8@kernel.org>
To: Benno Lossin <lossin@kernel.org>
X-Mailer: Apple Mail (2.3826.600.51.1.1)
X-ZohoMailClient: External

Hi Benno,

> On 2 Aug 2025, at 07:52, Benno Lossin <lossin@kernel.org> wrote:
>=20
> On Fri Aug 1, 2025 at 3:48 PM CEST, Daniel Almeida wrote:
>>> On 27 Jul 2025, at 12:03, Sidong Yang <sidong.yang@furiosa.ai> =
wrote:
>>> +    #[inline]
>>> +    pub fn pdu(&mut self) -> &mut MaybeUninit<[u8; 32]> {
>>=20
>> Why MaybeUninit? Also, this is a question for others, but I don=E2=80=99=
t think
>> that `u8`s can ever be uninitialized as all byte values are valid for =
`u8`.
>=20
> `u8` can be uninitialized. Uninitialized doesn't just mean "can take =
any
> bit pattern", but also "is known to the compiler as being
> uninitialized". The docs of `MaybeUninit` explain it like this:
>=20
>    Moreover, uninitialized memory is special in that it does not have =
a
>    fixed value (=E2=80=9Cfixed=E2=80=9D meaning =E2=80=9Cit won=E2=80=99=
t change without being written
>    to=E2=80=9D). Reading the same uninitialized byte multiple times =
can give
>    different results.
>=20
> But the return type probably should be `&mut [MaybeUninit<u8>; 32]`
> instead.


Right, but I guess the question then is why would we ever need to use
MaybeUninit here anyways.

It's a reference to a C array. Just treat that as initialized.

=E2=80=94 Daniel=

