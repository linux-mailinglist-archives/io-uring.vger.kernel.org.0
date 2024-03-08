Return-Path: <io-uring+bounces-864-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9501D8765CA
	for <lists+io-uring@lfdr.de>; Fri,  8 Mar 2024 14:59:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 299832817D9
	for <lists+io-uring@lfdr.de>; Fri,  8 Mar 2024 13:59:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B15040868;
	Fri,  8 Mar 2024 13:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B2R9P9I0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39343FBB7
	for <io-uring@vger.kernel.org>; Fri,  8 Mar 2024 13:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709906331; cv=none; b=BJRBWJBuRHDoBq/Euqq6kaatW7JffAMocjWGhGwSnO+hw5DolxLtgooU6rC9TeHXKZJOeHuQXXEPNJXQHVaVhpgwFlA3c3YZ7VbS+3XWDwIY8UC1zjNozsVuzAv0CLfB6bdfzPUeFBpbZ0/FvFmaB0vPTn3jsdsYRK1XFF3gKNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709906331; c=relaxed/simple;
	bh=kLBOIJPjNWZ/WKku1IIFFux9O3I4hS7Otz3AeffrseM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H3WcmjvtEqIqL8hy5Vj5D1egtM60dhfnwiAIp7jQMp4skUkKd2WHoW9Hz3JLzZ3R1P9BSdw9gwqLnvdtfOh4z5vxp+mi07mK0ukF/cnLAeyQoSMec857xxwKE5pc9rvGgQFLq5MHMgegsgVcifz8FyUCP3/g3es6iu5g95JddDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B2R9P9I0; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a26ed1e05c7so311654366b.2
        for <io-uring@vger.kernel.org>; Fri, 08 Mar 2024 05:58:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709906328; x=1710511128; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NJZOeTUKvaZ9tzibdK6mZ+2xfJqhd2aZvSUwYP3TffE=;
        b=B2R9P9I0PO7xUxbXLJnBfGFvcVIbp9y1SCJKSb4STqTEVwAIof0cTErEHxRmQ0Ex70
         yp4ZdLIGOxTqwQ3/IkIe/cuvVN30EqO9rC43pZ8vF3Nr/HBAPZjEEDf5DlV2fCtkM6KH
         YA/1XUdPvxxDe8Lu6ng5g9bQ/qQrxXuoGFqv97jGqJhbAGSnlEWkMXP/HbT1p15gbBzl
         Ke+0QbRpdc7WxttEaVG0gbeqIlGLKsqFdFM9Hc76PgIWA9iXhUbPh6PYqIv6HuWJt6IO
         VAxwBoNG53ukKM/BnrxmdqCLd/02cICXjCB/fccffBMQ3gK4ETmxNqDARx/u6J+vYZR0
         QWIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709906328; x=1710511128;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NJZOeTUKvaZ9tzibdK6mZ+2xfJqhd2aZvSUwYP3TffE=;
        b=jGJV8hYDrJsxpBaPkBenT9GXnB0jrlPl2f4ZjifXG8oQhmqAQ/btgL63hlxRcgxjbM
         lIbr4UMONTTYROqULtjFDhyfklxpqheF+JK+MTNfOzr/2HvkgbnotJDzXbWlt2In0Asj
         gNlUoG9glD6gwBzgysGd1NGJgfgVuZkVLhA7r2cHjm8J9VmNijvD64Ipklv6XQGuTaHy
         jwmfykEKRcRlBwhFpBIkrX5r1gmayEbRbPb6krPDjDu2X+vyUY4ijd/HR7O85Xo2zTKK
         GyPLYI87dY24HuCvAt6MbP7z7EIKDwBWq9v0nRkR6Mv6bhPbpb65i/jK8o07Rxlr1qQa
         +EZw==
X-Gm-Message-State: AOJu0Yz0yd9roQEyiFWmW+1l8xUZQZLL3bpo+RKSZVMw/hJNu0R7at8e
	erqKeod3UWUENx34KPCdsOMpWrt0Jrsvxw8LN3uxu1BtVwuFzDbjf3yn/l+zz1o=
X-Google-Smtp-Source: AGHT+IE7WUfgQyBrzBqByBnm6+rLWWemHeajvmampNCKsn5B54w6l9RLPMdIygz/5sFdMLb4UkDaAQ==
X-Received: by 2002:a17:906:458:b0:a45:a731:d021 with SMTP id e24-20020a170906045800b00a45a731d021mr6464183eja.33.1709906327803;
        Fri, 08 Mar 2024 05:58:47 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:d306])
        by smtp.gmail.com with ESMTPSA id p16-20020a170906229000b00a442979e5e5sm9303189eja.220.2024.03.08.05.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Mar 2024 05:58:47 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 1/3] io_uring: fix mshot io-wq checks
Date: Fri,  8 Mar 2024 13:55:56 +0000
Message-ID: <d8c5b36a39258036f93301cd60d3cd295e40653d.1709905727.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1709905727.git.asml.silence@gmail.com>
References: <cover.1709905727.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When checking for concurrent CQE posting, we're not only interested in
requests running from the poll handler but also strayed requests ended
up in normal io-wq execution. We're disallowing multishots in general
from io-wq, not only when they came in a certain way.

Cc: stable@vger.kernel.org
Fixes: 17add5cea2bba ("io_uring: force multishot CQEs into task context")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 52f0d3b735fd..d4ab4bdaf845 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -87,7 +87,7 @@ static inline bool io_check_multishot(struct io_kiocb *req,
 	 * generic paths but multipoll may decide to post extra cqes.
 	 */
 	return !(issue_flags & IO_URING_F_IOWQ) ||
-		!(issue_flags & IO_URING_F_MULTISHOT) ||
+		!(req->flags & REQ_F_APOLL_MULTISHOT) ||
 		!req->ctx->task_complete;
 }
 
-- 
2.43.0


