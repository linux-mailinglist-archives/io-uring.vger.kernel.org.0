Return-Path: <io-uring+bounces-3921-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F38759AB4C5
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 19:10:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F8461F2452A
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 17:10:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC0061BC9FB;
	Tue, 22 Oct 2024 17:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="3a7cpF2e"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6144E1BC091
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 17:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729617052; cv=none; b=CXIk13FUbmpT3Fb+LjtZk6bs8TvJFyto7uGIKdeuhH8O07D6kJ74ZE683koccvu/s+alr5RAUx90CVlOD0hfpbboEh+4oVwfb8mQAkaB8X08nCrbVH63jo2Y1e+BLeiy0YZnzeNM+4DnOL9iedVNVsOdwCFEK0vuEWvtTsDKmvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729617052; c=relaxed/simple;
	bh=Ll8+sJxAUrMCIU/Ez3VwG51GhedVB6ZmK9WxLumqa6U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f5kwPCGfWhy2Bopl9smVb8UjOSAvUypPOJ8HE026GKUgwTVELvdq0MQBCFie6f4TmIB0MI2RaznoB6Kx5xvvvCW40XxpHiAnxiFFXvtb/9KBP5B1lhhnAp9tjhVwP9NdZct58y6fIBBN3SQXQ0j3d/sX1MWvwR9+QSxB4jwjuLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=3a7cpF2e; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-71e72db7bb1so4255090b3a.0
        for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 10:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1729617050; x=1730221850; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oTQrnGRqar6M7Ym9pTU5zaNF4QuwrDpmbRVnSO3hRsw=;
        b=3a7cpF2e3CfgcpvdMXI7+DQpPkFa+xLyuKtv6+0HxqE+ixwcx+eVt6Z4GgOe7yVUTu
         08Y+VwzfpUVFE/et8hFcTuZC8B0n4OFMDuF/3s6WBgf+ksf77gMF2NrgF2Hq0BRLymm/
         psgWzP4BRJocSdRxuCq9JcT8rEqDyKErCj+D3dnFshgOwmSvt6wnck/+TI/q/0eDeYFj
         P8koBrWwD779B44WYhCyApqHYYZb1Gf/aFP28yYDypRSn6z5yBlQ9iHnn4aumZFsxTLr
         KalD5fM4Pw2nyYnrG2BDxhvyhbu3kjao16hKtrqXc6stGNTRtm0w67i9ZY4NhDSCxTmg
         aBGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729617050; x=1730221850;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oTQrnGRqar6M7Ym9pTU5zaNF4QuwrDpmbRVnSO3hRsw=;
        b=vnzfTB9sNlvfpSOVB2SlnMYa8O4+YFgTnaeLFvjEHAI8prN7E/2UXOefABs6B/tz3N
         vJIDy3/s5MDJgI0/oStnLShDu+3C24HdAQKCpHbfmjnVeV8973wca2GYC/eoYLQez3qk
         3OhzVeOwnpwGDLESoOfa2yuNbzcQCi3cY3Csrh/PqghLDmB2PrGPf5PyhxyjsJRt0+GY
         XADOmBvWuUzmd0n8d3+M3VECeVhp34iawkoE0gi7fWQse07aGKeJ8IdiOi/gCzbuUpYr
         Y4+2PZMbHU7VCgp1rfomHf+3RHI3pwMBZARMWD2hRy12YoZ+S7zJ0eI/xJgSeC9TwKcI
         HKoQ==
X-Forwarded-Encrypted: i=1; AJvYcCURMT0wtF3nMghxygRKjquqrWXEsiAY4MXlTe9TwCeUBSMXDHi+2U7AuWUgn1AcE1Sm5RYxvcOrxw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwciHRRPXC/yJc1FqY1HXhMpobW3dYQgkKBgdNToK2o2WcDvnRa
	rgh0Yi7U6th8CqxleerpRIx79r/KxlDOCvMq9CdKSxpi4RH407pJFSJkTo5Jxig=
