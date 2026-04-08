Return-Path: <io-uring+bounces-12993-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uH0CO49f1mkfEwgAu9opvQ
	(envelope-from <io-uring+bounces-12993-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 16:00:47 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 5202A3BD4ED
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 16:00:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7235C30041F3
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2026 14:00:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AC4112FF69;
	Wed,  8 Apr 2026 14:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="kpgBy20e"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BD82EBDDE
	for <io-uring@vger.kernel.org>; Wed,  8 Apr 2026 14:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775656844; cv=none; b=o6OGatszqeb3DhSnOWhGdGtRis4WZ7sORTJkGNtcHkcD/NO/qRVfoTJ380NCFhF7ogSL8c9Vqk1HK4H5/jv3wDnVIN7JSU0hA3vYpeQNhLA3X26cFG47Axguzp9GC9qkSNSCrlY+k8vv4KU6Em+UHVE94xR/QDhnPhpkOLOAbso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775656844; c=relaxed/simple;
	bh=r652sSnwH2ZU7kpoja/rc5iCFl8wHAEjiyXayjlGerc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mVxFxPuQ3jZdgg2S+J3ERkUsICvaj/Y1OFLisA7gizuTqvWam9hrVvblWM89Tvnp2fTGXD/1U7Qk9hX4UlDcwCbxz2Rpx967mwTUwU0oSo6CIyIVBuwGQiCI7LIwJUV0NXzbGD05TO2aQRHtIftxByldmUyPD4LiJ3BLj/uN2+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=kpgBy20e; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2b24fdac394so60843045ad.3
        for <io-uring@vger.kernel.org>; Wed, 08 Apr 2026 07:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1775656842; x=1776261642; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ok/+iY3+IvQIxI5ArkrEJvrXI2YUfkN2o45pU0fC2d4=;
        b=kpgBy20eB4iDFUcPBfFE4b1zdS5sbShY2SwEFhrzL3tSYmlXicfCBLM7+1bTbIq+BE
         K/jtnNjz/h6ETlI+5LUy7EDUdxREKWhiIVu9CRbRa/UfSik4PEqkYx43jNMosi0FiEyA
         /zMSV3oim+UXc2+p/z8mBbkI3ACpXfuyCuY74=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775656842; x=1776261642;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ok/+iY3+IvQIxI5ArkrEJvrXI2YUfkN2o45pU0fC2d4=;
        b=YDEG87zTO7BEelwg20KLP7fitIzBKSPpO7a8vmAvLRE9gSl04XruXEo5LEYK9uBtrB
         Xy/foR9sqKTCqrVHnS6cN0kawRcvXUGuh2CeyULxSIm3Vz0+G2DWJnTP5a9HZitdtth6
         B6x4nQC822bnV90hKdeOQmWYuySVuOo/Bb4N6hFajKRtzHec2CR1UjLRv73WohONpKPb
         FA8icj15zbcI42yu2/qa/UnZh4fpQf09Ff7kr4CyG9AzjhFdMc+8bRVjGhlYhG8avv5A
         HwIxnaEivKO31IniMlIZedzOfCPVp1u426zqtxnhA15u4dHsfnMrjh5Sh+eFpgcB3VUf
         CjNg==
X-Forwarded-Encrypted: i=1; AJvYcCXjYNyCjCv7Hh3dqv6Vo8V7Vsc1VttnklJ+XJdE4mENxSk3eQdrOCw+mAzOwHyapaX0eD5ukXVmEw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzGmWURcJX+z51RCeLRlEmMZ7eraEtTkNdL3UkhqKMYMzJjeXtI
	5ADkqEgjMp5kZJZWRNZqAJgGm4G2au2Xg8FShHzJ1hVl+sflMMtrl3ocWsks1P2pQQA=
X-Gm-Gg: AeBDiesUaFrVzaS8yqj0W160ld/qT4uABf6J6OUhRvhHHXL7nEfJ0Ey4mzYub+7Lc+y
	4N7MowuoVnXdBHar31M4UYbID/jfNmFvmwj3ktgf483oxI2E1D9rTBvYqs6XkgJIzSslY69b5LD
	iR4w+QF9v6thNyIdDmFFy3sIZTBhWa9ChK6x6QSSR6arf5+RFiQy5Bhn8PUzI/RDnkqc4y5/kSH
	f0clMEdfvqjZTSvVm1zFWRUSOcnj6drJfi7fgLs98wbB0KA/+b1JVU4eJur9ZdLjRaZwNeKqP2W
	XyFy9xDRVcm/5+ztvvrfKcbheEOcfteFIKF1umwkt84g5CHvq1tlcT+YWLrrNa045qe6leNF4Zd
	rJ/bnGD5on/OLEY4jRIrH/PgXoJNcPD/AOjGwgi13hlo3O9aJ3nlDv7C8JSB5WYvKilh3D6yH/w
	n3pCvIgY93PyuMe7/18YfNr1RD4lHXFVESVHgVCcUr06mn5LfRvPEm8H3xswo=
X-Received: by 2002:a17:903:2c03:b0:2b2:ac6f:f87 with SMTP id d9443c01a7336-2b2ac6f1261mr96625335ad.44.1775656842107;
        Wed, 08 Apr 2026 07:00:42 -0700 (PDT)
Received: from sidong.sidong.yang.office.furiosa.vpn ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2747612b7sm204465145ad.23.2026.04.08.07.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 07:00:41 -0700 (PDT)
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
Subject: [PATCH v4 0/5] Rust io_uring command abstraction for miscdevice
Date: Wed,  8 Apr 2026 13:59:57 +0000
Message-ID: <20260408140007.8401-1-sidong.yang@furiosa.ai>
X-Mailer: git-send-email 2.43.0
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[furiosa.ai:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[furiosa.ai:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12993-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sidong.yang@furiosa.ai,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,furiosa.ai:dkim,furiosa.ai:mid]
X-Rspamd-Queue-Id: 5202A3BD4ED
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

This series introduces Rust abstractions for io_uring commands
(`IORING_OP_URING_CMD`) and wires them up to the miscdevice framework,
allowing Rust drivers to handle io_uring passthrough commands.

The series is structured as follows:

1. Add io_uring C headers to Rust bindings.
2. Zero-init pdu in io_uring_cmd_prep() to avoid UB from stale data.
3. Core io_uring Rust abstractions (IoUringCmd, QueuedIoUringCmd,
   IoUringSqe, UringCmdAction type-state pattern).
4. MiscDevice trait extension with uring_cmd callback.
5. Sample demonstrating async uring_cmd handling via workqueue.

The sample completes asynchronously using a workqueue rather than
`io_uring_cmd_complete_in_task()`.  The latter is primarily needed
when completion originates from IRQ/softirq context (e.g. NVMe),
whereas workqueue workers already run in process context and can
safely call `io_uring_cmd_done()` directly.  A Rust binding for
`complete_in_task` can be added in a follow-up series.

Copy-based `read_pdu()`/`write_pdu()` are kept instead of returning
`&T`/`&mut T` references because the PDU is a `[u8; 32]` byte array
whose alignment may not satisfy `T`'s requirements.

Changes since v3:
- read_pdu(): replaced MaybeUninit + copy_nonoverlapping(c_void) with
  read_unaligned (Caleb, Benno).
- write_pdu(): fixed c_void cast to u8 in copy_nonoverlapping (Benno).
- IoUringSqe::opcode(): use read_volatile for SQE field access (Caleb).
- IoUringSqe::cmd_data(): removed unnecessary runtime opcode check;
  safety is guaranteed by construction since IoUringSqe can only be
  obtained from IoUringCmd::sqe() inside a uring_cmd callback (Caleb).
- Removed unused mut in sample WorkItem::run() (compiler warning).

Changes since v2:
- Adopted type-state pattern for IoUringCmd (IoUringCmd -> QueuedIoUringCmd)
  to enforce correct completion flow at compile time.
- UringCmdAction enum with Complete/Queued variants prevents returning
  Queued without holding a QueuedIoUringCmd handle.
- Fixed error code handling (use proper kernel error types).
- Suppressed unused result warning with `let _ = ...enqueue(work)`.

Sidong Yang (5):
  rust: bindings: add io_uring headers in bindings_helper.h
  io_uring/cmd: zero-init pdu in io_uring_cmd_prep() to avoid UB
  rust: io_uring: introduce rust abstraction for io-uring cmd
  rust: miscdevice: Add `uring_cmd` support
  samples: rust: Add `uring_cmd` example to `rust_misc_device`

 io_uring/uring_cmd.c             |   1 +
 rust/bindings/bindings_helper.h  |   2 +
 rust/helpers/helpers.c           |   1 +
 rust/helpers/io_uring.c          |   9 +
 rust/kernel/io_uring.rs          | 457 +++++++++++++++++++++++++++++++
 rust/kernel/lib.rs               |   1 +
 rust/kernel/miscdevice.rs        |  79 ++++++
 samples/rust/rust_misc_device.rs |  53 +++-
 8 files changed, 602 insertions(+), 1 deletion(-)
 create mode 100644 rust/helpers/io_uring.c
 create mode 100644 rust/kernel/io_uring.rs

-- 
2.43.0


