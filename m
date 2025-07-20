Return-Path: <io-uring+bounces-8738-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 86A6BB0B6D7
	for <lists+io-uring@lfdr.de>; Sun, 20 Jul 2025 18:07:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF77418982C2
	for <lists+io-uring@lfdr.de>; Sun, 20 Jul 2025 16:08:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A58F521CC4F;
	Sun, 20 Jul 2025 16:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="RI63pXLi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A951ACED7
	for <io-uring@vger.kernel.org>; Sun, 20 Jul 2025 16:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753027660; cv=none; b=qiitblf65yhA73aq5rOAXT7TLUFFfN+odvX33RyY5YPMJ3MWv3yoTwH1/6XCUnIkw9DRUeR7NG9GwpDz38BidJZhrWJEpS8dn0odkkpzF2dPJSoNI7F83U4DU2M6sxxvS9Zx0V2i5HihFsnTUuPgaqz2/3+9NUpynaDyA8x/RJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753027660; c=relaxed/simple;
	bh=MEAipS7tIqOOORhzOLxJEu3EMaurgTk3P3SmCmKRjYU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nVuptzazVyqcAM65eGP5eQxpqA/TiSVwewFbZquhekxuspgYFv5dbA+vTVqTC+I2AeHBSCuCHbhVn5mHGiR2wSUJn/kskvQkJ2Dhpv5p+8NsBIRZtLhaBh7+dAZzRcXVdMJM2TLSC0TjhGefUGmStZB4UxHZuopkt9tzfwgE4Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=RI63pXLi; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-234fcadde3eso41535075ad.0
        for <io-uring@vger.kernel.org>; Sun, 20 Jul 2025 09:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1753027658; x=1753632458; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Q8RUv7gDQVh9Xv400yvcTGdoBeNmRYOsZZ8FvZTzEiw=;
        b=RI63pXLiCCOy9Jw2OSad2RPSHhlSqt3JwtCVZRvcwQJmG5LOE7r4caeOyyGCfcz67g
         ARyTaKbDPzr2dgmr7abMvGU7OfYa8Tt3HstagpzXbHdlvg700GXSB8t/Dfm7n/MzINnL
         aPWySH7QpZQXQn/6r/PrxV0FJJFcfDP2rRG4o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753027658; x=1753632458;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q8RUv7gDQVh9Xv400yvcTGdoBeNmRYOsZZ8FvZTzEiw=;
        b=cI9Czj3SLC5nVohBzkXVsm3U7w1ICitiAF/pW8LT/MbXnoQ8vJSS1pgR2f38E4wZJ7
         7ShQ3lwCrX0o7gGK1RLgSTGm4U1SKgV710B9QQ288jSIOX9l9fPb1djX1Sg+1msD65S6
         i4NjSfmK4urFmpajzcN3/zSIEqixYW3FMqAIlA231FCV1gQD3Tho4Z9TBPh4tiMMXcv7
         LC3c3NvOQFie/iGSD1AaUaihy5AKBz69sfdvl387Zeutnez0/HZ3QMCH6UEVVz2H4XYz
         R0h07KsC3z7CVa1aIQ+hDTo9AQVcqEe1O+zwPkcnAIOLeyE0Ie2OzdRmiAwF0X95bx1L
         cbnw==
X-Forwarded-Encrypted: i=1; AJvYcCVkTnxw+nlw+8/mFtmiQUR3nr1NhnC7SoD/SCKarkApXCBHMzrm04YNDOsgTVSH8Yqu11GGTnhcHA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxS2OpahV+egGIWFsozDb4AEwChXR+iq7/xJbugMdO5JNMeeDdT
	cM9PmJ2rMatvFDvDcHovZ2cCHo5Kcu5UaPkVbMTN0VbWkS3Fu/XXDwOv6uWxAk4Jg2U=
X-Gm-Gg: ASbGncukaQ2MRiM1iXnJtDEzEX47u/rLA5f8c4u0Ml+FttfVCdoD8sqDQHBPRktGMdq
	a0M0DfGMkFxB/fj4uaefxIlFbBwIddHEMKeh3uO7HMNshx62BdsDWKdp8os32QWXGKIdQ5VSQwK
	8iR00A/PGvu9WmhavT3eqiij6Q49FCS4JVblBz6VWUe6Xnqkw6S6Izw2hnj1TJC3dZoUxBMNZ8h
	PL+JmGo0mfbjf5euUgGAjA4ETjWCpaUj3/8lDwLzcv3GBlSNdOKPdMntINNiiKzkpfDSOn2s3QE
	Jwa0dnAcuwVjiF3WWW+mdTeCsFwz+G5zNWMVGzXdlyXM6oN2WP3e/TlgziIGdkTbEoz6NMcuUCu
	KX4Xa/pSAbKmxtsjGkcHI8SRLvV1gznggJGSRldpFfUZn4n8rx6MF
X-Google-Smtp-Source: AGHT+IGf/MnOq1vbpyuq47JBNkrTX3YVoxz/LvdQ9w+9MydBBoVrrzSdMf5GEBSblzU0JCHK+46alA==
X-Received: by 2002:a17:902:dac9:b0:23d:dd63:2cd9 with SMTP id d9443c01a7336-23e25780c52mr307048635ad.46.1753027658452;
        Sun, 20 Jul 2025 09:07:38 -0700 (PDT)
Received: from sidongui-MacBookPro.local ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23e3b60eabasm43262175ad.54.2025.07.20.09.07.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Jul 2025 09:07:38 -0700 (PDT)
Date: Mon, 21 Jul 2025 01:07:22 +0900
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Jens Axboe <axboe@kernel.dk>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH 0/4] rust: miscdevice: abstraction for uring-cmd
Message-ID: <aH0UOiu4M3RjrPaO@sidongui-MacBookPro.local>
References: <20250719143358.22363-1-sidong.yang@furiosa.ai>
 <CANiq72nWFW-5DFJA31ugMY7v0nRNk6Uyb1KuyJfp0RtxJh3ynQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72nWFW-5DFJA31ugMY7v0nRNk6Uyb1KuyJfp0RtxJh3ynQ@mail.gmail.com>

On Sat, Jul 19, 2025 at 06:34:49PM +0200, Miguel Ojeda wrote:
> On Sat, Jul 19, 2025 at 4:34 PM Sidong Yang <sidong.yang@furiosa.ai> wrote:
> >
> > This patch series implemens an abstraction for io-uring sqe and cmd and
> > adds uring_cmd callback for miscdevice. Also there is an example that use
> > uring_cmd in rust-miscdevice sample.
> 
> Who will be using these?

Hi, Miguel

Although some existing kernel modules already use uring_cmd, they aren’t 
implemented in Rust. Currently, no Rust code leverages this abstraction, 
but it will enable anyone who wants to write kernel drivers in Rust using 
uring_cmd.

Thanks,
Sidong

> 
> Thanks!
> 
> Cheers,
> Miguel

