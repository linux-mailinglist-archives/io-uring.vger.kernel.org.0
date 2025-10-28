Return-Path: <io-uring+bounces-10257-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id F0781C127F5
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 02:12:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E053F4EC82F
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 01:12:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88B4C3594C;
	Tue, 28 Oct 2025 01:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Yb4StEvs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B511F1F130B
	for <io-uring@vger.kernel.org>; Tue, 28 Oct 2025 01:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761613932; cv=none; b=PN5g3el76GnS8G/C99nMnCRa+0Y+PbwcfIRzKfz0dIffbD4n7PbKxyuMD99RJ8s3MWzuN0AmCCk9jCkcMx/p9d1iVcfodtIYT2SEu1+mYnpcQQV9WlzZbn5MkCmZ098ny9M/8L3mGiG4livhIdzu+muFqlG6vdLLpVD1iIwT1DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761613932; c=relaxed/simple;
	bh=acDHJhzNiJBkuxbV6YVsyXqLDd8Hjxr5jUjTV5VJOFY=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=O3CzKns0aylcTQLm6bcCcxVrOgLcLZvmsrjNfBKxVbxlfIT4h6GN6Zmz7fud36GRVhfglwxjQVpMYCMvTaJCMWJDa35CTqZ2zfRgtjY4Pp5wM4+WmwtIe7AxlBxgswhJKScGoQUz5Jbqmg/VkL5+F3A65dbLl0UXZDDeFZikp1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Yb4StEvs; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-430bf3b7608so57715955ab.3
        for <io-uring@vger.kernel.org>; Mon, 27 Oct 2025 18:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761613929; x=1762218729; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=anaMxUn2v+v0l5YV0DUUG+fotoe6wcIBoNQmuaMyt1s=;
        b=Yb4StEvsttvb6Pp3aDEeycV+Jcic85+5tS3TYvcby3vZv3c3BqMjdIpWjb6ZkbA7yi
         N0qpUOiOA4XIIf0NJ+L25L/ZCEUNxWAVL5yoA1H+ns64qgIJc4r3ZgadsbcN/Eqx/wGQ
         0LdTaNyiOamRazUIveSVcxxJbfayERO2/d6Ip6YDHIr8XruqRj6cCq5nxy+sUR0swMk1
         QA+8zsPgwZI04xIoNNNEabPqxhHWuSeRWMfus9Tj2ULHZbJA93alOnAZfft9rTAhqv89
         J6/Q069O6kAEDkAvNSwzo9jbpxB/TjBpx6pPjlfnXOJo2oYYXg4nibxs1HGEoR1QdaAz
         8ApQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761613929; x=1762218729;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=anaMxUn2v+v0l5YV0DUUG+fotoe6wcIBoNQmuaMyt1s=;
        b=sE/0wlOPDrRCxK+QYb4SdEWrzUD7yx5DowSqXA/1j19sdCLc6rwIRLEo8TdJ4jCeWg
         HTkOFRYSg2jDusR00WmgK9YCKZe/oIAoV3yafX2JHylcr4+pCMpBZZIx8YyE0E+fPcHE
         QLmxkDHbsmrAN5OVxp+t5vOjzoAwiLOI1EUbKPTHlhjj8ZTGp4bqlF0zSkZK9zCTkD0y
         vC3gTuMa4dn7dBOMCVSSbODUwxck7wq0YFu3Qixxl8QCJCmKQCpFejJUqggyyDnxTwdV
         0jlSZ28eG7y00stUfVVv5Q30FnZHuXa9ONEODHdt+7DRPs2gIP7THHKeHQN+TBTdMV3k
         klFA==
X-Gm-Message-State: AOJu0YzcJ4zhrR/DbaT+CUqWgBCdomMs8OorKiYMj4+cuiFQ2TRUIJJ9
	2xfJGdug7U4sRKIObx/GrvuFjhmwuSr2OvWnBpxCO7KRuMoEmTecRnfDbjxkHTFWSHAmsWGXclC
	ZcQymX44=
