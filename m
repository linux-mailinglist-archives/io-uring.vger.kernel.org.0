Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5A693616C2
	for <lists+io-uring@lfdr.de>; Fri, 16 Apr 2021 02:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235660AbhDPA1f (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Apr 2021 20:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234716AbhDPA1e (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Apr 2021 20:27:34 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12901C061574
        for <io-uring@vger.kernel.org>; Thu, 15 Apr 2021 17:27:11 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id e7so16015607wrs.11
        for <io-uring@vger.kernel.org>; Thu, 15 Apr 2021 17:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TBS3hidTzfErx67oBTfwa9TrDgEVlP0lRUeyk0lkCyM=;
        b=jxRbESnGGGesMrBX2chBWH1pNdMUObLYxV2nhFPiCmnEhQWMKYn0/fuR7eQSNTppa2
         IqDpO5U91EW99JU4ysZ8UWjUYlfnaDYUBOoXFKuFLEGVTE6jAdm9l3gyXkfffoAtztHc
         KO4NabZYB342ilrgp2L3iPZLecsWuJTOnzCqK2e2yYaeN0llDPqPMCBdTT3uuMbC8Lc4
         o/H9jBIbGG7gAP7e9Hj/D5bODqrjHVjEa9Zgrgbt6AuI+clFg+KGd4bs+jJA81QW3pLu
         7JbMnM9bFvsuKZCpke46HnC2VKHStTHF4l8qSWI92X66KytxUMz96KYqb4Mq335qH8OA
         auSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TBS3hidTzfErx67oBTfwa9TrDgEVlP0lRUeyk0lkCyM=;
        b=jJj6zPae6qO8plgQNyRW/Ifmvx8NjNdVQqLc9rSWwc4ggyqcNBUoAnFleieVo801QW
         VBrv70lTUhGxD09Zvx+2J4VbJennqNwVx9Z+YOmIzmrAE/OX104l8yv8zhQ3wg0UyS9B
         C9sWl+iqSoG1CK+uIYL9JCKDymq2ZWatH3KXim4ghj+0Cq4su73JdZaYcB2IM6MqDO7i
         Yek+rY8GXT0jfzvWuPiRGMisKOkqTsp5wulYLVxDVEhsKh6G6Ba+nVG3xYfpELwZbsrB
         tVQ3a6mofrmFWwhT1JuNVhAlCucW25jGkyyWdB0m3yTqlHMXhqF5uTLOPxokl5JYiYz4
         wEMQ==
X-Gm-Message-State: AOAM531N1WWMSIcGYKsZXB9WHUGMgodUsH8a7//jTLxW+kuMjVlbgLbR
        /vHjCVhlRHtFa2dJ2nqp7z8=
X-Google-Smtp-Source: ABdhPJzhwNS2a2q81XbJHvEhFpoear3Yty+ODKVK2gSgtUJil1Z1ON2/fB2np4UwsVCiY9obuD1uow==
X-Received: by 2002:a5d:6909:: with SMTP id t9mr6003142wru.69.1618532829879;
        Thu, 15 Apr 2021 17:27:09 -0700 (PDT)
Received: from localhost.localdomain ([185.69.144.21])
        by smtp.gmail.com with ESMTPSA id x15sm5611421wmi.41.2021.04.15.17.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 17:27:09 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>, Joakim Hassila <joj@mac.com>
Subject: [PATCH 1/2] percpu_ref: add percpu_ref_atomic_count()
Date:   Fri, 16 Apr 2021 01:22:51 +0100
Message-Id: <d17d951b120bb2d65870013bfdc7495a92c6fb82.1618532491.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1618532491.git.asml.silence@gmail.com>
References: <cover.1618532491.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add percpu_ref_atomic_count(), which returns number of references of a
percpu_ref switched prior into atomic mode, so the caller is responsible
to make sure it's in the right mode.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/percpu-refcount.h |  1 +
 lib/percpu-refcount.c           | 26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index 16c35a728b4c..0ff40e79efa2 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -131,6 +131,7 @@ void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
 void percpu_ref_resurrect(struct percpu_ref *ref);
 void percpu_ref_reinit(struct percpu_ref *ref);
 bool percpu_ref_is_zero(struct percpu_ref *ref);
+unsigned long percpu_ref_atomic_count(struct percpu_ref *ref);
 
 /**
  * percpu_ref_kill - drop the initial ref
diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
index a1071cdefb5a..56286995e2b8 100644
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -425,6 +425,32 @@ bool percpu_ref_is_zero(struct percpu_ref *ref)
 }
 EXPORT_SYMBOL_GPL(percpu_ref_is_zero);
 
+/**
+ * percpu_ref_atomic_count - returns number of left references
+ * @ref: percpu_ref to test
+ *
+ * This function is safe to call as long as @ref is switch into atomic mode,
+ * and is between init and exit.
+ */
+unsigned long percpu_ref_atomic_count(struct percpu_ref *ref)
+{
+	unsigned long __percpu *percpu_count;
+	unsigned long count, flags;
+
+	if (WARN_ON_ONCE(__ref_is_percpu(ref, &percpu_count)))
+		return -1UL;
+
+	/* protect us from being destroyed */
+	spin_lock_irqsave(&percpu_ref_switch_lock, flags);
+	if (ref->data)
+		count = atomic_long_read(&ref->data->count);
+	else
+		count = ref->percpu_count_ptr >> __PERCPU_REF_FLAG_BITS;
+	spin_unlock_irqrestore(&percpu_ref_switch_lock, flags);
+
+	return count;
+}
+
 /**
  * percpu_ref_reinit - re-initialize a percpu refcount
  * @ref: perpcu_ref to re-initialize
-- 
2.24.0

