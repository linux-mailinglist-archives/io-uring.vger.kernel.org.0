Return-Path: <io-uring+bounces-8897-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F306CB1E291
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 08:56:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DDE3C18C01B2
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 06:56:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D8AF218ACC;
	Fri,  8 Aug 2025 06:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="LiKydgnT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96564214228
	for <io-uring@vger.kernel.org>; Fri,  8 Aug 2025 06:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754636190; cv=none; b=cQIgyRGVe4W7t7is71WXearxWtyuqY04VYC+m+8vNUmO8k6fJG80+tSDdD/4tORE9kQrMAGlOAsiQqY1pNKdP+f5l5qcz/oxzzO/TDJIheAXiZXjl9YEeXb1gnqNt9cwPGin7Evhe3X3PgrJEs4TemSAbyF7T5l2hi4pya9/bEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754636190; c=relaxed/simple;
	bh=WsMFsX9rI/MR4482dUjWIW9KG1CwbzogAuN1PmMV95U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VC7coqhg8D//cHmVfn6sXlrFEe80OY3DNFMC6sRH7hRTJoAgQnhEqPrt6UgCHJjLQThsXg3uiG+yX/WCfn/PxSNYsCCCcFjWWkMRv6vQgi6WsZeiHEEeyIgcEelMArICU0mDLvuOBdyQZ9H5FxT98zkG2jwhHd6SBVcNHpw0sKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=LiKydgnT; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-76bed310fa1so1617457b3a.2
        for <io-uring@vger.kernel.org>; Thu, 07 Aug 2025 23:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1754636189; x=1755240989; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EhfcZbysLPTN6Dd84Mx3cVIHOXMMLtVJ6fpljAwuNzE=;
        b=LiKydgnTx3QDtkx+siqOcq6MTmjCYhVHb7Ke7Y5KffEBajDbgW3VyZD4NnPgaXd19l
         /vcZof/+AdoAvekR7919IjcXVzN50/vtNEoeMVcvH0f3j5TZ6zYWW6P9Bh4SXcq0vFs0
         YvwZeEy9lehSGsQeGfKklUTE3/MS4N7DqsN9w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754636189; x=1755240989;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EhfcZbysLPTN6Dd84Mx3cVIHOXMMLtVJ6fpljAwuNzE=;
        b=gXfZwIhdIJPWjDCzokr7lVSfrWPBSzEhZLbIV2cjXSQkdsnbEevj1FTcw/VrsBcCSE
         HdpLIKcBVsuKxzRmpJAjPsZFLbs61JKD7uNgjjvQuxy0HKw6lbpeDTkJCeWdNBbMeEH7
         iCpSTwfxR2ysNeGhPE7tSQt7twErxiaMmSkcPRjxTluKFZlw2nuRL1ndyWYCf+g8Kv1c
         T1AZr0tHS7T4DAIAnABhuqfUOyVi71KySHk0D03I8RdoxidKPpcB29P4kTAC0UCUMvaN
         wccI5K6BYOuGTMa7r2cOvE2vc7dU9rn2A1dZJnouhTa1P7pSHxCLa1Xp6eewjCW2yszK
         2bNA==
X-Forwarded-Encrypted: i=1; AJvYcCXjD3lIHD5wkamA2lnXBUFWK/bMbpO8hOAxIbL4T+WWXuADPVFRNnogubeNfpw5TlKc/BWXyIHXEw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxNfiMhL6KK9rtpACVPU2DvInsSozvp/txET6Si8fqm4MGHzzuU
	aGIF7SS6+t5sG8qAgaWgv0MvAaqCZ+x9QASQUgS/Jw5LU04PfZPiZFEckTGMDTi8FC0=
