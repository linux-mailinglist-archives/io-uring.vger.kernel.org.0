Return-Path: <io-uring+bounces-11905-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GGUTLrOgdGmd8AAAu9opvQ
	(envelope-from <io-uring+bounces-11905-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 24 Jan 2026 11:36:35 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A84B47D411
	for <lists+io-uring@lfdr.de>; Sat, 24 Jan 2026 11:36:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D79A03002F77
	for <lists+io-uring@lfdr.de>; Sat, 24 Jan 2026 10:36:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0158427A927;
	Sat, 24 Jan 2026 10:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HlGwy4JL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA701F03D2
	for <io-uring@vger.kernel.org>; Sat, 24 Jan 2026 10:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769250986; cv=none; b=o4kAdKua7m+4iidwkL22fY021Bt+Y5ad7WWCyVYZW9ib2u3nXDjH0iBtdzfO3U6kbtXuRdZVpnpu99f06tgq0ox9tK07dD+qga2feF5bd8aNmTroi1cFN8FyvLZagRCqLFRiEKW/lIKjiB8QEjMHS0Z9jxP8/FTViG57dpYNxOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769250986; c=relaxed/simple;
	bh=uZktoa9nwKYOMB40W/F1FbukjUOG+xb9xQc5zLXOkvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=alpmLjfiRiJw7UgRzjgdNyE+ujYxc/xXMdEk6syB4ro+UbRZBRQpXVrfrAxSHKycXVtCRuBd7jrmJ6RrWCe3emMx27349YeUjOE0SMgvszi7uhKH9RAvvyl+rOEd9VBYV7dodvWW6Fw2rHvh4siNbWTm/Xtx2mfJk79dPyI7Dho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HlGwy4JL; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-47fedb7c68dso29883545e9.2
        for <io-uring@vger.kernel.org>; Sat, 24 Jan 2026 02:36:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769250983; x=1769855783; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=id1hLw6ZvU3sPPbM3xii8tiFX5fv81jh+WFXbM2/0Yc=;
        b=HlGwy4JLDnzyJms5vM8NheI4vWHCgioHk3SUGdv+9NMfx4aq3vmgOeAhan19bPXsY+
         HDuVfcQ1wzwOohtvUIMr8E/VWSxHgN7JSzBmLMVRACt8nZ3HRWSEzYrN48/yoPF1cXHk
         b2Uc+NkruQlY04nU+XavDJeeXvmepOWRmj8KiLg0ECxfzwxjGNz/uLr8lNhTBhPj3k8n
         qrlhRg3Mw++716IH9dawx5gz1UlNJLRg8v8zBTz/RjbKMbciSjqkyH9Xjl+EWFTi/uU6
         WgNmMk7ii+5o0ZRJZfLl06qhKVpZEO1h9u7XbDPFPQKNP8VyZ2Oh5TsM02LuTsjBxZGR
         Qb5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769250983; x=1769855783;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=id1hLw6ZvU3sPPbM3xii8tiFX5fv81jh+WFXbM2/0Yc=;
        b=jI7MN9oDZyU2D+QePHDxJjNoU+YgVVcrwIywfe23oU2RqtVSC5DbZscgknVJAJhP0O
         5Sfx22WQFnJKZtPcIP8RhpHo1ibgbslQfifMu+XFoqwg7i4tMEnN0a1Jx38KvB1k91cO
         Zt0z0H/O10Bj8pKPcQCmwNe7lUOPQUNE5u94oEkjzOlPK3krG68BNTMvnqLmN/WabkM2
         CyqTPzZfzeCepeY0odaI4zhCdkVfaw/H7L+kvPP8HsxNW21TE/s1oNEGtdEpJg51nRCt
         kU1zTYtOq0y2kr1DI6PrQ55dpSisSwW6YwCZPqL6xCMGKOk5Hled2HpQniQi94rr+lVf
         dGGw==
X-Gm-Message-State: AOJu0YxambWHkC7CM3GACgEWFFfcRMeAJWogeedkwf0LnucbaFXtf/Oc
	p/U8AQ6uD1QABDDIA08MLyI2cg74cymvsziozmvg/d2WeoEOpyos3M1llcPI2Q==
X-Gm-Gg: AZuq6aK/3+UkQLw5ZI6s4xez+hhOu0674v+GD9Iwxk1zirkedgdaTIvI+A8BTXMk7nr
	qbzA9IY6yQz9prIeS25YC+WhKNwrhjuKChT8afi3fKqAD876vvFDK5nSZNUhpWu8cB1qe8j0uZd
	a7KzX4QMtkeOMb90jWL0aGlHoFCDhrXk1OfW3WjGrBoQFgIxwNOC774xMkTWwUXF3+IzEmGSrbo
	JRFnwg+aeDMwJl1i1GqkPxwPVcaHmqsj4phvv65wS41wR2d3Ig35xV4XUiDcbY9CoD6KfZsFIUO
	PMPK8rfUoeGaX7DGnwHnjnjQ8ndRFfdZdrZPQobHagMR6eQLOyPoRMwBUT9ExbxfuP9Rlefu2Dz
	kAS6RJgUgWtHT/LFIw9AaoLGd3EQGzvcobTNRwgETcpnuNagwWD8zhRBQduaWAaBizqJvjbFEFY
	8at7xZB/TUXFMs70KKDhfKZ/6PD8Z8r6/k82cpzD+frJqn9cIYX1k+uaI1s73S2LBQhSIJm4MyH
	CXjqW505HZuiFZr5A==
X-Received: by 2002:a05:600c:1396:b0:480:3a71:92b2 with SMTP id 5b1f17b1804b1-48051256163mr62601405e9.26.1769250983210;
        Sat, 24 Jan 2026 02:36:23 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4804db8da59sm46164855e9.5.2026.01.24.02.36.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Jan 2026 02:36:22 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH 0/1] io_uring: zcrx large buffers support
Date: Sat, 24 Jan 2026 10:36:16 +0000
Message-ID: <cover.1769249792.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-11905-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A84B47D411
X-Rspamd-Action: no action

A single patch enabling large buffer support for zcrx by propagating
user parameters to the net + sanitisation. It depends on net/ changes
that can be found in a 6.19-rc5 based branch [1] that's already pulled
into the net tree.

[1] https://github.com/isilence/linux.git tags/net-queue-rx-buf-len-v9

For convenience, all changes including net and io_uring can be found in:

https://github.com/isilence/linux.git zcrx/for-next

Link to the netdev series:

https://lore.kernel.org/netdev/cover.1768493907.git.asml.silence@gmail.com/

Pavel Begunkov (1):
  io_uring/zcrx: implement large rx buffer support

 include/uapi/linux/io_uring.h |  2 +-
 io_uring/zcrx.c               | 39 ++++++++++++++++++++++++++++++-----
 2 files changed, 35 insertions(+), 6 deletions(-)

-- 
2.52.0


