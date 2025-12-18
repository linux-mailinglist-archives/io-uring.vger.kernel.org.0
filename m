Return-Path: <io-uring+bounces-11209-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D0BACCB2E1
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 10:32:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DD1AB3031EBF
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 09:32:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36F653314D9;
	Thu, 18 Dec 2025 09:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NvJUGy+0"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB232FF178
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 09:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766050346; cv=none; b=iqokpjHwDVlKS84t7sYTk5EeLSK6roSwa9mrHs2uEMRXERb9M6jTQT4iaQLQZG7w0VRj43gerTcdt5ddq7R+99ck/4bIEEqQuT3j9DPh7fdEBCI3l+j2mUGQe/86i7w4EqyqUbL5kU0mtE8TSdy5fZwoCwe/vY3tmwSdYJF7QAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766050346; c=relaxed/simple;
	bh=g41ZRVsdo4l1JscDtGfKbU2nxcNj683tXxZAUCYMEf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rr3gojEiW6/b58BKLVn+sZu+8+Uktc4jGgcPc+EDfki+qnioNvFifCi3GrXbrW49MlJQuj9FYA0C41wkUg7Ef7XOt5qc5ePDK0WzlSI8h/hu/PGvpc3dqPVAAyCbAPrsUzu1M5NfUDUGPipBqykMVdF3fY9RHsrt+qxtKAPsgzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NvJUGy+0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766050343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Oo9GDeM4DKKNu1JTi1OaeGMwC5vm+SZqtyFCDYZV+JE=;
	b=NvJUGy+0wWJrb1Abq0aIjvOFofuOkn6Phe4hxkk3bOwbdW4cernPdbDyMW7DGd8f9GcZ1G
	Ei4lxkt0ikpsPcfTg0Dv9cr0eBzbVanIi/CgIXHJVnx3ACAAyxgGBB6GBJ9eNbwgJT2ZrF
	noWM4pPa6ppmW66WVBV2Kxp983ONE80=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-661-933RWCzLPv2sKXgWiZW0ig-1; Thu,
 18 Dec 2025 04:32:20 -0500
X-MC-Unique: 933RWCzLPv2sKXgWiZW0ig-1
X-Mimecast-MFC-AGG-ID: 933RWCzLPv2sKXgWiZW0ig_1766050339
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9DC531801211;
	Thu, 18 Dec 2025 09:32:18 +0000 (UTC)
Received: from localhost (unknown [10.72.116.190])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 763FC1800352;
	Thu, 18 Dec 2025 09:32:17 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org
Cc: io-uring@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>,
	huang-jl <huang-jl@deepseek.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 3/3] io_uring: don't re-calculate iov_iter nr_segs in io_import_kbuf()
Date: Thu, 18 Dec 2025 17:31:44 +0800
Message-ID: <20251218093146.1218279-4-ming.lei@redhat.com>
In-Reply-To: <20251218093146.1218279-1-ming.lei@redhat.com>
References: <20251218093146.1218279-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

We have provide correct byte counts to iov_iter, and it is enough to
cap the iteration, not necessary to re-calculate exact nr_segs.

Especially the previous two patches avoid to use bio->bi_vcnt as
split hint, and don't use iov_iter->nr_segs to initialize bio->bi_vcnt.

The iov_iter nr_segs re-calculation[1] is added for avoiding unnecessary
bio split, which is fixed now by the previous two patches.

[1] https://lkml.org/lkml/2025/4/16/351

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/rsrc.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index a63474b331bf..ee6283676ba7 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1055,16 +1055,6 @@ static int io_import_kbuf(int ddir, struct iov_iter *iter,
 
 	iov_iter_bvec(iter, ddir, imu->bvec, imu->nr_bvecs, count);
 	iov_iter_advance(iter, offset);
-
-	if (count < imu->len) {
-		const struct bio_vec *bvec = iter->bvec;
-
-		while (len > bvec->bv_len) {
-			len -= bvec->bv_len;
-			bvec++;
-		}
-		iter->nr_segs = 1 + bvec - iter->bvec;
-	}
 	return 0;
 }
 
-- 
2.47.0


