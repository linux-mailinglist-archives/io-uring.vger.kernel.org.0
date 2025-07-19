Return-Path: <io-uring+bounces-8726-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C42AB0B07B
	for <lists+io-uring@lfdr.de>; Sat, 19 Jul 2025 16:34:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C4F2AA8071
	for <lists+io-uring@lfdr.de>; Sat, 19 Jul 2025 14:34:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC01128852B;
	Sat, 19 Jul 2025 14:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="UHA2Vjl0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFBF6288539
	for <io-uring@vger.kernel.org>; Sat, 19 Jul 2025 14:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752935657; cv=none; b=YdoM6DCH+6VqesI1nhTN/6o6+gNqEvlP/pmb7BHTwRbdcHLLXBEyd31KqJmF8NUcDrF+cjzkK5iGgNOsgwS3LjGr6vKzlbNZIc2mubxr5e5swvI9dWGlWtlImynG+cjmuMNtxJ4jKD2gNjFr84XrgGCONJT5SKd2p4vWayTj6Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752935657; c=relaxed/simple;
	bh=hiYfT7g7dEoDoCFfoRNmanSXnUrnNYBQJyWlQ2T6V+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4AsGyPbS4yJC2HSm9sOCZaId/DiZadJfSR+soOXIw6ziFa2edDqHtJGVzWqCKaL6oItii1I8jIjtVZIZNKXXq9O5dBopaHGRhHE2IjFj5pbgI6F+IhK6IEhpIqVFVnxt+vSXEy8w+Grdf87JWSXO2+WK8a3yPWSTRDzO5tPaCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=UHA2Vjl0; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-23508d30142so35464545ad.0
        for <io-uring@vger.kernel.org>; Sat, 19 Jul 2025 07:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1752935654; x=1753540454; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QoZ5l7uX723ZF26lE5z2JZL2KcJPe7FMlPZI7PwJSRw=;
        b=UHA2Vjl0HVSaJ5MUNvqQs9kjuKTho+MVWNouiA0AgG98jP63Fet7xfUtuOeSSO5JXx
         xq5i4nfJxk542Y+Gzm7Q+ny5knN4q4MLnSQwB4aIEne3FPgnREnnZvul597C0q1bAFNt
         4pkkCBjs19vvD8HJEq1fUSTYuDxuD1anp5x7E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752935654; x=1753540454;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QoZ5l7uX723ZF26lE5z2JZL2KcJPe7FMlPZI7PwJSRw=;
        b=FZa45LUyRDqRhyd4SRyDMc8mO9RV3mqDh9ihYEhY1qKaO9iBtFB/xdFsjL5Hx4hByo
         fXrAiAXiVEa4yui2WFb1OLZs0nQ/qfFZSCiaU7FY9ZyyckVcJt29VstTsZAsQDM4ewsK
         5ZJ+SndlJF+rLAlBZRXEdZD/KrxuWMuaBf//gTH56PLc0/v8uPZ5sUWz7+4r0KJJ0Q1T
         15XqDLWXJvMZtUPIeO/xNuUmRqIIDF+nmwbofQX1Fz76pS0LFvYtjPW9ID9Lb2Tptmig
         Qcfpj3AVBTh7CB9jKohBTrwDI1J88hhQl1qwZTu+zfWBVMxFGImlbN7vIxbndVgBjyzY
         xirw==
X-Forwarded-Encrypted: i=1; AJvYcCUL5lKJJw7xaGrddWX9di06q40IEUQxU7tV/8T1X2lOeDuuHZ/kzwDvrGx6SPXIljYgA3ZlQ5Zakw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzKi4jRMu0+Pbsr641ga4AWprvOqiT6Rtillg1Rmx+B0Rrw8JYR
	VkpMFVpX8UWkBh2BX2Uf2V6YQExjvwh1kePn3aUHbcxGk+Uk9LNt5IFjhjNP1B43WtM=
