Return-Path: <io-uring+bounces-9476-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AE76B3BFB9
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 17:46:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2F4F11891925
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 15:44:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24991321F52;
	Fri, 29 Aug 2025 15:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="emrsUv2Z"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30A01E51EA
	for <io-uring@vger.kernel.org>; Fri, 29 Aug 2025 15:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756482258; cv=none; b=iDmCv+HkFCs12YURVip+z8vyL2ijh+wRzyMSGyGh5COsE/eB6Y+Fc2kAfUC2cUVCuVw7lEPdfJRAc4ffRZaIOnHrly6ZPvbGO8yeME2U1oOrKGLVhg0uGE0pGMqyT3HvIu0stqerB6l7epbZEYcCr+HApbeI1D3QqATk63VodFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756482258; c=relaxed/simple;
	bh=dzUCZV7EfvG6O5WqSP1LF2/kmG1ldMeG1vNhlS8dvBQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VCZHTrKv01BaXPClh4XioSLvxrN/XY2jFQddpJd2qNw4YUtFcqIBikapAjObhpraXutcLMf9gHyZyd7nHqN0YiWsNg+W8o45WnfSST5DFDQutVVrkmWZtyUr9+fkJs1o2XF/vu8+H0QA5wjSyZbeBJ0YuH/uALEr8OoFG+taWoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=emrsUv2Z; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7720f23123dso2212192b3a.2
        for <io-uring@vger.kernel.org>; Fri, 29 Aug 2025 08:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1756482255; x=1757087055; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IGgCLabLukJXDx5jPLPH/OkDjgmbhWChjc+3HfEzLxo=;
        b=emrsUv2Zk10o9fR9J4J1IUe3GMr9IKDqB47OJ1KtLzpLRidZnzfIbXOodE56CBjZbB
         RtufVJU7vmpTTlIlMorS+Rakft8sIJ5+Vl/7iHO5qEpvODz5wHCsCBjg9Fg0UG5eSxie
         Kgxo51oCzQYfc2lD/gIt0bTUzMJFudd9JE0yk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756482255; x=1757087055;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IGgCLabLukJXDx5jPLPH/OkDjgmbhWChjc+3HfEzLxo=;
        b=fozaOsj+nJVXlgS3MOv7jgZS572+EsC3nSPCg5A1cIVep1d+TeeYZVFRqYv2YR4yMU
         Vrge7XTCQt2tYUtwAhKRCPd96mPlPwtipW1Lxwt4k0TbI9lUcj9QSXYHowxvyXa6fEnT
         oQ8c3Icu2XrS9fv0yoOz/Lzt3hZ9/IyjwV1NA17137KZGcxiUBf/QOWruXQjQ/eaYx99
         UUYTh7+3StqKEe2MVUmNxxHewpKTlUDKDu+axcxtumjJHb/sMObmAWIngyz/QSN0QXKj
         0RbeRSklWZSrIn5pwR+WxcixpEgJS9mCfGwD9/6lwP5kWhTkIxDWPV2bJtYUAteEbVI/
         DOeA==
X-Forwarded-Encrypted: i=1; AJvYcCXeSivtEIf08eT2UcShh/5tOk11Q6uan+nnMNAu/fuRi/6+yolyCKsdW4jxEDD2fmWBH9fw2EzFwg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5dNz5K9rzqhf+JuZeMEd9RMJ+L6ub95Vs0eBj76ZZutJFrTiT
	cKT/nac/WuQ/YKffyC2EyFH7fIy7YtA8BnEd6epbuQKx6tQ5BJI/rwFO/w5fo8YW2lA=
X-Gm-Gg: ASbGncsVmsmKxjX67YsUxnlqrNXoYM9w0y2cnJdhUHftBPgkxyVVAFrCbSTuyhy34fq
	d0XScXKytI03JaD6K/wVtcTq2jHKU35dvBTn5ptoAynmiVYE/PA2ox3HbrKNsF6c5fRbqEsPYb8
	XSrdi8CRI/hbQ0eAawS3IIQp8/7XaqcgEvTD8IIwnn9gXHvNGqHqleNjBiximHcJd9SjiYusc6e
	gTuxu3nm7h/YB/sxBCXiD2qOtXFkjFz5xM9QexwcBUe/hK3U1tkubLiyYWugdZ+Ajn08ldPtOpP
	iWagq/ydhKTpjr8lIAHwm4xhF5xEpnBwZHWdPi+lo8jwWId4TG1vext6SXzIui+dGmiYh6A78Gc
	rgwgi/yNOsUKTmv1T9B430nZGQMtr8UqKxVnyHmVoajVWNQqYmpFcpg==
