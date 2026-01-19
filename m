Return-Path: <io-uring+bounces-11807-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C4EB2D39CBA
	for <lists+io-uring@lfdr.de>; Mon, 19 Jan 2026 04:15:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7C55C30056F9
	for <lists+io-uring@lfdr.de>; Mon, 19 Jan 2026 03:15:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1007C17AE11;
	Mon, 19 Jan 2026 03:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vqt3q9b2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA8D15746F
	for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 03:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768792545; cv=none; b=ptFxrT9Zkl9vAUtVehXDhNogTUdCgH1zpYLEKPCD6z8e6OW4wHCfvsS1EAjRUV/9BgFmAjEA13f37iQYAsp934k2VEVkLM2WWpykBhsPcSg4VWyoxYU61olGC/wLuK+wMMJroUPaEJoLGlB3Mfm09Kq0jDbvde6hysnWwtYoZXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768792545; c=relaxed/simple;
	bh=yiTKXspo7xmTJgNJJhjXIB+9751xFNtRWUXXuCextcg=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=f5KPbydMSl+Z3YjE1hMDtxxIAAW0IhsgkEhwiBWzK/67Y4yxvS8jlC6RyTxJUGyJgvn22dlEyM7U3J+22lRPMI8HzWRcQSnUVa2BoCDwMJs5KJlabrQEkhHtdFZkBTd+Bj72OaaoSFf1QJFIIG7N3UIt6Ow7YqJj5R2RMf/zKMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vqt3q9b2; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-4075798605aso443139fac.0
        for <io-uring@vger.kernel.org>; Sun, 18 Jan 2026 19:15:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768792541; x=1769397341; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xBhXTNXYj1mSvmKS4Ch42eNPxLbrfOAlyfoNRUcItgw=;
        b=vqt3q9b2jmpBnVH+K9lI7GY0L6lLavOctmJ8Ck1cE6DUiy8z1BxEN9z9dAafHrm7rN
         2lK7vNKXu6CqDniHESsKZsX85J+MXEfxAmZqpt7Iy1LQrA5lIdfo7rbTTEJMdjzL53iB
         849gZJvgQ7W1qcGSUMMBtr1jio7eMG1GDIik3wCSjpCe+rBV5WILz2upWGZiJv2Vidd2
         QpwzBgiODWm0Nn3wmLc0ae+T5IpRlSZn1Dag5pAhU7e0+viY3/ypiXJ5i9HioMSvZXbO
         Mlwtm1PZqaGv0awaqOdeZs+ElS6RIAmIOEEqd9lFo2ETDWe+gKJKRH8sMp+iav9qYYdN
         NLhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768792541; x=1769397341;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xBhXTNXYj1mSvmKS4Ch42eNPxLbrfOAlyfoNRUcItgw=;
        b=fH8uf4uBGrQ+BKszLiIUV8hefvsQtSTh068rDYZV+H3/xHCSLSYF+iPGhZR0T8DSlI
         N7tlUULHC+ImxJ2SK71fdgF+8Oda69k4VFf65emOmKi4AGPWFpu7apEx0NoL6PJx84uB
         IZso7buppdo1nwJL5zYJoccTst0AH7L5nlVydh0fy0HY21bPHDACNCUG/VST2DCTWs2e
         bacwIX2OKEK5okQhX8nsBHDkPmj+9p9oVlZBeCLA8MB4Gy3I7AwiitVMTaEb1P/ZlRz4
         62TaDmZpS+cTCBQ9SApTx3wtXDHSe3MbV+JBCmw5KRNFsw5Nb69vXPPPgfpBQpvju6bL
         8wWQ==
X-Gm-Message-State: AOJu0YyPa5+Aysj3NN1jazb+1/0NSO1XFobsAT63fi0rbsPB/+MmawEc
	ZCGsHbEiEgLtjDqufVZrlbIw1fdpOvauOGuq9+X6O4XIK30GpKgh6xBMZRwi68HI5tGEOnirbtP
	AXHv/
