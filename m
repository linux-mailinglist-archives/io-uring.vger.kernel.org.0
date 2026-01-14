Return-Path: <io-uring+bounces-11711-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D270D1FF3F
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 16:52:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C33923002899
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 15:52:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14EC627E1A1;
	Wed, 14 Jan 2026 15:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HIccsa9R"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318BC27EFFA
	for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 15:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768405957; cv=none; b=uKh8guM8aF5SP0z1wD/6KtDLP+PwaSXbCadGjzmwduGsLhrae0kkvxJeGmACgn/Oo7+07l5lfSalmlOyNoF0X6ElqjPXhWPumczXTKqceTImtZ4koC2oPcEoiuE3wB9tvNJ4Y5QT1IAWCjpv2xxOLsgbLMnbukP2YQmDQ9HbMNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768405957; c=relaxed/simple;
	bh=aZaGrg05z1uilw8uWt8mJsG48U57CSokPkzqeeP4Vg4=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=uvQMOlTIqeTj8ERdfuTLRktf1tzyLFNrfw4o6grx2R1gEaD/ChhS5Q9d0toWWn0rgzQAdPw3DmEiFoQ/e6m+s+Em0KN2ztFyHQmKT7irpB2b1+HGzx4F2NVj3L0sIcaqP62ABp1w5/4989o8QlvUAwvvqAI55EewF9/yDtuHa/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HIccsa9R; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7cfd2423793so152224a34.2
        for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 07:52:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768405954; x=1769010754; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6VnEIdUQ6QFjLnBNfqPSX5Jt78Om/7FfeTMsos+6Emg=;
        b=HIccsa9RH/dvIdIZhh2kePOXZJtBBbU1ZCb4+XEP7j2k8v62VFWqMqU/9sIfgHORPs
         3IOITAYiynPGFNcxI3TJR9QVodxqUkWrf13vZ34dX6WSEHVJWeo4Flk2nULDg18nWlNV
         ZGoWQIaKAWHmUGMDhJxxSV5aEUUWvTFkhQ+5B1AGImehGMHTS3Je0CXdnqCsz2ZvAgag
         yqpjiF3opCaQoNbQHgsUrka+Tg1XNY6drvujpA13wcPOPH+K+CJZRyjDpOr0vBNcinlH
         pYf7WTscupF3IA4s9uXNT4eaDhlkMAGHPlmLt2iM3OFiAccY661fU0e3yoi6F7D858eA
         clrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768405954; x=1769010754;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6VnEIdUQ6QFjLnBNfqPSX5Jt78Om/7FfeTMsos+6Emg=;
        b=uoDwyM6ICjQqPtrI8JHke8Q01qwPtF7eazjkX451/SFn9gjgUj6R5micrURRuRvK5e
         C0efYTf5+1XoRhcgYgvzan7kxKDa/MFvS7n6rEeEOYwCf54/So+yRmN8xp5tOCO9AZO6
         KLlRKtK1O2KH/poJXyB2ZCL3WnkxUxIh0Xbpa/LjPREiVam2UuyoaF0ZIPpkgI1QBkvr
         TWKJgaFruknGtS/1TQKrt/AjDJX93pb+jzMLmZmRa5jFcCbJ0Ymrg3kADEX+sB+FUofn
         y0vaF0VR7Hx4bJ7db8TBJ/2aVLivyx41hnbo/HqFyuf7tBGSxiNpq1rLSz+bstvLYv2m
         iPzw==
X-Gm-Message-State: AOJu0Yxzh8nDgXyEScLHnXXMNGuwLU8xHE8oJjcLOaAXclJ2ZjQO8ftc
	EMYXnsRh11N+JZQ+Q1LFZikKtkf1ff/qtETC7+tyZaZWett9o1VmYedSCCHJglTxEqR8tATKRrM
	NT1Eq
X-Gm-Gg: AY/fxX5PEm44OaIBVfChzQLA43nIzCl69ZuVZyDxdRUS8pyWbnzcID5RSgmda+21Ivp
	vxb0HKqVPNRKO81t26ZfSou8hd8sax7vUonxc5maqJBWtpcw3fDwvxGDX1t7NlpPl68NH5a9r+Y
	JBjC+pGIzxhG2JBZDpZVCUbBbTzTw5NCC5gjvwFAsWOe0x+PcQ3CZWO2yni4MC4ZkEV2fh8W39L
	aRqxIIVABSMKtNtbvxK+TVW7jZ6LpIL9gyY9fmiqFHNgod0/foROC3SaaSMji5/4nmvy1OFIND4
	b/J+Ru3aIw2GJ+kBViBocJqjjR7OmUdoCyJt1zGEp51jKDRuZ0hABhZezbH0p4stsUu2PAo4hrU
	0An1LZKzs/5SRWrL2PeZkS7GJsttTdJ163kzVc1h83LAIA53N+JGx50DTUm1bLUqxzevY6TWD9h
	24iPFsPAM=
X-Received: by 2002:a05:6830:3104:b0:7cf:d18e:2bfe with SMTP id 46e09a7af769-7cfd18e2c48mr609528a34.24.1768405953743;
        Wed, 14 Jan 2026 07:52:33 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ce478d9c2esm19055167a34.21.2026.01.14.07.52.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jan 2026 07:52:33 -0800 (PST)
Message-ID: <636afbe3-d547-49da-aeaf-7da56e28608c@kernel.dk>
Date: Wed, 14 Jan 2026 08:52:31 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
Cc: Ming Lei <ming.lei@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/uring_cmd: explicitly disallow cancelations for
 IOPOLL
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

This currently isn't supported, and due to a recent commit, it also
cannot easily be supported by io_uring due to hash_node and IOPOLL
completion data overlapping.

This can be revisited if we ever do support cancelations of requests
that have gone to the block stack.

Suggested-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 197474911f04..ee7b49f47cb5 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -104,6 +104,15 @@ void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
 	struct io_kiocb *req = cmd_to_io_kiocb(cmd);
 	struct io_ring_ctx *ctx = req->ctx;
 
+	/*
+	 * Doing cancelations on IOPOLL requests are not supported. Both
+	 * because they can't get canceled in the block stack, but also
+	 * because iopoll completion data overlaps with the hash_node used
+	 * for tracking.
+	 */
+	if (ctx->flags & IORING_SETUP_IOPOLL)
+		return;
+
 	if (!(cmd->flags & IORING_URING_CMD_CANCELABLE)) {
 		cmd->flags |= IORING_URING_CMD_CANCELABLE;
 		io_ring_submit_lock(ctx, issue_flags);
-- 
Jens Axboe


