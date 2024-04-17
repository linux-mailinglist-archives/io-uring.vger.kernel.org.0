Return-Path: <io-uring+bounces-1582-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A3C88A85F4
	for <lists+io-uring@lfdr.de>; Wed, 17 Apr 2024 16:30:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 564382826F2
	for <lists+io-uring@lfdr.de>; Wed, 17 Apr 2024 14:30:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3C4614036F;
	Wed, 17 Apr 2024 14:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="eIjrsjY8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5046E13D290
	for <io-uring@vger.kernel.org>; Wed, 17 Apr 2024 14:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713364197; cv=none; b=EtIG0sNOq8zTqtqUWVHqKZiwEYbXH34B3ig+TJVIDhZpwTeBlGXw4ymFCdkkXaVo1boWVDDmPhfy2XfpqH0f5fWl5OJVN2q2lB5wZckyUKb3G2xLoHi3TV9Bnwwx3YgJQXonAmTv3Zl5YWjQS0/KMxwkkF6XJqzMWLLJCmxOWJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713364197; c=relaxed/simple;
	bh=piV1HZtuIHqItUFq/E8AVj7NeWKDbWYTD2HzdYNZ53E=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=PuTvAM+1nnO9AeC7j7eMBC3FqsuaWZv26nYAPutPtA0eynnkyLfU1SNRio2QcTJAKPYvZcJ0NlOvyStGYSFsTSi7evR57LKBbubbHSGmXAzQllJ4us50/xpga5W0Qpzjy8AORwRfqaJtH9LBLFNlQ/BUvUHO1zRolCJ3fkgDtJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=eIjrsjY8; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-7d9a64f140dso24479839f.1
        for <io-uring@vger.kernel.org>; Wed, 17 Apr 2024 07:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1713364195; x=1713968995; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vipV28Yr5zjBGOpRyyxn1dyQMVr/kIJxwtZLX30eHGc=;
        b=eIjrsjY8gB6/HqoWm62GDZO7KoTFiYPuQFslD1uscXPUeRHJsdH5vOhK748O8gsmhr
         YlriKdM2SxkH7+aw4g5kmkPkW5XXqH8TJ/twCoHRpTv5LQehXN1417Zbrg2SgTEhSr6m
         r7nWmLGOzs/JlHJDWyq59pcKgF6cB00nwGQ4e65gXNgjSmKkfSCS2ptSYcy/Rke6mrTA
         kS2ThdXdBwnWTSeQNLAg3o7Arc+TZDyDwWzVL8+KxKzuL+ULqZ9Tl3WUtlGO+XSjuKPx
         sU7sjhG47+YK8paMT4Hku05aBLA5MT6f0y/inLGIhvrDyfSVM+7HroCSOv9sPuPA0CD0
         c2Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713364195; x=1713968995;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vipV28Yr5zjBGOpRyyxn1dyQMVr/kIJxwtZLX30eHGc=;
        b=VKoHY2P+chbQDMK7k/bC8g4tIxdey0KTvndH70/5+HZLy31YutfQ6YFuhrBPOTRgQG
         ZgqNATdSUFvnQFLHB1lFc6fjs3AGtWHRWgZXljeroEhMtIefR1uD98OLE3uH4vhNDKpl
         vk6xygnOThpZPyF3fgqYylK6XiITJG1DAsmnQEO95Rtinp4qOMADbZR4EmF32Eqf9bqu
         igHl/cF/VheUJidR1HrTi0RDc3UeVVix3PMy00pJetkgIo9OHzNOV3tQ/1J+yvbu2OHq
         2/m5QEs8dqOB/GxO3TEZz85B6FSTVmel59SZ+cYu9U5DTfvuDAnPRz/HBip8W7NNIO/0
         +rTQ==
X-Gm-Message-State: AOJu0YziKSIndmCYPJh5DBPz8pwxFuDzHv/YtaKC0HIGs2YV+ep4Ggcp
	FVG/gWel2gOV9UuBcQvm1saLgKXVf5qhcfy/udkGrQkmBO7hbbAmaef2ct/CkAQKSdLdQksoH2M
	V
X-Google-Smtp-Source: AGHT+IHykh7EdOOKYxbJtgq8HNv2Ptef1Q3rOWPXaik/v/5XugxMWN1YGlBhiLVNAcBLSglzE6WNLg==
X-Received: by 2002:a92:b102:0:b0:36b:2ff9:9275 with SMTP id t2-20020a92b102000000b0036b2ff99275mr4751157ilh.2.1713364195440;
        Wed, 17 Apr 2024 07:29:55 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id f6-20020a056638168600b00482cd74e958sm4454864jat.85.2024.04.17.07.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Apr 2024 07:29:55 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
In-Reply-To: <20240416021054.3940-1-krisman@suse.de>
References: <20240416021054.3940-1-krisman@suse.de>
Subject: Re: [PATCH 0/2] io-wq: cancelation race fix and small cleanup in
 io-wq
Message-Id: <171336419491.150319.6267913495904795358.b4-ty@kernel.dk>
Date: Wed, 17 Apr 2024 08:29:54 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Mon, 15 Apr 2024 22:10:52 -0400, Gabriel Krisman Bertazi wrote:
> Two small fixes to the wq path, closing a small race of cancelation with
> wq work removal for execution.
> 
> Thank you,
> 
> Gabriel Krisman Bertazi (2):
>   io-wq: write next_work before dropping acct_lock
>   io-wq: Drop intermediate step between pending list and active work
> 
> [...]

Applied, thanks!

[1/2] io-wq: write next_work before dropping acct_lock
      commit: 068c27e32e51e94e4a9eb30ae85f4097a3602980
[2/2] io-wq: Drop intermediate step between pending list and active work
      commit: 24c3fc5c75c5b9d471783b4a4958748243828613

Best regards,
-- 
Jens Axboe




