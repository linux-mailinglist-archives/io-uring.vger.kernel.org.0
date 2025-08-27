Return-Path: <io-uring+bounces-9315-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04163B38B10
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 22:41:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BCDF8173447
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 20:41:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8482A2F3638;
	Wed, 27 Aug 2025 20:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=daniel.almeida@collabora.com header.b="UfEyxg4D"
X-Original-To: io-uring@vger.kernel.org
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82EB1DE4CA;
	Wed, 27 Aug 2025 20:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756327312; cv=pass; b=dI+WANQNtIu15lN6liwNKwSGTP/2u0Nd5fwBms9lGFL8aj12tR17bW0PjnPwEVafe9Q9C/ejy5WnBFvPVqt3SbEcpnL7V/pbbb/0r8TjzxqOHZJUpdw+W8gQhzAlGmQ0pntwr6EDPuYADBXKqcnwcNdixhFBs/gswXppZBM4Eng=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756327312; c=relaxed/simple;
	bh=AAbWlI+fVcNf245EchlXIdUhWf3zE9NOC3Rv4By1WiE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Cs9yX9kBm5uYIoUpwYhUVgQ90cUBzCSOcfAQvS2S9L7s2CCTP6I5GtmidMLhMiOPScih9VBf71kjk0UEDpHWN3+qCIfj2ZhReF70jYFODzVcRyUecSx5AT08+bZK1igEGB7/toG6GsY13Sa0GjB1532SgsDG7XW3JEvlb9JrU5I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=daniel.almeida@collabora.com header.b=UfEyxg4D; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
ARC-Seal: i=1; a=rsa-sha256; t=1756327294; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=JTHWYYS9oIbP0QhXcNxXBj5jk2dy0D/6YCrTJUNIcp0HiZrsieosK9UkFBONgPwl1/q2ZZBa+mXnqKT12s9IhTJtWffPvApX2qVyVgLBYg4sohTagyWqVFaCV/244Z3wd04DlASxR4wOXasrhQH6KUt+a9smqrdXykaf0EPBc+M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1756327294; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=eOYQVW7gHFiStIKVWbs6rHPJJ18hdXIIhJXvCnzDhh8=; 
	b=lLMFReCT1mfTXXZOVYD5BHc73epFgvnLu2hKJSI10nGq1RF2TS0+AIbV3xviFyh1CJg4iiyR/WCBOJZHx5laPLFnkygM++DpggGs54iAc2msRdZAjSEC7don5rbdH7G6G6RMA1ywLQkFL2zKKZJsXIxJw2fjeOhj36eiH7o0tnY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1756327294;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:References:To:To:Reply-To;
	bh=eOYQVW7gHFiStIKVWbs6rHPJJ18hdXIIhJXvCnzDhh8=;
	b=UfEyxg4DI7IqRWhw8uVCFiaYlGTmbaussrWAOdwohNDBnB5DUsMiLFISGJJoIyMa
	8b5b9vIVxTeSKDUKWXYlWcaI8TvTpEFBdcd4IM40Q7kxtaH1CCh6W9VZ+09DWeHhKUz
	nvJAuyWLvQcAg+40HrLXtxdYAzAfIuyVr7tmZYDc=
Received: by mx.zohomail.com with SMTPS id 1756327291209106.7581479016601;
	Wed, 27 Aug 2025 13:41:31 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [RFC PATCH v3 3/5] rust: io_uring: introduce rust abstraction for
 io-uring cmd
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <20250822125555.8620-4-sidong.yang@furiosa.ai>
Date: Wed, 27 Aug 2025 17:41:15 -0300
Cc: Jens Axboe <axboe@kernel.dk>,
 Caleb Sander Mateos <csander@purestorage.com>,
 Benno Lossin <lossin@kernel.org>,
 Miguel Ojeda <ojeda@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <713667D6-8001-408D-819D-E9326FC3AFD5@collabora.com>
References: <20250822125555.8620-1-sidong.yang@furiosa.ai>
 <20250822125555.8620-4-sidong.yang@furiosa.ai>
To: Sidong Yang <sidong.yang@furiosa.ai>
X-Mailer: Apple Mail (2.3826.700.81)
X-ZohoMailClient: External

