Return-Path: <io-uring+bounces-7128-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 92498A68E52
	for <lists+io-uring@lfdr.de>; Wed, 19 Mar 2025 14:56:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4AC9A189D62D
	for <lists+io-uring@lfdr.de>; Wed, 19 Mar 2025 13:48:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3F6F14B092;
	Wed, 19 Mar 2025 13:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="f3DPcQuE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5371F13AD05
	for <io-uring@vger.kernel.org>; Wed, 19 Mar 2025 13:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742392071; cv=none; b=l5mbtdig5qDwFIDLOVadVjzhejfwjtHv0bgY1IoPOX5jeUYOiAOVowqQuA56QfAxJPH0swfxPmXcOKqMDgl9K7Y4RdxPlqvSN2hFPI8T6cYSe9wcINSIEZqF8N7WF5vgoss0W4y2pQOHHyWw85sL52SK3da+T74CBMzTd4W0jCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742392071; c=relaxed/simple;
	bh=gI3d0oq8RFkLJT0BKOqqZY5LDOgamQFwyVDxfP9pnI0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=palJpNr2HS+HwcpwbfzlNgjeSKc3+5PvCJuK8R75HWZXzX0GfNRNwuChj+7jk0M0yRF652koBaHDlLlfKQa+syqMXGi1Slg7aFUVBWV1BEkAsz+uT9AODeyHEAh5P7T3whsJQ8214nEI9ZsUaUvCW1jyU3dUYbWbaVyDkBHbSRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=f3DPcQuE; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3cfce97a3d9so28882305ab.2
        for <io-uring@vger.kernel.org>; Wed, 19 Mar 2025 06:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742392066; x=1742996866; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=31/9dX8h5y/Q1q6lZ8EltzJp+C/LJbFi3dpAwHGu6aI=;
        b=f3DPcQuEWBKWlG7Z1BYf3jLR+CLG1ggw3mg+I9TS12kbl0BqI+y9jZrZ/0xtUuwlL3
         uYPcSqez3wEdmOpTdhzdxwQBgcsqWxQzmHfyHfV5wLtiO9aDspfDOioXYtu4S1eFpyVC
         juXLn/+uYfjtK0Ikm7A+mKwBAc+TCoe1PA3kneQoF1qoleoKwOFvtLNhOh4IDqYxGyjb
         bhgTEJLXbnxUL94N1SNhCLq42BgKEun14SN83T8Vnk7PcU5Tjr8cg7b5eHTnt9Zyb4ws
         /7znjDUGKJFG4ZQLqA1OaK1RkxQJ2vXyIl88mjbw8WmYhUwaoJxirdWAHdLC+fn7wQmE
         aGug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742392066; x=1742996866;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=31/9dX8h5y/Q1q6lZ8EltzJp+C/LJbFi3dpAwHGu6aI=;
        b=BoFawI75xoIM1nwgIolN4C5enLndnNp8Ts0YL4aCAJGF7ZLdVpLfONtF7AQStQg0B/
         f4VBlNe0Xbc9yD1QQhVunhowpza/IPJq0GJ0JV1y6q5MLymn6ACSxjZAvUf1+YzUk4UN
         hm9xBi6bWeF0j9ZuEe+CdRJ7LT3q0PCifxeYqPty+fARrVKuaV0gfY+LPQiSwNgBuuqw
         wI9kPS0RhJAKU45PN3Z/Nqehd7Oh39IrrRG4al7PahOJHI8k0Kb5PBIffMoGVUaSLgdw
         rg/VBKtX9fy1R5/WoO7FTR1NDc5SUPyEC8h5g6gcqMQoN+7SY7E7q+dDue1ZFqFDrOVc
         SGkA==
