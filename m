Return-Path: <io-uring+bounces-11885-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gC/+HxZWcmkpiwAAu9opvQ
	(envelope-from <io-uring+bounces-11885-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 17:53:42 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 22F8E6A633
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 17:53:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5889230041FD
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 16:44:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A588633A9F4;
	Thu, 22 Jan 2026 16:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jCdaFvS6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3EA29A9FE
	for <io-uring@vger.kernel.org>; Thu, 22 Jan 2026 16:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769099079; cv=none; b=p0k/0Q0Eng9Tpr+XwZW73DZNtRjq03mWX9c5QkEKpU3otr7fg7e31r8A1czOppXbTeD2emxYiLlHh7+S8LpEq1rc9fsVqg1zwh27/6UcO2Y0Go8o+7fQjs8Bcy4xeg08D7Le42UM+WgNhQzrMH4n/e4CB+poDo3KVJgTauoNgrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769099079; c=relaxed/simple;
	bh=7HYATV2fIB2RdkktMTJT1A6QM5K1dOxZso8j0YpWQiQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=AVFIG61SnqqL85TqRtx8ZZ4wU0sdDfm0WVV330j4NUp0n5XYE6SeEz01U3ewUIh4dLoSxvJ9zSgLNhCNRthcVrKi4KcEk0VJ14BosMIha3Eos54TL86/6iUmrj/gb/qtRcd82jGmK52+P+MllHgIoK4EfUgKuscUvJi0QxRiZ98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jCdaFvS6; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-4043b27ddeaso355814fac.1
        for <io-uring@vger.kernel.org>; Thu, 22 Jan 2026 08:24:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769099067; x=1769703867; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=az180H+DGQXOwo1BiAsjWXjA1eFDu5dbYYAhKMqsYIw=;
        b=jCdaFvS6+QLyKLd5AAvDAZlgShF+Q6CDYLfFkVgNlT1hkPPkrcuGKwEEiVRiR8pjYC
         ymVbZyhUN6zNWFCRWXgGD5OLme7bwCLMB3L/a8QZ/SAb0+KJ4zC9mJFLgOuyKvfaaJGc
         aPkWum6o5y0o0TCANFimA1VWKH6vDImRz5BapUJXZG87Dqabu8DBR0K4fbtyD+VaRJL3
         b9zcFsThOLvTo7XMntlTbT/FJSTZgnCZ6Mt9u1VNYC0G9PFW7L99JcW34oZDRujIUJiX
         VZU5lwTIWQ6UcvKD9aZcayDREAUO9l9ocURm1gH7kGuHCXSJ3mo26oxisbNzK4iMBz9W
         JrzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769099067; x=1769703867;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=az180H+DGQXOwo1BiAsjWXjA1eFDu5dbYYAhKMqsYIw=;
        b=p/03ULisfqwE4lBd83r/aV0nulYylEAx6XVQDtDaamgW1T2BgFocbVX9A/fYPl/THt
         nuWINGu6/TvPRe9c3u4K4yQ5aaNVUbku78KposistAM7j7EAp3lBWPpY1XUaVzDZTj+3
         DeaCJMBuXHU7xY66M289fLpnYxNk0NFMJHc7i1dXFfLFteknnl1NVsJSBW53B+40rOzQ
         fVr47NcwAuq662Dl27dYG1g8h4nOJ1QWfjxRShnLsQZrTSqn/xYHL7yvJ8qrgfijrUAI
         BkR72LmkVjAtVQa0EW9KQvZG2ERlZ1jS8mpX7BdOsvImnvFcI5M4nOIh9Noglm5woU/a
         7zwg==
X-Gm-Message-State: AOJu0YwkZ+9dZOCUj1WC2DB6YdDpFxT4BNUtwkk2QLWnmXZa1zmZbjUD
	HW6vADQppjK8ju+ByoRbEinyVeo5GNwZP4IRUJtTN7Vt/I/Q0gkHtgh5eijyQZl8PaeE7FviSgI
	DDWpV/zA=
X-Gm-Gg: AZuq6aJG1zDy+zTodS0WWIPGuEt7oAM4auLU/C/JSuTDZwfe+ih2KnOMqlLKMa5HFmb
	/mmdlXClbr/6gVnvIGSI/btcHNB4/9oSJ8EUtPVtqsvUcd+GHbxdPW+lTyD4m8q8MYQav1WByqE
	nx9TVRwYv793TsA+yoLMsCdi7wgn4xoXvsOYb1hH/KFj57l7I9nhPhxc19GBmd1ytVl+qPhVJ80
	u8puQHzzBMs1wN7UI2La2HZeBiQnzY9aNiNTQEIDlQddcA1BMIU0iVAK/vG3QY0cyK4DyW/6CDx
	2mjOA+563Ycmwl+dUHsQi4PRnQcdUFYmNSnuj6JQjoft4R1KgC9AL4E3bhSLr/9VOQjx3V7vQOr
	32KxfwnSJlug1SMy7IpV8O27RsddXMxkGS1gy99tOjd1rsGMFvivzypS6P3qGXED9JaSE9yuprP
	xb5hkE7PJ9Xr2hWRCOHKkuSp8cHRBf7utdGmfP0TdIAh0iw5UkjRuhIrguFPB5Arv4Mg==
X-Received: by 2002:a05:6870:31b0:b0:3f1:4bb4:72f5 with SMTP id 586e51a60fabf-408ab7a5efemr46191fac.33.1769099067194;
        Thu, 22 Jan 2026 08:24:27 -0800 (PST)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4044bd14883sm13408105fac.12.2026.01.22.08.24.26
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 08:24:26 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET 0/2] Split out wait and task_work handling
Date: Thu, 22 Jan 2026 09:21:50 -0700
Message-ID: <20260122162424.353513-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-11885-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_ONE(0.00)[1];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: 22F8E6A633
X-Rspamd-Action: no action

Hi,

io_uring.c is still pretty massive, even after a bit of cancelation
refactoring in the 6.19 work. We can reasonably split out the wait
and task_work handling into separate files as well, bringing the file
from about 103k to about 84k. Outside of that, it makes the code
easier to reason about and navigate.

No functional changes in this series.

 io_uring/Makefile   |  14 +-
 io_uring/cancel.c   |   1 +
 io_uring/io_uring.c | 693 +-------------------------------------------
 io_uring/io_uring.h |  79 +----
 io_uring/tw.c       | 355 +++++++++++++++++++++++
 io_uring/tw.h       | 116 ++++++++
 io_uring/wait.c     | 308 ++++++++++++++++++++
 io_uring/wait.h     |  49 ++++
 8 files changed, 842 insertions(+), 773 deletions(-)

-- 
Jens Axboe


