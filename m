Return-Path: <io-uring+bounces-11302-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 73ED4CDCDFF
	for <lists+io-uring@lfdr.de>; Wed, 24 Dec 2025 17:44:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 85DA9301A594
	for <lists+io-uring@lfdr.de>; Wed, 24 Dec 2025 16:44:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3984532720E;
	Wed, 24 Dec 2025 16:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HIwO9sNp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DDF918B0A
	for <io-uring@vger.kernel.org>; Wed, 24 Dec 2025 16:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766594607; cv=none; b=dF0/tuWF+r79MP1l/gY1tp0+bPNatNH6Pi6IF5N5FprOCRTzPT9ontAekIb8PmlKhqyspiWfJtQNwRxXrnK5/nWXJ7LpAnBDgFLbIhljwD+q4WI5YbIH/kxORNQcIGIPa33mx6wkfJnb+aeNqkr39mEjEn2QMSgU30nHoT6DrjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766594607; c=relaxed/simple;
	bh=AiiMcR0T/Q577F9tdt0FEwOLmgTPTKSndvU3PGKdp/o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ADfWdefEcMzsALnNN5jHpn8KdwVuUCg8x5AQk/zZJQoXgtBhqOlqhHrcVQ71PRceGdvLV+Si9YJ5x4qfStpCzLLBLfe/Q3xyTNyNAq6WdF5EqmkHdok1/xN5JNIoV4X/J/J4q5CjJsbLkRdk1CaDUVCDAKcd3uomqDYJ5JrXh0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HIwO9sNp; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7f216280242so2179714b3a.1
        for <io-uring@vger.kernel.org>; Wed, 24 Dec 2025 08:43:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766594605; x=1767199405; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ssG8N04RBTKk33KNiGJ23C3mBaOiOd3tZk3DIrx1DLk=;
        b=HIwO9sNp7ygPXHdecLYt65BdPrIwZ81jqG4QXbrXwjDaosmeqf35Bwt8GOQFCJANyI
         1LlmSuzAVZ/PmhYhGxU3uqG5KWCkmZTFU/fzfeLeve/DSU6GFMfN9XV95ZG9C2oqn8uv
         mdkb7Dfv0/7+9st5Hyy3BxICyqIOiZiEnfB6R4NUoYgt4Uzd9M+OZHxgWgpZhLNZZ7mR
         unpy2bOU9OmcRKepWnPIwgOYE4jP0nnado616WTk3gyVfldiVhpH+LNZ27Ug6i2xKqlw
         BhN8z3dffGJ2S8c7VOrDqEnPPiGNo9B4dKnAooSofCpu/TFqsXci5/3283CO7YBuqBTU
         +nUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766594605; x=1767199405;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ssG8N04RBTKk33KNiGJ23C3mBaOiOd3tZk3DIrx1DLk=;
        b=oEkYbvJCbFO0oW7f+hhAdYUkWeswnTE/bS79SVPa3tO0SmqzZlG3/MkX8oViuSJZJm
         CZ7GC0tN2Ex6WMEAj0wYwHogYnoj70wfnf2SsNtamwvQRXVKbsxWSzEpsCp653LGdFJY
         0sZ+mvcy4CzswZhl8KLRO6Ni8XpIImp5BDxEIFuAscwTfFcC2gUslltQnQESxQgDW556
         SQW1Vd4sgBC8qkXC0yWEzs9DIKI73pFpL7rn0hj+wfqs8bT/LtgcHOTLoOvR1AfVn1un
         L6StscOxMD7qdb8gZhZ3unix2ZrBi86Zgeuvchwmo0K4ugsPudEjUSjJFFTjyQLfeYQc
         DiLA==
X-Gm-Message-State: AOJu0Ywi9iQcHHqJw62NS4bkqHASFM767S1Y0rllBqAmrFvZ4/fUqUKB
	84MHGe0iObFN3TutYRGAVHBZCrMxHDcHRS4CulWzhhG3zA3RVxP1KnT76xntElQb
