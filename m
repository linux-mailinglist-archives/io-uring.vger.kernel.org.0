Return-Path: <io-uring+bounces-8662-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C589B03CBF
	for <lists+io-uring@lfdr.de>; Mon, 14 Jul 2025 12:58:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0002C3A4BDF
	for <lists+io-uring@lfdr.de>; Mon, 14 Jul 2025 10:57:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F36B2AE6A;
	Mon, 14 Jul 2025 10:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L4n4NOmN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D858F23BCE4
	for <io-uring@vger.kernel.org>; Mon, 14 Jul 2025 10:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752490661; cv=none; b=eIrLi/Wc2h/M8JgZKH6U3eiePfDeizjk4HqUc1w/CTsMD8GcixBfCpe+TH8YsgdVco1EuYrAPKAteJBWhhBSukmSkohKS+neQyOANaTj8YSMKrJrx0xPDaUcbt14nGMh5a9tKb4hi6mgv4JZEZXYx6tGocFcm3LIn1PZ8+Ul9u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752490661; c=relaxed/simple;
	bh=1xAptf5HltCOXP3Fi6Wd5J30ROK56k6xuu7gpEKNazI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a0Brh19SZh5WhBx1sAhfrJCMc27sFA6RF5I1C6DpXyZjbG6tkQfrqdzlDlWyyvdQYpBgXKEZ46NP+jCSksRJsZ1tDZdkrMQQ5Q9DZEJkC+bMFPt0hKViabgdkESStkuEyIwvKEoYHX4aJQH5pbJmD3KpnDhHoQ5xZReC6KnQp64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L4n4NOmN; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-60c51860bf5so6994182a12.1
        for <io-uring@vger.kernel.org>; Mon, 14 Jul 2025 03:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752490658; x=1753095458; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4ym9cocc+S6APxf/eruOG078Cv4Xc4ij0MBj4G6dugQ=;
        b=L4n4NOmN2fRIa3W6rKCo3o/mP/18QHb1nT/aUSBXMJh2pDNYvUh9fFmyjJDWKKZq41
         pI0LaYHX0XplCI6JFc+7yAFm4xgmHOI+nY76fbn7IDTZ7n9gDNFgSBjcSktmXjRdVms5
         vNwvkeSqpA6/EwQuHf7Mc/YBDhDMXwYq5gfCP5eW9jSOx3NqQ2YssH+PlnXAP7YZKwaO
         nkEZ6ZjVeXOIJjqFnnQFWK4O7eEc7ezS7lrDeASn5XxSh2Lbe8jJKiCeshA/l2PJw5L1
         j+rNEaMSCMJnOpNpPyLXcBaWe3oJxHo+f8K+oMEGscG/xMDJIJdEIacFlbf5FcI0gf+4
         Qw+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752490658; x=1753095458;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4ym9cocc+S6APxf/eruOG078Cv4Xc4ij0MBj4G6dugQ=;
        b=rYg93T3oQrkD1jVLZoPEd23N+n2QSoeYHI2Lo8FcQEIYzyoyMnfHjtg3SitZzResW+
         vp9+40OXh8DV9EUh9YGQefUt1eLC2EF993Er5ZrF8RK9PD9p0Y2W29rZ++bQkvh3WU3K
         Otx6KJ3eAupVIS7iEGshmAVShvkHkZ0qjU0EJ6zDJtjhrWj9yr4WLHNHF4YXyYZeWrmu
         iR/FDUm5GJCKeaNPkKCxNWuO7BXVB1WV5A74F0lSIt+nngOSH3blE6r6waBmi3Zv/y6s
         vcU4FcNsZJIUrwFY2tdr28qGQxJVr1YIsFsuCZtPwZCcyKLP8IVSYrBEIPSscXT3gB4l
         vkeA==
X-Gm-Message-State: AOJu0YxyJEbReP5gZDhzMVeBUDTXB6Sh5OG3W1BCbeui9PMcjZVqK4yl
	8wwWUBqAlIT8skeFRC/6UcnR60tSd5a/yHKjiMUrEMmhvONMUg5GjOcaIhaEUw==
X-Gm-Gg: ASbGnctBNGGW244hsv9JHUTNfI2JeYwUWqykupp2iPQ6Njaoiu8ORqr/Gu8gIfOzhfW
	ogec2pW/9FqjEiCic5s8f0JGuM8vdbZ7wePjlHHmP5ucuziD1c0JsVml3kGVSeCApVdUVOWc8Nk
	xNk0lpffLSgleInyFpeFj6r+qAX4B5hl2V9ebkWY1eNUI7gJWG7syjpvQSLinEPKda7W9BkGdQA
	m6XujXYiSZoZ6PL1MsDwpjUDmF58AsZh2nDq0aTH8XTpiIY7NvYKiEIQQZycByIiY4XVQhokePj
	i/UhB+TGC48HTMh2Q24ZEFMITFm7RHau12fHOMDmQkZtxig54gWy0cBGnmZxGaTSbRiyzLosODn
	TZJGZIO0TOFsgx9/y
X-Google-Smtp-Source: AGHT+IENVmKAIJVtZrSvzWCsokzEmTw8j3xhKJwLfN1/05esCxtxFnRrsuOPP0UDxW6xnPYZ+YyLGg==
X-Received: by 2002:a05:6402:1d1c:b0:609:aa85:8d6f with SMTP id 4fb4d7f45d1cf-611ecf9b234mr8116311a12.11.1752490657512;
        Mon, 14 Jul 2025 03:57:37 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:f749])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-611c9733d71sm6003508a12.43.2025.07.14.03.57.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jul 2025 03:57:36 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	dw@davidwei.uk
Subject: [PATCH 1/1] io_uring/poll: fix POLLERR handling
Date: Mon, 14 Jul 2025 11:59:05 +0100
Message-ID: <550b470aafd8d018e3e426d96ce10663da90ac45.1752443564.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

8c8492ca64e7 ("io_uring/net: don't retry connect operation on EPOLLERR")
is a little dirty hack that
1) wrongfully assumes that POLLERR equals to a failed request, which
breaks all POLLERR users, e.g. all error queue recv interfaces.
2) deviates the connection request behaviour from connect(2), and
3) racy and solved at a wrong level.

Nothing can be done with 2) now, and 3) is beyond the scope of the
patch. At least solve 1) by moving the hack out of generic poll handling
into io_connect().

Cc: stable@vger.kernel.org
Fixes: 8c8492ca64e79 ("io_uring/net: don't retry connect operation on EPOLLERR")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c  | 4 +++-
 io_uring/poll.c | 2 --
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 43a43522f406..e2213e4d9420 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1732,13 +1732,15 @@ int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 {
+	struct poll_table_struct pt = { ._key = EPOLLERR };
 	struct io_connect *connect = io_kiocb_to_cmd(req, struct io_connect);
 	struct io_async_msghdr *io = req->async_data;
 	unsigned file_flags;
 	int ret;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 
-	if (unlikely(req->flags & REQ_F_FAIL)) {
+	ret = vfs_poll(req->file, &pt) & req->apoll_events;
+	if (ret & EPOLLERR) {
 		ret = -ECONNRESET;
 		goto out;
 	}
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 0526062e2f81..20e9b46a4adf 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -273,8 +273,6 @@ static int io_poll_check_events(struct io_kiocb *req, io_tw_token_t tw)
 				return IOU_POLL_REISSUE;
 			}
 		}
-		if (unlikely(req->cqe.res & EPOLLERR))
-			req_set_fail(req);
 		if (req->apoll_events & EPOLLONESHOT)
 			return IOU_POLL_DONE;
 
-- 
2.49.0


