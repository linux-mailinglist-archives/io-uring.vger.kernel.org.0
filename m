Return-Path: <io-uring+bounces-6105-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BC0DA1AB5F
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 21:31:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 481D4188B651
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 20:31:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54A201C3F00;
	Thu, 23 Jan 2025 20:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="K8bMXIQl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64261CEE9B
	for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 20:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737663993; cv=none; b=am17mx/o7ayK+vi/j+v5K91wKHTsil1ZA13b15J0p0ktXFrLWcKrlbEjCIrE/bjqY9b69VOghvY4d+8WUcRiiYB3N/YGQMaX9Fyq22L+qL8oyWDCCKvC51REQwdqV/wFFAAoDCEqnBWaSYD4epqWq4Rn+sMzZtiCWfXXWaK05ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737663993; c=relaxed/simple;
	bh=XLXuVqHtZFEB7bPFde0vj33ievU7lEE8M2zClCjuLDM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jwaFBSh+VZxejiU41y0dXF59iI3R8IGYjBYnPOQIGLmVJbHvWPQa4NphCMBzai5sgwCsHCnEWubVJExArOMt+jh2goD8Ex7mafFrQSnHRDxthS2WsCM5sexF+7+mJ+cQZfmy0UHN/eTKctd3K7KeYKe6ck5QM6R71eFiHl6OmHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=K8bMXIQl; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-844e55a981dso38706339f.3
        for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 12:26:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737663989; x=1738268789; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hiEhNnCHIvd1kMhTIZJjRFXfBjI32La/iI76KUOi0lo=;
        b=K8bMXIQldVdg5lldddvfK8/4V0Q3wQRUuflBt/uh6MUGn1EnCMYV5z1QjmzBPlJxjD
         y2niN/BWCXOEXWdgJXkhtkCzqrBLHTbfizCcgjSRxqOKwADudstg22v891EBTwFcrVsB
         ecpYdWnkhRTJyV5y6SCW2E+IcEv67UCb7XkQTILW9y9/qCSn8mFDCwqSJMchLR8eL2yp
         y0PAhDaDF4sQ+fdi20HcKrjjHdYevWnEQAuIQDgoF6qx1aICtLIUeayAwik+arosfiHh
         W4kxcjalbBxea7QYfKK2Y4n/VWTOF8RHZMkyXedzLMM95mqyJcXNQMXM4Z8edGKDthdH
         qwdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737663989; x=1738268789;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hiEhNnCHIvd1kMhTIZJjRFXfBjI32La/iI76KUOi0lo=;
        b=mjFApJPx2blXO0O7stEi79KFJnaq4NV3gUMEbCH8xkLl6caBHYUCOENS6n7b1Dc8W6
         pjfBab6BFPHhkw1Cc7rJNFRtIUqArWq2HWoCmN7It0e+iODdW6nSxfKmyShVku56lOwl
         jtf7zCnsBEfMh3CpD2Z1YG4syeSB5GG7vZyTKawGIsrLZFTCoU7HQJuaqZKj85x++xlm
         cTwPc9egZx/dmb+m6t4zSAfT/T3Ekf92SGRAUjKIOVF6e2uL6k/Qe1hHcSngoCYUlPZ6
         DV1Hrr3q01pRUXjt5GqYoqbYx5RG9tOf8Lx7fFufmPcUhjTHMSOP6DYf8pPI6FcFPu7U
         ODGg==
X-Forwarded-Encrypted: i=1; AJvYcCUOGCFFg/8uLSIGmdVhnfjINWYmGm65YzQIx5nlumWQv7gFt+hoZ9RdAzx0TQS5uK0hGXWUsf7yrQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwObeFTsiczcCK7owtR1STFIkC1sGG4N40KVw4OmQAn4NNNRiL9
	68h8NQw3dqnc5FNlhVU6jUuaZy0SxWAGLBWep5hlT5mbCfOFKQ4rXe3bfNWiVMY=
X-Gm-Gg: ASbGncu4mSAIJPAixlxRxOLHMS1viw3MjLS3jT8CWwNO563l1Fc9zaXiN8Xr43T2ABz
	+vLXP6dp2oR8Th/FU7QYT3Mla6alpBcM3QvZXJYBo9I119SNLY8uVPvrvILGn+wckJp8OEPXP3b
	9820jSXesFvdk6Fij597JUFFKrlM9VUQsbjBCUtqX+UNIOeWoQ7f5KKJiO2cfPooXO+Y8cqX/Ib
	SsVKTWu1pZXWYy3X07kGvqhbG23PK2oqzWTanSh/uY4R9oSY75cv8W7TEoCbrC2fOSSpCs85WDy
