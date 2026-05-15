Return-Path: <io-uring+bounces-13357-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oHiFGw0sB2oLsgIAu9opvQ
	(envelope-from <io-uring+bounces-13357-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 16:22:05 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C1EC75514B8
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 16:22:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A7635305C5B7
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 14:16:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2587E33D509;
	Fri, 15 May 2026 14:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="ga7tGuFr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCFB31A56D
	for <io-uring@vger.kernel.org>; Fri, 15 May 2026 14:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778854607; cv=none; b=c3LjohGaRGVWveuSKuvZ4OqHHEtagGg4TckgAAMjNk6ncPxq0mv2cVgcfH9cE7YY/eNd+oyXczN/aeRD1v6kDAjp4ANNINzo0sn7uGt17zhxEzmfan+kOIEZnFNgNbQZNrp5WQoLRsZ9V7T7bOfNLXIWYKmJVvIF4ai8PEl+Ym4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778854607; c=relaxed/simple;
	bh=2ZS3CAN32CjNaiu8pkxXRDT48dK9Sl4x2deRUyr3oVE=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=aVF85TWIungZXAK8WKUfQdIc3J1XwCcf+WmkxtjNzfNy9QF85ty/UT4bPwZbooAaOMakQxkXfA4fQhTeqMBkLEF9nia9E9wsAsBwJCi7ILGaSolSDAMByhKV52LqiH2XSDvCEJEBHfoOptML6cIOG77KK/eq11PJLjdk8E1WBbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=ga7tGuFr; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-439712b3416so1965808fac.2
        for <io-uring@vger.kernel.org>; Fri, 15 May 2026 07:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778854604; x=1779459404; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YXP0NV7BM3az27AA8iiG15iWGqlRf3+iDSOjMzVbmxs=;
        b=ga7tGuFrD4vHH5AqFlIs5BhRpCPFwoAvHD/0sloSvtbQcTLR/mlRZI010jImxoySYX
         ryx8eHpVIWubTMFCRhATvQUAGyBcdQZC+7d66BMaLOG1J6FTBc0DkfGje1q8SLVbYk+Z
         R9XtOWM7HzDiU6W0V+PME1BwfJt/QKuanBHLxcUP2qiqLy7r5IWwSG/xH2bDCTy6PnwG
         j0TUHAUrwT/QJjP/e7ZyOMSqd4yYVMqRSWVXLxxQDi8spl+ebyXli2T8zMHr3hstZXF9
         nEFLgKIYK5tF8//Vl6H8W/Prann8jR4dPQgbcUwJuV2hK361mRNZIvGAp4bb8x0BFNSe
         XtpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778854604; x=1779459404;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YXP0NV7BM3az27AA8iiG15iWGqlRf3+iDSOjMzVbmxs=;
        b=CwnF07+hT1gQGu7JwilPPTx4by7U0kLyMLpJAt5ayqrgmO4T40vdCCqpAu3y5MEOey
         vYEbWtNmX8OfUyUvit22u9e4XfhmdbRBzZTCl0UPMx/j0/LMFlxflxfJCXSMTq+RDmA0
         ZdWrNENFuDE03mNWpsJrX23t6BYXrYTf06+SOcwNehcmWlmnnq/l2zpo6uSh1KM6mTjb
         UsHOJj/y7jWoNYPJmykWDEpzvf5PXiNSPTl4ivS9bssvTxo+Cz9CIAOE2cH2jqKKNdQv
         z+G0gISyQwJX+sraZfv3KUrM9yfpXZqqPYIVVL3cw5SxymW4bi8JitKvvR+QIUiS4cRV
         6gow==
X-Gm-Message-State: AOJu0YxrEuB6VRGL02VDBENlqRW/Xe5oCYh9I7t0PpLAokIIPNO/TrxW
	dko4bBlCJep391w1kx5XFtoU9VyOLgmflZTDrGpdDGWysPRFvrEeKEKIR8wbqV3p2C8p3+iOW4Y
	1XUfZ
X-Gm-Gg: Acq92OGYItcUF5xGWSGC/0saAFICRhzcm1jV/BKL79LJfS940zq48sbwqEqogT56bkA
	2+rNWtbwP0DzDd1yLgng0gxZ0fSyBNZn4YKjzxFJTpL6oBq9uRh0+UXb7ORzkRKPV9Hx0uJPfmV
	Qw0am8oOXFSqEaa/bbTWMcx5/8G1XweFeYg74qweE5Sb5bb+hK0VV4jyj7T66ekjSQAbZUs2z98
	TZL0v3SYmqrra3NP1za1tllcjEbsocxdWTFjfzY0t6z9lBvsRDgLGPG7niLXDcGi6toAn5CUr6C
	RtD+BnbJ37wJlqYvToNj/e9jVUJKwAeio2LK+Fg6I4kNYj3aunr1MZW2k3hCVUFB/xlHjBysjHT
	osqPw2DUFpokRYn1/CzIaRgf6BzE32kWbEebju85435bASn9dQo7RKqqMX2ozw5dW7YFdtjiKMP
	L6KzDYRapEhQXcKt4ol5sE/wrGqIojtBtY898+8d393AOe4J4595yW9Yo1rSWpn5JpDwxMAOKWx
	DQoMuVf0xOCPZ4hS+g=
X-Received: by 2002:a05:6870:fb92:b0:41c:fdd7:5b4d with SMTP id 586e51a60fabf-43a2dce18a4mr2666833fac.19.1778854603661;
        Fri, 15 May 2026 07:16:43 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-439fc53f2acsm4295891fac.14.2026.05.15.07.16.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2026 07:16:42 -0700 (PDT)
Message-ID: <52144dd5-f3a8-4a82-b048-36b53518c9c3@kernel.dk>
Date: Fri, 15 May 2026 08:16:41 -0600
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
Subject: [GIT PULL] io_uring fixes for 7.1-rc4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C1EC75514B8
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13357-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Action: no action

Hi Linus,

Set of fixes for io_uring that should get applied to the 7.1 kernel
release. This pull request contains:

- Small series sanitizing the locking done for either modifying or
  reading a chain of requests.

- If the application has a pid namespace, ensure that the sqthread pid
  is correctly printed in fdinfo.

- Fix for a hashing issue in the io-wq thread pool, which could lead to
  a use-after-free.

- Kill dead argument from io_prep_rw_pi().

- Fix for a missed validation of the CQ ring head, affecting CQE refill.

Please pull!


The following changes since commit 45d2b37a37ab98484693533496395c610a2cab96:

  io_uring/wait: honour caller's time namespace for IORING_ENTER_ABS_TIMER (2026-05-06 04:58:56 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.1-20260515

for you to fetch changes up to f44d38a31f1802b7222adaea9ee69f9d280f698a:

  io_uring: validate user-controlled cq.head in io_cqe_cache_refill() (2026-05-13 21:44:57 -0600)

----------------------------------------------------------------
io_uring-7.1-20260515

----------------------------------------------------------------
Jens Axboe (3):
      io_uring: hold uring_lock when walking link chain in io_wq_free_work()
      io_uring: defer linked-timeout chain splice out of hrtimer context
      io_uring: hold uring_lock across io_kill_timeouts() in cancel path

Maoyi Xie (1):
      io_uring/fdinfo: translate SqThread PID through caller's pid_ns

Nicholas Carlini (1):
      io-wq: check that the predecessor is hashed in io_wq_remove_pending()

Yang Xiuwei (1):
      io_uring/rw: drop unused attr_type_mask from io_prep_rw_pi()

Zizhi Wo (1):
      io_uring: validate user-controlled cq.head in io_cqe_cache_refill()

 io_uring/cancel.c   |  2 +-
 io_uring/fdinfo.c   |  3 ++-
 io_uring/io-wq.c    |  3 ++-
 io_uring/io_uring.c | 29 +++++++++++++++++++++++------
 io_uring/rw.c       |  4 ++--
 io_uring/timeout.c  | 16 ++++++++++++++--
 6 files changed, 44 insertions(+), 13 deletions(-)

-- 
Jens Axboe


