Return-Path: <io-uring+bounces-9529-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3D49B3F1D0
	for <lists+io-uring@lfdr.de>; Tue,  2 Sep 2025 03:13:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BCAF87A9494
	for <lists+io-uring@lfdr.de>; Tue,  2 Sep 2025 01:11:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F5B92DEA79;
	Tue,  2 Sep 2025 01:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="ey38dI/Z"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03EC2820B6
	for <io-uring@vger.kernel.org>; Tue,  2 Sep 2025 01:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756775578; cv=none; b=cpTaDu/bnsGl0J6bxr2/ri4/B/1tnpDZjHEfPQZhAnfWbM6dcAW73ZrrppQjqP6Q7Eaq8fs/y8RGdt4r9ezbVlxYwrAVqVkPjMqJsfhnmJW6eIcUkPe6gbyHiw/y3TVaPNlG6JL/xRKBKojI3at6VKrrwTz2fzbdZeVTXQ+RfzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756775578; c=relaxed/simple;
	bh=awX1e0YRkWX41k+/Ji6Uvy3ENqw57cjMbsgXpXjnxqI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dLJP09l87r+dFK8+vpM26LY7tifBg15/zhk9fILSELuZRt+FHznw8f6Cbdn+/geZvzUFtJuC9iy4LAgOBCij6zbOhq4LYYsyV7FDJlNLhYnbgpEYJj2xyzXCce+h3vGOYoHk1Ak5lZ/GBYeyhwgoU2HL+GlZfV9wcxfIZ5NQp5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=ey38dI/Z; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-24adcc94338so3561215ad.2
        for <io-uring@vger.kernel.org>; Mon, 01 Sep 2025 18:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1756775576; x=1757380376; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XHCvvP+35dkC2S6ABunes2v2HwY6e7Eot3UleSEfYpQ=;
        b=ey38dI/ZVrr1n04g4Hw5eDhVzdMbcVPtU1teTrL15nm3PSkKxoYhZoaE4zylpgvXJY
         1qQRx9mZsfxhFJy8Rz/G6yfkL8RjpoTVUO+S47qARnxhw0q9gGXIz0g/yg3QaW66iYbS
         +bIhkuP4ZZltPZzsTL9WQZ8/nLOyniUsizE+ke5z24M0S9/PzlCt5WPKYIaCk+dyYaUg
         CI6AtiyY3ro18gRxMithk6mUe9TL0iw/ZFe5881nU8nQgfJiyG+g1EDboa1nb/SFT41B
         fv1iw0gVrUgC4gzzFy7DJlJeXvH5vsQuRmEUDg1u3CDw838o3uw9XPAcppGXQJeYCi96
         016w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756775576; x=1757380376;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XHCvvP+35dkC2S6ABunes2v2HwY6e7Eot3UleSEfYpQ=;
        b=Np1hNUgtpC8lxAw8dDontABJOdWCPam2/s3JLMKKouLpGDu/a2gkeHHoQz3k5p541P
         Ds+QLO0z4hXMVkevsO6GfcsPScJL+4ExUTh8GZ8D8QnoYRYzFr+slrV/brL4JRbIBCYd
         eXlVpSmRWzcEZYwxJR6HRDIVHScJm5Syf+jiGrfiWSFHHb6yFDlFIDLmBxLHx5vq8Ert
         XD9Uh/skSwBtmYPCeuyrLceYZQkGvsNKtT8GGIMKgXu4vV9t0gyYIZIVX3Ob7GnaomDA
         XlHNL2Y3EmU9qV22kZaShgCwlyPvKQy9kgPd6xBDjiSrjB+AbwIRNvdq0qrLJF8Di4vi
         SPpQ==
