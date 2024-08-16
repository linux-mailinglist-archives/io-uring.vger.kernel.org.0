Return-Path: <io-uring+bounces-2794-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C2A159550E4
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 20:32:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7625C1F22678
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 18:32:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCDB51C3F3E;
	Fri, 16 Aug 2024 18:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wq6dWmvT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A837F1C3F1A
	for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 18:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723833106; cv=none; b=GCetQqruwXtN2QhjXg1TWODHXG2AtQrmw2Hve8YJOXACQgzFj2c0CY3ExyvTOgxsDEpbOeP9/IL7f5pGkWwfHZu/ky2lNmV1T082OxLSw3B3cLDXgIukcONsmqstHrN9/7L2r4f0/jPfAFq+s/2iBN7gPKnpXmFonSA0NNhTzn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723833106; c=relaxed/simple;
	bh=wBLC1xx411MuYumWmylECOlPJ0WUNHKgh5uSMFv+/Ms=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=SYO4LcdoqOLz3cH59XfL3M0YR90QCkCgbiLd/rpDBmMg3NS3HJ5BROz2+L/cKGCbsyxZmlQS83ib+pbn4Zb9QkK3ua9Aq99EeE8TnrjSvlJY8BRdyS54Tc/f2OOUzOM/nIgnSvUVV3K/Sk1AUzhBia+UYGox5p46soX7Cd569ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wq6dWmvT; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-824e1ebda41so8488639f.1
        for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 11:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723833102; x=1724437902; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CyWPYhOxF7kF1eQQpUEIw+fTUDykck1g2NssSbBG/20=;
        b=wq6dWmvTiV8EqsbeJn17e46dmg4bbzRzqqFhfnrYTCznUhf7Wu4LoQn24GI1/XX6lL
         jF39GHZbBhDRL6eoXRYra97tIVDDBntKpBlC0gBBrG/IngKJuY8WTj/gPmMUK6lrsAhh
         yzZuM2e8aNAh5/HHl1k0w+0vxYst+kk/VIHVkFSN04utQ+IAJaEYDpXaziWEN5G1Im98
         MLCnhUDumStnMdtnuoel37z1hjaGEG9S3OND/3j//wOz2GIKumqZD0w2nW0e/IquR9Nw
         wNShe6LB7UPlUb18MRM8xZAkg21YR0MM9vya3yogkeZts5VTf6B78tgr6Zu7YDP7qtwp
         0XTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723833102; x=1724437902;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CyWPYhOxF7kF1eQQpUEIw+fTUDykck1g2NssSbBG/20=;
        b=qM/LYcdcm20M8OB3Kjc7VWlREeW7hVCLJ81E/VHE/DRfVcyiJSn4o2+B/CJLVT8pJO
         ejAaPdfi5cmMXLHCmohgocDxQeMu4XalU9r+zRPOH6gCBN1Iajzytzi57OeAztpLAqUi
         F96WmL28ZENGOCgc1Wp4OFvsNkwShby5fqya0iYHUnChRj9cR70scoDrbbiKxGqxTaEi
         8En0nOGJpk45SvXPUkkoldq1rMaE/PzGmVv23M2He8Z/RQyGs2NMUPTJZl7OnGbZECTL
         VqHnfoX4TuvZxnvud1wq7ZMz/jbV9tZd4shSgglpaj5Ndwb/IJfxXGG2YDxu/TShbVGL
         lQnQ==
X-Gm-Message-State: AOJu0YyeQgu4HDz5paLehj2AfPzjhpmR5tRBUWj8LJYsvi7BefXbnRYO
	w2scYfYMfDyt8tsknk/YBni5YSRqj/DjkcEIR5NNv+kUdC7zEdMWdOIoqUDiRgU=
X-Google-Smtp-Source: AGHT+IGQSXeaw/DqDeJx2+noxycL9i553HwUohD6ABSHKf1OrHgQxNiEftc7fIzHcS749UNlUk55Qg==
X-Received: by 2002:a5d:9299:0:b0:81f:9219:4494 with SMTP id ca18e2360f4ac-824f26a6827mr273898539f.2.1723833102399;
        Fri, 16 Aug 2024 11:31:42 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ccd6f3dc96sm1387426173.115.2024.08.16.11.31.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 11:31:41 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20240816181526.3642732-1-csander@purestorage.com>
References: <20240816181526.3642732-1-csander@purestorage.com>
Subject: Re: [PATCH] io_uring: fix user_data field name in comment
Message-Id: <172383310135.58661.17925473453197931956.b4-ty@kernel.dk>
Date: Fri, 16 Aug 2024 12:31:41 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.1


On Fri, 16 Aug 2024 12:15:23 -0600, Caleb Sander Mateos wrote:
> io_uring_cqe's user_data field refers to `sqe->data`, but io_uring_sqe
> does not have a data field. Fix the comment to say `sqe->user_data`.
> 
> 

Applied, thanks!

[1/1] io_uring: fix user_data field name in comment
      commit: 1fc2ac428ef7d2ab9e8e19efe7ec3e58aea51bf3

Best regards,
-- 
Jens Axboe




