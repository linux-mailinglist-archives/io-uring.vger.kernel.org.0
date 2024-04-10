Return-Path: <io-uring+bounces-1488-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4266289E83E
	for <lists+io-uring@lfdr.de>; Wed, 10 Apr 2024 04:39:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 395BD1C23936
	for <lists+io-uring@lfdr.de>; Wed, 10 Apr 2024 02:39:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A77815664;
	Wed, 10 Apr 2024 02:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fISbtRJC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2123538C
	for <io-uring@vger.kernel.org>; Wed, 10 Apr 2024 02:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712716756; cv=none; b=hXfCz9yqrqucyld053AUmDSf7q9a7vV/nzUA5z+3uINxlfYSNFHCTw9gfxPJJLTyfQGvhjVfXT7K84ZEh/C8kPWXeL4VWlNPq9pj8InRVtCUPemBI/RxGkfFZVIsFQx3Pq6qOMtkUV63Z1G127Czk21rBZUnSnqg2DLhpy3YP+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712716756; c=relaxed/simple;
	bh=6MNqWGdtSAFROsxXFHE0qaT9J+ogE1+Yw5tpqspDucU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iLI/rNTCgs+enRmBuX1Hh9iTtgQ8pZrFUVuHERTIFQ8Lf2X/REVboVlQrcOCtIW3QaN8eD99uQ15o8+qaOssJtkNTfgnuSlb5NCJsV/8KYMye6JR47QNcfKvimXam8zvhEl0rfCbsMV6PC74nTvF5/mT0Rh45i8O+/ilPZ+6Wdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fISbtRJC; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-5a4e0859b65so1655414eaf.0
        for <io-uring@vger.kernel.org>; Tue, 09 Apr 2024 19:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1712716752; x=1713321552; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oDVxGRawSZtglefW/g+RBEwucNUJxK0HTtED3rnumf4=;
        b=fISbtRJCnGWt2+nZloy+HTbMqRqAOWzv4KmdMR/VkI6mTubA2IGQt7SUvglVBR84HI
         N7bC8kz7Ny0DXLDrGY2dl6fA/BfAz+u4meeJRauT/PNOqOG+TX8FjOeEhxKWODnSfYr2
         tL49P+zU1cCuYu1+h/ercVEReX2T2Pa5+h/FOB6uCJubbO4XDR8ao6ehsSfJKqaCaknH
         S/9HtuR4NFEA6d3vPsdstqBjT6pL4TLA7KpvkjfjXfV+9IYY165Tje3Yr/Ri/3Uz2O0B
         2aO/42GAWbV94pRjTZSi1XDtiuSEj90dobtGM+h2JWmE8Ad7pv3W/g8VXjBheIkpggoZ
         XfoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712716752; x=1713321552;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oDVxGRawSZtglefW/g+RBEwucNUJxK0HTtED3rnumf4=;
        b=asa6lKExqOukvSpr+1Gy7bCQsEWCMvJtDK7NV3STkKDnsOKhCKCaDEm0q1eu6ibCZU
         BFZg4TRBdaYlq8g2G6IgPzO3xnXRn95mE+vs1V8dFd4K1Qo3XC7KeBXezkiyKlzkji9l
         O48inQXoUplJ0YmrGGSRMzEHAjplEMysjmQWQAmrMs1orFY2CT/VAZigLEdcWb8SKCWQ
         avC1eJzKzQywtSSO8I+AIT+ARdxywlOUTyjy+dm8CNmbYXKD4dh7LCppLcGWhoVAVlvY
         GIzjAy6xHWJ0Wr/qccnmdi6Ku7nP+iWCuL1aSzH8cwFMEa7DcvrHAgiD/mNsGOwNrj5u
         X8zQ==
X-Forwarded-Encrypted: i=1; AJvYcCXOkR0zjuPE3Ja49r6wMNn1jFDeVPwkngC+ZI3mrLOfPbyftoy33kY7xvPzejq8O02zeNqMf5wgBaWsEuXDSWDe+F/1rN/jzs4=
X-Gm-Message-State: AOJu0YyjAEVCaagyqy+S8E+npqaXD0P8ylireSmomkcZdVkdNp7f7Vyb
	30WjrSaAQcX60wdTHPTK5ZZxuS8DGyi0r9oYHu/+7MoVq0gl18jd9TTAvPVVses=
X-Google-Smtp-Source: AGHT+IEWpNH6EqrPls6fZoDd/GMuZMADknAAUOgQj3NcJUvIqZrX+WoaLlvdDSmEVWDBWGl9ErLuuA==
X-Received: by 2002:a05:6870:d14d:b0:22e:c52e:e7a1 with SMTP id f13-20020a056870d14d00b0022ec52ee7a1mr1689380oac.1.1712716750798;
        Tue, 09 Apr 2024 19:39:10 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id y6-20020a62f246000000b006e6c74eac34sm9070542pfl.151.2024.04.09.19.39.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Apr 2024 19:39:10 -0700 (PDT)
Message-ID: <512df3a2-6a61-4b64-bfaf-69c73d8c18c7@kernel.dk>
Date: Tue, 9 Apr 2024 20:39:09 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next] io_uring: separate header for exported net bits
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
References: <20240409210554.1878789-1-dw@davidwei.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240409210554.1878789-1-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/9/24 3:05 PM, David Wei wrote:
> (cherry picked from commit 9218ba39c2bf0e7bb44e88968801cdc4e6e9fb3e)

This one doesn't make any sense for the commit message, as it's some sha
from a tree that nobody knows about. Not a big deal, I axed it from the
commit message, just mentioning it for future patches.

-- 
Jens Axboe


