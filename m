Return-Path: <io-uring+bounces-905-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A026A879DBB
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 22:46:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 557491F227AA
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 21:46:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34A15143753;
	Tue, 12 Mar 2024 21:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="np0WOB+7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5183144040
	for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 21:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710279879; cv=none; b=DclpeLErgDCovoWbeokbbDnWVBPudDpoY2ds1H9OH7bqzcemaGw159U4y6RGUhjX0FgAU9PEx5v4DJ5K4Kns9a/lh8dPY4p7BUdt9ntV1iiDEcR/qYqLHegIGggWD/z6gE/5pMVZoo94bB/YDi3pSLlCM54627SZOPfWPlO2EX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710279879; c=relaxed/simple;
	bh=W3WXMs3garqhAb32SzklKNlFKnh2r5NOCtW103aAhto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gqFAjTf4gFGw8S/g0yX8wV3Cp05stvGGBVC//PLgXmbmdC56hAUmxgLMvr1h0rNNqkikPZhbv70KJRzy1hgccJ2d3qA4+v+VOIpNr1/TujlM1NJUwCsbatDgv/YBmSOy3kvG1blraoJdrPpTOxzqyywBAqPCcPWPamt4SuFKHCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=np0WOB+7; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-29c14800a7fso1745195a91.2
        for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 14:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1710279877; x=1710884677; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e+tA/rM03kyiWmHG7W3g16fbOzLvHn1bTNN6KvcsaQ0=;
        b=np0WOB+7rylLFl/sAjdGwd736MiRPi/74atlRWcJqw8aDDXihCL7MjJ8A+81PHNKYF
         WUDDLZOYpdVwswxmNVYr4oUoKohwa/iGplXQfUfKp/GWX8EL8tfzxUiF6y/v4y/L2Rv7
         i7jpZz0AyQzXYznLtMT/QGb91qhxaw099L7ZuITz2DEV69GI1JeBnqR+t0e1PWKbdE3w
         oHF0HyrDAEXdcjmaN/KPY1NfpULYPuTX6c4zRkQc944yH0PDY83cQ3xtXFcl+hwYiRsY
         W7VqUbFyOjtSOhZ8XOGLkLfsoq9XTSJmlsanlyJS0ELylT/TlM/Q5OPnI3ljIIXxzPaV
         Tn+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710279877; x=1710884677;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e+tA/rM03kyiWmHG7W3g16fbOzLvHn1bTNN6KvcsaQ0=;
        b=H+FOohKTvEuk3fHlDlhMzSMMAfYXLon2O1kE+v2k9ItNKtNKlApRYrm1JdTHRJ9L8J
         7WT2RtBk2RNMzsxuYXNJzhvBPFsmjv9KPFjGaSd5GViarM4KSbZTdvfklYHEqTe/yY1o
         BajYNQcFr+uAOQuC+Zp6XRXaT/BWu0ltVtU1MRVrgiFdrTm4ihZmg01UU9WWGxZxq/aa
         HcqtcWeudGkIPjTOUSXFqdAFUskqeQWhufnLeY9tdpxhNAv0K0nyt23wQoXUyQ1RAKPd
         nq/bPmhZwEz6KLIwnfw0R59CY08Fe9KEz2zjLpcJI2o21NJj4Qe4/pfbKUq3hau7Z24s
         wgsw==
X-Gm-Message-State: AOJu0YxR1Ld/dNwxUUtKXiyfb69/B8pOOGiPdF368L3JExkNHNPjFaA3
	fu/3pGTymKn5p+1rDkLBu8vnmmKOmTC1LtMdm1YW0EOWKDYIFtME6Bfi+TFdEOmMnWvLMJHlg6j
	O
X-Google-Smtp-Source: AGHT+IH5+jrF0vlqMy6uApDvygsRxFdJckSqSzWO7yWz6TQbdmOZB1Brgo8GpGb8aHoRcJ50xBNLBg==
X-Received: by 2002:a17:90b:400f:b0:29b:d899:e7a7 with SMTP id ie15-20020a17090b400f00b0029bd899e7a7mr3000692pjb.7.1710279876687;
        Tue, 12 Mar 2024 14:44:36 -0700 (PDT)
Received: from localhost (fwdproxy-prn-015.fbsv.net. [2a03:2880:ff:f::face:b00c])
        by smtp.gmail.com with ESMTPSA id c12-20020a17090aa60c00b0029c0cc16888sm56937pjq.1.2024.03.12.14.44.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Mar 2024 14:44:36 -0700 (PDT)
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
	Mina Almasry <almasrymina@google.com>
Subject: [RFC PATCH v4 03/16] net: page_pool: add ->scrub mem provider callback
Date: Tue, 12 Mar 2024 14:44:17 -0700
Message-ID: <20240312214430.2923019-4-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240312214430.2923019-1-dw@davidwei.uk>
References: <20240312214430.2923019-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

page pool is now waiting for all ppiovs to return before destroying
itself, and for that to happen the memory provider might need to push
some buffers, flush caches and so on.

todo: we'll try to get by without it before the final release

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/net/page_pool/types.h | 1 +
 net/core/page_pool.c          | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/include/net/page_pool/types.h b/include/net/page_pool/types.h
index 096cd2455b2c..347837b83d36 100644
--- a/include/net/page_pool/types.h
+++ b/include/net/page_pool/types.h
@@ -134,6 +134,7 @@ struct memory_provider_ops {
 	void (*destroy)(struct page_pool *pool);
 	netmem_ref (*alloc_pages)(struct page_pool *pool, gfp_t gfp);
 	bool (*release_page)(struct page_pool *pool, netmem_ref netmem);
+	void (*scrub)(struct page_pool *pool);
 };
 
 extern const struct memory_provider_ops dmabuf_devmem_ops;
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 5d5b78878473..fc92e551ed13 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -984,6 +984,9 @@ static void page_pool_empty_alloc_cache_once(struct page_pool *pool)
 
 static void page_pool_scrub(struct page_pool *pool)
 {
+	if (pool->mp_ops && pool->mp_ops->scrub)
+		pool->mp_ops->scrub(pool);
+
 	page_pool_empty_alloc_cache_once(pool);
 	pool->destroy_cnt++;
 
-- 
2.43.0


