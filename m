Return-Path: <io-uring+bounces-2413-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D409692422F
	for <lists+io-uring@lfdr.de>; Tue,  2 Jul 2024 17:19:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9041728859F
	for <lists+io-uring@lfdr.de>; Tue,  2 Jul 2024 15:19:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F3861BC06F;
	Tue,  2 Jul 2024 15:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="y6lMOMq1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1971BBBC8
	for <io-uring@vger.kernel.org>; Tue,  2 Jul 2024 15:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719933520; cv=none; b=IGmu0VVSAqj36CXLbYap5IpuEZ0Q1KL6y01IKctk7c9z6Ak4yKyx7KNqt5x/GywI993kB35aEWe6bhsUm2vdURfC2RN41dHYwU2TK3kikzt+rFuF3GxKjUlPLseR5/QwPfKlQ3FWrt7fewOog5wRaS0s5AL5UhA/PsamqnZrUQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719933520; c=relaxed/simple;
	bh=8VyXqx9GoXMMipDgvyuDBT0CVy5/gYZk4Lf1pNHBxTI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cYMJT9IqkQ3FIhYAuxjizPsHaN4BoQz10Vx8UZl15tIaGpW2rqdq+2MCgwFFZIDSlAW0D4jLVfyDgZufpciWLjFs/E3lQWSGvAkkLym1+Mif2ztVSh6xt7bLCImML1ij40hs3F8q1k/SRfQw3ECBQJnJv6wRsFFtauQpNQL3Alw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=y6lMOMq1; arc=none smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-24c582673a5so561522fac.2
        for <io-uring@vger.kernel.org>; Tue, 02 Jul 2024 08:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1719933517; x=1720538317; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=//QX2V50H9V2wWizm5y5foBrm6VcvlW47rr2j1EQtE0=;
        b=y6lMOMq13jRpxfPeJRE17e3v5iEfJ+gpO5gI8TakZqJhJXf03+87xP5qVbCvu/oXMB
         ZP5n5AKYgaTjvNPPrkKjBibWIzDcq5f3eCWH+IewqGi+z6ivLaG6X8L2G6DA14ZbSaol
         LH3kzXgRRP+5pCI9N8ZO9dKDaEFuh7km5IF89+vrFGvATCRgAGboiJS/GxU1BHVjJRpq
         dOcjdtjEhwBOW4xZsF9BV5QHBw3fE1IXSLwOvH7Kiw6/cJjCA8Rvuy5WV65eaFl6qCY1
         6C7lmcAIUQMIC92CF2JGif9hpUVon0Z5GU55H4+pQgSxrk0eqICoFS5gy98XcYNlcSuk
         Vdew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719933517; x=1720538317;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=//QX2V50H9V2wWizm5y5foBrm6VcvlW47rr2j1EQtE0=;
        b=kPn7mEtDRvC8nCVNPG9kItSvop1LcpGcB1FR9y1qP8AN9ox8/1romcR4qexexsRDlX
         RnPeZFYYqstNNAc5sdBxEZ9OryyScVfNffGTlXm9iCqPCigczMmJ76GvGXSkL7YwGW76
         8EnfR8RB8ApBS2D++dB6ROFVXSARpiK0vaAce+bPzPxnCPUn6sQ/nCWM+A43JnXBSSLq
         ipE+sjP6HSBDptSXE0Dd6yNc4Ii8klSbG13VbQ8NaLVzS0032qSCxLae/xY48xtoNrb0
         E29t1iZRzkMC4FhysNELOabsLFXrMaOE2aeIxGu1DQtJQhAr9PgUc3nOHCXbGiKbzB1A
         7G+w==
X-Gm-Message-State: AOJu0YxMBK/IwH5AA3nm1UGKD+XIKeqvsWSNpg3IWD4ZPat8Gi1P6pAZ
	PXtXol6h4HBwfp7Y1kFD9KKHJyVVoL4i8tYeuHUHioW7RMyU006z2x1j/+y979g=
X-Google-Smtp-Source: AGHT+IFo22yVwfF/lSG5ZdmPxk1LQ8GGm67egABzuuIJHx5kn+RBBTkNW1Ek5F2mLCQYw0XHNdmXUw==
X-Received: by 2002:a05:6870:3c0d:b0:254:7e18:7e1a with SMTP id 586e51a60fabf-25db36bd873mr9153324fac.5.1719933517437;
        Tue, 02 Jul 2024 08:18:37 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-25d8e3a05f4sm2231820fac.58.2024.07.02.08.18.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jul 2024 08:18:37 -0700 (PDT)
Message-ID: <4490ecbb-8ec5-463f-aab5-b638acc2e120@kernel.dk>
Date: Tue, 2 Jul 2024 09:18:36 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring/msg_ring: use kmem_cache_free() to free
 request
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org, asml.silence@gmail.com
References: <20240701144908.19602-1-axboe@kernel.dk>
 <20240701144908.19602-3-axboe@kernel.dk> <87ikxnzuug.fsf@mailhost.krisman.be>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87ikxnzuug.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/2/24 9:17 AM, Gabriel Krisman Bertazi wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> The change adding caching around the request allocated and freed for
>> data messages changed a kmem_cache_free() to a kfree(), which isn't
>> correct as the request came from slab in the first place. Fix that up
>> and use the right freeing function if the cache is already at its limit.
>>
>> Fixes: 50cf5f3842af ("io_uring/msg_ring: add an alloc cache for io_kiocb entries")
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> Fwiw, kfree works fine for kmem_cache_alloc objects since 6.4, when SLOB
> was removed.  Either way, it doesn't harm.

Right, it's more for consistency sake, it's not fixing a real bug.

-- 
Jens Axboe



