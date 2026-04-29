Return-Path: <io-uring+bounces-13175-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AINdGgsk8mlmoQEAu9opvQ
	(envelope-from <io-uring+bounces-13175-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2026 17:30:19 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EFFD4496ED9
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2026 17:30:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 31C0630E26A5
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2026 15:26:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F70737CD2A;
	Wed, 29 Apr 2026 15:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZxbT4MqG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2BA37F01C
	for <io-uring@vger.kernel.org>; Wed, 29 Apr 2026 15:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777476397; cv=none; b=GPODMpZX+9B/2+ed/q8cZ4BSUNZhrVlXremYRH9Gf3Ycs3GNrn10p32vImFO4WFpU9nsTtw0YTu/idfd1TgWHxJQPtL/7s/m539SBE/pzjHjGjIQF9g3Pj9Ozw0hP3XUXbPmE0ysW1dadWpa207ZogRgy/EDivt1+WQOl4gT/ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777476397; c=relaxed/simple;
	bh=Rg4ViyjWjJ0uH1MionkRUKz+M0sp6VZkQ9UyDJex3kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1UTD4EEzAcuiLovgAHC0hznDrjytAxItgFlctpmzrMATOOEDY65PtBgRl30cv6nFBkTBlO6a5kUoISU3o3eGFbB3fyufWHxjG1ixIY0DQWs/Lsq0vz+lRfxC2hlk4WQdINxG28BZQ2fDk2JgDIDzxI715Jn5IhoImpSqAkNhzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZxbT4MqG; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-43eada6d900so12149100f8f.0
        for <io-uring@vger.kernel.org>; Wed, 29 Apr 2026 08:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777476393; x=1778081193; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nOTrV0WGracSIFm0V666o5CRu83OUP8NlZEfiWwVSJE=;
        b=ZxbT4MqGYb41heJHzUNkeNrQqqbwivoko4YMr5UyQTxSL8WB1OyORAio38DxntrS6u
         auZrBgzdXlS/Zd+QO9j19xJeT986+p4M04JYGsA9Cy1qY7tyv6ZXSsqeu3lOu5KcvgSf
         bwH040Jp458XcQ78nGYH+2kcXG0HqNQhcSaQEopmU66xpyEEMarI7UgAdVTwheElzo5Z
         2HR0Fn7PnbcP6s0xfsjdbr5X0o3yQ4BN/63ISgNQnvQCaJQJJrImNwWpwl1p/TSCFX2Z
         otPWWi2MPrnCArGZBi2AILWhP9XjXJtLKVR4fjzxCf2rtAdcaSa+MtvsIi8IVnFvQkLk
         9NQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777476393; x=1778081193;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nOTrV0WGracSIFm0V666o5CRu83OUP8NlZEfiWwVSJE=;
        b=jjuiG4FHM0Ogk60JfGdUVEXIO6RYg8tKVqDDfOGMdbSFFs5Q4r4npvnWPrZ7OYHBDt
         261zWfcumVp6/WLmiya8PQTZWnyboyq5/XZdK3JjYPTsL7sIcJSuZOzSxKn6zFVkzWsW
         5TK+wJw88GEYFuBqu7zCFxYrAxkayqwjnJOXW41JVxm/jz1ZZGXhVFNIURPjDpiFqoXS
         TObJ6rGBm4dp8YVVLqueNGFHzsj+KtjMVVcyelTsS+YIT4qCZSs/Kl1nPepdfx8EtGNW
         Lw1vjOLvIDcu/t7MuFYBJOl0ealM7JWF1Y7JFkYk1bsOeUMzT6rjZSv8HqJpAjDwQg7h
         PZDQ==
X-Forwarded-Encrypted: i=1; AFNElJ/03K3pFcsA3OV/ci81wU7CaXlqLlqd1bM5v3vUVTHhnxmNTVtbinwSi0El8T3w/Sn6DB43IKtM2w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyZxCXGVr6v6Rt+bhFv+vuAxysFf+9MLLca5gcdmvK6N6L0PHPb
	xne13iJnbH/hCvBYgBH8JJVM8sg+BreMyir3rVcbGechzw7TS4683Qib
X-Gm-Gg: AeBDievLeeev2GpKX055KBi8ABrKdaU4rL51FPDGBMyO6WkGzFZ9GljlM2jhXoPTD6w
	EeZL/PhB3yAOOE1h1g/mBqPuxRF38nDHTqhg/qGBkFE/t2CyuPcrXcGG9M0yH51Ea3ApA8H1lVM
	RWk0b76IFZWrR+123vjWGOuWG2HiPsJ6UhEwTh6NuJ5ukyVHOl3bWZRJakG4cgVkDFtSj6NACy0
	kAEDPEZBsVj32zvFnyhiF9cuWDhUdt+Aqzw9QRH3UzEHerg0XW5D5839gvqonOTjWTNanMzuOXU
	CF4y745v/VQbU565rVGFLc68GBsjFcybkXyre+cm8V0QnF9wctEyMrO1zDScpKyE8TERoBpZDjL
	S4c1ZM1VqmS/BktNF7+XVNFtEosN3xSThWQAagCgSoJ+gEVE3i4wIVAY8Br5sqy+wwoRcowtCD8
	v8zs9jM+Wt5wfX2KdZ0qcHzcGwK1mqIPeM+njcbCT7wdMYSd3gh2x1jbVPwdgr60eXdAdn0X5Zu
	bHohGKLOEuib45kPE08XE4tbVi32fHyDHNOS/zyJQP0
X-Received: by 2002:a05:6000:250f:b0:43f:e41d:85f2 with SMTP id ffacd0b85a97d-4464839c9bcmr15101656f8f.2.1777476392719;
        Wed, 29 Apr 2026 08:26:32 -0700 (PDT)
Received: from 127.0.0.1localhost ([82.132.184.31])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-447b76e5c22sm6382951f8f.28.2026.04.29.08.26.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 08:26:32 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org
Cc: asml.silence@gmail.com,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Tushar Gohad <tushar.gohad@intel.com>,
	William Power <william.power@intel.com>,
	Phil Cayton <phil.cayton@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v3 03/10] block: move bvec init into __bio_clone
