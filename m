Return-Path: <io-uring+bounces-2255-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E8DF690DC00
	for <lists+io-uring@lfdr.de>; Tue, 18 Jun 2024 20:56:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 677591F23609
	for <lists+io-uring@lfdr.de>; Tue, 18 Jun 2024 18:56:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24E2C15ECDE;
	Tue, 18 Jun 2024 18:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="gK1tnftW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D8B15ECCD
	for <io-uring@vger.kernel.org>; Tue, 18 Jun 2024 18:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718736998; cv=none; b=QI50JyVYYbqkKzrm61RV8Ct1ZBTwvl1GKq7TRWdfVS9k4jJKZlMMybsFD1TC9omcxCqa5E11b5vGt7uSATksk56mslzEaOYYfvy83Zc+zIMxmPaTTIUCHi1KHJkvJo1mJReri2L1M8lLecrp3C/wzxxfhRnY3TKyzDy1BPARJj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718736998; c=relaxed/simple;
	bh=5sRSBv5ItwHdn11wxMNodSOFiUzcifGJAq+cXuJeUeo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D5PLem4C4fL51FSeKxXqn0rA+7HV9J15hxxYL2Uobd33HGL+FRRb8Vso38spZp0lBZkLhKZYD9qPlZI5xBW8dm8i+dVS+yH6k+XGfty3/8U2UgE7PY5aeZdzLqLLV00s0RU9UGHqjhzjyTAVMFmAGqumUYxUN8lSknduMysIMrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=gK1tnftW; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-254976d3327so462349fac.1
        for <io-uring@vger.kernel.org>; Tue, 18 Jun 2024 11:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718736995; x=1719341795; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sJkyFFcYxDyLZVeBnsiuoh7hRv4i7f2OlZKY56NSA2I=;
        b=gK1tnftWBh5424Vol8h7JhWRY1kqrgXac2S4GHrdNzyhVVUMmapHQMsryLAVQaSu3w
         j3pAsc38QY31dcHJlCC0iBXiAuWZvlSlSGPM1w5c/HEu7IjQ4FSejiD/hHyZmxenLMRb
         s2BBcoJyOE0Ry2DxV4r6F2TBNDbGd3g2GkEq4YBlYIwKFdSFhsdMDPS4yeY8tdOKQQpH
         GLgDNgNHLkxjhMguLqLPxdzMDM1R03JzMsdbFC7ssnBFJZCru4fgwNvRWqzC5a7YWaUk
         UVfcPAexQS6U5UR1qc/HRqDl9+NpD5wFaeFFAhV4CedEyDOimQ7ta+pncNgBec0Z1hpo
         Y5dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718736995; x=1719341795;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sJkyFFcYxDyLZVeBnsiuoh7hRv4i7f2OlZKY56NSA2I=;
        b=NmLRaSR61l3A3OgQ8e790SGFXz+NSAkzKob/Ba54md3KxXTQtxBzL5oxAAeYkbo56d
         8wtcLhHPou6fRpZjgFSOk+uh77UKH0ml+5zLCvGBuYkTYpy7dHC5PGr1qZktt3nL9tDp
         46p89LFE49QO1uOdAJwgA42yK4Nl4D1vmukK0x1qGIux0qIouJWd42/J74izTBFDsVvE
         vhPhWPRDAEsA77fLTH8MBruecWe+XRfuUJWRr8+T4VTJedNjKvoSDk1otfPAnuiWIdpd
         BEaVNrRkQN0JrRaFD+W0eJp6XG8JrRAzrokcQj5S5a8xV05KyCHQepEuXglrKFDe+lmb
         CFIg==
X-Gm-Message-State: AOJu0YxQS8/3FiVdIs8RSaMxveQzBfr1rjuKlHE8PhkRT/GbgRpHYcxO
	5kIvzh/AuqzN23cG032E+0Vjczuuv7g2gOdK01w96VmTPErDcwtPPPo+WTTAK0pB4VDxy8Hp8xS
	d
