Return-Path: <io-uring+bounces-7449-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 576A7A83452
	for <lists+io-uring@lfdr.de>; Thu, 10 Apr 2025 00:59:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5DBE21B63CF9
	for <lists+io-uring@lfdr.de>; Wed,  9 Apr 2025 22:59:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FE5921ADC6;
	Wed,  9 Apr 2025 22:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DF+/VtTK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9081E5203
	for <io-uring@vger.kernel.org>; Wed,  9 Apr 2025 22:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744239568; cv=none; b=JBswKtkDPtpZXqwuKFBcIZDHJLBqNU1Mz3z4IAGbpJX5DTONJu6XfsnBQoJoj0SKEI3Jg/QdY0XZR2Dw5nJhSzokxdnn0ngCvjJCJPhyJe67+dAK3f80JvcQbKVl/teaa/yYyuOLui8OCkFJsnwdYY3cQQcBUyWqbXGGhIUG5XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744239568; c=relaxed/simple;
	bh=xOxuLKsd4iNKFtCO11c1Ccmj8BgTQseN9Few4dgjXLE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z5d4CIhaQPxaj72YWoRj7oql5G1Rhq1KRhNJ6Cmld3Kg5YvAihx2sYU/f6eQlzLvoATpYdKVjBwsivc1xdkPNpjxab94C2Sn5P5HuWG4KjpveZiisCgsYGqJ3r6zuoPxsq7igPOB/oyE1H7tFIhj80deL47EoaPYbS/2OJz0cTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DF+/VtTK; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3914aba1ce4so72815f8f.2
        for <io-uring@vger.kernel.org>; Wed, 09 Apr 2025 15:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744239564; x=1744844364; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1pLbT8BBcWL5lMgQpokl1vxpw7r82DdLbNWN9qVF+6g=;
        b=DF+/VtTKDa2kahSUX4EiTI4fHBfTT3tTEylKWUGWq7T0kH/YS+ruqjF66sMfabSWCJ
         eUH/+IdZIggsPdWvN8PqJCaztrWavRF1jRuGmRypG8d2/NsdLbcpcPcSN35CUBPpT89z
         KHHRdwxfweAp+WXC8B5wIy14eG7oGVhucLUlCBWEWcZ36b+KHDft0iVC7qaeI+uwU4hU
         +ptGsiet5W8jcn5g31ilafhS6hjfVyOe8szZVomdrpjMH6fnVVNiItna9hY5SWuyvXah
         TT/o4OG4B3XuWBYT277SkA6Vp5Ief1cH00fZPVNtxgNvv+inGuPX6KD95MY20rQz6MZM
         9CSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744239564; x=1744844364;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1pLbT8BBcWL5lMgQpokl1vxpw7r82DdLbNWN9qVF+6g=;
        b=Of0HUY3/ZYeTwdxpNszPyG7Pga4mWCAVDucM9zeoKSYL3OsRR+OgV0gmPYaaGFi3E8
         s73Db+SFZln6XXnnikvEAyBGe3qiLOuPpxiV1zfICFrpr+ZPKH2QsWmQ++W1iq36dltD
         Ku6wrVX4bbK4NBaeNspMFGqm4pOUf14E5ajB8v/HtKW97zxn3r3bEOloGmW/Y3IijgjO
         fgZDaKd6WFR0ck7lRGqgCZdeCzdwlKBXpeiua4yttKpur2UzAFZPFVI+/0ALRKAkoIaw
         BSRAFgyZNjHhE2TZRdV/nznp0G76M9G7Ecpu27Y5BOIW39JuDbV+h5qrMLXhf/epIiL6
         0shA==
X-Gm-Message-State: AOJu0YymMOabuxtfh0aKKc56074APj5uNOissZ4LWhV2RblFBQ3mH/ir
	eat37Hf8Xr0qnVvlnY5L3rXuAmKoOR9iKBr6DN/JrA8sU70JWEm1akLFmQ==
X-Gm-Gg: ASbGncsD5dMSSWPfPCvF7p1Znljj+4pC6sTwFar5o02YO1/oqN2wVRwEyX0jvtL3e6B
	zKKlMQv3NuOZwoXFZYAJToa3308IHcroWyJVxTaxLc+iVUJq/wfmXAiPvJWdUf68q8EbjguCZE5
	X2ghHuEATBq/RnwVbqY8VdLxtD4NipwWAMpaUHnZg3VJ979GNnoI90wB+HlIwzur61fq2a0s7bQ
	Rnhd2Dh/9N3ZUP8x2BGvOY0u0BgCcRVGVETC+ilGxUuH5uKZZlt0NpHr3lnw4mfM7wVpAXcEd2X
	Rm4BebKps/w4lKU3Xjq1zqlXrblDgVaYHXEQQepesLo5wKFvFA==
X-Google-Smtp-Source: AGHT+IGyJF5oqSufx0PYM9OxEDS66s3CMQBP9xysJGh5c7DqWUyJevYDIR+z/PdrbBW0Ys3CtePrqg==
X-Received: by 2002:a05:6000:40c9:b0:38f:4acd:975c with SMTP id ffacd0b85a97d-39d8fd8c72amr100575f8f.27.1744239564360;
        Wed, 09 Apr 2025 15:59:24 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.132.84])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43f235a5e90sm30505995e9.38.2025.04.09.15.59.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Apr 2025 15:59:23 -0700 (PDT)
Message-ID: <bd93f763-b630-4588-a83e-ab50b1af891c@gmail.com>
Date: Thu, 10 Apr 2025 00:00:33 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 2/2] examples: add a zcrx example
Content-Language: en-US
To: io-uring@vger.kernel.org
Cc: David Wei <dw@davidwei.uk>
References: <cover.1744221361.git.asml.silence@gmail.com>
 <1d9c7573840a5d1f1ab4f054dadfa68be8820821.1744221361.git.asml.silence@gmail.com>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <1d9c7573840a5d1f1ab4f054dadfa68be8820821.1744221361.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/9/25 18:58, Pavel Begunkov wrote:
...
> +static void parse_opts(int argc, char **argv)
> +{
> +	struct sockaddr_in6 *addr6 = (void *) &cfg_addr;
> +	int c;
> +
> +	if (argc <= 1)
> +		usage(argv[0]);
> +
> +	while ((c = getopt(argc, argv, "vp:i:q:o:")) != -1) {
> +		switch (c) {
> +		case 'p':
> +			cfg_port = strtoul(optarg, NULL, 0);
> +			break;
> +		case 'i':
> +			cfg_ifname = optarg;
> +			break;
> +		case 'o': {
> +			cfg_oneshot = true;
> +			cfg_oneshot_recvs = strtoul(optarg, NULL, 0);
> +			break;
> +		}
> +		case 'q':
> +			cfg_queue_id = strtoul(optarg, NULL, 0);
> +			break;
> +		}
> +		case 'v':
> +			cfg_verify_data = true;
> +			break;

Sth went wrong here, I'll need to resend.

-- 
Pavel Begunkov


