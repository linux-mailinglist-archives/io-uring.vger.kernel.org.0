Return-Path: <io-uring+bounces-13425-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6JD1MctNDGpIeQUAu9opvQ
	(envelope-from <io-uring+bounces-13425-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 13:47:23 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 75A6057DF4B
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 13:47:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D8860304D46C
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 11:44:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 976E24ADD92;
	Tue, 19 May 2026 11:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l1jvXZc6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211D435200A
	for <io-uring@vger.kernel.org>; Tue, 19 May 2026 11:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779191086; cv=none; b=MzyVV42AErTEhAijkcKx5gaxccROmBUrdNWC6cTxdAbksRtAJ8ejfKEQ659TvmbWxvLIkJXbuy2crFh8rCn3qUpH8z8D/OeXAOrhv4lZG9sBLPIaXiO6aiL4pIo+2DAzhGDQxBzcHh+N9no3BtmmLRoCXeb3OKO3Pnq4cdWEa3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779191086; c=relaxed/simple;
	bh=smbb5f+MTzgWTNcXfgixllw7irmF+kG3BO/t7kkRLlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JV536by/F0hPhAWOsMWjcC3uyNiL8iGw0x1wDnLJY2wmMhDt+LJsCt0ncr3LVxuEmacFE3/4eyIt6qYDKIsOk5FwzT+Uz/xyQdUFrMVxruKkalyu7zuHL1hQPF3Q5Y2KuTx0Z6IX+2hZUCdSZFHxkOnzv6gR3kO4DnRYzCWCDAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l1jvXZc6; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-48e82c23840so27356335e9.3
        for <io-uring@vger.kernel.org>; Tue, 19 May 2026 04:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779191083; x=1779795883; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cUOFBS5qjwcHKBbh8i3Q6c8n431FFzTbA8NMglOxXrw=;
        b=l1jvXZc6CiRyEhflrMXlf5BcFtjqyKEcrhtG51G9t57f7C/G0WZoyRNp0ba1Iy4pfp
         mhCPBWCn89xT5+JSWjwKs2NndH2f5koOQPmVqfKfYEe8gHFHfUAH8/6/RitUV/cc0imi
         v297h5Wxv+YE2mHQP3ukzvM5FlvZUwXQ9XldGSQpnRkzGdZSD+n7yzqCU0LRihQhOaZG
         9z92LXj33gRjHbSbnf+nY5TRlpa2s8xBBnrrc6Z6oPzwBgPtxVdHB8wzEXWT9wBTy4RU
         pdZb2tmJ6wgJlN4HmSVan48SCk+TRfscmLF6Mb3cw4vWJgK/lwj7/TU5SWyTQxIYdXdv
         6rTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779191083; x=1779795883;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cUOFBS5qjwcHKBbh8i3Q6c8n431FFzTbA8NMglOxXrw=;
        b=TtRGZFVuw9Qs9UrZ4iOLXBC+fQ7UwAToBgoF4h+GrIIXyRGewTi0apOOe7kbL/utxP
         MJJMsC0VDUL+V2hXUH+YStFdLH71jKY+ZBKSyAxWS6U9ny/7rDYroUsMvb8CCMLXFs8L
         w5gnmM15zPw2m3HtCaLEJVxCLRjWYuiTmmQI9rzZLQLcKv+kDWJ0d9Asktk3V/XZbT9l
         Auq9TMlvrYZOJonk1rqiKKex40sBAQcv3H9CkxBChypk6qMLp6zHhlv9dHDPpdCpMkZ2
         LqSCX/JoMXSk7QywKViAvrb915yRaMHuqfy5YwV+GhZPK8wRUSL5GGqacsNVj7Em6NKM
         QQnw==
X-Gm-Message-State: AOJu0YwsCGWzbkvxuUy09pDMqvYaO8rXblDzc7e0EGkXMLLv0PZj5ZMx
	ZTE3mSIsvaODxWR4o4Wa97yyQzoBxyaZp6cARwD0MDNluqUavnFMlSqhdsnsLA==
X-Gm-Gg: Acq92OFTj7jOgCyYj1nLTpQqu3rf3oYNWwASrFwI2bGDjKPog5gbQEh38fem44RKaj4
	gZT8LEbb1t8ui6qZVncjT5eZ97uIU53vjeUxWaUACS4eWlo/GcrjWJMHgmsQfKsrp3AqCGMp5Iv
	xSWFrkiTDYQ1kUIVDTcBCVdUc4UQZ5MOW4hpMlFfBeoyDP/Y3duLUaCUdxnSeWvy67OH2sA6eCl
	jYp/J6nQWGHBBzZZwxliEMk53K91k3h8OGPzjWqRuI1Lr5xHBMu73Wr6g0vQw7T4y1+E5BlZeXg
	74allFVqWpo2fxPGo3QNf/X97VoHMddrwuQ0FBPNZekEy+pijD4/o/ZcBB3CtDwdMnoeMaF0/7k
	sDX7QIcEFB0QQ8pPiZ3m6SBw4U5GYcxHzchK9+o2z2YiRhsy6qc3nl27o0iIIqvdAljgHWkVMan
	rYmXUnfiJ/5MenQmmV0ooNTMx9GUNYRaVD8yc9MBHcF3/u/Qa9Zf6ZVIECtSNKN4CSzs1S8bzwl
	MTiwqx64hSMOPliZvaTGOlxZYw9U5o6Y61R4/Re
X-Received: by 2002:a05:600c:8189:b0:48e:89f9:9408 with SMTP id 5b1f17b1804b1-48fe632374fmr292720615e9.20.1779191083401;
        Tue, 19 May 2026 04:44:43 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe5694f2csm323392445e9.4.2026.05.19.04.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 04:44:42 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH 1/8] io_uring/zcrx: make scrubbing more reliable
Date: Tue, 19 May 2026 12:44:27 +0100
Message-ID: <c4ea127023494cbbedebd21a2b7ae5ff0448eb95.1779189667.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1779189667.git.asml.silence@gmail.com>
References: <cover.1779189667.git.asml.silence@gmail.com>
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
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13425-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_THREE(0.00)[3];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 75A6057DF4B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Currently, scrubbing is done once before killing all recvzc requests.
It's fine as those are cancelled and don't return buffers afterwards,
but it'll be more reliable not to rely that much on cancellations.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 7b93c87b8371..60cef10dc491 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -986,6 +986,12 @@ void io_unregister_zcrx(struct io_ring_ctx *ctx)
 		}
 		if (!ifq)
 			break;
+		/*
+		 * io_uring can run requests and return buffers to the user
+		 * after termination, scrub it again.
+		 */
+		if (refcount_read(&ifq->user_refs) == 0)
+			io_zcrx_scrub(ifq);
 		io_put_zcrx_ifq(ifq);
 	}
 
-- 
2.54.0


