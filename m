Return-Path: <io-uring+bounces-8883-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 50FC9B1ACD5
	for <lists+io-uring@lfdr.de>; Tue,  5 Aug 2025 05:40:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E3A5818A0116
	for <lists+io-uring@lfdr.de>; Tue,  5 Aug 2025 03:40:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B396F1C75E2;
	Tue,  5 Aug 2025 03:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="iqki1PxY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E26D6ADD
	for <io-uring@vger.kernel.org>; Tue,  5 Aug 2025 03:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754365209; cv=none; b=UHqjkwqo8Ejl8QIe2kyHc7hApq3JSYB9LDYuhmYz0psTSO3tg0ZRxjJuMvGBhUGARbyFJs67EBPqcLMMWRGeU4PEsHhZ6RNruNF4mcrByRnzYoVYlsDUBByNXlmNc9+pE1Zby9EgoVeOBCOcnDYnpHkASlV94XBIDY7Tf7m6n9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754365209; c=relaxed/simple;
	bh=Aecn+N+PV2faHP5yCdQdiFz9AaRWRtVnw+CjGrEtMRM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EK2BZ+3NVprEkb0EP6TfU7nWHa/XTLRkbHPmzG++vBseKmA0z7oZll0nf0smPD8iYKO2BhGPv3s13gJit+lx+W5247vYItLB9x5xiq3neXCGYshgGyNj52TVdzT8Roic1rsWBNTF4rGbL62ANH7JmpiPn4Khv8JYncJOd0tTZMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=iqki1PxY; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2407235722bso55159065ad.1
        for <io-uring@vger.kernel.org>; Mon, 04 Aug 2025 20:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1754365207; x=1754970007; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=a1JU4FS8kYW1CWPQmxZIHp9H+RSxgq3bqdqexRw7Ndk=;
        b=iqki1PxYv/Wq7I0xDmGyj968pHPTzXrcztSPvbWAF+xRpdO5ouCK50TGvX0Y3ptG7t
         zlnvo5PoczS/NzBzRMVe0mwjKGpINueEcS/Le2LGmRhbIZER3oXMYWqwLtWXDPRtxino
         FsUzVK7OnXGj4nHMSiz6RcyPhP8szeu/DNYks=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754365207; x=1754970007;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a1JU4FS8kYW1CWPQmxZIHp9H+RSxgq3bqdqexRw7Ndk=;
        b=Md8i7BALdExV09rhq6e1/yftjcn5Bk0miVqNWeZIqnofhcZBnpp5Ndi/z1ghLsC8Bo
         K09g0kQjJh0PPuDk95kGXi1fvJrt7kyOJ0zG+akd2c9j3HuKszcA/WuGpzCMKrLVJsHv
         dcIy1lPFyRVtBvxcoy+Y2ryhPZaupGr7JI08q2quJpAd1hTA9w5Mj60iHSPNs+3cXNvj
         oaM1exZX6Gb0Gh8cViOnGJv2ybLoL+HaNwIsTGCS2FS0VSnZ080N4Fo+GlO0DdStKQb0
         N9S9Ecolm61bGo3hZKRjdvRrHSlJuslo/YKYLLEyRcFPq+lEllQyMvZrqxmZw+ubtwv3
         X3OA==
X-Forwarded-Encrypted: i=1; AJvYcCXnIG+nsZN/NGPHMxGkkA9WATrnNDDkIQWpkMQMfBi2mUZ0vMEguJ0Pg5tZbtLiQm+MYlr5UjMRWA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3MtSG2ub1yexq83y5iZh9Gl4Ou2poFcIqAzBQpDNAUIzRvYOR
	n0ItuN7vGAuDw1MuSlpUXBEyc3t32H0EauGyIfmSwMIiymQt4r1vxotKxDajfc6/YHI=
