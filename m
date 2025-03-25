Return-Path: <io-uring+bounces-7236-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 09DA5A702DB
	for <lists+io-uring@lfdr.de>; Tue, 25 Mar 2025 14:53:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3FAA97A262A
	for <lists+io-uring@lfdr.de>; Tue, 25 Mar 2025 13:51:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F5E22561D7;
	Tue, 25 Mar 2025 13:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bJaro2dI"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10B425522E
	for <io-uring@vger.kernel.org>; Tue, 25 Mar 2025 13:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742910749; cv=none; b=AAqW2fML5C9WmHCOsvmD0nyWjDw4J00B7PmRLiRKkZ7l7zh2VOuxy/SY9KCdiK8NXExEYcU6PAgBc4idmyEXW3loEI+zIHp1IGlAJwK5vT4cJAeQfiRDLzZGkp7v3nO74ZFIiHhPxo2gizGRixt8yOmdIfv2UeZQ5GhCdqBvFuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742910749; c=relaxed/simple;
	bh=i2hYLhBC4x1d3VnoC0ecf3oNjvo1HQHgwaBb04veB8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YS7K/vlJyn3eXT9s3c2ORLAswL0dcUJf7EmKjMFu4V0VsfG9YBVO1yWAyTq/2CDREHmvoOT8oQsN/bbAx6kdMcOJUp7txfIASZ2DhtyTL6pvuH4IlS16Xyq1QwIWvJsNSEfNztM265QmFCkH1aIuklsg6kmRs347oMNgDuXCAm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bJaro2dI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742910746;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uWAOs5fsFruVcO2h9150cvagOZphYokop91XUuxe8bc=;
	b=bJaro2dIDlsX+pgBmJKc8TkQsgF05jjP7wMrQDKWroQCv5pzd6hPzY4xbDXXdi3Diz5X8q
	FfZQn1g2C1Tz+KHIjgKVi78+07S0pzFwXuj6Ycb/EtUXO5+Gmc6vOm4xxh5uTSJXGUXqX3
	qg0smJ6PkqunhcAWHqqLeJ16tcMgLDo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-398-HPQWnUEyN_O4_N3YbnGJsg-1; Tue,
 25 Mar 2025 09:52:22 -0400
X-MC-Unique: HPQWnUEyN_O4_N3YbnGJsg-1
X-Mimecast-MFC-AGG-ID: HPQWnUEyN_O4_N3YbnGJsg_1742910741
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9E1FE180899B;
	Tue, 25 Mar 2025 13:52:20 +0000 (UTC)
Received: from localhost (unknown [10.72.120.3])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 525A4180A802;
	Tue, 25 Mar 2025 13:52:18 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 2/4] block: add for_each_mp_bvec()
Date: Tue, 25 Mar 2025 21:51:51 +0800
Message-ID: <20250325135155.935398-3-ming.lei@redhat.com>
In-Reply-To: <20250325135155.935398-1-ming.lei@redhat.com>
References: <20250325135155.935398-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Add helper of for_each_mp_bvec() for io_uring to import fixed kernel
buffer.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/bvec.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index ba8f52d48b94..204b22a99c4b 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -184,6 +184,12 @@ static inline void bvec_iter_advance_single(const struct bio_vec *bv,
 		((bvl = bvec_iter_bvec((bio_vec), (iter))), 1);	\
 	     bvec_iter_advance_single((bio_vec), &(iter), (bvl).bv_len))
 
+#define for_each_mp_bvec(bvl, bio_vec, iter, start)			\
+	for (iter = (start);						\
+	     (iter).bi_size &&						\
+		((bvl = mp_bvec_iter_bvec((bio_vec), (iter))), 1);	\
+	     bvec_iter_advance_single((bio_vec), &(iter), (bvl).bv_len))
+
 /* for iterating one bio from start to end */
 #define BVEC_ITER_ALL_INIT (struct bvec_iter)				\
 {									\
-- 
2.47.0


