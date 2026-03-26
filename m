Return-Path: <io-uring+bounces-12868-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uK64A7cyxWlS8AQAu9opvQ
	(envelope-from <io-uring+bounces-12868-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 26 Mar 2026 14:20:55 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id AFB33335E27
	for <lists+io-uring@lfdr.de>; Thu, 26 Mar 2026 14:20:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 4F7BD301BA53
	for <lists+io-uring@lfdr.de>; Thu, 26 Mar 2026 13:15:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDFD12C324C;
	Thu, 26 Mar 2026 13:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="c0VHLuts"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AEFF217733
	for <io-uring@vger.kernel.org>; Thu, 26 Mar 2026 13:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774530942; cv=none; b=LC2AIq3hTq4H5oYNQSa2H7WGweUjoDhhzrFhi+m0OnFvCpYJ8CG4jYyXlLszSTGKgfIknrwfeM5eIS/lCCUAGtvZi6n6ciT8MQvij9uuA/xaQF+PSNDx5OkK1fwWe9a2r0udy8Bwk/zbAzrq3M5X9Vk7Dz0fbceZRnfQfLX1wHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774530942; c=relaxed/simple;
	bh=yu//bjTyumYGsWP2MgN+dma6VfnlgHUraEcevGh/Ojw=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=q3+COGomIDDqZeT/UIDtdVKZQ2HLHaT+gzLny6WeVcVmbUe4EIYapWtpjASJfcRacKth8xdKpD34hfzQxgfawz8mvgZypUN2cIzHkqASb6gkoMFXRt+ecNarnNwc74TDezlGQ/i7lVwLS2btNJGNeklR4bSvUS+1eVwQ48TF3Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=c0VHLuts; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-467166cb638so330238b6e.2
        for <io-uring@vger.kernel.org>; Thu, 26 Mar 2026 06:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1774530939; x=1775135739; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3YtZJo47G4sQC+3SSLdijefXyUaRldnR5YTbcFqwkQA=;
        b=c0VHLutsi00UGAarVv78t5/wvqJKvyDYwZNrxoa7vaXJJWlqUPLOgLYfM4cZ2yC5kS
         v3fD3KmYCSAkY7Yv1LeNKbOqKZVKk3KS/sPPgE+IytcBBR2xk+aZ5P9Miq50lk5c2A9P
         lusw5Zz2Z8LhZrkXVig+AivtKq/HqNOZZjXXpXoeR++yO8WX5hGsclVfjOTRcEm891zW
         AxvLUOX5bo+beA5bcFYtZtKkhSBuU4vnuELmVv3pme8C8IKXE/bbt9Gdne29BMO7H/I9
         NEAgwpxWFJ6EXRoc844H/dp/Z9MPCYOXaC/jt68oHNKEvcjc+sINtNULjiInw3mxFYMZ
         Dy/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774530939; x=1775135739;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3YtZJo47G4sQC+3SSLdijefXyUaRldnR5YTbcFqwkQA=;
        b=KLtcRn3CEsSWjNVUjVUuD9pFdqvBi/qr4UbycGp+3y/wRV7u3n6dOq41fEmMUI4p8F
         0R1dU9PlrnFk+QBr6zrnmvnb8ilNlFKarbI+hQNytsLEeJdJv0rI5StmlpV29yZ6vILk
         PayQJxpMgMcoK3KTWZdgTPn70KbxJos9zWOMvaKFcr4qnphHLDtQ1x3ZzYmku3wO0ruI
         Y5vxVEspbg9REQDcQIq0Hye/1AnpJJM1b7xBjoh9BNZ0Gg/ZzBbkMgUGYSAGrSL/BSCJ
         c0d4lp06L62U/VLXsKh0jy7Ks8a7OhKO7m629UHdx49jm8QFrr2BQCNiUzwVX3PDovwU
         hjVQ==
X-Gm-Message-State: AOJu0YxRfwH/PN4gTgtFf+nKnPXhmioLXCJ4sO3S/FKAMj3NeeVgLUcm
	dCjH87dVDIu2J13U+G32iGv3evDGMup6aFZGo5d8AIfgZr3LEWXpa/OOiT9sDgc3dqbIMrZfW2S
	/QvpQkP8=
X-Gm-Gg: ATEYQzweFhkBdJEWClkKQqeMbLnsN2C0x40mH9/aotXPZZ44vGmL0bKMfEJgoCTziAg
	aTtwp/UMcUmnRbh0I5w+8/nnbPwAkqRUMPDDCpbZXPK1YqypiHPBtHzZjJPkHFeX6y0BuwGy2Tx
	QevxlHAxm5DSAQj2Q+xtB+7+4IajE+6BViDcXLc6rAEXOsgKl1Gkjndg3wcuqpY9KfQvMjHUqEb
	OfWf8cSClMVLoKWnb9j7EnWObVrY6gvN8fEkX3QX4puSeFeLzzLJxn8/PtWztNBdhaSq1dkfsfZ
	yPeoJJWQTDjN2WSVdvesvoTMPu6kuLboqBUJNvwRh2sODlbBaw3h7VPEq2SQyxQB1BBWm8GasL4
	EVuGjTG0JdJaTjUl/RLICkSyqkPRi1CxLoTtKAnY41lJVyWcp8B5fxdYTErWiQxgm9V2lPcUR2E
	T88ORyKaaifHwTQUN5Fs6rQbF5r2WZKXSXvE9w9tK9E+lTdzQl98jWhVDffaHru3NuVCoaCxEnr
	rDyOGGF+w==
X-Received: by 2002:a05:6808:1907:b0:467:a44:dde2 with SMTP id 5614622812f47-46a5c7fd037mr3382639b6e.56.1774530938544;
        Thu, 26 Mar 2026 06:15:38 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-46a7099df08sm1614220b6e.15.2026.03.26.06.15.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Mar 2026 06:15:37 -0700 (PDT)
Message-ID: <7738473a-d45b-4521-8526-4a7ba02cd35a@kernel.dk>
Date: Thu, 26 Mar 2026 07:15:37 -0600
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
Subject: [PATCH] io_uring/fdinfo: fix SQE_MIXED SQE displaying
Cc: Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12868-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel.dk:email,kernel.dk:mid,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: AFB33335E27
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

When displaying pending SQEs for a MIXED ring, each 128-byte SQE
increments sq_head to skip the second slot, but the loop counter is not
adjusted. This can cause the loop to read past sq_tail by one entry for
each 128-byte SQE encountered, displaying SQEs that haven't been made
consumable yet by the application.

Match the kernel's own consumption logic in io_init_req() which
decrements what's left when consuming the extra slot.

Fixes: 1cba30bf9fdd ("io_uring: add support for IORING_SETUP_SQE_MIXED")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 80178b69e05a..25c92ace18bd 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -125,6 +125,7 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 					sq_idx);
 				break;
 			}
+			i++;
 			sqe128 = true;
 		}
 		seq_printf(m, "%5u: opcode:%s, fd:%d, flags:%x, off:%llu, "

-- 
Jens Axboe


