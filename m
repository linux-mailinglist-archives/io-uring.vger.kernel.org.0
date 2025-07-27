Return-Path: <io-uring+bounces-8807-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 12C7DB13006
	for <lists+io-uring@lfdr.de>; Sun, 27 Jul 2025 17:05:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D7E3178877
	for <lists+io-uring@lfdr.de>; Sun, 27 Jul 2025 15:05:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA04721D3D3;
	Sun, 27 Jul 2025 15:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="oYvpybBo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50DE621CC61
	for <io-uring@vger.kernel.org>; Sun, 27 Jul 2025 15:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753628674; cv=none; b=QpUKOWLPNGLku7YB903wVCEFcqbSYSreYNGNuRr9Gym2bS64GAj9m/GdgzOzb55vUxhKEi4fvfuySbplSB6eKw/bHNNLIJNSQAJ4cfHpU3TppaOyV+R2qLjo1UiMDaijraa/4rIf6AkO6lYdTWlrfmX23GLI9/3xkamYEzfyFVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753628674; c=relaxed/simple;
	bh=LYz4BJjEcxej4a2hfZQjwwKXuLLfa6KFrpaj5RCmjU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QIS8CEEKUjlTAOIDW2A50wi6Ijc7hd793PsG5ShWLZwkMa4slf8hjKGTjGBm8csWxw7Dnvu4z7opmsX1FMve6V6c+6e6XdMH6oTiLAeR/La/ZFt9itmGZHZT6yD1caHmZb96EbuWpZFZd7FJxfR52SVOSR9pRtNI5wUOAJRKQkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=oYvpybBo; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-24014cd385bso3901095ad.0
        for <io-uring@vger.kernel.org>; Sun, 27 Jul 2025 08:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1753628672; x=1754233472; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PF8dNyFHhR5n7ctm1h4dvcd/FHv92TBiu95SBZTfIhs=;
        b=oYvpybBozPeNGcX9sJTU7BAvYgyef8KzlEzqS72ym5+zHa0LXdxdWXDMjZExT3q3Ht
         wN4kArx/GmqEUXs6VdgDze9FWxp4bLm2t9lobECX1fV6XdG0nGRwzhmRnJevvuX+McHH
         Unjpe6rXvWlPPAMUGlhntd4Iu6bxmslgI9NZ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753628672; x=1754233472;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PF8dNyFHhR5n7ctm1h4dvcd/FHv92TBiu95SBZTfIhs=;
        b=JJpotBm5ROdEqaZf2LN8rwx1MUsT3okQH6t1ED+Kr2eZ57iD5lXDY+YjkFnprW3ZD+
         8lpMEdQNDB4E6C1UEAfeVD/IW/QETs4KRkTtQP++JGCLiV7/muVoQYDZ2gdHRvpdRhdA
         jyW1G63vYcWwQWnmfW6M6OtSVum8vC8blcbsuG38cTCtpyE8LatcYsJk3BiSuBs5ccTs
         aW4TXDgAWltHBfgA19KVorMCPO6pOMZ8Pb+Qq5EdApTRslyOZ/5rVoqYWc+jQpxeewTD
         FytJY1oQDVtqYnjpZvSjk/1stZkVm2heAeBnH0+e2wFubPRosRewZAoTWOUmNKMfj/Go
         l9jw==
X-Forwarded-Encrypted: i=1; AJvYcCXKPHRtZWPBVXYxqW6zCic6jOBdvtieM2eQXbF6XxHSYGZsToeTmguP+Ix+2UwDO6Gnv/SY5EzPhA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxbXYY8smasf+e6rED0QOUvnANm+nIYQuQcy0zmcvfJ2xv46B+C
	BKj9Poi209xkF/1TM358X/4F3Vngx8GHq0LCq6BP6FPON4kqohF5YfSz+1FuoLridB0=
X-Gm-Gg: ASbGncsMp9rYH/EHcj3u52G8+vUonWwxD2aKLDLH1H8aNgsCSUUr4upxEkW6Ogaqjy7
	QhTZlObEdeiXcOHembkmqS1qi2kU9o2WPfoNwfpB+XFJuOq9ipgmMKPEiJnB07cmDeQ9jBqcBsa
	mi1rImjlqNbpLsbZ/ry94nfNGxppwlGk5EkPI2HgPclY5HU0dzCLEy8mr5U1hxPr2x7wjVUIuk1
	BPDl+pDtdhVZoIs5DkneJd4L8KXg1zu4wE8im/SZPCV/QXD55yLCitnZgdF67h4SF6LPPgUhCoO
	wm2wfrSZ1LE7Z2oFbfyo3qtNgzkG27BB/3NJ1Un5yOdxRNuA+wptRVXCBMCZljayU14XfrctNzl
	F1x5VN1TIXUPxaUNYWJ9hmJFgP+ydnk+JOSHJsDmTbF+a2h7AagvEyPGLmkdhFRGITcAdp2/+
