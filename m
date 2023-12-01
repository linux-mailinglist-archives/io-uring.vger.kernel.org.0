Return-Path: <io-uring+bounces-187-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C7DEE800065
	for <lists+io-uring@lfdr.de>; Fri,  1 Dec 2023 01:40:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04DB71C20C8A
	for <lists+io-uring@lfdr.de>; Fri,  1 Dec 2023 00:40:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 836A5387;
	Fri,  1 Dec 2023 00:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PXQTIU7V"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 380FF10DE
	for <io-uring@vger.kernel.org>; Thu, 30 Nov 2023 16:40:48 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-54af2498e85so1791022a12.0
        for <io-uring@vger.kernel.org>; Thu, 30 Nov 2023 16:40:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701391246; x=1701996046; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dW9I7peJ0tx5nHOnkR/PXN6Di7zysrrpxK+B2DaVuEs=;
        b=PXQTIU7V6f5fNhaK/lBlYt+Wcx4U4EYr+SZypCmyYq0v2VV46QplC2AzRjoF1rZMVb
         xTEjbOMrteHIc+oUUFBheDb6rFyta2TiyHEiiBL2qmcXox6Cqbn4/n192qizi1OKrU1A
         u5q84rSUOge2zA9Kr085asYr8rb2nicPs9U220JtIVHcfjeyTmIuJ+7UrHqkcDbuxHT/
         800XD39db8qclYFfONJ3zupED9vfZJOGoSEtE8wuEP0/4p1RB1IV8rAxOa6fh4zb5qC0
         YMkKCiJsMb/P5oiJ6FTqBdt3saH8OUWpKGqDUOV4EqKo2cW7kKxg5V2/+5qG34FukdYL
         rDOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701391246; x=1701996046;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dW9I7peJ0tx5nHOnkR/PXN6Di7zysrrpxK+B2DaVuEs=;
        b=va2v0Vfazs1O06X9eRI5h57yStlmwcJQEfit/7m/HqlUWlmGc3fH0JgepumkTucjNS
         QgerxZhOAgAYSr28pcUXTghnYkf1ssKePWMJRJW3xnDxf8QTzaeMK7W3Ttvof8x/UqSS
         zGostqzPnO+9Y9ueaUlZP+t3MrgbpWdIbExqkBA6tNtSVBd4dezKe2U+xNrfMCKgQpqU
         ptfCpAvzIbYl4N8b/9rEUl46kIfpUmU4wvTFpWlhpRdU6sqMgD1AXBPS8SbUIumcupVO
         Z92TCm9X5fXbsqbWqqUMXBLuLIp2IBr4hKjcG0qSvkd5OHveEf1hW4JSrFxF/OAXj74T
         N0TA==
X-Gm-Message-State: AOJu0YxoqZjh2YVWqE5pLC6gTce++8NPdUIZCy5FWcQiy9xBM6nvTdNM
	REu7gPPmW8NHyYHYPUc/Jadz1nQFEvk=
X-Google-Smtp-Source: AGHT+IFD+rl/O8AkHQ6IX6dhyUXiE6+D/RpiQKVwmFPots61QBvnC8UFF4lHG5BsZZsaBrGz/YFxjw==
X-Received: by 2002:a50:a404:0:b0:542:d2c4:b423 with SMTP id u4-20020a50a404000000b00542d2c4b423mr286843edb.30.1701391246341;
        Thu, 30 Nov 2023 16:40:46 -0800 (PST)
Received: from 127.0.0.1localhost ([185.69.145.191])
        by smtp.gmail.com with ESMTPSA id ca25-20020aa7cd79000000b005489e55d95esm1059139edb.22.2023.11.30.16.40.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 16:40:45 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH for-next 1/2] io_uring: don't check iopoll if request completes
Date: Fri,  1 Dec 2023 00:38:52 +0000
Message-ID: <2f8690e2fa5213a2ff292fac29a7143c036cdd60.1701390926.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1701390926.git.asml.silence@gmail.com>
References: <cover.1701390926.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IOPOLL request should never return IOU_OK, so the following iopoll
queueing check in io_issue_sqe() after getting IOU_OK doesn't make any
sense as would never turn true. Let's optimise on that and return a bit
earlier. It's also much more resilient to potential bugs from
mischieving iopoll implementations.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6ffd7216393b..21e646ef9654 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1896,7 +1896,11 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 			io_req_complete_defer(req);
 		else
 			io_req_complete_post(req, issue_flags);
-	} else if (ret != IOU_ISSUE_SKIP_COMPLETE)
+
+		return 0;
+	}
+
+	if (ret != IOU_ISSUE_SKIP_COMPLETE)
 		return ret;
 
 	/* If the op doesn't have a file, we're not polling for it */
-- 
2.43.0


