Return-Path: <io-uring+bounces-12635-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IL7bCQlosWnsugIAu9opvQ
	(envelope-from <io-uring+bounces-12635-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 11 Mar 2026 14:03:05 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B0A3264132
	for <lists+io-uring@lfdr.de>; Wed, 11 Mar 2026 14:03:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2446D305DAA2
	for <lists+io-uring@lfdr.de>; Wed, 11 Mar 2026 13:00:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA72F19C553;
	Wed, 11 Mar 2026 13:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CnOFNMxp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619F58F48
	for <io-uring@vger.kernel.org>; Wed, 11 Mar 2026 13:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773234040; cv=none; b=pZ3KBc+KXU/iWqaizGKwjOxqa9DtBKZLmsX74MEdPlGAWGvQMlWnMqd0twlN0mj2neHtg7jR1SZXce4m9hIjfLuG/hVzrXLHBahZ/vGOkyic5L08bBEsj2VwyCIsqF6g0rw/g4yMv6Yz80QcAFeCKuAy+1LMUrh/VqsRRq4tdAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773234040; c=relaxed/simple;
	bh=LXS4b0kDAKA4g7NUC9YDIR4zo8NIZUl0tQDlT4SvKys=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=s6n953tW1R03ODwLLWHcMrMb/LhEFo6h09CE/YvRJGBRC0y61Bilzk3csqJzU2QDV4WFaUhYLvuWzqCKwJcXlHpeG4aMpudymJLME/P5T9r/yS6BX5ZvgRubNxFshfUwRlkccP/1QLAuuhjnG+ToXx80P3/KArwBAacTZS21tbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CnOFNMxp; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7d773a4af0aso25342a34.0
        for <io-uring@vger.kernel.org>; Wed, 11 Mar 2026 06:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773234037; x=1773838837; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tgCrp9Vn7i6Zkgjd+jhK7Z7pEmf7HJG5+zYuD5Vo9I8=;
        b=CnOFNMxptGjd/D6+uXf7754Vu87hRejbCSdt++i8VH0s44kBjYqvFGcYn2u2+GZSV3
         lduA3j8UzwkaLmXz+6au7HW/HIaCghEskcpypnQE6HppXuA/yuAvBwkulJBQOADcDG48
         1RD1LFCHCZER5EWI2T1USOpKucBN45fkxd4ru9cr76lwwGjSzda7cw9kSxpRRc3EYPcO
         GlpoPkcNg08dR/34EjO87+puDpheyItUnCoEV8sv7ewlqx7LwV9mZsYRsRahjyY0tdyr
         hMcTy50j7QM7eStjTFCHF/zYZUfZvJ6ZGanMlCjGoyV/AtfGNPA3os9mZ/I8RTwr/vir
         YyHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773234037; x=1773838837;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tgCrp9Vn7i6Zkgjd+jhK7Z7pEmf7HJG5+zYuD5Vo9I8=;
        b=bD4p8LDXVNW5YrDXe8G5LnFXdI72cw+XoDtj2ZHJeveMrkaDPBiH0teP/OH4lQW0Qn
         NJxbhtpocBzoWBufnPgR7b5ze0Evd6QHYqsrQfg0C+ponH82vvUsI0kiWGNYPnv1x6VL
         rytnydx/DIkcyRScgHXCOFiC/PdJe00trLzTEUMujsFVvKatiOwd8mXqZr2Nx/wSUSGz
         YuD6KRXp51IlycXCFufrG/D+IoNEnRA9JcA/bJSTbw8LgfsiU2E33t1ETqg+MMcdya+x
         9DqIZRwzQ+jrMQxQa5UNA3C1dEPNZokd1qDYMNaf+4ATlKfmXDjOvzYKYhWfHqmZoSM4
         N0AA==
X-Gm-Message-State: AOJu0Yz6oVliMisan2PtfazuOpZat6j1CsoW4DNVgzwKpi8t5f6qD/x4
	bATL1rbpL5uR3gTJVoIiQbdwB81RoeN2agDomTjzKkn/TJLzuicRKt6vpqYZ/XHEnVSrvzGmLYi
	Mzz4ljJI=
X-Gm-Gg: ATEYQzxK0ISf1wFT/nKDyPXYLg391aZgusg3Aq5qGCpjo3jDbas1sYypjFVj0cXNxBV
	8xnPoclowlTGEnS2fARR9mo0k8Q1ImyeaHDc1qoTaZX4kMbQY/41K0Ej8VlDz78VKoOACNkkRoZ
	toTmrZGDuiqOkxeBiWod0nqD6Ve36UXM/vzXssFsoNFqmetXs5gUOvPBWJ2tLV4gsO8wSsOJH4j
	nBqVz89my2wbjLp9reTx/OqVWTHqjhyqkRCn0PlvY76KR0fTE7wNCHLy5vPmJW18f5j40061T2c
	pAFmN6fqw8nkHbacLWczGiyF6u5bU6Y7dok0nCR6OT4B4GLBMX/jqoZ8GzviHKCLFKWO7IX0UKk
	mfUmBaGy02j2Bsezb9tE6svbVUGRNB/l483HWFgwIKd8bBo3n2cKWVTcg8qsSa3hW1cuf63OVeF
	L5kI/3KOO08qEvTJOm+kslSuJ2qv88U2ZItT4KdH/DArggInB70gwfW40YjrbBs/eTyRTPu88Zh
	oEw
X-Received: by 2002:a05:6830:dc9:b0:7d7:5604:72a0 with SMTP id 46e09a7af769-7d76a697debmr1610845a34.13.1773234035584;
        Wed, 11 Mar 2026 06:00:35 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d7749f20a3sm9171a34.2.2026.03.11.06.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 06:00:34 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Tom Ryan <ryan36005@gmail.com>
Cc: gregkh@linuxfoundation.org, kbusch@meta.com, csander@purestorage.com
In-Reply-To: <20260310194449.79258-1-ryan36005@gmail.com>
References: <20260310194449.79258-1-ryan36005@gmail.com>
Subject: Re: [PATCH v2 liburing] test/sqe-mixed-boundary: validate physical
 SQE index for 128-byte ops
Message-Id: <177323403444.190825.17840012691916534088.b4-ty@kernel.dk>
Date: Wed, 11 Mar 2026 07:00:34 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Rspamd-Queue-Id: 6B0A3264132
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	TAGGED_FROM(0.00)[bounces-12635-lists,io-uring=lfdr.de];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,kernel.dk:mid]
X-Rspamd-Action: no action


On Tue, 10 Mar 2026 12:44:49 -0700, Tom Ryan wrote:
> Add a test for the kernel fix that replaces the cached_sq_head alignment
> check with physical SQE index validation in io_init_req() for SQE_MIXED
> 128-byte operations.
> 
> test_valid_position: verifies that a NOP128 at a valid physical slot
> (identity-mapped via sq_array) succeeds.
> 
> [...]

Applied, thanks!

[1/1] test/sqe-mixed-boundary: validate physical SQE index for 128-byte ops
      commit: a35e4943ec95af0aba795a58fd9d680a54406dc5

Best regards,
-- 
Jens Axboe




