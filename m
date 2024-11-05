Return-Path: <io-uring+bounces-4454-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 067439BCD1A
	for <lists+io-uring@lfdr.de>; Tue,  5 Nov 2024 13:53:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 86380B224A2
	for <lists+io-uring@lfdr.de>; Tue,  5 Nov 2024 12:53:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D2191D5AA2;
	Tue,  5 Nov 2024 12:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ciQB2xAZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87831D54FE
	for <io-uring@vger.kernel.org>; Tue,  5 Nov 2024 12:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730811194; cv=none; b=gAIjTSwjAQKplppnin8OEI1CRmxHblgo4cp67Ds6tGzYRBBEH7oMpG5E/vwj62ZU72cRcMc4LC10IerZSezwhI7myajbSw2dcF/DJjkxsQ5sql+rUz/wcgrNFhbe+Y+QHlpgb05KkerbbBUhjTNGA9xdV/3AyYU0M57OTa1Vl7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730811194; c=relaxed/simple;
	bh=HfTXplarQOHy9YfWmWCfFXa/p0jmzVRpggtdp58QP7g=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=NeFa0/HgNyOUG2+SSFumQrH0B7yJ2E0n4OMRBVELedHVCq0Jif7QhdZ0sggJdoyK/1q575X5yP9Xu4R5MWwF8IYKEA38ElUMbxEu2sy9IZsr8KUZ7YbNuVbiybTLJ+2+gnq1kNWMSWCxVnIxvLvneFp0wux6S7/4NK5970Qp6ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ciQB2xAZ; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-20e576dbc42so56060795ad.0
        for <io-uring@vger.kernel.org>; Tue, 05 Nov 2024 04:53:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730811192; x=1731415992; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5BO5XX0R5eMaR+cACtZBYsHiyqQQsnCsIlJHaNsW+1s=;
        b=ciQB2xAZxDodmv/4zZRwOfpmpADtUd+3RuLOErSbKjwCStmm+vSUU3AHOd1OI3qXhl
         +bBNQPAfkurZTSEQYJqg51Z8p3inoeLkoDHKV8oHgmCOshHve8IW8wA/RxWpOU/pUr6M
         rmjI9Z0cxOnqLio4L6Hqff+zeK8prgUEjtmNKIIfMIvfKDUiGvAD4prLlfYC0kPp011g
         DnSSBZ7j88cvI2PQ8+4XwnNInxgi5xjnXKCCHTRXU9uWaJusDJLW/ToudO1kUxDu7vAn
         nhnQNFiicaf9xhTE1RVn8rBQOlaOfthvotEdE3pkSEiO0Al7CJV5FSpC+CIKgmjWsZH4
         Dzug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730811192; x=1731415992;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5BO5XX0R5eMaR+cACtZBYsHiyqQQsnCsIlJHaNsW+1s=;
        b=WHDyo7VX+SVFzpP3fqBrRPg+Wb1bcGdAuZ9zUFVwPEs7rvFJaw5a341cPDBWSRdbh+
         wafFgn0gWRG4U6Lc/uvT4Ek1M8lpGSq1QjGhXn+WNkUWWZeq6dJF6O2ArUbmmKrfarny
         MXnZBrdiLfNZk361fl5YeSM0EVUl6h3GimePFzCuhTTnftr7JAA5iJBLBCMCl6m6Xxfe
         3nMQaFvG9/IJ3F/t1BSF9ZdCpD6ViJloU8zH+RdjDeYwGyZg5J52q3z2VBO00d8gs+g7
         Vtx2Cygod3fCxlAzjToEEKznVI3nz1+Wop6hmHxXqZEpugZtGmJAcGTvKziGJV8UuhDj
         MRwQ==
X-Gm-Message-State: AOJu0YzlqTfV1PdfkLXMyHvrNvfqcZ7qaEvzcG6M1YEoGneAJBm+xbIU
	2rFR4w57f/iWGG0cR0UU4WlvcmXprsvTyGZbifQxu1zf17I53zS4S0c6/wSCw5UbLpejHrN1bYF
	fEJc=
X-Google-Smtp-Source: AGHT+IHW22lYbExBI32TkNRE38B8+QjxS3w5HIAZEw3M81HNS9P0ZL9SaBybKHsNgYQTFtUz1JvPgA==
X-Received: by 2002:a17:902:e890:b0:20c:e169:eb75 with SMTP id d9443c01a7336-21103abcfbbmr279296885ad.2.1730811191979;
        Tue, 05 Nov 2024 04:53:11 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211057c7560sm77321965ad.237.2024.11.05.04.53.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2024 04:53:11 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <d1cd472cec2230c66bd1c8d412a5833f0af75384.1730772720.git.asml.silence@gmail.com>
References: <d1cd472cec2230c66bd1c8d412a5833f0af75384.1730772720.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: avoid normal tw intermediate fallback
Message-Id: <173081119091.5378.7521271914967142535.b4-ty@kernel.dk>
Date: Tue, 05 Nov 2024 05:53:10 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2


On Tue, 05 Nov 2024 02:12:33 +0000, Pavel Begunkov wrote:
> When a DEFER_TASKRUN io_uring is terminating it requeues deferred task
> work items as normal tw, which can further fallback to kthread
> execution. Avoid this extra step and always push them to the fallback
> kthread.
> 
> 

Applied, thanks!

[1/1] io_uring: avoid normal tw intermediate fallback
      commit: 1e891bb8c4d0fe2d8c008d9d96d7e29d7f86f5e2

Best regards,
-- 
Jens Axboe




