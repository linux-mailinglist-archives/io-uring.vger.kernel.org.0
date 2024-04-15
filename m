Return-Path: <io-uring+bounces-1551-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F8848A52C5
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 16:11:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C51E286D25
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 14:11:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9726246424;
	Mon, 15 Apr 2024 14:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Hcc9vUiE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36D474BEB
	for <io-uring@vger.kernel.org>; Mon, 15 Apr 2024 14:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713190294; cv=none; b=QG5AESQlCkHck1xhZPzkrEiSJABteUq0JLmCXgnBGDfpeAnblcyPbhmg/us4dOehzKMKXMxZ51uJYM9nmQKIRjKKPAv93jsvAAE8IxrvSkJ1zAgYoDBq48OpeMPLXmrTJKfbVbtSZ+wXT6SwCDRe7H7Ty15a9/eVG8GSdhwroa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713190294; c=relaxed/simple;
	bh=PGaHEmJ1pu7pc+ebv7VcmLzkXBtwTg/Xm5YzLlxalR4=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=jRPOD6WVaCkz4XiGei0oo+/raWWjNwiqQ7LrFRScPYelTj7pauNJ1JTOZDdW4cU/8Su28mqVRIV5S4ytb6SxFNVuXe97MQqGX3oFwNkZLxrzJXEYKboNANGICjjNrScF7etSV/+x+/qhVRk/N2Uav/1mRIpphdjKN/s9RU4Vt8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Hcc9vUiE; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-7d94fde45deso15328039f.1
        for <io-uring@vger.kernel.org>; Mon, 15 Apr 2024 07:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1713190290; x=1713795090; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MgiBhi8Nan5utwSTu1p0gfvjg4siZAobymDySQRUqz0=;
        b=Hcc9vUiEXQwxjNkrw22DkJ6pRm7Ciw/ez8WYupfAa06/WZcXVe4vwA1a5J07/KnQW/
         6MWBUUTZeWZXCQhCsUMzwMcKc3743caAxY+wuBRadZxdCGcjMZ5WDi7370jmuUH/ArAi
         ekXvRF9pT38BFl8kMekZ8jUUaE1qYXiEMnfiA8kKgpLLydlA9A5Za6VJC9V1avz3EMHW
         4zvBfq+d9mTyIYnbys9Eonzwlm1i9zl681tbj+wDY8AEAZZIX8DP2FSELIP4dwgz1J7q
         yQBYyY1VQPsCfnH+VkkjGmOyEFU8kQCnjzKAD4UNG0w9KfW5oh0oDpD2A3T9l/EEBEJB
         mQQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713190290; x=1713795090;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MgiBhi8Nan5utwSTu1p0gfvjg4siZAobymDySQRUqz0=;
        b=rREChZBM62qJLbP2HTPsJ3ww7X+JE1qzmZh4uo3Ve/2aYgixnJGci5XEJ0+9YwEYCo
         4al/6Ab5KLWy6Wfun84wRZ3syyw/0hXlE9FDih/mixIr3ky9bdxl3eyJL1sTOVrCql6o
         dltrAqK+BsKKpRDiRaOs1GHwNgzmdFwMSHD5j+EhWCYejDYrCH0Wri6QHcXQDmAZexEx
         Y1ibiIFwz8akE4+T067is1m2KKiDE/fs5pFX7B5EJ2hBNCv4od4AFO3dPuxkIzl0Ws74
         VOV1P79cF3KnFy61MX1BRjcaCqMfrBVYmPNc0usRPyfFxymQvt3E/CfYhYUUWd/CvBNL
         REBg==
X-Gm-Message-State: AOJu0YxCp4ePaVnCjZ3v9nbUu6HQaQwmfpziik2FitOqBY7521X66qPS
	5S8hEdtgPJLMRlEvDqHzi2B2+x6Lf/lhM5Gk5hDLwxOFzknOcVssXyZdRAdIsYU=
X-Google-Smtp-Source: AGHT+IGrJ5VaPyeUJQ93WcFvOVpL2RXCUL+5MpZqtO44dezYvcztaLB2gf+I4agnNtoE8xi/Apw6/Q==
X-Received: by 2002:a5d:94c3:0:b0:7d9:892f:389d with SMTP id y3-20020a5d94c3000000b007d9892f389dmr2034276ior.1.1713190289729;
        Mon, 15 Apr 2024 07:11:29 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id j15-20020a0566022ccf00b007d6905cc017sm2581027iow.4.2024.04.15.07.11.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Apr 2024 07:11:29 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1713185320.git.asml.silence@gmail.com>
References: <cover.1713185320.git.asml.silence@gmail.com>
Subject: Re: [for-next 0/3] simple sendzc cleanups
Message-Id: <171319028902.13246.4989296181535567731.b4-ty@kernel.dk>
Date: Mon, 15 Apr 2024 08:11:29 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Mon, 15 Apr 2024 13:50:10 +0100, Pavel Begunkov wrote:
> Simple SENDZC notification cleanups that make sense by themselves
> split out from the notif stacking series.
> 
> Pavel Begunkov (3):
>   io_uring/notif: refactor io_tx_ubuf_complete()
>   io_uring/notif: remove ctx var from io_notif_tw_complete
>   io_uring/notif: shrink account_pages to u32
> 
> [...]

Applied, thanks!

[1/3] io_uring/notif: refactor io_tx_ubuf_complete()
      commit: 7e58d0af5a587e74f46f55b91a0197f750eba78c
[2/3] io_uring/notif: remove ctx var from io_notif_tw_complete
      commit: 2e730d8de45768810df4a6859cd64c5387cf0131
[3/3] io_uring/notif: shrink account_pages to u32
      commit: d6e295061f239bee48c9e49313f68042121e21c2

Best regards,
-- 
Jens Axboe




