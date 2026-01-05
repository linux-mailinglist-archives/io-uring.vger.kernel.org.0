Return-Path: <io-uring+bounces-11361-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 71573CF43D7
	for <lists+io-uring@lfdr.de>; Mon, 05 Jan 2026 15:51:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0D7CC3009696
	for <lists+io-uring@lfdr.de>; Mon,  5 Jan 2026 14:51:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 433983446B0;
	Mon,  5 Jan 2026 14:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="3B6FVWpI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f194.google.com (mail-oi1-f194.google.com [209.85.167.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67DA7335BCC
	for <io-uring@vger.kernel.org>; Mon,  5 Jan 2026 14:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767624362; cv=none; b=Ksy1PRwdOAwlXwm5LIU6JOR3nWaxwUsVR8gwKIjLbrkEyjtoapBhfhIxzQxPGUh4DR943nl9qvKx8BoIt9fV0D4O+EQixIkugOK9pn9VmC0+RPnGHtHDBr67Oncgi/kK4cs3f8Tmx/rRj0JFNva/jxO8IsmUjhgibHdUUg4Iyus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767624362; c=relaxed/simple;
	bh=Gmh6UR0LpYtZFFE1wBOfftPen5lNoACFYfqeu7sZIFY=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=L1Z1Xl+QYLQ9LQBUDh1z9HYtnC9wJqj7kmE9nxcRhq7fg1AGnlqYfe0V9Ga1ecbSEFabU3pF71bvoDuBYsyLeMJARwnLHvv7OC1eqsWlbr1u85OIxlFmm0UbCC9enFOqFUBT/L80nGxEPFq/Udl9p/7k14z3Cj9GP5cxEQ1npTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=3B6FVWpI; arc=none smtp.client-ip=209.85.167.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f194.google.com with SMTP id 5614622812f47-450ac3ed719so18430b6e.0
        for <io-uring@vger.kernel.org>; Mon, 05 Jan 2026 06:45:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1767624356; x=1768229156; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dKLtE+oZCF0FwP/bX1vmFWj+X1XIJLdeCuvw04SNjjM=;
        b=3B6FVWpIvS9XILwMSLfzF23L1Z+QJWNnfUIMzlu+IQuW0wy1qh8GAbMz1JKpcOEm0+
         moHbE0riEXRVnAEqX9tScGEpkwI1RCxiJX2XZRFTll6pb6NbV3YK/Yw7Ew1nShgCDeyn
         E6rLeo1gF5QZiOxrx4HWAFEPKrqOs+mvO/pwJWIijoLEEyudPYSJskqRKZVUCTTtFQBp
         gqt8OITeYfCWndgnop6CjnpqpK8HRovjn6CfJ54AaatX6kOY9hqKhCMPlEG5vXFWTmIj
         n2GqzQsy5/PtbYsuQUfr4I4KyayufjLQubXHcxGMoLCI0JnaN/eNbapcPptd/BCEuxVZ
         hOJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767624356; x=1768229156;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dKLtE+oZCF0FwP/bX1vmFWj+X1XIJLdeCuvw04SNjjM=;
        b=rj6S36Exhpg26zMqM6uH/gs0IlFpnmWmXZh1WJKcOISpVEU3RvTK4Ek8LE16I+svaP
         hsCymJo0LQcZU83WZ0Ay9XuXE4tdJXgQxrCCaP7hxrQLOBYqNHam70kXNtnz7fd/dhit
         DsPXn/O1ELVnv1fv394m0+YLRm8hcLcnx9je5/WFwOzqC5k+u/zaKBOfuPPMdcFNRPuW
         5FZGyfYcliOUxnnupmGWoMt0gIC5dLUCnZiuS7hjtOExhABYjGKaT2VMqLbQHI8fJowl
         zexF2sEXPFWi1KzQlZy/fTu+7ORP9aWpn8saMJ+Pbh8LToYOrSFPCQjhUKGJKJWyuthW
         03Nw==
X-Gm-Message-State: AOJu0Ywr79o9bfF1HAnhy3GNnQmWFJnLMTV3+eFEQqT7/FFRInU0HU3z
	SS1dFh9Kv4dEgDxIxJ75UbnpXLM/C4gyf+Tk1AyKfFTYXiDWllsumOfXIYF1RZ80DJbeXott5gn
	5v7DOb5M=
X-Gm-Gg: AY/fxX6tR3rq//KVHRWaQVKN1cRKetUNs5zBFRjVw1YuatunSZN4SUAPxhxjiJ9s7Rh
	5lWqSXDNg5Amfq3lSai4+zzPbIDfqsrIGWbd3+ONQFt77XiAwFejwUmq477l6cOBilVQrQB7r7J
	sal6cJxehYcB4JNSupCz7ppSC2SJhVLQW0W8lbXVLntOySPQlM3xLjyAAgH5hR03P089sWZQHJ2
	nEiQWCOyle3bCoKZaUw7YuAzpwV+O3t1EF3fHu9ENvXSQ9PGorDes+fEPaw6acGLUKhcHSo4Zhf
	ptBp3+/Nuoypl9kYMnwHWqup8uqxLJnzAe3trjMSOXZbLl5Ag5Mg/TSbRIfK/7uZ0brtmoMKa4H
	EaDadsHRLs2Gm5L5vnaniuEpf6RhRrFz596EAdoZG5wDoZAiiqvRrS1ftsuczclCKSF8IcpLa2p
	sfNQxDCbDQFAX/8HReE2w=
X-Google-Smtp-Source: AGHT+IEGDvG863f5Kt7RNkJpgoyJE8bH+fjxl6BVLdYnseG1gV/HAPrGuh3NRSD4221cpyxDb0X5lQ==
X-Received: by 2002:a05:6808:3445:b0:453:10c4:e8a8 with SMTP id 5614622812f47-457b22349bfmr22338454b6e.42.1767624356116;
        Mon, 05 Jan 2026 06:45:56 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-459f23f612csm8632035b6e.7.2026.01.05.06.45.55
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jan 2026 06:45:55 -0800 (PST)
Message-ID: <79dbdfd9-636d-426c-8299-7becb588b19b@kernel.dk>
Date: Mon, 5 Jan 2026 07:45:54 -0700
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
Subject: [PATCH] io_uring/io-wq: ensure workers are woken when io-wq context
 is exited
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

When io_wq_exit_start() is called, the IO_WQ_BIT_EXIT bit is set to
indicate to workers that the async context is going away. When that
happens, any worker alive should be woken up. If that doesn't happen,
then io-wq worker exit may take as long as WORKER_IDLE_TIMEOUT, which
is set to 5 seconds by default.

Cc: stable@vger.kernel.org # v6.18+
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Didn't fully bisect where this problem got introduced, it's sometime
between 6.12 and 6.15. But as 6.18 is the latest maintained stable
that has the issue, just mark it for 6.18.

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index cd13d8aac3d2..fd8c15ad2b97 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -1294,6 +1294,14 @@ static bool io_task_work_match(struct callback_head *cb, void *data)
 void io_wq_exit_start(struct io_wq *wq)
 {
 	set_bit(IO_WQ_BIT_EXIT, &wq->state);
+
+	for (int i = 0; i < IO_WQ_ACCT_NR; i++) {
+		struct io_wq_acct *acct = &wq->acct[i];
+
+		raw_spin_lock(&acct->workers_lock);
+		io_acct_for_each_worker(acct, io_wq_worker_wake, NULL);
+		raw_spin_unlock(&acct->workers_lock);
+	}
 }
 
 static void io_wq_cancel_tw_create(struct io_wq *wq)

-- 
Jens Axboe


