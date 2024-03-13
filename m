Return-Path: <io-uring+bounces-925-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48AE987B2DB
	for <lists+io-uring@lfdr.de>; Wed, 13 Mar 2024 21:27:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 77AC21C2258E
	for <lists+io-uring@lfdr.de>; Wed, 13 Mar 2024 20:27:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FEDE52F62;
	Wed, 13 Mar 2024 20:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="gj5IzuwM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55DA4F88A
	for <io-uring@vger.kernel.org>; Wed, 13 Mar 2024 20:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710361655; cv=none; b=VB2ZLhDl9D/6SzSK0PcZw0MtfuDp2Uz2sxGJgwAikeK0s8b8oFCLy7WZba9p8kyxjx1OPjYCAR2Qcn+7+V9ribN0Em6h4COnliMGuGEYDhdelzYaYcC5MyQtLj306kPcU3b10YDo8fuiorRqxH5cKtpLcpiA/ohkralAdMoNZdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710361655; c=relaxed/simple;
	bh=aI9U6oNqBXGSYwv2rqeO6IqLQ1ljfWEKvRQZKp7Fd5E=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=V9EAPqM+z+ZevvU++GVqe2nTpqNyDqr+BrHRLFQtMZpzBfwHweBPB3xsvcSo7HRC0rL1aKz2SYwJNvm0zXs6uZdF6BwUPQIOzc9OCzpG39QMOzEmIh8pOtrvIwajJ7XLEGmkKFWyCeJEs7LnJTeiCazjM+TeDEbvDFRua5/ozIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=gj5IzuwM; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-36649b5bee6so426975ab.1
        for <io-uring@vger.kernel.org>; Wed, 13 Mar 2024 13:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710361653; x=1710966453; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XtLbuQ14rePkrMukPE9/+fowEss0Vo4ehtNIjnRYHBU=;
        b=gj5IzuwM/kij4Lk8XmOV9RFEggdVDVcMkpWXnGfkZCwoPg11AqAZYS2rznWrR4qx3m
         ZCpe+boimE9GRcKb5ldUmMu1w75O+5ymvaTlRBTyHiMoEVYvFDFQor2waFVMq6ohZJk3
         rWunkuNJuT2HFLImbXWedTIjLoY8wAj3QRrzoBMiqO6fEWJhuvsYED8FRLhRn8QhCwQ1
         fjvhjhLlI7Vz4mFCPJ9pe92APUSy+T1ySCkBXf/M2tSgMiWQoZ86Hp+NRd8s4RWnTG/v
         9mCWinJ8Gcf9KVzr7D7Fqgif6TAyxKk9SWhgcJF/p00xKj7bjBs86wdI9MnYoITPWjTd
         JP7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710361653; x=1710966453;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XtLbuQ14rePkrMukPE9/+fowEss0Vo4ehtNIjnRYHBU=;
        b=CEIdPykERXv3P3BIUeJ3RQLZbWKVek0SRjH7HINAGu5rkJHy0lD/++bTDkvo0Gpaq4
         AKUuf4IuwWh7T5/DbwmDk72lM4XwyuIMIizf7QPk3ytYBvElPcNPiXy8cvUZTGhiNzGm
         TKIDzgbQE0m5m+PndYfnZNQ8k/gOz8xT347UOQ7TNfW/tODIBvaUBit+P5IZncqI0mba
         TOAmhZoui1g8i5xaj4Q2AVNeiscxGFK/qTH8vSqXJsutb5X6f8xCoVpzAVn3jMyoDUsT
         1KYwrXXERwlDv3gHylY2B5XxhMTcFXNKvsa4oK9FJ3pge9QjKHr99DEdaax4lHGRNP3O
         GXRA==
X-Gm-Message-State: AOJu0YxLQwwtxmNQdnx31X7jJBJhGX7gIwil5i0CcPqL8sEO4EOctUXY
	x4wHxXpPfkhrrQt725hRguJVj8yupkJ/joPM6DQg+jWX2KlF8Nec3XSSVn+goGI1qLJvmPh5iCY
	+
X-Google-Smtp-Source: AGHT+IG6dMh+Udeuysd3l5qaPYJs0XUHr9OLL8b9t6OxoANhEjMd3Gum8iGhnNSFnKvdEAZNMw642g==
X-Received: by 2002:a6b:e914:0:b0:7c8:bb03:a7a with SMTP id u20-20020a6be914000000b007c8bb030a7amr23608iof.2.1710361652721;
        Wed, 13 Mar 2024 13:27:32 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a42-20020a02942d000000b00476cca7d5b9sm3081057jai.166.2024.03.13.13.27.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Mar 2024 13:27:31 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <9ff6cdf91429b8a51699c210e1f6af6ea3f8bdcf.1710255382.git.asml.silence@gmail.com>
References: <9ff6cdf91429b8a51699c210e1f6af6ea3f8bdcf.1710255382.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: clean rings on NO_MMAP alloc fail
Message-Id: <171036165147.297831.6141604399654227492.b4-ty@kernel.dk>
Date: Wed, 13 Mar 2024 14:27:31 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Tue, 12 Mar 2024 14:56:27 +0000, Pavel Begunkov wrote:
> We make a few cancellation judgements based on ctx->rings, so let's
> zero it afer deallocation for IORING_SETUP_NO_MMAP just like it's
> done with the mmap case. Likely, it's not a real problem, but zeroing
> is safer and better tested.
> 
> 

Applied, thanks!

[1/1] io_uring: clean rings on NO_MMAP alloc fail
      commit: cef59d1ea7170ec753182302645a0191c8aa3382

Best regards,
-- 
Jens Axboe




