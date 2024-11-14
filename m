Return-Path: <io-uring+bounces-4693-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F29E9C8B98
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 14:15:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1F64AB30F3B
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 13:09:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 354141FAC5D;
	Thu, 14 Nov 2024 13:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bhlu/LAI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F62C383A5;
	Thu, 14 Nov 2024 13:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731589738; cv=none; b=mbkr9fiN/Bt21Hv5zxsEBStPBnq4ufRkPuMwsxhexfA8+M96BdCYJHN0WVlHX+6YfPY9EdYhk/n9sYkH5XciK8BXspXvH+G0PiFTm0bUdH6Bpl6KQ9dajJuLHzCTeL8heHsa8HC1NLX0CkF74Ug8Y8NEefjQo/GAhRyQCAq7eWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731589738; c=relaxed/simple;
	bh=WUKBai31hAzwn/m1gNuyFpU6gULUok9qnIuRCm88kKo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EqwbKWNftD7tGZxWJjmWtTYwCn0CARjWk5kQmnWsyK/ehXoVbiHWpawAt5qG3TkE+NYd4+ctqaDqIGG8DzJUQWMPfDATQ06ms1JqwgvKclvlo7ZlYmmdl942geU/iQz08kLWXkMpACjnPTGTIZwzXIiSxewvB8rv+w2IP0X0EHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bhlu/LAI; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5cf7aadc8b7so542792a12.1;
        Thu, 14 Nov 2024 05:08:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731589735; x=1732194535; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iLSvMAcvDMJIHYqWDlKkrua+nGTltpWcxj1L4JSgD7A=;
        b=Bhlu/LAIBozgcuMLyrTgWYLS+qlVKYhm42qLcBefvho+QMwAmh5WA40kYjw81kSmwE
         k5HbBXUfwcCZnooNi+qBf9Drzy5Djh3zYo+ofPZMV8+1O36kSlONYw4FuPAHDPFMRSqk
         u8zAbDozzx/RJYgbDomRqaHT9EjUKwO+b5eH03wYYCLrBvYuxK37huiogVmWALocb5el
         tx8LyrfTMXm1wjz8IFy4Zeamkv3/HsePCuHoS2Q8Y/bFnhUunzV2Vdg46uwZjq4VJfbS
         nXBWjmR/C6lUQC+Df8XBuDCgWXA3b7f4QF+1cAuRy1LoBfdAT0+bC++K6AzxDvWNw3Uj
         a5dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731589735; x=1732194535;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iLSvMAcvDMJIHYqWDlKkrua+nGTltpWcxj1L4JSgD7A=;
        b=V/B2gRSjtISH8aJjDm2+Yx6/X9z8eoL5jDcMl/CyGngp5lkyeYhb1Spb1TNmf911Ez
         HYb0FWc+7+RGvajxIdKwPe+0LBXLQi+W7/PN0vC88mpug+e9ax3e3qa21k1usNvKPyec
         4s9UAyRuPoj1s8+C8c6TLaGS9KFJtMYW8GXtCP17tkWNAKy3prQsFiG5yTgUzaDqZ4/8
         SAD9JEWz0Mbmezb45nRhsa5LWAKOr9zr5LPb2ABrMqGNT8WtgNQdklb3L4tCqKInnLYl
         ME4r1k2istQ/GPJcdmAyuONe2vK+ngdqUL1lp+BEPm24paanzv1mi4ECeqQAJNRDBsqS
         UkWQ==
