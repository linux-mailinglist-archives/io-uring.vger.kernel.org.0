Return-Path: <io-uring+bounces-13078-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qMMFNFiE52m+9gEAu9opvQ
	(envelope-from <io-uring+bounces-13078-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 16:06:16 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 349F943BBE6
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 16:06:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 85B68305BA95
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 13:56:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8478388E6A;
	Tue, 21 Apr 2026 13:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="uiCB17kd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209DC2D9EC2
	for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 13:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776779791; cv=none; b=mI1/S/MuFLSeHw69TCpJSYdm/cSeKRPplng4SbBkEivYMNrr8eF6lESaXLz9UfyCUCNQqGj2N4fp6zRxr5OLOocnMFvvdBx6wrSs9T0KYGy7pytttGTDlhVud2mzW26/D9pyZsvB6DKTrd1UCJvavXKx5Aw019A3KhYrA7T0lzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776779791; c=relaxed/simple;
	bh=GSbk5VdwZAM79AlMeGjfbPx2vl4AVWT3VBjOe6OyMkU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ihK5OUmVG5SS7uMoMwS1naU2M56A7w+Qf54Tb+WyYj7/IXV8BnJ2ibCC6XCMCKAXuNEHs+l8XOshW0/NccX18uT/yl10pLw3RPcHUxtWUQjErQLsJCSGQzcQ0sbdiRRCb0n1Qlfv/zPLfOGXlgsPKqxp0Pp429Iw0qt2FHJ3mtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=uiCB17kd; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-40946982a78so1431870fac.2
        for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 06:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776779789; x=1777384589; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=KgsTTvhuZyYbTWwId7JLygOCGSvOanjt2xaoeErqvrQ=;
        b=uiCB17kdZucGjawqoj+KPqFe10UkjybeDSf2IpaYCRvCuZEn2wakBHK+wBq9o4K+6N
         IV77NYwjCJ9c/FgJAzsK+eZXHe7VsYR6wm64J+rojgWwKQ6HhNC4sHLi29L4SwaWzlRJ
         7gYwmmhFxMSxd7+dVe64NBaWI5vvySxgTVG4H5xZ+qo+VwG4i1BYADhvE1SFblfg9eMJ
         2uWYTy2rk5ksIENcbrOO0IOOWrxN1Mb+/iDhPtgN15CT0whk3B886XfwekaZBpAzPgqL
         BMyHAsdszsAFrCsniE9XIQIfmp4Hxz06EuwMDf1hv+BQ4fsMqDHqaqw8+v6g5LT8/BnK
         LU5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776779789; x=1777384589;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KgsTTvhuZyYbTWwId7JLygOCGSvOanjt2xaoeErqvrQ=;
        b=Jw4yInkCJ8Eih7rMh1qVKkXBzOsZbm2PtimHe8Vt8uzINSS/i4cvU7lvK733H6Bgy5
         TpwTfKGOVtTgo81sdo94M1U4cZFJYHVoTVkxgZ1tvf6UzWgJWMXMJ+YGSUrcuZuSf1XW
         zqf9us/Pl8nvqEh9OBme0dH6tB27DS1Wm223NtUfF7ajZ+2wsgg37pQ1XCkCQVCmn1ZQ
         4JVmDNf6BDmCBvn+JmR9Dye94kVE7wKNxsSNn80tHRoVb2chC0sI1WWv4ZtCOkWsoAx1
         ybQOOdMZPZCsK3IS6TlDaqKKcTwvuR/x6yaH3Ln1ovWw1IV8R/UuxfboqB8LTnbx++EJ
         djiA==
X-Gm-Message-State: AOJu0YwW0R98Kj9fww7Cyfij9eWH2LrwvsNVJmpsZlNhNUKe5L4aAMHF
	pAupXO8IvNCMTlSMcr4DIRyU8VKaii5iEUH03Lv95TOsrdlErUe7q/t3kzpOjMDEWh1w6WYbb7l
	bMXSaGVM=
X-Gm-Gg: AeBDieusdTZuXKHiqObMoEKnQfrtvL04pr8X7MWHJRgObEKAElJABYQVTHSRwspmAX+
	5ahEOOlFQp/FxGL+ZycF6zZvkCjAxO2JrqujGSTkybkDDIq26yrMJxKPmnoIhiDD5KVZkLsuSHy
	ubA5uxiBbgujpuwLlnm+xXSXTZ15ctRfWxGDz3f/PYaYw1ArhI78D/XxoM89cg91CwiSzb/hPm0
	mUllII4ECOwcjJylVAOcZDjlcpPDd64KoRK+7RGGkv2mVInfzZAxlyyN+zeNndJqeKjv2a1KRYQ
	a/b+nB/M/sNCUbZDnXax7lVYZjhG2vbagST89pkMOhT7APzDPpmYvmhawkK3WscfIZAZANFnwaA
	4OF9YddSAxS3bXg0Iqdt9/VGpYOxksReI7hZEC6L4zQDvFqACW1KJi/eAGsRPYHuWfhiQlAFZNV
	rgT2HeY1kaCMkCzbx+u3KZ2YmS739T7jodYRSD6mR2WlKV56PuHHE8Hogfb42/xBmil9lhDMMYq
	WT3LfQ=
X-Received: by 2002:a05:6870:d91:b0:417:3260:8586 with SMTP id 586e51a60fabf-42adede6712mr10142319fac.34.1776779788557;
        Tue, 21 Apr 2026 06:56:28 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-42b8fe2c52bsm11756474fac.0.2026.04.21.06.56.27
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 06:56:28 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET 0/6] Various bug fixes
Date: Tue, 21 Apr 2026 07:51:37 -0600
Message-ID: <20260421135626.581917-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DMARC_NA(0.00)[kernel.dk];
	TAGGED_FROM(0.00)[bounces-13078-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 349F943BBE6
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi,

A random bag of fixes and cleanups. In detail:

- Patch 1, defensive cleanup for a patch merged in this merge window.
  Not reachable, but it's confusing and should get cleaned up.

- Patch 2, spectre masking for file updates.

- Patch 3, defensive cleanup for the imu cache, using kvfree()
  consistently. Idea being that it'd be easy to mess this up in the
  future if caching changes.

- Patch 4, more defensive cleanups, just hardening ensuring that
  only >= 0 is passed in for bytes consumed for the kbuf path.

- Patch 5, actual fix for futex, where multiple partial wakeups would
  end up waking the same queue multiple times, rather than moving on
  to the next one.

- Patch 6, actual fix for ring resizing with CQE32/SQE128 and pending
  entries in the SQ or CQ rings.

 io_uring/alloc_cache.h |  2 +-
 io_uring/futex.c       |  4 +++-
 io_uring/io_uring.c    |  3 ++-
 io_uring/register.c    | 36 ++++++++++++++++++++++++++++--------
 io_uring/rsrc.c        |  5 ++++-
 io_uring/rsrc.h        |  9 +++++++--
 io_uring/rw.c          |  4 ++--
 7 files changed, 47 insertions(+), 16 deletions(-)

-- 
Jens Axboe



