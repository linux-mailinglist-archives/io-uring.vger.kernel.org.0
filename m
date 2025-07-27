Return-Path: <io-uring+bounces-8806-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 747D5B13003
	for <lists+io-uring@lfdr.de>; Sun, 27 Jul 2025 17:05:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6FE06178B0D
	for <lists+io-uring@lfdr.de>; Sun, 27 Jul 2025 15:04:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 972D31F7575;
	Sun, 27 Jul 2025 15:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="WbS2hieZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EBE21CA00
	for <io-uring@vger.kernel.org>; Sun, 27 Jul 2025 15:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753628671; cv=none; b=bbhD0pF6YofCw6BUJv1WRJjr+H2aBzpx1/Q5cHheVAa87liAegwJnm5pkztAXm3pLPK2yqnD1qft1IqgWHeFjC5xVvCqD1CKaFCAOpl6b1K/VX89wrVTG41IflrU+mMy15SE5agPXrie1Jj+QjAY9ImZfoD4Ux+/bZYM4BK/1JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753628671; c=relaxed/simple;
	bh=cK0C6CMwUFq5DnEbyxxAxzphNNePE5niB42IjceE7Vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ly77gmGYORpUN30Cshb8y/mc4icsLZm11+mzx/kBfnVI4iGZIbS85f49lYjlYEdcCDfrQsp7fOnKdwY3ZiHsC77C4P/lELLOcfU3u8yftHPdMq/sqLvcolLytEHi4keUNQncuTOTKCfIW5PW3M1NVjJQXtm7F1RgBgwrAOo1wb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=WbS2hieZ; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-313bb9b2f5bso3308813a91.3
        for <io-uring@vger.kernel.org>; Sun, 27 Jul 2025 08:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1753628669; x=1754233469; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IJ11FFDjzx+V6NkfUN6iB7gcMGoXSPCw6j8ek1pZA3I=;
        b=WbS2hieZqce/Ywj/m8nhIZMQ7Mj2+83CSmSjrJzVQiudsZH5bqhp3D4+eA/+DqN9qZ
         zPfLETjxQnhsmAjGJcTV0/D4wSfw5CQLQ0K0GEMwZhKk//MU/ytbCHb/YVzzC0Bg9hyH
         IpHu8BO2sx2hsm2dhKn5wNEgRjxXEGyGq27M0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753628669; x=1754233469;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IJ11FFDjzx+V6NkfUN6iB7gcMGoXSPCw6j8ek1pZA3I=;
        b=iiVrITBlCOjIFjo6ByXgQmRUzdXajlCqZXlmFK7iT0rl8BnTRSQRhY0fPuiO18e9mm
         yWY0VAAYo66Qq0hL2J3iByxSNT/cf3YUU+Sz1qyziAxZU5J2ZsFLRjthTDXo9R1eDxqX
         jeexpvtN3fCi0wSXL7ZkGHT+L1B91bpLEBbzFTW9xDzm4aEjToXiiZ2/x0bTiN1AEXjg
         TSnC13Wccb8ZH2Gz5UD8l2t16SkT9Gnl9vB9WUTzvfAtW9EGHxO6zbmRmKhX645ZKFl1
         LTgxBNCOZHb7GQZexritv/b713p29aqTsGIl2zRJ0cVbPzYz+D79DLmnTVQ1nYboJIJt
         mtYQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJBY/YiFeG+c3dSi5WvKxozNa9G2J7LuGXzetWg1dyJy2m22taBkepyGfMgdNSL/7MHiswU7N1DQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxHwo/kH6NKWu6qGkps9kiRiZkffiEozwtrgjvlvXGPtS3CYaAp
	WfkkW1rteKWCWni1Afl4qS+2df70FqLYSiGcxn3teaB83u/z/Pk9UabZHTKbnmDG3xE=
