Return-Path: <io-uring+bounces-8450-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F3135AE47B9
	for <lists+io-uring@lfdr.de>; Mon, 23 Jun 2025 17:01:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA0FC1883902
	for <lists+io-uring@lfdr.de>; Mon, 23 Jun 2025 14:59:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D832324DCE8;
	Mon, 23 Jun 2025 14:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="b3y9Dqy6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85DE25E839
	for <io-uring@vger.kernel.org>; Mon, 23 Jun 2025 14:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750690749; cv=none; b=n5sbcvfafK89+RL3HfFSdo3xMRByUEznNWWt4OjKK/iGkoqQN6PRCiaTVQ0lSlg1NHlYskmUdsB8UKaxnsWEfQuYq7gJ74o8rkstjBpWIdWEZI9DoqUbXhDVtgcLfQVOY4xZxGP7f6qRYjG/qyurRDUtfQ2G26A7GNe0Q7fuQao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750690749; c=relaxed/simple;
	bh=hx8ntCgRo+ZB8/WslKubMzSR7Qpl5s/6TXJeGl0BVDg=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=V5FiSmj85HxhS085EuBgPrsqY0pKxluKOydBBS+k//1y80JWOzE0KzeFKpNPUNkypcfYK1zvc2LYFsP04iyWD2vL4LAjLJ3ZkK3qJviz2aYBWkK5IbqT7yw6Z9ftdu1U8n1qtxCagVOb/gczfrI6jOBS3J4lt0ODrR1uufE4m+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=b3y9Dqy6; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b271f3ae786so3231229a12.3
        for <io-uring@vger.kernel.org>; Mon, 23 Jun 2025 07:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1750690746; x=1751295546; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H7F8sOqomppPYAeF6JrDjbcHhxF/KM+mu9Ng4FE7SwE=;
        b=b3y9Dqy6PRkSEC+q1bmT4gbjevOn0zNO2UWO83VeGg/oMLbiEceWApsOg840qgbtwz
         XJyiFEXaABHWvgyR7NCmxjo5QzI5P+vVG1S7zYCtgeRdW9uBsqott6d7swLGgKuPyGFj
         pqr9VulUK70I9kj8Wjj9E7Zyzly3VuNJ29a+vyGFaBbhd/JEv5lOxqvw8TxYSiDAhNyH
         T3G9ubAUwUqlVAYdpMoJWU1uPSxgag4Yr0JmoHPawPa4tp/DlyaO1a+PqP0ogFUQHn19
         O3oqjxpPgS+I2NynjT5+UXIouMvggEDvnHu1EnEXrx9U43Ed0G9c+GTvzFAsG8OmQoed
         UtdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750690746; x=1751295546;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H7F8sOqomppPYAeF6JrDjbcHhxF/KM+mu9Ng4FE7SwE=;
        b=LJYBOfRT5bsfApWOX5TwwLAwRVVNXTD43sUWwRVv5reWaPssunC/OWkLNupzEKqXiq
         KIksAiJjwDMgX8ay0bnin79L8e/rZ8KWH2a7/W8GPhiisyEM6YI8P6UXMzFRd1bOZHAc
         aUSnxDSMdMDbPv8mjCRZb21n+kFqVVnjDa3kTpZrnLsrHnvXMUevFzCdydXkPZJVB+7L
         rhs0V2TWGkhNA2DRcktyj2NBEdsY/LJMY+zGKsqslVSoWG8Fj+0bFP2ZSRb3+w0sR1uO
         UEwA9Ci5GUr9+HTCRTtNIffYE8iE+XPrYSnTddN0i7U+4v7/YDhTTKgksX+D0UDC28Jn
         vh7A==
X-Gm-Message-State: AOJu0YxsyfMHG5pzuW8g38OoBoKt/Cqzl7tduTTZpH1kyl7e2uI7muEo
	wPaGLU5R2Sy+6IZu6zt7+KDUWqQ0WOA40c8lJP31mOMKUC1pD56056NpBfKF6eQ3nyK6Abh/9Rq
	ioFG1
X-Gm-Gg: ASbGncvEh7PeYMV6f0BJzeueI5JUuQ6/RG1pfIOB8qlA724L+tHzwhPLDD0YUqt2Mnc
	A0TKqTxdnW/WhN28xM0U1WZWnJFooBypdGIFk6l0Yf6SUu6byxv9auJLYAZblBvXZq5n7q3oyM6
	roC/NRWHYV9q53GUeuVGKY8J/nTy1aqW/csSKvwEZGzzOVgKBPuvUb6V0vBApb6vEWjPA7xVNOM
	VELLiWWSFwlEn/J4O/gIrS5jbeh+IqumW7gQgQhJE4070Ca7+kr4f+SHV7g1NvQxNY4mzZ427gQ
	aDUZ2mACQyXeplTNwQDpG50i0qbyBqXBbIZ/bP3qVQi1sMkLYFgPYg==
X-Google-Smtp-Source: AGHT+IGrChfiEhdn8iNY4spB/7qcaP7gpVig8FaOb+cg0c0/67a4p3spy7QtbNOlXSUloXdHwH1ktg==
X-Received: by 2002:a17:90b:5826:b0:2fe:e9c6:689e with SMTP id 98e67ed59e1d1-3159d64432cmr19715200a91.8.1750690746066;
        Mon, 23 Jun 2025 07:59:06 -0700 (PDT)
Received: from [127.0.0.1] ([12.48.65.201])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3158a3137b6sm10957606a91.33.2025.06.23.07.59.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jun 2025 07:59:05 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Fengnan Chang <changfengnan@bytedance.com>
In-Reply-To: <20250623110218.61490-1-changfengnan@bytedance.com>
References: <20250623110218.61490-1-changfengnan@bytedance.com>
Subject: Re: [PATCH] io_uring: make fallocate be hashed work
Message-Id: <175069074512.48680.9575841881249533750.b4-ty@kernel.dk>
Date: Mon, 23 Jun 2025 08:59:05 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-d7477


On Mon, 23 Jun 2025 19:02:18 +0800, Fengnan Chang wrote:
> Like ftruncate and write, fallocate operations on the same file cannot
> be executed in parallel, so it is better to make fallocate be hashed
> work.
> 
> 

Applied, thanks!

[1/1] io_uring: make fallocate be hashed work
      commit: 88a80066af1617fab444776135d840467414beb6

Best regards,
-- 
Jens Axboe