X-Gm-Gg: AY/fxX6VP3ZGpz2F+USKOUidegbhiGON9/BWEp9VK9iFW9tJ0T0TZXEmDvIL8B3zaF0
	50FsZgTMEI9OLFMVqYawo4z5jnnmIhpVt9wfMnb+7LaBhFKmV813qIf/FLCkwi/bRvSNzseActP
	kKNNdBFEtjrvipYwNbxEPGK9o8N43EgYsq9Bv9Pd8EI9KoJuHoZv5H+8XU9CsL0anyJq74/4dVj
	W7WKs7oVau15vGAXMAgl5W/5PUjV6npCYsTrcfUdDOfj6JQoJvPA4j7tu8rLkMFg1swA3oNqii4
	F3EfYg/1foFByBX7kiu0gnhwB28civ4PtI9t5WbfYWPbswBUnMNSm/OYbN9RauW3iNZv5CteVz/
	dndIj6vcDzm9dsgj0mv5ngMUxrPOzoMD7j8mLW9iE8rf3Q+S9OR95C4CcsIJzYQOIm5XXWsR5rm
	nnIZnyTmHneqUO6AbPJNU16nz8gejo/EwbOBAuenf9G0G7OGexR36Y4hBc62Aze451GDE2gIIR+
	aHlTyKs
X-Received: by 2002:a05:6871:2b1c:b0:3f5:4172:1b with SMTP id 586e51a60fabf-4044d03e9b7mr4710865fac.56.1768792540911;
        Sun, 18 Jan 2026 19:15:40 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4044baf38ffsm6013358fac.5.2026.01.18.19.15.40
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Jan 2026 19:15:40 -0800 (PST)
Message-ID: <d98a65d5-3881-4029-8c2c-bc2dfb34c18e@kernel.dk>
Date: Sun, 18 Jan 2026 20:15:39 -0700
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
Subject: [PATCH] io_uring/rw: free potentially allocated iovec on cache put
 failure
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

If a read/write request goes through io_req_rw_cleanup() and has an
allocated iovec attached and fails to put to the rw_cache, then it may
end up with an unaccounted iovec pointer. Have io_rw_recycle() return
whether it recycled the request or not, and use that to gauge whether to
free a potential iovec or not.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 331af6bf4234..2b7521129f8b 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -144,19 +144,22 @@ static inline int io_import_rw_buffer(int rw, struct io_kiocb *req,
 	return 0;
 }
 
-static void io_rw_recycle(struct io_kiocb *req, unsigned int issue_flags)
+static bool io_rw_recycle(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_async_rw *rw = req->async_data;
 
 	if (unlikely(issue_flags & IO_URING_F_UNLOCKED))
-		return;
+		return false;
 
 	io_alloc_cache_vec_kasan(&rw->vec);
 	if (rw->vec.nr > IO_VEC_CACHE_SOFT_CAP)
 		io_vec_free(&rw->vec);
 
-	if (io_alloc_cache_put(&req->ctx->rw_cache, rw))
+	if (io_alloc_cache_put(&req->ctx->rw_cache, rw)) {
 		io_req_async_data_clear(req, 0);
+		return true;
+	}
+	return false;
 }
 
 static void io_req_rw_cleanup(struct io_kiocb *req, unsigned int issue_flags)
@@ -190,7 +193,11 @@ static void io_req_rw_cleanup(struct io_kiocb *req, unsigned int issue_flags)
 	 */
 	if (!(req->flags & (REQ_F_REISSUE | REQ_F_REFCOUNT))) {
 		req->flags &= ~REQ_F_NEED_CLEANUP;
-		io_rw_recycle(req, issue_flags);
+		if (!io_rw_recycle(req, issue_flags)) {
+			struct io_async_rw *rw = req->async_data;
+
+			io_vec_free(&rw->vec);
+		}
 	}
 }
 
-- 
Jens Axboe


