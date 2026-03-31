Return-Path: <io-uring+bounces-12899-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kGMSBOLYy2kaMAYAu9opvQ
	(envelope-from <io-uring+bounces-12899-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2026 16:23:30 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AE2C36AE04
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2026 16:23:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B26BA302B801
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2026 14:19:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 571803FA5F4;
	Tue, 31 Mar 2026 14:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="pKDEr02n"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4CB3D7D7B
	for <io-uring@vger.kernel.org>; Tue, 31 Mar 2026 14:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774966768; cv=none; b=GzjWLv337UbifkqNe+Kc7VWZ1NGCO4zoHK7l0lUsb7gjND1VnNUQT8VkwJvfoCb/9u0IA3M9+SUChSxK38oeS1yhk3kL5i6hpj9YHlqIhwb7cmnnbs6hEedKSP0674S6IHOZgi/ybwUsU2+HFomjqA4UIiDN6nFSHVbuTIttnZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774966768; c=relaxed/simple;
	bh=OeLhRSsOLwliJdCxsEYqGORGqHP8FRhrPygqEAY2hbk=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=te6Lsw5k53moea7xQPs3rqOgV5G6O1gZmEAMyP70dESBKmw3mMc5QYinWQoB0E5iCLX/7yIxg1UAEw+ip4hCGQfu/zKNPeF9FojbyVdBnl/vV9BzPITK1l3145Z1VIgiNX3VoP14kdJsBManLUvnAO6c7QK6CJG1UkbkDUqtmAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=pKDEr02n; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7d74aa6bcdbso3197306a34.2
        for <io-uring@vger.kernel.org>; Tue, 31 Mar 2026 07:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1774966764; x=1775571564; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YjFISqfU7YGcHziCUzcxBdlO4OXSYhCJuXUC0HNqX3c=;
        b=pKDEr02nZhviO8aDiLqxBnZTSM7LErG0SXztwnQIbJgdkmwp9h0Y9i7/eUUIzS1zXP
         bPm6NNGiUFqqTu1Trx/JOBZximD8Ft6QwRpPCbwxx/oObhp+MuKKqWSxf+LAKB4F6Tiq
         7IsILz7gl+qf7cx39ta2Si+KMqbBEk1ec0cV4gTrlABnQhcuZCmAp+gUjMO7QHcSZGW3
         jBCQC1S7jmxOv0SBMYVXd2lXYqotYNMtl2OuOUgvB4BYbAy7EszwlH7AMVq4GAPcJ2D4
         6LHfVwokKQNbUGqX32W/k8v27Cu3Ko0OPwYLyuHDA2SXgR6SI6K0ZPff4KwADY5mxHe3
         OTWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774966764; x=1775571564;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YjFISqfU7YGcHziCUzcxBdlO4OXSYhCJuXUC0HNqX3c=;
        b=gDKuzWk4vKZMC4jHmqAJ+wkQ8oatMPGaLLuovwbrLZOddP0dK3ZfupOR3kAHDEUiI4
         qEOZhwJcjN4ewyGUsYAY3YLucY6+uBsvNkXO9l1SftsXe1Q/ovsMhaFZGvDrbY9Yrj37
         rGD9ff/EczhcGpSPQpoX9w2Q1QbbOtpQeTHt9ZqJmjLQ6FID6sGrcFLehguMZ92pKLGx
         gdQLO3SUM7ZZEDtoN/SyIOYOrcbkAeXSJ2qMUCqQSt+sNjWdKEHV7S8u110BcQwVQdqm
         JG1dH1BurchTvn49nEehWP0++8NktGKynBE6KapEyugDYIY/3wQCd45JUJ3fNxrENijx
         PcWw==
X-Gm-Message-State: AOJu0YzO4UGCwJWVS2Na2IR4ZVhhvjRJnF9IDjltZGXWUbD1AWah7Blb
	cKYKQ4y1dEoj7EWUOMM9dU7ctVpvM5JRcuDKwjHzUH1OKis3TgmLloYzv95dIgDksVhtScMgMrz
	oOVxG
X-Gm-Gg: ATEYQzzJKhJHKXc/ZzsbsaQufnu790NfD7VcpXnYaE7AOHwdZv6xsan076f9MnvapLM
	c2CPXN2HNeyjTaAUq+Ywa96oAoYfjYpuQaBzUnihsLP4pnL4i9GvzdE8DLOvzB7ptkBzNau/+XS
	/utZYvcj3O28nbp5g8jTRnihxj4jKoG2SP7QFGo/W8+IlJgZLvfjlUT/7LsrXl1XZdQrr1+QMS8
	3fb25WRx+0ns5aEFh5yDCA0dQ5V2iB94jC/1qSA/bSTtwIjszCEig1vXGKTD3v33niXapze9S7e
	Hq2Flb7n5NjigRA3uORQqprYEdD4ZXG9y6HydAdf23ZUZ3oA9n/wZlKPPkCKHoDzoh/jDTfuiTF
	HM2QxVIH9Mh4RKuGtw1ZzAzjE60VePEQEJ0gqeRvqZGSREMWafk3U9GL4hhPAV6n/R53FKRq+dy
	dIs3dLhnd5CkFHzH8CknjineCPgIYUPZOmzmQ/5Xs5zsn4rfeJ93/EkqXFQQSf+BBRFzFfaCkBX
	MPpgGLL6SaH9tA03lUe
X-Received: by 2002:a05:6830:661a:b0:7d7:bf70:c021 with SMTP id 46e09a7af769-7d9faf1c5b4mr8577707a34.27.1774966764302;
        Tue, 31 Mar 2026 07:19:24 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7da0a335421sm8121173a34.3.2026.03.31.07.19.23
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2026 07:19:23 -0700 (PDT)
Message-ID: <4e2e2aab-84ed-4320-a9d5-076c52971c0f@kernel.dk>
Date: Tue, 31 Mar 2026 08:19:23 -0600
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
Subject: [PATCH] io_uring/bpf_fiters: retain COW'ed settings on parse failures
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12899-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-0.883];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:email,kernel.dk:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7AE2C36AE04
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

If io_parse_restrictions() fails, it ends up clearing any restrictions
currently set. The intent is only to clear whatever it already applied,
but it ends up clearing everything, including whatever settings may have
been applied in a copy-on-write fashion already. Ensure that those are
retained.

Link: https://lore.kernel.org/io-uring/CAK8a0jzF-zaO5ZmdOrmfuxrhXuKg5m5+RDuO7tNvtj=kUYbW7Q@mail.gmail.com/
Reported-by: antonius <bluedragonsec2023@gmail.com>
Fixes: ed82f35b926b ("io_uring: allow registration of per-task restrictions")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/register.c b/io_uring/register.c
index 5f3eb018fb32..837324bf0223 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -178,9 +178,17 @@ static __cold int io_register_restrictions(struct io_ring_ctx *ctx,
 		return -EBUSY;
 
 	ret = io_parse_restrictions(arg, nr_args, &ctx->restrictions);
-	/* Reset all restrictions if an error happened */
+	/*
+	 * Reset all restrictions if an error happened, but retain any COW'ed
+	 * settings.
+	 */
 	if (ret < 0) {
+		struct io_bpf_filters *bpf = ctx->restrictions.bpf_filters;
+		bool cowed = ctx->restrictions.bpf_filters_cow;
+
 		memset(&ctx->restrictions, 0, sizeof(ctx->restrictions));
+		ctx->restrictions.bpf_filters = bpf;
+		ctx->restrictions.bpf_filters_cow = cowed;
 		return ret;
 	}
 	if (ctx->restrictions.op_registered)

-- 
Jens Axboe


