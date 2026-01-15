Return-Path: <io-uring+bounces-11731-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7306DD25E09
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 17:53:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D1EC23025FAE
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 16:52:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9102396B75;
	Thu, 15 Jan 2026 16:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="3Owe1dNT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097D042049
	for <io-uring@vger.kernel.org>; Thu, 15 Jan 2026 16:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768495977; cv=none; b=DQ7NJ+L329FmNdOzGQCT/HBqzDS/aZjYpXHiN9OknMOxadi3rK2zS5PbDI3hwttp3BkGZIbhNff+LL/2vtEQfAnB3XjKvp1W5dbd7G2AUpND1gqRhXxVGL1Mx6wBJ8q0oua3uPIz9pmaULo/nIQ0ozVLlH4FdpHAMQ0TPphCuL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768495977; c=relaxed/simple;
	bh=g3cma3+sLQgnbLA2UNKVXbfOpOW7Ura7QRTQ83SZ0Kg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Chmf2Osx3eD07NAqkbd4+K52TZwSzRuzVszCUfft4dNiaS5BHCaotnN4v4whh0o6M6sQcO4oVVvSZ+TOPvMCdTUGWG2z9j7FLgmdfpFbdNhwLdcIElBbHADELINWFM3dppr4P5xv86jVPZ/p5dglnTCSuM5ROdObNQgLOI/31NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=3Owe1dNT; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7cfd5d34817so693066a34.1
        for <io-uring@vger.kernel.org>; Thu, 15 Jan 2026 08:52:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768495973; x=1769100773; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=NnhoBaXoAHlu6xNi+MKPzGZPrelA6LdUEuPWOYiaqC4=;
        b=3Owe1dNTxOduSFlQihE0UrytSwTehVGjCtjDgudX824YbN2e6f6FU3BK751gcplWSn
         G6EpcBXw0ZRHukN4R7sLoVcerUVP3IF55l+Qd8xh00G1Ax9FKQ26iuJRFdbsGa7Jefwm
         435/YgXeSb3BtRabm+YkMAuuyTnk9eYYKBJGJtMYZ0P0GgCIP7v38snOJw1FBHa0MAQQ
         x/zvKKw47cBhMvob6T+1s0X/glUYuwQykgryYWMZMicy7zLjfTSg9/3ZVkRb7RLrXojU
         vsRohRz6Ji0ydn1zJB1Qo6583ib0D+7z9QFDa61xi7tS5dDGdaMBi/rO9VJT6AaG70IQ
         nhmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768495973; x=1769100773;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NnhoBaXoAHlu6xNi+MKPzGZPrelA6LdUEuPWOYiaqC4=;
        b=bhe4MR8MeIxd7sOjOiafy67D5bqrPyltC5PvucLQVG9TrSGti3CDlKVo51YW4rQSDq
         rbawHe75WSWYACtGWON/QuyL0wUkLwntBr5shcGS4Fo9HK2iVn7aVVk7aUxNEK5odWWT
         aF+Gon5CRAy4MaKGbbDBaTWQSER0aEzyzlMY4WXYRJAvkJT2TYqjW6KJxn16whvZOs7f
         dAR6ntXaqSYxcJXFJmBFZn5PzNhUg0qtRDQgSIy4O96PYroIGL73qOQGRkZoLGpHl3Xj
         umja0Gy9wfUWEV1Lc7OlbTB3J2voqBmOczvc1zeiOyfyr3Mbfvd45VAGRhFWrmuhwpWd
         Y+gg==
X-Gm-Message-State: AOJu0YxHhlg9LLRxDhiVydama9ftjv33ZrzRmYY9MyCcmgf+iJZuNdCL
	ApKgfmfvbBskGdCp//lPl6JLdOFDLc86dE0cTouRWAAsC6E7twSTnukE402tsROfjJs7CjvwGp7
	nZnyR
X-Gm-Gg: AY/fxX5G9YnSM6kPTEdiGFSo7UQvk7KS0C/ncAqFh4AJF5MsmGEsTBmN9sHIRBjZmxl
	6R7zryuespqhHG4iWitJDl54L7d/OtrqMg1s4fxzo/1UiupVPELY+L4N8SGPNuW22wJKxHhTVRm
	eE7k3u9tuKneoTjOoCRbif9XxmJxI2Mf+J2i3gdUw71XAgg1Xo4uWwip9ozp//mUjC4qjko9TkF
	RiAU4Spb6C+ToFlhYaQRG29aQs1VIjv7melKH183Fl4y8UADH8t/NRYKSog3I1FXAe17llGzExh
	4iDJhxf7rQ1erK/l6tArcYNxhd5hfoiaUF2Yu4mv+S5UR+sIZ6tJhMokZLeTRejyKNXH+qqjY+X
	crIeU9bf1/6tnpsd+0CuHStLpQyBlZI0U5XOx2cNj0N2FQltEjW//VlRd+WoL4smmLZyGuA==
