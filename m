Return-Path: <io-uring+bounces-8930-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6575FB1FBF7
	for <lists+io-uring@lfdr.de>; Sun, 10 Aug 2025 22:06:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B85297AB29D
	for <lists+io-uring@lfdr.de>; Sun, 10 Aug 2025 20:04:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0463220D4FF;
	Sun, 10 Aug 2025 20:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t+apOD5b"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E541FDA8E;
	Sun, 10 Aug 2025 20:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754856385; cv=none; b=Qhb3hcfpu8WfCUsz8mPe/WqJUsZjPlRB126I0V+U3pKhQhQP6yr5Sk+jAPDDTlUaIAsJzq34+qNvDp7W59HALJHeDb/r0FCv2LujhJmiqskivac+jdq1htfM7B5CgbXnLr67gqcL1H3sz2a2UENNP9MaJj7diW0JPAO8MdX+qac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754856385; c=relaxed/simple;
	bh=ZLDwdPbfyQD3OfJvih1vPZ40n1AO27fW53f6uph3ULY=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=PcQRpjdVBd9i/6IQh2HrNl1g6fVP7H/zqTkdWtE7yR42w4LbuuTK5P7n7QhYYNqnpB3kX8EuAzHw8ZCyK33+smsup2Cg7oZboAOgbQZidztvXMDhq4iYk8eNDk1U7AjcCoXvqi4Y1VRh0z2Kj4+c+9qVHiYYXLEJsflJ7rK0SVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t+apOD5b; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68F15C4CEEB;
	Sun, 10 Aug 2025 20:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754856385;
	bh=ZLDwdPbfyQD3OfJvih1vPZ40n1AO27fW53f6uph3ULY=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=t+apOD5bEx7wsH8TzlcL3E9tKPCWYG5fPmK8eHa73DQ4W0hMfAVrtuUJIFDFSqMOC
	 HarGg7TZxy9fcdR1VOO0kAPCW5cqf6lBLQm5cKH2hTBvKIIWap8w1Ims+9CWbqXH0+
	 NYzrTx5Od8jvByVOziBwGvgoJqqd8b6gQ67UqRj1fhW6FcNSL9ReB5anF57E0XnZ2y
	 w4nnfVrJ7G7L82XdwcoiWvzg+W793/x1+ayudU1jOTF0OFF+7T5CrE+LkjTCyufI9v
	 0ef4Aprta0pQdoJ6wO53DahddpgTWoh5bKwT7O91nFYILk3hxI3gY5f0TqBJuFiv/K
	 FEkWaihDWWUuw==
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 10 Aug 2025 22:06:21 +0200
Message-Id: <DBZ0O49ME4BF.2JFHBZQVPJ4TK@kernel.org>
Cc: "Caleb Sander Mateos" <csander@purestorage.com>, "Miguel Ojeda"
 <ojeda@kernel.org>, "Arnd Bergmann" <arnd@arndb.de>, "Jens Axboe"
 <axboe@kernel.dk>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <io-uring@vger.kernel.org>
Subject: Re: [RFC PATCH v2 2/4] rust: io_uring: introduce rust abstraction
 for io-uring cmd
From: "Benno Lossin" <lossin@kernel.org>
To: "Sidong Yang" <sidong.yang@furiosa.ai>, "Daniel Almeida"
 <daniel.almeida@collabora.com>
X-Mailer: aerc 0.20.1
References: <949A27C5-1535-48D1-BE7E-F7E366A49A52@collabora.com>
 <DBVDWWHX8UY7.TG5OHXBZM2OX@kernel.org>
 <aJWfl87T3wehIviV@sidongui-MacBookPro.local>
 <DBWX0L4LIOF6.1AVJJV0SMDQ3P@kernel.org>
 <aJXG3wPf9W3usEj2@sidongui-MacBookPro.local>
 <DBXTJQ27RY6K.1R6KUNEXF008N@kernel.org>
 <aJdEbFI2FqSCBt9L@sidongui-MacBookPro.local>
 <DBY6DMQYZ2CL.2P0LZO2HF13MJ@kernel.org>
 <aJijj4kiMV9yxOrM@sidongui-MacBookPro.local>
 <81C84BD8-D99C-4103-A280-CFC71DF58E3B@collabora.com>
 <aJiwrcq9nz0mUqKh@sidongui-MacBookPro.local>
