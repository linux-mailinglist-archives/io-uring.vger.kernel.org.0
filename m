Return-Path: <io-uring+bounces-9760-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 788B7B53F61
	for <lists+io-uring@lfdr.de>; Fri, 12 Sep 2025 02:06:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C48A680D6E
	for <lists+io-uring@lfdr.de>; Fri, 12 Sep 2025 00:06:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D8DB1853;
	Fri, 12 Sep 2025 00:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="hiEsnjSn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F619A41
	for <io-uring@vger.kernel.org>; Fri, 12 Sep 2025 00:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757635582; cv=none; b=HA3cFrqimUecr/qSUSFvHzoFsZwNhU3ydPBtSWdqMe9v7mBQgTYyL+mcGpxTtH8cN6qnmoPX1gwjBQOR9Za9MqD8K3RPajkl/8YVag3tCjeJ0yW3JDhAdF06qqE5YwFxc3Y1QPpBvyfO6j+WJU621ES4moVKvTzhJn6M03uj6jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757635582; c=relaxed/simple;
	bh=+6OPioA90E5nzaoCC+gocHUjf3q9Y81ZBY0L3e9+kGc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TtrwfOsLemDXhhAk0Rpa5Cw21DAQTxM4oGfaRhubcnrkD5SbsK5rNGslbCx5XNchHuLlqYqFVoCf4ua4ldOM+nvV9iD8aPn6+D9RzofbykMoHcQP0pDWdDtBcGunODmFMsWVUVQl3Nje5YUj9fmfOTov0iLox//Wh0am3agS5Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=hiEsnjSn; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45ddc7d5731so9145485e9.1
        for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 17:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1757635579; x=1758240379; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XQ+S/AjoUpa12H97dfICorV7t0bCnG6lmMpJwiBX4/M=;
        b=hiEsnjSnXJkdG+/RtNT366LSZzvjAwyUEGkOMnZJ6N1n5L/VoAgcfYKXOJokKU/XVC
         /70FCgZhpTNpgyRefQykB6jpm8eDsSZULJVIlhYJufSFdjVV85bCKRHAulVYIDdf7bwV
         iwYVXw35L+T5HpnUTIui7eGYv6e4prsMqf75NTUTAlsXHX/cdP++uLmZ9PDj2oiU/oRq
         VephEKI37yD6OhpB5ItMEav7c05y0YuG6Ls2RfyiJIknh00RNOnMiQ4T0aPKiLECc5w5
         Oudhz7JDhkhkwbvn2PxyaatsnP0v8eAMlS1D5HzGig1pOSSg9KKRJFK3RRfVwi6aAR4M
         EGFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757635579; x=1758240379;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XQ+S/AjoUpa12H97dfICorV7t0bCnG6lmMpJwiBX4/M=;
        b=PEN8wIcl9EzG9uWSpBNt/n/vBQJr/o1tka8I+4ex/AUUv1l1Rm0zet+E3P/TfhJT0w
         0QNOAP4khJBvlvVpTzPDNR1otgpK3FUnwGiiDP/TqVEZLtvqH0I63bwj03auJrmjztFt
         ufxvx8MVdwbJ8lOd1T2sqsZyMiz4ZctUg6WW2Yh7DR8Z4Kegz/6DfuYOguVsgaqWa3Bw
         3o7aESIBYGczBwIGu/tmRS27gDAec9fuZuXpN6tFsigqdGcfDNYCaLlKaOMwhdw+uxGu
         +J2UyqqXXsqWfVCUG0Gr0n6x8DhFpxzgS2CLeqfaR46m2KSbgQELivSY6nj5swCbDDMD
         0Y+w==
X-Forwarded-Encrypted: i=1; AJvYcCWvRtpBQkZuxKRdS+W6wIohR/faSe8ztZrdNfFS4+LyYkrgemrPeo1p3+sbIqvhp/q225phVDAF1g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxaYoh7ieIhyezPoiY9soV4TokoX0KwaQjFY4Tn3v+7HPkqRA2S
	KLK9Y51AAzgxA+j1vsbeYqOkMXP6Z3rRqHPgsjODkiHG2G4HLMjkPeDlNvYUSnpxZkI=