X-Google-Smtp-Source: AGHT+IGaq6k4lNErHErQqWD+mWP7WxXWvWnbaRafxAC530vNF00FhKoZR4PvVdmxZbYzQpYp8hF5UQ==
X-Received: by 2002:a17:903:19e4:b0:248:d674:2b5 with SMTP id d9443c01a7336-248d674035cmr106623825ad.18.1756482254689;
        Fri, 29 Aug 2025 08:44:14 -0700 (PDT)
Received: from sidongui-MacBookPro.local ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-249144837fcsm19800355ad.15.2025.08.29.08.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 08:44:14 -0700 (PDT)
Date: Sat, 30 Aug 2025 00:43:58 +0900
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Daniel Almeida <daniel.almeida@collabora.com>
Cc: Jens Axboe <axboe@kernel.dk>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Benno Lossin <lossin@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [RFC PATCH v3 3/5] rust: io_uring: introduce rust abstraction
 for io-uring cmd
Message-ID: <aLHKvjBZYJk2Ci34@sidongui-MacBookPro.local>
References: <20250822125555.8620-1-sidong.yang@furiosa.ai>
 <20250822125555.8620-4-sidong.yang@furiosa.ai>
 <713667D6-8001-408D-819D-E9326FC3AFD5@collabora.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <713667D6-8001-408D-819D-E9326FC3AFD5@collabora.com>

On Wed, Aug 27, 2025 at 05:41:15PM -0300, Daniel Almeida wrote:

Hi Daniel,

> Hi Sidong,
> 
> > On 22 Aug 2025, at 09:55, Sidong Yang <sidong.yang@furiosa.ai> wrote:
> > 
> > Implment the io-uring abstractions needed for miscdevicecs and other
> > char devices that have io-uring command interface.
> 
> Can you expand on this last part?

Sure. 
> 
> > 
> > * `io_uring::IoUringCmd` : Rust abstraction for `io_uring_cmd` which
> >  will be used as arg for `MiscDevice::uring_cmd()`. And driver can get
> >  `cmd_op` sent from userspace. Also it has `flags` which includes option
> >  that is reissued.
> > 
> 
> This is a bit hard to parse.

I'll fix this.
> 
> > * `io_uring::IoUringSqe` : Rust abstraction for `io_uring_sqe` which
> >  could be get from `IoUringCmd::sqe()` and driver could get `cmd_data`
> >  from userspace. Also `IoUringSqe` has more data like opcode could be used in
> >  driver.
> 
> Same here.

Same here.
> 
> > 
> > Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> > ---
> > rust/kernel/io_uring.rs | 306 ++++++++++++++++++++++++++++++++++++++++
> > rust/kernel/lib.rs      |   1 +
> > 2 files changed, 307 insertions(+)
> > create mode 100644 rust/kernel/io_uring.rs
> > 
> > diff --git a/rust/kernel/io_uring.rs b/rust/kernel/io_uring.rs
> > new file mode 100644
> > index 000000000000..61e88bdf4e42
> > --- /dev/null
> > +++ b/rust/kernel/io_uring.rs
> > @@ -0,0 +1,306 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +// SPDX-FileCopyrightText: (C) 2025 Furiosa AI
> > +
> > +//! Abstractions for io-uring.
> > +//!
> > +//! This module provides types for implements io-uring interface for char device.
> 
> This is also hard to parse.

I'll fix this.
> 
> > +//!
> > +//!
> > +//! C headers: [`include/linux/io_uring/cmd.h`](srctree/include/linux/io_uring/cmd.h) and
> > +//! [`include/linux/io_uring/io_uring.h`](srctree/include/linux/io_uring/io_uring.h)
> > +
> > +use core::{mem::MaybeUninit, pin::Pin};
> > +
> > +use crate::error::from_result;
> > +use crate::transmute::{AsBytes, FromBytes};
> > +use crate::{fs::File, types::Opaque};
> > +
> > +use crate::prelude::*;
> > +
> > +/// io-uring opcode
> 
> /// `IoUring` opcodes.
> 
> Notice:
> 
> a) The capitalization,
> b) The use of backticks,
> c) The period in the end.
> 
> This is an ongoing effort to keep the docs tidy :)