X-Google-Smtp-Source: AGHT+IE43Q7tj3zbGYXJWYSy3dh4vp5hl2Ww+lmpQ7HtirEz6YuIVTrrE2n5DVzVlv9K6OipcC+fFA==
X-Received: by 2002:a05:6870:5486:b0:259:a580:7a93 with SMTP id 586e51a60fabf-25c949b7f87mr775523fac.2.1718736995071;
        Tue, 18 Jun 2024 11:56:35 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2567a9f7d6fsm3255492fac.20.2024.06.18.11.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jun 2024 11:56:34 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCHSET v4 0/9] Improve MSG_RING DEFER_TASKRUN performance
Date: Tue, 18 Jun 2024 12:48:39 -0600
Message-ID: <20240618185631.71781-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Hi,

For v1 and replies to that and tons of perf measurements, go here:

https://lore.kernel.org/io-uring/3d553205-0fe2-482e-8d4c-a4a1ad278893@kernel.dk/

and find v2 here:

https://lore.kernel.org/io-uring/20240530152822.535791-2-axboe@kernel.dk/

and v3 here:

https://lore.kernel.org/io-uring/20240605141933.11975-1-axboe@kernel.dk/

and you can find the git tree here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-msg-ring.1

and the silly test app being used here:

https://kernel.dk/msg-lat.c

Patches are based on top of the pending 6.11 io_uring changes.

tldr is that this series greatly improves both latency, overhead, and
throughput of sending messages to other rings. It's done by using the
existing io_uring task_work for passing messages, rather than utilize
the rather big hammer of TWA_SIGNAL based generic kernel task_work.
Note that this differs from v3 of this posting, as that used the
CQE overflow approach. While the CQE overflow approach still performs
a bit better than this approach, this one is a bit cleaner.

Performance for local (same node CPUs) message passing before this
change:

init_flags=3000, delay=10 usec
latencies for: receiver (msg=82631)
    percentiles (nsec):
     |  1.0000th=[ 3088],  5.0000th=[ 3088], 10.0000th=[ 3120],
     | 20.0000th=[ 3248], 30.0000th=[ 3280], 40.0000th=[ 3312],
     | 50.0000th=[ 3408], 60.0000th=[ 3440], 70.0000th=[ 3472],
     | 80.0000th=[ 3504], 90.0000th=[ 3600], 95.0000th=[ 3696],
     | 99.0000th=[ 6368], 99.5000th=[ 6496], 99.9000th=[ 6880],
     | 99.9500th=[ 7008], 99.9900th=[12352]
latencies for: sender (msg=82631)
    percentiles (nsec):
     |  1.0000th=[ 5280],  5.0000th=[ 5280], 10.0000th=[ 5344],
     | 20.0000th=[ 5408], 30.0000th=[ 5472], 40.0000th=[ 5472],
     | 50.0000th=[ 5600], 60.0000th=[ 5600], 70.0000th=[ 5664],
     | 80.0000th=[ 5664], 90.0000th=[ 5792], 95.0000th=[ 5920],
     | 99.0000th=[ 8512], 99.5000th=[ 8640], 99.9000th=[ 8896],
     | 99.9500th=[ 9280], 99.9900th=[19840]

and after:

init_flags=3000, delay=10 usec
Latencies for: Sender (msg=236763)
    percentiles (nsec):
     |  1.0000th=[  225],  5.0000th=[  245], 10.0000th=[  278],
     | 20.0000th=[  294], 30.0000th=[  330], 40.0000th=[  378],
     | 50.0000th=[  418], 60.0000th=[  466], 70.0000th=[  524],
     | 80.0000th=[  604], 90.0000th=[  708], 95.0000th=[  804],
     | 99.0000th=[ 1864], 99.5000th=[ 2480], 99.9000th=[ 2768],
     | 99.9500th=[ 2864], 99.9900th=[ 3056]