Hi Sidong,

> On 22 Aug 2025, at 09:55, Sidong Yang <sidong.yang@furiosa.ai> wrote:
>=20
> Implment the io-uring abstractions needed for miscdevicecs and other
> char devices that have io-uring command interface.

Can you expand on this last part?

>=20
> * `io_uring::IoUringCmd` : Rust abstraction for `io_uring_cmd` which
>  will be used as arg for `MiscDevice::uring_cmd()`. And driver can get
>  `cmd_op` sent from userspace. Also it has `flags` which includes =
option
>  that is reissued.
>=20

This is a bit hard to parse.

> * `io_uring::IoUringSqe` : Rust abstraction for `io_uring_sqe` which
>  could be get from `IoUringCmd::sqe()` and driver could get `cmd_data`
>  from userspace. Also `IoUringSqe` has more data like opcode could be =
used in
>  driver.

Same here.

>=20
> Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> ---
> rust/kernel/io_uring.rs | 306 ++++++++++++++++++++++++++++++++++++++++
> rust/kernel/lib.rs      |   1 +
> 2 files changed, 307 insertions(+)
> create mode 100644 rust/kernel/io_uring.rs
>=20
> diff --git a/rust/kernel/io_uring.rs b/rust/kernel/io_uring.rs
> new file mode 100644
> index 000000000000..61e88bdf4e42
> --- /dev/null
> +++ b/rust/kernel/io_uring.rs
> @@ -0,0 +1,306 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// SPDX-FileCopyrightText: (C) 2025 Furiosa AI
> +
> +//! Abstractions for io-uring.
> +//!
> +//! This module provides types for implements io-uring interface for =
char device.

This is also hard to parse.

> +//!
> +//!
> +//! C headers: =
[`include/linux/io_uring/cmd.h`](srctree/include/linux/io_uring/cmd.h) =
and
> +//! =
[`include/linux/io_uring/io_uring.h`](srctree/include/linux/io_uring/io_ur=
ing.h)
> +
> +use core::{mem::MaybeUninit, pin::Pin};
> +
> +use crate::error::from_result;
> +use crate::transmute::{AsBytes, FromBytes};
> +use crate::{fs::File, types::Opaque};
> +
> +use crate::prelude::*;
> +
> +/// io-uring opcode

/// `IoUring` opcodes.

Notice:

a) The capitalization,
b) The use of backticks,
c) The period in the end.

This is an ongoing effort to keep the docs tidy :)

> +pub mod opcode {
> +    /// opcode for uring cmd
> +    pub const URING_CMD: u32 =3D =
bindings::io_uring_op_IORING_OP_URING_CMD;
> +}

Should this be its own type? This way we can use the type system to =
enforce
that only valid opcodes are used where an opcode is expected.

> +
> +/// A Rust abstraction for the Linux kernel's `io_uring_cmd` =
structure.

/// A Rust abstraction for `io_uring_cmd`.

> +///
> +/// This structure is a safe, opaque wrapper around the raw C =
`io_uring_cmd`
> +/// binding from the Linux kernel. It represents a command structure =
used
> +/// in io_uring operations within the kernel.

This code will also be part of the kernel, so mentioning =E2=80=9Cthe =
Linux kernel=E2=80=9D is superfluous.

> +/// This type is used internally by the io_uring subsystem to manage
> +/// asynchronous I/O commands.
> +///
> +/// This type should not be constructed or manipulated directly by
> +/// kernel module developers.

=E2=80=9C=E2=80=A6by drivers=E2=80=9D.

> +///
> +/// # INVARIANT

/// # Invariants

> +/// - `self.inner` always points to a valid, live =
`bindings::io_uring_cmd`.

Blank here

