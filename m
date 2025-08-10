Return-Path: <io-uring+bounces-8929-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2147B1FA8C
	for <lists+io-uring@lfdr.de>; Sun, 10 Aug 2025 16:46:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8527C3BCC79
	for <lists+io-uring@lfdr.de>; Sun, 10 Aug 2025 14:46:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3B58176ADE;
	Sun, 10 Aug 2025 14:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="LFYakjWM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6C429CEB
	for <io-uring@vger.kernel.org>; Sun, 10 Aug 2025 14:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754837172; cv=none; b=M4batUcKWKYFwvRGT3qXsuFqidwCXxIHLmVb9L5d/t69Mf80O5LyASX/Mz70SqdrMoRRl/vFzXX7/zLiG4MzWCUy399aZtKyZkTL2u35THePfs4bmce6NmfpvETLQLwUANRMkbUz9QDflq6yBFOmAxS27jliS6jxh7+LCb8ZfwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754837172; c=relaxed/simple;
	bh=yNCyjBxmpcqjd9BVhKaOCkQW4cIXOHRPMXQ4R74Lndg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AbbC3nARZTKb2sBifrR2slLOcvrxzFusCuLZcad4hPoDBAxxc+CJQby2qSuD3l5HpfWZmItLdo8O/FiM1idkyjIeMu6lQ1bK/cRwknYXH9yFHBSq6moM2lrnAQQtN7EOS3xeDG8X/Ca9gOj3HP7/wWjK0Ms48ma5eiFoDG465hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=LFYakjWM; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b4209a0d426so3703415a12.1
        for <io-uring@vger.kernel.org>; Sun, 10 Aug 2025 07:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1754837171; x=1755441971; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+ofUuggQi14oNkJwPEJoW3BcLCOFwOPlMFxB7Ion1Fc=;
        b=LFYakjWMx618KlHyUcHLhKrWznyapA7jk37TtwJjF6G6JTG37Pn0iqGK2dvAHiGlLN
         mqX+zyycCs5XDqXObntZ7svkNITyMm+2GvsGKYUzEPDmvLZvCfKb8Q68yw5AZhTkxp0C
         ftfp/EB5w7CsgddOxualANUZ5TXwbbuaX1GE0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754837171; x=1755441971;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+ofUuggQi14oNkJwPEJoW3BcLCOFwOPlMFxB7Ion1Fc=;
        b=XcC84sooXQMc69G/XZ9RFa+rLx2GgzmAEoWNWo2hdtseNuvn0TlrCbmP1aKAcNQh0L
         3Fvph4ZFgiTWTPTAZKgXCj+uiCviYvuAkgxiPzEhY8atGgsiWwZd6HotpRlki8+rQSln
         nmvY2YgooCBQ+VZ0O2oJH0OtBbewO9jFN+QzY0z8YNMQUIr0SLaYmBzFjhS56f4iYEPY
         Mdxx8pNT8csVXlHNVJ54PUPDYAYo+a9LcOg7YKd/GULqXZe1vi2LxlpHYvxq8hC0N7Sj
         kGuB9/j9vtWtJybkpeVO9ZW7ZxErtUrpoWYJ9BDmpIv9KN/fg90tFT1pmiYry8c9Ckkd
         DJBA==
X-Forwarded-Encrypted: i=1; AJvYcCVIBUqzeopGkGezRYVbTKt6nJn5oyWUroNl8bfAcRcbp05l0mDpoOynenMOLvWKZVWRHWZbnUAheQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3RqikGEabANHOAFiYt2SPqMWuC3qG3ALTp5v8+ZWiVTG31Vvl
	jExIriwvOWv3tWIOqUHH10h3XjqJkng37Vn7D2ud2k9nfxwXwH+vmuRFbzy7tjo0TejzYNsdd+X
	qsNO/
X-Gm-Gg: ASbGnctDLzB2eILNP6YqnK//7oUQxinpYuRqlO0qY/rbqh/mXegd9y7Gbkbo6XIzIpA
	9YDVcVbSQI89wjIaf6gqf/6voLVv7QZDUBH55c49dls/Mtc1SpD0XY8N/OXkcBsXNk7zs+J5gn0
	eJE66q+AeztmBnWAyQKrJV7U2w7y4yRPDbs+Y2a3M0Tqz8mVjOD6WyGidlAqFIzpxPETZ0jrVTZ
	S2DX8DrZ155p0up22HraVw5ARKq8ePEPv2uvHvcX4y4U4A13mJKlVC/OKcOFvf+PSZaHsuhN+9S
	z7fI1QPiAz2zZhg+WR+CtXiIdqKp0pmolgaXu+ki1UymYzLAnwcJiIZBjRSOCaIsHCqXie8FXau
	jJGiHqiiJXUY+OGEh3hXSt0K6zfbOAY46o0xD1nR/1IAgDHrjPo659WbE
