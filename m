Return-Path: <io-uring+bounces-10592-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A540C574DD
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 13:00:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BD5174E538F
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 12:00:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B818E34DCF9;
	Thu, 13 Nov 2025 12:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IFMnNRjC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D6134DB72
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 12:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763035205; cv=none; b=cOYjZxc5D0czocLg1XqcuRQqD2KVj2XUG0OfJb7P4Y1rSPVUVqicxz+9TQ0fP7lETKpgupifeYPndEUdQSE2f2C30QoXe7fSLX/JbZ6fSyj9JR4qJaU3x5JWicfcVoHwZki9H7CEhdZWg+YrXf2bOk67EENq1nd0uIZUT9+FdNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763035205; c=relaxed/simple;
	bh=NuPVeBpIgMJbCPHy1nB+C+KK2Ihhwit2cisQySbMmis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EEVJcmootLqnzSK1NU0lQvUJcH0TqtjZG/rq0rX+x/wKQst97HgjpoiYgbqtlMIRcFtnf1xrCbfysc01vDJUr70XFv/wnE/JJypxpjXjBasYzui+0MoGXUU29WoTqKkPQ53vdGR67jcCYcbNQTLKgf+2QGAuv+8KjTLGxci7KQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IFMnNRjC; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-429c82bf86bso420546f8f.1
        for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 04:00:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763035202; x=1763640002; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KNaBbr/XtlIiT+NLq77AUPGmpuV38YzGOAG+CRYuLKc=;
        b=IFMnNRjC6HPN6vR4tnsC/G/uwhYmTI4TxbL4zkL/jm1mQ1AIeGfpMrptC9UN13cLAA
         SStzzYX3gnE7rPR9DwOufS59axzz24xlm2h4S9uLoVvCPSKlylr1Aj6jR2nwryls9Ljj
         UdZLNZnfN/y6zgGiKPx35eJw6T/CWjRctIjHPpELxjm9vACwLwbOAjjelr6Z0Bo4aaEz
         fu9iaSFyfb++EuG0p6zA2tN8DZ36Z6dHuUh0k0VzoLhuctK1oMKcA4fjYwiXDjnbRk2V
         g+CdQuDDYAoqwiCgpj7Rh1xo9EzSJFCB0r9U5Up02Fz30Gf6Y4GISlRUz+dg0LF4wEIe
         b8jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763035202; x=1763640002;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KNaBbr/XtlIiT+NLq77AUPGmpuV38YzGOAG+CRYuLKc=;
        b=FOH5BnsttOkzySneZpoyRuRj2/KjruRIygwuOHO8m0U4q1SKXPPZDCz/g3NxTxtZ4E
         6e6etSgbCrJ/teG+9+Hg6Wnh8Og5dQtUoysN7LLhHGp1o7GEHnjWIJGSHrQuDLO8OyWf
         9oOCsOE5zZ8DwweLzaIDkhw4c90VG7GcskJZw4q/aOHjo+fWsCMVC1925Y+DEWFY7tp8
         RfoHsSpKTXHwDMSFIe/EGUPhfmMpkbqPxW7YDzIEF2llem794LfptKtdxkYJR4ZZpRHq
         gxoP1gVLVWpZqZMH/zuOAFPQJbrwauEeyIrZFJr+fwVGKCMblUGHXuM/zYlHRRyJcXHV
         Mhcg==
X-Gm-Message-State: AOJu0Yzp3fQFbO8NX+Y5FrkySo2SkhCubpnf6ph2mruamki2dKne2AXw
	9y8lUN6X7kAfsuyXcpLanc8fKISUHk6TUQPL/cKLOzR1Krghva6b89525fZpnA==
X-Gm-Gg: ASbGncu2K05GVdIg/nQ5aNUGOvfroXTrz5MQqEWYIzEMgx0rBq9dEMWvLzgA6mhaRZm
	WHNYpV0BGuoP4q5k+C5G4k8j3lAEbTjPWulY+tEJoSEGqpN9PcWw2LipTTJEfJOUQ4OWwutmmZb
	7hvwSZHy3mdcFzy3eyShyIvmlK9Om+4rQQODS7XufU9LwyEBLKaS3n8UCxD1dccPKL1SEtaXLA/
	cdYmy8vAxWPc2BAvG0EdRwMAou/PjURkfCLLb2GmpyfweVvp1bJCNL0eVkG9h8pSv3ZGuttZtkh
	YrngWtykauWSdc+UtoKEAnc05aihXjq3QXN0hR7+L8Tt7YtzF/g8iNkJiIgVLXXIqzo6u/hfj39
	aeZZOF1ofo0ZcFMxQojf7cRrcYyo/382+PeLHgrXxHmwRhMG1/jiuDJ1ybezLi0ZoQkumUQ==
X-Google-Smtp-Source: AGHT+IF8iVXD9HR9QtpQlWDU7ba/vhpe1Nss63SkOgo4tmW2okffTGV5lJ/DLP2CS3sCEs60xbpyxQ==
X-Received: by 2002:a5d:5d12:0:b0:42b:3661:304a with SMTP id ffacd0b85a97d-42b4bdaf273mr6874188f8f.38.1763035201829;
        Thu, 13 Nov 2025 04:00:01 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:6794])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53e85e6fsm3686816f8f.18.2025.11.13.04.00.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 04:00:01 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	Martin KaFai Lau <martin.lau@linux.dev>,
	bpf@vger.kernel.org,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	ming.lei@redhat.com
Subject: [PATCH v3 02/10] io_uring: simplify io_cqring_wait_schedule results
Date: Thu, 13 Nov 2025 11:59:39 +0000
Message-ID: <76d1a38a13dab5820891c44bf32d13ca7e3196f1.1763031077.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1763031077.git.asml.silence@gmail.com>
References: <cover.1763031077.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The io_cqring_wait_schedule() caller don't differentiate between the
helper returning 0 and 1, so simplify it and return 0 in both cases.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3eb4c9200bb2..b26c2a0a0295 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2607,11 +2607,11 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 					  ktime_t start_time)
 {
 	if (unlikely(READ_ONCE(ctx->check_cq)))
-		return 1;
+		return 0;
 	if (unlikely(io_local_work_pending(ctx)))
-		return 1;
+		return 0;
 	if (unlikely(task_work_pending(current)))
-		return 1;
+		return 0;
 	if (unlikely(task_sigpending(current)))
 		return -EINTR;
 	if (unlikely(io_should_wake(iowq)))
-- 
2.49.0


