Return-Path: <io-uring+bounces-13232-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yCvGNl29+Gnh0AIAu9opvQ
	(envelope-from <io-uring+bounces-13232-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 04 May 2026 17:38:05 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C48E4C0C83
	for <lists+io-uring@lfdr.de>; Mon, 04 May 2026 17:38:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6E476301BF52
	for <lists+io-uring@lfdr.de>; Mon,  4 May 2026 15:38:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC35F3E022A;
	Mon,  4 May 2026 15:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MCeG+qe6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C10E38947E
	for <io-uring@vger.kernel.org>; Mon,  4 May 2026 15:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777909081; cv=none; b=eHetPgj9iVDM7Z/lIm2vNb43j/6e8RHJwB5qiY3ULuL2DLRAKwVpUnY5JPx+XLO8c+sKG2DJP/7mpQQwirtGqcziJnOx7a+cSWbgwfdrnX9Bax5olCewn2sr1OfY8pml2t3tQa3B3jyvsQJmGj3aScNUT6oW8kXmiVr5PUfU2DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777909081; c=relaxed/simple;
	bh=4oiJ0Xur8OKYqo3eAfcV47Rj5WxGJOObgIniTs1LeEw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=soeIHt/ocGz/P2eUAbc/mF7hwA5RxC73UczfdkE8HjVg4jQ2MBlaZ5rrzjZ0YzG2yuru7wL2OsaE8S60x/5wCjnT1EXDWzhMX0/InfhfsnjsexZ1tziy6m95XBnwZKl1jR7cgcLWS9V048YGz+CBbD+z5JESkRjaLVBKu3BuERo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MCeG+qe6; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-c7980c060cfso1303457a12.2
        for <io-uring@vger.kernel.org>; Mon, 04 May 2026 08:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777909080; x=1778513880; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7/MBm9STXrG0stFlZQF6BRwSfe934Vw9vzplPi2awrg=;
        b=MCeG+qe6FN22KAG2nWTZVUxMEff5ywQdn28gZOCMFfiDaMQImoHkXfvah6K+1SlzGq
         xKtJ8dkg2/X6VQxW/CYaFvv0L8G1ceVGzY6Pwf7JLrZNUKf1+ZTRzJIawa1HbTa790Z8
         w95Ri0NTBeMIbweReTkaeQukyh0c/YCO8QQ0HvNhOt+B3lZ1yI1JCnmqqbCpIJd0YU8M
         tHFQhlKh4+ZYTmIuSJotetZB/GqEvaH2XTjtfHH83YAqPhmS9iIoyeL0VDgYFG3RlXtS
         xxrQjyHJ73jeTagQ5gu/LOmiEzPIguIisaArKsIC9S9+uni3oJ7E8pPLokt6Osa6E2UF
         pLAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777909080; x=1778513880;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7/MBm9STXrG0stFlZQF6BRwSfe934Vw9vzplPi2awrg=;
        b=gpWPT+tQ17B1cnuxbly1r6Ra/zuKwZiERj5Xne2u1TIwHh95PVuV1rWu4IYue76fSg
         +CP4OAHI/uaznnTXJYbFYwlDgz8/xk5pe+k0fZtaRC/Aen4QPtX9jEIpvpeqWWRQ2SUz
         3glx/+P59izJROuvI/C/JVi3FAVfL2D7xyoZmreoK7Bhi+tUWlGdufgjmRuMjytpbsmi
         nnQnQEajVy/Z4TCEKIApW94IoeVH+tEsA3DOOHX22V41qCfFIQXsRvRX3q81F//Ru9PJ
         SDeI+8dX8JTZIhN1LEMy3Q1xaN26QRzRulpYiodlbiCHXbhaM2X+v/PoVMrbbZvIhIts
         ltfg==
X-Forwarded-Encrypted: i=1; AFNElJ/N0LvaIzEg9XSXcxtF5FhF5wJwqJEec+mpp2K/HMnnOzz8xRmwKKAbDwrbvSW0SsZQNdew+SifzA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzbwbySoTbSKCGCfPVXTV1CEpiWjCeeI7CooEDL+NHXIRc1plsi
	K8UMYA69LChObR+py1MatkbfBxHbEKRx/JSqVhkMQ+o/MccYWoENqlACE5eiXw==
X-Gm-Gg: AeBDievLJHYkMojTTRzLkRiaeG2lZvVHhp5s9Jb3VU4jKX0OECLHV9lLNPty3aJ4CZB
	yz5cRurunBoFy3/7CbeIjbPJ28RIh6KPVq8Z+knDx9sJnMRkl3w/fNLxQtojdFQd57n6JLqqI2q
	tVMSpgU33PSPUt3E8HS8nR5xpdCgrueMcwWQqCv3XO3gybgCdHxaGFVoZQZ52KOjlaigeDNqrSH
	3JIqi4vw7PPXdHSvFkEMBWdjjOMDQxALE1t0O5hpMHMH5mqZulaPcOKcpb7wHcq5qlHOsbFzGQi
	2/5a5BIFQOj6fkGPHFohsUxEHAO9tDG9lOBdaXJ2ttH9hT93Ssntu5LzFI+y2W/8RxB9QSNdksJ
	asPRrshmZ9JmFW62xGyLxejqeALRSITmClnbpAbgzV8gY4VJD7r1bWZk6c0tfjU4I35n1yqeDQg
	XtRhOuId9Tjmhs4OViVBATkeG8yjiUpVUD8BTaYJJqm5tvy1rCzv/PB3Z/jwY=
X-Received: by 2002:a17:903:1a24:b0:2b2:5840:80c4 with SMTP id d9443c01a7336-2b9f260ae75mr114102925ad.25.1777909079568;
        Mon, 04 May 2026 08:37:59 -0700 (PDT)
Received: from csl-conti-dell7858.ntu.edu.sg ([155.69.195.57])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b9caaaec82sm110364095ad.24.2026.05.04.08.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 08:37:59 -0700 (PDT)
From: Maoyi Xie <maoyixie.tju@gmail.com>
X-Google-Original-From: Maoyi Xie <maoyi.xie@ntu.edu.sg>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] io_uring: honour submitter's time namespace for ABS timeouts
Date: Mon,  4 May 2026 23:37:53 +0800
Message-Id: <20260504153755.1293932-1-maoyi.xie@ntu.edu.sg>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2C48E4C0C83
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13232-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maoyixietju@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,ntu.edu.sg:mid]

