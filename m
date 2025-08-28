Return-Path: <io-uring+bounces-9357-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 34061B39023
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 02:37:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E912D17E01A
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 00:37:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42A7318C03F;
	Thu, 28 Aug 2025 00:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DZBelAiU"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C9352F99
	for <io-uring@vger.kernel.org>; Thu, 28 Aug 2025 00:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756341388; cv=none; b=Zn5X08/+j6BHwuddJrnMcHeIXn1rLkg5WHoI+Xn8yzKVLfvHaTLjyx6pS19ZnkfaO9FBBacbhSMPLr+Q4sKBPgEBwoDx+Hd+JuCTFiXxNxoUZqRDcdPMvaoZ1xuy7eIqK4I5TJfOiz2B64XE19fXXVNbmsmySnlckQTXyV9j/Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756341388; c=relaxed/simple;
	bh=CdLRkCX8XI/02EUSo5ic5GhdyXL2Nd+JxibJBpPujic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F6gC8QDlk5slo4A+HcCmUfvtwHzPVJr8T94uZlsRRa/Jh/yAI88tQNGk7TOs33szyrN73tfXLRp38MbkzkdKNGVOULThPrTRJVuWXMmSQhwv/A24Tz3zbw5TydL6lrchb9jZmWTVNDcGDSmQV0j9/ea/aiyNxn/ZfOxbxs+Zjqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DZBelAiU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756341385;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qnKysJL5GiqE+y97pHRbVvxIin+VVlNppF1nbhqMT9w=;
	b=DZBelAiUCHbzUrDyn1LstLT5BEibgrUJ47kgo0L7ptYlW2Q00+Oxrxnhyt//QYsV2xwz5r
	33l05UXUf9XyEj2X8W+D4pFwXLJkfE+CVRrmuxtxh/SbkaI8VLOnCNEyPpXtZVmqcRHpFq
	hsPHncJdKSMrsnPHahYyb919nniaU7o=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-688-p8oF4Ju0OnOLPVfEnO6v4A-1; Wed,
 27 Aug 2025 20:36:21 -0400
X-MC-Unique: p8oF4Ju0OnOLPVfEnO6v4A-1
X-Mimecast-MFC-AGG-ID: p8oF4Ju0OnOLPVfEnO6v4A_1756341379
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A4EF3180047F;
	Thu, 28 Aug 2025 00:36:19 +0000 (UTC)
Received: from fedora (unknown [10.72.116.22])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3EE7419560B2;
	Thu, 28 Aug 2025 00:36:12 +0000 (UTC)
Date: Thu, 28 Aug 2025 08:36:07 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Sidong Yang <sidong.yang@furiosa.ai>
Cc: Jens Axboe <axboe@kernel.dk>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Benno Lossin <lossin@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [RFC PATCH v3 3/5] rust: io_uring: introduce rust abstraction
 for io-uring cmd
Message-ID: <aK-kd3GBhxOzt_mA@fedora>
References: <20250822125555.8620-1-sidong.yang@furiosa.ai>
 <20250822125555.8620-4-sidong.yang@furiosa.ai>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250822125555.8620-4-sidong.yang@furiosa.ai>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Fri, Aug 22, 2025 at 12:55:53PM +0000, Sidong Yang wrote:
