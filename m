Return-Path: <io-uring+bounces-4732-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 301269CF2ED
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 18:30:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D0BCE1F21255
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 17:30:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1511415383D;
	Fri, 15 Nov 2024 17:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wXC5UzrZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6538B166307
	for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 17:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731691817; cv=none; b=O+eNM3hSb3ggi2vQ7Wf25CA593IzC8HNebQMhLsErYWwu2EnZF4lkmX9VSc3HPza07IPH/B+x7mUHiXzPV/hY0n0b0c8Bytljhy+Eh5CGBLFHJbBOz6orlFbuOrNL1/GzXGFztFXCFl7EVO2JltnF2dY9RV6Dw6TkO5Gm+SB40A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731691817; c=relaxed/simple;
	bh=UQsMIlcjeiZ8krc06WiEC3GNIG231ZG4OL1ykw2o7SY=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=K1FnFvOYFxu4iHBKHpNRdmDpgZyJgQ2FGJY/2RE2hsGL43uhWwfm49k2Ieh0wnK14Z903WBPSiwP9IJ8cDPHU8jrv/abs2A6mERpZeXxqjuQ0l+svyRcp5jvtlw18eTbt/n+h5b0Rlmeapr6wWtKS2moOjm9+vq7OUnr6CQ3zys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wXC5UzrZ; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-5ebc05007daso456878eaf.1
        for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 09:30:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731691813; x=1732296613; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3F3p6ZZyqbFH78ZRNoSAPUvqCZ/7qX9HYQ3laVeSgdg=;
        b=wXC5UzrZUseWd9Tfsn0u7ChnK8gau8PanxmlpmIutWHP+se8ZL05Jb7spfVeUyFcSz
         GmkKGWhU3Sm6U1WwnRhA7m4XRFkLRK7cKWzBkPBvNjQ15zpJgSh9AdTFPpgU1JGLZWNy
         rvihqvTIjOl74FuCxrdxOKFMMhiMvdpNJWvnElw33swJ4yB+80JJRcXc1nKGravaIa9s
         KMg0GTMGdhfhbZ1LOT3YUFtp1S8VTXhMPyQkCVDF4CoVbhIpzPjI1ghsCOZkjZoCcvl0
         y4Uv7LWa5KQHkq2hn9RPww3Y1GzpdyCfuNfJy8/bohHANrSZwBVHlDrGuiIvlTBN7wJx
         SXDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731691813; x=1732296613;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3F3p6ZZyqbFH78ZRNoSAPUvqCZ/7qX9HYQ3laVeSgdg=;
        b=G4ugGnPccTUqCTmwCldVp3iowVr+u22DEtocUiJYzAu3r6qljLgwTIMjGLFexFN4Zd
         OxHq75R3IA36WRHjsQk1HStb+9MoDMPeL58zKLH4EfivD0f+TpADAt8hOM9QgQTKhWai
         SUXciPjxaURneFVFXbo8rmdLzQNvIG43TYN7Y3qYvZCCRcFFWuDJbN6z9aLuqrbn4oqJ
         WFcGI8uYz6BDiKJ2Wx+yvzlF1jdAlIJ20D7XUjdDWDTBjFFtEMiZdvifujPStg+Ohpcc
         AwojsMp1KhQtUg9qa3tRDh4Q4mTIy3xhXnm9dp+wstU2nyUizuqcYC3wVmI0djtBZf9n
         steQ==
X-Gm-Message-State: AOJu0YzgXM7naGP9XiDnL8TWz/ysbWuWIxsN6Mq3xX+m53GwhXMJvVkq
	GDTFUi7u/8Wo/9+he+EBVlNhcuNXdjg0/j9P/BlLh0RtmRXSfh8LUSMiNNiklVcZVEcYSmGv3Ec
	FNVQ=
X-Google-Smtp-Source: AGHT+IGN7AQL7dGc1ZqiMXqrBYJQO2/hp1qrxvZRiCBy3qOp49lrqdl5flVGHHFDQ9ZjzSJY08Pagg==
X-Received: by 2002:a05:6830:6384:b0:718:4198:f7ea with SMTP id 46e09a7af769-71a77a0a1d8mr3667421a34.23.1731691812899;
        Fri, 15 Nov 2024 09:30:12 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-71a780ea4easm604774a34.8.2024.11.15.09.30.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2024 09:30:12 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1731689588.git.asml.silence@gmail.com>
References: <cover.1731689588.git.asml.silence@gmail.com>
Subject: Re: [PATCH v3 0/6] regions, param pre-mapping and reg waits
 extension
Message-Id: <173169181217.2520456.13381974829148736459.b4-ty@kernel.dk>
Date: Fri, 15 Nov 2024 10:30:12 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2


On Fri, 15 Nov 2024 16:54:37 +0000, Pavel Begunkov wrote:
> A bit late but first we need a better and more generic API for
> ring/memory/region registration (see Patch 4), and it changes the API
> extending registered waits to be a generic parameter passing mechanism.
> That will be useful in the future to implement a more flexible rings
> creation, especially when we want to share same huge page / mapping.
> Patch 6 uses it for registered wait arguments, and it can also be
> used to optimise parameter passing for normal io_uring requests.
> 
> [...]

Applied, thanks!

[1/6] io_uring: fortify io_pin_pages with a warning
      (no commit info)
[2/6] io_uring: disable ENTER_EXT_ARG_REG for IOPOLL
      (no commit info)
[3/6] io_uring: temporarily disable registered waits
      (no commit info)
[4/6] io_uring: introduce concept of memory regions
      (no commit info)
[5/6] io_uring: add memory region registration
      (no commit info)
[6/6] io_uring: restore back registered wait arguments
      (no commit info)

Best regards,
-- 
Jens Axboe




