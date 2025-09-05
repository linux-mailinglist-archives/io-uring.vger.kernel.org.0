Return-Path: <io-uring+bounces-9579-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B8E19B44B3A
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 03:25:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 773D3587FB2
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 01:25:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BEC21EA7CE;
	Fri,  5 Sep 2025 01:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="KX0G1Bds"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f225.google.com (mail-il1-f225.google.com [209.85.166.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909EC17D346
	for <io-uring@vger.kernel.org>; Fri,  5 Sep 2025 01:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757035542; cv=none; b=a7huY+fmetxbwu5VCjA2vDrfzq7l+PKEYwWcX1eUXyQYG6CUU1ZwxozTirzf7xkW/Q9Q1KzvbElN8kmtqOMEEy7uNzVo46F6Ny1vJ4e0VyYrJK+TqKdc2yNzd7wwmvelOy7PJy05CnI97j9FoELtAtfyUUrivYkInt391jrzWHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757035542; c=relaxed/simple;
	bh=x4M8vzAa9G8ugV41duNrOqQggOoYYSbHqlw8bIGHuNE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hq9WyM5DX6L1/csSOV3elrXzx80H7lm4f5xo3eDi3Sk+jOmN9urUrHcFhtVnJ3ANet7jDsdWWv9V9qN603mohzByEioQPzuDat6iYL5jlbtO3W+hOR9RVFepCYUboCeuu3qwsjes7NVs02zKdlYMXr94SFMCMN+Zcc49ZhBmrGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=KX0G1Bds; arc=none smtp.client-ip=209.85.166.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-il1-f225.google.com with SMTP id e9e14a558f8ab-3f4926aa183so1452585ab.2
        for <io-uring@vger.kernel.org>; Thu, 04 Sep 2025 18:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1757035540; x=1757640340; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gnWnwy0cMPqtw5BEHHtxoCEyhV636CoDiZ02zMa7Bpc=;
        b=KX0G1BdsNc6ziyIIZCKL5mOk9yAZHbiRFAM3rUbmRlAHkBo2ykmGSakl+JBpOeTSAO
         KHWNkTK+WJD7uDu7jfITrHQGaxfDqobMv+TBVdNwXyHTNzx3MZsgcb1P8F0iZ5KGLU/i
         tpCIBT7ALN/V+IeQ6DO3UE/4AkLiXK+AmD+Bpkh1fEf5IOA9E0HvSRRpuWe5T4fItbDF
         sbCBMNDnsrru/RFbJoUznzDhPupbKityO2PR+YqSfWINqC2+BGArFnKyJoCi1Ye3odx9
         kMZ/SEur9VABAm5QGehwvcmpGgEeBh9jPCjJXHhvJK7DYg6YDEb+9aTKRmqzSIoWAZx+
         jmAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757035540; x=1757640340;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gnWnwy0cMPqtw5BEHHtxoCEyhV636CoDiZ02zMa7Bpc=;
        b=UqerU30B0CxbGIdOtXh6VEwVSJg0UsQATBDCo16h71QasoHvN5HQ8VWDxNtDSBIc6N
         nV8zLjeDd7XdaexSyKvQ/UrIJ7TScemsRFv3R31POPtL8zvsXeHYmVLXepIAHERX+iTz
         CV2IQQkZX6+vS3eMwaPB/dl9GJK3CGGdmnLKQaIWpbUY2+8PE1b3dp0vhB/952WjHehX
         ccFAOqQABNaoWTz6NxL3xBSfb0CW8it+GVxLlrMI4VwS32ulitacbJUQtX+8bOOnAAQ3
         fxney/+Lt2PzDv3fE6J6Rtgn3Qxa23ctyeWyANEOmZHGPf5sPbZD/FyH75RheRPNapU8
         GiFQ==
X-Forwarded-Encrypted: i=1; AJvYcCXdt8Gfrzg2ghlu5Nhms9lxTOXUrOjbWDc5OxpFbMcNrzRyiS9GWGM/E3IeTEeixHTr1se9mRIcJA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyZ69KlIja52UgNo3PKvR7H7YpYrQvOFbEwmmwcfSn883eWGnqg
	wOJrVBt/o3x1farjtaq+swRQQY17hoxaTvQCOr53DlY4nRK3FhdkHR+JcISPu5inw2cIgV9GrGZ
	8YNKK2OWc+bKyIUezM9bCZvDngbAD4DJG66Fm
X-Gm-Gg: ASbGncsPz+mXxmcRULNSfVhW5SSOWTJXRsyT/WkCsFnS8ur2H2tPUC7Z0GNeeWPTAnZ
	/DvqP/Ta0Ivqzt6pucqiRrvLZ5jZXRlqSeyuDn+yhYi5nteaiXGUKwn25EBSmjxUSN6DBLmdBmb
	5cb7ZicjRrjRDvTaIjPdtg81SNThdRQRAaWbO3BF0gtVtx6F5CJs2u/8KOe4AOTgx6fMB7W+xRQ
	OQSinSBv7hS/9OlNZAk7Mn1Lk5C8mMwoObUND/yL8IiIwxVCi3mswSSdIbLuUgWEnBmezfZr6nE
	qVXSGUOLkUHK62VAECY0l3kp5iR/evRvmPlBfau1JTkyMEd6DvtCUpudE7fyT/Hlz0Xco6tX
X-Google-Smtp-Source: AGHT+IE1TscQtnz7ja8VNIEOcYQE2LBDQ1YalQFkXxSCa5lmyVLkiFojFsDoRfuToE7u7AukvENY4JbX6eqT
X-Received: by 2002:a05:6e02:1fc5:b0:3ef:beb7:dba4 with SMTP id e9e14a558f8ab-3f321afda65mr148455715ab.2.1757035539735;
        Thu, 04 Sep 2025 18:25:39 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.128])
        by smtp-relay.gmail.com with ESMTPS id 8926c6da1cb9f-50d8f2deb9dsm902184173.41.2025.09.04.18.25.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 18:25:39 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 186B2340237;
	Thu,  4 Sep 2025 19:25:39 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 13106E41A5E; Thu,  4 Sep 2025 19:25:39 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring/rsrc: initialize io_rsrc_data nodes array
