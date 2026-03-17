Return-Path: <io-uring+bounces-12730-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iEvRKFC7uWnJMQIAu9opvQ
	(envelope-from <io-uring+bounces-12730-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 21:36:32 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 43F532B250C
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 21:36:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2DB16302C700
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 20:36:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A059E347FEE;
	Tue, 17 Mar 2026 20:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mvJlVXY7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF765CDF1
	for <io-uring@vger.kernel.org>; Tue, 17 Mar 2026 20:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773779788; cv=none; b=AAD9jqN4xIycE93F4ahit89ciMsyqMYBdl/VQTcmGO2zPk2BcACwKnFc05YZOLrxnWy78r7hRp8IvQFfd/KAboBLdPpM9KhnIGGV+F09WEMQujINxv33W+Q/PY74Y5+GX0p8DyMCx8OC3rzalOfxMBdmHK4HoaIkpunXaGArQnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773779788; c=relaxed/simple;
	bh=gR0o8yJQHu+K0HXLrLXObf0wZemyQeaec0PznKtBKNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aYjIkjSnPWO/udMw62w+hZEUqX7m7qd1XYlAJjN3l5DGnAQFEL9fTmSA8xIMKHzv9XypUBahHQhargt0jonIqhfOCEyJxJSwpwQ+jP2rYFfZU206lbWkQOU8SLDTpCRSZTxpFpNRATsJbQz6fouaYJRRvjwYSj3/rUF0SJb3Tjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mvJlVXY7; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-40f387a688dso91587fac.0
        for <io-uring@vger.kernel.org>; Tue, 17 Mar 2026 13:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773779785; x=1774384585; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ATcsiR0+g5XEiHnvLvrCdq6nFAFEou5U2Gz3Tk9gZDY=;
        b=mvJlVXY7NsjzFwYSSWJZevJbKfxF+NJWD0aK8SobNUFyJ3mK/Y0cRYlQSHvkdYsvW6
         fb9M+QML0gW3mSRMq0nKhDMcVxb+zVhrY5RoJW+cXa9C/c4k+DuKmfLC30Zq1pSfVJ60
         NubJTUuYCBvscpkFvXnFbiONEnt0S4JnOhBjPm/H5ULD1drjG0s4UHoLKVbj9w9mkKvG
         m+J4hSwRkrZhClYAVlmbUl+IS6VaBNyzaG4Pr10VI8qPki0ai/oj/GVUdlR91s91RY1K
         ARF+f7FnMxgJIMpz036vL5tlK5A5XpAM65qoPew18m6ZRFhlFnAFUOaD4Q/VqcLmeCdH
         0+Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773779785; x=1774384585;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ATcsiR0+g5XEiHnvLvrCdq6nFAFEou5U2Gz3Tk9gZDY=;
        b=QxpQ0agoljzCxa82ucAGL3L7bSRuDqdmNqGPkeWaLgRwPzZDe0xO/BGunp+pwdajB+
         k66RPbcJKbQ0TBzfe4etJKIOwB88ArYJOco9vMIOLKav3sK0mHlBFe9tuxfbtADf9Kuq
         e80x0QeOM/waohlGq3A1boaZZAWLzcK2xDMu16d67dF383xWX4o5GnSwuN9IoKoEcKJ2
         hAi1uhYxX7Ioe5n3+G9kAhmBqBOLnlUn5+u95cZPm4uOn7h2OSqLqC/rivQe+yQpeDJe
         bp0avdspOGCMkP44/ZpmzOB+wg5Y5LhR1jro62UEzzyXu4relJHapt6mineIXvj29A/C
         3SqA==
X-Gm-Message-State: AOJu0YxMF0pcCZC+l+VXsh60ii/wmpOarofgKnkwBF6qTgJoopxhGpt3
	o6kgpNy3jDJ+DEYqC8eSt8MUdOHfBoab99bzI/d+4lfPZvLZ287Ru89bq9vFP5CyBqF0FiwEqJq
	jOcnu2I0=
X-Gm-Gg: ATEYQzwHB/1M1CQr/a/ZpyFP+E1Wy1B+l67Hfix8f8bUmzlJAZa2OuZTAU5Fhu6qVWP
	KoBhHy1LNB0FwnKweB57P1moY5DJD1C0yQq3v/46Ana/9SFmjqfu426XY1P3SihJMmkzPkEEJoO
	YOPFbHWrk/tqQu/c+/jXCboim174g86nEpLydEH+COJg4VYLvw7uLYTA4s47PQ5e9VxvGsu8Wah
	/Qu7joOa3RbiD+v0PtTo34t4a84sY35tSTgaE5z6g63JMtrcvN4eI5EfIo9CY0ezcN4DdG681Zl
	cJC62tzRVpSC7KfYJtWeFtGLtfft20cQIOKJi3JV+u85gXOfr1v9V1fNejqR0aTVAcCcY6e5bjE
	yAHApbxlu7OCxHgpHZOC3whQHrFzGkv7vRTFFYH8hVesfXVT39Pite6n6qWR3Krzwqal4TCcKHs
	P20dO+oPFPWZ1o0HzjQMR1L1TWHlSu0xLfDwPBBiQwYzW4Ei3JJ/5HgjRWvyKkHh/1QI0=
X-Received: by 2002:a05:6870:8a25:b0:417:211:33ca with SMTP id 586e51a60fabf-41bd4050688mr682799fac.36.1773779785377;
        Tue, 17 Mar 2026 13:36:25 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41bd2cc1015sm670885fac.14.2026.03.17.13.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 13:36:24 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/5] io_uring/kbuf: use 'ctx' consistently
Date: Tue, 17 Mar 2026 14:35:14 -0600
Message-ID: <20260317203622.1007183-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317203622.1007183-1-axboe@kernel.dk>
References: <20260317203622.1007183-1-axboe@kernel.dk>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12730-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 43F532B250C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

There's already a local ctx variable, yet the ring lock and unlock
helpers use req->ctx. use ctx consistently.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/kbuf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 26813b0f1dfd..ff81f32d8032 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -225,7 +225,7 @@ struct io_br_sel io_buffer_select(struct io_kiocb *req, size_t *len,
 	struct io_br_sel sel = { };
 	struct io_buffer_list *bl;
 
-	io_ring_submit_lock(req->ctx, issue_flags);
+	io_ring_submit_lock(ctx, issue_flags);
 
 	bl = io_buffer_get_list(ctx, buf_group);
 	if (likely(bl)) {
@@ -234,7 +234,7 @@ struct io_br_sel io_buffer_select(struct io_kiocb *req, size_t *len,
 		else
 			sel.addr = io_provided_buffer_select(req, len, bl);
 	}
-	io_ring_submit_unlock(req->ctx, issue_flags);
+	io_ring_submit_unlock(ctx, issue_flags);
 	return sel;
 }
 
-- 
2.53.0