X-Forwarded-Encrypted: i=1; AJvYcCUSiIOICyve6Zch3nV0563caVznJYIteyPMaf64v0vCuPMb2l7OseuAE92dq0YBDJMOgttxxrq7B5AR8w==@vger.kernel.org, AJvYcCUy8lrJsRMow/vK3jQSt1jOaAoS6A0z/yiPuOppMzYjGb/Zdmi16wKc0287ecE5pDEjotgRHfSWSg==@vger.kernel.org, AJvYcCWcWxLblQwPe2wQycBtkD8Kjmgd+wbTxRRonfOG2Odx0DRJ1Gk2c0/cD/rL8CbfzFCnHkQ4HuMfpMHrTosh4Q==@vger.kernel.org, AJvYcCXqq5stGN+PmI5JDVIJDfUqdkVgeM0sFwodxAMeqrcZGyHWAQB0+TuJt18gPcDVdNgQhqQxhJWNgdkVRZI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEDx45WVfU63vEpHOxReAcimzNXgaHZGLGK+vPeEuWC0F/dUrZ
	EXGevJPAYHm+pwoWxlloL2lr1jgGG4CFIna6fKRkSA83M62seVj1
X-Google-Smtp-Source: AGHT+IHYWjN5l6K2Kq+RrDtUeiT+m7+vJWueNPIn3tnYMxsQbh1CD6IGXJhFROExTaUr6np+BDJm2A==
X-Received: by 2002:a17:907:930e:b0:a9a:67aa:31f5 with SMTP id a640c23a62f3a-aa1f8038e76mr646269466b.10.1731589734544;
        Thu, 14 Nov 2024 05:08:54 -0800 (PST)
Received: from [192.168.42.163] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa20e0812aesm60676366b.176.2024.11.14.05.08.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Nov 2024 05:08:54 -0800 (PST)
Message-ID: <3fa101c9-1b38-426d-9d7c-8ed488035d4a@gmail.com>
Date: Thu, 14 Nov 2024 13:09:44 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 06/11] io_uring: introduce attributes for read/write
 and PI support
To: Christoph Hellwig <hch@lst.de>, Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, kbusch@kernel.org, martin.petersen@oracle.com,
 anuj1072538@gmail.com, brauner@kernel.org, jack@suse.cz,
 viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 gost.dev@samsung.com, linux-scsi@vger.kernel.org, vishak.g@samsung.com,
 linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
References: <20241114104517.51726-1-anuj20.g@samsung.com>
 <CGME20241114105405epcas5p24ca2fb9017276ff8a50ef447638fd739@epcas5p2.samsung.com>
 <20241114104517.51726-7-anuj20.g@samsung.com> <20241114121632.GA3382@lst.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241114121632.GA3382@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/14/24 12:16, Christoph Hellwig wrote:
> On Thu, Nov 14, 2024 at 04:15:12PM +0530, Anuj Gupta wrote:
>> PI attribute is supported only for direct IO. Also, vectored read/write
>> operations are not supported with PI currently.

And my apologies Anuj, I've been busy, I hope to take a look
at this series today / tomorrow.

> Eww.  I know it's frustration for your if maintainers give contradicting
> guidance, but this is really an awful interface.  Not only the pointless

Because once you placed it at a fixed location nothing realistically
will be able to reuse it. Not everyone will need PI, but the assumption
that there will be more more additional types of attributes / parameters.

With SQE128 it's also a problem that now all SQEs are 128 bytes regardless
of whether a particular request needs it or not, and the user will need
to zero them for each request.

The discussion continued in the v6 thread, here

https://lore.kernel.org/all/20241031065535.GA26299@lst.de/T/#m12beca2ede2bd2017796adb391bedec9c95d85c3

and a little bit more here:

https://lore.kernel.org/all/20241031065535.GA26299@lst.de/T/#mc3f7a95915a64551e061d37b33a643676c5d87b2

> indirection which make the interface hard to use, but limiting it to
> not support vectored I/O makes it pretty useless.

I'm not sure why that's the case and need to take a look), but I
don't immediately see how it's relevant to that part of the API. It
shouldn't really matter where the main PI structure is located, you
get an iovec pointer and code from there wouldn't be any different.

> I guess I need to do a little read-up on why Pavel wants this, but
> from the block/fs perspective the previous interface made so much
> more sense.

-- 
Pavel Begunkov

