Return-Path: <io-uring+bounces-10463-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E50D1C43325
	for <lists+io-uring@lfdr.de>; Sat, 08 Nov 2025 19:15:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F4A93AF636
	for <lists+io-uring@lfdr.de>; Sat,  8 Nov 2025 18:15:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A8042741DA;
	Sat,  8 Nov 2025 18:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="lFuXdxqG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FAA27703E
	for <io-uring@vger.kernel.org>; Sat,  8 Nov 2025 18:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762625675; cv=none; b=ruWr8izaZcubCSDr28XE/1fMRiUxwm8clYky2u2ck3qTSmnCySf0arMLzfku766mnresIQGbJwxpx8WAGxbTMzrs7NJf3ElCSxgBNWwRFiU3LkwvgrmNpLM98BzZT6gbNoMQcPb5Ibqr6nFsDgOCNLqFzlcIC0VDZd+4S/y45CE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762625675; c=relaxed/simple;
	bh=swDa2PQ3bTyqse4dDEsB5XLEJB58Uvr9Sg1pgYPVJH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ljkIJVt3HAuHofSHgo4a8yZAGdmDfLMkJIz3TEX4XRpSCX5b7z9fj3x7vJ43UwVN+SfPTGhuJesXA9cyXJ/3WAY0Srw44ADbONwgt21dxHCCPlj1gSDrP/OQc27h5h3LBA0cpKHOQG80TclmewKk3Oo1Ec23dV5Ji3y1V8EmK24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=lFuXdxqG; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-3e4228e0fb7so1117965fac.3
        for <io-uring@vger.kernel.org>; Sat, 08 Nov 2025 10:14:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1762625673; x=1763230473; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DnnUSLvFMGOvFxx4OXBj7KUZH0qTnU4jvHFzpkOE1No=;
        b=lFuXdxqGZEFXllwBeQpYE6ufBepM8cKTh54NxsXx9R8NGA6VXznl7eNZCoCQPmGsbR
         m45/1JTzj/bMY6qKbnXQ1jck7vRu0Dkwqf3HBKOHJDEfw78AuuLVlaxt7d2HnW4EhDQg
         ryBP2jKuJzN60iTVUf1vdnFX6yKvPfbIX5XtN/lebIl040/nvytmssJvHZrcNhlTWrlK
         u0cdd1Cj2YQn/XuZuDLX0WecmdYbFjvcPdF9/pUbJG1rtqmJ92DsR7pF96eTeay5fFna
         4YtKMti/vDkkC8KDWejsRwfRUncSMRzyMso1jM+3P8KmrfZOBWgIfSV8J5Zf1PHGtimT
         upUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762625673; x=1763230473;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DnnUSLvFMGOvFxx4OXBj7KUZH0qTnU4jvHFzpkOE1No=;
        b=G4sjXxqQxJbUXp2aSPbouqS87/DuLvFYhffqDkwqMJ7ZzV3WVh2T4Vpvg1dnR4A3EJ
         E6GAIHl9sE0u8B0m8YW6P1w8rgJ4nJeS0SmIPcGINDbsgCxLz1s1LMh+rB4NFQZu+Nt8
         tNwAFd4YpOOdU/4F4X5XmW3FYE0L56a73u2A059GOCNeCWkhGB9AnN1W8dV/9blF5lDw
         CN7guXnbnP8pLj5DReaWzQWizGbaMF00rff80cigv6nXP4T2nrIqjhgKemgAqMc7Tkem
         JnhikKftkJGf97KNbmv9GYpNJAjAntdqYOEDw/N4CAcIoeaKRMFIgy0Z+wn2/x6PNB75
         1ZFA==
X-Gm-Message-State: AOJu0Yy+7++9A454AAfzHPeXKI/p7ITGVYACm/foi8GjrSmFYg6UVr49
	D9IPonACqfhKo7r6FFcFwEsPYeWhs1n0CbsTKgI9VJ86S1Ai/MCPVgtYJJ6oRhfDYYVgR2QLcFA
	CS/hH
