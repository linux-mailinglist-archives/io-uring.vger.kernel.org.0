Return-Path: <io-uring+bounces-8808-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C852B13007
	for <lists+io-uring@lfdr.de>; Sun, 27 Jul 2025 17:05:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E1D31791D8
	for <lists+io-uring@lfdr.de>; Sun, 27 Jul 2025 15:05:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19BA021E0AF;
	Sun, 27 Jul 2025 15:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="ir2XY/E5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9322D21D585
	for <io-uring@vger.kernel.org>; Sun, 27 Jul 2025 15:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753628678; cv=none; b=fb/c8DGdAMvI7oQYuCSDEVKH0DuUZ4S65SEaTCB54cLjANPoAm/wq8ZtuxatH1I20HFN5JhKKhGieu/dbJYSr4eBxhixNrwljnMd06YG3hS5U9Z/s38pWlbHZsYkT0k4XCM1rCNT2mV9y+6/KzuRobuqHCcN9IhZP/Ekhb9FnV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753628678; c=relaxed/simple;
	bh=jNgn+CIvun+R8VfNUxSXEoyphazpmnbHYWrUF62SfyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XlMVahhltvCtaFovePccI8oKoftfLdoXjdE7OuY+PvM7b3s776LfPdOWZond/y396DY3yGD7exbu6eFFHtn52/Fxz8LzTeROgB+0yrvInWQG5AcoUixHH5nhytEyqoqkAY+AXsa/YXFJkl7hwtNQMY0XtKkZV8MYTh89YI8Xhi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=ir2XY/E5; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-23aeac7d77aso33109985ad.3
        for <io-uring@vger.kernel.org>; Sun, 27 Jul 2025 08:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1753628676; x=1754233476; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BeNP/PP8zrdwI/UScK/RcuZJZ4ARpjDlW5AwHswNcR4=;
        b=ir2XY/E5gcnilqBBkpD/V/9/SfBhZ7t9ruUs6al5TzEx9aAlEQVjHbnT7fZMytQ3B7
         ThmxRCNLpXgdlsxhk3Lv2VBKvY9YL0bD40MMMOh2YDgEPrQ0/TsJIiOpiF7H1aEVSXnQ
         tTnl/W6Ite76U7giSmcpHIo5y2CdiWO8cA6pU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753628676; x=1754233476;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BeNP/PP8zrdwI/UScK/RcuZJZ4ARpjDlW5AwHswNcR4=;
        b=ByO0siULzaKNUgQnFuK4L2YMtnXQTGEK+uZXPULZJ63lqG9JrwH0lz/K27hkMCyvVD
         1b655IDOzhPgS2LEaU3n1Q+lHlY9G0Nu+t3oij6FvFWfAry6f+GkYHA9hEq0DTQlpNgU
         XjpNniCDhDdwhdr+qTzg9jMmc6n0gB/82xr7XPEhHIvdRvGnftF5N0tZk78KmrgH8JOv
         L1mgZ5HhUEoYGNFd8TZ6XSPwYn4KUAu3pZ8QIqCuRQtSTQiOQhDpJNtGCiKXUB6YSk0J
         wHk8hIb2iFQFwSzMc+oUkegtIXu3RVs318fvZueLNZhdTyNxP4dhi5iBYW0qM3j99/vM
         Iywg==
X-Forwarded-Encrypted: i=1; AJvYcCVYxDkETb38ZVBXznQ4/RhQEFyNAanu4/lahWkIqGBFAYUBlg0Jc14vpPY+3JohOZ5Ena/K73gzKg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxbotTLetONoh9jBBA9gJUuCc00aLnXNvS7eszve6tfDw7hjOFW
	QIVIVrA+DKUqor+Llf3DOlrGjMn7PbNRSETujrdepAz8i1eRKtS3gX20JLwsVNXUmSE=
X-Gm-Gg: ASbGncte5phtIysT3TAKViVPe9mtX9zIpaPA1dBygY9UGwQQ6fFn9Yo0qWpgCwEZqeK
	T3+QALDgNyx90Y8FpI06PaY/75/ZEA4gHHbutgex5+q4S0mJbWVRdXHK6XCPjzx36xFcdlymUST
	C2h4jpHfIouNx0sYLOPjjvLGWYp5v1xvpc9ZNLQ0qGj6/D8ari3VXrZioqZJQa5CT8LYlnLIPIa
	m/C4p6KsPzTPRaL19BJYzyU5IOD99+SZJ70m1QzJLiJEw88/RkYL1yMlemBu9o5Y5Ajja2eXfjA
	f6MMhQ7jTV1tg5NtvJstia6wIq72TuCT3Ov0oxy7wJPcGSYBdh2qgW3ATdTRHjh0eYnX8L7f4xL
	rHlOQa96JyyuPIcZK5GuawYNlUGI7a17GNHjj3pqaocbJJDMWVlGGA9T5kR6JLg==
X-Google-Smtp-Source: AGHT+IEcwUGTvIwSkq572UO1/rKsozpV5VbkWfGTO1wB9NAisfgejoLG5RhSTngcNuD/suDu9l8M6g==
X-Received: by 2002:a17:903:3c4d:b0:234:c8f6:1afb with SMTP id d9443c01a7336-23fb2ee8a67mr118373005ad.0.1753628675847;
        Sun, 27 Jul 2025 08:04:35 -0700 (PDT)
Received: from sidong.sidong.yang.office.furiosa.vpn ([175.195.128.78])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23ffdec96aesm15381965ad.165.2025.07.27.08.04.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jul 2025 08:04:35 -0700 (PDT)
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
Subject: [RFC PATCH v2 4/4] samples: rust: rust_misc_device: add uring_cmd example
Date: Sun, 27 Jul 2025 15:03:29 +0000
Message-ID: <20250727150329.27433-5-sidong.yang@furiosa.ai>
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

This patch makes rust_misc_device handle uring_cmd. Command ops are like
ioctl that set or get values in simple way.

Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
---
 samples/rust/rust_misc_device.rs | 34 ++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/samples/rust/rust_misc_device.rs b/samples/rust/rust_misc_device.rs
index c881fd6dbd08..1044bde86e8d 100644
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
 
+const RUST_MISC_DEV_URING_CMD_SET_VALUE: u32 = _IOR::<i32>('|' as u32, 0x83);
+const RUST_MISC_DEV_URING_CMD_GET_VALUE: u32 = _IOW::<i32>('|' as u32, 0x84);
+
 module! {
     type: RustMiscDeviceModule,
     name: "rust_misc_device",
@@ -190,6 +194,36 @@ fn ioctl(me: Pin<&RustMiscDevice>, _file: &File, cmd: u32, arg: usize) -> Result
 
         Ok(0)
     }
+
+    fn uring_cmd(
+        me: Pin<&RustMiscDevice>,
+        io_uring_cmd: Pin<&mut IoUringCmd>,
+        _issue_flags: u32,
+    ) -> Result<i32> {
+        dev_info!(me.dev, "UringCmd Rust Misc Device Sample\n");
+
+        let cmd = io_uring_cmd.cmd_op();
+        let cmd_data = io_uring_cmd.sqe().cmd_data().as_ptr() as *const usize;
+
+        // SAFETY: `cmd_data` is guaranteed to be a valid pointer to the command data
+        // within the SQE structure.
+        // FIXME: switch to read_once() when it's available.
+        let addr = unsafe { core::ptr::read_volatile(cmd_data) };
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


