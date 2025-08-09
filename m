Return-Path: <io-uring+bounces-8920-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4817BB1F411
	for <lists+io-uring@lfdr.de>; Sat,  9 Aug 2025 12:18:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0AE1B1C218E2
	for <lists+io-uring@lfdr.de>; Sat,  9 Aug 2025 10:19:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A471324679F;
	Sat,  9 Aug 2025 10:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IxYjeXqP"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E8723B62C;
	Sat,  9 Aug 2025 10:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754734733; cv=none; b=fFW5XFCOSjm08wsoJmHXynVop0XTrWXv4HJKtr6UeJMURkGtD7OQqbD7liJGaJsk4j04LQS9uDaBpIPLo1h7dTAAaYYIB5W+saAadvjSAcI9niGgC2XnVAnB88Q7x+Db0+7NHEPyjEbWhsXwEPPguXwkYzLYnAFWhUT1mlY+TjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754734733; c=relaxed/simple;
	bh=3kTYfvX/cig3L/pY8sJWJIZAQ0MeL7eM9NiGFkbQpNA=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=AjxE2Fd6JBsF6qaOCsQQg0lA2OR+4JD9Y/oQ5u8sp+4BdfG4ZImbQx7CTRGHJT29fMVZuYBeZHS5DNv7CjHFnWdD5HJegeeF/Vsbq9+1gWd14fAJvBnJDG7Pv55wFI09T9w0FkzyUodaEMWTXvFFZxZzxzvh6fARwT/2t2rXPR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IxYjeXqP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04663C4CEE7;
	Sat,  9 Aug 2025 10:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754734732;
	bh=3kTYfvX/cig3L/pY8sJWJIZAQ0MeL7eM9NiGFkbQpNA=;
	h=Date:To:Cc:Subject:From:References:In-Reply-To:From;
	b=IxYjeXqPHlUJa37Wqz4UdSMV/G8qNNw/rwrlElk1s6w9Rt2eB+ZUV+Vwav6ZbKYja
	 WDSz6yWM5D+5WIpRRYNXtHLuR+xXu8YTIchJ118qn/PLNwYw1VFzNtGwz2roFmJKj2
	 Nefdjgo0cOBB+7uQq/LKuLb7r7TlCfOBDthWlXgUuVo9nWI2jeJ9NGgW4ZAu+dekbc
	 kNIVfM9SEGKSP9Ez9iSlXIph/9TuySRahsnFRl63qxPmXW3UxtrNpnxlucXirF40uL
	 vbsvep2Fe8dRvfJFaRo1crge5nM62Q4VFHxMMXX0JOJIqOQnnCtdtl7iX7dKZt6DsL
	 YzSu+7NnhXhsg==
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 09 Aug 2025 12:18:49 +0200
Message-Id: <DBXTJQ27RY6K.1R6KUNEXF008N@kernel.org>
To: "Sidong Yang" <sidong.yang@furiosa.ai>
Cc: "Daniel Almeida" <daniel.almeida@collabora.com>, "Caleb Sander Mateos"
 <csander@purestorage.com>, "Miguel Ojeda" <ojeda@kernel.org>, "Arnd
 Bergmann" <arnd@arndb.de>, "Jens Axboe" <axboe@kernel.dk>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>,
 <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <io-uring@vger.kernel.org>
Subject: Re: [RFC PATCH v2 2/4] rust: io_uring: introduce rust abstraction
 for io-uring cmd
From: "Benno Lossin" <lossin@kernel.org>
X-Mailer: aerc 0.20.1
References: <20250727150329.27433-1-sidong.yang@furiosa.ai>
 <20250727150329.27433-3-sidong.yang@furiosa.ai>
 <D6CDE1A5-879F-49B1-9E10-2998D04B678F@collabora.com>
 <DBRVVTJ5LDV2.2NHTJ4S490N8@kernel.org>
 <949A27C5-1535-48D1-BE7E-F7E366A49A52@collabora.com>
 <DBVDWWHX8UY7.TG5OHXBZM2OX@kernel.org>
 <aJWfl87T3wehIviV@sidongui-MacBookPro.local>
 <DBWX0L4LIOF6.1AVJJV0SMDQ3P@kernel.org>
 <aJXG3wPf9W3usEj2@sidongui-MacBookPro.local>
