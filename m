Return-Path: <io-uring+bounces-6609-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 59B18A3FBE0
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 17:48:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34D94189B7F1
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 16:43:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10F04200B85;
	Fri, 21 Feb 2025 16:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jgDC/afs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F2B1FFC73
	for <io-uring@vger.kernel.org>; Fri, 21 Feb 2025 16:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740156067; cv=none; b=ScRpZHkYHyvdUUssinze264fQ4MJpXn4Qz3pDa/2AOig5HqNloxvWb3orjOg4cK9Ttx/diAEVUt7SFgLR6oP5ElE61nS5O2dnQ/txL1Kvk8ed6IbSZ6f++tUtoLbiNKYeAttmV7b69qfsZhIRQxzMXtXvxOmXzzYimrUjoJYS7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740156067; c=relaxed/simple;
	bh=dmUxB4J/2XKaiD0TPz1wNh4b/XwJpHH1eifZLpTasOE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=t2gOnWWWBm/nF4JtCxUHs+GKs4LVyypqhv5sJVsjkXznuwhWAOzoUGJebEHJA2C02511u6n/xaGjoamQKsIBpQS8HSuPGknH3sXEpAHDICpibANgGjtb5sKZEgrDdRZ26PIiPfpJzPXFeRt2P3A2VAMrR0/Ucnz8Tejo2v87C3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jgDC/afs; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3d19d214f0aso14763765ab.1
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2025 08:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740156065; x=1740760865; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I4ID4+lyldDoEC3ThrXQZyVv5qoGJRoVswuBHih0cls=;
        b=jgDC/afsb6rGc2zHGJ7kO9eMMsDg4MMpWYpBaoLsNaLBNfHzLiuE8m/tt9TXZmMKkd
         KQRLxQJKvd7jBKrPjpcMh0E8EelGB2k777Cn9K204BB8V+T1JNrjG/kqxvyG8hb6pIn/
         6436opAbOLL0HVkuDjsFPyLC60NhM+mTr/CNX5TqEaam1zsYWjpl+VOiBVUvpxWxs+y3
         Sfmu+semPwZtpfcvrm8WJrd+CG+NPhY9QUWmR5M04KSKLzvfYl0EL7Wm+dDbiX3SntTC
         z+9PyGeyaGUF1un9ZiDKczLkb18oSCOTulqt9UZKysK9AR5uqf6UpL9m2EyxfRf8yeRY
         S+Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740156065; x=1740760865;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I4ID4+lyldDoEC3ThrXQZyVv5qoGJRoVswuBHih0cls=;
        b=YVJN8yFjKoLAmUB1+WMJ57iYOcIOdVHgSa6vWSKXNzqO6s5+KXOuX96JxAIwYIFEat
         RqcOec329b6YOqfe0tJwUBiuNIjNe9pxaR5WJ2/F5DWE2KV8mss+cY4kDpqZCrHl3rpS
         82Epm01ZjQ6jx3kEx4f982soFZpmF5zgZf8vlAsG+AcfaBsix20Hp9IZMPU6sihUm49i
         eQlhmsJQti0oxJlqIDw8EykCsxKdpsReWbFYDCTRSOLeTVQmX01UotGrU4MQx3BEvtCg
         9MUi5xaBFI5IExGgCNLLxKWe0OTrzMMH9GqZSV/as7N/QFPhUxRai1OwYMYjGgp8ZF7y
         8pTg==
X-Gm-Message-State: AOJu0Yw55es36aOAwkzFxfQ0elX3uPSTaL/NftMHT/5HRnBTZBpazaBd
	uIIge9AgMOp7z0Paztl2cgnf9YYfAEOY7kvXBfYRloHNm1GEIOFYtbq3Z/uzDbROFyXUHjIO+k4
	W
X-Gm-Gg: ASbGnctEX/4fYIywGPl/WreeKB32I6gH9w249rsWlehPi/LV1pefuByltfOaX7IoLtA
	//6noCiIC8OAAj0cZ7fRvJZ7ZQDFf5Mr+ytetbORKAkErCu/aFJPJJhdFqi7/VVGt7U+PComuow
	ux0aAGBFlZW6ku8tFwJKFselRq3ZRm3TOW4+Q8yHchoPjGA+ph8zl3eVCEtrXhT1zRpTUm0kvs9
	SJOOoUgkNdsb01gOAlFcRTVT80GIJ1zyCzA8Dr0IbAsZ+6KFSD49i+IrbA0Ktcd8rU5mpKtHXo6
	HS3L0BjI07E9erUtPw==
X-Google-Smtp-Source: AGHT+IH24WicmLTOdffhUruC7b/9hi6JwA3K+wqMsYujP0Llt/zIev+nrrMyu7vVLU9VPE+m21XCLg==
X-Received: by 2002:a05:6e02:1c0f:b0:3d2:b34d:a264 with SMTP id e9e14a558f8ab-3d2cb492863mr40089155ab.12.1740156065127;
        Fri, 21 Feb 2025 08:41:05 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4eea474d868sm2178355173.53.2025.02.21.08.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2025 08:41:04 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Bui Quang Minh <minhquangbui99@gmail.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, David Wei <dw@davidwei.uk>, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20250221085933.26034-1-minhquangbui99@gmail.com>
References: <20250221085933.26034-1-minhquangbui99@gmail.com>
Subject: Re: [PATCH] io_uring: add missing IORING_MAP_OFF_ZCRX_REGION in
 io_uring_mmap
Message-Id: <174015606425.1769700.10918790702012673616.b4-ty@kernel.dk>
Date: Fri, 21 Feb 2025 09:41:04 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-94c79


On Fri, 21 Feb 2025 15:59:33 +0700, Bui Quang Minh wrote:
> Allow user to mmap the kernel allocated zerocopy-rx refill queue.
> 
> 

Applied, thanks!

[1/1] io_uring: add missing IORING_MAP_OFF_ZCRX_REGION in io_uring_mmap
      commit: 92ade52f26555f15880b42405e35f0cfbb8ea7db

Best regards,
-- 
Jens Axboe




