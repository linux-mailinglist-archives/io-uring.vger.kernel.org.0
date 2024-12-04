Return-Path: <io-uring+bounces-5218-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 65DC79E45A2
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 21:25:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CA73AB60D44
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 17:57:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45A4A20DD71;
	Wed,  4 Dec 2024 17:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="0fZViDl0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D363F2144C9
	for <io-uring@vger.kernel.org>; Wed,  4 Dec 2024 17:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733332970; cv=none; b=mcO1gXXrEItSu5tmxMXn+02QOPiIj5YRM86mh5t4G28TtCejeV1Eq8u9UiDR0Ecr4BPqFevNGRU1sXZqhbRFynZr+LlMTjc1mXdKfR3uSTV+/ioy946So2dGMC4Sj6aueACsV6C1J2gkefwSHmJ7pelBXLEXsx6idxxCWtbkLE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733332970; c=relaxed/simple;
	bh=APKr5aLd6vQflFkrq4T1x51i6M4tU+UpDKsCgobut2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5aTFRNBGv4XMlULhfWCGiRxr4VCKsNUOkgBN+SHvpKewhlKFm7cHToMhKW4axtW/Vgw0yd6RAmCMdTUuPyc8hULMOyLiXuWU/Bo75RjomXQJnb954MnRDtnLnve5iflCWjjEzvDjaVNSaPOGbvVC2equ8C4MA5S865cL4jZ5WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=0fZViDl0; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-724f383c5bfso54989b3a.1
        for <io-uring@vger.kernel.org>; Wed, 04 Dec 2024 09:22:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1733332968; x=1733937768; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M2vkmdBzDyqn2IwGI+dU78wy5gRI5n87yNySC9Hmw6M=;
        b=0fZViDl0WrAIih3ykgYs3fLinyyR/oc1Fkx6ehElvo3YjQW2a0mDsdjMVRDpJjgJgi
         XaZbWa/XDHBbP17qwkFlAkUQbXPNcrtZhu92TDZnOUhlZMEcr1HvBQ3RETyNXirRjHKR
         kW2K6jr3AAPTyReO+4r/ldJAKcsbO7L8MWVdTra5lJNosBiAhSlEDd5s+pdQwrP456W0
         OqS7CGUkyTU1D2P4UONWCeaLY8BcMcrVZicI8PvCY0Q2l+x01PUWNlWvAduwgsuKNvWw
         T8CNbMthwtcgRS67xPG6zCwMz7Tdm+wtPETuX3jojbByffqz7tJ/3dw/yWQGrlP1YFWX
         mkKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733332968; x=1733937768;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M2vkmdBzDyqn2IwGI+dU78wy5gRI5n87yNySC9Hmw6M=;
        b=AvjIEWr7+l+qLvOXdNdLn2avEJSlfSGK+1g2sP8lLQ7UgBK+bZCMJWFt3NiofqrDV7
         QRDtbPlm261kFhfadOezDNUOXi4rc4rtnxwBIxW+9sk5l+5RbIKcXDp4VH493H4glyd7
         yfRWWiLkAJ1TxAB+KJ1dDmXFX4Sf6j79ANlCw1IXBc2oGXc+RKyXXTKQpdAQUZpFCzmE
         btE5jil8mQJpyasFNYqH/MnMs7bcrQntMp57xc0dcqlmnwhct9jSVCECXIqgo2j+6vGU
         koGYYL4/7UNU7by8sQrwYJW+rvRn2eKLVDX6HlLDGWAz+EhK8rWkwvFmXy7js7Ie5P/x
         d0SQ==
X-Gm-Message-State: AOJu0YxjYJDKP/TLNVhqj71DEuZk4TnfZhf+4l4XWK7wWuedex9A0yUr
	bcXkoNIhb+P96WwErrGct9rNubKrhcbMrQySHzwJJjBL/qK4OE+7Q6ctTDNP0wv4sm3+UladPHs
	R
X-Gm-Gg: ASbGncv/KnmWkrf2HFlDcWaPf5uUmCFfYNaKbLy3X443hGccr26AY9yEnMZEuXdGp8B
	7LzI6W0U8Z2a6Z99MJBCqwO43PUVfiwAZ9bBF27oW4yKSKlnm8H9AygdcWsWzHoyuFmHdUNS2kc
	tD3T/54bE73aR3Uilt8DM8OO5nimdVDye7bAMIzjRP8W078ldnwiY70Zn9OU+OF9lPkUbj8BQr7
	jlaAptQO4jrmatHdcc+YL0S5RjCRvc8S6o=
X-Google-Smtp-Source: AGHT+IG9Kld6tAEKAy17eJTwxd2vNTg24V286fmwbwIZ10oR7zVgKPAWK1HWQD7C1mnwVSOsUpjlyQ==
X-Received: by 2002:a17:90b:17c9:b0:2ee:6e22:bfd0 with SMTP id 98e67ed59e1d1-2ef1ce997f8mr6252786a91.21.1733332968233;
        Wed, 04 Dec 2024 09:22:48 -0800 (PST)
Received: from localhost ([2a03:2880:ff:10::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ef27062fd7sm1675569a91.46.2024.12.04.09.22.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2024 09:22:47 -0800 (PST)
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
Subject: [PATCH net-next v8 05/17] net: page_pool: add ->scrub mem provider callback
Date: Wed,  4 Dec 2024 09:21:44 -0800
Message-ID: <20241204172204.4180482-6-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241204172204.4180482-1-dw@davidwei.uk>
References: <20241204172204.4180482-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

Some page pool memory providers like io_uring need to catch the point
when the page pool is asked to be destroyed. ->destroy is not enough
because it relies on the page pool to wait for its buffers first, but
for that to happen a provider might need to react, e.g. to collect all
buffers that are currently given to the user space.

Add a new provider's scrub callback serving the purpose and called off
the pp's generic (cold) scrubbing path, i.e. page_pool_scrub().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/net/page_pool/types.h | 1 +
 net/core/page_pool.c          | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/include/net/page_pool/types.h b/include/net/page_pool/types.h
index 8a35fe474adb..fd0376ad0d26 100644
--- a/include/net/page_pool/types.h
+++ b/include/net/page_pool/types.h
@@ -157,6 +157,7 @@ struct memory_provider_ops {
 	bool (*release_netmem)(struct page_pool *pool, netmem_ref netmem);
 	int (*init)(struct page_pool *pool);
 	void (*destroy)(struct page_pool *pool);
+	void (*scrub)(struct page_pool *pool);
 };
 
 struct pp_memory_provider_params {
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 36f61a1e4ffe..13f1a4a63760 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -1038,6 +1038,9 @@ static void page_pool_empty_alloc_cache_once(struct page_pool *pool)
 
 static void page_pool_scrub(struct page_pool *pool)
 {
+	if (pool->mp_ops && pool->mp_ops->scrub)
+		pool->mp_ops->scrub(pool);
+
 	page_pool_empty_alloc_cache_once(pool);
 	pool->destroy_cnt++;
 
-- 
2.43.5


