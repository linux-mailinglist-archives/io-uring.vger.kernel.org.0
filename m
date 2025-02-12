Return-Path: <io-uring+bounces-6349-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A917A31AD9
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 01:52:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A84B3A4E9D
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 00:51:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCFC527182B;
	Wed, 12 Feb 2025 00:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="YQuBBhdX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f226.google.com (mail-il1-f226.google.com [209.85.166.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B481CAA4
	for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 00:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739321517; cv=none; b=PwNUF+Hc+8f3h51ZlHPSh5FrKAogJweGI1rA4gUCDAg8ZYQ7EUsVlVTCDCwBTa/XfJQUEQiHiNd8WYaTUroMTYv/ESwOi2iXhNRNQhgiTfW7y4KPZqsINtxpBm0T9i/vjdhw23b10wZf66mt+wipwpri9oDiY3rI3LjO4D/LXg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739321517; c=relaxed/simple;
	bh=uybylxy3CxWXbqjZP/G8qtq9yh04SBEkS6ZcbdxAOJs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N/BKHeX5cMSCl130Vh/RdAaOqFzLSEsL5CNPbjvhL4ILoikg1azKSHnLtZD5JRQMBpt4TE8v8Z/kDiGoxg4OM80xyYiX/HVVcxJnfLAws/tD7WR3VmQZ8amSZq/67PaFwliPm7Ji8qpAoHZxlh6V29h27E2K0K1O4iMbYdra4OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=YQuBBhdX; arc=none smtp.client-ip=209.85.166.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-il1-f226.google.com with SMTP id e9e14a558f8ab-3cce58350afso1509385ab.1
        for <io-uring@vger.kernel.org>; Tue, 11 Feb 2025 16:51:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1739321514; x=1739926314; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wxjIUJ0LCGQtTFpUNlyNV0SkSCoelxvdgjl3lNP3O8Q=;
        b=YQuBBhdXtlhiMYbjNudL7nmHpca/Y0mTj4OVMAt8jhZ3lunmcaFqjmt5+N+ARepVb4
         /HbwefJrySa8AAehPF5SYyd8bvsey+j2f1+d6GmbEQ2FEW7TmmjlD53u2vJZ+UPOB/2s
         TixUWP++afQFjuKjiWUenY5QHxzXx8YN8R3rtmLmD+zuw3WhALLMrPnWj8wSajvnSG1m
         RXx2BaGw9x3Z0DkZ61EBMkiH5UlY1pmDezcky/onvd48YJM2hvidVkJ0wvShTLpDnMix
         fHHzMVo0EO+ZyyN5Mz/L4Z+1cqGJj7GVgdB3sMAePo8QjZAzRz6Zwcn8V8wk7xawEEaQ
         UpSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739321514; x=1739926314;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wxjIUJ0LCGQtTFpUNlyNV0SkSCoelxvdgjl3lNP3O8Q=;
        b=rJfz4VJVa2jM43E3EavWXVHdL4tnK+OUs5Wk9Qjj1tV8L+eKqF7ujvuDqCy5v/XXYe
         JlJEwmJhT6yHvo54pQ5iIABPj/zaZOr4HXikwc6sTW5IlDRDmzIsF/9x7iIAyAoTbOD5
         JaxXeoh7tywZ5zNE1VciXSpHSf1ZV+6hrHmWU4ONrZeGXOwBwwlUK3kKsUYtH7nrBGve
         OZ++Sto9X+0owyHQ6w7WQ67towi/JHFNDAt1nhR4TS78N9PxEq6HkyfO2yFQbVQF4iPh
         iO8nf73APTO3Uxs0yxQvnQOlBLyduPOOcFZfWXuRZJwXOW5TtzrDcIPmnx3nfyXtS57j
         Z09Q==
X-Forwarded-Encrypted: i=1; AJvYcCUbrgkVQP/6e85Vg1URlCAqhfUwZGcP98ebpSZ3WCMg6ShaTfmwWWz6qJ+WxjRw8bTr/R8/nF1D8g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3m2uQLrv340DgmrbSDcnNZeao3DQYF6fqiDPFyJZX3I4Yn982
	aIEt7RNx5wIW0o8GBbrmkfT0FRYJZd9HHPNRlBek8xwYaaZK+doZUhHwXFos3ZY2r9fZMmNrQhe
	mwa2Qp+VOhwAdZjWjNIDLOtWOUZPuVJ5CE6oNI6VmMhh9jh2U
X-Gm-Gg: ASbGncsk5njCFyzGTTqL4NsQ/7mCeNbnJvsEk+evGYehladdAe/LOrlVOYp21qA241Q
	5NCOCvNQ/dlUr2NvBw2lasyIeSvt0NcyBzCYWerZMspmFif7VQIZKDFJdkaMmoCtkoXtGu25Cdh
	Ya4NULywAGAwJrs9GjcAvmZzUmLlStjxp5++IqAXNfMZJKO+oSsh4ouSWJ3yc8sTfFfCvncbM93
	dAZXjstDMAAG0hVPU6fiIZe4/wUDTd75FZ1riEG6xdk7O4RfrlxrTsXWeyhkyYBqV7Wss1VQyEm
	8p0SakR/xNJYbjr7U/FzV6o=
X-Google-Smtp-Source: AGHT+IHYpDUM5IoG8Gefvs4nmEzKc+3MUcQyKzvpDeSdd4lhbhbGh2EnHmPFJjw+Kv8PFBLmrPRm+a/xUBfZ
X-Received: by 2002:a05:6e02:1d9a:b0:3d0:13f1:b47c with SMTP id e9e14a558f8ab-3d17c2155e0mr3318165ab.4.1739321514520;
        Tue, 11 Feb 2025 16:51:54 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id e9e14a558f8ab-3d16133e8f5sm3111825ab.69.2025.02.11.16.51.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2025 16:51:54 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 715553400C7;
	Tue, 11 Feb 2025 17:51:53 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 685E6E40C16; Tue, 11 Feb 2025 17:51:23 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring: use lockless_cq flag in io_req_complete_post()
Date: Tue, 11 Feb 2025 17:51:18 -0700
Message-ID: <20250212005119.3433005-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring_create() computes ctx->lockless_cq as:
ctx->task_complete || (ctx->flags & IORING_SETUP_IOPOLL)

So use it to simplify that expression in io_req_complete_post().

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ec98a0ec6f34..0bd94599df81 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -897,11 +897,11 @@ static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 
 	/*
 	 * Handle special CQ sync cases via task_work. DEFER_TASKRUN requires
 	 * the submitter task context, IOPOLL protects with uring_lock.
 	 */
-	if (ctx->task_complete || (ctx->flags & IORING_SETUP_IOPOLL)) {
+	if (ctx->lockless_cq) {
 		req->io_task_work.func = io_req_task_complete;
 		io_req_task_work_add(req);
 		return;
 	}
 
-- 
2.45.2


