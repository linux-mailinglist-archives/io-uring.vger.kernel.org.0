Return-Path: <io-uring+bounces-2110-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EA8BF8FD0B1
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 16:20:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C2852886AF
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 14:20:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 050AE19D88A;
	Wed,  5 Jun 2024 14:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="s0RHII/r"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE5F22318
	for <io-uring@vger.kernel.org>; Wed,  5 Jun 2024 14:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717597183; cv=none; b=EsIETH4U/BVPE9IkyWnJTuH21A1I2Ol/JcG7ZzrUbMEY3gMloyCoemLD8oVEkgk0Se+04csCkNfkTuBpawkg5YtYAfT/xtRkXCyWwWlR3cFDE+gHDqLrOfBDeGm+uECVnQNR3ByqAJGuYPcG7R5Vg9szG+mK3JUP2KsquH5ci0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717597183; c=relaxed/simple;
	bh=Aln2wSRQNEeAuTWcoIzNfcKMF7DXv1CAkDGH/8rDVN0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ivxuQRCQCUekJLMKaC+/fgUtF6VguoBj3O7JnpTJXskXuRbvHcMGQSyHSYQG3jBvbEauzzefN6VlMWYZpW4AQzsFBS3tI5Fq0v8f3oIQwqJc5cs56OKwVYCDZtirWZ/Ana10pk+mYTaPtdcLuVJMon7fTLIMYV+q0zwsywgZuHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=s0RHII/r; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-6f9391798eeso204318a34.0
        for <io-uring@vger.kernel.org>; Wed, 05 Jun 2024 07:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717597179; x=1718201979; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=O0EU9TUZasV/1Y0HxB3UPaVJDbPtR0EfY3oxR9CFXPk=;
        b=s0RHII/rHng03FtL0MhpBM2laD7zSZAF9AJyo1O5N/j/RWgW74o2TmRctK/Lps2XeI
         Ck7bR2S/zpmFOKCrksFBV0qSZJEQsAyou9duOxqyvipqilWm2cCooYnPvVjbwrOdpNdS
         FEpDxJQ61YGPU3RAFGuJba18v2m3veTev+XqyK0T9y8/2WPgz2KQG8csYnzAqyC1G5/v
         lWcI0RRQ/PEqOWk3JR8Mq/X1ZwlWTgaGa7jZD47VLQv+XPPb1KtjOcysFd2sJr3rnTem
         1no2wcM/cYpzENAi3WrtMxk2GtaeR7Ro7tk/ccCehidJNyDbPhKHQrNwMKPdZyuBqkmU
         LRPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717597179; x=1718201979;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O0EU9TUZasV/1Y0HxB3UPaVJDbPtR0EfY3oxR9CFXPk=;
        b=M9NfB0Jh6HM4jiRhImHUuPExwnGFb/esQ+69Ad3v2wCffIO7bSjbaOVDIn9TpY+cyW
         VoWNfw6p8OaZIbLGsJj3KO4KW0NC/ejW53sBZJb6c54eUwHo+2Y4LrJMWOjGedeAPS2i
         nRLpakandQ8OnEgt+ZlnTvyKXzwmjfX7aMIgkazSAoeY4eYxqFbltmtqu26xTpTO3hK5
         0LF3X+HBEKFnRUz5rlIsZ+2gisXLH1XdwcpOn9KZiqHDD5YG2IrW+lrCPgAMHEkIXZbM
         KnEUX/ko1g7kXOtRNal821BnleKR6gc83IoDH/i/6lPohldVPkXsBj6ZzPNuxywydLI0
         yKWQ==
X-Gm-Message-State: AOJu0Yw3vUf2qACiEE5yJ5BJGrjq53oRY0KFlkNfCkQA7W6LJH52R29w
	8Vb2SOas0zY/QApJ08B0OFUobTHe/RiFk710PJU5ZTcRCFcrExWgvrEuwM8/lpRdD8b6ZW8tdWG
	I
X-Google-Smtp-Source: AGHT+IG/apaZJVlhMrQkXrfKJ/i2zmzHEio3LhqQMHfFkrsYj/WFkxMYnKeDrrf98hTfhHQeFyZ6NA==
X-Received: by 2002:a05:6870:c6a2:b0:24f:cabc:4fa3 with SMTP id 586e51a60fabf-25121872124mr2996565fac.0.1717597179167;
        Wed, 05 Jun 2024 07:19:39 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-250853ca28esm4048918fac.55.2024.06.05.07.19.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jun 2024 07:19:38 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCHSET v3 0/9] Improve MSG_RING DEFER_TASKRUN performance
Date: Wed,  5 Jun 2024 07:51:08 -0600
Message-ID: <20240605141933.11975-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

For v1 and replies to that and tons of perf measurements, go here:

https://lore.kernel.org/io-uring/3d553205-0fe2-482e-8d4c-a4a1ad278893@kernel.dk/T/#m12f44c0a9ee40a59b0dcc226e22a0d031903aa73

and find v2 here:

