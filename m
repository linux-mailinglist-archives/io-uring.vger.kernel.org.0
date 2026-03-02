Return-Path: <io-uring+bounces-12534-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eH0GNmEPpmkJJwAAu9opvQ
	(envelope-from <io-uring+bounces-12534-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 23:29:53 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 758731E5761
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 23:29:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2BD1C30E7D26
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2026 22:17:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 500413909A5;
	Mon,  2 Mar 2026 22:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g+Cgq56G"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105A43909BD
	for <io-uring@vger.kernel.org>; Mon,  2 Mar 2026 22:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772489863; cv=none; b=o0subsUUQA1IL06OcC2utulApzEFRe6sCxvdqLilviXqVwSyy0QlTFcdUul1SpbBVUbAU2Ce/d+4LVSUoXB0sVcLo6q++/r5qAKqWTQhdBeRQ6ADZeO2jie8OsWZDeGmkwA8RRmbiJBxuOqw0jA1Mpu4S9as7HDNdsf8O41IgJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772489863; c=relaxed/simple;
	bh=e5cz2bIVLbsU+cAPQA9qjkP/tzkHzHpAi6s7NlZ4zYw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E6ZGtYt0CjLSMtLOeGDKROaaTX4RodtB/qiXKmmUYyG7X70u8QJUNzXQ7PNmrSGwllLwNsP3+T2mAVZtAiW5+JEedGCSl4uCFt0/OotKvIF78keXxML+ml8OB+P0XZAKGcM0m1Hjd86r/QrEfGSiMbeK44BzMkV8idDeswwHbN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g+Cgq56G; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4377174e1ebso3673510f8f.3
        for <io-uring@vger.kernel.org>; Mon, 02 Mar 2026 14:17:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772489860; x=1773094660; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=20ZBvw+8A17JrzKBL3m55KShBJ8EWIYwmxPjaH7SOVY=;
        b=g+Cgq56GKNXjRgcpH+R3pudFJZol/HdQb7EjXM+tstBiGT18Pp6c41cSgku7oDllCz
         +Ld+BcEgylUkgHnVSlg1JYMtF71szWuapD1ierRfTTHCUgemsd2jTkF9ije+d0NC0AfB
         O3a0MnOmaC8sDt+/Bh3nlTT2vKVAhTB/5ptTLhHjAWiGPF9vFiok3QUJkjbPZHCx598N
         h4JfOC1LCsISTtOyBUT/cly2k/WdnZs/Bqp+v52qjHlFAZj+lCseSkBQR1E502MWw2UM
         NP0jnIkchYlt5PoXAV5mFlkjeGPq+10Z3cRxQuE/tiYkeYtV/ux5aIR5Kp0LA9OyhG2o
         7Rng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772489860; x=1773094660;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=20ZBvw+8A17JrzKBL3m55KShBJ8EWIYwmxPjaH7SOVY=;
        b=TWUinwR5mIusFY4GEE9C0Bu/ea8h9VxkWA7+SaT67kWL6aTfIHamVjmXcqbCD597uQ
         8fH5j7J2lppthYmQNYN22w2SxRjFntc8cVyY74I2Eo9eYJ8gbRnc3oenCjNP1c73rLHx
         RIPlSw8jS3B+Rk8di48BR2miwDqauh0UTsbgqnwUWilwR+NMAL7L4B2DfMUJxjN9VMEw
         1IxEnSf7RRQKJRWzrnUFXuhyEY+ttI3EKxeNaARRcymnXCH5EsrfXgLdynq3dczxfOHS
         6/XXZJwSPrLHqNdrp4XOVz384SKv8vbEed4ghX1VmarzedvoizhA2Yt83kyzgkEhn/oK
         3uqw==
X-Gm-Message-State: AOJu0YyKaNrYYYhFo3Yc8G9Ks0FDFFfd+Gxp7PpPIdP+xLtMcK2mc8d7
	XKE1QbF2WU+4SBOKs8q30lzfJF/lO97PsDKZLTyFMb7VqvMay7+SOSzqnpTb4Q==
X-Gm-Gg: ATEYQzyrz6TjGcU0zt9J/su1xAFENjvoIs42XDRgcFoxeJPOKyZ4rjij600kmDUFgiH
	PUdjUNU9NHA0FLfEsMmwCvL0eumhCfl09gpn3ybGBblEztC2dXxbQSC9hJkZdbuhRMBzpWInktC
	QvVi9GudnqMtLVQFypTXxylrcdCMeTPv4C1UzlEQtHyAJI/isDhfHv04I5mplcCENB1+i5ht39Z
	X/cvUx1zsiEN1xmOVXPN2gAS7vX6oIHCfT732cU86SghSunTVDLJvXfcsiAXrji0tjXurDWHo3j
	1AyZNJyGOnQOv204p1A2eYhg8cLXFBCNbIhAhvzbQAk34NYARGpqCAFNRx2TiUf1ImvuvsJNfaZ
	BulSJrDRT6g3RlmSQmP8T7VM1PQ/udbv6pmCGLNSCaFdayVYIpDqZET+R42xc2b4vkyz0WsEALr
	xymNnNqUDDQB4FJZn0fZPxMpnB7CMIqHhTRIMFCdimCg5jL5rM9SfYQVF0i92lIsM8achqCVNH6
	a5kyTkMFU8Qq661826jWAQGYgQQnweslG4M5sSOZ3P9fI+2Xruuk8UFUtLs5KakK+b5/7D5Jve3
	jA==
X-Received: by 2002:a05:6000:3106:b0:439:8f32:8674 with SMTP id ffacd0b85a97d-4399de3e2b8mr25504482f8f.53.1772489859516;
        Mon, 02 Mar 2026 14:17:39 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439ac9f3e5bsm21544589f8f.37.2026.03.02.14.17.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 14:17:39 -0800 (PST)
Message-ID: <0350d0fd-3037-4c04-b9ae-31bdb1913ada@gmail.com>
Date: Mon, 2 Mar 2026 22:17:35 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/zcrx: fix post open error handling
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk, netdev@vger.kernel.org, stable@vger.kernel.org,
 Sasha Levin <sashal@kernel.org>
References: <ae4f2296e2c33bb65ef2a1487b120033879e493f.1772489730.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ae4f2296e2c33bb65ef2a1487b120033879e493f.1772489730.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 758731E5761
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12534-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On 3/2/26 22:15, Pavel Begunkov wrote:
> [ upstream commit 5d540e4508950c674d6feef1d95463d039bbf4f5 ]
> 
> 5d540e4508950 ("io_uring/zcrx: fix post open error handling") fixes some
> post queue open problems. Instead of picking all dependencies for that
> patch just move post open error handling out of the way, so once a queue
> is open we can always report a success.
> 
> Move copy_to_user earlier before open,  and xa_store() should already
> never fail as the slot is explicitly pre-allocated.

I somehow lost a stable-6.18 label in the process

-- 
Pavel Begunkov