X-Gm-Gg: ASbGncs9R6FGh8u+IQDb4cT5FRc69q+HqXuWZVzpdPh1+sH35fo1gNyRsVPrNcRBd7H
	fYvMaFrzQlvzVVmZVpzmRJxt58TcjmKaLaWmkAEnG8B5XZ21EfTnaUUJ8krUIxQUIDwf8zNhQ7M
	Hv+NNGlVwvaAq0c0wNdhcRW7JQaRp18qnEaBPTj9lYGp7mFaaufQFlxOs4frv1DzVB/AYR3e9ah
	r0Ow8z43yvf4DX0XeNgRJLjnbWs1s79yVczuyKa8/c8XSgb5pP9GcHRIwj9XqklsmRQTHAP/5YO
	f19FB4ogv5u/namePDD1iETQelGoIwkf8n+4Sul3MTXtJJ5PG07VPmRZI+Q+Y2I+T5GNmrKwtkH
	QCPZ/VnKcVWlnNy8T8mDu3mNYVgsRe7dP1EJ71+xKJiD/iUdHUGjEEuI=
X-Google-Smtp-Source: AGHT+IHTcVM3q0I5xWJDAtf9e0dkEZb4JYcSwdUDr1KdmWRf6kJlehP8vobdCmWXoHpYpwWVcNjKzw==
X-Received: by 2002:a17:902:d482:b0:235:e9fe:83c0 with SMTP id d9443c01a7336-24246fefe69mr160033035ad.27.1754365206782;
        Mon, 04 Aug 2025 20:40:06 -0700 (PDT)
Received: from sidongui-MacBookPro.local ([175.195.128.78])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1ef595esm120298645ad.13.2025.08.04.20.40.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 20:40:06 -0700 (PDT)
Date: Tue, 5 Aug 2025 12:39:51 +0900
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Daniel Almeida <daniel.almeida@collabora.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Benno Lossin <lossin@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/4] rust: io_uring: introduce rust abstraction
 for io-uring cmd
Message-ID: <aJF9B0sV__t2oG20@sidongui-MacBookPro.local>
References: <20250727150329.27433-1-sidong.yang@furiosa.ai>
 <20250727150329.27433-3-sidong.yang@furiosa.ai>
 <D6CDE1A5-879F-49B1-9E10-2998D04B678F@collabora.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <D6CDE1A5-879F-49B1-9E10-2998D04B678F@collabora.com>

On Fri, Aug 01, 2025 at 10:48:40AM -0300, Daniel Almeida wrote:

Hi Daniel,

> Hi Sidong,
> 
> > On 27 Jul 2025, at 12:03, Sidong Yang <sidong.yang@furiosa.ai> wrote:
> > 
> > This patch introduces rust abstraction for io-uring sqe, cmd. IoUringSqe
> > abstracts io_uring_sqe and it has cmd_data(). and IoUringCmd is
> > abstraction for io_uring_cmd. From this, user can get cmd_op, flags,
> > pdu and also sqe.
> 
> IMHO you need to expand this substantially.
> 
> Instead of a very brief discussion of *what* you're doing, you need to explain
> *why* you're doing this and how this patch fits with the overall plan that you
> have in mind.

It seems that it's hard to explain *why* deeply. But I'll try it.

> 
> Also, for the sake of reviewers, try to at least describe the role of all the
> types you've mentioned.

Okay, I'll add some detailed descrption for all types like IoUringCmd.
> 
> > 
> > Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> > ---
> > rust/kernel/io_uring.rs | 183 ++++++++++++++++++++++++++++++++++++++++
> > rust/kernel/lib.rs      |   1 +
> > 2 files changed, 184 insertions(+)
> > create mode 100644 rust/kernel/io_uring.rs
> > 
> > diff --git a/rust/kernel/io_uring.rs b/rust/kernel/io_uring.rs
> > new file mode 100644
> > index 000000000000..0acdf3878247
> > --- /dev/null
> > +++ b/rust/kernel/io_uring.rs
> > @@ -0,0 +1,183 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +// Copyright (C) 2025 Furiosa AI.
> > +
> 
> Perhaps this instead [0].

Thanks, I'll change it with the format.
> 
> 
> > +//! IoUring command and submission queue entry abstractions.
> 
> Maybe expand this just a little bit as well.

Okay.
> 
> > +//!
> > +//! C headers: [`include/linux/io_uring/cmd.h`](srctree/include/linux/io_uring/cmd.h) and
> > +//! [`include/linux/io_uring/io_uring.h`](srctree/include/linux/io_uring/io_uring.h)
> > +
> > +use core::{mem::MaybeUninit, pin::Pin, ptr::addr_of_mut};
> > +
> > +use crate::{fs::File, types::Opaque};
> > +
> > +/// A Rust abstraction for the Linux kernel's `io_uring_cmd` structure.
> 
> Is there a link for io_uring_cmd that you can use here?

