Return-Path: <io-uring+bounces-5920-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 030ABA13C55
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 15:35:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 23072163A6E
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 14:35:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 951A88633A;
	Thu, 16 Jan 2025 14:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hdqc5AvU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CE724A7C9
	for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 14:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737038111; cv=none; b=lbcUQ3Fl9e0jZ2If1TG76GkIOuYfzDbA6JUzDo40AUi8Owo8g7oK1cNnY3cuXxjZQy/T3/GhGTnOlFZjpNwyVLOXgCmghQzh1onLISGkEhJWdqY7S/omL6BCXhErDc31/DH8Uxdx9vkJ+OW8kBDkWXzyvGYGsGjFNO1HWagbm5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737038111; c=relaxed/simple;
	bh=4Dk6tG+GhWySb/qJbrPdjEuugM3MTZn9ZHCYWNdN8ug=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=iq3B4XbTtIMkW26+gHpK7go8jy4Ua4ndoUCYQf+xLnmo6ZbBZs4UOJGEMH+W2qFgQ7vEre376keo4PfnZQB990vZCo4LYrC6AsfyWKOgKowha9vxGKNJLsyMSk1dv9GDmzIRYykGYyp+onsFcvlKS8o5nO2xm8RCg7nb7p6N66A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hdqc5AvU; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-844ce213af6so33135239f.1
        for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 06:35:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737038107; x=1737642907; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r+3f+DcvLYdzFwtL1mLeFdCXT6nSorFHDAXRS7rVMfk=;
        b=hdqc5AvUpgFOj2qEJpfr76+5e4mkLTeBJ53rK6RR/zeuaICeDivck0Dw+rpJEIHeIx
         bZ0vMV6fSTZ8nPXrUW6+6/kEXINWhMEqmRLYTfhn8RK14MAwVP+UWrfnlsbPHTj7sGYq
         UZnu61yaIYCU9gZXPXzFRhEpv4cxchU5oiagBsMjOp672fH7QGMcfHyDDCsOL0yGyw5f
         7LnDuJOs0uqO+HGYGVv/IB5sVUDrgiVh3UdAr9ZL8pZ9Qp4fbLMq4PO/tVi3bNnoc9yI
         iUpBk2ndeO3Fhu936AMCGrGNdmwXzSXgZLRWmOaNYHtRJ5tshtewWYYNxaNf5KmHDiQw
         N0OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737038107; x=1737642907;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r+3f+DcvLYdzFwtL1mLeFdCXT6nSorFHDAXRS7rVMfk=;
        b=hlWC4Cs71eruVcxV/l3TdvpvSH+EtsYHCTVCR5t5rPDle9KDkdBfRbDEpQdMMrAKK/
         TjEubM7gJXPBPEdC/BjRybarf+fw4ITPM+eCx99SI3S1BU4y46w9cUOEh7zqSiispgCZ
         cA1qzkgujXFbCDIqxBpVKKQ+B0ah4A4kxM6aLnuEEZ0YMHcgkvlmCSfexaEnjacBz5QK
         ovU2rHauixQyroaU/droGySljhDgGC5dhYZOyAtQkLoTJ6TyQFlT04GdwTy6kC1syqSU
         EaD9V0KU5dFk6FPzSmXhnX8fjRwpTTvxepOq2y2gkyVy9W+MWESXgY01LsrAC2Puce4o
         61MQ==
X-Gm-Message-State: AOJu0Yya0kHkDF0MOE1wb4uPOFw2xodA9L6OoV84L+rkY37btUKgNO14
	vffUbLXXPR0GSYohWG2NP5IjGW8XkA7aI5P3g3tKeVNarEwQDcvJqMYpT6xTVCp0BdvbbhFTJHU
	w
X-Gm-Gg: ASbGncspA122sxeC44ujS4+OA+QAFRKsZDQNrZ2Y0Q90G6d3+dcXOOChkEVM1dLEySv
	YF/bAq36CGGFtlwCpBdkXh4bPIut2kJJHbpP2zfmvbquJU4qw7qyvj/O8CAgR7D9g8okNS5xs7R
	GN/RFEtQ1F85iIZ0Ana1dAcsuWwvVuiHjT1eF1TYbrifXgmMARbK3Ts/6kXbz1RYFmXbzEgXZrT
	IN2fEAOSZd+idb8W6+/1qX93NfG3XKSfwOuTGsO3MIpWM8=
X-Google-Smtp-Source: AGHT+IHfZkB62QCbggv3rv0IsX1fiWE+YP1NBdWW7aPEf9B+9SVbMn4k3fxMXwfh4SjLQwvG+SD07Q==
X-Received: by 2002:a05:6602:4a05:b0:844:e06e:53c6 with SMTP id ca18e2360f4ac-84ce0166661mr2758887539f.11.1737038107560;
        Thu, 16 Jan 2025 06:35:07 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea75495f5dsm50579173.60.2025.01.16.06.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 06:35:06 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring <io-uring@vger.kernel.org>, 
 Sidong Yang <sidong.yang@furiosa.ai>
In-Reply-To: <20250115142033.658599-1-sidong.yang@furiosa.ai>
References: <20250115142033.658599-1-sidong.yang@furiosa.ai>
Subject: Re: [PATCH] io_uring/rsrc: remove unused parameter ctx for
 io_rsrc_node_alloc()
Message-Id: <173703810672.17139.4735547261796102265.b4-ty@kernel.dk>
Date: Thu, 16 Jan 2025 07:35:06 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Wed, 15 Jan 2025 14:20:31 +0000, Sidong Yang wrote:
> io_uring_ctx parameter for io_rsrc_node_alloc() is unused for now.
> This patch removes the parameter and fixes the callers accordingly.
> 
> 

Applied, thanks!

[1/1] io_uring/rsrc: remove unused parameter ctx for io_rsrc_node_alloc()
      commit: 02c2a59d20ae1424fce4d08d1dd5e61d911ac1fa

Best regards,
-- 
Jens Axboe