> Implment the io-uring abstractions needed for miscdevicecs and other
> char devices that have io-uring command interface.
> 
> * `io_uring::IoUringCmd` : Rust abstraction for `io_uring_cmd` which
>   will be used as arg for `MiscDevice::uring_cmd()`. And driver can get
>   `cmd_op` sent from userspace. Also it has `flags` which includes option
>   that is reissued.
> 
> * `io_uring::IoUringSqe` : Rust abstraction for `io_uring_sqe` which
>   could be get from `IoUringCmd::sqe()` and driver could get `cmd_data`
>   from userspace. Also `IoUringSqe` has more data like opcode could be used in
>   driver.
> 
> Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> ---
>  rust/kernel/io_uring.rs | 306 ++++++++++++++++++++++++++++++++++++++++
>  rust/kernel/lib.rs      |   1 +
>  2 files changed, 307 insertions(+)
>  create mode 100644 rust/kernel/io_uring.rs
> 
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
> +//! This module provides types for implements io-uring interface for char device.
> +//!
> +//!
> +//! C headers: [`include/linux/io_uring/cmd.h`](srctree/include/linux/io_uring/cmd.h) and
> +//! [`include/linux/io_uring/io_uring.h`](srctree/include/linux/io_uring/io_uring.h)
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
> +pub mod opcode {
> +    /// opcode for uring cmd
> +    pub const URING_CMD: u32 = bindings::io_uring_op_IORING_OP_URING_CMD;
> +}
> +
> +/// A Rust abstraction for the Linux kernel's `io_uring_cmd` structure.
> +///
> +/// This structure is a safe, opaque wrapper around the raw C `io_uring_cmd`
> +/// binding from the Linux kernel. It represents a command structure used
> +/// in io_uring operations within the kernel.
> +/// This type is used internally by the io_uring subsystem to manage
> +/// asynchronous I/O commands.
> +///
> +/// This type should not be constructed or manipulated directly by
> +/// kernel module developers.
> +///
> +/// # INVARIANT
> +/// - `self.inner` always points to a valid, live `bindings::io_uring_cmd`.
> +#[repr(transparent)]
> +pub struct IoUringCmd {
> +    /// An opaque wrapper containing the actual `io_uring_cmd` data.
> +    inner: Opaque<bindings::io_uring_cmd>,
> +}
> +
> +impl IoUringCmd {
> +    /// Returns the cmd_op with associated with the `io_uring_cmd`.
> +    #[inline]
> +    pub fn cmd_op(&self) -> u32 {
> +        // SAFETY: `self.inner` is guaranteed by the type invariant to point
> +        // to a live `io_uring_cmd`, so dereferencing is safe.
> +        unsafe { (*self.inner.get()).cmd_op }
> +    }
> +
> +    /// Returns the flags with associated with the `io_uring_cmd`.
> +    #[inline]
> +    pub fn flags(&self) -> u32 {
> +        // SAFETY: `self.inner` is guaranteed by the type invariant to point
> +        // to a live `io_uring_cmd`, so dereferencing is safe.
> +        unsafe { (*self.inner.get()).flags }
> +    }
> +
> +    /// Reads protocol data unit as `T` that impl `FromBytes` from uring cmd
> +    ///
> +    /// Fails with [`EFAULT`] if size of `T` is bigger than pdu size.
> +    #[inline]
> +    pub fn read_pdu<T: FromBytes>(&self) -> Result<T> {
> +        // SAFETY: `self.inner` is guaranteed by the type invariant to point
> +        // to a live `io_uring_cmd`, so dereferencing is safe.
> +        let inner = unsafe { &mut *self.inner.get() };
> +
> +        let len = size_of::<T>();
> +        if len > inner.pdu.len() {
> +            return Err(EFAULT);
> +        }
> +
> +        let mut out: MaybeUninit<T> = MaybeUninit::uninit();
> +        let ptr = &raw mut inner.pdu as *const c_void;
> +
> +        // SAFETY:
> +        // * The `ptr` is valid pointer from `self.inner` that is guaranteed by type invariant.
> +        // * The `out` is valid pointer that points `T` which impls `FromBytes` and checked
> +        //   size of `T` is smaller than pdu size.
> +        unsafe {
> +            core::ptr::copy_nonoverlapping(ptr, out.as_mut_ptr().cast::<c_void>(), len);
> +        }
> +
> +        // SAFETY: The read above has initialized all bytes in `out`, and since `T` implements
> +        // `FromBytes`, any bit-pattern is a valid value for this type.
> +        Ok(unsafe { out.assume_init() })
> +    }
> +
> +    /// Writes the provided `value` to `pdu` in uring_cmd `self`
> +    ///
> +    /// Fails with [`EFAULT`] if size of `T` is bigger than pdu size.
> +    #[inline]
> +    pub fn write_pdu<T: AsBytes>(&mut self, value: &T) -> Result<()> {
> +        // SAFETY: `self.inner` is guaranteed by the type invariant to point
> +        // to a live `io_uring_cmd`, so dereferencing is safe.
> +        let inner = unsafe { &mut *self.inner.get() };
> +
> +        let len = size_of::<T>();
> +        if len > inner.pdu.len() {
> +            return Err(EFAULT);
> +        }
> +
> +        let src = (value as *const T).cast::<c_void>();
> +        let dst = &raw mut inner.pdu as *mut c_void;
> +
> +        // SAFETY:
> +        // * The `src` is points valid memory that is guaranteed by `T` impls `AsBytes`
> +        // * The `dst` is valid. It's from `self.inner` that is guaranteed by type invariant.
> +        // * It's safe to copy because size of `T` is no more than len of pdu.
> +        unsafe {
> +            core::ptr::copy_nonoverlapping(src, dst, len);
> +        }
> +
> +        Ok(())
> +    }

pdu is part of IoUringCmd, which is live in the whole uring_cmd lifetime. But
both read_pdu()/write_pdu() needs copy to read or write any byte in the pdu, which
is slow and hard to use, it could be more efficient to add two methods to return
Result<&T> and Result<mut &T> for user to manipulate uring_cmd's pdu.


Thanks, 
Ming


