Return-Path: <io-uring+bounces-458-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BBAB8839389
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 16:48:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5DA1E1F20EC3
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 15:48:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A296B6281F;
	Tue, 23 Jan 2024 15:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jUvu9DlF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1596280F
	for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 15:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706024412; cv=none; b=uhy8tu2/9pXsECT6alilq5Qr2LmijrXS9UKcnveTVgiojadVKVEP22lW3WBkO1FVAMSBUdLYoj84htdWa6SaWxZLDpNIt6053CxW0LACo3H8ik3wDwMRBwNEEeWZ5UYU2iPB6f7Gl1YIyyhgGAt80QtI3IRoDwMZ7qQiYO1OOgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706024412; c=relaxed/simple;
	bh=q1U70h1nnwpRiHmZSPi8yBN11MunIyRyfOKlvq1ZTxg=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=odAgyhPEV8ECfMoJRscyHop3PgU1PiuN5y0buODlfGM0anNWTW+HHGUhvy2VTGZSAZc1GXyJQvu+C3Zu3t8lvW+r5dcZmPxuNiscL5UJDYX5ZPPxQNLpkGDnhneINloKkZgTa5V7GVrJCsLjIII2jqkd3M+VqHbworRKQ+wZq2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jUvu9DlF; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-7beeeb1ba87so59856139f.0
        for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 07:40:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1706024409; x=1706629209; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S/6A1fiha7dorYvAVSx0A+3e/0mmmEbA+YNsvXi2gDI=;
        b=jUvu9DlF7Y3Zg53t+YIM5UUes60kblv1eMuVzVQrYq81NcAOYzot2Pts9/LZZjp0fK
         aTLwxnEfLYcrYPMwzyCx8w9VlDY7SLr2971bf6K2cY2u0BbL4yqP/qcWwei0Nxpde+To
         n7SnDoL/KORDmjP6U8uv32K0EeyzOWpU73E++22MfCRvvsd48nptW7d30FQJgCt1o083
         8NdNtOPt6u4mkGYWHKJH52uFNcOtePW3SQayFmxND3RA8zALPEcDOIK23644x5g6U09d
         Tau+irTFwLzEhdnZBdIvHETmazrDFWjPhtIYbe0D9vRRvEEba+1gI1IM4Xilv7P8y/x3
         TUMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706024409; x=1706629209;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S/6A1fiha7dorYvAVSx0A+3e/0mmmEbA+YNsvXi2gDI=;
        b=gYX1NoBkO0iqtvDgBxawtLz1p4rMu/+OafYw7rwtnB+n7OeUDkQlJ5AJa7Xb1YThJM
         Y/voC/36NwOOKoNTuUb8Mttqt4C4uH2WjkqOi++i+H3nFR+T8zyIsIKdapFLpA3uLsCU
         LcBqGrBb5qSRUNHeEnJPU5PANSoUjzG1MEGbtVnjT2ewTNZ5PoCpa2uoTOVHbnYtE53j
         +ROdP7gcZQyftd8JaAP37g5m++HSotZk2WPWUznX+y37JLW8Z4/8UMIMqObazqZM9I5d
         budKriKbZ2gxAGOl4TLvve7M72Ow9WxeU0vvHHe6/DhcIEeaj2j0KY/etGY16o1VFFcn
         EInQ==
X-Gm-Message-State: AOJu0Yx80pgZo+xZuTo/CCICK20dnSW1U/sfRNfatmrUo5PFahaLMsKz
	eR9E5acfgDgfePk4F7vgDbXT+4Ziwce3RZUnB5Mhw7XrNuwCcLgLvQJj6EdlaFlPw3TvDELHryY
	ka78=
X-Google-Smtp-Source: AGHT+IHLXZ5GJsNu51sqa9pjb1ueFQx48Bo7NGJGD1VmIkn/w1tnPLFAaXebYPsAFCJDRu7xyXe/5Q==
X-Received: by 2002:a05:6602:4145:b0:7bf:60bc:7f1e with SMTP id bv5-20020a056602414500b007bf60bc7f1emr11052611iob.1.1706024408912;
        Tue, 23 Jan 2024 07:40:08 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l17-20020a02a891000000b0046df3b352casm3578713jam.38.2024.01.23.07.40.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jan 2024 07:40:08 -0800 (PST)
Message-ID: <98b98bfb-ccec-49a2-af5c-d5d61c825482@kernel.dk>
Date: Tue, 23 Jan 2024 08:40:08 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] Add __do_ftruncate that truncates a struct file*
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
To: Tony Solomonik <tony.solomonik@gmail.com>
Cc: krisman@suse.de, leitao@debian.org, io-uring@vger.kernel.org,
 asml.silence@gmail.com
References: <CAD62OrGa9pS6-Qgg_UD4r4d+kCSPQihq0VvtVombrbAAOroG=w@mail.gmail.com>
 <20240123113333.79503-1-tony.solomonik@gmail.com>
 <a44444f9-a220-48a3-b282-a26319e2261c@kernel.dk>
In-Reply-To: <a44444f9-a220-48a3-b282-a26319e2261c@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/23/24 8:38 AM, Jens Axboe wrote:
>> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
>> index fd9d12de7e92..e8c56986e751 100644
>> --- a/include/linux/syscalls.h
>> +++ b/include/linux/syscalls.h
>> @@ -1229,6 +1229,8 @@ static inline long ksys_lchown(const char __user *filename, uid_t user,
>>  			     AT_SYMLINK_NOFOLLOW);
>>  }
>>  
>> +extern long __do_ftruncate(struct file *file, loff_t length, int small);
>> +
>>  extern long do_sys_ftruncate(unsigned int fd, loff_t length, int small);
>>  
>>  static inline long ksys_ftruncate(unsigned int fd, loff_t length)
> 
> This should go in fs/internal.h, it's not a syscall related thing.

And while at it, let's call it ftruncate_file() as that more accurately
describes what it does.

-- 
Jens Axboe


