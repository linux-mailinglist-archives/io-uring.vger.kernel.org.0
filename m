Return-Path: <io-uring+bounces-13173-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yDaIBaEj8mlmoQEAu9opvQ
	(envelope-from <io-uring+bounces-13173-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2026 17:28:33 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 970BA496E35
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2026 17:28:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9CFEA309085D
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2026 15:26:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A373B3806D6;
	Wed, 29 Apr 2026 15:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q//38A29"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCEED37E303
	for <io-uring@vger.kernel.org>; Wed, 29 Apr 2026 15:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777476388; cv=none; b=dPH4q/Stjq0aqYYSOj2UBzy0GMeygd5N/89DvnZvfGk+BNUm7Cq6KckNComKVfJHagi6/TrEoA/DR1EmHGVRLPoeBBy3YLZ42QpMLhspus7Tcjx2Uzs637BYeoZAai/Kl+BmYBJsqkQuGoKxUu7FEbaxllUAIj/KboyEcjnVdCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777476388; c=relaxed/simple;
	bh=dwXXUn2/AXYocQMBrxdXlK4QY//00n+FpUG8ksJYzZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D+3VkTwjj7CF3IPeUX2m9ey42NYHHWYPvYkof7/9snUEQ7AQpSY4SYPMCKuXBuZ0hQaxZOLUf7w4bBOLk64KFTw5dMi7AjusdR71z8ZBtFq7epC+osAfuFTmls5W+ARde0VCghM043QFJEv828Xb8jZPhy04Md9s2H8lvoV1X/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q//38A29; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-48374014a77so162933605e9.3
        for <io-uring@vger.kernel.org>; Wed, 29 Apr 2026 08:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777476383; x=1778081183; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bz5U140iikgjy9qkhQv9ANNAasoYi2fY/CedhAQlGZc=;
        b=Q//38A29BIyAwvgVfxuarwdkkCIkYkoEgnlCZ1ZWTVC9bBGBlbwjWMLO+PCyW3pZb3
         /pU/BZg1FEtUrImeH+eXGiGHqna2ZvIWgk+L6yR86y2B0VdaVlYkeMunR7khoFxE4S8J
         0FNUd76MGFcBRZ5OxoP4ajvEzZZMXCSTkGLykLqyP0Ab+gFIXaGbWxh2fVbPdhx2Z9ZJ
         KEn1sba+9jRPPUOBVsvW0+1xOMEdWejyHJKwKElkTfsdDWcEYtTzEgQw3k+6VtHwcQUk
         tNSQwq6YhbSfLlBF0fbYnD0bGUK6JS4s8nem1hUMV56iM3cdlycEqDt4GJcUEtO5p6XO
         1Mlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777476383; x=1778081183;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Bz5U140iikgjy9qkhQv9ANNAasoYi2fY/CedhAQlGZc=;
        b=j7yoGRhbUtP/LB9zXj44A07v7EBkYVxzX2liH0rcnIXb9S0Hks5xvc+JO/cK/Tqp/S
         FGFMxKovR078BLRUmzxawOs98KWVYYgrbi3VSM48rdIWtmzDNHxFNJ0AwjdVC5Wwo/IU
         b0mi1x/8bG+4kMdXXzmtG3geou4KmAlCN3jZbaRYwlHoayniF1nRIGHKOr3r0Gwtv9s5
         6LNRm+Zcl/45eN2gmLofJX6dnttqk7OB8qt0ROErOYJhuYEd+moWtpc+mMnZHbImXQYL
         BQqqLdrPlwoiqSag4NOeIcT3Rgb4HwCIcL95c7PHb5xZyQK7aFid6Zt1oCIp3Bb4x8Es
         CRjw==
X-Forwarded-Encrypted: i=1; AFNElJ/gmml/g9nDnw23ATPVEz3NRWgak9kXaenmJZaoJpmEiw6x7NQaOnCl9/6+jS9cyv0r5oWFt74NFQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzchg9TO+dijPP2OA6THLnjZjCX4D59LKn62rpFUGKP6k14ZyNF
	116Bafz8X+CLKNL6tJEyGyE8mzQtvvL6pSHT1JI/6P3Wo0n7aoR+Sf6e
X-Gm-Gg: AeBDievyiCx6+BQhkMniffj83r808T6IwI1BtlprZr7MRYCnJCS7hdDdpAB8f8mCqGp
	lKZ14od0pI3eX2ximKZWMJKMQvQraLQZzLzITEMJdQKiMiWmFoQ4t9qDZwJOsSQ1cZ1sWvImBXY
	2U8ll/jGztiTMZHYy53pXZK9Q3AzZlQn0DaAUfhIKFpJXiplZE6C4wgOP9uJrwyUJHnJVl+Tp8y
	vHKRz0ZdcIg5xZwUcY2ASrP4S9X0pTcIpUH/jRl/OtdW4AEPOpo5llgiZg35stl4N2U+ryEf6WP
	kQF99ztM4heZ1gwR9TMbxVuptjlr/Twl+NpSq227BnEWt0qAJZgIC3seG1R7KimUjiVFQCxYOlG
	qK+EdHg/L10VtorldfAi/JiMNLcRyio3asE4qrTmLNR+soxq8EYPhPgfBtNSBP9kefATNeeYUAe
	F+NpwNTgYJfQCADkH0zdwBv+nFkvaAt7B680T+yTnj2KOUi5+iLaiaiyq74I3foua2G22ROOpW8
	kNGAFMjgNewpXu4Kqgi46mFHTXlndzGfORz+QVWhvtR
X-Received: by 2002:a05:600c:3b13:b0:48a:52ee:5776 with SMTP id 5b1f17b1804b1-48a77ae049fmr129049305e9.11.1777476382406;
        Wed, 29 Apr 2026 08:26:22 -0700 (PDT)
Received: from 127.0.0.1localhost ([82.132.184.31])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-447b76e5c22sm6382951f8f.28.2026.04.29.08.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 08:26:21 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org
Cc: asml.silence@gmail.com,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Tushar Gohad <tushar.gohad@intel.com>,
	William Power <william.power@intel.com>,
	Phil Cayton <phil.cayton@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v3 01/10] file: add callback for creating long-term dmabuf maps
Date: Wed, 29 Apr 2026 16:25:47 +0100
Message-ID: <ae941457cf6cacb9d4c16b6ec904da9ef7fed97f.1777475843.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1777475843.git.asml.silence@gmail.com>
References: <cover.1777475843.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 970BA496E35
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[25];
	FREEMAIL_CC(0.00)[gmail.com,samsung.com,intel.com,nvidia.com];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13173-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]

Introduce a new file callback that allows creating long-term dma
mapping. All necessary information together with a dmabuf will be passed
in the second argument of type struct io_dmabuf_token, which will be
defined in following patches.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/fs.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index b5b01bb22d12..c5558aab4628 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1920,6 +1920,7 @@ struct dir_context {
 
 struct io_uring_cmd;
 struct offset_ctx;
+struct io_dmabuf_token;
 
 typedef unsigned int __bitwise fop_flags_t;
 
@@ -1967,6 +1968,7 @@ struct file_operations {
 	int (*uring_cmd_iopoll)(struct io_uring_cmd *, struct io_comp_batch *,
 				unsigned int poll_flags);
 	int (*mmap_prepare)(struct vm_area_desc *);
+	int (*create_dmabuf_token)(struct file *, struct io_dmabuf_token *);
 } __randomize_layout;
 
 /* Supports async buffered reads */
-- 
2.53.0


