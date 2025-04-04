Return-Path: <io-uring+bounces-7389-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 64F5EA7B5CA
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 04:22:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 54FE0189CEF4
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 02:22:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 063472628C;
	Fri,  4 Apr 2025 02:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="h8eE0rtX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC34E17A2FD
	for <io-uring@vger.kernel.org>; Fri,  4 Apr 2025 02:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743733202; cv=none; b=hoeMGDiS1TwRGHm41uPSdwXkZlGpB5RMyzDCXRC2NybKobQAzOXMttuk0+Gwghv/vyiVZLjfFCpaexWCHxRxs73a+d65dXgWXW18o99oDMpIN8NgW8DRJAf/iSUcZ00qIXCiL7Wj1DiLHD30sEDzVZp9RmETLMK/dxnP/Lgua30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743733202; c=relaxed/simple;
	bh=viauY4W22XzOs/4/4vEnGIRS3fPsBxVvkPzWY68WWvw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=jtiFnXYHY1Pc22IZ46POde1zMHpSCIFQHHypZ5ZKXi1ibgJOTV5+utUnd4FxiqcbImR7zXujaPmNbXhjg0W7Mvhem9/3Brh2d88pBiOXzKjSIaOhLE0iMCuHA+SKOUTfgR2knbp+vSK4SFuwv8o7ZcvywuI/DxVZ5ym8dwVHf9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=h8eE0rtX; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-85e15dc801aso118384739f.2
        for <io-uring@vger.kernel.org>; Thu, 03 Apr 2025 19:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743733198; x=1744337998; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C6aKWvhuA48zE33ggUf4PNXsIWWoh0a+qeJyXXIFSl4=;
        b=h8eE0rtXsQE/odVmu4NafKeKjtF8c61PAkMdzLj3ffuuDy5N6jFMagjkZRNVhVKlqh
         tSv09GJoTrLPRNYkcm/cNpwLGA3I9Yg0uY87MeZk0+oedRPiJgaNB7D1ODabbRE//n9u
         +fouOgOnLwKQAq+YVmm57hyuHa9lKEZ1HJKsdgoeOlZp5M/yyIfxHkeFZVI54E3yLcxU
         JwCkaFkmWv04y0tTN9Uj1oVelkHLnbxGXgFcpTcBYNndaAvVBsX4FXKbXw+2NxysYlnB
         ByIKDkDlXJd0wRbEHVqYTfIwlIccUDydlMa40qFM+WcVB//FuboFhbxgzakGpir+5g5b
         HRUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743733198; x=1744337998;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C6aKWvhuA48zE33ggUf4PNXsIWWoh0a+qeJyXXIFSl4=;
        b=iMecJkmIOwsyj4ScRlX1vT/a2t2cw1idQ+jrs1W4Vh6+Wm0th2KVWPZyDSsKZNXejg
         6d2fIWj66QcivhyhplsM5ycd0s4UjDnKKSumkrp57UPD37lSc00N2u1Fc9K7T1MMGa5C
         X7N/7m2PeCiefzR2oAlszpnY19b7sgRGIOr/QIJCdmmKCjpWSXdKdvUbal/gvT+48wv4
         V/XDjwy2RWJlAMwFPZQIOWh+CorcjzG4ndfnyXUpdw3aW+ER57nnU0Aq4vSlPrOJy2tB
         lOI2N2GF01E/L6njVPF1rKIy4kOZYYRUaRYU3M2Mslr7WwBz2N1eYDTEhgwKlM9zcsVM
         /WMw==
X-Gm-Message-State: AOJu0Yy9JOw0x+KOQvq+5rmZWas0Za/jDsZeLMofwigSYWvPzALas5SJ
	0ZwrbRMGPgugbqMt6I3mjC0epnk2cdJWm0MaqBQtvSWcp4iYpAZGsMZ/oVxfnaY=
X-Gm-Gg: ASbGnctYtzpKY2JHpm3MqLLPCoc1wW3Jxz5SY7soXKHZd+HQknBHYqaEm/cosCDjcph
	kklxE0KGQLAFfXhGA8Cbkrv5AZvWdctC5o4mZ49feKW0WCCZ0CbAEuzN9J6KmfCSddDGDJB4Xs/
	jVId0EsRMLemkwipH3KPF1sD8T3SFjp0q4Shc8yAjRVZoqt9zgcjlH1p/YqeXl/sNpL6s/0xX7y
	iN0wr9QKBuUYXLr1Spg9L1o2UxhRBhCees6xqbFsqGpq4uX9G+N39lwDto7Edw5nXSucaMnhrue
	bew/AZVBSUCInNWmzqyohXqCu31MOIxDoBOQ
X-Google-Smtp-Source: AGHT+IEzvqBl5+D2se6dffkydLAa59IqVJ0Mmc1cResHW31sfryBDHYHwP6o9S5i0eweNbEDnAb4Fw==
X-Received: by 2002:a05:6602:3811:b0:85b:4154:7906 with SMTP id ca18e2360f4ac-8611b439f6amr193994239f.5.1743733198527;
        Thu, 03 Apr 2025 19:19:58 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8611137aeacsm44849239f.37.2025.04.03.19.19.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 19:19:57 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, linux-block@vger.kernel.org, 
 Pavel Begunkov <asml.silence@gmail.com>, Ming Lei <ming.lei@redhat.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>, 
 Uday Shankar <ushankar@purestorage.com>
In-Reply-To: <20250404001849.1443064-1-ming.lei@redhat.com>
References: <20250404001849.1443064-1-ming.lei@redhat.com>
Subject: Re: [PATCH] selftests: ublk: fix test_stripe_04
Message-Id: <174373319721.1127267.3756134797323684566.b4-ty@kernel.dk>
Date: Thu, 03 Apr 2025 20:19:57 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Fri, 04 Apr 2025 08:18:49 +0800, Ming Lei wrote:
> Commit 57ed58c13256 ("selftests: ublk: enable zero copy for stripe target")
> added test entry of test_stripe_04, but forgot to add the test script.
> 
> So fix the test by adding the script file.
> 
> 

Applied, thanks!

[1/1] selftests: ublk: fix test_stripe_04
      (no commit info)

Best regards,
-- 
Jens Axboe




