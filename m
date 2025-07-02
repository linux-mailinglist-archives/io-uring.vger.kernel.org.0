Return-Path: <io-uring+bounces-8568-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 904FEAF5A62
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 16:02:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E3BB81C22B09
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 14:02:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 127F2280025;
	Wed,  2 Jul 2025 14:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CTTPP9Gt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93948277CA6
	for <io-uring@vger.kernel.org>; Wed,  2 Jul 2025 14:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751464933; cv=none; b=q0OuOS+sCqTFNrW0p3wRDvXdliFmHDgPEPkMRynYUIHxulJn+NrlzNM2h8kWaJm9gtaR4AqPVbIKGxcYWfhBbk2dn9j/h9+8LgBglPicGZt0VxnfK2JNXEMAMnb3LmPvN5YnHSrx5NduR2fO+qME0ZGRgSJqgio7NZONWoKMv1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751464933; c=relaxed/simple;
	bh=Nv1J/YwJd/1WInHQulecxJCT+Owuj7WTyA5M9tdgtHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m30H1bUXRYqViwejT8hQSsBHCbwrkds55/ZJFaCA5F6GLjagBbWxWzoG2yIk6ZTn0XsAuXTRFpuInq0Mdk1s4D779qOQZQPNNDD6o86+Ztpe45Q2nSYDJl6l9hNlujADxO48GrUjjFfrbgKxEuE8yUUBB+Bh6vOUy/x0lIYsiTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CTTPP9Gt; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-234c5b57557so44013585ad.3
        for <io-uring@vger.kernel.org>; Wed, 02 Jul 2025 07:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751464930; x=1752069730; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BD3cUMqYJg997d1pue4/G4HDRqC/d97A0JSEAjfGGDE=;
        b=CTTPP9GtEDIvyme9AaV+mNUWQgo6ECbuXHj0WuOOQMVWmia3jfrx2LjCSzT9HAx0yq
         PNGBjTDvLmZSOvBtPpX6aS9UKCYBqcCF7C2AlHSBCrOBylhfo96vuEycZnC8gA6ZH+S/
         CQf5c/X0C9iDlQwbvIRavNhIAP1woNe60B1ZHd2RxO1XmHLZsCsGTRIkRi8LFC6djOEC
         eERriW+QVRdCuAjmP20uT/Mlh43H0hWwpQzv3Gm91DHSAPRCuho23pORlOD4HUMQUA5+
         BUO3XQOSkcjybu/qWacKtS+ZssG2J1SAwdCIhhkVU9L8mqFpqKg3yUJzzrdbXoTuRbu0
         QaAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751464930; x=1752069730;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BD3cUMqYJg997d1pue4/G4HDRqC/d97A0JSEAjfGGDE=;
        b=skyLKfZt6xRtFf8W9F4D42h+bfJ/zB+90rDlQCC14ZTC+exVJlf1Ta0mG9HGPAXt3F
         sLaNGkqqj88IuE+UM6SijRBPGbbscU9ptGlGaqCpHGNCDJMTZjOtGQLwHZ51PSfXjfoU
         z1x71hSPLereLjP7vynORG8tJRF9QGj77XvGbu+8z0sEw5KmZ4TfX4seYQdBc3ERm/29
         KimMxS5FjqIjK4UWpLiuEXYDZSgud2OUIY71C3mmfLjdWj3kudYHCP0prl7A7/+gAS4t
         eQ5JBuKkZu/afxB5QUP9XbpCJFlfUg/Udb/8+YxEmoqfkXVVic0jFZ1X4exDz2n0St0Q
         0pTw==
X-Gm-Message-State: AOJu0YyyEixITkEkdN14Cm77mr3HFdByG7iiJr/7/LHWeS+IPd7vLW3D
	CApgD8g7gAIOc6TuUbJ+ob9yvoB+/85WhTyDxE0jT0EOwBy6i5PIzI90L1RqPbr9
X-Gm-Gg: ASbGncu5NamHhzBODDScZczvz6ei57+J0Ohi34IDE/afpvezfj6rbgIJHrr2m9WUtfJ
	Sq9hpnmYcAn3s7GG2TvmI6r25+Yt8r4nwzJ0wX/AXzRX4e3hJZC3Wgt8kek/eL2U5NK4h0zDkDO
	Mn4QOuR4s5SDR57nThbx4uXvQ7JuLzaRi+JhRZF3mz3Me/y+BKz9eGSZS/VUAiADmEaxkgX7oej
	xdTTaoSaKL+Q3X3v0fQB09+hZ7nEdUd3WBaCOl+aTvko4Ka/HUI1ppBwlOXwaAg49Ai8A+qOINs
	KsMsOI8ZFUde0MdvNVLRtlsD8DR3y81OMROpP0bTaVtgPFcKKdKGECRdrK4=
X-Google-Smtp-Source: AGHT+IE6HbYucn+r6WP8Glhw4xy23StQ6uHGHbsRdR43hL5gorBgL707B73BM0a4ZRc71uYrxMQl/w==
X-Received: by 2002:a17:903:41c6:b0:224:10a2:cae7 with SMTP id d9443c01a7336-23c6e5708e0mr43272565ad.40.1751464929169;
        Wed, 02 Jul 2025 07:02:09 -0700 (PDT)
Received: from 127.com ([50.230.198.98])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb3c6e14sm126828135ad.228.2025.07.02.07.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jul 2025 07:02:08 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 2/6] io_uring/zcrx: return error from io_zcrx_map_area_*
Date: Wed,  2 Jul 2025 15:03:22 +0100
Message-ID: <42668e82be3a84b07ee8fc76d1d6d5ac0f137fe5.1751464343.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1751464343.git.asml.silence@gmail.com>
References: <cover.1751464343.git.asml.silence@gmail.com>
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


