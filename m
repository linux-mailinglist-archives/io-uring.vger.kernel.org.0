Return-Path: <io-uring+bounces-8742-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E8EBFB0B710
	for <lists+io-uring@lfdr.de>; Sun, 20 Jul 2025 19:01:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61D193BC52A
	for <lists+io-uring@lfdr.de>; Sun, 20 Jul 2025 17:00:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A86719CD17;
	Sun, 20 Jul 2025 17:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c7LTL8fJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28AA4317D;
	Sun, 20 Jul 2025 17:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753030867; cv=none; b=c3cG5vTmuwPPv1GzGm2Pr/LlU7adVoY08wwXDMZkZbYVOJ5y7CEXlz3Gc7uoGi6i5unh0DTy/kkH0OmsClhjnZ9MCXtbVT7fxDTDHUUfIId/qZeQwlxponGB3gQBCbPbZXWASbNmKOCLsXM2zCZytJtA+DIy6HxdJ3hYbDfy7Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753030867; c=relaxed/simple;
	bh=qU3XxxE0RplRFm28wH4KM43ddmXfQRaAHRKn3hWWYFc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f4qpxfJUq601RSeMvFCgLPI3+kI8NKDho9L9L8qUwkJvhg99rvdtg6jEUJJHPQgD0JsFICCJXMC5WmMJR1g0XUmFM4tRZiLnNXqSYk3oQZym6lUdGSsm4L8u/p7RB4rhQfJTR/YOk8GBTNI25+fMyIP47epwwAwURaX9e+zdIQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c7LTL8fJ; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-312efc384fcso670064a91.3;
        Sun, 20 Jul 2025 10:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753030865; x=1753635665; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qU3XxxE0RplRFm28wH4KM43ddmXfQRaAHRKn3hWWYFc=;
        b=c7LTL8fJ9yXssrSvmKF23cl5W76xqk2INgu+yX/STBsWGWddqUEpmKDFBg9h4mXj8S
         fQUF5GPp0OoqUV/HFOlfn1qqYzKApUtWHs0CnVSEGllRi1wXJ2GeYiYLzc8Xi4yKyzow
         0GgHlIuxrUK/00JOUyUwQquztujB+qUj4WGdoDTuTXm8uDBeRomL+FUz81mDLcRZtLdm
         zrDBtqpd0l7EC0xgs179AnOsq8KXWnhuP5Nr26QY2nU3LziuUWd8pEXoa7VwVTuu0Zvt
         v/lIpXtiJBU2EjXXkkaJ1dm7jpxTEKMLdEsJwfSefNmoicnZZCEDa13Rr8KiysqCQZgJ
         uYlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753030865; x=1753635665;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qU3XxxE0RplRFm28wH4KM43ddmXfQRaAHRKn3hWWYFc=;
        b=kT2jHaI/nHtK4VBZDFkwzol086PSlikKAEU097YyGpIewkBgJ86dcf0XxS7rYWcPKm
         rDh0b/IHzPwqUygKZ7Xw1u4nAEvq+04YXcOageGXfTA1qGlXezygu4+WTQ3r3ZJ9aK4D
         NPs3yGzvzliYoekfHQ/dMcMQO3Zf/RtEf9fKf5BFye2qgQxs1QUJhYRpo93KTVYLpvS7
         5iFucd+U9wIayqcXOdu5zsmlyXa2U8ShCSMeHqGiUW3cMY38spLx0quSaTVw60sjOH1d
         DWS7byeWJ1UOhtMgxlUOjpCfo0QsGDD0xb36GkrUhLRx2WSCax9OejP/IIVcZCrLXzhT
         aRxA==
X-Forwarded-Encrypted: i=1; AJvYcCVSaSPfNtJn4eRNOmJUc/MrX5PKrcCf01QSL2EY+2ecVfRakCuF+RaTAHVZ+SXyOJ12aBfUd57cMi09payn@vger.kernel.org, AJvYcCWYCfiSwjn4cXc9ZchHUFD5pmNFzgEDzuMOht8AYKWrvsxjnd0zoYUYDfKxcmPAuiwZZmpZYkpdPw==@vger.kernel.org, AJvYcCXO5RgCOW8rnEu8Gfu8JvPnwqhfMjoaJjWc0/Jf9zaGleSMBUyHNcHsVhl2c/AzPiLlrXnSFnb7Xq0V+vYk6Ac=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+rn4GFnkRUVDHi+f2GZEPjmok+jKir0Dlb4/bHKFOZ1irMUES
	CoqN2jk99w0TuEMSjAdcfCcSol0gjdvcBgzI7Jn0IDvKTV5MfnFj6FhAT7H7iNQLQMLuYAV/sxy
	7V9Ql2JANsM4kVaxUA7NKf/KMTuP6oZY=
X-Gm-Gg: ASbGncu9RNUUzZs228FDYz0zLntWp+JeUaeiPH/2AdprNYnucFqjW/eHZ/UT8QXkf8g
	IoIEO3Ud07PceYwGv4l28tIDJmWyWoA9iAoVF5Jn9UrcelmJRScyzL9uYZXFz27exuE5/iMkAvJ
	9N+1mNuv6Ew19EAoC2NgWBCViqDa/qXbOb4P44D0+AeSiGyNBCq+Kxg4dvbP4M+JV66XPXQP68L
	xTilOeE
X-Google-Smtp-Source: AGHT+IHUtL1e3Hg5/rKlw/2CVoF9SPNlDamcRb09ysakMBQyCP/UF94gA5Yl0xlkr99I8TO8TXIuIXr8wGKno2J2Foo=
X-Received: by 2002:a17:90b:57cf:b0:311:a314:c2c9 with SMTP id
 98e67ed59e1d1-31c9e6e5debmr10559151a91.1.1753030864796; Sun, 20 Jul 2025
 10:01:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250719143358.22363-1-sidong.yang@furiosa.ai>
 <CANiq72nWFW-5DFJA31ugMY7v0nRNk6Uyb1KuyJfp0RtxJh3ynQ@mail.gmail.com>
 <aH0UOiu4M3RjrPaO@sidongui-MacBookPro.local> <CANiq72kRQ5OF9oUvfbnj+cbXk+tPTmYpVxYofTuCY1a2bcJr3w@mail.gmail.com>
 <aH0e3oyKvvOEkFCt@sidongui-MacBookPro.local>
In-Reply-To: <aH0e3oyKvvOEkFCt@sidongui-MacBookPro.local>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 20 Jul 2025 19:00:51 +0200
X-Gm-Features: Ac12FXxdLEnNfSeXeWBCm5oXAgdrvMcl9zxBw3UPtBI3b2A1aF5Kf-AbUG3pOYE
Message-ID: <CANiq72mUAZhKQbUpa01LxMp56RDYHjB=h7zJX2z38qzpU7yZkg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] rust: miscdevice: abstraction for uring-cmd
To: Sidong Yang <sidong.yang@furiosa.ai>
Cc: Miguel Ojeda <ojeda@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	io-uring@vger.kernel.org, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 20, 2025 at 6:52=E2=80=AFPM Sidong Yang <sidong.yang@furiosa.ai=
> wrote:
>
> Sadly, there isn=E2=80=99t a concrete user yet. I understand that an abst=
raction by itself
> won=E2=80=99t be merged without a real in-tree user.
> I=E2=80=99ll identify a suitable kernel module to port to Rust and follow=
 up once I have one.

Sounds good, thanks!

(Just in case: maintainers may or may not want to have an equivalent
Rust module for a C one, it is up to them. In that case,
https://rust-for-linux.com/rust-reference-drivers may help.).

Cheers,
Miguel

