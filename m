Return-Path: <io-uring+bounces-9927-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 65EFBBC4D8F
	for <lists+io-uring@lfdr.de>; Wed, 08 Oct 2025 14:36:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 11FD3351914
	for <lists+io-uring@lfdr.de>; Wed,  8 Oct 2025 12:36:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE96D248886;
	Wed,  8 Oct 2025 12:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OnRBCKW3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5DB21B9C0
	for <io-uring@vger.kernel.org>; Wed,  8 Oct 2025 12:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759926995; cv=none; b=R0Ev0gBP0LGN/MjdZ6whlrzunW2+ioCYB7cRSeP5LnUQHIgCc1PSXDIr9W14IUa1CwMnKMQ1+M9k055KMljL7QBHDt631h9ydhSexBr19+uzgLP11hBo8E96dQZwox1nsb+bnvjXrhdVNF/lpYWaoZhW4EeJQzFPmO+ZF2+aNRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759926995; c=relaxed/simple;
	bh=+aIC047GhiBphGidHfz+QV4GqetGV7y8jq9FC37CcQU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aH0B+gqIx6QASzUV72rUqA1GQ5pMrWp5K8NHGA+G1cOm5bCHALMw6GD5HBPjO2uVy53yAbSqZYo4N/V3Fuz+Y75dohXFH9nIUJHTzBam93uc6vxqfSJ/QFQ+LD77ytD3DgFpwvei1JCrsemKR6LepWZWo2ptwacQyCIuBzrzams=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OnRBCKW3; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3ee15505cdeso796636f8f.0
        for <io-uring@vger.kernel.org>; Wed, 08 Oct 2025 05:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759926992; x=1760531792; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nx6oINGF5HKLwp7WkUz37F0BvYl4MRcOkRkrhp85qcw=;
        b=OnRBCKW3GKcxrg01gwZ4/alSTFjqM/Y5acdKPjkdgCtEK8MCi7DfcJB/et4TXtfXZF
         3Nm0epBTZe+STorWtLpUUNOPyoL90Lmol+ly+/qB0U4ZdeieO+e2U7L+Wwfwc3KiLejl
         eLBQUoVQeBFRCACfTE2yHj0bH614cEECJ1R5m48TMqfB/KDtav2hraCZ/CNzzIadA2cT
         4bBMvGSJiRxS48V9Lya9V4UbUD4ZpYN41E30xYA3T2QEf0dmHnoz8rB4y5vu4EgGYaqd
         amG71rHE6QB28bHIYmWQn+dc9I6OkTJxwOHyONaf5UYo3oFV2MdVAFCuNhqbJEj/XjfM
         bmug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759926992; x=1760531792;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nx6oINGF5HKLwp7WkUz37F0BvYl4MRcOkRkrhp85qcw=;
        b=aoDYC8CQTPAn3mUmzzY6QDTgklJ7dAvAFKaNzdDpl/OkQk83UlrcwYQRczLl80zl2l
         x6+mx1yAQcFNTcdZfCIvyz6UVdGoenLMnJB/0X2ybdVDa4fAzMvTisZ4DtA+YdNtxXmA
         Wrv+Fx7cPM1Xb0eI/pH8XsGGS2HdLhimw/vdnX0bQM9He6H8kDu/YBuKJedzgZIVDryw
         1/RTU8H9uqmZZtaSmI8hgeNV1YtHa0d7PJE1A78hF1Z93W0USQlrbA+eKRWqwl4agBDa
         RNeXD7pFy98Y8Zz85lH7Yh/uT2l10gkQHiRxlsQ63sJTLAU8lO2l/AtDDb3wKyLSqDgq
         4a0Q==
X-Gm-Message-State: AOJu0Yw1UXju9PFIDN8buJuSzW+VM2HJq+QIqAFO/bKWBVjpQWvJKbmM
	rPJwTD9kwEWhD+b029m5VWN5rDKZAfRk+Z8PebKpVQB3ytVJtsVBWYjr3rhj0g==
X-Gm-Gg: ASbGncsgFOOgImiAoBwZVlWpQRJhmx8nAmTH5ngbMG6s3uXxF/d10DPbKiklY+ZoN+S
	OaJqEI1oqgprnXLuzhq40e9Ymz5M3JV+ainZ96/I0cltlIZZeiIhy5YH07d2tYLpBQe5TS/c2Ng
	zri7hRlPRsagLew1CS/ihMA3eMm45B8sl1LfgYd0TphY66nksRYWOWHMknun9usTIIvPGavh/Jw
	2nN7jJU3c0RVPTu7SdCbvOmiHTfjvdxwDfnkOgOQUqU9ifrpoSLAJJZ71JiYUQI7DKdVk5/X4ii
	cKHAs9RlJUPkYRtvUUnBldzbvy7myrqSzy8dw76isGj8wfNvPZPvsbg03qNvCvs3hirKF4VGNPP
	cYuZXEoBd8dTY2NYTEXGmkmxvRSW9Dg==
X-Google-Smtp-Source: AGHT+IHBwzFZ1BAgN9wywEcc3pOtjkCY++l+dUBvhhk0BS+igZeRAbRPqebdxDb6FvFYFecs3sDC4A==
X-Received: by 2002:a05:6000:1f09:b0:425:86b1:113a with SMTP id ffacd0b85a97d-42586c057f2mr3631229f8f.16.1759926991884;
        Wed, 08 Oct 2025 05:36:31 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:b002])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8abe90sm29631170f8f.23.2025.10.08.05.36.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 05:36:30 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org,
	Matthias Jasny <matthiasjasny@gmail.com>
Subject: [PATCH 1/1] io_uring/zcrx: fix overshooting recv limit
Date: Wed,  8 Oct 2025 13:38:06 +0100
Message-ID: <b0441e746c0a840908ec3e3881f782b5e84aa6d3.1759914280.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's reported that sometimes a zcrx request can receive more than was
requested. It's caused by io_zcrx_recv_skb() adjusting desc->count for
all received buffers including frag lists, but then doing recursive
calls to process frag list skbs, which leads to desc->count double
accounting and underflow.

Reported-and-tested-by: Matthias Jasny <matthiasjasny@gmail.com>
Fixes: 6699ec9a23f85 ("io_uring/zcrx: add a read limit to recvzc requests")
Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 723e4266b91f..ef73440b605a 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -1236,12 +1236,16 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 
 		end = start + frag_iter->len;
 		if (offset < end) {
+			size_t count;
+
 			copy = end - offset;
 			if (copy > len)
 				copy = len;
 
 			off = offset - start;
+			count = desc->count;
 			ret = io_zcrx_recv_skb(desc, frag_iter, off, copy);
+			desc->count = count;
 			if (ret < 0)
 				goto out;
 
-- 
2.49.0


