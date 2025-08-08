Return-Path: <io-uring+bounces-8899-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 37A92B1E4AA
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 10:49:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 03DBB1AA190A
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 08:49:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00FB9264638;
	Fri,  8 Aug 2025 08:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tXqaUEzE"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D0E1BC5C;
	Fri,  8 Aug 2025 08:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754642957; cv=none; b=LaQiL1+hG/G1go7mAx4CMLBK4LoXNdQufyDizS+akyvOxy99uKBIxtrCeD2fTueYX6E5CtxOHZ3euz6XA+bIrNocRu5HVzK4NXbFHrvJId8UrwCy31he/Eeu5n0WGnZiDFzp7fJOjRB/pdNFH/sBnybwPcv14mC33AMmctgiDtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754642957; c=relaxed/simple;
	bh=eLQfRVKg5seqR9xZt6I+jvxaFNgVZxZH7nAhxSwK5+k=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=cqGHJgZGkXl5IwXUlHJZYuRQObzJhHh3niuBG/SwI+b4E8chJdD6k8nbxcyuWYY6Pkk99aM0d/go3iIrNfZj7h0o2dtYTJlL/DfoQz1PDt+sGp5EJX5VWdQAysoZBTabkZz6H7tmU4kA4A6plDRSIpd61dpZ3HZPyUFZFjAoWSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tXqaUEzE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800F0C4CEED;
	Fri,  8 Aug 2025 08:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754642957;
	bh=eLQfRVKg5seqR9xZt6I+jvxaFNgVZxZH7nAhxSwK5+k=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=tXqaUEzEEoOW33P+l5GqaAIG/jRdBdurHU7hcVueCFOIPOnRZrQjJbmu8oj85R4Ju
	 0Nsy8mKv2UUMipDbNPfrrQTxL+fGAlXwJyXQYWG1eHIs0nYNZv/1L/OgsnYH/Xq8gX
	 iVBoWaVZ6NkQqfnDoxVosy3PMKOTRNIIj3yXmDro+O+ViQ8PNfRSRu6s/0qGxCrYKq
	 ko9J0Fuo7dyPJaM1KG3WZoC+ENljjU90zMPS6o2Aj1BE1Od6Zyer/YgenSFkLowu+h
	 +sZDx2fZwY2FqkCGqYPrlxu5Hum6lxsE1XqR/Z6ThAnyb0FmLoQk9Ge6EZLfVjrn3z
	 RWZEgnOJNNFYA==
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 08 Aug 2025 10:49:14 +0200
Message-Id: <DBWX0L4LIOF6.1AVJJV0SMDQ3P@kernel.org>
Subject: Re: [RFC PATCH v2 2/4] rust: io_uring: introduce rust abstraction
 for io-uring cmd
From: "Benno Lossin" <lossin@kernel.org>
To: "Sidong Yang" <sidong.yang@furiosa.ai>
Cc: "Daniel Almeida" <daniel.almeida@collabora.com>, "Caleb Sander Mateos"
 <csander@purestorage.com>, "Miguel Ojeda" <ojeda@kernel.org>, "Arnd
 Bergmann" <arnd@arndb.de>, "Jens Axboe" <axboe@kernel.dk>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>,
 <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <io-uring@vger.kernel.org>
X-Mailer: aerc 0.20.1
References: <20250727150329.27433-1-sidong.yang@furiosa.ai>
 <20250727150329.27433-3-sidong.yang@furiosa.ai>
 <D6CDE1A5-879F-49B1-9E10-2998D04B678F@collabora.com>
 <DBRVVTJ5LDV2.2NHTJ4S490N8@kernel.org>
 <949A27C5-1535-48D1-BE7E-F7E366A49A52@collabora.com>
 <DBVDWWHX8UY7.TG5OHXBZM2OX@kernel.org>
 <aJWfl87T3wehIviV@sidongui-MacBookPro.local>
In-Reply-To: <aJWfl87T3wehIviV@sidongui-MacBookPro.local>

On Fri Aug 8, 2025 at 8:56 AM CEST, Sidong Yang wrote:
> On Wed, Aug 06, 2025 at 03:38:24PM +0200, Benno Lossin wrote:
>> On Wed Aug 6, 2025 at 2:38 PM CEST, Daniel Almeida wrote:
>> > Hi Benno,
>> >
>> >> On 2 Aug 2025, at 07:52, Benno Lossin <lossin@kernel.org> wrote:
>> >>=20
>> >> On Fri Aug 1, 2025 at 3:48 PM CEST, Daniel Almeida wrote:
>> >>>> On 27 Jul 2025, at 12:03, Sidong Yang <sidong.yang@furiosa.ai> wrot=
e:
>> >>>> +    #[inline]
>> >>>> +    pub fn pdu(&mut self) -> &mut MaybeUninit<[u8; 32]> {
>> >>>=20
>> >>> Why MaybeUninit? Also, this is a question for others, but I don=C2=
=B4t think
>> >>> that `u8`s can ever be uninitialized as all byte values are valid fo=
r `u8`.
>> >>=20
>> >> `u8` can be uninitialized. Uninitialized doesn't just mean "can take =
any
>> >> bit pattern", but also "is known to the compiler as being
>> >> uninitialized". The docs of `MaybeUninit` explain it like this:
>> >>=20
>> >>    Moreover, uninitialized memory is special in that it does not have=
 a
>> >>    fixed value ("fixed" meaning "it won=C2=B4t change without being w=
ritten
>> >>    to"). Reading the same uninitialized byte multiple times can give
>> >>    different results.
>> >>=20
>> >> But the return type probably should be `&mut [MaybeUninit<u8>; 32]`
>> >> instead.
>> >
>> >
>> > Right, but I guess the question then is why would we ever need to use
>> > MaybeUninit here anyways.
>> >
>> > It's a reference to a C array. Just treat that as initialized.
>>=20
>> AFAIK C uninitialized memory also is considered uninitialized in Rust.
>> So if this array is not properly initialized on the C side, this would
>> be the correct type. If it is initialized, then just use `&mut [u8; 32]`=
.
>
> pdu field is memory chunk for driver can use it freely. The driver usuall=
y
> saves a private data and read or modify it on the other context. using
> just `&mut [u8;32]` would be simple and easy to use.

Private data is usually handled using `ForeignOwnable` in Rust. What
kind of data would be stored there? If it's a pointer, then `&mut [u8;
32]` would not be the correct choice.

---
Cheers,
Benno

