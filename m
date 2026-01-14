Return-Path: <io-uring+bounces-11706-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A6E9FD1FAC4
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 16:16:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 11DCB301B499
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 15:12:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A276278E63;
	Wed, 14 Jan 2026 15:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ks7/lP0u"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f196.google.com (mail-oi1-f196.google.com [209.85.167.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3154F1EF09B
	for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 15:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768403540; cv=none; b=OhjkPE5QZO/bDQmNmouKXQEeeYIuDlbtmdvzo34gPQgRlb1O/V+B5ayh4nM4Z3Y0Ft6wunQfspMxLqEacescDN98DE/95bgPnlCJC0rdOI/81wCNQ3KJHQUMXrPuSt4bIai6ihDdstH+ZC8sHoj5cjrSq8l2Q9d/+g01PdcLA38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768403540; c=relaxed/simple;
	bh=YR6CMYE1KTUVpFnj+umG4Rr50/4sxmaCJzXKV8IgA7Y=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=C3KGq7Ci9QFKD+/VfAM/1JaXoiE7qOadEPnjOWj+IqUtUeG3Q2fGT83vgUDqmYXPyajUVnxyrZCurg1vBk+IlGn3GRzM2X3SkkG88EMdDAwMEtA820EmxdFPFSda7greMBtnMbL2A6iDebPHkzj1u5vrVl10Q1BnYYifM0An+0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ks7/lP0u; arc=none smtp.client-ip=209.85.167.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f196.google.com with SMTP id 5614622812f47-4511f736011so574590b6e.0
        for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 07:12:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768403536; x=1769008336; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6ttmlb+w50qhP8C1edOUlKlT3WXzbZ6Zta1DCmyJ1Y0=;
        b=ks7/lP0uaJAbpPHTSBxJX9M2T1AmrnbF/UMKS7Nq7CTKbsvUVBR0RqQa9qmMkls4ub
         neJAigvSbe9ZwZfU7FZ8QHwpXpynDZvEU92/OUQqkCrNKyv4yWVZXiez/JqR4ikDG9Rl
         SXQm9LSx8nC8XMhgmGQ+z7tdiPe/AXHUGEuMp4KrM5dNr4KHP2bEfcm2l0SSn9pKLJst
         ggnMLuinUSwCrA5Z9jb7im+zbQFGDcQUHDmQ8nkJ7NTOWGt8Gwi4oViw7Fmj3KbR/ufB
         C6aoYoAL5WBiXGB8BokZFEpdET3JteSxoZbcIXUHpxK7D+AceBX0b40b4UGMbaR/96A8
         8gjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768403536; x=1769008336;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6ttmlb+w50qhP8C1edOUlKlT3WXzbZ6Zta1DCmyJ1Y0=;
        b=H8HoVsriMESo/Qfggk66W1btYHvgxjWFIRXlZwaiKE3XEIGCrSnHIE2OiWrQOfRslq
         mExDhidfcECOEMf6fCFZ2Gm6G/hWH5ALW590dr/QroHlbA4q4imbphNdaxR4xUMGd//9
         HQG4UeVWlXgkZYAWDSaV6H9BBTmTa/07ktBH4qdH6tyjCDx/fBbcwr9Kentro7GZp6qT
         1NV7XTur2ArJ0FsDfoNTCb19TKISypH11vyPy508O90aNKGVtSX4maO4zEjKvWiTEmW3
         HsAhQBGt0tNmGosp9pqgTYVpOJfcZpL6RkYJys3+yanWHMhjXJDIelqiGFftnGo8162G
         IhcQ==
X-Gm-Message-State: AOJu0YzhC86O/8hPiVNftGpySYLNZvhETnGxYF2Y5MyiurPonZmYIYla
	sHpFTnL3Mg6gETrzlcfhxOwwIbM934rOdhnmWB1op9R84Kv8MLUNBluNeFGaq6QmbZBNKAApa2c
	bNlaF8uE=
X-Gm-Gg: AY/fxX5a+4kIE2Bpd2uKzo39rD6E8rzt25DU5EECXbWG72BOLZxq5RYp9mn2s+SAnxq
	MaBDeDlk2Skzi2tOL6M9gnKw98lnzIkhLnDeLu4D/5n/Xg5qhJ1nhE4+HcQDOmnnf3RjnY8EXqW
	STyZNwm4y0Fv1spfYMR6LENaZxnC3sQrPWIzrvuhPioAw6pInt/W65a9Ww3lyUGSVmbFzYGb61d
	YYuAunQjfxx5gfXjioqCx+WUzFJ4tE0SOxFccODRoVuRb4Sny4cclZzslV86F0lHxaDfHvUf7sl
	16KJlau7SDUFiY6ldfDmAJQ07P8gKRVi48ZdaWSw0eYMriU1p2x+22q1wTnSC5+NJ9xCTczlp0u
	C5aACRlDv8rC/WnJxCL7lsDT7uDyLJhb+1A1fMS8pgrGzmajuLS4lcvZWUDsqNxgQeW3pY++yM0
	2ywbb7J21PNjWQR9Xxdg==
X-Received: by 2002:a05:6808:c14b:b0:45a:58af:fee1 with SMTP id 5614622812f47-45c71417c09mr2271467b6e.16.1768403536319;
        Wed, 14 Jan 2026 07:12:16 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a5e1b0779sm10838729b6e.7.2026.01.14.07.12.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jan 2026 07:12:15 -0800 (PST)
Message-ID: <b60cab06-92ad-467b-b512-1e76ec5e970e@kernel.dk>
Date: Wed, 14 Jan 2026 08:12:15 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: fix IOPOLL with passthrough I/O
Cc: Yi Zhang <yi.zhang@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

A previous commit improving IOPOLL made an incorrect assumption that
task_work isn't used with IOPOLL. This can cause crashes when doing
passthrough I/O on nvme, where queueing the completion task_work will
trample on the same memory that holds the completed list of requests.

Fix it up by shuffling the members around, so we're not sharing any
parts that end up getting used in this path.

Fixes: 3c7d76d6128a ("io_uring: IOPOLL polling improvements")
Reported-by: Yi Zhang <yi.zhang@redhat.com>
Link: https://lore.kernel.org/linux-block/CAHj4cs_SLPj9v9w5MgfzHKy+983enPx3ZQY2kMuMJ1202DBefw@mail.gmail.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index e4c804f99c30..211686ad89fd 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -713,13 +713,10 @@ struct io_kiocb {
 	atomic_t			refs;
 	bool				cancel_seq_set;
 
-	/*
-	 * IOPOLL doesn't use task_work, so use the ->iopoll_node list
-	 * entry to manage pending iopoll requests.
-	 */
 	union {
 		struct io_task_work	io_task_work;
-		struct list_head	iopoll_node;
+		/* For IOPOLL setup queues, with hybrid polling */
+		u64                     iopoll_start;
 	};
 
 	union {
@@ -728,8 +725,8 @@ struct io_kiocb {
 		 * poll
 		 */
 		struct hlist_node	hash_node;
-		/* For IOPOLL setup queues, with hybrid polling */
-		u64                     iopoll_start;
+		/* IOPOLL completion handling */
+		struct list_head	iopoll_node;
 		/* for private io_kiocb freeing */
 		struct rcu_head		rcu_head;
 	};

-- 
Jens Axboe


