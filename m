Return-Path: <io-uring+bounces-2790-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A51C4955073
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 20:01:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 25C011F21959
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 18:01:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 434C41C230C;
	Fri, 16 Aug 2024 18:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="XxQG/vqK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EB01AC8BE
	for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 18:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723831311; cv=none; b=c+DyWVKKIIOWu2OTpkzmcOY1HAbRi2IomFd5Q3VF5Am4sELciIOYaRUkGYloc7sMvpu8wTwVphxs5MDcmNKFJC8We+XDE5dIpcuhIg/iE1hpPQeTAs+PaalyCAPSMYsOs1w/QvWwkZA73UGBMemODZs8z4/nJ5vooI+faQUONLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723831311; c=relaxed/simple;
	bh=1pjiXVrs23bAZoampHMpZnf6iRv1ZrGUp9ewj3/VB1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lcqvKoKjYRJc4NEGxYY5W8GMUmbKyb+i+aQjZIocC+xAN7pLu+KF4n9bhVbjDJYbpmMA2RsPjmoFytuw65Cjjk6eal6IldQlGbJ1DMTaxa8aIyXWM68ynt1kqoctDme7a+BC/RH1nr1xNtzcykCjTdlXDXoARLEyi2mrfip/u4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=XxQG/vqK; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2021a99af5eso20995ad.1
        for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 11:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1723831309; x=1724436109; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ke3AOIKA3Yax3N7x8wo2tJPHEZgh5pyF9+zELxS8yp8=;
        b=XxQG/vqKoMu2ZrWxkXiFv7vQ080p36YKI7CytQMzSfXVdo4RQ8RNSHqMUwwYZhWsET
         fJSrS7OLDSlWaJN7tmlb0gWgO0BSCKs6WUxcrEVKGJMXAwMZ2CPxfd6KnI3cyDtrqNEG
         aUDXW3kN2tTzkz8k75rhIrCj4bkguzuDnIfzPeTJ9DScsNncT06N5LqIzHY4677ZjMhH
         9tv4gXXE64M+GSlluTJQmtzIwTn5sle6mRH3W67avVypxQvLHawlPTYpq6lHNb19CEFi
         weOLF36EnlukVJhvDe9GcXM6AD3CB0LU8p2ckhVozyKXD8m86l68y6Wr9Hx1chs97iiL
         GVIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723831309; x=1724436109;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ke3AOIKA3Yax3N7x8wo2tJPHEZgh5pyF9+zELxS8yp8=;
        b=dlHeKdSSUvSZgcsiqW7UoxKujU7b9DTQ8CjsEYeP+sgUjLUBh/BczaKUXTn4EBZQsq
         uUkcntfKq7MfpG5US1i1HKrB2UkvbjZnBi6Fx+g2mG1Unlq0rt2AUw/p2F1kQD8RvaCY
         Cf7Tbf58C9ADy7P79eWsN5krzWobkkNof4ow0QnwmRpWxtYkuPVgLEPR4DB/Z8y+LpTt
         sT7yRv/sLUvbF+Cl08x29wpqymyXGPbKhSwx2TsuusTZtvlNz4YEXshdSGPqS8RqUSOj
         Bu+cku/6Pz1tpxFmOZv++USOJCGl8LP1hMCUGl/iImkvzyyhgXfSEaud1TS5hW+mRDN7
         EpJw==
X-Gm-Message-State: AOJu0YxArp+AtnKRU30yThpWK63PA1qm0P0vFoOPBCGv9YZdpkzmtsXE
	kEUqy9G7Sn+qD6wX/9vXRrJ+xCHuYEC3eVQXZZk66pSpsWGr7WR1VvzH/ctNC0OyISR7p6O5BFz
	O
X-Google-Smtp-Source: AGHT+IHcykNSsTlSbGSzSJrsVdVrFLeqaOLXk44GywjB/Q42UrmX6yXIF3reLxiP1Y9pxEwmgWQyvQ==
X-Received: by 2002:a17:902:db09:b0:1fd:a1d2:c03b with SMTP id d9443c01a7336-20203f4d83cmr45634835ad.59.1723831308601;
        Fri, 16 Aug 2024 11:01:48 -0700 (PDT)
Received: from localhost (fwdproxy-prn-003.fbsv.net. [2a03:2880:ff:3::face:b00c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f03753c9sm28232195ad.167.2024.08.16.11.01.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 11:01:48 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v1 1/3] io_uring: add IORING_ENTER_NO_IOWAIT flag
Date: Fri, 16 Aug 2024 11:01:43 -0700
Message-ID: <20240816180145.14561-2-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20240816180145.14561-1-dw@davidwei.uk>
References: <20240816180145.14561-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add IORING_ENTER_NO_IOWAIT flag. If this is set then io_uring will not
set current->in_iowait prior to waiting.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/uapi/linux/io_uring.h | 1 +
 io_uring/io_uring.c           | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 48c440edf674..2552d4927511 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -508,6 +508,7 @@ struct io_cqring_offsets {
 #define IORING_ENTER_EXT_ARG		(1U << 3)
 #define IORING_ENTER_REGISTERED_RING	(1U << 4)
 #define IORING_ENTER_ABS_TIMER		(1U << 5)
+#define IORING_ENTER_NO_IOWAIT		(1U << 6)
 
 /*
  * Passed in for io_uring_setup(2). Copied back with updated info on success
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 20229e72b65c..4cc905b228a5 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3155,7 +3155,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	if (unlikely(flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP |
 			       IORING_ENTER_SQ_WAIT | IORING_ENTER_EXT_ARG |
 			       IORING_ENTER_REGISTERED_RING |
-			       IORING_ENTER_ABS_TIMER)))
+			       IORING_ENTER_ABS_TIMER | IORING_ENTER_NO_IOWAIT)))
 		return -EINVAL;
 
 	/*
-- 
2.43.5


