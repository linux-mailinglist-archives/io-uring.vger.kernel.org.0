Return-Path: <io-uring+bounces-8871-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9616DB182AD
	for <lists+io-uring@lfdr.de>; Fri,  1 Aug 2025 15:49:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F40AB1C27686
	for <lists+io-uring@lfdr.de>; Fri,  1 Aug 2025 13:49:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 120548F49;
	Fri,  1 Aug 2025 13:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=daniel.almeida@collabora.com header.b="guA68300"
X-Original-To: io-uring@vger.kernel.org
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE48335977;
	Fri,  1 Aug 2025 13:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754056159; cv=pass; b=GNiwHnOdJ/n+e9ZBTk+TrcAs7bmuqa9uaKit+O6KWbA20k5HduV0Oe7cUVZ0xtddI6dY2crbA+xWixYBYHUsFb5YAHfEEI5dCFVoezbb8T+ROubgOUmGtCtJuaFTfxIZnHz9jZw6MU9Hy7A5cmZzScYR15mBsTTy55ezKJohvbo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754056159; c=relaxed/simple;
	bh=6LsAS/wu7KwX4V8T1a/Z42eqYEpNt2GVqneS9HDsMTI=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=fIqZH7T2lZ9ULTV1dpfLNFVFU32pp5R8uRqSgTEN5ckbesw61zDsBqik52UUmcMffivSlh23CUcBBV9+q2OcZLZ1hdU1z4xcS0ggaU6QsOLPpTODUBusyvo9ucnPZWV0V+BUY44i3ohkxuBghb0AEJiUOcj6UJHgsz6oCqw2WKQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=daniel.almeida@collabora.com header.b=guA68300; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
ARC-Seal: i=1; a=rsa-sha256; t=1754056137; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Z4m3vQLygAfygti5PyKdg0jDT2mG7stnZA4BJormwFJ2VGYoq7EEiPW0lC9h0aVPAAXp2RjtkPk3Dvs3LL80/A4cIu0E553d4t08FF+aXODrjXb559OZFVJXkdGw4PYJWbkXJeKVlYgTXtYjP5+1uhdEylcORFZj91spuiFRILY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1754056137; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=eZHQ7rcT6yQWosjzQmPSOHVZJEHNKhkiHi1TOcOClQY=; 
	b=ailP5D0Vkr5734o/KKKhsyXHtPoWKJs/R9v6xl+OYrq6I1+/tQqxVu5Td6+VU5zCglYhayhQ/OCTXNZcThv9QaR0/MPeHG4MSXRDai9tSKsciWwZZ+lTlcPhNjxaHy5ioTZ0sTcrNAfd9Ts30vIifN7L9skTyJnX59qXGp5R7Ks=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1754056137;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:References:To:To:Reply-To;
	bh=eZHQ7rcT6yQWosjzQmPSOHVZJEHNKhkiHi1TOcOClQY=;
	b=guA683001pubrgje39RhTMoz8bARpzFCujCR7km/eYbgyubnqn7bdfVzDm8RDRjg
	dXp0iWTZ9ihjwfe4vA3tIthEPbs62DCgfqblWQWHnvGtbhnATqJYAfuZgiclZMOV1Nb
	bu59boaJZSRCWumWUjZTrS4yL7FOd1tbXIYL3ErU=
Received: by mx.zohomail.com with SMTPS id 1754056135088990.9045317152799;
	Fri, 1 Aug 2025 06:48:55 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: [RFC PATCH v2 2/4] rust: io_uring: introduce rust abstraction for
 io-uring cmd
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <20250727150329.27433-3-sidong.yang@furiosa.ai>
Date: Fri, 1 Aug 2025 10:48:40 -0300
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
Message-Id: <D6CDE1A5-879F-49B1-9E10-2998D04B678F@collabora.com>
References: <20250727150329.27433-1-sidong.yang@furiosa.ai>
 <20250727150329.27433-3-sidong.yang@furiosa.ai>
To: Sidong Yang <sidong.yang@furiosa.ai>
X-Mailer: Apple Mail (2.3826.600.51.1.1)
X-ZohoMailClient: External

Hi Sidong,

> On 27 Jul 2025, at 12:03, Sidong Yang <sidong.yang@furiosa.ai> wrote:
>=20
> This patch introduces rust abstraction for io-uring sqe, cmd. =
IoUringSqe
> abstracts io_uring_sqe and it has cmd_data(). and IoUringCmd is
> abstraction for io_uring_cmd. =46rom this, user can get cmd_op, flags,
> pdu and also sqe.

