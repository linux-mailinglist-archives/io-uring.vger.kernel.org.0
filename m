Return-Path: <io-uring+bounces-2903-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AFE7095C0CE
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 00:22:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EDA39B2329A
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 22:22:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FC201D1728;
	Thu, 22 Aug 2024 22:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xhS+aATn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2987D1D0DF2
	for <io-uring@vger.kernel.org>; Thu, 22 Aug 2024 22:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724365287; cv=none; b=iP5S6b+iKpiEyIVDPWvHxvfkfgOTMANu/Wq8QIM0irKvNwZ6bCP/VE/rSCwyWBRnmJiCIykVqP3BzzDzAG+svmTxD8fW3PBg+bXVgkAob7oix1h7A4X9DjQfCdkPHHMSU7z95sMZDVdHxEk79L/7N/rBtY9DWyHzSI9w181YW4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724365287; c=relaxed/simple;
	bh=j8RDWl/MUW9jSpqRoo/6uv4ikq6fPGI3FhR30VRxn9U=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=OFn77eKFhu4kbk4A4WeZQEcFot85DSf+DtrsNn89PGbz7ew8NkkKF6uYNMmAvWzj1GZydwSrjlf87caW+85PLLUU4IdSf7f1BTWLdfuBOXD7xmOGQjEz2v8DshVj4pFES6WY+VrfwaJHn3+auHffUaAlIJS5kDobVQyK5AkArd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xhS+aATn; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-7c3d9a5e050so964241a12.2
        for <io-uring@vger.kernel.org>; Thu, 22 Aug 2024 15:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724365281; x=1724970081; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t92z2/CRXinBKFyyoX01nV8Fbp2TSnPxtNZsBrfXelc=;
        b=xhS+aATns936FGLZPirj2bKccXRpBK9/6mQmLTyKlIh/nU1ag2NkpLmgtvI9oV8j7H
         L5eIQIZE8Vk+BvoF1iIaOPcG8k3v0LTTO0RmERlPK1lslltzPrzqik7wXbx0dgfV3qyW
         tv+EOdI8Gf5c8VPUUO0JKJX1Lc1tvGV0RNXRuuDDt8F40EEJXNPrGUV5Zn17SsbibEEb
         BXZslb6kjBta3Qdy3FzkCIB0sKqKn6fgpG7Vo2Y7lwBPCTdhIVSa334aX1mBwntuZakn
         oI4Np3Ur5X68/PDKgPDqvFuJp4IMsuogRRlcT8QYCXah6kEkIgV6KstHiyP0Vf5TkYyW
         oV+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724365281; x=1724970081;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=t92z2/CRXinBKFyyoX01nV8Fbp2TSnPxtNZsBrfXelc=;
        b=pTtvGmUrMIiQJoGcqJH7lWEwQBB+v2K4IvWTlu5OzPOjduSIJg1R7pxBBJlAQsssEY
         SD60kS4TX7QiaQjbOlPDWw4kaAhhKtjbKLpsCdzVcLj4V0TuUmaj912I0euvuCSS2077
         T96Yl8nyOnOu+qAbBVb3KvZ84/w4JljyP020z3pzjeqn7G8LYvNvFRV8Pm26uS36SNBf
         AEILywTCfXEi2ULlJmXf0ZBrS8WEHC+8+aHjKVo2JsX/V5qBRx1SmldYHNETSTEBE5vo
         NARE0XQ3q60IHnx3pzWqiHhrNhAtlkRb7h/8FTlnuVgjbMW0/bKneOrYIVCDD8CoHGb0
         kstw==
X-Gm-Message-State: AOJu0YyHEV5vxNLk0HV9bKR9OhdFhSbKcxVs0bq+nz6gs8rQ3247iq3g
	rpGWoV0wxFDETmdigcIkvxMHFLB2itQQ1h300DmO5T813nr3g8z5v3876cYCm0Nla/vJL+8QrSc
	r
X-Google-Smtp-Source: AGHT+IGIyaRyLaKMdN9FR5VAZM9hLP7m8xRCmVymn7gRx44B1ihodzg+ezRuXPF+M7YO9qblIw0DgA==
X-Received: by 2002:a05:6a21:1304:b0:1c3:cfc2:2b1f with SMTP id adf61e73a8af0-1cc8a10db5dmr596848637.37.1724365281306;
        Thu, 22 Aug 2024 15:21:21 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-203855664c1sm17367295ad.3.2024.08.22.15.21.20
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Aug 2024 15:21:20 -0700 (PDT)
Message-ID: <c25950aa-416c-47ab-b889-113d73013cf5@kernel.dk>
Date: Thu, 22 Aug 2024 16:21:19 -0600
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
Subject: [PATCH] io_uring/kbuf: sanitize peek buffer setup
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Harden the buffer peeking a bit, by adding a sanity check for it having
a valid size. Outside of that, arg->max_len is a size_t, though it's
only ever set to a 32-bit value (as it's governed by MAX_RW_COUNT).
Bump our needed check to a size_t so we know it fits. Finally, cap the
calculated needed iov value to the PEEK_MAX_IMPORT, which is the
maximum number of segments that should be peeked.

Fixes: 35c8711c8fc4 ("io_uring/kbuf: add helpers for getting/peeking multiple buffers")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index c95dc1736dd9..1af2bd56af44 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -218,10 +218,13 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 
 	buf = io_ring_head_to_buf(br, head, bl->mask);
 	if (arg->max_len) {
-		int needed;
+		u32 len = READ_ONCE(buf->len);
+		size_t needed;
 
-		needed = (arg->max_len + buf->len - 1) / buf->len;
-		needed = min(needed, PEEK_MAX_IMPORT);
+		if (unlikely(!len))
+			return -ENOBUFS;
+		needed = (arg->max_len + len - 1) / len;
+		needed = min_not_zero(needed, (size_t) PEEK_MAX_IMPORT);
 		if (nr_avail > needed)
 			nr_avail = needed;
 	}

-- 
Jens Axboe


