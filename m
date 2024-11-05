Return-Path: <io-uring+bounces-4447-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AADE9BC255
	for <lists+io-uring@lfdr.de>; Tue,  5 Nov 2024 02:08:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE1DE2832AD
	for <lists+io-uring@lfdr.de>; Tue,  5 Nov 2024 01:08:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A90EB65C;
	Tue,  5 Nov 2024 01:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J2TS/Ou9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC2F179BD;
	Tue,  5 Nov 2024 01:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730768913; cv=none; b=dk7b2YN4L22gAeEHu9rpboclwbmyw2MpDWSuhYg3sRnsxInjKouwa4qF+eS0y8Kt+v5+IULYlpleCI/Zx0JGLXc38QvR0BVRxz7W27k6bhK7ikJikRQU73soxSytrSymaNqPIi/31T/Y7gIly55a/91UWdzuFDUnyHl8+idV+p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730768913; c=relaxed/simple;
	bh=hHvdRdW+fW0pxpAILcBUaFPFpkUuiFqOD3AkfLtzT9E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WvekUU56g+WSjblXiCgnrEhDgEvpU5KzN6ow3GZZxWoWvLzH0fXhbMvjfaG3/Vc3ovQjYDS/JxwIgmbwo3ajoZbNvRiIFLsI04e+l5qi9uw7TxD9gFNe9PVLzjK6IgTN44T939yO574ofIHeI29ANxgWbDvvQ7qhluWnQ5/aN/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J2TS/Ou9; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2fb51e00c05so71038911fa.0;
        Mon, 04 Nov 2024 17:08:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730768909; x=1731373709; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vwYy7nSlZB+y8B+kMzEpNFJDHLv1rFCOnF4tjya76lU=;
        b=J2TS/Ou9Ey3JsTA9ILEwMHwTu0rzRJTwi5PgoKW/VGNeBv2FcvY1oE81EYGCsZwqMz
         4Msz9JSTsq9GjZcYsBjI7ml1RzXM7hELkXenhFo7PnTXerlvjVFaLSVG4I6urQLeGpzT
         /o4K1IePfgw1ak8mPZRvwiH0ePtkzNdtz+E6yGtSwnY0laRbWUYqtU03OoOgIQYyrcIT
         d5XHRwhc4Pd7jYMwBtGvIwz4xX9wVgAYiRrhhltCK+mEYdVJiBewX9A4C3JYf59X/a0Q
         xfP9RY6P4HcBX1Dhv0pcT16C1ZARp1HETmrgWOf+l98DSt8PD26CyMrF4pJt0V0+vSAn
         gyrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730768909; x=1731373709;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vwYy7nSlZB+y8B+kMzEpNFJDHLv1rFCOnF4tjya76lU=;
        b=DDssHikTV3VUQ1M3qDvfqgTJuC5UaHd7ZeJqREE1XX2wxO4qQig7Tzw3Fx4GOqTi3Q
         ve6Rzygbt1YFUh230TzXLhpqnJ98kvXacg0gdbzrLSvWJXIqstQJt4Z2NYZDgebD3M7F
         yrXfYyYLNbP+m3DDCh250d7YAg5VqPW3t/EM+pgF1TMDJTYlEVyRl5+gDtPc+XE71wBb
         TQk6DQIp9N8prAPDaYhweFGyR4HEx9vXyRHlwemhd5q/QiTEjAnpHrZP+n4403KJ0Z+b
         qo3HJ5Qaf+fhvTquGsIOjGVmevTETJSW9S7ix5gBc7e3da9EWDxhjkRL2Le/Vt6k3g18
         8mpg==
X-Forwarded-Encrypted: i=1; AJvYcCVkGSV/vfJhETNgh0HW88YJJhmGK0N+L9Xg6rFEfcbmgCCgpLtZWy6vEGW2Szt51EE+LM8z73M2DZEU2HCa3Q==@vger.kernel.org, AJvYcCXOxWXb4hL5T2wjjzVdSXBIJ99ZsfBTLjVv/sCY3BAQfEXWlRvJPCZk6eUjHSs9LKB6dK/hgbvIEA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzxc7P8+nuSIK8jvfF7YB9sEFK2gfgnIeXLhkkzVfPRnmy+9HnV
	dp8sKMaSdKdezp6hdQHhbt8+BR/WezRLJxj8zHb4l3CZnYNqzLsXNhm0AA==
X-Google-Smtp-Source: AGHT+IEefNDP2MM+aZtaLaoLaLazoX+zbAA0eH21KIr2yO+DX7/LRtKFxzaTJeMO91Eb0ysts5j2jA==
X-Received: by 2002:a05:651c:1506:b0:2f7:6653:8053 with SMTP id 38308e7fff4ca-2fedb7c72d6mr98770141fa.18.1730768909156;
        Mon, 04 Nov 2024 17:08:29 -0800 (PST)
Received: from [192.168.42.95] ([148.252.145.116])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9eb17f92ffsm52744366b.141.2024.11.04.17.08.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2024 17:08:28 -0800 (PST)
Message-ID: <f8e7a026-da8a-4ce4-9b76-24c7eef4a80a@gmail.com>
Date: Tue, 5 Nov 2024 01:08:32 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 12/15] io_uring/cmd: let cmds to know about dying
 task
To: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 Joanne Koong <joannelkoong@gmail.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>
References: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
 <20241016-fuse-uring-for-6-10-rfc4-v4-12-9739c753666e@ddn.com>
 <b4e388fe-4986-4ce7-b696-31f2d725cf1c@gmail.com>
 <473a3eb3-5472-4f1c-8709-f30ef3bee310@ddn.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <473a3eb3-5472-4f1c-8709-f30ef3bee310@ddn.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/24 22:15, Bernd Schubert wrote:
> On 11/4/24 01:28, Pavel Begunkov wrote:
...
>> In general if you need to change something, either stick your
>> name, so that I know it might be a derivative, or reflect it in
>> the commit message, e.g.
>>
>> Signed-off-by: initial author
>> [Person 2: changed this and that]
>> Signed-off-by: person 2
> 
> Oh sorry, for sure. I totally forgot to update the commit message.
> 
> Somehow the initial version didn't trigger. I need to double check to

"Didn't trigger" like in "kernel was still crashing"?

FWIW, the original version is how it's handled in several places
across io_uring, and the difference is a gap for !DEFER_TASKRUN
when a task_work is queued somewhere in between when a task is
started going through exit() but haven't got PF_EXITING set yet.
IOW, should be harder to hit.

-- 
Pavel Begunkov

