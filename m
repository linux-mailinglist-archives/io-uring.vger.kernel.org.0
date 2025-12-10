Return-Path: <io-uring+bounces-11001-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C2027CB29AC
	for <lists+io-uring@lfdr.de>; Wed, 10 Dec 2025 10:53:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F00E13009955
	for <lists+io-uring@lfdr.de>; Wed, 10 Dec 2025 09:53:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 647812FE053;
	Wed, 10 Dec 2025 09:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="gIKkrCQI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dl1-f68.google.com (mail-dl1-f68.google.com [74.125.82.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57772FE041
	for <io-uring@vger.kernel.org>; Wed, 10 Dec 2025 09:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765360399; cv=none; b=b5nF2zTD2Yv3ShBCTD7ARVMFZkhfrzLfYJBrEua0ldkq6iCyq5CL9WZnD3WhEveLulA6kSM4HW07NzekSBDkjCb29c5WzQekoOJRgPVwExJTgqrQ8hLv0Pxsqu6V1SnOUSwMuSuFJHL5Jk4oz5YBFcU8irV0GL9RG5XZ6svqb2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765360399; c=relaxed/simple;
	bh=JlM9AqWd1RyWOJiRCCXE+NuXQ2q8EHsZh4wxYWos3Cc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=JCPPvKYD8ikdNgUlAOo3lsFE0KzLpPyPR8NBSdVZ3AsMScyPXfV9C05tyBPdN+Ag5DUw9wasOdw1ZoNA9zP4cmm5i75G+ce3AvuUCHP3HjK8DRfo4p3H2PECaW8H+cELXo23o87UXhlljnUSijagwPNbIPdBPAjLNJwIqK6waM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=gIKkrCQI; arc=none smtp.client-ip=74.125.82.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-dl1-f68.google.com with SMTP id a92af1059eb24-11b6bc976d6so941805c88.0
        for <io-uring@vger.kernel.org>; Wed, 10 Dec 2025 01:53:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1765360394; x=1765965194; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iZ9EEX7gWWHH8n0IY8QrEGQfLIIl0O6mAljgho1luTg=;
        b=gIKkrCQIPaHGVwBrgQ0cozP5/GSytKQTKIodPQu8N3hDjyA3oDNY5uCUjbkIAuHdDb
         isJjFqw5MNsFrV4npmWhjOTA0EGaPflk1GyK1z4e900JlSggRiiFIf8JNt8L9wYWtPIr
         fx5Tg+pKeW5Pxkk664GOgWKdocFQ3jd4ooOvZlYznFU0RxPchuGGBsNe4EcLraFsscg1
         WHgZ/LAbBI66NlVmmEMTStLLUZAyC6ZBTaGd8gyj9oconNLi123fbvIqpsBAphlpvmR1
         pxqDHiA7XTvSBuJOPGfrnSgHicvzcb5f1qVqZMiJdvyzjfVc8GsXKnYp45cF62ECq4xj
         JiiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765360394; x=1765965194;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iZ9EEX7gWWHH8n0IY8QrEGQfLIIl0O6mAljgho1luTg=;
        b=WtwPVFLx/dxSr3wuZmq4bi514oqS3NBLDYo2AYEPP/lWbHC6ptxCeY2bnpTUFZgL4i
         aJKJE9EtviWKp5caxQnEUENu+okxdIl001Byjb4ZSN6/ts0pqn8WtdKJV87l6xv0kjQH
         J9VYVeKKReJcFH3bljGltcVLRgKIWbqQbVlkGUbCuDw9AOtaQABX+yiCv6hLMZAJTx7s
         nSAq1Krg8cDnfASt6BoMME98yGj8yI9VwORvpO3DSiok21+562ZqRQBj58Apih3rZKaA
         ZXfHPoTFkmyclmOeH4jtnSN7dVF6Bz5ygkiGbAspPExRs4kMNzqsrYiJcoJW9qJd5ZR9
         /BEg==