> +#[repr(transparent)]
> +pub struct IoUringCmd {
> +    /// An opaque wrapper containing the actual `io_uring_cmd` data.
> +    inner: Opaque<bindings::io_uring_cmd>,
> +}
> +
> +impl IoUringCmd {
> +    /// Returns the cmd_op with associated with the `io_uring_cmd`.

This sentence does not parse very well.

> +    #[inline]
> +    pub fn cmd_op(&self) -> u32 {
> +        // SAFETY: `self.inner` is guaranteed by the type invariant =
to point
> +        // to a live `io_uring_cmd`, so dereferencing is safe.
> +        unsafe { (*self.inner.get()).cmd_op }

Perhaps add an as_raw() method so this becomes:

unsafe {*self.as_raw()}.cmd_op

> +    }
> +
> +    /// Returns the flags with associated with the `io_uring_cmd`.

With the command, or something like that. The user doesn=E2=80=99t see =
the raw
bindings::io_uring_cmd so we shouldn=E2=80=99t be mentioning it if we =
can help it.

> +    #[inline]
> +    pub fn flags(&self) -> u32 {
> +        // SAFETY: `self.inner` is guaranteed by the type invariant =
to point
> +        // to a live `io_uring_cmd`, so dereferencing is safe.
> +        unsafe { (*self.inner.get()).flags }
> +    }
> +
> +    /// Reads protocol data unit as `T` that impl `FromBytes` from =
uring cmd

This sentence does not parse very well.

> +    ///
> +    /// Fails with [`EFAULT`] if size of `T` is bigger than pdu size.

/// # Errors

> +    #[inline]
> +    pub fn read_pdu<T: FromBytes>(&self) -> Result<T> {

This takes &self,

> +        // SAFETY: `self.inner` is guaranteed by the type invariant =
to point
> +        // to a live `io_uring_cmd`, so dereferencing is safe.
> +        let inner =3D unsafe { &mut *self.inner.get() };

But this creates a &mut to self.inner using unsafe code. Avoid doing =
this in
general. All of a sudden your type is not thread-safe anymore.

If you need to mutate &self here, then take &mut self as an argument.

> +
> +        let len =3D size_of::<T>();
> +        if len > inner.pdu.len() {
> +            return Err(EFAULT);

EFAULT? How about EINVAL?

> +        }
> +
> +        let mut out: MaybeUninit<T> =3D MaybeUninit::uninit();
> +        let ptr =3D &raw mut inner.pdu as *const c_void;
> +
> +        // SAFETY:
> +        // * The `ptr` is valid pointer from `self.inner` that is =
guaranteed by type invariant.
> +        // * The `out` is valid pointer that points `T` which impls =
`FromBytes` and checked
> +        //   size of `T` is smaller than pdu size.
> +        unsafe {
> +            core::ptr::copy_nonoverlapping(ptr, =
out.as_mut_ptr().cast::<c_void>(), len);

I don=E2=80=99t think you need to manually specify c_void here.

Benno, can=E2=80=99t we use core::mem::zeroed() or something like that =
to avoid this unsafe?

The input was zeroed in prep() and the output can just be a zeroed T on =
the
stack, unless I missed something?

> +        }
> +
> +        // SAFETY: The read above has initialized all bytes in `out`, =
and since `T` implements
> +        // `FromBytes`, any bit-pattern is a valid value for this =
type.
> +        Ok(unsafe { out.assume_init() })
> +    }
> +
> +    /// Writes the provided `value` to `pdu` in uring_cmd `self`

Writes the provided `value` to `pdu`.

> +    ///

/// # Errors
///

> +    /// Fails with [`EFAULT`] if size of `T` is bigger than pdu size.

> +    #[inline]
> +    pub fn write_pdu<T: AsBytes>(&mut self, value: &T) -> Result<()> =
{
> +        // SAFETY: `self.inner` is guaranteed by the type invariant =
to point
> +        // to a live `io_uring_cmd`, so dereferencing is safe.
> +        let inner =3D unsafe { &mut *self.inner.get() };
> +
> +        let len =3D size_of::<T>();
> +        if len > inner.pdu.len() {
> +            return Err(EFAULT);
> +        }
> +
> +        let src =3D (value as *const T).cast::<c_void>();

as_ptr().cast()

> +        let dst =3D &raw mut inner.pdu as *mut c_void;

(&raw mut inner.pdu).cast()

> +
> +        // SAFETY:
> +        // * The `src` is points valid memory that is guaranteed by =
`T` impls `AsBytes`
> +        // * The `dst` is valid. It's from `self.inner` that is =
guaranteed by type invariant.
> +        // * It's safe to copy because size of `T` is no more than =
len of pdu.
> +        unsafe {
> +            core::ptr::copy_nonoverlapping(src, dst, len);
> +        }
> +
> +        Ok(())
> +    }
> +
> +    /// Constructs a new [`IoUringCmd`] from a raw `io_uring_cmd`

Missing period.

> +    ///
> +    /// # Safety
> +    ///
> +    /// The caller must guarantee that:
> +    /// - `ptr` is non-null, properly aligned, and points to a valid
> +    ///   `bindings::io_uring_cmd`.

Blanks for every bullet point, please.

> +    /// - The pointed-to memory remains initialized and valid for the =
entire
> +    ///   lifetime `'a` of the returned reference.
> +    /// - While the returned `Pin<&'a mut IoUringCmd>` is alive, the =
underlying
> +    ///   object is **not moved** (pinning requirement).

They can=E2=80=99t move an !Unpin type in safe code.

> +    /// - **Aliasing rules:** the returned `&mut` has **exclusive** =
access to the same
> +    ///   object for its entire lifetime:

You really don=E2=80=99t need to emphasize these.

> +    ///   - No other `&mut` **or** `&` references to the same =
`io_uring_cmd` may be
> +    ///     alive at the same time.

This and the point above are identical.

> +    ///   - There must be no concurrent reads/writes through raw =
pointers, FFI, or
> +    ///     other kernel paths to the same object during this =
lifetime.

This and the first point say the same thing.

> +    ///   - If the object can be touched from other contexts (e.g. =
IRQ/another CPU),
> +    ///     the caller must provide synchronization to uphold this =
exclusivity.

