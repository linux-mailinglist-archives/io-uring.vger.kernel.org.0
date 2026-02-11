Return-Path: <io-uring+bounces-12172-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GCRdIIEAjWnAwwAAu9opvQ
	(envelope-from <io-uring+bounces-12172-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 23:19:45 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C4C2712810F
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 23:19:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 61AD830BB52F
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 22:19:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C06CC29D297;
	Wed, 11 Feb 2026 22:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="F4kMzzkM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40952324B34
	for <io-uring@vger.kernel.org>; Wed, 11 Feb 2026 22:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770848382; cv=none; b=UsBiCeygbYWtth5cj0L+q0RG7K04FEDyYbGvVORBxNFJmfI8E2dvXilWXyB8tb1992ru8xDmOAseI7ov7W+mphqzpPOM2Ob2ZocDRFP8Ffx8MUtiN+sj06JErhQMq+R266e5WtRhRrtThfpEwIf3316XZpnHKYhttTGpc3N/ZfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770848382; c=relaxed/simple;
	bh=OAzMgD+sVMzNwOHwIAAJqEcV74BtB6RaJ1ul5POyZTI=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=VlUvMDp1JJLsbVrtgFa/qaA6sG0sohdVVrqh3Jg7bXrOnZbRfdIscmmhQIjwJZPcLnThwcVNn2gQEfRTODRg7mR01FAZ+a/yoyzY+wyfJ5oNLVHSbS34KqcsPnnlWM+7gKNS5jh4Znhif02G2HT3qxsmL/lz08173f+z4wFBLj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=F4kMzzkM; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-45ee8823e2aso4416527b6e.0
        for <io-uring@vger.kernel.org>; Wed, 11 Feb 2026 14:19:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770848379; x=1771453179; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BIcD5KtuEIQckY6mCV+CiyR8T7ku6Xpm/lKo27x1R6I=;
        b=F4kMzzkMdZHKoJrgNfYVHGgo+xRktMwygdWArp1zQND89m/4eSTsPVZtTiogiB0Bxn
         19X73kMCCYo5JDplpEO98yZ5mf24sJXVqiAOutqAWTFMXUrYHNccpIJc8Lp6mbZAp39u
         DRBwxImXq83UcsfGu5citawgmPduU21RVAb+3mU081/Bf/6unabRhx41D3ZqX7Ipeh4R
         MhDwbOvtcpvw2XOuUrkBJKa84QIetNqnfo91d9a9io6Kq202cRHy6db5a35pxEAvbO1M
         2cMXb2xKjn8pePhLPIllYqj0A+K6/C9UpErvcrqSQo3gRWD/E/kg/TWplnM2QvSakmzX
         D8sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770848379; x=1771453179;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BIcD5KtuEIQckY6mCV+CiyR8T7ku6Xpm/lKo27x1R6I=;
        b=rZRwp/LrohmUHtgE9kBXNBRJeKb4QKe406zVE6Or+ZUJx+5Y1kbU1mBUGPMU7qukNV
         fvNcGC814bkHjN2EPlFWpo0F8ph5UdHVv8GUUYBrkwdB9UPFq5ym0s+vdn05knWd4JGl
         px2sHAqcPEIYwQEd1Ku1dREFVwY+03AH+PDSXTl6GBfAlC9Wu7xgjN7EopPiamZkAUk3
         NwsfIpAmng7DUWsy+MifVtCUXW9KK4T/mzPZEGRV0ChbbA5hslV4oxoddefpJ7fPnfN7
         FJdCLVhMvQ3cobbux6FfnZrG/e0ZXgjtc/Xfg17dZkw9GfjI5K7G5bLnOdZQiQvvP9Rw
         kyHw==
X-Gm-Message-State: AOJu0Yw180nrkiaBhK5ZMc/zYaY4QoWKnsDrAYvxBpjxITBbXoRbOIUu
	5iarqANVbPK+7qu9RNE25E8z09bonk4kf7bxxoNfXDkv/7HasnYsCJ50W4kknerQ29JEP/tc7xw
	XVgy1GSw=
X-Gm-Gg: AZuq6aLVME3NpzkYPd+DEIxTSZUc8Fa++hhtu1CWpDiaKseJfARg2B1Dh9yLObkahvX
	zETWqlWJCl7bI3WRGUUldCQbqngWL/myJqXzbmWB4C9ZzYvV0VBx1gbNE5tguxB4bKE8CE/SLek
	pdvOeFyFGbAn0h9K9u2g6Mrneinb4TUbT4BU8kYIdsYNkgzLXfImpvW3r7Tm0LTfKsjW/RRNkws
	kZLDENrb2tNro7WC2hPiN+RTo1HOgOHTxfAQMk9CPpSlBkf3LupeV3nBWdKQOJdVDYqoyUExOQj
	wh8pjWKJ2+I/7DlG8OR+wonAD8PTX53O5ORyt8Eb2jaVFbd6p1i2Zb+RxH1ylS0Sg1hVTmEcmB7
	PFR23IIGItmAgt2vj6cZwRvn11pN1zS9IjmodJr7P/GVAI3oMZ/rizpXZl4GEb249mx10ihE3CT
	Lk+INqyvSj7jcakJ+tyeIlMuNq/t3y88xwDAoYJzpmY2GBlXvB1g5R9G9ScTHhruDol7rsSU7D/
	1h6lYQr
X-Received: by 2002:a05:6808:6b48:b0:450:6eb0:3481 with SMTP id 5614622812f47-4637b8ba1d7mr429323b6e.43.1770848378955;
        Wed, 11 Feb 2026 14:19:38 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4636b064d1asm1726801b6e.11.2026.02.11.14.19.38
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Feb 2026 14:19:38 -0800 (PST)
Message-ID: <e2269f5c-bd17-4900-b615-392e76314f9c@kernel.dk>
Date: Wed, 11 Feb 2026 15:19:37 -0700
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
Subject: [PATCH] io_uring/filetable: clamp alloc_hint to the configured alloc
 range
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_ALL(0.00)[];
	TAGGED_FROM(0.00)[bounces-12172-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid,kernel.dk:email]
X-Rspamd-Queue-Id: C4C2712810F
X-Rspamd-Action: no action

Explicit fixed file install/remove operations on slots outside the
configured alloc range can corrupt alloc_hint via io_file_bitmap_set()
and io_file_bitmap_clear(), which unconditionally update alloc_hint to
the bit position. This causes subsequent auto-allocations to fall
outside the configured range.

For example, if the alloc range is [10, 20) and a file is removed at
slot 2, alloc_hint gets set to 2. The next auto-alloc then starts
searching from slot 2, potentially returning a slot below the range.

Fix this by clamping alloc_hint to [file_alloc_start, file_alloc_end)
at the top of io_file_bitmap_get() before starting the search.

Cc: stable@vger.kernel.org
Fixes: 6e73dffbb93c ("io_uring: let to set a range for file slot allocation")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/filetable.c b/io_uring/filetable.c
index 794ef95df293..cb1838c9fc37 100644
--- a/io_uring/filetable.c
+++ b/io_uring/filetable.c
@@ -22,6 +22,10 @@ static int io_file_bitmap_get(struct io_ring_ctx *ctx)
 	if (!table->bitmap)
 		return -ENFILE;
 
+	if (table->alloc_hint < ctx->file_alloc_start ||
+	    table->alloc_hint >= ctx->file_alloc_end)
+		table->alloc_hint = ctx->file_alloc_start;
+
 	do {
 		ret = find_next_zero_bit(table->bitmap, nr, table->alloc_hint);
 		if (ret != nr)

-- 
Jens Axboe


