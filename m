Return-Path: <io-uring+bounces-12232-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OBuHEfldkmmUtQEAu9opvQ
	(envelope-from <io-uring+bounces-12232-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 00:59:53 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id BD43C140614
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 00:59:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0B1F43007651
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 23:55:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5262C2459E7;
	Sun, 15 Feb 2026 23:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ez32T83i"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09221B7F4
	for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 23:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771199738; cv=none; b=pDBU5ykcT7NyDs/wu0bzraORNDFvXv7fjN5OfNqEGgcPuwk0zUIpP4goiZ2iwToZhPyOL3R+lxE/kBWmb9QMTTSki97q7UMdupJzlc1rC7HRoFyF5QDxnePJBySc2uhyZ0tVdMSVyfiKOSAxtQtYmouitvEm0LPcvQc2aWaro5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771199738; c=relaxed/simple;
	bh=V0x7wLJBYX0nfkloMBXf+o/1FfHEEmv2FiqrcH7dqCw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=bAgoeygup6XcRURkNc9cY+/+C01MI9okf23m5nOcvF9YSDqU6tDtiZIRSVff/UJJ+IuUiJ3E5fCOVAzs+1FUtqDy5hktAdqicSibAaJXSJ959zYDfUgmS1zZ316THhctmRKeLUrbP1pz/MnWCHI60Ag1BEAmCFPSQ3Vdh3KAR8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ez32T83i; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7d196a2334fso2289576a34.1
        for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 15:55:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771199736; x=1771804536; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2uBqQkcSBi0YUCOpfN/PM+qfkZpXtOfWMA026z/TM64=;
        b=ez32T83iYsrTIigvjssJGahiZqCDfnz3M+4sS9zSNqcq0TLRR8bs2etYAlr5bMDmxb
         aGLVDrOWBPVFLosFF+JpNM+HsOEdXzvYuYsBgMxRmxLSzJLT/KqVJ6lnnH8v/TPhHRKt
         ALfyEx8QJBuFUR3f8iWprJRmYYdz6hXH+8YgpOGYiWzMp45YYlUdmnc0uM5HhyZzk6/j
         OzBegJY92xF8Vl9aM8QYM/6mdxChkS/FJohBG9w2vgaV6L8x3U6PRooMJ5W9wI1CAKEK
         5T7PztFwMNjbKdqLhaFK31onORqoh2ABOSwImYmtXI1VTTEdcIMZ9fcPGCUP2BO9gH5a
         a7WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771199736; x=1771804536;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2uBqQkcSBi0YUCOpfN/PM+qfkZpXtOfWMA026z/TM64=;
        b=tAG6imN3cn8V01PCZpZK5duLubSrDJd+keG2iDutV5nXFFPpLKCp3ADXtcYKrUHVFZ
         dzHK5p0hFngNbpmi5gT7YHtEgvim72r7vj6kjChes4D2vXvnTshTDGXwYIvQzux8VFwU
         1WNzYMPD7ebEhGBsDYMWNRz48x/uDlEj3cliuh3Vi3YPfC5npiPf2FTs0SYtYJ5TFJsv
         S6YCSMdPAiN/zXA7AOi4VrN72+/ApROK77FpY60vYtKN24niJINClupQb6i0ZCgfVU1q
         taNGmghTm2RpuuhawCM2dbVbsw2yVNJXRXrgn5OBEfkLMFOpsh/dS+4WNfj33f+HUnpA
         SVJA==
X-Gm-Message-State: AOJu0YzZIMOjja/hDzb0mU2Zr6KLYfptYq5XBbm5cnGB6vdkFRdZ/WFy
	3j61yPO7hes7/NvepBGd7rOeQmfsyvXtsTyPZMgYZHzIdirZ5/hmDund9QDdz2y6Byw=
X-Gm-Gg: AZuq6aL1Rd2f9lR8aUzeKMKik9aZ6aW+ibCvSkL1BqYh3QbDI7uGLNWW3LGiip8rmvp
	NG9URwwrRWJEvbsd/fNRm7R6PKqczyzesZF5Va62m6/gylklMCWJ0XF5Do4uXOdDcE7NEEuiogy
	v1KUIT9K7dbAbCaBTdUIByP8LJCoStPm16elYAPrWdefb+NQnxZh8P/TQ1M/wk6vC25DFLW5mTZ
	DiK/aU8OgbF+Mz4G9OEdw+xK6fQEVfYU7XUn3PeFjvTwXAT6z8q9UBXtaoDwY6SYXqxZ7Ug/XrO
	OHaF6q3ydc83e6lANpD0OIbELQ33F79rVxBcrVjJRY6vP2smNtR5COmMXaOu5WI1hbyeB2uG+hm
	H/+FHlwxKxNtEq6U0ux7GLB8C5fcr5jB7oEa9BKh0yzCBwc+r4Xyhsu7poFam0d6hL4ESMVZPLS
	bl7KAKLVKakFlDpMMPq+3nGRl18N1eC3HwUQ13dvL9DrAYvdXqH7oX7EsrsjCMJKPXUTPP4EcyY
	u0d
X-Received: by 2002:a05:6830:811a:b0:7d1:5253:a0b6 with SMTP id 46e09a7af769-7d4cde099b3mr2414401a34.2.1771199735812;
        Sun, 15 Feb 2026 15:55:35 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d4d1e6ff70sm4768576a34.16.2026.02.15.15.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Feb 2026 15:55:35 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc: io-uring Mailing List <io-uring@vger.kernel.org>, 
 GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>, 
 Christian Mazakas <christian.mazakas@gmail.com>
In-Reply-To: <20260215181612.1941963-1-ammarfaizi2@gnuweeb.org>
References: <20260215181612.1941963-1-ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH liburing] github: Upgrade clang version to 22
Message-Id: <177119973472.87571.2616828602372853475.b4-ty@kernel.dk>
Date: Sun, 15 Feb 2026 16:55:34 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-12232-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,vger.gnuweeb.org,gmail.com];
	RCPT_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim,kernel.dk:mid]
X-Rspamd-Queue-Id: BD43C140614
X-Rspamd-Action: no action


On Mon, 16 Feb 2026 01:16:12 +0700, Ammar Faizi wrote:
> Commit 5cb44fe56b58 ("workflows/build.yml: install default ubuntu-24.04
> clang") downgraded the CI to the Ubuntu 24.04 default Clang (v18). As
> noted by @cmazakas, it was because it broke bindgen.
> 
> @cmazakas recently confirmed that Clang 22 does not suffer from this
> bindgen incompatibility. Therefore, upgrade the environment to Clang 22
> to gain access to the latest static analysis tooling.
> 
> [...]

Applied, thanks!

[1/1] github: Upgrade clang version to 22
      commit: fa9896fa9371e661ff158328d8c5dd906fe8cdac

Best regards,
-- 
Jens Axboe




