Return-Path: <io-uring+bounces-11920-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ca4wIi9Odmn4PAEAu9opvQ
	(envelope-from <io-uring+bounces-11920-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 25 Jan 2026 18:09:03 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BB4CD81896
	for <lists+io-uring@lfdr.de>; Sun, 25 Jan 2026 18:09:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DE2763003EF7
	for <lists+io-uring@lfdr.de>; Sun, 25 Jan 2026 17:09:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 482F0221FBA;
	Sun, 25 Jan 2026 17:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="x3w0XsjY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70911A0712
	for <io-uring@vger.kernel.org>; Sun, 25 Jan 2026 17:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769360940; cv=none; b=YYsvdURozCVn8NfsM1F+GbWKmg8HRudvtOOeyxoEf3zgRFbyu2Nz19Rc1DVXJ4pNNomj3+AyzPr/g4/X0PP2WEwZDM+/Hm2FFtLLbHQwy9bDb4Ve3qa3ZQGVeNPrKVplwdQ80FhvIJadtQLUrxlZsvgoW1qRusJN0aAXDSg1slw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769360940; c=relaxed/simple;
	bh=VAQYp6CmM/xmstLC52VHSxrsBlJMwM+fbhYZtn3U6ek=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=jFpLtBnX38wwNgTGHDmsxNqgQI8MWWIqGxjmEGJGxXNfTQHTt2AdEcXrhiLn1VJTWOqKuACzphHj+I45/667EizvI1/k3poFpbn57Q6aJWOSfkVDz3cxOlUYE53D1tgGpFm4aImpFs1oNENHKIffJXQfaB0dScGcO65KrNBXH0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=x3w0XsjY; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7d122733808so1422355a34.2
        for <io-uring@vger.kernel.org>; Sun, 25 Jan 2026 09:08:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769360936; x=1769965736; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uIBRVAgzl/3OcDJfgOZuVpLRWO54lCxQga1tiUgnUDk=;
        b=x3w0XsjYJ0Yl4qFDtX6qp8w5h/74QHzBL1Otjn06DuYjX8YF3qvv2nqRCwD/76whax
         dtQ0owlEAzSPPuOuFm9OmIEM7cEoOBtOhYxj0jVOXdUxgkXUJzNId7IW42uqi3y9T/Su
         SnF9BjRP27Loa1RlYXa6wAt7OpFqbRf7tMAFpisWNDsmJA1/BllnRL9KH6hCJ+KbatuW
         YO4W0EtefTvMmWBlb/tDQFinByD0U+/oNA2Q4mBgKM5jR3g+WOl0AV44TMpocjcIr25F
         7ksAySepqCTHuhi18K8+AQKtIllnxsC35A/0InW4cQP0bnWslE55I8odP9IM/lvwhCKl
         HSHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769360936; x=1769965736;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uIBRVAgzl/3OcDJfgOZuVpLRWO54lCxQga1tiUgnUDk=;
        b=NBbuCdHH9eHZahTfaUjDslXGC5ppzb+6p/b2zBMij09fUyuy07UGy1pgl9fK0rnMKk
         6CDhoPOKTLrDebPxHdfGK9tS1FYqsdZEZK9e85vZDYUBmY5dCPmFZRhGde6be0ST+H87
         36dz/sEBe3l1T+Jwjh/d8bfefphCpw+bJzmnS4mgK7pJ9n5K70jz55KIiPfBo/2EkJ0N
         G9SSnAZhTqipcpC7KJ+qidAF3YD9yJBxS3iACctedHJHiuKpm8hIe0FRDazOS3RmIK8G
         ouW0p5FzWG1zhaRl20Bhsjdw6DnH5YSECoUajwF681Gs9guvugRatHDb9Qlt5GQjyoOC
         Zexg==
X-Gm-Message-State: AOJu0YwnS/bjiTKURe+oyu4prAP8P7fMPMco3yGv25RfaGK3BqbX+DQh
	ID5T48fPW2i0LN+InxkH/kQakJnAgPpzrzKWOtxUDXHrJ0juDWAjk1rq2bO2LY6NuD7iGIAu0ja
	SHSmSKhs=
X-Gm-Gg: AZuq6aICx1OP6VB0o3oGb3QR6t7xaP+91/ZtPtTFQR0rOL0fcelKVE/V+1GzZTPU5Nh
	6QOoGI0oC6+nZmnoSGDNForCxwOTdMrUxubawMximoQPcPo/ZDgcFlXO0PKZL4tHfR7FeJmhB6X
	kFWmfYrJ5ezlFVo0nmiNUaO8JQ//VRlRQA4zsxeX8xxc1RiHKioOADs7sEAQI/0+KRkqOrHrSeq
	3HTx2hBCFo0/ZgICeEQNz9M53wLOA3LN1pkw1MK/IxCE9l6HONAYeWNQpJJlXc0//4eOVM64jiq
	s+SC8rT9fDC4Mu5rsyLRQlcMKOJ14T6/NA97ByxaBlAmZIjVrVtnUeDK1Ks/w/w1B43wFS0UaCc
	hmaaR8+VJKB1V3Xc+3mspKVyeRBP8MSm007lWTEnaLne+l3wMB3x+ls5KCs3x00f8Xa9CSAvrr6
	MGDnlCrQYHdFA8Zg9wQEtk7VbzMQ0oU24B1khFiWsRcWZAcCFZ+YDpxF2T+nV0f+Z9jaoXLg==
X-Received: by 2002:a05:6830:3506:b0:7cf:d191:4c51 with SMTP id 46e09a7af769-7d1701b4d82mr1112290a34.6.1769360936152;
        Sun, 25 Jan 2026 09:08:56 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d15b3c01b5sm6177477a34.14.2026.01.25.09.08.55
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Jan 2026 09:08:55 -0800 (PST)
Message-ID: <d8fd1498-fe73-4f48-9213-6b18ec698a3d@kernel.dk>
Date: Sun, 25 Jan 2026 10:08:54 -0700
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
Subject: [PATCH for-next] io_uring/futex: use GFP_KERNEL_ACCOUNT for futex
 data allocation
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
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-11920-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BB4CD81896
X-Rspamd-Action: no action

Be a bit nicer and ensure it plays nice with memcg accounting.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/futex.c b/io_uring/futex.c
index 11bfff5a80df..1dabcfd503b8 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -186,7 +186,7 @@ int io_futexv_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -EINVAL;
 
 	ifd = kzalloc(struct_size_t(struct io_futexv_data, futexv, iof->futex_nr),
-			GFP_KERNEL);
+			GFP_KERNEL_ACCOUNT);
 	if (!ifd)
 		return -ENOMEM;
 
-- 
Jens Axboe


