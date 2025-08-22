Return-Path: <io-uring+bounces-9248-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E612B318AE
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 15:02:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C2B0C1D250B5
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 12:59:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A95C2FDC3C;
	Fri, 22 Aug 2025 12:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="ZzQQgW7o"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30F42FCBF8
	for <io-uring@vger.kernel.org>; Fri, 22 Aug 2025 12:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755867396; cv=none; b=WSbNBF2rwIU9fXF0QJcIZc17OvbLWe9WDH5lssf7FsNYkNWmvQ+215G4E3SYQsxEoi2St8EK1zTJmhCNdeOBH0JRvwrB59Ccv8gW4Xxn5HXGwGGsNUtf30BK7P+eOGO1VMGCA6Vc9p0HMtrQRz4MS1PUqfqfHAUpK5KJoOR3zo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755867396; c=relaxed/simple;
	bh=1nMyaUUKEGhRekyXqu7nR9wX+y2S3pEaBQ1AynCB5Zk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BNlAUGxLGnvK7nfi8K5+xkqB08EL7akZQdjcoiAg3zt2W76vZnvqpjINku+G98IPQ+Ry2W8M9u87LqjG7W/duRjMsSdxxsbV5pEXCxv+MwgC3FF2/KlpVvorvzFlnOiIr1j/Si3hOsqvaFDeFCEdpksdUS+t0CMmpMDDoSgPyoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=ZzQQgW7o; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-76e92b3ded3so1051673b3a.2
        for <io-uring@vger.kernel.org>; Fri, 22 Aug 2025 05:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1755867394; x=1756472194; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3ulg0un0kO+mVAmR2axpKOfpFutSEzipFHqPMKIsEvs=;
        b=ZzQQgW7oQPnYixcBvC2h4bSfNcIR6EmiPzhx2M/88XBXHwz1nLDIPwkzO1fIkGEJRM
         hUk0+E49Ar3BdBbWfxZmANP7xzqjvYWT5b10Jd9aIwknhC7bEgZ8Ap1lT9wZ1tzZTudk
         eaLYji/nzEcXMqRqyJ3MmtNbPkfxWg4q1509g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755867394; x=1756472194;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3ulg0un0kO+mVAmR2axpKOfpFutSEzipFHqPMKIsEvs=;
        b=bs5/gctBbJ3HxO32nEtE5kSTi9dRIrCZDMi+QZ7sWLKeVViyh89ZhQT+eaICqz2nlI
         IVaL0ihqbop8SPvzLHc8YoJq5JgaUtl/1lHQuEIuOGG8XXWLZaCmlsoBaTdw/ouDvDwc
         yCMoUfJZzgm7T4G5IEgZq0SKRjxCnz8uqwuChM+GifdKHmw7k9CVdcT2W+Q8Gul9ly2E
         wQK+89yXZgg520izzkxvtyiQ5tRxxkISHZHUrlE8RdsX298dUrc8/yCcvwMAsOTAH96R
         pi2ZM8+WQISWePK9ut1o7p7ezKgcB/vYgrDIK5FOHKB4KvbzZP31LiXnbRX5089W2eM5
         LsjQ==
X-Forwarded-Encrypted: i=1; AJvYcCW7QKI7dQOylzBEYWeKkAEflRZRSBswjb3KC31dUxjKKkiwHCF9+RZmM8Y7dunyqeUi+tLje588oQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yws5t7o9/vNhISOcbo/KSZCJsikBzQOMXskRrkZYyevvDjC0nlq
	GgY3U2nBvq9ZSwrSqbRyT+NQnPhJdCj7t2iSUQoUfgvyxOcKg4Lo+cH081j+PMJtvGE=
