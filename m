Return-Path: <io-uring+bounces-3951-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 26FD19ACFE5
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 18:15:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C6042B246DF
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 16:15:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20C651C1ADE;
	Wed, 23 Oct 2024 16:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Dfzecdfv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDF613B792
	for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 16:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729700130; cv=none; b=QQa+KUAaCOKfm0N/5TKbgkiQns4Hgokpi31cujIimqy178yhSIlntSr7oMwS7sp6SrnEO9Wu0MkED4OuckD/Kn3sW8+9ISgM5nTGl1zxp6yv+EAmoFVn6QUY7cbNz0tYzjOVG9Z+MmeYFR0fMRfH4deZZd0Cfk30bHOkIkTf3fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729700130; c=relaxed/simple;
	bh=Z0kpiriFPHTK/b9vJVR+VM0EHCAbCDbXpGsQ/2t4pQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kYJhITrWkIxSluW5pEvayEp6/l7n4jfWS0aXTgC/R4OGJWat1syW285MnZqAQUEMI4w/LR7fYQhbYxiH4yQgMpsLCaKdH5EQNu//YfQy6CtcbzcH72fh3kV37PfV3ZSzNVTiyi0G3+ffW3t2QW9+7ssjFpkuWCJQG3x+UeHthBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Dfzecdfv; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-83abf71f244so192794639f.1
        for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 09:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729700126; x=1730304926; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aHfspwQxEyRhCy9SkIRl43Tdri8nV0vWzJCiZfMrWDI=;
        b=Dfzecdfv/8R+qJrPWDfl4Tln/R0FqNgaVe32WcXbN11wqiyqbeiP0qtUJ2CBL+AB8U
         WihDjalspPUD+omR6kZsLRZDqJPMaKkytd2GbDbM//kGeKJOo04sivHcjdXUU4Zye+WQ
         MaVVqNkGPIb1BBVwFIfiA6s5NwJoYD4dATDrIj9heye1IiEfKUioIqqdUPgh5r0bcVSb
         D9X2LYmvySevY52uC4gYBM54YeUQR0L3a3qbhqcm81Uuk76+Jgu07ApfQtFTadJx61jP
         Q2D8g31JnCbMA1PIRzJrHzQIXK+vq96y0DfQvkwZ6CrkwKkXboVP+v+LeFpMs0Xm5K3b
         kwPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729700126; x=1730304926;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aHfspwQxEyRhCy9SkIRl43Tdri8nV0vWzJCiZfMrWDI=;
        b=OBNvIzmrW81pkcz8nCZ0wSg6TUZ5PCSMQstEsWkCa9d1ee0/EZCAhC2BHj29CGAFu4
         iIWu9HffL0v7szcLw/PHNrgRssiPydoUpDtb7rTgbZkz/YboQ1OM5cHBZNXoPNORrOnw
         +hv2RdQd8m/WzKItuhPDlqMlIm6oEPJDwRVwu5DBzvfHOZoe8Wt6QGL3PCxgjiqdaViO
         +Qmu177mkfvgd8QZLuYT9Lc0jYGgx865tgpxKs5U1klZwz6d3A/9VFnvn3/+jxq74SLE
         HjUDy80yNreAYjmtSHEuzmExxVCgDprvfffAy7rvnFtSPgqQXHl4xZSo9Qq0TKdZnUV3
         wyaw==
X-Gm-Message-State: AOJu0YzTm6KECMGHe4pAi4byW4qC9rH7TP3G2HGPgTZmFVZiTjMlJE/3
	hWM/KUCOOiZzuLe99M12LVxZUReJwO54ZzqXaXGRMZipTYLl97JfJT2RzU4vLR0XLpG8lALelET
	J
X-Google-Smtp-Source: AGHT+IGS9hDCzocVql31HNJObnEAQDK2LRkhVV8Opl77/mTwv3ZfR7kglhc2JAxDfTFkoWuRmOgb4Q==
X-Received: by 2002:a05:6602:6d06:b0:83a:b7c8:a3dc with SMTP id ca18e2360f4ac-83af6155cccmr294769339f.1.1729700126240;
        Wed, 23 Oct 2024 09:15:26 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a556c29sm2138180173.43.2024.10.23.09.15.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 09:15:25 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/7] io_uring/kbuf: mark buf_sel_arg mode as KBUF_MODE_FREE once allocated
Date: Wed, 23 Oct 2024 10:07:34 -0600
Message-ID: <20241023161522.1126423-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241023161522.1126423-1-axboe@kernel.dk>
References: <20241023161522.1126423-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If kbuf expands the iovec array, then it doesn't matter if the caller
didn't set KBUF_MODE_FREE or not, as once allocated it should be marked
as such. Ensure that this is the case.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/kbuf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index d407576ddfb7..1318b8ee2599 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -245,6 +245,7 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 			kfree(arg->iovs);
 		arg->iovs = iov;
 		nr_iovs = nr_avail;
+		arg->mode |= KBUF_MODE_FREE;
 	} else if (nr_avail < nr_iovs) {
 		nr_iovs = nr_avail;
 	}
-- 
2.45.2


