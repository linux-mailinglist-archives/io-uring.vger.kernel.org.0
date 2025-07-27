Return-Path: <io-uring+bounces-8804-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 777F7B12FFF
	for <lists+io-uring@lfdr.de>; Sun, 27 Jul 2025 17:04:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8F96E1893224
	for <lists+io-uring@lfdr.de>; Sun, 27 Jul 2025 15:04:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F14B1B412A;
	Sun, 27 Jul 2025 15:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="iOEnQwZv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04CC212B3D
	for <io-uring@vger.kernel.org>; Sun, 27 Jul 2025 15:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753628664; cv=none; b=KA/KsG+CR20rudgcN4Swb0DnXid3iNnr/ig4rZ4lciaYTYoiObxRuqW47IQGFgFXV9Yyr1KRcatAbsk8YMuv1Bidy39V9UBHNHBbFGEpfiRsd8vuHsxxPvxErsqm8z1wejme1t1fDy70hykhwFGCfcvW04V5PyftQy8Yespc/18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753628664; c=relaxed/simple;
	bh=lq0rvADk0ip5/mydADtM0En2DQCVdDhGMreH6FgPDVM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gdbQJVlPveoz4SsGplwhv+R/BIo8PxI8Cq2mAPC63gDXhjlq89u+74ACKVvKfJtKquA6f9gSgzrb4NFyhjVXaa9hT5THjrNQE5B5MTaw4PkxKIiVGlpO+5OGAo34uRJKPxPlMKGhFqEC2xrZUcenX/2U+98A3W0SdG5+P/y8OXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=iOEnQwZv; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-23602481460so36354415ad.0
        for <io-uring@vger.kernel.org>; Sun, 27 Jul 2025 08:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1753628662; x=1754233462; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=I8fMaV7c+UtGlaRMtsdXr3vVISUVpzDVRmnS+us0bO8=;
        b=iOEnQwZv/cVZs2U7/iys6edJfNysimk7xFgnXVJun2ATq/8ab9oIn58iqyHiUhzN+1
         F/evwjxkJvFUZvqanlZwosyoBAmUagJFn0dva0oXexwxUPDWdDJ54Y7vxbf+Tb+BsAq4
         KLfqT47wWABwAjlGusEubViRLWf40XMytiCjY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753628662; x=1754233462;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I8fMaV7c+UtGlaRMtsdXr3vVISUVpzDVRmnS+us0bO8=;
        b=VC97ZtmPuxGBYMPXx4S6RXeCf8e10hpBlrIMV/CLqjeTD7IlNT1aaqBrDyp6wIyWY8
         t+zLJFoiPW4YXlq9JViB5H4QuTbNnuHUm71iVgHKCSFSt+dv1fFTrN8MOEAxD5GNWQXR
         A/3EG4Ts2uJb92FVcXbP2lki935MqVjQFCHhGMyeY0oVSGsTAqao1+Um9jbjBETlmIOR
         g4vJiLcDCd69DgooBP5geU1tXqSdLIDr9vkYKA/Aq7eVx+TWHU4Om5PfrQuV2krruoSi
         pnMEagcRByUTJridE4hO7Zdfu5HndB/cpBm41gdArVuNlrx1oGXirsMltWmFPj3ozFMB
         CtMg==
X-Forwarded-Encrypted: i=1; AJvYcCX/Ct1n7kPIkBFwJyXjhtuzYUN2apVfQzvznH1QdY+M15Bfab/p5D2AwA8sZADaSubHRfJX/5br1g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwgFpBF6UjSR2v0KZFyTUP4F4r+TZ27FqXoMKU4tI2odkeV/QOA
	LWunMTSLQhTQliwaQhCI3VxHSCFxxxL4tfZ4Vvv7CiMpzvA1wTCxsTFGyd/q/yypNlg=
X-Gm-Gg: ASbGncvfCSLu3DcyDMEE5pMVvH5VD73poEaJ58OIoGL3KExumDa99K9kfbn0c5HRczI
	ZtFLC1ppXTCdR12m1W4jdrCJVNAkxYH9H7T2hLURBNQ2mTQ3DWGLGSYLbCJcnbe6zIEAPkw+2mj
	QFnZ4rzf81r/mvpJGzh6JOQF2zle/EcavY20lZ6PGgUb/bYA5PAWRPT2ZWotkK9kxIxODXCXWTp
	0myXzgYkszLubPnI2c7H/+4phBoPQqjxWgkANgMCup3QkYBcBwbSyqqEbI8nv4WWf2MQ/N1ExYE
	6AU5AXlKnZ3XM3pqSh3XfKh1JYKg1ahi6tvSi4rNKJxPD6zZUhxDs8IaGHvEVEucO4VzXGc1kdh
	WkfqhrkJTHI9sedOUxRc7iiHy21PsK7F0Xpwbiq8osXkG9qETpwsQ8KN/5c2zpSw65mlTnDuq
X-Google-Smtp-Source: AGHT+IERy6bHNyPQYc6vhNgW+EwcyEcEdVXT80IqNzqwwqkceUiP0GUosARdB51ehMoaNIFf//OcvA==
X-Received: by 2002:a17:902:ccc4:b0:224:910:23f6 with SMTP id d9443c01a7336-23fb31675bfmr164192955ad.45.1753628661986;
        Sun, 27 Jul 2025 08:04:21 -0700 (PDT)
Received: from sidong.sidong.yang.office.furiosa.vpn ([175.195.128.78])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23ffdec96aesm15381965ad.165.2025.07.27.08.04.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jul 2025 08:04:21 -0700 (PDT)
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
Subject: [RFC PATCH v2 0/4] rust: miscdevice: abstraction for uring-cmd
Date: Sun, 27 Jul 2025 15:03:25 +0000
Message-ID: <20250727150329.27433-1-sidong.yang@furiosa.ai>
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

I received a email from kernel bot that `io_tw_state` is not FFI-safe.
It seems that the struct has no field how can I fix this?

Changelog:
v2:
* use pinned &mut for IoUringCmd
* add missing safety comments
* use write_volatile for read uring_cmd in sample

Sidong Yang (4):
  rust: bindings: add io_uring headers in bindings_helper.h
  rust: io_uring: introduce rust abstraction for io-uring cmd
  rust: miscdevice: add uring_cmd() for MiscDevice trait
  samples: rust: rust_misc_device: add uring_cmd example

 rust/bindings/bindings_helper.h  |   2 +
 rust/kernel/io_uring.rs          | 183 +++++++++++++++++++++++++++++++
 rust/kernel/lib.rs               |   1 +
 rust/kernel/miscdevice.rs        |  41 +++++++
 samples/rust/rust_misc_device.rs |  34 ++++++
 5 files changed, 261 insertions(+)
 create mode 100644 rust/kernel/io_uring.rs

-- 
2.43.0


