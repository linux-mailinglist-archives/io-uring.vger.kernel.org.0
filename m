Return-Path: <io-uring+bounces-13326-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UMyoA5LNBWpGbgIAu9opvQ
	(envelope-from <io-uring+bounces-13326-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 15:26:42 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 780AB5424FB
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 15:26:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 23277304F417
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 13:24:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 234FE3B5F59;
	Thu, 14 May 2026 13:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="vUTxV83e"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DF026F293
	for <io-uring@vger.kernel.org>; Thu, 14 May 2026 13:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778765077; cv=none; b=IRPjmC8aNSmg4S0b4O5mtBBKgOWKpUobDcIjAgQ6A0KMELh2Rxxhg115+oPWRTjN4UyAGt0InbYn4RpGts565L1IIxDg5r6SVRgc6EZ+c+pQIKsSA+OBbg3gT9XnJAMdL0nq3pHPSGqKXrMCefMKEXatVdmiPwpykVAh66JHzXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778765077; c=relaxed/simple;
	bh=RrT6toACTl5DT3wmIMVy8+3hqwxauglhJEk+RIH79zw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=m6kX8OStLrWioydCJ+1QnWZskF9uT7tBTiiG/TVqmRhl7vnF6mU4FdP2yMLmWSLlQbwo2KysPiwbJYdpOXN3Ib9jFYjpctuqeANhe4YHLXUUZSHWvYKkXDKv7z3eXKISWy3OM/vWjnfVyqOWPByzYODRV/+wV4HC3oMipKG7hHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=vUTxV83e; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-47c35be02fdso3139847b6e.3
        for <io-uring@vger.kernel.org>; Thu, 14 May 2026 06:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778765074; x=1779369874; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nJTd4wsSMNZra9aHETQpZm0OARY0xx4eMpBIe40gR1M=;
        b=vUTxV83eDLs2CtoZZ2ffLzpCh8bfz+TPeOK55lSU3EDiZUqLamR26zLMX/8f2CkDyY
         Fa4w9JimsOGTnyFHqQLlMpw+PDT2ih0FXiKVAcpL84Zzz6LgFBxNPc3gXgMCc5HaAm2N
         mSpN6LFxM2zkWgrG2gRbhlGydnMhTSvg1T/1sIbFX1+fe005kSj93S2XPX/uPbegc3fJ
         63Zj7XSKe1WSd/MnVCabIs9ceWLdQi04VsGhH7/fHfnocAFegz44L7xU0Q1TLTkhgItN
         vib+R0oe6F14FRfu7fVo5MeTA1KebbvtAihm6WIINmL8GUGFPc8Xy7BglhDD9biYPaYo
         XdnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778765074; x=1779369874;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nJTd4wsSMNZra9aHETQpZm0OARY0xx4eMpBIe40gR1M=;
        b=O8Ibp8NQneXDUaCBUxKoE/qdOAJBUvyA3p9UWdhIdjfivUoQoO6NEDScv99OzjY89X
         dGOJRJxTiais1w59cm8ia2HbtmQFJ4pfGkr9rONB2CNPOA7qb8KFdcFAR/LwidMOn93w
         AnwZUn9hih4kWfORi1+mT8uYk2huX9fy+fRgOI4pkZRz9ENfVXCsWsNGE0QUMpltk8Rs
         HBRFoC832Za8L5BBfJciPAIl411HdgfzbLRQ38HXGdSmyH5unwYlal0+3GqU+w6K7UOZ
         gDMDh0ffa8D/AkiXP1hEVptp99NhNavAD3U+Cx/dqmE0gMCYL9P8E01iQSDHREsJo7O0
         XxrQ==
X-Gm-Message-State: AOJu0YwMp67cdiHhfsh7lXhHVAAYiODloPKspaRGUVs+Bv8N5/50zeb0
	k/CtYReuukkFBXrZjW068ebQOtYDeN30AuZTfSd4tdL7lUWnh9lqfPliQJfkx3AtkRQ=
X-Gm-Gg: Acq92OGNbwVsTtKHuvulH1VEkVKRxdHHVpxurrYUYLshGEH5Iil7ySQrDwtWpCAaZaJ
	nCZ6GUO1iv9vOiSwfnATpBlSmhmi3dsdPj1z4i3R4t4fJAJArirVS2kkTtQ546Tzu9DQIapXjfn
	xebkutmdPqj0HvgLkR9RM8p7JGBVnxN0X7it8QfdTXIQdydoHA6U3xKfwWBFvmlrUFRQbejGF/J
	+5NBq+PrY7dGzQA6sP9vsgLNnCyYWaSzHW4s2TNyME/16Z+B0vdoJydExdZL7UBSNRX2GKdnOjs
	FsxhcbD3aldT+9ToCrNhFjHlhuGaJXsyCj9LZ0QMusErKtP2WiL+TU6j3NCO/mEjVQyzMZRLZwY
	0Hdy42eEElCejMBwBmf7rUE28txXie+FYWI33pgYEUodbRWolJNb1Fo9mOZ+Bqac1EI4ovgcmOh
	hfIOgd5wQDjXa2L433tWuErSam1DENnwF90/NC4u2sBhVmWaz1eBlqdr8oAxH5Y7A/tpAcpQ+09
	vU=
X-Received: by 2002:a4a:e913:0:b0:699:90a5:106b with SMTP id 006d021491bc7-69b78d6ee9emr3659916eaf.24.1778765074142;
        Thu, 14 May 2026 06:24:34 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69b8ca96c9dsm1196505eaf.11.2026.05.14.06.24.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 06:24:33 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Shouvik Kar <auxcorelabs@gmail.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, Kees Cook <kees@kernel.org>, 
 Christian Brauner <brauner@kernel.org>
In-Reply-To: <20260512110242.26219-1-auxcorelabs@gmail.com>
References: <20260512110242.26219-1-auxcorelabs@gmail.com>
Subject: Re: [PATCH] io_uring/net: allow filtering on IORING_OP_CONNECT
Message-Id: <177876507317.606913.15547662217786217356.b4-ty@b4>
Date: Thu, 14 May 2026 07:24:33 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: 780AB5424FB
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13326-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FREEMAIL_CC(0.00)[gmail.com,kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[5];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Action: no action


On Tue, 12 May 2026 16:32:42 +0530, Shouvik Kar wrote:
> This adds custom filtering for IORING_OP_CONNECT, where the target
> family is always exposed, and (for AF_INET / AF_INET6) port and
> address are exposed. port and v4_addr are in network byte order so
> filter authors can compare against on-wire constants.
> 
> Skip population unless addr_len covers the populated fields, to
> avoid leaking stale io_async_msghdr data on short connects.
> 
> [...]

Applied, thanks!

[1/1] io_uring/net: allow filtering on IORING_OP_CONNECT
      commit: 899bea8248cee35d54760a5e7d61a76af8e64411

Best regards,
-- 
Jens Axboe




