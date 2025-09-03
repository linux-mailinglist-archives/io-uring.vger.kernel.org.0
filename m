Return-Path: <io-uring+bounces-9546-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4124EB411E7
	for <lists+io-uring@lfdr.de>; Wed,  3 Sep 2025 03:23:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A3635E11C0
	for <lists+io-uring@lfdr.de>; Wed,  3 Sep 2025 01:22:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F9B91E5B9E;
	Wed,  3 Sep 2025 01:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="U8vfaoRd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8BEE1DE3BB
	for <io-uring@vger.kernel.org>; Wed,  3 Sep 2025 01:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756862506; cv=none; b=Q29eFaLUEGkXjQreYmOZSpcP4EMAUu1p76qNKWkPODabmpdf3nPUZQqxTY3ZRhuQ5sh8K37nBUyNE7Er2sq0I/46J3hlIErNQ5Hp9Fjy8IvkLMrIh7fqM7KeXxUxod7QNflX1KhWVO3w5nU3qQXlCo0Xeeb1Dd7KkI+xilOXXeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756862506; c=relaxed/simple;
	bh=PM+IAa6D+7JRvOsDd49HmyMUGDSaJXBLJBLbItAyfAU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=oqiKCHQpQ4is562N7JgLvZvWpJYKXp4quo6Y+isNMHntZcGujGnmYL0+CePuHTqu8UQha+SL8pprp5Kcqq7fjBKmxGAJ6k1L8M1+lRCuYK5RTOwKdVLdAF9dC2S6vLbGHEZ9NGg4ObyVY+SN9fNOlyhSpTLoEobaQRREXKXH//c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=U8vfaoRd; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3ea779929b0so36006375ab.1
        for <io-uring@vger.kernel.org>; Tue, 02 Sep 2025 18:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1756862504; x=1757467304; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kJWw4md4ZzcVTetUSdQyZ+2bMYMienRhnen9fvHE7Ec=;
        b=U8vfaoRdvyxaeqXMQ6ZpgawY98fShrnbZzXtGzyKoJGkal7nFa4OvVdETVEN58Rr3+
         7ibz4Vet8KkTYCw+qFM87L7E8u/6l/xvedDBgdR6J+HJUmc9zqjUZ6fKW0iQlvNaZmpb
         HVRzpUbUbk5o5TKuu9+7HmfrM8GI91OGUrWO6q4E5UgiiurGlu3+kRZlxPAxHvLO6IM5
         UjrknsPUetuc4Hh7iU/CV5PELx5ptxYjGmdfo2BCvKmc4VkB6SZjrvQiyu8/+S0SiPMS
         Wbg8LRgURuP+yR9sF8QWGNM+5NW6DFvlIc+2V02ELL+cCQ32XFv9n6IVNVVMy2J7NOWF
         JjbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756862504; x=1757467304;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kJWw4md4ZzcVTetUSdQyZ+2bMYMienRhnen9fvHE7Ec=;
        b=k6EXpioLMRIjAJZAgkv3+dIPW35C+sT3fqxes7jdKC5knq84KRIjV+DKEJZmju8aTM
         3Elu7VZn33QuscuL3fU/+RE+mpnMJ/G4HVN8GPWxsFc+QB2kq9HSg4UwiFXgR8BFVE0H
         7bUgVwPEWfdLzcatibTYB9J/COuwKqjjD+nfhh858NAN2iyi3nc0/KkL2XbVjP9g+cwg
         QCyXLiCzawl/N9msfyc5dhOrI95q7jH7PtGVO0auS69y9gLwWAlzXZU+MS62v3ReRF4o
         v691CbBwaHyEXSD5vscWhNOtbNo6zfj4qo6W8/39+xLn3Xvz3o2IWvG2kkcIG53no7UQ
         M6ew==
X-Gm-Message-State: AOJu0Yw2LK9mXBK0f3xz6C+I70a0j4j3TNFNiBiZ+R+6/Lnhb3+9Izlm
	NV/jU2U8jnkyzY2yf878vQs7htNoa8ZryftGtq5kl5SiE5jtYQU3ENba0TI+9yh1VPc=
X-Gm-Gg: ASbGnctvgkhBZz3hfSq/lcDvKkSJowN7UE9Atf0RBW0O6LT3VUElYHfMXisA2w2UZTn
	jjxfvLhgDGVQlltNzs/59XFdFGBEVtPM3LUQmBonkZ4hJaITao94GyEcqZc4ywZDPeAGmyZt5HG
	KsfDZcU32Qa5zRI+iX4patpAid7VywGWyHkO/wxOwBdlD8b3BEVR/La0bUBOQu9d4WdivbfLIqa
	FE8xZAXkr5HeNw6bjyergWTf9b5SP77d3ZYichIFAOLO+wJZn6Is0CSemA6cZ8pL5xjfR6w7Prf
	SzWih3K/VqIaVoc8HDhVvTYN7oAEcn613jekjDwzlYuhP30kGkcmcollI3juPCLl8P/V54CLVRS
	+AFMQ9v+GFF3kXdoXV9it5aLug/WdH+i9srblMoirggjKrR9g/hxOhvZuN9w5zgvj
X-Google-Smtp-Source: AGHT+IEpPfuAAE8pbVm+xvNfRUo9Bw3bSAVSdw6Wvw/qtz54SOaCk9QzmO8i29HhuAPP6IWFV/kXFQ==
X-Received: by 2002:a05:6e02:3c81:b0:3f0:7ad2:2bf5 with SMTP id e9e14a558f8ab-3f400674aa1mr237520975ab.12.1756862503862;
        Tue, 02 Sep 2025 18:21:43 -0700 (PDT)
Received: from [127.0.0.1] (syn-047-044-098-030.biz.spectrum.com. [47.44.98.30])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50d8f31cc0dsm3662537173.38.2025.09.02.18.21.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 18:21:41 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20250902215108.1925105-1-csander@purestorage.com>
References: <20250902215108.1925105-1-csander@purestorage.com>
Subject: Re: [PATCH] io_uring/register: drop redundant submitter_task check
Message-Id: <175686250149.108754.7904798401542730118.b4-ty@kernel.dk>
Date: Tue, 02 Sep 2025 19:21:41 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Tue, 02 Sep 2025 15:51:07 -0600, Caleb Sander Mateos wrote:
> For IORING_SETUP_SINGLE_ISSUER io_ring_ctx's, io_register_resize_rings()
> checks that the current task is the ctx's submitter_task. However, its
> caller __io_uring_register() already checks this. Drop the redundant
> check in io_register_resize_rings().
> 
> 

Applied, thanks!

[1/1] io_uring/register: drop redundant submitter_task check
      commit: 8b9c9a2e7da11e50a1109a1f38bca0aecf25b185

Best regards,
-- 
Jens Axboe