X-Google-Smtp-Source: AGHT+IGA/VW29LBb6c+SvCc/Xi2z36iu+jzINihApT/PsLqokoe8h/QSSjwto30OM6bfQFyw31ARWA==
X-Received: by 2002:a17:902:cec8:b0:242:9bbc:6018 with SMTP id d9443c01a7336-242c2277f70mr138091215ad.56.1754837170576;
        Sun, 10 Aug 2025 07:46:10 -0700 (PDT)
Received: from sidongui-MacBookPro.local ([175.195.128.78])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1ef75bdsm250934735ad.11.2025.08.10.07.46.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Aug 2025 07:46:10 -0700 (PDT)
Date: Sun, 10 Aug 2025 23:46:05 +0900
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Daniel Almeida <daniel.almeida@collabora.com>
Cc: Benno Lossin <lossin@kernel.org>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Miguel Ojeda <ojeda@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Jens Axboe <axboe@kernel.dk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/4] rust: io_uring: introduce rust abstraction
 for io-uring cmd
Message-ID: <aJiwrcq9nz0mUqKh@sidongui-MacBookPro.local>
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
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <81C84BD8-D99C-4103-A280-CFC71DF58E3B@collabora.com>

On Sun, Aug 10, 2025 at 11:27:12AM -0300, Daniel Almeida wrote:
> 
> 
> > On 10 Aug 2025, at 10:50, Sidong Yang <sidong.yang@furiosa.ai> wrote:
> > 
> > On Sat, Aug 09, 2025 at 10:22:06PM +0200, Benno Lossin wrote:
> >> On Sat Aug 9, 2025 at 2:51 PM CEST, Sidong Yang wrote:
> >>> On Sat, Aug 09, 2025 at 12:18:49PM +0200, Benno Lossin wrote:
> >>>> We'd need to ensure that `borrow_pdu` can only be called if `store_pdu`
> >>>> has been called before. Is there any way we can just ensure that pdu is
> >>>> always initialized? Like a callback that's called once, before the value
> >>>> is used at all?
> >>> 
> >>> I've thought about this. As Celab said, returning `&mut MaybeUninit<[u8;32]> is
> >>> simple and best. Only driver knows it's initialized. There is no way to
> >>> check whether it's initialized with reading the pdu. The best way is to return
> >>> `&mut MaybeUninit<[u8;32]>` and driver initializes it in first time. After 
> >>> init, driver knows it's guranteed that it's initialized so it could call 
> >>> `assume_init_mut()`. And casting to other struct is another problem. The driver
> >>> is responsible for determining how to interpret the PDU, whether by using it
> >>> directly as a byte array or by performing an unsafe cast to another struct.
> >> 
> >> But then drivers will have to use `unsafe` & possibly cast the slice to
> >> a struct? I think that's bad design since we try to avoid unsafe code in
> >> drivers as much as possible. Couldn't we try to ensure from the
> >> abstraction side that any time you create such an object, the driver
> >> needs to provide the pdu data? Or we could make it implement `Default`
> >> and then set it to that before handing it to the driver.
> > 
> > pdu data is [u8; 32] memory space that driver can borrow. this has two kind of
> > issues. The one is that the array is not initialized and another one is it's
> > array type that driver should cast it to private data structure unsafely.
> > The first one could be resolved with returning `&mut MaybeUninit<>`. And the
> > second one, casting issue, is remaining. 
> > 
> > It seems that we need new unsafe trait like below:
> > 
> > /// Pdu should be... repr C or transparent, sizeof <= 20
> > unsafe trait Pdu: Sized {}
> > 
> > /// Returning to casted Pdu type T
> > pub fn pdu<T: Pdu>(&mut self) -> &mut MaybeUninit<T>
> 
> Wait, you receive an uninitialized array, and you´re supposed to cast it to
> T, is that correct? Because that does not fit the signature above.

Sorry if my intent wasn´t clear. More example below:

// in rust/kernel/io_uring.rs
unsafe trait Pdu: Sized {}
pub fn pdu<T: Pdu>(&mut self) -> &mut MaybeUninit<T> {
    let inner = unsafe { &mut *self.inner.get() };
    let ptr = &raw mut inner.pdu as *mut MaybeUninit<T>; // the cast here
    unsafe { &mut *ptr }
}

// in driver code
#[repr(C)] struct MyPdu { value: u64 }
unsafe impl Pdu for MyPdu {}

// initialize
ioucmd.pdu().write(MyPdu { value: 1 });

// read or modify
let mypdu = unsafe { ioucmd.pdu().assume_init_mut() };

Thanks,
Sidong
> 
> > 
> > I think it is like bytemuck::Pod trait. Pod meaning plain old data.
> > 
> > Thanks,
> > Sidong
> > 
> > 
> >> 
> >> ---
> >> Cheers,
> >> Benno
> 
> 
> I'm not really sure how this solves the transmute/cast problem. Is the trait
> you're referring to supposed to have any member functions? Or is it just a
> marker trait?
> 
> I wonder if we can fit the existing "kernel::FromBytes" for this problem.
> 
> - Daniel
> 

