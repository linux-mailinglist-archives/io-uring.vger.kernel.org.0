Return-Path: <io-uring+bounces-8924-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 29BADB1F629
	for <lists+io-uring@lfdr.de>; Sat,  9 Aug 2025 22:22:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 458CC189D9C1
	for <lists+io-uring@lfdr.de>; Sat,  9 Aug 2025 20:22:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8722D224AF9;
	Sat,  9 Aug 2025 20:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D/1LjE54"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4312E36F1;
	Sat,  9 Aug 2025 20:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754770930; cv=none; b=VjLlsNwqwGaz09CX7iz+4PWMLcIsJkW8ruAShjliHll+/JDito/G26tF5VVPmlos96jV/jW+E4gNnzCNUzh/itFK/ZuzvGxz+jTuLpBpnbA1rIX7TH4MX/P91ndARiTuwfqqaSHi2YvEnXV8EjpJVrPE0GVLQAmBP+uSLyOyp2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754770930; c=relaxed/simple;
	bh=BjLJCqEd7VeVy0KqVbhTunrlhwq6ZptffnF9gyr2yPk=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=oa0RU/WKRX8fqD5Shk662DkQEnR7NEnAe1mhUYJh0PaK5Nv4Nqb22fpL2YL76ceT4n3IQ31EGvufrLtOyJIuSO/hIucHLF+UXgrSQ9drqltaTc3R2pjjOfkgeqTRj8JL89JOUyGAxBGlCZuC0XQ3rzdDMZ4xnK6igt0DYlLB7Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D/1LjE54; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F5CC4CEE7;
	Sat,  9 Aug 2025 20:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754770929;
	bh=BjLJCqEd7VeVy0KqVbhTunrlhwq6ZptffnF9gyr2yPk=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=D/1LjE54khs3k1dxPdkfwM+QSFd8Utx13CvoVehajnhjigIRpypfuSPvANeZY/3+S
	 L3tGPbz3mq0l8hnYKFBfFFsh3qb37sqgNivvpNR/by/Swc6pl5I5bcadT1NPhcimb3
	 kS1E7ue7LLwyQI9pdDWvumVddJhIm5SIhUFD0rKkoPbibtbqrpsL3nwlSX4IgQntRs
	 yeI+Zc9jIgIV9A179t2hdTl9UMXOJ97EA/3kPeRTIfTX/hD5/6zIk9+oHAKoCUqfWa
	 YIywFvPa3IRbYbfDVORNCoaBpFxJBWhmNhsLxy24wYeDBCpOH3XLQCAX3kAmya3Yos
	 fE9+bXvTMK8OA==
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 09 Aug 2025 22:22:06 +0200
Message-Id: <DBY6DMQYZ2CL.2P0LZO2HF13MJ@kernel.org>
Cc: "Daniel Almeida" <daniel.almeida@collabora.com>, "Miguel Ojeda"
 <ojeda@kernel.org>, "Arnd Bergmann" <arnd@arndb.de>, "Jens Axboe"
 <axboe@kernel.dk>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <io-uring@vger.kernel.org>
Subject: Re: [RFC PATCH v2 2/4] rust: io_uring: introduce rust abstraction
 for io-uring cmd
From: "Benno Lossin" <lossin@kernel.org>
To: "Sidong Yang" <sidong.yang@furiosa.ai>, "Caleb Sander Mateos"
 <csander@purestorage.com>
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
 <DBXTJQ27RY6K.1R6KUNEXF008N@kernel.org>
 <aJdEbFI2FqSCBt9L@sidongui-MacBookPro.local>
In-Reply-To: <aJdEbFI2FqSCBt9L@sidongui-MacBookPro.local>

On Sat Aug 9, 2025 at 2:51 PM CEST, Sidong Yang wrote:
> On Sat, Aug 09, 2025 at 12:18:49PM +0200, Benno Lossin wrote:
>> We'd need to ensure that `borrow_pdu` can only be called if `store_pdu`
>> has been called before. Is there any way we can just ensure that pdu is
>> always initialized? Like a callback that's called once, before the value
>> is used at all?
>
> I've thought about this. As Celab said, returning `&mut MaybeUninit<[u8;3=
2]> is
> simple and best. Only driver knows it's initialized. There is no way to
> check whether it's initialized with reading the pdu. The best way is to r=
eturn
> `&mut MaybeUninit<[u8;32]>` and driver initializes it in first time. Afte=
r=20
> init, driver knows it's guranteed that it's initialized so it could call=
=20
> `assume_init_mut()`. And casting to other struct is another problem. The =
driver
> is responsible for determining how to interpret the PDU, whether by using=
 it
> directly as a byte array or by performing an unsafe cast to another struc=
t.

But then drivers will have to use `unsafe` & possibly cast the slice to
a struct? I think that's bad design since we try to avoid unsafe code in
drivers as much as possible. Couldn't we try to ensure from the
abstraction side that any time you create such an object, the driver
needs to provide the pdu data? Or we could make it implement `Default`
and then set it to that before handing it to the driver.

---
Cheers,
Benno

