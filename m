Return-Path: <io-uring+bounces-11896-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GPs2JJhgc2kCvQAAu9opvQ
	(envelope-from <io-uring+bounces-11896-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 23 Jan 2026 12:50:48 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D17A475644
	for <lists+io-uring@lfdr.de>; Fri, 23 Jan 2026 12:50:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 49A0A303675E
	for <lists+io-uring@lfdr.de>; Fri, 23 Jan 2026 11:48:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FC93320382;
	Fri, 23 Jan 2026 11:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="LldfiBAw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BF231A7ED
	for <io-uring@vger.kernel.org>; Fri, 23 Jan 2026 11:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769168916; cv=none; b=Y/iQpQK5FLMNpPs/4t3+nYugyKO3ElOFXIA2n4MolBvhx3f5IGhZVmEPFlzv1dDU7xZq736ZGiy7yV/2BttsLOddiKgORXbb0Ebw9pExV+07TEzgBbahSRaR6KmR5WbSIajhJrVHzVvTmJ4EqRv5clTg40fCEEJhlp5wYcO7rS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769168916; c=relaxed/simple;
	bh=lJbmBDY4p0K2oHemvzGf+vMeVSB1xhFvc7HgcMSNAIU=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=tHeQn7cGHqaNZLPlONDvYQ1rBNkV4thOMiyjd8nSl8A4MkMCbw5QpV/qdE1pGu1eapz1+rV173yo/BIMZgyt0f2AIORAyyP5wzyjCj6QwzYbZlb1k0tI6E3x1wKYIrsvw7EhL30ZWnfy/K8cGfi3fuRY0P+3Vx2h9MBy06z05ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=LldfiBAw; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-459ac606f0bso1507515b6e.0
        for <io-uring@vger.kernel.org>; Fri, 23 Jan 2026 03:48:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769168911; x=1769773711; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s8j29u+WRc7+WHzvn6sB9Kynj7TGtOy2pPDGqssDmBU=;
        b=LldfiBAwcUieoCy9bLAxoIuN/mKO8leHHQF9ZLhl0B2WIzCJw5m4Awrp/K+JE+YTQL
         jMmU/539pfqHtakVn9yZkAnzczEF+TcBQeZBSnm+rqH3dzwZEBuFcaUeYqJlQWPvc6Wc
         9msAzVvvtv5b1qXEQgEQ9BrJRyf3lmCmXl9YrbseCZURNPdVTD7TfUwi1sEvcQzWR9RI
         t36+7aLIG2gwJX0Tza/R5Zgk+6qVR8Bui/tcCfjUr/f7lsuee7GhSwYElpLNgE73dCdi
         1Ew+tsn9OFFKjg6iMpPr7WSTWpTjlcCDsk1kzu8npJrBEkR88eYAAn38Fb7w/tilVep9
         C9NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769168911; x=1769773711;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s8j29u+WRc7+WHzvn6sB9Kynj7TGtOy2pPDGqssDmBU=;
        b=aqoE8I/5JUOwM9a2s9TMZx1v5kGCi3dle0QO0AiJ9i0U72LOJre/4pWpTE5lDtdYOV
         yiz8MVPp2ozNsk2mjnKfztKFnuzeqxawLMRRVPv+hYX7eEzBCWfux3excBVYwx6EhxWo
         OLAmYjpcoHU+8bVHqp5A2XwukzLgxKGnAAfKFegHCwYQEuW0AXFq8Sgn4RP9Dbqb2LBG
         AvMVTBsom9cU/1XCMJATt3eYj28c2OnuSL+6uZ5UQfa5GoR8EJCfkuuQbFzkReB4tR1z
         J2QXE7qYNKeD4JrJAROildvH4URwppS6nxn7Jg9nuCKU8hhQ6aD3fZ21ZZUOHuiaAPxk
         SA/w==
X-Gm-Message-State: AOJu0Ywk00hReeyCcfDV/ky8Mewlcchz+aEN9y7TejqUuChF3otyTico
	PXm3V4kmd2TPbiOWVO6nRR8Krr0LfNr4Qh05bu3BPM9zdnGgzYmUarBadKvmDHUi6h49PwKMDL6
	P+9+27pk=
X-Gm-Gg: AZuq6aK/4PKsDu4gDiXjnA0nqcTB3fClXTdVC+3J4IamEhs9IxGuOmelA08Ra4FBb6A
	hqekc6y4NBQ85UE77xa3BDQaB8qnMFEt6ZDkvHHDdejRT9amnx/08UTAAPKQY5VYD7QBHcjqZQo
	qNV9k/x12cTulkXGTShWtRZBTBN8t5POpv4UzaG1RkZj8MifhY7Y9t9XUedVg/laJd5EmHVOXPe
	/gd6GUPKSplMIQfVnZi9/B2NcJOGpMNr7j6VeZI3HMU9zAQvdm1WX8GvfMa7OcDhrAv5+MBE7My
	7A/RzPgTas5UyPVLeIXlIIHZLE9z034CNwKLpGruq76Rabowrt7Kn4r8ojxB91Zu0LZddEhS2Hr
	Ei4V3m5ey97aQlXRmw4jl7GHrxdM+ovh79skgH1HD402OtxZ8YZqYN5cIkmORZsZJceKGRxQKID
	wulcTxM199xLJL8dTk2hK2gTk1LveayPputvo4b360fPirSnTCaxB7g0ldFVIztTsiLlYVeQ==
X-Received: by 2002:a05:6808:80b3:b0:45c:9973:c539 with SMTP id 5614622812f47-45eb1d49f19mr1343369b6e.26.1769168911019;
        Fri, 23 Jan 2026 03:48:31 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45eb4255785sm1133580b6e.19.2026.01.23.03.48.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jan 2026 03:48:30 -0800 (PST)
Message-ID: <40479c6a-b214-47ea-a777-f600cfa03acc@kernel.dk>
Date: Fri, 23 Jan 2026 04:48:29 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.19-rc7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11896-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.997];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D17A475644
X-Rspamd-Action: no action