In-Reply-To: <aJXG3wPf9W3usEj2@sidongui-MacBookPro.local>

On Fri Aug 8, 2025 at 11:43 AM CEST, Sidong Yang wrote:
> On Fri, Aug 08, 2025 at 10:49:14AM +0200, Benno Lossin wrote:
>> On Fri Aug 8, 2025 at 8:56 AM CEST, Sidong Yang wrote:
>> > On Wed, Aug 06, 2025 at 03:38:24PM +0200, Benno Lossin wrote:
>> >> On Wed Aug 6, 2025 at 2:38 PM CEST, Daniel Almeida wrote:
>> >> > Hi Benno,
>> >> >
>> >> >> On 2 Aug 2025, at 07:52, Benno Lossin <lossin@kernel.org> wrote:
>> >> >>=20
>> >> >> On Fri Aug 1, 2025 at 3:48 PM CEST, Daniel Almeida wrote:
>> >> >>>> On 27 Jul 2025, at 12:03, Sidong Yang <sidong.yang@furiosa.ai> w=
rote:
>> >> >>>> +    #[inline]
>> >> >>>> +    pub fn pdu(&mut self) -> &mut MaybeUninit<[u8; 32]> {
>> >> >>>=20
>> >> >>> Why MaybeUninit? Also, this is a question for others, but I don=
=C2=B4t think
>> >> >>> that `u8`s can ever be uninitialized as all byte values are valid=
 for `u8`.
>> >> >>=20
>> >> >> `u8` can be uninitialized. Uninitialized doesn't just mean "can ta=
ke any
>> >> >> bit pattern", but also "is known to the compiler as being
>> >> >> uninitialized". The docs of `MaybeUninit` explain it like this:
>> >> >>=20
>> >> >>    Moreover, uninitialized memory is special in that it does not h=
ave a
>> >> >>    fixed value ("fixed" meaning "it won=C2=B4t change without bein=
g written
>> >> >>    to"). Reading the same uninitialized byte multiple times can gi=
ve
>> >> >>    different results.
>> >> >>=20
>> >> >> But the return type probably should be `&mut [MaybeUninit<u8>; 32]=
`
>> >> >> instead.
>> >> >
>> >> >
>> >> > Right, but I guess the question then is why would we ever need to u=
se
>> >> > MaybeUninit here anyways.
>> >> >
>> >> > It's a reference to a C array. Just treat that as initialized.
>> >>=20
>> >> AFAIK C uninitialized memory also is considered uninitialized in Rust=
.
>> >> So if this array is not properly initialized on the C side, this woul=
d
>> >> be the correct type. If it is initialized, then just use `&mut [u8; 3=
2]`.
>> >
>> > pdu field is memory chunk for driver can use it freely. The driver usu=
ally
>> > saves a private data and read or modify it on the other context. using
>> > just `&mut [u8;32]` would be simple and easy to use.
>>=20
>> Private data is usually handled using `ForeignOwnable` in Rust. What
>> kind of data would be stored there? If it's a pointer, then `&mut [u8;
>> 32]` would not be the correct choice.
>
> Most driver uses `io_uring_cmd_to_pdu` macro that casts address of pdu to
> private data type. It seems that all driver use this macro has it's own
> struct type. How about make 2 function for pdu? like store_pdu(), borrow_=
pdu().

We'd need to ensure that `borrow_pdu` can only be called if `store_pdu`
has been called before. Is there any way we can just ensure that pdu is
always initialized? Like a callback that's called once, before the value
is used at all?

---
Cheers,
Benno

