Return-Path: <io-uring+bounces-13424-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4BQaLbtNDGrjdQUAu9opvQ
	(envelope-from <io-uring+bounces-13424-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 13:47:07 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 34BFD57DF3D
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 13:47:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B7F5C3010169
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 11:44:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8D503A9638;
	Tue, 19 May 2026 11:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C9JgtFQX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E66F4921BB
	for <io-uring@vger.kernel.org>; Tue, 19 May 2026 11:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779191085; cv=none; b=Qwric/h4IU1bUqZTnUD7nXsIQ4GPHWFs30T7Q6iNAVl/9VpH4wG/IzNXLkTa2CiqOgL7gMzoqxmBfA7hpail3cI7DGWy/kepearVEpxbGYCb5RmLPL+TK7L7/q8q2TIeZaJIpH3NGwLGqaeSISV+fh+D1Vl2598klSk1f19+PSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779191085; c=relaxed/simple;
	bh=Thp/yGRYPzrK7+o1uGmfOmX/4+AmLSGA/EjCvgrXHto=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sFB8QkWz9uUmBEcWN24v/BWptLWz9hP/6FRsufL2yZuvnNMm5A3ql6xn+bv9iX0tYRl2j8raYcQAA3RQK20xPsGPENsbVugdmW7w97ycPMgq03J8ygeowhmfLYlbjxn1Pfw3aOc9j/WZ01RvrgvWZ+Iq1jFfubXUaFHth3v0OBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C9JgtFQX; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-48a3e9862f0so20012955e9.1
        for <io-uring@vger.kernel.org>; Tue, 19 May 2026 04:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779191082; x=1779795882; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cf/dxnqWNAfphMgMYtVh0cJBYEPwPfrN54UMe38KMEQ=;
        b=C9JgtFQXuljf5C2Hy0R1wmGX/F3gUvKqHyPd9bOC+zA7S8Ke/qebiUfffr8jsm/TrV
         PzlNvoRfG5LWB66uXbLc1dVpZvmrf34Q6CP1CvLHd7U4VPUq2HAUXxWjtjdkzf1LZmdY
         ZBk8mYgzAYOmk/TGdRqX35UaO6pti2zhzO2T+lJ1DZbARi1FaZM1EqMoQWKISU6xy6/a
         LdSgG8QVzec3zNE1m//BvcJbeVf82lrQiq1M1FfzF2ytS8R3Q2J3p5441i7yEgLKDFAN
         osYt59aWbOJVvS5+1ti0g1xNvaf288sl9Zk5DLcwTCNCdVazv+PtdYpgpY7O5jAcUsUc
         oWUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779191082; x=1779795882;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cf/dxnqWNAfphMgMYtVh0cJBYEPwPfrN54UMe38KMEQ=;
        b=icqcTiLIjEYCU3xB1T6PA0V9SQrCKss1jvrWQUmNHuw0nsrfdeUUhXHgPRVVtVBNvd
         Mo0NtEedY1ezWlRbNo6HVlGvhBHig25RlOs3G1orl6keozMe0LFpLA9aUejuwbgxz4VP
         0l5vCrzBazeZqF60zKJ453C44FK/H0hwTzj9Dy/fLsUopwO8vjvSxZfKKfSAvXGcVC8x
         dsSq9Hs/vzzp3euNSad3A3HaXPXRdlW9qTJ0NzOEpThzvl3TBtOC3VWvLuka4IKKMiJt
         7UEjyP9eOQVQMwYDUx10GhMCOw+Lhspjre9AMOzPbl+LxIC8sUroQspuBaYUJ0L1D2oG
         dhag==
X-Gm-Message-State: AOJu0YxKBSrACmQyFreNoC5e8OPNBf4bexrAQ+5nVPDqIvbPV1opB6ep
	40v4mekJ5WWOjZB8QQxLPG8zR1pZtZzd0R/LRtguONqK+LZY+hfoSY2oBnRiZQ==
X-Gm-Gg: Acq92OF+MgBX04MhbyJ41rBaMjiS0ujOl6WCoQyz8sPJhWeX0JLLZ8ByxJkEgp2X61j
	LuqG+Q0K1WEDpgtczPv48fZuKWYrs/+40P/inTruxMn/Rk0lmspHpo9GNNDu9G77eJQR5U7lKZz
	zLnMrXusfTh6E2zm0bHh87YYSDGO+PBfZARkcEbKTR9Ul0XjDF0KeQM8JWC9EW4i/2mf88fhELq
	czRPog9HgkC3r2SEYf1MWDnKbWw+kVPD42OFDAUcSiadCeUsVhvBa+h9ny++wlmxC68LJG5bBwv
	VToH4zcJIHE2kXH9pWw34VQmgtwkBraEmwyEZw96amd2LBO0/XiF/KlSS2ilN35GN6IEwKnanln
	v43FiYHejdhorWog286dNqRM84DlgR/Ilh4jrDye/a9NBX+uN7oluAjbOwW/Cu0RmcAcidA9anz
	+f2/gbbrjxGsTtJnR9rjxDGSvmorGqeyjjOD9LfOfHibHZ+iAyKDuQOSSwNreeI9qIFGjNeoBnc
	IBzGashzSUlRCI/brGQlO+3rEs1cQ==
X-Received: by 2002:a05:600c:609b:b0:485:3c2e:60d5 with SMTP id 5b1f17b1804b1-48fe4cadfeemr291089965e9.2.1779191082265;
        Tue, 19 May 2026 04:44:42 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe5694f2csm323392445e9.4.2026.05.19.04.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 04:44:41 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH 0/8] first zcrx updates for 7.2
Date: Tue, 19 May 2026 12:44:26 +0100
Message-ID: <cover.1779189667.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13424-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 34BFD57DF3D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

First batch of zcrx updates for 7.2. The main part is patches 5-8,
which add notifications from zcrx to userspace via asynchronous
CQE posting about events like allocation failures and copying, and
statistics. It's accompanied by relevant query updates. Patches 1-4
are general cleanups.

Bertie Tryner (1):
  io_uring/zcrx: reorder fd allocation in zcrx_export()

Clément Léger (2):
  io_uring/zcrx: notify user on frag copy fallback
  io_uring/zcrx: add shared-memory notification statistics

Pavel Begunkov (5):
  io_uring/zcrx: make scrubbing more reliable
  io_uring/zcrx: poison pointers on unregistration
  io_uring/zcrx: remove extra ifq close
  io_uring/zcrx: add ctx pointer to zcrx
  io_uring/zcrx: notify user when out of buffers

 include/uapi/linux/io_uring/query.h |  12 ++
 include/uapi/linux/io_uring/zcrx.h  |  36 ++++-
 io_uring/io_uring.c                 |   2 +-
 io_uring/io_uring.h                 |   1 +
 io_uring/query.c                    |  16 ++
 io_uring/zcrx.c                     | 227 ++++++++++++++++++++++++----
 io_uring/zcrx.h                     |  11 +-
 7 files changed, 274 insertions(+), 31 deletions(-)

-- 
2.54.0