Thanks :)
> 
> > +pub mod opcode {
> > +    /// opcode for uring cmd
> > +    pub const URING_CMD: u32 = bindings::io_uring_op_IORING_OP_URING_CMD;
> > +}
> 
> Should this be its own type? This way we can use the type system to enforce
> that only valid opcodes are used where an opcode is expected.

Sure. How about a transparent struct like below.

#[repr(transparent)]
pub struct Opcode(u32);

impl Opcode {
    pub const URING_CMD: Self =
        Self(bindings::io_uring_op_IORING_OP_URING_CMD as u32);
}

> 
> > +
> > +/// A Rust abstraction for the Linux kernel's `io_uring_cmd` structure.
> 
> /// A Rust abstraction for `io_uring_cmd`.

Okay, I'll fixed all comments mentioning "Linux kernel".
> 
> > +///
> > +/// This structure is a safe, opaque wrapper around the raw C `io_uring_cmd`
> > +/// binding from the Linux kernel. It represents a command structure used
> > +/// in io_uring operations within the kernel.
> 
> This code will also be part of the kernel, so mentioning "the Linux kernel" is superfluous.

Thanks.
> 
> > +/// This type is used internally by the io_uring subsystem to manage
> > +/// asynchronous I/O commands.
> > +///
> > +/// This type should not be constructed or manipulated directly by
> > +/// kernel module developers.
> 
> "...by drivers".

Thanks.
> 
> > +///
> > +/// # INVARIANT
> 
> /// # Invariants

Thanks.
> 
> > +/// - `self.inner` always points to a valid, live `bindings::io_uring_cmd`.
> 
> Blank here

