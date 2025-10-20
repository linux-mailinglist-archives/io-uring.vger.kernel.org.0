Return-Path: <io-uring+bounces-10067-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 922DDBF25AA
	for <lists+io-uring@lfdr.de>; Mon, 20 Oct 2025 18:16:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E5473B8D06
	for <lists+io-uring@lfdr.de>; Mon, 20 Oct 2025 16:15:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B41FE27BF93;
	Mon, 20 Oct 2025 16:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="AZ7os7Xn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B762571DE
	for <io-uring@vger.kernel.org>; Mon, 20 Oct 2025 16:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760976906; cv=none; b=Ey5b4m5VtaMtyN8al04rGYgE+epDDwu3dAreAa77UyKez40fKDb5BBhsZyI0suJyjGotuW1v8Wldv9CfV75thZz87aGWzqoN6+9VP5OeB4UCEMuYFage5lDdb9wgfCTf+73EM5C6kQGoQvdvfLFQx7y6/By2glms7AOIAWCFctw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760976906; c=relaxed/simple;
	bh=8lL3IXeG+mgbAJ5epE3wz0kdWbYNQgQz2eN/UlKcfLU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dKbxRPVbtH52nW68mj65hnJsLE8pGwM9t4Mb4ICjGNvJpNQmiZoFr4FnsqhMVrU4IPqHm1C7zmZFsCtobZ9RqytliWHkKweSHNcmsh0tk4etcjBkb4hn35mxD1u1MfOweX0R+z3MQhfeN0XhiKd9Hvkya373AVomMYbCjMfQN3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=AZ7os7Xn; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-430ca4647c7so14702705ab.3
        for <io-uring@vger.kernel.org>; Mon, 20 Oct 2025 09:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1760976902; x=1761581702; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GuT0JHbPcYTfEuqlH1OnDzBY4HhyngWZygNPiqiL6cU=;
        b=AZ7os7XnqQkOedwYlHFlxyNlPkhLYm3b6dnV+qhrAiXQPM9RP13iDw3XL2dkEcuy/O
         7O97D3s/iBFuSDS6Y+RFSFszghT4vLnmdlYnk2i+wZ32tAi/gR4bnv7zBc5SXQHa1N79
         upBY06SV13Z/Vs1akoSiNMgKvblqGbSzXwNR6H4bgvHFYS6WPhi5h38jHZwXsyYwszfB
         GShhyu1uDCgL9uETKRWI0A5G9h3uPxo/qT6wjZfgTjwPIFX6S7EAQwPGOmkyFCYyJi6T
         HEtUaZNa7sm+jl857lfEv33hW7m/yu2OgbzDGNsSAae9+gGbuEktiljE/kGGlfUMPdX7
         acdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760976902; x=1761581702;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GuT0JHbPcYTfEuqlH1OnDzBY4HhyngWZygNPiqiL6cU=;
        b=JVI1exV4mt3jiTfT08LkUCUHYbCG4B1Y3w0gn+3XhICsp/Jp+rEj+xTUOpIsOKgbVv
         /KNetKRXYTAoDuxZ/cawD+RC0bE+RUThW+8WnX4cyNZucfs2pe2Z5lefljU4uveSsTaP
         9qdafw7Lq6yYEjvn1rYDHyVkTqXR12dFDM1xZ+jD+ql9S/bfD8fG2zjqiIA7EiB8a/Ab
         b5KWurmEze//Vd1qhyUjymF+OaXr7WFLIvyuK/XRouz+wDHUTYGkfB1w/fAmDlkQnJDW
         +R0bdVAKJ9UjofpO1M6OEg7xkJeDYFxqmmX8yHEGlTc40bqFV/5DQ+p54OSEtkeErL+9
         E+Ig==
X-Forwarded-Encrypted: i=1; AJvYcCU34dDKA1ZuutDF83OZWYgcY65g3POiTmw23SZm+mx20BCd28h6LMePLpH8cK9q3Wfl1duYdjq/QA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzh4AKAWbql7AZeVXezA0wecbdV/l875v8iwtlJKASggjGvfK1P
	ZBe2vOo/rvD78t/3S/ncsh3HveOpP1iaKoeEP/SLfvKWSc735RqMiVhlDJYekj5R1eE=
