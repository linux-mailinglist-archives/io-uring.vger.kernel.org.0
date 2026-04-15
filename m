Return-Path: <io-uring+bounces-13048-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SL2TFmDw32kCagAAu9opvQ
	(envelope-from <io-uring+bounces-13048-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 15 Apr 2026 22:09:04 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C1729407902
	for <lists+io-uring@lfdr.de>; Wed, 15 Apr 2026 22:09:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 636F73023E11
	for <lists+io-uring@lfdr.de>; Wed, 15 Apr 2026 20:09:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23D3D386428;
	Wed, 15 Apr 2026 20:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="dByz4gfC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9B938553C
	for <io-uring@vger.kernel.org>; Wed, 15 Apr 2026 20:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776283740; cv=none; b=Zi8eHPzzf/bLBvtZxN/n78XFt7PkdqDOHddWdAkFV8liV1lIKCNhFKrl+93Q63XJrTEPbp/GVoja+HylLzy+T8XX2/pDGcWdpFvwaGqfPWYRXmgVNMBJKtqBSq/A1zNAclXGwK8rzXu1c51xTjX5sqkjmHfXcIJeJf/tKdKxwfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776283740; c=relaxed/simple;
	bh=i+yBECSERSBqSLFArpGiU6NUb2O6U8OfXh2wLgqn0Pc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Te+1c/1YxSFnBMkUvMbgiR3FSx2Zkp7LfJCYwEEfJq5ukR1O2qotvutWvV+vHPhFWSWh3/d+Gpg3bHFZa8jj8y818roGVu5CQJyuRMOKes6/FsLQtYpsx/3ySR8ZlxGvhQSqz4JddULQrVfEyG7gTQqqEZcugds9l0/0kcYcRZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=dByz4gfC; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7d1872504cbso6402785a34.0
        for <io-uring@vger.kernel.org>; Wed, 15 Apr 2026 13:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776283737; x=1776888537; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ot77yH4czMwORatuyMQjlgGRom+tee40L0BgcS3XZpk=;
        b=dByz4gfCDvaVy0EFaSilnwv7r1ywPFo9i3U0tB9o3PGx+sbKChqnfisAB+Rt3bxNXR
         fPkb8LEvBZr2hu5LLBGEusuSCAITg+wLQ0YZoUf+WQo7KF8VDwitRvTlkiJDkRkdlwi+
         /dL7HUa1eTF3vnSV6L3tzSODkDCqi4Pp6mypBPEC9HqAjSFVkfHJlt+e6TxWtLaxTZdE
         +q3u7KKdls2QpYpYIaklMwFbEY48u3u5aIMavUgAAnnuweUBGU5eeJk0Xjnk8Kv+n+IN
         B5cc62V2JPN2Ja2hPQY37AsOrzn3sqvcOBxli+0B4jW918nTQiD8Hpd0JSJl80wQ63MH
         uUBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776283737; x=1776888537;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ot77yH4czMwORatuyMQjlgGRom+tee40L0BgcS3XZpk=;
        b=ZxqmCFBMf4wEWE3VNYxnkXFVHNM4m/nolmv2yCjSdELmaVhaXvrMW0jckU/wFGTAZs
         BQ2m79xzkAwZ2MyYViuWIh1Gsjl/um7Qcaw206izN11Z6cNVV8NKs/72nZEidQAswB+d
         8pn5aXL6AZ8nWcbwNU0GH0Zk71+NhNlZiwPgO+M7+urFT3MXefHqHNg5GOEK0tpOfBt5
         HW3znPoKAYX0vHX4mbLiGOPIF/IMYY/bYD0gLcNCbEnxSJ/86H7MMpaHLh0Cg+77bIyt
         XYFzvbEz88pZPSaCN+Y2K+DDaKUl5FWbyFlX4dXwpvz0LSW9MdFN8hEBpDsr55K73RWB
         8zMw==
X-Gm-Message-State: AOJu0Yy5mP41FJNBUWubLZPTd9/d4bAWIwjc9ZDtY3dDEbP4B4iLapRp
	/hYPcjsipmvpRGVDjCsQ2FCiopjjhcoWl9FUJ07IoQ6zHJ08dZZz2BjJQFjJB5XNAoM=
X-Gm-Gg: AeBDiesYauUzR5IMwy5CkOPhCOfxDGeFjKv2fKtXNdjWMQZArXV10QsRnoU07GFQu6O
	8OdydW10ERHCcu0YP0RB7o1k23oAvvR7Rjs78auCEjTiEa2wR5Hze5Jjnz0G6CDqTJOe1KioIqS
	L62gFcO+Dlkg3F8WYNdUZx+7JdHt3IEknvJ6XMQeGvzgIfThTQnTM+qc9XdzC5qmWZ8HxCP804N
	ownJIfzngaYjT0fQqhEpcbkqKcAoEUnshjtgBi4KXMRfbLY/iPOzLviOa/k58dp8D0JBl6UPhRA
	eAWBQgkvMUyWMQs8VJcUVZx07nJwyz1R1HQ89r5GelCWySs7wslEOwXL9p/mrPr2gqB39oYh/lQ
	80OqR7MJ4j7S5Gd7wu7Z+ZCU5wNgAC6lPFfso5BezF5UTXxhvkn2AFCAgRx1uxM3QWHgKML61Az
	MyTabUvfFratLPQ2FokvVuzNRrVfttpYKLedn5mCvN4M3kVRGLpdDYI6eKS3kJpmJoqjgLxYLn+
	lrE0cR6A3gOUmLzakz4Ia+6uX6cYqMw0wpm+LSC
X-Received: by 2002:a05:6830:368b:b0:7d7:c004:9d92 with SMTP id 46e09a7af769-7dc804116c4mr622277a34.8.1776283737523;
        Wed, 15 Apr 2026 13:08:57 -0700 (PDT)
Received: from [127.0.0.1] ([72.170.223.83])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dc7746b5a8sm1741310a34.6.2026.04.15.13.08.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 13:08:57 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Ren Wei <n05ec@lzu.edu.cn>
Cc: asml.silence@gmail.com, yifanwucs@gmail.com, tomapufckgml@gmail.com, 
 yuantan098@gmail.com, bird@lzu.edu.cn, zcliangcn@gmail.com, 
 ylong030@ucr.edu
In-Reply-To: <3a3508b08bcd7f1bc3beff848ae6e1d73d355043.1775965597.git.ylong030@ucr.edu>
References: <3a3508b08bcd7f1bc3beff848ae6e1d73d355043.1775965597.git.ylong030@ucr.edu>
Subject: Re: [PATCH 1/1] io_uring/poll: fix signed comparison in
 io_poll_get_ownership()
Message-Id: <177628372965.679178.4854515446834646892.b4-ty@b4>
Date: Wed, 15 Apr 2026 14:08:49 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Spamd-Result: default: False [0.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13048-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,lzu.edu.cn,ucr.edu];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[9];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: C1729407902
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr


On Sun, 12 Apr 2026 16:38:20 +0800, Ren Wei wrote:
> io_poll_get_ownership() uses a signed comparison to check whether
> poll_refs has reached the threshold for the slowpath:
> 
>     if (unlikely(atomic_read(&req->poll_refs) >= IO_POLL_REF_BIAS))
> 
> atomic_read() returns int (signed). When IO_POLL_CANCEL_FLAG
> (BIT(31)) is set in poll_refs, the value becomes negative in
> signed arithmetic, so the >= 128 comparison always evaluates to
> false and the slowpath is never taken.
> 
> [...]

Applied, thanks!

[1/1] io_uring/poll: fix signed comparison in io_poll_get_ownership()
      commit: 326941b22806cbf2df1fbfe902b7908b368cce42

Best regards,
-- 
Jens Axboe