Thanks.
> 
> > +#[repr(transparent)]
> > +pub struct IoUringCmd {
> > +    /// An opaque wrapper containing the actual `io_uring_cmd` data.
> > +    inner: Opaque<bindings::io_uring_cmd>,
> > +}
> > +
> > +impl IoUringCmd {
> > +    /// Returns the cmd_op with associated with the `io_uring_cmd`.
> 
> This sentence does not parse very well.

I'll fix this. Like you said, it's better to not to mention the c structure.
> 
> > +    #[inline]
> > +    pub fn cmd_op(&self) -> u32 {
> > +        // SAFETY: `self.inner` is guaranteed by the type invariant to point
> > +        // to a live `io_uring_cmd`, so dereferencing is safe.
> > +        unsafe { (*self.inner.get()).cmd_op }
> 
> Perhaps add an as_raw() method so this becomes:
> 
> unsafe {*self.as_raw()}.cmd_op

Agreed. Also it would return the Opcode type than u32.
> 
> > +    }
> > +
> > +    /// Returns the flags with associated with the `io_uring_cmd`.
> 
> With the command, or something like that. The user doesn´t see the raw
> bindings::io_uring_cmd so we shouldn´t be mentioning it if we can help it.

Agreed. I'll try to fix this without mentioning the io_uring_cmd.
> 
> > +    #[inline]
> > +    pub fn flags(&self) -> u32 {
> > +        // SAFETY: `self.inner` is guaranteed by the type invariant to point
> > +        // to a live `io_uring_cmd`, so dereferencing is safe.
> > +        unsafe { (*self.inner.get()).flags }
> > +    }
> > +
> > +    /// Reads protocol data unit as `T` that impl `FromBytes` from uring cmd
> 
> This sentence does not parse very well.

I'll fix this.
> 
> > +    ///
> > +    /// Fails with [`EFAULT`] if size of `T` is bigger than pdu size.
> 
> /// # Errors

Thanks.
> 
> > +    #[inline]
> > +    pub fn read_pdu<T: FromBytes>(&self) -> Result<T> {
> 
> This takes &self,
> 
> > +        // SAFETY: `self.inner` is guaranteed by the type invariant to point
> > +        // to a live `io_uring_cmd`, so dereferencing is safe.
> > +        let inner = unsafe { &mut *self.inner.get() };
> 
> But this creates a &mut to self.inner using unsafe code. Avoid doing this in
> general. All of a sudden your type is not thread-safe anymore.
> 
> If you need to mutate &self here, then take &mut self as an argument.
> 
> > +
> > +        let len = size_of::<T>();
> > +        if len > inner.pdu.len() {
> > +            return Err(EFAULT);
> 
> EFAULT? How about EINVAL?

Good.
> 
> > +        }
> > +
> > +        let mut out: MaybeUninit<T> = MaybeUninit::uninit();
> > +        let ptr = &raw mut inner.pdu as *const c_void;
> > +
> > +        // SAFETY:
> > +        // * The `ptr` is valid pointer from `self.inner` that is guaranteed by type invariant.
> > +        // * The `out` is valid pointer that points `T` which impls `FromBytes` and checked
> > +        //   size of `T` is smaller than pdu size.
> > +        unsafe {
> > +            core::ptr::copy_nonoverlapping(ptr, out.as_mut_ptr().cast::<c_void>(), len);
> 
> I don´t think you need to manually specify c_void here.
> 
> Benno, can´t we use core::mem::zeroed() or something like that to avoid this unsafe?
> 
> The input was zeroed in prep() and the output can just be a zeroed T on the
> stack, unless I missed something?
> 
> > +        }
> > +
> > +        // SAFETY: The read above has initialized all bytes in `out`, and since `T` implements
> > +        // `FromBytes`, any bit-pattern is a valid value for this type.
> > +        Ok(unsafe { out.assume_init() })
> > +    }
> > +
> > +    /// Writes the provided `value` to `pdu` in uring_cmd `self`
> 
> Writes the provided `value` to `pdu`.

Thanks.
> 
> > +    ///
> 
> /// # Errors
> ///

Thanks.
> 
> > +    /// Fails with [`EFAULT`] if size of `T` is bigger than pdu size.
> 
> > +    #[inline]
> > +    pub fn write_pdu<T: AsBytes>(&mut self, value: &T) -> Result<()> {
> > +        // SAFETY: `self.inner` is guaranteed by the type invariant to point
> > +        // to a live `io_uring_cmd`, so dereferencing is safe.
> > +        let inner = unsafe { &mut *self.inner.get() };
> > +
> > +        let len = size_of::<T>();
> > +        if len > inner.pdu.len() {
> > +            return Err(EFAULT);
> > +        }
> > +
> > +        let src = (value as *const T).cast::<c_void>();
> 
> as_ptr().cast()
> 
> > +        let dst = &raw mut inner.pdu as *mut c_void;
> 
> (&raw mut inner.pdu).cast()
> 

Thanks.
> > +
> > +        // SAFETY:
> > +        // * The `src` is points valid memory that is guaranteed by `T` impls `AsBytes`
> > +        // * The `dst` is valid. It's from `self.inner` that is guaranteed by type invariant.
> > +        // * It's safe to copy because size of `T` is no more than len of pdu.
> > +        unsafe {
> > +            core::ptr::copy_nonoverlapping(src, dst, len);
> > +        }
> > +
> > +        Ok(())
> > +    }
> > +
> > +    /// Constructs a new [`IoUringCmd`] from a raw `io_uring_cmd`
> 
> Missing period.

Thanks.
> 
> > +    ///
> > +    /// # Safety
> > +    ///
> > +    /// The caller must guarantee that:
> > +    /// - `ptr` is non-null, properly aligned, and points to a valid
> > +    ///   `bindings::io_uring_cmd`.
> 
> Blanks for every bullet point, please.

Thanks.
> 
> > +    /// - The pointed-to memory remains initialized and valid for the entire
> > +    ///   lifetime `'a` of the returned reference.
> > +    /// - While the returned `Pin<&'a mut IoUringCmd>` is alive, the underlying
> > +    ///   object is **not moved** (pinning requirement).
> 
> They can´t move an !Unpin type in safe code.

Okay, this could be removed.
> 
> > +    /// - **Aliasing rules:** the returned `&mut` has **exclusive** access to the same
> > +    ///   object for its entire lifetime:
> 
> You really don´t need to emphasize these.

Okay.
> 
> > +    ///   - No other `&mut` **or** `&` references to the same `io_uring_cmd` may be
> > +    ///     alive at the same time.
> 
> This and the point above are identical.

It would be removed.
> 
> > +    ///   - There must be no concurrent reads/writes through raw pointers, FFI, or
> > +    ///     other kernel paths to the same object during this lifetime.
> 
> This and the first point say the same thing.
> 
> > +    ///   - If the object can be touched from other contexts (e.g. IRQ/another CPU),
> > +    ///     the caller must provide synchronization to uphold this exclusivity.
> 
> I am not sure what you mean.
> > +    /// - This function relies on `IoUringCmd` being `repr(transparent)` over
> > +    ///   `bindings::io_uring_cmd` so the cast preserves layout.
> 
> This is not a safety requirement.
> 
> Just adapt the requirements from other instances of from_raw(), they all
> convert a *mut T to a &T so the safety requirements are similar.
> 

Okay, This safety comments are too redundant. I'll rewrite this. Thanks.
> > +    #[inline]
> > +    pub unsafe fn from_raw<'a>(ptr: *mut bindings::io_uring_cmd) -> Pin<&'a mut IoUringCmd> {
> 
> Why is this pub? Sounds like a massive footgun? This should be private or at
> best pub(crate).

Because from_raw() would be used in miscdevice. pub(crate) will be okay.
> 
> 
> > +        // SAFETY:
> > +        // * The caller guarantees that the pointer is not dangling and stays
> > +        //   valid for the duration of 'a.
> > +        // * The cast is okay because `IoUringCmd` is `repr(transparent)` and
> > +        //   has the same memory layout as `bindings::io_uring_cmd`.
> > +        // * The returned `Pin` ensures that the object cannot be moved, which
> > +        //   is required because the kernel may hold pointers to this memory
> > +        //   location and moving it would invalidate those pointers.
> 
> > +        unsafe { Pin::new_unchecked(&mut *ptr.cast()) }
> > +    }
> > +
> > +    /// Returns the file that referenced by uring cmd self.
> > +    #[inline]
> > +    pub fn file(&self) -> &File {
> > +        // SAFETY: `self.inner` is guaranteed by the type invariant to point
> > +        // to a live `io_uring_cmd`, so dereferencing is safe.
> > +        let file = unsafe { (*self.inner.get()).file };
> > +
> > +        // SAFETY:
> > +        // * The `file` points valid file.
> 
> Why?

`file` is from `self.inner` which is guranteed by the type invariant. I missed the
comment.
> 
> > +        // * refcount is positive after submission queue entry issued.
> > +        // * There is no active fdget_pos region on the file on this thread.
> > +        unsafe { File::from_raw_file(file) }
> > +    }
> > +
> > +    /// Returns an reference to the [`IoUringSqe`] associated with this command.
> 
> s/an/a

Thanks.

> 
> > +    #[inline]
> > +    pub fn sqe(&self) -> &IoUringSqe {
> > +        // SAFETY: `self.inner` is guaranteed by the type invariant to point
> > +        // to a live `io_uring_cmd`, so dereferencing is safe.
> > +        let sqe = unsafe { (*self.inner.get()).sqe };
> > +        // SAFETY: The call guarantees that the `sqe` points valid io_uring_sqe.
> 
> What do you mean by "the call guarantees" ?

It's just miss. This should be "This call is guaranteed to be safe because...". 
> 
> > +        unsafe { IoUringSqe::from_raw(sqe) }
> > +    }
> > +
> > +    /// Completes an this [`IoUringCmd`] request that was previously queued.
> 
> This sentence does not parse very well.

I'll fix this. Thanks.
> 
> > +    ///
> > +    /// # Safety
> > +    ///
> > +    /// - This function must be called **only** for a command whose `uring_cmd`
> 
> Please no emphasis.

Thanks.
> 
> > +    ///   handler previously returned **`-EIOCBQUEUED`** to io_uring.
> 
> To what? Are you referring to a Rust type, or to the C part of the kernel?

I referred C type but it's better to use Rust return type.
> 
> > +    ///
> > +    /// # Parameters
> > +    ///
> > +    /// - `ret`: Result to return to userspace.
> > +    /// - `res2`: Extra for big completion queue entry `IORING_SETUP_CQE32`.
> 
> This sentence does not parse very well. Also, can you rename this?

Okay.
> 
> > +    /// - `issue_flags`: Flags associated with this request, typically the same
> > +    ///   as those passed to the `uring_cmd` handler.
> > +    #[inline]
> > +    pub fn done(self: Pin<&mut IoUringCmd>, ret: Result<i32>, res2: u64, issue_flags: u32) {
> > +        let ret = from_result(|| ret) as isize;
> 
> What does this do?

It casts Result<i32> to isize. `bindings::io_uring_cmd_done` receives `isize`.
I wanted that `ret` would be `Result` than just i32. `ret` should be just isize?

> 
> > +        // SAFETY: The call guarantees that `self.inner` is not dangling and stays valid
> 
> What do you mean "the call" ?

Sorry, "This call is guruanteed to be safe ..."
> 
> > +        unsafe {
> > +            bindings::io_uring_cmd_done(self.inner.get(), ret, res2, issue_flags);
> > +        }
> > +    }
> > +}
> > +
> > +/// A Rust abstraction for the Linux kernel's `io_uring_sqe` structure.
> 
> Please don´t mention the words "Linux kernel" here either.