X-Forwarded-Encrypted: i=1; AJvYcCUGP+gVDBndhdZ0r785ScmVcbfTHBHY8u4RBE4K2nwuWlh/SJfs210077ct8IfeQsC6x870RwDJ9w==@vger.kernel.org
X-Gm-Message-State: AOJu0YwPdvTd/XyBEJkeakxJHLPwTj/nT7vjCHIMrj//M/yrKI1eqfgg
	eJ51OG826xbmkLCWZULxGX4NLVnajyEZz2S6Kj3GLSj9pF5MXcHjzgZB6AP/pWkxnS6Nn1kgbxm
	L5yfuGvAThc98OWO43nVprkxf3mIBHgEnotwj6UMp6g==
X-Gm-Gg: ASbGncvAqHc2r8gtdP24KjzZu/MsE4/TtbyYRvzV5NJXDDRl5mqaeHu+57eLIC6utNB
	n2DR7BYS3tF8fQJOST7UcUM9Ns27Ht/28t9G4VIV3WDYQBBbEHkQ0QC0faXQIUuDn4D2O1xwsoU
	AbSl0mg+HrXV9O1IQ3DReKGzFM9IhTHbW1q2vingQpIF5FXvla2B6SFAPmNws5hZYETSDqID42N
	S5LbutSYaqbJ+sBNIAmK2g=
X-Google-Smtp-Source: AGHT+IEG2IssOpUWBOcieXLsVvbOyzxsmj8mA6d7fj/u5ol+zhX4uKtUoxTEtisgipvsTbZhNW18XYVCsPZLFXH6rAM=
X-Received: by 2002:a17:902:d2cb:b0:240:280a:5443 with SMTP id
 d9443c01a7336-2491e5df37cmr94240315ad.3.1756775576098; Mon, 01 Sep 2025
 18:12:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250822125555.8620-1-sidong.yang@furiosa.ai> <20250822125555.8620-5-sidong.yang@furiosa.ai>
