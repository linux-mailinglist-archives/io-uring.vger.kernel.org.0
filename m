Return-Path: <io-uring+bounces-7988-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6367AB9E20
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 16:04:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 939B83AFD15
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 14:04:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 883351A29A;
	Fri, 16 May 2025 14:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="zYHuYNix"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5046FC1D
	for <io-uring@vger.kernel.org>; Fri, 16 May 2025 14:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747404288; cv=none; b=NAIgiG1CL6pTDiRAlzZr4jyl5X0I+LE9x/vE/9gSQ8tulwmTjk26TXVfJfC8uC5IfWMLUMGDc1uQnKjXD4EbepQ3aSKROWDukOeRST6x17afT4UqgJKCcrrdMIika5mJM0PTmsU/7Ts//jP0c0Bw6EtCflmAefdLGqusqLYXRSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747404288; c=relaxed/simple;
	bh=M3zmC76ClxnzwAkF9MYCy10BBXh+eZlVQZ3NHB4c2I8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=b2ajbLFySAKcX9UsvcNGW8gmLnapyrIMiFo/F/UWL1tzYEVcBYmNWBGPVGd4SFf5gUCoHwsME3VgS+4DzGvHVSeGv3H+lNu4WhWk6KBKoVxK18F4lxL9mRMTmoiPUbLoyKgFkh6K+qoXB+ZfhCg/Er1gFw0PxL/keBcSBWjF4A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=zYHuYNix; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3db6cda65efso11257985ab.1
        for <io-uring@vger.kernel.org>; Fri, 16 May 2025 07:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747404284; x=1748009084; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NC+YoAfFScARNlAWt5LjiPnBvecoahJqpxajqfWZECE=;
        b=zYHuYNix9cFXykSNZGr8fuKVgOn3wCCV2Qxc+W+Tr4hPohMTYlEYwWHvuzJHYvjAl8
         nQsZPE4db6Q5LbLImAe5SklQPTT/dixb/rqURJY0cudYOSdXh2HNPsiTkp35TKE9i+d2
         4M7fRVZK1k01WnyAd9zUZqzXEnYbCohVJQpTD0AXR8R8uyZoIcBs7yeyPoqXxvzQLIqh
         bNrt8E3nu+vYr/JqnU+xlWN+bBk9d7cG7zQwO7uHinWafTlTlaoiv74B6CDpiUH9d39d
         wvIfqzxAFug168I0bfRtOX5V5vKwZdECjaU6YNQDUzmhKzdzD46rjQBlREErIms3EZ2L
         nNkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747404284; x=1748009084;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NC+YoAfFScARNlAWt5LjiPnBvecoahJqpxajqfWZECE=;
        b=gE4bKOPJDYdG+mGYIagL65wh9oNPQGc034b0h+fLTYUYVvObyyCSnKl1f5U4l2HWpI
         RUFmLaFLnawnELN6fdbAltKfVJuWMhjCN58IkD+RCKIw6H25wbcuwG36dEOKDhN/nUC/
         BfMKLg9fYOZ2GddKOtJLV5whnTlzxNMtdvRZYG98RiGdq6MEeJMr0Or0eIz9axAaUd6z
         EFwUOfsSF4UyxD+gZHQedPf7HUXnUNYZlUmzTypt3kVsvCBDLkQD6QSg3GkptduEqC62
         h8Y9FWA0YLnxXLvegdOpuMOAp2+gh9bry09xMtQJG6k4LxXduHdFeRSR9jCOqtAs/8BJ
         ifzw==
X-Forwarded-Encrypted: i=1; AJvYcCWzRMuSCeXCFEauTcPFP8kbl3zT3PLolEoQlCwUgemjci8WDia60T9deHNorMqiTq67Ldf9JJxMSA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwhQcJ10QZoVYraZ4J8oI4f99S0t7jOP0KKZvCwfErm/Z80Hzf7
	IgxauLKBFpWrRzfT2ugp9r4tuH5uM7pT4A754fSO49pF2PUbS3yjZydxAFvYWAZCGmQ=
X-Gm-Gg: ASbGncsIGyDxGJWnTiZ+eSTyoSUTFUhoWayfJq3xfp+FIu4RMcMYTmzT3qUDiaov6OB
	/i8kMeHYqToAsLGQpMJWTFdDbvJ913ETE6a3kXQMZ6U4DvUh03XaFY0ddkEvnV1dho+0RSQzNP2
	AFofmZZUTWKHrLuUPUTlAVci7f6HhiC6I24+6OqosDuEd0IMF9CB8sHNC4TCqIx1LoLRoYFz8t+
	y++bg8t/QxCNCpjfRZF2I0h3jvxg4D2mk6eZgQOkT8WZbeirhhK/dG/qSQMRkzfogoWsAMXK3F4
	PI4/Lz1JZu53zS9BZEKiNuOs1HMDP9q3ilCeG/zswAmyHHw=
X-Google-Smtp-Source: AGHT+IFzbHlMije369co62TJykOZIAmQiwmQqgBANUZkq9ryyEZnRfDxRHf/xkhvadquA9wQ2iXEJw==
X-Received: by 2002:a05:6e02:1848:b0:3d6:d838:8b93 with SMTP id e9e14a558f8ab-3db848d9c8emr35340205ab.7.1747404283773;
        Fri, 16 May 2025 07:04:43 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3db8443a3a1sm4956265ab.58.2025.05.16.07.04.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 May 2025 07:04:43 -0700 (PDT)
Message-ID: <c5f3ce6e-271e-43fd-9628-0a1a858a628c@kernel.dk>
Date: Fri, 16 May 2025 08:04:42 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v2] register: Remove deprecated
 io_uring_cqwait_reg_arg
To: Haiyue Wang <haiyuewa@163.com>, io-uring@vger.kernel.org
References: <20250516091040.32374-1-haiyuewa@163.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250516091040.32374-1-haiyuewa@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/16/25 3:09 AM, Haiyue Wang wrote:
> The opcode IORING_REGISTER_CQWAIT_REG and its argument io_uring_cqwait_reg_arg
> have been removed by [1] and [2].
> 
> And a more generic opcode IORING_REGISTER_MEM_REGION has been introduced by [3]
> since Linux 6.13.

It's a shame to remove this (though of course it needs to go) and not
add the MEM_REGION replacement instead. Any interest in adding those
parts?

-- 
Jens Axboe