Yes, I'll add a link for the struct.
> 
> > +///
> > +/// This structure is a safe, opaque wrapper around the raw C `io_uring_cmd`
> > +/// binding from the Linux kernel. It represents a command structure used
> > +/// in io_uring operations within the kernel.
> 
> Perhaps backticks on "io_uring" ?

Thanks.
> 
> > +///
> > +/// # Type Safety
> > +///
> > +/// The `#[repr(transparent)]` attribute ensures that this wrapper has
> > +/// the same memory layout as the underlying `io_uring_cmd` structure,
> > +/// allowing it to be safely transmuted between the two representations.
> > +///
> > +/// # Fields
> > +///
> > +/// * `inner` - An opaque wrapper containing the actual `io_uring_cmd` data.
> > +///             The `Opaque` type prevents direct access to the internal
> > +///             structure fields, ensuring memory safety and encapsulation.
> 
> Place this on top of the field itself please. Also, I don´t think you need
> this at all because you don't need to explain the Opaque type, as it's
> extensively used in the kernel crate.

Okay, I'll move this comments to code with the field.
> 
> > +///
> > +/// # Usage
> 
> I don´t think you need this.

Okay.
> 
> > +///
> > +/// This type is used internally by the io_uring subsystem to manage
> > +/// asynchronous I/O commands. It is typically accessed through a pinned
> > +/// mutable reference: `Pin<&mut IoUringCmd>`. The pinning ensures that
> > +/// the structure remains at a fixed memory location, which is required
> > +/// for safe interaction with the kernel's io_uring infrastructure.
> 
> I don´t think you need anything other than:

Thanks, It's too verbose. I'll rewrite this.
> 
> > +/// This type is used internally by the io_uring subsystem to manage
> > +/// asynchronous I/O commands.
> 
> Specifically, you don´t need to say this:
> 
> >  The pinning ensures that
> > +/// the structure remains at a fixed memory location,
> 
> 
> 
> > +///
> > +/// Users typically receive this type as an argument in the `file_operations::uring_cmd()`
> > +/// callback function, where they can access and manipulate the io_uring command
> > +/// data for custom file operations.
> > +///
> > +/// This type should not be constructed or manipulated directly by
> > +/// kernel module developers.
> 
> Well, this is pub, so the reality is that it can be manipulated directly
> through whatever public API it offers.
> 

Agreed, We should provide safe pub fns that it doesn't corrupt the inner state.

