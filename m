Return-Path: <io-uring+bounces-10444-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 79B43C41510
	for <lists+io-uring@lfdr.de>; Fri, 07 Nov 2025 19:43:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 291EB1896C30
	for <lists+io-uring@lfdr.de>; Fri,  7 Nov 2025 18:44:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF1412E040D;
	Fri,  7 Nov 2025 18:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WdnVATAF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C11336ECC
	for <io-uring@vger.kernel.org>; Fri,  7 Nov 2025 18:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762541014; cv=none; b=XKBZhPvUhs9ddqbY5mwRXWmRT7pwo/hF8vP/QDKPUoAO4/qYpQB8vU12BULy9jUmEiAHaymToJk5h1NFYO/qVIr1XOqOZb4ipKLhjHURTGi1wzOMb/T2JJ3BWa4yctcsm/Y3gpawfzHWgCXLhZ3m+CLz9Jffnv8MLg2omAWFGL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762541014; c=relaxed/simple;
	bh=nQqsQbW8sLt9vzJIoWuSmQFusnTlWSbBn+vx1kiyri8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IBqj82UE27Xa3vmrx8kSgn14jrIkUp6/diyYJaaG5czZmcVzE/T43Lqv+GMdtO22EPSf2ee5nFlmbxol3nhRogJQKkPeObrF05NQjn2fjwisTWz2EIIEBbBHL9U4wQ0WUZ3IS/7qC1l+KO4gV7Ar9eqR4De7RLuumP0NQ4WZJ/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WdnVATAF; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-429c7e438a8so996229f8f.2
        for <io-uring@vger.kernel.org>; Fri, 07 Nov 2025 10:43:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762541011; x=1763145811; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9RVwz3sMbg+clsZmLZQo1Cmw25WzG+27GQr3DeSsuTk=;
        b=WdnVATAFASgS57Z1jJthIudXFvJ6+PYZlRMlk6yqV5CeNuqXna8X9rf6fagiTZFLe4
         FfyRpN/R7dsiGvlpmhCpkaf30sBmx1APAw80S+PUauqjsfSwssUaC0GRKLetDLqxaOJ2
         XXOaoVFltgYnuL8GESTSPu2mcx3ig4VzjGrla16mGnV92500Xu5vVfgAc21XUMd/sUm2
         5q1f2wFT45SN9y5NFTGJVsQ2q8OO4juJqeDT9YNWCJ5KfVCdl11kTnHMroU7SSoFdJqm
         E24rAq3sWNctSsht1NPN/tAWu/MA5ew/81voCQqnNktfT9dEgoRM58frVULvbwlgDhE4
         LM6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762541011; x=1763145811;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9RVwz3sMbg+clsZmLZQo1Cmw25WzG+27GQr3DeSsuTk=;
        b=b4K9bPm4iVGD5Af5rHyHv6nomTnsu+RCJjQw2ef/6VwGUfpa32FIOxi6XMSgl+Tar6
         YfZBukL+qasORYt0C6RC5fewjtFpGcZEluJdXT9K5MM3J6S87Li5YaOyPId0f5OP+PNf
         TU/eCKekSPavf3NzFR0Ut+QEjkE8za83S0nDZiv/F3XqTVfJUBnN+Y/kVsTVR3crRNhW
         m/PwUGBXjGdQMEXQ5zWzCR779r3rDHhsnW8Mx979hcnCqXfTfIBHLOy9jvE5yAfvb5X7
         m2JnJGlnsc7SyjbVr1zeZ31fiuAZN3pDwHWL5fQ4oMWl1vxZCmEt2suBAzD1DO17e7MI
         v/aQ==
X-Gm-Message-State: AOJu0YwIq56PvX41jhtgnujE1gTSDxglmRlo/REVLNYE8ZuwzAB5RgYl
	gf45h5rwjFrx5SGh3dOHkl6YgoONHVPi4E96k2KPelSV4UbNGoKkyclquoQY0w==
X-Gm-Gg: ASbGncuPJyGFg1iuZhqiRIFINcdfuXa7RwYD2pYpfG9z19ArJCZod4aTtU5kfHRWtW5
	jqL8Hk/5bg+PmPbip5gBg/DzyviqsjSbArvrfeg92goGUmtD0sTchPv2UMX1J5Z/TbK+F1YRvqY
	1NgCFpDaAgrx6RkOQkJaewfYq4s6PpO1yTt269X1id8mRDrmVZanSp/OGiqzXYDU+yD6SQdc8+i
	E3hAa0hxSzMX8dv4zvbDghdIEThpC6U8TU3Z7A+qhFcTHZeYDhR7cPixEG2+asqun9u3RYKKh9v
	qz5W2aRaz/svoIbVo67DEwRoGiM0C0aQESdayTWU7ldj/p/HecXZVxTq+BtK8J2AAVF0BARCgFE
	aPFb9aCFCxc7DoJmA5tjb8yo9eqhdPaiaJRJWleYXJFDFWPiRjcKwkA5vzKUrR6aOyphoDbO6TU
	3W9OOCGhkr7OoxjUV8mx7L3f8V0VUqKveMhtdtQPzDBFK+VE01Y8o=
X-Google-Smtp-Source: AGHT+IF1AHZXFN9Y1MfzvdpIxKrXqhPZ2v/vOFB0yL8t5f1MfQS0cppsiElePtxpKlpxlanF1UfCDA==
X-Received: by 2002:a05:6000:21c1:b0:42b:2c61:86f1 with SMTP id ffacd0b85a97d-42b2c6189d3mr345342f8f.35.1762541010947;
        Fri, 07 Nov 2025 10:43:30 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac675ca3csm6878761f8f.23.2025.11.07.10.43.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Nov 2025 10:43:30 -0800 (PST)
Message-ID: <3338436a-bd36-4acd-a6f5-afb3d741b2a3@gmail.com>
Date: Fri, 7 Nov 2025 18:43:28 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: regbuf vector size truncation
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk,
 Google Big Sleep <big-sleep-vuln-reports+bigsleep-458654612@google.com>
References: <11fbc25aecfd5dcb722a757dfe5d3f676391c955.1762540764.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <11fbc25aecfd5dcb722a757dfe5d3f676391c955.1762540764.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/7/25 18:41, Pavel Begunkov wrote:

Should be "_fix_ regbuf vector size truncation" in the subject,
but I guess it doesn't matter.

> There is a report of io_estimate_bvec_size() truncating the calculated
> number of segments that leads to corruption issues. Check it doesn't
> overflow "int"s used later. Rough but simple, can be improved on top.
> 
> Cc: stable@vger.kernel.org
> Fixes: 9ef4cbbcb4ac3 ("io_uring: add infra for importing vectored reg buffers")
> Reported-by: Google Big Sleep <big-sleep-vuln-reports+bigsleep-458654612@google.com>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
-- 
Pavel Begunkov


