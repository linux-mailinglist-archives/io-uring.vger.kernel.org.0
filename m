Return-Path: <io-uring+bounces-13275-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8DQCCzABA2rdzQEAu9opvQ
	(envelope-from <io-uring+bounces-13275-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 12:30:08 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E148451E91F
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 12:30:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EB17930703B6
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 10:25:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51193349CCD;
	Tue, 12 May 2026 10:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JSzOdNwh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F31395AF4
	for <io-uring@vger.kernel.org>; Tue, 12 May 2026 10:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778581529; cv=none; b=hFJboLgMPZ5rx8v1gsEf+q8e280V4zB2DQUiDfGMEnufNVcIiis5Ise3Cvg+6SLz3t/2yDuvRfTYNaioIG3ZbzaxrgUJBN4Oy4lfx7gHipPF2nyNMw3sEnR/KVlSuI/hzX4qbqViHRh0fbO9cJcT7h1HRuqHdzeyQgOIVzNmadI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778581529; c=relaxed/simple;
	bh=sBOTTT/hZwbHIngdOqOniPski00+V5/fid9M3+WPdUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FnPaQOtLmRACSqzWkhr8v6DV5UxNz1TD8BmMWCB3VvAHnNzuSZSRNyesPlmtMnVewQhDWAbUp82oRKKG42x6EGbeJOVNu1d85qopGFlsrzoVbazvjSaMT8/AH/wyTRMMXLLRkUzq5slQQzODE30R3f+1ARlDQ5qLKvpLCqK1d8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JSzOdNwh; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-48374014a77so49346365e9.3
        for <io-uring@vger.kernel.org>; Tue, 12 May 2026 03:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778581526; x=1779186326; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Edr+ytgwsmK9YysqqZ45HcW/A2JY308WqKVGXyYCiys=;
        b=JSzOdNwhxryTgGzl+knueXrRGfqA+lxpNMmok+0+puBz0HmF9NkqtIWOJFBn/rc5pw
         cJIxz14LV6v1qx4t/aFG9qi2UbpVgr6TvpvW6gFQ4rAWt6YceVGwP4KsLIaNK8wiauZp
         M4SJqkw2qNcTbZ2tgM68b5UseXhDZ1j5Y/P62ZeeyyeLY0xY6VAFDpl9Hn/ewqL6rzG1
         mZrrv74Eb5wCDa62PlddiDqpMlFjLyooX/G5mceWZZXRWdEZoTCIy1fyNpIH8yxbcW17
         M4ah+/Q/YcchFJFh7NusxOfDtHrBFjD9Ijk2s0A9LHWqJG4CRvB5zX/qpL+DHsbyOgRL
         x32g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778581526; x=1779186326;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Edr+ytgwsmK9YysqqZ45HcW/A2JY308WqKVGXyYCiys=;
        b=SwExmRRCD0mWZf99xDzTx8htgqTRtEFOl/A05GT3rPrmgs4rBoxtH045VFlgH3JxYJ
         /gRpT0ChC3kJVz1umzsGJLWXcTylNGfcoM5HnUX41uvulW0nsWrC76kZ1ABTgcQnWfIH
         duL9b1ya+W200N5jkEhSnlb0rAgc9peGQJlMSo1eERkd9S9mcmvju3bhItJuO419eBx+
         X0Ozx/iWqx2H9wI/m61K3pkwC3TEoWAUo/FlqVauA/RQoZN6rAjPu/aZaBW9eGGkjG4j
         Y/e+GdPpfbMq344cYKopRBCBLEAzm4dV7ntJbOfnY56ilTFOrA4U9dt+wm3umJluPXO3
         3ffA==
X-Gm-Message-State: AOJu0Yz1Na1ebkAefMHM3l/d4k/WtpB4YySFGmzKwj3uXCYauAs6rkUn
	yQS4N3wyHb0nLgr2ts0QtusNKQ8r6YDkgu+idKZVE8MGzhOI/om5pdo5NEuxPQ==
X-Gm-Gg: Acq92OE2OmphmhV9Er6WCgTrA4+nfHfTYy50lz0BfunYlm9L4aFAOVI+7KKNFiGY4X6
	CLueUJaQ9w+c1uJA8f+ZBuVdzveIDMr0Z7PW7p2qBNGsr3lXuNkpcGqmliJf2EqDYdytJqlKKwe
	1i678YUvUlEok9OUwBwWki7mXGpcnTLfVJ8v1x2ls6AzQd7FiGiA4jW0JyKPtYDzOeqBFmC8MKY
	HBnVIV1cDtPERkWMcgqppcdoXdibT7Pb7t84Bf9xxnp318C5mDWhzJX0AMSpDajRWBo1ptXTMgN
	piiRHx1dG1TSjSsrR+DcaL3Xz5UQHIMDog02IoH3kmvI/hWNMiS2W6ED8J5hK/vJsvZMFPyyMJl
	fYP4BFZTHxvK2j691ZwkQdZnLdWC/6GlbHqEmqOLtJsxO3LgyZmQeKWn+fAj3kUMnFJWXmhoFtW
	lXHBhswxTP1FSD+hRy7pNai9fdbbnRhg7d5OVQv43X4oh7OtUph8orPWLZI6DuBd0WgRMEkY9Sf
	3VURRbarw==
X-Received: by 2002:a05:600c:4509:b0:48a:56d5:16f2 with SMTP id 5b1f17b1804b1-48e706b3cadmr212454415e9.7.1778581525830;
        Tue, 12 May 2026 03:25:25 -0700 (PDT)
Received: from 127.net ([2620:10d:c092:600::1:8c90])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e9052c9fesm74352255e9.1.2026.05.12.03.25.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 03:25:25 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [RFC 1/6] io_uring/zcrx: remove extra ifq close
Date: Tue, 12 May 2026 11:25:01 +0100
Message-ID: <3adec4b4bfb3b82232eda6152bb07f9cf86e0391.1778581283.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1778581283.git.asml.silence@gmail.com>
References: <cover.1778581283.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E148451E91F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-13275-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Action: no action

By the time io_zcrx_ifq_free() is called the interface queue should
already be closed, so io_close_queue() will be a no-op. Remove the call
and add a couple of warnings.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 7b93c87b8371..3478040f2197 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -576,7 +576,10 @@ static void io_close_queue(struct io_zcrx_ifq *ifq)
 
 static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 {
-	io_close_queue(ifq);
+	if (WARN_ON_ONCE(ifq->if_rxq != -1))
+		return;
+	if (WARN_ON_ONCE(ifq->netdev != NULL))
+		return;
 
 	if (ifq->area)
 		io_zcrx_free_area(ifq, ifq->area);
-- 
2.53.0


