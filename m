Return-Path: <io-uring+bounces-11871-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MFxODFFScWkKCQAAu9opvQ
	(envelope-from <io-uring+bounces-11871-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 23:25:21 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id DE9075EC20
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 23:25:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D1B0C705B01
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 22:23:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4DD9352947;
	Wed, 21 Jan 2026 22:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kFVFi/2g"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB203559D3
	for <io-uring@vger.kernel.org>; Wed, 21 Jan 2026 22:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769034211; cv=none; b=oxkVHAHAvkS7fu3Jbth4JVWN6/M8LEBecjebpXCzrBYaWJo4VEQqcrsXv0a9KE9a3j37qiRER7Tz4Pj20Bz+ZHMaAYnxK+V6BuqSd685GAQvosR7HhC1qtrfJqdouwmuXd33KcBI1MAlMzk467mCwz48FIeL/uTwh0xC6GBp1Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769034211; c=relaxed/simple;
	bh=1u7qHImS7x9muE4tO7sCZtCx6y59RsJTG4QJ/Ow2TIA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cvnTnUlLk29NArbdX4NK1Gic+gMvHvtxdVa8kLGFlyV1tHZHrLwol3nuJicRVWSP57r+gnweWjdUOgxW/mNPtYuD05M98Kq3Y2jQIsG6THVkyqwMhjrw/baR6Pk5Xyip5KZt6qXLJGyRxW6JTRFzmjGmB8IpRPcMfFK82lr4MEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kFVFi/2g; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-4358fb60802so168757f8f.1
        for <io-uring@vger.kernel.org>; Wed, 21 Jan 2026 14:23:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769034208; x=1769639008; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3R7TYovmwRdJZ/XHrKqR+mCofGQPSHqrkmplBw+mAl8=;
        b=kFVFi/2gF0LSa5IQ5VYUzrPf9h16usTyvR0gR3Q0NaRjxNRk1f/F53teC+vBLmhWon
         u9oVPXsjHiFibA461JYQVjBUBZAsVMiGeZ93Wu8EwH2P9o3tmjP6VD1eOnWGsRqIUfUT
         Llparsi7QWKpgKaZjft0ivFCZAnzhMLA5kQFCrLWHAxOs0IL0F90yw3E0qSLU8de2QRC
         3fuAKZXaPkR+BZjGy8kN52CFUemYhAWQ950aCxA1MIgkDdXRUskOpveMaQ9va0QQKK9W
         mxuJDaGwda8+feVrjM5BNQuCwKK6eXqDnuGOJ7wHLuIUZ1XFi6Xip72dg0r8rAaFJ5MB
         jL/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769034208; x=1769639008;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3R7TYovmwRdJZ/XHrKqR+mCofGQPSHqrkmplBw+mAl8=;
        b=FRh8+5dS/V++HrmnqFHl+Ku4qcQH8SpXBXGJ4xXbMN2wqnk1UNxK20DY6k66rLle81
         30DPB4SODUPK5FajzMGO/KJgddpuodWrSUMqM7olYiQpHMz8zoxi763lxXcV1x8uwH9M
         53dcBU1SrtYX2q6CeEAN2Oo8QMqzKmxib01mw4zNiNOHKPCFbrKnFm4i8SsE4E/no6N1
         8kQXmOTuESumkC7UtZHRYtYY4aYu8Dvs9QC7AHT8wxhYcWaaSMU0l8PN1tmFcBUFBPlE
         Pll52dFINWJewohcg21u5rQMq1eSh4vhIWSi5ZhuKDSNMJ5NuAUMPFCHh09tWrRj1N0a
         jqfg==
X-Gm-Message-State: AOJu0Yx+6muoFtSYLH9LDTocD3jB+vb8WCFC5thhGAAX3npsvryk6NSv
	ljopw2QF38TJLcy8CBL67OVxvP8ee1nYzFc5JY8KokBwqv5X0LWPH1+G0IET2Eht
X-Gm-Gg: AZuq6aIBWSLyi0wlKHv8bOfZNicag+mLCi9/yXLfmbpp/YP1rVfUkSWbrEKxX6OHUCv
	CDEI4l4J7N5NxXcsrDKs7oZIGLvxTRnO6492F30gDCXloXtlPNJEJQF6vQUw7XHsouOTwzZAaSC
	ZkbBKNHL0BQMuGW8+k05e2nyhgXuMus7IGQtWF3HTb/ZAwAHBEVHfPcgmFcz5S6qRIAo0TTrONs
	kMxV6j6eV1pyvLoqSxFHCqDJd9TaxySXBEvBxWMMHSindgKCtczfYx//qLlpCYS0CLabJ2N49Rt
	nBfZ7s+vsfXLKmMBLxAybIQ5lM+SiMofpvK4QV8Wx18lGWRT/3mZFKhJutgVls/O7k702Qg98GZ
	YgZHjutafGAfD4syQcHWodE7YXlI6jQgAX4HzWaMlDvXkVt+AYxH+PYQlRa1LS5cp+CP9m6jtiX
	G2ln09hcYVNOg8/y/rIm5r1mH+dONFumvyd7SMxkIujz1Z/qD89Qa1/QQZfRrtluXSCWIswJoJY
	E7V3vW6nSX4LfYr5A==
X-Received: by 2002:adf:f812:0:b0:435:9e32:2b85 with SMTP id ffacd0b85a97d-435a5ff993cmr1366806f8f.29.1769034207905;
        Wed, 21 Jan 2026 14:23:27 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43569921da2sm40011103f8f.1.2026.01.21.14.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 14:23:27 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH liburing 0/2] Add support for IORING_SETUP_SQ_REWIND
Date: Wed, 21 Jan 2026 22:23:20 +0000
Message-ID: <cover.1769034107.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DMARC_POLICY_ALLOW(0.00)[gmail.com,none];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11871-lists,io-uring=lfdr.de];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns]
X-Rspamd-Queue-Id: DE9075EC20
X-Rspamd-Action: no action

Add liburing support and tests for IORING_SETUP_SQ_REWIND.

Pavel Begunkov (2):
  src/queue: Add support for non circular SQ
  tests: add SETUP_SQ_REWIND tests

 src/include/liburing.h          |  5 ++++-
 src/include/liburing/io_uring.h | 12 ++++++++++++
 src/queue.c                     |  5 +++++
 test/test.h                     |  2 ++
 4 files changed, 23 insertions(+), 1 deletion(-)

-- 
2.52.0


