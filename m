Return-Path: <io-uring+bounces-3091-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F3AAF970A8C
	for <lists+io-uring@lfdr.de>; Mon,  9 Sep 2024 00:43:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1195281BFA
	for <lists+io-uring@lfdr.de>; Sun,  8 Sep 2024 22:43:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F87716131C;
	Sun,  8 Sep 2024 22:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YyRnzJBb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D83F14D420
	for <io-uring@vger.kernel.org>; Sun,  8 Sep 2024 22:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725835434; cv=none; b=BTLZsIBmn0QLPcL1lRMJ4o+tf/mdym2buHw1/OLd/S1Dy9OK8Ft/SKNz1xtRXiyv8w1eF/hnp1j7NKT02l/3CDRHXnXWGgP5SunIJbcG6hht1Db2bMA5wIIIyZlGxGWXrVae7YUzYjOoGMs1QT9w+WXD19pKNbN/BP0q5gLhfHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725835434; c=relaxed/simple;
	bh=3Kor3yv3ywm3saN1nnfM5YfFsoGmPxm1ickkJWyVMSk=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=MSR4BUszjbE/3s2y5tG0InR0KN5LkNCMGsIsNjBd1vSdBx8N5TfVP27uiKihn+bE5bs3+abeRJ4UsKd+uGLMT1HzMhL+LaMKLyla8djYBfZIcqR1yXE8Dp62cKk8j0Yez7knmxc1f+wjnKATSF5u+dMn3mWWRuvs9O4M/uEtJZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YyRnzJBb; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-7cf5e179b68so2832265a12.1
        for <io-uring@vger.kernel.org>; Sun, 08 Sep 2024 15:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1725835430; x=1726440230; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iAyLddTqguzkGr3Wj05/22DLnL5wITmlleipJ1mo33o=;
        b=YyRnzJBbK5Mt5UNhSvlBQahLxldL4dZ3OI0s0jK2W9yM55oKYxagGe8hMJHKX8kYzU
         6PFwGvF2xppvoMdZm65F8asNVSEZ2lppXM2qyLfMQmPRNBG7JLQ5f2ScXsKuutH6syB8
         7kXvz5IlUmsx+X0EqQkytt9JJCkOr1EhoDlMmX3NT9zhbwNMZwwac28YuZq6aj35bts2
         4eFWmiSGK6BtP1cOaYd2uESKXp8QK0poayd30rIeSDoiZXvBYWqH7gqiQ57NWLbOTyMS
         H38qZ7LiMfe30uj3sdUp7jerCiNtE8yp6v5i+fyNlvAclIp72gckIfi0mN5acOL3KwzS
         pUoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725835430; x=1726440230;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iAyLddTqguzkGr3Wj05/22DLnL5wITmlleipJ1mo33o=;
        b=BUrzfk6doZAqFkxhjBNL9dRgysr6kqBDhinPD6MSLJlWHUFy3jrfTNGR1fMuN6RfmB
         WdnfmBe9Ylf+J6+rudLXtYtaVws7guDrx/svXNNyYcUVbvH0hlsUihzi7iYdQBts0UFp
         nX1YxyzyK9mOM5yPiTYKTtwzriAu/fSGDf8xbibfkWmqlxObZaqx6oD2CFZNs/pHuU5f
         e95O2go8j/hR72jhruux/AdUKekM8Qa/CTYtjJ0QhMQV9viNtCZXbeDGBeLZpRkuqkmY
         OtZeHFKebjEpx1g8JvVSHg22sCTYfdHEnkXgMTNrFdvCnj9giYaoUvjFTm58bZ+ZRobC
         FaQQ==
X-Gm-Message-State: AOJu0Yyvkiv9UutCN54cqjFeK4Hpb+uN1rb2uzntGkhfjNGBsTMcS4pe
	ETsQTypK76801ylnTjy+GJOZW+CAC7NNTY9e7YDVwCqQ+qx7eHq9+N7dKe+bAvZkA60vHoFPHdp
	Q
