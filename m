Return-Path: <io-uring+bounces-12914-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iAtaDTgjzWlkaQYAu9opvQ
	(envelope-from <io-uring+bounces-12914-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 15:52:56 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A8AD337B9D1
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 15:52:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6310D30B7ACD
	for <lists+io-uring@lfdr.de>; Wed,  1 Apr 2026 13:40:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB3DC43E4B5;
	Wed,  1 Apr 2026 13:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="PGFAjVZ9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEAB43E495
	for <io-uring@vger.kernel.org>; Wed,  1 Apr 2026 13:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775050758; cv=none; b=n8UdLHuayyP8AjbaW36mkQqvEaxEuNZkpN0BLMC1zx15zkSEPGsbs6g3MP6g81m+3Wqhqc1/dlX1ar/71JJBzDiMGVryRudU47+yXkklkiqdbx51ZyGC/Fo8uT6RPKx1QTuCstHxaC/MWF2xuIHXKgdDJEHoWiAbUotZsVSYloo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775050758; c=relaxed/simple;
	bh=hketbG0+Gx79AbhidYUKgR4UjZ73evB3q+sujpFAR0M=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=TKS7ltqgh4gLzK5ajWP05+F9PG/cyDqM6HTgJs1kwq3zeYJzveuBJNfbTl1n5VhOdrUDUNpxRHXSToZDjC3mz+vdjlRg+dOmhM7G/cFy292yckIWdBT32aEBMjZcuMnIci625fOt7ZgoOJw+9Cs4iAJ+fzU/+LGwgycZCVCBTgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=PGFAjVZ9; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7d7c77fd31cso6342761a34.3
        for <io-uring@vger.kernel.org>; Wed, 01 Apr 2026 06:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1775050754; x=1775655554; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6f1joDzYvaTTDmb8pu5drhC2rH1ET3V7sJAc7QOTBjM=;
        b=PGFAjVZ995KjAQiKX8imXVjyZCYRcCLNHRkVPxD+VTntDAqEA0uslbIMF6kiPms2rd
         Q9CKnGtAnLTXhSmk5EYRp/lZV66g96qBwB3zLKNq84NIK/ovknGrWSb+on9M7yUQQCVk
         NCsanbdgxmcCGJJ9gIzwg/P1GMKWKeQRb7Hy8owoI+jDAOBAdcVGJYs+3EVvxzxH5vu2
         5C7IruvcXu4/zhADdMdRkmFftBfRC6iG+P5YNcP+wXF9vFuASjJVinILcRIh9I4c7OSK
         l31jis8cazd2FAu2Af1tWRE8lDCtUYnBTSNJCgmn3gBVjGkrXQEp9H+j+Xs2wD18q17e
         nThQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775050754; x=1775655554;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6f1joDzYvaTTDmb8pu5drhC2rH1ET3V7sJAc7QOTBjM=;
        b=Fw7WnPiB/bvRYqCIQPqcup2obN2btP1Q71c2+Dw7l9seVBAxoNDQhlVZ/dxF9eQBmv
         vWzLXcxup5vLgrM38scU/m06KYKZ8fCVah/wxyUXw5IqQI45cILTRXLIeyC4te/4uVG8
         f5mmKGt0xmWFCJJCTOQ0HbxkJP5fE8S8H48Jj7Q3Q1ulDrxyRvS7rV2HhRNgIYjDOSgQ
         kZVxVsv6j+WPKkkFaGuYJQd8QDoUH0W+a2yzqf3/R8c3TteL2JFRGwunIFxGmMv85GIT
         dD2BTg8Rm2DRSuqZlbCOHm4wOLymiGqTlK9wgcy43EMKZ0xnVi0WBKnIyJpCfRg0WzSX
         AvCw==
X-Gm-Message-State: AOJu0YxhGRN6sMFf6f5hDpKPCNnF4VIckFCK9bciAFt7glCcNyLfvPtb
	aNucxPq81DawC+Y9zWk/Zi/cnInBZwp3MjayRfg+5w2OxeK4IgLX8ifmEf2IdP0H0gdMiLKCBjm
	sSc4KOlE=
X-Gm-Gg: ATEYQzxwYqrvE3MkSH4LaUF5c4nB2Jr/7q2EW/5Z2NSawKK3IvEPATFBXkzpMX0HOMG
	4K829c4nQwoTk0ZL7befQYopEbtzMGAWM076ujmZJvz8RKiHlZMj82vZhpLbKhx9HLuYOOcZQ6c
	vfSMQocq6/NSqX42ehChQ3uAUTgqe+wYBKU2bWhtHKDJAQV1CgylfD4LulfTbC+2pJRS41xQDs1
	tLCQhP8dYxxKDBypuKLz0Nec/0NYziGc4eBdLOuycFvjAdBik/KWP3i8845NX8DVrWcBqRst9Ju
	lv0r6d/Sfokt3ze9dj3rGpk2mZXbCSrj6kolXE/h66SDwaW3AC4dVj364Cy8onPXewzFKY9P2so
	cwfsNuC2AnPnmAo0i2oZkzI0KPnhFNA4NuSgGS5Pq8VfPLzXQJNXE+InX2LO+IJnJiFDlilG2ho
	qScghwOsdctHj/yhpzb6PYDB39hARXRXCKJdnYvHm5fjhpSMZ9kSpjJ3pRW7UidcUKiuvvF2R8P
	mWDeX2jOf+jvAU=
X-Received: by 2002:a05:6820:1992:b0:67e:16b4:aa07 with SMTP id 006d021491bc7-67fabd02b7emr1830928eaf.61.1775050754417;
        Wed, 01 Apr 2026 06:39:14 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67e23031720sm9598777eaf.2.2026.04.01.06.39.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 06:39:13 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org
In-Reply-To: <cover.1774780198.git.asml.silence@gmail.com>
References: <cover.1774780198.git.asml.silence@gmail.com>
Subject: Re: [PATCH io_uring-7.1 v3 0/6] follow up zcrx fixes
Message-Id: <177505075303.60447.2600863818242060387.b4-ty@b4>
Date: Wed, 01 Apr 2026 07:39:13 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.1
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	TAGGED_FROM(0.00)[bounces-12914-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-0.992];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: A8AD337B9D1
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr


On Tue, 31 Mar 2026 22:07:37 +0100, Pavel Begunkov wrote:
> Follow up fixes for the recent update flagged by review.
> 
> v3: include the mmap_offset cast patch from Anas
> v2: reject REG_NODEV + ->rx_buf_size
> 
> Anas Iqbal (1):
>   io_uring: cast id to u64 before shifting in io_allocate_rbuf_ring()
> 
> [...]

Applied, thanks!

[1/6] io_uring/zcrx: reject REG_NODEV with large rx_buf_size
      commit: f13bf23a829f39f21ac6e0757efe11304fff0e6a
[2/6] io_uring: cast id to u64 before shifting in io_allocate_rbuf_ring()
      commit: 42cf59688914875d6eb06c9674a4b33984e6dd45
[3/6] io_uring/zcrx: don't use mark0 for allocating xarray
      commit: f168ed94b91a63165b99abb868eb3df01b5b5aef
[4/6] io_uring/zcrx: don't clear not allocated niovs
      commit: 600bf4721005b73763089328f17e5248dba2c034
[5/6] io_uring/zcrx: use dma_len for chunk size calculation
      commit: 5ad086c24beda5154ca21495cbc32903d6d64337
[6/6] io_uring/zcrx: use correct mmap off constants
      commit: a49d0b79efc770727ccc9f962afa22fdb99736de

Best regards,
-- 
Jens Axboe




