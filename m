Return-Path: <io-uring+bounces-1015-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 712D587DA40
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 14:13:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB96F281FFA
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 13:13:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8E8511CAB;
	Sat, 16 Mar 2024 13:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SYsqsXQn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103FA17BAB
	for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 13:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710594799; cv=none; b=lQqCuu4nx3FlTtM5H+87CTdNArlWI4j9+mTPtkRIWXiNwoUcv8/BLq0ZBN5bCaO41ivT/xVqJx1qVDWngHxt8wdiQMUdF8/g3B+ahFypusXVcBbmk2abhhlMu+qecTeYaxF/+ZqbMfUSXS/wcpVZcuYsqG/FzNS6NL5UI5LZBtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710594799; c=relaxed/simple;
	bh=9IKAL9O5Kzhj2bWwcxxcLVVHc+FpAsBJbr8QW4g4aUo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=BRinNKJvKr9oGSIXU2ibATZtRMw5ddJJRHbMJjA7H/WvcndH162rdgISJORoVLCbq/d+iDTd8TA8SKsi2uesMzqEEw83h5HiGqUE+Xut///SOARzoBK6RylpfptufQ2tnf2JQ77ce+xmTYYz9BPDhd2lhRco6/z1Iso7nGLnRl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SYsqsXQn; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-29f66c9ffa5so61614a91.0
        for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 06:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710594797; x=1711199597; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=021yMPdarsacqdEo/8CW8u8ZNpKM/XY65JYdTMbED3E=;
        b=SYsqsXQnyxjI5FaI3H4Ei4p6f2DHpFTCq5uuHn5HoBMxAcHa1Ne/EGuJ1XCJ4+vd3N
         fAklUSYbVg35/Fu/BBAmwHljfq8ZmkfGsWafhadRsKAI49w+ZFhICHsu9wCQerJjjUel
         NgCWeZvGoqiSCULURemeyQWNxMu0j92CAf69y9Iz8IeLKyYySp8uDwgwY6Frj3CQmiic
         8B24sngWY5HHIDVOhRX9h+BbS7LlOjkP6WtSIYUsxsZIA9JJpGu1y8qMzqI2bV7jraSe
         XwVRLJCKdlV5jnzCXWJlK3vj6+cW/Oj69NG92cn6S2Ojtnk+sFmOK8aMnA04ACAuF17G
         +83w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710594797; x=1711199597;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=021yMPdarsacqdEo/8CW8u8ZNpKM/XY65JYdTMbED3E=;
        b=L0rZAxS+oeSi2EOxMvLsRNxDy6LIPw4wCbPnpzv3kcg0egiNatWzQzr/7oYdN4SbT1
         M+tYB8wQ5OPPIzpcGe6TUc89LU9lHiQYZErnaJOm+5TFffjDovtS4LTvBOoj4Ax3t2xT
         7OMTPhnwiEG++wNm7XjyQiBsRp+KYWM5uj+ojk+sqazeIRYMOlpW1dT2R5+JVAfBHS8u
         1ozbpYInxTbjJb6Bq5aJyiDrSnJ8IX8etlED/6m/fU1QHgqLExrSgtvrY31sNbWpbr2T
         CbHNI7NL28Pw7VLGpEqT8TocsBVGhS/QlVkAvuq0k4bfTV5H90GuxBauHCMr6UgY5X6P
         4PQg==
X-Forwarded-Encrypted: i=1; AJvYcCUIBcpPQYOFayy4tSqCV8iCYDdsfoLGC9qEeOXY3PJfgPrHsNvGa06DjVLQXU624fnh5POzeRagKsi/1lJHafh900bU0fjh0Lc=
X-Gm-Message-State: AOJu0YzZIZZzAUKmjdBHJlgXWFO9Bkrire57PfZI4M4v8cv4uI56LCE9
	wz9BT2JGOF1I1V0jyhHF+l5V6f4HDTa21tV2mRu5dGu6+d97cbCJXrlN2Bx1KZo=
X-Google-Smtp-Source: AGHT+IGEB06ioccjFGEijllB1TxsKceBi0Cg4zSrV2NbWYgWBhNn0T9hLjMGz7iRHDJPhTfSg7DauA==
X-Received: by 2002:a17:902:e810:b0:1dd:667f:bf1b with SMTP id u16-20020a170902e81000b001dd667fbf1bmr8749305plg.0.1710594797320;
        Sat, 16 Mar 2024 06:13:17 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id i17-20020a170902c95100b001dd59b54f9fsm77566pla.136.2024.03.16.06.13.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Mar 2024 06:13:16 -0700 (PDT)
Message-ID: <dc93c896-19f9-4b6b-aabd-742cc8afae84@kernel.dk>
Date: Sat, 16 Mar 2024 07:13:15 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] KMSAN: uninit-value in io_sendrecv_fail
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
To: syzbot <syzbot+f8e9a371388aa62ecab4@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000024b0820613ba8647@google.com>
 <b090c928-6c42-4735-9758-e8a137832607@kernel.dk>
In-Reply-To: <b090c928-6c42-4735-9758-e8a137832607@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz test: git://git.kernel.dk/linux.git io_uring-6.9

-- 
Jens Axboe


