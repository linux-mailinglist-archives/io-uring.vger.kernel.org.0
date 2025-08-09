Return-Path: <io-uring+bounces-8921-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D811AB1F4A7
	for <lists+io-uring@lfdr.de>; Sat,  9 Aug 2025 14:52:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA28E17B2AE
	for <lists+io-uring@lfdr.de>; Sat,  9 Aug 2025 12:52:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56E73286892;
	Sat,  9 Aug 2025 12:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="P8z7F4W2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B4822172D
	for <io-uring@vger.kernel.org>; Sat,  9 Aug 2025 12:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754743924; cv=none; b=X9P5lUv7HJYoRGMnoaJDjFweaXQYtri7t0+u1Rus9jdy0qzrBbr3DA26dM7dsxyzMgkRAFlFJIGZ2EWSfl2bXuS08YgAJJW3vfpAdOZfNlUPJjSAPS6j8uimOVJjbR78h9uXdwZwFGa2b+8/QGZRnTXO/Y61MlfghDywpwQ0ZHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754743924; c=relaxed/simple;
	bh=2mKpDbQ0TiPYWnYs/2WRUGwn/9a4+AQbBllAeNZ18yA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I6iQ9fuGc7ypD3VhYqKEJpB7w/z6QCoPnvpvarBGIErmq7mk2gxx9LhbGEwFaVDF+4pAU6CPYclIiu1VLj8C88kkOcYZCodBUWH0/kJNBooHZNdfmJo1M5j8cJuByPZ3aRDVrhlmMNdjPOXm4q3BSAymu8VMJQGnKYiwpVx4MlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=P8z7F4W2; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-76bd2b11f80so2809697b3a.3
        for <io-uring@vger.kernel.org>; Sat, 09 Aug 2025 05:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1754743922; x=1755348722; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lZQHDrk/LkanyBqpFJsbPVrV+kWk5kpVdTdjq5Ed4zs=;
        b=P8z7F4W2g4ZlymB9XRWSOz14m8nwYnAdK3gwogYjoY3Rwyjk4Pnu54CB7PXlAecjt+
         I4cCiq/ECvun5EZEyfaeGeJgu73pxm722FSmC3CEI8YzvED7r5RP+d2cZWNvV1tyLP4U
         E3je/86JvIxyeyfv94MXfYIKEolB2lqIttsUE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754743922; x=1755348722;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lZQHDrk/LkanyBqpFJsbPVrV+kWk5kpVdTdjq5Ed4zs=;
        b=efffYVcsT1URqKQIjocFvqQCT4IbChdw553ZEXvE5hVSHAo1phx3HTapUD/1Ke3rTN
         StOxHkZ7AQ0p/Rn03vSAmDsLCWsu/S0dZcs9N9HKtdlSl/j3JNO18lFMT7YvPoGkdr9w
         dX4UdzYP4x5wMEvTUwLMRevxX371xTYgC4VhCEo+Q3J3XFJ05Tum+yVdSKiv5zzIoREs
         0cNN3xaXmydd6UbcZgaxZR3XbETV05ymw4Db7709EvGEY7mkstp4TU8oQLdqQXi/XDtP
         WshHe2cm6WmEsmkI69PiuQgvILyQZwn9gSJhMq326GUzkgQpC5Ib7m+jIdMH2QhO3FMX
         MCCQ==
X-Forwarded-Encrypted: i=1; AJvYcCWmeKh60v+Ohgq1W0kYFPtjawKTzKusgRzuk2VpJfDZZFc8+5xQkOizQKe+AXW2xXCm0ERf0NFe9g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwUdt8d49lMcO8Fc+PKFeumrr68eOjWcA1A6YSbF/fuutzLJxZG
	tq8scj00UjIg3wNMM2vuJm76jemWEnRvonhrDVRm6uWZjxDTsJnvPyQsD6JBoIi101g=
X-Gm-Gg: ASbGncuhSpIMn6zgSJvDG2NaOy9CrTHHqmoLqH1Rdnv2T8ivbpeu31UxhHpbyOhuK3n
	KgDIYQjVeCXlS3z8yJZcLz1KycVgkYJkTZ4kmuSxbV2wycJg73QFPApbZjJlScgowxAIIc4uUhU
	cgnPyCkJM93xGge7aQNu5lTFu8qkNUcGtsDi082iejPhIsSfJ9z3w32hr/90XG46msUsc0OHcqS
	N9qbAFFNTO5sd/PZM2crk9jRsJlaaMoehwxQLDxbgI6AkTfWiTjaD0urIcBYVi2Ibb3fIG697ZA
	7qnqxWnLQdV4N27e3KH/uAEvj4jA2zGi7sUYc+B1sKktiTEpNUhdWY0gimAOC6Ak2LMkUX/Xmso
	s16k1VeJ/Kc7SCQgM1BEzwYYDwP/aO+JCHHnZ5DZXGVwiYFRVHdyYG72cu4BFInpMcIWYeC4j