Latencies for: Receiver (msg=236763)
    percentiles (nsec):
     |  1.0000th=[  764],  5.0000th=[  940], 10.0000th=[ 1096],
     | 20.0000th=[ 1416], 30.0000th=[ 1736], 40.0000th=[ 2040],
     | 50.0000th=[ 2352], 60.0000th=[ 2704], 70.0000th=[ 3152],
     | 80.0000th=[ 3856], 90.0000th=[ 4960], 95.0000th=[ 6176],
     | 99.0000th=[ 8032], 99.5000th=[ 8256], 99.9000th=[ 8768],
     | 99.9500th=[10304], 99.9900th=[91648]

and for remote (different nodes) CPUs, before:

init_flags=3000, delay=10 usec
Latencies for: Receiver (msg=44002)
    percentiles (nsec):
     |  1.0000th=[ 7264],  5.0000th=[ 8384], 10.0000th=[ 8512],
     | 20.0000th=[ 8640], 30.0000th=[ 8896], 40.0000th=[ 9024],
     | 50.0000th=[ 9152], 60.0000th=[ 9280], 70.0000th=[ 9408],
     | 80.0000th=[ 9536], 90.0000th=[ 9792], 95.0000th=[ 9920],
     | 99.0000th=[10304], 99.5000th=[13376], 99.9000th=[19840],
     | 99.9500th=[20608], 99.9900th=[25728]
Latencies for: Sender (msg=44002)
    percentiles (nsec):
     |  1.0000th=[11712],  5.0000th=[12864], 10.0000th=[12864],
     | 20.0000th=[13120], 30.0000th=[13248], 40.0000th=[13376],
     | 50.0000th=[13504], 60.0000th=[13760], 70.0000th=[13888],
     | 80.0000th=[14144], 90.0000th=[14272], 95.0000th=[14400],
     | 99.0000th=[15936], 99.5000th=[21632], 99.9000th=[24704],
     | 99.9500th=[25984], 99.9900th=[37632]

and after the changes:

init_flags=3000, delay=10 usec
Latencies for: Sender (msg=192598)
    percentiles (nsec):
     |  1.0000th=[  402],  5.0000th=[  430], 10.0000th=[  446],
     | 20.0000th=[  482], 30.0000th=[  700], 40.0000th=[  804],
     | 50.0000th=[  932], 60.0000th=[ 1176], 70.0000th=[ 1304],
     | 80.0000th=[ 1480], 90.0000th=[ 1752], 95.0000th=[ 2128],
     | 99.0000th=[ 2736], 99.5000th=[ 2928], 99.9000th=[ 4256],
     | 99.9500th=[ 8768], 99.9900th=[12864]
Latencies for: Receiver (msg=192598)
    percentiles (nsec):
     |  1.0000th=[ 2024],  5.0000th=[ 2544], 10.0000th=[ 2928],
     | 20.0000th=[ 3600], 30.0000th=[ 4048], 40.0000th=[ 4448],
     | 50.0000th=[ 4896], 60.0000th=[ 5408], 70.0000th=[ 5920],
     | 80.0000th=[ 6752], 90.0000th=[ 7904], 95.0000th=[ 9408],
     | 99.0000th=[10816], 99.5000th=[11712], 99.9000th=[16320],
     | 99.9500th=[18304], 99.9900th=[22656]

 include/linux/io_uring_types.h |   3 +
 io_uring/io_uring.c            |  53 ++++++++++++---
 io_uring/io_uring.h            |   3 +
 io_uring/msg_ring.c            | 119 ++++++++++++++++++++-------------
 io_uring/msg_ring.h            |   1 +
 5 files changed, 124 insertions(+), 55 deletions(-)

Since v3:
- Switch back to task_work approach, rather than utilize overflows
  for this
- Retain old task_work approach for fd passing
- Various tweaks and cleanups

-- 
Jens Axboe


