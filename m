Return-Path: <io-uring+bounces-6793-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 523F0A46840
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 18:41:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61A803AE165
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 17:41:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A5AE222592;
	Wed, 26 Feb 2025 17:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SSYxwarf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCBD021CC6A
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 17:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740591682; cv=none; b=qRXmhEFIaYse5j2vaVSq5Ox9a7ejZhCtwKyxrt27yYUEcWrtXXfrU5iP7Ez2CC3O3uKFUP+ODBE47jQIlq3DccGMCBzfT19OiIayVLbtCou0UwXlo2I4pmvjt2ZzkONzH0tZv2CXBcqyQLIPzZQk040NBNyDosD061pn750Jr8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740591682; c=relaxed/simple;
	bh=00qHpqccB62GYU9Ki7MTAiyUZ5btmWs6SXnOcgalEBA=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=RiCgRj2v27X5qjLBSffH7tAYCERbXm9fEhdX7iNnMZH6AYqBbDHy2rSlPka1c6P49ZUr0dd2GeOj4TTTkGu2lc3vyFvuvMcEPX+swQ6OvRDwUFVFm9io0ksEJYnca/UmEGkZmrjK/KJIO4EsaSKNFIM1O2GfIhtBA0kVbyRhVro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SSYxwarf; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3d19e40a891so274655ab.3
        for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 09:41:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740591679; x=1741196479; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GcQGktGX9qknrBwZiMTT1RnbRZbxscab5vQvpnjw6rY=;
        b=SSYxwarf6+n9QWd9TWi7mRBACvy4hegApnNQauQeuErG00G4EJQdeQ+AMLTy5+vt/k
         tmpD43jR0zZ4N75tUKLNaaOKMofLspZddW+e861ty4p+a2Ba75lwSqauLLltgqjIdU/V
         b8FW8tnMn5jdeHoISuNEQXb6i9vKoCd26N8PmqYrhDrkJN1EmlxtP430BGtKIt/9ebz0
         xXRtcd97YJa569CRrr/amcLKyracD/1ENfmYxPLfuLJEsakxtE60wZ6qIyd2qiM+6rEo
         buz0f+i1JUHeULJ/8AwhP8C3y+BAuXCl/ZS7R+HQKubERra2+JEGbnkddGbS18q8W3Rh
         WjSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740591679; x=1741196479;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GcQGktGX9qknrBwZiMTT1RnbRZbxscab5vQvpnjw6rY=;
        b=NFsIiZVtK92H33gAYW+joShPqBnaJCucYnufEntsshWMLYdqqzwqZq6ZQkL7n9Qn6o
         T6/AFDBjQi5dnqw5qF6zKri9GGMeKdwRlUYQVOhMEcP39pNEygziXUtqgS3Zytc5M8bg
         ntSCPZcPIF8iLtOxlRBRxPhRoscreDJBa6XA2z0T1lZkpcBClBNkQc7PnFinGthTFqn7
         CY6v3NTDmVBbriRPWklsGOXw19rNYDaY33CQ6w702wfP68NVHNmDEMqlLMSxOo0HwFq9
         Fhp9+t4t/ILe7qRsIs3peLOO2AbxB6UoKx7y250vaUKaY6Hv0sIaezNCrGX9dnMcQXpQ
         uzkQ==
X-Gm-Message-State: AOJu0YxD9qnIOC4NnXXEHDG+4kIAJVfaMJcOm7gAYNpFTqebRLNXNQMZ
	7kN2Zp31fqasMXJEzDV8YsKAVbWMFtf4tSPy00/5gzb7Zxe8mSbeug1wfNYEgA1JgoEMmQkBftu
	m
X-Gm-Gg: ASbGnct16NAcfBpDciv5WDKyIGPS3sCDegyQfyBLBx0C076b4hWUKV+1FKKx5vHU9Ks
	T2jNaXSAhpaPmbNMc+80AYRfrZ3CT5NC9XMZBNGnogS3gnXfPX9RmZqRGY/kAQhYfaQKi+3Dmuc
	c6p8oQn+6xKUvGT2pKE69O8kG42r3aN8TDjv3pcrBkr7JWqtNopmebaUDyfLtC4YGZhDslg8R2T
	Riel+CBpfD+kdqoX8YRYUxTeAYRu6m9ne+sFFtTVD4S3erAdJ0V2yiYhO/u8sL5saTt3oAFdurN
	LIshN9QXT7M27vG1
X-Google-Smtp-Source: AGHT+IGku4O++U5dQ0mGPB3HALVe1UVZui3mQbiMjToQQGfKVwvC3KZqpXGxcZOvNtdzdOjMjXEHEQ==
X-Received: by 2002:a05:6e02:1b06:b0:3cf:c8ec:d390 with SMTP id e9e14a558f8ab-3d2fc0c1158mr87898115ab.4.1740591678810;
        Wed, 26 Feb 2025 09:41:18 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d36165309csm9014665ab.16.2025.02.26.09.41.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 09:41:18 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1740569495.git.asml.silence@gmail.com>
References: <cover.1740569495.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/7] improve net msghdr / iovec handlng
Message-Id: <174059167782.2279502.4185819427784696172.b4-ty@kernel.dk>
Date: Wed, 26 Feb 2025 10:41:17 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-94c79


On Wed, 26 Feb 2025 11:41:14 +0000, Pavel Begunkov wrote:
> Note: depends on ("io_uring/net: save msg_control for compat")
> 
> Continuing refactoring how iovecs are treated, this series adds
> some more sanity to handling struct msghdr in the networking code.
> We can do some more cleaning on top, but it should be in a good
> shape, and it'll be easier to do new stuff with that in.
> 
> [...]

Applied, thanks!

[1/7] io_uring/net: remove unnecessary REQ_F_NEED_CLEANUP
      commit: 398421b7d776edecbd89a7ca6cdaaac0d965762d
[2/7] io_uring/net: simplify compat selbuf iov parsing
      commit: c30f89f1d08b205ab96aa09ce06549ba34bbba67
[3/7] io_uring/net: isolate msghdr copying code
      commit: 6b69dd00e98a6f9041415351f9894539da0e73c4
[4/7] io_uring/net: verify msghdr before copying iovec
      commit: 820c215726a57ffd766376d23feed2bebe27a18f
[5/7] io_uring/net: derive iovec storage later
      commit: 67f9fbe72a2d2abb25aafd1af6d9f6373cbc5024
[6/7] io_uring/net: unify *mshot_prep calls with compat
      commit: 68525267875757520752ff1abbda0af58fc172b9
[7/7] io_uring/net: extract iovec import into a helper
      commit: 7eb5bb749ed945ead6a089e18e1d1da74523ac9a

Best regards,
-- 
Jens Axboe




