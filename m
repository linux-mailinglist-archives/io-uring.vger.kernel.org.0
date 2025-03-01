Return-Path: <io-uring+bounces-6890-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41E3AA4A808
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 03:23:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 45B6B177CFB
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 02:23:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0059F192B84;
	Sat,  1 Mar 2025 02:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="VErMNgxL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656BC8F6D
	for <io-uring@vger.kernel.org>; Sat,  1 Mar 2025 02:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740795819; cv=none; b=Ona3BUjDu/1Rw0qJ0x/S8pLeAB4PDfVz2Q6v7xc1FzJx1C/Z2ByhLk+ly/bT6f9wIqsqQPagMPTmEKPAM2uq11dV82US9GMehdJ89PN77UHudDdxeRCrvkG0NAFTJDHrTcoEhTcDr2DBEAzuRZ5ewOct/3734PfuzYw3ua9PPmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740795819; c=relaxed/simple;
	bh=/iJC7ZZ0UAHcIY+EsbFLVy5vOdJXxBEZ75070krP+2o=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=OCrHmesaSheSWSRjwoOP0LRQiXA2APMirv4iQBTye7dX6+kBORWt0uFCP29Wro5ZpxtVOOYF7R40B+1+7uswz61DOVYO4cNdScUuUVgs6G+8mANTl8GbRDjHo9K+VtFq/6nhFYaNgE3wOOJIKPib3Flo0LznYcJJ/NJnpyaU4r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=VErMNgxL; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-6fd30144fe1so20817347b3.1
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 18:23:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740795817; x=1741400617; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jgnPYGo1br/XdlJIX/NQbWvegLuBLl+0tDsfBISzu2k=;
        b=VErMNgxLoo/5FDaHbMyEn8MQsMd89qlbYmhn2p0AE1XgCegJyv+WVMGCSoYVbotLt7
         SnYZ+bEETITgkxw5FLmISj+74iGBQzp9PNjjbeFXM7kMqsxEgtmLuGRQO4QBxkI9pGau
         kWY6K7vPajR/KlUT05LozxQsRAk8BlVTpfwDMrvsrOBCAimRVDBcXYGCYEKwYhrQY1sc
         smWGcClkP6nv/oZ5z2psJ5Rh3a9TwVRtwzpmAczADpi6iFpTSoBbavhBLAsgRoQUiDP4
         oOyl+zqI4gCZD6mJzRzQekiUWW427UBp/8uUn/QIHea6+1YDEtG+ViQxtVm8cCUiemcv
         5g4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740795817; x=1741400617;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jgnPYGo1br/XdlJIX/NQbWvegLuBLl+0tDsfBISzu2k=;
        b=FA/cWNEOTaq9YcLnMfJc5CGfjKFnZr6Kmh/7rfZ7Wqxr4pQvMy4I/+QppbLVB5oCQu
         vMgpmR0V4zoFMt8nTu7gpWimpZVe5IzYDTWlFmS0GcW13qq+5VYPjBWI4cV0lpfrGbGb
         HMNxWKkJpUkK9qpO9ah8Qf8fRsMNbXTLuV6KqJW+0IDcs9WNN1sBnItZXEiboST4WHSH
         Mf5USXjBbBji8KfC+D6H5+2wPxRq4RewHh6dxdGte1HOht8IB/A8QnixUeldXI3ALoHn
         f/saZf0TwhjYiAMeDnogM3syOFAgOBCDLRyCIGrPZUW19bI00IdXyqe9EkfBm5Ph88RG
         A5RQ==
X-Gm-Message-State: AOJu0YziK4LnsFdx0qa6kolOObcLxm/pOZkxNmhapAvkSG22amEh7K59
	89NnHGn4la4r6c7UkLKv7PtgVyrjBEZpzV7EVAL/EsUsG7/38HDRx7iWanFC23S+myjKKlwOcz6
	S
X-Gm-Gg: ASbGnctZA99iKsAB17H0tb+y0Rc1JqL8q0J7uUpI+gfOPWZiQZ3DpJd9/JdFdDan3P6
	gP/h5QyoLEv0Hpmc8yg+iE31vWdyblEHTlsEGEN5fuYeUtdjEyQ0faomsrZl+wPH7vFdaCoOKQt
	AiP58RDez5jTTWIe8I5/vqX3gWjfOgGCrG98fwbqFWzVyASuFrMObPzk7UbFKtC+Oh31pPRnUyZ
	pIB4o8cuQVA8zvt5E3cuXCmu4tYNSOD64OFIxqjLTMUP7BeQvYM4V1zbaIvmRA0pcqAzlAqUR0v
	jlUkIVAgsSMdOZ/wxscm9biQAKdlqPPlw40tOrc=
X-Google-Smtp-Source: AGHT+IFpVfF8vlZh4plPINDaxBlipPQen/O0lp4jkw9BN8vWuc+gldnvPAzkxEjPwH4u0FHGAxtxSA==
X-Received: by 2002:a05:690c:3001:b0:6fd:44a5:5b68 with SMTP id 00721157ae682-6fd4a100420mr83481277b3.35.1740795816982;
        Fri, 28 Feb 2025 18:23:36 -0800 (PST)
Received: from [127.0.0.1] ([207.222.175.10])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6fd3cb7e02dsm10175307b3.84.2025.02.28.18.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 18:23:36 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20250228223057.615284-1-csander@purestorage.com>
References: <20250228223057.615284-1-csander@purestorage.com>
Subject: Re: [PATCH] io_uring/rsrc: use rq_data_dir() to compute bvec dir
Message-Id: <174079581576.2596794.17941051100907210365.b4-ty@kernel.dk>
Date: Fri, 28 Feb 2025 19:23:35 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-94c79


On Fri, 28 Feb 2025 15:30:56 -0700, Caleb Sander Mateos wrote:
> The macro rq_data_dir() already computes a request's data direction.
> Use it in place of the if-else to set imu->dir.
> 
> 

Applied, thanks!

[1/1] io_uring/rsrc: use rq_data_dir() to compute bvec dir
      commit: 2fced37638a897be4e0ac724d93a23a4e38633a6

Best regards,
-- 
Jens Axboe




