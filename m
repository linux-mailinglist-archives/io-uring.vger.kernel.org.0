Return-Path: <io-uring+bounces-5210-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D3009E41CF
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 18:37:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D12E281573
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 17:37:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D35A81A8F8A;
	Wed,  4 Dec 2024 17:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GpY+XFKl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F6C1C3BE1
	for <io-uring@vger.kernel.org>; Wed,  4 Dec 2024 17:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733332135; cv=none; b=jW7E7+9TG0Qx6PrV5k1HgIef8+wf4ETuG9fe9q3cxW/4H178xinVKx7o1Nf0+NxuxXtqvvIEPkUvEFKMWuEYMRy7vxDuldvGPqWjmky2fIBPEhStpJygEEY1UKua00Kgp1RVATNVgiImCO1+yPhy0ipVZzJ4IyG2BUKAIJ/C72E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733332135; c=relaxed/simple;
	bh=5gCPZVrrifqnSFAQWHbs+OifVGQuIbzw/66LkaDUaWg=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=CEH4D06vUQtJgZHfgFjpUxk2hwGGM6jGXxdbR0N+q5wSzqo0Ey6jFoKwHNAo9AsLbNju0+kwldLMdnAuoxYN1ybc1cVLz2rdcK4xs1+8Zf174megYoq7WmYRLkzXAEC8MKvw04O+lREN4lSYKH0Jer01uw9pJosi+DofQBjkslU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GpY+XFKl; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7252f48acf2so35656b3a.2
        for <io-uring@vger.kernel.org>; Wed, 04 Dec 2024 09:08:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1733332134; x=1733936934; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nili2EeXhBBnCR9E7SrWkjme6AdYdFkZANnDcpM0kP4=;
        b=GpY+XFKlZNrV3hUUZGDIaXqUfM4WonHUI5bCYdmZwWEDR8S62d8geDp6dIAqnw8XNF
         J0e0MDGPUh/D6JNSfxPrEEmuFQVObYTBM3SkN05xdpwmxdD/vh07vraA7RQkRGe8j5g+
         y786XWszefTJVdCHTW1K1ONTjPWTYdXR1akRogvlbQnOCNCNP81ah7cN/Tm/gDYtI+8J
         TRBNeIcOIJ4OpQgN6ldvsb6ZSyV8wVcvzizgmicXYvov3JiXNS3AEihrqsIfAuppPBbr
         PU6U2advuXR8TQPK1Qiy5lzlIJfgrR2XfVgmyY0EGCo5QXE3uLRznn86ezyJRyKKK+Cc
         1hWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733332134; x=1733936934;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nili2EeXhBBnCR9E7SrWkjme6AdYdFkZANnDcpM0kP4=;
        b=a9oAfWQ7pLPxMVPk5ySSOL6mBjbOVa2/hd5oqdQmm06+IDoc5y8znFA6ymhxjSeP71
         4kyZopZ2woqInZikUkU1Jd2AMWFTd8vMeULKZ3hbMDyCCxTupYJa6s+DTokDxtgT27G9
         boTrdqm+1fqFCuKHyTebk6TkDjf82KDRqh9y5GLk0hbxdop26KM8oav6k9cyHizt0U4i
         zMpeJVTIR4nPcpbbU6NWSibn2mnGfl/uoI1q4kDw1ZgusRFPC5JQ4T8mVruh+9E03lOM
         84g5oEopwFr5Ro6o7ZxSgO4+oijMFV0LYopguP//3LHnsUc35ZgoiShWrjVJNOYwNGDp
         gVFg==
X-Forwarded-Encrypted: i=1; AJvYcCU+yHBdLGfdUsJh5RZkG8IQd9D1mXANLYjS1RdyPK/43rPz2eQJ+w/2sJKxm4NXA72W/rFHiE86yg==@vger.kernel.org
X-Gm-Message-State: AOJu0YypAah90T09bxuQjUwdoHRQ/5XjlfQDK4Wat2HI7MP4sr8iOHNJ
	bmDN6LePtCT2NTwzLj92jIP8Q4F9elLHOLbj1zp+4JDbzMEuVR+cUpXo3Al66K/VUxqKUMheAHh
	y
X-Gm-Gg: ASbGncsDGobj+U+/VOtPqD12LLo8ABS8dEW93tBYNPUl3JRW8Qzemfmqvbicd5HDrLT
	GEKnf8XQlsZsbnIbCnAqLCpm2M2LkboyIGcKm9QxJpnWedpILzPOeJqKXVkyqAgIFXkh8/TrilR
	GNTMzckoeV3me7s5XKenqvGxTivd30ll3l/hfCPXY5YHRrpOKmig660CAdq+v1forSOOhqe16CG
	672gx7wSYNy0/vgRPFVzuavEFKZ6yIvQl4ZtfdmivIJ1c3YIdSjlMnbdQ==
X-Google-Smtp-Source: AGHT+IE/dcKUbzDldznX90U6aZ3I9fPcXtLjv21sHTghzH/vPO7ZipqAKTafj4KlAoSHYtxs5LKwZg==
X-Received: by 2002:a05:6a00:3d52:b0:724:f1c7:dfbb with SMTP id d2e1a72fcca58-72587f00457mr7404358b3a.7.1733332133692;
        Wed, 04 Dec 2024 09:08:53 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:122::1:2343? ([2620:10d:c090:600::1:a7a9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7254180fcb0sm12954875b3a.147.2024.12.04.09.08.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2024 09:08:53 -0800 (PST)
Message-ID: <61930195-ef48-4ce0-b1e1-f3a8a0a7fc30@kernel.dk>
Date: Wed, 4 Dec 2024 10:08:52 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [syzbot] [io-uring?] general protection fault in
 io_uring_show_fdinfo (2)
To: syzbot <syzbot+6cb1e1ecb22a749ef8e8@syzkaller.appspotmail.com>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <67251dc5.050a0220.529b6.015d.GAE@google.com>
 <67255272.050a0220.35b515.017b.GAE@google.com>
Content-Language: en-US
In-Reply-To: <67255272.050a0220.35b515.017b.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz fix: io_uring/rsrc: get rid of the empty node and dummy_ubuf

-- 
Jens Axboe


