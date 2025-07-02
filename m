Return-Path: <io-uring+bounces-8576-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9066DAF5B1C
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 16:27:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D9A3518955D0
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 14:28:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC62F2F5310;
	Wed,  2 Jul 2025 14:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L1FkIxHh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4525C28B503
	for <io-uring@vger.kernel.org>; Wed,  2 Jul 2025 14:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751466470; cv=none; b=VODYOLUjWI5WBEsLOXwguxt4rm2Mk9/tZES8srlHoX4ftaO/zX2piTYIL4Hh+tMsy8/cqKhx8gbE5dMwMEBNooiuNu3NxsQ+rAxr6CQRomSCL6L7r3zRIByceRyzx6bIN0GZLOcQ2N30P9sN332Eb38tzdvpZa6hB2REOHcjLeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751466470; c=relaxed/simple;
	bh=Nv1J/YwJd/1WInHQulecxJCT+Owuj7WTyA5M9tdgtHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uBcfIwZC6Mz0Td1QlzKjeldmX3ycYxrTkncLvYIL1h/+Q+ljMivsLppRlbRbw6yCJHSpYLh35A6bznayp7hEEbIUNwVlIW0iElczRaRnYkQJd+ZisE1T/JtAe358KUzdeS7u/3pvTmRcbwtZHvMW7EOcfXoEY/ZmLSAbKhm1pCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L1FkIxHh; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-73c17c770a7so5666970b3a.2
        for <io-uring@vger.kernel.org>; Wed, 02 Jul 2025 07:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751466468; x=1752071268; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BD3cUMqYJg997d1pue4/G4HDRqC/d97A0JSEAjfGGDE=;
        b=L1FkIxHhZ6Bq0Oxhi1VyIJDQVURkLG1QIiJEd91RosSX9afEUtuQ9m07nOXBPfeqi2
         6yuSm1mmH3IUrqwY2a8bWPOtPzrmBSNQZMmwP19IX92mkTYKvanX//1bkpZif7jdgr08
         mIVaOAuSapdw0KW/+mWua4uNT/tzHpvrhUlCm/tXqtE8vriJ7U49f2YJjRS30hLysPoA
         0VdH9+sGcm28ZVDjQ04LJybz22BiFGuiXMfqhwFNSWu/OqZmXCmBc4baVjzZhvOPI4AC
         Cfv+Tr8ZLeAuwSbgwj7Vjxa5mJvOPJZfS8yMlFlTtpNOnPBGaECoIE7BOshSBmzFh5hT
         xiOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751466468; x=1752071268;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BD3cUMqYJg997d1pue4/G4HDRqC/d97A0JSEAjfGGDE=;
        b=oMPioT+roqq3QR7eJ/RgnilZNuuD2gY8KSMJqrbmX+VAxm56drP8dfQAt42QRq138Q
         FFcun3+h3PIIAsCBsbGzCaM6y6xfFHStVdXDS/jt4v8p1v21lyTTemmPbV+gtItcEPDe
         TchvTxlkAmZFOsnDcAB6Z/tS/EPFHDHKJ+zNL10qODYWm6bxTP+DV/eByLeMqMW0Ys1i
         SKtrkyhW7Z0x1QUvW7W1hiZTtZc6B9TN0W+jHsvvW/41br1CvbZAev0RkioRkJA2MCxJ
         aeMAMEmOR/TXa9QTyC1w7e9+dVc2rHSLLITvqs9R0GwBnnQzAXPRF0xW48tbr/ZDR9jQ
         CEww==
X-Gm-Message-State: AOJu0YzWR758AGCFX9BNphXdA2TA96sZG/QMlQwwb3tvdJGH4jBsHHzN
	fUV5HRvsabkXlU7CHsMbNAW9hE9aUiyJ+wIFQaGuTtS28JiRNK+THxjmUd1b+0E/
