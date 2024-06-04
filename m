Return-Path: <io-uring+bounces-2097-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85ED48FBC5B
	for <lists+io-uring@lfdr.de>; Tue,  4 Jun 2024 21:13:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 365EB2866C4
	for <lists+io-uring@lfdr.de>; Tue,  4 Jun 2024 19:13:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4416314AD32;
	Tue,  4 Jun 2024 19:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dGunhtSC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A29114A629
	for <io-uring@vger.kernel.org>; Tue,  4 Jun 2024 19:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717528403; cv=none; b=DT3Gh8BmED+JeAjZtfQuSXcnBbj6oxySqNjT6FPC4+UMNSZvviCfNvd0Nzswf83LfjI0Yeed5gNN6iIrgS9SBBH3rZGHdiRay/6tXF6XTDoFgbG76AyeCz+BtqIsMoK+DRg90AZqrhDyhdULmvjuxnMNOCqXH6n4APt9tjM2n64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717528403; c=relaxed/simple;
	bh=xg02Tm1CxyttF9srLzKdrVJB7d9Y06yLmnRJarU5y48=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Ho+kaDXm1cSLc4oZmgqa8mBmsIle4EYIcSL2bcKMddW3uSOqAKaD6SNz71DJb+Wv0QFkNHuKWLUcR5ntJ7AqsYTPDeGeD+p0aIs9O7o6L/LGCU/SR0epUJbjmQcli9lCPHvY0wPPvv+QypJrfe91grB7zaONKyF1+CdgQULcSDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dGunhtSC; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2c1e9965478so613226a91.0
        for <io-uring@vger.kernel.org>; Tue, 04 Jun 2024 12:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717528398; x=1718133198; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=qBn1duKAVAtgxX7stVKvG8tP+D4kTxLMPU50SVB0S3Y=;
        b=dGunhtSC2Ece2WkIwmx1lbDbl83Esini2Q64T1Kdsu5Ij4N+5BD2z7QfDk1PPW4+u1
         jJzn0NQsoOFxFsHbSZ6deLUB4HoyMaZHalyeVzgS1BI7THMXZgHldmNxnsCysWdzvpDj
         cBEUIdmi/ag+xLsWyUBdfquYxq4f1lqosTPeYZNaZrq2E8h2K67amrcEN6Nqt0q3ZJFK
         cwAChRvUiwtOyAK6eoiPGrv01t+U6WtQmISLulHNVGv7RF67IbZA5w8JjNaHS3WJrONp
         t5whPPvMISj/AGdFA7/XU9olnm8cI4ks+C9w/qZUvaAq1m2PgV883zTQU/ZvmSa3ST4w
         qNKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717528398; x=1718133198;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qBn1duKAVAtgxX7stVKvG8tP+D4kTxLMPU50SVB0S3Y=;
        b=sViKtz//ox7Fx9mDPB5XAxJIpF1U/N++LKmXmBbcqPwIpCRZJ5DPliRosTzX2VzzEx
         kSV+47BBZPeApGOBe3kZ/sgMGz5q1W5EryUOfoFnrs1pifT+gh3P8ZavX2s82bmHEFoJ
         sQ8I0mGtxUd0E6AsTdsx6H16DidlterBLUKjW/YQ3ohEm+IumrN7tHKcCviwWkM3MG/8
         f3RK1ZJbLURco2bAH6eY80XZE+zoUDfK6OQR32vmNISkNGpfLidnnVX2T4/vBqQGd5+D
         htSAje1ZYiXbNRW62PlLXzg9493cDGt03upFStK/XCtU9QDRFKu1zb4kIghM6aNO+V+H
         YtXQ==
X-Gm-Message-State: AOJu0YwKA8WaQjDdxMevGuxi9mo0BZChzfGg/BMZaJN9ZXDXcNmtRXH2
	aklRLaAuDk59kCJyUxv9h0ktjIRmWIdcUyM9A2L4RKJjr2izO3oVw0c8aO3rGmb/kP226ZnT61G
	X
