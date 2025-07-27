Return-Path: <io-uring+bounces-8805-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9E7DB13001
	for <lists+io-uring@lfdr.de>; Sun, 27 Jul 2025 17:04:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A26817871C
	for <lists+io-uring@lfdr.de>; Sun, 27 Jul 2025 15:04:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B5BA21B9F1;
	Sun, 27 Jul 2025 15:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="C+w1gprh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB0A21B918
	for <io-uring@vger.kernel.org>; Sun, 27 Jul 2025 15:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753628667; cv=none; b=K9aWwB1yBoLES1IwHGubrZYUKQJn/ddVYHHp390HGWbFn7TLbvhiRNRZtDmdve3sBxZSYxBSydGPgwjm27UiS2zl/DYx9oePeHvirQ4Pz51VTVpqQe4tX7QRfXJcjrGSpXZLvrI7mgRZ1UXe0YlB/mpZYnbZhbh6Pi4XktQlH+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753628667; c=relaxed/simple;
	bh=H4aHIJOV1TJAq6ZuusFg9Zqr2Br14ng8uZtfr3ysksQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fTU9JQSceKixD2DIuBvkXdprPAXhdFJ2QyC7wEmC6Oiz9BkCQ7oU7hVfGeAoGwyoDFLNPk8K3pCxzBg05TFWnRNa1/VdnLxDlBnD4oUodu3DSz0bMIHJxOKzq6JfBj1PdU5ImpOyaw7k3EjdVGq/S64qDgSjMfDPNvVvdviOKHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=C+w1gprh; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2400f746440so2957305ad.2
        for <io-uring@vger.kernel.org>; Sun, 27 Jul 2025 08:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1753628665; x=1754233465; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TkIl0Ng87tj2Fj8IQfRrJkmK5nZP9FIei480gavcNNA=;
        b=C+w1gprhE1LSZUr3AKY+NKfeXsbGRczUf3vBzxMHuzhfEgcoMyLlOpvVz6bg3VUJvR
         T070zJP8V33fQDhZLl/585EIYF8b/UIYhXfMoN0RnOTc0yJt4OA8tZ+9lMizxJPAazPY
         AO1taE7AGjFBN9DwXCqPOP34ZnMYaEUl9raJk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753628665; x=1754233465;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TkIl0Ng87tj2Fj8IQfRrJkmK5nZP9FIei480gavcNNA=;
        b=WbeZ+Rcxzxk/O/mMtIjxrfOm4RlhP12yvMEFQDjpHHOOdl8UYJxSKyM85/ZSEEfknQ
         dyZ1eXp07GW4GEQyWtyViu/tVblcQpmeApP51nOdA1OTsHLhj2YO9JlMhrtsXbu4WfMa
         415k7KMh3zVICvz/IeyUXI5tej8JCJXzMZWkFG5hhM8yAfEQAPNBQaCewuB6k4PsZUak
         e2uKvmVNyVbUZBIDg9MyaREVbup0/bPVw/6uyf1+Sidmb3EyeLM0YZH/N1pNOiUituWC
         jJuy6nrJddGNszCK5ZIkAq30PqOhuUiThY45znqYEtveCCfdpiU/92Wg3bOQiU1WpkEy
         Ey7Q==
X-Forwarded-Encrypted: i=1; AJvYcCVGZotJs+sqN51VqTJSeEshiuBk3peQrlifOEw7/c/Pajy6ZsouQ94oQlddWOakL/idup4wpBsf1w==@vger.kernel.org
X-Gm-Message-State: AOJu0YxOs2maB81vHhfV2PKZXTxPOJoKO+HlYVCgQmexuOMTZ84AcPVB
	YFM4dN4xwfXaDokZb5rfnXwmPrTbB/2ttnroIKYJRLjak2Q6Y0cOAdqUpw3ntBrSdhU=
X-Gm-Gg: ASbGncvwqFZH5PC8GrqA3jLTYoggSnTFbFXgEBNrr1Tog6rN24H7aJdyR0qLRAlJEYU
	ddo9FVlgUXVdLdTAWf6WSRFnBukBK/6Vi9oSle9pBYlmGdUENVacDHdyBQbpQfdHRS08Yqt9+w+
	KhGcGj7JX/K/KufA4ypCWV8C4CPgZdxlzniFOFS9N5K+u9bVVwJPFqjidGhwoJtSshEUlARAKFY
	ZyWB79fHsJoNoLW7dbUODlZz4M4+jErd92XaeLuCB0t8WNTtJ5LLEc8Zg2P6VeTzcQPiU478Spo
	zDIlopYUmDgiRM1iWAcFAGy/PEF7QZbqhCJHSAwsH6T5j06SDypnYTBuOgMZH+XiMUN/hNKWKll
	RNCyOazV0YDmKBAWZNJoWP1b5Ha0qTwZba0X378iEOiBWKBhd6zBk5f5caeRYCg==
X-Google-Smtp-Source: AGHT+IH3T9NAHqsD3owCYZXUMl0VQjeiye3RBk2SMd/XJ4g10HNgS5Tm3Wd75o21SRnae8bador9kg==
X-Received: by 2002:a17:903:ace:b0:240:1953:f9a with SMTP id d9443c01a7336-24019531719mr20105335ad.2.1753628665479;
        Sun, 27 Jul 2025 08:04:25 -0700 (PDT)
Received: from sidong.sidong.yang.office.furiosa.vpn ([175.195.128.78])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23ffdec96aesm15381965ad.165.2025.07.27.08.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jul 2025 08:04:25 -0700 (PDT)
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
Subject: [RFC PATCH v2 1/4] rust: bindings: add io_uring headers in bindings_helper.h
Date: Sun, 27 Jul 2025 15:03:26 +0000
Message-ID: <20250727150329.27433-2-sidong.yang@furiosa.ai>
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