X-Gm-Gg: ASbGnctvnhOpX2QtNIke2SCiqjp0eOZazoNJ+FPTzGhM3CQyPGDK3IDz9Xa6TxcrpAm
	pw0yTCA9v9JxCFxzVHh6zdSN1RtKP3vy3y71HM3jzWD2ITw+SkmghANflXpdYT/eRgxcvAFA2r/
	BPpO2JvQMHg2ybdWTRMhM4witFPScduQwKmZnxrxt6Z4N2797jpk69prfXvEthauqyLsAyNHxsF
	EQrT+ILnW3JbQxRbKsu2BnK7llGRmIV9O3FNLa9U/nm04xb201mcC0VHam+CG7XHABiZbC6KBfy
	AYG/yvEfUeLL1ouwr1o6VeEHASKVwldbMr70NDwwNlSjaUVtg4yIU3LbQOELieYPgg25utYcZlY
	TKIJl4C1LUaV1WmHCELK0zlNwDv54M39dvIK2evfY/piwq5DiRdm0o33ZoK4xuhdcrPxw1XOtv8
	dgvchclaY/jAkISsEiK2/k20S97NvfVA==
X-Google-Smtp-Source: AGHT+IGrBUhsgwfE9g87Lzu8eUXccxeW06jeYL+x3OkNB5Kh/GkA4Z86GFd2cImWj5hklQQV94fRJg==
X-Received: by 2002:a05:6871:2b84:b0:3e7:dd0a:31cd with SMTP id 586e51a60fabf-3e7dd0a3747mr366357fac.30.1762625672793;
        Sat, 08 Nov 2025 10:14:32 -0800 (PST)
Received: from localhost ([2a03:2880:12ff:4c::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c6f0f0b21fsm3297035a34.1.2025.11.08.10.14.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Nov 2025 10:14:32 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v6 4/5] io_uring/zcrx: add io_fill_zcrx_offsets()
Date: Sat,  8 Nov 2025 10:14:22 -0800
Message-ID: <20251108181423.3518005-5-dw@davidwei.uk>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251108181423.3518005-1-dw@davidwei.uk>
References: <20251108181423.3518005-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a helper io_fill_zcrx_offsets() that sets the constant offsets in
struct io_uring_zcrx_offsets returned to userspace.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zcrx.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 3fba3bbff570..49990c89ce95 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -345,6 +345,13 @@ static void io_zcrx_get_niov_uref(struct net_iov *niov)
 	atomic_inc(io_get_user_counter(niov));
 }
 
+static void io_fill_zcrx_offsets(struct io_uring_zcrx_offsets *offsets)
+{
+	offsets->head = offsetof(struct io_uring, head);
+	offsets->tail = offsetof(struct io_uring, tail);
+	offsets->rqes = ALIGN(sizeof(struct io_uring), L1_CACHE_BYTES);
+}
+
 static int io_allocate_rbuf_ring(struct io_ring_ctx *ctx,
 				 struct io_zcrx_ifq *ifq,
 				 struct io_uring_zcrx_ifq_reg *reg,
@@ -356,7 +363,8 @@ static int io_allocate_rbuf_ring(struct io_ring_ctx *ctx,
 	void *ptr;
 	int ret;
 
-	off = ALIGN(sizeof(struct io_uring), L1_CACHE_BYTES);
+	io_fill_zcrx_offsets(&reg->offsets);
+	off = reg->offsets.rqes;
 	size = off + sizeof(struct io_uring_zcrx_rqe) * reg->rq_entries;
 	if (size > rd->size)
 		return -EINVAL;
@@ -372,9 +380,6 @@ static int io_allocate_rbuf_ring(struct io_ring_ctx *ctx,
 	ifq->rq_ring = (struct io_uring *)ptr;
 	ifq->rqes = (struct io_uring_zcrx_rqe *)(ptr + off);
 
-	reg->offsets.head = offsetof(struct io_uring, head);
-	reg->offsets.tail = offsetof(struct io_uring, tail);
-	reg->offsets.rqes = off;
 	return 0;
 }
 
-- 
2.47.3