X-Google-Smtp-Source: AGHT+IHov+8cO+ICJ8uGXkOn/pFAVIGmNPdR9TfHGwVn/VjLuqTrvJRI8NWjzP0XuaoFJBpDONJNbw==
X-Received: by 2002:a17:902:ec91:b0:206:9c9b:61bb with SMTP id d9443c01a7336-206b7ce742fmr211197475ad.6.1725835429495;
        Sun, 08 Sep 2024 15:43:49 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20710f21726sm23529405ad.236.2024.09.08.15.43.48
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Sep 2024 15:43:48 -0700 (PDT)
Message-ID: <03850d46-6ac5-42d0-b43d-2f5744fb8091@kernel.dk>
Date: Sun, 8 Sep 2024 16:43:48 -0600
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
Subject: [PATCH] io_uring/eventfd: move refs to refcount_t
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

atomic_t for the struct io_ev_fd references and there are no issues with
it. While the ref getting and putting for the eventfd code is somewhat
performance critical for cases where eventfd signaling is used (news
flash, you should not...), it probably doesn't warrant using an atomic_t
for this. Let's just move to it to refcount_t to get the added
protection of over/underflows.

Link: https://lore.kernel.org/lkml/202409082039.hnsaIJ3X-lkp@intel.com/
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202409082039.hnsaIJ3X-lkp@intel.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/eventfd.c b/io_uring/eventfd.c
index d9836d43725f..e37fddd5d9ce 100644
--- a/io_uring/eventfd.c
+++ b/io_uring/eventfd.c
@@ -15,7 +15,7 @@ struct io_ev_fd {
 	struct eventfd_ctx	*cq_ev_fd;
 	unsigned int		eventfd_async: 1;
 	struct rcu_head		rcu;
-	atomic_t		refs;
+	refcount_t		refs;
 	atomic_t		ops;
 };
 
@@ -37,7 +37,7 @@ static void io_eventfd_do_signal(struct rcu_head *rcu)
 
 	eventfd_signal_mask(ev_fd->cq_ev_fd, EPOLL_URING_WAKE);
 
-	if (atomic_dec_and_test(&ev_fd->refs))
+	if (refcount_dec_and_test(&ev_fd->refs))
 		io_eventfd_free(rcu);
 }
 
@@ -63,7 +63,7 @@ void io_eventfd_signal(struct io_ring_ctx *ctx)
 	 */
 	if (unlikely(!ev_fd))
 		return;
-	if (!atomic_inc_not_zero(&ev_fd->refs))
+	if (!refcount_inc_not_zero(&ev_fd->refs))
 		return;
 	if (ev_fd->eventfd_async && !io_wq_current_is_worker())
 		goto out;
@@ -77,7 +77,7 @@ void io_eventfd_signal(struct io_ring_ctx *ctx)
 		}
 	}
 out:
-	if (atomic_dec_and_test(&ev_fd->refs))
+	if (refcount_dec_and_test(&ev_fd->refs))
 		call_rcu(&ev_fd->rcu, io_eventfd_free);
 }
 
@@ -137,7 +137,7 @@ int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
 
 	ev_fd->eventfd_async = eventfd_async;
 	ctx->has_evfd = true;
-	atomic_set(&ev_fd->refs, 1);
+	refcount_set(&ev_fd->refs, 1);
 	atomic_set(&ev_fd->ops, 0);
 	rcu_assign_pointer(ctx->io_ev_fd, ev_fd);
 	return 0;
@@ -152,7 +152,7 @@ int io_eventfd_unregister(struct io_ring_ctx *ctx)
 	if (ev_fd) {
 		ctx->has_evfd = false;
 		rcu_assign_pointer(ctx->io_ev_fd, NULL);
-		if (atomic_dec_and_test(&ev_fd->refs))
+		if (refcount_dec_and_test(&ev_fd->refs))
 			call_rcu(&ev_fd->rcu, io_eventfd_free);
 		return 0;
 	}

-- 
Jens Axboe