X-Gm-Gg: ASbGncuMYS2PPbCLHwKWZy70JU91v/Pk6ZVBZ74ldCeh7BZW7HaEmvneUjLXoaZjswG
	6OHLTR0E3I2fB0BzY+JFulkoZxU4/gTMKYv8jhao1HuXfMZ+UVJLh9jyUPWMn+lCkTLK3JpNzxi
	gAYamxaep1GWV8zKd1vT3GHH5jbHe6v8iRKuP41uYOe300kgSLWWaxsA5/qmVNvupKhwtcbSSv0
	1b7csbOL/K7UGH/KjAeYqtPyzLsBzwVYaWLvi5wNQofbojfb4uS8op91oyvVnlg470OiqQD/JcH
	RGaJmbGnkgKV6+ixlNRBxNtExVCfGoAfZM7PIz4jSd4z/HzzhHy0BeOzZqwp0XAeV+oT7qfihzN
	ObzoR4UtifgDWjz0TqEvqfS4xVQmDZ63Y40+ljc9d4Yrk4K/kkDJltKf/GRle6Q==
X-Google-Smtp-Source: AGHT+IE3hAqzLrTBhTY5Ya+9CrhJfIsOJHOrILP0ExPfcok2Clc4Gt9jHoPD5aDn4VtBNA+4A8gs8A==
X-Received: by 2002:a05:6a00:230b:b0:740:afda:a742 with SMTP id d2e1a72fcca58-76c45fccf09mr2710386b3a.0.1754636188680;
        Thu, 07 Aug 2025 23:56:28 -0700 (PDT)
Received: from sidongui-MacBookPro.local ([175.195.128.78])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76c2ea6893csm5448866b3a.104.2025.08.07.23.56.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Aug 2025 23:56:28 -0700 (PDT)
Date: Fri, 8 Aug 2025 15:56:23 +0900
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
Message-ID: <aJWfl87T3wehIviV@sidongui-MacBookPro.local>
References: <20250727150329.27433-1-sidong.yang@furiosa.ai>
 <20250727150329.27433-3-sidong.yang@furiosa.ai>
 <D6CDE1A5-879F-49B1-9E10-2998D04B678F@collabora.com>
 <DBRVVTJ5LDV2.2NHTJ4S490N8@kernel.org>
 <949A27C5-1535-48D1-BE7E-F7E366A49A52@collabora.com>
 <DBVDWWHX8UY7.TG5OHXBZM2OX@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DBVDWWHX8UY7.TG5OHXBZM2OX@kernel.org>

On Wed, Aug 06, 2025 at 03:38:24PM +0200, Benno Lossin wrote:
> On Wed Aug 6, 2025 at 2:38 PM CEST, Daniel Almeida wrote:
> > Hi Benno,
> >
> >> On 2 Aug 2025, at 07:52, Benno Lossin <lossin@kernel.org> wrote:
> >> 
> >> On Fri Aug 1, 2025 at 3:48 PM CEST, Daniel Almeida wrote:
> >>>> On 27 Jul 2025, at 12:03, Sidong Yang <sidong.yang@furiosa.ai> wrote:
> >>>> +    #[inline]
> >>>> +    pub fn pdu(&mut self) -> &mut MaybeUninit<[u8; 32]> {
> >>> 
> >>> Why MaybeUninit? Also, this is a question for others, but I don´t think
> >>> that `u8`s can ever be uninitialized as all byte values are valid for `u8`.
> >> 
> >> `u8` can be uninitialized. Uninitialized doesn't just mean "can take any
> >> bit pattern", but also "is known to the compiler as being
> >> uninitialized". The docs of `MaybeUninit` explain it like this:
> >> 
> >>    Moreover, uninitialized memory is special in that it does not have a
> >>    fixed value ("fixed" meaning "it won´t change without being written
> >>    to"). Reading the same uninitialized byte multiple times can give
> >>    different results.
> >> 
> >> But the return type probably should be `&mut [MaybeUninit<u8>; 32]`
> >> instead.
> >
> >
> > Right, but I guess the question then is why would we ever need to use
> > MaybeUninit here anyways.
> >
> > It's a reference to a C array. Just treat that as initialized.
> 
> AFAIK C uninitialized memory also is considered uninitialized in Rust.
> So if this array is not properly initialized on the C side, this would
> be the correct type. If it is initialized, then just use `&mut [u8; 32]`.

pdu field is memory chunk for driver can use it freely. The driver usually
saves a private data and read or modify it on the other context. using
just `&mut [u8;32]` would be simple and easy to use.

> 
> ---
> Cheers,
> Benno