X-Google-Smtp-Source: AGHT+IHEW1FYnnoLHn8RPxPGGY44z/TuPqcpPN/hk7FdjXqRG6hN1NoASvthKg1fCAkfuGCSXCFDkg==
X-Received: by 2002:a05:6a20:cd92:b0:1d9:275b:4ef0 with SMTP id adf61e73a8af0-1d96deb6f1bmr3711126637.17.1729617050563;
        Tue, 22 Oct 2024 10:10:50 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1256:1:80c:c984:f4f1:951f? ([2620:10d:c090:500::4:56f4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71ec13eab06sm4980055b3a.154.2024.10.22.10.10.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2024 10:10:50 -0700 (PDT)
Message-ID: <b9e260b1-683c-4829-9ffc-5e76c84569e5@davidwei.uk>
Date: Tue, 22 Oct 2024 10:10:47 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 00/15] fuse: fuse-over-io-uring
Content-Language: en-GB
To: Bernd Schubert <bernd.schubert@fastmail.fm>,
 Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 Joanne Koong <joannelkoong@gmail.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, Josef Bacik <josef@toxicpanda.com>
References: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
 <38c76d27-1657-4f8c-9875-43839c8bbe80@davidwei.uk>
 <ed03c267-92c1-4431-85b2-d58fd45807be@fastmail.fm>
 <11032431-e58b-4f75-a8b5-cf978ffbfa50@davidwei.uk>
 <baf09fb5-60a6-4aa9-9a6f-0d94ccce6ba4@fastmail.fm>
 <a95ec1f4-ca49-495d-9284-eb8828de870a@fastmail.fm>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <a95ec1f4-ca49-495d-9284-eb8828de870a@fastmail.fm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024-10-22 05:46, Bernd Schubert wrote:
> 
> 
> On 10/22/24 12:24, Bernd Schubert wrote:
>> On 10/21/24 22:57, David Wei wrote:
>>> If I am already in dest when I do the mount using passthrough_hp and
>>> then e.g. ls, it hangs indefinitely even if I kill passthrough_hp.
>>
>> I'm going to check in a bit. I hope it is not a recursion issue.
>>
> 
> Hmm, I cannot reproduce this
> 
> bernd@squeeze1 dest>pwd
> /scratch/dest
> 
> bernd@squeeze1 dest>/home/bernd/src/libfuse/github//build-debian/example/passthrough_hp -o allow_other --nopassthrough --uring --uring-per-core-queue --uring-fg-depth=1 --uring-bg-depth=1 /scratch/source /scratch/dest
> 
> bernd@squeeze1 dest>ll
> total 6.4G
> drwxr-xr-x 2 fusetests fusetests 4.0K Jul 30 17:59 scratch_mnt
> drwxr-xr-x 2 fusetests fusetests 4.0K Jul 30 17:59 test_dir
> -rw-r--r-- 1 bernd     bernd      50G Sep 12 14:20 testfile
> -rwxr-xr-x 1 bernd     bernd     6.3G Sep 12 14:39 testfile1
> 
> 
> Same when running in foreground and doing operations from another console
> 
> 
> cqe unique: 4, opcode: GETATTR (3), nodeid: 1, insize: 16, pid: 732
>     unique: 4, result=104
> cqe unique: 6, opcode: STATFS (17), nodeid: 1, insize: 0, pid: 732
>     unique: 6, result=80
> 
> 
> In order to check it is not a recursion issue I also switched my VM to
> one core - still no issue. What is your setup?
> Also, I'm still on 6.10, I want to send out v5 with separated headers
> later this week and next week v6 (and maybe without RFC) for 6.12 next
> week.

I tried this again and could not repro anymore. I think your latest
libfuse that falls back to /dev/fuse fixed it. Sorry for the noise!

> 
> 
> Thanks,
> Bernd

