Return-Path: <io-uring+bounces-8922-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02351B1F4A9
	for <lists+io-uring@lfdr.de>; Sat,  9 Aug 2025 14:53:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8EE0A7A31D4
	for <lists+io-uring@lfdr.de>; Sat,  9 Aug 2025 12:52:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC2802868A1;
	Sat,  9 Aug 2025 12:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="fZsbyABi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5AF274B34
	for <io-uring@vger.kernel.org>; Sat,  9 Aug 2025 12:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754744021; cv=none; b=rPs6frfAnbjp1t4+896o41ex7Hink7bkAHNhVS0n4HYeTL03PETOSLJ0LEFV1mbV3lqaV+FX3itwODu98xoeZ8CZc0jSPpTbN+0sOhZ1avJT+svL3zv9OnRIkhBu5nGQsEIUd0wdgyQyK8HkoPExjAbTk1Wtn3IliZpxNZry4X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754744021; c=relaxed/simple;
	bh=fx1Rl2XN14tk+BtEc41p90+jXDudqi7LnVoEeN8UTn4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EYK9X0PiRB3NefNm3XVj+ZdA1IJ4vjtv7V4gU6fde6CufcgkCDYFbtpWXukogYyO/SQ5jErzMSfY0d2QADGp1OhYn6lGbAjT1c+9ze669iytavn06YGXOMtzzuxvdL3mlDUw6t26Ob/CuR4CDB3Ryn9g53aKXa/TZq+2s8gk9+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=fZsbyABi; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-32138e0d9adso2613434a91.2
        for <io-uring@vger.kernel.org>; Sat, 09 Aug 2025 05:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1754744020; x=1755348820; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=l6ld1uqa+Y0Ptl6MvYRH/7bNpbs5gzVTJqHHdh4KG+0=;
        b=fZsbyABiD2Vl1ej9G+3ddCDD8ZE1kpI8dtpAlGfM0wr+bXwNcHvbMkgwSitds+Jzy8
         p4VoRogEBvnvd0iNuYJ2WphvrvMmF5l0OkRPB9FSnhV39LsdUpmqs1G55mPhWwbnpsjz
         v6gTKmY+VRgYbkgegD+CtXabuhrp7v2ygbWks=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754744020; x=1755348820;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l6ld1uqa+Y0Ptl6MvYRH/7bNpbs5gzVTJqHHdh4KG+0=;
        b=sV+tWrg8ARh5xzP2vDWufzxL6OYwg9n88G8WK2wI9mFYwyrB4zac83ZpMVmIwKmuOz
         ZPIt3eXMUoCgZB8GM1JYvWl5t/NBRHV9Zyy2RwVQTFL3Tq1dRsLQdYdm5YEXCoREP32s
         b4tX1lxOeJR3fjOShGPLZnrJigKBL0QmAyaQDYYZ6bfHoP9vNnM8Pzf8YGoHbcBHzB3D
         Mb0D6PHxERTg4Ri7aauBNhA8l6F8SExlI1ShneRI4WDtDl8KFOqBn9f83RfCo7wL8X8F
         uqqusgsOI3PZFmSNz65m5a3Ez4WltlFYzVVFoxmWMKWbBbYzONy0niXGMsAwM+xXhHqb
         fRxA==
X-Forwarded-Encrypted: i=1; AJvYcCUCuyNC55v5VhPMJjKZ+Yec2pT3h2uSw0UO81k7oF0PRuOjC762kdkHGaW6scyq30ijCRY0eUKgnw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzuCm2k4sI0EFMh9EY8YHUbAr0vISiHt6uA0n6YLGmoSidFGdlY
	0tOJFdpUgjhbyV1D0tWeZLM6fuO3Kold60jo4yFQ0WmSko0Lr3JD2DUSLCYF1loXfeU=
X-Gm-Gg: ASbGncvNWeoQ9ob6Gs30929Bwl9F20oLS1JGvn9uKQdySpEWPfd/g84ONIBYYmY3EVO
	7qBws6s/R2dFxKMd18w4UBQ9tj5LwRkPxAPZL+rYLSLEKheix/FnYenPIPfbNTgjvhazVIXqk1C
	JRYGVQBwW58oO+I46EzIlB6BLf3IJnvQrpfZKuSjqB0lvvu+g1vVW7BqA5Pc7IOiaGQSLG6MinF
	B0lLDyDaVitG3lwefaCFj9s167iWDybya2FLbDnCnhm7ROAsi8T+dLhOzW1+IYOlhC+T//Fi1dv
	XPZtLWxQXblfNphnEhVbJ/we6ZOpGlQe+4CFL2V1jaDjt2oUz+/S65vTLZDS0k9mEPZHFrYBC+P
	BHeKvARabBWWddaQiNvc2r0ByBlxPx3Hit2eMgrlLweWgVfQ+m3mREkkUViDtPw==
