Return-Path: <io-uring+bounces-11797-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id D702ED39869
	for <lists+io-uring@lfdr.de>; Sun, 18 Jan 2026 18:23:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5A13B3001FE1
	for <lists+io-uring@lfdr.de>; Sun, 18 Jan 2026 17:23:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47814204C36;
	Sun, 18 Jan 2026 17:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Vv4VfC9E"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A686A33B
	for <io-uring@vger.kernel.org>; Sun, 18 Jan 2026 17:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768757015; cv=none; b=jhM97IrjuMjUqDK77mAN2tFWZozKf6HTolaa2znA1Dc0ieh12fzOklU1+VSirJ6JIWoIbetfvSuzD7Q6AwVRcc6MAorvl7JR1YN07M/efUD7quTYce6iERZqmtqxgH8LQRlYpNbj81vQfyZRtZDXA6+e66NL8TZcFzfumpgOhds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768757015; c=relaxed/simple;
	bh=8OV3n9s0JLezleSqCwDGpiJZecRpNVluuTj5nSFqk/U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O18Db/yifATu/quuxJe3rZ1t8/VNKKH1jNypEmI467DC+x8l6hzfQB7roSoQXZEO4gQPS9EgpflJjqhxpnxuPPdx2k2cJBcvtQTjCkQc9XZq05eP3/jbaK20ithikuBCoG1yzBhpUyTBJwIV2IVr6PVhzn3qU0SZuTMvn3YmCZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Vv4VfC9E; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7cfd65ea639so2181840a34.0
        for <io-uring@vger.kernel.org>; Sun, 18 Jan 2026 09:23:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768757011; x=1769361811; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MvijkG0CamMU+qs3S88549BhZtfYWcSAyOrvThWUstU=;
        b=Vv4VfC9E260Ou+F/HSNzssCd1Dz1RJQcKFICIXfYQFTuDlEo42xfRG9Sjt3puwtceS
         eG5D7Llhu/a6P5PsZiWqWjfWcxterXUg1M8MCyrqR7iAHiqy1DQGLba07p5FUd2ZJOfE
         Ta9US4EGVCtKHe1oTlm+Q4ljs3ViFMX8XHfGJhIY0HIguWgr4ih8fIKNpAMshn4LKpvD
         3Ro/t6UYzSyJoxgU52saS8W6THvJ/ZnRkN7BVRJffZ9hhR9mK1ISBoC+ywcstm8Pf6JG
         kWMdvs/1BGxN0vIISGm210Fq959S4TIxw/v/DpF6diyBCGCP3LIoz3xgTXvFMdFvC/rm
         OK6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768757011; x=1769361811;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MvijkG0CamMU+qs3S88549BhZtfYWcSAyOrvThWUstU=;
        b=st8Mo6hwsX9M9JRx67WP+Xf7FJ3QOrsAG6SzEeP01uT+4JFWqXGeYfisa6zRylHUWy
         Cmsq9RAKzfBFGPFBH6q5LpK26lGLuRHB+HzQifPp1z1i903ifklq1CjC4Yu59s9YJzIV
         1Ku2fJy357f+GQFMwh5+pFox23OKceLT0IxKh0fxh8FNawUcrF6nmm86++Dt504mRHKR
         V6wzkP9f7QPCYMGHhJscLQjvn1HoyeymzXRd5BbL5fLZ/XHI4UyaeCaL9V8iFvjgkl6R
         kv1xN/DUxoeeyNvHLgYP1OH7d5l6MC0sQ0toOwG21zq1DFcDNfg4B6d39JytkOKF4XAF
         8s0Q==
X-Gm-Message-State: AOJu0YzkS2de+YwVNQeltysgme7+PZHfwN6kxfV27oRTa4o0SOaebrMM
	jm7OJf3ItlIRqnodLIXw/iwpI7oUrdokOnBN+KVVJ/oZQ3avvhOqtenqL8d7A2nTDfuGJk+B8wI
	+bopN
