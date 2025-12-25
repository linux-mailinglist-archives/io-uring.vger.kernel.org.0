Return-Path: <io-uring+bounces-11304-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id CB817CDD60E
	for <lists+io-uring@lfdr.de>; Thu, 25 Dec 2025 07:34:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 70F9A3000B75
	for <lists+io-uring@lfdr.de>; Thu, 25 Dec 2025 06:34:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECEE12D12F1;
	Thu, 25 Dec 2025 06:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HvMMpzu8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77530381AF
	for <io-uring@vger.kernel.org>; Thu, 25 Dec 2025 06:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766644454; cv=none; b=q/gPGfOwzQzrx7wO2TqxcYDsXGHIXc8gmVBn+NUHqoqYLGrS1NrmY1u+Ul9s0F9XOJdghSyituRNRPidbap279Znd0oo3489JUhlJ5vCJsivFi9EgKjaOI1zajbUG7n8+pBMOTHvc/5gOz8/URfgFe+nqtL41EQmhFFEDS1jttM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766644454; c=relaxed/simple;
	bh=pTWub1wm6+YOwgTT62/BfAKG3yOfsN3gpjW71MdZj3E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LoIgvYMClt/aMJxB7wtUfT82edN99fLcABDDbjZDND8YduYiX2nB/pejaZbmaXBLpQGGHSe1XViO/2UmiPn504myfOyKoW0oKFmet0ONRkCC7NmGWjrShtj/PquIaElu00ZtMvaoeAfqMTDrUnq5DQ6d/1yb09FrJjP3f9Zj3YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HvMMpzu8; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2a0b4320665so97613435ad.1
        for <io-uring@vger.kernel.org>; Wed, 24 Dec 2025 22:34:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766644453; x=1767249253; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OMv12N6Z7QdXIVFJNcbnUr2FQCD/anI5DuLaDa7CSFo=;
        b=HvMMpzu8Y2TMb0LTh2pjqh25x70RKEp3Mqfrkzlxo9HmoUgQyP2EPYj8iFOKN4wglE
         A5WdUN/BwO9ylSHfrsVzTLslU57fWdOzwt6QMvrnqavahFs14shVmk9YAkUzKwWrDddw
         97tg+Z7xN1QpL1kFXCamdAdfl3DlCtBNmtoyxStmX9oAoXcbJHu/cv3MSasg8BPueiDi
         zGhKUjrtaePmkUjsL+jp6Zt2AJMVdn1H4UAAEtYnhCYg4iJB4jjrKQP7U8fpg/hmZeXz
         s1AYQ6YbM1w1vx6jXm8evwrLHsXtAq/uoSSNHXdfkQVWWHcvS/GelO3u8ObLw90jC208
         NizQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766644453; x=1767249253;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OMv12N6Z7QdXIVFJNcbnUr2FQCD/anI5DuLaDa7CSFo=;
        b=p2Ylj0Kpzt7UhY3Qtep2W8rTAJ+t4+tirtNzNVDgWqNHFVlxiNTRPNjPGPJ43WnVoH
         KyN3kcPhhTnqtP4nU7GKvVccDJxA/BIN609P/OcN88V9zX0jRHwVQ2iQIkYEl8AzZpwp
         fctegqIQVxkAKhb5j8RMJHq3yEXDY253a7y1zaRn1bAxgXU36fzpqhMg3HLfbr9rL3W/
         20utcwGt/XV1qhA+nnnMGu4l/lfhPqx8/XGr2+RwzAz2aMDvJFlUvdP8xNY4M+DsLOuv
         SP+ExbttieyngzUcZZuLdOzK3U6sdrClezCRqLG6Ogl6lC0lxRfOIr0rm6lipbFo7lMl
         4+PQ==
X-Gm-Message-State: AOJu0YxjVoA7aQDoo29Bw54+PVoY0/TI24MLn9b2SkSTkED6Dlro0W3j
	+g1YyIsphoD2kLHvXqNCr62TEEmFTMNopTUzUm9OZ4pQUPE8iufBVEmU
X-Gm-Gg: AY/fxX4Vbzz2/CVsRCKwW6Apwhf9ym2nLmIrdzixI2iFXAsx8NDrO413qrDlXktOaws
	8Gmecx+l9/g2+ZQawcTGQZ/sz4b1aeIfDPLysOyknwN8nPC+RUpW7XyLUxES9LmnJRNLfE8Mf7b
	Cfjx67RWEWzOENHBORn+0KYUAmtMaALYn0xzGiqcGuc7PkjETjHpfxIb1obqi8OA4AHGArnziBI
	LTAKgs4vQfORo2HgLbAdV23L2LXjvRyCVya8dCG5UUtJV09khkZxH18gfWhwk3sKvc5r8i2Ndx1
	5DBm8YbjiPHWN5cndogKjH9cTbgZy3mc1RmAK3b9HRde8SnYwy1zvrs28dqcdj+XcO/DXP9CG/d
	FWd7OVpowCwwE1iKhaT6NYuYtrlIkJOjis1CwhpOPxVuX39dwmXV/CDWXtIqWJYgXd4QLrLiP0r
	57yqu0bDJR99/xJxfTrz17PUuiVESV
X-Google-Smtp-Source: AGHT+IFx0tk9ytMvmJKYaOSglMaTl8EMF2q6AFP1CjeCN6tQ8HgdzQxtnWndoHZS4n0yWdBkn8zNew==
X-Received: by 2002:a17:902:e74b:b0:299:e215:f61e with SMTP id d9443c01a7336-2a2f2a34fadmr199291485ad.36.1766644452765;
        Wed, 24 Dec 2025 22:34:12 -0800 (PST)
Received: from localhost.localdomain ([111.125.235.126])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d4cb48sm174073575ad.64.2025.12.24.22.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Dec 2025 22:34:12 -0800 (PST)
From: Prithvi Tambewagh <activprithvi@gmail.com>
To: syzbot+00e61c43eb5e4740438f@syzkaller.appspotmail.com,
	axboe@kernel.dk,
	brauner@kernel.org,
	jack@suse.cz,
	viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	Prithvi Tambewagh <activprithvi@gmail.com>
Subject: Syzbot test for v2: io_uring: fix filename leak in __io_openat_prep()
Date: Thu, 25 Dec 2025 12:04:02 +0530
Message-Id: <20251225063402.19684-1-activprithvi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <694bcb49.050a0220.35954c.001a.GAE@google.com>
References: <694bcb49.050a0220.35954c.001a.GAE@google.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

#syz test git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git b927546677c876e26eba308550207c2ddf812a43

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


