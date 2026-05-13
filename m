Return-Path: <io-uring+bounces-13312-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0AyWFBlyBGopJgIAu9opvQ
	(envelope-from <io-uring+bounces-13312-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2026 14:44:09 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EEDC5333BF
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2026 14:44:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5C108303DEA5
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2026 12:37:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5939406268;
	Wed, 13 May 2026 12:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="tL9qCpZC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1187F379EE2
	for <io-uring@vger.kernel.org>; Wed, 13 May 2026 12:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778675778; cv=none; b=o6wBnAzRHlu178iyfXy1i13JRSouS5OUsNYMcIOMsXQEx292g1vMqwxoOx/6IPYX7Y8ZwQa1JurgeWNnueoDXWnZzU2/kby56eBBkVXserMIaP53Q0DaXQKHVw4zJk2dw8VNCekjccy+gyPlunM74F5hzYjbNulOS+zBdmgMqs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778675778; c=relaxed/simple;
	bh=sbFNKdic5N1nxemCfVVj+fHFd75uZ+iCTrtWdXoMxDs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=uJmCoLihigCjuOaoNplZrWzPAAHfx3gkd8IN0jD9+WstC2Hrrj21n7qHO9a/0mEBWa/9BylbtEtgTKwVW7ukV2O9E9ZjHT/w/d7KIrBcR/oAFAPx8rMTY2odRn5ZXhpm6CpVJIG+ZaCI+B0brT6uCxx0fOooA/AEskyJ78k0+6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=tL9qCpZC; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-479e6bc357eso2609433b6e.2
        for <io-uring@vger.kernel.org>; Wed, 13 May 2026 05:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778675775; x=1779280575; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DYMDfr3O7tN6kvl9q/h1aItZWr5fr7tR6oKIf7iQGeU=;
        b=tL9qCpZCI+6d97hEWnqL9KV1PTtClFB21J6jJo+w1UDaXu135y/SZcZWrJ0f4GVh/o
         87LldgBwISaBL6Iv0ilyMHW69YJP9S3z7Mmb4amlkgCNo/hNgIkHC0fzPH8ABlLEFyiP
         lYUu41vwg7QpG6dxaotuCS73neqM15Doht/SucQIbuiNcGB/AKDnkh53AB9PfX3cOs+m
         srCCfe41ekghlsdzAAau6r7fVioTScHUI2YMsm0Mqi4X4TO/M8LVVrLxFbac224+EJIl
         NdGdXAYLqDv3ShBHmzSGiurz1iOkCeveqo1e/dYlLEEAHS2PT5FBcjwJAW2bJ5io6lT9
         +eLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778675775; x=1779280575;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DYMDfr3O7tN6kvl9q/h1aItZWr5fr7tR6oKIf7iQGeU=;
        b=pBk7z7umLJCvHcBcmEUyOl1PtjeUsQiqCToCAkHs6tm7OL+CbmMOqOvx60bTn7TW1u
         +TVeXxBnBU0xnZsyS6kk1LRiwyPGdHB6OCqj+s3OD49KlW3GkNtA9D/HwPuQiZXtkkls
         I03ZhEwR8n6itenF+S2+rKg5CehptUDnCrS6f8BwvTKdFChHQet1i1z8CuxpOzV2yWP/
         jtyebOJbUbhGPy2Pi4MJXsPm5WyElZv0XuziQ+adxZIDsgzuOwHFZxYQxDBVOJuOFall
         TsJDdMP9tH4EL6AXKXc20LMBdGrgE4wsAKEotJYfjmTZM1ZwHoXz3+cePioMELqm7Xff
         D2bw==
X-Gm-Message-State: AOJu0YwAVx4TE5MzMZN96vTxT5/lk97nV/SJwzeR2q0o/F3+PL4KTkb6
	cSf5NlNIq4s5OqfKXMMvSUYHtGWk63rJm0/cfudOtHSWgJJ+MsliniNz+bQTt6T5WLMYwNfEZdj
	7AWXA
X-Gm-Gg: Acq92OFcT+mGPMgw1pZreUIgM5kk+CrSKDz9J6+IJeczGtTswHtIeFWMTHjj6Km7kO4
	K4soydK4pZKd4EIE1Trs3ZJ2p/i+ZffoQJl3+yNMRRVaRpLsz+ZSTyLeqhtiMhjc+jg9T3njybz
	HglubTds68QOTvNPdPcQV0DGJRHly3NQbNzmQXbry3UNJX1no95QgjsxZe9b9KY+yAe1XFJCNvK
	bf1NzfmL2IqJNW+AGfYvethwTrRiy04PDHxZm8ovA5OZM5Afgy9HgzoRtOW0bK6yk3n/uX8lIO+
	GNdKHyEzgfP9w+XGCU9v5BdnJRiPevwVMEX7Ab/8pqVj0kc3JN72J/8aD+fJz7eI+yLCqOiO/Rb
	VBQjA2tddmsgdUim6jsjxpHWv1ikwbjXBCcv9csnJ0iAafGKm4AUqpO3MVh3cqv2Ed5AIKKYWqB
	5IswRJz4IIVk7eyZCIqxKWjpxkzHrFfpuZFfmpdqUeYhmf4gpssxRJf+ttXPL7IAhNrfjsO4aXn
	ZRI
X-Received: by 2002:a05:6808:2394:b0:46a:6e9f:dec1 with SMTP id 5614622812f47-482b2d92815mr1745686b6e.35.1778675774949;
        Wed, 13 May 2026 05:36:14 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4824f8f1964sm8345311b6e.7.2026.05.13.05.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 05:36:14 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Yang Xiuwei <yangxiuwei@kylinos.cn>
Cc: io-uring@vger.kernel.org
In-Reply-To: <20260513094303.866533-1-yangxiuwei@kylinos.cn>
References: <20260513094303.866533-1-yangxiuwei@kylinos.cn>
Subject: Re: [PATCH] io_uring/rw: drop unused attr_type_mask from
 io_prep_rw_pi()
Message-Id: <177867577347.354957.1601540161209886702.b4-ty@b4>
Date: Wed, 13 May 2026 06:36:13 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: 3EEDC5333BF
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13312-lists,io-uring=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Action: no action


On Wed, 13 May 2026 17:43:03 +0800, Yang Xiuwei wrote:
> io_prep_rw_pi() never used the attr_type_mask argument. Callers already
> validate sqe->attr_type_mask before invoking the helper (only
> IORING_RW_ATTR_FLAG_PI is supported today). Remove the dead parameter to
> avoid implying further interpretation happens here.

Applied, thanks!

[1/1] io_uring/rw: drop unused attr_type_mask from io_prep_rw_pi()
      commit: 5f7c7c63ffb1a187eb90c80864469db45f3bd2a8

Best regards,
-- 
Jens Axboe




