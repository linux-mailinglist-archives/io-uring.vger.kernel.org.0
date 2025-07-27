Return-Path: <io-uring+bounces-8810-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23D1EB130F4
	for <lists+io-uring@lfdr.de>; Sun, 27 Jul 2025 19:34:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4807C1778B1
	for <lists+io-uring@lfdr.de>; Sun, 27 Jul 2025 17:34:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A16B01E5B60;
	Sun, 27 Jul 2025 17:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=daniel.almeida@collabora.com header.b="dOdmwBWy"
X-Original-To: io-uring@vger.kernel.org
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEFD621A426;
	Sun, 27 Jul 2025 17:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753637669; cv=pass; b=l3tMD2QtY2HY+fCzKD8BMoPZMLBUKpED8TRD/IsRz4j43ATCWceEC1aLEXki93K3GtMWh85KffozWob7kUVW7XV/lDcd8kPY3/xKUN++0ZBgPm695eGmoh4nWQH4wSwXRHySiRYQCXjUARFF5vHE75YK3pngAIvEcCZ7yN4gy8M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753637669; c=relaxed/simple;
	bh=vaZVi9JGzmaEuqLuOHnGEW875OUE5MDTLAfJ99AXyC8=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=HxklangePi8/IjtvETcaun1RPng5ts/LAw1uWiWp/n4umAIt9SewRS+G8CUJd5LWalFWexGZ9BHQWdX/JirWkOLEaxBORZbNa0JaYbsbI9I9i4mb/L5N8FY/ommjgazK6QNsW+WbPcuavp+hbhAWOSm6c0fKZ3jewweaI3wZP9g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=daniel.almeida@collabora.com header.b=dOdmwBWy; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
ARC-Seal: i=1; a=rsa-sha256; t=1753637654; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=g+sGYw1DzCBgjA1EC8u7OGhTYqumjeLiWu3Wa87RsfLehNwrItNPZHLkVgMGXN4n/Z1UruhNcn35IQUChierT1oj+n0sMq4ONVmXYOXmPOyVbjbzjTXJqa3jZWsqmlwQzxlF0vYxZPo41fF1uKhiIZVH9X8B2z8UGOS5KjZ0/A4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1753637654; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=okMS3/1S2iNACQoSQsLmd+UrausqQyZ3VLxCRlug4Ms=; 
	b=HOlIvx7X341VP/3GtxvgWDSUAMasnQdTJoSB1DzTP7I9C8NQBWgP6eRGw72FeaLDWhRxI6YjkEAi7VenKaz5ZiwKJtRECnQ0iZ35vqiC/BqYq6/cpEyEQk3cyYgbzxZyAlpwhjYx0GXIb8E/EVPVxbKVmwlIl/Nla1b7AvbmoLo=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1753637654;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:References:To:To:Reply-To;
	bh=okMS3/1S2iNACQoSQsLmd+UrausqQyZ3VLxCRlug4Ms=;
	b=dOdmwBWyQrhrUCXh4MC2c2TLeMP+NRjLcDnwjIgfnJ+z/2COvqlaGap86cftU3lI
	9nQlCVaVhkSvFYccIN2Or9/RhuU6NZn821HMkKHfKG52xIX1LszLiv+EGbhxB46TXdO
	M5HHcACcplAQntvu8aGeU6QRpsuvJdHzrKwg1L6U=
Received: by mx.zohomail.com with SMTPS id 1753637651196383.2365766479402;
	Sun, 27 Jul 2025 10:34:11 -0700 (PDT)
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
Date: Sun, 27 Jul 2025 14:17:05 -0300
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
Message-Id: <CACB1415-0535-4A05-B904-5F388A1F7C08@collabora.com>
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

It=E2=80=99s not something that you introduced. Empty structs are =
problematic when
used in FFI, because  ZSTs are not defined in the C standard AFAIK, =
although
they are supported in some compilers. For example, this is not illegal =
nor UB
in GCC [0]. The docs say:

> The structure has size zero.

This aligns with Rust's treatment of ZSTs, which are also zero-sized, so =
I
don't think this will be a problem, but lets wait for others to chime =
in.

I'll review this tomorrow.

>=20
> Changelog:
> v2:
> * use pinned &mut for IoUringCmd
> * add missing safety comments
> * use write_volatile for read uring_cmd in sample
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


=E2=80=94 Daniel

[0]: https://gcc.gnu.org/onlinedocs/gcc/Empty-Structures.html