IMHO you need to expand this substantially.

Instead of a very brief discussion of *what* you're doing, you need to =
explain
*why* you're doing this and how this patch fits with the overall plan =
that you
have in mind.

Also, for the sake of reviewers, try to at least describe the role of =
all the
types you've mentioned.

>=20
> Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> ---
> rust/kernel/io_uring.rs | 183 ++++++++++++++++++++++++++++++++++++++++
> rust/kernel/lib.rs      |   1 +
> 2 files changed, 184 insertions(+)
> create mode 100644 rust/kernel/io_uring.rs
>=20
> diff --git a/rust/kernel/io_uring.rs b/rust/kernel/io_uring.rs
> new file mode 100644
> index 000000000000..0acdf3878247
> --- /dev/null
> +++ b/rust/kernel/io_uring.rs
> @@ -0,0 +1,183 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +// Copyright (C) 2025 Furiosa AI.
> +

Perhaps this instead [0].


> +//! IoUring command and submission queue entry abstractions.

Maybe expand this just a little bit as well.

> +//!
> +//! C headers: =
[`include/linux/io_uring/cmd.h`](srctree/include/linux/io_uring/cmd.h) =
and
> +//! =
[`include/linux/io_uring/io_uring.h`](srctree/include/linux/io_uring/io_ur=
ing.h)
> +
> +use core::{mem::MaybeUninit, pin::Pin, ptr::addr_of_mut};
> +
> +use crate::{fs::File, types::Opaque};
> +
> +/// A Rust abstraction for the Linux kernel's `io_uring_cmd` =
structure.

Is there a link for io_uring_cmd that you can use here?

> +///
> +/// This structure is a safe, opaque wrapper around the raw C =
`io_uring_cmd`
> +/// binding from the Linux kernel. It represents a command structure =
used
> +/// in io_uring operations within the kernel.

Perhaps backticks on =E2=80=9Cio_uring=E2=80=9D ?

> +///
> +/// # Type Safety
> +///
> +/// The `#[repr(transparent)]` attribute ensures that this wrapper =
has
> +/// the same memory layout as the underlying `io_uring_cmd` =
structure,
> +/// allowing it to be safely transmuted between the two =
representations.
> +///
> +/// # Fields
> +///
> +/// * `inner` - An opaque wrapper containing the actual =
`io_uring_cmd` data.
> +///             The `Opaque` type prevents direct access to the =
internal
> +///             structure fields, ensuring memory safety and =
encapsulation.

Place this on top of the field itself please. Also, I don=E2=80=99t =
think you need
this at all because you don't need to explain the Opaque type, as it's
extensively used in the kernel crate.

> +///
> +/// # Usage

I don=E2=80=99t think you need this.

> +///
> +/// This type is used internally by the io_uring subsystem to manage
> +/// asynchronous I/O commands. It is typically accessed through a =
pinned
> +/// mutable reference: `Pin<&mut IoUringCmd>`. The pinning ensures =
that
> +/// the structure remains at a fixed memory location, which is =
required
> +/// for safe interaction with the kernel's io_uring infrastructure.

I don=E2=80=99t think you need anything other than:

> +/// This type is used internally by the io_uring subsystem to manage
> +/// asynchronous I/O commands.

Specifically, you don=E2=80=99t need to say this:

>  The pinning ensures that
> +/// the structure remains at a fixed memory location,



> +///
> +/// Users typically receive this type as an argument in the =
`file_operations::uring_cmd()`
> +/// callback function, where they can access and manipulate the =
io_uring command
> +/// data for custom file operations.
> +///
> +/// This type should not be constructed or manipulated directly by
> +/// kernel module developers.

Well, this is pub, so the reality is that it can be manipulated directly
through whatever public API it offers.

