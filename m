Return-Path: <io-uring+bounces-8931-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7FFCB208D5
	for <lists+io-uring@lfdr.de>; Mon, 11 Aug 2025 14:34:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EBC327A2E2F
	for <lists+io-uring@lfdr.de>; Mon, 11 Aug 2025 12:33:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D845B288C22;
	Mon, 11 Aug 2025 12:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="Rbxhtke7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B513C38
	for <io-uring@vger.kernel.org>; Mon, 11 Aug 2025 12:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754915688; cv=none; b=G/QYq6Hnn4AoSrx0d0B6JFkLaIZZ3gnzD+m+zZkv3d1RJ25Zn2LYxt1uhndq1p7knC1rCbj1h+6aFwY/mR5lRAR8SHoLJOFC00w0EbddqUQNJcRUnVcGMcVz9d30vQMIvfM5OSUO0j17g6E8FKb/16vaFNV9fa+zYEfXhXCygeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754915688; c=relaxed/simple;
	bh=XPovIlxIpK3Xyq5m0fxGOWM6Yw0u3P4oVgNQIGmTFhc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YUBDUIrpTMrQdIsT9Wb5HRwVook3c6OrTiOeFVx7u5hMgP3wma4F7niyCH2xeyAo4YoiR57GQe9kHoeFQWWJ8k2tBWPr4PITJsyAPEzdH6Azdl6SU5wYJigiOPqdfH8cj8es3XV0ngagWe1PIMnNl0M2Dyy9v7QRnLJvF6NrKCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=Rbxhtke7; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b3f80661991so3696138a12.0
        for <io-uring@vger.kernel.org>; Mon, 11 Aug 2025 05:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1754915687; x=1755520487; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jnhz3gg9UqvoEaKu6PtG0eWIp3XZKcHUtlBjEIsc8uo=;
        b=Rbxhtke7Do6Ln4tLtq8h1ckX80tU+9AHWKU5Rx/rTnAzIRru4dvk8wYDPfow0gx3wF
         ZXxkylJiiFCeRlF0SP/9RdP0+2bd9JqsNpbXxv7o7KTRRx6OT2fHVEV866luFxX3Lu/M
         wk8+vKfBea78XyvCcEIGZWb+tLPu8bS/ed1u0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754915687; x=1755520487;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jnhz3gg9UqvoEaKu6PtG0eWIp3XZKcHUtlBjEIsc8uo=;
        b=I0amZzj2czfUxbDB8sS4NN8BmapSw2XdDFO98j0PxOB0mI3BBi96zZkvl+44lkU1bE
         2LogryBc+KICqpLoFpTAW2Q+E22orE8beRcfe32N6LzaTAVzHN/gPSxM4DkGXug7prOf
         /rgTWDxEyw2uY5owCeu994cErMt4JubB3YfaAX9ISAigO1e/Cve2bKHRu9TSlj5byGHZ
         wXLlhdbfASVWOl+AaLbcyhDoK0OXWSjx/sVYYduJCruMeHFh2NSoZeDw+iRfHAdoEgVa
         ufHYamWSIW6FIlZk3Bq8W4Y+ls4HPI8e1YxUqIXpKodt+7wzka44mpKGxL6Kerti2NP7
         Pdtg==
X-Forwarded-Encrypted: i=1; AJvYcCWjAQrM7OIiSyP9S0ctV4jzDpKxtRMvmZU5Xl984XwwuWHL3fG77Y9WhzgRfA640zbtArsqrHKrrA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzvNtQnMazZf/HPoR/0x1Nx1u92DYLvBNhY2Ku3maWIrt+NpeO9
	kxIVAD66HICldKWz8QDEuV2odl1WiuJl7R2iYYdwG+nctiIONMIrUsiEaPW0EztY3HY=
