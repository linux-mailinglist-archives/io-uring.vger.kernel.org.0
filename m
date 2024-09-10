Return-Path: <io-uring+bounces-3109-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 060619739F1
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 16:33:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B27C91F26B68
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 14:33:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75A711922E1;
	Tue, 10 Sep 2024 14:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=felix.moessbauer@siemens.com header.b="TRrGEo4l"
X-Original-To: io-uring@vger.kernel.org
Received: from mta-64-228.siemens.flowmailer.net (mta-64-228.siemens.flowmailer.net [185.136.64.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D305183094
	for <io-uring@vger.kernel.org>; Tue, 10 Sep 2024 14:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.136.64.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725978817; cv=none; b=mSZw4iY2HNwsTUhLU7KjAlCv/2VUB4C0R1xrD8UJmKrJrVh96/iV63Vo5L514Kfbk8ti6G9m8STGVgbiTO718VmgP48WDn13u+lEFtj2GePZpoQAIn4V6xZZ/O8iXiOxat5oKfnE2Loe1oSy0eGS2LJaWxnwoxBxg2uBqLTyEpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725978817; c=relaxed/simple;
	bh=poE8grF23H6F7X6kladvopyA9WzGBQJEyFVgCwLsZQE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=o3VBpMs9xuPlM7lpikZW6O/TsuVqMPZlxrL0kLOYBK19UYzMvyq/5n5x4HYXgIfdpSS2HIoWQxdkGDtlNxb7bZUE4O3IbWWAYU9GRj4Q7b1kEt9wRiYc1zn3MWsRvFo6V9xg8gj5Vy2Ye409W1HBULO41k/eAd7N+eGbQILql48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=rts-flowmailer.siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=felix.moessbauer@siemens.com header.b=TRrGEo4l; arc=none smtp.client-ip=185.136.64.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rts-flowmailer.siemens.com
Received: by mta-64-228.siemens.flowmailer.net with ESMTPSA id 202409101433299f8719594560100f43
        for <io-uring@vger.kernel.org>;
        Tue, 10 Sep 2024 16:33:29 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; s=fm1;
 d=siemens.com; i=felix.moessbauer@siemens.com;
 h=Date:From:Subject:To:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Cc;
 bh=YhEk9dDDTR4Esasd68P4fshsCaDrjR3/+F0dNLo1y8c=;
 b=TRrGEo4lTdKAcEt7WDLBAJz+Y09fpohs3hI/QT7+E0IZDpaV422/VtQbok/drlU2vdFW9x
 Z5Z26hUFvrIFu228o1URCSF5fJqMGY8mC6cSSd7M65WWDUzEVbmKyEYjE+Lbv+FgrzXWZyRa
 XonRCtlanYnHT5dLX3r8TvCPjN7HEDm4ZxJKFAQG/Ygs7p1qMJg5z6Qrjr44GMDL9AAESA8N
 lhCo0W5gAlTA0AN9Xvr3YrA7tRHl/a8hhWIEAVh67RA1d9oxIlltM2q8zfMWUrMwwaxtbEfe
 YMvYQuGGjDw3ca9aer5lgz6DDjdbqJvXu58g+v6r1LnjZSlIbmilQ25A==;
From: Felix Moessbauer <felix.moessbauer@siemens.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	cgroups@vger.kernel.org,
	dqminh@cloudflare.com,
	longman@redhat.com,
	adriaan.schmidt@siemens.com,
	florian.bezdeka@siemens.com,
	Felix Moessbauer <felix.moessbauer@siemens.com>
Subject: [PATCH 0/2] io_uring/io-wq: respect cgroup cpusets
Date: Tue, 10 Sep 2024 16:33:18 +0200
Message-Id: <20240910143320.123234-1-felix.moessbauer@siemens.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Flowmailer-Platform: Siemens
Feedback-ID: 519:519-1321639:519-21489:flowmailer

Hi,

this series continues the affinity cleanup work started in
io_uring/sqpoll. It has been tested against the liburing testsuite
(make runtests), whereby the read-mshot test always fails:

  Running test read-mshot.t
  Buffer ring register failed -22
  test_inc 0 0 failed                                                                                                                          
  Test read-mshot.t failed with ret 1     

However, this test also fails on a non-patched linux-next @ 
bc83b4d1f086. The test wq-aff.t succeeds if at least cpu 0,1 are in
the set and fails otherwise. This is expected, as the test wants
to pin on these cpus. I'll send a patch for liburing to skip that test
in case this pre-condition is not met.

Regarding backporting: I would like to backport these patches to 6.1 as
well, as they affect our realtime applications. However, in-between 6.1
and next there is a major change da64d6db3bd3 ("io_uring: One wqe per
wq"), which makes the backport tricky. While I don't think we want to
backport this change, would a dedicated backport of the two pinning
patches for the old multi-queue implementation have a chance to be accepted?

Best regards,
Felix Moessbauer
Siemens AG

Felix Moessbauer (2):
  io_uring/io-wq: do not allow pinning outside of cpuset
  io_uring/io-wq: limit io poller cpuset to ambient one

 io_uring/io-wq.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

-- 
2.39.2


