Return-Path: <io-uring+bounces-12173-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uFITKLYAjWnAwwAAu9opvQ
	(envelope-from <io-uring+bounces-12173-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 23:20:38 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 14000128141
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 23:20:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0556030C2308
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 22:20:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2129242D70;
	Wed, 11 Feb 2026 22:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="e6/D0+jF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B2B29D297
	for <io-uring@vger.kernel.org>; Wed, 11 Feb 2026 22:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770848430; cv=none; b=l76fFlMECXBOLEiT8wRWhfdYJcctCKMsJn+VN945m9hXKZkdo9skZEemjpeO/X6ogeUFt84RJ5OGM7YZul0+/Uxoi8L2bYGOVz3+B6gD5cVRC9R4ZE40HDERHtPpn9uICcwra72Pvh3aFl5wsPKRODG4Le2w9j84pGOTiVVCga4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770848430; c=relaxed/simple;
	bh=dRMKb7kqf8aFSFp/aTDoP4V6IPxolWH93T9pwO2xwqM=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=Mxg0p+ySqQP+TpAqDjoMIU5aeS7fy9YPeR4I0Yyt0/JWMd4Eh0oWAXnyiWQL6/7tvyNtcCWmtCsGiB6BxmoLAszoSZQ7SYYDWM5OFIhBosGm/5/I9KEDKrEJy2UIQa+JYD9OhOinLwZTmIZW1Y5oMx90wN2VhC52gq412FVLaNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=e6/D0+jF; arc=none smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-409440b98b5so1533844fac.2
        for <io-uring@vger.kernel.org>; Wed, 11 Feb 2026 14:20:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770848427; x=1771453227; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FTme+33Rx/JZkozVBsbDemJ5bTWk/szGiL+MwExYtDQ=;
        b=e6/D0+jF72BKiNZrdvpEuRCIMpcjZq7PrWupJLKAAp7Hc5LyTIReRLvCcTWnoI1c2y
         8O+OnpwgKed1KGrAZ5ADSXlURosUp1AG5G8VGa45VbKpvt7HJK6Mkmr2yHm3c+XJuEKO
         WlO3BbHDsPC028GXnHP83uRmHTAwAMIL4+t6drvaRxseKed+81cL5VBbg9xw/BKkCSsW
         n4g65/JTI4fLGzfdPhSSh4hvPdv6tpKO6Xre4GqhN3cimGzfB9pDT5WH9qpFpSpwuHtC
         O0mBZqRAPZJCE7ULT0WepVYhnJIrJaAEeBa1K7Kc1IWZPT09M5QA83bkkdIsbAvLOWH/
         8ztw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770848427; x=1771453227;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FTme+33Rx/JZkozVBsbDemJ5bTWk/szGiL+MwExYtDQ=;
        b=LNi7GQKEhohIN5ZZwQBqRmnm3ftG+mGN5yOpqTP//tAiNGbDtkFVdKBEtYerULvWii
         JEWR3cyScmlbzGGdaEVHKwB+hUARNOf0BNrExwUYSZR8Ne4M6u2ujmebBl4b8VyeXQ8N
         hxTnR3+DQ+9sZY/zcDgy0NSPPY+efGygvX6ABl+nvZiLvxboQZLW4cXFpse9SQeRJb7R
         9Sh7+BXBiJgCnEo0kcsdsTSP6Kanb2lTEiAc0yYXOMwb0rS33udIo/MElMMGnO7zdD4h
         g/wV79NamJ0JbPOMbqrZtr5M0mJKmVgWRNG26NrxNftWqHcCIfixId/+vXQ4966lmb3Q
         lqsw==
X-Gm-Message-State: AOJu0YyuCsYrrlsYEDF72vPWgJY/ePfufGvIakvrY5N4YCcpPNlL/2UP
	fkBsM+yrbmfAbgJ0XE3NB7dcMNwpkYnn8+FwYU0OyzbpK4AiEXFj5jlA6aDdXraSkQdm5d7F+fK
	pq5Y2euM=
X-Gm-Gg: AZuq6aItGGm1We3RyBaOY7n+bVmJ9fHC7TtTDg6lAkTsdJsVXoCjOS1NDi9PPcMzTUQ
	WiERgOkLoumbcNW9zgLVdHgsOxbrrkXjcnGcL1VvIxAeZFIMs2aVaZ25+sZJoj9GrFZ9KZVeOEz
	eFZOPKquCCUn+B7RVjoVClBk5LnSKGLBMw2ota+6yGITZ+EV95ZGw9Gtk7IRoPokaUXI3mJ/zy6
	Q3h9e4RgwFj5dudj2fbZbMYogwinRAdMlmfoyW8pcNfPQZ2If3BwHyRhXsGCuoarTuefO0MGvNN
	422AUnXE6y6yZR6ST0DnwTOL/FdjwuUGZZT49g5m4qNjkCyYXO3EZf3tljVdRo7cG/OnimqKMhP
	1orKrRX0fQgCOEQx0C2iNVKZ3mdUFXDaKqf5DeLfgrCJqUMrYAl2/o8Z0cxPJ1aoFMTBo3b0Kin
	sDzWra6Hh76VPl97dZh2QY4kfAtyMm9kK2+P16Fmrqfw4qL7ZHTuDW8Gq8ZzrwA8OxM0JQP9WgG
	x32W/G6
X-Received: by 2002:a05:6820:450f:b0:65c:a528:bb6d with SMTP id 006d021491bc7-675db0569a2mr17138eaf.7.1770848427418;
        Wed, 11 Feb 2026 14:20:27 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-40eaf103ac3sm2197512fac.11.2026.02.11.14.20.26
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Feb 2026 14:20:26 -0800 (PST)
Message-ID: <5b00c809-04e7-4989-80f7-fd7ef21b3cab@kernel.dk>
Date: Wed, 11 Feb 2026 15:20:26 -0700
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
Subject: [PATCH] io_uring/openclose: fix io_pipe_fixed() slot tracking for
 specific slots
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_ALL(0.00)[];
	TAGGED_FROM(0.00)[bounces-12173-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid,kernel.dk:email]
X-Rspamd-Queue-Id: 14000128141
X-Rspamd-Action: no action

__io_fixed_fd_install() returns 0 on success for non-alloc mode (specific
slot), not the slot index. io_pipe_fixed() used this return value directly
as the slot index in fds[], which can cause the following issues the
reported values returned via copy_to_user() to be incorrect, or the
error path operating on the incorrect direct descriptor.

Fix by computing the actual 0-based slot index (slot - 1) for specific
slot mode, while preserving the existing behavior for auto-alloc mode
where __io_fixed_fd_install() already returns the allocated index.

Cc: stable@vger.kernel.org
Fixes: 53db8a71ecb4 ("io_uring: add support for IORING_OP_PIPE")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/openclose.c b/io_uring/openclose.c
index d617b421b1e6..c71242915dad 100644
--- a/io_uring/openclose.c
+++ b/io_uring/openclose.c
@@ -345,31 +345,34 @@ static int io_pipe_fixed(struct io_kiocb *req, struct file **files,
 {
 	struct io_pipe *p = io_kiocb_to_cmd(req, struct io_pipe);
 	struct io_ring_ctx *ctx = req->ctx;
+	bool alloc_slot;
 	int ret, fds[2] = { -1, -1 };
 	int slot = p->file_slot;
 
 	if (p->flags & O_CLOEXEC)
 		return -EINVAL;
 
+	alloc_slot = slot == IORING_FILE_INDEX_ALLOC;
+
 	io_ring_submit_lock(ctx, issue_flags);
 
 	ret = __io_fixed_fd_install(ctx, files[0], slot);
 	if (ret < 0)
 		goto err;
-	fds[0] = ret;
+	fds[0] = alloc_slot ? ret : slot - 1;
 	files[0] = NULL;
 
 	/*
 	 * If a specific slot is given, next one will be used for
 	 * the write side.
 	 */
-	if (slot != IORING_FILE_INDEX_ALLOC)
+	if (!alloc_slot)
 		slot++;
 
 	ret = __io_fixed_fd_install(ctx, files[1], slot);
 	if (ret < 0)
 		goto err;
-	fds[1] = ret;
+	fds[1] = alloc_slot ? ret : slot - 1;
 	files[1] = NULL;
 
 	io_ring_submit_unlock(ctx, issue_flags);

-- 
Jens Axboe


