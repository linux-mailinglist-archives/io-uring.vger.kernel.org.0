Return-Path: <io-uring+bounces-5533-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 526379F5BA2
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 01:36:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C02517A513D
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 00:36:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA4411E48A;
	Wed, 18 Dec 2024 00:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="jDFxBStL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0BA1F956
	for <io-uring@vger.kernel.org>; Wed, 18 Dec 2024 00:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734482161; cv=none; b=V/Gvrr4vfL7raOawSqrcte4qMAtD9Aua3RVHT2WjXQVwYfb680YkljKtMocbMuwJTh/iVs/6mfCbYn+g/zXCNNWHot+ugtZBDZG+UwoBX3F9scrGinHDAishQn89arK0VrYYA70meqV0ZsB2sH7ZQFfPyo7HJpEOyI0fzBuL5lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734482161; c=relaxed/simple;
	bh=CztbvP9+RIyhpbrNQZVgPuMnd7qkzCOzRjukEnHDodc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CdQkJPgL6WprHY4SshyRBMNELfD/KD7PvavMHH8Qp0SvmCNQISQ23F3K9XuCfX4BPAYBURpV+Qufya6dSvzYlqW1WFMpEVdWrpfkf2SXQGWcZD+QVCiqTMK/p+/gP/12U4agohsTD1iQ2fvP/0RNuB2fS2tNIokg50y+iyRrvMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=jDFxBStL; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-728e81257bfso4843817b3a.2
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 16:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1734482159; x=1735086959; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3FmBtD/9kNoCPyeDOsGVnpCJKDKHQdivfmWBaZAFy/E=;
        b=jDFxBStL702Qzebhgvjw8DUM/qZhn4Bsh/MwdZdhABqeeXz5NJCwomO9mlRzsayg4K
         CQHx/nVFUcDZrCDm3EEDER72/s0CGN73a6YjUhPpWQi87d2IkBO6KVzkLghs8dlZgmPg
         0YGPa5GK/hFwQETXwA8v6YYP2aogWx9zAg0Omg0RhxES0aR1C36AxuN+sjtuP+khVoSo
         O6pNPnPfJeXc+IIhCa9JwK1NefLnHq5vEC4BrJl2XgMUVu9ka4u0HP6CkSyQ2+V4yvLA
         QyIWP0s5H3Vy4t+fJIalnmpaBwS1XojhI9Sj64yND51FKRrQ/pvV8XVh6y3NtEKbRhx7
         CTWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734482159; x=1735086959;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3FmBtD/9kNoCPyeDOsGVnpCJKDKHQdivfmWBaZAFy/E=;
        b=CVQXgGOR1QdOQmi4I/2ha9u8OJpTbUacxsARUB3+fPKDvj9EhWk54W2ZpUMY+85/zH
         48MpKCrQC4xZgBa8a4PrsOjto3ITF2uZjHhRUT4T+LEPhTPAHmcY01oiAT12DzNAiPu4
         EkNovTDyCm0oBz1fKNq1WKmaU2S78xDcCEOen8T6tyfb+GXFjTHKI64wb3Rz1Vn0zzf6
         hbArQ2NDn27MoxStul2z450xzm/nyyo1qnFIF/zTy56X8xw3MaRq6tUvDRs61Ibq8P7Y
         6va1VqJTyKKRIqtfifRPx5tvyplEjw3OysSVQJV7OsrqV1R1H96MzyWkiXwRj3tzarUM
         eydA==
X-Gm-Message-State: AOJu0YxReZ6/mcBiph0LLL+8X5B5PoNOPOnFkYZoZpS3X9T3Q+qcJzUR
	oTOThxrqnw79tQDYcgoHxEvzEViTsNgE0n88GF998jV0wNyr6Ffj/fQ6UoacoLPprTJ/VkBsiTz
	i
X-Gm-Gg: ASbGnctZwOYNj8AvVWi5VPoAidhv8baILw4a0+Nd8A8I5xpZDVNJuvqq8s3O5MtH+mQ
	cOqLRSuut5Mk4t8T9BgEhp85dGdGYMkTba5vn1H8+3WEBsi+76+84kkb90wQ3BLRzq3zf6SVrrh
	l1krGqqY7enGFVd4GO//KYdAJeYMo8aV1bPNdj70+5Yn5DAzwaF9LdeZVVIslw3ifhIiL5KiFn8
	yTatqk/tL1sduAJy6vd6Z5A+8HorCgSm5AN76JO6A==
X-Google-Smtp-Source: AGHT+IHQ+upJz/RGUUcV/5i4GKWOu+LYEOubkwJvJFMyfJVlxE6d4/uwYN9uI8/eqCX8ruOMmIPNzA==
X-Received: by 2002:a05:6a21:3991:b0:1e1:a094:f20e with SMTP id adf61e73a8af0-1e5b47fc6c3mr1441096637.17.1734482159683;
        Tue, 17 Dec 2024 16:35:59 -0800 (PST)
Received: from localhost ([2a03:2880:ff:10::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-801d5a933c1sm6453128a12.2.2024.12.17.16.35.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 16:35:59 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <stfomichev@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Pedro Tammela <pctammela@mojatatu.com>
Subject: [--bla-- 01/20] net: page_pool: don't cast mp param to devmem
Date: Tue, 17 Dec 2024 16:35:29 -0800
Message-ID: <20241218003549.786301-2-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241218003549.786301-1-dw@davidwei.uk>
References: <20241218003549.786301-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

page_pool_check_memory_provider() is a generic path and shouldn't assume
anything about the actual type of the memory provider argument. It's
fine while devmem is the only provider, but cast away the devmem
specific binding types to avoid confusion.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 net/core/page_pool_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/page_pool_user.c b/net/core/page_pool_user.c
index 48335766c1bf..8d31c71bea1a 100644
--- a/net/core/page_pool_user.c
+++ b/net/core/page_pool_user.c
@@ -353,7 +353,7 @@ void page_pool_unlist(struct page_pool *pool)
 int page_pool_check_memory_provider(struct net_device *dev,
 				    struct netdev_rx_queue *rxq)
 {
-	struct net_devmem_dmabuf_binding *binding = rxq->mp_params.mp_priv;
+	void *binding = rxq->mp_params.mp_priv;
 	struct page_pool *pool;
 	struct hlist_node *n;
 
-- 
2.43.5


