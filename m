Return-Path: <io-uring+bounces-8872-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76972B1832C
	for <lists+io-uring@lfdr.de>; Fri,  1 Aug 2025 16:05:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42BF03BB19D
	for <lists+io-uring@lfdr.de>; Fri,  1 Aug 2025 14:05:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F012266EF1;
	Fri,  1 Aug 2025 14:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=daniel.almeida@collabora.com header.b="cMVSnMq/"
X-Original-To: io-uring@vger.kernel.org
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8206426657B;
	Fri,  1 Aug 2025 14:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754057109; cv=pass; b=uRXuR5XfnA0GUJC6erZWTfJ7/Dto1pQaZHGREYY5z0eY1vI10gIfzFd0Ar55YCgY55aYR8b40LEYuoVZRKGb5967Tfyly0I6g72M475dqGYpwDrnpvGCxZJVjj5VTHgl9eKU64P+F94phZ9teX9VR2U7ce0cLnw+SRPpfr0jiGo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754057109; c=relaxed/simple;
	bh=IvwDY0j+SJZREw4lZmoxZuCFFsmcbBZiszUJJweliAg=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=EzVZFOcmYeYZenjj8OBF2omgg/cWkEb56BNikyjf51rEvb6pyP5PiD1pXY7G6/WdL/VZHSQsicDpHD60o1FwD3x7kn8XI5XsGmggEVcNpuIplBy2J0kRiNgj7jIGocvMk70PVn9zDP4IiFNQpSJEHzgeKZDj0d4sppEaZbH/1Bo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=daniel.almeida@collabora.com header.b=cMVSnMq/; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
ARC-Seal: i=1; a=rsa-sha256; t=1754057093; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=cUnymMh/HGlvGEspneAgSNC3tW4UbQqAugNCRhNvRLez9AGgzBEv3V+Ese8PSyp4NSR/xbkSCA14vKUV2/wHUmPp903uoXj+Mbtt3/1azkSGswAYjod3Qw9ES9Ec1T46aBqeotmGs0h9A8LraOKpZo9T+otbg4VkMgTu6PZmgis=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1754057093; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=SIuicZOreiJhSEfa7GtOtPdtVIuNxAma9Nw9rHALgKE=; 
	b=FM6Kry8II+NjyuOd/ZsuVp28vIHalaBLmWcl7bM0qgKxxvi924cEMCtZDxIBiDn6bOv6q0qGDxdJKUmBHqT5vUFV/bqkPxQ1R8qKQ/81Glx+CW+H94AxffLFd1Qt9UQhcSfGGdofB/SRBjTa7MLSoQlQ/gKJseIKYagjiBD4B08=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1754057093;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:References:To:To:Reply-To;
	bh=SIuicZOreiJhSEfa7GtOtPdtVIuNxAma9Nw9rHALgKE=;
	b=cMVSnMq/5wSjXBcd/hn5Fgl8SegwPIRRw4t0FoZdOfttStGzuOW9dTGoeVb3fn7G
	IRSniYbStoSU3BW7WG/9pSLaVTSYvQnPcsSFMr61VxnujEGFH24yatz5xoqryWx3hRW
	X8Eat9HN0AoK95qs0D/DfS64V2jjfoDZrMJ6E4cw=
Received: by mx.zohomail.com with SMTPS id 1754057091653547.7640404221518;
	Fri, 1 Aug 2025 07:04:51 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: [RFC PATCH v2 3/4] rust: miscdevice: add uring_cmd() for
 MiscDevice trait
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <20250727150329.27433-4-sidong.yang@furiosa.ai>
Date: Fri, 1 Aug 2025 11:04:36 -0300
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
Message-Id: <BC40C40D-D835-4B5E-927C-A55939110114@collabora.com>
References: <20250727150329.27433-1-sidong.yang@furiosa.ai>
 <20250727150329.27433-4-sidong.yang@furiosa.ai>
To: Sidong Yang <sidong.yang@furiosa.ai>
X-Mailer: Apple Mail (2.3826.600.51.1.1)
X-ZohoMailClient: External

Hi Sidong,

> On 27 Jul 2025, at 12:03, Sidong Yang <sidong.yang@furiosa.ai> wrote:
>=20
> This patch adds uring_cmd() function for MiscDevice trait and its
> callback implementation. It uses IoUringCmd that io_uring_cmd rust
> abstraction.

I can=E2=80=99t parse this.

>=20
> Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> ---
> rust/kernel/miscdevice.rs | 41 +++++++++++++++++++++++++++++++++++++++
> 1 file changed, 41 insertions(+)
>=20
> diff --git a/rust/kernel/miscdevice.rs b/rust/kernel/miscdevice.rs
> index 288f40e79906..54be866ea7ff 100644
> --- a/rust/kernel/miscdevice.rs
> +++ b/rust/kernel/miscdevice.rs
> @@ -14,6 +14,7 @@
>     error::{to_result, Error, Result, VTABLE_DEFAULT_ERROR},
>     ffi::{c_int, c_long, c_uint, c_ulong},
>     fs::File,
> +    io_uring::IoUringCmd,
>     mm::virt::VmaNew,
>     prelude::*,
>     seq_file::SeqFile,
> @@ -175,6 +176,19 @@ fn show_fdinfo(
>     ) {
>         build_error!(VTABLE_DEFAULT_ERROR)
>     }
> +
> +    /// Handler for uring_cmd.
> +    ///
> +    /// This function is invoked when userspace process submits the =
uring_cmd op
> +    /// on io_uring submission queue. The `io_uring_cmd` would be =
used for get
> +    /// arguments cmd_op, sqe, cmd_data.

