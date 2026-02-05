Return-Path: <io-uring+bounces-12054-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2MmlEqq6hGnG4wMAu9opvQ
	(envelope-from <io-uring+bounces-12054-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 05 Feb 2026 16:43:38 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B3EF6F4B4F
	for <lists+io-uring@lfdr.de>; Thu, 05 Feb 2026 16:43:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AD28E3009017
	for <lists+io-uring@lfdr.de>; Thu,  5 Feb 2026 15:43:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB26F421F1B;
	Thu,  5 Feb 2026 15:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CNmLq8hf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EC33E958A
	for <io-uring@vger.kernel.org>; Thu,  5 Feb 2026 15:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770306214; cv=none; b=s1+SC5Uyc2Tou3TmESoZ79/6hBIzOrrubYJKPXS2ctsP3F0LZnSgwl+9SkS1W6E4NCfpA06sm+oy/xjtIvpGw9LVFMQIiPAAuUkOuOKqrOEOexdpOZHpTchfIQb7E+0glcWUDZlc3DpYpiL0fmn9Jg3fZPX7BVWbtZm4ELcnRuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770306214; c=relaxed/simple;
	bh=oZWSq0Ayo4/1wzgGLMHmEtH9azBvu59UI8U57uQQSTU=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=tT56G1XmBWs/8I60U6WSEInmvcatLvK6hvsBtvH3bPb7muO8M+Na4Rw6uLCkE7QNIHY2/ZYHg9Gd2jX/8e1L/h9ezzyTWN1r1MedSuicZrruECH3RmP+yi5CL02MIVI/BOz41lwZ8x8hWan6FO5KgU1z7kdcf4wNirD5V93HDOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CNmLq8hf; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7d196a2334fso872674a34.1
        for <io-uring@vger.kernel.org>; Thu, 05 Feb 2026 07:43:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770306212; x=1770911012; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nMXbApU5/TWRDmasnITz2fHk+gIP7eQ9o492rS0rXXw=;
        b=CNmLq8hftbs6/91wHFetjyJ+o8Jv6gqy8nB/gEsl4bJN18/92dupGEf69FV/rlvblr
         wKsvfnU8dDdt4E3L1wIgcjCwrPfu9RAF2DwA76UVERMCjNDCEkMm8u9R5SZbotSljDWr
         FRJ2qIxyFLIuAEW2sCGXHpityFOI+NJabzm76J1nuSEp/GPPiiiaeix4xJjnd0vMYL9f
         dQu03yBhOUoE/MJXpAWQ6QL19aCkhYR7uYKKq6GV7M/9NGf7c/uvxZZgr8umiLtCONm5
         mu8yroVNJtuIHY0E5pTt1yUlyfy+q/THpJm1oWMxhx8FDs0KFOptBNeEHYtg3gNkJPCc
         br9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770306212; x=1770911012;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nMXbApU5/TWRDmasnITz2fHk+gIP7eQ9o492rS0rXXw=;
        b=gXnmG5NO+6Kblz2T29JLrdLwwUvJbJNOVm7TpP1rDvOXq/Z8Do5voLvA1Y45M4nj21
         /pdPaAZy6od8U0er4AKTXauzv2h8s0pn9K2BvW792+9F2/lg80A4JupY87xEYc/S7SUI
         fbCTBsL+Th5rKAPqwUZMpF8Q2NwI4BDpoRLDweVYWWMG0N3xqEvwsy/6yQP0IPP0YKi0
         jbTMl4m52u5drQyod4rkfvYkiHfO7ih9eUshJ2aYjA2n1zZLkqjyUnyCRY5FN+NhujOF
         g96tHPVavSm+T+K2eybyLJ3GDh0z9tun7i0C+cZ6w0U0D4g+37XitEeK+5u/8mAZsXX5
         oxwg==
X-Gm-Message-State: AOJu0YwR571Bmtm11CKKq9PYvlqJVTWnJ+JaSBcQ4GEWkQNIURC+mvhh
	vXHVJcMQgx7hBxZN3Q98FU+RZbrtPAl0Jy0g/gZ2jXlMtRudaoy//bCADDgaqx8ioSt/5d97k/U
	cXrJvxNE=
X-Gm-Gg: AZuq6aJ5Ok2m2B1Yj9V2FbmHV3WpI/wwfKPa8oBdYaGEK26dO5tldYx94TlVcHRTcVb
	IP1rCJeTwLvjlkag39vMz8c2ga86ukxydEjvbtkHPrj1pU0gToisyRG15kHPG7y5hI9E4x0KqIY
	O8CQ2WQyJzAdINJo/JZoOz7rE7aizFnhbszkG2LEX3itspC4eDmPugsO8iM4fcYqECDO2CxKJ9a
	0QKNIFeXFbuIzleDPlDzNjgfzjVmu7xd/oT2WehtQ1uXBNgybzaLYyOppZG0Aw1E4p6LcwX/7ZV
	nd+op7dFxwKu0rOqAkgYxZRSGG1jdZ2sx7pypOHjFXs7tkJW+1AhOUGJSoeTMSfV4k1f7XLlzYf
	isA8/pnbAoSlHvxf8hogpjvqkhb/IKm9SPtiV9rNa/3GY0Z3aB3qs4K5p8NMq/yYQzku/kFDXyN
	wROMXyI72xWd9x6zvGh6dHnzkH+v+qN3yy5lq/Cn1w+2T14axrXyfdQg/jTi9SRLlCGjNAkA==
X-Received: by 2002:a05:6830:2aa6:b0:7c7:1a6:6a09 with SMTP id 46e09a7af769-7d4570ce525mr1836213a34.17.1770306212408;
        Thu, 05 Feb 2026 07:43:32 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d4490f3c06sm3835875a34.2.2026.02.05.07.43.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Feb 2026 07:43:31 -0800 (PST)
Message-ID: <9f658484-0a25-49a1-ae27-d2ffa0f3132f@kernel.dk>
Date: Thu, 5 Feb 2026 08:43:31 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/kbuf: fix memory leak if io_buffer_add_list fails
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[gmail.com];
	RCPT_COUNT_TWO(0.00)[2];
	TAGGED_FROM(0.00)[bounces-12054-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	TO_DN_ALL(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B3EF6F4B4F
X-Rspamd-Action: no action

io_register_pbuf_ring() ignores the return value of io_buffer_add_list(),
which can fail if xa_store() returns an error (e.g., -ENOMEM). When this
happens, the function returns 0 (success) to the caller, but the
io_buffer_list structure is neither added to the xarray nor freed.

In practice this requires failure injection to hit, hence not a real
issue. But it should get fixed up none the less.

Fixes: ef62de3c4ad5 ("io_uring/kbuf: use region api for pbuf rings")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 796d131107dd..67d4fe576473 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -669,8 +669,9 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	bl->buf_ring = br;
 	if (reg.flags & IOU_PBUF_RING_INC)
 		bl->flags |= IOBL_INC;
-	io_buffer_add_list(ctx, bl, reg.bgid);
-	return 0;
+	ret = io_buffer_add_list(ctx, bl, reg.bgid);
+	if (!ret)
+		return 0;
 fail:
 	io_free_region(ctx->user, &bl->region);
 	kfree(bl);

-- 
Jens Axboe


