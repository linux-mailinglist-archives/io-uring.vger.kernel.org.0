Return-Path: <io-uring+bounces-2567-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E198C93B036
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 13:16:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9930E1F212FF
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 11:16:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A066414A4EF;
	Wed, 24 Jul 2024 11:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PGzN7c/D"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05D8157484
	for <io-uring@vger.kernel.org>; Wed, 24 Jul 2024 11:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721819772; cv=none; b=TGC1k9ZLt1Neop7hb1pQsmx4P7EhiMjTDiJIaVSJ6peyelTnMQlhh0LO2cT5TUf59p/5LUgDq/BusexZadNhY1982dbRHovT3B8bv3kR8UX1y2F7Co5fyZJHAyqc4hjEuAIP0zjRMf3dIWD7S7BAwB39Kgu0+UcmItTMNycfa08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721819772; c=relaxed/simple;
	bh=YhY3z+W1X0D9gHwO7eWabrVEsRS6BZJMNPo7BZbqWNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XDsuvFLXci6dsJjpJbMtJ86GuQ1PF8USuTQYYVds4Rzsnzi98ztdaO+OkerpEW9gjfmyt/1NABSeYSalVinsqTd1fzMjAtXk7RSvi9q5pkuMLq/pFxrOFOg4simm1iepFZnXtJQ9jp59jLmaSUZVIE5mtZvjrHjqCbpdcgIqUIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PGzN7c/D; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2ef248ab2aeso60578191fa.0
        for <io-uring@vger.kernel.org>; Wed, 24 Jul 2024 04:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721819768; x=1722424568; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YlfOiDcV+xFMbCLirMw48k16oIhVBdnv0gB3Y16FZ4E=;
        b=PGzN7c/DOVOJxvRTTL+RBPVsJdxCgdJQ3u2Zmc9B06VyzibkWtSyCaBTxmgMNi9fp8
         vsBqxkTBrQpX4CvFUb26geThoyUJRb9rhDluMfAjqk3KWN1+p9KRE0XSxUrPHKZ273F/
         i/FwVCZhf0DSYcYFAF8RCgfWSNVHlIm1x67c8wAy2h6oSYJW2mpkxOX6evdHbnGMHbWK
         NdUKw2IanhwxL9qbC8uVsCJ9A6wzDba+QOqeMDKRFIWuKJxRXc6nQSRPt0Hiq4fSdMU7
         UDIeGPFS7A/gkFHD/2LpH/MeiCOfIEWa2FoSzgaFGvdOWL2yxG/fbx7gyGkoWspRQfmo
         CVKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721819768; x=1722424568;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YlfOiDcV+xFMbCLirMw48k16oIhVBdnv0gB3Y16FZ4E=;
        b=YBl4N/2yjNTk4yUidZL88fbtXJdFPhLNQuF441ShObymO69zQnDYwJirVkIdstsepI
         9gHiQlIb/iUOmSx35YjWATTWzkXYOSTcWLnEDf07wuNmGXqVehXXaW0MQI05h6YMz3Bx
         RVkM2Mt0ke5Jri9H2fKpGx6LqG1qjlU986aKcpIu8gSQzyxhF53pQNw/2JtWe9e7Ui1I
         Fl2KkPF7HXZS1mgiiVfdjAWYio99fRpWhll15OdqCEK4ZHEPCvMDj7NIVJPsQI4Sl5jk
         gTbEyAWf9frNxNZ3WRnGq81R8KK1KdJTV2+/eWMJHXBMtuBQ9OKiul4DVzmyXukiMSrv
         XM2w==
X-Gm-Message-State: AOJu0YwxQnmnvLmVX478hobGFbM9MwXfqw6vCkSSrc5p+lYBZslzfWT8
	gprUgCX3lwWtzG9x79oCcmMvywsBu4DoWvpbgi/i56doYXZnRJUcZz06fw==
X-Google-Smtp-Source: AGHT+IEUc1xK3pIP5UmYhH+Hqo2YWS6wWD6UUXoAymavBeCbxF3XsgVgG/GkmLw4yp7+wdTjycnE8w==
X-Received: by 2002:a2e:9789:0:b0:2f0:1fd5:2f32 with SMTP id 38308e7fff4ca-2f02b99e528mr22464031fa.48.1721819768195;
        Wed, 24 Jul 2024 04:16:08 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5a745917f82sm5006310a12.85.2024.07.24.04.16.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jul 2024 04:16:07 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 6/6] io_uring: align iowq and task request error handling
Date: Wed, 24 Jul 2024 12:16:21 +0100
Message-ID: <c550e152bf4a290187f91a4322ddcb5d6d1f2c73.1721819383.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1721819383.git.asml.silence@gmail.com>
References: <cover.1721819383.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a difference in how io_queue_sqe and io_wq_submit_work treat
error codes they get from io_issue_sqe. The first one fails anything
unknown but latter only fails when the code is negative.

It doesn't make sense to have this discrepancy, align them to the
io_queue_sqe behaviour.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 10c409e56241..2626424f5d73 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1849,7 +1849,7 @@ void io_wq_submit_work(struct io_wq_work *work)
 	} while (1);
 
 	/* avoid locking problems by failing it from a clean context */
-	if (ret < 0)
+	if (ret)
 		io_req_task_queue_fail(req, ret);
 }
 
-- 
2.44.0


