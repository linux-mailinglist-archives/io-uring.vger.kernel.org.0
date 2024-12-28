Return-Path: <io-uring+bounces-5622-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F2D19FDC28
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2024 21:33:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B28053A1436
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2024 20:33:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D965D18A922;
	Sat, 28 Dec 2024 20:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="KhsLJyl3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64F978F5B
	for <io-uring@vger.kernel.org>; Sat, 28 Dec 2024 20:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735418005; cv=none; b=rQSpnkgBeYD+WoAospccqVimeCjuZFHt0F2EdbPhtOjdps+GIhehef9PYpQbV14RD9oZSCPENBbLmvf9biJQKWSgU7HrhNcJ46fUBElN2w0vpQX1RTxh31zzgR6rVSyHzPZ39khloAfu++agebOYB+MZfl8B9sxKQg3AuPWbAZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735418005; c=relaxed/simple;
	bh=Wju1wWVEdudY10wnnOFt3Xff2n5vefDsJklzI8vhMQs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=P+px4AA5jeE9/Iqs23IxvD9Qjd1fnF/sy6mruAseKx7kaWlF5jOX5AKQpcQGmoaEPm3wOYckAoYQ0oIuTvj6cqjR0Brkgokj/yGbRkD910iRdicF/kl5OpSlNXdVm2mBLwDWbm9yW+SHxdHTRxMtwotttkVtahiuOYomxt4JGoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=KhsLJyl3; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-216401de828so97988755ad.3
        for <io-uring@vger.kernel.org>; Sat, 28 Dec 2024 12:33:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1735418003; x=1736022803; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=x15Lyg1HfitWyD8CW8oTyMUBNGYdwVa9e/fNCeGl6HQ=;
        b=KhsLJyl3pW7Cst08KXXSWLtYnZHnLW5fWoXEUW1kdOif7X40ScYMdpGParrG0zq5c9
         bk9+JtKyuvFJTU+LHGzDhl2Z77C6L7uN2GQkC37oDOKZErH3no+OLPZWHv2Go2E9NW8K
         RZ5tfrnRMAvUN4D4OSHdzVm76aDUWhw+9MA71PF7pnfIrt3+KI1GD1d8+UfhElWjhwtO
         3njb3a3S6STWsQcGurd0vuoY+HNLUMwMJOe+KpB2L2LpKqptE6pACRIc6DWZaiXwuOvp
         ecArRUC1RF51yHFWtaU9QCqPCt9OXPHeWOcRzPN9rGuT35ZjP/YkutbnuEyUIo4H7CwI
         1NLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735418003; x=1736022803;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x15Lyg1HfitWyD8CW8oTyMUBNGYdwVa9e/fNCeGl6HQ=;
        b=SbiFWrTwfimxctmW4oR9dem+kHxrKyaRsgwR7btPLuJJYg3PueG+KDnEz3RdBod5yb
         gtW+1M7KA7AZZhekzycAXRPioKYE1zBdKfl3tB0oTOFhxn8TGoe46U1VU30vtZVGaExz
         Lr82mwVFWBlvJa8CoqtCxfoU9u8S0xru4mME6pWWaFCZ65ULJTx9Ds4mfLUKr5K4DRz/
         jN9W/ttRbv5Q0LtRHEcZZ2MUUZtd3WBc9KB2FaU2oKpvSvT2k0I5JvK0PeP2YTsSC7ex
         NpMGZjl+GreizdCo3a5QmVEXFFM9lFFUbf4ZjTqCQ6DrTGq3BnLHgNBxz5UzFRsOvvlZ
         dypg==
X-Forwarded-Encrypted: i=1; AJvYcCX9OOY34dF5ak5osiDKx9eiqVQnXGCgIUGjJXXl+dBY28ugTayi7fmoT6bxu0XlLDlkBzckb69Ztw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxJ2Jgxt3gO1sE59NRpbJFK2I6ABsH0LpB5keWOJCW+RQdsEw8S
	HLs+Ieuwfr6lwWsm4hZsRaeocN0T4AywIbpE2M1W2PPIDp5RB/DPgU0PuG1doFY=
X-Gm-Gg: ASbGncsGjLnjpe3IAnHLkVJDRMJkB/lXBvrr7s3KN+VgEUC1kVepDev8kml85MYV/AV
	fPIkDQvOWe/XA5T9Bv2upcXrNmohVqgr/Wi/bqQ36CGeAOq2cPebW6XpBkc3jXiGZY0QFpveoHO
	rquDir7908OcI4RDdN8mpEGv95OSVStSpOeui3BB9ZXD6s9lGOe5q7vsKSxoMsTk7Jt6KdAgfEq
	Az2VjhxtwSWSxlZbOoob2eTRpxC8zXDwPnN5TPttz3+/E/v5n+KqA==
X-Google-Smtp-Source: AGHT+IGRO9sZFQ4SKJZO9Hk1uENN8kYbBsibMekolJACPeiDY19LE9k2pWuZjEVzlhF4Z3tAqk45RQ==
X-Received: by 2002:aa7:8895:0:b0:71e:2a0:b0b8 with SMTP id d2e1a72fcca58-72abdd3c48emr41968186b3a.1.1735418003279;
        Sat, 28 Dec 2024 12:33:23 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad8164c7sm16582051b3a.4.2024.12.28.12.33.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Dec 2024 12:33:22 -0800 (PST)
Message-ID: <092163e2-598e-4c6c-afb4-d17e0e0cfd13@kernel.dk>
Date: Sat, 28 Dec 2024 13:33:21 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] WARNING: locking bug in sched_core_balance
To: syzbot <syzbot+14641d8d78cc029add8a@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 mingo@redhat.com, syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
 x86@kernel.org
References: <676babe1.050a0220.2f3838.02bf.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <676babe1.050a0220.2f3838.02bf.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/24/24 11:53 PM, syzbot wrote:
> syzbot has found a reproducer for the following issue on:

No indication that this is related to io_uring at all.

#syz set subsystems: kernel

-- 
Jens Axboe