> +#[repr(transparent)]
> +pub struct IoUringCmd {
> +    inner: Opaque<bindings::io_uring_cmd>,
> +}
> +
> +impl IoUringCmd {
> +    /// Returns the cmd_op with associated with the io_uring_cmd.

Backticks

> +    #[inline]
> +    pub fn cmd_op(&self) -> u32 {
> +        // SAFETY: The call guarantees that `self.inner` is not =
dangling and stays valid

Not sure I understand what you=E2=80=99re trying to say here. Perhaps =
add an
invariant saying that `self.inner` always points to a valid
`bindings::io_uring_cmd` and mention that here instead.

> +        unsafe { (*self.inner.get()).cmd_op }
> +    }
> +
> +    /// Returns the flags with associated with the io_uring_cmd.
> +    #[inline]
> +    pub fn flags(&self) -> u32 {
> +        // SAFETY: The call guarantees that `self.inner` is not =
dangling and stays valid
> +        unsafe { (*self.inner.get()).flags }
> +    }
> +
> +    /// Returns the ref pdu for free use.

I have no idea what =E2=80=9Cref pdu=E2=80=9D is. You need to describe =
these acronyms.

> +    #[inline]
> +    pub fn pdu(&mut self) -> &mut MaybeUninit<[u8; 32]> {

Why MaybeUninit? Also, this is a question for others, but I don=E2=80=99t =
think
that `u8`s can ever be uninitialized as all byte values are valid for =
`u8`.

> +        // SAFETY: The call guarantees that `self.inner` is not =
dangling and stays valid
> +        let inner =3D unsafe { &mut *self.inner.get() };
> +        let ptr =3D addr_of_mut!(inner.pdu) as *mut MaybeUninit<[u8; =
32]>;

&raw mut

> +
> +        // SAFETY: The call guarantees that `self.inner` is not =
dangling and stays valid
> +        unsafe { &mut *ptr }
> +    }
> +
> +    /// Constructs a new `IoUringCmd` from a raw `io_uring_cmd`

[`IoUringCmd`]

By the way, always build the docs and see if they look nice.

> +    ///
> +    /// # Safety
> +    ///
> +    /// The caller must guarantee that:
> +    /// - The pointer `ptr` is not null and points to a valid =
`bindings::io_uring_cmd`.
> +    /// - The memory pointed to by `ptr` remains valid for the =
duration of the returned reference's lifetime `'a`.
> +    /// - The memory will not be moved or freed while the returned =
`Pin<&mut IoUringCmd>` is alive.

This returns a wrapper over a mutable reference. You must mention =
Rust=E2=80=99s aliasing rules here.

> +    #[inline]
> +    pub unsafe fn from_raw<'a>(ptr: *mut bindings::io_uring_cmd) -> =
Pin<&'a mut IoUringCmd> {
> +        // SAFETY: The caller guarantees that the pointer is not =
dangling and stays valid for the
> +        // duration of 'a. The cast is okay because `IoUringCmd` is =
`repr(transparent)` and has the
> +        // same memory layout as `bindings::io_uring_cmd`. The =
returned `Pin` ensures that the object
> +        // cannot be moved, which is required because the kernel may =
hold pointers to this memory
> +        // location and moving it would invalidate those pointers.

Please break this into multiple paragraphs.

> +        unsafe { Pin::new_unchecked(&mut *ptr.cast()) }
> +    }
> +
> +    /// Returns the file that referenced by uring cmd self.
> +    #[inline]
> +    pub fn file(&self) -> &File {
> +        // SAFETY: The call guarantees that the `self.inner` is not =
dangling and stays valid
> +        let file =3D unsafe { (*self.inner.get()).file };
> +        // SAFETY: The call guarantees that `file` points valid file.
> +        unsafe { File::from_raw_file(file) }
> +    }
> +
> +    /// Returns a reference to the uring cmd's SQE.

Please define what `SQE` means. Add links if possible.

> +    #[inline]
> +    pub fn sqe(&self) -> &IoUringSqe {
> +        // SAFETY: The call guarantees that the `self.inner` is not =
dangling and stays valid
> +        let sqe =3D unsafe { (*self.inner.get()).sqe };
> +        // SAFETY: The call guarantees that the `sqe` points valid =
io_uring_sqe.

Backticks

> +        unsafe { IoUringSqe::from_raw(sqe) }
> +    }
> +
> +    /// Called by consumers of io_uring_cmd, if they originally =
returned -EIOCBQUEUED upon receiving the command

Backticks

> +    #[inline]
> +    pub fn done(self: Pin<&mut IoUringCmd>, ret: isize, res2: u64, =
issue_flags: u32) {

The arguments are cryptic here. Please let us know what they do.

> +        // SAFETY: The call guarantees that `self.inner` is not =
dangling and stays valid
> +        unsafe {
> +            bindings::io_uring_cmd_done(self.inner.get(), ret, res2, =
issue_flags);
> +        }
> +    }
> +}
> +
> +/// A Rust abstraction for the Linux kernel's `io_uring_sqe` =
structure.
> +///
> +/// This structure is a safe, opaque wrapper around the raw C =
`io_uring_sqe`
> +/// binding from the Linux kernel. It represents a Submission Queue =
Entry

Ah, SQE =3D=3D Submission Queue Entry. Is there a link for this?

> +/// used in io_uring operations within the kernel.
> +///
> +/// # Type Safety
> +///
> +/// The `#[repr(transparent)]` attribute ensures that this wrapper =
has
> +/// the same memory layout as the underlying `io_uring_sqe` =
structure,
> +/// allowing it to be safely transmuted between the two =
representations.
> +///
> +/// # Fields
> +///
> +/// * `inner` - An opaque wrapper containing the actual =
`io_uring_sqe` data.
> +///             The `Opaque` type prevents direct access to the =
internal
> +///             structure fields, ensuring memory safety and =
encapsulation.
> +///
> +/// # Usage
> +///
> +/// This type represents a submission queue entry that describes an =
I/O
> +/// operation to be executed by the io_uring subsystem. It contains
> +/// information such as the operation type, file descriptor, buffer
> +/// pointers, and other operation-specific data.

This description is very good :)