Yes.
> 
> > +///
> > +/// This structure is a safe, opaque wrapper around the raw C [`io_uring_sqe`](srctree/include/uapi/linux/io_uring.h)
> 
> This line needs to be wrapped.

Okay.
> 
> > +/// binding from the Linux kernel. It represents a Submission Queue Entry
> 
> Can you link somewhere here? Perhaps there´s docs for "Submission Queue
> Entry".

Okay I'll find it.
> 
> > +/// used in io_uring operations within the kernel.
> > +///
> > +/// # Type Safety
> > +///
> > +/// The `#[repr(transparent)]` attribute ensures that this wrapper has
> > +/// the same memory layout as the underlying `io_uring_sqe` structure,
> > +/// allowing it to be safely transmuted between the two representations.
> 
> This is an invariant, please move it there.

Thanks.
> 
> > +///
> > +/// # Fields
> > +///
> > +/// * `inner` - An opaque wrapper containing the actual `io_uring_sqe` data.
> > +///             The `Opaque` type prevents direct access to the internal
> > +///             structure fields, ensuring memory safety and encapsulation.
> 
> Inline docs please.

Okay.
> 
> > +///
> > +/// # Usage
> 
> I don´t think we specifically need to mention "# Usage".

Okay it would be deleted.
> 
> > +///
> > +/// This type represents a submission queue entry that describes an I/O
> 
> You can start with "Represents a...". No need to say "this type" here.

