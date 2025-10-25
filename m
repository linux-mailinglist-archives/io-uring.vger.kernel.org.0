Return-Path: <io-uring+bounces-10214-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E0FBC0A114
	for <lists+io-uring@lfdr.de>; Sun, 26 Oct 2025 01:38:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8DA481AA7760
	for <lists+io-uring@lfdr.de>; Sat, 25 Oct 2025 23:38:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B2B92E3B0E;
	Sat, 25 Oct 2025 23:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="VHKrHPqm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A922DF6EA
	for <io-uring@vger.kernel.org>; Sat, 25 Oct 2025 23:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761435476; cv=none; b=JLusRXdE+WdYct7Pm7wLDfpvY38EVs/qnfbS11VA2mMhLQRLNE6Ygulm9lwkeOhu+ox+LTpSmkBjUlRTt2Zgss1jFKW5QKhVFGB29AY6rSFRgyWYiyW/fWEQ/Ac8qt/0p7Yj0oy/YoOSYStu1asQyPAF4S8OftUvRyK8FmTlKKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761435476; c=relaxed/simple;
	bh=Dx4U+Gaq/clGn09ECu7zSnUeMedBa7Zznmvzmrd2rLM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P9zjrQQgU8zaZAiR5GACpEqo8Aim5sFj2+t08mxoypkLU4jZWCqNZyoM1AwhTsFM8BSP+sagoGl2sdNKz2lvF0l+ug2UD7hmzQXJ+dV16EDSwb096MSCrpoylvro3X9kYdg/gJb8QxYrR3E7kjP05XzWvQga+KniXXPR0E4PgO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=VHKrHPqm; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-430e182727dso15338085ab.1
        for <io-uring@vger.kernel.org>; Sat, 25 Oct 2025 16:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761435471; x=1762040271; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uP2cTMdqoXM56t3bzPV291d+nRePd6UdCfenlgq7J4k=;
        b=VHKrHPqmGSTOJrRN+gRlmVRbs4/kD1ulbM2C/3bqRif9ZFgIb1rxP/aXs5UwHt9Igi
         ftsnA1IaBFFCFU60MwcO6zNrW9BHkMt/lUKmCWfxXX5Q8MO9kkrUzALY+YAbVjyCI8K1
         JBIiYNjNy8vdz1ciHlu7mlKB3YOmxTUs5XQ00t56zF7/JA9uCDHDOARjZ3un0mNVc7Ec
         rsTk9DHf/HGThu8Wi2BmZVEFRZcOlpuYEr7fz4ezZCd95xDfx1E5tjjYGrMWv25tjYdf
         IweGQGJYOONsFLFKds3ZaNqTGGVb1EK9uoteJ0+UiE+ghwzTogx7zW9Si0BMlteglZcM
         nNgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761435471; x=1762040271;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uP2cTMdqoXM56t3bzPV291d+nRePd6UdCfenlgq7J4k=;
        b=h9jpRLRs4mYDkyFV8OeycwIuM+3itH8wCYTVpcI5rE1w4QzX7oyWXc/jT5tQvxIUQF
         5TnUY/b1p44E6SMcIYVWg7XhwHaVW+K4dszXl2gBZNny8pcFC69yT5xKA7WIEe/9NPgn
         POfYijWXTmfNoQkSxbJF8PQsi353XKjI2imOI1wrWtb6+kibW4MP6fbhvIMk8DpOoHoK
         rUsPB2Gx0rMEeEKAS/z58TRKhofAnlBWXfTPNFy/+QO+NU9tFlx/m6SFeYLBb4+hzl+K
         CRYOTYZ9ad3YhnmmIk1o/zb6ZBX/lcjo4M/k5S8aLRHA8akOkF0mYOjaDtvVSienWtzT
         Ufew==
X-Forwarded-Encrypted: i=1; AJvYcCXzA3e6kTIV13VZr1Mn9ImGhPRA8qKUqAGwvQIjzBDrSta5wbzXT97f/1YPIIDchh8sbKhYk+5poQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyhGYOKTlZ+Q3vmYps0kVbWA4Uil+00oIkv4so3zbVc82q7y7u0
	FAIpXhO1JZ9D3Dxe0ZQlW3l1+Qwyt0iRtRUkgB/0uIy9xnQMngfGD2jhJgKl7/GXuyY=
X-Gm-Gg: ASbGncu8DN+1lp+e2SxvVsQkoFLHwIkkBTUUo4s+ys8ZtTWdIOJyvSoRfkZaMMIeYX/
	XBslB1Tgm/RFLX+nXxAmYDOK33hstrhnnzamLdKrWnQhUxUANkuPbLLNeEnec6ojKfSAgCWSQ7U
	mtw0MWz+WEwblW9FOacUYLHrg2aDwO26IK3mjc1XZs9cGOVwkkfELcguF/JBEg5AMiz8Y+cj0Gm
	ecdR7oZ6AvDnCUTFRJ+tMyHs0A+ZTyIzxW2x0swPPUtvQSqA5RCwav9jpdiE6R7ZwbeNrAlrOUu
	YzNMAFUJLV+ZPNF3Gf8HhMDzAntWDvvLE6papFoBCe5oft9M43Ukv3w8qQisSPnjS2K4YPXflB2
	B54uO5Sooz/N4UfDiwz6fkaIk6EGEiHcJ3bgiclyKDMP3ezlyuREbK8kUotsgedeatHMQNBydxX
	9YxyJzGiCw
X-Google-Smtp-Source: AGHT+IEUxjCHMUkVgNCW7r+20nOOVAyChpFQ4pF8QbECTAE7TkPei/vWPSqX65q+xvHnBbCesi2PeQ==
X-Received: by 2002:a05:6e02:1aaa:b0:430:b178:428a with SMTP id e9e14a558f8ab-430c52d7705mr441468165ab.22.1761435470947;
        Sat, 25 Oct 2025 16:37:50 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5aea995e70csm1327153173.42.2025.10.25.16.37.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Oct 2025 16:37:49 -0700 (PDT)
Message-ID: <0a9d9e34-a351-4168-bbdc-3ca3b6c3e17b@kernel.dk>
Date: Sat, 25 Oct 2025 17:37:48 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] io_uring/zcrx: add refcount to struct io_zcrx_ifq
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
References: <20251025191504.3024224-1-dw@davidwei.uk>
 <20251025191504.3024224-3-dw@davidwei.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251025191504.3024224-3-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/25/25 1:15 PM, David Wei wrote:
> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> index a816f5902091..22d759307c16 100644
> --- a/io_uring/zcrx.c
> +++ b/io_uring/zcrx.c
> @@ -730,6 +731,8 @@ void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
>  	lockdep_assert_held(&ctx->uring_lock);
>  
>  	xa_for_each(&ctx->zcrx_ctxs, index, ifq) {
> +		if (refcount_read(&ifq->refs) > 1)
> +			continue;

This is a bit odd, it's not an idiomatic way to use reference counts.
Why isn't this a refcount_dec_and_test()? Given that both the later grab
when sharing is enabled and the shutdown here are under the ->uring_lock
this may not matter, but it'd be a lot more obviously correct if it
looked ala:

		if (refcount_dec_and_test(&ifq->refs)) {
  			io_zcrx_scrub(ifq);
  			io_close_queue(ifq);
		}

instead?

-- 
Jens Axboe