I am not sure what you mean.
> +    /// - This function relies on `IoUringCmd` being =
`repr(transparent)` over
> +    ///   `bindings::io_uring_cmd` so the cast preserves layout.

This is not a safety requirement.

Just adapt the requirements from other instances of from_raw(), they all
convert a *mut T to a &T so the safety requirements are similar.

> +    #[inline]
> +    pub unsafe fn from_raw<'a>(ptr: *mut bindings::io_uring_cmd) -> =
Pin<&'a mut IoUringCmd> {

Why is this pub? Sounds like a massive footgun? This should be private =
or at
best pub(crate).


> +        // SAFETY:
> +        // * The caller guarantees that the pointer is not dangling =
and stays
> +        //   valid for the duration of 'a.
> +        // * The cast is okay because `IoUringCmd` is =
`repr(transparent)` and
> +        //   has the same memory layout as `bindings::io_uring_cmd`.
> +        // * The returned `Pin` ensures that the object cannot be =
moved, which
> +        //   is required because the kernel may hold pointers to this =
memory
> +        //   location and moving it would invalidate those pointers.

> +        unsafe { Pin::new_unchecked(&mut *ptr.cast()) }
> +    }
> +
> +    /// Returns the file that referenced by uring cmd self.
> +    #[inline]
> +    pub fn file(&self) -> &File {
> +        // SAFETY: `self.inner` is guaranteed by the type invariant =
to point
> +        // to a live `io_uring_cmd`, so dereferencing is safe.
> +        let file =3D unsafe { (*self.inner.get()).file };
> +
> +        // SAFETY:
> +        // * The `file` points valid file.

Why?

> +        // * refcount is positive after submission queue entry =
issued.
> +        // * There is no active fdget_pos region on the file on this =
thread.
> +        unsafe { File::from_raw_file(file) }
> +    }
> +
> +    /// Returns an reference to the [`IoUringSqe`] associated with =
this command.

s/an/a

> +    #[inline]
> +    pub fn sqe(&self) -> &IoUringSqe {
> +        // SAFETY: `self.inner` is guaranteed by the type invariant =
to point
> +        // to a live `io_uring_cmd`, so dereferencing is safe.
> +        let sqe =3D unsafe { (*self.inner.get()).sqe };
> +        // SAFETY: The call guarantees that the `sqe` points valid =
io_uring_sqe.

What do you mean by =E2=80=9Cthe call guarantees=E2=80=9D ?

> +        unsafe { IoUringSqe::from_raw(sqe) }
> +    }
> +
> +    /// Completes an this [`IoUringCmd`] request that was previously =
queued.

