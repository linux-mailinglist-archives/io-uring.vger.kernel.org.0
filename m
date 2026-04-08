Return-Path: <io-uring+bounces-12996-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KG5mIXlg1mmDEwgAu9opvQ
	(envelope-from <io-uring+bounces-12996-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 16:04:41 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 024DA3BD61F
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 16:04:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C57F430803E4
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2026 14:01:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A9AD3D2FFC;
	Wed,  8 Apr 2026 14:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="hKj+NKWE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F1D3D2FFB
	for <io-uring@vger.kernel.org>; Wed,  8 Apr 2026 14:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775656854; cv=none; b=DelN0w+iDTBmf55yVTcUid5B5X2BpFFxRvP1IcGceA+gusHqeD61MxCDyGqDVqqDzfr47Km+LP6vZhWK1ecN46DwO6qYSS5qGA3Fk6SM8WQ8gl435gKdh1qBmxw5zpqE8d+OIXhTeIE4wwTiv6ziC+I1S+PVbd5C9pttw3b7qnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775656854; c=relaxed/simple;
	bh=Bchb8OzVWWyDh/mxawPxf0XTr5yVBhmm6JV3/UG9Hjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R53cp5oDnOeBhcOg/s42uPZWaUo59aG82t8PtimGRnTpdDcRs8fOWEVR6/LbYXBky/5Xv3njkzjVaglugBSV02vc4jd19JHgH7u7gxVJ9tTmA+zShsaZMohbBptmn+sc4OEZ9s+Lr4/m6mtucmP/8+OUcJckJUu1LXBWmrSjYLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=hKj+NKWE; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-c70e27e2b74so1975623a12.0
        for <io-uring@vger.kernel.org>; Wed, 08 Apr 2026 07:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1775656851; x=1776261651; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sz2N6F5rlh3/V10zDwXAUHPxGo/+h1EXIThAywxTIJM=;
        b=hKj+NKWEjaz370Ktjg83QD/hBlkFLE34X+Y4NPS4wViCd34KDUiM3hyUWuTBtMbZ3Z
         SfcazX/QB0cNUXw96di2LyTpJ2ezYtGsKKAAPM5QRDqzwMMXhhyW5a7/3PMcXCWBQkbX
         o/cTX68xudQR+sE9mf3pPT4aAyBcifiFzrkVo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775656851; x=1776261651;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Sz2N6F5rlh3/V10zDwXAUHPxGo/+h1EXIThAywxTIJM=;
        b=OW+zb25S2QoRvWS0f0RETzxQxqP0EYY+jX908UtjYtAJOUnnd92rb3TgOqoieDMdTl
         /PobYt6T1i4JRr80Pt4XGKhdJnyeyJXsw56F7YdOrlRNLLXm04AHz5dDLe1zfy+C2IJZ
         o9E8NEKz4GtY5RovTJ1wIT0GLfgHJoYzLykLoJkYznTB3aU3zIfSWy5Sl/IBN6J0JZ9S
         C9GE+DngGdEVUQXCae+QJLS6jodza97P/lwocPhYjP/hNLbxXgp+YgNObOmUpD7CmL/F
         PnyQfjZiEpPRNiRFyH5KDtmj9qsdXQn2kMrg6RQ7naogFQAU2An5JOeDxldKOpy4QJnv
         PmHQ==
X-Forwarded-Encrypted: i=1; AJvYcCVefwACWCJq22O3Ew4izhmOo3bVkQHMJQLTfq8uWXwqMFvfoqDmHxxVcqsDNxYYfxh0GQ6ZI7F4Sw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwK9qLV6CO9ZRmyfQgjTtr6UfGTANOudeoj6bKMyVCf45JOBgVA
	qM0t7YJFghaVHvjZf4R8ZLTy0sKsUeAwaACDjoqqQoxyktFEpizP6KXyGAr9u5F3E9E=
X-Gm-Gg: AeBDietGWmmPg/h85lJX3NBdwV8rPHHduOGx0C9/kza93aXz+qFZrMS5oMxcQf1/xR5
	p3oE36XDJ54EePm1AJQLPwYoHFqZIuNf3LmyYCxXOR9DQkCEYm8T7sXPEEm+5jIoDx/BMQbEtw9
	S95aJQuy1CagCQQd45OdQ5lfiggNBkbqmiKdIlt2NfNyzmEevQIh/oI8dsAetoKQovRsQpC2c1m
	R78WHAsVpeQ5KGC+o5v1jOIgjEH2BfSe0krmfcKJReM/IRDAEfX4PWImAtmuIRuNQRlsAfZWSMk
	Fc1tYULCnRsuL4eI25W2+tz34xGUQNarWYs3st0xITbk5U1QB9QQw4ukJJxeYtAMqCnpVQYHH2E
	HI2IkqqLglB2qh8+ZFP1IRQHIsHpNUVwELjArSloQtl0SZWOJi+dlKhOHipcF/ow0sDcirdYDjn
	csdMEiSvKKgMO0gMcr+mhYDk5wyBIkDaMOMgWm6ouMZE3Llpi/ISJatb6TFkI=
X-Received: by 2002:a17:902:ef08:b0:2b0:a957:304 with SMTP id d9443c01a7336-2b28163b7d3mr240742995ad.6.1775656850121;
        Wed, 08 Apr 2026 07:00:50 -0700 (PDT)
Received: from sidong.sidong.yang.office.furiosa.vpn ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2747612b7sm204465145ad.23.2026.04.08.07.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 07:00:49 -0700 (PDT)
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Jens Axboe <axboe@kernel.dk>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Benno Lossin <lossin@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	Sidong Yang <sidong.yang@furiosa.ai>
Subject: [PATCH v4 3/5] rust: io_uring: introduce rust abstraction for io-uring cmd
Date: Wed,  8 Apr 2026 14:00:00 +0000
Message-ID: <20260408140007.8401-4-sidong.yang@furiosa.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260408140007.8401-1-sidong.yang@furiosa.ai>
References: <20260408140007.8401-1-sidong.yang@furiosa.ai>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[furiosa.ai,none];
	R_DKIM_ALLOW(-0.20)[furiosa.ai:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[furiosa.ai:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12996-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sidong.yang@furiosa.ai,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[furiosa.ai:dkim,furiosa.ai:email,furiosa.ai:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 024DA3BD61F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Implement the io-uring abstractions needed for miscdevices and other
char devices that have io-uring command interface.

* `io_uring::IoUringCmd` : Rust abstraction for `io_uring_cmd` which
  will be used as arg for `MiscDevice::uring_cmd()`. And driver can get
  `cmd_op` sent from userspace. Also it has `flags` which includes option
  that is reissued.

* `io_uring::IoUringSqe` : Rust abstraction for `io_uring_sqe` which
  can be obtained from `IoUringCmd::sqe()` and driver could get `cmd_data`
  from userspace. Also `IoUringSqe` has more data like opcode which can be used
  in drivers.

Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
---
 rust/helpers/helpers.c  |   1 +
 rust/helpers/io_uring.c |   9 +
 rust/kernel/io_uring.rs | 457 ++++++++++++++++++++++++++++++++++++++++
 rust/kernel/lib.rs      |   1 +
 4 files changed, 468 insertions(+)
 create mode 100644 rust/helpers/io_uring.c
 create mode 100644 rust/kernel/io_uring.rs

diff --git a/rust/helpers/helpers.c b/rust/helpers/helpers.c
index e05c6e7e4abb..3fa2b3d9f83a 100644
--- a/rust/helpers/helpers.c
+++ b/rust/helpers/helpers.c
@@ -62,6 +62,7 @@
 #include "irq.c"
 #include "fs.c"
 #include "io.c"
+#include "io_uring.c"
 #include "jump_label.c"
 #include "kunit.c"
 #include "maple_tree.c"
diff --git a/rust/helpers/io_uring.c b/rust/helpers/io_uring.c
new file mode 100644
index 000000000000..818859867b34
--- /dev/null
+++ b/rust/helpers/io_uring.c
@@ -0,0 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/io_uring/cmd.h>
+
+__rust_helper void rust_helper_io_uring_cmd_done32(struct io_uring_cmd *cmd, s32 ret,
+						    u64 res2, unsigned int issue_flags)
+{
+	io_uring_cmd_done32(cmd, ret, res2, issue_flags);
+}
diff --git a/rust/kernel/io_uring.rs b/rust/kernel/io_uring.rs
new file mode 100644
index 000000000000..adec60537cfb
--- /dev/null
+++ b/rust/kernel/io_uring.rs
@@ -0,0 +1,457 @@
+// SPDX-License-Identifier: GPL-2.0
+// SPDX-FileCopyrightText: (C) 2025 Furiosa AI
+
+//! Abstractions for io-uring.
+//!
+//! This module provides abstractions for the io-uring interface for character devices.
+//!
+//!
+//! C headers: [`include/linux/io_uring/cmd.h`](srctree/include/linux/io_uring/cmd.h) and
+//! [`include/linux/io_uring/io_uring.h`](srctree/include/linux/io_uring/io_uring.h)
+
+use core::ptr::NonNull;
+
+use crate::error::from_result;
+use crate::transmute::{AsBytes, FromBytes};
+use crate::{fs::File, types::Opaque};
+
+use crate::prelude::*;
+
+/// Size in bytes of the protocol data unit (PDU) embedded in `io_uring_cmd`.
+///
+/// Matches the size of the `pdu` field in `struct io_uring_cmd` as defined in
+/// `include/linux/io_uring/cmd.h`.
+pub(crate) const PDU_SIZE: usize = 32;
+
+/// Opcode of an [`IoUringSqe`].
+///
+/// Each submission queue entry in io_uring specifies an operation
+/// to perform, such as read, write, or a driver-specific `URING_CMD`.
+#[repr(transparent)]
+#[derive(PartialEq)]
+pub struct Opcode(u8);
+
+impl Opcode {
+    /// Driver-specific passthrough command.
+    pub const URING_CMD: Self = Self(bindings::io_uring_op_IORING_OP_URING_CMD as u8);
+}
+
+/// A fresh `io_uring_cmd` received from the driver callback.
+///
+/// Represents a submission received from userspace via `IORING_OP_URING_CMD`.
+/// A driver obtains this from the `uring_cmd` callback in [`crate::miscdevice::MiscDevice`].
+///
+/// The driver must either complete the command synchronously by calling
+/// [`Self::complete`], or queue it for asynchronous completion by calling
+/// [`Self::queue`], which yields a [`QueuedIoUringCmd`] handle.
+///
+/// # Invariants
+///
+/// `self.inner` is non-null, properly aligned, and points to a valid, live
+/// `bindings::io_uring_cmd` for the duration of the driver callback.
+pub struct IoUringCmd {
+    inner: NonNull<bindings::io_uring_cmd>,
+}
+
+// SAFETY: `io_uring_cmd` is a kernel-allocated structure.  The kernel
+// guarantees that it remains alive until the driver either returns a
+// non-`EIOCBQUEUED` result or calls `io_uring_cmd_done32()`.  Moving the
+// pointer to another thread is safe: the kernel object is not tied to any
+// particular CPU or task context.
+unsafe impl Send for IoUringCmd {}
+
+// SAFETY: All `&self` methods on `IoUringCmd` only read from the underlying
+// `io_uring_cmd` (cmd_op, flags, sqe, file).  `write_pdu` takes `&mut self`,
+// so the borrow checker prevents concurrent mutable access.  Sharing
+// `&IoUringCmd` across threads is therefore safe.
+unsafe impl Sync for IoUringCmd {}
+
+/// An [`IoUringCmd`] that has been queued for asynchronous completion.
+///
+/// The only way to obtain a `QueuedIoUringCmd` is through [`IoUringCmd::queue`],
+/// which ensures the command was properly handed off to the async path before
+/// [`UringCmdAction::Queued`] is returned to the vtable.
+///
+/// Call [`Self::done`] exactly once to post the completion to userspace.
+///
+/// # Invariants
+///
+/// `self.inner` is non-null, properly aligned, and points to a valid, live
+/// `bindings::io_uring_cmd` until [`Self::done`] is called.
+pub struct QueuedIoUringCmd {
+    inner: NonNull<bindings::io_uring_cmd>,
+}
+
+// SAFETY: Same reasoning as for `IoUringCmd`. After `queue()`, the handle is
+// intentionally moved to a different context (e.g. a workqueue) to call
+// `done()` later.
+unsafe impl Send for QueuedIoUringCmd {}
+
+// SAFETY: All `&self` methods on `QueuedIoUringCmd` only read from the
+// underlying `io_uring_cmd`.
+unsafe impl Sync for QueuedIoUringCmd {}
+
+/// Proof that a `uring_cmd` request completed synchronously.
+pub struct CompleteAction {
+    ret: i32,
+}
+
+impl CompleteAction {
+    /// Returns the userspace result for this synchronous completion.
+    #[inline]
+    pub fn ret(&self) -> i32 {
+        self.ret
+    }
+}
+
+/// Proof that a `uring_cmd` request was queued for asynchronous completion.
+///
+/// This type has a private field and can only be constructed inside this module,
+/// so it can only be obtained through [`IoUringCmd::queue`].
+pub struct QueuedAction {
+    _private: (),
+}
+
+/// Completion mode for `uring_cmd`.
+pub enum UringCmdAction {
+    /// Request is completed synchronously and returns this result to userspace.
+    Complete(CompleteAction),
+    /// Request is queued for asynchronous completion.
+    ///
+    /// This variant can only be constructed by calling [`IoUringCmd::queue`],
+    /// which enforces that the caller holds a [`QueuedIoUringCmd`] handle and
+    /// will eventually call [`QueuedIoUringCmd::done`].
+    Queued(QueuedAction),
+}
+
+impl IoUringCmd {
+    /// Returns the `cmd_op` associated with this command.
+    #[inline]
+    pub fn cmd_op(&self) -> u32 {
+        // SAFETY: `self.inner` is guaranteed by the type invariant to point
+        // to a live `io_uring_cmd`, so dereferencing is safe.
+        unsafe { (*self.as_raw()).cmd_op }
+    }
+
+    /// Returns the flags field of this command.
+    ///
+    /// The returned value is `io_uring_cmd.flags`, which is a combination of:
+    /// - User-set flags from `sqe->uring_cmd_flags` (bits 0–1):
+    ///   `IORING_URING_CMD_FIXED`, `IORING_URING_CMD_MULTISHOT`.
+    /// - Kernel-set flags (bits 30–31):
+    ///   `IORING_URING_CMD_CANCELABLE`, `IORING_URING_CMD_REISSUE`.
+    ///
+    /// Note: this is **not** the `issue_flags` parameter passed to the
+    /// `uring_cmd` callback, which carries `IO_URING_F_*` flags such as
+    /// `IO_URING_F_NONBLOCK`.
+    #[inline]
+    pub fn flags(&self) -> u32 {
+        // SAFETY: `self.inner` is guaranteed by the type invariant to point
+        // to a live `io_uring_cmd`, so dereferencing is safe.
+        unsafe { (*self.as_raw()).flags }
+    }
+
+    /// Reads the protocol data unit (PDU) as a value of type `T`.
+    ///
+    /// # Errors
+    ///
+    /// Returns [`EINVAL`] if `size_of::<T>()` exceeds the PDU size.
+    #[inline]
+    pub fn read_pdu<T: FromBytes>(&self) -> Result<T> {
+        // SAFETY: `self.inner` is guaranteed by the type invariant to point
+        // to a live `io_uring_cmd`, so dereferencing is safe.
+        let inner = unsafe { &*self.inner.as_ref() };
+
+        if size_of::<T>() > inner.pdu.len() {
+            return Err(EINVAL);
+        }
+
+        let ptr = inner.pdu.as_ptr() as *const T;
+
+        // SAFETY: `ptr` is a valid pointer derived from `self.inner`, which
+        // is guaranteed by the type invariant. `size_of::<T>()` bytes are
+        // available in the PDU (checked above). `read_unaligned` is used
+        // because the PDU is a byte array and may not satisfy `T`'s alignment.
+        // `T: FromBytes` guarantees that every bit-pattern is a valid value.
+        Ok(unsafe { core::ptr::read_unaligned(ptr) })
+    }
+
+    /// Writes `value` to the PDU of this command.
+    ///
+    /// # Errors
+    ///
+    /// Returns [`EINVAL`] if `size_of::<T>()` exceeds the PDU size.
+    #[inline]
+    pub fn write_pdu<T: AsBytes>(&mut self, value: &T) -> Result<()> {
+        // SAFETY: `self.inner` is guaranteed by the type invariant to point
+        // to a live `io_uring_cmd`, so dereferencing is safe.
+        let inner = unsafe { self.inner.as_mut() };
+
+        let len = size_of::<T>();
+        if len > inner.pdu.len() {
+            return Err(EINVAL);
+        }
+
+        let src = (value as *const T).cast::<u8>();
+        let dst = &raw mut inner.pdu as *mut u8;
+
+        // SAFETY:
+        // * `src` points to valid memory because `T: AsBytes`.
+        // * `dst` is valid and derived from `self.inner`, which is guaranteed
+        //   by the type invariant.
+        // * The byte count does not exceed the PDU length (checked above).
+        unsafe {
+            core::ptr::copy_nonoverlapping(src, dst, len);
+        }
+
+        Ok(())
+    }
+
+    /// Constructs an [`IoUringCmd`] from a raw pointer.
+    ///
+    /// # Safety
+    ///
+    /// The caller must guarantee that:
+    /// - `ptr` is non-null, properly aligned, and points to a valid, initialised
+    ///   `bindings::io_uring_cmd`.
+    /// - The pointed-to object remains alive until the driver either returns a
+    ///   non-`EIOCBQUEUED` value or calls [`QueuedIoUringCmd::done`].
+    /// - No other mutable reference to the same object exists for the duration
+    ///   of the returned handle's lifetime.
+    #[inline]
+    pub(crate) unsafe fn from_raw(ptr: *mut bindings::io_uring_cmd) -> Result<Self> {
+        let Some(inner) = NonNull::new(ptr) else {
+            return Err(EINVAL);
+        };
+
+        Ok(Self { inner })
+    }
+
+    /// Returns a raw pointer to the underlying `io_uring_cmd`.
+    #[inline]
+    fn as_raw(&self) -> *mut bindings::io_uring_cmd {
+        self.inner.as_ptr()
+    }
+
+    /// Returns the file associated with this command.
+    ///
+    /// The returned reference is valid for the lifetime of `&self`.  The kernel
+    /// holds a reference to the file for the entire lifetime of the enclosing
+    /// `io_kiocb`, so this is safe to call at any point while `IoUringCmd` is
+    /// alive.
+    #[inline]
+    pub fn file(&self) -> &File {
+        // SAFETY: `self.inner` is guaranteed by the type invariant to point
+        // to a live `io_uring_cmd`, so dereferencing is safe.
+        let file = unsafe { (*self.as_raw()).file };
+
+        // SAFETY:
+        // * The `io_kiocb` holds a reference to the file for its entire
+        //   lifetime, so `file` is valid and has a positive refcount.
+        // * There is no active fdget_pos region on the file on this thread.
+        unsafe { File::from_raw_file(file) }
+    }
+
+    /// Returns a reference to the [`IoUringSqe`] associated with this command.
+    #[inline]
+    pub fn sqe(&self) -> &IoUringSqe {
+        // SAFETY: `self.inner` is guaranteed by the type invariant to point
+        // to a live `io_uring_cmd`, so dereferencing is safe.
+        let sqe = unsafe { self.inner.as_ref().sqe };
+        // SAFETY: `sqe` is a valid pointer set by the io_uring core during
+        // submission queue entry preparation and remains valid for the lifetime
+        // of the `io_uring_cmd`.
+        unsafe { IoUringSqe::from_raw(sqe) }
+    }
+
+    /// Marks this command as completed synchronously with the provided return value.
+    ///
+    /// The vtable will return `ret` directly to the io_uring core, which posts
+    /// the completion queue entry.  No further action is needed from the driver.
+    #[inline]
+    pub fn complete(self, ret: i32) -> UringCmdAction {
+        UringCmdAction::Complete(CompleteAction { ret })
+    }
+
+    /// Queues this command for asynchronous completion.
+    ///
+    /// Returns a [`UringCmdAction::Queued`] token to return from the driver
+    /// callback and a [`QueuedIoUringCmd`] handle that must be used to call
+    /// [`QueuedIoUringCmd::done`] at a later point.
+    ///
+    /// Because [`QueuedAction`] has a private field, [`UringCmdAction::Queued`]
+    /// can **only** be constructed through this method.  This prevents a driver
+    /// from accidentally returning `Queued` after already completing the command
+    /// via `done()`.
+    #[inline]
+    pub fn queue(self) -> (UringCmdAction, QueuedIoUringCmd) {
+        let queued = QueuedIoUringCmd { inner: self.inner };
+        (UringCmdAction::Queued(QueuedAction { _private: () }), queued)
+    }
+}
+
+impl QueuedIoUringCmd {
+    /// Returns the `cmd_op` associated with this command.
+    #[inline]
+    pub fn cmd_op(&self) -> u32 {
+        // SAFETY: `self.inner` is guaranteed by the type invariant to point
+        // to a live `io_uring_cmd`, so dereferencing is safe.
+        unsafe { (*self.inner.as_ptr()).cmd_op }
+    }
+
+    /// Returns the file associated with this command.
+    ///
+    /// See [`IoUringCmd::file`] for safety details.
+    #[inline]
+    pub fn file(&self) -> &File {
+        // SAFETY: Same as `IoUringCmd::file`.
+        let file = unsafe { (*self.inner.as_ptr()).file };
+        // SAFETY: The `io_kiocb` holds a reference to the file for its entire
+        // lifetime, so `file` is valid and has a positive refcount.
+        unsafe { File::from_raw_file(file) }
+    }
+
+    /// Reads the PDU as a value of type `T`.
+    ///
+    /// See [`IoUringCmd::read_pdu`] for details and error conditions.
+    #[inline]
+    pub fn read_pdu<T: FromBytes>(&self) -> Result<T> {
+        // SAFETY: `self.inner` is guaranteed by the type invariant to point
+        // to a live `io_uring_cmd`, so dereferencing is safe.
+        let inner = unsafe { &*self.inner.as_ref() };
+
+        if size_of::<T>() > inner.pdu.len() {
+            return Err(EINVAL);
+        }
+
+        let ptr = inner.pdu.as_ptr() as *const T;
+
+        // SAFETY: Same as `IoUringCmd::read_pdu`.
+        Ok(unsafe { core::ptr::read_unaligned(ptr) })
+    }
+
+    /// Writes `value` to the PDU of this command.
+    ///
+    /// See [`IoUringCmd::write_pdu`] for details and error conditions.
+    #[inline]
+    pub fn write_pdu<T: AsBytes>(&mut self, value: &T) -> Result<()> {
+        // SAFETY: `self.inner` is guaranteed by the type invariant to point
+        // to a live `io_uring_cmd`, so dereferencing is safe.
+        let inner = unsafe { self.inner.as_mut() };
+
+        let len = size_of::<T>();
+        if len > inner.pdu.len() {
+            return Err(EINVAL);
+        }
+
+        let src = (value as *const T).cast::<u8>();
+        let dst = &raw mut inner.pdu as *mut u8;
+
+        // SAFETY: Same as `IoUringCmd::write_pdu`.
+        unsafe {
+            core::ptr::copy_nonoverlapping(src, dst, len);
+        }
+
+        Ok(())
+    }
+
+    /// Posts the asynchronous completion to userspace.
+    ///
+    /// # Parameters
+    ///
+    /// - `ret`: Result to return to userspace.
+    /// - `res2`: Extra result word for `IORING_SETUP_CQE32` big-CQE rings;
+    ///   pass `0` if not needed.
+    /// - `issue_flags`: The `issue_flags` value received by the `uring_cmd`
+    ///   callback; pass it through unchanged.
+    #[inline]
+    pub fn done(self, ret: Result<i32>, res2: u64, issue_flags: u32) {
+        let ret = from_result(|| ret);
+        // SAFETY: `self.inner` is a valid `io_uring_cmd` that was previously
+        // queued (returned `EIOCBQUEUED` to io_uring).  The kernel keeps the
+        // `io_kiocb` alive until this call completes.
+        unsafe {
+            bindings::io_uring_cmd_done32(self.inner.as_ptr(), ret, res2, issue_flags);
+        }
+    }
+}
+
+/// A Rust abstraction for `io_uring_sqe`.
+///
+/// Represents a Submission Queue Entry (SQE) that describes an I/O operation
+/// to be executed by the io_uring subsystem.  Obtain an instance from
+/// [`IoUringCmd::sqe`].
+///
+/// This type should not be constructed directly by drivers.
+///
+/// # Invariants
+///
+/// `self.inner` always points to a valid, live `bindings::io_uring_sqe`.
+/// The `repr(transparent)` attribute guarantees the same memory layout as the
+/// underlying binding.
+#[repr(transparent)]
+pub struct IoUringSqe {
+    inner: Opaque<bindings::io_uring_sqe>,
+}
+
+impl IoUringSqe {
+    /// Returns the opcode of this SQE.
+    pub fn opcode(&self) -> Opcode {
+        // SAFETY: `self.inner` guaranteed by the type invariant to point
+        // to a live `io_uring_sqe`, so dereferencing is safe.  Volatile
+        // read is used because the SQE may reside in memory shared with
+        // userspace.
+        Opcode(unsafe { core::ptr::addr_of!((*self.inner.get()).opcode).read_volatile() })
+    }
+
+    /// Reads the inline `cmd` data of this SQE as a value of type `T`.
+    ///
+    /// Only the standard `io_uring_sqe` layout is supported
+    /// (`IORING_SETUP_SQE128` is not handled here).
+    ///
+    /// # Errors
+    ///
+    /// Returns [`EINVAL`] if `size_of::<T>()` exceeds the inline command buffer.
+    pub fn cmd_data<T: FromBytes>(&self) -> Result<T> {
+        // SAFETY: `self.inner` guaranteed by the type invariant to point
+        // to a live `io_uring_sqe`, so dereferencing is safe.
+        let sqe = unsafe { &*self.inner.get() };
+
+        // SAFETY: Accessing the `sqe.cmd` union field is safe because
+        // `IoUringSqe` can only be obtained from `IoUringCmd::sqe()`, which
+        // is only available inside a `uring_cmd` callback where the opcode
+        // is guaranteed to be `IORING_OP_URING_CMD` by the io_uring core.
+        let cmd = unsafe { sqe.__bindgen_anon_6.cmd.as_ref() };
+        let cmd_len = size_of_val(&sqe.__bindgen_anon_6.bindgen_union_field);
+
+        if cmd_len < size_of::<T>() {
+            return Err(EINVAL);
+        }
+
+        let cmd_ptr = cmd.as_ptr() as *const T;
+
+        // SAFETY: `cmd_ptr` is valid, derived from `self.inner` which is
+        // guaranteed by the type invariant. `read_unaligned` is used because
+        // the cmd data may not satisfy `T`'s alignment requirements.
+        // `T: FromBytes` guarantees that every bit-pattern is a valid value.
+        Ok(unsafe { core::ptr::read_unaligned(cmd_ptr) })
+    }
+
+    /// Constructs an [`IoUringSqe`] reference from a raw pointer.
+    ///
+    /// # Safety
+    ///
+    /// The caller must guarantee that:
+    /// - `ptr` is non-null, properly aligned, and points to a valid, initialised
+    ///   `bindings::io_uring_sqe`.
+    /// - The pointed-to object remains valid for the entire lifetime `'a`.
+    /// - No mutable access to the same object occurs while the returned
+    ///   reference is alive.
+    #[inline]
+    pub(crate) unsafe fn from_raw<'a>(ptr: *const bindings::io_uring_sqe) -> &'a IoUringSqe {
+        // SAFETY: The caller guarantees that the pointer is not dangling and
+        // stays valid for the duration of 'a.  The cast is valid because
+        // `IoUringSqe` is `repr(transparent)` over `bindings::io_uring_sqe`.
+        unsafe { &*ptr.cast() }
+    }
+}
diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index 0fa9d820fe7c..235d1d03dde2 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -76,6 +76,7 @@
 pub mod impl_flags;
 pub mod init;
 pub mod io;
+pub mod io_uring;
 pub mod ioctl;
 pub mod iommu;
 pub mod iov;
-- 
2.43.0


