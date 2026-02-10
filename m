Return-Path: <io-uring+bounces-12137-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4L2hOBijiml2MgAAu9opvQ
	(envelope-from <io-uring+bounces-12137-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 04:16:40 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A8D80116B5F
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 04:16:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B808930234DA
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 03:16:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B80952FE048;
	Tue, 10 Feb 2026 03:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="KW8rdMC+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B6227A904
	for <io-uring@vger.kernel.org>; Tue, 10 Feb 2026 03:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770693397; cv=none; b=VDcv/QDNYdTXhTFuhNXjHmODX62yRP0Di/F79txCHhc3g1HHJaQgutcUfyXpQpxdhSmpF/V8clYixAbsbfBcjlgHqGoK8S34Bct40Hcfw3QlaSrom1xeAWhYAFAxFigudk+c4HdcTmQSmR1LjdkWX/lyIK3bzSCIfSL2ryhd94o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770693397; c=relaxed/simple;
	bh=q9jNzlfaAy/I6pbwY8FUsKP82anaZdGZflN0fmLkRTg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=D1PgWG7pVGnxvsHWQBmllcI27fi+fMxDFewYMa/5vFxTIbrllwdWnWVKgEGD4wy2ZOu8Xn3bqyf+S43wGZR8Q2/V6bgaD/lhuukPwsABP7pl9fSPyIYHpeV7nz9lk9+n6u8mmrs1jYZoLmeF+BLJbf7WFB0sLw7g69gQ7VJtfkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=KW8rdMC+; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7d18a9d2b1aso4280564a34.2
        for <io-uring@vger.kernel.org>; Mon, 09 Feb 2026 19:16:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770693395; x=1771298195; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F0t7uvmWqTJv0ETPhyxHfdTPm926rJnNC5OBCXyIqkc=;
        b=KW8rdMC+77zyiF6K1ZAzMCHozsScuzZOrQkT9D+b6y1dAkn6HrEcxsmMSLIBiIr9QM
         vqvD219Q3OpvtDepMQg7guHyaxZwOwB5gKwRSpusYb9FpL+vZJLsnUtRiwcrIjFHqjZK
         QUoflsRdSo6Qy60Vt+wgoJNWvnAR+imjIxYNdHUxR2o1vfbsIfFgzuYPfm9X2N4rzwjf
         uaeJSypOcr8DqStUsdXw7lLmczeDYaLS+mFZNFhmoPOkKUqKavOmPszzvD7wqyzs27RU
         f+RRx8xnC/HhUojcqvcHk8Dti6I/61ybCeKN7bBigJyn0AWMQR8SrYeC7XftBOAMsK7+
         +hvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770693395; x=1771298195;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=F0t7uvmWqTJv0ETPhyxHfdTPm926rJnNC5OBCXyIqkc=;
        b=ll40wZGGWgflapKYJ8y5kaQopCB2b7mH9SUYCKqMYy1q8WT6otqCsY3CJBQQjOBa9F
         ycpBkJ6H14IYo64HoZZyz2457LRiN4eJrInB80OfcjxmTCHmJQo/MyxDoW8FiTv4vTd6
         QrqRF4liySyQboJ+QQBxQDTPyjmBA6wEWdANvuiwd4h33z1FKqfeoE1WCrmwI0jSQFmB
         /qdxvuA/LqWMcdpA4zfggy4nMngjnNIIoxnbSPZV7NB6doW3NcUP+H49h8GCo6+TZnjp
         420ZbhmuOITZEB6o1jouqI/VXu21dQR9vF0Wb68NluzP2Y0mmNAfBBPI3wtm5NPLk2DA
         UkSQ==
X-Gm-Message-State: AOJu0Yz5x3YuQxeQIQuZSwXExmYziWFqod8A28dhMnG+HdEM/UTOiEDd
	alIL24Z4OmWtQhO2LjLeFBr66a3sP2m7uX1k9yK+kAWWylS/4RaA/RNFkHj9s3HNOFkf8Wrz/nv
	1mYu/EVo=
X-Gm-Gg: AZuq6aLZ/DNLQuljA3v3Iya01vZG5QMQhAA+iIHaWR4YY5HeiNv6xvmsa40p0Mb62LD
	Fj2G+IzYjdep9JNa20tBqRV0JzozaOgeOPMgdPGt7P3g6hEBM35Q98bEKxU51kjl+wkPQ09RZBW
	Pe2tIw/QipaoPxHoFQHG/RtPzQixe6gMCgnGk9ncJtpW8XvLG2nMlvjQVYFt+KpQ4pPBgJPXOHL
	d0hC5jbMomK05VQD46OLIFPIFeeRK6GKAzHfrBiaRml7ofnqWwXrUIByQ/DQUUSyu97YtUpKP3s
	ycqn6GFvJsKotUncqOJ7jHfZYDn4lFkoqFJ1aXKplx4wiNmr+i+1fPBxb3KYdr5Y/BOBb6f8OBJ
	QxcoFUfAy7L+MvD/85lEoeawnIS770xgCVY5HeUxEJMLfY9xpr1LLGNYBzlG4sLhnZ/HDdFhcK4
	aNwZIPF4mIOSjoqpYUkE6jxluRExBL4lZB96LHUsukmx9I4KHGy4QYOZC0+beitpk/WeLy4jafk
	Dr2
X-Received: by 2002:a05:6820:2209:b0:66a:b73:5e2d with SMTP id 006d021491bc7-66d350d0df2mr5728081eaf.59.1770693395200;
        Mon, 09 Feb 2026 19:16:35 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-66d3adcaa9csm7545605eaf.11.2026.02.09.19.16.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Feb 2026 19:16:34 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Yang Xiuwei <yangxiuwei@kylinos.cn>
Cc: io-uring@vger.kernel.org
In-Reply-To: <20260210023432.1874130-1-yangxiuwei@kylinos.cn>
References: <20260210023432.1874130-1-yangxiuwei@kylinos.cn>
Subject: Re: [PATCH v2 1/1] io_uring/tctx: avoid modifying loop variable in
 io_ring_add_registered_file
Message-Id: <177069339380.478075.8988787095054858919.b4-ty@kernel.dk>
Date: Mon, 09 Feb 2026 20:16:33 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	TAGGED_FROM(0.00)[bounces-12137-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid]
X-Rspamd-Queue-Id: A8D80116B5F
X-Rspamd-Action: no action


On Tue, 10 Feb 2026 10:34:32 +0800, Yang Xiuwei wrote:
> Use a separate 'idx' variable to store the result of array_index_nospec()
> instead of modifying the loop variable 'offset' directly. This improves
> code clarity by separating the logical index from the sanitized index
> used for array access.
> 
> No functional change intended.
> 
> [...]

Applied, thanks!

[1/1] io_uring/tctx: avoid modifying loop variable in io_ring_add_registered_file
      commit: daa0b901f8319414cf9f56237f15240b95e4b1b2

Best regards,
-- 
Jens Axboe