This sentence does not parse very well.

> +    ///
> +    /// # Safety
> +    ///
> +    /// - This function must be called **only** for a command whose =
`uring_cmd`

Please no emphasis.

> +    ///   handler previously returned **`-EIOCBQUEUED`** to io_uring.

To what? Are you referring to a Rust type, or to the C part of the =
kernel?

> +    ///
> +    /// # Parameters
> +    ///
> +    /// - `ret`: Result to return to userspace.
> +    /// - `res2`: Extra for big completion queue entry =
`IORING_SETUP_CQE32`.

This sentence does not parse very well. Also, can you rename this?

> +    /// - `issue_flags`: Flags associated with this request, =
typically the same
> +    ///   as those passed to the `uring_cmd` handler.
> +    #[inline]
> +    pub fn done(self: Pin<&mut IoUringCmd>, ret: Result<i32>, res2: =
u64, issue_flags: u32) {
> +        let ret =3D from_result(|| ret) as isize;

What does this do?

> +        // SAFETY: The call guarantees that `self.inner` is not =
dangling and stays valid

What do you mean =E2=80=9Cthe call=E2=80=9D ?

> +        unsafe {
> +            bindings::io_uring_cmd_done(self.inner.get(), ret, res2, =
issue_flags);
> +        }
> +    }
> +}
> +
> +/// A Rust abstraction for the Linux kernel's `io_uring_sqe` =
structure.

Please don=E2=80=99t mention the words =E2=80=9CLinux kernel=E2=80=9D =
here either.

> +///
> +/// This structure is a safe, opaque wrapper around the raw C =
[`io_uring_sqe`](srctree/include/uapi/linux/io_uring.h)

This line needs to be wrapped.

> +/// binding from the Linux kernel. It represents a Submission Queue =
Entry

Can you link somewhere here? Perhaps there=E2=80=99s docs for =
=E2=80=9CSubmission Queue
Entry=E2=80=9D.

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

This is an invariant, please move it there.

> +///
> +/// # Fields
> +///
> +/// * `inner` - An opaque wrapper containing the actual =
`io_uring_sqe` data.
> +///             The `Opaque` type prevents direct access to the =
internal
> +///             structure fields, ensuring memory safety and =
encapsulation.

Inline docs please.

> +///
> +/// # Usage

I don=E2=80=99t think we specifically need to mention =E2=80=9C# =
Usage=E2=80=9D.

> +///
> +/// This type represents a submission queue entry that describes an =
I/O

You can start with =E2=80=9CRepresents a=E2=80=A6=E2=80=9D. No need to =
say =E2=80=9Cthis type=E2=80=9D here.

> +/// operation to be executed by the io_uring subsystem. It contains
> +/// information such as the operation type, file descriptor, buffer
> +/// pointers, and other operation-specific data.
> +///
> +/// Users can obtain this type from [`IoUringCmd::sqe()`] method, =
which
> +/// extracts the submission queue entry associated with a command.
> +///
> +/// This type should not be constructed or manipulated directly by
> +/// kernel module developers.

By drivers.

> +///
> +/// # INVARIANT

/// # Invariants

