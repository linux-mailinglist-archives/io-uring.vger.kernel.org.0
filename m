Return-Path: <io-uring+bounces-9256-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54739B31942
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 15:21:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32842AC4E4C
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 13:17:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05D0930499D;
	Fri, 22 Aug 2025 13:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CydOrFPe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A88302CCC
	for <io-uring@vger.kernel.org>; Fri, 22 Aug 2025 13:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755868566; cv=none; b=WXR9KWrWJ0DGVn+sh0fPaMNUNRAZi5hrsvAO66kurr7qN5pFZGN8UzfXj8zRzPZKMfFjNnFWEhJrDZcTG0GNM6tGFY+MAvmu7vLQ/K9iaVHHuGruHWVtdJzIIZMXUrr+SU47c6CL8Dt0CYU6eXHCQYomG/h3MD80y5nOqdmdKiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755868566; c=relaxed/simple;
	bh=lCsro4CJBMF+D3264rl3CNoPtUXoImd/BPkzVlHunKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m9fVEofw6lE3UwUh+aUDkPMrdxvRD/s7exnRPhsJBMKQmIhU5uSf3UeT222DqmbyO9ElpC1e9OItU5RJpj/aX/AnzteyO2KKblMEOI2dq5Up+zGqWNiTW+BEM1Ql9Q7QvYLBP0/N0UKaDdOsFlg2iwJR8CMGYzd2Erwc51n+KOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CydOrFPe; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-88432dc61d8so185450139f.1
        for <io-uring@vger.kernel.org>; Fri, 22 Aug 2025 06:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755868562; x=1756473362; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9AKAb0qEkHWYZZg+YlLBlMjnmdIz5QWZ/OiVNDXJAIQ=;
        b=CydOrFPeOQ+0BSMZr30hcUvwt+yUY6P0+BkAZHPB4krN7NugIakvyIauuati9q7Qly
         8aTd7Eevg9YbZJ9xQ4TgUs0F+pPmHEvgGXNn/UyFsmGarO23ZnXHoF4C9MyCb7gPz/zQ
         cCiYLL+0cTvrUUxiDpMRdrEJfq4xEMqcEpdiEWcSzeHW29FYW996xDZz1tua+/M2L/Q5
         cb9/pDqXk9pKkeKS9TIKWzpuOv/fjdo5JDKkA7UXq8HKC17BLMp7XyaXFiLpYM8SmoiK
         x7BqPhm+Vtz+hBrrE5CRjqDg4nUSuqPpZrCCoRTjxTpvBTeOFjlWHcT49EBbDJ9UrCtT
         ET8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755868562; x=1756473362;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9AKAb0qEkHWYZZg+YlLBlMjnmdIz5QWZ/OiVNDXJAIQ=;
        b=xSZPDa1a/moAPoMCpJYB5ergdsNPbgbXYcAkPa/wlPZq4Es62/tKUURvzDXr2lsPOU
         Rqrr2TZb1rOMJbdE+l5rAiK1+QwhF2x0Y2qgbHwojO5shTukwBpoXUlIjObhY9S3p5jr
         UXc6id+9UVa+YrIlhAvzwkyJSgzJ6M7Enhn0gI6SW4+Fl/+OqcEr2R16NDPy2UryTHC/
         nk5mO5zvckiDUYkrZxMC21tXuZdDKQbVmvHW4MLbaRqeyDESuBP4umanKkuetmDV5Iys
         j7EHQGREupLEUzmyk2/K8oEPR2GcGtRztPkvPp4hL5kmCC772QuekixcFz6QHnsSLy+I
         34Aw==
X-Gm-Message-State: AOJu0YxZ8rZtup43+TGUts5WC8A7NUF3FSGizI6hAcRoLMjqrr4o+6aD
	6wNsQxhoxuJgAoE2JP64GdN/Wq6Z3ohhQXNY7XFamA5VaiNln0wiROcz1MSxPEE4Djc7Y0jmJpe
	b6azu
X-Gm-Gg: ASbGncsKpfIQEvCd5F+rsPigoQMzeW/S/x+ht6E1WXiIrssplrmZgtrJYhmitGLL41m
	Qbe2KyCR8oc8pVT6a95GsUxRj/ne8hnVr5opCdYQRccB1YHQBz6cv6tdKeoGhMja8419c/pfk5x
	dHpzVQ08ZJN7e608TWg7eevbtX54220NmbKoweuurKUGL/GhXD++VY14QHADN/UATLVHYMUc0ir
	0ZGgkVq9GA5+/B9z/JmA71w4n9jTKzeS1y+0NHzacDQ9cGoTghs7gjSws1eX9ZHujXNTwa9PRON
	aj7EJIdFXZcXNersN/lILVC5eMGZkJ2Hvy++bgOZYOG5PJf/25AOb+uNITPVoBkVjpU6BnS8b7D
	w3/el6A==
X-Google-Smtp-Source: AGHT+IHZ5YQhjejrPhudiZOgQaijyjtdhk+xq2EPlLZOIVAxl150S4/CKW7qPcD+okX5qetQN5C0cA==
X-Received: by 2002:a05:6e02:228b:b0:3e9:eec4:9b74 with SMTP id e9e14a558f8ab-3e9eec49f44mr11692415ab.31.1755868561112;
        Fri, 22 Aug 2025 06:16:01 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e57e679121sm89355595ab.30.2025.08.22.06.16.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Aug 2025 06:16:00 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] io_uring/futex: ensure io_futex_wait() cleans up properly on failure
Date: Fri, 22 Aug 2025 07:14:46 -0600
Message-ID: <20250822131557.891602-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250822131557.891602-1-axboe@kernel.dk>
References: <20250822131557.891602-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The io_futex_data is allocated upfront and assigned to the io_kiocb
async_data field, but the request isn't marked with REQ_F_ASYNC_DATA
at that point. Those two should always go together, as the flag tells
io_uring whether the field is valid or not.

Additionally, on failure cleanup, the futex handler frees the data but
does not clear ->async_data. Clear the data and the flag in the error
path as well.

Thanks to Trend Micro Zero Day Initiative and particularly ReDress for
reporting this.

Cc: stable@vger.kernel.org
Fixes: 194bb58c6090 ("io_uring: add support for futex wake and wait")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/futex.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/io_uring/futex.c b/io_uring/futex.c
index 692462d50c8c..9113a44984f3 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -288,6 +288,7 @@ int io_futex_wait(struct io_kiocb *req, unsigned int issue_flags)
 		goto done_unlock;
 	}
 
+	req->flags |= REQ_F_ASYNC_DATA;
 	req->async_data = ifd;
 	ifd->q = futex_q_init;
 	ifd->q.bitset = iof->futex_mask;
@@ -309,6 +310,8 @@ int io_futex_wait(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
+	req->async_data = NULL;
+	req->flags &= ~REQ_F_ASYNC_DATA;
 	kfree(ifd);
 	return IOU_COMPLETE;
 }
-- 
2.50.1