X-Gm-Gg: ASbGncvTqjHs/OBCgPp0A3l0yljJxECKcGlDObSN+cZcU4UjCZhQhxGja80PPndulFN
	KImV4SQe1GugQ86MebCtg/H4U/+xKKkbt8qLotQ1Smee1BxOEJCj5T8q2ZGSqDU9KAswKuYeoha
	lCw9W+Sua6sOgTL5J1k3szJBGYICT+iL/qWTiRIh+F1TZrrYykxEGZqtug0K8cp8odS7UH4t3hY
	QelpxHH2nJGvYq2Nse5IO5KjL+o4rtO7DUljHyMS2PZhv2f67m4Kb3rTlahCQGDJRjs738Cdnzm
	8Q39yC4yoq2a2/fDSK9TD4NihznRpd85rZhZDaADKVeTizeAeECSUtjYZEAVCLr528p0yYzv77F
	7dMHyBYBC72dEsFVHCun/qJHxjJXzmF6BlqQA537kd8u+y+w0MoXmoMzr
X-Google-Smtp-Source: AGHT+IHKUm9OnDYHdk/WKwUbriS/iwTepKs5TyQMaFN4XNopewnVVvMHIJNAzd7+96ZNmHDCNZ6O7Q==
X-Received: by 2002:a17:902:f54d:b0:235:e1e4:edb0 with SMTP id d9443c01a7336-242b0792788mr291538425ad.22.1754915686551;
        Mon, 11 Aug 2025 05:34:46 -0700 (PDT)
Received: from sidongui-MacBookPro.local ([175.195.128.78])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241e899adc3sm273742055ad.118.2025.08.11.05.34.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 05:34:46 -0700 (PDT)
Date: Mon, 11 Aug 2025 21:34:40 +0900
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Benno Lossin <lossin@kernel.org>
Cc: Daniel Almeida <daniel.almeida@collabora.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Miguel Ojeda <ojeda@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Jens Axboe <axboe@kernel.dk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/4] rust: io_uring: introduce rust abstraction
 for io-uring cmd
Message-ID: <aJnjYPAqA6vtn9YH@sidongui-MacBookPro.local>
References: <aJWfl87T3wehIviV@sidongui-MacBookPro.local>
 <DBWX0L4LIOF6.1AVJJV0SMDQ3P@kernel.org>
 <aJXG3wPf9W3usEj2@sidongui-MacBookPro.local>
 <DBXTJQ27RY6K.1R6KUNEXF008N@kernel.org>
 <aJdEbFI2FqSCBt9L@sidongui-MacBookPro.local>
 <DBY6DMQYZ2CL.2P0LZO2HF13MJ@kernel.org>
 <aJijj4kiMV9yxOrM@sidongui-MacBookPro.local>
 <81C84BD8-D99C-4103-A280-CFC71DF58E3B@collabora.com>
 <aJiwrcq9nz0mUqKh@sidongui-MacBookPro.local>
 <DBZ0O49ME4BF.2JFHBZQVPJ4TK@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DBZ0O49ME4BF.2JFHBZQVPJ4TK@kernel.org>

