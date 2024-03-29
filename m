Return-Path: <io-uring+bounces-1338-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A9588927BE
	for <lists+io-uring@lfdr.de>; Sat, 30 Mar 2024 00:15:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 847B71C210C1
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 23:15:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 878C813D62A;
	Fri, 29 Mar 2024 23:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="A/3fNjjw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39BE213791F
	for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 23:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711754148; cv=none; b=rNSOWTsl4ZF+wl5W0MmE2uajZM7j7Ry+P7mG8P3asphhO51CrAP1n7lwbcvNtoEcSDjvfTT34kA64kpld9b9uZFP5bHb4u4AVLMLSqKKsZxakJjGFo9STUhbkIIm0IXz6cpdT1bn0QpxQ9ZGoxj801HsqGWeAYonrAQECdVIN28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711754148; c=relaxed/simple;
	bh=B38TqAIR6twb3262TohECiLCnvKqAKZDcFpAUNQGD2w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B2dcxBAi17lkmRUdICegxg6aZSxElRsD8B5niPY7f7PXa+DU4x+Amx0FT8Sl1fvlXfcdYht/0Dfpx5EwnsM7/c6Gh5VpW8y44SG8o1HfGLK129QVOKtj1IWI1jSeVnZW1T4JZjjUOhxLoTh7CPUhFaU3wLW+yD+9N43nIGNXx58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=A/3fNjjw; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1dd3c6c8dbbso2910525ad.1
        for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 16:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711754145; x=1712358945; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=btl1USfK6BwXzey2GUv6BywGO2c/oXOq7q5Lz+WFwhk=;
        b=A/3fNjjwxn1KqDbSvrOTpPWn/rdqmPuOIkD28ypOKYf8jF71WEYWJ3VynhC6zhEyxj
         pqd5Z1aqTp1DfYKjQxITe0Wm2o/hQUo3TzB7JwfPuJ6oKkyaHUOzfNXQoCv18Q+v64GZ
         12qgr62iXmiQnSz44V8rrojwQze9bIa6MmeBH1mp2qcevodRI19fO+eA5ik0EgnkKKNb
         jLeD4SQ/hCyMkS1QI4wDuAY3m8oz0oDkWf/G97gYeuVEZndIubvCyeBUV7f6NvNm1PEq
         fmVZoY2YHdQOuY1eVi6PfA4BnNybTpVuIN64ZLV5VXCOZeTB81NmIaCyIzR97eG4IdhM
         pZqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711754145; x=1712358945;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=btl1USfK6BwXzey2GUv6BywGO2c/oXOq7q5Lz+WFwhk=;
        b=sr4hyOYFxL9fQyPveq5JpfEAM9ILePSESD5xl03D3mZqGZo1wh27JFeDX8btAW5QFE
         BB4hwMipIeCHyJ1wevA3bNYnYqh/o23NKSyGFGrcxpiTbINAj9E5bbITxn63g4HbmhXE
         4U+qOJTOJLqyjF6nLH+KtTsBuqOsa5Ia5h+pyUD+HMfX9VA+2o1/2qBQ5xo9dtNPzXQo
         TnOmvQlqHfkhTqc19CFuVHW23kiQX3W6ci03sCv8rSwf93jejgS3dFl/+vjAjMov/hVU
         tjRRlyFCwvpXLOv2fTDUr18MlQfV1ZKLOCI9N+S94DUnFGxOL2Jwta/pL6m5YeqRytcR
         FirA==
X-Forwarded-Encrypted: i=1; AJvYcCV5PvMQqlBR1eRENcaeawSlFjfq4nXC530FdtG/W0a3TW0B8d1ZQVGKCHjpanByNCbp1XvYzu7OrGMyIr32LbA94hB6Wo7wTFQ=
X-Gm-Message-State: AOJu0Yx/EjLyYyQAiW/eJe1Bbevxk760RHrT+HesEaOuET/YY3DdtyCY
	QIKsCb7xLychYmIWBnIZu3v8K+RwCf3seNpsNlfF86yYP8DPIDP5zNuTWvdqRyY=
X-Google-Smtp-Source: AGHT+IHh/wJNDKYjDS0Le/CHe87pb86v8J4ceX9zE09VetBqcdnyHpg0XYEZONgJzfODOr4SfEliaw==
X-Received: by 2002:a17:902:c255:b0:1de:e8ce:9d7a with SMTP id 21-20020a170902c25500b001dee8ce9d7amr3684053plg.5.1711754145427;
        Fri, 29 Mar 2024 16:15:45 -0700 (PDT)
Received: from [10.46.44.174] ([156.39.10.100])
        by smtp.gmail.com with ESMTPSA id w20-20020a1709027b9400b001dca3a65200sm4004014pll.228.2024.03.29.16.15.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Mar 2024 16:15:44 -0700 (PDT)
Message-ID: <940f0842-194d-4799-8bb2-2024e6903608@kernel.dk>
Date: Fri, 29 Mar 2024 17:15:44 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [axboe-block:for-6.10/io_uring 42/42] io_uring/register.c:175:24:
 warning: arithmetic between different enumeration types ('enum
 io_uring_register_restriction_op' and 'enum io_uring_register_op')
Content-Language: en-US
To: Gabriel Krisman Bertazi <krisman@suse.de>,
 kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, llvm@lists.linux.dev,
 io-uring@vger.kernel.org
References: <202403291458.6AjzdI64-lkp@intel.com>
 <87h6go66fm.fsf@mailhost.krisman.be>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87h6go66fm.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/29/24 4:04 PM, Gabriel Krisman Bertazi wrote:
> kernel test robot <lkp@intel.com> writes:
> 
> [+ io_uring list ]
> 
>>>> io_uring/register.c:175:24: warning: arithmetic between different
>> enumeration types ('enum io_uring_register_restriction_op' and 'enum
>> io_uring_register_op') [-Wenum-enum-conversion]
>>      175 |         if (!arg || nr_args > IORING_MAX_RESTRICTIONS)
>>          |                               ^~~~~~~~~~~~~~~~~~~~~~~
>>    io_uring/register.c:31:58: note: expanded from macro 'IORING_MAX_RESTRICTIONS'
>>       31 | #define IORING_MAX_RESTRICTIONS (IORING_RESTRICTION_LAST + \
>>          |                                  ~~~~~~~~~~~~~~~~~~~~~~~ ^
>>       32 |                                  IORING_REGISTER_LAST + IORING_OP_LAST)
>>          |                                  ~~~~~~~~~~~~~~~~~~~~
>>    14 warnings generated.
> 
> hm.
> 
> Do we want to fix?  The arithmetic is safe here.  I actually tried
> triggering the warning with gcc, but even with -Wenum-conversion in
> gcc-12 (which is in -Wextra and we don't use in the kernel build), I
> couldn't do it.  only llvm catches this.
> 
> can we explicit cast to int to silent it?

I don't think we care, there are others like it in the kernel already.
Plus you need some magic warning incantation to hit it, clang by default
is not going to be enough.

-- 
Jens Axboe