X-Gm-Gg: ASbGncuoKtGY7rYrZ8HEgt86LO+aXDJuaN8CoHVJsUTEdgBjEgTx1KwvQMkD0pWfFEV
	MK4SsnqSj1m0FUrb4WdHGYSkaALoqDpmcGAuX4EyNNYJL4VP9FEaypZpDfgd2gfhdZAPTYoD/Eb
	YL6MFJwzG2LdN522LYNV2J2irgFI/N4fv+/0vKIDZ6E7ziz5pdCmGWLNPOyB07FC8QkpmMUpnp9
	/mjRlCX5x/3Xu9iowuXmQmPY3gEX3TYPZgzQG3wcrW0LgUg0/z/uEYiDFzkSPOGqpEgKVPhfGG3
	VM4QsAGCjdx3vywNIMqyt1qfwcCkVU4BzMGEoSHmLx3HRK60zn2HYlGpg13aBAguouoTg/gCM0E
	Ran1SxxJojaw8UBxu4jJjaKnQSjpfoDYrau5BgqFEHiO6tX6VgyKxcFXLqPo7NTA8J0zsQw==
X-Google-Smtp-Source: AGHT+IFnM/CiV+7xt++m6hPsUY32KdWuau4dLfx8UwlhOPQ9sEoM5NIlxtAMRGhEYpHMy1yGgtgf5g==
X-Received: by 2002:a17:902:ef08:b0:23d:d9ae:3b56 with SMTP id d9443c01a7336-23e256b7467mr228306365ad.22.1752935654049;
        Sat, 19 Jul 2025 07:34:14 -0700 (PDT)
Received: from sidong.sidong.yang.office.furiosa.vpn ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23e3b5e3d4esm30017525ad.23.2025.07.19.07.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Jul 2025 07:34:13 -0700 (PDT)
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Miguel Ojeda <ojeda@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Jens Axboe <axboe@kernel.dk>
Cc: rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	Sidong Yang <sidong.yang@furiosa.ai>
Subject: [PATCH 2/4] rust: io_uring: introduce rust abstraction for io-uring cmd
Date: Sat, 19 Jul 2025 14:33:56 +0000
Message-ID: <20250719143358.22363-3-sidong.yang@furiosa.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250719143358.22363-1-sidong.yang@furiosa.ai>
References: <20250719143358.22363-1-sidong.yang@furiosa.ai>
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
 rust/kernel/io_uring.rs | 114 ++++++++++++++++++++++++++++++++++++++++
 rust/kernel/lib.rs      |   1 +
 2 files changed, 115 insertions(+)
 create mode 100644 rust/kernel/io_uring.rs

