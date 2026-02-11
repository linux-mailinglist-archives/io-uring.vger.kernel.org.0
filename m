Return-Path: <io-uring+bounces-12156-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OFT2MQ2bjGlkrgAAu9opvQ
	(envelope-from <io-uring+bounces-12156-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 16:06:53 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 45C7D1256EC
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 16:06:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D979330268A3
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 15:06:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3301224397A;
	Wed, 11 Feb 2026 15:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="iBDnVmA4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB55D1DF980
	for <io-uring@vger.kernel.org>; Wed, 11 Feb 2026 15:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770822393; cv=none; b=Uixsto3PvYk8d2cepgUhqsvqhjUTwVGSXy++x5lqXiO2zBRbI/jzOxwAUNwUHQKAJ/Lc4CBMZBt61m6tD+TD5QO9WACLnbC1VkwOoR+T3RA31tAX8EsfqZR76jlg0TwF8L/kZ3Ru/7RZjGcMsJNmxYvRgLE7SB/dgtSKOs2cj8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770822393; c=relaxed/simple;
	bh=vqUgzeBGphbWscnLiGMMp+Ll5Vp9310ge1UFbsr2GsM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gwnExkR28ugs5o05D/J4c6PrRzZ2RlKvxtUV8Z5Dnzi39o87zMQMMNd4Stc/5XGyu6x6EakjVTUCtg6Bkwu18DANrhH5Kx9eUXG3d3UiHueKxYlSFNd+eh3m4Y0i541CkTT2XD+Qq9s7/ai2jG2H7DY7EA+8XyPygSb98aO5f7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=iBDnVmA4; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-45f04f1348cso3437949b6e.1
        for <io-uring@vger.kernel.org>; Wed, 11 Feb 2026 07:06:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770822389; x=1771427189; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zI8R76tRAizCYBV08Iw9JV2oSM2l9MroeSbZuX5v43Q=;
        b=iBDnVmA4hHwExoKsIHjmOTEwx55Vh89jFjma9LYd/zzwAkUSNI6OevsTv+jwGjxuAx
         8adOfgduErDohENbq57gWnodCc+LBmBzkeRt9CoTlJD6R+IMer5rwiXL5fNtOamd9Bqa
         pOu3NfX9tU3I45Xe9/zUAr7SWK6KdU74sBC30M1oDaNqVoe9SRO0PQOM9idZ/Rnl0TQV
         py5IJ3jBOBywE9WwiNGWY+9aMLJ+TKkA33BCz6nXOed1w/BN/XkG+T012Sp/qbO6ceTg
         aXWmWHkTZw3lpRelWgKSoDwl6Z9Yj9/j9Rf2ZC48q9/oVD3W2Hfenr3mvqqAT38wvk9F
         gIWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770822389; x=1771427189;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zI8R76tRAizCYBV08Iw9JV2oSM2l9MroeSbZuX5v43Q=;
        b=u2kL5SaQDApL1hXsrT6cjIiDBmA7yrThH7hVP5jF0/FI7IU2duiRnDw1TToIDJv9gC
         jfn1kvkXwb+/76GQUeIeuVj+bR2qT8Krot9ykg+9LE9dDH73a+fPtTbrGFiFpNJHs2xE
         OLVjniTygyuy7qr+1aphupxybgwO2VAm5K7QHom2qFyqzEANyAsRdAq+1Hh8aQU8W77R
         I8nZkHtC/2hW7DOh9499TiUK3BWWaKu4RYtDhfkH44b2fPTHfclCMOtoYs310Y+Bm+bz
         ExCiJc3Lp8mpODa/dnoUVvS1pb27BxwEJU8/oKILbZulPc09OJJ4xZ2VKrF73lWBQ9MO
         TsdA==
X-Gm-Message-State: AOJu0YwuCK57ExTXjt24Fe3c6id/6ShyuzLwhYgeZ/AjavLzDe3KHK/l
	pbSavWQHzpYcWc0KSHe98mOKlARDB6u9XSfStNHEbwhYXbo4ja08OsIQwf8q8mGqe14aRI5Caih
	uFgzetSo=
X-Gm-Gg: AZuq6aJCQ6wx6bVnnxhGTmnRYvYGgNtC/xnTdBaULb+c8jl4Voo02+OPCKRlashatQh
	gk3zSGhCJe2dDhOJuQrbUwIA6ysh5Tel7a7aAqLl5hqjMH8yAnkb6A452Lw+Ht5X6hgpEaeQS0z
	cdq/qVxxTvXEoYSJ9yq/7e4cAZOSxRy9stLprTO1l6bwqlBnW3NFrArVzCXQ36kWbdDTNiSC70N
	hQKOSJKnVwGzZ3NAkKQiViPWtaXYlHQioZHeHi/QWmWftDt+cX3RI2GHEUOV5zGcpvavU1QfGij
	H0S46qIXAHEo5426QmAT0ZklZnAGTwtL5tGlxFGKWxMzZES5tqsq8ruujt0qPWXhevXJDje4bJN
	C/jkEG0PKgbpO6Z0972BUmQ6iiVUC7/Ja76eXbCLCDOgPZg6+h1NbzJGoT8kEXIoBlhHanN9FSM
	TNZ5MWHCMgd4pltratrBOwISDg1WQ7p/rLKFTzQj9/i8/jQqV9zfmypqeKL1HAp9bkEXWr
X-Received: by 2002:a05:6808:1924:b0:45e:a52c:e4cd with SMTP id 5614622812f47-463664e06bdmr1577711b6e.27.1770822389227;
        Wed, 11 Feb 2026 07:06:29 -0800 (PST)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-40eaf16c383sm1462414fac.14.2026.02.11.07.06.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 07:06:28 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: brauner@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCHSET 0/2] cBPF filter API adjustment
Date: Wed, 11 Feb 2026 08:01:16 -0700
Message-ID: <20260211150626.136826-1-axboe@kernel.dk>
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
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12156-lists,io-uring=lfdr.de];
	PRECEDENCE_BULK(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_THREE(0.00)[3];
	TAGGED_RCPT(0.00)[io-uring];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 45C7D1256EC
X-Rspamd-Action: no action

Hi,

Christian brought up a good point on the API - what if the task and
kernel differ on what the payload size is for an opcode? Currently
there are two defined payloads, inside struct io_uring_bpf_ctx:

	struct {
		__u32	family;
		__u32	type;
		__u32	protocol;
	} socket;

	struct {
		__u64	flags;
		__u64	mode;
		__u64	resolve;
	} open;

and it could be a requirement that a filter exactly matches the payload
that the kernel uses, if extensions have been made on the kernel side.
Hence this small series updates the API slightly:

struct io_uring_bpf_filter adds a pdu_size field, which userspace can
set to the size if expects. For an OPENAT/OPENAT2 filter, that would
be sizeof(struct open) above. The kernel can validate that they match,
where the mismatch policy is controlled by userspace. See patch 2 for
details. In case of a mismatch that causes an error, the kernel side
pdu_size is copied back to userspace.

Patch 1 exposes the pdu_size by shoving the filtering and pdu_size
into the issue side definitions, and patch 2 implements the above
size checking.

The liburing master branch has been updated as well for this, as
copying back the pdu_size necessitates changing the API on that side.
Test cases and man pages are updated as well.

 include/uapi/linux/io_uring/bpf_filter.h |  8 ++-
 io_uring/bpf_filter.c                    | 82 ++++++++++++++++--------
 io_uring/opdef.c                         |  6 ++
 io_uring/opdef.h                         |  6 ++
 4 files changed, 74 insertions(+), 28 deletions(-)

-- 
Jens Axboe


