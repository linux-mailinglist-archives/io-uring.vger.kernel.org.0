Return-Path: <io-uring+bounces-12378-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +LViEkVgnGnpFQQAu9opvQ
	(envelope-from <io-uring+bounces-12378-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 15:12:21 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B7082177D4A
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 15:12:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E7E353023E1D
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 14:12:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB197283C87;
	Mon, 23 Feb 2026 14:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OTNQsHq8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65DFE1F5846
	for <io-uring@vger.kernel.org>; Mon, 23 Feb 2026 14:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771855931; cv=none; b=pC5C6ERh/p1JkfiXi+6d52LFhFm4WH3dQNap4w61TZ5gECWAekagK2OF3UX4Kryh+Hf8Umc9QqRW0j7Ae/E/mkEALd6991/cisaNeNVEaLs5riqhRzy0oy3dE2TXKyi4LuIWMbclw6uvdaBU2BsuAjPa0MVb350JV2lI3nZP7/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771855931; c=relaxed/simple;
	bh=vPI0v9tLP4dA2zjPWRAwXIWEaY1tBckw+Sxflgn6aCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ikyi60qmPU6fdsoSqplfS/oM1W2j8lfc85ynCNl2jvTApQn/pAIUf9HZI6p8Io9oi3TZr7ETSyTJQkAcOKkCIy19kXuL1UfguMemDWOiivD0Uci5Ox0lxjRI2nu46r4uurtB9ogPdE2bN+IPpbuNxWnmFn4Rhn8R8x1VLfrAJ1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OTNQsHq8; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-48375f10628so27812055e9.1
        for <io-uring@vger.kernel.org>; Mon, 23 Feb 2026 06:12:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771855928; x=1772460728; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hAuNkcDjgRQes9ZoBfKfcmFmP/VU8bCoDmQ6evxgyE0=;
        b=OTNQsHq8oDtgsYTKRvYADaAalqpsLc8fvFVBwhlaFoHP1tCyfDU+7IyrvZhM2rH3Qo
         8Opb07ZQwP1CkGcM91EPU0keJ20IdyEJhIcQsllrJZa8JWhlpf0b4an17dTmil6afU0N
         TtSVVh3fE69IDU9ZlvvHKj7JSaYt5BsBwmiMNVfqAmoJI3/vZCcSiQNQ5BKtjb8A/ndJ
         Rv8SvJelXINx9M6dR7nrb+sGVzDMlbNHHGNF6z8IyJoaD9vGf/kGtomPJ7B066zEhZv+
         nBAn8EXW/0pHgADxlnIDO2FSc5Kx7PD//5fKPdRTWj1T9wCTlM9M5H2uu3+UxANpOb4K
         TYNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771855928; x=1772460728;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hAuNkcDjgRQes9ZoBfKfcmFmP/VU8bCoDmQ6evxgyE0=;
        b=Pi86okrABNwVMaHisy/0zIm3jVkxV0aW/0zRMoBEYL7EBs+soLtGps+qin722aLYce
         QElc5wRjVeYghVB5l6s1FzN39LVj/uouf/jTThmI1F6tTIWUN0RiiiTHVWfDmgIragTR
         QX3dz5Z/Qe+8vIGKVTEHan7fe8fNoFxoMpTGbMg0++/7qzK+lR68YCixtN1Uj1EvRnth
         lIjLKlIbAOl4L0wopcc/lArfNsleOLNoSL8Ccgm04ya8jweDPAzXa+7OiNRfX0MIZ60z
         FuclX4zkrqJR9WMEtbJIje22a3WEQ9nYQFz1PPAy1io2iZD9sZvOF/ZFrXj18S6HXG6d
         sIPg==
X-Gm-Message-State: AOJu0Yzx1GBTLw/I9L7Z0tdpS/jIsxeo1vleKixecA+850DaV4vWYY9Q
	JmLa05FCCHlTHKxQyIZN9C5E7djOODoCQ78aigsarErtzpn98eBqEbCX8jolBg==
X-Gm-Gg: AZuq6aI03qL4HA/UusDs8LReK5WfV9WijLzPJ80aDay0jQ4bKm8KNE2V2BzcAoFZ6o2
	LvkdGnyVCxwOk7/3Mke6Gwd7/AdyYmiknx2Tqhw2fYu4qkqhqumjv5dwoASQCkdGxSPbtYKIuyu
	5HBf2gHqWgEhg2d3e7xWGPfF36IaWmMJoBs+wN9UHWrzhGSd3/jx9Ic56tetR1o/LNuF+FN8rRc
	Yx1OuDLfR1tRA+uEDUm+dQoLxlV93G8NSSa5ZHtsSm9qBVWn4vpNNqxNPlDA+y29Q0u2M0RSh0Z
	NKjNhlTA3UNqbI9Fhaf5WBNsBOUC2+lA5zBzEthjJyHPKE57Uu4HEg7zgznh/sVA83nebejsoyK
	ncLrRoMJX76bzgntEIVBVs9bILif2P5rIBTzqgGrUBc0aYSAgDNOqjAHS0EMVgZNNiORkSJNuXf
	KaebTf5BBElHxTCx/psLDfIjv4uvDPivILhb6hRvoABbZz46feF3b5rG2TXNsFrZU9bWk53A+jn
	6IBPtSX0A==
X-Received: by 2002:a05:600c:810a:b0:480:1e9e:f9c with SMTP id 5b1f17b1804b1-483a95bda25mr141490985e9.10.1771855928356;
        Mon, 23 Feb 2026 06:12:08 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:36ea])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483a31bc0e3sm247077275e9.5.2026.02.23.06.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 06:12:07 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	bpf@vger.kernel.org,
	axboe@kernel.dk,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: [PATCH 0/3] extra io_uring BPF examples