X-Gm-Gg: AY/fxX4Hd972wJCmhXnASfQQvcQXuJGzezITTrbRcmXuYWmz5CaJbVuXwhfJs8pOvxi
	aJgdZwYuLD0au0ig6f79DvgN6E41HnGY5C3B14TLCz/6gpU3oelkVBJYzaeMbgJQc1s3KSMYNWm
	p+G3P9DXTsE1mq3FGQld7lhKTfzHmuQFKpRBSt/RrMyJARaqcxwJ9gd7etVURrl8cWIRlZpgN0d
	43wNFtjdaQBgtqp4Om25ZMkNlPLFjwbcC1sXYwiCyU50FqpvjK3etCoZ8FidNfNYTYRMFmcSZOG
	71ZKeju5T+IvL/+gHZ6u6DhF1CU4aAh2payhe4S2H0nKk/UAlTsB0TEr397PWEWoF1einGMU5h4
	M+1f0q1Qcm0bAW9maqtzPBOWWJ1xdkNhmTPa+CWKJ/b6undQAuJHycatcfkpvyEBGFtA1Hvs9GG
	98nWIx0unXbfNIyH9oiBgawRat9Pe2Yr0AyoE2OWoQfiMrOjcLEhqFvqkB
X-Received: by 2002:a05:6830:7304:b0:7cf:d150:a245 with SMTP id 46e09a7af769-7cfded4e064mr3835312a34.5.1768757011283;
        Sun, 18 Jan 2026 09:23:31 -0800 (PST)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf101198sm5489558a34.13.2026.01.18.09.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jan 2026 09:23:30 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: brauner@kernel.org
Subject: [PATCHSET v5] Inherited restrictions and BPF filtering
Date: Sun, 18 Jan 2026 10:16:50 -0700
Message-ID: <20260118172328.1067592-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Followup to v4 here:

https://lore.kernel.org/io-uring/20260116224356.399361-1-axboe@kernel.dk/

Due to some feedback from Christian, ended up redoing the filter side of
this to use cBPF rather than eBPF. This provides better support for the
some of the intended use case of this, like containers, as eBPF cannot
be used unprivileged there. This obviously comes with a bit of pain on
the usability front, as you now need to write filters in cBPF bytecode.
I did keep the API such that eBPF filters can be added as well, but that
can be a separate patch. Since the BPF type is just a minor part of this
change, most of the code is exactly the same as before.

As before, filters can be registered with directly with a ring, or with
the calling task. Filters registered with a ring only affect that ring,
while filters registered with a task will affect any ring subsequently
created. Additionally, task filters are inherited across fork. For both
the original task and any of its children, once registered, only further
restrictions may be added. A forked child initially starts with a
reference to its parent table. If the parent makes changes to that
table, they will also affect the child. The exception being if the child
registers further filters - in that case, the filters table is COW'ed
and the reference is dropped to the parent table.

Kernel branch can be found here:

https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git/log/?h=io_uring-bpf-restrictions.2

and a liburing branch with support helpers and a fairly substantial test
case can be found here:

https://git.kernel.org/pub/scm/linux/kernel/git/axboe/liburing.git/log/?h=bpf-restrictions

 include/linux/io_uring.h                 |  14 +-
 include/linux/io_uring_types.h           |  13 +
 include/linux/sched.h                    |   1 +
 include/uapi/linux/io_uring.h            |  10 +
 include/uapi/linux/io_uring/bpf_filter.h |  54 +++
 io_uring/Kconfig                         |   5 +
 io_uring/Makefile                        |   1 +
 io_uring/bpf_filter.c                    | 430 +++++++++++++++++++++++
 io_uring/bpf_filter.h                    |  48 +++
 io_uring/io_uring.c                      |  48 +++
 io_uring/io_uring.h                      |   1 +
 io_uring/net.c                           |   9 +
 io_uring/net.h                           |   6 +
 io_uring/register.c                      |  76 ++++
 io_uring/tctx.c                          |  42 ++-
 kernel/fork.c                            |   5 +
 16 files changed, 753 insertions(+), 10 deletions(-)

Changes since v4
- Drop eBPF and switch to cBPF instead. This is a bit of a pain on the
  userspace side obviously, as you now have to write bytecode. But it's
  necessary for supporting some of the use cases we care about, like
  containers.
- Add ctx->bpf_filters cache to reduce dereferences needed to get to
  the filter table.
- Do fast "no filter exists for this opcode" check.
- Fix bug with dummy filter in iterating and running filters.
- Fix bug with ring inheriting task filters for classic filters.
- Move uapi headers to io_uring/bpf_filter.h
- Add Kconfig CONFIG_IO_URING_BPF symbol

-- 
Jens Axboe


