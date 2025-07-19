Return-Path: <io-uring+bounces-8724-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FDE0B0B077
	for <lists+io-uring@lfdr.de>; Sat, 19 Jul 2025 16:34:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E08D3B6E15
	for <lists+io-uring@lfdr.de>; Sat, 19 Jul 2025 14:33:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EA4C2264AA;
	Sat, 19 Jul 2025 14:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="k1GEk6Qs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13976225795
	for <io-uring@vger.kernel.org>; Sat, 19 Jul 2025 14:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752935650; cv=none; b=VXyXCl8w5HbjW046PonUgz0ZTiBfpclBQ51TDa0He1e/R3iCIi/7eLw8D6m2vZ3oG3T/kCneF2C1/w/CTpXyEEwScpiDHwjxzicQPnwUCZQuvx4naK76zswI+K7IBeW7WdVr7Q3d3TwgH+RrbAP9SL/vqJ79hr2Zalah6b58jMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752935650; c=relaxed/simple;
	bh=cIlsCjU60tcTX9pCHNYoUdcY4K8aiFQvCiC3AoK61jA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EIbPbpwjcrGc/ppj4zncmmWE3a/ubYmfELjy8GVIKrj7uWTlOvxcaeJAX8CIHZiXWfafFr5RAPnOJNj1g5Fktnf3/w9iansKtEflM21sDRJGw5VSWNe9v4wvwR2w5WWGAuAwduHO2PRTxfqefptGFIbFWfA0b81+Feo2jms5vx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=k1GEk6Qs; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-237311f5a54so23610685ad.2
        for <io-uring@vger.kernel.org>; Sat, 19 Jul 2025 07:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1752935648; x=1753540448; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZgLQWEfUsgUd4bc4XTm4Fj5yFjdCjIN4tWY9zvoyEr0=;
        b=k1GEk6QsJy7Gr8V2GkgXwYyY6fMmoLO+SL4J7RMq41hSdzOp9o7tyyzHeBiKm6ic6F
         ByVh2CPivEttJ2usjF56ufvZlU9JjpGinv6GUPvnjB8xcKYf8isEJ9ICp5tVoLek3arL
         pxAsLWu2HYjm2eyXB4rKpOIJHBq4/V0anUMtk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752935648; x=1753540448;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZgLQWEfUsgUd4bc4XTm4Fj5yFjdCjIN4tWY9zvoyEr0=;
        b=h10bakbrrSI0XCvlDkk8cUWk8tOZmFKzb+39RUnI+3T0KsG2OtXBMVWqEl55nbZoYC
         dyix/fhiw5HWPf7wgm5wAfHDnuXIot50bSb7lj7I5N8h3MgNxTum3QdUDvl76//lEYby
         4oJjr98+TUGjAVEY7B+w8KO0iduV8ldjRXw9DV/MEw8pxFmFQfmDoy21Tf4IVSSJhjE7
         0ZY/gn9n4JbhcJiwFowFqRrguzwQbx7pv2nUs8JRl829OsTzVD38PNPDXtUWdl05EzSm
         EfCJOtNOlPGhChPrR/5DrdWjMVC4thP1t2ry1dlkK0bf0fV9U0YVTtEmwK60ZphCwy7r
         oE8A==
X-Forwarded-Encrypted: i=1; AJvYcCUoI8wGeWNj/DNR7GAayvEPAb/qntNCQ9LEyXIiS33yyp0harcd5KAZOnzvxc/l7eC+ZYH0n2ElsA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxWYYQybUhTXmeW86CRYkmUovqqEZcTozuLnXl9rTaaKehQmrpr
	oEjYZZfn3erIdLeVsrW+rNPLRzPNo4fDSE/z6+K/uWFMABhPqfLsfhNM5IYF/V5IzdB4hrYY4Ho
	fwEsJ
X-Gm-Gg: ASbGncsXMn78AwP3Q+MmZoAj4sigSOGbgnB9V8clg/kC21wrLOuyZrU37H581zae4Bs
	rfAXah+PAJtr4xFpqCQSRlkgIlA0jnxhFxSN1eMiSP1dbHUwu9MVMTgUZEnrIzL9sCgs6Qi8Nrd
	Tbt0Pp49SDl3S/jkXa6s+5UFVuayl2sPYCWbrRSWdYaXRIArJ1slVKg6CUVapfimm/QJww0jh54
	cBIcgucjwQaVybwU+yl2U1+DGwLlSetirUGILeNYAli7kQECXfjSTUUR5o0WY6u4OrDnqH/VtV+
	W2k/QZU05ktiu2kKsnR454N7JNlelP1OozMavCOYHa5wex2vkCBJ403Xg6xzeKRZlXArkSc13J5
	aFG/IbiuCKaAjJRHmxttTSK6bT4AJG1FbfHmbFzrsAs0xMN5qJ98461cMCx0=
X-Google-Smtp-Source: AGHT+IHmqgL62d37O3Ajjc0SWP3lfmOKTeqf3aN029Y1WM6pxkfJu+Z5abVV+qUXutkwbgMwULqrSQ==
X-Received: by 2002:a17:902:ce85:b0:23c:8f15:3d46 with SMTP id d9443c01a7336-23e25750d9emr181722575ad.37.1752935648180;
        Sat, 19 Jul 2025 07:34:08 -0700 (PDT)
Received: from sidong.sidong.yang.office.furiosa.vpn ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23e3b5e3d4esm30017525ad.23.2025.07.19.07.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Jul 2025 07:34:07 -0700 (PDT)
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Miguel Ojeda <ojeda@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Jens Axboe <axboe@kernel.dk>
Cc: rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	Sidong Yang <sidong.yang@furiosa.ai>
Subject: [RFC PATCH 0/4] rust: miscdevice: abstraction for uring-cmd
Date: Sat, 19 Jul 2025 14:33:54 +0000
Message-ID: <20250719143358.22363-1-sidong.yang@furiosa.ai>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series implemens an abstraction for io-uring sqe and cmd and
adds uring_cmd callback for miscdevice. Also there is an example that use
uring_cmd in rust-miscdevice sample.

Sidong Yang (4):
  rust: bindings: add io_uring headers in bindings_helper.h
  rust: io_uring: introduce rust abstraction for io-uring cmd
  rust: miscdevice: add uring_cmd() for MiscDevice trait
  samples: rust: rust_misc_device: add uring_cmd example

 rust/bindings/bindings_helper.h  |   2 +
 rust/kernel/io_uring.rs          | 114 +++++++++++++++++++++++++++++++
 rust/kernel/lib.rs               |   1 +
 rust/kernel/miscdevice.rs        |  34 +++++++++
 samples/rust/rust_misc_device.rs |  30 ++++++++
 5 files changed, 181 insertions(+)
 create mode 100644 rust/kernel/io_uring.rs

-- 
2.43.0