X-Gm-Gg: ASbGncufYfoI2ovI9SW9xiyZ3kaZRsJh8wxRDewrqs1kK+upHPx2L4pyiGrA8Y5x0vG
	kfJjTy8xr6DFuCWrFSPponoqeBMe/Ym/rseIcoSXvYlJu/Ydv0dno+DAr9f/6eH51jbU1H7TM8n
	ckPzkMaoeHMJIj0QouTN/UvqZApI4CbMhrMcUkRIoJwqNgtI04Y2oiNItp87xefX6ShS9SA2kGJ
	wA621PQq3QCStpqNjMzqONRa95xcxjExK5O0HhKnShMdxlKK919IHCvucUUjMO7HS/u5Oa6ucSd
	x12c64sU2Ps1U3q5mlAkgo3ZXcak19L6qbNAF7iyHL6tVm3BcCWNpT2MIhRPMsb6xYua7qqMRlS
	Hd5zjBJvbwd96WJqVPJTvQ4eEQzNpASVc09BDPbVDTFvh1zQzppIpFkS6odznen8UCJgNbSp0a/
	s5JgHK6OAsIZeNnieALbs=
X-Google-Smtp-Source: AGHT+IGmRsR3RYk0F4yo9yR2QKcLq1VCoAkPxQirmXOREBp/8YI95x/NnTOSe/eX+ZfO8eISlJTnRg==
X-Received: by 2002:a05:6e02:1525:b0:430:b167:3604 with SMTP id e9e14a558f8ab-4320f7a6151mr30384625ab.4.1761613929509;
        Mon, 27 Oct 2025 18:12:09 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5aea9e38679sm3750928173.63.2025.10.27.18.12.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 18:12:08 -0700 (PDT)
Message-ID: <85801cc1-082a-4383-877d-67cc181a50c6@kernel.dk>
Date: Mon, 27 Oct 2025 19:12:08 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>, Keith Busch <kbusch@kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/fdinfo: cap SQ iteration at max SQ entries
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

A previous commit changed the logic around how SQ entries are iterated,
and as a result, had a few bugs. One is that it fully trusts the SQ
head and tail, which are user exposed. Another is that it fails to
increment the SQ head if the SQ index is out of range.

Fix both of those up, reverting to the previous logic of how to
iterate SQ entries.

Fixes: 1cba30bf9fdd ("io_uring: add support for IORING_SETUP_SQE_MIXED")
Reported-by: syzbot+10a9b495f54a17b607a6@syzkaller.appspotmail.com
Tested-by: syzbot+10a9b495f54a17b607a6@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index a3ce92183540..248006424cab 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -67,6 +67,7 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 	unsigned int cq_head = READ_ONCE(r->cq.head);
 	unsigned int cq_tail = READ_ONCE(r->cq.tail);
 	unsigned int sq_shift = 0;
+	unsigned int sq_entries;
 	int sq_pid = -1, sq_cpu = -1;
 	u64 sq_total_time = 0, sq_work_time = 0;
 	unsigned int i;
@@ -89,17 +90,18 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 	seq_printf(m, "CqTail:\t%u\n", cq_tail);
 	seq_printf(m, "CachedCqTail:\t%u\n", data_race(ctx->cached_cq_tail));
 	seq_printf(m, "SQEs:\t%u\n", sq_tail - sq_head);
-	while (sq_head < sq_tail) {
+	sq_entries = min(sq_tail - sq_head, ctx->sq_entries);
+	for (i = 0; i < sq_entries; i++) {
+		unsigned int entry = i + sq_head;
 		struct io_uring_sqe *sqe;
 		unsigned int sq_idx;
 		bool sqe128 = false;
 		u8 opcode;
 
 		if (ctx->flags & IORING_SETUP_NO_SQARRAY)
-			sq_idx = sq_head & sq_mask;
+			sq_idx = entry & sq_mask;
 		else
-			sq_idx = READ_ONCE(ctx->sq_array[sq_head & sq_mask]);
-
+			sq_idx = READ_ONCE(ctx->sq_array[entry & sq_mask]);
 		if (sq_idx > sq_mask)
 			continue;
 
@@ -141,7 +143,6 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 			}
 		}
 		seq_printf(m, "\n");
-		sq_head++;
 	}
 	seq_printf(m, "CQEs:\t%u\n", cq_tail - cq_head);
 	while (cq_head < cq_tail) {

-- 
Jens Axboe


