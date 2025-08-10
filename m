Return-Path: <io-uring+bounces-8928-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0077EB1FA6A
	for <lists+io-uring@lfdr.de>; Sun, 10 Aug 2025 16:27:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E6B731891C9D
	for <lists+io-uring@lfdr.de>; Sun, 10 Aug 2025 14:28:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 951B72652B2;
	Sun, 10 Aug 2025 14:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=daniel.almeida@collabora.com header.b="TLZZp0+U"
X-Original-To: io-uring@vger.kernel.org
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703245680;
	Sun, 10 Aug 2025 14:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754836064; cv=pass; b=vF7E3cWnQrVN2hhpf9NkFoGsASoI9Z9KwNi0SKNrnMGw0UnrMZ+PCtcnOcRWXLSoECDu7nktaK2DJVVSakMMDTymekswzTYOjp1qxI8sFD+gitUghJ5CUPXS7ErWWSJdbRveonz7laGyyS5WlGgG4c5imShdrVHZi4gDMrp2W64=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754836064; c=relaxed/simple;
	bh=WpT0ERGZuimm9kof3GOrtSeUJgPOdfbsqkFcm5wNXyQ=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=H0Lk5mN6p+1msXqJ45xVoBqkOKLwx7R0jW8RrRBNUsEHnFaRFmG1xmPYbNEWgAYGRZDDTBInqk3mZPse3PUFI0tl0fso0Kwpf/p5GtJ26kSJMK42nVx3gu9v5hhmk4UC7Lkw8mS/rayZNt71SXRT11+Fnxf4GDckqjYHvB/Rst4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=daniel.almeida@collabora.com header.b=TLZZp0+U; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
ARC-Seal: i=1; a=rsa-sha256; t=1754836050; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=TPWtnrfma/Y1NgYLl6KHrx6dCUkcoGi+woO3F4RPHb89+tw5bTEXUvVYrWCKObb1oyIgms0gRy5ENnvcLQJQG1+EmJN5QnlsDP7H+jiOZFnJ3dc8iTTT6XhVWzpZO7B9Od50sMDnZ04Ckg5HykdcVyVBkT7L+ZGQDJHiVDXzPVM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1754836050; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=WpT0ERGZuimm9kof3GOrtSeUJgPOdfbsqkFcm5wNXyQ=; 
	b=Ri1/j8l8UicO33qQsXZvLh0GhhKHg4/+6IFy0Xa5iFoXxE3lEbPTo3cr/VcqIpg3kLWyCyOgi0LVQwZmGiGCQF0TD2qxJQHC0jHbRf5kDqn2DLbruWIguWet88A57XQ61GzIMoyq89vaei4UTuiEg5/+RtoUUOn6eLxaCb6/xl8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1754836049;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:References:To:To:Reply-To;
	bh=WpT0ERGZuimm9kof3GOrtSeUJgPOdfbsqkFcm5wNXyQ=;
	b=TLZZp0+US7vkD8wR+prPw328wYvXKCdBmDVkadSNpZSAbA4sV/yT4Qt+Lr0HtsHZ
	8GJ/W5cdAYv7l8s+XbAjdtrXbLKJUf4Ou2egG+2/TU6d5T1T7eK9CWE+8vSOsK9HYvC
	QqdHBx7iRoAyBARFb5/b1LR35PcDyFrtmaUF5Us0=
Received: by mx.zohomail.com with SMTPS id 1754836047578846.437942645183;
	Sun, 10 Aug 2025 07:27:27 -0700 (PDT)
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
In-Reply-To: <aJijj4kiMV9yxOrM@sidongui-MacBookPro.local>
Date: Sun, 10 Aug 2025 11:27:12 -0300
Cc: Benno Lossin <lossin@kernel.org>,
 Caleb Sander Mateos <csander@purestorage.com>,
 Miguel Ojeda <ojeda@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>,
 Jens Axboe <axboe@kernel.dk>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <81C84BD8-D99C-4103-A280-CFC71DF58E3B@collabora.com>
