Return-Path: <io-uring+bounces-8741-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 17343B0B70A
	for <lists+io-uring@lfdr.de>; Sun, 20 Jul 2025 18:53:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C2725189448D
	for <lists+io-uring@lfdr.de>; Sun, 20 Jul 2025 16:53:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B41422127B;
	Sun, 20 Jul 2025 16:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="TaLaf4Z1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081BA20E718
	for <io-uring@vger.kernel.org>; Sun, 20 Jul 2025 16:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753030376; cv=none; b=ADDbAygR7aM8aK1zFAe1EnCI3jQ5IV/Fp8uqa/B9vEp0kFOhjT4TChSrhkbNWE2Th+txXDD3RnLOIwG5cbdJXGZs5TgSaYoyq8Hs819g9LW+rRG5dfzGZpfahTD0ItN4lssU2YMYV1osK4agztPypiMlckhhpuSEyvdDLEx3ojo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753030376; c=relaxed/simple;
	bh=4PwpNKH8Q2DpW937AT1LxyRZt2KyM12kPBSFFyk4+9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H/zmzjM1YsnScYDqBDo0QYdtH2tsLhQTcrolGgSBmFG7sfVlU0DV9NO6ScBj/D1dXAhafZ4zCGmENn93GQxV0Yc8//5QBdQZk2CTVDGGR+PiQb6tXhzTf1SEcAuo5L2nnHUZklQJmryWrJ+qoIIto+HGXEtUivbYeQ/KGjmc30k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=TaLaf4Z1; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-23694cec0feso32383705ad.2
        for <io-uring@vger.kernel.org>; Sun, 20 Jul 2025 09:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1753030373; x=1753635173; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5g9J6n730EaRvQ/cS6fHvI1K6/7KH11pjfrToDZxHXI=;
        b=TaLaf4Z1Yyy3Nz179AmU/WHhYuMVea/Xayf2GVu/tV9O500k0s3ZYa3WtFO+T8yVDO
         9R7FU5U2G6exsKfjazjdeM6tT6FITlrjO1XgPtTRo2aCH65rOhPIZvXd+mdkEwbKKVJk
         vOktQekDvi6ohROhn5lP/e33j7ZxG8WYCLUx8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753030373; x=1753635173;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5g9J6n730EaRvQ/cS6fHvI1K6/7KH11pjfrToDZxHXI=;
        b=a1QAHweBHK21wroMBGnJ7Qn184El8xISvfKaBGuwRokr3GT05uEh6V6/0utksWbVhQ
         Q73f+22hd4I+Mo5OCLSgoNeUg9wh5hGL6duW2TECrkhcbdpd2xRwrA6kxUXWmXHEzS2+
         u5Mr2vhSWZPsBbVzVUTrqBkkuEafKbwKJJChgEN1cKsDhcm1sDUu03Bex6Fz2C6Dcnca
         E1/Q+9BLkMt4sOmihWpgxRLgp2RHWEAoH+E5pYw/IS0bs6sqjP5PllwFf8eYF3aqhcn7
         7hVYJwkFi530x6cwqa7TTwNc5gZMuMerERSCtse8gxJ3X/r9LGZyDxcLW9RNCTvnnBsD
         FL1g==
X-Forwarded-Encrypted: i=1; AJvYcCWkZZRpdHbJC57C7N47ZFjJJci+omlw+Uwea6WdoCDA0XOErfMmevXDXSrNE8UAe3fgOaUaQNByPA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3ftVFvqTRBf9xvzqOPcK+tr5gKQuzOAd23wSyJ1NRyKs29f/u
	pYvueh9nQnIRYweEAXXEIHi4ybwZVtpP5dkbiLzY2Ke93ubOiCqehCeTxte7uHMLMY8=
X-Gm-Gg: ASbGnctMbs3dUyMsjG+H7ACJuVQkqaJyw0El1mJWeTIoiqxjZijURtUEmgfKKaYyK57
	sO4cXcmt/ED7Erh24Hcdj58m3TCKTTo2YkEBDzeZFvmattTPojONiohpy1LRyxO4CWvuzctkX3A
	2Efk4rqVkyfR0dbogqlQGoQnQCw9LyBfred2FApXUNb+NwUCvYDw2Qkf1TJUyNmyPwyvV+rVOub
	pdJLSmAsnmzB9mhBJ5ZGNifygcPJbYuuecGPIqFK+V7lM1EpnyLbhQ2fGGFzwqG++yYW1GLlEah
	+QV4+rOR7ChSvOK2w9Mf3JqOn5/X/auEwIVceMQUwojTqou8a6X7w+DEqVdjaRBw2TWxqYiF9IT
	3uVRflJ6+svf2FNVf3pfpL7futyBm/bjnvUvlEBGxJnBlfu/CsjJD
X-Google-Smtp-Source: AGHT+IGu4j0mRiBMJYNMw/BPoiEqpd7qeKKASroav1OqR863hNB3giu6x7o/eqfqqXM0dWh+qfPxbA==
X-Received: by 2002:a17:902:f745:b0:22e:421b:49b1 with SMTP id d9443c01a7336-23e24f9477dmr272435395ad.48.1753030373376;
        Sun, 20 Jul 2025 09:52:53 -0700 (PDT)
Received: from sidongui-MacBookPro.local ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23e3b6d1ce0sm43778065ad.149.2025.07.20.09.52.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Jul 2025 09:52:52 -0700 (PDT)
Date: Mon, 21 Jul 2025 01:52:46 +0900
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
Message-ID: <aH0e3oyKvvOEkFCt@sidongui-MacBookPro.local>
References: <20250719143358.22363-1-sidong.yang@furiosa.ai>
 <CANiq72nWFW-5DFJA31ugMY7v0nRNk6Uyb1KuyJfp0RtxJh3ynQ@mail.gmail.com>
 <aH0UOiu4M3RjrPaO@sidongui-MacBookPro.local>
 <CANiq72kRQ5OF9oUvfbnj+cbXk+tPTmYpVxYofTuCY1a2bcJr3w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72kRQ5OF9oUvfbnj+cbXk+tPTmYpVxYofTuCY1a2bcJr3w@mail.gmail.com>

On Sun, Jul 20, 2025 at 06:41:06PM +0200, Miguel Ojeda wrote:
> On Sun, Jul 20, 2025 at 6:07 PM Sidong Yang <sidong.yang@furiosa.ai> wrote:
> >
> > Although some existing kernel modules already use uring_cmd, they aren’t
> > implemented in Rust. Currently, no Rust code leverages this abstraction,
> > but it will enable anyone who wants to write kernel drivers in Rust using
> > uring_cmd.
> 
> Do you have a concrete user in mind?

Sadly, there isn’t a concrete user yet. I understand that an abstraction by itself
won’t be merged without a real in-tree user.
I’ll identify a suitable kernel module to port to Rust and follow up once I have one.

Thanks,
Sidong

> 
> i.e. I am asking because the kernel, in general, requires a user (in
> mainline) for code to be merged. So maintainers normally don't merge
> code unless it is clear who will use a feature upstream -- please see
> the last bullet of:
> 
>     https://rust-for-linux.com/contributing#submitting-new-abstractions-and-modules
> 
> Thanks!
> 
> Cheers,
> Miguel