X-Gm-Gg: ASbGncuF/u8ljdidSH4QXZ9jEukgXQnaNL+QMH+IgGKQmjca6u/uYyd7AalYxPDeRVy
	IGc0FtnN4xHHxpm9EXeU2jkIqvEkUHK2z+UoiSVpKblZxPFsBPdbVmtGeJ4WqflZgluaU8zG+Fp
	NgC/YrFdv2NVL16nXOm9oxzumfc+/SIiVgDofkFsJayE5h6HeT4R2CZShnOqJBnWQkqOG8OdVvp
	kLQI3/BPMGLLW7MaXWeyXkVLwTYKjqN+Cn+Qu9v77kTLxNRfj8UMOBEB1YLuZID614Mg6UPioEO
	RS5gGsOExRpUX7MmRuo2icHevTYmxkbD6GXVI+rK6Uqm3u59GvZJ0aOZms5EXVQQj8LVmpNuVYE
	HiklicSVGoztLC2gO4uZ06baM1t6qgS/C1YV8IwPThAQeYRCvLypwh89vlpG5AQ==
X-Google-Smtp-Source: AGHT+IH0f6GIgi9C1wsJukW9qT+wBKrNk/MtPTNq8t53L3BzWGIVFMNGwdiF9Ph0f4hFJBwPzZjydA==
X-Received: by 2002:a17:90b:4c86:b0:313:17e3:7ae0 with SMTP id 98e67ed59e1d1-31e77a26fcbmr10353854a91.34.1753628668983;
        Sun, 27 Jul 2025 08:04:28 -0700 (PDT)
Received: from sidong.sidong.yang.office.furiosa.vpn ([175.195.128.78])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23ffdec96aesm15381965ad.165.2025.07.27.08.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jul 2025 08:04:28 -0700 (PDT)
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Caleb Sander Mateos <csander@purestorage.com>,
	Benno Lossin <lossin@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Jens Axboe <axboe@kernel.dk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	Sidong Yang <sidong.yang@furiosa.ai>
Subject: [RFC PATCH v2 2/4] rust: io_uring: introduce rust abstraction for io-uring cmd
Date: Sun, 27 Jul 2025 15:03:27 +0000
Message-ID: <20250727150329.27433-3-sidong.yang@furiosa.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250727150329.27433-1-sidong.yang@furiosa.ai>
References: <20250727150329.27433-1-sidong.yang@furiosa.ai>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch introduces rust abstraction for io-uring sqe, cmd. IoUringSqe
abstracts io_uring_sqe and it has cmd_data(). and IoUringCmd is
abstraction for io_uring_cmd. From this, user can get cmd_op, flags,
pdu and also sqe.

Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
---
 rust/kernel/io_uring.rs | 183 ++++++++++++++++++++++++++++++++++++++++
 rust/kernel/lib.rs      |   1 +
 2 files changed, 184 insertions(+)
 create mode 100644 rust/kernel/io_uring.rs

diff --git a/rust/kernel/io_uring.rs b/rust/kernel/io_uring.rs
new file mode 100644
index 000000000000..0acdf3878247
--- /dev/null
+++ b/rust/kernel/io_uring.rs
@@ -0,0 +1,183 @@
+// SPDX-License-Identifier: GPL-2.0
+
+// Copyright (C) 2025 Furiosa AI.
+
+//! IoUring command and submission queue entry abstractions.
+//!
+//! C headers: [`include/linux/io_uring/cmd.h`](srctree/include/linux/io_uring/cmd.h) and
+//! [`include/linux/io_uring/io_uring.h`](srctree/include/linux/io_uring/io_uring.h)
+
+use core::{mem::MaybeUninit, pin::Pin, ptr::addr_of_mut};
+
+use crate::{fs::File, types::Opaque};
+
+/// A Rust abstraction for the Linux kernel's `io_uring_cmd` structure.
+///
+/// This structure is a safe, opaque wrapper around the raw C `io_uring_cmd`
+/// binding from the Linux kernel. It represents a command structure used
+/// in io_uring operations within the kernel.
+///
+/// # Type Safety
+///
+/// The `#[repr(transparent)]` attribute ensures that this wrapper has
+/// the same memory layout as the underlying `io_uring_cmd` structure,
+/// allowing it to be safely transmuted between the two representations.
+///
+/// # Fields
+///
+/// * `inner` - An opaque wrapper containing the actual `io_uring_cmd` data.
+///             The `Opaque` type prevents direct access to the internal
+///             structure fields, ensuring memory safety and encapsulation.
+///
+/// # Usage
+///
+/// This type is used internally by the io_uring subsystem to manage
+/// asynchronous I/O commands. It is typically accessed through a pinned
+/// mutable reference: `Pin<&mut IoUringCmd>`. The pinning ensures that
+/// the structure remains at a fixed memory location, which is required
+/// for safe interaction with the kernel's io_uring infrastructure.
+///
+/// Users typically receive this type as an argument in the `file_operations::uring_cmd()`
+/// callback function, where they can access and manipulate the io_uring command
+/// data for custom file operations.
+///
+/// This type should not be constructed or manipulated directly by
+/// kernel module developers.
+#[repr(transparent)]
+pub struct IoUringCmd {
+    inner: Opaque<bindings::io_uring_cmd>,
+}
+
+impl IoUringCmd {
+    /// Returns the cmd_op with associated with the io_uring_cmd.
+    #[inline]
+    pub fn cmd_op(&self) -> u32 {
+        // SAFETY: The call guarantees that `self.inner` is not dangling and stays valid
+        unsafe { (*self.inner.get()).cmd_op }
+    }
+
+    /// Returns the flags with associated with the io_uring_cmd.
+    #[inline]
+    pub fn flags(&self) -> u32 {
+        // SAFETY: The call guarantees that `self.inner` is not dangling and stays valid
+        unsafe { (*self.inner.get()).flags }
+    }
+
+    /// Returns the ref pdu for free use.
+    #[inline]
+    pub fn pdu(&mut self) -> &mut MaybeUninit<[u8; 32]> {
+        // SAFETY: The call guarantees that `self.inner` is not dangling and stays valid
+        let inner = unsafe { &mut *self.inner.get() };
+        let ptr = addr_of_mut!(inner.pdu) as *mut MaybeUninit<[u8; 32]>;
+
+        // SAFETY: The call guarantees that `self.inner` is not dangling and stays valid
+        unsafe { &mut *ptr }
+    }
+
+    /// Constructs a new `IoUringCmd` from a raw `io_uring_cmd`
+    ///
+    /// # Safety
+    ///
+    /// The caller must guarantee that:
+    /// - The pointer `ptr` is not null and points to a valid `bindings::io_uring_cmd`.
+    /// - The memory pointed to by `ptr` remains valid for the duration of the returned reference's lifetime `'a`.
+    /// - The memory will not be moved or freed while the returned `Pin<&mut IoUringCmd>` is alive.
+    #[inline]
+    pub unsafe fn from_raw<'a>(ptr: *mut bindings::io_uring_cmd) -> Pin<&'a mut IoUringCmd> {
+        // SAFETY: The caller guarantees that the pointer is not dangling and stays valid for the
+        // duration of 'a. The cast is okay because `IoUringCmd` is `repr(transparent)` and has the
+        // same memory layout as `bindings::io_uring_cmd`. The returned `Pin` ensures that the object
+        // cannot be moved, which is required because the kernel may hold pointers to this memory
+        // location and moving it would invalidate those pointers.
+        unsafe { Pin::new_unchecked(&mut *ptr.cast()) }
+    }
+
+    /// Returns the file that referenced by uring cmd self.
+    #[inline]
+    pub fn file(&self) -> &File {
+        // SAFETY: The call guarantees that the `self.inner` is not dangling and stays valid
+        let file = unsafe { (*self.inner.get()).file };
+        // SAFETY: The call guarantees that `file` points valid file.
+        unsafe { File::from_raw_file(file) }
+    }
+
+    /// Returns a reference to the uring cmd's SQE.
+    #[inline]
+    pub fn sqe(&self) -> &IoUringSqe {
+        // SAFETY: The call guarantees that the `self.inner` is not dangling and stays valid
+        let sqe = unsafe { (*self.inner.get()).sqe };
+        // SAFETY: The call guarantees that the `sqe` points valid io_uring_sqe.
+        unsafe { IoUringSqe::from_raw(sqe) }
+    }
+
+    /// Called by consumers of io_uring_cmd, if they originally returned -EIOCBQUEUED upon receiving the command
+    #[inline]
+    pub fn done(self: Pin<&mut IoUringCmd>, ret: isize, res2: u64, issue_flags: u32) {
+        // SAFETY: The call guarantees that `self.inner` is not dangling and stays valid
+        unsafe {
+            bindings::io_uring_cmd_done(self.inner.get(), ret, res2, issue_flags);
+        }
+    }
+}
+
+/// A Rust abstraction for the Linux kernel's `io_uring_sqe` structure.
+///
+/// This structure is a safe, opaque wrapper around the raw C `io_uring_sqe`
+/// binding from the Linux kernel. It represents a Submission Queue Entry
+/// used in io_uring operations within the kernel.
+///
+/// # Type Safety
+///
+/// The `#[repr(transparent)]` attribute ensures that this wrapper has
+/// the same memory layout as the underlying `io_uring_sqe` structure,
+/// allowing it to be safely transmuted between the two representations.
+///
+/// # Fields
+///
+/// * `inner` - An opaque wrapper containing the actual `io_uring_sqe` data.
+///             The `Opaque` type prevents direct access to the internal
+///             structure fields, ensuring memory safety and encapsulation.
+///
+/// # Usage
+///
+/// This type represents a submission queue entry that describes an I/O
+/// operation to be executed by the io_uring subsystem. It contains
+/// information such as the operation type, file descriptor, buffer
+/// pointers, and other operation-specific data.
+///
+/// Users can obtain this type from `IoUringCmd::sqe()` method, which
+/// extracts the submission queue entry associated with a command.
+///
+/// This type should not be constructed or manipulated directly by
+/// kernel module developers.
+#[repr(transparent)]
+pub struct IoUringSqe {
+    inner: Opaque<bindings::io_uring_sqe>,
+}
+
+impl<'a> IoUringSqe {
+    /// Returns the cmd_data with associated with the io_uring_sqe.
+    /// This function returns 16 byte array. We don't support IORING_SETUP_SQE128 for now.
+    pub fn cmd_data(&'a self) -> &'a [Opaque<u8>] {
+        // SAFETY: The call guarantees that `self.inner` is not dangling and stays valid
+        let cmd = unsafe { (*self.inner.get()).__bindgen_anon_6.cmd.as_ref() };
+
+        // SAFETY: The call guarantees that `cmd` is not dangling and stays valid
+        unsafe { core::slice::from_raw_parts(cmd.as_ptr() as *const Opaque<u8>, 16) }
+    }
+
+    /// Constructs a new `IoUringSqe` from a raw `io_uring_sqe`
+    ///
+    /// # Safety
+    ///
+    /// The caller must guarantee that:
+    /// - The pointer `ptr` is not null and points to a valid `bindings::io_uring_sqe`.
+    /// - The memory pointed to by `ptr` remains valid for the duration of the returned reference's lifetime `'a`.
+    #[inline]
+    pub unsafe fn from_raw(ptr: *const bindings::io_uring_sqe) -> &'a IoUringSqe {
+        // SAFETY: The caller guarantees that the pointer is not dangling and stays valid for the
+        // duration of 'a. The cast is okay because `IoUringSqe` is `repr(transparent)` and has the
+        // same memory layout as `bindings::io_uring_sqe`.
+        unsafe { &*ptr.cast() }
+    }
+}
diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index 6b4774b2b1c3..fb310e78d51d 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -80,6 +80,7 @@
 pub mod fs;
 pub mod init;
 pub mod io;
+pub mod io_uring;
 pub mod ioctl;
 pub mod jump_label;
 #[cfg(CONFIG_KUNIT)]
-- 
2.43.0


