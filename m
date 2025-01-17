Return-Path: <io-uring+bounces-5972-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50E6AA14ECB
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 12:52:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E7441692C5
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 11:52:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2ED81FE45D;
	Fri, 17 Jan 2025 11:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MMu4XCeB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D5A1FE44A;
	Fri, 17 Jan 2025 11:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737114718; cv=none; b=izpQLtdOsGi/3MTvyu9zPRs0GNJlOs3zeQRwgwdspMzbAIdgawe7OMbpfnvfXB9iG/6uHc/sHzWmScFTslC6lMCG/wWZSIk/miRgBwwa6SFhGIpyQ8qZnzbY18scV+268XIcOJLVlCrpRCaQN7FLy3DkZknLMgIs+iaHrJXA514=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737114718; c=relaxed/simple;
	bh=6pFDC2CD9Wi9XMSARcrMAO/89M9GHlI6X5WG+dxJilg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DRUjjgYwoYBJAEU+g4xhthTbiz+rD+UrcbeIegWMq7zdHVt7Lh2692CJJsK2ZgDKJff8AJb0h1KRfQy4IgpFq13DohUcpWacuYJ39PTbLl0/5sitbMCaCgf0jHfFZnfWcKLbLgFDhZjSp/Okpd2XNvzDl2MC8MoUh5yCk9fCsT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MMu4XCeB; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5d3f65844deso3259576a12.0;
        Fri, 17 Jan 2025 03:51:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737114715; x=1737719515; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tmfA4Yf7ZKLoSBMeZE3uXiNlV0Mrj/AdvcoJ/zoXdPc=;
        b=MMu4XCeBf+QnUvAkNPj6WMkM3k8u4xWYzk3CfifxpzSh5M/EFHP1hIfD4wB8zIYemc
         Y4j2kht12ZbIjnIwexMGsa7RuEboKjhrrBYGdGHYDg3bb+70sx2yMgIMxmQwX0I1/x3k
         L2ZHw7x9W3dqBlnHVcuuxWEQ8S9pPZ02dVjU47Edi5xu6pRW3Dra6e019u5f8HIO9zLF
         hQxiEbEM3dBzxUY8qmPMaBzBppc9EMfZQIV8oMSRRAukPdgCTKmQSlWYXMEcx3zpjVXO
         o0WKY3a6lWsp9mIzhGlRMqk2c69hwmHIvuP9OQa/ezHy/pQLgnzezYuMiq4go9s+WHN4
         JZzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737114715; x=1737719515;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tmfA4Yf7ZKLoSBMeZE3uXiNlV0Mrj/AdvcoJ/zoXdPc=;
        b=T6nNAif/uiy7rmSuPqssaOMzCO+WdDaI89YDYlhhpAb7ZQUhjlNuMldFk6FhSOSgCo
         1I8y6qoXtqtoawgYmGFHX53zuMTzsAjRcsQcJyIy0pEpC6O/h2HEjyoE6O5XE7WJRtPq
         e+E/pRj4Eku9YQ11kecwK5yuKyCdgpyceBLpNOrXIgshNyzZBmrtZ2AANNCGmmOpQYq/
         QnakSBFRCCmu5+hJm14W38gErtdCTwEJdHWCC6Kzqeayh8eLS6wYrA5I+uR2BIh9CngQ
         uVk9nuv4g+LFFpyS1FEn9FPlR84ea8wYdOuwXCX09iCalUF1yzCuB1pzpcofMsa+Sz+1
         nnEg==
X-Forwarded-Encrypted: i=1; AJvYcCVmLBePo73punI98gzRM5pgUkjqzKBxt1zC0qw29hpE7HwEhwsaL6f45QTA7XYWiA9ZU96shu+B6g==@vger.kernel.org, AJvYcCVuKfFKirwcdRV2DWotPWEgoVKhi/F+bnys9JwPCZFxuOJhm30ojaMmN9KuPF7b+DMU6p0hAOqBoZzD8T7V+g==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywd29fdqww90AeDCf+MWO/cJsxBDjfSPGw3bkvCj3B+GVmw+3qR
	eky+env/dIp2wZOY8fFYrGDKiZDucpCr4vGp8cJQZGcRxO/eOXGp
X-Gm-Gg: ASbGnctnqL5cuJYwRnpr0UymsiDVSeGNEs8I0Dc/zzfmSCy9gPJeAvIZWCw+T9C2+L5
	EEwETCyOwwwzWRa/aIL1V0LGX4hFJ/lH8Tzsyc6+NFX4D4WBf7pwkoJwpmt7268Fcnm2absSsYh
	xIfnRq10WouDiMwUm8fDlcq2lnt2QgxqCjdNHWD3MT/q+clBtucha+ebMNxHwTQ/9L3hrI7LGYf
	tlxNzoiPF34EnARd2BKeDyki7TSSofll2kKKLdrsya/h/qgElpeRQjLUZi7QR7xWjlClemlDZ8w
	ri2btgnLvRlXFQ==
X-Google-Smtp-Source: AGHT+IGlbCQlk7yH5FsYCblQRMUs0iCVzOlHKZx7QRKW+xc/Jr46Tpbj29AQPv/s6YF7s6s6aMm5MA==
X-Received: by 2002:a05:6402:27d1:b0:5db:6177:4458 with SMTP id 4fb4d7f45d1cf-5db7d355152mr1815755a12.25.1737114715026;
        Fri, 17 Jan 2025 03:51:55 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:56de])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5db73eb57basm1391724a12.58.2025.01.17.03.51.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2025 03:51:54 -0800 (PST)
Message-ID: <8b8dd37a-9b6e-4a25-8c72-3d396ec18edb@gmail.com>
Date: Fri, 17 Jan 2025 11:52:39 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 17/17] fuse: enable fuse-over-io-uring
To: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>,
 bernd@bsbernd.com
References: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
 <20250107-fuse-uring-for-6-10-rfc4-v9-17-9c786f9a7a9d@ddn.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250107-fuse-uring-for-6-10-rfc4-v9-17-9c786f9a7a9d@ddn.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/7/25 00:25, Bernd Schubert wrote:
> All required parts are handled now, fuse-io-uring can
> be enabled.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov


