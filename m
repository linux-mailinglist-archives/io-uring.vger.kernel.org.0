Return-Path: <io-uring+bounces-8740-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 996D3B0B703
	for <lists+io-uring@lfdr.de>; Sun, 20 Jul 2025 18:41:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA8B01770F5
	for <lists+io-uring@lfdr.de>; Sun, 20 Jul 2025 16:41:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C17482206B1;
	Sun, 20 Jul 2025 16:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZX2a0jGu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A55C1B423D;
	Sun, 20 Jul 2025 16:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753029681; cv=none; b=qzITAFuWIfzF1PBFI1sR/lTjd9GpHMaj5LP0Oqq3E5VxktLYmuJ2BuaMfokpBUflVIfBMrVyLdkOnV2cq/9/QXM5TpSM3DdOwf99bgzDXxBgUNTEKLDtuxZ6hOMgFAPWbG3oQYRgSfxmcUo5qebTl3wZeHPKoo6/+QshcXnJVqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753029681; c=relaxed/simple;
	bh=xEjlwgbQbOHqNZfDliNEW2Zpgg3sSwA/kbqHZJZ8p2s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qsvxV38SbgNWl8TyLUkTA49Ds7w41p4LnLZ56S1PZq16AGZx7DKYPg3sPpdoC0o0kdkoMEy37UNnqEc2WruWrEVlZ1uZwkiD6A0H2LqAMTKs3pZzzQHNaHujObPFAwDMfBcL8/mZ6704saobtB8KRVX2bYbL1YpivkehTlNyp5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZX2a0jGu; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-313067339e9so750643a91.2;
        Sun, 20 Jul 2025 09:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753029679; x=1753634479; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u2R08B0M6B/bO5Z84OsszAkv0QNGB70mRleYsQvtc0U=;
        b=ZX2a0jGu2A5CjbwH/G08qu2Uup6Th76wRJiLnD+npHoN94DaNrP35uEfDGgkXp5ASm
         w45+WXeEeMuxS447Llfafu4ioO4WxmBlRD06StY0sGsDesoZqLAzzg+Y+BWwv4ZYnOYF
         3cW4QCCmqZ6UBFh3othBXy2FkFC25QhEFRru813mSh/lCJquXpcTezYfsW2gC7otlz+b
         rXsCsbr5jYeFCGdPb69uwm9WV/hr+YiIR+hKb05QWhkrnJgU9Ta/lasjPyv4PEIUYAJq
         zKcBqLL+EU6oDnj2uUwqU58i1HzEu5p5R4Y7jOKd1X/xR0HO8C5S4wlv2bUM/3MA+SGC
         4fOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753029679; x=1753634479;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u2R08B0M6B/bO5Z84OsszAkv0QNGB70mRleYsQvtc0U=;
        b=DVLNV4onzwEHZfM4BP6zPu9iQmk9dk4LaPDnN1lr/KK34OKSo9GVsy96TOmqummCJy
         vI5r/qhD20WYjmmJYUHkwDPXBgzz60ZrExnuhSL9N3Gj8Po+lBLcfIIkiMmDH7eNOPb7
         IjV+71W4JHRa9lvl2ZT79+MFZOy3ekhOvl5XBE3BwfMNzfMvppzFFm2pTj+3I98RlaOV
         UvRM2AUUrwQVx4f+t2f1N2/+8jZzBNdqkm9eJXD1exGQ/eVJz/cRgCdj4yJ2+IGMNC0D
         13kg98poLGVixlxUCFnsDZtejK6lMF55i5fkBB+/LVFyBsIomfwW2Im3KxEaagdrQVpU
         SqOg==
X-Forwarded-Encrypted: i=1; AJvYcCUJUY1T3f0AtR5L7q6pYZf6G8qkUnd4hpGHwaZmPOf+eS+O2hr2DxFODOCSzk3vFr0b1uWF4dqg6g==@vger.kernel.org, AJvYcCUUjOlcxh4Rw12zh2/uHyh9q1YSpiJokqQ8VjvRNxljHYfHxinanJX7ntBsDiT6qPX2OSBIKv/0ONHiDaGg@vger.kernel.org, AJvYcCVGdokTqI2NVkbkrjhFeDs8yswkkW16FpLx8O07iIxRFi/CYz0RXvGMU1K5XqNj933mkdOVEo2AC6/ynome7+8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy68/uA663tSaQ0voXxpGGYNJUd9lAE0oDPbL6xvNZPHVE8fNc7
	cpccIGSOLw83qeR5w+KnsxpXfAR+Xy2uSDF6GB/BUbOLhWK/RosP0G3RPP9tOEuYEdC5xuZg2hu
	b47F5teMrCv+YbJ6mci8WRLPxLZojI3sOtAR52oD0wg==
X-Gm-Gg: ASbGnctylrxDcyMB8LekAuwz6JU77ENjrc3K6wcHD63WWnVojspw+7qLPPW8xi8KNCv
	sJtQxZxaqAIrGU5eHzrZAUGlocLqwK3eHMcsMPZGH4VwXIEEHCdA3A5sy2WP+/22OYIBRYu75rT
	T7qioGd3VZMuGhHiyf7vZrx65/pdWAL87gxMUaZHmCPLqzx5DzyYWlqyqrzjkBjcLTkP3XSGewR
	LilhaYH
X-Google-Smtp-Source: AGHT+IFQqLKqY9GWASRnB+Q22pehsjordJutcnwFOx7nY7UOk4Lymr/qJvDFeYgIvx02ePKyDN8dAq7decQUqdMgnAY=
X-Received: by 2002:a17:90b:4b8b:b0:311:9c9a:58e2 with SMTP id
 98e67ed59e1d1-31c9e798695mr9601871a91.7.1753029678698; Sun, 20 Jul 2025
 09:41:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250719143358.22363-1-sidong.yang@furiosa.ai>
 <CANiq72nWFW-5DFJA31ugMY7v0nRNk6Uyb1KuyJfp0RtxJh3ynQ@mail.gmail.com> <aH0UOiu4M3RjrPaO@sidongui-MacBookPro.local>
In-Reply-To: <aH0UOiu4M3RjrPaO@sidongui-MacBookPro.local>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 20 Jul 2025 18:41:06 +0200
X-Gm-Features: Ac12FXwdnXKdBtzyvJWb4t5_hzaLDwi_JJmL7-sgXMwqrJlQA-Fr-Cu7Jce5-Do
Message-ID: <CANiq72kRQ5OF9oUvfbnj+cbXk+tPTmYpVxYofTuCY1a2bcJr3w@mail.gmail.com>
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

On Sun, Jul 20, 2025 at 6:07=E2=80=AFPM Sidong Yang <sidong.yang@furiosa.ai=
> wrote:
>
> Although some existing kernel modules already use uring_cmd, they aren=E2=
=80=99t
> implemented in Rust. Currently, no Rust code leverages this abstraction,
> but it will enable anyone who wants to write kernel drivers in Rust using
> uring_cmd.

Do you have a concrete user in mind?

i.e. I am asking because the kernel, in general, requires a user (in
mainline) for code to be merged. So maintainers normally don't merge
code unless it is clear who will use a feature upstream -- please see
the last bullet of:

    https://rust-for-linux.com/contributing#submitting-new-abstractions-and=
-modules

Thanks!

Cheers,
Miguel

