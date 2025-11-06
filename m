Return-Path: <io-uring+bounces-10395-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B8A86C3A817
	for <lists+io-uring@lfdr.de>; Thu, 06 Nov 2025 12:18:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D1031A41558
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 11:19:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A421B30DD29;
	Thu,  6 Nov 2025 11:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FQBvXb0j"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEEA030E0C2
	for <io-uring@vger.kernel.org>; Thu,  6 Nov 2025 11:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762427909; cv=none; b=ak3x0EUIm2vo94Hs4i5750OKJMWPlJZES1EY64BPCjTgxdVycqLMHyN0CzWU30U2vqQFOmxqygov1UuYVv/BXqEdBVsm/2IrA0MBg6x3XHZ27P1tDdX0zQo9seqNtEC3oQsEpa5L0WC1dFEdA/GAmj90EUqCHDa78Z5bNrbmn+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762427909; c=relaxed/simple;
	bh=q9qP6rinajMx7rtOD8a1zMyKxHJNeqzScHocjyeWyek=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=umA5h3dpvnzSCYZdrBMYHhTdtDcwWdxSM60GIfNaMmLrcFqy7ruHC2/NspUDkFrBxGhsa9yGkf2v9xrSlCgcOgPTvDpBBDD4vGdGX79xoCT0zPNv7hl/dDKYVAYCq549KhufeOOeILoDlQgRFs1rJoIfxL4a7pXkzVjfPtWzKCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FQBvXb0j; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-477563e28a3so6784085e9.1
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 03:18:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762427906; x=1763032706; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0/rBOe1zXcqjIALzT6F72Jxuxm+SnLT+ei/iO9Tb6QA=;
        b=FQBvXb0jKOn03KiimnTJ8W6jcsm4iHvBqAW1xoFSsvySbC6ppWVRSMPQIRUr9G0pXT
         aQAp1x++Rv7CaTG8+VoqDJ+gamd2wTOnRMhJ+BA/JrNaqGhwrnbS8MeG3KQnB6jw5zrX
         MPrjwOIbYKggtaW0TRTEY4g9uwBYQ19Nm1GA02BZIROx/hSGE9r7uk7WM5NeHz7q4Ntc
         OFlvRHhOpWaw8hykoVXI6gw5DLnuoYm0uY9+dU6iX9lOyfWV/GIMAxyJYVe+Cpjea7zJ
         oMaUZySHhj+QUpBl5DEYR9FN5uplXAmBPSOuwEoCpQBSqKSZ8R6JBro6WgmG77lqrcWN
         t98g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762427906; x=1763032706;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0/rBOe1zXcqjIALzT6F72Jxuxm+SnLT+ei/iO9Tb6QA=;
        b=hk09AIMA8CsRCgrbIRTNnk6oXzWTF1Gr9HUchWwLy4mKsbsb8LrwYqlvLJb09SQPqt
         pKwkxq23DMgK/D1K2+O91It5Z3Qf6vv9CZVhxr3gWp+nHesRiCcrjPKo7UPXo3k+XoV5
         Qy1knMMpPmQ8bny+uODqMErcf6Pq2TJMoltCN8DE128tXyGrZxX03QEIc8UQUxzWN1oI
         b0ESmLlcDNr64ZLH0D0mXRfJee4A6tIiLpuyyaIv6U/kH5mJqUHH1BVVJuiShuUUU+X7
         lDQClNZejYjR+U7sLijYxa0oFfHc1Qt7bV44iKivnNmwfi/D7IS5md0AKUSttgYY9dXv
         C/iA==
X-Forwarded-Encrypted: i=1; AJvYcCW+Q9iQ7gxm5ZohfUJv1wpGvvTOxUTARKF7i3kdoBBAYx9hxjRSOnd6U4eFEQ9tvRJn25CYOI4+lw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwKTt1Qg+wjRsGhSm9slEsXwwmPTtD0w+oDehpnE5CuzwB/Cp22
	6q9NspbcRevl/t4ofIvXcvc2u9ZqXu2udLvYKyaNpGFyGcdrsRkKjKEKAaaNCA==
X-Gm-Gg: ASbGncuKHQ0z9HMq+bfHCTdTKRoXEI5L4xfTZSknLEohlWeVUUdE3sSpZIjyojcGchb
	PH4356ywJ7/vRD+wdKaKyndGdfFcxkp3kCRxk/qyirZdYeODL4KUa0uOoA7xFo0CbK9xYhmAtgt
	XbSuCBFZ3+XATzP3KfS7jARrCHcq2oOyfENoIoz9tRgEbzsIZpbHpN66oQ6SGgOI3xWC01nwDs7
	8WrGUzAF5CXTemJmn+vrAwzI3IuWD9s/9oCfonVaQDvxNsmpsZXRKxmiZvFDtdoYUX+JogOt+bv
	M59L7wtvSO3pWIrUEvehixpN1QMUZxgxm1bw5d/E5pvfeA6Z+u105qWVUOcTh2psqYNOnZMhGao
	mms4dQwn3co3ELHgb0VXIknxMpoCNlOC8DaICU8de1UEKMmOFfesOj0p4myNk+HaDn2yxcE0AfD
	gDzyrEb6YaD9NI5eCEAcTfTgZNhK9mzJQSeX8Vx0uZ8cCBLj7E8k8=
X-Google-Smtp-Source: AGHT+IH838wzTECzdx/Te5XL+1DFPqB1sYTzYK94ZHlQm4rCvG7UEgR+8sLaS7ijKZwBzyxRnmSMYg==
X-Received: by 2002:a05:600c:a108:b0:475:d278:1ab8 with SMTP id 5b1f17b1804b1-47761ffd211mr24852765e9.2.1762427905771;
        Thu, 06 Nov 2025 03:18:25 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477632bda1asm36383835e9.3.2025.11.06.03.18.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Nov 2025 03:18:25 -0800 (PST)
Message-ID: <e49d76a4-9f61-43fc-826a-2a5b452d3149@gmail.com>
Date: Thu, 6 Nov 2025 11:18:23 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 4/7] io_uring/zcrx: add io_zcrx_ifq arg to
 io_zcrx_free_area()
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
References: <20251104224458.1683606-1-dw@davidwei.uk>
 <20251104224458.1683606-5-dw@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20251104224458.1683606-5-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/25 22:44, David Wei wrote:
> Add io_zcrx_ifq arg to io_zcrx_free_area(). A QOL change to reduce line
> widths.

Not sure it makes any difference but doesn't hurt either, so

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov


