Return-Path: <io-uring+bounces-6201-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 40A20A24072
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2025 17:30:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF5231889833
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2025 16:30:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC5261EE03B;
	Fri, 31 Jan 2025 16:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X7lpnlAK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C62D1E9B17
	for <io-uring@vger.kernel.org>; Fri, 31 Jan 2025 16:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738341002; cv=none; b=Kr8ozdQAO+uzI2h2N7W4mminbRc2rCuMEuHS+Os4U8H1LjrDZBSkyCIjT8FOkruUKtZ6E9jYLcZqEB9Vsdr3nm572I+K9dB4B5AeMhPlpxxqGrIBI1BvHTm7VITXZKDvvI1GF22J6jQ3eQRAEMjeC6IGcyvjO6vt8xMzmfAF3MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738341002; c=relaxed/simple;
	bh=BJ8oiGe3x9jAStKlIq8ywiyMJEbtYUQWvh1B2dCqLz8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=NWmaJ0coEhkutq/6q8pO2DX0cSODwZGkJEegFJ9XqvyRoV2Zjy/DXThkDFioesqqLM4mK4nYcwyXo2r372Ebd/IdUGShALLc2UBistK/smxaen/92rRBKFaf7hQ0Y7fj/TikhpI7MezsxrGA6rG1rxlmb8hLjCWn55ldXym8rU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X7lpnlAK; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5d414b8af7bso4238696a12.0
        for <io-uring@vger.kernel.org>; Fri, 31 Jan 2025 08:30:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738340999; x=1738945799; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=O56B7xjafETr+cBstdT8PibOBYedWbBt9oZ6sXl5sIc=;
        b=X7lpnlAKdBau7GoLvuUjGMYZ3SSsg65xuK0I6WyXJxdUj6wFk/c+OkGo9oGvTL1+Vg
         ZkCM+PHLEs1lOdI/a+U9jAi3Qw76lGWyoFonqAIT2Dh1otsIV9k98G/68Agiv28eMX4H
         SERZ1wvwquGD+lkrJcHw6fJFRHbdGdKP51ujvkz9m4/YHEpMr50Sgafsn2jxepIWWJtr
         g7biymdYpYWcoeE0wQr7KZM13paoVb5AVdww1mN/ttlsKbzSQnyU236FGWJUE+GKkbKO
         0H7R2fOVBsvSB0U8z+fVSKi0XqtHpGeCxnpPfyw1yDgqpwQAfIWb/8rvv/qYpYzzMhxt
         ELAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738340999; x=1738945799;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O56B7xjafETr+cBstdT8PibOBYedWbBt9oZ6sXl5sIc=;
        b=f9Snc0sY+o/hEhfvbWaoUZEI/CjOFmtanLX7grbr30XHNfBoUcPcu9vpXCml8MLjKe
         TMlK0HoWnRJPEFe3xXPFD3ANplXZT+To0pRvX3VTVCaueBK2SjOjT5M5siAAeHFo2GQz
         wwD72g9zHihfE7/L+tQkkf9vMEZY72rANKKzQJWiisr6hDSTmy9DP8Hvq5hFqz7+R0ML
         oQo/nS1Ma+YFm4n8hhjxaa1jNUSsilxUxQHEbSj/z2KjarT2aK89YqRYp2tjEIpG1xZ3
         EQ8MMQST8ToEanvz/yavyIO4JDdqqZx8NYj0oLO9rKIgH0JhoT4sxHUONVyEAeosW87V
         9yKw==
X-Forwarded-Encrypted: i=1; AJvYcCVQ3/1Bkli/+XZbZ4y7IPaIp4sUU33/zgTHp1DUcM6Izj+nXntC8Htbxb5HyaDXiZCqU5UMnA5lqQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwSOcO/jIKstk0Pt7IV5g/l9EkHvBZS+kP3MP/GtPFTmc0TcnXd
	fH0zv7Q+5kIhF4R/0HOULaAgwY+yR5/jW0wOWSvc//Am6E30IJEvm6de9g==
X-Gm-Gg: ASbGncsasvERiAqpxFh09uPVw9EEEq13xphVdYlHB94Vp9527gqSN3UKZKJxXmL7Q4S
	x6fKsbRaHpcfDvHf71BC1lnIT9LqVCsXX2CRAFjyYnrWKErHz1hk4MW/rEHvayDj6EJ+d54A8VO
	PER28SngT/PWpnjoGbkrF1IXRkEHYEsFvaGqWN1gsxxuvciZzeXFsJcHwqvF21yIi+w1lPt0V9E
	C9ZzMuAskirmNoEPYvoResT/AKlQS1+1k44pBbMVEqnvxmvyfDYIFRmdxZX6OyYI27P6JGLjgVC
	4HtDrvutwP8q+akPefYZbYESi1vyldLOmJ8d9UTZ/9HIpQuJ
X-Google-Smtp-Source: AGHT+IHNH31mlW1JVW0PPMiE+J2HHwzm/gpV9UL8eNcultScGI+77e8f3YUl/puYS4iqI6pTzuJZAQ==
X-Received: by 2002:a05:6402:40c4:b0:5dc:893d:6dd4 with SMTP id 4fb4d7f45d1cf-5dc893d6e8emr1535002a12.0.1738340999323;
        Fri, 31 Jan 2025 08:29:59 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:7071])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dc723e9fa7sm3074379a12.20.2025.01.31.08.29.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2025 08:29:58 -0800 (PST)
Message-ID: <8f6de104-ddd7-463a-ae13-b63fe0a285e6@gmail.com>
Date: Fri, 31 Jan 2025 16:30:14 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] io_uring: propagate req cache creation errors
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1738339723.git.asml.silence@gmail.com>
 <8adc7ffcac05a8f1ae2c309ea1d0806b5b0c48b4.1738339723.git.asml.silence@gmail.com>
 <e9b3aca7-4095-4795-8570-eabbb093d118@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <e9b3aca7-4095-4795-8570-eabbb093d118@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/31/25 16:26, Jens Axboe wrote:
> On 1/31/25 9:24 AM, Pavel Begunkov wrote:
>> It's very unlikely, but in theory cache creation can fail during
>> initcall, so don't forget to return errors back if something goes wrong.
> 
> This is why SLAB_PANIC is used, it'll panic if this fails. That's
> commonly used for setup/init time kind of setups, where we never
> expect any failure to occur. Hence this can never return NULL.

Yeah, missed it, thanks

-- 
Pavel Begunkov


