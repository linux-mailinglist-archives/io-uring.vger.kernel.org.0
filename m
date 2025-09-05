Return-Path: <io-uring+bounces-9586-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AA02B45277
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 11:05:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2F493AFF02
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 09:05:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4D5730CD88;
	Fri,  5 Sep 2025 09:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MQ6ZgIuv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5472459E7
	for <io-uring@vger.kernel.org>; Fri,  5 Sep 2025 09:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757062985; cv=none; b=ac8M8g2IR0W0cc/eGLqM2jAw/ykL4GzjmtASNhBRZip8+mTyIIeyAx9WDScD9Bl12+vDD+fqgg20bD8ARaDWgvgNQ4BioI9KNLw/ik6ECNOmZ2mfEhe9EnRGRJH6jpKZCog+NFPYMLNMkcKDbrqJv8qjVZmO2imHxVw8znb4zzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757062985; c=relaxed/simple;
	bh=VaAvxpmvWpcIRNYfIuBLuLBDWVBAraDDL2Dkr33I3Is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b5B+69f2FTUYZI94Bmdxy1vQ5DaW18IvD0agyb4d2eYFbGf9i+F1KFl1kzlRvGfL34VqByyCyegof/ISD1S4EBGtX+aLguy8KhZRZT1i7XvIjeH6/kTn5n7jW77EJFZ4zl/c6dYoOEiP+cUO3pMC5eLgPDq77eyTiSssd+X5ILc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MQ6ZgIuv; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45b7d485173so12704075e9.0
        for <io-uring@vger.kernel.org>; Fri, 05 Sep 2025 02:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757062982; x=1757667782; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nt/BTMnZjbckMMcIPhoa5XW7IR0P0ZrQGAwnv9I0YWM=;
        b=MQ6ZgIuvqyn4wYzMaFqInMzUR18fRIKPXaHdiIbE59jEnnttwgLehx2cvveZdZlYxI
         wXM5Sa2rfGGUL4n6OZtgSLrI0wYXGM5W7D0d3yj58Ub5902B2uCEAL2TOabOkdqDXUYu
         8n92A7Y/lxnmFCdKQrALU3aqHQ9uTBfmvvUkSio0XhYCWj0+BOKbiY3qtNaOOMMsYAnl
         n326mcTkxviT+IXAn+niLhbl/Qz0xWmym/dMDe52513uje5vRwzsNlcZ/j/nHUkAX+LC
         D7+Bb5bETitnppHf6gp9gAMg1F1Dkw8qLIwmULTL8JPrYvbP2PqDfFRXXTgphjvsB12a
         IkjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757062982; x=1757667782;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nt/BTMnZjbckMMcIPhoa5XW7IR0P0ZrQGAwnv9I0YWM=;
        b=rtgszcspFWV8pVX569XV+QrN7tvaHBD3cKuEw2CuzWwLHKvYpuGoMx1bRbX8dq8caP
         vZcN4L63zAPircXZy4eiztfTJH/k0VTQ2aKjlQ0e1c8UUT289KcWnBplSQ/Z4db+TxKU
         qIQyfxxCoq3eWpA1D9hPOgVoJyZlE3pG4biCR+YB9NMsJOXaNN3ppcgwAWe1USc1wt3r
         sO+fx8jjnmSNUHm0OHqKEkeAjmFonNST+mIbmL9cqAZym9yxy4UA0lapKjFNfIuMDcRE
         fKpiNnXX3PXksAqdt5Mnz2UlBg5TdWxqHNZ5Gj5lirRokhunDuSD6mOOk5uWqywIs3LC
         8FQw==
X-Forwarded-Encrypted: i=1; AJvYcCVyw7AB+hFtp2EjGqDqDeMAOYuYZlG5y/OwXQ2cZA4DlD2n/aXrNKAJN80pj1tAUVNn2y8qnAp5Kw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzCYed1bkXNqWs69BfUcv5sMySJ15sksWxu6o/bdMMAm3BVFCB5
	zp79k8Aknk1zo175YcxyB72IvT7AbO8kHDGoSjSzA0KIaiwKE/GynWEE0OUu1wvWxtg=
X-Gm-Gg: ASbGncuikv6FG2wIRKPq0Q+GrMAwx8kwjsB1Ck48AoYlrunpBTjpAimjQ+Si6ADRTs2
	xf+fuDoSy65R8B+e1rVxmQhUQ8H3VWx2YeOtMEdVcExz0pfc5GNpbpTjzd85woJDgeD4Jhpb3Rw
	p8+ONxHyZPBcvsq6jS4uLxSOON/Al/J9xCS0jIAlKUSPvYoCQIMcVznYRdvDOa9cr6k8XJHoX6i
	lpRq+rpVIitXaAQRtpccWjWkPby/g0iMtq0L5dDpryg6onP+bSIJ80qEGMgR16HlV6WQ1Zaj10i
	uzC62w9dnSrHcDvrZhZu8j5fzQCa9WWn185EJWdsAY6AHcLXakXBtxFZkb6m6WqWSSGnJnTIjhA
	yfYTnxCA8pkrHuKaRPICrjVTKx8Vagee+RgV316rUtokHXWE=
X-Google-Smtp-Source: AGHT+IG24LG76Z8S7qjGz27+3F1ALNcnbEoV9/XxGeTDwaPVM8Afb0DdvYFTxZIXBCPoWwayYgKRDQ==
X-Received: by 2002:a05:600c:3153:b0:456:1b6f:c888 with SMTP id 5b1f17b1804b1-45b85570cffmr189956765e9.23.1757062981863;
        Fri, 05 Sep 2025 02:03:01 -0700 (PDT)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d66b013b7dsm19653105f8f.28.2025.09.05.02.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 02:03:01 -0700 (PDT)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 2/2] io_uring: replace use of system_unbound_wq with system_dfl_wq
Date: Fri,  5 Sep 2025 11:02:40 +0200
Message-ID: <20250905090240.102790-3-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250905090240.102790-1-marco.crivellari@suse.com>
References: <20250905090240.102790-1-marco.crivellari@suse.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently if a user enqueue a work item using schedule_delayed_work() the
used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
schedule_work() that is using system_wq and queue_work(), that makes use
again of WORK_CPU_UNBOUND.

This lack of consistentcy cannot be addressed without refactoring the API.

system_unbound_wq should be the default workqueue so as not to enforce
locality constraints for random work whenever it's not required.

Adding system_dfl_wq to encourage its use when unbound work should be used.

queue_work() / queue_delayed_work() / mod_delayed_work() will now use the
new unbound wq: whether the user still use the old wq a warn will be
printed along with a wq redirect to the new one.

The old system_unbound_wq will be kept for a few release cycles.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2a6ead3c7d36..74972ecf2045 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2983,7 +2983,7 @@ static __cold void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 
 	INIT_WORK(&ctx->exit_work, io_ring_exit_work);
 	/*
-	 * Use system_unbound_wq to avoid spawning tons of event kworkers
+	 * Use system_dfl_wq to avoid spawning tons of event kworkers
 	 * if we're exiting a ton of rings at the same time. It just adds
 	 * noise and overhead, there's no discernable change in runtime
 	 * over using system_percpu_wq.
-- 
2.51.0


