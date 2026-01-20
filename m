Return-Path: <io-uring+bounces-11841-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YEUQNvHNb2mgMQAAu9opvQ
	(envelope-from <io-uring+bounces-11841-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 19:48:17 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 50C4049C48
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 19:48:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 977A3A280E1
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 17:00:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9426D3233EA;
	Tue, 20 Jan 2026 16:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="tMsxuUDZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D1B320CA3
	for <io-uring@vger.kernel.org>; Tue, 20 Jan 2026 16:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768928259; cv=none; b=WnVs4t/2b8qGDcczum4TZutg3G/TCjQbX/bcTDcUWPFBvIzg3KJr4ONiN0oZd+EanJOW3knj8QHvqpOidkBToehCv1MBHETX7Q1dF0lFWtZcHDC859qa2dsqufE4Dr5i+54bcdLc/nMOaYlkONznellZ+vCEV1d9V5k/GDUfY5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768928259; c=relaxed/simple;
	bh=Xr9aZoU+bdKamHRiCyKDaCOtMWJcq/m23w+fbYBzk50=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=CIWV0bosaEufL6caSMvV8E76dkIpTE8wcH4a9oFsXMBfD9PKsu1JTzLA4ANBkQ8QhZmjsC6BZTp5oA26zGD0HozPfA+Jwpil8/NQzheKnCdSBZcNmNUZ9yJpaRgAvoA+CF3lLA0tSox9zbNVuRLN5moH1/6jjaNGarzqhUAGliw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=tMsxuUDZ; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-45c7400259bso2103263b6e.3
        for <io-uring@vger.kernel.org>; Tue, 20 Jan 2026 08:57:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768928255; x=1769533055; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t3NUL5cq0XWWxQhoC9j/1hjWyGWvHVhTW5NY0JROu+k=;
        b=tMsxuUDZHfiRblCOkFY6oHU3BJJqLC7Ot/pEHRdnvcnGzpZE571bJZ1FJ5EEC1gb+D
         lID54rJYb0W7ohxtYUQMpLIGliNdbjpUFeqroVNii4QQmvEVar+vXA+Ee4Nrb6HYuwiE
         x/EO/NLSJRhf+I8MvoOzBJU7t+yp7zcV/cv9auMG5UhuuPm/Wfb4pWUDw2sg5ZzTWdGl
         raanMnuQcPsINsnus9DD5J+UZImFszJMlA1SR/cOWlw9ECCO8aPu0HJr/50uvtViZyxD
         DiY164Vs8vHDPfyfmLrzG+1bef5GBYSLvK19pIwoFFys5DkDLQ/0MkWMeRQqbPRXTbbu
         xMtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768928255; x=1769533055;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=t3NUL5cq0XWWxQhoC9j/1hjWyGWvHVhTW5NY0JROu+k=;
        b=vrYjIQwF8tWDeQkSle8GQsNWKfNM44ZiOaCeScjOmAShsoTd+swG+HTF53PJya0A14
         ky4a8hW83B5YE+8Nr83FDro78GLwzwV4tal7VWU6Jd8xftK6Zaxe+fdswJRyF0127bAn
         egf0UJhrd5nUf8H7+PpQUA/bix8UjO9UmkcZpCK3+qIq3cWYIiJKaGAC8JEZY1koPBhq
         fny0jtYSBDyJrJudbl6R/Qr3CwYl2GRsKFWmCI1K28Dbtkm4sDAEMCMf72BoIxPnPGeJ
         BziwnPLSnACuNTxh7aolH0y28hCz/e9yjazdW08rp0fXhjrSVViVOgJV1pKzh16Vk3/M
         ftTw==
X-Gm-Message-State: AOJu0YymdOlaVafCAd1/lHdrMxcd9EEGtKyfFNqHSTTE/YzowTsOaGms
	tyEULbCy5JLEi9GALEvBm7x0rC1zuyRBvLon7DnEJfeEj96sr5PkrV8S5bBO6t46BWWdhWoDwsb
	fOqKl4f0=
X-Gm-Gg: AY/fxX6iu6oz/Tm5JWXvdoIhFJV6wdCi9IdtQcNrS6Uq1UzIfdQUJH3uGm2pe4DSYK0
	dHw5j01l3nZQJQjgcfFz/ouZsLcpjQWFbZ3hzZQzRXE1sK9GuBNDNPwBXoMBumFDGNYzNgERUfu
	v7qS3QzmLwSu1+wxvSb2DSFbs+jLzW0KspIA2Uy4Zth00vtmm8P/pNei2HJS3PecYaNp2vWxc3A
	KPTLgBudhjVq0LmZp9eGSfBjSNedLF/3dHyheU2S8xWSTJdYoEKjYMbSDm5NHtEZYjkT4ikWQtw
	f+pYBezo+iEEvh5SXU7eLNggan7GVSKBq5xQ8zZ9r7JBs3tuhL3Z//L6/qixJjuS05+wh5/neO+
	AsnJChVrtZ29uajB3XzYLw5o5zFVd6v1+gXkLQ4erhZDLVTTy0mnpDOTJsTIInYV9VdGkmj8UGz
	nOFlnvFACJ2/jsp07VP3NlAYFJz886sKuztnRU5rCK1cJaK30gVQ8TdYjTKbRyd+1Ow3uL
X-Received: by 2002:a05:6808:4fde:b0:45c:96bb:1202 with SMTP id 5614622812f47-45c9d8e9726mr6871253b6e.58.1768928254804;
        Tue, 20 Jan 2026 08:57:34 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4044bd15c79sm9431457fac.10.2026.01.20.08.57.33
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jan 2026 08:57:34 -0800 (PST)
Message-ID: <3c841bbb-ab4e-4afc-827f-caef3998eef5@kernel.dk>
Date: Tue, 20 Jan 2026 09:57:33 -0700
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
Subject: [PATCH for-next] io_uring/timeout: annotate data race in
 io_flush_timeouts()
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
	TAGGED_FROM(0.00)[bounces-11841-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:email,kernel.dk:mid,dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,kernel-dk.20230601.gappssmtp.com:dkim,appspotmail.com:email]
X-Rspamd-Queue-Id: 50C4049C48
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

syzbot correctly reports this as a KCSAN race, as ctx->cached_cq_tail
should be read under ->uring_lock. This isn't immediately feasible in
io_flush_timeouts(), but as long as we read a stable value, that should
be good enough. If two io-wq threads compete on this value, then they
will both end up calling io_flush_timeouts() and at least one of them
will see the correct value.

Reported-by: syzbot+6c48db7d94402407301e@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index d8fbbaf31cf3..84dda24f3eb2 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -130,7 +130,7 @@ __cold void io_flush_timeouts(struct io_ring_ctx *ctx)
 	u32 seq;
 
 	raw_spin_lock_irq(&ctx->timeout_lock);
-	seq = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
+	seq = READ_ONCE(ctx->cached_cq_tail) - atomic_read(&ctx->cq_timeouts);
 
 	list_for_each_entry_safe(timeout, tmp, &ctx->timeout_list, list) {
 		struct io_kiocb *req = cmd_to_io_kiocb(timeout);

-- 
Jens Axboe


