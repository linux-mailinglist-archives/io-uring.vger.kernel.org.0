Return-Path: <io-uring+bounces-8098-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A7F2AC2283
	for <lists+io-uring@lfdr.de>; Fri, 23 May 2025 14:18:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AFF199E5E22
	for <lists+io-uring@lfdr.de>; Fri, 23 May 2025 12:17:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55D9922D9F7;
	Fri, 23 May 2025 12:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1N/k5Nor"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4E52253A9
	for <io-uring@vger.kernel.org>; Fri, 23 May 2025 12:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748002690; cv=none; b=mG4OSOupPoOfL/+dDJKCOHzuZ4Ty2T3uspGfcZRGtShy1qMgai/e5FgeiUIpYc0or7XwT0es4MjXtNTwtxcGucGhPNdX2Mxc7te4wSWj7dgxnZDgcxe6satHrpCIX9eyHd3iOOUm8I542oQcBw/Y/HTfRHyUZSDVWxyTNaPrmnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748002690; c=relaxed/simple;
	bh=JW+Yk8pOfPAtOL7yS7xaQqrCU97nVhD134tEHuingm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lyl4npA8Scz2/Tb0IGJNz+gfQyROaIUos0gNrRHeCcjjNJ5c8Yuw6gWw63NN/B76/FLgBT+P5m/WJmZPHUjZPdd+N3zquRl7ThiXv9pX4rJWnjIBZXhDuTEZ7ZIRvtrxdCZHaXVlsHAJPcuTs17llZwc5Txhij+2jPQwhw+lZa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1N/k5Nor; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-609e7f3caf3so5254712eaf.1
        for <io-uring@vger.kernel.org>; Fri, 23 May 2025 05:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748002686; x=1748607486; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tqyxMcNGA5qFCaeguIjR/Aup3i6uvkpEnscb+i8B/n8=;
        b=1N/k5Norn/cXb2pYpEmG0A2QeML0r1T1b4JyDeNBIc6yk97byXV9la/zkL7ayECtOQ
         CMZVyhnrFQlN0PSjsfV/P4Fm2LNTWN4ORCGyeED0auYL6jugDzRMPKdjlpsexd6yJ0iy
         +nwP3UOdCpscdWj8izbN+od4nd54MG2NgKba67GNxh+zosn4q+iC5CaFIgx0P6o03yHx
         aL3vH8xCMyUTjpqaYeIx20c8xqNXVzCVqjq2j1Un2tVGXe7+udGNBc2sUa2gjru7A/R7
         XIGvIECnpDgjSh8DHTVRDdLQgk6FojXjEDMTavWfw8hqXed0Kjzv0+dcQiZjyUhPm0YB
         EaXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748002686; x=1748607486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tqyxMcNGA5qFCaeguIjR/Aup3i6uvkpEnscb+i8B/n8=;
        b=cpNSXRMjGblzCrylwRiDsNQX0Nxezk4lIx7aiVhKNFuCPDjj7645RWPHZkqc02mfVD
         TYIFPUlGRS+YpUjRtkcaR85HCOrartTxV0voPFtYtXbix+EDh9ZOSiECrdghAAzVZs70
         tYCedrczP7X5xhd8EuYA4aLOuYHQnzsFgKnEPFk+nzhxvpO8RMIyWUyujLpsStTNbPjQ
         qspXEvO/TBXULY/FovBPz8GXTvY8KLU7Ibj/NDRwl8+WLjpRCjmVdzkaQoi5OcsKBIYc
         WEv8ZwQ23kfpcKul+KTuG9XhfjLcBc8LwbZVT9VqH1tcjD6yKK5viMOu3pkiCi5c9K9L
         yB6A==
X-Gm-Message-State: AOJu0YyO68YjZLXjuWxmkYXovwGCQdhjDhlXnxlJQRTJd4SF/pzoF6+u
	Yu6s9v2Fwo7SIQx+RtacpIS/yePyl6e9O1n31y0j4z0U7f6u93qvOmrdJHyQW23nZOd1c4oJGUS
	UmKtV