This series addresses two io_uring code paths that arm an ABS
hrtimer from a timestamp supplied by the caller. Both paths skip
the conversion from the submitter's time namespace view to host
view via timens_ktime_to_host(). The clock is CLOCK_MONOTONIC by
default, or optionally CLOCK_BOOTTIME.

All four other ABS timer interfaces already do this conversion:
timer_settime(TIMER_ABSTIME), clock_nanosleep(TIMER_ABSTIME),
alarm_timer_nsleep(TIMER_ABSTIME), and
timerfd_settime(TFD_TIMER_ABSTIME).

Patch 1/2 (io_uring/timeout) covers IORING_OP_TIMEOUT and
IORING_OP_LINK_TIMEOUT via io_parse_user_time(). It is essentially
the draft Pavel posted on the original thread. I rebased it on
io_uring-7.1 and verified end to end.

Patch 2/2 (io_uring/wait) covers the IORING_ENTER_ABS_TIMER path
in io_uring_enter(). That path parses ext_arg->ts inline rather
than going through io_parse_user_time(). Patch 1/2 therefore does
not cover it.

Per Pavel and Jens's discussion on the original thread, the two
sites use two direct timens_ktime_to_host() call sites rather
than a shared helper. Patch 1/2 also splits the existing
io_timeout_get_clock() into a flags only io_flags_to_clock(), so
io_parse_user_time() can resolve the clock without a
struct io_timeout_data.

SQPOLL is automatically covered. The SQPOLL kernel thread is
created via create_io_thread() with CLONE_THREAD and no CLONE_NEW*
flag. copy_namespaces() therefore shares the submitter's nsproxy
by reference. timens_ktime_to_host() through "current" sees the
submitter's time_ns when called from the SQPOLL kthread. PoCs for
both paths confirm this.

Reproducers (run inside unshare --user --time with a -10s
monotonic offset):

  IORING_TIMEOUT_ABS (patch 1/2):
    vanilla 7.1-rc:  elapsed = 1 ms  (bug, fires immediately)
    patched:         elapsed = 1000 ms (offset honoured)

  IORING_ENTER_ABS_TIMER (patch 2/2):
    vanilla 7.1-rc:  elapsed = 1 ms  (bug)
    patched:         elapsed = 999 ms (offset honoured)

Maoyi Xie (2):
  io_uring/timeout: honour caller's time namespace for
    IORING_TIMEOUT_ABS
  io_uring/wait: honour caller's time namespace for
    IORING_ENTER_ABS_TIMER

 io_uring/timeout.c | 35 ++++++++++++++++++++++-------------
 io_uring/wait.c    |  6 +++++-
 2 files changed, 27 insertions(+), 14 deletions(-)


base-commit: 04fe9aeb4f3c0999e6715385664c677469dfd8f4
-- 
2.34.1


