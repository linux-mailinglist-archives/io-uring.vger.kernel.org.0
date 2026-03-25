Return-Path: <io-uring+bounces-12858-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2GPgCxLmw2lvugQAu9opvQ
	(envelope-from <io-uring+bounces-12858-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2026 14:41:38 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 387D4325F94
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2026 14:41:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5E7D530DD326
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2026 13:10:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FA283D9037;
	Wed, 25 Mar 2026 13:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CpukFqKS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D593D9DC4
	for <io-uring@vger.kernel.org>; Wed, 25 Mar 2026 13:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774444165; cv=none; b=ZWqYaPoN8mrHFShrZspc99n1w1/VCXa5h1VGHVY53TezFGouCJ5d3FfCoWL83ZBYgKMicPo7eMhHgbzORCaJWZOiv1DCkfv7kdWeI5DAXPwPZPRt9Z/w/7z1pUG6A6C3snHVvdeQfH/w9wWHWekGvD1ZAMMUkTrKJ0sPHykqvq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774444165; c=relaxed/simple;
	bh=myU71HvPlH+tua7C7irZrMYkDHJZVMRXKhIgm4Zf60w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sT3dnuvOEmu1iZhVNBR/imPLHy7e3eQqyFMvDMaMYoQvhJWgJhToXXTHX7kkwVvrk1d07ujKo55sU/WrBQB4xk28PsJ5a9FKDgbSsohsxvBJNxAXUXryN2D04hON9FyvG/kj7Ujb4Wp8sotOgKqb/W+8WaiijejUnmnbgPAXPMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CpukFqKS; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4852e9ca034so47697665e9.2
        for <io-uring@vger.kernel.org>; Wed, 25 Mar 2026 06:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774444162; x=1775048962; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lhJtq23YXlExKR4zSWdcdWFcbRO5WZ5uUMn9Pgs/3DA=;
        b=CpukFqKS7+5DJeXI1x1q0sV5WDl9yYoLB7SGNSumeapT33WnrmcCzEyF2wkJ/CpwLP
         lofbq5AlPaXSt65pzEH2Mc2klNAiJm6JeQxsgV5vQMX0Fgz5eE6Vf66kKx3M8pXmF0tc
         9WH3rFg6cRtoE0WnqlfmpgyH4Pg0G4wkQDE+olZDEqENDsKK6tJ2hWq18XOIATXbL0GX
         SXHnXvA80JfJYO5MtfvwooOljK9zBTmYn32TuqpjcbrzIG+KEuazPUMbPAaQ8Mb3gvN4
         BG5mHpfEUbuaS+/CSOjn1wsU8FUwKPMTumT/qfHIF0qKdL/jOgLX0EeebR55i+y4qOvl
         CL1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774444162; x=1775048962;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lhJtq23YXlExKR4zSWdcdWFcbRO5WZ5uUMn9Pgs/3DA=;
        b=ZJCroOjXLANyDNtwvkzCO4c/mFZSA0PqaNjxxVj5oOk37HGZ1wWcSHaGIaHIMy8iJG
         kB3cCs5HyE6oD+r6maXqVRbxLyLARMvXCUwkSlNYxiyrMCNI8+ELUUMU78h3cn6LiAiE
         Z4QgtnLtIkSLV9V+Tuug9LDXEAuV1NwfyiP0XUdId4+Mlj6BxdmGOsU+mNui6IKb9ZlT
         p7/OoeFJtnR5yhA/F6UwUqZMC7CmPBpCZIHpqOgMoRrh9oGBZTfvg+8rGnclt94G2djD
         7ge9JiD71LWO5XEdc4MXOUy91avt69XAHDvZVKra4y2VsWWacobGljS4vOlpmDsN5dAM
         MAFw==
X-Gm-Message-State: AOJu0YyXhRUOFT4CefQ/+3nj20thhtnz6gv0L250gXQhfRq5OM/yqtV+
	kKZuX9Z0wpQzdRFXarjIegHs5v2qVmowc7JZWoV6XqTrzgP9+ttxk5Cdfx+6yw==
X-Gm-Gg: ATEYQzxWVMiJVl4AzIpn/+wd7ET6qa4gO7CJwt2rfQgizqId04ePWn1JRzoRtGdzAQ/
	VszKuQqBPbO0oumPC/kyUTd0UsnsH6ELcV8oRVZNZs9fTNJIVgVxDKlSwVtwGgXPUXuREPDzAIi
	/QJWz4py8XMBXE1GAj9JdJi4VXenBX3dHT3Pcaone+tjaSVz7fnpsKwF6STwosucsEGT9IF3aSm
	/WLrXn84wUCEGE6SThfJ3zr9N288+ZuD2NS/Ha/Svu/T8KHJQvcGU13s2Y0mz+/4RXW6rOtYnWS
	4YOm77+v1k6LobyO0LIR5CcJ/LWnX35UVYoZxH7mwE1HIsVDjhh0ZhTUPsSioqtmTl1tk/EPCtg
	h2YggWrhRlxhSlpXT+/MsR6Fnfv8s7H5IJxrQRHHTBsmkX04nwKJqIWUByQCHQPiHBqF/qz/Gm4
	77Aza5LRT/vO83cpsdeC5P1XTuVkyyxfKJKthhEpxfIPF6QHkMnvQxlkyALs4tUAbfEPyZxa5cz
	2X8In7GVA==
X-Received: by 2002:a05:600c:3516:b0:485:3bc7:a231 with SMTP id 5b1f17b1804b1-48716084829mr54679745e9.29.1774444161726;
        Wed, 25 Mar 2026 06:09:21 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:8126])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b644bd923sm54062611f8f.12.2026.03.25.06.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 06:09:21 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring-7.1 v2 4/5] io_uring/zcrx: use dma_len for chunk size calculation
Date: Wed, 25 Mar 2026 13:09:21 +0000
Message-ID: <fa3e05e80b41664c5cf0af5e1658bc761dda59be.1774444007.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774444007.git.asml.silence@gmail.com>
References: <cover.1774444007.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12858-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 387D4325F94
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Buffers are now dma-mapped earlier and we can sg_dma_len(), otherwise,
since it's walking with for_each_sgtable_dma_sg(), it might wrongfully
reject some configurations. As a bonus, it'd now be able to use larger
chunks if dma addresses are coalesced e.g by iommu.

Fixes: 8c0cab0b7bf76 ("always dma map in advance")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index d9174cb31a44..e1d2e1f1b766 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -63,7 +63,7 @@ static int io_area_max_shift(struct io_zcrx_mem *mem)
 	unsigned i;
 
 	for_each_sgtable_dma_sg(sgt, sg, i)
-		shift = min(shift, __ffs(sg->length));
+		shift = min(shift, __ffs(sg_dma_len(sg)));
 	return shift;
 }
 
-- 
2.53.0