> > +#[repr(transparent)]
> > +pub struct IoUringCmd {
> > +    inner: Opaque<bindings::io_uring_cmd>,
> > +}
> > +
> > +impl IoUringCmd {
> > +    /// Returns the cmd_op with associated with the io_uring_cmd.
> 
> Backticks
Thanks.
> 
> > +    #[inline]
> > +    pub fn cmd_op(&self) -> u32 {
> > +        // SAFETY: The call guarantees that `self.inner` is not dangling and stays valid
> 
> Not sure I understand what you´re trying to say here. Perhaps add an
> invariant saying that `self.inner` always points to a valid
> `bindings::io_uring_cmd` and mention that here instead.

Thanks, I'll add INVARIANT comment for self.inner and reference it in this comment.
> 
> > +        unsafe { (*self.inner.get()).cmd_op }
> > +    }
> > +
> > +    /// Returns the flags with associated with the io_uring_cmd.
> > +    #[inline]
> > +    pub fn flags(&self) -> u32 {
> > +        // SAFETY: The call guarantees that `self.inner` is not dangling and stays valid
> > +        unsafe { (*self.inner.get()).flags }
> > +    }
> > +
> > +    /// Returns the ref pdu for free use.
> 
> I have no idea what "ref pdu" is. You need to describe these acronyms.

Okay. Thanks.
> 
> > +    #[inline]
> > +    pub fn pdu(&mut self) -> &mut MaybeUninit<[u8; 32]> {
> 
> Why MaybeUninit? Also, this is a question for others, but I don´t think
> that `u8`s can ever be uninitialized as all byte values are valid for `u8`.
> 
> > +        // SAFETY: The call guarantees that `self.inner` is not dangling and stays valid
> > +        let inner = unsafe { &mut *self.inner.get() };
> > +        let ptr = addr_of_mut!(inner.pdu) as *mut MaybeUninit<[u8; 32]>;
> 
> &raw mut

I didn't know about this. Thanks.
> 
> > +
> > +        // SAFETY: The call guarantees that `self.inner` is not dangling and stays valid
> > +        unsafe { &mut *ptr }
> > +    }
> > +
> > +    /// Constructs a new `IoUringCmd` from a raw `io_uring_cmd`
> 
> [`IoUringCmd`]
> 
> By the way, always build the docs and see if they look nice.

Thanks.
> 
> > +    ///
> > +    /// # Safety
> > +    ///
> > +    /// The caller must guarantee that:
> > +    /// - The pointer `ptr` is not null and points to a valid `bindings::io_uring_cmd`.
> > +    /// - The memory pointed to by `ptr` remains valid for the duration of the returned reference's lifetime `'a`.
> > +    /// - The memory will not be moved or freed while the returned `Pin<&mut IoUringCmd>` is alive.
> 
> This returns a wrapper over a mutable reference. You must mention Rust´s aliasing rules here.

Okay. Thanks.
> 
> > +    #[inline]
> > +    pub unsafe fn from_raw<'a>(ptr: *mut bindings::io_uring_cmd) -> Pin<&'a mut IoUringCmd> {
> > +        // SAFETY: The caller guarantees that the pointer is not dangling and stays valid for the
> > +        // duration of 'a. The cast is okay because `IoUringCmd` is `repr(transparent)` and has the
> > +        // same memory layout as `bindings::io_uring_cmd`. The returned `Pin` ensures that the object
> > +        // cannot be moved, which is required because the kernel may hold pointers to this memory
> > +        // location and moving it would invalidate those pointers.
> 
> Please break this into multiple paragraphs.

Thanks.
> 
> > +        unsafe { Pin::new_unchecked(&mut *ptr.cast()) }
> > +    }
> > +
> > +    /// Returns the file that referenced by uring cmd self.
> > +    #[inline]
> > +    pub fn file(&self) -> &File {
> > +        // SAFETY: The call guarantees that the `self.inner` is not dangling and stays valid
> > +        let file = unsafe { (*self.inner.get()).file };
> > +        // SAFETY: The call guarantees that `file` points valid file.
> > +        unsafe { File::from_raw_file(file) }
> > +    }
> > +
> > +    /// Returns a reference to the uring cmd's SQE.
> 
> Please define what `SQE` means. Add links if possible.

Okay. Thanks.
> 
> > +    #[inline]
> > +    pub fn sqe(&self) -> &IoUringSqe {
> > +        // SAFETY: The call guarantees that the `self.inner` is not dangling and stays valid
> > +        let sqe = unsafe { (*self.inner.get()).sqe };
> > +        // SAFETY: The call guarantees that the `sqe` points valid io_uring_sqe.
> 
> Backticks

Thanks.
> 
> > +        unsafe { IoUringSqe::from_raw(sqe) }
> > +    }
> > +
> > +    /// Called by consumers of io_uring_cmd, if they originally returned -EIOCBQUEUED upon receiving the command
> 
> Backticks

Thanks.
> 
> > +    #[inline]
> > +    pub fn done(self: Pin<&mut IoUringCmd>, ret: isize, res2: u64, issue_flags: u32) {
> 
> The arguments are cryptic here. Please let us know what they do.

Thanks I'll add description for each arguments.
> 
> > +        // SAFETY: The call guarantees that `self.inner` is not dangling and stays valid
> > +        unsafe {
> > +            bindings::io_uring_cmd_done(self.inner.get(), ret, res2, issue_flags);
> > +        }
> > +    }
> > +}
> > +
> > +/// A Rust abstraction for the Linux kernel's `io_uring_sqe` structure.
> > +///
> > +/// This structure is a safe, opaque wrapper around the raw C `io_uring_sqe`
> > +/// binding from the Linux kernel. It represents a Submission Queue Entry
> 
> Ah, SQE == Submission Queue Entry. Is there a link for this?

