Return-Path: <io-uring+bounces-13671-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id u8yrDvDcKmpSyQMAu9opvQ
	(envelope-from <io-uring+bounces-13671-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 18:06:08 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id B89056734BC
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 18:06:07 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=Y8P4+Tqq;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13671-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.232.135.74 as permitted sender) smtp.mailfrom="io-uring+bounces-13671-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 1B05C3011379
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 16:06:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4543C403B13;
	Thu, 11 Jun 2026 16:06:05 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866B03FBA7
	for <io-uring@vger.kernel.org>; Thu, 11 Jun 2026 16:06:03 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781193965; cv=none; b=d0cPlxVBg7nGn6spPWTdEQmitqErCMniqnHzBsPWLneJTbFQAuih48tvPbqC+k8h5SFkBKVFCbAs7FfkoQ/tkIwloEkYrpQ4/5LIudAbkf/4cRa0LBEZrVBFQmhXQ7zU2416esY9XnM7WjpvGdkPrqTj84Co4IEpIscbndn1bEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781193965; c=relaxed/simple;
	bh=1r1/axfuQEMxICVO1sSeV0blFi/NRppyhFbzAhb0gos=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DbbZkc2m9EMocNNIks6T+ygapv3b6BiXL41sB55zhq5EgH6Mbdw4tfDqzBDxaaAV/5r6i7l+EN1O12RWM816F6hPXXxnLOb9PE2NPePj3QQKQUBxczIqb6mwZ0Tii71iLm2x7xIr1e7weAmEXlHr1CIM/RqU7x33ykkbjNXsii0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=Y8P4+Tqq; arc=none smtp.client-ip=209.85.160.51
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-43d133d9a28so34959fac.2
        for <io-uring@vger.kernel.org>; Thu, 11 Jun 2026 09:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781193962; x=1781798762; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3b1x8xGV7cSIq1Qx4a06O3JKPDWeOdcXL8IuMPZ8gYI=;
        b=Y8P4+Tqq8IStuMIF4bVuse2MaAxYSBFrlbNy484R7cYUi0rX+rRWvldnfUN69AUaBR
         aHK6yqPBU5meKV2iOTDdo4wkdpQPRYOkv01AfdIMCq9cUmM/6rOZZX9Qj3ZSSPn8TZMM
         gb3hGTmANrQFo7Lo7iyEwXLEAIqDCGr//kxvNEo7coBGi5ghMjLl90Hon/lF42WqbNyd
         G0B2iyW/FVJBiE0hHLItplLPK4hPNw7mpxRmznTn/bati6KqU4ZqWB+J8W47GvY7ZOiF
         r7I+s6DNbPMhLfxvPhGsZK1Pl50r3OOwtkca43hAzl53DQ9O9Bb5BhELfmXhmUgbT4cu
         1ulw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781193962; x=1781798762;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3b1x8xGV7cSIq1Qx4a06O3JKPDWeOdcXL8IuMPZ8gYI=;
        b=ITNV0cfjfaE9/mlE/6KMF6VHeDrgbWZtuB6xTALWvkUq9+ksxDdn1DzPnFnEFWTNCf
         Hos0czNZYrIl9PQG2kfN2nZPoF8I1s3xOu3BRW5uuDj5wAdIYzqcgBS8ID1RPZziXgco
         xr1d0xlDgd6mfUG6j9k16vDmw5wgAHx8oLeQon96Fa7K6NtVPJpwXOeNlZZ7/uyHtKn6
         Vdy2hHi/QOFX2JtCOvpjl80qNhGMiij0FNMLR/uwX9K7TkHoVsIaMCVgR93gT4JGs84C
         q8ycV0Oq+cXBTfBeVqKosM7x44BgFOvdpnN39v8VraaOwKbO2htjDgKfGwZPLdoFRVM+
         NKxw==
X-Gm-Message-State: AOJu0YyHCJoQ9evvAuOvm8ClD7pv/ONPdnsEmbAE2+BCDen+lROilmUa
	TLHxn5NNIrbQzYIV69KjunQaSfFy2RbZhqtfZNnceHWsGrzY5rbcsboRN87SLOS3303wbGxiiei
	NKQv0WcM=
X-Gm-Gg: Acq92OEYw3pwPG4dYa1v51OCTB3XXtDlUjimqDZhYpaPNUSYcQ/mo50oCLXDFzhOQCS
	jkhH2KxSTcYD3NbNtB2NZS3YPEvNEENyVmY2/CF4QEj3p6t+mkP9P+h7izAjNvL7AnxYMi3oiv4
	mwV8YomD9FGKyJaynq9Sl1q7ZJ0neFBVNbjAKS9WwTC3PuMWoR4jvOZT9nNf5Rg6EaEPlXqIVkD
	dwqaLs5L75lyLOcctCbtIrJjd3iFjGTXX9fJwgJoBy6mhX1tXTypSI2+s3bNSn4GRVdkcS4az31
	3u18rM2bz7bZzEISppsYJqHDuGXZztItrqUSifD0Emz+9AXGeCTYcrl8zM+om5AVXhSEPhTJlFq
	5q86coq+l3gx7c3WkOx6BQQyt+A91bwrSRh2imh9J96JyMxvZAFAZCZlQlsl2JZWQG91GQDjf8j
	wYC30Ka1EBZMzy9danIiJx/PjtmwuzkyaBfo0RK+rvX5K0nC9knI7FHiOs6eQVagQrSqIOV3op3
	MI1UQ==
X-Received: by 2002:a05:6870:e254:b0:441:b0ff:132a with SMTP id 586e51a60fabf-44241a91e8amr2303514fac.18.1781193960939;
        Thu, 11 Jun 2026 09:06:00 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-442444c7d9csm1353221fac.3.2026.06.11.09.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 09:06:00 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: dvyukov@google.com
Subject: [PATCHSET 0/2] Add lockless MPSC FIFO queue for task work
Date: Thu, 11 Jun 2026 09:58:40 -0600
Message-ID: <20260611160553.1486640-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:dvyukov@google.com,s:lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-13671-lists,io-uring=lfdr.de];
	RCPT_COUNT_TWO(0.00)[2];
	PRECEDENCE_BULK(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORWARDED(0.00)[lists@lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_FORWARDING(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: B89056734BC

Hi,

Details are in the commits, but this adds a variant of an MPSC FIFO
queued based on Dmitry's intrusive MPSC node-based queue algorithm.
Main motivation is better cache locality between the consumer and
producers, and avoiding the need to reverse the llist before running
it. Numbers in patch 2.

Patch 1 adds the basic queue implementation, patch 2 adopts it for
DEFER_TASKRUN variants of io_uring.

Results are really promising. It clearly scales better with more
task work running or producing, and it avoids the added overhead
of needing to reverse the llist when local task work is run. Runs all
the regression tests, and the benchmarking I've done. I've had a user
harness version of this running on arm64 and x86-64 as well.

Can also be found in a git tree here:

https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git/log/?h=io_uring-tw-mpscq

 include/linux/io_uring_types.h |  26 +++++-
 io_uring/io_uring.c            |   2 +-
 io_uring/loop.c                |   2 +-
 io_uring/mpscq.h               | 121 +++++++++++++++++++++++++++
 io_uring/tw.c                  | 145 ++++++++++++++++-----------------
 io_uring/tw.h                  |   4 +-
 io_uring/wait.c                |   8 +-
 io_uring/wait.h                |  20 ++++-
 8 files changed, 239 insertions(+), 89 deletions(-)

-- 
Jens Axboe