X-Google-Smtp-Source: AGHT+IFcjBPLY/Xa4hYE3eyEOrKh2Os0wuPqUC3HbAyWGwOz4XCQxm0BUTtuOLLAae0AdjLSZ+8oxg==
X-Received: by 2002:a05:6e02:2161:b0:3ce:4b12:fa17 with SMTP id e9e14a558f8ab-3cf7449dae5mr228171765ab.19.1737663989180;
        Thu, 23 Jan 2025 12:26:29 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3cfc7504fd7sm1527945ab.60.2025.01.23.12.26.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2025 12:26:28 -0800 (PST)
Message-ID: <79efe5a3-00d4-4242-aee9-6cb2ccc56090@kernel.dk>
Date: Thu, 23 Jan 2025 13:26:27 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Bug#1093243: Upgrade to 6.1.123 kernel causes mariadb hangs
To: Salvatore Bonaccorso <carnil@debian.org>, 1093243@bugs.debian.org,
 Bernhard Schmidt <berni@debian.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <173706089225.4380.9492796104667651797.reportbug@backup22.biblionix.com>
 <a2194f09-aea4-4f07-b23c-a64b3dbdce42@dfn.de>
 <173706089225.4380.9492796104667651797.reportbug@backup22.biblionix.com>
 <Z4_wKuDhmbktlbF-@fliwatuet.svr02.mucip.net>
 <173706089225.4380.9492796104667651797.reportbug@backup22.biblionix.com>
 <Z5FLufDg65O1ZDiA@eldamar.lan> <Z5KhDG86fvwzQ3VM@eldamar.lan>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <Z5KhDG86fvwzQ3VM@eldamar.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/23/25 1:05 PM, Salvatore Bonaccorso wrote:
> Hi all,
> 
> On Wed, Jan 22, 2025 at 08:49:13PM +0100, Salvatore Bonaccorso wrote:
>> Control: forwarded -1 https://jira.mariadb.org/projects/MDEV/issues/MDEV-35886
>> Hi,
>>
>> On Tue, Jan 21, 2025 at 08:06:18PM +0100, Bernhard Schmidt wrote:
>>> Control: affects -1 src:mariadb
>>> Control: tags -1 + confirmed
>>> Control: severity -1 critical
>>>
>>> Seeing this too. We have two standalone systems running the stock
>>> bookworm MariaDB and the opensource network management system LibreNMS,
>>> which is quite write-heavy. After some time (sometimes a couple of
>>> hours, sometimes 1-2 days) all connection slots to the database are
>>> full.
>>>
>>> When you kill one client process you can connect and issue "show
>>> processlist", you see all slots busy with easy update/select queries
>>> that have been running for hours. You need to SIGKILL mariadbd to
>>> recover.
>>>
>>> The last two days our colleagues running a Galera cluster (unsure about
>>> the version, inquiring) have been affected by this as well. They found
>>> an mariadb bug report about this.
>>>
>>> https://jira.mariadb.org/projects/MDEV/issues/MDEV-35886?filter=allopenissues
>>>
>>> Since there have been reports about data loss I think it warrants
>>> increasing the severity to critical.
>>>
>>> I'm not 100% sure about -30 though, we have been downgrading the
>>> production system to -28 and upgraded the test system to -30, and both
>>> are working fine. The test system has less load though, and I trust the
>>> reports here that -30 is still broken.
>>
>> I would be interested to know if someone is able to reproduce the
>> issue more in under lab conditions, which would enable us to bisect
>> the issue.
>>
>> As a start I set the above issue as a forward, to have the issues
>> linked (and we later on can update it to the linux upstream report).
> 
> I suspect this might be introduced by one of the io_uring related
> changes between 6.1.119 and 6.1.123. 
> 
> But we need to be able to trigger the issue in an environment not in
> production, and then bisect those upstream changes. I'm still looping
> in already Jens Axboe if this rings some bell.
> 
> Jens, for context, we have reports in Debian about MariaDB hangs after
> updating from 6.1.119 based kernel to 6.1.123 (and 6.1.144) as
> reported in https://bugs.debian.org/1093243

Thanks for the report, that's certainly unexpected. I'll take a look.

-- 
Jens Axboe

