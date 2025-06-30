Return-Path: <io-uring+bounces-8522-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14A2BAEE46F
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 18:25:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4528D3B9B56
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 16:22:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0311818FDBE;
	Mon, 30 Jun 2025 16:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mOrI0EUf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903BA2949F6
	for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 16:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751300453; cv=none; b=qHr7CDG+hBXes62MuqgBxh3AN2SxLJrnyK6wS9/N8vTRz+gKZ3QExoeRbGYQzCKW5lWGdcKf7Ytj6QHq30eJPn/wqRYyVmNQU2WFQFppjqIlwXAzVnzRhMnzh/rRu1ZGOoDJN+GR+kJzByzzb92iM/W0O4Cjmi+hntP9dUl1Yfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751300453; c=relaxed/simple;
	bh=/PMq4YngXXUWDyGQhOmk9sMYc5ZTg0zYPWkG3spUmp4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=DUiYjVzPrvmLRaebtJT/YZEJoStKwSS9dED5pyPq35hc+YGm81n8JOgIKOMZAQAU7j/HRRIvKwMDLzMPGTJl1HyxMSWAAQKLIYV+bjaFRNthRdJv3EwaDUPdz0IZleO39BCPoayowZsbDS4DZ5C9aOIwWQRqyaU69gofq1lVVN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mOrI0EUf; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-86cf3a3d4ccso476083239f.3
        for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 09:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1751300448; x=1751905248; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bDRKVlqMlnt7o7Z6k2FsD8svQAAggEYIq7xbnjeeBPQ=;
        b=mOrI0EUf7G471JezOgMu4Xb2d+qUSdhmZVFzCe967csITHFOgAy7W2WyOUcb2d+0Od
         H67Qa/L61HeHdx2/Ubzzucbaay/d9egLdg/gZFhKpZZ2i49rRHsFuLJi9w9dNHtLcSPz
         VREXYqMfPGyzFvZlbGvafptRU/0l9PgAiutH0azqOKtkfGkeDZvXa2HDnXry1/cS6vJZ
         HXWk0bSS7CdsABkBPbPFawdWGaTJGZCO42ESckPRKqv+4yBaWVXq3Gu3IlCLDh1kh+78
         aWl72yM4X6jtTh6V9LT8ySTU8cm0xpUogOBNiTrs9KUN05F+0UzdTwyigVhZSBfkNk0c
         LMKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751300448; x=1751905248;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bDRKVlqMlnt7o7Z6k2FsD8svQAAggEYIq7xbnjeeBPQ=;
        b=VWlBlaiOhn/pHGZGd7RJtLdOrmM1xllB0qci0P8yFuh3dyB4qU+E5w5eYYW0mnowua
         0xv4ziSxYaQXTaJCEVi1iaXl4cZjacRttxmiWKV3WL+FKaQQmKN4GAUuw5o8OHQTjLCi
         bEtpcw/EVAKuEMdGtHho9gCsbOW2vFX9a7TIl1xf/yobGHd7fTiA1/rg1FlPVQFnL3f4
         cn9CEIHfwEKxjs/cSRhpHZg4OhvQc0N5x6EqdodjgfOgFmbrGgSODLzBxhdyDkgLOet0
         T6ufR0jckAIPyKcdktWel7+qb9T7kKHjOsqZ8LPtUz5t8HDIwxJohuKJCZ+V4kdxHlcD
         1fCQ==
X-Forwarded-Encrypted: i=1; AJvYcCV08NSxNpwdHZeWJt4qrSWc694HcfGC4klTZVO4BWXqTC/JxMNbMvc8m9aim0pn/1u1ZkfIn1o89g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxM22wkFf/cZcGkL2oQ3vpLg33iGNj43TUUqPH5TrXJEbsbe62+
	QrkhylpML04LS4ssg8mfMNKAsIHupbCVtGHQ4t5E9ueG1E3ogLPMqrOTtkHGfd2JwfA=
X-Gm-Gg: ASbGnct167ucAA8+p5g2IsdJR5sZdGG89FugSnpPbNMCuGmjW2Lgmdmr1TNiRQuqqHg
	GpwrWhy4k2KIp9s88G0Q3PY8qT89SA2sx7u2bNwmcLPAsHuCwEdTsWgG9kWotWcwRiHoZODvfwi
	za0IcP6Fb8/F/tM1xELxkthIFxjHhmdHzKK5n/kTlK1n0WecqE7cHnIOuj7Nro5EUiZafz2e1ry
	hzi6OhKc6jfp4W/M0fiyefkKe10T71rkmNhwW6hN20n6JrWyBJVzkTxErYcD5OLwqr347IINaLr
	+LJXrwcr6jI1a4GpyyN/Kyxn1g3gFqCbiNkATg+pulMTmFydMdy47Ar+xAfyMH94fU7W4w==
X-Google-Smtp-Source: AGHT+IG2kE5fxA8tPuhQuuOqOTgr7TWC8fdNytkvwA6MBWUbVgBSGTWg76vfXHMsP50QCa2eDRBBZQ==
X-Received: by 2002:a05:6602:2cc7:b0:875:b7b6:ae55 with SMTP id ca18e2360f4ac-876882b0459mr1478616339f.5.1751300446922;
        Mon, 30 Jun 2025 09:20:46 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-876879f4c0fsm193889239f.6.2025.06.30.09.20.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jun 2025 09:20:46 -0700 (PDT)
Message-ID: <accdc66c-1ee4-44af-9555-be2bd9236e25@kernel.dk>
Date: Mon, 30 Jun 2025 10:20:45 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] tests: timestamp example
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1751299730.git.asml.silence@gmail.com>
 <4ba2daee657f4ff41fe4bcae1f75bc0ad7079d6d.1751299730.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <4ba2daee657f4ff41fe4bcae1f75bc0ad7079d6d.1751299730.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/30/25 10:09 AM, Pavel Begunkov wrote:
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

A bit of commit message might be nice? Ditto the other patch.
I know they are pretty straight forward, but doesn't hurt to
spell out a bit why the change is being made.

> +#ifndef SCM_TS_OPT_ID
> +#define SCM_TS_OPT_ID 0
> +#endif

This one had me a bit puzzled, particularly with:

> +	if (SCM_TS_OPT_ID == 0) {
> +		fprintf(stderr, "no SCM_TS_OPT_ID, skip\n");
> +		return T_EXIT_SKIP;
> +	}

as that'll just make the test skip on even my debian unstable/testing
base as it's still not defined there. But I guess it's because it's arch
specific? FWIW, looks like anything but sparc/parisc define it as 81,
hence in terms of coverage might be better to simply define it for
anything but those and actually have the test run?

-- 
Jens Axboe

