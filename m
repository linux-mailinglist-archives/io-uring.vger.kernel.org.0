Return-Path: <io-uring+bounces-3639-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F0CB99BBCB
	for <lists+io-uring@lfdr.de>; Sun, 13 Oct 2024 22:45:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 42040B20D07
	for <lists+io-uring@lfdr.de>; Sun, 13 Oct 2024 20:45:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90FC9153820;
	Sun, 13 Oct 2024 20:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a5UHjtKW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F0C82C7E
	for <io-uring@vger.kernel.org>; Sun, 13 Oct 2024 20:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728852327; cv=none; b=ed4Sl8Zgj9XEvSYyVUeeAVIZjBGlcvUQVwBEkwR6XvXaxzMlC/MNLqG+JgPWuJzxNsptgI04NENTsaebsacAmRUf9UJGzMJmdcthNJ6CqwWkNd/o7rIbMaaqNHIgdr8oo1CSSSDi+phnVG4vznvUHaLZQQCN+8fAegy55iuzKlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728852327; c=relaxed/simple;
	bh=idTE/ZoyUAY2FfIC7N922Le2YuZkQAgfND7CHavmnlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HN+ZXM17NPZLJhY0Cpp95aKGZ1Y27GnCPeHEH6G7doJIjKWYUEdnovg9Ia3/fU5I7L9Cu+/IA7Jf44m0HLtbaBDMBsB2D6/zLo141Kz/DGCr4iqh/I3vRjiS+qm2cMlSgqeIyMFQkDzWVTm5Rksw8DZKLzW13/gxL1/KFG75epA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a5UHjtKW; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a99f1fd20c4so197116566b.0
        for <io-uring@vger.kernel.org>; Sun, 13 Oct 2024 13:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728852324; x=1729457124; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/hcqGpvYvx9e+u8f8c8/gljD8DVc1Gr458BRRpYb63I=;
        b=a5UHjtKWfNrc4vvb5MYxlB2rB/AdT9k/kyXTnPOE/nD5a7hiWd+pTx0I83ThVePt8b
         ArKKlL9QpnM1O3cVWx5EXubCd+Enf+mF7ypIBo9fjBr933J30eFHo+lnligJ1bqC7fhL
         XCWGsFz+xpaL8S66sX72DE+0gCZ9U1d8Ifw990HuQFQSUM3FIu+o5vQlmuNKLlQMneIy
         yns1gMy8T28u4AtsZMupAc+7lsGZ0XmEj1tPodx71EcmkKb6NKi7NEkpyRGGsGRr1Hvx
         I7CcclMGVrJzPJ+7QEy9kX+Ijf3xTbRwevlnOjCRyz6sJKsW+SAXWOpISNRH2E9JjV/5
         /9QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728852324; x=1729457124;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/hcqGpvYvx9e+u8f8c8/gljD8DVc1Gr458BRRpYb63I=;
        b=mdN0iO8AXEfK2Dk1Us/IDbRFuVyBfYxyzSdxZGwefEFu5b7rlxrofDmfoe96jiseM6
         +lbKlZ7zY357EvvPKH7cE/JPSOgXJtrxIdNYwsFyz5kCEcTyG+DkizV5gxmc4HPFTuMw
         YjAmakAnngef8bFgW7TJDNOctV5rBZSzOv4CPW5er9ORJQ5FVjNQ6zgGvieOeqmC3faN
         AZvtXKPSYlxlOWiGLmLjY06+J9OZOR3A0oEFgAkpFhV1bFHTCm0cKYWdQnLnM18rY0xQ
         LubAsYytzTbaQ6DLWoqqJQG+TGgnzh5f+4DU0ryC9vz9xF+hV0FzV9KhdbfjkwGACGcm
         CJEQ==
X-Gm-Message-State: AOJu0YwKKqMqgUFWDGWaR4Wlm/zXInum/Dw0dqGYDYVXbIsD8/o9e2yI
	GihqMcttXwr/UaK2RdOKrqeO9ugDlhMHwC/P2O1X0ZX3JovajLPxN9B/7g==
X-Google-Smtp-Source: AGHT+IFy5WtDRpYZtQoU9sBeH//45mi9JUBHNKJAz1ObFJRFVvZZVpCIkHGY+IGDqsE0MR4J4TvZLQ==
X-Received: by 2002:a17:907:3e1c:b0:a99:f3fb:f88e with SMTP id a640c23a62f3a-a99f3fbf984mr410631766b.41.1728852323523;
        Sun, 13 Oct 2024 13:45:23 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.233.136])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a99f86b689dsm186078166b.181.2024.10.13.13.45.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2024 13:45:22 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH liburing 3/3] man/io_uring_prep_cmd_discard.3: add discard man pages
Date: Sun, 13 Oct 2024 21:45:46 +0100
Message-ID: <c3ee216f61f1e3d1df22a2b5531060c757f3935c.1728851862.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1728851862.git.asml.silence@gmail.com>
References: <cover.1728851862.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 man/io_uring_prep_cmd_discard.3 | 60 +++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)
 create mode 100644 man/io_uring_prep_cmd_discard.3

diff --git a/man/io_uring_prep_cmd_discard.3 b/man/io_uring_prep_cmd_discard.3
new file mode 100644
index 0000000..75e25bb
--- /dev/null
+++ b/man/io_uring_prep_cmd_discard.3
@@ -0,0 +1,60 @@
+.\" Copyright (C) 2024 Pavel Begunkov <asml.silence@gmail.com>
+.\"
+.\" SPDX-License-Identifier: LGPL-2.0-or-later
+.\"
+.TH io_uring_prep_cmd_discard 3 "Oct 13, 2024" "liburing-2.8" "liburing Manual"
+.SH NAME
+io_uring_prep_cmd_discard \- prepare a discard command
+.SH SYNOPSIS
+.nf
+.B #include <liburing.h>
+.PP
+.BI "void io_uring_prep_cmd_discard(struct io_uring_sqe *" sqe ","
+.BI "                          int " fd ","
+.BI "                          uint64_t " offset ","
+.BI "                          uint64_t " nbytes ");"
+.fi
+.SH DESCRIPTION
+The
+.BR io_uring_prep_cmd_discard (3)
+function prepares a discard command request. The submission queue entry
+.I sqe
+is setup to use the file descriptor
+.IR fd
+to start discarding
+.I nbytes
+at the specified
+.IR offset .
+
+The command is an asynchronous equivalent of
+.B BLOCK_URING_CMD_DISCARD
+ioctl with a few differences. It allows multiple parallel discards, and it does
+not exclude concurrent writes and reads. As a result, it may lead to races for
+the data on the disk, and it's the user's responsibility to account for that.
+Furthermore, we only do best effort to invalidate page caches, the user has
+to make sure there are no other inflight requests are modifying or reading
+the range(s), otherwise it might result in stale page cache and data
+inconsistencies.
+
+Available since 6.12.
+
+.SH RETURN VALUE
+None
+.SH ERRORS
+The CQE
+.I res
+field will contain the result of the operation. See the related man page for
+details on possible values. Note that where synchronous system calls will return
+.B -1
+on failure and set
+.I errno
+to the actual error value, io_uring never uses
+.IR errno .
+Instead it returns the negated
+.I errno
+directly in the CQE
+.I res
+field.
+.SH SEE ALSO
+.BR io_uring_get_sqe (3),
+.BR io_uring_submit (3),
-- 
2.46.0