X-Google-Smtp-Source: AGHT+IFB6M/iK5b+VX6qsLhQzXTdgj2DRxrKstCfZsGXDnZr07n3sQDXtrRVVzTp4bMKr/agcoYYRA==
X-Received: by 2002:a17:902:ccc9:b0:240:2eb6:d5cc with SMTP id d9443c01a7336-2402eb6d9e9mr6477695ad.17.1753628672438;
        Sun, 27 Jul 2025 08:04:32 -0700 (PDT)
Received: from sidong.sidong.yang.office.furiosa.vpn ([175.195.128.78])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23ffdec96aesm15381965ad.165.2025.07.27.08.04.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jul 2025 08:04:32 -0700 (PDT)
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
Subject: [RFC PATCH v2 3/4] rust: miscdevice: add uring_cmd() for MiscDevice trait
Date: Sun, 27 Jul 2025 15:03:28 +0000
Message-ID: <20250727150329.27433-4-sidong.yang@furiosa.ai>
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

This patch adds uring_cmd() function for MiscDevice trait and its
callback implementation. It uses IoUringCmd that io_uring_cmd rust
abstraction.

Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
---
 rust/kernel/miscdevice.rs | 41 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/rust/kernel/miscdevice.rs b/rust/kernel/miscdevice.rs
index 288f40e79906..54be866ea7ff 100644
--- a/rust/kernel/miscdevice.rs
+++ b/rust/kernel/miscdevice.rs
@@ -14,6 +14,7 @@
     error::{to_result, Error, Result, VTABLE_DEFAULT_ERROR},
     ffi::{c_int, c_long, c_uint, c_ulong},
     fs::File,
+    io_uring::IoUringCmd,
     mm::virt::VmaNew,
     prelude::*,
     seq_file::SeqFile,
@@ -175,6 +176,19 @@ fn show_fdinfo(
     ) {
         build_error!(VTABLE_DEFAULT_ERROR)
     }
+
+    /// Handler for uring_cmd.
+    ///
+    /// This function is invoked when userspace process submits the uring_cmd op
+    /// on io_uring submission queue. The `io_uring_cmd` would be used for get
+    /// arguments cmd_op, sqe, cmd_data.
+    fn uring_cmd(
+        _device: <Self::Ptr as ForeignOwnable>::Borrowed<'_>,
+        _io_uring_cmd: Pin<&mut IoUringCmd>,
+        _issue_flags: u32,
+    ) -> Result<i32> {
+        build_error!(VTABLE_DEFAULT_ERROR)
+    }
 }
 
 /// A vtable for the file operations of a Rust miscdevice.
@@ -332,6 +346,28 @@ impl<T: MiscDevice> MiscdeviceVTable<T> {
         T::show_fdinfo(device, m, file);
     }
 
+    /// # Safety
+    ///
+    /// `ioucmd` is not null and points to a valid `bindings::io_uring_cmd`.
+    unsafe extern "C" fn uring_cmd(
+        ioucmd: *mut bindings::io_uring_cmd,
+        issue_flags: ffi::c_uint,
+    ) -> ffi::c_int {
+        // SAFETY: The file is valid for the duration of this call.
+        let ioucmd = unsafe { IoUringCmd::from_raw(ioucmd) };
+        let file = ioucmd.file();
+
+        // SAFETY: The file is valid for the duration of this call.
+        let private = unsafe { (*file.as_ptr()).private_data }.cast();
+        // SAFETY: uring_cmd calls can borrow the private data of the file.
+        let device = unsafe { <T::Ptr as ForeignOwnable>::borrow(private) };
+
+        match T::uring_cmd(device, ioucmd, issue_flags) {
+            Ok(ret) => ret as ffi::c_int,
+            Err(err) => err.to_errno() as ffi::c_int,
+        }
+    }
+
     const VTABLE: bindings::file_operations = bindings::file_operations {
         open: Some(Self::open),
         release: Some(Self::release),
@@ -354,6 +390,11 @@ impl<T: MiscDevice> MiscdeviceVTable<T> {
         } else {
             None
         },
+        uring_cmd: if T::HAS_URING_CMD {
+            Some(Self::uring_cmd)
+        } else {
+            None
+        },
         // SAFETY: All zeros is a valid value for `bindings::file_operations`.
         ..unsafe { MaybeUninit::zeroed().assume_init() }
     };
-- 
2.43.0


