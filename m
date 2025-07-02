Return-Path: <io-uring+bounces-8587-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B856DAF6532
	for <lists+io-uring@lfdr.de>; Thu,  3 Jul 2025 00:27:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 511631BC85ED
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 22:27:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 499E51EC014;
	Wed,  2 Jul 2025 22:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="POKCFPXc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E7C70805
	for <io-uring@vger.kernel.org>; Wed,  2 Jul 2025 22:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751495243; cv=none; b=mO0Rlbr35mWF6gTk6X36mrIsaThWQ7V/N2XXxzb23Vh2fH7uewT1fEzOtnE5s11SjzTIabR3pvC5vbUr4Eo5NuCpAFFiRLe11C68fPPW8m1cToTLszFLP03Y7ZVvktQoWoBmfa53q6AiZHVmKu5Rt4jBmv5LO2tEQlTWuSJWJOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751495243; c=relaxed/simple;
	bh=o2UmIv2wdl+WSFsrQ1+lVA/esCIf5t47IL2pkxu9tTE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=KG/ccIHbC1PaQk7O5Ai6wc9Fg6/JOHR1bQoNyd+/ue18FFruGtoUfZfV979wcseD3Vw6CYztM7TnA60tvsaRgn62kFhG2JeusrlgNUK+aViEV6UTSoy3rTlebfNfk+FibtPr8Gshe2wd+HaE0mbASwPPhi+kElgMoIytIQgRPH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=POKCFPXc; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7490cb9a892so5194736b3a.0
        for <io-uring@vger.kernel.org>; Wed, 02 Jul 2025 15:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1751495241; x=1752100041; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=y3OobVHV6SRK/WjQ8ynuM9QZzgqND7jcfAvBPjJBK3g=;
        b=POKCFPXcLJbhQJm0Lm3oK6NjVZ9Kyr7SylaarqJKFU0AZ0aQobKvozjArE+VzliNsI
         a0ur6HoPnx9AvQOVN5AsK7I3D4OKl2Wu602cryjPFAc1LcMYDZ55ayA9PP1fWTB4YqIv
         QCk1QjYbroM/szSzUHM6Y1YC4NP8II9Lmr3R3YNLWEKEl9aT+yQEZjaNe4Im2lv/8tLQ
         ikpcKeQal2k/zpzKVvv045WyHiNVCKVLevNRFizWNP5mnlVhHV8eQ+61JbKGh36MpJMI
         J9c8tIbiyr2EHfNXxxmXyeE9odCHeQ7tc4v2UAz5E6itbuloIS48XUgSen2H7NFgx3z5
         piZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751495241; x=1752100041;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y3OobVHV6SRK/WjQ8ynuM9QZzgqND7jcfAvBPjJBK3g=;
        b=O/CGnI7b8EYKk5FH8bHmL5Wu/adsAxZcCJQnczSYQsJzszfJZw+BDVbpIoSEg8hrNn
         HqZlOVqqJuSC+GVX/lVd2t7gMNCKl4CgZ5v9v3dkS2kJJol0aDzSEKKjcfcnG4VSdY8+
         B8upjeHYs7GErjbe5nM4n/7qBPhFsi4LvgfYDT3tt9Rs57glxHzBm4Ejo6esUpm48bLG
         FiD5eYRkAkVXv7gDiKjp8dcW14ChF6OVXEBcOwzDBGVXuLDo9XRIYSXa8Z3supPYmNLL
         FvWTK0KCdzlNJa5PXl8Nc1e3RLas7bhASmTnO62bSUe5kydg76fTYuXJtGZklhXkIQAQ
         rnGA==
X-Forwarded-Encrypted: i=1; AJvYcCXpykDxTk5XZZ8CyUxCWwRf7H8w5AbBK1yedlpflwxmsfqcRoQeZJT6RDK5IHy6ZldycqSltChiHA==@vger.kernel.org
X-Gm-Message-State: AOJu0YysHoMUcxji2AO7NhPLe+TDbX79wps79TH1YuF9wuGxJL8Bxkya
	xw2xk/yShyRobUrtFGOsWUjdnGt9OO8BqeqUMBze5jZ8w8UPczlsTqd1umLLDdLBdovILUKT4qE
	3HeLa1ro=
X-Gm-Gg: ASbGncvlucleUdWR8SmZy2LuGIVeokUrCJpJVoDUQHcJbj4WDxvs2LxmceocX3KjlzS
	lXdGsVyfk03mG9uOLvBPjmWn0Ragj1jL6gBpH0LhfEuHbyXJP5pcYELBiJs49RNuEkVsZiedmFL
	e63ecGxIpqOBZnr1AXvte779Ak5Xq85R8IA/aLOJuPz6Kw/WJ16/yuF/2gIofivZgYKbbSp50Hk
	7v9/54eA0EUgibxNM0WkpTTcoM404FBMXqMooVHqzKXfr0hzxSqiWkz0Aj/eu7zrwEPL/m+KDtT
	Z46fg7e9P06NRw3O1eUnHD8/FmXI02qTdh+ujOCIXHKLuLvkUqiytrchTklfsKyqLtAbHwRGX+2
	GO2aPdIBKzt26QuUz6aMX+klm
X-Google-Smtp-Source: AGHT+IElWW91apliV0yfvAvVbAEaq3ylvi3VmhlILdYdmBgegg648J2Qgswc9cDoY+0GAe1YcE0z4w==
X-Received: by 2002:a05:6a20:729d:b0:21a:e091:ac25 with SMTP id adf61e73a8af0-2240a01fcb6mr2179496637.6.1751495240958;
        Wed, 02 Jul 2025 15:27:20 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1156:1:14f8:5a41:7998:a806? ([2620:10d:c090:500::5:b65f])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af541bb6csm15042622b3a.41.2025.07.02.15.27.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jul 2025 15:27:20 -0700 (PDT)
Message-ID: <bf0aac47-723e-40eb-a280-f8868edf9d26@davidwei.uk>
Date: Wed, 2 Jul 2025 15:27:17 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/6] io_uring/zcrx: return error from
 io_zcrx_map_area_*
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1751466461.git.asml.silence@gmail.com>
 <42668e82be3a84b07ee8fc76d1d6d5ac0f137fe5.1751466461.git.asml.silence@gmail.com>
Content-Language: en-US
From: David Wei <dw@davidwei.uk>
In-Reply-To: <42668e82be3a84b07ee8fc76d1d6d5ac0f137fe5.1751466461.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025-07-02 07:29, Pavel Begunkov wrote:
> io_zcrx_map_area_*() helpers return the number of processed niovs, which
> we use to unroll some of the mappings for user memory areas. It's
> unhandy, and dmabuf doesn't care about it. Return an error code instead
> and move failure partial unmapping into io_zcrx_map_area_umem().
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   io_uring/zcrx.c | 27 ++++++++++++++-------------
>   1 file changed, 14 insertions(+), 13 deletions(-)
> 
> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> index 99a253c1c6c5..2cde88988260 100644
> --- a/io_uring/zcrx.c
> +++ b/io_uring/zcrx.c

...

> @@ -254,29 +254,30 @@ static int io_zcrx_map_area_umem(struct io_zcrx_ifq *ifq, struct io_zcrx_area *a
>   			break;
>   		}
>   	}
> -	return i;
> +
> +	if (i != area->nia.num_niovs) {
> +		__io_zcrx_unmap_area(ifq, area, i);
> +		return -EINVAL;
> +	}
> +	return 0;
>   }

Does io_release_dmabuf() still need to be called in
io_zcrx_map_area_dmabuf() in case of failure, if say
net_mp_niov_set_dma_addr() fails in the loop?

