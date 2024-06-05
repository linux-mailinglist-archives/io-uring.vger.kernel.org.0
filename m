Return-Path: <io-uring+bounces-2121-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FA428FD16B
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 17:11:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F34F9282A35
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 15:11:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF89819D891;
	Wed,  5 Jun 2024 15:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YaYlmhFK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CE73B1BC
	for <io-uring@vger.kernel.org>; Wed,  5 Jun 2024 15:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717600302; cv=none; b=E5AHV0LYqlAPUwnAUyWw7MWTZyqhGCzNWo14PZ+BGOFHxcbWLoQLotetvqvBXoj5kDnh0aVtjGTzFKONPkud255gig3W1WmaiqUMHpFnFllqbVDHcMn44Fi+jXKHLoBVHIv3zbY8G8+8xCiNMWgLLZLUwDltnwpCQ4YyuLe4yT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717600302; c=relaxed/simple;
	bh=jKNzlPWrAtxIAE3HdYVaYahFIokbmweumoT+e35CDAQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=sPok867LO9O5Jh8pFgAdh2uYEu61J1kNgb+V/VYHf13nkJtbv8J6+JJb1OQYRIqLvCXkvkH+MW9MlUpuqBsPqvepM2aPQjMqot4lNsOhw3bUr/7yYWQLEPQdz3KmSMLh9x/ikwHOHlGn7euTBV83KqcvkgxKX20NHO4GJruwV2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YaYlmhFK; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a696cde86a4so10163566b.1
        for <io-uring@vger.kernel.org>; Wed, 05 Jun 2024 08:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717600299; x=1718205099; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WjHYscBECkXuWZUYeUzjUfjKFVRKcZEOHjbljtJ2VqM=;
        b=YaYlmhFKt6W5ZAZ+oyffSgfWLjsOU32Rd3OjWM5XVmzxq0Y1W6Tf1wHvfkryCZq2qY
         V2XCTCtk4syWna5lmE0V42PkP7mptlrFoDWtOIa8Us1KEU/jRuRFf/wlS/enFA0G3qGv
         C992mgp6d/VFVKfa/5p3hGtBRzACkta0aMRzm0VJR1icCSaUnIPOWU+t3Thw20r0gYXb
         ymDiIuQMmZ+YMvLtj1v935wbjwBGFX3EEOeRCtNR3ecdo4Ucnmml+V1xwplOSDBgviPJ
         PWjlM0jwYdtYL0rFqM2YdlDOJq0/eahBvHvJv8oybYnF4/qY9mvWUIY9wc4ZDRQNNOOa
         PV/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717600299; x=1718205099;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WjHYscBECkXuWZUYeUzjUfjKFVRKcZEOHjbljtJ2VqM=;
        b=Id9PrauFJgIejuLWEHCFU741jM2rcqHLiEwaFo1H9Ks/u6KNShWobIFf0nYqGrbapJ
         KqfBHGNAbe3GxZVQzGHBEkBVkJBsG4z5SLVog0CytgWR52dYIuMZBHCdDyYc54tsNZ8P
         A/6qOElLIOMev8MlIjcHjFrZJjQ6iBOEpiCzRGmS/5TYwj7nmkMCiLQNsLzLugwmh8y0
         gmcX4A/cDxlZ0vx/XVdWoFzLR5LjjkYLqobOvToPdaVydsv3fvjiY5f6vJO2T4qsj8vG
         4FnHu/JkFCXoNa55DKMHn6swAOUSRar3N9fJnpLOPgNp2plRdxf1+AACgwsoSufdQEKS
         Re4A==
X-Forwarded-Encrypted: i=1; AJvYcCWPwigdPuT4lpXXe4GBowsjGhub8PnKYHVXph3BJKdmhhfyPYt0LU5AvcmYmaiU2TjCOySRT2xMFNDC0gofyP4aPlStnVPzL+Y=
X-Gm-Message-State: AOJu0YzkErfEn4I0u13o+OBGtrh+daG2XUt1tRM0NGNu5W38SkE0Zonf
	GRUkrXnyI/iX2AiffLdOCrw0GlubzXESFmhvdHfnp1gbO5NJ5pS7
X-Google-Smtp-Source: AGHT+IHA/r5/QU4lXglLNrmHvjHtaE854vq/ATUUUDnxOt2DcJkcsH/i0sHhBMBgqatIJfB3OdUtug==
X-Received: by 2002:a17:907:10c9:b0:a6a:f9cc:ff9c with SMTP id a640c23a62f3a-a6af9cd0492mr136532166b.27.1717600299059;
        Wed, 05 Jun 2024 08:11:39 -0700 (PDT)
Received: from [192.168.42.45] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a69187afd73sm415526966b.63.2024.06.05.08.11.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jun 2024 08:11:38 -0700 (PDT)
Message-ID: <138bf208-dbfa-4d56-b3fe-ff23c59af294@gmail.com>
Date: Wed, 5 Jun 2024 16:11:42 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] io_uring: move to using private ring references
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240604191314.454554-1-axboe@kernel.dk>
 <20240604191314.454554-4-axboe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240604191314.454554-4-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/4/24 20:01, Jens Axboe wrote:
> io_uring currently uses percpu refcounts for the ring reference. This
> works fine, but exiting a ring requires an RCU grace period to lapse
> and this slows down ring exit quite a lot.
> 
> Add a basic per-cpu counter for our references instead, and use that.

All the synchronisation heavy lifting is done by RCU, what
makes it safe to read other CPUs counters in
io_ring_ref_maybe_done()?

Let's say you have 1 ref, then:

CPU1: fallback: get_ref();
CPU2: put_ref(); io_ring_ref_maybe_done();

There should be 1 ref left but without extra sync
io_ring_ref_maybe_done() can read the old value from CPU1
before the get => UAF.

-- 
Pavel Begunkov