X-Gm-Gg: ASbGncsKkgQmGSs7gUPUYNuGW4pETmYW807NJmU5Pom74E3kH+WiPl1zJ0nzPt+0XpP
	xRvCWGdMgtB7tTg4nhFIqrpIoJMbp2nDnTsVZ+H/4MbgbDKCiwA6P8eNIPsqyfvcXPoK+qtDUE8
	Fd8FcfoH9gs5KfXUUWigkjIyt7G6ftL5bjgTi9bxufT0oT70S3zdG8uidJ9/Hh770iGBdxbL3Xz
	UYiOh3Bc8wTEQfUE3RnGJB0y82tye64X+foS7SsqiaI/XwlCaDT3zDB3pdnXXIXW+nAscmAXUHB
	4Aw8WlPL3umJUot43n3//I8FjNr0JlWi1OpI+1SMa1O80MQfP+4YSbcQNzSWXLHmsVGHRbjlZkP
	MdyvSkGnqxvlX9XDDytSUebndZ2+EE1px8K/oCGGBJ+AdtO8csT9I9b5wA0AE+vZbxJ91QMBW
X-Google-Smtp-Source: AGHT+IEp+IhiJ5Y2qqThOY6Kgaz/N52FJgbWJaI5kfueM3u9gCmUlUWDGA1cE7aiJXWfaowDUnBfRg==
X-Received: by 2002:a05:6a21:33a2:b0:23f:3f96:ea1d with SMTP id adf61e73a8af0-24340d77b55mr4754737637.29.1755867394083;
        Fri, 22 Aug 2025 05:56:34 -0700 (PDT)
Received: from sidong.sidong.yang.office.furiosa.vpn ([175.195.128.78])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b4764003537sm7194544a12.25.2025.08.22.05.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Aug 2025 05:56:33 -0700 (PDT)
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
Subject: [RFC PATCH v3 0/5] rust: miscdevice: abstraction for uring_cmd
Date: Fri, 22 Aug 2025 12:55:50 +0000
Message-ID: <20250822125555.8620-1-sidong.yang@furiosa.ai>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series implements the groundwork for using io-uring cmd
interface in rust miscdevice.

 1. Io-uring headers for bindings
    We needs additional headers for implementing rust abstraction.

 2. zero-init pdu in io_uring_cmd
    We need to initialize pdu for avoiding UB when reading pdu in rust.

 3. Core abstractions
    Provides 2 core struct for abstraction. One is for io_uring_cmd and
    another is for io_uring_sqe.

 4. Method for MiscDevice
    MiscDevice has some method for `file_operations`. This patch adds a
    method `uring_cmd` which could be used in miscdevice driver.

 5. uring_cmd interface for MiscDevice sample
    Added sample code for using new interface for `MiscDevice::uring_cmd()`

Together, these 5 patches.

 - io-uring headers for bindings
 - zero-init pdu in io_uring_cmd
 - abstraction types for io-uring interface
 - add uring_cmd method for miscdevice
 - sample that implements uring_cmd method

Changelog:
v2:
* use pinned &mut for IoUringCmd
* add missing safety comments
* use write_volatile for read uring_cmd in sample

v3:
* fixes various comments including safety related ones.
* zero-init pdu in io_uring_cmd
* use `read_pdu`/`write_pdu` with `AsBytes`/`FromBytes` for pdu
* `IoUringSqe::cmd_data` checkes opcode and returns `FromBytes`
* use `_IOR`/`_IOW` macros for cmd_op in sample

Sidong Yang (5):
  rust: bindings: add io_uring headers in bindings_helper.h
  io_uring/cmd: zero-init pdu in io_uring_cmd_prep() to avoid UB
  rust: io_uring: introduce rust abstraction for io-uring cmd
  rust: miscdevice: Add `uring_cmd` support
  samples: rust: Add `uring_cmd` example to `rust_misc_device`

 io_uring/uring_cmd.c             |   1 +
 rust/bindings/bindings_helper.h  |   2 +
 rust/kernel/io_uring.rs          | 306 +++++++++++++++++++++++++++++++
 rust/kernel/lib.rs               |   1 +
 rust/kernel/miscdevice.rs        |  53 +++++-
 samples/rust/rust_misc_device.rs |  27 +++
 6 files changed, 389 insertions(+), 1 deletion(-)
 create mode 100644 rust/kernel/io_uring.rs

-- 
2.43.0


