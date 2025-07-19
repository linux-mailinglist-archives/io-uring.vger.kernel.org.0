Return-Path: <io-uring+bounces-8728-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E7F2B0B07F
	for <lists+io-uring@lfdr.de>; Sat, 19 Jul 2025 16:35:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 02FB4564021
	for <lists+io-uring@lfdr.de>; Sat, 19 Jul 2025 14:35:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09DAB28934C;
	Sat, 19 Jul 2025 14:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="aJfYuXOx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F66288CAE
	for <io-uring@vger.kernel.org>; Sat, 19 Jul 2025 14:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752935661; cv=none; b=NVplo1bShGx7KilyNZ3t7ikNZ9pW5mDu/aLgrsSDBXiD0iPV+N2JOBFDH3elkaGa1ljzSyyZTjG9mHlS48kZSoSkLu0tSBvYcc4NwwPqsuEjIbaAaIw0O5qd3bOaQa1pPm70ORtMNlqfAMYWYXwwFrZp4qbBtL65EKFJexZUdFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752935661; c=relaxed/simple;
	bh=R8jGhX8GJtxbiAjtt52NeFBV/TnGPSvZljPJO54V9Lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=InRejcadg7M4Oc7WGd2uaZ1GFeW4w27JObE2Ep9CFNkSrb/SNcPDAor9LTMmGCdXS1sfFR27s53BSwLL0JhRRKwAkF4/fQax290B6ttonyse9txYlCGRdGzeEnRTiEE1wg+WCNqZJkHZqhKilNFDgXD5QqI8kz+Hh2iZzvrcZc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=aJfYuXOx; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-23c8f179e1bso30169885ad.1
        for <io-uring@vger.kernel.org>; Sat, 19 Jul 2025 07:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1752935660; x=1753540460; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JXkaSAeBjzAQ8y2xwh0Xd1YosILeCAcR4SjyO3knpT8=;
        b=aJfYuXOxg5aGSwJytWRSxA2iVptDm6BSlt+stdfturMsUIiU+oTsmKsEAMyLSlaXqO
         G5TkolIGNV00tg7nANLFhpxuXloH+FwRnvq47kzMKJDEsSy22Q18K+MBRk7NVP3mYCLE
         nbmrHP2KLJhOGX47b3qAg/oVkz0Bny0npGBTg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752935660; x=1753540460;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JXkaSAeBjzAQ8y2xwh0Xd1YosILeCAcR4SjyO3knpT8=;
        b=ph0NLsYK0x1co2yl2rjmisJ14bQ4vkZaD+BVZpLgJskY6OPRxwMF63opgOe/Jwp4P2
         9bCdrOAPwmblHMsqmctGKjx8OJBbEvEIAI2WwYlXNOuPQ9Kh6xj8UdTBOcCe3qgASoB7
         Gm+TajdbAdaTDn5PuhM+Jzi33xWNavZTDH5PZrKiJeWArbahaHRLsHLg29YhrfFbSwB6
         Jk4F3pdlv1z2HSVP3/5XKSuDUZ91WyBrUOh6gD7NOQn5nKAV9IX9RADQQ/QxTPtp2P+y
         HIK0y3O8xVrWkSpko/1x+PjkNLXlQMgyQhDmGXZ1GZ3yG+m6Mp7UcuWaONszQxfsJOLp
         Wb+Q==
X-Forwarded-Encrypted: i=1; AJvYcCUOLZ7DuwRaMseqab+9J18L3ZY7NCu5u1MYUZpgWWApLVxja0Ie1exFvdYKqqJErT0XyNlrVBX1qw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxifW3IgUK1gd9sOLODYit5zz3JoFdl7uEeFf/UnhKjppSTPSSu
	n63yU3GU4POqQb8wMGiMetTbITwI0scG0yfqRTUjNBINJ8dZOAlFu8tq4cXbDyGOmjg=
