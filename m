Return-Path: <io-uring+bounces-8927-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 74C69B1FA49
	for <lists+io-uring@lfdr.de>; Sun, 10 Aug 2025 15:50:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 67FDD189471D
	for <lists+io-uring@lfdr.de>; Sun, 10 Aug 2025 13:50:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E647224886F;
	Sun, 10 Aug 2025 13:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="U6melqi+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B5A8F54
	for <io-uring@vger.kernel.org>; Sun, 10 Aug 2025 13:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754833827; cv=none; b=rVvXU2z+zDR/g2mXvuFWonyv/2Pudv988vET9A8FhWfO2wpYf9aFy1QVhx6woNZ/ynHOrNuJIzrQWhnbPz4w2BzbLauNz1vaav3CLqOsYLO0kv9b6cTE2MJndjvvkDcQbc0EGgB3iX/sebo21gLShN08B9wNSDCBPT8TwDbNZFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754833827; c=relaxed/simple;
	bh=p7BsbrGAmeMQfqoDvx2nZTX6wg9kIycv6VZ0kixKOJw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fuQs1IKCRWnTCwklIdrZTSNQn3B1yCY0EIAi2V1OhwImiZvDgyDlsbyxTyu6r+blHL5LFEDYF9Vw10w1FJuq2fCAjrIbvgsYJsiFhASvXqS8I+RQs611mTQNcIx/bDli+YWD9F0SfB/u6NFVykN++cB2Gt03ecnBSW1H/JnlLOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=U6melqi+; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-240418cbb8bso22205385ad.2
        for <io-uring@vger.kernel.org>; Sun, 10 Aug 2025 06:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1754833826; x=1755438626; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uEJoriNDa5rnMjLc9ZXlpdYdb6v5lPl2Mbkc+ZGNcbk=;
        b=U6melqi+MzSUKfUE9ovqN5bJ23rejO1JDxIecibUEd3O8cx6TTnvxd+61g97jj6DSq
         a9VT8lm5r2EmVgvFUDggjsKY6iIoqGU753Sm25+LDER5n0rahvDWu5j/E1m/OLg4BgeM
         +EXpm+hArXaHO2TP7dvmu2FQDEn9nJYlUWUJo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754833826; x=1755438626;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uEJoriNDa5rnMjLc9ZXlpdYdb6v5lPl2Mbkc+ZGNcbk=;
        b=q41X4a9pvZ4ZePghxqU/KtN2rmBIBXl9Pq5lmjxBlrIdZFntaB4tgGup3zC91Ql4bU
         TFBk3opYFFZE7WoVwmCFIC5LhoLAvrF1fOyf1nYGAch/KIwWXIlpbXW+MWL43vPkYJLw
         92yiDrbUKMwotMQ2jmA0Oq0FQHvpCMuCHLLGI5jIinIAlB3X0Qs5NMQzVNsQq+hj1gvA
         36MOK13uuJNY97sW19n1ZsbjIVmtiYw6Ql8J0uoO2BWo3icgc+wxmI/M1iVSj9Og9AQT
         3EX6W01D9mGgEHjXJkoCRSRwuCOXEUAQH5z7/KIpVImcC5YLP3MRAraywNyAG0HZuGgw
         I5Jg==
X-Forwarded-Encrypted: i=1; AJvYcCUnOfpXobTA14VAQF2JwnhJSNAgQrq+oPDnS/dmeOrRin5m9fOMVVsLe9Tp9teRo0kAyBtlbbe2sg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzU7/5DrK1I7/6MNhMaQaVJSyvNO1FXDqA2uneEsYNmFp5EKgbu
	1tVmxjmgbym7wFzHNeEGVj0qlsltu/jgvv8XMy0/F3XG+85Xtvhw9ZfZ56HrjmytQBg=