X-Gm-Gg: ASbGncto4fvmsJ15mSMSWAGR5IAs5WwmR7BoVM3GTV87P6viSz28F7k9fZZV2XuLEb+
	AilH/ANQNamq0j/JA5BRJ2Qw+347f85JQeYFST51kR/jYJqq3H6HQQAaVQuRRBO0UE7e/6mzC72
	iwZdClFbs/IqU4G6hc1fK7LNtK01hx+858KUtCxKc9NShkc8mmei8Eecgk0xE/NTSEthoGw0R3q
	KKxUr+FpdpdBHlaQxfnpDhVp5IKjb0u5zHBx7DDJh/z+8c9cYrIuY4zAYhTCqqV5kXuNc/0pz/e
	qoFjZ+G+zqPSCHWZE4d+n/lp5m7B3tlnIC/RRG0Ar4dGffTWJEH3ncXC
X-Google-Smtp-Source: AGHT+IGhsjO9TZKHuf8VgKTnzaeWFyvwvXrEyly+CzNmvOc9Y4jGnVgHB5HD8l+NZRZ0LkV8Y5SFsw==
X-Received: by 2002:a05:6e02:2788:b0:3d8:1b25:cc2 with SMTP id e9e14a558f8ab-3dc9326cf12mr29257625ab.8.1748002676249;
        Fri, 23 May 2025 05:17:56 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc3ddeafsm3617552173.71.2025.05.23.05.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 May 2025 05:17:55 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: changfengnan@bytedance.com,
	lidiangang@bytedance.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring/io-wq: only create a new worker if it can make progress
Date: Fri, 23 May 2025 06:15:15 -0600
Message-ID: <20250523121749.1252334-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250523121749.1252334-1-axboe@kernel.dk>
References: <20250523121749.1252334-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hashed work is serialized by io-wq, intended to be used for cases like
serializing buffered writes to a regular file, where the file system
will serialize the workers anyway with a mutex or similar. Since they
would be forcibly serialized and blocked, it's more efficient for io-wq
to handle these individually rather than issue them in parallel.

If a worker is currently handling a hashed work item and gets blocked,
don't create a new worker if the next work item is also hashed and
mapped to the same bucket. That new worker would not be able to make any
progress anyway.

Reported-by: Fengnan Chang <changfengnan@bytedance.com>
Reported-by: Diangang Li <lidiangang@bytedance.com>
Link: https://lore.kernel.org/io-uring/20250522090909.73212-1-changfengnan@bytedance.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io-wq.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index c4af99460399..cd1fcb115739 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -419,6 +419,30 @@ static bool io_queue_worker_create(struct io_worker *worker,
 	return false;
 }
 
+/* Defer if current and next work are both hashed to the same chain */
+static bool io_wq_hash_defer(struct io_wq_work *work, struct io_wq_acct *acct)
+{
+	unsigned int hash, work_flags;
+	struct io_wq_work *next;
+
+	lockdep_assert_held(&acct->lock);
+
+	work_flags = atomic_read(&work->flags);
+	if (!__io_wq_is_hashed(work_flags))
+		return false;
+
+	/* should not happen, io_acct_run_queue() said we had work */
+	if (wq_list_empty(&acct->work_list))
+		return true;
+
+	hash = __io_get_work_hash(work_flags);
+	next = container_of(acct->work_list.first, struct io_wq_work, list);
+	work_flags = atomic_read(&next->flags);
+	if (!__io_wq_is_hashed(work_flags))
+		return false;
+	return hash == __io_get_work_hash(work_flags);
+}
+
 static void io_wq_dec_running(struct io_worker *worker)
 {
 	struct io_wq_acct *acct = io_wq_get_acct(worker);
@@ -433,6 +457,10 @@ static void io_wq_dec_running(struct io_worker *worker)
 		return;
 	if (!io_acct_run_queue(acct))
 		return;
+	if (io_wq_hash_defer(worker->cur_work, acct)) {
+		raw_spin_unlock(&acct->lock);
+		return;
+	}
 
 	raw_spin_unlock(&acct->lock);
 	atomic_inc(&acct->nr_running);
-- 
2.49.0


