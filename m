Return-Path: <io-uring+bounces-2608-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BD118941585
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 17:38:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76ED92852CB
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 15:38:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 623BF18A92F;
	Tue, 30 Jul 2024 15:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lMTewmHH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF8C197A83
	for <io-uring@vger.kernel.org>; Tue, 30 Jul 2024 15:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722353909; cv=none; b=FC0GN2wIGbg35WO2PDayAkPFpuuzILgGFFvlQBXckSnV6avZTVdcKmHZSud9t1PHsU/mh9OUTdiUWU+A5pmX336s9FaaHfNtb6vyoP7mgEB8iTiHYEm0qPsS9a08rcCJXxamqZQ11lUzWwdaW3GRMIPrDg11GKUT/nzhymXJs9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722353909; c=relaxed/simple;
	bh=hfBm1VKDBt7MLPeqQQ+t6UDwPR/z3SUbOYdMHycjSCs=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:Cc:
	 In-Reply-To:Content-Type; b=bFqCX9Nyigb7GzgxWHpnF059pgi3FL6XJo5w4VikIwSk+WqPtDrmBZosleU4G0H93WbSdAMoxHRsvgt0MMosUFl7pjGLTDwMIMzTlvDpEJR7MJyXMcbkV8EZHHt3Es8/Pci5oZ2nyarFAwHUsqiD4UH5Ae4yBTfOGsrKBs73AQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lMTewmHH; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5afd7a9660eso5305256a12.0
        for <io-uring@vger.kernel.org>; Tue, 30 Jul 2024 08:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722353905; x=1722958705; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:cc:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/zr7ltYVf01A8vRYA4CK0FcrKHV0xEPvML/dFhX98HM=;
        b=lMTewmHHu3fivs17H/P31Hfv2qxqnmfkCAgb0WJ+OmlDIOIXcZl1CXemzcosZXmVEe
         fB1PJpsxi3hAL7tjm9hQAEvQGW2HqNk//exnghX0SodWCE9GmrEStQrNFEtrgxyfD+hH
         WETO98pj7oyAPnatjBAX3tc3jTHLHECq2zvB0Zz9lSrnQnhwDJOzV+qT5VCZGgYTcAWZ
         73XdvWoo614MzvCQG2//Oqhfj63p+VAEeLTLZunZ53W1kM8wKpMazmggLL9DCQEwgEOk
         hDWJ8MkOfdt/w0poQZ0EPbF8++V4uO5CzPF6kM0Ov2Rc3YZXeCOyVE4Rs/gsgezbupZS
         ucXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722353905; x=1722958705;
        h=content-transfer-encoding:in-reply-to:cc:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/zr7ltYVf01A8vRYA4CK0FcrKHV0xEPvML/dFhX98HM=;
        b=WmKsYP4Y3dcPqcPMupPUiNVktZzc4gxfVKOpS9F2bqfRdSVdstRiGFzE5wByfKeDvU
         bV6c/vooQ3G3cYDXmw/gFnrf5+6mxYj5yWwpjJF7AfwH1sntbDm4Y7ApJeiXi4m1M+jk
         eJkytdKgJdDaVvq9/ac7KLAKm1A0vi24i5eyXU7zEAbvAnTTAjf11zWtph/4ArC1a+D8
         740RgN/xwEAzfrANZ1llgmA4LCc8RKiY+jyoBwoamRxNSCxkO9XVE/0sbRxLu07BdXTD
         jatUs+FOv4dUy/A9VXr248icWiMxY66aKQI/MTW+M0dwvx3vQPijXbfgd/fQRSoMj37V
         d+cw==
X-Forwarded-Encrypted: i=1; AJvYcCVJbkglTL0xlHhT28+Bbv+U5adyPpeE5zt9CrnrXVeTC3wafOtd+7D6OUN0mQVm+T9fGZgjpl2qOuRDZG2ZP4gTgeFTaGjmNBI=
X-Gm-Message-State: AOJu0YxUc7buS3C3ch5IzU2KpsvpCGa5qze2W2t0RzJVJtCUFiVLMVDf
	LB6X5FjfSBYo/N4fmryh8FwQFjcM5+DcxgjsXTmdg52V9qEfU3XT8Nym3g==
X-Google-Smtp-Source: AGHT+IGohi2PQBMog9Uy7C4q+Z0KrVFmjyJYfqw2yUBLYLvAfQQTiROXjN/Lh23vxSeq3ax8awnhqg==
X-Received: by 2002:a05:6402:4303:b0:5a2:8c11:7e05 with SMTP id 4fb4d7f45d1cf-5b020102e6emr8703441a12.6.1722353904729;
        Tue, 30 Jul 2024 08:38:24 -0700 (PDT)
Received: from [192.168.42.72] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5ac64eb3cb8sm7270283a12.77.2024.07.30.08.38.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jul 2024 08:38:24 -0700 (PDT)
Message-ID: <b77c6fe1-db33-4fd5-9f0b-67376f75dd54@gmail.com>
Date: Tue, 30 Jul 2024 16:38:53 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: add napi busy settings to the fdinfo output
From: Pavel Begunkov <asml.silence@gmail.com>
To: Olivier Langlois <olivier@trillion01.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
References: <bb184f8b62703ddd3e6e19eae7ab6c67b97e1e10.1722293317.git.olivier@trillion01.com>
 <08e5c092-a7c4-47ca-8e4b-44acb741d1f9@gmail.com>
Content-Language: en-US
Cc: Lewis Baker <lewissbaker@gmail.com>
In-Reply-To: <08e5c092-a7c4-47ca-8e4b-44acb741d1f9@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/24 16:33, Pavel Begunkov wrote:
> While on the topic of busy polling, there is a function
> io_napi_adjust_timeout(), it ensures that we don't busy poll for longer
> than the passed wait timeout.
> 
> Do you use it? I have some doubts in regards to its usefulness, and
> would prefer to try get rid of it if there are no users since it's a
> hustle.

And I need to ask Lewis (CC'ed) the same question (see above).
Looking at

commit 415ce0ea55c5a3afea501a773e002be9ed7149f5
Author: Jens Axboe <axboe@kernel.dk>
Date:   Mon Jun 3 13:56:53 2024 -0600

     io_uring/napi: fix timeout calculation

https://git.kernel.dk/cgit/linux-block/commit/?id=415ce0ea55c5a3afea501a773e002be9ed7149f5


It sounds like you might be using it.

-- 
Pavel Begunkov

