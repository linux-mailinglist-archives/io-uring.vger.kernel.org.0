Return-Path: <io-uring+bounces-12928-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8EK8OBx/zWnqeAYAu9opvQ
	(envelope-from <io-uring+bounces-12928-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 22:25:00 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4996A380247
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 22:25:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B25EB302A6C4
	for <lists+io-uring@lfdr.de>; Wed,  1 Apr 2026 20:21:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33AE9258CCC;
	Wed,  1 Apr 2026 20:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xzpBlHO+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA03221FBD
	for <io-uring@vger.kernel.org>; Wed,  1 Apr 2026 20:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775074917; cv=none; b=QOj93StjDqLtrLmTDk3uk42+7qRYHRvtXjVNYUiRBiHVCI4ekYIt4+L0FXEKNN/AInzRbXnGpVu62UUorOJiO3zW8O/WV+gLWt/VuJqLmKL8d8aa/J56Bnf5ymj02e5QWVNdlKXoWHvx+a/4eirkcT8a7Y7Ro2LbkN/qzLPovbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775074917; c=relaxed/simple;
	bh=RK/wQxGie/X102BD4ToCzhb1OI0D4km0csYNt+6DWvc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=QrAtYdDVWIF8j3yWOlFiyABF4hLdyEKdcQM1EFePNRT8vEws87mX8u9N2+TVZhQc6oQ9DLbS05uQlEsOqxeAZ3zDNIvQwQTrnc9Rwj/kR4kGFVA/rt0IUzIdH27dcSRwz1lVwA1iiQNXLRtu3iONVqKg5Xxm0sp1xixCKWSjkQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xzpBlHO+; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7d55b97f358so100908a34.3
        for <io-uring@vger.kernel.org>; Wed, 01 Apr 2026 13:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1775074913; x=1775679713; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LVgq6SBHbICDHMSKhWPDBbpPijK2PEvUuj9ropz9eBY=;
        b=xzpBlHO+iLS9LBia9jmMf/yUSIFAb8tpgPX6zx8+WhhSaab3H7Ad5xVhIF7WU/PMUW
         CSNhTviqYeUGSKz/892hFybOifVRBRmC/IQAAVAx6y6hai5V/e8RuIBsnv0yTYHThD/O
         uXFFirxQFybalnCPnYH9MvPfVDoE4eilyz+NZ4Fce5FZG/8oshC/KKi+wZZ6hu+4cYUN
         /cyqS/LH63A8rgQwlioFiUV2x94Wj5VNTDGUoBrg4XDPgOMh3XnaX+vPukbf7karm6U8
         DruNYzUvmXtzqRWRs2n27NDb19IDDwA7xtO1FDpI8iC18lDmFkgkOh2abhUYmC5QVKsf
         FUug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775074913; x=1775679713;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LVgq6SBHbICDHMSKhWPDBbpPijK2PEvUuj9ropz9eBY=;
        b=hy04DiTvMoI/CRyWUhiM3N88tMdlahcdBSdRe+lnDDVMjfrD5UwMdjzsOE14oDZOj1
         eoxDBmvGRoPvlrr8cQ2JLkMe2HWiglU+1Sk9fJMnWysn0g9Kj3S2fWaBQW7nMd1g+eae
         oLkgjVYkaaB2ciEdLKrwnwI+6dz0sDUaHwJpqpBETbGSvtWGQZSawXCDNOOQTTr34sUE
         eIKpRgeeQFXiEwz9JKx9S4DaiQkaH0UDL4839hfittbNFieRLgnNN7NXY+6TKu4ZT9Wx
         J4Pkr1vUHmfLzeA+keNSj+ESjmtXXAElbDAbrrONlwKxIpZx2SKlMTkJ2tdPw6CDK65f
         cENw==
X-Gm-Message-State: AOJu0YwjMLSfRYjBq+7Z0AttITQBpLYRfiLPWm98RAlx7dT+/CEzwdAj
	mOmIq6rFgD3zfjMn5iW6/csEX32CE4GgN3DMw48mMCmDYFFPUaYIIyuDaZ9SazNaoJ4=
X-Gm-Gg: ATEYQzzBVy9CBtWuI+WVvCKY5ESbwEx7kYany2FkjZzBqEaITQE+u3lDzN1mycjp5zo
	htBDEaiXga6c6zPI0Oe/yNs6At9PWKwBbMqxEgcbMEbSSeNDwUkU/OAW5I5NsTiltvOa7VUwLj8
	EQ1JhRXDEH0x5c4ZmwOk5+n+8z7Y8yKeM6lbuH3l68ES8ejDA91nZyGCzVfUY6a1bT420v8uN4+
	soeVISIX74XeyezZrxbYycFbR64BacO3qynlYOXwe7i26z1h3g/mFkBruZxdhUAtktrpRl8JRYN
	zWs4jredpFa720UTGmumqKNp9De1B5l6ZqKcrZJseeEC2aYCaLwVXgj1POZ1h7Upx9Lm9R3INsM
	/HoQdi0USrAPZ57PI4LKWFMBDf9fuzv1Hm4p8/9Mg5EG2XrKkOd7viNNcUdyeMugE+48hWixJSm
	fiqMc8oHKZz5tKQRbUT+VA2KBu8YOss5/mgZJp60Kv3vRJq4mtJnY65m5phVGHnnoo4UWe61mvA
	nSEDJ+cwkexdg==
X-Received: by 2002:a05:6830:4410:b0:7d9:f50f:96cf with SMTP id 46e09a7af769-7db991d714emr3524928a34.6.1775074913514;
        Wed, 01 Apr 2026 13:21:53 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dba72febcdsm641217a34.18.2026.04.01.13.21.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 13:21:52 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: io-uring@vger.kernel.org
In-Reply-To: <20260401173511.4052303-1-joannelkoong@gmail.com>
References: <20260401173511.4052303-1-joannelkoong@gmail.com>
Subject: Re: [PATCH v1] io_uring/rw: clean up __io_read() obsolete comment
 and early returns
Message-Id: <177507491251.129411.4935904214369196186.b4-ty@b4>
Date: Wed, 01 Apr 2026 14:21:52 -0600
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
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12928-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-0.988];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 4996A380247
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr


On Wed, 01 Apr 2026 10:35:11 -0700, Joanne Koong wrote:
> After commit a9165b83c193 ("io_uring/rw: always setup io_async_rw for
> read/write requests") which moved the iovec allocation into the prep
> path and stores it in req->async_data where it now gets freed as part of
> the request lifecycle, this comment is now outdated.
> 
> Remove it and clean up the goto as well.
> 
> [...]

Applied, thanks!

[1/1] io_uring/rw: clean up __io_read() obsolete comment and early returns
      commit: c3196f84b1e4089287bfc6745496213f1e46bc00

Best regards,
-- 
Jens Axboe




