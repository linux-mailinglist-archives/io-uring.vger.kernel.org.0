Return-Path: <io-uring+bounces-12998-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mDaZM3Zg1mmDEwgAu9opvQ
	(envelope-from <io-uring+bounces-12998-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 16:04:38 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DA0B83BD617
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 16:04:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 6166C303D239
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2026 14:01:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF9433D331E;
	Wed,  8 Apr 2026 14:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="CetpzWbf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F813D3D02
	for <io-uring@vger.kernel.org>; Wed,  8 Apr 2026 14:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775656859; cv=none; b=WcjM8OLO9Mf1C/Wq27LIh4IpjhfZtOgcCzpO5P4V6eT7zbZSQ20itN17s0RJJPs9DoMAUhAz5jxZh6l7YLq1DRQ9a3JWPO2wHY4H/ATkSa0rtk8P6ELWwYMG1pNJS2/yuPnXIPhh5SE94NGgzBealaCjK65tWhp0dtXtre62b1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775656859; c=relaxed/simple;
	bh=1RUauL2RCVFelsgWteX9fUSv4uF/cElWij5jQkbisA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xp1rDGK/BL+n4N2U3viruQcTLjbJimVmPv8kU36WunHEJUOj3TPlOFHjLSyy692/nkgkS5yuqAfVCn0JOAK7eVGg+wzQPS6/qoVMaBfokRfebmHN0FpDoAnqt1J9TQ9hMfO4lNa2Wpsph4PNNcuh9GEcOZe5MWnuUjBTqV32GU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=CetpzWbf; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c70f91776fcso2516606a12.0
        for <io-uring@vger.kernel.org>; Wed, 08 Apr 2026 07:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1775656857; x=1776261657; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vrpY2TRUYM3HpI2L60VlYb3B/Pcn97Bimqdq+op4nJ8=;
        b=CetpzWbfA8Q/tx2hmjRdyI3utdBF3O4M8YWcee1L0opioeYfO7iA6sUsbqLl63GS21
         Yi2PR5JqiL14rNtcMa/k50flMyTNEsuyLLs/SMlRBlsHqQEJJbOsZ1wfVgQvaYKFzd/G
         pQsfivdVWBmwSrg/4x2ADdxt8GkDbvEU1TeWY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775656857; x=1776261657;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vrpY2TRUYM3HpI2L60VlYb3B/Pcn97Bimqdq+op4nJ8=;
        b=g8HHE0T+8sNQiQRhE4kYtyWbZnmNbkWdA5K/ob4lFM0Ta/Do+pIvgezTrT9yvMVA45
         x5h3Nv8ylE7u/hGsC1mBbkE/VGFC3gL9lhpI0k2lpzxDCpOcH8SlbFiFMQ00LR9ztKjd
         I+0VQwd169yQdv0Y6iQ9xXfJb7xsvDuN99tlp/th7FiXmUEr0CUsGP5eqBhG8aAmocRs
         OqzbNxypwoUQKud3Sde74mOlj42HBLWsG/XaIXxBAc/E7ZU0io7HLZo8ufkQqeGM8PkV
         XQYM0R+WUBreth0MdT8k8Dyap2meeQi9BpVFY7W1aseg/9S1Q5W7+FsXPAIpIVOpXWUc
         /k1g==
X-Forwarded-Encrypted: i=1; AJvYcCXKXl8jkcDzq0TjzXOlBYIi2sk9Kz6DY8BX9Ql1p1SmvLwh7UvW21XfFOLFUn/Hk4gw7cAPXagafg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyjnbBZwGXQfmg3TMlp6/+qGjp4gzvwKpuiBqQgzr6YAL23IeaQ
	Iau3aroFxrUB1vPyxBCimK8S3S0yoybsgzSPGXGjIsOXFLhLFXUwVykQ9Lvns73BD9Y=
X-Gm-Gg: AeBDietdkDeGVlLwn+Ul+/8C2MG+ZCj2326bjQ6W5/3ncWwo1Sk+3201irgUc2pdqVw
	8IFgnIn02G8U7rI9DEeTW03hmJvLCk7YtVGqi14c2zDHLhDMYq66bIv2ompnDsIhlGtwpYUj6xR
	o+GBTjc7yGZZ/XIE2vGWRwUbTimSPCWZgd25k+T0kvf0ZD+z7dS1phQnXG4qbxWwFs0x8xlD5GC
	LloeRgq8pNiZxoW4XyLFV8D55yTjRWRBkvVavJFFrdGG/EHQnbj6grdgrxisyWggSaExQiMUS/N
	UF7w2O06XSX/TiLbSpnyZ6g4dY/LgZUIFzCMgx8fzTtCB4ZADr8EmmBd/u/d94/7sEHxx4CzLKP
	fLYB5Xlu50kBqC18KZqO3wm379ISKX05DL5oTFe5eiZmuVcwwNG9B9dzTSB+pM0gEuxjKLBxmfO
	5HLf7XUIT+ySGv6Bu9D7rt7f3FrmRCiIIdTS/VEduGyiC85zjwPHhVaBnbyo4=
X-Received: by 2002:a17:903:37ce:b0:2b2:4697:78f3 with SMTP id d9443c01a7336-2b2817b3469mr224774545ad.34.1775656857085;
        Wed, 08 Apr 2026 07:00:57 -0700 (PDT)
Received: from sidong.sidong.yang.office.furiosa.vpn ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2747612b7sm204465145ad.23.2026.04.08.07.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 07:00:55 -0700 (PDT)
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
Subject: [PATCH v4 5/5] samples: rust: Add `uring_cmd` example to `rust_misc_device`
Date: Wed,  8 Apr 2026 14:00:02 +0000
Message-ID: <20260408140007.8401-6-sidong.yang@furiosa.ai>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[furiosa.ai:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[furiosa.ai:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12998-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sidong.yang@furiosa.ai,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,furiosa.ai:dkim,furiosa.ai:email,furiosa.ai:mid,self.work:url]
X-Rspamd-Queue-Id: DA0B83BD617
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

This patch extends the `rust_misc_device` sample to demonstrate how to
use the `uring_cmd` interface for asynchronous device operations.

The new implementation handles two `uring_cmd` operations:

*   `RUST_MISC_DEV_URING_CMD_SET_VALUE`: Sets a value in the device.
*   `RUST_MISC_DEV_URING_CMD_GET_VALUE`: Gets a value from the device.

To use this new functionality, users can submit `IORING_OP_URING_CMD`
operations to the `rust_misc_device` character device.

Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
---
 samples/rust/rust_misc_device.rs | 53 +++++++++++++++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)

diff --git a/samples/rust/rust_misc_device.rs b/samples/rust/rust_misc_device.rs
index 87a1fe63533a..ef506e8b26fe 100644
--- a/samples/rust/rust_misc_device.rs
+++ b/samples/rust/rust_misc_device.rs
@@ -98,13 +98,15 @@
 use kernel::{
     device::Device,
     fs::{File, Kiocb},
+    io_uring::{IoUringCmd, QueuedIoUringCmd, UringCmdAction},
     ioctl::{_IO, _IOC_SIZE, _IOR, _IOW},
     iov::{IovIterDest, IovIterSource},
     miscdevice::{MiscDevice, MiscDeviceOptions, MiscDeviceRegistration},
     new_mutex,
     prelude::*,
-    sync::{aref::ARef, Mutex},
+    sync::{Arc, aref::ARef, Mutex},
     uaccess::{UserSlice, UserSliceReader, UserSliceWriter},
+    workqueue::{impl_has_work, new_work, HasWork},
 };
 
 const RUST_MISC_DEV_HELLO: u32 = _IO('|' as u32, 0x80);
@@ -151,6 +153,42 @@ struct RustMiscDevice {
     dev: ARef<Device>,
 }
 
+#[pin_data]
+struct IoUringCmdWork {
+    #[pin]
+    ioucmd: Mutex<Option<(QueuedIoUringCmd, u32)>>,
+    #[pin]
+    work: kernel::workqueue::Work<IoUringCmdWork>,
+}
+
+impl_has_work! {
+    impl HasWork<Self> for IoUringCmdWork { self.work }
+}
+
+impl kernel::workqueue::WorkItem for IoUringCmdWork {
+    type Pointer = Arc<IoUringCmdWork>;
+
+    fn run(work: Arc<IoUringCmdWork>) {
+        pr_info!("IoUringCmdWork::run()");
+
+        if let Some((ioucmd, issue_flags)) = work.ioucmd.lock().take() {
+            ioucmd.done(Ok(0), 0, issue_flags);
+        }
+    }
+}
+
+impl IoUringCmdWork {
+    fn new(ioucmd: QueuedIoUringCmd, issue_flags: u32) -> Result<Arc<Self>> {
+        Arc::pin_init(
+            pin_init!(Self {
+                ioucmd <- new_mutex!(Some((ioucmd, issue_flags))),
+                work <- new_work!("IoUringCmdWork::work"),
+            }),
+            GFP_KERNEL,
+        )
+    }
+}
+
 #[vtable]
 impl MiscDevice for RustMiscDevice {
     type Ptr = Pin<KBox<Self>>;
@@ -220,6 +258,19 @@ fn ioctl(me: Pin<&RustMiscDevice>, _file: &File, cmd: u32, arg: usize) -> Result
 
         Ok(0)
     }
+
+    fn uring_cmd(
+        me: Pin<&RustMiscDevice>,
+        ioucmd: IoUringCmd,
+        issue_flags: u32,
+    ) -> Result<UringCmdAction> {
+        dev_info!(me.dev, "UringCmd Rust Misc Device Sample\n");
+
+        let (action, queued_ioucmd) = ioucmd.queue();
+        let work = IoUringCmdWork::new(queued_ioucmd, issue_flags)?;
+        let _ = kernel::workqueue::system().enqueue(work);
+        Ok(action)
+    }
 }
 
 #[pinned_drop]
-- 
2.43.0


