Return-Path: <io-uring+bounces-9249-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BFCFB318B4
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 15:02:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7974F1BA0ADE
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 12:59:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E514D30276B;
	Fri, 22 Aug 2025 12:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="QAuNGGSP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7532FDC2F
	for <io-uring@vger.kernel.org>; Fri, 22 Aug 2025 12:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755867399; cv=none; b=qNKcQVDd2FfWS/py43B+rYqbV+gv1p7Vt5vUrtJrOY4fJ8hpEEZiGHFzGG+CeLJki+Ifq0mgVOEZ9860n4hgH7iOpIlN3cZiw/NPA0a4LTAfnhgr7zS11KPsi0Df08eXHnWcvV3fSjhJaQAL/YXFeknROWtZWln95ygj25iFlNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755867399; c=relaxed/simple;
	bh=2p8LG69KmCVA8ZLTUV6rgT5Wy5/pv1AhMG9wpLxMJIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=paMuQboToiCTehdtkx32ow8/5QVjPQys91X4pMyY88ZkjNNKC0jD14oqckT+B8cg23aOUlV/CXfczQn62NmRkBO30flhFfKI+/eQkb8whLp+UhGHpRou0owZhl0rNjpefHLkD9wXs1XTQ8e5gbXezYEwPNV48QRz0Stx6X8q7Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=QAuNGGSP; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-76e2ea94c7cso1955103b3a.2
        for <io-uring@vger.kernel.org>; Fri, 22 Aug 2025 05:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1755867398; x=1756472198; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p8fwNJeHNHWIWunBevE6xxfqz+V4AStymQDWUp+Nzso=;
        b=QAuNGGSP0ojjaY4qas+ib2P3xKaP0KlZxo0Mkc7/aOaHvUbtVAKBQTEKEYP6WUZf2U
         5zE61e8nwoVb6zR9o2wvyoaWdvf0vnzk6Wl+EXSsbV7+y207FcKbqAXhMcx2jXURHEMy
         3dDiFoAFGabwz9w8srf+x7zObFXNYgcQwfIWk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755867398; x=1756472198;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p8fwNJeHNHWIWunBevE6xxfqz+V4AStymQDWUp+Nzso=;
        b=da8zbiemxxoO+tjiEKuYO0TjpRDN2v0OvqEnKYcZz3lNdSiqX3y72Betj6e51JXUTB
         h8mrcSeVOmco8kFSpk5P8rnVrXq0oTuW56zSix8eGssJiSxl8bZsMyQet24Z/7QuxcmU
         pxPYAQnqZjhT0GYBhzaB8ll/Jlrwd6Q/L2XfX/2ojKugvJC7Zj2Efj5SB82FVS97Wpg9
         pAvxU70exR8kjZwqHC1JjXXzOHD+yr9dvMuUhUjUpRmEcF/PlUgzREyU6GAWLAYuy/7D
         ttio6q97NvyMM/gO9MiE9ZqWn/y0oS/Afd/dJOJpqy8Zs3YCjnH5GZL17+94rviOfHOg
         F5Wg==
X-Forwarded-Encrypted: i=1; AJvYcCVjOfWlhA1A7vuknmh5nrt9JSYRO+X1RQ52aQJNBAMaGF/D9Y7KXlksR7lR6IwAPJnkxdKynfmieg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwfoQY1ds/XCcIyOv2QNYAikXxnlh1K5YuS3+HGnY44Y9CwvWBr
	CxH3U95EHcBvMW94d5aKYc9fsPqlrnzV4LhUlXkFD9YxgUJ3xko2NMwF/2vlkIYxITc=
X-Gm-Gg: ASbGncugdMbdfG01ut9KzPOsFLU2qo9oU1C0G0a6s/+5/6R+iyVTfdZ8aIPU33tKQ1I
	Lbj2As+B3JEZrL1+MxAhO7qMDEa20XeWwslVQzpH9JbpQM3SQZwXvZdjB25erP2Ikj3Roi54GKt
	fQBoQj4iU+FFvYLh/GLNF4cbA7jQw2lbF7fzNVEUKSOo7lZtAfTMZymFNUzeRiB/qNAieQK78Vp
	VmNd8eksn19NT6+KkpGbvAYGJhiOA4UHK3M/eaRQYjbsUG0qrGByoafH9LFrJQrVAE1ZP/GO11d
	Xtonvn5mEaVh8G36M2qCt0JcpOz2IuQwXHMjrfD7sM4sPl+VDba3Lbvqz3+boqBvgdmUg6U+HHQ
	BLhEV2jF0u+paCV0mS8Ec1CcCTK0HsqesOBg4zk5Svf0C9if16IIzl9rSxCZ3pVGZK+5+Qg18
X-Google-Smtp-Source: AGHT+IHDhJuu9+cO4uxsw6AoUa51QjPpNUdCs5GI2HWZsOmJ82BW0DSG2NIaLQoRPu3I8EhQjTg/gQ==
X-Received: by 2002:a05:6a20:430d:b0:23d:9cca:e710 with SMTP id adf61e73a8af0-24340de334bmr4095404637.44.1755867397819;
        Fri, 22 Aug 2025 05:56:37 -0700 (PDT)
Received: from sidong.sidong.yang.office.furiosa.vpn ([175.195.128.78])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b4764003537sm7194544a12.25.2025.08.22.05.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Aug 2025 05:56:37 -0700 (PDT)
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
Subject: [RFC PATCH v3 1/5] rust: bindings: add io_uring headers in bindings_helper.h
Date: Fri, 22 Aug 2025 12:55:51 +0000
Message-ID: <20250822125555.8620-2-sidong.yang@furiosa.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250822125555.8620-1-sidong.yang@furiosa.ai>
References: <20250822125555.8620-1-sidong.yang@furiosa.ai>
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
index 84d60635e8a9..96beaea73755 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -75,6 +75,8 @@
 #include <linux/wait.h>
 #include <linux/workqueue.h>
 #include <linux/xarray.h>
+#include <linux/io_uring.h>
+#include <linux/io_uring/cmd.h>
 #include <trace/events/rust_sample.h>
 
 #if defined(CONFIG_DRM_PANIC_SCREEN_QR_CODE)
-- 
2.43.0


