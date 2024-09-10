Return-Path: <io-uring+bounces-3121-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A42A2973C9A
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 17:46:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 67DD528318D
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 15:46:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACD341A00DA;
	Tue, 10 Sep 2024 15:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=felix.moessbauer@siemens.com header.b="Vz600VjG"
X-Original-To: io-uring@vger.kernel.org
Received: from mta-65-225.siemens.flowmailer.net (mta-65-225.siemens.flowmailer.net [185.136.65.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619031922F6
	for <io-uring@vger.kernel.org>; Tue, 10 Sep 2024 15:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.136.65.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725983155; cv=none; b=Ei43LsLElAD2jl6Po3gPMBmoPOjWF3ExfK4mwPKV6iEFdWLICnjr1S5Mk1RqIPOzElRN5qpMRfZhoCK7ySE4NCyEqjMXjNaBZF6cdPMrMGKMBlK6vOC2aH1omhRdENfv6wUujEFZ9v7/3HMfhOcQnBiZYlKrK7GHketM4ql6zhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725983155; c=relaxed/simple;
	bh=ZGIN6oL8ZbhY+JlkI9Ku+beUgqeJ7DREjZJAKrxKUks=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PKG7HuheYU60Q3XqD9jf8xfAO7L/8SqjYiXitKtIBAa0w10cHG2E8MNXDVKw7NIWWsVCQcPpx+9YaXO4e8mQkr++5YKH3wDUvCTKMH8Zx8d4FykeT3SNJ8m2U/gGMpzBwRyNIxpDJSRSmpqpepV4KkvwK9LAjh6pFV16e0ztopM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=rts-flowmailer.siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=felix.moessbauer@siemens.com header.b=Vz600VjG; arc=none smtp.client-ip=185.136.65.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rts-flowmailer.siemens.com
Received: by mta-65-225.siemens.flowmailer.net with ESMTPSA id 20240910154548802b19939950f8ef19
        for <io-uring@vger.kernel.org>;
        Tue, 10 Sep 2024 17:45:48 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; s=fm1;
 d=siemens.com; i=felix.moessbauer@siemens.com;
 h=Date:From:Subject:To:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Cc;
 bh=nThz1Prv8qbxtOruFaTCR2A/NQ2gWru4hgUnv1ATbIE=;
 b=Vz600VjGeixnbiVq/I5rQLc1cFupil2HtlL0k1mMpot4i3Rb+qiBx2dgC5tEBchf7ZUy8z
 x4ABdutZ7QxR6c//wEv38Q307qCiczchclKz5CnwEHQTDehJzi5KblaFK2G2rIfMktVsZWwk
 0qzKkTjziOqSoqt2Kx04oDTzTRnA2Lke5DI/GkPVJsXuaEp+vRIfsTG2rbO7oFlJhkoxrdvP
 ObIFpg9Z2wlGGiAfi6S5ihJcKkwgccH104EGM6NcYKVeRy4LhG/m4EIjJf+d6Q0ZZGo4FrM2
 zpY0v0D2xauEwR6JUMDrNWGoPyCqyKeceqgJREfNaEqEWjdew3FG4hjQ==;
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
Subject: [PATCH v2 0/2] io_uring/io-wq: respect cgroup cpusets
Date: Tue, 10 Sep 2024 17:45:33 +0200
Message-Id: <20240910154535.140587-1-felix.moessbauer@siemens.com>
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
io_uring/sqpoll. It has been successfully tested against the liburing
testsuite (make runtests), liburing @ caae94903d2e201.

The test wq-aff.t succeeds if at least cpu 0,1 are in
the set and fails otherwise. This is expected, as the test wants
to pin on these cpus. I'll send a patch for liburing to skip that test
in case this pre-condition is not met.

Changes since v1:

- rework commit messages (don't use ambient cpus, wq threads are no
  pollers)
- no functional changes

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


