Return-Path: <io-uring+bounces-13028-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GD4XJG6p22lsEwkAu9opvQ
	(envelope-from <io-uring+bounces-13028-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 12 Apr 2026 16:17:18 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 295C73E4302
	for <lists+io-uring@lfdr.de>; Sun, 12 Apr 2026 16:17:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8F1473003365
	for <lists+io-uring@lfdr.de>; Sun, 12 Apr 2026 14:17:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30E67244667;
	Sun, 12 Apr 2026 14:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="htHYTfX6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD876175A92
	for <io-uring@vger.kernel.org>; Sun, 12 Apr 2026 14:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776003435; cv=none; b=DQocpD2aD/C2fQ3KKmkHflPH0fusaddnhJMwJyny3R7T2REKekUFygHufTQHCdBzAK9skij1c3q7LVog/tMw8k8ze10anQK3ZVJsrOTG5HaG8gGv59QvvKI6TBvt9394oaeCO5g9FEWHTr/D08fzKsgc/K1WmRhCyvyzYrqw8RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776003435; c=relaxed/simple;
	bh=i7zYI4mOvV8+JAqQ8YEuOkLQCztosHwAzfRLS9bCzPc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ac/OiSPmhxKMXS1HkPLY7IEcbQSFtchsYx8hoMH2pCGIqQPYChzlp9Ajljiez2ioGOj4MpeULSx22byI/SAqEeyYiIHpZtuh7hxq/nMyenPk+GEU2gikxfLHgFMcPljBE8Dx8B4Ibdsn7lWkG1XRIXjwQlg8CKM1ufPaHOdvr9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=htHYTfX6; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-48374014a77so49907775e9.3
        for <io-uring@vger.kernel.org>; Sun, 12 Apr 2026 07:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776003431; x=1776608231; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=f97EwlV1Rzn116FIyNtcfv48dAPQdN/79grIHhpg3Tk=;
        b=htHYTfX6iGuVzd48XO3DlnqP34utN8jk6v7shtnQA2kpcyo/Hq+GgfEKMsB61/ffRt
         6aG4NzhyX5W7PtPfC6EiPc+FUzztD9fRVV1FCVIIswB0q5laKlD9Nj/yWUaASzRN/g0D
         NiqUOs23xf0ksPiERYVBe8XRzAufzTpI2AIYCfIDvZ7DiV1XPtQrZ7JnRglsVZiWNdXP
         omH7cEaYwnT0CayBAy2qpSoqdHOoAz+D+4Nf14v5YHyM1GuBmJMVz1Q2dgEgRTcWiOdU
         QNlWgeoFZ7V1JNHOqv4qXA4cnc97T8rHS9Baxci8cNcrBwW4nS2R54Xun2D/cmT63ypd
         tGBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776003431; x=1776608231;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f97EwlV1Rzn116FIyNtcfv48dAPQdN/79grIHhpg3Tk=;
        b=A0eDqQwG8di5xz3ku1OzlL+OyvlZyEEj4TOFAjE0VMyNzVo21wLgyMXjm9JN6w6j/i
         903GdFFwhNpMAiujdcOYJsbCeDqnKghjZrpsqe+VFZecHFS7Qabhp4h5+JKKLNhQ6moX
         11scaMISzcgrHBMN5/Bw/JQGCj4YNIpGGrJCrKlrOC+DiXjZ62bC0zgfjz45LJSQ//rD
         bDfLs8CoboU7CM5vujElEZya9yzu/ZblXC1RH1kyMpKZ49IA5GtPxewfLxTrKREDXkBr
         6BqcegoEqJ+wJadSWV9LoKlTbh7TiIMblOC+wm+t8A9fx7hbKjhoSPSGj+ayfyitP/vs
         /HlQ==
X-Gm-Message-State: AOJu0Yz9FvmAJ1G46ednx1so7E4ERC56d/UttsNi6wAwa8fTMbWA2qNf
	7KQI75A6f0qJAEHDOfQ+SGe0RdVi/Gs5RJQlxNQdonKILBTc6iFTHWQ8DpW13A==
X-Gm-Gg: AeBDiesnwARpkmQuGX0c/4/H9txABX6UeDtrL2CCxICmGygFK21eL6JhlDHr05KzfXJ
	7K2drMK9tT4hOp09lCzQiLphozjkWTeqgFApZlMjGh18NPhTbFFu0OLkTMOR2YrVoleHWAKtWet
	yOGNt4eHKFYNsPRoKBh4UNpUiPswz/54j2kgTXLxZozJfvvfMbzpPOXbPDORZWJ7QYTI1pVjwJX
	aPLbM8OncyfHA6Q2inISV44AE+V9oq4pvok2q9GlIuWIw7GkRh5WeP1Rmm68X2fCCWFw85a7WdU
	SOQ+opWXLv6BKiGf7OaC5k2fjJuGFjqH/p0MlmUJU+vKKbgaoIZ1hphyFcXMuCQrYUTTnet7Ru5
	7m5WSO1WJgURsGboSE1JTpQEZSkI/xSxAqXMmpdP7AZkmWOIUFMmF09js3a4NSBwmK8rMkgHoUj
	Iy6lHC/t9tboYgwi2dr4OPy5R5whL9+GiertO41W6As2HcmCGIJYS9uwE6om4h0TviGBY4p2kDN
	sHEBNcPd1LMnYqxjE4ut0+SRfeylQ==
X-Received: by 2002:a05:600c:1391:b0:486:fe23:1707 with SMTP id 5b1f17b1804b1-488d687116amr149052855e9.20.1776003431381;
        Sun, 12 Apr 2026 07:17:11 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d58a414bsm224368975e9.4.2026.04.12.07.17.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2026 07:17:10 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH liburing 1/1] examples/zcrx: fix just allocated sock struct checks
Date: Sun, 12 Apr 2026 15:17:14 +0100
Message-ID: <b689b7956262aa53d37c0608c80a007dfa4cd06e.1776002658.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-13028-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 295C73E4302
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

The line in process_accept() checking sockfd is a leftover from times
there was just one static socket. Now it's allocated, and we shouldn't
be checking an uninitialised value, which fails the benchmark from time
to time.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 examples/zcrx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/examples/zcrx.c b/examples/zcrx.c
index 4b9f078e..b55b07ce 100644
--- a/examples/zcrx.c
+++ b/examples/zcrx.c
@@ -356,8 +356,6 @@ static void process_accept(struct io_uring *ring, struct io_uring_cqe *cqe)
 	conn = aligned_alloc(64, sizeof(*conn));
 	if (!conn)
 		t_error(1, 0, "can't allocate conn structure");
-	if (conn->sockfd)
-		t_error(1, 0, "Unexpected second connection");
 
 	memset(conn, 0, sizeof(*conn));
 	conn->sockfd = cqe->res;
-- 
2.53.0