X-Gm-Gg: ASbGncuEDrSRWM9Lq4l+QZkF+xSJEsDABfgcB2soQAWpcB9z0/DPgwlxpkV985Q+2kj
	INmMJt91aEWY8pk6ZZMN61kebK7CLx3ziTfJv0XiwAtkO/txDGMP1OHEUkf51VJ1IselhEd5Oxo
	SiparD4PLo4dODfCpVqP7W5WWI4jDuWvN3iprOWdOPmv3GuACtjumrlFz0aglvN1S89mpcQ/hRs
	6gAW/wtdOvd+QAjytx3kxtSAgxoUWbnq4fXfPLjSJOqfSM5c1HLsy6S5hTAEpojc8KiUUV27khr
	gYUV1dUaYBaoLskrCYql071go0pqEBao2bAuPuoq+JOJykjtnpp0Wdd29fY=
X-Google-Smtp-Source: AGHT+IEad+CLTTnKElupXv0onOo45z6FA07ieBvrpEY+2Zie/28bfBEDtfw9ZtUMJLoMdSMOPSfH2Q==
X-Received: by 2002:a05:6a00:1ad0:b0:740:9d7c:8f5c with SMTP id d2e1a72fcca58-74b514c3b03mr4612790b3a.18.1751466468012;
        Wed, 02 Jul 2025 07:27:48 -0700 (PDT)
Received: from 127.com ([50.230.198.98])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af5409a41sm13765094b3a.29.2025.07.02.07.27.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jul 2025 07:27:47 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v4 2/6] io_uring/zcrx: return error from io_zcrx_map_area_*
Date: Wed,  2 Jul 2025 15:29:05 +0100
Message-ID: <42668e82be3a84b07ee8fc76d1d6d5ac0f137fe5.1751466461.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1751466461.git.asml.silence@gmail.com>
References: <cover.1751466461.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_zcrx_map_area_*() helpers return the number of processed niovs, which
we use to unroll some of the mappings for user memory areas. It's
unhandy, and dmabuf doesn't care about it. Return an error code instead
and move failure partial unmapping into io_zcrx_map_area_umem().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 99a253c1c6c5..2cde88988260 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -139,13 +139,13 @@ static int io_zcrx_map_area_dmabuf(struct io_zcrx_ifq *ifq, struct io_zcrx_area
 			struct net_iov *niov = &area->nia.niovs[niov_idx];
 
 			if (net_mp_niov_set_dma_addr(niov, dma))
-				return 0;
+				return -EFAULT;
 			sg_len -= PAGE_SIZE;
 			dma += PAGE_SIZE;
 			niov_idx++;
 		}
 	}
-	return niov_idx;
+	return 0;
 }
 
 static int io_import_umem(struct io_zcrx_ifq *ifq,
@@ -254,29 +254,30 @@ static int io_zcrx_map_area_umem(struct io_zcrx_ifq *ifq, struct io_zcrx_area *a
 			break;
 		}
 	}
-	return i;
+
+	if (i != area->nia.num_niovs) {
+		__io_zcrx_unmap_area(ifq, area, i);
+		return -EINVAL;
+	}
+	return 0;
 }
 
 static int io_zcrx_map_area(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
 {
-	unsigned nr;
+	int ret;
 
 	guard(mutex)(&ifq->dma_lock);
 	if (area->is_mapped)
 		return 0;
 
 	if (area->mem.is_dmabuf)
-		nr = io_zcrx_map_area_dmabuf(ifq, area);
+		ret = io_zcrx_map_area_dmabuf(ifq, area);
 	else
-		nr = io_zcrx_map_area_umem(ifq, area);
+		ret = io_zcrx_map_area_umem(ifq, area);
 
-	if (nr != area->nia.num_niovs) {
-		__io_zcrx_unmap_area(ifq, area, nr);
-		return -EINVAL;
-	}
-
-	area->is_mapped = true;
-	return 0;
+	if (ret == 0)
+		area->is_mapped = true;
+	return ret;
 }
 
 static void io_zcrx_sync_for_device(const struct page_pool *pool,
-- 
2.49.0


