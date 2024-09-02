Return-Path: <io-uring+bounces-3013-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 418E0968B2D
	for <lists+io-uring@lfdr.de>; Mon,  2 Sep 2024 17:40:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C33ADB21CBC
	for <lists+io-uring@lfdr.de>; Mon,  2 Sep 2024 15:40:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA0E819F105;
	Mon,  2 Sep 2024 15:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="yuAHtmJ8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC837364BA
	for <io-uring@vger.kernel.org>; Mon,  2 Sep 2024 15:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725291624; cv=none; b=VbzRlAp4tcjkF4mYPYKaurSLKDEtiQW38va0buwKvy+FiVuniBFXZ4e7Ddh4OnuRHfa/MQq8uC4r4Xoc7vMBQIHu2wiyXpCa40sCRz+ig4NwcM4hFB/bR6X/HmFHexUp60mKFNVoHepqq4kqUC8TktFxijaZ93xUOyuZr7NbnbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725291624; c=relaxed/simple;
	bh=qUzbEgovbqZq5w7omKq3eD4xqVgYXIWRkzD4uF3AoIQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=F6h6bReryPcg3rVNPPOPUoDcEHeQ5r6g28M8aTP8vN9zrbVhu4qMdqy535+4AQu/xm9JzsIX09pNHiBZkLKckVgCu5dni16sFrMfZEPt+7WZKJ34HmPhWdHA/rOtAYTh/m470B798aG1CwIR8g16jdtlO6EgajL+vxuUKHr2uhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=yuAHtmJ8; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2d88690837eso1858026a91.2
        for <io-uring@vger.kernel.org>; Mon, 02 Sep 2024 08:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1725291621; x=1725896421; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tqU1kDCHFohRSR7SOIyLpIkHKZD0JqCFO7fQYNgH8FM=;
        b=yuAHtmJ8BitMmuy6+4dzSn73x9CSAzmglIzSIm31w3Ic43F4CoGuB/ZJgvfZ2pLlcl
         7AUIBfOiDSUfPYfb7uNNujNT+YwfJAWVkQ/bSngCsHNXBOxsQodBFLjsXn4oUt/Uwpnx
         KWe9pCD2G7A6veKCIHS5Xsyck8lc4DrRynxrAx1oBxRmYRiSS8qW9vBpfTXBTr6qsi7j
         yO3ZGcZ9Ry4YIbO/lV1ljEzdaLuvF4DY/JV+dFPC4zPyGGjQ85ifxX+M0QDv2XW9xuL+
         8rSzP+V/DcQG9MeZhsHTcDCUI3C4kxoxAY8MRL6Kh6XIllHbx0tqpInbg21r7Eo2Uf5w
         4mkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725291621; x=1725896421;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tqU1kDCHFohRSR7SOIyLpIkHKZD0JqCFO7fQYNgH8FM=;
        b=GHZ5+pdzfXf/aaH8SMjOLxRIhf/qPd6EoBOOcviWwcWp4aKp2P5cjDz59DB1ollJMU
         tWkDWj+ssK6puUqjF3zByP9lLjOjo6+Js1HHP3sfd0tOJXpJ6x+nscpjZkH5tcrhSQxE
         faqdc0EWhDDJ+dirj+WltntWg2ykihNnN7L8EordxSoPnTfZK2MzK/AO1Ah01llGOyq1
         GBpQQasJrwOc5i3B/KQRt3O8aIyCKzB79XVmdaVeyKsVGBpADQfO4aJCqss09J05c+2x
         Xt60wJUI9xMazpS7NeBq0u5TFg6v0C+UZdl2k2ZJ3DvmWushVD+TBxiyrMyVgievaMBp
         NY3g==
X-Gm-Message-State: AOJu0YxpOdJcd1XiKqpYyklRt+NWclp8H0HnKPvGw5qU2nc7mTZW2Dye
	TvesEZ6k/yse8JnBZNpfJrjppeB8XABSVV9B2NxNwvvE7O52lp0NNF4BRspcOOw=
X-Google-Smtp-Source: AGHT+IHB8V+krjuB/c896e3GtUXxu/0LT1cDdzPg5efCWGpZ8kiLNDMVWjjQNssCyTkMgLKtV5iOgQ==
X-Received: by 2002:a17:90a:e2c3:b0:2d8:a373:481e with SMTP id 98e67ed59e1d1-2d8a3736fffmr5204552a91.24.1725291620802;
        Mon, 02 Sep 2024 08:40:20 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d8e77590c7sm1899850a91.6.2024.09.02.08.40.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2024 08:40:19 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: asml.silence@gmail.com, Anuj Gupta <anuj20.g@samsung.com>
Cc: io-uring@vger.kernel.org
In-Reply-To: <20240902062134.136387-1-anuj20.g@samsung.com>
References: <CGME20240902062908epcas5p334384250be037fb09463e5093c082b56@epcas5p3.samsung.com>
 <20240902062134.136387-1-anuj20.g@samsung.com>
Subject: Re: [PATCH v1 0/2] cleanup
Message-Id: <172529161963.4471.14701393752845459189.b4-ty@kernel.dk>
Date: Mon, 02 Sep 2024 09:40:19 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.1


On Mon, 02 Sep 2024 11:51:32 +0530, Anuj Gupta wrote:
> Two cleanups
> First patch adds a new line after variable declaration.
> Second patch removes a unused declaration.
> 
> Anuj Gupta (2):
>   io_uring: add new line after variable declaration
>   io_uring: remove unused rsrc_put_fn
> 
> [...]

Applied, thanks!

[1/2] io_uring: add new line after variable declaration
      commit: 6cf52b42c4efa4d064d19064fd2313ca4aaf9569
[2/2] io_uring: remove unused rsrc_put_fn
      commit: c9f9ce65c2436879779d39c6e65b95c74a206e49

Best regards,
-- 
Jens Axboe




