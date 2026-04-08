Return-Path: <io-uring+bounces-12997-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GNKUEplg1mmDEwgAu9opvQ
	(envelope-from <io-uring+bounces-12997-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 16:05:13 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E88653BD636
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 16:05:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C67FE30875C6
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2026 14:01:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25A4E3D3301;
	Wed,  8 Apr 2026 14:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="PNlUV+I+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7FF3D3007
	for <io-uring@vger.kernel.org>; Wed,  8 Apr 2026 14:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775656855; cv=none; b=RD9idcaUwWHWjWrnT3ru3aDVM7Sxx6Fu3jUKa1XrhhNdKLS5R8sao3Wmqm5QY15oCPFajHqXZasbcItmeGG5bka56gPG7U65mKbhm4c8Kgh7fGmB2/x6MrbOj7gCOC8ueUmkyppPoqKDwqpAxh8l1pWFLvIZk9dwOKTrz/VtwP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775656855; c=relaxed/simple;
	bh=qJPvaTDkdQnF6GB2/DJhWc0YSkNmMUsm38EVHAmFNn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KEiRu4xA2MMjj9K0Q4aXSDJOcpfrUN7HISI8EI5KLhCrPp/9/RWxOzRimd78dSdnnGZYRV9wK4l4CpB7ZAgXRzzEQIO9V3p2dMsnauGSUrVN1n7CU1Zf2lIDEUZoLJTqLqhsE0/MadJ+E5QQLvQWdVpZP7Pj9quEFu0BITrvnXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=PNlUV+I+; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2b23f90f53aso55219725ad.0
        for <io-uring@vger.kernel.org>; Wed, 08 Apr 2026 07:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1775656853; x=1776261653; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cb7E2CfVk9owGcBqZvU+iKSSUuaUHhRXNpFRwID2YDM=;
        b=PNlUV+I+Ca1UNcyqt0hxPVFYhnCySXEzJPFi+swiEGQ+qJ8KFOmPDTNWVPnYhWGoSW
         L41DtRrz+bdKjyEvwLOCMEXdtEsI3QQelaUHzJyaxu4wTlV6E1FtQ59WQxaTUkMgQEHI
         sZweFaK25pN9SmFWt+Ep29O58KKbVWf0Dgcjw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775656853; x=1776261653;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cb7E2CfVk9owGcBqZvU+iKSSUuaUHhRXNpFRwID2YDM=;
        b=WG6cVkVXm0mP11NUa3iYmDtDhIqIJ6nsTEK+hENaV+dalLmiAt8DBEN7B4WB7i0/AZ
         LADKh7n1syVN0DHazjdcRMXy7HAC3SUZTXZmEbiv/QHtMfkn3FHSbX2vrFQFAhhf58ZV
         De/AZ/bqmqdYMfZ/CFN1xtgkYXXk8F/83bLmQ0K7BDU6/Ht3Pl84zEsWAuQgFCW/EZia
         l6ux1KXFx6Km3AKZ+4x0yTUBt2dxv2EHaN1vKIGQ97KDrvyCI5d0UWBeZfTavtmPZ+9F
         9p2u2jc724NekgOS3UtipGpNlpeuwynWBGy/NE4nEPT60xMzNdtU3USjNmIxCHnRCHHd
         sr9w==
X-Forwarded-Encrypted: i=1; AJvYcCVFqak5dkk4J7SmWCfS8u36k8kMokG+Gn0T07O4OCF29a4FLM4EY/YmGyQ1FqllJWj13dEI/4J7SQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/KF6xUvVKzGJp3nZVWoPmbftt0VdngFApdH1nC0YrqdQ+88/4
	75wU+YMS1Zm2ZREoUn/kTPjjuxEWcuziY40NuoMVC/6KfBFcA1yDpMgXO8G8SrgjI20=
X-Gm-Gg: AeBDieusmEGJKzQtFv829wnrwPyHu/D3LN6xjOh/CVIQcujyCPSwB/WdvpsNObVTtP1
	yIZRZbG498Ng1sU2VxswpmkOuKdj8mmY0XKx2iBzh7voZ6smPo0zdClOyz25wkuIGvg0LxEULoq
	iS9+lYk2SiF9FNdLqyR8bO3Nw4yHQi2RtIa3ifLIHVGpHfi43fIROvmXOgcUImAbse1M4grl7Zq
	I3von23EH3P6Upr/eX5RiodaLV4eWoQYNEHJcbJ9A8Fa7hv0AnhHryoW0GqaA8a/1ez9/lypWN4
	s3AE1EcxreEVvBa28ty1Ke7IumcDwyeCktSluPIAYyEY3CovAeP7zh/D6gsfaMRpAAHuRXpQEJW
	Q2WEydoFSB5mvF38F6PLiYk21kENyL2vS6qtEc6xw7sZQexlFxP620QdH6ou++fAeYE9KU7+84o
	STZdmkg+fra02i2Mdzid6ssSho5jPfHeSpkMOD8EDlWwRdk54swkE1Gsd6WiU=
X-Received: by 2002:a17:903:2ec7:b0:2b0:4554:9c24 with SMTP id d9443c01a7336-2b2817a20e9mr224313505ad.32.1775656853111;
        Wed, 08 Apr 2026 07:00:53 -0700 (PDT)
Received: from sidong.sidong.yang.office.furiosa.vpn ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2747612b7sm204465145ad.23.2026.04.08.07.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 07:00:52 -0700 (PDT)
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
Subject: [PATCH v4 4/5] rust: miscdevice: Add `uring_cmd` support
Date: Wed,  8 Apr 2026 14:00:01 +0000
Message-ID: <20260408140007.8401-5-sidong.yang@furiosa.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260408140007.8401-1-sidong.yang@furiosa.ai>
References: <20260408140007.8401-1-sidong.yang@furiosa.ai>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[furiosa.ai:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[furiosa.ai:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12997-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sidong.yang@furiosa.ai,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[furiosa.ai:dkim,furiosa.ai:email,furiosa.ai:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E88653BD636
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

This patch introduces support for `uring_cmd` to the `miscdevice`
framework. This is achieved by adding a new `uring_cmd` method to the
`MiscDevice` trait and wiring it up to the corresponding
`file_operations` entry.

The `uring_cmd` function provides a mechanism for `io_uring` to issue
commands to a device driver.

The new `uring_cmd` method takes the device, an `IoUringCmd` object,
and issue flags as arguments. The `IoUringCmd` object is a safe Rust
abstraction around the raw `io_uring_cmd` struct.

To enable `uring_cmd` for a specific misc device, the `HAS_URING_CMD`
constant must be set to `true` in the `MiscDevice` implementation.

Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
---
 rust/kernel/miscdevice.rs | 79 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/rust/kernel/miscdevice.rs b/rust/kernel/miscdevice.rs
index c3c2052c9206..7fe6021c2c96 100644
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
@@ -190,6 +191,29 @@ fn show_fdinfo(
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
+    /// and should be forwarded to [`crate::io_uring::QueuedIoUringCmd::done`]
+    /// unchanged when completing asynchronously.
+    fn uring_cmd(
+        _device: <Self::Ptr as ForeignOwnable>::Borrowed<'_>,
+        _io_uring_cmd: IoUringCmd,
+        _issue_flags: u32,
+    ) -> Result<UringCmdAction> {
+        build_error!(VTABLE_DEFAULT_ERROR)
+    }
 }
 
 /// A vtable for the file operations of a Rust miscdevice.
@@ -387,6 +411,56 @@ impl<T: MiscDevice> MiscdeviceVTable<T> {
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
@@ -419,6 +493,11 @@ impl<T: MiscDevice> MiscdeviceVTable<T> {
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


