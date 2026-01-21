Return-Path: <io-uring+bounces-11874-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oIwLE0BhcWkHGgAAu9opvQ
	(envelope-from <io-uring+bounces-11874-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 00:29:04 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id EAACA5F84F
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 00:29:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4A93A5E0F38
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 23:26:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D85223A99E;
	Wed, 21 Jan 2026 23:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HaEwMzhQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07E7263C8F
	for <io-uring@vger.kernel.org>; Wed, 21 Jan 2026 23:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769037954; cv=none; b=YbyLbOclViFOczEE0vcA8tLwEoGzi4jGrZxZ+4GyTLR7ENNxCIrUucxLXK55aj4WSjtoPEKw09rKamS5vn24Fs+n/MA88Dpi4HSXNUZAcjtJT1/EcKtxnow1eNRk1wgJCoaxduAqso5GAMoMsDy8vv8c6OjcuF3udKtIuS4QnYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769037954; c=relaxed/simple;
	bh=P/QJ69O5NSm3TzT36fUtlY4I9kgAl2JEdS7UPFvzvZ0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=dYpyQmmnfhGdCRtnUjC/b4qXNQStEO2QyZ+Cs1IfouIXwnbpYdN5DuRm+ZTVFrLAD7WGXU/z3kGfzpGH38dxdXrCS3gLsUzL9HRlD0tgyI443GuFU39Llg2miOYG6f4Yzacn1IsXvInMQZnnSwVgM+ObsnTfOg/ETHP3weioahg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HaEwMzhQ; arc=none smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-4044854464fso240538fac.3
        for <io-uring@vger.kernel.org>; Wed, 21 Jan 2026 15:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769037949; x=1769642749; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=mNaIM1h7KFcJgZXA5aRAJu8jYgZW057npcW5S8I8khQ=;
        b=HaEwMzhQ+f5ekEvwUbBjM/EFFpYMx/DXDikpHVnWS1vRGrHRwHwwQ/cbGDnc9SYO2m
         Dmk9F/Ve+cn/pDm5kZfgIt5GMUhUFDJM0bXnLn5Ik3EHwSa9EPX8A6pEg/WMAvkTiqUt
         5Oqvz9KOUxXjqItGj5J7WYQk6qwadqkWc3Lx4z3fpkB6YBbodbX/O4H95kGj7WKIcSQV
         q++HLhYJxjTzkILY1INOAmfwBX3SPMxbEdh27iTUP5ohMGcl2xRQp/80T3xrI4BUFOwv
         RijLlETp2QLXO/SLewC/s2Sj6hzqk19aDV0hH7n4thtktVl87D9cE0kwZX9+4mNqHZ46
         h26g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769037949; x=1769642749;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mNaIM1h7KFcJgZXA5aRAJu8jYgZW057npcW5S8I8khQ=;
        b=oz8cMipiTk9oK1jm5RAX2leAEnjWhAh9WJK8O1qiF+WREl9xAfjDcrtNpETLErbAhD
         KV2jJmKWwK0W6w59o5W+3Jn3fWp/v2YhGu9+ziUdMQJ/O3ggBwwamQVxjFhO/yhaBv2s
         KL7UOedWmcLgDVvtTScihJ0+apxlX+XAhAEgTka9g2cC6PI529AHLUdbHzKUJZ0rvIuj
         gMGWSpbHLx7kk7NWDRaLkP5mDujFKexVhydbkWDzO0aCswMGE0+cNudjCX50Gy2walyX
         5b/vrXZ3VQ7qtOpCK7RYWHzQNhBQinaPCP7dsX8Dk8qKn7VzWjvAudNJ6HuSUKH79cP/
         6QvA==
X-Gm-Message-State: AOJu0YzQ5pwnDHEl4GlJOZAcS+Z/q9aNpbAtjMQNd78Ri3Xtc9A0TfAQ
	pE6zT/L9EXnkLfLIiyYz7M9G2064XDd3oNoOW4m64lqX0qbSlA5V0RvLJ1pwaToj9sg7i7gkr22
	8Vr0BRa8=
X-Gm-Gg: AZuq6aKlDVQ7GIC7Trz7trJkf6uZxAyQXfMizH1QZ68XD+eeQdkBZ5EWUPERQ21ogpv
	pGXQI1fjgHO7nOR9hhF1HHABRpfP0iG1wX4ueR401jKkptDr7fKbP6WUW3EhUTA1RM40L8e9ZG6
	Du+MKntZfEpJnTo+iKQZrVEKdg6pg68eidWyGTloeyk2TDqOlgtOWQo4IH0h0BHz1QxE6Q51w1S
	VBkHd86KO+2GGQgS6r/EJl7pQGncGf0IGEwhBWtHE9tiYBoKQ5ah9TTw/7hdjg92E9F9NqGdXlq
	wv2GJDB4meBkOr8M53A2iBj6Cmrb7EDBdKpvNqTxl3u3OugZ2+tv2zWxDO0zYXb6ohL/Bu8akpW
	gq3I0TO6NKKSuZ38q5E4zVZ1JfLhYpmgQvClofpLASmRji4gwLCh8irScg5jjbBWBcJhDLk8EAp
	3TzfbZpTr621t7vc6z8AZIC/mOMXipg7x6DSMiuNfmpHtcwk1KPkiRnZckeoGrXH0BmGk=
X-Received: by 2002:a05:6870:9623:b0:404:2856:6036 with SMTP id 586e51a60fabf-4044c4f0364mr9537269fac.47.1769037949011;
        Wed, 21 Jan 2026 15:25:49 -0800 (PST)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4044bb55928sm12074632fac.7.2026.01.21.15.25.48
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 15:25:48 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET 0/2] Avoid spurious syzbot induced hung task panics
Date: Wed, 21 Jan 2026 16:22:15 -0700
Message-ID: <20260121232546.260055-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-11874-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	RCPT_COUNT_ONE(0.00)[1];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: EAACA5F84F
X-Rspamd-Action: no action

Hi,

For details, see this saga:

https://lore.kernel.org/io-uring/68a2decc.050a0220.e29e5.0099.GAE@google.com/

where the tldr is that there's no real bug here, it's just syzbot doing
hundreds of 2GB /dev/msr* reads in a tiny vm and with a bunch of
debugging enabled. That leads to triggering the hung task detector when
we wait on io-wq workers to exit. I did queue a patch for 6.19 that
makes this less likely to occur, as it'll only run the very first of
the items before noticing the cancelation:

https://lore.kernel.org/io-uring/937c3e38-368e-43eb-9d7e-2dcc0697799f@kernel.dk/

but even that isn't quite enough due to how much syzbot overloads the
system.

This will still throw a WARN_ON_ONCE(), which perhaps should just be a
printk() of some sort as the trace isn't THAT interesting. But it will
avoid hitting the hung task timeout detector, which for syzbot leads
to a panic + reboot.

 io_uring/io-wq.c    | 22 +++++++++++++++++++++-
 io_uring/io_uring.c |  2 +-
 io_uring/io_uring.h |  6 ++++++
 3 files changed, 28 insertions(+), 2 deletions(-)

-- 
Jens Axboe