I'll add a link for this.
> 
> > +/// used in io_uring operations within the kernel.
> > +///
> > +/// # Type Safety
> > +///
> > +/// The `#[repr(transparent)]` attribute ensures that this wrapper has
> > +/// the same memory layout as the underlying `io_uring_sqe` structure,
> > +/// allowing it to be safely transmuted between the two representations.
> > +///
> > +/// # Fields
> > +///
> > +/// * `inner` - An opaque wrapper containing the actual `io_uring_sqe` data.
> > +///             The `Opaque` type prevents direct access to the internal
> > +///             structure fields, ensuring memory safety and encapsulation.
> > +///
> > +/// # Usage
> > +///
> > +/// This type represents a submission queue entry that describes an I/O
> > +/// operation to be executed by the io_uring subsystem. It contains
> > +/// information such as the operation type, file descriptor, buffer
> > +/// pointers, and other operation-specific data.
> 
> This description is very good :)

Thanks. :)
> 
> > +///
> > +/// Users can obtain this type from `IoUringCmd::sqe()` method, which
> > +/// extracts the submission queue entry associated with a command.
> 
> [`IoUringCmd::sqe`]

Thanks.
> 
> > +///
> > +/// This type should not be constructed or manipulated directly by
> > +/// kernel module developers.
> 
> Again, this is pub and can be freely manipulated through whatever
> public API it offers.

Okay.
> 
> > +#[repr(transparent)]
> > +pub struct IoUringSqe {
> > +    inner: Opaque<bindings::io_uring_sqe>,
> > +}
> > +
> > +impl<'a> IoUringSqe {
> 
> Why is this `a here?

It seems that I can delete 'a here. 
> 
> > +    /// Returns the cmd_data with associated with the io_uring_sqe.
> > +    /// This function returns 16 byte array. We don't support IORING_SETUP_SQE128 for now.
> > +    pub fn cmd_data(&'a self) -> &'a [Opaque<u8>] {
> 
> This is automatically placed by the compiler. See the lifetime elision rules
> [1].
> 
Thanks.

> Also why does this return a reference to an array of Opaque<u8>?
> 
> You can return a &[u8] here if you can prove that this reference is legal given
> Rust's aliasing rules. If you can't, then you have to look at what the DMA
> allocator code is doing and use that as an example, i.e.: have a look at the
> dma_read and dma_write macros and mark the function that returns the slice as
> "unsafe".
> 

Okay. It's better to use &[u8].

> > +        // SAFETY: The call guarantees that `self.inner` is not dangling and stays valid
> > +        let cmd = unsafe { (*self.inner.get()).__bindgen_anon_6.cmd.as_ref() };
> 
> What do you mean by "the call" ? Same in all other places where this sentence is used.
Thanks, it should be dereferecing than call.

> > +
> > +        // SAFETY: The call guarantees that `cmd` is not dangling and stays valid
> > +        unsafe { core::slice::from_raw_parts(cmd.as_ptr() as *const Opaque<u8>, 16) }
> > +    }
> > +
> > +    /// Constructs a new `IoUringSqe` from a raw `io_uring_sqe`
> > +    ///
> > +    /// # Safety
> > +    ///
> > +    /// The caller must guarantee that:
> > +    /// - The pointer `ptr` is not null and points to a valid `bindings::io_uring_sqe`.
> > +    /// - The memory pointed to by `ptr` remains valid for the duration of the returned reference's lifetime `'a`.
> 
> Must mention Rust´s aliasing rules here.

Okay. Thanks.
> 
> > +    #[inline]
> > +    pub unsafe fn from_raw(ptr: *const bindings::io_uring_sqe) -> &'a IoUringSqe {
> > +        // SAFETY: The caller guarantees that the pointer is not dangling and stays valid for the
> > +        // duration of 'a. The cast is okay because `IoUringSqe` is `repr(transparent)` and has the
> > +        // same memory layout as `bindings::io_uring_sqe`.
> > +        unsafe { &*ptr.cast() }
> > +    }
> > +}
> > diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
> > index 6b4774b2b1c3..fb310e78d51d 100644
> > --- a/rust/kernel/lib.rs
> > +++ b/rust/kernel/lib.rs
> > @@ -80,6 +80,7 @@
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
> > 
> 
> [0] https://spdx.github.io/spdx-spec/v3.0.1/model/Software/Properties/copyrightText/
> [1] https://doc.rust-lang.org/reference/lifetime-elision.html

