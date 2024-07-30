Return-Path: <io-uring+bounces-2602-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 810869411D9
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 14:27:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B72B1F24B5E
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 12:27:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DF6119EEB6;
	Tue, 30 Jul 2024 12:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="uc6ZxWMj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985E819E836
	for <io-uring@vger.kernel.org>; Tue, 30 Jul 2024 12:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722342400; cv=none; b=B/fmvo2REp7jMcR+96LaO1AGopqjkKCwW4nIbtZebQ3c1NWowNli/vPhyeEzW0af0XYGgehCp5w8YJdZtByuS5/XJNiCZSDynYKii972KAea0kXT7G+7FB4LXgiiOaMCuGcFQdoxlHj0oicRMh8EOYg7Ol3M1PSQYuJvDe0ju0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722342400; c=relaxed/simple;
	bh=vOE2WRXETz8HcUiiH93pi46hhnrkL0woZEXP6L4C5tI=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=TKg0Qn9kzQsF8S+X4kTMXva0jyNsQpw+9zCQ/rkCg5ezLKFAQfRpWC4BvKjPERbzpzoouOkY5CEl7yTtYuvi1mwI0naF/kiEPhZ/EhuF6TTqSGcg9076fQtsxNia0rWRj4z8Xe1MdtHLZKvb7wKh1hNBHpjKkWwIwtGaFR+eBmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=uc6ZxWMj; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1fc57d0f15aso2031625ad.2
        for <io-uring@vger.kernel.org>; Tue, 30 Jul 2024 05:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1722342396; x=1722947196; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vVvLRDkkBY7qvx2y1vXM3ozVPai6knp3uT3KZkEBOS8=;
        b=uc6ZxWMj0RF4dvIYLTIXykOMViFzPZ+qI/UD9x/YT08dbls7z6EkaKs29uKzt+NeGV
         C4UkziUMCgydFSZb23uSmh2nJGNzcAMqRZoMaa9mCUNJgTV6XHlGjmNjNzTGoZRwnzDc
         MKaqYmz/f/49cSiRet86+qMRpLuvX/tO0UHNRu7ZHnHSo8QHOaWBYQATT0tqybC23p3o
         JXyY7qVn2ZMNuE1FMeW54FhrqLR8PHHFX+BB8Z/toYzLPwJazpWt25GtZfN1n8SQfFiX
         sEX9aCQNcd5TtGDlREZkFSVgYhr6Km9zeMmpPjHIZ691TVoOPPWABytNcm3eTQaIYVXQ
         Hjfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722342396; x=1722947196;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vVvLRDkkBY7qvx2y1vXM3ozVPai6knp3uT3KZkEBOS8=;
        b=ExZtvhs8Q3wm6C5OlsKoYdhPdE+5ogrozXG/MDL2yUIVSpuWBCkXUXFEDqN+d/VmeX
         6eWr8WMqtSYaktN8O7lh+O9DqFBNkbPhDJYKPdIP3/A/MQJbDuwbCw8RAPnj6bmnQYRL
         T2j6vwJRyYynKK123thr+UdRCLNMRroWzu1pg8biRvLGr1ujtuIwRq4WK3wuiLXX79Lj
         KhssVgRYF3jtsX8lJyhfWDAsmDxcCRzweKKrOqZlD4xhQEoF5Mf/wUOiqlVDfmzVXvHU
         hCB/FRPWvNhH+0idgCXRcCM0UPa4P6Fr5UsESThZlV7nCYe82TBlWqLtxD4RnF2emDtS
         1zWQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDDQhzMogRl5XBr5KhAI+oQH6VgGSo1Buj9uFs0bGWKbpB40kqUSeI6ONMce08baC8g6uN+LNtVOPX+zFBjE3ahILD1DC0UzY=
X-Gm-Message-State: AOJu0Ywou5iM6ciMILoda+jfiXuRlkYPDjuUmGHUcd1D3pj39VMHQAWG
	fpt3QjEa1KgMu1gCY+/yjW1bwF+FntUPzUlh9sp69tPFXw2BkRalcW/8DObXjvAitkndThUIPcl
	q
X-Google-Smtp-Source: AGHT+IGIRIIaOWXOzoR5/vqQeMtsh0cj8EgXJjta2OJ4SG3IZEL4rQ0u/g7ZP613f9JFqCZK9SK7Dw==
X-Received: by 2002:a17:902:be06:b0:1f9:b19b:4255 with SMTP id d9443c01a7336-1fed6c1b174mr117521985ad.4.1722342396493;
        Tue, 30 Jul 2024 05:26:36 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fed7fc5e81sm100568405ad.278.2024.07.30.05.26.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jul 2024 05:26:35 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, 
 Olivier Langlois <olivier@trillion01.com>
In-Reply-To: <bb184f8b62703ddd3e6e19eae7ab6c67b97e1e10.1722293317.git.olivier@trillion01.com>
References: <bb184f8b62703ddd3e6e19eae7ab6c67b97e1e10.1722293317.git.olivier@trillion01.com>
Subject: Re: [PATCH] io_uring: add napi busy settings to the fdinfo output
Message-Id: <172234239545.14309.16406517953911491916.b4-ty@kernel.dk>
Date: Tue, 30 Jul 2024 06:26:35 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.1


On Mon, 29 Jul 2024 18:38:33 -0400, Olivier Langlois wrote:
> this info may be useful when attempting to debug a problem
> involving a ring using the feature.
> 
> Here is an example of the output:
> ip-172-31-39-89 /proc/772/fdinfo # cat 14
> pos:	0
> flags:	02000002
> mnt_id:	16
> ino:	10243
> SqMask:	0xff
> SqHead:	633
> SqTail:	633
> CachedSqHead:	633
> CqMask:	0x3fff
> CqHead:	430250
> CqTail:	430250
> CachedCqTail:	430250
> SQEs:	0
> CQEs:	0
> SqThread:	885
> SqThreadCpu:	0
> SqTotalTime:	52793826
> SqWorkTime:	3590465
> UserFiles:	0
> UserBufs:	0
> PollList:
>   op=10, task_works=0
>   op=10, task_works=0
>   op=10, task_works=0
>   op=10, task_works=0
>   op=6, task_works=0
>   op=10, task_works=0
>   op=10, task_works=0
>   op=10, task_works=0
>   op=10, task_works=0
>   op=10, task_works=0
>   op=6, task_works=0
>   op=10, task_works=0
>   op=10, task_works=0
>   op=10, task_works=0
>   op=10, task_works=0
>   op=10, task_works=0
>   op=10, task_works=0
>   op=10, task_works=0
>   op=10, task_works=0
>   op=10, task_works=0
>   op=10, task_works=0
>   op=10, task_works=0
>   op=10, task_works=0
>   op=10, task_works=0
>   op=10, task_works=0
>   op=10, task_works=0
>   op=10, task_works=0
>   op=10, task_works=0
>   op=10, task_works=0
>   op=10, task_works=0
>   op=10, task_works=0
>   op=10, task_works=0
>   op=10, task_works=0
>   op=10, task_works=0
>   op=10, task_works=0
> CqOverflowList:
> NAPI:	enabled
> napi_busy_poll_to:	1
> napi_prefer_busy_poll:	true
> 
> [...]

Applied, thanks!

[1/1] io_uring: add napi busy settings to the fdinfo output
      commit: 0c87670003aabfdf8772e8ee19d8794adab9a7e7

Best regards,
-- 
Jens Axboe




