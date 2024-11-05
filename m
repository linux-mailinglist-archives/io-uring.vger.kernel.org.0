Return-Path: <io-uring+bounces-4448-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AAB4E9BC26A
	for <lists+io-uring@lfdr.de>; Tue,  5 Nov 2024 02:20:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC23C1C219A2
	for <lists+io-uring@lfdr.de>; Tue,  5 Nov 2024 01:20:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13E6A168BD;
	Tue,  5 Nov 2024 01:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S7imEkVB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6467518643;
	Tue,  5 Nov 2024 01:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730769616; cv=none; b=ZE5MsqVBPU7GjU3RTxyrZxRvVyQRC97DEaZm7/leMRa/vs4Mp+/nonFKQB00DX6uawqaLa2o/qjvfnQKICdHCdVJVRxA/E+bkr8jKpG0m2aD0jdI/uqbUlOH2ceIG+kCD9XwYQAqjxS+9495mN7ORlK9P4ikFh7TqbdYbtZuhEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730769616; c=relaxed/simple;
	bh=4ZeODM8skcep6J2m+GGX7dhWp6HeU31CoF2rqvPJ0z0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=tgUZVGlVIIXHytBPq5CucxF441PKSlQ110sb0mvSxjuV+sqtNXOlMhfCfgoN5rZ9JTcdppN6wW0zMh56F2Dl3QQhc3LsgGcm7ufaZzmzK2eRXCVBAWNNPj+AS6YJfZm4JVuB9qDYo4L6Vo4e2Ccid3vEH6QT0VQHBmca6CRDrJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S7imEkVB; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a9a6b4ca29bso632486666b.3;
        Mon, 04 Nov 2024 17:20:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730769613; x=1731374413; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8zDOYGOJYzIB3JQdGMKFXo1DFLDaK4hziGkm1F7ZkF0=;
        b=S7imEkVB9qIaAAAcwTt++TJ0UgOGlQNg4u54UnAT210F2bCD7xqshAsQu4/+uQJJ0h
         uFZl+1vdgqmAbcS/kZ+/rGfvVYLnMwWkFctsrHVmW/5mP0Epqrffv2HQejb8ddhY9NeZ
         bTa64e5LurUNqkdANybyjzLptCtkpKhATFS9A8+Mq/x+FA3lQiwahzd/VTBqKdYnnAbc
         gSqaYwCnM66WSinWRtGnthkNibuCWCCcmIWZz7P4mPE6Eszi+J015zt5cfcMv+Smgeqj
         ugzBl5DLc0e74P0ko0riBk4/4HJfQ+gD6KNOG1qkHzWpnZI5Rdmm8l92Olf0/pzayO+Z
         /VmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730769613; x=1731374413;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8zDOYGOJYzIB3JQdGMKFXo1DFLDaK4hziGkm1F7ZkF0=;
        b=mbDCUGxkp1loi1irZ0v17g29+8qxForlHw5ZWd0KmCfX3zA3wl7tMvmOutlRMuU1bp
         dmpA0Bp78zs27na0srjCPebJpxxkBtxGm/0eu24cctaeJnm8nG9DDQha06COnu24SQcz
         yqBZTPCYggAOa5W5eNztV1bSVPvXYDYkCQ/vqemBYZrWXBdJKWBUEBPVKyYcPInjr4+j
         9ffbi1lv1AinPBub7ovzz1JuzqmuwhNjj1Pa9zcDwGnib5OSVtR3MT/x/pn1W0zQKhpg
         2rx3/Ds2CHi8O4VJg+k7TFveRf3J4R2KguHBg3Wt+LGsJ8QX1U8Udyvy/30ykH+KBHnl
         r45A==