diff --git a/rust/kernel/io_uring.rs b/rust/kernel/io_uring.rs
new file mode 100644
index 000000000000..7843effbedb4
--- /dev/null
+++ b/rust/kernel/io_uring.rs
@@ -0,0 +1,114 @@
+// SPDX-License-Identifier: GPL-2.0
+
+// Copyright (C) 2025 Furiosa AI.
+
+//! Files and file descriptors.
+//!
+//! C headers: [`include/linux/io_uring/cmd.h`](srctree/include/linux/io_uring/cmd.h) and
+//! [`include/linux/file.h`](srctree/include/linux/file.h)
+
+use core::mem::MaybeUninit;
+
+use crate::{fs::File, types::Opaque};
+
+pub mod flags {
+    pub const COMPLETE_DEFER: i32 = bindings::io_uring_cmd_flags_IO_URING_F_COMPLETE_DEFER;
+    pub const UNLOCKED: i32 = bindings::io_uring_cmd_flags_IO_URING_F_UNLOCKED;
+
+    pub const MULTISHOT: i32 = bindings::io_uring_cmd_flags_IO_URING_F_MULTISHOT;
+    pub const IOWQ: i32 = bindings::io_uring_cmd_flags_IO_URING_F_IOWQ;
+    pub const NONBLOCK: i32 = bindings::io_uring_cmd_flags_IO_URING_F_NONBLOCK;
+
+    pub const SQE128: i32 = bindings::io_uring_cmd_flags_IO_URING_F_SQE128;
+    pub const CQE32: i32 = bindings::io_uring_cmd_flags_IO_URING_F_CQE32;
+    pub const IOPOLL: i32 = bindings::io_uring_cmd_flags_IO_URING_F_IOPOLL;
+
+    pub const CANCEL: i32 = bindings::io_uring_cmd_flags_IO_URING_F_CANCEL;
+    pub const COMPAT: i32 = bindings::io_uring_cmd_flags_IO_URING_F_COMPAT;
+    pub const TASK_DEAD: i32 = bindings::io_uring_cmd_flags_IO_URING_F_TASK_DEAD;
+}
+
+#[repr(transparent)]
+pub struct IoUringCmd {
+    inner: Opaque<bindings::io_uring_cmd>,
+}
+
+impl IoUringCmd {
+    /// Returns the cmd_op with associated with the io_uring_cmd.
+    #[inline]
+    pub fn cmd_op(&self) -> u32 {
+        // SAFETY: The call guarantees that the pointer is not dangling and stays valid
+        unsafe { (*self.inner.get()).cmd_op }
+    }
+
+    /// Returns the flags with associated with the io_uring_cmd.
+    #[inline]
+    pub fn flags(&self) -> u32 {
+        // SAFETY: The call guarantees that the pointer is not dangling and stays valid
+        unsafe { (*self.inner.get()).flags }
+    }
+
+    /// Returns the ref pdu for free use.
+    #[inline]
+    pub fn pdu(&mut self) -> MaybeUninit<&mut [u8; 32]> {
+        // SAFETY: The call guarantees that the pointer is not dangling and stays valid
+        unsafe { MaybeUninit::new(&mut (*self.inner.get()).pdu) }
+    }
+
+    /// Constructs a new `struct io_uring_cmd` wrapper from a file descriptor.
+    #[inline]
+    pub unsafe fn from_raw<'a>(ptr: *const bindings::io_uring_cmd) -> &'a IoUringCmd {
+        // SAFETY: The caller guarantees that the pointer is not dangling and stays valid for the
+        // duration of 'a. The cast is okay because `File` is `repr(transparent)`.
+        unsafe { &*ptr.cast() }
+    }
+
+    // Returns the file that referenced by uring cmd self.
+    #[inline]
+    pub fn file<'a>(&'a self) -> &'a File {
+        // SAFETY: The call guarantees that the pointer is not dangling and stays valid
+        let file = unsafe { (*self.inner.get()).file };
+        unsafe { File::from_raw_file(file) }
+    }
+
+    // Returns the sqe  that referenced by uring cmd self.
+    #[inline]
+    pub fn sqe(&self) -> &IoUringSqe {
+        // SAFETY: The call guarantees that the pointer is not dangling and stays valid
+        let ptr = unsafe { (*self.inner.get()).sqe };
+        unsafe { IoUringSqe::from_raw(ptr) }
+    }
+
+    // Called by consumers of io_uring_cmd, if they originally returned -EIOCBQUEUED upon receiving the command
+    #[inline]
+    pub fn done(self, ret: isize, res2: u64, issue_flags: u32) {
+        // SAFETY: The call guarantees that the pointer is not dangling and stays valid
+        unsafe {
+            bindings::io_uring_cmd_done(self.inner.get(), ret, res2, issue_flags);
+        }
+    }
+}
+
+#[repr(transparent)]
+pub struct IoUringSqe {
+    inner: Opaque<bindings::io_uring_sqe>,
+}
+
+impl<'a> IoUringSqe {
+    pub fn cmd_data(&'a self) -> &'a [Opaque<u8>] {
+        // SAFETY: The call guarantees that the pointer is not dangling and stays valid
+        unsafe {
+            let cmd = (*self.inner.get()).__bindgen_anon_6.cmd.as_ref();
+            core::slice::from_raw_parts(cmd.as_ptr() as *const Opaque<u8>, 8)
+        }
+    }
+
+    #[inline]
+    pub unsafe fn from_raw(ptr: *const bindings::io_uring_sqe) -> &'a IoUringSqe {
+        // SAFETY: The caller guarantees that the pointer is not dangling and stays valid for the
+        // duration of 'a. The cast is okay because `File` is `repr(transparent)`.
+        //
+        // INVARIANT: The caller guarantees that there are no problematic `fdget_pos` calls.
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


