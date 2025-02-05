Return-Path: <io-uring+bounces-6283-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BDBDDA29B2A
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2025 21:27:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A913A3A4726
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2025 20:26:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDE881519AD;
	Wed,  5 Feb 2025 20:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ppDfKdVg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D0C211A0B
	for <io-uring@vger.kernel.org>; Wed,  5 Feb 2025 20:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738787214; cv=none; b=KydloR1THBUBBUuhGVb4yS9u7m4WjZ5M+iO2xr8UfgcyegT5VI0rEGsoPnPQ2logwDnixeE/+AsiTZ2CzrMnKyJLV2+0hgiUhrmPO9kxUmgOFfdr4CGL2sOp86QYn+AwWyPK9W8Ons9EMYru7DlcbZ47GBaXEonrKkFkUzvdIrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738787214; c=relaxed/simple;
	bh=42bNpDZeuVDAuMUQFLIssqZ9JSXExnqO5Lq8mGUQLug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2sdnhS2eniUoBEcvnx+AeSmlbDTDIJJ26EyklwAhs7Rw3+SQpORQiPLkfkVt5b5SP0VdzwOYLLolxm+tWEFB64Mmfn/Wd49lQMWN0tTKsMfrEPh5vyMr14PGZPjyCrQShThnp8aQlmYZALt6lGpKQl/XXExH/zkmNRLcl+g+rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ppDfKdVg; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-84ceaf2667aso13671739f.3
        for <io-uring@vger.kernel.org>; Wed, 05 Feb 2025 12:26:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738787212; x=1739392012; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vba7+r7gu6BsgHeCtt02tOKMD0rn8QytXeaRi/JBOmk=;
        b=ppDfKdVgSQfcfcns3ci2o8I5yoDH34juiH2mf1XjQQTa8LyBD0j81copUsaC+PExEK
         MQ2f/fd+OmDJT7rBf0WqX2neATfAgWg7SgWMDxLjTzTovrSIj8suU9eQxo1mecPh2l3m
         +UaTv+j1JrMVjcGGOHzMgPsQXUWp2S+Una1kNXjJ9kVA7zgDGTS5zv6Yvi7r5sDRrWHh
         fMnj6QkZX5dXwIJamFsq2fsYMpgPm/jtiVdSHRkM5yOIfQRaczHCOuB3D0ctV6I4AEUJ
         oKGCDdLwWQBn8ashP+hEBve1xiqKVNdB+TsCoRmceUgUnqQW55NboX+dbcfC/og6t3ww
         N3Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738787212; x=1739392012;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vba7+r7gu6BsgHeCtt02tOKMD0rn8QytXeaRi/JBOmk=;
        b=q3DNanp7VbmKW5jmxdTgAOMISyhU8YfEtkbV/EN5ORQ90CZlZKBz1y9gXU+IIsmjzn
         mLdvuDM/Ewl4h7AmuDXZUpFwDs7jMrwMxPhDMPikUAVOxrmNjuDuF6bnCk4L0HdXHsuC
         TnfWOfMzfy1xufnBAMOX2uLjgELfwtoQXbcfBlfqkZLSyiFC5Ox/88Zb6uXEA2hNclkO
         /0RTf/n9jgMfOPMZrTaS/+nvfcxpuOxLRe+x3WJb1bLELrg2xBw15+Fg1tCT84h152GE
         iv9k4pUylhlGvQ2k53bpgBJ3thF8wRsMf40IcBr8k7N9GXWMpLgAiF21/ZbGnwIhBckr
         ChSQ==
X-Gm-Message-State: AOJu0Yzz8+FTQAMtR003f+gXjUUlvbCVD5WCt+62ryr5MCI6TzEiMdrJ
	jeM/edIatkLYzFYxCrulnwEitlcKiuDqjNbUWdVbRh9rS0s46kG3gydl0eb8dMFkC/iMZNtnqt1
	B
X-Gm-Gg: ASbGnctmx7843ggISSaWunrDYC52rbLjBxgjOGpNc1PCOyxSjGbEGNt3viBglr38DC6
	tF7z3f8CFN3sof65pk7iUBOJ4y/VCsux08oPvxa/sESeXmqB5lyjNvFyQIvOF75CdhyYGDA4bDN
	AqwUp0Np0u+JFajfoZBk+uD/WCZSKm5Bbh2UqNorJxdUB9BtH7BflYV+z+D3cdG197HR3Mjq8Tr
	I3qAGRo42hWY6mt4JoZUgHmmtZxqg43N9wAK+a/6o9o5wmF/2yChZ6gi8fDpyUqIrjqRSccsPT5
	7CaB4OlbUhdMmxs0TRA=
X-Google-Smtp-Source: AGHT+IH1Sy8dutgN5WJ3P5+RSU2YarbbZz2xOryZ7hURKMJ5X90tbOtSkLenpAQeqjHA50Ru1Zl9rw==
X-Received: by 2002:a92:ca0a:0:b0:3cf:cd87:1bf9 with SMTP id e9e14a558f8ab-3d04f97d889mr38331725ab.22.1738787212072;
        Wed, 05 Feb 2025 12:26:52 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec7458ed51sm3352071173.23.2025.02.05.12.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 12:26:51 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/6] io_uring/waitid: use generic io_cancel_remove() helper
Date: Wed,  5 Feb 2025 13:26:13 -0700
Message-ID: <20250205202641.646812-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250205202641.646812-1-axboe@kernel.dk>
References: <20250205202641.646812-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Don't implement our own loop rolling and checking, just use the generic
helper to find and cancel requests.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/waitid.c | 24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

diff --git a/io_uring/waitid.c b/io_uring/waitid.c
index ed7c76426358..4fb465b48560 100644
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -159,29 +159,7 @@ static bool __io_waitid_cancel(struct io_kiocb *req)
 int io_waitid_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
 		     unsigned int issue_flags)
 {
-	struct hlist_node *tmp;
-	struct io_kiocb *req;
-	int nr = 0;
-
-	if (cd->flags & (IORING_ASYNC_CANCEL_FD|IORING_ASYNC_CANCEL_FD_FIXED))
-		return -ENOENT;
-
-	io_ring_submit_lock(ctx, issue_flags);
-	hlist_for_each_entry_safe(req, tmp, &ctx->waitid_list, hash_node) {
-		if (req->cqe.user_data != cd->data &&
-		    !(cd->flags & IORING_ASYNC_CANCEL_ANY))
-			continue;
-		if (__io_waitid_cancel(req))
-			nr++;
-		if (!(cd->flags & IORING_ASYNC_CANCEL_ALL))
-			break;
-	}
-	io_ring_submit_unlock(ctx, issue_flags);
-
-	if (nr)
-		return nr;
-
-	return -ENOENT;
+	return io_cancel_remove(ctx, cd, issue_flags, &ctx->waitid_list, __io_waitid_cancel);
 }
 
 bool io_waitid_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *tctx,
-- 
2.47.2