X-Google-Smtp-Source: AGHT+IEYcnbWDkUTVzAJhblKeZ2ZZoJD60e/e/JnNVhB2OyeAcQJmssBvzhYnRZPpRISv1VmKV62Cw==
X-Received: by 2002:a05:6a00:4b15:b0:76b:49af:eceb with SMTP id d2e1a72fcca58-76c4613760fmr9771501b3a.20.1754743922047;
        Sat, 09 Aug 2025 05:52:02 -0700 (PDT)
Received: from sidongui-MacBookPro.local ([175.195.128.78])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bccfbd1a7sm22589272b3a.73.2025.08.09.05.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Aug 2025 05:52:01 -0700 (PDT)
Date: Sat, 9 Aug 2025 21:51:56 +0900
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Benno Lossin <lossin@kernel.org>,
	Caleb Sander Mateos <csander@purestorage.com>
Cc: Daniel Almeida <daniel.almeida@collabora.com>,
	Miguel Ojeda <ojeda@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Jens Axboe <axboe@kernel.dk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/4] rust: io_uring: introduce rust abstraction
 for io-uring cmd
Message-ID: <aJdEbFI2FqSCBt9L@sidongui-MacBookPro.local>
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
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DBXTJQ27RY6K.1R6KUNEXF008N@kernel.org>

On Sat, Aug 09, 2025 at 12:18:49PM +0200, Benno Lossin wrote:
> On Fri Aug 8, 2025 at 11:43 AM CEST, Sidong Yang wrote:
> > On Fri, Aug 08, 2025 at 10:49:14AM +0200, Benno Lossin wrote:
> >> On Fri Aug 8, 2025 at 8:56 AM CEST, Sidong Yang wrote:
> >> > On Wed, Aug 06, 2025 at 03:38:24PM +0200, Benno Lossin wrote:
> >> >> On Wed Aug 6, 2025 at 2:38 PM CEST, Daniel Almeida wrote:
> >> >> > Hi Benno,
> >> >> >
> >> >> >> On 2 Aug 2025, at 07:52, Benno Lossin <lossin@kernel.org> wrote:
> >> >> >> 
> >> >> >> On Fri Aug 1, 2025 at 3:48 PM CEST, Daniel Almeida wrote:
> >> >> >>>> On 27 Jul 2025, at 12:03, Sidong Yang <sidong.yang@furiosa.ai> wrote:
> >> >> >>>> +    #[inline]
> >> >> >>>> +    pub fn pdu(&mut self) -> &mut MaybeUninit<[u8; 32]> {
> >> >> >>> 
> >> >> >>> Why MaybeUninit? Also, this is a question for others, but I don´t think
> >> >> >>> that `u8`s can ever be uninitialized as all byte values are valid for `u8`.
> >> >> >> 
> >> >> >> `u8` can be uninitialized. Uninitialized doesn't just mean "can take any
> >> >> >> bit pattern", but also "is known to the compiler as being
> >> >> >> uninitialized". The docs of `MaybeUninit` explain it like this:
> >> >> >> 
> >> >> >>    Moreover, uninitialized memory is special in that it does not have a
> >> >> >>    fixed value ("fixed" meaning "it won´t change without being written
> >> >> >>    to"). Reading the same uninitialized byte multiple times can give
> >> >> >>    different results.
> >> >> >> 
> >> >> >> But the return type probably should be `&mut [MaybeUninit<u8>; 32]`
> >> >> >> instead.
> >> >> >
> >> >> >
> >> >> > Right, but I guess the question then is why would we ever need to use
> >> >> > MaybeUninit here anyways.
> >> >> >
> >> >> > It's a reference to a C array. Just treat that as initialized.
> >> >> 
> >> >> AFAIK C uninitialized memory also is considered uninitialized in Rust.
> >> >> So if this array is not properly initialized on the C side, this would
> >> >> be the correct type. If it is initialized, then just use `&mut [u8; 32]`.
> >> >
> >> > pdu field is memory chunk for driver can use it freely. The driver usually
> >> > saves a private data and read or modify it on the other context. using
> >> > just `&mut [u8;32]` would be simple and easy to use.
> >> 
> >> Private data is usually handled using `ForeignOwnable` in Rust. What
> >> kind of data would be stored there? If it's a pointer, then `&mut [u8;
> >> 32]` would not be the correct choice.
> >
> > Most driver uses `io_uring_cmd_to_pdu` macro that casts address of pdu to
> > private data type. It seems that all driver use this macro has it's own
> > struct type. How about make 2 function for pdu? like store_pdu(), borrow_pdu().
> 
> We'd need to ensure that `borrow_pdu` can only be called if `store_pdu`
> has been called before. Is there any way we can just ensure that pdu is
> always initialized? Like a callback that's called once, before the value
> is used at all?

I've thought about this. As Celab said, returning `&mut MaybeUninit<[u8;32]> is
simple and best. Only driver knows it's initialized. There is no way to
check whether it's initialized with reading the pdu. The best way is to return
`&mut MaybeUninit<[u8;32]>` and driver initializes it in first time. After 
init, driver knows it's guranteed that it's initialized so it could call 
`assume_init_mut()`. And casting to other struct is another problem. The driver
is responsible for determining how to interpret the PDU, whether by using it
directly as a byte array or by performing an unsafe cast to another struct.

Thanks,
Sidong


> 
> ---
> Cheers,
> Benno

