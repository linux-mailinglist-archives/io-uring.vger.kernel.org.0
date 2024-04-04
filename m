Return-Path: <io-uring+bounces-1397-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02066899314
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 04:19:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6176D2833EA
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 02:19:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AB8E1095B;
	Fri,  5 Apr 2024 02:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MOMbDrJo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C484AB67E;
	Fri,  5 Apr 2024 02:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712283543; cv=none; b=BaD66s75Nob7oIYa8lKsurw/XJJ8NOpnpm3adGU6b50ElkaEHcLFHsZ3njidVI8WZMuc8yKLR8MigplL5CvldcQnWSgjjNVJJnzCzBUpRROeGtWwzFxyP/MrqzOOVwYEhLVCeo0gkeaLhHkEglgmtkFNFJTb7JqpJ+KWBPUKJV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712283543; c=relaxed/simple;
	bh=MdKz9HO/MEnCu98IZ9g57PWWEkBZ4g/hdCyy2WmbaM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TyidWuzMWMcqzppu3srfQms317Hu8RPQhc5rvrRu0aZ1wV74SL3b3ckooKXiXFMizmvPW6WVeLqya2+tyN9DRpsXrknrpabtEIIeTd76StEkIHGjuUCFa+Rsv2NQjMFKlyToiNlGTzuqKM2rKDvjwik5qbVWZ4710+tf0W8i1+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MOMbDrJo; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-78a5580324eso94374585a.3;
        Thu, 04 Apr 2024 19:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712283540; x=1712888340; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QrBxNOgOhwOoTM6st8k20/ILsbMyEoFne61a12r+YLw=;
        b=MOMbDrJozYvIsrCpBYWt/IjKLvkLr1WSz1EfGGMzRjRi0Px74J7mnaKCPxZSSoVSsX
         rexR7EdRZbsi0Wk3H9WzKlE2Ai5rXiAcOlqpFUzM2Eip2r3zfchSc/wzHF9atek6Mkj8
         EhbcdjbOk2U06/QDXN5PRqMh7FVyJq9FgbFf/ub5ETNaOBZQmnC1765Ihnn1+JRz+CTO
         0q6bOfok11nSUaRpbosF6fHigBjgds9iYPGSLO0IlCxxv10NElMo7lFpKRWQX/oPZ8Cy
         F57T5jH8n5TpWeEpO/yNtUqssrMuRohGfHqre7/a62/+ixOzDURaJtwm5Wef61W347mJ
         RMJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712283540; x=1712888340;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QrBxNOgOhwOoTM6st8k20/ILsbMyEoFne61a12r+YLw=;
        b=IacSuZGO8rLIwKQyGJqonntGi+r0FRfWckpNsDasfKTGBTIN2uoQv32YhVyHXFiKnY
         aYr/20OAq8HAWi5UfCq/IijS4rkvomy0VrJVAEw1qn+ARNrf7FXbuTknalfIXuLA4BeQ
         +RAbdtIT4YY0iZ5GhCKZSBTOfCP6cj23Im5QglRmz8TeU7Fd13nfyeIjhM9zGODzy3r9
         KIe7lTYl6nQ5yKGCDeHpZA1ALuB7ucpnfV2PbHsEVTFejnpDgALfFeMZ/s/pLCslwVzW
         38v52+wpkSQF5NP9izLCagSzllSrrdGCPbPq5FuzwqfPWpZV2rp3OOi4iKLh8WV+xGjm
         283Q==
X-Forwarded-Encrypted: i=1; AJvYcCX0mwazYVSDPV4fA5TYRmFRvaSqtRGkIPRzpZh2M5zdrRgGmxNy15TGsaT77q0PUjoqBi3IEh2los9r/Vx1loyDXbekE4MOFPKg/Cmjs3QgvoD+0Qjqd90carpWs04SgbndIAtmizvboYQNlak1iYMP1I4sHv03/tX/cxtusz1KgUUNGh8l
X-Gm-Message-State: AOJu0YzCxBCrxrdtWzSjh3S8/QFDqeG+s03r/NC8Ni5iEOQFQlGTAjjL
	BqtzpcfhiFKkS9v4E939ltQ9Y78E76Q2RHEWvRq6P5qgacy0MQ1M
X-Google-Smtp-Source: AGHT+IHkPd5B8LovJ0cyWAC2USRF0wUN7jGuq6K4BDdMroZ053FUDaivvQrXBMPx03zxifKFr/r7Og==
X-Received: by 2002:a05:620a:46a2:b0:78d:4337:a291 with SMTP id bq34-20020a05620a46a200b0078d4337a291mr240658qkb.12.1712283540710;
        Thu, 04 Apr 2024 19:19:00 -0700 (PDT)
Received: from localhost ([2601:8c:502:14f0:acdd:1182:de4a:7f88])
        by smtp.gmail.com with ESMTPSA id bk32-20020a05620a1a2000b00789ee7c9d2fsm260939qkb.109.2024.04.04.19.19.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Apr 2024 19:19:00 -0700 (PDT)
Date: Thu, 4 Apr 2024 18:19:01 -0400
From: Oliver Crumrine <ozlinuxc@gmail.com>
To: axboe@kernel.dk, asml.silence@gmail.com, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, shuah@kernel.org, 
	leitao@debian.org
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] io_uring: Add io_uring_peek_cqe to mini_liburing
Message-ID: <44916a6a3f94bfcff78da2c602c916c856d7cfcf.1712268605.git.ozlinuxc@gmail.com>
References: <cover.1712268605.git.ozlinuxc@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1712268605.git.ozlinuxc@gmail.com>

mini_liburing.h is used by the io_uring tests as a stand-in for
liburing. The next patch in this series needs the io_uring_peek_cqe
function, and I speculate that future tests will too, so add that here.

Please scrutinize this code, I am somewhat new to io_uring, and whilst I
have tested this and know it to work, I very well could've made a
mistake somewhere without noticing.

Signed-off-by: Oliver Crumrine <ozlinuxc@gmail.com>
---
 tools/include/io_uring/mini_liburing.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tools/include/io_uring/mini_liburing.h b/tools/include/io_uring/mini_liburing.h
index 9ccb16074eb5..94dcc7f9aa33 100644
--- a/tools/include/io_uring/mini_liburing.h
+++ b/tools/include/io_uring/mini_liburing.h
@@ -182,6 +182,24 @@ static inline int io_uring_wait_cqe(struct io_uring *ring,
 	return 0;
 }
 
+static inline int io_uring_peek_cqe(struct io_uring *ring,
+				    struct io_uring_cqe **cqe_ptr)
+{
+	struct io_uring_cq *cq = &ring->cq;
+	const unsigned int mask = *cq->kring_mask;
+	unsigned int head = *cq->khead;
+	unsigned int tail = *cq->ktail;
+
+	*cqe_ptr = NULL;
+
+	read_barrier();
+	if (head-tail) {
+		*cqe_ptr = &cq->cqes[head & mask];
+		return 0;
+	}
+	return -EAGAIN;
+}
+
 static inline int io_uring_submit(struct io_uring *ring)
 {
 	struct io_uring_sq *sq = &ring->sq;
-- 
2.44.0