On Sun, Aug 10, 2025 at 10:06:21PM +0200, Benno Lossin wrote:
> On Sun Aug 10, 2025 at 4:46 PM CEST, Sidong Yang wrote:
> > On Sun, Aug 10, 2025 at 11:27:12AM -0300, Daniel Almeida wrote:
> >> > On 10 Aug 2025, at 10:50, Sidong Yang <sidong.yang@furiosa.ai> wrote:
> >> > 
> >> > On Sat, Aug 09, 2025 at 10:22:06PM +0200, Benno Lossin wrote:
> >> >> On Sat Aug 9, 2025 at 2:51 PM CEST, Sidong Yang wrote:
> >> >>> On Sat, Aug 09, 2025 at 12:18:49PM +0200, Benno Lossin wrote:
> >> >>>> We'd need to ensure that `borrow_pdu` can only be called if `store_pdu`
> >> >>>> has been called before. Is there any way we can just ensure that pdu is
> >> >>>> always initialized? Like a callback that's called once, before the value
> >> >>>> is used at all?
> >> >>> 
> >> >>> I've thought about this. As Celab said, returning `&mut MaybeUninit<[u8;32]> is
> >> >>> simple and best. Only driver knows it's initialized. There is no way to
> >> >>> check whether it's initialized with reading the pdu. The best way is to return
> >> >>> `&mut MaybeUninit<[u8;32]>` and driver initializes it in first time. After 
> >> >>> init, driver knows it's guranteed that it's initialized so it could call 
> >> >>> `assume_init_mut()`. And casting to other struct is another problem. The driver
> >> >>> is responsible for determining how to interpret the PDU, whether by using it
> >> >>> directly as a byte array or by performing an unsafe cast to another struct.
> >> >> 
> >> >> But then drivers will have to use `unsafe` & possibly cast the slice to
> >> >> a struct? I think that's bad design since we try to avoid unsafe code in
> >> >> drivers as much as possible. Couldn't we try to ensure from the
> >> >> abstraction side that any time you create such an object, the driver
> >> >> needs to provide the pdu data? Or we could make it implement `Default`
> >> >> and then set it to that before handing it to the driver.
> >> > 
> >> > pdu data is [u8; 32] memory space that driver can borrow. this has two kind of
> >> > issues. The one is that the array is not initialized and another one is it's
> >> > array type that driver should cast it to private data structure unsafely.
> >> > The first one could be resolved with returning `&mut MaybeUninit<>`. And the
> >> > second one, casting issue, is remaining. 
> >> > 
> >> > It seems that we need new unsafe trait like below:
> >> > 
> >> > /// Pdu should be... repr C or transparent, sizeof <= 20
> >> > unsafe trait Pdu: Sized {}
> >> > 
> >> > /// Returning to casted Pdu type T
> >> > pub fn pdu<T: Pdu>(&mut self) -> &mut MaybeUninit<T>
> >> 
> >> Wait, you receive an uninitialized array, and you´re supposed to cast it to
> >> T, is that correct? Because that does not fit the signature above.
> >
> > Sorry if my intent wasn´t clear. More example below:
> >
> > // in rust/kernel/io_uring.rs
> > unsafe trait Pdu: Sized {}
> > pub fn pdu<T: Pdu>(&mut self) -> &mut MaybeUninit<T> {
> >     let inner = unsafe { &mut *self.inner.get() };
> >     let ptr = &raw mut inner.pdu as *mut MaybeUninit<T>; // the cast here
> >     unsafe { &mut *ptr }
> > }
> >
> > // in driver code
> > #[repr(C)] struct MyPdu { value: u64 }
> > unsafe impl Pdu for MyPdu {}
> >
> > // initialize
> > ioucmd.pdu().write(MyPdu { value: 1 });
> >
> > // read or modify
> > let mypdu = unsafe { ioucmd.pdu().assume_init_mut() };
> 
> This is the kind of code I'd like to avoid, since it plans to use
> `unsafe` in driver code (the `unsafe impl` above is also a problem, but
> we can solve that with a derive macro).
> 
> Where are the entrypoints for `IoUringCmd` for driver code? I imagine
> that there is some kind of a driver callback (like `probe`, `open` etc)
> that contains an `Pin<&mut IoUringCmd>` as an argument, right? When is
> it created, can we control that & just write some default value to the
> pdu field?

There is `uring_cmd` callback in `file_operation` at c side. `Pin<&mut IoUringCmd>`
would be create in the callback function. But the callback function could be
called repeatedly with same `io_uring_cmd` instance as far as I know.

But in c side, there is initialization step `io_uring_cmd_prep()`.
How about fill zero pdu in `io_uring_cmd_prep()`? And we could assign a byte
as flag in pdu for checking initialized also we should provide 31 bytes except
a byte for the flag.

Thanks,
Sidong
> 
> ---
> Cheers,
> Benno