https://lore.kernel.org/io-uring/20240530152822.535791-2-axboe@kernel.dk/

and you can find the git tree here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-msg_ring

Patches are based on top of current Linus -git, with the 6.10 and 6.11
pending io_uring changes pulled in.

tldr is that this series greatly improves both latency, overhead, and
throughput of sending messages to other rings. It's done by using the
CQE overflow framework rather than attempting to local remote rings,
which can potentially cause spurious -EAGAIN and io-wq usage. Outside
of that, it also unifies how message posting is done, ending up with a
single method across target ring types.

Some select performance results:

Sender using 10 usec delay, sending ~100K messages per second:

Pre-patches:

Latencies for: Sender (msg=131950)
    percentiles (nsec):
     |  1.0000th=[ 1896],  5.0000th=[ 2064], 10.0000th=[ 2096],
     | 20.0000th=[ 2192], 30.0000th=[ 2352], 40.0000th=[ 2480],
     | 50.0000th=[ 2544], 60.0000th=[ 2608], 70.0000th=[ 2896],
     | 80.0000th=[ 2992], 90.0000th=[ 3376], 95.0000th=[ 3472],
     | 99.0000th=[ 3568], 99.5000th=[ 3728], 99.9000th=[ 6880],
     | 99.9500th=[14656], 99.9900th=[42752]
Latencies for: Receiver (msg=131950)
    percentiles (nsec):
     |  1.0000th=[ 1160],  5.0000th=[ 1288], 10.0000th=[ 1336],
     | 20.0000th=[ 1384], 30.0000th=[ 1448], 40.0000th=[ 1624],
     | 50.0000th=[ 1688], 60.0000th=[ 1736], 70.0000th=[ 1768],
     | 80.0000th=[ 1848], 90.0000th=[ 2256], 95.0000th=[ 2320],
     | 99.0000th=[ 2416], 99.5000th=[ 2480], 99.9000th=[ 3184],
     | 99.9500th=[14400], 99.9900th=[18304]
Expected messages: 299882

and with the patches:

Latencies for: Sender (msg=247931)
    percentiles (nsec):
     |  1.0000th=[  181],  5.0000th=[  191], 10.0000th=[  201],
     | 20.0000th=[  211], 30.0000th=[  231], 40.0000th=[  262],
     | 50.0000th=[  290], 60.0000th=[  322], 70.0000th=[  390],
     | 80.0000th=[  482], 90.0000th=[  748], 95.0000th=[  892],
     | 99.0000th=[ 1032], 99.5000th=[ 1096], 99.9000th=[ 1336],
     | 99.9500th=[ 1512], 99.9900th=[ 1992]
Latencies for: Receiver (msg=247931)
    percentiles (nsec):
     |  1.0000th=[  350],  5.0000th=[  382], 10.0000th=[  410],
     | 20.0000th=[  482], 30.0000th=[  572], 40.0000th=[  652],
     | 50.0000th=[  764], 60.0000th=[  860], 70.0000th=[ 1080],
     | 80.0000th=[ 1480], 90.0000th=[ 1768], 95.0000th=[ 1896],
     | 99.0000th=[ 2448], 99.5000th=[ 2576], 99.9000th=[ 3184],
     | 99.9500th=[ 3792], 99.9900th=[17280]
Expected messages: 299926

which is a ~8.7x improvement for 50th latency percentile for the sender,
and ~3.5x for the 99th percentile, and a ~2.2x receiver side improvement
for the 50th percentile. Higher percentiels for the receiver are pretty
similar, but note that this is accomplished with the throughput being
almost twice that of before (~248K messages over 3 seconds vs ~132K
before).

Using a 20 usec message delay, targeting 50K messages per second,
the latency picture is close to the same as above. However, pre patches
we get ~110K messages and after we get ~142K messages. Pre patches is
~37% off the target rate, with the patches we're within 5% of the
target.

One interesting use case for message passing is sending work items
between rings. For example, you can have a ring that accepts connections
and then passes them to worker threads that have their own ring. Or you
can have threads that receive data and needs to pass a work item for
processing to another thread. Normally that would be done with some kind
of queue with serialization, and then a remote wakeup with eg epoll on
the other end and using eventfd. That isn't very efficient. With message
passing, you can simply hand over the work item rather than need to
manage both a queue and a wakeup mechanism in userspace.

 include/linux/io_uring_types.h |   8 ++
 io_uring/io_uring.c            |  33 ++----
 io_uring/io_uring.h            |  44 +++++++
 io_uring/msg_ring.c            | 211 +++++++++++++++++----------------
 io_uring/msg_ring.h            |   3 +
 5 files changed, 176 insertions(+), 123 deletions(-)

Changes since v2:
- Add wakeup batching for MSG_RING with DEFER_TASKRUN by refactoring
  the helpers that we use for local task_work.
- Drop patch splitting fd installing into a separate helper, as we just
  remove it at the end anyway when the old MSG_RING posting code is
  removed.
- Little cleanups

-- 
Jens Axboe


