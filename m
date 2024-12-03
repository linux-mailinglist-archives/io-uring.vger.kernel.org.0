Return-Path: <io-uring+bounces-5186-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D36279E1DBE
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 14:38:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A8A19165CFE
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 13:37:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C15401F1305;
	Tue,  3 Dec 2024 13:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vXkR24yg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39BE01EF0A6
	for <io-uring@vger.kernel.org>; Tue,  3 Dec 2024 13:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733233070; cv=none; b=bSjgSFeq/1LNYOhQhzGXmNdbZWc7fD/MkPeY3RjF+2sf0ylGn++YKo1fdR7JUbw9Xu0uTFdgdEH6VUvHtPKly4tTtilSDNCPmA4YSUdAkUY228he4SixXCPEZ5pAPYDkDlsdOYCJX0tGXoJJAWjbFXWJA59toQnlBtFe2rlcb24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733233070; c=relaxed/simple;
	bh=JS/rlD8w1FvFLI/O3xpiUzbobo/LygDkgTemGE+9600=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kZsS5P+mnkvE62YrWAzgCM5TabEcSSyXim2a1QzqYniLp/nGWqWofDxEnxbYOxyaq8m2tbzHVyeZi8RrDPqFcr+VwfZQPZdLSFJ3ZtEL2eXrFkynzoFlYUfa+sl72UYPqtyg9C750M/VW98xGpZ/7ZpDNxWKx+278Cmomw4DlNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vXkR24yg; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-3ead60cedb7so1150340b6e.1
        for <io-uring@vger.kernel.org>; Tue, 03 Dec 2024 05:37:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1733233066; x=1733837866; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wsWPHjmWjBz3G/kQLOeuH2+I6rjDNraqrmmvkuCY7zQ=;
        b=vXkR24ygDTfNf106rlh88EME81Xst4pIimaTipobXl1DGd3iCdRVxJQPWAsL53Sd+a
         hcQUf0jDK6IG2UTShbR8EEMAne8F98jhZrNr8W1nNk75JrNhLshHutKwC5AwgMp4mP0+
         ZN/87GHS0GfJhJwrBPtr1KTp6M4aB9TT228fyfDDKw3Ju1RZX3cxVJDXnwJDVVDMMZ7i
         tgcGbdkpStG+d8IGY5o8/INMKMnsdZKIsp+UsFq7SqJiTsdIPARBWTr254GVUXnzb966
         ymi3XUsxti/UmXbbEeKgHWg8E2gxf/1PTAS+N6mzPCadV+8iTwCC1QWmt1W6Gpersyr0
         7WSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733233066; x=1733837866;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wsWPHjmWjBz3G/kQLOeuH2+I6rjDNraqrmmvkuCY7zQ=;
        b=L+OpZLz9fbKaZ8IrJUPTMuDuI0Byn0Xe/lLIry4AvZrsLWkkRMbaG8Fj3Nc40z/iuF
         dRaqMWXLGCjlO/NR806AELiXYrajHTdVFL+P458VsKLzGbCn9sxhNqdlaZOxwbej6m9/
         FgFC9ybKRxjgVNdxyrHiHrGemfgrRR2wUxo925F2Kszz8nsIsjSv6Q+rS6X8S8D9WIon
         aOE39U1EBaCLPdS2VSt7Kh/aCyFbQOLng83vOiR3SAlNYAWTeuRWnGEGwuncZWa5ae31
         nWmBZfrVtvzt3DrHJyBk4E4aiIGRUGyph9W/AIwpqB4dEjJOzDCooHyFI1DfIH7WX5Do
         E9lA==
X-Gm-Message-State: AOJu0YxcY0tf5tqdJuuOhHGqXrGLdMMN8GnQXhnGz1UBmBp66OrXqRbZ
	yPQQ20QzVq2Pb+oHsiSTk8IZ5wBSmQwdzrygiPySJUl9zlOlOFx3xU0+e4idWuI=
X-Gm-Gg: ASbGncsnC/cb2yCDUjkKL/AzyAZhzHTyHzexKK+WMVCHVOwMyFuVF9C5m3skn43NNjL
	9rDkIYAXdPY0UskGbP11icvpmYJX+Dty2DuLepUl0nXPdrotLjDcqxgxtV4eKMrmOMCqk66vc2L
	hV5MvMsL+jr5T53WPgS/djETT0zHZIprnFmTFCUSOcI4UuLYLEG94TI7jKnMtioe1WTBpXhOJBc
	mPh24MA8VicBtIRRmAZv8KI5sVA4PTof7M7xutuqm018qCy
X-Google-Smtp-Source: AGHT+IEuSp5o+p3ybUcBLC1PgcMo8VF6/14HtMOSARUwcbJGRDHVxCyQl070L+LdXrAiM9kGGhj7eg==
X-Received: by 2002:a05:6808:1597:b0:3e7:a15c:4692 with SMTP id 5614622812f47-3eae5058ec1mr2712590b6e.27.1733233065990;
        Tue, 03 Dec 2024 05:37:45 -0800 (PST)
Received: from [172.20.2.46] ([130.250.255.163])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3ea8603a1basm2854500b6e.7.2024.12.03.05.37.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2024 05:37:45 -0800 (PST)
Message-ID: <c42ee76f-8b1e-4f05-aa2d-eea0d6ea24a5@kernel.dk>
Date: Tue, 3 Dec 2024 06:37:44 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: CONFIG_IO_URING can be enabled although it is not visible
To: lizetao <lizetao1@huawei.com>, "masahiroy@kernel.org"
 <masahiroy@kernel.org>
Cc: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 Pavel Begunkov <asml.silence@gmail.com>
References: <5b03eb679ae74070b25510190549bdb9@huawei.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <5b03eb679ae74070b25510190549bdb9@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/3/24 6:04 AM, lizetao wrote:
> Hi,
> 
> When I chose to enable CONFIG_IO_URING, I found that CONFIG_IO_URING
> can also be enabled when CONFIG_EXPERT is n. It seems that other
> macros are in a similar situation, so is this reasonable?

The point of EXPERT isn't to make certain things only enableable if
EXPRT is set, it's just controls the visibility of the symbols. As your
quote shows too:

>   Visible if: EXPERT [=n]                                               

-- 
Jens Axboe

