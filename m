Return-Path: <io-uring+bounces-2281-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C88990F1B1
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 17:06:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A7E251F229D7
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 15:06:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DD6F770FC;
	Wed, 19 Jun 2024 15:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="bCR/O+O6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384A04436A
	for <io-uring@vger.kernel.org>; Wed, 19 Jun 2024 15:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718809601; cv=none; b=TbLWE8uDsahGw4RULjg7AxHdXIjwbtB0FUIJ6y+wwVPIkqYhZ8V04xhTaRBal3ffpTMCi0gmWJTKW2AhLZTn3ciOENmtis42krBLhmCp9wWHeToCk46/jEoVMZYhLaUsBbgCyAmoDtHpMDo96i7Xu0kMLn6omH3JBqKGdJHTVFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718809601; c=relaxed/simple;
	bh=LWGjmP+rC1JFhC9qPYSY2Zefx1xD1uvPRocWZ9AHnMc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iuXJR7HHHTs5WbMP+heTjWXID+Vv8vqdVdmzU/TMYFhTNghCmGZ3gf17tqkMZpnV1nL/lQwB0e43jCOYtxcKObyAhrInNLISI0WtrtRAg/DyGmWjLOIclWXPahuiz7pHmo6ZQi+l6uM463rSnqU9GWnnPrluAtztQjnC8To7GAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=bCR/O+O6; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1f9a78c6c21so863815ad.3
        for <io-uring@vger.kernel.org>; Wed, 19 Jun 2024 08:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718809599; x=1719414399; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=on338al4U9oenyDxZgV6JQd2LQZkOB/N1W0IURYugIA=;
        b=bCR/O+O6k+T9r/cFKNIiuI0Hh/vv7VvqZRcIerdCifSr3TZrN9t1JsYuAdsW3cX7Ig
         9eSia1B+9zteukvJjqmSWag6jOcPKLqGNbJDZKb6jV0c06tFYStpkxWx4JNT/rdTYm6d
         9+SaQobLhfh7Abr7rzgYLXdLRm2WdRdpk9Fn5K+/2ju1ueGYZq3+XcbW+a1Av8Ah7bPi
         9d+osX/Prc3DVFGm9byxk2M3HYVH5XFuT4Ty/cr3NaIilk2/fr3XgnVQ+xR3mHydpLfS
         w6O7sHa/rAPSm7pt2V0/ZjX0wKwE7tD+SgiDCFbSgwVrr7d3fbYKwh+67uuRmk8uWBAC
         UIXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718809599; x=1719414399;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=on338al4U9oenyDxZgV6JQd2LQZkOB/N1W0IURYugIA=;
        b=fR6KINNL4mOSV2Pxlohb2RsyM6dss4rv11K/7QvlCNQQBMymSV8DtIXHyyLlog0XHQ
         kNK84yENd4fuBjLPHfnZIGtku2aJOM5pJ4qSZWCFLVdKtRu5mu/4b75hISNH21lMAGcQ
         /bDrzj95RBzRKZa8wwIs36mcgOJkytlD8KIGqoHnDL9gcEjldb6yYwoj+OOuW/tGQvxU
         zZMVWhhJZMPdcsjeIs/sE1mwRT4mS3nATS1AxvVv5HtjCmhvZgFVgYkXfjZe0xrEe25z
         SS4QmRx/GQCMJrFaKGymxA1ATurDxHVDm9VcFcl9YGRPxJkS6Jy8grRhXlNB7PekxIfp
         LLxw==
X-Forwarded-Encrypted: i=1; AJvYcCVcs1CNrg6XmxRxcJlTIbm+Moquj3Xmho/ifyzzKyKmO6lO1Ry5NPzbEq213UOq5AkSz40zgv2p34VSUjKiHMGZm74jJZbNqq8=
X-Gm-Message-State: AOJu0YyFDrtOX4NAw/ITLFI7G/HAQDQdvVI5rBYDrqkVedUv3eIcNV3j
	PmWiXz1TXlnjs83s433d/yEBi3i9nNGJI7PCj+5NRPHTuYZSPfamjSY53fXgELE=
X-Google-Smtp-Source: AGHT+IECR7Dr/Jv1DuLw8Fb5iIB0YA7F/Bl9zA0Wwsbx0/D7dUo4CUCioMaYQAp04nXRThH7esU8UA==
X-Received: by 2002:a17:902:dac6:b0:1f5:e635:21e9 with SMTP id d9443c01a7336-1f9aa3d23d5mr29343655ad.2.1718809599394;
        Wed, 19 Jun 2024 08:06:39 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f855e55e8dsm117998375ad.31.2024.06.19.08.06.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jun 2024 08:06:38 -0700 (PDT)
Message-ID: <8002392e-5246-4d3e-8c8a-70ccffe39a08@kernel.dk>
Date: Wed, 19 Jun 2024 09:06:37 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] net: Split a __sys_bind helper for io_uring
To: Jakub Kicinski <kuba@kernel.org>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
References: <20240614163047.31581-1-krisman@suse.de>
 <20240618174953.5efda404@kernel.org>
 <68b482cd-4516-4e00-b540-4f9ee492d6e3@kernel.dk>
 <20240619080447.6ad08fea@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240619080447.6ad08fea@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/19/24 9:04 AM, Jakub Kicinski wrote:
> On Wed, 19 Jun 2024 07:40:40 -0600 Jens Axboe wrote:
>> On 6/18/24 6:49 PM, Jakub Kicinski wrote:
>>> On Fri, 14 Jun 2024 12:30:44 -0400 Gabriel Krisman Bertazi wrote:  
>>>> io_uring holds a reference to the file and maintains a
>>>> sockaddr_storage address.  Similarly to what was done to
>>>> __sys_connect_file, split an internal helper for __sys_bind in
>>>> preparation to supporting an io_uring bind command.
>>>>
>>>> Reviewed-by: Jens Axboe <axboe@kernel.dk>
>>>> Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>  
>>>
>>> Acked-by: Jakub Kicinski <kuba@kernel.org>  
>>
>> Are you fine with me queueing up 1-2 via the io_uring branch?
>> I'm guessing the risk of conflict should be very low, so doesn't
>> warrant a shared branch.
> 
> Yup, exactly, these can go via io_uring without branch juggling.

Great thanks!

-- 
Jens Axboe


