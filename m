Return-Path: <io-uring+bounces-8809-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 19FA1B130E3
	for <lists+io-uring@lfdr.de>; Sun, 27 Jul 2025 19:17:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2C9131897C93
	for <lists+io-uring@lfdr.de>; Sun, 27 Jul 2025 17:18:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C27F15E5C2;
	Sun, 27 Jul 2025 17:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=daniel.almeida@collabora.com header.b="Weriryb1"
X-Original-To: io-uring@vger.kernel.org
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02EE81724;
	Sun, 27 Jul 2025 17:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753636670; cv=pass; b=YNOF4pgkK20SS62tD+OwDKHEBwnPonjfQ3+ftxRtLBepKiB+eLh2T38oRwRsD52xkYVGJBf6m6XovROSUMJf+3KRYqOs/elI/jl8R5jWJUApeoGnebj+2BwhelVB1p64aynQb+CCCRAd3b1183aGa7KIZZ+/vf6VkffnXoRaJSQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753636670; c=relaxed/simple;
	bh=vaZVi9JGzmaEuqLuOHnGEW875OUE5MDTLAfJ99AXyC8=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=NNkl0C4MQUjVh7SHDv9cCpfiY2yPhEcCGJ9k7+rGvO2rSX0zQbpyLVoHrFJi8MJxcMgkiHIOD0rIb+OPeuCevkd2SOG4PQei9hFomZm/3dOI1vLVBteF62x3vgofxsmVHumF6ssFksM+x4NlTUYFOKDpVFntV06f95ZCkmuUwXU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=daniel.almeida@collabora.com header.b=Weriryb1; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
ARC-Seal: i=1; a=rsa-sha256; t=1753636655; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=B577dRGqexhbKFmKh+c69nTrdBqUCCXicwKcYtjllSgUPia1A+RpsvEa5dNFH7ub56m5wOK65Wz1xVqWkG3DLUN6QwOwQydpU9weSmRda4GotE4ccPtSziT8vuUXvUHmhEMxvTxnJFqrd8zItRZuIiZU2rGW/BCNxpLehAgLeMw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1753636655; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=okMS3/1S2iNACQoSQsLmd+UrausqQyZ3VLxCRlug4Ms=; 
	b=NE1vKRizRodnTf1W7Oq3r07FzpGNG9cUdtd1U1S5E7eQVnxzLFbeZ8OF6/GBdqUMX8PRKXxrJuUIg7sBmZolObyKCtyBspNuUI+2BSt/XtGC6PDq/tub/pDTYH45/aQD8A5t6jvMsz6+oMqHrWAbocYJbEODCvjAGJsjtoNVbbA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1753636655;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:References:To:To:Reply-To;
	bh=okMS3/1S2iNACQoSQsLmd+UrausqQyZ3VLxCRlug4Ms=;
	b=Weriryb14hInS3N7Krl4CI3aHdf5FK6q9ZytzElz+vDWBe7pDHn4dHgHFg/HGagm
	Eu9ID4K+8gwbV4KbwjvPDU/5mh0V7W+Tcanica7FkNs+0fWj1doJeSOsvY3g5BxFVuY
	9uE9WsZ0XfE27kbF+V4TG3LdZrYEy1w3waXIWuts=
Received: by mx.zohomail.com with SMTPS id 1753636652954912.0321119634177;
	Sun, 27 Jul 2025 10:17:32 -0700 (PDT)
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



