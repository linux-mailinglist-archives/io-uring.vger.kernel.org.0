Return-Path: <io-uring+bounces-8873-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 104E6B1836D
	for <lists+io-uring@lfdr.de>; Fri,  1 Aug 2025 16:12:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 566A41C20F36
	for <lists+io-uring@lfdr.de>; Fri,  1 Aug 2025 14:12:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 998BE26A0C5;
	Fri,  1 Aug 2025 14:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=daniel.almeida@collabora.com header.b="OL1Fwqsx"
X-Original-To: io-uring@vger.kernel.org
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51728269AFB;
	Fri,  1 Aug 2025 14:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754057534; cv=pass; b=tD0XtwrLCnlaaOzwxr2MzVq6TE2bKnt5GrLo+wzSslM8IMU8/15qUFcdFc1eCpZ1tuYY/NZf2okrd6sKFtxTUxiRyyIx7Nc7OJwggEug6TPf9fPSVudeo5clUMiTGUQen6nv+/+Qr1YoZgoneuaae1IZlv7DIXn1o7TLhRwdj8o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754057534; c=relaxed/simple;
	bh=mbAvw5BaTOMePlARO4T6j/krBAXicAuUFKo+Q+lSAIA=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=iPpVZEK5XA2XExjI8yA3Soulm/r1OrK2wNgKwREE6+KEe8GngoGKmLMUiE53Xrj7PBxzeskFFrGW7tGfx3y0N94mja1BCgqLSI4aKwV03yataz/NYWOMExcQUoZ5fYB0RXp4ST9ZE4w96RpT0LuxxG6qLwAe5VZ2ypyGJkUkjvw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=daniel.almeida@collabora.com header.b=OL1Fwqsx; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
ARC-Seal: i=1; a=rsa-sha256; t=1754057521; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=faQ9HD9f/NwSteKdnDkfiVkVUqMlysNzsQ6hgAb270J4d5UTGvI+SIb6+A40Nlxo6MtLH1wIW1c+G016XAixQQxGMkpnuEZYnGQj84XjveXN2XmVjJP1EokZhAXYLVpc3i//GyVthEDdrle6ZnFoOG9KNF/icru/QhC8iX8sb6c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1754057521; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=CBT+TzLa9lSSi6LGbYJzkFfqTalTb4QzGiuD/t/Goa0=; 
	b=F3vcNNPQBHTQ9QVbjMKIFQ/bou6jHwzqdQ83xuQ11IiVkBa6QdbYjXL7xbd5xt++FWbB+qY02gzzpFYqTGIccLIrd7ITGmrUUmYaA9Kk4GO83xnHSeHNVE2Y9yXtT7Zuvx3+9zPB4QO0rwQhFhyVd7CnOEo0p34I9rA2+bGL5A8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1754057521;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:References:To:To:Reply-To;
	bh=CBT+TzLa9lSSi6LGbYJzkFfqTalTb4QzGiuD/t/Goa0=;
	b=OL1Fwqsxftn5LnMXmKeHDV9L1tkLR22uukju1aF7cVFoPUP7qCFocUnl0mIm6lsp
	51cNeq2GOmcaQSBm8pHQdbZWwDH+4xwVfhLw31clTAsyqr8NT0LuZNq7k2qCn9nsTtB
	hvom8boRkCCQ5hQAd/tK0ecbnjOIWNMWpbHeE9aQ=
Received: by mx.zohomail.com with SMTPS id 1754057518977842.1352915038811;
	Fri, 1 Aug 2025 07:11:58 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: [RFC PATCH v2 4/4] samples: rust: rust_misc_device: add uring_cmd
 example
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <20250727150329.27433-5-sidong.yang@furiosa.ai>
Date: Fri, 1 Aug 2025 11:11:44 -0300
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
Message-Id: <B650673C-E2C8-4382-A86D-CD44840F5B21@collabora.com>
References: <20250727150329.27433-1-sidong.yang@furiosa.ai>
 <20250727150329.27433-5-sidong.yang@furiosa.ai>
To: Sidong Yang <sidong.yang@furiosa.ai>
X-Mailer: Apple Mail (2.3826.600.51.1.1)
X-ZohoMailClient: External