X-Gm-Gg: ASbGncvXt3lU0UtY/dPEv0cwdSjW5ynZWEVGC/so9+B1a4CI7oVfrYNrzGppkpLIxlC
	emAzvfFTXs7fxFkn1oJrt7ONsqreS+pBkAqEPOv9dt/78w08rlcppvbqqLRrahEWi242pwQHKW5
	+StIonrYcZOP3G8djPwa/sTDecao96JN0+gIcFZqlzAzbiwuleulTFpcIal9cRGTDDYfyyWXWY/
	/NV7h1g0GabVyZR9A62MQR4/WlPKLwi588tWPqKcoNTNRV1dhU3EBQWSspGZatUnZ2CYPwzRsOY
	dv8qcmmyNhKNl7yk7N6pnq7bRWmxtOiT75dFbdt84xAJjxSf86C6NwzL+dX0A7nGhhYDmZLB6Ns
	FuR5rUY91uScU8oGUiR67JZTNCVd6p5e1BVrScVTV61uQkiZ3moA8qCO/RrW6KQn6bi0MrlrFly
	N7SL/55ZZPf+xOUaLz8fKnSipy6gEv3knkk8MdcNJAHKhz
X-Google-Smtp-Source: AGHT+IFskXhj3JotjTK7+H0Jl9VGIBaJvG/P81CDfESkKjEB2nYSiqffBM8TrVpfVHiNaEyyyaOlqA==
X-Received: by 2002:a05:600c:1f8b:b0:45b:47e1:ef71 with SMTP id 5b1f17b1804b1-45f21221db1mr10323485e9.36.1757635578608;
        Thu, 11 Sep 2025 17:06:18 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f31f700023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f31:f700:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e0157cc84sm22899865e9.7.2025.09.11.17.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 17:06:18 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: Jens Axboe <axboe@kernel.dk>,
	Fengnan Chang <changfengnan@bytedance.com>,
	Sasha Levin <sashal@kernel.org>,
	Diangang Li <lidiangang@bytedance.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>,
	stable@vger.kernel.org
Subject: [PATCH] io_uring/io-wq: fix `max_workers` breakage and `nr_workers` underflow
Date: Fri, 12 Sep 2025 02:06:09 +0200
Message-ID: <20250912000609.1429966-1-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 88e6c42e40de ("io_uring/io-wq: add check free worker before
create new worker") reused the variable `do_create` for something
else, abusing it for the free worker check.

This caused the value to effectively always be `true` at the time
`nr_workers < max_workers` was checked, but it should really be
`false`.  This means the `max_workers` setting was ignored, and worse:
if the limit had already been reached, incrementing `nr_workers` was
skipped even though another worker would be created.

When later lots of workers exit, the `nr_workers` field could easily
underflow, making the problem worse because more and more workers
would be created without incrementing `nr_workers`.

The simple solution is to use a different variable for the free worker
check instead of using one variable for two different things.

Cc: stable@vger.kernel.org
Fixes: 88e6c42e40de ("io_uring/io-wq: add check free worker before create new worker")
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 io_uring/io-wq.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 17dfaa0395c4..1d03b2fc4b25 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -352,16 +352,16 @@ static void create_worker_cb(struct callback_head *cb)
 	struct io_wq *wq;
 
 	struct io_wq_acct *acct;
-	bool do_create = false;
+	bool activated_free_worker, do_create = false;
 
 	worker = container_of(cb, struct io_worker, create_work);
 	wq = worker->wq;
 	acct = worker->acct;
 
 	rcu_read_lock();
-	do_create = !io_acct_activate_free_worker(acct);
+	activated_free_worker = io_acct_activate_free_worker(acct);
 	rcu_read_unlock();
-	if (!do_create)
+	if (activated_free_worker)
 		goto no_need_create;
 
 	raw_spin_lock(&acct->workers_lock);
-- 
2.47.3


