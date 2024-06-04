Return-Path: <io-uring+bounces-2093-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 39B5B8FB3FF
	for <lists+io-uring@lfdr.de>; Tue,  4 Jun 2024 15:40:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E21B31F2212B
	for <lists+io-uring@lfdr.de>; Tue,  4 Jun 2024 13:40:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 523F41487CE;
	Tue,  4 Jun 2024 13:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IyewzNbo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A7E146D76
	for <io-uring@vger.kernel.org>; Tue,  4 Jun 2024 13:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717508331; cv=none; b=OR+Jq5ezHEuTGQvOL9XCgitRi4SKVGE5rAHxL/Vg/wYdXdOaW6nhY5owcTbQo0y9qMWC3FPQoDpt3XUjuz2JAOij566uNqOB8xIX8noVXoy3+sD9zIDrdZKkbojyadx6m44n8755y7P6Ndt8o1gJRuCA/HitGeCLnj5RhWckicU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717508331; c=relaxed/simple;
	bh=mLOB/pRDSaqep4kaNRLrvlUmHU00bgxlnVyjfSPtsEk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=s/H/rEoZMhi1Mp0n0NYINituM2hR5OAqOXX4NzWaoBh92s/8hWsLHhLf+r9zV4gZJ4wZ6JNjpM/80kkdyzzv6/F3yr4tQhFI5zuzpfezOzmWbmvmSyh/iL50eR6Yr/UV7pRO+TlvCmeDHA1BJxeM/PNclzxJPR7jW1c5ItouoyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IyewzNbo; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-6d125d826f4so211053a12.0
        for <io-uring@vger.kernel.org>; Tue, 04 Jun 2024 06:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717508329; x=1718113129; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wyXYBZ9yf/+pq+sDdhkihpXpTq6hpcaT1psfHyvcipQ=;
        b=IyewzNboMpcwW5LFMTFxdY4SQ1KG2Q+U6IGwJlTrzALJKOjw/JKNzXkiCnHi9jmS9J
         eOlFQY+innZPCcgj56KeD6Az2gAsr9khEuktItMjqTjCRV0HOlA6LHK4FvKE/kX8GcaN
         DjJ9HDIVl8c4etQ9mDDS2tOBKmVH0urcEJpp/3efMCMSOxLuZMhIkB1DfHdu+uw22hpW
         5r2jONIgP0E/l8reAXvD6z0NHJxrdyqtHJ9b+mxD/cqRS19VEvzmXG/vkkxwS+ZK3Rn9
         XtkJdIPfHqxbjDZZKvn1RBhJPJVym5TWFFAn+1koXb3jqScMupOOk5lhSMtnDGcXhJYT
         FMXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717508329; x=1718113129;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wyXYBZ9yf/+pq+sDdhkihpXpTq6hpcaT1psfHyvcipQ=;
        b=NICKj5LYJGGMw2MHv3Y2BY2lQMI0Kyg08gZfRBS4EbInhkIAWN3cYGK6GUa8wVG0sL
         HXcDTXTB66f9KwB0oYv/ETeRRohvF6iPEQZMtYiwb71yw6HzxJJvgXkNiitv1xEgWiBc
         CI51IxLoHlYf/6s3mR32OhoPeAzC8Op0O6Uvs2omdplsdeSpzlJtqhm4Pl1dKDcV7Xny
         1cBqcJHgcJVs+QXQSK6uxh+ruSGUWmMQ3VHHAgZqQH+JzX5y9aFsaQlqlmi6SNOHOYYa
         7J2mVfQoE+BClzwzhZ2GNm2z4Gq4b1pIePeZ2xa1xkSXSJoWEtrwe644TfZG6sJ1Zmoo
         WiYg==
X-Forwarded-Encrypted: i=1; AJvYcCXmh4eIKxB7jZTTCEhEjWEiNz9xj45iUj1aiBGXY5BNp4qm/YIEyaZN9JdFZGwbG82y4QUpGe7YLhwyE6YRjuK9RXCEzRvpIiI=
X-Gm-Message-State: AOJu0YwYj8akfTifWn5401p3HdOAoiWdHKeeaxkR8aKAx4ImJKGkFRGf
	eArsirkj0ixPtIoRMgs60Kfw8xKLo1ajPl5MQThNCbMKUD1X8oOZ1i+VuQymdq8=
X-Google-Smtp-Source: AGHT+IGgE1PUAohyvsVgmtFENCcomUvJIkWVXPFd7SdjzctUJnwKJA25eUqbhTVsMlgms0m7bEff7Q==
X-Received: by 2002:a05:6a21:338f:b0:1b2:53c5:9e67 with SMTP id adf61e73a8af0-1b2a46feafemr2610730637.4.1717508329280;
        Tue, 04 Jun 2024 06:38:49 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c1a77bab23sm10440745a91.48.2024.06.04.06.38.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 06:38:48 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: asml.silence@gmail.com, nathan@kernel.org, ndesaulniers@google.com, 
 morbo@google.com, justinstitt@google.com, Su Hui <suhui@nfschina.com>
Cc: haoxu@linux.alibaba.com, io-uring@vger.kernel.org, 
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
 kernel-janitors@vger.kernel.org
In-Reply-To: <20240604121242.2661244-1-suhui@nfschina.com>
References: <20240604121242.2661244-1-suhui@nfschina.com>
Subject: Re: [PATCH] io_uring/io-wq: avoid garbge value of 'match' in
 io_wq_enqueue()
Message-Id: <171750832792.373240.8767021460699358833.b4-ty@kernel.dk>
Date: Tue, 04 Jun 2024 07:38:47 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Tue, 04 Jun 2024 20:12:43 +0800, Su Hui wrote:
> Clang static checker (scan-build) warning:
> o_uring/io-wq.c:line 1051, column 3
> The expression is an uninitialized value. The computed value will
> also be garbage.
> 
> 'match.nr_pending' is used in io_acct_cancel_pending_work(), but it is
> not initialized. Change the order of assignment for 'match' to fix
> this problem.
> 
> [...]

Applied, thanks!

[1/1] io_uring/io-wq: avoid garbge value of 'match' in io_wq_enqueue()
      commit: e87863ed45a1c36b0d8a5b70134caf8c794d8d57

Best regards,
-- 
Jens Axboe




