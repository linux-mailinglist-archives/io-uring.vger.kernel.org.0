Return-Path: <io-uring+bounces-10814-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 66ED4C8B275
	for <lists+io-uring@lfdr.de>; Wed, 26 Nov 2025 18:14:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 579754E1E73
	for <lists+io-uring@lfdr.de>; Wed, 26 Nov 2025 17:14:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C072B33E354;
	Wed, 26 Nov 2025 17:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="gOS1SIJI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80ADF33EAE7
	for <io-uring@vger.kernel.org>; Wed, 26 Nov 2025 17:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764177277; cv=none; b=gFgRuH4O8DDMBf50QKYcvXdoDNPBqOQvL50Cw7k9l75KTOZMIQQDyorC7aK+UzOUxKBmi+1/Adbu5GL7CTzv2Tg4Zl5L6jbKG0IDSK+1X+lqChjKeGpxhISyMLKB1LafdCNP4vWvVHWrbLfWRRagE6jSlUOhfU2DW7NMdf0XMX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764177277; c=relaxed/simple;
	bh=lbaDlQ7tLTIJ4Bs610zK2eA49dnMyoefkBqmbIAGDak=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=BSjZ+ku3pxzAG3yL7eoGUyfcoIAMdKkq4/Xo37UX7458esvnmRVjPmrcTvJneX6G3OzIrlx31yMYAqGO2zpAawrQ/lHIJB0L0cLxobZztYu8MIJwaXQcm2QSmbQs0tutTXWidn6VSK0oNpOeim9MoIWfTP3CzAqoAD8Z/4mKMlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=gOS1SIJI; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-948e1ec34afso274319039f.3
        for <io-uring@vger.kernel.org>; Wed, 26 Nov 2025 09:14:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764177274; x=1764782074; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CsiGGenxuL4YbGDC295QGlomZsbSV9P6s1hpNabHO7c=;
        b=gOS1SIJIUp7/M07r5q+tUPjPhq88ndLgo4CD2fDNz4mLGz3ELt/43ZK7npQCARMFbU
         EiLsw2T8GZUNtIefLYdCBp8oeAPY/wyxBOmolE/8IzxWcY+qMhRIXhq+O27WzJ8b7EEa
         tUCyGP5DDIpjeAuqLc2G6mfyiCbyJpnT3UQegkRLfdaD6HLqnRBIWpA+YByt0Fx9vvEQ
         5/0ukozz7d2uhbd/KBUdivnG4a0MoXrnBU5meurotY4uSH4cpTRCXNSciBULyIYnTSyn
         pDflMwUoJSExV38RHUSQKMP05efdReGuoV3QJYDEBr9DBcnMxYbizyILCLjoad9JvEfO
         yz7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764177274; x=1764782074;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CsiGGenxuL4YbGDC295QGlomZsbSV9P6s1hpNabHO7c=;
        b=pazukSdZMAhEmFDNBpydi9jrU5GVE8Jm2WXLd2SG4BGhYDDIhIA5BjP7ySWpibAqka
         IkCqgZspG+Txj5OR6fcMfacdh1c2gk9L2V1YbKezCDuqzJEztUxinAScsR4I0OrJbFVI
         dJkQknmTEgERHxzd0sfYSh5aJVcDGJFOcaWSYSCShPbN83Cff8GXhSNERdth0c3WSQoy
         89YFNtTEbIsd4Yi1NjtJYOfp6jtFE5hFpHiTbabZwQQjMf3aMcMoQm9Ycqniq25GVIFw
         s3s2TimTpi136xuohDJD5hQiKzHb6gDd+3lhJ4eGwePyQ58KSbDnjdVPEkzZPsMnAjpS
         psRA==
X-Gm-Message-State: AOJu0Yyiu2mSezW9gKHMF/IvN/rBO33ILXAI+f2g4p3ztKUK6fY6H1G+
	IDJtOwOmNsvI8ZX9dBIFHAV9fZmpJv0y/uHpvxyRCgNGNtL6YxwoDZRuxl9at9QCtvKnqXO2yZu
	2XuPU
X-Gm-Gg: ASbGncuASFUoTriyJ4z9caGST60chgitTLsaErd582Zv6Lovo7fsQacLSlmJHbAZ5mi
	mtlM35B/BvjDoV/q6Tv4PXNLEXIwmjoHsIvZAqpMG+BMDGmWBN86bS1py2Dtr+aX/WdsAVedbDi
	0l9YXHG9P1qcrV2h85iE5CkFDimTCWTJrS5Ty1tLG2cUqVdhE1RskYw5eWOkaqYp+L407X3bJvJ
	qcQbb+FpavtuR1LgXi6SnTV8G2ezB0Jmd1CaohdSUlQ7BFOKv86Ey10LwcXMzUs02rmIVAUJwoE
	4S00dFvq5RQ6va8F1RMmTbuorP6pPaHSt7jc9v/+8LyjjPUySL1KLTwZSins7S19s3P33PSjKDW
	eZ+S5x/TdtpeEZmVP93dysAUxC3WMviYmptNVCH9s5tPEJrvChV3hk7KPuTqvngfwVZRByVtSoW
	r2jw==
X-Google-Smtp-Source: AGHT+IHOO1UZf8E1mY0C/8pPZ9p+PHL2wfA86GthAJG9F8RdvnssHO9Q9yf2T16hTLxrfohJawldzg==
X-Received: by 2002:a05:6e02:3784:b0:433:720b:2b80 with SMTP id e9e14a558f8ab-435dd03c7b8mr62920585ab.5.1764177274220;
        Wed, 26 Nov 2025 09:14:34 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-435a90dba32sm88409755ab.28.2025.11.26.09.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Nov 2025 09:14:33 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20251126005936.3988966-1-csander@purestorage.com>
References: <20251126005936.3988966-1-csander@purestorage.com>
Subject: Re: [PATCH] io_uring/query: drop unused io_handle_query_entry()
 ctx arg
Message-Id: <176417727336.85325.5347136303993490383.b4-ty@kernel.dk>
Date: Wed, 26 Nov 2025 10:14:33 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Tue, 25 Nov 2025 17:59:34 -0700, Caleb Sander Mateos wrote:
> io_handle_query_entry() doesn't use its struct io_ring_ctx *ctx
> argument. So remove it from the function and its callers.
> 
> 

Applied, thanks!

[1/1] io_uring/query: drop unused io_handle_query_entry() ctx arg
      commit: 1e93de9205b4d5c0f06507e9e1c398574a07fb80

Best regards,
-- 
Jens Axboe