X-Forwarded-Encrypted: i=1; AJvYcCVXM96eb93PTxiOU/9mYwdJ2O/AvH1LjgieFDTrVH8Kz4VEf4bP1ndHFUfhq084TFXR5xiDBIxU7A==@vger.kernel.org
X-Gm-Message-State: AOJu0YwAw1/OTQFovbG7BqM4AUx2LPwxnk5pJw4elYuuIgRycxgfNHIp
	MuhKnyHEdylZi356QMlz5RZMQRDfmx42+q96iLo+T1iuRxRkvSz2YdVpSkOKoyLeoWkl0pfWv6y
	b
X-Gm-Gg: ASbGncvfer4LDAWz2VEg4h5iV0pa1X5SbXz8FBSOKU7dadCe9dGie7xbKMbNqCwh2Y7
	wvVLWOITA41Lu+7nYnnC66ON92EGHnJ4PCwO7CQPMfn7v2J0NJ+idsZBH5e+HR1mXK8cn4DdDru
	LOIhAowet1btZendiAnaUqk2t/N4WbA4LtEOZxuZJxl7qAfOZ431lCcc5BpNMCkPufFd+53EtY0
	1F4GjxKGV33v785UwfmjBpBCaru1qwWp/VGT8i9phTJxmjrlAChY//tKt2mlmyGVF5Fp9oe1q8k
	OTnjmyXnIwA8bziR+9mHn8ut+swsCRtlHt3DARxizK3Au8cgHzw=
X-Google-Smtp-Source: AGHT+IEI4sxopQX297Ju3nM2WMxPQNYj+mauENnbyA3AW0gPHRPjSCyQLYc40sifSqJ+JqkzPw9JEQ==
X-Received: by 2002:a05:6e02:1d98:b0:3d5:81aa:4d11 with SMTP id e9e14a558f8ab-3d586b38cddmr22858135ab.9.1742392066259;
        Wed, 19 Mar 2025 06:47:46 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d47a6471f4sm37944595ab.10.2025.03.19.06.47.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Mar 2025 06:47:45 -0700 (PDT)
Message-ID: <b49e66d9-d7d7-4450-b124-c2a1cb6277b7@kernel.dk>
Date: Wed, 19 Mar 2025 07:47:44 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] liburing: test: replace ublk test with kernel
 selftests
To: Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org
References: <20250319092641.4017758-1-ming.lei@redhat.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250319092641.4017758-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/19/25 3:26 AM, Ming Lei wrote:
> Hi Jens,
> 
> The 1st patch removes the liburing ublk test source, and the 2nd patch
> adds the test back with the kernel ublk selftest source.
> 
> The original test case is covered, and io_uring kernel fixed buffer and
> ublk zero copy is covered too.
> 
> Now the ublk source code is one generic ublk server implementation, and
> test code is shell script, this way is flexible & easy to add new tests.

Fails locally here, I think you'll need a few ifdefs for having a not
completely uptodate header:

ublk//kublk.c: In function ?cmd_dev_get_features?:
ublk//kublk.c:997:30: error: ?UBLK_F_USER_RECOVERY_FAIL_IO? undeclared (first use in this function); did you mean ?UBLK_F_USER_RECOVERY_REISSUE??
  997 |                 [const_ilog2(UBLK_F_USER_RECOVERY_FAIL_IO)] = "RECOVERY_FAIL_IO",
      |                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~

With

#ifndef UBLK_F_USER_RECOVERY_FAIL_IO
#define UBLK_F_USER_RECOVERY_FAIL_IO   (1ULL << 9)
#endif

added it works as expected for me, but might not be a bad idea to
include a few more? Looks like there's a good spot for it in kublk.h
where there's already something for UBLK_U_IO_REGISTER_IO_BUF.

Outside of that, when running this in my usual vm testing, I see:

Running test ublk/test_stress_02.sh                                 modprobe: FATAL: Module ublk_drv not found in directory /lib/modules/6.14.0-rc7-00360-ge07e8363c5e8

as I have ublk built-in. The test still runs, but would be nice to
get rid of that complaint.

-- 
Jens Axboe

