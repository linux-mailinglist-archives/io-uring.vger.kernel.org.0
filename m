Return-Path: <io-uring+bounces-8954-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41A5AB24992
	for <lists+io-uring@lfdr.de>; Wed, 13 Aug 2025 14:33:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 538B23B2C3F
	for <lists+io-uring@lfdr.de>; Wed, 13 Aug 2025 12:32:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0778717F4F6;
	Wed, 13 Aug 2025 12:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="aFOKi8+a"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523FA2C0F60
	for <io-uring@vger.kernel.org>; Wed, 13 Aug 2025 12:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755088344; cv=none; b=ZCEdW4hSKj3+F2uUJjYIFhbjJxTvXIATEd40HzxL3DF3zMc3M7gn9WkAS7M4T9ZPpX0Jue24vC9gjJPZeXlgcyHgXocOHyFlksxen7iW6hnblSKIXcsAbb6Xi02t8SQJtjhhOmFVuSwI5QHwzuNbPjSUAdgnNxlQ0VLJJXD1azc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755088344; c=relaxed/simple;
	bh=kNCJWuPUyDQ7B8Oyoc9paWVucZz3ziGhP5Yn3e7oodk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Mj0EJ+N8jsbqxVGquPSDG+vEyq+JceeBqYvKlKLkL+ZOfn1Bvg3zYb+GMIAVSoTL1SBERY1jdwMY7qjLSBLz8ThQ4nYHfS9H4j4xJlCKxo+xVA/I3eGH1H+tJJe5wK451HpJ8EH8G2q9hADr222oBnMctTGlMS7p9CPehVfLvak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=aFOKi8+a; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-321c5eb1f4bso1211756a91.1
        for <io-uring@vger.kernel.org>; Wed, 13 Aug 2025 05:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755088343; x=1755693143; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w1IQEoSdpxHttYa87VLIcAQInibFZXNzj1ynFJ+dCLg=;
        b=aFOKi8+aD0seS0R8DKkEktHJiIoY4dzDpBVy/J/DOhFOrPcyYXeczNdSLYY0xG4TlF
         jSJkDltKBfgWf9ombP7kUSK7t5HqurIoiphmOKgzGYzN4qtyimk53Jz/TgN5scuhhB75
         7+hAmEgANSTT6v5irr/soJJIiu8zF/qHh3Y4oehabIGq0xHmzoIg8ZPT7boWe+yCQZTZ
         KOv9YbLlRz3ixYv3KV6VAQXqbBtb3gUqk8RYsa8yAUxsdOvwJut4AEHxPaD1TqVJQwIx
         QlxqzL1t23QqRYG1qsBkUGRGA52Ek3zmT/6GyU0F90oRDktN4Kkhq3JD/EgJk0h/9K5V
         4Jtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755088343; x=1755693143;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w1IQEoSdpxHttYa87VLIcAQInibFZXNzj1ynFJ+dCLg=;
        b=FIdhPA8awIKTByVhZHw8Faj9tLQD9/rTxX9fpioivNO7LfeMnfC6oJxPoaU3nX/gD1
         +pY6U00Cw0cDBloo1O2VzTa1G3mggb3V0rcxUVmFKIqVMYS0cKvoIFHt1L/bdBQed1nM
         Ea3wq4AjGn1pBS6WZC+5ETUbZhUZMgKON7OwR11RoV6YRvzUQD4o/rn4aGYfBfAd+trv
         2g39DfYlATECNMKuWiIAmbsHttXa8K/CDiJCaXKh9J1iP1GOwtl2vZDXUCxJmDlihFeO
         HPmCVqCBwjFadIhdQ0luj7/gv+AogJbINi9mHvSQdscg3b1nWlBO2YQWRjX81emb2bPo
         2oKg==
X-Gm-Message-State: AOJu0YzMQeV3Je4t/oMUGKYd+6Y8jjKMKC0ydsQAd5TXoTLLUe5SOWS4
	PSCzIbykMEkBHibs9mLPD6HBkfF2RfwuZNxuKIW+WC1e7TaeX5o6NwIjPsSaPu03/OI=
X-Gm-Gg: ASbGncuftbtOx6g6Vx+Xlp/n/ZrD9VSTXblmepWJzLMuj08SJzHXqXdaKP/aBhPVTwL
	Nnmdlt/K5AT+kOiUaC++Vylzr0B/9HTRnPhn7VWpeSUUX5gaek1Xrt45n+LxFrPdnLPiWX5SetL
	/kaNaUTCEyw44oDxyAh4DCEGGYyEdUJKcn9YWkUCKX/W/Ebtm+glA/YwR04tWHW7UoLumxBSwxE
	xtTOr1U8TQ/Ei8z4HzidDGDn1udZhWXhIuHtC2zXUPwrTfX9wKiyCh88R9KAdOgjBJ4rPvwg8kt
	CZ0XoU8MEo+3jwIeC8qY64La2JQXy8q9gUfi1a80QyfA2++zO+77Fj8nnAk1EltP+Nl2BHl/QTW
	BEz7uLgdywBt3mdc=
X-Google-Smtp-Source: AGHT+IGkF4n/CDK8zvLCTqhnauoSHIbp52uVh//GCrtq3+xK87WpDAaLp7d2EWHXp9TVMSuz3eR2Mg==
X-Received: by 2002:a17:90b:562c:b0:311:df4b:4b93 with SMTP id 98e67ed59e1d1-321d0d671aemr4172974a91.7.1755088342571;
        Wed, 13 Aug 2025 05:32:22 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3232553e4a2sm82418a91.4.2025.08.13.05.32.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 05:32:21 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Fengnan Chang <changfengnan@bytedance.com>
Cc: Diangang Li <lidiangang@bytedance.com>
In-Reply-To: <20250813120214.18729-1-changfengnan@bytedance.com>
References: <20250813120214.18729-1-changfengnan@bytedance.com>
Subject: Re: [PATCH] io_uring/io-wq: add check free worker before create
 new worker
Message-Id: <175508834085.953995.1091490656256130940.b4-ty@kernel.dk>
Date: Wed, 13 Aug 2025 06:32:20 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Wed, 13 Aug 2025 20:02:14 +0800, Fengnan Chang wrote:
> After commit 0b2b066f8a85 ("io_uring/io-wq: only create a new worker
> if it can make progress"), in our produce environment, we still
> observe that part of io_worker threads keeps creating and destroying.
> After analysis, it was confirmed that this was due to a more complex
> scenario involving a large number of fsync operations, which can be
> abstracted as frequent write + fsync operations on multiple files in
> a single uring instance. Since write is a hash operation while fsync
> is not, and fsync is likely to be suspended during execution, the
> action of checking the hash value in
> io_wqe_dec_running cannot handle such scenarios.
> Similarly, if hash-based work and non-hash-based work are sent at the
> same time, similar issues are likely to occur.
> Returning to the starting point of the issue, when a new work
> arrives, io_wq_enqueue may wake up free worker A, while
> io_wq_dec_running may create worker B. Ultimately, only one of A and
> B can obtain and process the task, leaving the other in an idle
> state. In the end, the issue is caused by inconsistent logic in the
> checks performed by io_wq_enqueue and io_wq_dec_running.
> Therefore, the problem can be resolved by checking for available
> workers in io_wq_dec_running.
> 
> [...]

Applied, thanks!

[1/1] io_uring/io-wq: add check free worker before create new worker
      commit: 9d83e1f05c98bab5de350bef89177e2be8b34db0

Best regards,
-- 
Jens Axboe