In-Reply-To: <20250822125555.8620-5-sidong.yang@furiosa.ai>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 1 Sep 2025 18:12:44 -0700
X-Gm-Features: Ac12FXzs379zYbpHtd7ODaycp9bhnHq9U5sPnDYXJdkInKyity4iorwvYehK-UA
Message-ID: <CADUfDZoDvAp1yqFyB_SQiynqQfOQPkO_mnQ_pWAXpZJESecFFw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 4/5] rust: miscdevice: Add `uring_cmd` support
To: Sidong Yang <sidong.yang@furiosa.ai>
Cc: Jens Axboe <axboe@kernel.dk>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Benno Lossin <lossin@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 22, 2025 at 5:56=E2=80=AFAM Sidong Yang <sidong.yang@furiosa.ai=
> wrote:
>
> This patch introduces support for `uring_cmd` to the `miscdevice`
> framework. This is achieved by adding a new `uring_cmd` method to the
> `MiscDevice` trait and wiring it up to the corresponding
> `file_operations` entry.
>
> The `uring_cmd` function provides a mechanism for `io_uring` to issue
> commands to a device driver.
>
> The new `uring_cmd` method takes the device, an `IoUringCmd` object,
> and issue flags as arguments. The `IoUringCmd` object is a safe Rust
> abstraction around the raw `io_uring_cmd` struct.
>
> To enable `uring_cmd` for a specific misc device, the `HAS_URING_CMD`
> constant must be set to `true` in the `MiscDevice` implementation.
>
> Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> ---
>  rust/kernel/miscdevice.rs | 53 ++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 52 insertions(+), 1 deletion(-)
>
> diff --git a/rust/kernel/miscdevice.rs b/rust/kernel/miscdevice.rs
> index 6373fe183b27..fcef579218ba 100644
> --- a/rust/kernel/miscdevice.rs
> +++ b/rust/kernel/miscdevice.rs
> @@ -11,9 +11,10 @@
>  use crate::{
>      bindings,
>      device::Device,
> -    error::{to_result, Error, Result, VTABLE_DEFAULT_ERROR},
> +    error::{from_result, to_result, Error, Result, VTABLE_DEFAULT_ERROR}=
,
>      ffi::{c_int, c_long, c_uint, c_ulong},
>      fs::File,
> +    io_uring::IoUringCmd,
>      mm::virt::VmaNew,
>      prelude::*,
>      seq_file::SeqFile,
> @@ -180,6 +181,21 @@ fn show_fdinfo(
>      ) {
>          build_error!(VTABLE_DEFAULT_ERROR)
>      }
> +
> +    /// Handler for uring_cmd.
> +    ///
> +    /// This function is invoked when userspace process submits an uring=
_cmd op
> +    /// on io-uring submission queue. The `device` is borrowed instance =
defined
> +    /// by `Ptr`. The `io_uring_cmd` would be used for get arguments cmd=
_op, sqe,
> +    /// cmd_data. The `issue_flags` is the flags includes options for ur=
ing_cmd.
> +    /// The options are listed in `kernel::io_uring::cmd_flags`.
> +    fn uring_cmd(
> +        _device: <Self::Ptr as ForeignOwnable>::Borrowed<'_>,
> +        _io_uring_cmd: Pin<&mut IoUringCmd>,

Passing the IoUringCmd by reference doesn't allow the uring_cmd()
implementation to store it beyond the function return. That precludes
any asynchronous uring_cmd() implementation, which is kind of the
whole point of uring_cmd. I think uring_cmd() needs to transfer
ownership of the IoUringCmd so the implementation can complete it
asynchronously.

Best,
Caleb

> +        _issue_flags: u32,
> +    ) -> Result<i32> {
> +        build_error!(VTABLE_DEFAULT_ERROR)
> +    }
>  }
>
>  /// A vtable for the file operations of a Rust miscdevice.
> @@ -337,6 +353,36 @@ impl<T: MiscDevice> MiscdeviceVTable<T> {
>          T::show_fdinfo(device, m, file);
>      }
>
> +    /// # Safety
> +    ///
> +    /// The caller must ensure that:
> +    /// - The pointer `ioucmd` is not null and points to a valid `bindin=
gs::io_uring_cmd`.
> +    unsafe extern "C" fn uring_cmd(
> +        ioucmd: *mut bindings::io_uring_cmd,
> +        issue_flags: ffi::c_uint,
> +    ) -> c_int {
> +        // SAFETY: `file` referenced by `ioucmd` is valid pointer. It's =
assigned in
> +        // uring cmd preparation. So dereferencing is safe.
> +        let raw_file =3D unsafe { (*ioucmd).file };
> +
> +        // SAFETY: `private_data` is guaranteed that it has valid pointe=
r after
> +        // this file opened. So dereferencing is safe.
> +        let private =3D unsafe { (*raw_file).private_data }.cast();
> +
> +        // SAFETY: `ioucmd` is not null and points to valid memory `bind=
ings::io_uring_cmd`
> +        // and the memory pointed by `ioucmd` is valid and will not be m=
oved or
> +        // freed for the lifetime of returned value `ioucmd`
> +        let ioucmd =3D unsafe { IoUringCmd::from_raw(ioucmd) };
> +
> +        // SAFETY: This call is safe because `private` is returned by
> +        // `into_foreign` in [`open`]. And it's guaranteed
> +        // that `from_foreign` is called by [`release`] after the end of
> +        // the lifetime of `device`
> +        let device =3D unsafe { <T::Ptr as ForeignOwnable>::borrow(priva=
te) };
> +
> +        from_result(|| T::uring_cmd(device, ioucmd, issue_flags))
> +    }
> +
>      const VTABLE: bindings::file_operations =3D bindings::file_operation=
s {
>          open: Some(Self::open),
>          release: Some(Self::release),
> @@ -359,6 +405,11 @@ impl<T: MiscDevice> MiscdeviceVTable<T> {
>          } else {
>              None
>          },
> +        uring_cmd: if T::HAS_URING_CMD {
> +            Some(Self::uring_cmd)
> +        } else {
> +            None
> +        },
>          // SAFETY: All zeros is a valid value for `bindings::file_operat=
ions`.
>          ..unsafe { MaybeUninit::zeroed().assume_init() }
>      };
> --
> 2.43.0
>

