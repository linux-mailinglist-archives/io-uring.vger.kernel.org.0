Return-Path: <io-uring+bounces-6150-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 28CFEA20B5E
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 14:39:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 632B43A6718
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 13:39:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E30891A8418;
	Tue, 28 Jan 2025 13:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="dyk+YEbt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A131A76AC
	for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 13:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738071580; cv=none; b=ZvKuX7IHbcBeyoPenq0iilqTyIoOXThtJxHLwm3FkLEfS3g9f3id1wxfaKyyh6kY6ZoSzFpgzrlnjiFd1rrZ8fVHToOymj88VL/SF+IigTxQIiVwLcV5rY+GBMSpywb1/Hr2C0zyrH/F/07tTADJI7muw3vSS+AdMO8P6Lsmm78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738071580; c=relaxed/simple;
	bh=srkResxdP4Pqydq94udETtB9G/kWLvauGsd1OifrxTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CHzgV5liSzrPodOyeRPxL5Ulg4IXJg7MZT5fygthFyeEp74nMBZg/Ptjic9H6lx7D0IT1Y+4jRaVmMawMzKhwYGwcSIT9QpCb5Iw+nTzzzpG/89TPmC271f8vC53HVv93ZhG1srqheQo9NRsDPvF/P8+pHMGJx264jMZPbO+o6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=dyk+YEbt; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-386329da1d9so2904606f8f.1
        for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 05:39:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1738071577; x=1738676377; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CelVTbMR7GPzFcsvtgcyQD9/IaPZPL2IppoN0M2ePcg=;
        b=dyk+YEbthISWkdcqxuLiVFjyarAOmKSoohVqr6g4AIo3AVs06haipYSpJStqqYlj/c
         uZr5cQb5czQzA2BJMjX8YrVI7uGgQ7aXEQYMlARjZCEbydkcn5yqLB+kbyZ9wIAzdxN3
         hOKg1Ed6Id9TQu4FDJ6N4n9fOrZwKzRQjOD/GhUfaOjF8WDaA1n/mWUjNlUw7slDAtsB
         wlsvCVPGYpywLO9yd/2aViQWO4fYDH3FlhEZ0+y8qxjxzfXEt4jmFboqr3Qif/0uFW/v
         V6gkjSBEJYLLGXY68b7SEmAUk0dhh7udzkAseEIRHsMr4nNHlVhZNInk9VpXJ47B5bWW
         26Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738071577; x=1738676377;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CelVTbMR7GPzFcsvtgcyQD9/IaPZPL2IppoN0M2ePcg=;
        b=fI9C6OxX5xOA0eGj2BS3Whs1S33K1fiVfH4jZ5kDQPKPXRDPu263lKDYxrHyouz9Tp
         INhwvilGLxYZnKLTS6Mhq0JJFXdA9XQtR/FQoEYqfV0su5yDb9eFLMroMUbXnlETsF/I
         oCL5J1GyeGfO1HcDPBJ7mvuVSr6dkEW1YaOFjDG60UarYqTpy7Uo6DLc2wpsTiQKVLaF
         Ob9HpdpnhAgV6sz5dthJq0GBm8zD5mws/IIxiRryZ4BPE0jXOsfRA2IF5IJVLdKB9mHZ
         XwpEGA4GwHjaghmVGSeyJgzuC+MuZZ3AUXoMToSE5Fr2yAIbOYb3SahIGEbAeiCUsVVS
         AU4A==
X-Forwarded-Encrypted: i=1; AJvYcCUWvuiwXVZiAClpQwsutQRHBrLyWZRiDUQUgOSNfvYO2SLZKuJ1rTKH9G6GV7Xf3VozFRPzTFNpSA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy14IyX1IzAxnN2mlswniaeUoEsccDOTvHtJgKcu7EIa6q2tosB
	27RZIYUGehHPZMFs+yqEtXmG3GWVy7ilur6ZFkKMZZINcPu5hxIfzLqf4sH2HncYTt4ob8WEMpt
	hUwc=