X-Google-Smtp-Source: AGHT+IH5f5cNvzpXf17LlgWA25ewvOKYTEmS0VuZsRCrkPjKKGv2W6MopF+4CIBn+4jENggLyowSPA==
X-Received: by 2002:a17:90b:3788:b0:2c1:a4ca:53d with SMTP id 98e67ed59e1d1-2c27db63bf5mr367343a91.3.1717528398211;
        Tue, 04 Jun 2024 12:13:18 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c1c283164fsm8960265a91.37.2024.06.04.12.13.17
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 12:13:17 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET RFC 0/5] Wait on cancelations at release time
Date: Tue,  4 Jun 2024 13:01:27 -0600
Message-ID: <20240604191314.454554-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

I've posted this before, but did a bit more work on it and sending it
out again. The idea is to ensure that we've done any fputs that we need
to when a task using a ring exit, so that we don't leave references that
will get put "shortly afterwards". Currently cancelations are done by
ring exit work, which is punted to a kworker. This means that after the
final ->release() on the io_uring fd has completed, there can still be
pending fputs. This can be observed by running the following script:


#!/bin/bash

DEV=/dev/nvme0n1
MNT=/data
ITER=0

while true; do
	echo loop $ITER
	sudo mount $DEV $MNT
	fio --name=test --ioengine=io_uring --iodepth=2 --filename=$MNT/foo --size=1g --buffered=1 --overwrite=0 --numjobs=12 --minimal --rw=randread --thread=1 --output=/dev/null --eta=never &
	Y=$(($RANDOM % 3))
	X=$(($RANDOM % 10))
	VAL="$Y.$X"
	sleep $VAL
	FIO_PID=$(pidof fio)
	if [ -z "$FIO_PID" ]; then
		((ITER++))
		continue
	fi
	ps -e | grep fio > /dev/null 2>&1
	while [ $? -eq 0 ]; do
		killall -KILL $FIO_PID > /dev/null 2>&1
		echo will wait
		wait > /dev/null 2>&1
		echo done waiting
		ps -e | grep "fio " > /dev/null 2>&1
	done
	sudo umount /data
	if [ $? -ne 0 ]; then
		break
	fi
	((ITER++))
done

which just starts a fio job doing writes, kills it, waits on the task
to exit, and then immediately tries to umount it. Currently that will
at some point trigger:

[...]
loop 9
will wait(f=12)
done waiting
umount: /data: target is busy.

as the umount raced with the final fputs on the files being accessed
on the mount point.

There are a few parts to this:

1) Final fput is done via task_work, but for kernel threads, it's done
   via a delayed work queue. Patches 1+2 allows for kernel threads to
   use task_work like other threads, as we can then quiesce the fputs
   for the task rather than need to flush a system wide global pending
   list that can have pending final releases for any task or file.

2) Patch 3 moves away from percpu reference counts, as those require
   an RCU sync on freeing. As the goal is to move to sync cancelations
   on exit, this can add considerable latency. Outside of that, percpu
   ref counts provide a lot of guarantees and features that io_uring
   doesn't need, and the new approach is faster.

3) Finally, make the cancelations sync. They are still offloaded to
   a kworker, but the task doing ->release() waits for them to finish.

With this, the above test case works fine, as expected.

I'll send patches 1+2 separately, but wanted to get this out for review
and discussion first.

Patches are against current -git, with io_uring 6.10 and 6.11 pending
changes pulled in. You can also find the patches here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-exit-cancel

 fs/file_table.c                |  2 +-
 include/linux/io_uring_types.h |  4 +-
 include/linux/sched.h          |  2 +-
 io_uring/Makefile              |  2 +-
 io_uring/io_uring.c            | 77 ++++++++++++++++++++++++----------
 io_uring/io_uring.h            |  3 +-
 io_uring/refs.c                | 58 +++++++++++++++++++++++++
 io_uring/refs.h                | 53 +++++++++++++++++++++++
 io_uring/register.c            |  3 +-
 io_uring/rw.c                  |  3 +-
 io_uring/sqpoll.c              |  3 +-
 kernel/fork.c                  |  2 +-
 12 files changed, 182 insertions(+), 30 deletions(-)

-- 
Jens Axboe


