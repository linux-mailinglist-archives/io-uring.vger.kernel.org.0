Return-Path: <io-uring+bounces-13046-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mA9jCStX32n1RwAAu9opvQ
	(envelope-from <io-uring+bounces-13046-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 15 Apr 2026 11:15:23 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BFB7240270F
	for <lists+io-uring@lfdr.de>; Wed, 15 Apr 2026 11:15:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F02DC314872B
	for <lists+io-uring@lfdr.de>; Wed, 15 Apr 2026 09:09:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4176E328255;
	Wed, 15 Apr 2026 09:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="LPLKD0tK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D15329C6B
	for <io-uring@vger.kernel.org>; Wed, 15 Apr 2026 09:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776244160; cv=none; b=goPnHrn7TMINXE+nC/NYRlYswJJYqxjxnBkcNm/iazUuF8+LP4Mv0aYIx3xcRrQEwDh2zVJLApGiBEuWJbTbNcI40LLYkuUcgGvpm0CZ8o4uiTUQeIF5MbO6gXq6Pul55gVDEvc5Dn79ZTb+2tLfP90TmmCH1mvN9+sZxc7UBng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776244160; c=relaxed/simple;
	bh=Bll4HoxZRoadw3eBKwz/4mSEumf8EkZvc3IvUn6eioY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gSl2D+9Q3eYM/wla4kxUhHDs9m9m8+LAIKmIjNkkNBLreigiZYxqR8xsI9zgJHp6xFdwq/RH9xMl1RatPKJCuflZEErNK4XI+FgS3LAR0QCKnmiayskZM9fkfyKCPquL0SefE6tKEFRg3z/rgsxA0pO/38Xkg6RzwyEQl4MGyqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=LPLKD0tK; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-82f2385724aso2675153b3a.0
        for <io-uring@vger.kernel.org>; Wed, 15 Apr 2026 02:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1776244158; x=1776848958; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=POyxFYQ+V9mFipVgPFkvK5v/sTQB318bLmjeylTNt7s=;
        b=LPLKD0tKgKfPh8vYiiiYqBgk+kP9aHC9CBsLSaTb9840FRjN04bDdXPAXnPf0MhEkW
         MENYRxzu5C3YWfBDjHXOFRx1egzSnOT79SC/P4YdizmLiuPC8puMHFKdeC+G+Fuy3Ky7
         RxoFL9qO83yVasKwLWxoWPSNIzRPyI+yC/K3Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776244158; x=1776848958;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=POyxFYQ+V9mFipVgPFkvK5v/sTQB318bLmjeylTNt7s=;
        b=I5X0tZsKgCseYfb8R30BTnwFw/ebCpeqsWEwcrd1NexBS+1tnF7h3ldwZ2yCLwAS2V
         SFe9P/A8qPVJuOFjIxiY7LPnPdYDDvv1C5DMOFP0mRHpqPTFbp/4WKKBbCb3TJpVYOA5
         +LlfAjgMMj8LF/U7lX1YvbLNuXmrBkIU596QlA2gPbkVUJIf00bYnpwMfH95qiWBpas/
         CaxhHvXy5Aayn0qqzjNiTYns3OU7ZLrqTimRAvIaH5P2slJFQwibD70uFzxVLzA1fhEH
         STgJeNJpnqHOsd9N4ALEckhNwNqfKO1lpPkuNl3dzfC4MndnSTBaPDNKN5pajXtAcMee
         OMyQ==
X-Forwarded-Encrypted: i=1; AFNElJ+RJmVgJ0ECl6k45iTB12FoF/Mh0xBQq2ZNE8Hhn/sRMDD25b/o404+qQk03Aeyk04CFkaLdvzSoA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzOvxT4Cb4VKK/lnts9anG24yMrov3Dn7y4dqHZn1PFgtqALLFC
	PJuEVhkSM1M3ho9UEt40VK/vD5B5Ako86QrLxxfbefuOxkpmFkXHWubliis6YUWxFeU=
X-Gm-Gg: AeBDiev3yjvH8FpwX1V93pKO6ttP2WIAaO8Wzf6HVuV0uZRsOsqpuL9J130QPPJ9lHJ
	xG7vVyDOZmR9h9ACCy0ZHRfmSv0hKSKNZLWoFHhVmHfmlTa/j4/gewTSAz0JPyeF+feprLElZ1Y
	su1ha/fKpX+L7VnsAu2yYvYviAwqClc5NzmwFY+xlgYQ3+qN/YT5HGw04I5lsycSiGlktHa/m6Q
	tGbD5qd0gVMWTi39f+/jy1+x6kuqeEpyd6wuT81XdWYDgJbe80p1nM769HF46z1+KpoUFh/MOLu
	kVeAxh76jrrblH3zURcqSyH2LR1eqV02OXL0KPGDr8JewE3FJyjg+ZFm4Nao83a6n4y80DgCyj9
	POywwQLfADRmEhIxyU46Qzcx/26HzlDOWhpoAptbnMj9Qm3dCCEeOH2b3Z180ttW1tiHxfP/lbh
	8Bt2hcfFsf3Msy3pT5yAg2icpM/DYnejXZql52gCZiN1V0sQq1Kzp/4M0ZIjg=
X-Received: by 2002:a05:6300:210d:b0:39f:c48d:fcd2 with SMTP id adf61e73a8af0-39fe3ddd0bdmr22715132637.27.1776244158271;
        Wed, 15 Apr 2026 02:09:18 -0700 (PDT)
Received: from sidong.sidong.yang.office.furiosa.vpn ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7957ecee24sm1074619a12.1.2026.04.15.02.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 02:09:17 -0700 (PDT)
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
Subject: [PATCH v5 3/4] rust: miscdevice: Add `uring_cmd` support
Date: Wed, 15 Apr 2026 09:02:14 +0000
Message-ID: <20260415090851.4897-4-sidong.yang@furiosa.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260415090851.4897-1-sidong.yang@furiosa.ai>
References: <20260415090851.4897-1-sidong.yang@furiosa.ai>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[furiosa.ai,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[furiosa.ai:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[furiosa.ai:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13046-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sidong.yang@furiosa.ai,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,furiosa.ai:email,furiosa.ai:dkim,furiosa.ai:mid]
X-Rspamd-Queue-Id: BFB7240270F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add a uring_cmd method to the MiscDevice trait and wire it up to
file_operations, allowing Rust misc device drivers to handle
IORING_OP_URING_CMD submissions from io_uring.

The vtable wrapper zero-initialises the PDU for fresh (non-reissued)
commands so that drivers always start from a clean state.  On reissue
the PDU retains its contents from the previous attempt.

To enable uring_cmd for a specific misc device, set HAS_URING_CMD
to true in the MiscDevice implementation.

Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
---
 rust/kernel/miscdevice.rs | 81 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/rust/kernel/miscdevice.rs b/rust/kernel/miscdevice.rs
index c3c2052c9206..549693e6aea0 100644
--- a/rust/kernel/miscdevice.rs
+++ b/rust/kernel/miscdevice.rs
@@ -14,6 +14,7 @@
     error::{to_result, Error, Result, VTABLE_DEFAULT_ERROR},
     ffi::{c_int, c_long, c_uint, c_ulong},
     fs::{File, Kiocb},
+    io_uring::{self, IoUringCmd, UringCmdAction},
     iov::{IovIterDest, IovIterSource},
     mm::virt::VmaNew,
     prelude::*,
@@ -190,6 +191,31 @@ fn show_fdinfo(
     ) {
         build_error!(VTABLE_DEFAULT_ERROR)
     }
+
+    /// Handler for `uring_cmd`.
+    ///
+    /// Invoked when userspace submits an `IORING_OP_URING_CMD` entry to the
+    /// io-uring submission queue for a file backed by this driver.
+    ///
+    /// The driver must either complete the command synchronously by calling
+    /// [`IoUringCmd::complete`] and returning `Ok(UringCmdAction::Complete(_))`,
+    /// or queue it for asynchronous completion by calling [`IoUringCmd::queue`]
+    /// and returning `Ok(UringCmdAction::Queued(_))`.  In the latter case the
+    /// driver must eventually call [`crate::io_uring::QueuedIoUringCmd::done`]
+    /// to post the completion to userspace.
+    ///
+    /// `issue_flags` carries `IO_URING_F_*` flags (e.g. `IO_URING_F_NONBLOCK`)
+    /// describing the current execution context.  When completing
+    /// asynchronously, do **not** forward this value to
+    /// [`crate::io_uring::QueuedIoUringCmd::done`]; see its documentation for
+    /// the correct flags to use in each completion context.
+    fn uring_cmd(
+        _device: <Self::Ptr as ForeignOwnable>::Borrowed<'_>,
+        _io_uring_cmd: IoUringCmd,
+        _issue_flags: u32,
+    ) -> Result<UringCmdAction> {
+        build_error!(VTABLE_DEFAULT_ERROR)
+    }
 }
 
 /// A vtable for the file operations of a Rust miscdevice.
@@ -387,6 +413,56 @@ impl<T: MiscDevice> MiscdeviceVTable<T> {
         T::show_fdinfo(device, m, file);
     }
 
+    /// # Safety
+    ///
+    /// - The pointer `ioucmd` is not null and points to a valid `bindings::io_uring_cmd`.
+    unsafe extern "C" fn uring_cmd(
+        ioucmd: *mut bindings::io_uring_cmd,
+        issue_flags: ffi::c_uint,
+    ) -> c_int {
+        // SAFETY: `file` referenced by `ioucmd` is valid pointer. It's assigned in
+        // uring cmd preparation. So dereferencing is safe.
+        let raw_file = unsafe { (*ioucmd).file };
+
+        // SAFETY: `private_data` is guaranteed that it has valid pointer after
+        // this file opened. So dereferencing is safe.
+        let private = unsafe { (*raw_file).private_data }.cast();
+
+        // SAFETY: `ioucmd` is not null and points to valid memory `bindings::io_uring_cmd`
+        // and the memory pointed by `ioucmd` is valid and will not be moved or
+        // freed for the lifetime of returned value `ioucmd`
+        let ioucmd = unsafe { IoUringCmd::from_raw(ioucmd) };
+        let mut ioucmd = match ioucmd {
+            Ok(ioucmd) => ioucmd,
+            Err(e) => {
+                return e.to_errno();
+            }
+        };
+
+        // Zero-initialize the PDU for fresh (non-reissued) commands so that
+        // drivers reading from it always start from a clean state.  On reissue
+        // the PDU retains its contents from the previous attempt, which is the
+        // expected behaviour (e.g. a driver may store state there across
+        // -EAGAIN retries).
+        if (ioucmd.flags() & bindings::IORING_URING_CMD_REISSUE) == 0 {
+            if let Err(e) = ioucmd.write_pdu(&[0u8; io_uring::PDU_SIZE]) {
+                return e.to_errno();
+            }
+        }
+
+        // SAFETY: This call is safe because `private` is returned by
+        // `into_foreign` in [`open`]. And it's guaranteed
+        // that `from_foreign` is called by [`release`] after the end of
+        // the lifetime of `device`
+        let device = unsafe { <T::Ptr as ForeignOwnable>::borrow(private) };
+
+        match T::uring_cmd(device, ioucmd, issue_flags) {
+            Ok(UringCmdAction::Complete(action)) => action.ret(),
+            Ok(UringCmdAction::Queued(_)) => EIOCBQUEUED.to_errno(),
+            Err(e) => e.to_errno(),
+        }
+    }
+
     const VTABLE: bindings::file_operations = bindings::file_operations {
         open: Some(Self::open),
         release: Some(Self::release),
@@ -419,6 +495,11 @@ impl<T: MiscDevice> MiscdeviceVTable<T> {
         } else {
             None
         },
+        uring_cmd: if T::HAS_URING_CMD {
+            Some(Self::uring_cmd)
+        } else {
+            None
+        },
         ..pin_init::zeroed()
     };
 
-- 
2.43.0