X-Gm-Gg: ASbGncvvF2KWfixnuDTJnJ8u03Y2a8AKSNj5sq6Ip6g75aHHXzet8JqxNhbtNtbf+5w
	GNYifNz6i9YTpjTi8MiGNXiwsNeEd3SrKnVv4xLgPvWmN1hZcFjS0p9yS1Ht/7fEkMZGUwCTkr5
	1EPuvxp2nispj88AlqO9HvZCQMLsS3midnppeMZgHdw7J2dVg1UmAB3zHfSvE0is4SxKXt2ck31
	JnNgk5byp0dBLCDhuZoBZqa6V1k74o/ME/U7Ct/k0hZhqXyHBKs/LsTANRpMJ8BjsuqUfM13wn8
	Bp5YJYFza4Jf1uCtE3clXIOHLRdnaVBAzBZ96LWWnMvXBYGByWF/JGWN1S+xspmP7TE0jf/iQ/H
	xr3h8A3m/anc7qnBUECq1KS0vEqnvAdE25EMqkGvmws6C4JTb9uwS/BDQ
X-Google-Smtp-Source: AGHT+IENp31HkWj826CiJ1+k4dxYMOt11EipK3CH7vyGbmZkeyW3/TjnLaKgr24R7x7nzGfXFeZ0iQ==
X-Received: by 2002:a17:902:d486:b0:240:a21c:89a6 with SMTP id d9443c01a7336-242c2003830mr150469815ad.12.1754833825790;
        Sun, 10 Aug 2025 06:50:25 -0700 (PDT)
Received: from sidongui-MacBookPro.local ([175.195.128.78])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1ef7557sm249307295ad.19.2025.08.10.06.50.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Aug 2025 06:50:25 -0700 (PDT)
Date: Sun, 10 Aug 2025 22:50:07 +0900
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Benno Lossin <lossin@kernel.org>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Miguel Ojeda <ojeda@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Jens Axboe <axboe@kernel.dk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/4] rust: io_uring: introduce rust abstraction
 for io-uring cmd
Message-ID: <aJijj4kiMV9yxOrM@sidongui-MacBookPro.local>
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
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DBY6DMQYZ2CL.2P0LZO2HF13MJ@kernel.org>

On Sat, Aug 09, 2025 at 10:22:06PM +0200, Benno Lossin wrote:
> On Sat Aug 9, 2025 at 2:51 PM CEST, Sidong Yang wrote:
> > On Sat, Aug 09, 2025 at 12:18:49PM +0200, Benno Lossin wrote:
> >> We'd need to ensure that `borrow_pdu` can only be called if `store_pdu`
> >> has been called before. Is there any way we can just ensure that pdu is
> >> always initialized? Like a callback that's called once, before the value
> >> is used at all?
> >
> > I've thought about this. As Celab said, returning `&mut MaybeUninit<[u8;32]> is
> > simple and best. Only driver knows it's initialized. There is no way to
> > check whether it's initialized with reading the pdu. The best way is to return
> > `&mut MaybeUninit<[u8;32]>` and driver initializes it in first time. After 
> > init, driver knows it's guranteed that it's initialized so it could call 
> > `assume_init_mut()`. And casting to other struct is another problem. The driver
> > is responsible for determining how to interpret the PDU, whether by using it
> > directly as a byte array or by performing an unsafe cast to another struct.
> 
> But then drivers will have to use `unsafe` & possibly cast the slice to
> a struct? I think that's bad design since we try to avoid unsafe code in
> drivers as much as possible. Couldn't we try to ensure from the
> abstraction side that any time you create such an object, the driver
> needs to provide the pdu data? Or we could make it implement `Default`
> and then set it to that before handing it to the driver.

pdu data is [u8; 32] memory space that driver can borrow. this has two kind of
issues. The one is that the array is not initialized and another one is it's
array type that driver should cast it to private data structure unsafely.
The first one could be resolved with returning `&mut MaybeUninit<>`. And the
second one, casting issue, is remaining. 

It seems that we need new unsafe trait like below:

/// Pdu should be... repr C or transparent, sizeof <= 20
unsafe trait Pdu: Sized {}

/// Returning to casted Pdu type T
pub fn pdu<T: Pdu>(&mut self) -> &mut MaybeUninit<T>

I think it is like bytemuck::Pod trait. Pod meaning plain old data.

Thanks,
Sidong


> 
> ---
> Cheers,
> Benno