Hi Linus,

A few fixes for io_uring that should go into this release. This pull
request contains:

- Fix for a potential leak of an iovec, if a specific cleanup path is
  used and the rw_cache is full at the time of the call.

- Fix for a regression added in this cycle, where waitid should be using
  prober release/acquire semantics for updating the wait queue head.

- Check for the cancelation bit being set for every work item processed
  by io-wq, not just at the start of the loop. Has no real practical
  implications other than to shut up syzbot doing crazy things that
  grossly overload a system, hence slowing down ring exit.

- A few selftest additions, updating the mini_liburing that selftests
  use.

Please pull!


The following changes since commit da579f05ef0faada3559e7faddf761c75cdf85e1:

  io_uring: move local task_work in exit cancel loop (2026-01-14 10:18:19 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.19-20260122

for you to fetch changes up to 145e0074392587606aa5df353d0e761f0b8357d5:

  selftests/io_uring: support NO_SQARRAY in miniliburing (2026-01-21 07:55:13 -0700)

----------------------------------------------------------------
io_uring-6.19-20260122

----------------------------------------------------------------
Jens Axboe (3):
      io_uring/rw: free potentially allocated iovec on cache put failure
      io_uring/waitid: fix KCSAN warning on io_waitid->head
      io_uring/io-wq: check IO_WQ_BIT_EXIT inside work run loop

Pavel Begunkov (2):
      selftests/io_uring: add io_uring_queue_init_params
      selftests/io_uring: support NO_SQARRAY in miniliburing

 io_uring/io-wq.c                       |  2 +-
 io_uring/rw.c                          | 15 ++++++---
 io_uring/waitid.c                      |  6 ++--
 tools/include/io_uring/mini_liburing.h | 59 +++++++++++++++++++++++++---------
 4 files changed, 59 insertions(+), 23 deletions(-)

-- 
Jens Axboe


