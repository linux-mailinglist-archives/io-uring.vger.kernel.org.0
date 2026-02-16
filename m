Return-Path: <io-uring+bounces-12272-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id XdENO+2Lk2mK6QEAu9opvQ
	(envelope-from <io-uring+bounces-12272-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 22:28:13 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 362EF147B5D
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 22:28:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5E030301C59D
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 21:28:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B5691465B4;
	Mon, 16 Feb 2026 21:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nNWNUctp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F735B21A
	for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 21:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771277290; cv=none; b=GPpd5YvybAiQm0Lxz4LELJB/XoYzWClDctf0Y8HaHz5pkozB9xoutJjAWXnfA7/yA6DcdkHkdmITNomJvcGfIC8GFrZUF1r1oC+ZcwCqRNAG26Qk8Aqq+z6PL2Zb8gXZip6zNMQviMCM6HaWH4IhsLUMqZ3Aqe44bRe9FguPgeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771277290; c=relaxed/simple;
	bh=DymJ7e+t+/xQnjp0musj+dX4d7giV4PWM8LZflKRvKM=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=SmdW0sAslm029yy0phtOK1obrZBanI9tXwA3/B3hlWL+bxtryIZpzasVOVQCj8e+8bctqs+jLim1fP6tRnCVcOLzOgLpQECpEHUCCk4jECDOvZPv5HpPArtfT5Cfwc1RiODNWVNrrVdNKcuTNvxJZr2WCcTS3Ew6Ss8NXlm/hBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nNWNUctp; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7d1890f7ee4so2114405a34.0
        for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 13:28:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771277286; x=1771882086; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8wfI4r3Rk1YEcKuUAam240f1d9R1LNzEuGsRscS0qrI=;
        b=nNWNUctpPvKK87SRKE2cYnwQnhA4ZvpXAn2YipyWTRMzw318uHwRe2w9HGfzOlyyz2
         clQ+nUxzwPAmoxdBLrzWOdLiy+qg12wa6alKdnbXYEslnanqS1NODOgBjGXGZ0GIzmga
         ZBMDWTYKzxW1pz+chNVBWj4ydn14pyrmMIX9QVVXsmiiSM2EX/rRkbFTHX4vLOzd6JCg
         SVfeSuOZ6c6rRVJD3YUIQyKX1/VcvR/qlwyP8ign8rh1FDk42fI+tNuLux09w3MynK8Q
         rFm0sNCMwVmhK79LkvfS0R084P06tzv/Lq+g7s9sSFVxNlvjUGf2op2by5ix7WD2iD3g
         VnQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771277286; x=1771882086;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8wfI4r3Rk1YEcKuUAam240f1d9R1LNzEuGsRscS0qrI=;
        b=q2OQcrWHMi0b7LWuBUlBFuABHbZCv0giJOjjutcauufeeMIWqMLk956Ud6Z5CqK6Ng
         t9c4y64RsdS+9ohX/2rrmxr+kCGdwNjICY0pF1mpwwI5833sgbXldTbmqevyolJAE0xS
         e5dql+IUuDSp7THg4dnXkCmjofQWKn+cm/tYsFAcDc0ahLDNMoEWEi0s8k05CKKPBvyc
         Au/fiMDkCpkJ05rAOw400uw9VVsS2modf+RRI+ofLudQMwgMQsBbhlTmsc6NDXRfdba/
         kfjPZdQ2htD2rfsurrdWgZwXqjMjHzfGFd/W040L3fQiafKL+6GANrWn0ptGIn0JClND
         xoGQ==
X-Gm-Message-State: AOJu0Yyq/sxYe/+Y8lbysq7d+GJa5fA+pJZdWw8Di0gpWexQp6tOy+kE
	+EjbWfr4eZQIkSrGxRu+ej367am9l1UC2w1XiASzbXuH5g0XUSPSkN/cyPxD8brTH3oS+KrXC1n
	FzcdHoUQ=
X-Gm-Gg: AZuq6aKcQa5eDVQGLzkF1v75zHu/3YBMLHAqhGaXMQ9sfxZ4aFYXK/aZYiDMFIBlqMk
	ZemQ8b7VO9cZ3GL1Qh5j9pypEU/IgXpQqqM83s4R5qqhTmC5vqE4abZMLVRDuVPlSuoauRfdi+7
	fJYomESvFmsEZyrWXOcsUXFm+Q5+CiWDjcVt5cDxJcK85D84PuMWVS2QW0741uCmfj9up/x9PBy
	sa5S5rAzR12fhLx9spfZFUnoxDdzXG8BC1WotGRVa98yvKEud+HPeGxsw8NrMsDLbwI3oxMcIsF
	n+6PRG52VmXVzw0z48A9UY8Ept6fZqNRgG2ofxVt3BgU5S9XFl4O/mWoyWJQ4OcGwAwcV1HcFRH
	FWqV8DnkF71QIn5axptFr2a1UjarukpzyyfQtJiB3HyJlTIwZGhhjgrNHpT+ZAiQKB7/+Na3ypM
	6/VqRzqUz/p8XxFW9Umlk+rm8X+hNshdUrGkCMandIMte5tCdphsE6zNPEiQmQKeB7qXkYy05GH
	QbYHy2oPg==
X-Received: by 2002:a05:6830:a90:b0:7c7:da3:ed27 with SMTP id 46e09a7af769-7d4c320366bmr6196013a34.35.1771277286386;
        Mon, 16 Feb 2026 13:28:06 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d4b99c978csm10430437a34.28.2026.02.16.13.28.05
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Feb 2026 13:28:05 -0800 (PST)
Message-ID: <4c1769d1-ae33-4c66-a74b-6f08844c7a02@kernel.dk>
Date: Mon, 16 Feb 2026 14:28:04 -0700
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
Subject: [PATCH] io_uring/cancel: de-unionize file and user_data in struct
 io_cancel_data
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-12272-lists,io-uring=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	DMARC_NA(0.00)[kernel.dk];
	TO_DN_ALL(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+]
X-Rspamd-Queue-Id: 362EF147B5D
X-Rspamd-Action: no action

By having them share the same space in struct io_cancel_data, it ends up
disallowing IORING_ASYNC_CANCEL_FD|IORING_ASYNC_CANCEL_USERDATA from
working. Eg you cannot match on both a file and user_data for
cancelation purposes. This obviously isn't a common use case as nobody
has reported this, but it does result in -ENOENT potentially being
returned when trying to match on both, rather than actually doing what
the API says it would.

Fixes: 4bf94615b888 ("io_uring: allow IORING_OP_ASYNC_CANCEL with 'fd' key")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/cancel.h b/io_uring/cancel.h
index 6783961ede1b..1b201a094303 100644
--- a/io_uring/cancel.h
+++ b/io_uring/cancel.h
@@ -6,10 +6,8 @@
 
 struct io_cancel_data {
 	struct io_ring_ctx *ctx;
-	union {
-		u64 data;
-		struct file *file;
-	};
+	u64 data;
+	struct file *file;
 	u8 opcode;
 	u32 flags;
 	int seq;

-- 
Jens Axboe


