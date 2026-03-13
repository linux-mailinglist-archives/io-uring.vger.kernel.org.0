Return-Path: <io-uring+bounces-12663-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UMleBeoMtGlvfwAAu9opvQ
	(envelope-from <io-uring+bounces-12663-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 13 Mar 2026 14:11:06 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 99C1E2837D8
	for <lists+io-uring@lfdr.de>; Fri, 13 Mar 2026 14:11:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C6E233080C2E
	for <lists+io-uring@lfdr.de>; Fri, 13 Mar 2026 13:09:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D410C315785;
	Fri, 13 Mar 2026 13:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b="SNxnVjfd";
	dkim=permerror (0-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b="BvDhNvhv"
X-Original-To: io-uring@vger.kernel.org
Received: from devnull.danielhodges.dev (vps-2f6e086e.vps.ovh.us [135.148.138.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5749327B4F7;
	Fri, 13 Mar 2026 13:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=135.148.138.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773407393; cv=none; b=EzsRiA/W1Kcv3DZ/LFuKyehe3lGmztiljD0Czzr2Obd1nXe4wgi35k4spgUsFbq8AaXYU3RFbKhL0AXMIA+mnE4Kd2o0EyJhyf925iJgStI6/P8pp725tysDen+zAneCznCA83UC71ez+mZ1MpYJy9ZdoNHJbCH3isSeQBCtX00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773407393; c=relaxed/simple;
	bh=wGZJU8v1o3wJsUvfOkK73w+fSpnkq+M5KPbGjAGjodc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Vz9zsfHMGd8Zw2jEqnzEkwjXWRjp78nqU7N3H/Dsgp/JzI2AacnvXcM5jNk7edmEwsOGJGCtJThfDDXFhC8mO0UFQAdkQ1Xj4ERO0c/qcXiu3Gbk/Iq73LPjnDY7s9O0ebms/s8GkK9sa+jf8kQZbNHMfokgJ+pM9vdgkQi9WIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=danielhodges.dev; spf=pass smtp.mailfrom=danielhodges.dev; dkim=pass (2048-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b=SNxnVjfd; dkim=permerror (0-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b=BvDhNvhv; arc=none smtp.client-ip=135.148.138.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=danielhodges.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=danielhodges.dev
DKIM-Signature: v=1; a=rsa-sha256; s=202510r; d=danielhodges.dev; c=relaxed/relaxed;
	h=Message-ID:Date:Subject:To:From; t=1773407260; bh=LjzcCLrzGOIYXAecJBE7WEn
	SORmrXrbpjYe2iSWzT1Q=; b=SNxnVjfduRvwGqq1KS8bwjzaM+Ln+Wjbrzl3xQqBrHRMA6Jw3O
	iGY3exJYU9E5l6TnbZx9ordO+B1wcpKuZab6Qtr9nX8qmv1BZB/LxMPasMyUidnNZgLKF1vldtJ
	4Jw+oxE9t5S/Lm06NU47aJx0nWxDgLX8gvCyMeajh4X/vKH9meD6BKHG2PTI4JXoWIgXJcnGRem
	IY9XA1mBDVCgvgZCVc0k3gP6JhoCuc+ZhD+MUtsL8dbYZl1rzs46PrMqRbUyK6wqLNCULif2SYN
	N9n16N3aRe2xFNP0Tbl8P0vuP4c/mXu25Rgbuf0IHLSv8Ovkgmqb3QdxdyD6KjJ6WPw==;
DKIM-Signature: v=1; a=ed25519-sha256; s=202510e; d=danielhodges.dev; c=relaxed/relaxed;
	h=Message-ID:Date:Subject:To:From; t=1773407260; bh=LjzcCLrzGOIYXAecJBE7WEn
	SORmrXrbpjYe2iSWzT1Q=; b=BvDhNvhvOfwIvkgBIrxEF2gOsb5HhWzX2ytOfv6VCJVWKBV9ul
	TEHMqkSkqhNStw0hfJrTosfmSU8EbMEvnmCA==;
From: Daniel Hodges <git@danielhodges.dev>
To: Jens Axboe <axboe@kernel.dk>
Cc: Daniel Hodges <git@danielhodges.dev>,
	Pavel Begunkov <asml.silence@gmail.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/2] io_uring: add IPC channel infrastructure
Date: Fri, 13 Mar 2026 09:07:37 -0400
Message-ID: <20260313130739.23265-1-git@danielhodges.dev>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[danielhodges.dev,reject];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[danielhodges.dev:s=202510r,danielhodges.dev:s=202510e];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12663-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[danielhodges.dev,gmail.com,vger.kernel.org];
	DKIM_TRACE(0.00)[danielhodges.dev:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[git@danielhodges.dev,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[danielhodges.dev:dkim,danielhodges.dev:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 99C1E2837D8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

io_uring currently lacks a dedicated mechanism for efficient inter-process
communication. Applications needing low-latency IPC must use pipes, Unix
domain sockets, or hand-roll shared memory with manual synchronization --
none of which integrate with the io_uring completion model or offer
built-in fan-out semantics.

This series adds an IPC channel primitive to io_uring that provides:

  - Shared memory ring buffer for zero-copy-style message passing
  - Lock-free CAS-based producer (no mutex on the send hot path)
  - RCU-based subscriber lookup on send/recv paths
  - Three delivery modes:
      * Unicast: single consumer, shared consumer.head via cmpxchg
      * Broadcast: all subscribers receive every message via
        per-subscriber local_head tracking
      * Multicast: round-robin distribution across receivers with
        cached recv_count for O(1) target selection
  - Lazy broadcast consumer.head advancement (amortized O(N) scan
    every 16 messages instead of per-recv)
  - Channel-based design supporting multiple subscribers across
    processes via anonymous file + mmap
  - Permission model based on Unix file permissions (mode bits)
  - Four registration commands: CREATE, ATTACH, DETACH, DESTROY
  - Two new opcodes: IORING_OP_IPC_SEND and IORING_OP_IPC_RECV
  - Targeted unicast send via sqe->file_index for subscriber ID

Benchmark results (VM, 32 vCPUs, 32 GB RAM):

Point-to-point latency (1 sender, 1 receiver, ns/msg):

  Msg Size   pipe    unix sock  shm+eventfd  io_uring unicast
  --------   ----    ---------  -----------  ---------------
  64 B        212      436        222           632
  256 B       240      845        216           597
  1 KB        424      613        550           640
  4 KB        673    1,326        350           848
  16 KB     1,982    1,477      2,169         1,893
  32 KB     4,777    3,667      2,443         3,185

For point-to-point, io_uring IPC is within 1.5-2.5x of pipe/shm for
small messages due to the io_uring submission overhead. At 16-32 KB the
copy cost dominates and all mechanisms converge.

Broadcast to 16 receivers (ns/msg, sender-side):

  Msg Size    pipe     unix sock  shm+eventfd  io_uring bcast
  --------   ------   ---------  -----------  --------------
  64 B       28,550    32,504      5,970         5,674
  256 B      27,588    34,777      5,429         6,600
  1 KB       28,072    34,845      6,542         6,095
  4 KB       37,277    46,154     11,520         6,367
  16 KB      57,998    58,348     34,969         7,592
  32 KB      89,404    83,496     93,082         8,202

The shared-ring broadcast architecture is the key differentiator: at
16 receivers with 32 KB messages, io_uring broadcast is 10.9x faster
than pipe and 11.3x faster than shm+eventfd because data is written
once to the shared ring rather than copied N times.

Scaling from 1 to 16 receivers (64 B messages):

  Mechanism        1 recv   16 recv   Degradation
  ---------        ------   -------   -----------
  pipe               212    28,550       135x
  unix sock          436    32,504        75x
  shm+eventfd        222     5,970        27x
  io_uring bcast     651     5,674       8.7x
  io_uring mcast     569     1,406       2.5x

Multicast sender throughput (ns/msg):

  Msg Size   1 recv  2 recv  4 recv  8 recv  16 recv
  --------   ------  ------  ------  ------  -------
  64 B         569     557     726     916    1,406
  4 KB         825     763     829   1,395    1,630
  32 KB      3,067   3,107   3,218   3,576    4,415

Multicast scales nearly flat because the CAS producer only contends
with the shared consumer.head, not with individual receivers.

Daniel Hodges (2):
  io_uring: add high-performance IPC channel infrastructure
  selftests/ipc: Add io_uring IPC selftest

 MAINTAINERS                                |    1 +
 include/linux/io_uring_types.h             |    7 +
 include/uapi/linux/io_uring.h              |   74 ++
 io_uring/Kconfig                           |   14 +
 io_uring/Makefile                          |    1 +
 io_uring/io_uring.c                        |    6 +
 io_uring/ipc.c                             | 1002 ++++++++++++++++
 io_uring/ipc.h                             |  161 +++
 io_uring/opdef.c                           |   19 +
 io_uring/register.c                        |   25 +
 tools/testing/selftests/ipc/Makefile       |    2 +-
 tools/testing/selftests/ipc/io_uring_ipc.c | 1265 ++++++++++++++++++++
 12 files changed, 2576 insertions(+), 1 deletion(-)
 create mode 100644 io_uring/ipc.c
 create mode 100644 io_uring/ipc.h
 create mode 100644 tools/testing/selftests/ipc/io_uring_ipc.c

--
2.52.0