Please improve this. I don=E2=80=99t think that anyone reading this can =
really get
a good grasp on what this function does.

What does `issue_flags` do?

> +    fn uring_cmd(
> +        _device: <Self::Ptr as ForeignOwnable>::Borrowed<'_>,
> +        _io_uring_cmd: Pin<&mut IoUringCmd>,
> +        _issue_flags: u32,
> +    ) -> Result<i32> {
> +        build_error!(VTABLE_DEFAULT_ERROR)
> +    }
> }
>=20
> /// A vtable for the file operations of a Rust miscdevice.
> @@ -332,6 +346,28 @@ impl<T: MiscDevice> MiscdeviceVTable<T> {
>         T::show_fdinfo(device, m, file);
>     }
>=20
> +    /// # Safety
> +    ///
> +    /// `ioucmd` is not null and points to a valid =
`bindings::io_uring_cmd`.

Please rewrite this as =E2=80=9Cthe caller must ensure that  `ioucmd` =
points to a
valid `bindings::io_uring_cmd`=E2=80=9D or some variation thereof.

> +    unsafe extern "C" fn uring_cmd(
> +        ioucmd: *mut bindings::io_uring_cmd,
> +        issue_flags: ffi::c_uint,
> +    ) -> ffi::c_int {
> +        // SAFETY: The file is valid for the duration of this call.
> +        let ioucmd =3D unsafe { IoUringCmd::from_raw(ioucmd) };

What file?

Also, this is what you wrote for IoUringCmd::from_raw:

+
+ /// Constructs a new `IoUringCmd` from a raw `io_uring_cmd`
+ ///
+ /// # Safety
+ ///
+ /// The caller must guarantee that:
+ /// - The pointer `ptr` is not null and points to a valid =
`bindings::io_uring_cmd`.
+ /// - The memory pointed to by `ptr` remains valid for the duration of =
the returned reference's lifetime `'a`.
+ /// - The memory will not be moved or freed while the returned =
`Pin<&mut IoUringCmd>` is alive.
+ #[inline]
+ pub unsafe fn from_raw<'a>(ptr: *mut bindings::io_uring_cmd) -> =
Pin<&'a mut IoUringCmd> {

Here, you have to mention how the safety requirements above are =
fulfilled in this call site.

> +        let file =3D ioucmd.file();
> +
> +        // SAFETY: The file is valid for the duration of this call.

Same here.

> +        let private =3D unsafe { (*file.as_ptr()).private_data =
}.cast();

Perhaps this can be hidden away in an accessor?

> +        // SAFETY: uring_cmd calls can borrow the private data of the =
file.
> +        let device =3D unsafe { <T::Ptr as =
ForeignOwnable>::borrow(private) };

This is ForeignOwnable::borrow():

    /// Borrows a foreign-owned object immutably.
    ///
    /// This method provides a way to access a foreign-owned value from =
Rust immutably. It provides
    /// you with exactly the same abilities as an `&Self` when the value =
is Rust-owned.
    ///
    /// # Safety
    ///
    /// The provided pointer must have been returned by a previous call =
to [`into_foreign`], and if
    /// the pointer is ever passed to [`from_foreign`], then that call =
must happen after the end of
    /// the lifetime `'a`.
    ///
    /// [`into_foreign`]: Self::into_foreign
    /// [`from_foreign`]: Self::from_foreign
    unsafe fn borrow<'a>(ptr: *mut Self::PointedTo) -> =
Self::Borrowed<'a>;

You must say how the safety requirements above are fulfilled in this =
call site
as well. In particular, are you sure that this is true? i.e.:

> The provided pointer must have been returned by a previous call to
> [`into_foreign`],


> +
> +        match T::uring_cmd(device, ioucmd, issue_flags) {
> +            Ok(ret) =3D> ret as ffi::c_int,
> +            Err(err) =3D> err.to_errno() as ffi::c_int,

c_int is in the prelude. Also, please have a look at =
error::from_result().

> +        }
> +    }
> +
>     const VTABLE: bindings::file_operations =3D =
bindings::file_operations {
>         open: Some(Self::open),
>         release: Some(Self::release),
> @@ -354,6 +390,11 @@ impl<T: MiscDevice> MiscdeviceVTable<T> {
>         } else {
>             None
>         },
> +        uring_cmd: if T::HAS_URING_CMD {
> +            Some(Self::uring_cmd)
> +        } else {
> +            None
> +        },
>         // SAFETY: All zeros is a valid value for =
`bindings::file_operations`.
>         ..unsafe { MaybeUninit::zeroed().assume_init() }
>     };
> --=20
> 2.43.0
>=20
>=20

=E2=80=94 Daniel


