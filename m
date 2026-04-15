Return-Path: <io-uring+bounces-13043-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GF4SHbxV32l1RwAAu9opvQ
	(envelope-from <io-uring+bounces-13043-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 15 Apr 2026 11:09:16 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B92C340256F
	for <lists+io-uring@lfdr.de>; Wed, 15 Apr 2026 11:09:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E161B3030231
	for <lists+io-uring@lfdr.de>; Wed, 15 Apr 2026 09:09:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30E593264C8;
	Wed, 15 Apr 2026 09:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="E/xVt26T"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37C230C615
	for <io-uring@vger.kernel.org>; Wed, 15 Apr 2026 09:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776244153; cv=none; b=SEb0k+yCrbYDoErOWUh2BS/f35cQm7lHiQGxS5wOj86UuyQjrV8LsIHW2k0ODUc711hnFBFAL8ArueE6GNcGM24A2eDFsCEfVKAr06P00n/OiE7kY9HOCETOsMoQYoc5AFqFW0J6XneIe9Wt0I90vWK8ybU8IffW6OOaLla5YXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776244153; c=relaxed/simple;
	bh=4/Cmd5DWvW/xOqkRrHMWmFSn6gxUEPa5rFXuJZw2bfg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cW0lz+Tb12dr/l+7W69QADxTHb26qLqyxJ9IibMapX/9k2mNlogBbZU8Sx1vQqbXv6FSNUKjDWRKbNtbQr3yaD5CwF3Bb8hn/yRxmRnf0zZJdvcHHY4KdXEiaU9X3SmtCb/pl8YvUXU84yKGT8hWsBh+itS7U2uj2XC4yq012qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=E/xVt26T; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-82c70e4654eso2814590b3a.2
        for <io-uring@vger.kernel.org>; Wed, 15 Apr 2026 02:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1776244150; x=1776848950; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SUTDp5+Z1gK0rhP4BsT0z2CnEhQfWS+xsZHo8398kwo=;
        b=E/xVt26T9wz4qlxLGppWOIBmd/qPSM2fNFvjR95wGycgftfYNnrQPb3hD99Mk2m9Tj
         LtWeIOle6nhWrZj1mdK6tILA/CUXUUssAc7vWMFX/vfT12vPilxPg1fyKjT6BNMtIkjM
         w4Jmj+/TtSADkvm6hXRcrH9fcayuEl4tFMs+A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776244150; x=1776848950;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SUTDp5+Z1gK0rhP4BsT0z2CnEhQfWS+xsZHo8398kwo=;
        b=KtZ7GjXdI7XZsz2K/Mmm4FNiSdezH/LuKJJtrJ8mfYpqXXeNDdU7Zs+BoUl57o4507
         jbOYxMcw2sktG7gA7SK8r/4VEu3Heq3vsaCg+j0wmQse2WZxJ1tJJ8ZbIsPnB2uMrqYw
         8lWs0RqLPU/abQIVZt9XQebdqdSEjrfCMUBFiMfvILuiIJC5XZvno6dcQG2+baTMKOEk
         WjxONWGk2OZOvKhoAVUC4tRYnXvV4PcmozYnogp0Cq0ue0lGR4smOmgHpsVEKgxT7TBl
         GTHERPWeozFxWGkTdUlU/oHpK4Abh24V3uNA6s4buXfdBaXUtS2v+M9RovD6SLC2H2UN
         3qqg==
X-Forwarded-Encrypted: i=1; AFNElJ+2GbwTqZauokv+2PnG/psmwiuLRy2ztXYC0rNc6QFoiOGC9BxjSgVt7iJNOjyiY1HN797Pm89DlQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwgSpfZgHDY8+jzmL+gd3rMg1KvNua09f3/YVcIj6cuZLu40erS
	mBw6tviPUQm531N0b9/CqWF/SdQnqw8Fjx/xyWXqudK16rSB7dBQlRyU22wgFEx+flo=
X-Gm-Gg: AeBDieuexyTX7aD9qKJrgf5GfK9E6162trH2nwF9Imu8uMEPYyYtz+fyYj3hJyc7cez
	0+lXacvQglQg4w+eTKJ/bILVfzJUXFPksqiY4pckYRwVeA/cCbH+z7ZocpK4O787EbIphTlAKF5
	lN9Yk52aADfkW0F5iDGhudZzup6dpQBedjWH8ADQRxM8uOxM5HOPs5X04efFbYpUVUC5m7tErFu
	k4pDx30HrSNzRiBpIQnqXig6/nhtnDdV5vifu7cGnXn0B2diZuC5lof8iv1F/+DE6R2mkDrDk+M
	kRlMtbHR4xG6ll9S9qNxDTLdlmd54RBIetnRdVAA+vzQiaTTg6xubaXBZUZS+FUWKEbj5UsJbVx
	+ajWPL4KgqJQA9vp45eJlee7n04NKVbnRP10uvkfn1/n49craFCb7KA/qnLKyw/dqUfvJMquqDE
	b+nCbbCqkZwZCOXsSIkT/wb9djSd+BIaoo2uP+WpQMZiNaFJUiGE6CUDQFUAo=
X-Received: by 2002:a05:6a20:7486:b0:39c:c07:144a with SMTP id adf61e73a8af0-39fe3f8aad4mr23349665637.36.1776244150289;
        Wed, 15 Apr 2026 02:09:10 -0700 (PDT)
Received: from sidong.sidong.yang.office.furiosa.vpn ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7957ecee24sm1074619a12.1.2026.04.15.02.09.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 02:09:09 -0700 (PDT)
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
Subject: [PATCH v5 0/4] Rust io_uring command abstraction for miscdevice
Date: Wed, 15 Apr 2026 09:02:11 +0000
Message-ID: <20260415090851.4897-1-sidong.yang@furiosa.ai>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[furiosa.ai:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[furiosa.ai:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13043-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sidong.yang@furiosa.ai,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[furiosa.ai:dkim,furiosa.ai:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B92C340256F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

This series introduces Rust abstractions for io_uring commands
(`IORING_OP_URING_CMD`) and wires them up to the miscdevice framework,
allowing Rust drivers to handle io_uring passthrough commands.

The series is structured as follows:

1. Add io_uring C headers to Rust bindings.
2. Core io_uring Rust abstractions (IoUringCmd, QueuedIoUringCmd,
   IoUringSqe, UringCmdAction type-state pattern, IoUringTaskWork trait).
3. MiscDevice trait extension with uring_cmd callback.
4. Sample demonstrating async uring_cmd handling via workqueue.

The sample completes asynchronously using a workqueue combined with
`complete_in_task()`, which schedules task_work in the submitter's task
context before calling `io_uring_cmd_done()`.  This two-step approach
ensures that completion always runs in the correct context regardless
of where the driver decides to finish the operation.

Copy-based `read_pdu()`/`write_pdu()` are kept instead of returning
`&T`/`&mut T` references because the PDU is a `[u8; 32]` byte array
whose alignment may not satisfy `T`'s requirements.

Changes since v4:
- Dropped patch 2/5 (C-side zero-init of PDU in io_uring_cmd_prep);
  zero-initialisation is handled in the Rust miscdevice vtable wrapper
  instead. (Greg)
- Placed io_uring headers in alphabetical order in
  bindings_helper.h. (Miguel)
- Used `.cast()` / `core::ptr::from_ref()` instead of `as` pointer
  casts throughout. (Daniel)
- Fixed workqueue completion bug: calling `io_uring_cmd_done()` directly
  from a workqueue is unsafe because the worker does not hold uring_lock.
  Added `complete_in_task()` / `IoUringTaskWork` trait so drivers
  schedule task_work first, then call `done()` with the correct
  `TASK_WORK_ISSUE_FLAGS` from the submitter's context.
- Removed `issue_flags` forwarding from sample; the workqueue now calls
  `complete_in_task()` instead of `done()` directly.
- Improved all commit messages.

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

Sidong Yang (4):
  rust: bindings: add io_uring headers in bindings_helper.h
  rust: io_uring: introduce rust abstraction for io-uring cmd
  rust: miscdevice: Add `uring_cmd` support
  samples: rust: Add `uring_cmd` example to `rust_misc_device`

 rust/bindings/bindings_helper.h  |   2 +
 rust/helpers/helpers.c           |   1 +
 rust/helpers/io_uring.c          |  15 +
 rust/kernel/io_uring.rs          | 522 +++++++++++++++++++++++++++++++
 rust/kernel/lib.rs               |   1 +
 rust/kernel/miscdevice.rs        |  81 +++++
 samples/rust/rust_misc_device.rs |  62 +++-
 7 files changed, 683 insertions(+), 1 deletion(-)
 create mode 100644 rust/helpers/io_uring.c
 create mode 100644 rust/kernel/io_uring.rs

--
2.43.0


