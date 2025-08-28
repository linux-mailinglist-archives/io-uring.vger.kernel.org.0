Return-Path: <io-uring+bounces-9365-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CAE4AB391DD
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 04:50:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D0C3461C44
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 02:50:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F01362698A2;
	Thu, 28 Aug 2025 02:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Ex5P+M77"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473C326656F
	for <io-uring@vger.kernel.org>; Thu, 28 Aug 2025 02:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756349429; cv=none; b=VmwRTrFGVqjlhMhiFKhewHEpw1Y9FeAu8L+xhzRbyPpoePmRGX6DuiaT4g/Sd0epb7fpqWkKKjFRg0P/G5ZknzPa7GYxlOAnLMfm33JJDj5/En6TCAU8+j+FaT2TL0Q1BdUIgq3nj/jwAgUCPsGW0Peb0W4OqQPoGFGYu7WKW+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756349429; c=relaxed/simple;
	bh=UIefXmkkwDn7msQkQbZM7yZZpmCmufplx9uC9EFw3ig=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HJxcQIpLOan0aLWTldYKgTS09+lr9NxdkAB31iu69ZMiBz5NGJmb/B67jAwxsbyDH+GkZtzFqSmzsBOWGw36tmt0p+ZfnE5sD7SUgWcpDP8cJTBmwgWAc2LBD+MaPRHL9kfhiuWntEs0F7W0pH4q0zp2qW9bLQIqV3ZXI+RiRFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Ex5P+M77; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2445827be70so5744325ad.3
        for <io-uring@vger.kernel.org>; Wed, 27 Aug 2025 19:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1756349426; x=1756954226; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EKFhfPBKU5aFdDy6tHlTA21oqL3oEJD1QCVMEEaNa0Y=;
        b=Ex5P+M77LR/8PuPgkqPQFMzWtjPPtD1crXQCwhhUEY40JPmAplMveU3yNB1R5LPSCV
         azavNCqgt/FaUfZmaTWFwc7c0FkO6eSHKs+Cl1U+DNvjIbaPasJS1p8Vs2GBNaZrlIgo
         JvM3ELkPhr+IrB5VDn4WGjyXq38b254XlzXzGb/NzSaowWJGtM9Qdg2RHm104v9xolXk
         3cfpK+y+dEmb5y8uyf6m1+65wIMv+y5Yl9uzdi7ypL/rhGrqzh9zQI7I93i5Sq0z8WOM
         HDASTh+eNokCrDAHAu9j5akrc4DctSY+uGJDJy+wV5z/rM2Z78Mi8GQFS3JvvVhwS30D
         kJpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756349426; x=1756954226;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EKFhfPBKU5aFdDy6tHlTA21oqL3oEJD1QCVMEEaNa0Y=;
        b=RURrT17gjYLuCCluXSlNgBU8VizpriRxTpo07IcFaP11OGBRmCplaHXNMQVfqw35XP
         DiZZL7Vx2QXuoDAh33VpYVSoFF/8CEtTpfdXzN9gWq8/o86W6YjmJIRJ3Aiyi8RCOBHn
         ziDy2hhoTAuOpbprXIgSwKsAU8hrs4LiRqOTmuSDBabPf8763Q8Rg7Lqfeu4aZQTJaWP
         jak73LSTeSMCTwdAZv8ODES90TNKvoJRnNm3JUlp5dKaNoNWt+bM5zyChXyWsfLYN1LI
         SBUoKWf//gVNQEGWpJjtJwm0iZ0WPLiOy4BlofTeQIR9bWnFASpl7sk8eV2zX7UuPFEE
         2XaA==
X-Forwarded-Encrypted: i=1; AJvYcCU69TvLVsJkU3W99SxJgd7kKM3xBE7l4Pcl6viz43wBJiEajAEMwHkziLLmX1TyTjM9dL+NLQGaZA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzXYL89OVR/pr2zzVDALVRmUd/Y/+UMIVigSjCPzV4DY1jaN9bR
	gP+GpG9jhAIdzxOSlQsX15MGxJbi6wIoWqNepqPMdIC0MUkifGxxuea+tSmtZ0IlIl8=
X-Gm-Gg: ASbGncv0yDYizHQVbYNM/+u22kzIPnV0hX/kpotfoaTd5DCU01eXu4t771BmwAXvhF2
	4LQTNJ9DEOMQlQ6KvpCwetyuU8eBKysW9ZLKc+Y053t07Pzg+6d5MohmtmIdRJxEVS4+zGORYhp
	1nndUS+vHf1/Xf3qiskbEaoF/pEB2I/qzwuXx7PO8CWUQdtYX98NB6VzFqipVePcGAg2Kzg+4HK
	xuqmuZs9ALRHVMKzL+NV33D1xgi3917DLjKFriEUzabM43UCwzB+JDFtWa5S7p5ipCxETjB2+Di
	MsRWIIaUhisfFXDq0N8vKRcpHWVKb1uV9O9y3WlM/fKjjtmuyLPwfsYTQYyw9RlqVIEKCRp2G2U
	imir76F4m5G0JzYweiP8y
X-Google-Smtp-Source: AGHT+IF/97+1Ccx7YoDUnrBy72ODTzV6Lkd87S50kMzYOgYq3bil/9cBOlNAli1Lqsf0X0I8sew71g==
X-Received: by 2002:a17:902:fc47:b0:246:9a5f:839f with SMTP id d9443c01a7336-2469a5f8594mr205144055ad.21.1756349426384;
        Wed, 27 Aug 2025 19:50:26 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b49cb88fac4sm12713923a12.9.2025.08.27.19.50.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Aug 2025 19:50:25 -0700 (PDT)
Message-ID: <8ed15a17-618f-4277-afc3-934939292060@kernel.dk>
Date: Wed, 27 Aug 2025 20:50:24 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring/kbuf: fix infinite loop in
 io_kbuf_inc_commit()
To: Qingyue Zhang <chunzhennn@qq.com>
Cc: aftern00n@qq.com, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <8abaf4ad-d457-422d-9e9e-932cab2588e6@kernel.dk>
 <tencent_87B68C160DC3F4AE06BD6DF0349B1B235E05@qq.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <tencent_87B68C160DC3F4AE06BD6DF0349B1B235E05@qq.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/27/25 8:49 PM, Qingyue Zhang wrote:
> On Wed, 27 Aug 2025 20:08:05 -0600, Jens Axboe wrote:
>> I don't think there's anything wrong with the looping and stopping at
>> the other end is of course a safe guard, but couldn't we just abort the
>> loop if we see a 0 sized buffer? At that point we know the buffer is
>> invalid, or the kernel is buggy, and it'd be saner to stop at that
>> point. Something ala:
>>
>>
>> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
>> index 394037d3f2f6..19a8bde5e1e1 100644
>> --- a/io_uring/kbuf.c
>> +++ b/io_uring/kbuf.c
>> @@ -42,7 +42,8 @@ static bool io_kbuf_inc_commit(struct io_buffer_list *bl, int len)
>>  		buf_len = READ_ONCE(buf->len);
>>  		this_len = min_t(u32, len, buf_len);
>>  		buf_len -= this_len;
>> -		if (buf_len) {
>> +		/* Stop looping for invalid buffer length of 0 */
>> +		if (buf_len || !this_len) {
>>  			buf->addr += this_len;
>>  			buf->len = buf_len;
>>  			return false;
> 
> Good idea, it looks nice to me.

I'll send it out, I amended the commit message a bit too.

-- 
Jens Axboe