X-Forwarded-Encrypted: i=1; AJvYcCWDL9uQU+JBGaLNJM2SQiHbtz2jvHY7jSENUITIQvP1qNLgpKAYQhAstQ8St7mVdhXUS8VtFyiUXDpo+CvF@vger.kernel.org, AJvYcCWluF9v3q4PXFjkyMdEto/eKo8chyaVpm3T9Ba0iF4spfMwbtdoyaV1PsDNzFLCGeUyj0NkyRAUtw==@vger.kernel.org, AJvYcCXWezvpnqYKc/4dvPeo1sJvRvZcXJHamDRAAKBfifd/8+APR6a2M/78esdPQx2An6KqOlvT4I2d/HFK@vger.kernel.org
X-Gm-Message-State: AOJu0Yy95+EkFeEEszbhPlCUKckSBpaGKxLm85+7XnTL0hq6X2SVjIPx
	9v1T/GOoc6XYCseLO3NXeXVsIFuOcotV2IhCQQbDAwoe1bbppj2ZWZ++sw==
X-Google-Smtp-Source: AGHT+IHT2qm2S6k5VB5g9yg+m4lEHMLIGG99uLnk4+glboo+zNf/MBRl0/XDlh55wrA8zQGBLAeEAw==
X-Received: by 2002:a17:907:97c9:b0:a9a:eca:f7c4 with SMTP id a640c23a62f3a-a9e50b9e2a8mr1643037566b.54.1730769612361;
        Mon, 04 Nov 2024 17:20:12 -0800 (PST)
Received: from [192.168.42.95] ([148.252.145.116])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9eb16f8e2csm54116366b.91.2024.11.04.17.20.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2024 17:20:11 -0800 (PST)
Message-ID: <768a51d0-8c63-4d9f-a636-c9cb52a0c4f4@gmail.com>
Date: Tue, 5 Nov 2024 01:20:15 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] [usb?] WARNING in io_get_cqe_overflow (2)
To: Jens Axboe <axboe@kernel.dk>,
 syzbot <syzbot+e333341d3d985e5173b2@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-usb@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <6728b077.050a0220.35b515.01ba.GAE@google.com>
 <13da163a-d088-4b4d-8ad1-dbf609b03228@gmail.com>
 <b29d2635-d640-4b8e-ad43-1aa25c20d7c8@kernel.dk>
 <965a473d-596a-4cf4-8ec2-a8626c4c73f6@gmail.com>
 <16f43422-91aa-4c6d-b36c-3e9cb52b1ff2@gmail.com>
 <e003c787-71b5-4373-ac53-c98b6b260e04@kernel.dk>
 <09b7008b-b8c1-4368-9d04-a3bdb96ab26d@gmail.com>
 <0daae856-a3c6-4eff-95cc-e39674f24d41@kernel.dk>
 <74004a91-2753-45fc-88b4-8b2103f9a155@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <74004a91-2753-45fc-88b4-8b2103f9a155@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/24 17:05, Jens Axboe wrote:
> On 11/4/24 10:03 AM, Jens Axboe wrote:
>> On 11/4/24 9:54 AM, Pavel Begunkov wrote:
>>> On 11/4/24 15:43, Jens Axboe wrote:
>>>> On 11/4/24 8:34 AM, Pavel Begunkov wrote:
>>>>> On 11/4/24 15:27, Pavel Begunkov wrote:
>>> ...
>>>>> Regardless, the rule with sth like that should be simpler,
>>>>> i.e. a ctx is getting killed => everything is run from fallback/kthread.
>>>>
>>>> I like it, and now there's another reason to do it. Can you out the
>>>> patch?
>>>
>>> Let's see if it works, hopefully will try today.
>>
>> I already tried it here fwiw, does fix the issue (as expected) and it
>> passes the full testing too.
> 
> Forgot to include the basic reproducer I wrote for this report, it's
> below.

Thanks for testing.

I was just looking at the patch, and the fun part is that it depends on
failing tw off PF_KTHREAD tasks... Otherwise when the fallback executes
a request the original task could still be alive =>
(req->task->flags & PF_EXITING) check passes and the request continues
doing stuff from the kthread (with no mm and so).

A side note that it should be marginally better than before on the
cancellation front because we're killing task_work more eagerly
for a dying ctx but alive tasks.

I'll send the patch properly.

-- 
Pavel Begunkov