X-Gm-Gg: ASbGncvptqKi07edmZm1kx9XrL+MNS2MMw2mVHbWJG3yHJe0p+yCJxoLiqC/k7Dmkx2
	3PXrHtJYaQVGkiRdS0IaWG0oSPfySVXX54GdogGbmV3wU2xL1D1d1dFRMo0mBb5e/skbOS5r7tb
	bNB+NRBG570zImMmsjdo9TAESCQncG4pOkQc/shQ2YE5GJiK5nbKUdG/PuyEVv8EOdliS0gXsaV
	Q7snb7oWHVotogDH27Tt4KQUR3X9l4UctsP0lktQxsX7mM72TDBIi5K6GAKW7w2j6YTOpBCpxxH
	XiHEEC47v4MeqS/+wn0O3p6qD7DnlD/emfTNVUofwFQBRVom6y+Z1JENIhTOhh+lVU5VcEvt92x
	z/aEgvQ8K2KsEy7k=
X-Google-Smtp-Source: AGHT+IF8M/ADaKWu3naSkh4B3oSig0LdPOLITkVOWQq8v9u1yCs+3hetH7yo8n6SXAQJJZxuKwKRAQ==
X-Received: by 2002:a05:6000:1a8c:b0:38a:888c:6786 with SMTP id ffacd0b85a97d-38bf57c063fmr41035427f8f.52.1738071576767;
        Tue, 28 Jan 2025 05:39:36 -0800 (PST)
Received: from raven.intern.cm-ag (p200300dc6f2b6900023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f2b:6900:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a1bb02dsm14160780f8f.70.2025.01.28.05.39.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2025 05:39:36 -0800 (PST)
From: Max Kellermann <max.kellermann@ionos.com>
To: axboe@kernel.dk,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH 1/8] io_uring/io-wq: eliminate redundant io_work_get_acct() calls
Date: Tue, 28 Jan 2025 14:39:20 +0100
Message-ID: <20250128133927.3989681-2-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250128133927.3989681-1-max.kellermann@ionos.com>
References: <20250128133927.3989681-1-max.kellermann@ionos.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of calling io_work_get_acct() again, pass acct to
io_wq_insert_work() and io_wq_remove_pending().

This atomic access in io_work_get_acct() was done under the
`acct->lock`, and optimizing it away reduces lock contention a bit.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 io_uring/io-wq.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 5d0928f37471..6d26f6f068af 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -903,9 +903,8 @@ static void io_run_cancel(struct io_wq_work *work, struct io_wq *wq)
 	} while (work);
 }
 
-static void io_wq_insert_work(struct io_wq *wq, struct io_wq_work *work)
+static void io_wq_insert_work(struct io_wq *wq, struct io_wq_acct *acct, struct io_wq_work *work)
 {
-	struct io_wq_acct *acct = io_work_get_acct(wq, work);
 	unsigned int hash;
 	struct io_wq_work *tail;
 
@@ -951,7 +950,7 @@ void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work)
 	}
 
 	raw_spin_lock(&acct->lock);
-	io_wq_insert_work(wq, work);
+	io_wq_insert_work(wq, acct, work);
 	clear_bit(IO_ACCT_STALLED_BIT, &acct->flags);
 	raw_spin_unlock(&acct->lock);
 
@@ -1021,10 +1020,10 @@ static bool io_wq_worker_cancel(struct io_worker *worker, void *data)
 }
 
 static inline void io_wq_remove_pending(struct io_wq *wq,
+					struct io_wq_acct *acct,
 					 struct io_wq_work *work,
 					 struct io_wq_work_node *prev)
 {
-	struct io_wq_acct *acct = io_work_get_acct(wq, work);
 	unsigned int hash = io_get_work_hash(work);
 	struct io_wq_work *prev_work = NULL;
 
@@ -1051,7 +1050,7 @@ static bool io_acct_cancel_pending_work(struct io_wq *wq,
 		work = container_of(node, struct io_wq_work, list);
 		if (!match->fn(work, match->data))
 			continue;
-		io_wq_remove_pending(wq, work, prev);
+		io_wq_remove_pending(wq, acct, work, prev);
 		raw_spin_unlock(&acct->lock);
 		io_run_cancel(work, wq);
 		match->nr_pending++;
-- 
2.45.2


