Return-Path: <io-uring+bounces-8618-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7580AAFD4C3
	for <lists+io-uring@lfdr.de>; Tue,  8 Jul 2025 19:09:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C3C716147E
	for <lists+io-uring@lfdr.de>; Tue,  8 Jul 2025 17:08:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF9C6BE46;
	Tue,  8 Jul 2025 17:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IlloH7vM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16AAF202F70
	for <io-uring@vger.kernel.org>; Tue,  8 Jul 2025 17:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994487; cv=none; b=R8hUBzkyQqkmnJjJf36K295kxxyjbetYQ6+76LxWqkLxC+LTignB/5XQ35CvytJ2scZgjcvP8/UtqDebV8pcBiKYk7W21AUJHM4vQHuYnLxZBnwyXLI7HvElxwEdfPNxhuN3YneAx5mm61+z0/S8klMdN144sFNAxgqWm9uZIsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994487; c=relaxed/simple;
	bh=OJ1GntkJ5ilDK16Xp2UzTIv0sVOw+Kywycg/F2S3Mbc=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=B4FzibJxcT2nNFqqc8qpAAnGx1ra/7ItPPxjlPJEQ9cmkrP2NcFmtYDSg4PbcKnVjOPoH1C6Zt1hbcdbaJu0tT0oVC5T4stplnUSBLTeinItNWYEUxT2SMnRRUnCwDXzpgBJ5exEeZy31UmjB1F4d+EwtbVsGO3K8AoY3QGjQFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IlloH7vM; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3df3891e28fso13045155ab.3
        for <io-uring@vger.kernel.org>; Tue, 08 Jul 2025 10:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1751994480; x=1752599280; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0uR2AAERTefZNGbKh++1SWGh73kTa5RXmHePaXy+KtM=;
        b=IlloH7vMUeZeoX0KMshpffa7q7Ad5WwyKX4JVLiKxCeiOp7IhKaMtNlsUoN6D40GM+
         bOz8mJgseDN6lkgo0PRku5SyVtWPd3O5ntPT4n995rJOnkBX0q9S5ToAq94GCOQ680ez
         1sT6MzMzCIOzMyn8u96Mg+2o+r5r5oUkAZnCoqAeHxEKnNdi5ZZVSnfMPRoNLuZQ+uaO
         Sg9YYmc6jzlh8xlL+8QFqu00ZdwAn1d5uZ4TAk0RopougOcFFNFEjRxsz6K7oo6C7JMG
         tkzErgGyJZaD1xEfvszFyFeRYRraaBkdUlZSNXH2J7LtEpopqfz0kAEyPwKcwqnnvg/y
         b0gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751994480; x=1752599280;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0uR2AAERTefZNGbKh++1SWGh73kTa5RXmHePaXy+KtM=;
        b=J0ajiBJ/Y0Z9T9mbSlLGbanBWVil7toJK6RoO21xt1c6UBTo9PSy2LVcmNbFZwahSJ
         2em6kPGYpO/Q1BiR6IGQ9oL1eWUbP1r0zX126v5cpU51IMaywUZB1t4UszqMU0M1oO7c
         ijFBICWBDjfqfAmi4t76p9eNM0xO208NRWxnpvEyXUfswhIfGSQ+2UNaZuC9sipw74kq
         9WXkl9hVHJfJHs96VNooNEflI90mmZzYwi25pEBHSj1dDaFYBJKadJfKCrqts4oJFFj/
         PPCTORrQrGHe1tK4apjqD7IFRD6sZqK7IY5nKiyizeZfbU48YBQIte7oAtTgmtzzcx1d
         LNqQ==
X-Gm-Message-State: AOJu0YxH9R+w36D+AmTWl4Mptj/wN+fu50ps4WeEAYlWcE3apcQd84dR
	Wyr46dUz7T+QlzoJT9yxNcWnKg1N/cNoGczxiwU+8DFEbZcTVgSR7govEjERm4245gWBCRYUIXS
	aOOAz
X-Gm-Gg: ASbGncv12w6g9dBgqEAumJyBunyyJ1kiqAduvuaqrytKWEzpMJ1SiQOp7lh+lF4Xm7R
	ZfUjdLOZ7yLWABxekbT2OEYOOcynHzrFfE+rEQwCjtiA9FSOUz/xzEbWpYJqxRxpHCDlixTmJIU
	B3GOiGFs689hp5PxPmu4d+wGx8ujQmZA9xC2c8PyH/plg58NneEobEldjkSrJJElfOTEY0eqfOH
	ZKz3a/GQ41IoRkM7YK+asfPECnyWyx368rRbG/+ZeBuM0HzhEYyV6yI1vDtg0tNckxJlfZsn4nE
	/tQ4h6pqPf546XwYUiVvKKHoezLr/XlxcnV4Oads0S+seTT/2qxZlNE9Ig==
X-Google-Smtp-Source: AGHT+IHcDzzi3VQohlehf1tcp1kDecK87scu6yuaQJGCP9leKgOJzDYRcke5jbHJMNnpLLu/Vcr0qQ==
X-Received: by 2002:a05:6e02:230a:b0:3e0:546c:bdc3 with SMTP id e9e14a558f8ab-3e135565182mr140719375ab.11.1751994480373;
        Tue, 08 Jul 2025 10:08:00 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e15929ebedsm2701955ab.31.2025.07.08.10.07.59
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jul 2025 10:07:59 -0700 (PDT)
Message-ID: <7f81d2ed-d5de-4fc2-b059-73ba00713a4f@kernel.dk>
Date: Tue, 8 Jul 2025 11:07:59 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] Revert "io_uring: gate REQ_F_ISREG on !S_ANON_INODE as well"
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

This reverts commit 6f11adcc6f36ffd8f33dbdf5f5ce073368975bc3.

The problematic commit was fixed in mainline, so the work-around in
io_uring can be removed at this point. Anonymous inodes no longer
pretend to be regular files after:

1e7ab6f67824 ("anon_inode: rework assertions")

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 73648d26a622..5111ec040c53 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1666,12 +1666,11 @@ static void io_iopoll_req_issued(struct io_kiocb *req, unsigned int issue_flags)
 
 io_req_flags_t io_file_get_flags(struct file *file)
 {
-	struct inode *inode = file_inode(file);
 	io_req_flags_t res = 0;
 
 	BUILD_BUG_ON(REQ_F_ISREG_BIT != REQ_F_SUPPORT_NOWAIT_BIT + 1);
 
-	if (S_ISREG(inode->i_mode) && !(inode->i_flags & S_ANON_INODE))
+	if (S_ISREG(file_inode(file)->i_mode))
 		res |= REQ_F_ISREG;
 	if ((file->f_flags & O_NONBLOCK) || (file->f_mode & FMODE_NOWAIT))
 		res |= REQ_F_SUPPORT_NOWAIT;

-- 
Jens Axboe


