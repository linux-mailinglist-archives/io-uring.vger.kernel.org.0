Return-Path: <io-uring+bounces-2112-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F4B88FD0E9
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 16:35:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 83848B2B534
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 14:20:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BD131863F;
	Wed,  5 Jun 2024 14:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="03NiykMr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA371EB56
	for <io-uring@vger.kernel.org>; Wed,  5 Jun 2024 14:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717597186; cv=none; b=hFFebUWbNv30ZiX8sLrhGyKGHbOL4VabnoVZoKubL9mvBcdROVokIhZtj/bnUrBwN8IUnH5OTh5UHMzebm5ETEyto6o7Wm3+owaghSQtgMZcHnaig/0n5GQqANO4wAksDTfaRCCg+obp3jzPwTBwQJfI+B8oNT++yhG9UYngkDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717597186; c=relaxed/simple;
	bh=DbCyZ2luzl89+Eh8uaBBmuMYg9vSkfpTwL8ayHGzEBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lc7dWDXK7bGuBXEcv3ZdLQtekuSbj/alntISG0jGh1QOER+R/iJbCRAKHIWOOVLZjtOCySxnNwAPlWTYvWDpOc8Gz7FgODxqz3XL4LyekdwfjEPYT2zwG4CCwf4JSLHtTyT4w0pocoQWNjvYvXOXgRVc2MYKzzgr4aQWstJmypk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=03NiykMr; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-250932751b9so112014fac.0
        for <io-uring@vger.kernel.org>; Wed, 05 Jun 2024 07:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717597183; x=1718201983; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wOQkpDBR8PoqEAncRvt11g7sOP8fj8jrMBX5gQ7aO/o=;
        b=03NiykMrQwFIW3sNZDnK29vlf8nIg4ujkv8kCPvcYY/QnvDgAkMQ+i+jz1bHbrvQn3
         NsF/jm1yTigpmfyWDHGdjtjQSbKcL8LOsn5DXFsS/+DZzzy8/dequMFg/IxPiSLO6MRJ
         k41hzoWBmw4K75GRVYEZHo/Ge24RIrJQgVhJEr6oCBTLrWxo98VfgJF870Fw5SFb2dnE
         G3HOto/OI+rY3d3P5RBnBeidZkCUTTxzZiILJf2waq57CD9mzYT8ZIwd8CVyrzwcUiSr
         0hxq5sLkU8wuv882rX7efLxPocd3vN2lo8Og20ZiHR2F1IynLwYo6NmOIpbPoz8ceyys
         u3QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717597183; x=1718201983;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wOQkpDBR8PoqEAncRvt11g7sOP8fj8jrMBX5gQ7aO/o=;
        b=Ta9dGgGbVSp5pQ83hNzB/DjfZkoJZvSmC7FyAa1cNNrOg+bqObKuxgGSxE/ZziYN7Q
         a4jr0prgNiSgvQP3wu/5h4t34koeuMd/t6qseZOhGI1+nME8ww8MvVokACpRGcF4VOhC
         Ox50oLdO6nQjdHEntaeIP5ZtMuE6gJKlD6ZE5B581x6MhRu4ZIbOrfIq8Eelcy5YeJVh
         0ptK8+EJnZUS+2DlQKVIKUu1BmFJZyLX9S50xcQCy38JrPnJ9XpQTWHm9hfTroKIGEtD
         gUTWNDiLEvpp7f2TuQB3df51VuU2TDY14O0nWCJRvx1grZnBLYr2/ClstsZmSj0Lwo/+
         vtcA==
X-Gm-Message-State: AOJu0Yw0nsiZzOAKZtBphfR92rtr8Jmyd5X3XmcFs3RgQyLVMorYl17z
	XG/t+qza9u5tnZP3ZOseURVNcz5J9jMXgQgUbT+n4JE+7Su/bGoQFXL6yx/+ViciQip1uaW52nX
	k
X-Google-Smtp-Source: AGHT+IGeepSW53VyIRITsVkpvjPOs3mUr4KvPSIJdsWpHSFTFlmCT+T8s+90HyE8K7O4aMvnehsoPA==
X-Received: by 2002:a05:6870:548f:b0:250:7c91:2bef with SMTP id 586e51a60fabf-25121f10bdfmr3041101fac.2.1717597182468;
        Wed, 05 Jun 2024 07:19:42 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-250853ca28esm4048918fac.55.2024.06.05.07.19.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jun 2024 07:19:41 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/9] io_uring: keep track of overflow entry count
Date: Wed,  5 Jun 2024 07:51:10 -0600
Message-ID: <20240605141933.11975-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240605141933.11975-1-axboe@kernel.dk>
References: <20240605141933.11975-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Not needed just yet, but in preparation for factoring these in for the
wakeup batching.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h | 1 +
 io_uring/io_uring.c            | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index a2227ab7fd16..d795f3f3a705 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -325,6 +325,7 @@ struct io_ring_ctx {
 		unsigned long		check_cq;
 		atomic_t		cq_wait_nr;
 		atomic_t		cq_timeouts;
+		int			nr_overflow;
 		struct wait_queue_head	cq_wait;
 	} ____cacheline_aligned_in_smp;
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 96f6da0bf5cd..94af56dd5344 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -618,6 +618,7 @@ static void __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool dying)
 			memcpy(cqe, &ocqe->cqe, cqe_size);
 		}
 		list_del(&ocqe->list);
+		ctx->nr_overflow--;
 		kfree(ocqe);
 	}
 
@@ -724,6 +725,7 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 		ocqe->cqe.big_cqe[0] = extra1;
 		ocqe->cqe.big_cqe[1] = extra2;
 	}
+	ctx->nr_overflow++;
 	list_add_tail(&ocqe->list, &ctx->cq_overflow_list);
 	return true;
 }
-- 
2.43.0


