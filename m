Return-Path: <io-uring+bounces-8725-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EB029B0B07A
	for <lists+io-uring@lfdr.de>; Sat, 19 Jul 2025 16:34:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 118D61AA1311
	for <lists+io-uring@lfdr.de>; Sat, 19 Jul 2025 14:34:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B56A2882BC;
	Sat, 19 Jul 2025 14:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="LVAHdl1W"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E482877EE
	for <io-uring@vger.kernel.org>; Sat, 19 Jul 2025 14:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752935653; cv=none; b=o/TpfLO87x4SxyggdkuFL7ljGLZubb03zuhGwBwsHYw1OSqFzrMD3yjAEK6BPWh25dPUmpYK6UmXLjZiN8H338Djpi4ioE6wcgi+zBM9bs42ItyYkWbu//NiRwak7BBeh41TjUdfdqWjWLj1MuSWVM4szrI6/M4rBtRqftqlPgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752935653; c=relaxed/simple;
	bh=H4aHIJOV1TJAq6ZuusFg9Zqr2Br14ng8uZtfr3ysksQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cbHKxEO6F8AarwiWzB1FivbcCqqP3aiHqXXDm2iBoZiJ1b8sfthxiaqfHwvBFLtqCJxOBZHsJPd/c/Vp9HrG28pmRrJKdZsnHGR9+h9HyXJnw+p/kPAi7AXR2Hi6RFjCqqSo0GNUcPfyDsERxyMyY1mqX9mgJWiOvZxOYRGjxfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=LVAHdl1W; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2363616a1a6so25588485ad.3
        for <io-uring@vger.kernel.org>; Sat, 19 Jul 2025 07:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1752935651; x=1753540451; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TkIl0Ng87tj2Fj8IQfRrJkmK5nZP9FIei480gavcNNA=;
        b=LVAHdl1Wrq0uawe3y/ixfQc3yT6BbiwWtht0+RGCFhvZFl04LGSg35NAT9ETQYSSIc
         eRM78ss+P/L8QQxPEu199EbTHs/EQ9g3YV4dr3LiQM0BxAbwQ1RHRazR6lk4ixQh2zw9
         6o3GqZIh3A/YNGjwytyV0iLgE2VyEjzUW+KbA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752935651; x=1753540451;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TkIl0Ng87tj2Fj8IQfRrJkmK5nZP9FIei480gavcNNA=;
        b=XQc8xRDn03gfwVkkcJjWebwb2lVOZNdgguYrdUIyXXvzYwoyvkDdJsN7hT/4JkSEPI
         a5b/sCrDAYZ+tyQcLG6MuNhEQ284LwmKLmfIZ+9Eff+B2ugtd+gEjXsQ6+O/tYklIhLc
         RlSVn3GsiMNnsFIma6otllQ/fTfngWvq6BgDV2sXlWPNuNyqN8ymCge16WTNHHdss+Jl
         UPsMDefcGyM3PEp7tKgfljoyxsaMmfTvHCk8vJGWhSUN7OPHGjMhWYR6qUHNipiqFE/o
         r9UPBwOhQ78xYRIMyRBI5FzRjJbgwv9KFnISNevE12WUGTmzLs1pgCVa6LNZkbxD6uOH
         Fghg==
X-Forwarded-Encrypted: i=1; AJvYcCWdhzQXTUBuhmeky1kH7K7+fgfaDyOyl8LoLZNaXx7RSis/8r2bsfz+5E8nzMAR+kE46JlWEWmpfw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwJMWdO6LyUopTmemNa9uy2JDvDeIo0YOV4qA2ZAEIQNZcd5rUE
	gseu/k7o/hMZyqNlPUp/DfZZODXCr6F2FfC7H8JfFlVEjp49OV8T6BfvjFDYFcjFg8I=
X-Gm-Gg: ASbGncv9g6KucqQ0YbVTp2Whq5YMKXUJxYtkhW3PRObm28nIc83Dwkkz+9zI/6g5TGf
	+ZTKxfWSV+lUOdoebqZ2IBneV3GfgwUoZbfB5ldnNMYtE+Ctwm29lw4wgsavLJ07ifySqV90hD+
	PmG4aSOEX/NK5TJUv48TeqQ9jLg3YFEhZUsloB1EYql08cnFom/MJ9darouglWfpFsy1GZtvjtT
	M14ybssuppTm9ueiTlUAwfxMTSlJZgcNA1oLW2LHb/srH13De4RRSPYL2jSggQpHdit0ITGnR7w
	3ft92XHHrSmpNhf+E+PnGIUYb1I5gqo2adS8vGcDM8kVD5he9VpeX+/76RN+ZEjg0A0E8hGwUV/
	m7XjbAwz0zws6rE3R6vSquWIrHoKL2HDHE9JeZqiYt9zL2MXMo2v+/6bWdnk=
X-Google-Smtp-Source: AGHT+IGpEs8uiBA7/aVMtHrt52Qtzk5GqQnPoy335qfDXK4TTerS+kRTHT4TOUh64k+czliVVMOb7A==
X-Received: by 2002:a17:902:e88d:b0:234:ed31:fc96 with SMTP id d9443c01a7336-23e2572fbc3mr200769665ad.26.1752935651099;
        Sat, 19 Jul 2025 07:34:11 -0700 (PDT)
Received: from sidong.sidong.yang.office.furiosa.vpn ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23e3b5e3d4esm30017525ad.23.2025.07.19.07.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Jul 2025 07:34:10 -0700 (PDT)
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Miguel Ojeda <ojeda@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Jens Axboe <axboe@kernel.dk>
Cc: rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	Sidong Yang <sidong.yang@furiosa.ai>
Subject: [PATCH 1/4] rust: bindings: add io_uring headers in bindings_helper.h
Date: Sat, 19 Jul 2025 14:33:55 +0000
Message-ID: <20250719143358.22363-2-sidong.yang@furiosa.ai>
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

This patch adds two headers io_uring.h io_uring/cmd.h in bindings_helper
for implementing rust io_uring abstraction.

Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
---
 rust/bindings/bindings_helper.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index 8cbb660e2ec2..a41205e2b8b8 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -72,6 +72,8 @@
 #include <linux/wait.h>
 #include <linux/workqueue.h>
 #include <linux/xarray.h>
+#include <linux/io_uring.h>
+#include <linux/io_uring/cmd.h>
 #include <trace/events/rust_sample.h>
 
 #if defined(CONFIG_DRM_PANIC_SCREEN_QR_CODE)
-- 
2.43.0