X-Received: by 2002:a05:6830:498d:b0:7c7:7fc7:8b9d with SMTP id 46e09a7af769-7cfdee19b62mr63675a34.18.1768495973458;
        Thu, 15 Jan 2026 08:52:53 -0800 (PST)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf0db2ddsm14369a34.3.2026.01.15.08.52.52
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 08:52:52 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET RFC v3] Inherited restrictions and BPF filtering
Date: Thu, 15 Jan 2026 09:36:31 -0700
Message-ID: <20260115165244.1037465-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Followup to v2 here:

https://lore.kernel.org/io-uring/20260109185155.88150-1-axboe@kernel.dk/

While this is a followup, it takes a different approach to the problem.
What remains is task inheritance - if a set of restrictions are
registered with a task, any children will get it too.

What's new is adding basic support for BPF filters, so that anything
can be filtered. You can add filters for each opcode, and several of
them as well. As the filtering is done after the prep phase, it's even
possible to support filtering based on user structs that are copied in
to the kernel. For now, only IORING_OP_SOCKET is done, and allows
filtering on domain/type/protocol. This is done as an example. A sample
filter for that could look like:

SEC("io_uring_filter")
int socket_filter(struct io_uring_bpf_ctx *ctx)
{
	/* Only allow AF_INET and AF_INET6 */
	if (ctx->socket.family != AF_INET && ctx->socket.family != AF_INET6)
		return 0;  /* Reject */

	/* Only allow SOCK_STREAM (TCP) */
	if (ctx->socket.type != SOCK_STREAM)
		return 0;  /* Reject */

	/* Only allow IPPROTO_TCP or default (0) */
	if (ctx->socket.protocol != IPPROTO_TCP && ctx->socket.protocol != 0)
		return 0;  /* Reject */

	return 1; /* Accept */
}

to restrict certain families, types, or protocols.

Just supports SQE opcodes for this kind of filtering, but easily
extendable to cover REGISTER opcodes as well, including arguments.

Sending this out as an RFC for comments. I think this provides most of
the functionality needed to filter basically anything. There's still
some rough edges here, notably the BPF support, as I really don't know
what I'm doing there. But it works for testing, at least... I don't have
a liburing branch for this just yet, let me know if you want some
test/sample code and I'll be happy to toss it over the wall. I'll add a
liburing branch over the weekend for easier experimentation.

Sample based on the above filter:

axboe@m2max-kvm ~> ./io_uring_bpf_loader io_uring_bpf_filter.c.bpf.o
io_uring BPF Socket Filter Test (C-based)
==========================================

io_uring initialized
BPF program loaded successfully from io_uring_bpf_filter.c.bpf.o, fd=4
BPF filter registered for opcode 45

Running tests...

Testing AF_INET TCP (explicit): PASSED (fd=5)
Testing AF_INET TCP (default): PASSED (fd=5)
Testing AF_INET6 TCP (explicit): PASSED (fd=5)
Testing AF_INET6 TCP (default): PASSED (fd=5)
Testing AF_INET UDP: PASSED (correctly rejected)
Testing AF_INET RAW: PASSED (correctly rejected)
Testing AF_UNIX: PASSED (correctly rejected)
Testing AF_INET TCP socket with UDP proto: PASSED (correctly rejected)

or running t/io_uring with IORING_OP_NOP and a filter set. This filter
just allows the opcode, but it's still run on each NOP issued:

axboe@m2max-kvm ~/g/fio (master)> sudo taskset -c 0 t/io_uring -N1 -n1 -E ~/noop_filter.bpf.c.o -B0 -F0 trim.json
submitter=0, tid=2287, file=trim.json, nfiles=1, node=-1
BPF program loaded successfully from /home/axboe/noop_filter.bpf.c.o, fd=5
BPF filter registered for opcode 0
polled=1, fixedbufs=0, register_files=0, buffered=0, QD=128
Engine=io_uring, sq_ring=128, cq_ring=128
IOPS=13.89M, IOS/call=32/32
IOPS=13.90M, IOS/call=32/32
[...]

Comments welcome! Kernel branch can be found here:

https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git/log/?h=io_uring-bpf-restrictions

and sits on top of for-7.0/io_uring

 include/linux/bpf.h            |   1 +
 include/linux/bpf_types.h      |   4 +
 include/linux/io_uring.h       |   2 +-
 include/linux/io_uring_types.h |  20 +++-
 include/linux/sched.h          |   1 +
 include/uapi/linux/bpf.h       |   1 +
 include/uapi/linux/io_uring.h  |  46 +++++++
 io_uring/Makefile              |   1 +
 io_uring/bpf_filter.c          | 212 +++++++++++++++++++++++++++++++++
 io_uring/bpf_filter.h          |  41 +++++++
 io_uring/io_uring.c            |  33 ++++-
 io_uring/net.c                 |   9 ++
 io_uring/net.h                 |   5 +
 io_uring/register.c            | 133 +++++++++++++++++++--
 io_uring/register.h            |   2 +
 io_uring/tctx.c                |  26 ++--
 kernel/bpf/syscall.c           |   9 ++
 kernel/fork.c                  |   4 +
 18 files changed, 527 insertions(+), 23 deletions(-)

-- 
Jens Axboe