Date: Thu,  4 Sep 2025 19:25:34 -0600
Message-ID: <20250905012535.2806919-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_rsrc_data_alloc() allocates an array of io_rsrc_node pointers and
assigns it to io_rsrc_data's nodes field along with the size in the nr
field. However, it doesn't initialize the io_rsrc_node pointers in the
array. If an error in io_sqe_buffers_register(), io_alloc_file_tables(),
io_sqe_files_register(), or io_clone_buffers() causes them to exit
before all the io_rsrc_node pointers in the array have been assigned,
io_rsrc_data_free() will read the uninitialized elements, triggering
undefined behavior.
Additionally, if dst_off exceeds the current size of the destination
buffer table in io_clone_buffers(), the io_rsrc_node pointers in between
won't be initialized. Any access to those registered buffer indices will
result in undefined behavior.
Allocate the array with kvcalloc() instead of kvmalloc_array() to ensure
the io_rsrc_node pointers are initialized to NULL (indicating no
registered buffer/file node).

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Fixes: 7029acd8a950 ("io_uring/rsrc: get rid of per-ring io_rsrc_node list")
---
 io_uring/rsrc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index f75f5e43fa4a..3f3f355f6613 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -209,12 +209,12 @@ __cold void io_rsrc_data_free(struct io_ring_ctx *ctx,
 	data->nr = 0;
 }
 
 __cold int io_rsrc_data_alloc(struct io_rsrc_data *data, unsigned nr)
 {
-	data->nodes = kvmalloc_array(nr, sizeof(struct io_rsrc_node *),
-					GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	data->nodes = kvcalloc(nr, sizeof(struct io_rsrc_node *),
+			       GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	if (data->nodes) {
 		data->nr = nr;
 		return 0;
 	}
 	return -ENOMEM;
-- 
2.45.2


