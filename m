Return-Path: <io-uring+bounces-13902-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id xuckODH2S2oHdwEAu9opvQ
	(envelope-from <io-uring+bounces-13902-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 20:38:41 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id D7CB771497E
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 20:38:40 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OKQcd976;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13902-lists+io-uring=lfdr.de@vger.kernel.org" designates 104.64.211.4 as permitted sender) smtp.mailfrom="io-uring+bounces-13902-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2FFD2306525C
	for <lists+io-uring@lfdr.de>; Mon,  6 Jul 2026 18:26:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C60743B6EB;
	Mon,  6 Jul 2026 18:26:03 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A1643847F
	for <io-uring@vger.kernel.org>; Mon,  6 Jul 2026 18:26:00 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783362362; cv=none; b=ORqAQOVmRYz4gUizGaDWu+3smI2bkRdQ+uiCTzOHRw8K8Jw3OQkOzj/zUkFrQnyDpu3ikRDHU1iTWxB3806cl5E5dvyTpshRvLHO4Qn5R9QXUiiWFeULIdQqiY4DEitDQUplKwQLCuHTUCEdlkB3Pa75v/JtcV8lEUSF2PM+ANo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783362362; c=relaxed/simple;
	bh=q3Biw9dVViTriSRGhp9mOH4a90WIr48NK6MQu3wHl5A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sMKSvzYgg2/0t3/P2YJ+6eDPYimOpLLUFWsuNpIhsd8FDgNIfAkyqWMZJXg5Crx774HxHpoEApbQnAXNeBNILgfggY6Ge+7GOQxp1Xlx5/eLPZBEbiZJx34CdI5fQTFe0gAYUFucRHoqzWhd9Af/S0043hjxdXjClDjBitAgV+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OKQcd976; arc=none smtp.client-ip=209.85.210.172
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-845b6d9bf39so100466b3a.1
        for <io-uring@vger.kernel.org>; Mon, 06 Jul 2026 11:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783362360; x=1783967160; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EhzAaTVsqENZ7jpjX8qsNEQ/QhOMPWhppRHzOqJiw64=;
        b=OKQcd976Hxib3sHG5ms8b122F9DSFjn4+3vwMwWVbAq2dDYuiWrZROeikvOXoV5lfj
         uJQCV13DjZluttD+JMZFkqdCmwDn73uvzTPwHbr2FFdj9wowLYJcQlaoXZQ+sEsH5aqJ
         hUgCu1OBwkKnMPoLAp6i9WoSIt2y7Ih27fB6P/m2Kwg+79kK3wdxjx79TsiVBR9xMzeY
         vjeeSl+HnY0SA9hHL7NyeAQfSXZktox+KHzSgghLDAzT6AbYJ75aGMSkoVYlHpRIXpWx
         AOb+vwdrTgXGghTbTEQiOrATB1ci9nMm2p8wkxcqiJr/ETBZVKUUZ1nR6K1j6AuAsiuy
         HeYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783362360; x=1783967160;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EhzAaTVsqENZ7jpjX8qsNEQ/QhOMPWhppRHzOqJiw64=;
        b=jPUZm4ORYZoatYe3oQ9IqCZWuq35FGozFnwHfb4fE5K38jHkv6Io/e+IW7iRXUzzwm
         JPDm4YZskb6In3b4dmby0RccKR3LgVkGh7gWI2kwb9oPjVWFvYbiWvZRL75kYwbJenaS
         FOCoW4Nh4Q9g8QBAGNqjRtqSoS+AY2UiMRIaTAbWKio/xKhebWqONYGVZVKddIXIBPsZ
         dVJhvdPyDpiBNSH5oLgBe4zH3GeeqeT+5F/qKKM2mmHlcCVGaKn11dDvDwDnl+5JitjL
         X95ApeY13fI2Gq05D4lW+i7getK2buk/pTLGmmonqBhYgXAlaORUcnQZRHcNFL1Wo8dI
         ko8w==
X-Forwarded-Encrypted: i=1; AHgh+RppCupo9wcfbJEWu+t0vAxpjIDxx3+8/QFtshui+iqYXP3V2BFmoJtKgnZff4GrXn+7EXXLQ8xWWQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyskt5up5NXlBBVPt6rGeHkMyjQoMaJrThOjmQ8864gR1GyXKda
	ynQ/Qmi447jbQywkKGGUstSFsaf5L9am5O79uzo6m5D4VKOASxiBx0sSOv1LblETZwg=
X-Gm-Gg: AfdE7cn3SBIYuSkOuc524KhxGkO+WZNDFqxCrgJhmQqeWCabZ3vJU0yxTNufnxq2w/U
	gw/1NnZd068J3S1gDVr87qLxL1wENfa8S/KF8wmIZS9bNJqH3p1ICPkHo4rlpCI/SQgZ0MMzEBM
	HrUd2xkDR5Cw0rclPs5XysAF3uNfjtyYF012i1/mJIijUcvezWPjQdU6oc/q1VmTKRdZqAlj6KR
	9Hnh/qlzReXpHsWP4YyUYhSJiQy/rItMu+uKWJNHuBArVbJzVigSFslUjhpxkpBwJVf6XsQ0Wt2
	hfE8RFTCXAt6ArNLbfVjeJaZuYGO1u+N4PGBDu5Va6W0VKXGMmVoXQMtJkKYChWrowloadCV6dR
	nl1+ntwSqZKJqRZa7s7Mn81OzHDNcOIixuthPjYVMLef7u8Yj6vDbGqYwMeDOmoBo+BCt9Od1f6
	RXkHYZMvvLQqQVv0TUsspKRKjcLoFVv2qOS2SdgtiK48xRUM9QiGtP1Qk=
X-Received: by 2002:a05:6a00:399f:b0:846:eaac:a5ea with SMTP id d2e1a72fcca58-84825f0636cmr1671705b3a.3.1783362360139;
        Mon, 06 Jul 2026 11:26:00 -0700 (PDT)
Received: from naup-virtual-machine.localdomain ([140.113.139.102])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6bc9f5dsm4228958b3a.27.2026.07.06.11.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 11:25:59 -0700 (PDT)
From: Hao-Yu Yang <naup96721@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk,
	io-uring@vger.kernel.org,
	Hao-Yu Yang <naup96721@gmail.com>
Subject: [PATCH v2] From b1014148d31468e2dcd8f237740ca1643571e875 Mon Sep 17 00:00:00 2001 From: Hao-Yu Yang <naup96721@gmail.com> Date: Sun, 5 Jul 2026 11:43:02 +0800 Subject: [PATCH v1] io_uring: fix dangling iovec after provided-buffer bundle grow failure
Date: Tue,  7 Jul 2026 02:25:34 +0800
Message-Id: <20260706182534.918737-1-naup96721@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [1.21 / 15.00];
	LONG_SUBJ(1.87)[249];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,vger.kernel.org,gmail.com];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-13902-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:linux-kernel@vger.kernel.org,m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:naup96721@gmail.com,s:lists@lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[naup96721@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[naup96721@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: D7CB771497E

When growing a provided-buffer bundle, the old cached iovec is freed
before the new buffers have all been validated. If validation fails, the
request still points at the freed iovec, which can be freed again during
completion cleanup.

BUG: KASAN: double-free in io_vec_free+0x2c/0x90
Freed by task 73:
 kfree+0x104/0x3b0
 io_vec_free+0x2c/0x90
 __io_submit_flush_completions+0xc03/0x1e40
 io_submit_sqes+0xdb5/0x2310

Allocated by task 73:
 io_ring_buffers_peek+0x559/0xc60
 io_buffers_select+0x1c1/0x460
 io_send+0x770/0x1050

Fix this by deferring the free of the old cached iovec until validation
has succeeded. On failure, free the newly allocated iovec and leave the
request pointing at the original one.

change log:
 v2: slimming v1 patch

Fixes: 46800585ae04 ("io_uring/kbuf: validate ring provided buffer addresses with access_ok()")
Signed-off-by: Hao-Yu Yang <naup96721@gmail.com>
---
 io_uring/kbuf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 3cd29477fff2..b6b969b55e12 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -287,8 +287,6 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 		iov = kmalloc_objs(struct iovec, nr_avail);
 		if (unlikely(!iov))
 			return -ENOMEM;
-		if (arg->mode & KBUF_MODE_FREE)
-			kfree(arg->iovs);
 		arg->iovs = iov;
 		nr_iovs = nr_avail;
 	} else if (nr_avail < nr_iovs) {
@@ -330,6 +328,9 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 		buf = io_ring_head_to_buf(br, ++head, bl->mask);
 	} while (--nr_iovs);
 
+	if (arg->mode & KBUF_MODE_FREE)
+		kfree(arg->iovs);
+
 	if (head == tail)
 		req->flags |= REQ_F_BL_EMPTY;
 
-- 
2.34.1


