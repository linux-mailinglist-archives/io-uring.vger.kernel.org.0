Return-Path: <io-uring+bounces-10012-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A8CECBDAFB4
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 20:57:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 72D694E0580
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 18:57:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDEF42BD5B9;
	Tue, 14 Oct 2025 18:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UJqBp/xk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1724727A10F
	for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 18:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760468225; cv=none; b=k2KqywpmVf8/pc6Jlb8ooT29W12X5p6qfhPmn0O8yAjL2q6AediVcIjxy+aQwiXF4Y0NdxtM8HWcRgfCvop/Fw2e/53s2vTkSnH21IJyOi7ESr6RvtUMWE8CTj6BFb2TvDyBa8i3vSPcdIue7H8naMkFw6EHKhNNGT/EZ+GEmgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760468225; c=relaxed/simple;
	bh=IDL2b823LBm6CwaUi1/5ruFNjEzbQELa/5WLaCZs6eg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Z987pMXD2QQLRJ6SdCLWxo88d4wce6ipZW44bEsjsWNZO8Z8HnHuGTmkgWMe2nzKSiJK54nS5lX9eU9MT/WaTQqiaIZsvODRyFv1AUo2tkuApt9I9gV+/xQL0VXME/okyiPw5ebG1ZH+OTKmBHibcId0IjbItrnzIxztzmO777g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UJqBp/xk; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3ee64bc6b90so3266448f8f.0
        for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 11:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760468222; x=1761073022; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b/jTFUH9DOp6VNTnnX8fy5GPYLS2iDZLoelL+mxiB5c=;
        b=UJqBp/xk5RLdgey4xUZWtHpoTF5g2KZ3LpwSSGbpeq1ZpxXSg+F8gvfzglPIVv4OFO
         m+JXwBl/eqW10G+O1H1zbaCM7K1l2aJaMwz0c3Sqcrj10aLMkXguOh9TrDByFSscKE40
         CGui+QQ4MWbNJvCBG0B7KYNtdWo4ay8tRpQDuWuWpUTDihSnR8sbPa6vFCbfyH2dohED
         EKxovZdUF8Fyw7SEYGYomVjNvx5B6JqffZdiaZGHcNS3x0Ibb6fiYjMoyi2i0+TroXRo
         3OOdqFeI/bigvU510LZqX0MnZyQfmaCDtXqXsq3Hiv3udu9IdYcMgw5JlwEXtBiK/+YQ
         jGrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760468222; x=1761073022;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b/jTFUH9DOp6VNTnnX8fy5GPYLS2iDZLoelL+mxiB5c=;
        b=X5HU/7voo1MoZHQrXZTkk/yB5gLZnW9ivcUd6dkMrXScqvr93iex5HRh9bqGlZRkDC
         dVHTT6IZYQP+flBw52fcY3+3X3sbCK8T7ruIY+0mbW3IuB3JRDs536fShMe/AwNLHrQb
         Tm9uIXkuxHsA3D6orsqXUOz/3bKMDR5GvAiF87guph5epgKCB0iesuF7HjriPjnvc6Ab
         fEw07loD5gOATTPGhbHhW+HnE4roCHN+89Qu6ZsWABoggNGRTdSxZSv+ihAAkM1kGQNr
         I3M8jeQ5N7GtrJNQBFQQmBBEE4kKNIWNm1S2lsH4fMGn40DxSvnZaFjUqx42w5899DD6
         qTfQ==
X-Forwarded-Encrypted: i=1; AJvYcCXqxIlNO6RphpRezujB20iVNLduq7xplNQgnqhi4DHYzBxLUfGAWvlYwHNYBblPWo7Qnn4J7PICqg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy27mmaamwUCCz5/jzTdktAIK5bFrWzuyb3YI07fOpHPXi/CnMA
	sEUDXM9dhkD4XiKuatMZAJP5TEmNy0BB7pKIeYdoWGM1YnJ95pAFZTZngxsiBw==
X-Gm-Gg: ASbGncssEO8dww4CPzT4RDx7iSzWBgoPoyeRUIrjZzzbXbu698EBR/xspE1dH/W28ve
	qJ4UJ3fDI0qZNPbRV08grNo3ImwknxJR5YDsNofx4gi8/vPYvrP8qfIlvrMfSzmanO4gfg/M3pb
	6gw+66UOJ7svnScT+UvJs5mQ3HJtTuJI78k6dCA/+9ba7aKN9O9DfNZMoq+v8divnwkAPQJZCmK
	tFU12Koe1ZZ0PqAjEl1+6s65rKC+JKJpOZVDtYCZLto2XhExeG6uCmKN6S/SHECrMUc143bnhcu
	1m4MOg6imbVxHss4aWzmilMVLqIRJEbkuk7wfQ043HpJHqx+VR9FKOEnM4ef4NWX2WPYcrJqUH2
	NHQLj/zPTnFcvfJKZCDp2wRBcYcxOBzuDzkOqORDE8L67mOeRThEIM8TSAvpjsUrGG2LhmfZ5HU
	67L3ludu1QRLmTSBae3QjE4Tr9sm2wH3K8djPdlw==
X-Google-Smtp-Source: AGHT+IHbHSCJlU6JZDHOuQ56ej7pZdcCdzckIkDSabwMiD5LV7TomzY5bb3D8owFTzrTTM+HLHuxGA==
X-Received: by 2002:a05:6000:438a:b0:425:86ae:b0b with SMTP id ffacd0b85a97d-4266e7d9330mr19296520f8f.38.1760468222115;
        Tue, 14 Oct 2025 11:57:02 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5e1024sm24860259f8f.42.2025.10.14.11.57.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 11:57:01 -0700 (PDT)
Message-ID: <ee9b441e-65e0-4644-a9e4-d4b1c1c8b47b@gmail.com>
Date: Tue, 14 Oct 2025 19:58:22 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring: introduce non-circular SQ
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1760438982.git.asml.silence@gmail.com>
 <d2cb4a123518196c2f33b9adfad8a8828969808c.1760438982.git.asml.silence@gmail.com>
 <0a659c8b-45e4-489e-9b84-fce7600a4beb@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <0a659c8b-45e4-489e-9b84-fce7600a4beb@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/14/25 18:21, Jens Axboe wrote:
> On 10/14/25 4:58 AM, Pavel Begunkov wrote:
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index a0cc1cc0dd01..d1c654a7fa9a 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -231,6 +231,12 @@ enum io_uring_sqe_flags_bit {
>>    */
>>   #define IORING_SETUP_CQE_MIXED		(1U << 18)
>>   
>> +/*
>> + * SQEs always start at index 0 in the submission ring instead of using a
>> + * wrap around indexing.
>> + */
>> +#define IORING_SETUP_SQ_REWIND		(1U << 19)
> 
> No real comments on this patch, very straightforward. I do think this
> comment should be expanded on considerably, mostly just by adding a
> comparison to how it's different from the normal non-rewind way of
> tracking which SQEs to submit. I can do it too, or send a v2.

Please do if that's fine with you. Not entirely sure how you
want to put it into words.

-- 
Pavel Begunkov


