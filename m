Return-Path: <io-uring+bounces-8874-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 64034B18376
	for <lists+io-uring@lfdr.de>; Fri,  1 Aug 2025 16:14:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 21C6C581433
	for <lists+io-uring@lfdr.de>; Fri,  1 Aug 2025 14:14:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BA6B26A0D5;
	Fri,  1 Aug 2025 14:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=daniel.almeida@collabora.com header.b="W+07vl/q"
X-Original-To: io-uring@vger.kernel.org
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2EF26A1D9;
	Fri,  1 Aug 2025 14:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754057639; cv=pass; b=AAWgbXdFXSwzarutRus7n6HppY7y+LDAemtY8a9ptTnodif84cqecWrTUIIKQQoGW+c6d/UDSniHzJ+guOk0ayTLoJrL25/Sxf+HUHrSscCkcT8h9ZQZSmC6gBxL5Iij89+im1CA6X8tzwXcRU7S9rwaCOSG+Uv7H0Q3zHGc7a8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754057639; c=relaxed/simple;
	bh=0sBN0Z0qD11Bdce2GGUn1pqzfIW4G+IxYD+sS5xgTik=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=nabTJGy6gVtYkYEZepzwGUARCEX4emhL/JVJHtiJg3Shn6+l4A6NFWMhQzgaNAkJslbzOPiyCXuUuKyKDidDwv1a6TZOb74CbrS/LwW0XiIAXieVl0rZ9Qj0AxNp8+MaQ6h3AbL8cRK7RGjp1zKFCJ/HSVp2fZ8MEjj8CKAX5kE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=daniel.almeida@collabora.com header.b=W+07vl/q; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
ARC-Seal: i=1; a=rsa-sha256; t=1754057626; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Ud0DXkeg2wuCidpOgvWrRZC1UvNDt7CxMKVXTJ3b0NUBKqyEmNNQ/QnSzreML4itR8Iwmx89ZQStEa+nVsex1BF9QJp6xBrvIX7mvgYi17t9qf7fd1vSj8ikrJj7e9rSHuLeZvOoH/gzIcsa7dgByVaTDg/BFj/dkM7oF+KHEA8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1754057626; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=nTWJeexliBNM0NTPr3zAFL74Ktscf2CHSD4SWIKTA5Y=; 
	b=YdP3diFmzMp8xs3hmbRpxIS/D5kCYuCzaG0tag5LfdctAQfwMtYHpljWs9mifW+wBYl5V44odVo7I9ACyZbpHszOrwOuB2JLjM7E3l2UNSzCpmMtaxUlDRQ5Nh2vtJ+X/KTbMxjz7rCJYW3NPH2RjQr4fbCZrUmbr+xxZrE1Hks=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1754057626;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:References:To:To:Reply-To;
	bh=nTWJeexliBNM0NTPr3zAFL74Ktscf2CHSD4SWIKTA5Y=;
	b=W+07vl/qks6/RrWWer7sYitaq4TNzI9OtMojyl3XjiO/uqlpusHvQR4messNwXkQ
	VhDAZ8Li9qttEonRA33YGaLB6WZXkI7mm82wzc0GSjRQP1cp6Ji24A/9lwE+camFQjQ
	evYT9RFSUxDjS4c/2hH3fo//aS37OA7fWb8AJ/lo=
Received: by mx.zohomail.com with SMTPS id 1754057624094370.9083390005841;
	Fri, 1 Aug 2025 07:13:44 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: [RFC PATCH v2 0/4] rust: miscdevice: abstraction for uring-cmd
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <20250727150329.27433-1-sidong.yang@furiosa.ai>
Date: Fri, 1 Aug 2025 11:13:29 -0300
Cc: Caleb Sander Mateos <csander@purestorage.com>,
 Benno Lossin <lossin@kernel.org>,
 Miguel Ojeda <ojeda@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>,
 Jens Axboe <axboe@kernel.dk>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <60A6421A-813F-4A93-88AF-4AE3027E1FA3@collabora.com>
References: <20250727150329.27433-1-sidong.yang@furiosa.ai>
To: Sidong Yang <sidong.yang@furiosa.ai>
X-Mailer: Apple Mail (2.3826.600.51.1.1)
X-ZohoMailClient: External

Hi Sidong,

> On 27 Jul 2025, at 12:03, Sidong Yang <sidong.yang@furiosa.ai> wrote:
>=20
> This patch series implemens an abstraction for io-uring sqe and cmd =
and
> adds uring_cmd callback for miscdevice. Also there is an example that =
use
> uring_cmd in rust-miscdevice sample.
>=20
> I received a email from kernel bot that `io_tw_state` is not FFI-safe.
> It seems that the struct has no field how can I fix this?
>=20
> Changelog:
> v2:
> * use pinned &mut for IoUringCmd
> * add missing safety comments
> * use write_volatile for read uring_cmd in sample

Why is v2 an RFC when v1 wasn=E2=80=99t? Can you mention it on the =
changelog?

>=20
> Sidong Yang (4):
>  rust: bindings: add io_uring headers in bindings_helper.h
>  rust: io_uring: introduce rust abstraction for io-uring cmd
>  rust: miscdevice: add uring_cmd() for MiscDevice trait
>  samples: rust: rust_misc_device: add uring_cmd example
>=20
> rust/bindings/bindings_helper.h  |   2 +
> rust/kernel/io_uring.rs          | 183 +++++++++++++++++++++++++++++++
> rust/kernel/lib.rs               |   1 +
> rust/kernel/miscdevice.rs        |  41 +++++++
> samples/rust/rust_misc_device.rs |  34 ++++++
> 5 files changed, 261 insertions(+)
> create mode 100644 rust/kernel/io_uring.rs
>=20
> --=20
> 2.43.0
>=20
>=20

=E2=80=94 Daniel=