X-Google-Smtp-Source: AGHT+IGh8dSlzi3tIj0AQRFc46haMuqZOjOj19eAYcc5a4BffBcr0JUb8WW+MLPjBW9qywnxDaMQvA==
X-Received: by 2002:a17:90b:17d0:b0:311:ef19:824d with SMTP id 98e67ed59e1d1-321839d39b2mr9575683a91.2.1754744019796;
        Sat, 09 Aug 2025 05:53:39 -0700 (PDT)
Received: from sidongui-MacBookPro.local ([175.195.128.78])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32161294ee4sm10490104a91.32.2025.08.09.05.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Aug 2025 05:53:39 -0700 (PDT)
Date: Sat, 9 Aug 2025 21:53:34 +0900
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Benno Lossin <lossin@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Miguel Ojeda <ojeda@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Jens Axboe <axboe@kernel.dk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/4] rust: io_uring: introduce rust abstraction
 for io-uring cmd
Message-ID: <aJdEzqbSxv0NhuDM@sidongui-MacBookPro.local>
References: <20250727150329.27433-1-sidong.yang@furiosa.ai>
 <20250727150329.27433-3-sidong.yang@furiosa.ai>
 <D6CDE1A5-879F-49B1-9E10-2998D04B678F@collabora.com>
 <DBRVVTJ5LDV2.2NHTJ4S490N8@kernel.org>
 <949A27C5-1535-48D1-BE7E-F7E366A49A52@collabora.com>
 <DBVDWWHX8UY7.TG5OHXBZM2OX@kernel.org>
 <aJWfl87T3wehIviV@sidongui-MacBookPro.local>
 <CADUfDZrWMrECM_LSh-nsurRBadskq_Z9wh_7nO1FUUxvOVHmKg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZrWMrECM_LSh-nsurRBadskq_Z9wh_7nO1FUUxvOVHmKg@mail.gmail.com>

On Fri, Aug 08, 2025 at 09:55:22AM -0400, Caleb Sander Mateos wrote:
> On Fri, Aug 8, 2025 at 2:56 AM Sidong Yang <sidong.yang@furiosa.ai> wrote:
> >
> > On Wed, Aug 06, 2025 at 03:38:24PM +0200, Benno Lossin wrote:
> > > On Wed Aug 6, 2025 at 2:38 PM CEST, Daniel Almeida wrote:
> > > > Hi Benno,
> > > >
> > > >> On 2 Aug 2025, at 07:52, Benno Lossin <lossin@kernel.org> wrote:
> > > >>
> > > >> On Fri Aug 1, 2025 at 3:48 PM CEST, Daniel Almeida wrote:
> > > >>>> On 27 Jul 2025, at 12:03, Sidong Yang <sidong.yang@furiosa.ai> wrote:
> > > >>>> +    #[inline]
> > > >>>> +    pub fn pdu(&mut self) -> &mut MaybeUninit<[u8; 32]> {
> > > >>>
> > > >>> Why MaybeUninit? Also, this is a question for others, but I don´t think
> > > >>> that `u8`s can ever be uninitialized as all byte values are valid for `u8`.
> > > >>
> > > >> `u8` can be uninitialized. Uninitialized doesn't just mean "can take any
> > > >> bit pattern", but also "is known to the compiler as being
> > > >> uninitialized". The docs of `MaybeUninit` explain it like this:
> > > >>
> > > >>    Moreover, uninitialized memory is special in that it does not have a
> > > >>    fixed value ("fixed" meaning "it won´t change without being written
> > > >>    to"). Reading the same uninitialized byte multiple times can give
> > > >>    different results.
> > > >>
> > > >> But the return type probably should be `&mut [MaybeUninit<u8>; 32]`
> > > >> instead.
> > > >
> > > >
> > > > Right, but I guess the question then is why would we ever need to use
> > > > MaybeUninit here anyways.
> > > >
> > > > It's a reference to a C array. Just treat that as initialized.
> > >
> > > AFAIK C uninitialized memory also is considered uninitialized in Rust.
> > > So if this array is not properly initialized on the C side, this would
> > > be the correct type. If it is initialized, then just use `&mut [u8; 32]`.
> >
> > pdu field is memory chunk for driver can use it freely. The driver usually
> > saves a private data and read or modify it on the other context. using
> > just `&mut [u8;32]` would be simple and easy to use.
> 
> MaybeUninit is correct. The io_uring/uring_cmd layer doesn't
> initialize the pdu field. struct io_uring_cmd is overlaid with struct
> io_kiocb's cmd field. struct io_kiocb's are allocated using
> kmem_cache_alloc(_bulk)() in __io_alloc_req_refill(). io_preinit_req()
> is called to initialize each struct io_kiocb but doesn't initialize
> the cmd field. As Sidong said, it's uninitialized memory for the
> ->uring_cmd() implementation to use however it wants for the duration
> of the command.

Agreed. Thanks.

Thanks,
Sidong
> 
> Best,
> Caleb

