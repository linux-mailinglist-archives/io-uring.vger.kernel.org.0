Return-Path: <io-uring+bounces-6357-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E0C2A32878
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 15:31:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1207E161455
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 14:31:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C166320B7FD;
	Wed, 12 Feb 2025 14:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hVm0cTpP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E03827180B
	for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 14:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739370689; cv=none; b=jCqbyO3ryPsQPF4RVLH+7SqwQ4Eu4aeA+E6Hs32bEmdSb2UaYvdOSbKpRRaEg/p/K2UvIMUwImJxhcQTFwCiE7h5+Ec7MjfPlTGFbFtfOBnE4Yxmep1gXmvDwtpzBqwvpwzJX3bEjSrts6/16EyYaKSC9KtBynSLe5rrTeUEPIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739370689; c=relaxed/simple;
	bh=IFGppnv/BECtol7fPY6PbjpaZumjbtFcVOwCxWiHoFI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FAH+N1VxiiIHrP7LhLGtsq3DP16P5bsHKnvol6iFryvLmxXyyMVKrFEMb28yXulg9FB7XRq9H9D/GkbRY6ScmwiBV3pTyamFEujCvHpXyOLYWbKdowEEJhbDwBalMVSAPxnmtvrGUyjlL0+V/UBknpd3CljJF9lL0QQdYfNraCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hVm0cTpP; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-8553108e7a2so225887939f.2
        for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 06:31:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739370685; x=1739975485; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SSD+RIEljsjrUQsTnK5CzvVwCDNNtPzzGRWNhLeXPkI=;
        b=hVm0cTpPXGKjiDbyULu2gpm0yon48MU5O+5cdJO3BAEIdWn/g3yDKy4TtUW/g825NH
         rPTfbbKGYZ4L9HVOSZfIbxT3hZEkyTF7j9SDXiHkQTSew/VYtUUDZTLym5a5tCLyZuWs
         KFnN9aHR0xd69FWzffi6fcD52RSTw347SaNMHbOzaVDSHoyzH+SLaWHRYDTorDnj5eIs
         OXa0LcAO528lcx3zM0amtUI5TvBmhnzlO/iyv99YbFjzqn/Eik1aZh215395R1P1Eofv
         QKAlBg4bq37aZgazxvEaL4ZxhNOM4SR6BjcekPL1D6FZENul1V1RrRUZwSYceS2Psd6e
         Tc6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739370685; x=1739975485;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SSD+RIEljsjrUQsTnK5CzvVwCDNNtPzzGRWNhLeXPkI=;
        b=WK7H9VeuoE6CdLSm9LyrPO0haamzsM+jsDOMUn2dwe7TbZbSRcLE+DGcUzRu4+Byex
         6guVCXt8Jq5pvRA17t4ijj4bkfkNhTYb0d8j2u27b1h6gS2h3bsJ0DYAErUIeI573Ft+
         VziH0G7FRCe3rBPP0usAjL/9AnBKyjRCUy6ClPoSbbBpLGcDEZSpvDGMVWwARGootkT4
         WwPW08OQXx/Rn9Wk6JwgRTH4VFKCzEYFkdGpzsb9+bPnyj9r+hnDjvu+zwJQyU2tdBGo
         yl3mzcoHvO13p2fE4LLB8iq450yYQ3kLMrEp+ubpRZgNNjlhfI03HCHxVYdJsYYG40bo
         TGFQ==
X-Forwarded-Encrypted: i=1; AJvYcCUX/RqXFILX9hQEmW075Oo9QSb7yMUFuLfDQqfBICIDVUJFSicInbAkodZIjPZe5GGC9LC8bz5b1g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyvp6aqUHx2kaorT54TfyscAoTJXxii7AkkhQvd4MFWJPQ703Xt
	LkPLLB/hkcC2/KKfk7e2BBSa2J8hcqKeKMZGLR+hLxmj0aV34Z100DHZVXEuQLc=
X-Gm-Gg: ASbGncszxoR2fwJkTl+G7wYROENzZGNG4sV1VmYmwm8sBN8hQCJU0IrIVxxGuoJPNNW
	7cMBWXgjCn17i8cbyAI4KZk9uy0hG3Aahc6R1xtQOYdmQzRaIfvr/vTCADRd+Rgc5ZKfqNh2mj5
	9SxXG7ywiTES2a3CC286lOB6UgGc9BYUPp9ela+nES6ydXUHqsuoKjtZyfc6+Qfbq/kcUUqUS2c
	Hc+xdfQFhFXF7m7cwCEnxJkamHtfbgQDCSdn31HmGan5CkbHeQi1bak4ctCqcUHu/Mx6lhjHGKn
	rT3aGC6WjbY=
X-Google-Smtp-Source: AGHT+IE/AELSIe24yEAhOTlct3331bLdFxOgsax4ZwnzPjlk8QO62qUa5CY6CtHd/UfCu1ybqqWTMA==
X-Received: by 2002:a05:6602:154a:b0:855:4e6c:e7cb with SMTP id ca18e2360f4ac-85555c8fcaamr325698139f.5.1739370685000;
        Wed, 12 Feb 2025 06:31:25 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ed203addeesm138899173.3.2025.02.12.06.31.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2025 06:31:24 -0800 (PST)
Message-ID: <5bab8ce8-a14b-4934-8a36-24b8366146b6@kernel.dk>
Date: Wed, 12 Feb 2025 07:31:23 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/waitid: don't abuse io_tw_state
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: Caleb Sander Mateos <csander@purestorage.com>
References: <9857d8768ee689f515c6f12b3ec5842c545c8959.1739367134.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <9857d8768ee689f515c6f12b3ec5842c545c8959.1739367134.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/12/25 6:33 AM, Pavel Begunkov wrote:
> struct io_tw_state is managed by core io_uring, and opcode handling code
> must never try to cheat and create their own instances, it's plain
> incorrect.
> 
> io_waitid_complete() attempts exactly that outside of the task work
> context, and even though the ring is locked, there would be no one to
> reap the requests from the defer completion list. It only works now
> because luckily it's called before io_uring_try_cancel_uring_cmd(),
> which flushes completions.

Applied, thanks.

-- 
Jens Axboe


