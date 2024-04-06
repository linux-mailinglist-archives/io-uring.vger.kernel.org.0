Return-Path: <io-uring+bounces-1418-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F84089A857
	for <lists+io-uring@lfdr.de>; Sat,  6 Apr 2024 04:07:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7EE101F224CC
	for <lists+io-uring@lfdr.de>; Sat,  6 Apr 2024 02:07:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 718FAFBEE;
	Sat,  6 Apr 2024 02:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="v6gGufni"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D7B3C00
	for <io-uring@vger.kernel.org>; Sat,  6 Apr 2024 02:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712369214; cv=none; b=Z3W2HqAKSW1WOLvHtw/rHPjS1VwG0QlfKkrQ79mOiYY3Wk2HbNBfLzA216d4x71kOc1QImJx6N/9CpTxhPQjlumAGoWa8mqlgkQnQdylCpBIBsa4qfhEI1l0s25jQLJWZPxKYgKlnofFMPk1uKV8TOU0TiUY0C5COG3PzsNLwuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712369214; c=relaxed/simple;
	bh=e5EXRkMuQtcY4FFU97cFwK+6ZxBGztReN24wshOxQy0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rNZ0Ui32vJA1D2rj6xBjq1nW+kHuAmjg9H8znEdFWVVYYlMJqqqpc9ZBAZ/qCnt9UHoykISU5nFiZ/nSZlHt/nItYiQFxUjOt5rT8lctOYzRR2IrOte0mqX4hOz6BwmV6xblAmrGYiRrRmWwnShm2cd/uvJ8FtncXJ/R9v3zdF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=v6gGufni; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-7d341631262so47484039f.0
        for <io-uring@vger.kernel.org>; Fri, 05 Apr 2024 19:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1712369211; x=1712974011; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ef5+3CH6LeOgjKhuTScYGIub12ur0Qg70xfmZlVajOg=;
        b=v6gGufnicAEAhOuCdXEobKx5BsOkcvq6mtHZHi0fY4ix8tX1md7i6+k7eEgNVaqhOi
         8yqBHAE1IF+x0lHeunfEmQBFBUk6F7VNhMzX4XcOaAfhL04M2QWJ3G20lkDFI72LhV3O
         IvqIEtMzzme/htx6fJziUh4nQoERCTiGppA8XfLUBusX1um54jrihaXwsSJUlEZVYe3a
         KafIZh6Zx3n6aNuYQ2ATVZOpGYe58q+8NNg+YDMCLETv9Jwc5ktqVBjyrA1kOSDKp2o0
         FZT70aN29TT4tXmpWbWnF9TKoowJAm/CQBtyGYCkXOx9fcQaFW3iKxXxh0s4kNvk/339
         d9XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712369211; x=1712974011;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ef5+3CH6LeOgjKhuTScYGIub12ur0Qg70xfmZlVajOg=;
        b=LMsNMzcJgj2MawWRPaABvb1MIj9mEu+2UBf+DvNOXQlBrZrvErk8E3Q8WTWV7PWEWr
         1HUvkVI2Mcx/CDysOaALG8b/rVTWhfgniggwg0MrlnrB6sUkOe0Y0NRYEM+D+boSoumh
         YNrgrUFpzkMqiK159eYQwraip+CbX1ufjp5jlJfk8vR3UNuCJn91zpPy82S+4hwigQeO
         wUO32sXkJUpV4zARH/gOXFZmmkNDd9QUrOJDMnJk/p20JIZ7WdIs99dGGUSGaCvbj8Jt
         5jhuSdxKe08Dg3oSQo8IDxANvZM6B//YK5MO5DttnC7CQti/CMgtcmuGWJW/fXhr9H9F
         k8Ew==
X-Gm-Message-State: AOJu0YxCS4zkXsIz/pzLXMvDv0MjqnUJIawODaM3FcMLPqnfQLKTh7p7
	LWJtszMKbXuRxKPnDgcyfCZDTFlCmrghUdgEJEJKYonoYlgMsklUZ03sWkHjmds=
X-Google-Smtp-Source: AGHT+IExzl72Id5N9VkNFUS4umNfTVh7GQ9SiT5dtfpNtOvaY2lc3a0JXNa024TUWD4io0C+OlTx5Q==
X-Received: by 2002:a92:d986:0:b0:369:f53b:6c2 with SMTP id r6-20020a92d986000000b00369f53b06c2mr2663931iln.1.1712369210867;
        Fri, 05 Apr 2024 19:06:50 -0700 (PDT)
Received: from [172.19.0.169] ([99.196.135.167])
        by smtp.gmail.com with ESMTPSA id s5-20020a92cb05000000b0036a0e23db86sm612548ilo.33.2024.04.05.19.06.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Apr 2024 19:06:50 -0700 (PDT)
Message-ID: <b2e8a3e7-a181-42cd-8963-e407a0aa46c6@kernel.dk>
Date: Fri, 5 Apr 2024 20:06:38 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: Fix io_cqring_wait() not restoring sigmask on
 get_timespec64() failure
Content-Language: en-US
To: Alexey Izbyshev <izbyshev@ispras.ru>,
 Pavel Begunkov <asml.silence@gmail.com>,
 Olivier Langlois <olivier@trillion01.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240405125551.237142-1-izbyshev@ispras.ru>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240405125551.237142-1-izbyshev@ispras.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/5/24 6:55 AM, Alexey Izbyshev wrote:
> This bug was introduced in commit 950e79dd7313 ("io_uring: minor
> io_cqring_wait() optimization"), which was made in preparation for
> adc8682ec690 ("io_uring: Add support for napi_busy_poll"). The latter
> got reverted in cb3182167325 ("Revert "io_uring: Add support for
> napi_busy_poll""), so simply undo the former as well.

Thanks - ironically I had to hand apply this one, as some of the
commits you mention above are not in the base you used for the
patch...

-- 
Jens Axboe



