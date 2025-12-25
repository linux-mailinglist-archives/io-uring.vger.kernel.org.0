Return-Path: <io-uring+bounces-11307-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E22C0CDD6D0
	for <lists+io-uring@lfdr.de>; Thu, 25 Dec 2025 08:29:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BDACD3018978
	for <lists+io-uring@lfdr.de>; Thu, 25 Dec 2025 07:28:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFFBC2F25F9;
	Thu, 25 Dec 2025 07:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BPbbcRHm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F2C2D8777
	for <io-uring@vger.kernel.org>; Thu, 25 Dec 2025 07:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766647721; cv=none; b=S20e3b05zyEgla6v7zqHzoBRgfBWAAtIqJcuRMFN9TFybINU04IGi+V7wNGOlF8W2gPu21OLbX/DkSlk7FhV3TFcib/EcVH3GMsexbLzzzpnjE+wXcTXm/vqKfNglKMRcVmmtlfY7YJM7ogFrkh0csgpeIo9M77gFqP06oQrnB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766647721; c=relaxed/simple;
	bh=nDbknJ7IUdumOxpo9hBQLkqYxDx2G2kdEPg/Zd1nCmo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=b+WERLqE4YWXuOeNwZCtLV3NAFYlX/DneLDrf97Oyd8M1Q97pnMThwNm3k9t6jLMDZOqeR1IBVj1afjEe7sSYoPtJVd20OjvT3jM/ZS2UOabUOiPjseEL8J+ZcaHmlOneioQwJTpOS6v+0Rwm2LRDohfL0pOODi7aYuNc54q+AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BPbbcRHm; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7b22ffa2a88so6101381b3a.1
        for <io-uring@vger.kernel.org>; Wed, 24 Dec 2025 23:28:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766647719; x=1767252519; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=p6BFcbd9iyFXSrOLN1khZAr09vJHb19aUamed8L/NRg=;
        b=BPbbcRHmr2XAdJPMbciFDgXmgU2jEEOqvaF0Uodl2q4pcJDvclntXFPZBMU4D3Xmj9
         6EiI/uap6ZpVRRZCcMoDJixOIp/Q74rr4fZAXLUm7ON3pfULkisWRbsdReDXWge4UeBG
         3L9v7CvBQFDnG5tCjk+MXQDu+N2CGaJ3kTe7I81zz7N0bGn1sozoFkMn1XvWv/f9IS++
         dlFmBlqBrJNh9bHjIGT9ah8fgeQqbRnq/HXFszpC/oWICopN6Ix4hJ6MXRygPu9P+Gz+
         r35zBYl+8grrB7AkgdvIhsmieZHHX1eUtTXIbhLg+a1vCn5z5oUlp9n5qjQZpp5cMjTy
         PzLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766647719; x=1767252519;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p6BFcbd9iyFXSrOLN1khZAr09vJHb19aUamed8L/NRg=;
        b=T7nYT9lz7owYD2xmAIe0u5kxUdbqgsRyGHlAIwjlvu6VDr59p9eEhDONCxZDJyiM8S
         /isnGf/kjUY39fQ8Xyt5uV4M7RNkiigsICLa0FQ2/3mV34LO1oFTMJtfMdbaGSTniAAp
         CZzWEE4/SgcRyfjeXzl2ZxNoHDcXRa2pFRuF3pBE3aKlIezBUVqvreuSqEUJ6Zf47Ukf
         nn3yG1F2MYu0P0lXaF3PTsr59/1LRXYPFIwUxJHreNwSWixdGsboL+saISXzw9Jm/8VX
         xupvwDGi5V0mqWnQhasOvk/Za57rFgmyXiuRaxB6l9beaCVckLfQHD3VG62hjDjngfKT
         iCvA==
X-Gm-Message-State: AOJu0YzX6UCWX0Ug0p/whyVOihZRnODzFP51ifDEUfKysHHj8YPmwwRJ
	N4q69WUX1/Ob/OODMB1jzlGwsMB+TAH5xignKQ77H27WycD2qNDdd6I6
X-Gm-Gg: AY/fxX7Eji2By35NoR+I5YWnzB0xYYk6NocuQJkKfhlyR+n1al8SzwRPuSAuCA+4kD0
	22tSCWQFzqdoDRzV9Mq0cmqG+nDYKjv+H0umeIETXPqYzNBlL8G3BtmfuvU/YKhhDtwZQGz/Xc4
	DO4E8Er2ZZCdt61nBK5KnS3ee76BABIIxUMrwz3OKiFyh3SSFXLwhZcu+3esp21ghX+VKIVdRRu
	4TfMfNK1FBnaPI90JX/w00WrQ4SVU3eiYEaWQeF3M6FUKGYYl4yMj8ITQZePvYATITZA03cU0fc
	zuwpMx1EzuPQOL8pIYD7lRqK+4T9OG2aoR+pf0w5yVFbndRn7Qhnvg3A7HP8XXTN7mpzGGIunbg
	AI3fBOR/dMgDa9MrR957vqJL1kXUQ/xq1tR5ptayJ9dhmLbXheDB7OsWjqGksQ2N4qz7ZNOb/u4
	4vgTVtUk89OZ3LKkBO5NZ8U0OG7Mz892t32erytT0=
X-Google-Smtp-Source: AGHT+IF2kBqM1Pc1oeCfW9iKt8MagjLl70ZYlJlrxss71glv1f95LGdDpd860qL8p+WKwgQCmnLTnQ==
X-Received: by 2002:a05:6a20:9189:b0:366:14ac:8c6c with SMTP id adf61e73a8af0-376ab2e8f52mr18576741637.66.1766647719168;
        Wed, 24 Dec 2025 23:28:39 -0800 (PST)
Received: from localhost.localdomain ([111.125.235.126])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1e79620bd3sm15961406a12.4.2025.12.24.23.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Dec 2025 23:28:38 -0800 (PST)
From: Prithvi Tambewagh <activprithvi@gmail.com>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	brauner@kernel.org,
	jack@suse.cz,
	viro@zeniv.linux.org.uk,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	khalid@kernel.org,
	Prithvi Tambewagh <activprithvi@gmail.com>,
	syzbot+00e61c43eb5e4740438f@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: [PATCH v2] io_uring: fix filename leak in __io_openat_prep()
Date: Thu, 25 Dec 2025 12:58:29 +0530
Message-Id: <20251225072829.44646-1-activprithvi@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

 __io_openat_prep() allocates a struct filename using getname(). However,
for the condition of the file being installed in the fixed file table as
well as having O_CLOEXEC flag set, the function returns early. At that
point, the request doesn't have REQ_F_NEED_CLEANUP flag set. Due to this,
the memory for the newly allocated struct filename is not cleaned up,
causing a memory leak.

Fix this by setting the REQ_F_NEED_CLEANUP for the request just after the
successful getname() call, so that when the request is torn down, the
filename will be cleaned up, along with other resources needing cleanup.

Reported-by: syzbot+00e61c43eb5e4740438f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=00e61c43eb5e4740438f
Tested-by: syzbot+00e61c43eb5e4740438f@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
---
 io_uring/openclose.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/openclose.c b/io_uring/openclose.c
index bfeb91b31bba..15dde9bd6ff6 100644
--- a/io_uring/openclose.c
+++ b/io_uring/openclose.c
@@ -73,13 +73,13 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 		open->filename = NULL;
 		return ret;
 	}
+	req->flags |= REQ_F_NEED_CLEANUP;
 
 	open->file_slot = READ_ONCE(sqe->file_index);
 	if (open->file_slot && (open->how.flags & O_CLOEXEC))
 		return -EINVAL;
 
 	open->nofile = rlimit(RLIMIT_NOFILE);
-	req->flags |= REQ_F_NEED_CLEANUP;
 	if (io_openat_force_async(open))
 		req->flags |= REQ_F_FORCE_ASYNC;
 	return 0;

base-commit: b927546677c876e26eba308550207c2ddf812a43
-- 
2.34.1