X-Gm-Gg: AY/fxX7XcI3rofde72MqQYXp3rVDGA51k3yHfH9EuXUCb1+jAhVSHnqRE3WZMMAGv2L
	Ek8mGRyxkrj0HroTPi+LRIrcQ6euVfU/SalgDS1y9Vza+pma5OYIDfOKWR/ANy+WYlKH8Au8iVj
	i+r/CliJIRKlpI5OeULtJLD+74S5ea7L2RAM+/a34zpIuVI0KyY89gnrJy8gwX97EGHa+iIm9hi
	obnx/txnToxqKFukygs5YfeDDkDfcYlsDMBCQ/ZVYhas+AvHWdeD5whk5n/tON0X7prreWCkYYd
	iLrbiycjJ8R8p3b8OGbQPtCDp8nAY95W0K6MJEVwTC54D0AeN9O2GfCYBpgmlypRdvPumO7rOOS
	rVFeUkIFxRcxSNN38hkvD/3FdNrZZuOMiuog1VDvugBtEbtFQ5YmetRv/m3Hh1Az8G1mKeFSK6Z
	cAdFB+djg/Rv1UtXaTyRuWCOGI0Zp6qKUk9di2fPE=
X-Google-Smtp-Source: AGHT+IESuNtdg7r6U8V3avyj/W74Bs7jNYRoapVQX/S1yMhl+s9xpYrFbDcjHGddBIRzo8KRQZaBBQ==
X-Received: by 2002:a05:6a21:328c:b0:342:fa5:8b20 with SMTP id adf61e73a8af0-3769f9332a1mr18035364637.30.1766594604796;
        Wed, 24 Dec 2025 08:43:24 -0800 (PST)
Received: from localhost.localdomain ([111.125.235.126])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3c82a10sm159726745ad.26.2025.12.24.08.43.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Dec 2025 08:43:24 -0800 (PST)
From: Prithvi Tambewagh <activprithvi@gmail.com>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	brauner@kernel.org,
	jack@suse.cz,
	viro@zeniv.linux.org.uk,
	linux-fsdevel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	khalid@kernel.org,
	Prithvi Tambewagh <activprithvi@gmail.com>,
	syzbot+00e61c43eb5e4740438f@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: [PATCH] io_uring: fix filename leak in __io_openat_prep()
Date: Wed, 24 Dec 2025 22:12:47 +0530
Message-Id: <20251224164247.103336-1-activprithvi@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__io_openat_prep() allocates a struct filename using getname(), but
it isn't freed in case the present file is installed in the fixed file
table and simultaneously, it has the flag O_CLOEXEC set in the
open->how.flags field.

This is an erroneous condition, since for a file installed in the fixed
file table, it won't be installed in the normal file table, due to which
the file cannot support close on exec. Earlier, the code just returned
-EINVAL error code for this condition, however, the memory allocated for
that struct filename wasn't freed, resulting in a memory leak.

Hence, the case of file being installed in the fixed file table as well
as having O_CLOEXEC flag in open->how.flags set, is adressed by using
putname() to release the memory allocated to the struct filename, then
setting the field open->filename to NULL, and after that, returning
-EINVAL.

Reported-by: syzbot+00e61c43eb5e4740438f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=00e61c43eb5e4740438f
Tested-by: syzbot+00e61c43eb5e4740438f@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
---
 io_uring/openclose.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/io_uring/openclose.c b/io_uring/openclose.c
index bfeb91b31bba..fc190a3d8112 100644
--- a/io_uring/openclose.c
+++ b/io_uring/openclose.c
@@ -75,8 +75,11 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	}
 
 	open->file_slot = READ_ONCE(sqe->file_index);
-	if (open->file_slot && (open->how.flags & O_CLOEXEC))
+	if (open->file_slot && (open->how.flags & O_CLOEXEC)) {
+		putname(open->filename);
+		open->filename = NULL;
 		return -EINVAL;
+	}
 
 	open->nofile = rlimit(RLIMIT_NOFILE);
 	req->flags |= REQ_F_NEED_CLEANUP;

base-commit: b927546677c876e26eba308550207c2ddf812a43
-- 
2.34.1


