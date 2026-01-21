Return-Path: <io-uring+bounces-11865-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8KxfDRQqcWniewAAu9opvQ
	(envelope-from <io-uring+bounces-11865-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 20:33:40 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id B35BF5C3F0
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 20:33:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 1F99B5805F4
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 18:24:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2328F36997C;
	Wed, 21 Jan 2026 18:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="huk/RdE5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BD621767D
	for <io-uring@vger.kernel.org>; Wed, 21 Jan 2026 18:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019762; cv=none; b=hzrP/jKF32KyvM4AWF6wllIcwSWiwuXdqHQH4KBGwd701BXt/yahDpvV55E8cu6jqHerWcjwuYMl8Fa5oIiOXIUHwG1wDvYscvu5/ac/eqdel3eoWgq3pFn1khXJZLnUN5j3TM7CzBkgcvhBwNR1DchvlT99U1b/yyzJkBBryZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019762; c=relaxed/simple;
	bh=QXIncZSOaqSqO/appKX7ZiPgAYK6ceuEwPmGcVWGiOI=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=UpMbjXhoe2c6FII/5L6ahC1gT0yw5aqkJlIvDvu3d6NQ+p4+565ovJvWpxzgDa1Rsmfn8vufS+EqRywIpTqlXL4hYcnZnDQdfWZrFBF5EQZL3rnn+rctBzo39Q930+zfIiyJ+Z3KQexMT/iT1r+f0BFqa8P9oGMDp7tWTk3D0U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=huk/RdE5; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7cfd9b898cdso58642a34.2
        for <io-uring@vger.kernel.org>; Wed, 21 Jan 2026 10:22:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769019756; x=1769624556; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Poac8Dia2NE/j/ZZHHhR1fnHMsTCG1x9+XvvC589a/A=;
        b=huk/RdE57NnxYqSociknx0ZsKSEB/YhetEFuQ62RBrp9v/z0dTdAGjP/oSHU4S3qD/
         3uOXY2it3lqktm9y8x32fJdeRVCfSErcA/Ws2CZMBG2SfUC381fI/RKnKWdSEO9LnspP
         +4EH4nIsc973ZS8qbG8KrRqaXM7KwFtlYw0T7+7cy+SdxuqJamlWmvwhZAOgJaoC2VHR
         JkyA7nvtEK6WcA+U9vdqB0dlKPmtMtl3Yq9Vex5/Iq7VFLLgAbAluT4n+88lC4KXnwdD
         bbPzHunJUvnEU4W+hWgru5Ur47OAUlPLBetK71nBSKLp+hF3LAuxDtrXD+vO/Yf4dses
         258w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769019756; x=1769624556;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Poac8Dia2NE/j/ZZHHhR1fnHMsTCG1x9+XvvC589a/A=;
        b=CHB+PTrej0c/3SbFG2FRyHr7uT5mPxponvccfSR94pqr5bkraeyWNopDD5E7NSOZ43
         j+ySguJo+htZ3FhKqhQXXhROTqewskfYA32qvYjLi/P/D6jDZIWQb5wF8mwpMAR4WQRy
         INHFI5+Zqlnmwyd/cQvUKQF+8JBc9HNinP0BvlqAGgnO7T65LI6XNXuocq+fo6HvLwHa
         g3hrM9yM9exeXlAuVv1fwVVOVyATUZ24EKaLt+kBAXkOcuglsmJ85lEcBp4WOxb62Oqx
         qXT2gOs+32oscyY5+0XopPQKTjTf5OwcfSIOVUdJmD/Ixi180tCE/943lgXO+O7k2qg8
         zgYw==
X-Gm-Message-State: AOJu0YwJ4enI6rZqlqdu39W1Kh+r7xSkuR5yUFx7591rqAGLti/Us86s
	Fv78gvA7FcI7gz9jmTkAl3KnmOVlGqoTf7sOso/LvkPtxNv+81geKET/sAZs8Ta5CSSr3EeZHvh
	vWIzq0W8=
X-Gm-Gg: AZuq6aJLUe2asGLAFMRpcGd6ePWDyMWU48dP04DBe3ld+umxkPKU30yAAbCTQ1MPKmT
	TJ2Xij8V7hdj24CY9+JxHSM7fPO7TX6m6j/f/X8YBW0yPJuAcmU5sn6ntulf8QwHD3WmKWGdQtL
	I85Sa2ThpyVxaV5RpBWNWHPuy/z/trgTneqN4i4W+FkLkNYGkHmSeiKcMPzhyqsdlGxctuvb68a
	8LoBl0uEqYQt6J6hu0pVa0pmqWMreuoZ64If/9MV9sTUU0GKJYbw/K251EyoQZchAKy6OswPIge
	Z5VvksSM2kiWDLR8hXUdt0Fn2yQj8RPtLDqJWrKjIXDlpi8FOABA1B68KnhPvSLl+qS2LKmjctK
	0Sk61t2e4eQWHMlKT87sUWvt911ql4oQE8x7mlGPfMna0HKT5/p7WXd7wv32HPCIKB126RKFSoL
	pcWCsxKzh9l+hyvHeAxwaRcLc7BtAs7nd2IYvOCZSXXP0pCO2v4J2+tNSbjcpp/uvRix4U
X-Received: by 2002:a05:6830:82e8:b0:7c7:5f79:40ca with SMTP id 46e09a7af769-7d140ac884fmr2957484a34.29.1769019756278;
        Wed, 21 Jan 2026 10:22:36 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf0efe41sm10788449a34.11.2026.01.21.10.22.35
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jan 2026 10:22:35 -0800 (PST)
Message-ID: <bfb7c986-428e-49e7-ba97-ca500eca3749@kernel.dk>
Date: Wed, 21 Jan 2026 11:22:35 -0700
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
Subject: [PATCH] io_uring/eventfd: remove unused ctx->evfd_last_cq_tail member
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_ONE(0.00)[1];
	TO_DN_ALL(0.00)[];
	TAGGED_FROM(0.00)[bounces-11865-lists,io-uring=lfdr.de];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo,kernel.dk:email,kernel.dk:mid,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: B35BF5C3F0
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

A previous commit got rid of any use of this member, but forgot to
remove it. Kill it.

Fixes: f4bb2f65bb81 ("io_uring/eventfd: move ctx->evfd_last_cq_tail into io_ev_fd")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 211686ad89fd..dc6bd6940a0d 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -442,6 +442,9 @@ struct io_ring_ctx {
 	struct list_head		defer_list;
 	unsigned			nr_drained;
 
+	/* protected by ->completion_lock */
+	unsigned			nr_req_allocated;
+
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	struct list_head	napi_list;	/* track busy poll napi_id */
 	spinlock_t		napi_lock;	/* napi_list lock */
@@ -454,10 +457,6 @@ struct io_ring_ctx {
 	DECLARE_HASHTABLE(napi_ht, 4);
 #endif
 
-	/* protected by ->completion_lock */
-	unsigned			evfd_last_cq_tail;
-	unsigned			nr_req_allocated;
-
 	/*
 	 * Protection for resize vs mmap races - both the mmap and resize
 	 * side will need to grab this lock, to prevent either side from

-- 
Jens Axboe


