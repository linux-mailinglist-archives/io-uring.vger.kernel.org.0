Return-Path: <io-uring+bounces-8039-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 01809ABAAA9
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 16:20:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E583E1B6259C
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 14:20:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FCEC1F181F;
	Sat, 17 May 2025 14:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="r+Vd5AT0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9123F4B1E6E
	for <io-uring@vger.kernel.org>; Sat, 17 May 2025 14:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747491633; cv=none; b=mCUwcXjf4+EGWJL6RnAGcnKFcISv38A303OCP2v7lvuz9LDWw08vMfGbQKCVU6S9f7c+beSxiKiryG+f0+puuj51bTvfA/qZcut1OIBKoebYgTMSMjldhYUdyn38PQduv5pY9V/JW32Npzd9HkafbfliCWbpVmpU9M5u770gcFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747491633; c=relaxed/simple;
	bh=kM4sCXl+GRXKrMoNr5LueflUF1rtGWewyaiiYr7Ne38=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=UTeTbqSo1w3H5IeLYP/YUNN6BWsQR5O2oikjLmcRggLlD3TspabMpltmJCEcaOmKX4qpHdH5qch66noumPG41oXac86zPoI+IFkwkT74Zf+jHXSO+R21xvkD1TL8zVzUU+tQDNEFau03clAhE6xw/iZKfIabxC8Dn1benVhyD5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=r+Vd5AT0; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3d91db4f0c3so13769135ab.3
        for <io-uring@vger.kernel.org>; Sat, 17 May 2025 07:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747491629; x=1748096429; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nkpqjYOwxYODrtN32sbYUxz7Jlp3Q43lX51aHlrWvz4=;
        b=r+Vd5AT0BhnTqJja77c5nCDBKUQI2n62FDwtXzBxM571Z5lHKAWglXhsrt3ssdrP5Z
         JLb9v2eQCR5jdQA1t+gpxJoMVlLUii1056HuQD2uBwc3uv2CmG8RunCLiqZFFSEBFBHn
         uI6okib9wGekpjXe4xvBhaYFmsbzJeL/dxvcw+42a7mZoGHeOXYTRgiREhP8tX0+Tzzt
         x/Mzes+I0UTFrv063yUok8B61JORs8+6hE+9pQaTk2a8g2fawuIIY/77knlpBl3z4RD6
         S5PsgIsI1nZ3hPW12/cJhrmJprcpA46Ch+uBYUBL+PtI6pPtA0k9n3Mj5xdRajYlEdnJ
         cGoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747491629; x=1748096429;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nkpqjYOwxYODrtN32sbYUxz7Jlp3Q43lX51aHlrWvz4=;
        b=kBtjDEiTQqEicZdKuVa0ZA1QZfCahtJB8yKzA8uRebS55CVnbjbdubYO3YCBYb3Fv0
         sGx9FUlwHtljux2GwmNaunFX6M02sMYKJVJogFYVUBN1JhFQ40aSV6rZmWyeVOCJqUiF
         ptmMwwbUX6c5sPl+gVx7Naas2YcsomA2fpEwIYoQDHcP1CTLzYjvjlD8j1+7Esly2KLT
         LeHCUp5ZUEBgD8FVdGNsworXLrfxmSlmb+k04j4BdKZ/iwJls0SQ3SUgNTqEpf4Iep8v
         NqEHkP+3AX1XKOED2MLVxADo+yr35na+QD/5z9glKBJyfQYGISasqh+PGZh8nz8XodXp
         VVUw==
X-Forwarded-Encrypted: i=1; AJvYcCWs4gDKanhHncQDwQz7/By2qiVAs2KPgk2VnuiQ/aN2CZBa18Iy/dgbi37g34/OdjiJcFLROgiQjA==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywh1p3J5xYAFP6XnvKy+LuxdRg6K+46U2oRRdD/2ldhHMszr2R/
	jVcav5iAliEr3512/JiCwXXLI5+PtcJOC8vRn9E3r2aZBMiQi0QreJtvuzFQJqDghks=
X-Gm-Gg: ASbGncu+l8M9nWMyLAn5vlLA0ng8As19JSMRzWpEvehvAOlicvsQmj03zSTbaNeEeL3
	TBl99j0hBRBb9JfG5bExshqWiL3o0nWQ0aQPKjyKT09MiFIBVTUq8IgOkxit2IDuVqHOrzOuVol
	NJtSiUl1zX0t8N3nU7SKrHSU5RjmXyzaSC34pfGNoUdbvMf7KB0gVxdo9ef46t4vfN0uWxKKEis
	2tQs6Lc+qsqvObotBEjaw8sTK+fOKixB8jkGh+SqhWm+Mt9U8PcsTl+UGgGixP2zi5sXIvGUDG1
	Hq167PhtiaAqMfM4H+4vzN6JQ0LOB26PklFyTd6Icx933CQc
X-Google-Smtp-Source: AGHT+IFb+ixIwqS+oohmpDPxNaZ/C4t5MPHp9DlITv0aJz/nk+Pj4nFa3mdmoPw2s7b+WPLF1y8deA==
X-Received: by 2002:a05:6e02:2704:b0:3d4:3fbf:967d with SMTP id e9e14a558f8ab-3db857395e2mr63177705ab.7.1747491629316;
        Sat, 17 May 2025 07:20:29 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3db843e07b8sm10482555ab.20.2025.05.17.07.20.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 May 2025 07:20:28 -0700 (PDT)
Message-ID: <80d92472-402b-407c-8e39-ce39b8ef46ed@kernel.dk>
Date: Sat, 17 May 2025 08:20:27 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v1] register: Remove old API
 io_uring_register_wait_reg
To: Haiyue Wang <haiyuewa@163.com>, io-uring@vger.kernel.org
References: <20250517140725.24052-1-haiyuewa@163.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250517140725.24052-1-haiyuewa@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/17/25 8:07 AM, Haiyue Wang wrote:
> The commit b38747291d50 ("queue: break reg wait setup") just left this
> API definition with always "-EINVAL" result for building test.
> 
> And new API 'io_uring_submit_and_wait_reg' has been implemented.

You can't just remove symbols from a previously released
version of the library...

-- 
Jens Axboe