Hi Sidong,

> On 27 Jul 2025, at 12:03, Sidong Yang <sidong.yang@furiosa.ai> wrote:
>=20
> This patch makes rust_misc_device handle uring_cmd. Command ops are =
like
> ioctl that set or get values in simple way.
>=20
> Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> ---
> samples/rust/rust_misc_device.rs | 34 ++++++++++++++++++++++++++++++++
> 1 file changed, 34 insertions(+)
>=20
> diff --git a/samples/rust/rust_misc_device.rs =
b/samples/rust/rust_misc_device.rs
> index c881fd6dbd08..1044bde86e8d 100644
> --- a/samples/rust/rust_misc_device.rs
> +++ b/samples/rust/rust_misc_device.rs
> @@ -101,6 +101,7 @@
>     c_str,
>     device::Device,
>     fs::File,
> +    io_uring::IoUringCmd,
>     ioctl::{_IO, _IOC_SIZE, _IOR, _IOW},
>     miscdevice::{MiscDevice, MiscDeviceOptions, =
MiscDeviceRegistration},
>     new_mutex,
> @@ -114,6 +115,9 @@
> const RUST_MISC_DEV_GET_VALUE: u32 =3D _IOR::<i32>('|' as u32, 0x81);
> const RUST_MISC_DEV_SET_VALUE: u32 =3D _IOW::<i32>('|' as u32, 0x82);
>=20
> +const RUST_MISC_DEV_URING_CMD_SET_VALUE: u32 =3D _IOR::<i32>('|' as =
u32, 0x83);
> +const RUST_MISC_DEV_URING_CMD_GET_VALUE: u32 =3D _IOW::<i32>('|' as =
u32, 0x84);
> +
> module! {
>     type: RustMiscDeviceModule,
>     name: "rust_misc_device",
> @@ -190,6 +194,36 @@ fn ioctl(me: Pin<&RustMiscDevice>, _file: &File, =
cmd: u32, arg: usize) -> Result
>=20
>         Ok(0)
>     }
> +
> +    fn uring_cmd(
> +        me: Pin<&RustMiscDevice>,

=E2=80=9Cme=E2=80=9D ?

> +        io_uring_cmd: Pin<&mut IoUringCmd>,
> +        _issue_flags: u32,
> +    ) -> Result<i32> {
> +        dev_info!(me.dev, "UringCmd Rust Misc Device Sample\n");
> +
> +        let cmd =3D io_uring_cmd.cmd_op();
> +        let cmd_data =3D io_uring_cmd.sqe().cmd_data().as_ptr() as =
*const usize;
> +
> +        // SAFETY: `cmd_data` is guaranteed to be a valid pointer to =
the command data
> +        // within the SQE structure.

This is what core::ptr::read_volatile says:

Safety
Behavior is undefined if any of the following conditions are violated:
    =E2=80=A2 src must be valid for reads.
    =E2=80=A2 src must be properly aligned.
    =E2=80=A2 src must point to a properly initialized value of type T.

You must prove that the pre-conditions above are fulfilled here.

> +        // FIXME: switch to read_once() when it's available.
> +        let addr =3D unsafe { core::ptr::read_volatile(cmd_data) };

So drivers have to write =E2=80=9Cunsafe=E2=80=9D directly? It isn=E2=80=99=
t forbidden, but
we should try our best to avoid it.

> +
> +        match cmd {
> +            RUST_MISC_DEV_URING_CMD_SET_VALUE =3D> {
> +                me.set_value(UserSlice::new(addr, 8).reader())?;
> +            }
> +            RUST_MISC_DEV_URING_CMD_GET_VALUE =3D> {
> +                me.get_value(UserSlice::new(addr, 8).writer())?;
> +            }
> +            _ =3D> {
> +                dev_err!(me.dev, "-> uring_cmd not recognised: {}\n", =
cmd);
> +                return Err(ENOTTY);
> +            }
> +        }
> +        Ok(0)
> +    }
> }
>=20

Who calls this function?

> #[pinned_drop]
> --=20
> 2.43.0
>=20
>=20

=E2=80=94 Daniel