X-Gm-Gg: ASbGncuAGky1imKusACvSiHWhUjBx/Z9AQdcNAdZ3kyOIfr0K3ywxngXsq6KjeDCMKW
	OrEId2090hjgA6tS55t3UDQc+xJ0SXhxKzWW5hmm9Xmck3J3zLoUF0/FagTt1vkDZI7+4mVKY/Z
	vuHbHJcRCNhDPZg/4tRPG4AjwDhixRthMsr3t5Y6h04ieXlE1bAaQOenXtgYinOkPSeoSmvlgZd
	nwIl4ss13rmxILmpri8Arx0nqTFRzgF3D3EoDiZkF6wGE0mrKy4D/2cUsT3Vncx2QNS4LHdqdML
	nM7/IaU/k2NsOUi1ZPRgLvdnx0LFnHGkdQNzscjsNQw4ZfxHukNQM+I7OZznJiUsvtelWDtVdSB
	jG3699Z4Io2FXz/DIhE7etBpoICOsa8jH5cgVHlnJo0C1UL6S67T5mdEzwzA=
X-Google-Smtp-Source: AGHT+IH1voNmCvwGJvMrZvclPm+sCwPYvCoAW1RlSoHG0ImiAoioy10GrH2F7hsoOibb8Z+aHB5r3g==
X-Received: by 2002:a17:903:1b6c:b0:234:8ec1:4aea with SMTP id d9443c01a7336-23e2579eed1mr218928065ad.52.1752935659962;
        Sat, 19 Jul 2025 07:34:19 -0700 (PDT)
Received: from sidong.sidong.yang.office.furiosa.vpn ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23e3b5e3d4esm30017525ad.23.2025.07.19.07.34.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Jul 2025 07:34:19 -0700 (PDT)
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Miguel Ojeda <ojeda@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Jens Axboe <axboe@kernel.dk>
Cc: rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	Sidong Yang <sidong.yang@furiosa.ai>
Subject: [PATCH 4/4] samples: rust: rust_misc_device: add uring_cmd example
Date: Sat, 19 Jul 2025 14:33:58 +0000
Message-ID: <20250719143358.22363-5-sidong.yang@furiosa.ai>
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

This patch makes rust_misc_device handle uring_cmd. Command ops are like
ioctl that set or get values in simple way.

Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
---
 samples/rust/rust_misc_device.rs | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/samples/rust/rust_misc_device.rs b/samples/rust/rust_misc_device.rs
index c881fd6dbd08..cd0e578231d2 100644
--- a/samples/rust/rust_misc_device.rs
+++ b/samples/rust/rust_misc_device.rs
@@ -101,6 +101,7 @@
     c_str,
     device::Device,
     fs::File,
+    io_uring::IoUringCmd,
     ioctl::{_IO, _IOC_SIZE, _IOR, _IOW},
     miscdevice::{MiscDevice, MiscDeviceOptions, MiscDeviceRegistration},
     new_mutex,
@@ -114,6 +115,9 @@
 const RUST_MISC_DEV_GET_VALUE: u32 = _IOR::<i32>('|' as u32, 0x81);
 const RUST_MISC_DEV_SET_VALUE: u32 = _IOW::<i32>('|' as u32, 0x82);
 
+const RUST_MISC_DEV_URING_CMD_SET_VALUE: u32 = 0x83;
+const RUST_MISC_DEV_URING_CMD_GET_VALUE: u32 = 0x84;
+
 module! {
     type: RustMiscDeviceModule,
     name: "rust_misc_device",
@@ -190,6 +194,32 @@ fn ioctl(me: Pin<&RustMiscDevice>, _file: &File, cmd: u32, arg: usize) -> Result
 
         Ok(0)
     }
+
+    fn uring_cmd(
+        me: Pin<&RustMiscDevice>,
+        _file: &File,
+        io_uring_cmd: &IoUringCmd,
+        _issue_flags: u32,
+    ) -> Result<isize> {
+        dev_info!(me.dev, "UringCmd Rust Misc Device Sample\n");
+        let cmd = io_uring_cmd.cmd_op();
+        let cmd_data = io_uring_cmd.sqe().cmd_data().as_ptr() as *const usize;
+        let addr = unsafe { *cmd_data };
+
+        match cmd {
+            RUST_MISC_DEV_URING_CMD_SET_VALUE => {
+                me.set_value(UserSlice::new(addr, 8).reader())?;
+            }
+            RUST_MISC_DEV_URING_CMD_GET_VALUE => {
+                me.get_value(UserSlice::new(addr, 8).writer())?;
+            }
+            _ => {
+                dev_err!(me.dev, "-> uring_cmd not recognised: {}\n", cmd);
+                return Err(ENOTTY);
+            }
+        }
+        Ok(0)
+    }
 }
 
 #[pinned_drop]
-- 
2.43.0


