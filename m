Return-Path: <io-uring+bounces-13324-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KDr/ArbNBWpGbgIAu9opvQ
	(envelope-from <io-uring+bounces-13324-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 15:27:18 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AC8D542527
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 15:27:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AF82B3026C25
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 13:24:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F3203D7D9C;
	Thu, 14 May 2026 13:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="LZ+ESrfY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92BF026F293
	for <io-uring@vger.kernel.org>; Thu, 14 May 2026 13:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778765068; cv=none; b=PJT+QD0oiYfHp3AT+pdf+69s6FFXs+Mks0CYj1gBOFHO2g0m649qzNHoP+7ZWF1wwH8IGFdNCl3LJQcxlYciOfF5klGZhroPYUNVdvY88sVy5Kx623U6CRxdV21TPzSL23GYfbH03drAcFZpgSzlfF0OBuUfVoymCKxgFrSyz0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778765068; c=relaxed/simple;
	bh=0QgQ9bBY+NxwhgHdWwpEruFhzvvHOOH4bLx2QCHeC30=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=qEFM75E+EVGm+mfGiHQOwWlsLjclMcB09QnuANyeAWzAKW+hJqGFkXjWxHzmgKjvlYVVs8rGgAedjaTwye459xqfdDD0xTjyC/GGRp7psL4VJ1ebmeK050oPHEIJorODOnw6Ksz0vLoeyVpHnTthui9vPmObq40r6k6Kz7a0D3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=LZ+ESrfY; arc=none smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-69b747a8984so982286eaf.2
        for <io-uring@vger.kernel.org>; Thu, 14 May 2026 06:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778765065; x=1779369865; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vz32gtdua8libie9MQ5sVv+lIab0jafScEX2v9J7UsY=;
        b=LZ+ESrfY/SmxRJE3IMoe7ZgSG+/4RkgzYdbt8qMDSzCaebLg31RqgReDEzOQZrbbZC
         stmKlTnZ2gteqMLBFkHyZlabhyTtM072PQ4wxtQXO58TBFGAx5RM7iPBW5b5esN6bQJp
         hTvPvtK7VLy9jG2n/rRmaoHAGCYJhFu87LU1Yqiqyt0WEz4iMi1iKNAe1h+/llLWEvJu
         guDYjKM+6Dzr56JJnCQp/rp0iIzeWW0wQy13J2IwUfLOf8uO1R4/eqamyKlWvD7oVIi8
         WrTd9koDPCkyOvNpn/SYWXxi9B5azXKbrffTatHMvlZNE9ZUVs41YRCy6K8KvJfq7NRH
         MaBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778765065; x=1779369865;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Vz32gtdua8libie9MQ5sVv+lIab0jafScEX2v9J7UsY=;
        b=dZrrIflXm+m5RgvOZJhyClLAsgU9nU1qW5f6hnmdTvzhYSINV9zmtRt7LIj4sinWOw
         yADnHJ73hjG8KlISwy0dByJUFvvdlS4pJJ9QqCtVzP5P4UKmxLcu8BYThjkIlwcb+mrz
         xjro7wlPy1TOnrMQGd297egHFL+4qor9DVt+7RU3Lf4N6hQ6Q2ON+DIBqvw6tvTjJ/Rf
         9xe+gnjmv8rxpj5fD+KcPVzf666V1pIb07xb8rwQPfRgPWsp5NWYwA/1XVaXpvvAwA3C
         vq3x74bLw8CxXHs9ixhrLqDHSRFBwEGa/uefpZEih2WxuXlnmo3wazPO2OfkttHdV6I3
         9w3A==
X-Forwarded-Encrypted: i=1; AFNElJ/GuehY9VxSAca+mqkPEjs5coLH9Jplr99Mf6l3zsCelzWqh1zo9NQJo78Z5HT5w9L+2lSRV7TrBA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzUUnMlfV92m4f4roCJp6AKPcRJPsLbChug6G1CbnaAwL2N+CKG
	kcxczhYf9Uyutb03tmf0WxY5v3HF38s/j9XtofdXSUcrJ7YgezUqJzEooaNuzL9shgqa69Aly+W
	HPuZI
X-Gm-Gg: Acq92OGkoHAEiKnVJfzWvz4nCYgesShMe3Fl5vVic1g9FesZAhBDgbft6nA5VH90Fa3
	40eD2ZJK3YR75JV9JIhWS03n8Cvy7bQFPwvYNceqtMFUvfk8ziqiJewpUBUAe9gCbooBP+wkA2d
	SAelUOk5iMqlRT2S/CZya91H8yEtFVwRykyM44I8v8zJK14ZnvFtcQMQeQMuDEjefIT/qy3bK3R
	IQtgG5XrExqwS/Nn2c2SmAZWdRICbRacyEdWRUx68RIuzq+3hKz6lLuSNsfQ4WT5ZxcDXh41Xbu
	ni/mCwVMtybc8Zb9rIOBERvuXVbXbCp/1WDOn82lCPLbCVcuKCm/B4CxImP1L+k54a6iDS1qSDG
	dlouJIqY9L9CIZCXS9+JUGm/3m96Bu73U32CoA5DFAlVoSOmAnyHfv2FtGMb0N6cggBQ4mFmdff
	1Vw7seQ9Wa51FArodTI4INlA/ExzRlQf7GCpgfEKnO86OIaVfMz2xbYLHYuTkQMDC+7JEM31GTI
	7E=
X-Received: by 2002:a05:6820:4c01:b0:694:8e28:fd6e with SMTP id 006d021491bc7-69b78dfaa7cmr4154432eaf.38.1778765065482;
        Thu, 14 May 2026 06:24:25 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-439fc542271sm1824216fac.15.2026.05.14.06.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 06:24:24 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: asml.silence@gmail.com, io-uring@vger.kernel.org, 
 Zizhi Wo <wozizhi@huaweicloud.com>
Cc: linux-kernel@vger.kernel.org, yangerkun@huawei.com, 
 chengzhihao1@huawei.com
In-Reply-To: <20260514021847.4062782-1-wozizhi@huaweicloud.com>
References: <20260514021847.4062782-1-wozizhi@huaweicloud.com>
Subject: Re: [PATCH V2] io_uring: validate user-controlled cq.head in
 io_cqe_cache_refill()
Message-Id: <177876506441.606701.15151656344889553957.b4-ty@b4>
Date: Thu, 14 May 2026 07:24:24 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: 4AC8D542527
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org,huaweicloud.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13324-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20251104.gappssmtp.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,fedora:email]
X-Rspamd-Action: no action


On Thu, 14 May 2026 10:18:47 +0800, Zizhi Wo wrote:
> [BUG]
> A fuzzing run reproduced an unkillable io_uring task stuck at ~100% CPU:
> 
>     [root@fedora io_uring_stress]# ps -ef | grep io_uring
>     root  1240  1  99 13:36 ?  00:01:35 [io_uring_stress] <defunct>
> 
> The task loops inside io_cqring_wait() and never returns to userspace, and
> SIGKILL has no effect.
> 
> [...]

Applied, thanks!

[1/1] io_uring: validate user-controlled cq.head in io_cqe_cache_refill()
      commit: f44d38a31f1802b7222adaea9ee69f9d280f698a

Best regards,
-- 
Jens Axboe




