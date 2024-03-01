Return-Path: <io-uring+bounces-813-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 41CE786E4C6
	for <lists+io-uring@lfdr.de>; Fri,  1 Mar 2024 16:55:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D6CF51F21B8F
	for <lists+io-uring@lfdr.de>; Fri,  1 Mar 2024 15:55:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80D1367E77;
	Fri,  1 Mar 2024 15:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="EjPUC1JR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058387003E
	for <io-uring@vger.kernel.org>; Fri,  1 Mar 2024 15:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709308537; cv=none; b=o3+du7FhrwVDVM21Xr4Q+WBKwVePwMUizDw7M7DbIR/TkCwqkCSgVGDlQLVKL4Q17SGzMNFQboBx+Gziuomga5YtdADyLgAK0sj3OC8rUylhxgaeHRP8g4iqZObtUSAOPddgeLEpP8hlgG2G7T4KgXhrF5BbbBxxgfD2W1OBGq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709308537; c=relaxed/simple;
	bh=n9kFjYjRE3qCNfcjmWpT8lMq1zW42Y+rPlcJGtESq30=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=kOycOnanUfkyPhsFt4b0D9CqdwWC25P4KBUlI8jn7nQ5cX3GoVGbrX2vXtydkbxieaiS93cAJTvKk4a0RKsQFmsVxb683J/XUV+1N6x08MdraV5jahFWmVnOgD5145qa9KTKUQk4vZYapsfsMCa60uSXJdT0CK+Jr5yc2mGkU9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=EjPUC1JR; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-7bf3283c18dso37156239f.0
        for <io-uring@vger.kernel.org>; Fri, 01 Mar 2024 07:55:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709308535; x=1709913335; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cuy/wgcCH07hny5bXY1Sk1fYdO558cghg+HCRH9bbn8=;
        b=EjPUC1JR7aBHxsdHTNgUQmnE+WUsZT9EEk6jUTzJ0mnuX+Ej6MzA8pusTqaeKHnQVm
         E0nHEYADLujhM+fViHSCp2I2gMawPi++NWWeEE4+xC7FpdLX3bePZUw1+iJCKp81SMjX
         iRGhX2zOlCPk2WX8JQz+Paq0FpjffN1ikuKTRkHqxwrsVyD6foWxcL85ajcoQFE95QJb
         ZxGb15H7VRbz2RYCH/WUIz9q9KGDpbW1ooEz/TP5lPjl13rdfmim4I3uLQzY7oS6Lp2E
         NwaE86V/1+5yYCxq9KcofHvsg2q1ukFBC1BTAnKCYQsReBfjWUeCdcfAqOmFQGEdS6tM
         uoKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709308535; x=1709913335;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cuy/wgcCH07hny5bXY1Sk1fYdO558cghg+HCRH9bbn8=;
        b=wCONn2naGXPSJ1Yw+Myw25bYkKrx8drejrzOIovvRRMRbVltnZqkJL8K+TKd0nSySU
         wiPjZGpvNdZ+zRLk+aGUrA7YQ17un5t3JyOCNQfrwvPHYiLvt8D3H4OqR6QXpVhBknde
         RJ9uZUKuuiWmD6DoAsN+wDsNlnG4QPSl08NyvmXexkCd4J8wFuDQhs2Q4olZQgSCPebr
         oNmgDXYeF8xRlNd2VDT25koG3oky3mPZveeXcD45eD4gQzy/2JudjFfU2b1DPpt4u5aK
         4uWM0qL7S2EKpWqQNWvoHcJbExunPRMbylAO7t+aNMnJkulgD7tejL7SyA8UNVRPYFpf
         S2LA==
X-Forwarded-Encrypted: i=1; AJvYcCWaHvPR1BL0xT9jci8nqS/7xqRnynXO5PU2ZBdrDRnWr5JulgkmFcfAeXEYTaNFkKZAZJPySzOcvVjqO3Qy0lAJ8XlzLipmUVI=
X-Gm-Message-State: AOJu0YxDxX/FoNaufif9QRYPP1VmJRqKklPJFob/5blkNSadwevYoYC1
	dUr65va/N96u2z9C/j6sKQdLhWurtxhRcL9sIG77fz5QUGqzIAFRM0J1TFfXiwZUnVcL83rbZaE
	P
X-Google-Smtp-Source: AGHT+IHUrApy+wOyvA8sED9sBQ8CJ/sYmaferYuZ3MvQVEiKHQQKdFnsIlVgvFZXeuJn78QW/IWMAg==
X-Received: by 2002:a6b:730c:0:b0:7c8:2c94:90b5 with SMTP id e12-20020a6b730c000000b007c82c9490b5mr357367ioh.0.1709308535226;
        Fri, 01 Mar 2024 07:55:35 -0800 (PST)
Received: from [127.0.0.1] ([99.196.129.26])
        by smtp.gmail.com with ESMTPSA id b4-20020a02c984000000b004745e754b73sm894609jap.176.2024.03.01.07.55.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Mar 2024 07:55:34 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Dylan Yudaken <dylany@fb.com>, Dan Carpenter <dan.carpenter@linaro.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>, Dylan Yudaken <dylany@fb.com>, 
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <7f5d7887-f76e-4e68-98c2-894bfedbf292@moroto.mountain>
References: <7f5d7887-f76e-4e68-98c2-894bfedbf292@moroto.mountain>
Subject: Re: [PATCH 0/2] io_uring/net: fix bug in io_recvmsg_mshot_prep()
Message-Id: <170930852923.1084422.13136941777087584791.b4-ty@kernel.dk>
Date: Fri, 01 Mar 2024 08:55:29 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Fri, 01 Mar 2024 18:28:40 +0300, Dan Carpenter wrote:
> The casting is problematic and could introduce an integer underflow
> issue.
> 
> Dan Carpenter (2):
>   io_uring/net: fix overflow check in io_recvmsg_mshot_prep()
>   io_uring/net: remove unnecesary check
> 
> [...]

Applied, thanks!

[1/2] io_uring/net: fix overflow check in io_recvmsg_mshot_prep()
      commit: a69d208854948bc8334a01bc17f13a06a5a977d2
[2/2] io_uring/net: remove unnecessary check
      commit: 789748af32c4a6f50db401d46e6a89ab28a6e3ac

Best regards,
-- 
Jens Axboe