Date: Wed, 29 Apr 2026 16:25:49 +0100
Message-ID: <43a91f54d61d3329316e40c69ace781b4d35fe0b.1777475843.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1777475843.git.asml.silence@gmail.com>
References: <cover.1777475843.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EFFD4496ED9
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[25];
	FREEMAIL_CC(0.00)[gmail.com,samsung.com,intel.com,nvidia.com];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13175-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]

To quote Cristoph: "Historically __bio_clone itself does not clone the
payload, just the bio. But we got rid of the callers that want to clone
a bio but not the payload long time ago". So let's move ->bi_io_vec
assignment into __bio_clone(), so we have a single point where it's set.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/bio.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 4d46af0cd256..0734b50d4992 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -851,6 +851,7 @@ static int __bio_clone(struct bio *bio, struct bio *bio_src, gfp_t gfp)
 	bio->bi_write_hint = bio_src->bi_write_hint;
 	bio->bi_write_stream = bio_src->bi_write_stream;
 	bio->bi_iter = bio_src->bi_iter;
+	bio->bi_io_vec = bio_src->bi_io_vec;
 
 	if (bio->bi_bdev) {
 		if (bio->bi_bdev == bio_src->bi_bdev &&
@@ -893,8 +894,6 @@ struct bio *bio_alloc_clone(struct block_device *bdev, struct bio *bio_src,
 		bio_put(bio);
 		return NULL;
 	}
-	bio->bi_io_vec = bio_src->bi_io_vec;
-
 	return bio;
 }
 EXPORT_SYMBOL(bio_alloc_clone);
@@ -914,7 +913,7 @@ int bio_init_clone(struct block_device *bdev, struct bio *bio,
 {
 	int ret;
 
-	bio_init(bio, bdev, bio_src->bi_io_vec, 0, bio_src->bi_opf);
+	bio_init(bio, bdev, NULL, 0, bio_src->bi_opf);
 	ret = __bio_clone(bio, bio_src, gfp);
 	if (ret)
 		bio_uninit(bio);
-- 
2.53.0