> +/// - `self.inner` always points to a valid, live =
`bindings::io_uring_sqe`.
> +#[repr(transparent)]
> +pub struct IoUringSqe {
> +    inner: Opaque<bindings::io_uring_sqe>,
> +}
> +
> +impl IoUringSqe {
> +    /// Reads and interprets the `cmd` field of an =
`bindings::io_uring_sqe` as a value of type `T`.
> +    ///
> +    /// # Safety & Invariants

Safety section for a safe function.

> +    /// - Construction of `T` is delegated to `FromBytes`, which =
guarantees that `T` has no
> +    ///   invalid bit patterns and can be safely reconstructed from =
raw bytes.
> +    /// - **Limitation:** This implementation does not support =
`IORING_SETUP_SQE128` (larger SQE entries).

Please no emphasis.


> +    ///   Only the standard `io_uring_sqe` layout is handled here.
> +    ///
> +    /// # Errors

Blank here.

> +    /// * Returns `EINVAL` if the `self` does not hold a =
`opcode::URING_CMD`.
> +    /// * Returns `EFAULT` if the command buffer is smaller than the =
requested type `T`.
> +    ///
> +    /// # Returns

I don=E2=80=99t think we need a specific section for this. Just write =
this in
normal prose please.


> +    /// * On success, returns a `T` deserialized from the `cmd`.
> +    /// * On failure, returns an appropriate error as described =
above.
> +    pub fn cmd_data<T: FromBytes>(&self) -> Result<T> {
> +        // SAFETY: `self.inner` guaranteed by the type invariant to =
point
> +        // to a live `io_uring_sqe`, so dereferencing is safe.
> +        let sqe =3D unsafe { &*self.inner.get() };
> +
> +        if u32::from(sqe.opcode) !=3D opcode::URING_CMD {
> +            return Err(EINVAL);
> +        }
> +
> +        // SAFETY: Accessing the `sqe.cmd` union field is safe =
because we've
> +        // verified that `sqe.opcode =3D=3D IORING_OP_URING_CMD`, =
which guarantees
> +        // that this union variant is initialized and valid.
> +        let cmd =3D unsafe { sqe.__bindgen_anon_6.cmd.as_ref() };
> +        let cmd_len =3D =
size_of_val(&sqe.__bindgen_anon_6.bindgen_union_field);
> +
> +        if cmd_len < size_of::<T>() {
> +            return Err(EFAULT);

EINVAL

> +        }
> +
> +        let cmd_ptr =3D cmd.as_ptr() as *mut T;

cast()

> +
> +        // SAFETY: `cmd_ptr` is valid from `self.inner` which is =
guaranteed by
> +        // type variant. And also it points to initialized `T` from =
userspace.

=E2=80=9CInvariant=E2=80=9D.

=E2=80=9C[=E2=80=A6] an initialized T=E2=80=9D.


> +        let ret =3D unsafe { core::ptr::read_unaligned(cmd_ptr) };
> +
> +        Ok(ret)
> +    }
> +
> +    /// Constructs a new `IoUringSqe` from a raw `io_uring_sqe`.

[`IoUringSqe`].

Please build the docs and make sure all your docs look nice.

> +    ///
> +    /// # Safety
> +    ///
> +    /// The caller must guarantee that:
> +    /// - `ptr` is non-null, properly aligned, and points to a valid =
initialized
> +    ///   `bindings::io_uring_sqe`.
> +    /// - The pointed-to memory remains valid (not freed or =
repurposed) for the
> +    ///   entire lifetime `'a` of the returned reference.
> +    /// - **Aliasing rules (for `&T`):** while the returned `&'a =
IoUringSqe` is
> +    ///   alive, there must be **no mutable access** to the same =
object through any
> +    ///   path (no `&mut`, no raw-pointer writes, no =
FFI/IRQ/other-CPU writers).
> +    ///   Multiple `&` is fine **only if all of them are read-only** =
for the entire
> +    ///   overlapping lifetime.
> +    /// - This relies on `IoUringSqe` being `repr(transparent)` over
> +    ///   `bindings::io_uring_sqe`, so the cast preserves layout.

Please rewrite this entire section given the feedback I gave higher up =
in this
patch.

> +    #[inline]
> +    pub unsafe fn from_raw<'a>(ptr: *const bindings::io_uring_sqe) -> =
&'a IoUringSqe {

Private or pub(crate) at best.

> +        // SAFETY: The caller guarantees that the pointer is not =
dangling and stays valid for the
> +        // duration of 'a. The cast is okay because `IoUringSqe` is =
`repr(transparent)` and has the
> +        // same memory layout as `bindings::io_uring_sqe`.
> +        unsafe { &*ptr.cast() }
> +    }
> +}
> diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
> index ed53169e795c..d38cf7137401 100644
> --- a/rust/kernel/lib.rs
> +++ b/rust/kernel/lib.rs
> @@ -91,6 +91,7 @@
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