Thanks.
> 
> > +/// operation to be executed by the io_uring subsystem. It contains
> > +/// information such as the operation type, file descriptor, buffer
> > +/// pointers, and other operation-specific data.
> > +///
> > +/// Users can obtain this type from [`IoUringCmd::sqe()`] method, which
> > +/// extracts the submission queue entry associated with a command.
> > +///
> > +/// This type should not be constructed or manipulated directly by
> > +/// kernel module developers.
> 
> By drivers.

Thanks.

> 
> > +///
> > +/// # INVARIANT
> 
> /// # Invariants

Thanks.
> 
> > +/// - `self.inner` always points to a valid, live `bindings::io_uring_sqe`.
> > +#[repr(transparent)]
> > +pub struct IoUringSqe {
> > +    inner: Opaque<bindings::io_uring_sqe>,
> > +}
> > +
> > +impl IoUringSqe {
> > +    /// Reads and interprets the `cmd` field of an `bindings::io_uring_sqe` as a value of type `T`.
> > +    ///
> > +    /// # Safety & Invariants
> 
> Safety section for a safe function.

Thanks.
> 
> > +    /// - Construction of `T` is delegated to `FromBytes`, which guarantees that `T` has no
> > +    ///   invalid bit patterns and can be safely reconstructed from raw bytes.
> > +    /// - **Limitation:** This implementation does not support `IORING_SETUP_SQE128` (larger SQE entries).
> 
> Please no emphasis.

Okay.
> 
> 
> > +    ///   Only the standard `io_uring_sqe` layout is handled here.
> > +    ///
> > +    /// # Errors
> 
> Blank here.

Thanks.
> 
> > +    /// * Returns `EINVAL` if the `self` does not hold a `opcode::URING_CMD`.
> > +    /// * Returns `EFAULT` if the command buffer is smaller than the requested type `T`.
> > +    ///
> > +    /// # Returns
> 
> I don´t think we need a specific section for this. Just write this in
> normal prose please.

Okay.
> 
> 
> > +    /// * On success, returns a `T` deserialized from the `cmd`.
> > +    /// * On failure, returns an appropriate error as described above.
> > +    pub fn cmd_data<T: FromBytes>(&self) -> Result<T> {
> > +        // SAFETY: `self.inner` guaranteed by the type invariant to point
> > +        // to a live `io_uring_sqe`, so dereferencing is safe.
> > +        let sqe = unsafe { &*self.inner.get() };
> > +
> > +        if u32::from(sqe.opcode) != opcode::URING_CMD {
> > +            return Err(EINVAL);
> > +        }
> > +
> > +        // SAFETY: Accessing the `sqe.cmd` union field is safe because we've
> > +        // verified that `sqe.opcode == IORING_OP_URING_CMD`, which guarantees
> > +        // that this union variant is initialized and valid.
> > +        let cmd = unsafe { sqe.__bindgen_anon_6.cmd.as_ref() };
> > +        let cmd_len = size_of_val(&sqe.__bindgen_anon_6.bindgen_union_field);
> > +
> > +        if cmd_len < size_of::<T>() {
> > +            return Err(EFAULT);
> 
> EINVAL

Thanks.
> 
> > +        }
> > +
> > +        let cmd_ptr = cmd.as_ptr() as *mut T;
> 
> cast()

Thanks.
> 
> > +
> > +        // SAFETY: `cmd_ptr` is valid from `self.inner` which is guaranteed by
> > +        // type variant. And also it points to initialized `T` from userspace.
> 
> "Invariant".

Thanks!
> 
> "[...] an initialized T".

Thanks.
> 
> 
> > +        let ret = unsafe { core::ptr::read_unaligned(cmd_ptr) };
> > +
> > +        Ok(ret)
> > +    }
> > +
> > +    /// Constructs a new `IoUringSqe` from a raw `io_uring_sqe`.
> 
> [`IoUringSqe`].
> 
> Please build the docs and make sure all your docs look nice.

Okay, I'll review comments by docs.
> 
> > +    ///
> > +    /// # Safety
> > +    ///
> > +    /// The caller must guarantee that:
> > +    /// - `ptr` is non-null, properly aligned, and points to a valid initialized
> > +    ///   `bindings::io_uring_sqe`.
> > +    /// - The pointed-to memory remains valid (not freed or repurposed) for the
> > +    ///   entire lifetime `'a` of the returned reference.
> > +    /// - **Aliasing rules (for `&T`):** while the returned `&'a IoUringSqe` is
> > +    ///   alive, there must be **no mutable access** to the same object through any
> > +    ///   path (no `&mut`, no raw-pointer writes, no FFI/IRQ/other-CPU writers).
> > +    ///   Multiple `&` is fine **only if all of them are read-only** for the entire
> > +    ///   overlapping lifetime.
> > +    /// - This relies on `IoUringSqe` being `repr(transparent)` over
> > +    ///   `bindings::io_uring_sqe`, so the cast preserves layout.
> 
> Please rewrite this entire section given the feedback I gave higher up in this
> patch.

Okay. I'll rewrite this.
> 
> > +    #[inline]
> > +    pub unsafe fn from_raw<'a>(ptr: *const bindings::io_uring_sqe) -> &'a IoUringSqe {
> 
> Private or pub(crate) at best.

Okay. pub(crate)
> 
> > +        // SAFETY: The caller guarantees that the pointer is not dangling and stays valid for the
> > +        // duration of 'a. The cast is okay because `IoUringSqe` is `repr(transparent)` and has the
> > +        // same memory layout as `bindings::io_uring_sqe`.
> > +        unsafe { &*ptr.cast() }
> > +    }
> > +}
> > diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
> > index ed53169e795c..d38cf7137401 100644
> > --- a/rust/kernel/lib.rs
> > +++ b/rust/kernel/lib.rs
> > @@ -91,6 +91,7 @@
> > pub mod fs;
> > pub mod init;
> > pub mod io;
> > +pub mod io_uring;
> > pub mod ioctl;
> > pub mod jump_label;
> > #[cfg(CONFIG_KUNIT)]
> > -- 
> > 2.43.0
> > 
> 

Thanks for detailed review!
I'll revise the comments overall.
Also there would be new type for opcode.

Thanks,
Sidong