In-Reply-To: <aJiwrcq9nz0mUqKh@sidongui-MacBookPro.local>

On Sun Aug 10, 2025 at 4:46 PM CEST, Sidong Yang wrote:
> On Sun, Aug 10, 2025 at 11:27:12AM -0300, Daniel Almeida wrote:
>> > On 10 Aug 2025, at 10:50, Sidong Yang <sidong.yang@furiosa.ai> wrote:
>> >=20
>> > On Sat, Aug 09, 2025 at 10:22:06PM +0200, Benno Lossin wrote:
>> >> On Sat Aug 9, 2025 at 2:51 PM CEST, Sidong Yang wrote:
>> >>> On Sat, Aug 09, 2025 at 12:18:49PM +0200, Benno Lossin wrote:
>> >>>> We'd need to ensure that `borrow_pdu` can only be called if `store_=
pdu`
>> >>>> has been called before. Is there any way we can just ensure that pd=
u is
>> >>>> always initialized? Like a callback that's called once, before the =
value
>> >>>> is used at all?
>> >>>=20
>> >>> I've thought about this. As Celab said, returning `&mut MaybeUninit<=
[u8;32]> is
>> >>> simple and best. Only driver knows it's initialized. There is no way=
 to
>> >>> check whether it's initialized with reading the pdu. The best way is=
 to return
>> >>> `&mut MaybeUninit<[u8;32]>` and driver initializes it in first time.=
 After=20
>> >>> init, driver knows it's guranteed that it's initialized so it could =
call=20
>> >>> `assume_init_mut()`. And casting to other struct is another problem.=
 The driver
>> >>> is responsible for determining how to interpret the PDU, whether by =
using it
>> >>> directly as a byte array or by performing an unsafe cast to another =
struct.
>> >>=20
>> >> But then drivers will have to use `unsafe` & possibly cast the slice =
to
>> >> a struct? I think that's bad design since we try to avoid unsafe code=
 in
>> >> drivers as much as possible. Couldn't we try to ensure from the
>> >> abstraction side that any time you create such an object, the driver
>> >> needs to provide the pdu data? Or we could make it implement `Default=
`
>> >> and then set it to that before handing it to the driver.
>> >=20
>> > pdu data is [u8; 32] memory space that driver can borrow. this has two=
 kind of
>> > issues. The one is that the array is not initialized and another one i=
s it's
>> > array type that driver should cast it to private data structure unsafe=
ly.
>> > The first one could be resolved with returning `&mut MaybeUninit<>`. A=
nd the
>> > second one, casting issue, is remaining.=20
>> >=20
>> > It seems that we need new unsafe trait like below:
>> >=20
>> > /// Pdu should be... repr C or transparent, sizeof <=3D 20
>> > unsafe trait Pdu: Sized {}
>> >=20
>> > /// Returning to casted Pdu type T
>> > pub fn pdu<T: Pdu>(&mut self) -> &mut MaybeUninit<T>
>>=20
>> Wait, you receive an uninitialized array, and you=C2=B4re supposed to ca=
st it to
>> T, is that correct? Because that does not fit the signature above.
>
> Sorry if my intent wasn=C2=B4t clear. More example below:
>
> // in rust/kernel/io_uring.rs
> unsafe trait Pdu: Sized {}
> pub fn pdu<T: Pdu>(&mut self) -> &mut MaybeUninit<T> {
>     let inner =3D unsafe { &mut *self.inner.get() };
>     let ptr =3D &raw mut inner.pdu as *mut MaybeUninit<T>; // the cast he=
re
>     unsafe { &mut *ptr }
> }
>
> // in driver code
> #[repr(C)] struct MyPdu { value: u64 }
> unsafe impl Pdu for MyPdu {}
>
> // initialize
> ioucmd.pdu().write(MyPdu { value: 1 });
>
> // read or modify
> let mypdu =3D unsafe { ioucmd.pdu().assume_init_mut() };

This is the kind of code I'd like to avoid, since it plans to use
`unsafe` in driver code (the `unsafe impl` above is also a problem, but
we can solve that with a derive macro).

Where are the entrypoints for `IoUringCmd` for driver code? I imagine
that there is some kind of a driver callback (like `probe`, `open` etc)
that contains an `Pin<&mut IoUringCmd>` as an argument, right? When is
it created, can we control that & just write some default value to the
pdu field?

---
Cheers,
Benno