X-Gm-Gg: ASbGnctY3gxeZEoGV4XzCdKqhJGrhEvhq3Xto5vjXy7XhxLg5PJQXc8CwN0qHiNGQEQ
	QX6AqU01XGzhzYZc7s68R+14cPSUwF+UuGrrnN9Bo99u+K/UTBE6SXqASLc2GHU++AAfcBZ6nH1
	Jcpp5oqE7fBlZ7utwljxdMPqkKCd8qQ723icQuIIecyQRmZkwDWu4l5bK73vLfZZMteHhvH6gpy
	OnSp/FERlzXWridG2e25NTacXu5CEZx4FM4bWkMIBt5ZfxVRBe0EWU0cutOmY1h3G6JKy89ys5m
	VbXRlHZryczVYe6uSUQe/KcUC5+9sCYfkQR/Z7YHczSqlyMTFvYEqskqs2iZ7CoEra5K4VbCXK9
	SHus6OS3iI3ljP/n6fhLCZWUoK7oX6uXylZZs26aB40HWiDWcfjpOpwF9eqBNmQ8kUs2FxEp6il
	1wkpVDgzQ=
X-Google-Smtp-Source: AGHT+IEg7aNW+ZUCQvJhhIhNbQySu2xGeib3GggROeVAsMVhwuxESxCYxh/yLlXaS3BLij6x0H4Tcw==
X-Received: by 2002:a05:6e02:451c:b0:430:ea1f:ff82 with SMTP id e9e14a558f8ab-430ea1fff96mr509775ab.23.1760976902458;
        Mon, 20 Oct 2025 09:15:02 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5a8a9771eeesm3084320173.50.2025.10.20.09.15.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 09:15:01 -0700 (PDT)
Message-ID: <1207928c-ad37-4ba0-b473-d38b9b2ce13c@kernel.dk>
Date: Mon, 20 Oct 2025 10:15:00 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] fuse: fuse support zero copy.
To: Xiaobing Li <xiaobing.li@samsung.com>, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 bschubert@ddn.com, kbusch@kernel.org, amir73il@gmail.com,
 asml.silence@gmail.com, dw@davidwei.uk, josef@toxicpanda.com,
 joannelkoong@gmail.com, tom.leiming@gmail.com, joshi.k@samsung.com,
 kun.dou@samsung.com, peiwei.li@samsung.com, xue01.he@samsung.com
References: <CGME20251020080512epcas5p4d3abbe6719fcb78fd65aea0524d85165@epcas5p4.samsung.com>
 <20251020080043.6638-1-xiaobing.li@samsung.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251020080043.6638-1-xiaobing.li@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/20/25 2:00 AM, Xiaobing Li wrote:
> DDN has enabled Fuse to support the io-uring solution, allowing us 
> to implement zero copy on this basis to further improve performance.
> 
> We have currently implemented zero copy using io-uring's fixed-buf 
> feature, further improving Fuse read performance. The general idea is 
> to first register a shared memory space through io_uring. 
> Then, libfuse in user space directly stores the read data into 
> the registered memory. The kernel then uses the io_uring_cmd_import_fixed 
> interface to directly retrieve the read results from the 
> shared memory, eliminating the need to copy data from user space to 
> kernel space.
> 
> The test data is as follows:
> 
> 4K IO size                                                           gain
> -------------------------------------------------------------------------
>                                |   no zero copy   |    zero copy  |  
> rw         iodepth     numjobs |      IOPS        |      IOPS     |    
> read          1           1    |      93K         |      97K      |  1.04
> read          16          16   |      169K        |      172K     |  1.02
> read          16          32   |      172K        |      173K     |  1.01
> read          32          16   |      169K        |      171K     |  1.01
> read          32          32   |      172K        |      173K     |  1.01
> randread      1           1    |      116K        |      136K     |  1.17
> randread      1           32   |      985K        |      994K     |  1.01
> randread      64          1    |      234K        |      261K     |  1.12
> randread      64          16   |      166K        |      168K     |  1.01
> randread      64          32   |      168K        |      170K     |  1.01
> 
> 128K IO size                                                         gain
> -------------------------------------------------------------------------
>                                |   no zero copy   |    zero copy  |
> rw         iodepth     numjobs |      IOPS        |      IOPS     |  
> read           1          1    |      24K         |      28K      |  1.17
> read           16         1    |      17K         |      19K      |  1.12
> read           64         1    |      17K         |      19K      |  1.12
> read           64         16   |      51K         |      55K      |  1.08
> read           64         32   |      54K         |      56K      |  1.04
> randread       1          1    |      24K         |      25K      |  1.04
> randread       16         1    |      17K         |      19K      |  1.12
> randread       64         1    |      16K         |      19K      |  1.19
> randread       64         16   |      50K         |      54K      |  1.08
> randread       64         32   |      49K         |      55K      |  1.12
> -------------------------------------------------------------------------
> 
> I will list the code after this solution is confirmed to be feasible.

Can you post the patches? A bit hard to tell if something is feasible or
the right direction without them :-)

-- 
Jens Axboe

