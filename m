Return-Path: <io-uring+bounces-13047-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MF0+IFZW32ndRwAAu9opvQ
	(envelope-from <io-uring+bounces-13047-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 15 Apr 2026 11:11:50 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 67C774025EC
	for <lists+io-uring@lfdr.de>; Wed, 15 Apr 2026 11:11:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 68028304E276
	for <lists+io-uring@lfdr.de>; Wed, 15 Apr 2026 09:09:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99E7733344D;
	Wed, 15 Apr 2026 09:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="A0keWuRI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40BF4331A64
	for <io-uring@vger.kernel.org>; Wed, 15 Apr 2026 09:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776244163; cv=none; b=akh3MgPAPYF7XrKtY56gYhBcfEB0mSd4l1Wo3UhsnFW+7n7hBKSJpWoqtIhax4iZNGluA+zHDz0SWwzBHWoOBW/Pq2oGyan38FeYUifKCHXHPWPD3CkzektBBtDgLFTvbNr7NG0toz3/KCqrvSSEQbBebxEywDn5Q+JyMAVo9Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776244163; c=relaxed/simple;
	bh=ubBzsvdvi4CPPSq8r6r63vK+XNzjHX2CU/Xs07mhl4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jujh9hyN6ccrQftzWRug5bSg2F2Oq7WgT6/UAkQRy0JUOVrx6/qVpwwKiCUdRamL/F86OG4SMCswPRQbFdmSCk9LCOQ2ZhEzJ9iDL5CbASlBtXTncWXSveXHA9UT1ojMOf/EMJTKq2BkTazXcjS0vImCN3TljcbvGb3jxm5NxZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=A0keWuRI; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c6e2355739dso2935121a12.2
        for <io-uring@vger.kernel.org>; Wed, 15 Apr 2026 02:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1776244162; x=1776848962; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0sT90Da8dxnzlMMkK3ArmGE7gcm3zpo3Cwr+6iFpQpk=;
        b=A0keWuRIsJxgGzsyA/DFNLpYSJoNQRyAHQXS9HgKMKIkySBA/TWm1AFBifCpuNHm+X
         BobZAiur5c8Pr9vlIXqcNEttlb5s5VMgTWn9bNtX1oKT0gcMcVPTcaVD9c8AOyWnWK5u
         dmPhUqNmBYz6cojD7uLLKndPyGn/TGFEYWWDM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776244162; x=1776848962;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0sT90Da8dxnzlMMkK3ArmGE7gcm3zpo3Cwr+6iFpQpk=;
        b=MNbZqKoJvo1R/yGyJAUU3oW6BgmsjjZ8BmD34oi0NHoBZvMMN+Z0BbR58ozunXkWdQ
         e7ANgIlu+52ML2ETYJ1nrL4Wyn/EKchxUHRzekNPVpCkWBdzJpP2kJzuTasCrjbnLb38
         O6CEMa+/Ro0UCipxuwiJZTA3Ts0Te9k2HCS6C84UcO+ZJzenRcBelcVMIPhXc1kD1nRw
         G17dqxgRxiQV+r12nV7fS+Z4MGLTmThFlUc4TX25hIA4Fn70Tewndte6i1+Bwh33e3Aj
         UDyvwAR26SeXBeJwpEYRuAK6xhcaximAyIFo/EJxbyTx9ZFuDED4plKx9F7JlBv3x/ya
         dePQ==
X-Forwarded-Encrypted: i=1; AFNElJ+U1qGnuPRCY1nG6aHhZCGHqMT86hV9Yy1CBk4xW0gv/Ae/6+48PgoN65svHicpfKcPP+wZKGvH4g==@vger.kernel.org
X-Gm-Message-State: AOJu0YyJR3nJnCNzq/MhJamCxcqz4QuWagrzFWfwvygN2D3KiUqarLFm
	Ec8+/LLZHogcN+8pljTBsEl+z8JKVmvOAmK1zGiEk/w3vp/Re+OnplZol3e1f73sdR4=
X-Gm-Gg: AeBDieu8yYFldpo+PGarpc2A9miOQIweTnkai4bjIP8gqTMsWkYnrAK4X/q6ci1t6dV
	7IcP6Gopt0UipiznHUZhJMoHXLy1GUJBTcv1FXveYO/Fko9aaV9XkeKqBdnu7fouk5pIDPPGG1W
	R8+6FK9tBf4uJD+DSGnY703nxljpd5uvh46e58Dz8BolwjVjUxItsFaKP9qYjDRHZ6vW/BK04P9
	UECU5v3vXtc23vw5Ms2bd/uLjQwrvdXnQQuw82bTj7YOVnNDExHpfuqA7jOks7TZ1TluBH4eFC0
	fH2x7GqE73xUoPtsZTUaHynCviz08tp3m1pc+2TyRUbeYonLtWfcmte19EP74nKO33NwasLg931
	ikUQ+vCvzrX045ePME/qMLHngRhOTJXb+aItSXpg8JyiIg8kr1I4WXCgD75LEJJUPztrihkyK64
	6k28cptqvIFEUzbsq8KKFCvJXn3K/LFX7taVublRfjf8ghIckp+QupwK3ZNXM=
X-Received: by 2002:a05:6a20:6a2c:b0:39c:4b84:d90f with SMTP id adf61e73a8af0-39fe3c6796emr22382238637.8.1776244161341;
        Wed, 15 Apr 2026 02:09:21 -0700 (PDT)
Received: from sidong.sidong.yang.office.furiosa.vpn ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7957ecee24sm1074619a12.1.2026.04.15.02.09.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 02:09:21 -0700 (PDT)
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
Subject: [PATCH v5 4/4] samples: rust: Add `uring_cmd` example to `rust_misc_device`
Date: Wed, 15 Apr 2026 09:02:15 +0000
Message-ID: <20260415090851.4897-5-sidong.yang@furiosa.ai>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[furiosa.ai:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[furiosa.ai:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13047-lists,io-uring=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,furiosa.ai:email,furiosa.ai:dkim,furiosa.ai:mid,self.work:url]
X-Rspamd-Queue-Id: 67C774025EC
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Extend the rust_misc_device sample to demonstrate uring_cmd handling.

The example completes asynchronously using a workqueue combined with
complete_in_task(), showing the full async completion flow:
IoUringCmd -> queue() -> workqueue -> complete_in_task() ->
task_work -> done().

Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
---
 samples/rust/rust_misc_device.rs | 62 +++++++++++++++++++++++++++++++-
 1 file changed, 61 insertions(+), 1 deletion(-)

diff --git a/samples/rust/rust_misc_device.rs b/samples/rust/rust_misc_device.rs
index 87a1fe63533a..4059348a56ad 100644
--- a/samples/rust/rust_misc_device.rs
+++ b/samples/rust/rust_misc_device.rs
@@ -98,13 +98,15 @@
 use kernel::{
     device::Device,
     fs::{File, Kiocb},
+    io_uring::{self, IoUringCmd, IoUringTaskWork, QueuedIoUringCmd, UringCmdAction},
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
@@ -151,6 +153,51 @@ struct RustMiscDevice {
     dev: ARef<Device>,
 }
 
+#[pin_data]
+struct IoUringCmdWork {
+    #[pin]
+    ioucmd: Mutex<Option<QueuedIoUringCmd>>,
+    #[pin]
+    work: kernel::workqueue::Work<IoUringCmdWork>,
+}
+
+impl_has_work! {
+    impl HasWork<Self> for IoUringCmdWork { self.work }
+}
+
+/// Task-work completion handler for the sample device.
+struct RustMiscDeviceCompletion;
+
+impl IoUringTaskWork for RustMiscDeviceCompletion {
+    fn task_work(cmd: QueuedIoUringCmd) {
+        cmd.done(Ok(0), 0, io_uring::TASK_WORK_ISSUE_FLAGS);
+    }
+}
+
+impl kernel::workqueue::WorkItem for IoUringCmdWork {
+    type Pointer = Arc<IoUringCmdWork>;
+
+    fn run(work: Arc<IoUringCmdWork>) {
+        pr_info!("IoUringCmdWork::run()");
+
+        if let Some(ioucmd) = work.ioucmd.lock().take() {
+            ioucmd.complete_in_task::<RustMiscDeviceCompletion>();
+        }
+    }
+}
+
+impl IoUringCmdWork {
+    fn new(ioucmd: QueuedIoUringCmd) -> Result<Arc<Self>> {
+        Arc::pin_init(
+            pin_init!(Self {
+                ioucmd <- new_mutex!(Some(ioucmd)),
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
@@ -220,6 +267,19 @@ fn ioctl(me: Pin<&RustMiscDevice>, _file: &File, cmd: u32, arg: usize) -> Result
 
         Ok(0)
     }
+
+    fn uring_cmd(
+        me: Pin<&RustMiscDevice>,
+        ioucmd: IoUringCmd,
+        _issue_flags: u32,
+    ) -> Result<UringCmdAction> {
+        dev_info!(me.dev, "UringCmd Rust Misc Device Sample\n");
+
+        let (action, queued_ioucmd) = ioucmd.queue();
+        let work = IoUringCmdWork::new(queued_ioucmd)?;
+        let _ = kernel::workqueue::system().enqueue(work);
+        Ok(action)
+    }
 }
 
 #[pinned_drop]
-- 
2.43.0