References: <D6CDE1A5-879F-49B1-9E10-2998D04B678F@collabora.com>
 <DBRVVTJ5LDV2.2NHTJ4S490N8@kernel.org>
 <949A27C5-1535-48D1-BE7E-F7E366A49A52@collabora.com>
 <DBVDWWHX8UY7.TG5OHXBZM2OX@kernel.org>
 <aJWfl87T3wehIviV@sidongui-MacBookPro.local>
 <DBWX0L4LIOF6.1AVJJV0SMDQ3P@kernel.org>
 <aJXG3wPf9W3usEj2@sidongui-MacBookPro.local>
 <DBXTJQ27RY6K.1R6KUNEXF008N@kernel.org>
 <aJdEbFI2FqSCBt9L@sidongui-MacBookPro.local>
 <DBY6DMQYZ2CL.2P0LZO2HF13MJ@kernel.org>
 <aJijj4kiMV9yxOrM@sidongui-MacBookPro.local>
To: Sidong Yang <sidong.yang@furiosa.ai>
X-Mailer: Apple Mail (2.3826.600.51.1.1)
X-ZohoMailClient: External



> On 10 Aug 2025, at 10:50, Sidong Yang <sidong.yang@furiosa.ai> wrote:
>=20
> On Sat, Aug 09, 2025 at 10:22:06PM +0200, Benno Lossin wrote:
>> On Sat Aug 9, 2025 at 2:51 PM CEST, Sidong Yang wrote:
>>> On Sat, Aug 09, 2025 at 12:18:49PM +0200, Benno Lossin wrote:
>>>> We'd need to ensure that `borrow_pdu` can only be called if =
`store_pdu`
>>>> has been called before. Is there any way we can just ensure that =
pdu is
>>>> always initialized? Like a callback that's called once, before the =
value
>>>> is used at all?
>>>=20
>>> I've thought about this. As Celab said, returning `&mut =
MaybeUninit<[u8;32]> is
>>> simple and best. Only driver knows it's initialized. There is no way =
to
>>> check whether it's initialized with reading the pdu. The best way is =
to return
>>> `&mut MaybeUninit<[u8;32]>` and driver initializes it in first time. =
After=20
>>> init, driver knows it's guranteed that it's initialized so it could =
call=20
>>> `assume_init_mut()`. And casting to other struct is another problem. =
The driver
>>> is responsible for determining how to interpret the PDU, whether by =
using it
>>> directly as a byte array or by performing an unsafe cast to another =
struct.
>>=20
>> But then drivers will have to use `unsafe` & possibly cast the slice =
to
>> a struct? I think that's bad design since we try to avoid unsafe code =
in
>> drivers as much as possible. Couldn't we try to ensure from the
>> abstraction side that any time you create such an object, the driver
>> needs to provide the pdu data? Or we could make it implement =
`Default`
>> and then set it to that before handing it to the driver.
>=20
> pdu data is [u8; 32] memory space that driver can borrow. this has two =
kind of
> issues. The one is that the array is not initialized and another one =
is it's
> array type that driver should cast it to private data structure =
unsafely.
> The first one could be resolved with returning `&mut MaybeUninit<>`. =
And the
> second one, casting issue, is remaining.=20
>=20
> It seems that we need new unsafe trait like below:
>=20
> /// Pdu should be... repr C or transparent, sizeof <=3D 20
> unsafe trait Pdu: Sized {}
>=20
> /// Returning to casted Pdu type T
> pub fn pdu<T: Pdu>(&mut self) -> &mut MaybeUninit<T>

Wait, you receive an uninitialized array, and you=E2=80=99re supposed to =
cast it to
T, is that correct? Because that does not fit the signature above.

>=20
> I think it is like bytemuck::Pod trait. Pod meaning plain old data.
>=20
> Thanks,
> Sidong
>=20
>=20
>>=20
>> ---
>> Cheers,
>> Benno


I'm not really sure how this solves the transmute/cast problem. Is the =
trait
you're referring to supposed to have any member functions? Or is it just =
a
marker trait?

I wonder if we can fit the existing "kernel::FromBytes" for this =
problem.

=E2=80=94 Daniel