X-Forwarded-Encrypted: i=1; AJvYcCX5QfEp/UJdkA5iTftKvdNLOTo6+DoqdjUAEa4A1UEN5Q0Jlk3nPJXvnQwYFX7dL1/ma9ypCMQDhg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwfiDVHfqvyRykxaylMPIZ4yw167M84YCql/hBqkJiPb5a3sxIf
	wGRJzRIwmv8X3uV7AG7q6OmV1ausd5psDVOOGh82K3GvpIgyPFMzARygpaXbgeuc0DU=
X-Gm-Gg: ASbGnctvq+L2kH3hySTl2WTJFHcHEU6Zv/+CGcLwCEmtsCueDMIEC9jhiQJCpSLRFlL
	yF//bpjDGjRBaJyOBS2deTOGYzzMHnlGrhS09D0zkVSnxcRIyGGeYQohbd5AjcJBXWTK52Zfv9R
	jGawlKsiKsrWozqJbmrK0be9oxIk7e1rFle+DI+y+a9IOwWt89+xnYaA43QDlMy937gHjrBhaoY
	gS1I1xpZe6jKo6kMlhz7frPg+pnUMZ9WfYkVFMk620XOIjWPGtI4zmRzwIXbwJ20g027/WRKn3+
	6KwrdckO3SpM7Wm4wM/zg4YcEYIln0zij8fTfBpTRrkmyUQFW4kQm51haqCjWc0a44sAAuQBUN9
	ZnjDvcQhxBMToQCdv0bXit+a7pSqt3tipp53xc+5HMRU/Fp/kXWxer8iY+JLPRb8U5KOx682i/s
	zRDUkgFM1Tna/8u1WbXTBHwvQXOMiP5LlLNSJrKb/Ej8gbRQ==
X-Google-Smtp-Source: AGHT+IHb7PFhBpV9M/is4IpdTv0jkLx1d3s483r56oIxRo6qeVoMfzipcDEXWj7q+KfJ8YyPdmKkWA==
X-Received: by 2002:a05:7022:160a:b0:11e:3e9:3e95 with SMTP id a92af1059eb24-11f251eb96cmr3482629c88.26.1765360393771;
        Wed, 10 Dec 2025 01:53:13 -0800 (PST)
Received: from [127.0.0.1] (221x255x142x61.ap221.ftth.ucom.ne.jp. [221.255.142.61])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11f283d4733sm7250095c88.17.2025.12.10.01.53.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 01:53:13 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: asml.silence@gmail.com, io-uring@vger.kernel.org, 
 Fengnan Chang <fengnanchang@gmail.com>
Cc: Fengnan Chang <changfengnan@bytedance.com>
In-Reply-To: <20251210085501.84261-1-changfengnan@bytedance.com>
References: <20251210085501.84261-1-changfengnan@bytedance.com>
Subject: Re: (subset) [RFC PATCH 0/2] io_uring: fix io may accumulation in
 poll mode
Message-Id: <176536039245.440710.12005422623407238580.b4-ty@kernel.dk>
Date: Wed, 10 Dec 2025 02:53:12 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Wed, 10 Dec 2025 16:54:59 +0800, Fengnan Chang wrote:
> In the io_do_iopoll function, when the poll loop of iopoll_list ends, it
> is considered that the current req is the actual completed request.
> This may be reasonable for multi-queue ctx, but is problematic for
> single-queue ctx because the current request may not be done when the
> poll gets to the result. In this case, the completed io needs to wait
> for the first io on the chain to complete before notifying the user,
> which may cause io accumulation in the list.
> Our modification plan is as follows: change io_wq_work_list to normal
> list so that the iopoll_list list in it can be removed and put into the
> comp_reqs list when the request is completed. This way each io is
> handled independently and all gets processed in time.
> 
> [...]

Applied, thanks!

[1/2] blk-mq: delete task running check in blk_hctx_poll
      (no commit info)

Best regards,
-- 
Jens Axboe