Date: Mon, 23 Feb 2026 14:11:59 +0000
Message-ID: <cover.1771850496.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12378-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B7082177D4A
X-Rspamd-Action: no action

NOT FOR INCLUSION

Alexei asked for extra more realistic examples. This this series is
based on top of v9 of the io_uring BPF series and implemented as
selftests. There could be more, but I stopped with 3 that should
give an idea how it'll be used:

1. A QD=1 file copy program that show cases state machine handling.

2. A BPF program rate-limiting the number of inflight io_uring request.
   That's a good example of what users asked for before but seemed to
   be too niche to be plumbed into the main io_uring path.

3. A toy example of how BPF can interact with registered buffers.

Pavel Begunkov (3):
  io_uring/selftests: add BPF'ed cp example
  io_uring/selftests: add rate limiter BPF program
  io_uring/selftests: add regbuf xor example

 io_uring/bpf-ops.c                            |  29 +++
 tools/testing/selftests/io_uring/Makefile     |   2 +-
 .../testing/selftests/io_uring/common-defs.h  |  27 +++
 tools/testing/selftests/io_uring/cp.bpf.c     | 134 ++++++++++++++
 tools/testing/selftests/io_uring/cp.c         | 130 +++++++++++++
 tools/testing/selftests/io_uring/helpers.h    |  15 +-
 .../selftests/io_uring/rate_limiter.bpf.c     |  84 +++++++++
 .../testing/selftests/io_uring/rate_limiter.c | 172 ++++++++++++++++++
 tools/testing/selftests/io_uring/xor.bpf.c    |  31 ++++
 tools/testing/selftests/io_uring/xor.c        |  83 +++++++++
 10 files changed, 702 insertions(+), 5 deletions(-)
 create mode 100644 tools/testing/selftests/io_uring/cp.bpf.c
 create mode 100644 tools/testing/selftests/io_uring/cp.c
 create mode 100644 tools/testing/selftests/io_uring/rate_limiter.bpf.c
 create mode 100644 tools/testing/selftests/io_uring/rate_limiter.c
 create mode 100644 tools/testing/selftests/io_uring/xor.bpf.c
 create mode 100644 tools/testing/selftests/io_uring/xor.c

-- 
2.52.0