> +///
> +/// Users can obtain this type from `IoUringCmd::sqe()` method, which
> +/// extracts the submission queue entry associated with a command.

[`IoUringCmd::sqe`]

> +///
> +/// This type should not be constructed or manipulated directly by
> +/// kernel module developers.

Again, this is pub and can be freely manipulated through whatever
public API it offers.

> +#[repr(transparent)]
> +pub struct IoUringSqe {
> +    inner: Opaque<bindings::io_uring_sqe>,
> +}
> +
> +impl<'a> IoUringSqe {

Why is this =E2=80=98a here?

> +    /// Returns the cmd_data with associated with the io_uring_sqe.
> +    /// This function returns 16 byte array. We don't support =
IORING_SETUP_SQE128 for now.
> +    pub fn cmd_data(&'a self) -> &'a [Opaque<u8>] {

This is automatically placed by the compiler. See the lifetime elision =
rules
[1].

Also why does this return a reference to an array of Opaque<u8>?

You can return a &[u8] here if you can prove that this reference is =
legal given
Rust's aliasing rules. If you can't, then you have to look at what the =
DMA
allocator code is doing and use that as an example, i.e.: have a look at =
the
dma_read and dma_write macros and mark the function that returns the =
slice as
"unsafe".

> +        // SAFETY: The call guarantees that `self.inner` is not =
dangling and stays valid
> +        let cmd =3D unsafe { =
(*self.inner.get()).__bindgen_anon_6.cmd.as_ref() };

What do you mean by =E2=80=9Cthe call=E2=80=9D ? Same in all other =
places where this sentence is used.
> +
> +        // SAFETY: The call guarantees that `cmd` is not dangling and =
stays valid
> +        unsafe { core::slice::from_raw_parts(cmd.as_ptr() as *const =
Opaque<u8>, 16) }
> +    }
> +
> +    /// Constructs a new `IoUringSqe` from a raw `io_uring_sqe`
> +    ///
> +    /// # Safety
> +    ///
> +    /// The caller must guarantee that:
> +    /// - The pointer `ptr` is not null and points to a valid =
`bindings::io_uring_sqe`.
> +    /// - The memory pointed to by `ptr` remains valid for the =
duration of the returned reference's lifetime `'a`.

Must mention Rust=E2=80=99s aliasing rules here.

> +    #[inline]
> +    pub unsafe fn from_raw(ptr: *const bindings::io_uring_sqe) -> &'a =
IoUringSqe {
> +        // SAFETY: The caller guarantees that the pointer is not =
dangling and stays valid for the
> +        // duration of 'a. The cast is okay because `IoUringSqe` is =
`repr(transparent)` and has the
> +        // same memory layout as `bindings::io_uring_sqe`.
> +        unsafe { &*ptr.cast() }
> +    }
> +}
> diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
> index 6b4774b2b1c3..fb310e78d51d 100644
> --- a/rust/kernel/lib.rs
> +++ b/rust/kernel/lib.rs
> @@ -80,6 +80,7 @@
> pub mod fs;
> pub mod init;
> pub mod io;
> +pub mod io_uring;
> pub mod ioctl;
> pub mod jump_label;
> #[cfg(CONFIG_KUNIT)]
> --=20
> 2.43.0
>=20
>=20

[0] =
https://spdx.github.io/spdx-spec/v3.0.1/model/Software/Properties/copyrigh=
tText/
[1] https://doc.rust-lang.org/reference/lifetime-elision.html=

