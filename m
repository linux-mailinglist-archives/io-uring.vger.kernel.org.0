Return-Path: <io-uring+bounces-9954-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A016FBCA45E
	for <lists+io-uring@lfdr.de>; Thu, 09 Oct 2025 18:58:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7DB613AE0B7
	for <lists+io-uring@lfdr.de>; Thu,  9 Oct 2025 16:57:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1897A1F3B9E;
	Thu,  9 Oct 2025 16:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="KbUa1pDY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EDF2264BA
	for <io-uring@vger.kernel.org>; Thu,  9 Oct 2025 16:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760029016; cv=none; b=u9WHiV1QIDVaB7sc1zWFZa1Wrh19TrnZ4I83iRbAuQXK31czLhehZJGLYNCzdC2PeQfJybpIVijiuLBKFexqnS5fqi7Rkn86Z/r/HvWw8/S2fv5iM2lcWIAxjTyL6cjEzf9syMcIemCuhXACl1ijRYvaeZ0A/NLI/i14wcqq3tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760029016; c=relaxed/simple;
	bh=7LeqwvthghquRc4FKiC1aJEy+UKkUTQYw9KjjVOShKA=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:References:
	 In-Reply-To:Content-Type; b=MTmthNIZ/waFtvgCE0AG9NM373Y1kIHn3fV+zdT1jojnBRT95uXz5FTnhyFhxooRExWY+CYSQhsdCXjwmaGht2DnQ/6RVknjyy4mMyAVRUvpOKfGV4biL9Rq+zC/blzsark7qLptas03raBigTnxGpTNznYBZ1obt0Zh0btcIzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=KbUa1pDY; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-92b92e4b078so48926739f.0
        for <io-uring@vger.kernel.org>; Thu, 09 Oct 2025 09:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1760029012; x=1760633812; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:from:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1dgrxHtWEHMr9Hmc1PtIDiyAxbzIwd/8rFxzt/ZgVmg=;
        b=KbUa1pDY3XbT5MArVAh9BLBJWP71y2g2HCQCEOBmnjTA7YHV3y40YcVRV0OLmTQXY6
         ifhsIWkZjpSzOpvliWdvXt3vRP0+0w7qzDaytn8mR0Hk6nBxZccJ+GL7L3D+ssLsQ3X0
         xvue3HJLF+ArK8WIF6Zj/r1Ujo/vDQmqLi//TQ/W1joGNzJpCx/bp60efBRl9cdQGoPU
         lfbaWxkm0n6bxCwLu5AubmZOTZ6iowjHWPpZ3bhubHcuHUDhTwDrLwlCT9NheZmUyrue
         Md0+7cXE520KKWzhqXv3yNEQoiZMdSt1JClKBaT9mFSPCbAomwUyq8VS+ZHFG6R2kMRG
         7ZMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760029012; x=1760633812;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1dgrxHtWEHMr9Hmc1PtIDiyAxbzIwd/8rFxzt/ZgVmg=;
        b=kRo9q7f6UXfz/YfRXAhtbKLrYNPndm5iZapxZJTD7sqZnUUVJ1PF+o/YV3S0mlCX6p
         AE6ialvH46admGfOQRh0ayivEzsZXnlkFgpZYB17CSyy2JJxqZ5oPEAyEm1wHP6zaGrP
         W7cNah44SXHfx8Ahn57JdFLSo5LmKYiRYBS//djbDwXQA1ygMC5mh9Y/LyXoOPCrMIEd
         XAkd3SuOr7RUujEjXDRYTQk7nWvmJ3KS5bDNwhj6QSsnz/pC2R/6OtCymLcB8Rx+jfSS
         H6a7CpvY/myYB8i1+/mg4qo8oaq0MfelM9d4V5i+6v8ETXQLpC/zCXmOho7HHNIi2CZ9
         0v9w==
X-Forwarded-Encrypted: i=1; AJvYcCVYc1TtNBXPM0l17bkdOFUVaGYJaNKCvOPYzPa8n0rRj7vwJHnH4cbqER6w0DFPafqWy9quKeHZVw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxvY9p/4W+8MgctEPT4nA3OK++dtb9aaG+VCarcUK/oDirnlvaM
	bkOgl6xt0RX/9HfgqCZgQbbQQelJZGOtCZmOtpgKxK/fjH39hjBbkENUo/s8417HNbU=
X-Gm-Gg: ASbGncuhwHzGnmf6iEC9KJQdpJcitp/ue4iyluly6SYhYQMNajlEvMCs4ddRleTv6e8
	6IEleAY0iIgaYZS9oiAcB9LdkbavBqZXFeaM1P4OTVogTSEs3oKivx34vOhMRGIeIG7W0ZfZRO9
	QJ9XxrKaYdtvtA3v1qMLEgWK7cOWmDdXnbgGfArL1tF3/xAjl/3FGA49lQPhnvV3nSwDVMYEp8f
	j73UbQ0G0D/Yrie/yMEvnchdpYjYT9xHa3pg2C/GYx0ZNpe7nOiLRa4IKBonHs8rS5L0+7GY3tD
	MDvrSIIGaZ6F3JUr5ohaAyTwT8t4R2FlNQtGFvyDYGZKJHLxnFa8IDyZ4NVXh+mSp+emipWVwTP
	bGGzS8q3IL1U0rW8EJr7dvyEcwrslwZlgvxjIbXBsmNtfGRLMcP/ryg==
X-Google-Smtp-Source: AGHT+IEgeZHB6dQQs+oiJlME1XwSt9GSDpkhuFy9/AtMSMVQtdVWxxf/2QEIM1orGKsmnZ+Kjd8wAQ==
X-Received: by 2002:a05:6602:13c3:b0:8a3:70e4:9abb with SMTP id ca18e2360f4ac-93bd166e931mr927048639f.0.1760029012145;
        Thu, 09 Oct 2025 09:56:52 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-57b5ea3132fsm8352370173.26.2025.10.09.09.56.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Oct 2025 09:56:51 -0700 (PDT)
Message-ID: <b64194fe-59c3-4d61-bbf8-1f9494b91dbf@kernel.dk>
Date: Thu, 9 Oct 2025 10:56:50 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [syzbot] [io-uring?] KASAN: slab-use-after-free Read in
 io_waitid_wait
To: syzbot <syzbot+b9e83021d9c642a33d8c@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <68e50af2.a00a0220.298cc0.0479.GAE@google.com>
Content-Language: en-US
In-Reply-To: <68e50af2.a00a0220.298cc0.0479.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git syztest 

-- 
Jens Axboe

