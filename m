Return-Path: <io-uring+bounces-12075-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KBQzLJvwhWkPIgQAu9opvQ
	(envelope-from <io-uring+bounces-12075-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 06 Feb 2026 14:46:03 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 57DC6FE62B
	for <lists+io-uring@lfdr.de>; Fri, 06 Feb 2026 14:46:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4E99930BE905
	for <lists+io-uring@lfdr.de>; Fri,  6 Feb 2026 13:40:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A86F38F248;
	Fri,  6 Feb 2026 13:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l3mhNFDD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15ABF367F56
	for <io-uring@vger.kernel.org>; Fri,  6 Feb 2026 13:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770385211; cv=none; b=E5WXAVPsq1PJaDY9BY5TYDcvB+9AJhyFCw1epAHQff5r9HLZLBLLIDE3KxkIkg77WcHq0GQQ7CNBq8eaW8EcSIcuKsTg26h32810WcLhqeqXW1+Gk9NG3Lj8y1zgeOQYk8XZPedF9yIJ0IAvr8qaJ069HUYcJJs2jMiWu/Sg348=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770385211; c=relaxed/simple;
	bh=2HFNmOufWCwJLMLsyff7exDJnW6+hr07aH3JcpMxurA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TBVG2BlsDcl+59lgMiVbRo+a662WAPQNuQlIlOqWpjlq5AlUXFO/6GzqbT4zYlvaTEFwffGPHcFOkxB2kd2x3VIwBQq2HjMIRdjgCyrm+sBotSxpu9VuVDOJdprM3XNjGIkn/VABYI0pxcmNL/rWDl8MBM7gcPfDjW/fRvrzN6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l3mhNFDD; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-47edd9024b1so7850655e9.3
        for <io-uring@vger.kernel.org>; Fri, 06 Feb 2026 05:40:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770385209; x=1770990009; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=acgu0QGpSbBYxjDws4fcOntfiUC/MgIGMChLZMpVBu8=;
        b=l3mhNFDD0q3Zl9iLvpin3TuudxzHwthHPuRSPLq2JNzU62ynlOOHYcMl1clylZ/a1k
         bgnTtHjj3ebTBLO8WGw5qbDgLvpx7p7YgX79Hx0ElCaxB5O9zWxRzRGrtLyIKZ+TDQPc
         A1NXrbq+6PUVIN7lXnd6H2jakAXUXC4aYLdSvq2Lxi0jUeLRAGSTO+ylw1Dz1/TWlaOt
         Lqq7xMb7dFbUTk372DcLEp5m9AHe6xfyOQgzzmSSaTf4p3lDnjbx3zYSOA3ahL8zEkXz
         ESz25bGU3a2N+uQUQNVb9qy24OQ/+p++hI92TW1z0V7iOrkaEpNHeswEYKoNy8+LmRx1
         9/Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770385209; x=1770990009;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=acgu0QGpSbBYxjDws4fcOntfiUC/MgIGMChLZMpVBu8=;
        b=iJ53FQZu/PKuEecJjEvmXDANaatWYrT6lGIGH2m6q0nvnkFrDSyx0G8xHZYBYKwku7
         JEqCLchzosh/EXxMNxTgw+ReEAXc7hJPvGe8DWeHz1bOZ9Ye8NDWz/rwZM0JqZLMtI83
         I7hpZ/g0iz66Vp8le6cftR2xf1LJZ29Dc1O8uOzVNx/gSXYxQo162pwuFGLVZXs6ExFD
         NeTB8H/IEK/Yiq0i6H21bB3zT02WFe7sY9l65yZ0wGwCkgqccoa1sr8zjCV1/RDAYZEu
         C3GIEX+cdqni9BEAvItNeHtxjVeQZ+mrHR5kp7CHEywrJZBkxgu4UAcxG9q/Ynee9g8F
         C6ew==
X-Forwarded-Encrypted: i=1; AJvYcCWpLNS9y8ppOyq4YXGyb5cEj2aMdUTQSgf+ES7cLD80WqpIjPIK9aCCKT37lnA3vpbd0OdewrUzNQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yymi4VAbzKYjHznaLQ2d0beVnBUUgtiVNim4XpRwZ+amXIdsQKQ
	wsnqryHiBShFOxXPYx36VxdeIt+RCQKEXdmOhg4HCDNGDuscG5GCE7Om
X-Gm-Gg: AZuq6aKO4Vu/LOgKL75UI4V17X4TgKIlcXcG5OJFyevivuWjf0xC0bSY+fyirKdi1dX
	W6j7kN5iSySJ7kO+Z9usRQiefHTKZKFRx9LqpxEfCKabAkEw4NEuB+0PP1VrTCvM6BXE6Yju0Ly
	ewzItbFeY7vHHvmJNwQMi/ps23vx+gypVEdNq7wSYBBziK5nmC6p8//dmev6O+hCbjvO6F7VlS1
	hRboAyeUx9JfFlskcHDjELQQfRo98YWBPUGfNNElC6Wu/sir90yqPSGjFeLUXtuo6hzqToJLW7z
	7+MM1h6snl2B6ott5DT7ylkoescfo+wDo1nVuzU8zNp3NXLDfzK3hOwa88zQHS64LbWDdtkXeKz
	YECA+vu5PfoI64si2lx2rNQpyoFkgB1sjOuIGe113H1h9m81KCLECR/hdCTNPn7/LvrbORiO0P6
	igcjYduYI=
X-Received: by 2002:a05:600c:528b:b0:477:2f7c:314f with SMTP id 5b1f17b1804b1-483201e25b5mr37192225e9.10.1770385209264;
        Fri, 06 Feb 2026 05:40:09 -0800 (PST)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-48317d345c2sm171484865e9.6.2026.02.06.05.40.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Feb 2026 05:40:08 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: joannelkoong@gmail.com
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	bschubert@ddn.com,
	csander@purestorage.com,
	io-uring@vger.kernel.org,
	krisman@suse.de,
	linux-fsdevel@vger.kernel.org,
	miklos@szeredi.hu,
	hch@infradead.org,
	xiaobing.li@samsung.com
Subject: Re: [PATCH v4 03/25] io_uring/kbuf: add support for kernel-managed buffer rings
Date: Fri,  6 Feb 2026 16:39:50 +0300
Message-ID: <20260206133950.3133771-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260116233044.1532965-4-joannelkoong@gmail.com>
References: <20260116233044.1532965-4-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,ddn.com,purestorage.com,vger.kernel.org,suse.de,szeredi.hu,infradead.org,samsung.com];
	FREEMAIL_TO(0.00)[gmail.com];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12075-lists,io-uring=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[safinaskar@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TO_DN_NONE(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-0.999];
	FREEMAIL_FROM(0.00)[gmail.com];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 57DC6FE62B
X-Rspamd-Action: no action

Joanne Koong <joannelkoong@gmail.com>:
> Add support for kernel-managed buffer rings (kmbuf rings)

Is it true that these kbufs solve same problem splice originally meant for?
I. e. is it true that kbuf is modern uring-based replacement for splice?

Linus said in 2006 in https://lore.kernel.org/all/Pine.LNX.4.64.0603300853190.27203@g5.osdl.org/ :

> The pipe is just the standard in-kernel buffer between two arbitrary 
> points. Think of it as a scatter-gather list with a wait-queue. That's 
> what a pipe _is_. Trying to get rid of the pipe totally misses the 
> whole point of splice().

So, kbuf is modern version of exactly this?

-- 
Askar Safin

