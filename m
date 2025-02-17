Return-Path: <io-uring+bounces-6487-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DD2D0A38557
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2025 15:04:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC3861892657
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2025 14:04:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A675B21E082;
	Mon, 17 Feb 2025 14:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lKr6pGeD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C4921CC7E
	for <io-uring@vger.kernel.org>; Mon, 17 Feb 2025 14:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739800999; cv=none; b=KEXX59f0tzOW27YFdBImuCBYQluP8523CSBXbBN30ju4nFU8x+mHa5O6v9ihsMzvRpMxQsRahzrG3G3tO2N/crYT1UCYpPgwY0SnkoYqiES5oZXKDTf3xZ0V5xoPRMfeXlBR16SQfGlLp9wN5z3pt/7fWgD5MBvTlivDeHWg+vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739800999; c=relaxed/simple;
	bh=RN8ezk+1S0zhWyt3T/rUa0uevT5meb39MNUDkaq2wKM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=SlnnyF/t322E0uq2aWOX7v6KKeO23BSyloLnEMdZQpVXRC1VIxF+a6RwQTyanYWUnxAagm0PkqVFrzA8zHaH6W+akd8y9gvjNqPGqOXD4eYgQN+WRfAcMgTC07r3wZ4v/c+9o1j3jGNqBUuisDKcKyesCY/xotVN9R8ggt4++TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lKr6pGeD; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-43932b9b09aso47769155e9.3
        for <io-uring@vger.kernel.org>; Mon, 17 Feb 2025 06:03:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739800996; x=1740405796; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sQS45aLTVazmAuV7MTcTjWHLjPQyKJQ7MkbUXFxL0Xc=;
        b=lKr6pGeDbR2UadRa7E+LjE78vwzOlz+0f3lpLN/Y1onh67DamG0e47YGaMIU+eTQfn
         2Uj7YQtk20oXoAZf8YBswYfo8VVlvqNW4K964iSQMUzntT5fM+Yk3/bLUxw0DG5nnZRC
         +l+oq30Je4QQ2XZI0MdK68jrOxuOctxYjY61WYsLKdNvVmIc35IpLStcoYkS5s2v4ccT
         ruNoJcvJ106e7CAEGAwd7oobRfHUmd9zkoRNdbMOQsoWpFXaBcshUjYdfgq+8byL4T3g
         ghtDng86HIKPgW+grvKs0tVkxhz0kPaXlWSYg+4gVVVngrUU2Ckmm6bX2nc8h07ezKTF
         SJNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739800996; x=1740405796;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sQS45aLTVazmAuV7MTcTjWHLjPQyKJQ7MkbUXFxL0Xc=;
        b=GlvpkPMZGUOmv9wx8+fHykHjbQJElnHstpOIV3x7TRQuAvfnLFvbPDrdGmIZoLN8Un
         aNWbsZWk0xjcI2M7J0eSugC4iC1Hwef/vPqUCE2cfonoCYPIE4In88tBHvOPN1x5fF+n
         XZLlcrbMKZniZi5YP4buShVUbAbjj0RahtUK91T2YhcICxkmfYPnrxSZR58bZCMtAP/P
         VlbFZMTkaXx/v+klutuD3PAuqdk2W0IvkreCr6eYAa60MtR+AJaHBlBcs3/znz+R5IQK
         HXOL5tA/55NH+nfGiFVEpE8k6o6aulFMOycDx0APH+oKBBEYxygPLC+Y68ZJCdqmEZ5H
         pMfQ==
X-Forwarded-Encrypted: i=1; AJvYcCUmTGFTebTfJiA5NDxJgXrpSc78UiuyaJ3z/u0tvTSaD4UuUqpzw9IijI2Ns8ShZlH/DjDr0SufSg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzvuywVZ3hnqdBMcJcCoPKPQtrxMHrEmUo6/uc4HcAWE7PKefxw
	EQlYUgNn7/vyD98SnSIROiePu4pqyV+DMuLlHlw+WrAfiX127dQlwFrYoA==
X-Gm-Gg: ASbGnct9PsHyGZL+3DwtRzp7ktxN1x4xHsH1oyq7pGmdEQwFHawH250KA7Jz5p3bulK
	xxXb8g9V3Ctv9kflzs7CjiQZWzI+kHRvX5FQ2mWHf99Jhlupg0EL28o2ctHrI4utqd6Z6fAcAlX
	+1EglR6F5SWoiacajBemageo2kVQwy2MC+lZ8NvaItwk88XXUeFK+hjkoCFni2FviqjW3iZKx8z
	02WpJxWNyGAXyQNpOMPsgh4ejG1+3aCqQwBan0xm79sqJ/ivSRL3GYqX0Lj8bVp9/fZBcD/wYGs
	1bXpJrhnzcUCrPh7boOO7q0G
X-Google-Smtp-Source: AGHT+IHDKc/86LD+B/kWWRAqbiK0C9oh2QkLCuO9PgfYJoqqLerxXC0h5IAWo7gIZRpoz0sSBsfcEw==
X-Received: by 2002:a05:600c:511f:b0:439:43b1:e60 with SMTP id 5b1f17b1804b1-4396e6df40amr94728125e9.17.1739800995902;
        Mon, 17 Feb 2025 06:03:15 -0800 (PST)
Received: from [192.168.8.100] ([185.69.145.170])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4395a04f22fsm152697555e9.5.2025.02.17.06.03.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2025 06:03:15 -0800 (PST)
Message-ID: <8fd28516-9a7f-4870-aad1-811547ea9101@gmail.com>
Date: Mon, 17 Feb 2025 14:04:10 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/rw: forbid multishot async reads
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <49f065f7b88b7a67190ce65919e7c93c04b3a74b.1739799395.git.asml.silence@gmail.com>
 <cd42f912-df8a-4c9d-a891-1c127f6b6fa0@kernel.dk>
 <c4f31fa4-25b8-4efb-80ef-3ffe85c4c421@gmail.com>
Content-Language: en-US
In-Reply-To: <c4f31fa4-25b8-4efb-80ef-3ffe85c4c421@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/17/25 14:03, Pavel Begunkov wrote:
> On 2/17/25 13:58, Jens Axboe wrote:
>> On 2/17/25 6:37 AM, Pavel Begunkov wrote:
>>> At the moment we can't sanely handle queuing an async request from a
>>> multishot context, so disable them. It shouldn't matter as pollable
>>> files / socekts don't normally do async.
>>
>> Having something pollable that can return -EIOCBQUEUED is odd, but
>> that's just a side comment.
> 
> [off list]
> 
> It is, but in short alg sockets do that. See
> struct msghdr::msg_iocb

Well, not really off list, but doesn't matter

-- 
Pavel Begunkov


