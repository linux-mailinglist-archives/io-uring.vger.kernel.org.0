Return-Path: <io-uring+bounces-3207-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CDD797A313
	for <lists+io-uring@lfdr.de>; Mon, 16 Sep 2024 15:49:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF32F1F22EC5
	for <lists+io-uring@lfdr.de>; Mon, 16 Sep 2024 13:49:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D255155A59;
	Mon, 16 Sep 2024 13:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="JkHk4k8Z"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFAB414A60C
	for <io-uring@vger.kernel.org>; Mon, 16 Sep 2024 13:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726494590; cv=none; b=YzQ/r47EXWCITwg41xaTf6ORwMkmh4JRtvrOgJN/4UW2qr312kGCeBcLRsXRnvMfThfeCHf7IDNtDfEG6lIzGeUxZsB1VTmcpIDfpSGldk0lbd5yBYGDYr4tOxrxna05A7Z1Tq70d20oQzgroGDkUUCP3g3h9m7APU4Mfxi9TCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726494590; c=relaxed/simple;
	bh=mTYLlhgJFyLCJFiquQhXbDJFC9KNkU16Jqo0fhCn7Mk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=aDCgt34Ur2KSg7VnYvBsjZPxdf1H/TGxGY54iAfBVFGHdbK1FgUUNtlv8uy9tvLX8sYNXNC6RXRghCQLPLUX8W39pWfwCxB4CNoCa11DH++EE5usXvnpVzuCBsgA1icFlQnKuRlL0J26Bf3sKY79CRAUBM6KBx4rL+9lRdovCFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=JkHk4k8Z; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-42cc43454d5so26633885e9.3
        for <io-uring@vger.kernel.org>; Mon, 16 Sep 2024 06:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726494586; x=1727099386; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NhrGkzepf/7gkzfLnNo1SUYJoz3hCDltEutlMFgBtEY=;
        b=JkHk4k8Z5Kwht73EaZOwmRiD4q1lZhFTaon+lgrc+irA92oS2AgclFY7TQIrBMqivh
         DRQKLSxmJ+FmX0x66KmjZ+VPfVPaSAlYxzk1KlQgXEj4+W/zyPGiHXnwRl6t4OtA0Bke
         LzBiTGELaUB2Ujmuf4dPg0K/v3+RyidiuXry9qQwvWWkZ4PRB8f5zZTaNWPSJX9x4117
         xTS6L23anWzNZmpDb5D4yaTU5jzdW5AZLrKdOYs4Sxi3cynnpkrWzKZWcqjLCc8lSiaW
         34tmv8y1FG/CsP3wOwU/bMyOJ7a/mKPcjzTxBzDB19IzwNcWySFtptsJ4eI/QHJ4O691
         TMtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726494586; x=1727099386;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NhrGkzepf/7gkzfLnNo1SUYJoz3hCDltEutlMFgBtEY=;
        b=jf7EdQ6ZiDoQAGQvcfa1ar7khVrlq/uA5DObMJDc93dMOS3TNA9G4BB1lPmMiKsA1u
         JEiWw4mSezjipuZC9zfyAByp+42ljo5TySVIlY3wZsoB/XBSLBi0NIxcKbexlGeHvOM0
         LlAg1nYs5DQoOBJifAaZi0Lx66PMCXy8zwfDimi6pKKU8gkbVXIga8X9U7jvbSDzMtEo
         Gfdxnj7N/dTKiDsHacm7riQPDcj31vGWZ1H7C+2dSfDOKxZQ4dd7w9gLRpvbiwlFwHHS
         FD5/jzoBtmMIaRpt9S+hEJ/Ft4lHmzSgeBitaH3pGUv14TwdUuM0IaNqDlmfxDAkqNcU
         Zi8Q==
X-Gm-Message-State: AOJu0YyzSIj8u4CKgjwdArmOnKmEfJ381Vk3O5tQucL5BRL6srmdbycc
	GvEPuDBz5FNhGTBRR9uUOniNyCBrq7Rg8OdSTzJqAbNZN9QR2IWr8g4rOQx5tRo=
X-Google-Smtp-Source: AGHT+IEFd+n3pMJxR417Q9zcx0oWXZFwDVePmgPghEM7qSB/XlIsd7vjIXUULvkasjnBv/6HrG/WoQ==
X-Received: by 2002:adf:ea46:0:b0:374:c712:507a with SMTP id ffacd0b85a97d-378d61f125fmr5809960f8f.32.1726494585856;
        Mon, 16 Sep 2024 06:49:45 -0700 (PDT)
Received: from [127.0.0.1] ([194.2.69.69])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-378e73e85ccsm7266248f8f.42.2024.09.16.06.49.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2024 06:49:45 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Felix Moessbauer <felix.moessbauer@siemens.com>
Cc: io-uring <io-uring@vger.kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20240916111150.1266191-1-felix.moessbauer@siemens.com>
References: <20240916111150.1266191-1-felix.moessbauer@siemens.com>
Subject: Re: [PATCH v3 1/1] io_uring/sqpoll: do not put cpumask on stack
Message-Id: <172649458122.10114.15596316527978537875.b4-ty@kernel.dk>
Date: Mon, 16 Sep 2024 07:49:41 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.1


On Mon, 16 Sep 2024 13:11:50 +0200, Felix Moessbauer wrote:
> Putting the cpumask on the stack is deprecated for a long time (since
> 2d3854a37e8), as these can be big. Given that, change the on-stack
> allocation of allowed_mask to be dynamically allocated.
> 
> 

Applied, thanks!

[1/1] io_uring/sqpoll: do not put cpumask on stack
      commit: 7f44beadcc11adb98220556d2ddbe9c97aa6d42d

Best regards,
-- 
Jens Axboe




