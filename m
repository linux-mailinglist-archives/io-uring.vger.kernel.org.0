Return-Path: <io-uring+bounces-10018-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 35D90BDE673
	for <lists+io-uring@lfdr.de>; Wed, 15 Oct 2025 14:09:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E9A304E385F
	for <lists+io-uring@lfdr.de>; Wed, 15 Oct 2025 12:09:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D650324B12;
	Wed, 15 Oct 2025 12:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HLp0FXcl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4083233ED
	for <io-uring@vger.kernel.org>; Wed, 15 Oct 2025 12:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760530157; cv=none; b=SkmOBTwpzluLbBsJmDUaBDPfu9ZYTqOQHlTroNmgD+KHDMN3kxPiV6Q7JJ4tPLOVm6P/4aDM3PqHmKmVnlNBZ3vmRPeg+KgOrOXSSlGZtU8QqoyydkRvlpdlJ5dqJ96dpYEXRTOgKCGSUZ+XQYiNRolpRbyBlPLTZcHNBfWlBhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760530157; c=relaxed/simple;
	bh=CUSPtdkxoRxrmCvLUJ/dt0zzfl01EOUqmRGvjXe5v/M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jasQjSD/T9wa9bIDDxG9fOD9WPnzo5TOHEiBZji2QNDzf8dIXQmaeC1gIB7V6hPuoucPDr3keoAPlnmYNB93TzGl6mGaUwTopxzSK8WvCGgu/ct+whoXIwJ2qOAc9+Du7sBbwFwnPVl4z6Qiou5iGCNFd+mJn1RIloZBLnS5Gcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HLp0FXcl; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-46e42deffa8so61256685e9.0
        for <io-uring@vger.kernel.org>; Wed, 15 Oct 2025 05:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760530153; x=1761134953; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=E2PI+ockwa6Xhh15SeJkjxmt/0BCVgjB/ytMicDSNKM=;
        b=HLp0FXclfS1+/6rM0UAIvujaHLNxnPV0PN/5DYJ9v5UKdBOQNb6zmTQXhFGFKGFAaf
         dgt3LULEXFlakKqEUwYsSs1pFmx55C6TE9f69WfDyis1On5sO/xxlwdgHWtmPENRs7Nr
         SXyZB/lJs0ZyRFQJt1r8HK5x6B849hxKWgrUyMug5igQCCufxrW37n65nn5lxBiiq6+P
         JdWHNvg4p0qn9o2i1nBNANPbOMgQsQbep51axE8aUMBL5KkLaEdZYDg3AvIxov4XIBEY
         gdfsYBdvqLqjanZU8KaC8D/PuC4nyFx4x/4EuYh7EdggEHcnexzDym3IX0zMURHbUSk/
         +Kvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760530153; x=1761134953;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E2PI+ockwa6Xhh15SeJkjxmt/0BCVgjB/ytMicDSNKM=;
        b=iQSCEIc8PeoKHEB31wGGd0UzjrYKeDdCKli5raMfnOalR0HS/EGMTU6V4a3IxQ5qzu
         cNcFpFtmYhC+rl4T4+WkAm6xVrFUe0zJ5jJQTmAOMkS9vncZ9cD5y0BCrp9qcuJtCRw2
         EaIkTZmrAzAV/2kNQm5wcrc+7PMNWCAsl5Rfhc50NLWSj0T0gFBcB5EvhKR2QA//tfGx
         jDp+IE3vwR+5y1HPs7iRE4BD9mfFm271IQ46i+vGcSegfGxpPD0ofRtOjjpfPyH9KNhC
         wVkvwq3cs4+W0K52IeOvkRDdTZevqJQAOlI8VF7Hmxagxlza18BJvXNG86lQEgsaIyAl
         eSSw==
X-Gm-Message-State: AOJu0YwRvlX9VKWzHg0404L+CzcZhxbVunRLbaMm+sYiMxJwPTyUiqWh
	TbgrVIA8d77Dzy6pq5YcGmCQxcrNKofnrcy8iPYfSUmHXHLeGwT0pFlFtRsRiw==
X-Gm-Gg: ASbGncuYDKMl0wtonA2lGBHPdxVPszbzfu20m6Er9kp/QMxVUUn3j3zR6XKALyakZtP
	9fS0/lXQ/+e4yvAhyL6avURN0ZYJ6vAsxtK+lsq5EH4vw88LYFl38gs5qOgCaVa284pSUb9c8M4
	IESV/hase8GA1AzAtC0fI8T3ueHg/DYlmG4sHDRctFnJFvDDm1FFS7OkIsVkhiImqBCh4A+qO73
	O9CHd9zG1aOKE5Z81tk6cbgiGAKuM4DNtMvALsi8S51pzrhevJdE5d3WOodUrWEnfr2B6KjdmqK
	ZVt0JXOw7KDVwTs1vrdvyyW0f0SMumpM0yfDn7xN39favN8vHl6MR2Hbu+riwjoFo5FsJXsJgH2
	f03EeqvYRusfIzpve/ByUvRJeft0f5vFku8hLj00ZzbYNkQ==
X-Google-Smtp-Source: AGHT+IHdP7hhMht4nR1xEwg04l8CIVoXrkJXZd9c0j5mV422k/nR0jllfSKipp+mBDWez490mFRQgg==
X-Received: by 2002:a05:600c:6287:b0:46f:b42e:e38d with SMTP id 5b1f17b1804b1-46fb42ee464mr133803365e9.40.1760530153377;
        Wed, 15 Oct 2025 05:09:13 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:f5a4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-470ff15ef28sm36098465e9.5.2025.10.15.05.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 05:09:12 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: fix unexpected placement on same size resizing
Date: Wed, 15 Oct 2025 13:10:31 +0100
Message-ID: <c75fe1c497a86daf2b989de48c13e02be263f1a9.1760529983.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There might be many reasons why a user is resizing a ring, e.g. moving
to huge pages or for some memory compaction using IORING_SETUP_NO_MMAP.
Don't bypass resizing, the user will definitely be surprised seeing 0
while the rings weren't actually moved to a new place.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/register.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/io_uring/register.c b/io_uring/register.c
index 58d43d624856..2e4717f1357c 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -421,13 +421,6 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	if (unlikely(ret))
 		return ret;
 
-	/* nothing to do, but copy params back */
-	if (p.sq_entries == ctx->sq_entries && p.cq_entries == ctx->cq_entries) {
-		if (copy_to_user(arg, &p, sizeof(p)))
-			return -EFAULT;
-		return 0;
-	}
-
 	size = rings_size(p.flags, p.sq_entries, p.cq_entries,
 				&sq_array_offset);
 	if (size == SIZE_MAX)
-- 
2.49.0


