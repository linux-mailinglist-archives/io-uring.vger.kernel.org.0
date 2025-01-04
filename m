Return-Path: <io-uring+bounces-5674-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95642A0170E
	for <lists+io-uring@lfdr.de>; Sat,  4 Jan 2025 23:12:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4EE133A3AF0
	for <lists+io-uring@lfdr.de>; Sat,  4 Jan 2025 22:12:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6FA8157A67;
	Sat,  4 Jan 2025 22:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mXWbk+7H"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04F81B87FF
	for <io-uring@vger.kernel.org>; Sat,  4 Jan 2025 22:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736028741; cv=none; b=l4wc83yiDEC8ro5y18I3d5h/DRIGUhT3nez6tZbz35d5KlHwB+GKDMeipJIaUnLt6zLCqDw5M82eg5jRv91VPxbLPfG8e/q8n3HLHhFkP4PkRdaoHZzfJrWY4hybR6RR/ot5s+bDLwZbq5VTetGmCjvnXqODMYr1bwKyW/o4AJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736028741; c=relaxed/simple;
	bh=ot9pg54Qf4Vjr9KjPVMaj6cog6V+6Th/KrKhtazCJOg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q177ExZ/CSKnH4WYjXvaTKgt1wDpYTlRt/RE0rCQZcbNOzh9cF4GSikHh+UMpYsaWwGzqhtcXC5EGm6TOt7Iu0wOFdJ9U6CsvI76qhQGsihCJ6Fa2+2UXmybL7NrioPge6Wp8czno7DHLz9EBN08lwXMnOJaXWC2oAM/VWfiKyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mXWbk+7H; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2ee74291415so15318252a91.3
        for <io-uring@vger.kernel.org>; Sat, 04 Jan 2025 14:12:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736028734; x=1736633534; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VOwe0Oqj8dtcyUoMuTRNorQ4LyH3rHYONRCI2ZTsRqM=;
        b=mXWbk+7HeKKRaBBd5Gf6zlJyiNtmvVIZ8994hZ36H/cef31VzD85pKorTzUYcpK+V0
         UwINFG4qOU2z8tXoV+6WsIq6HkmYhICoKfX2DHzYDfrZMUNBELP3vQlOgsfOfCURUtwf
         M/aU36JYVEs84LrJ0e1B87HHsbBZM5jpQfhb6wY4M/MB0UIB+qzBcIKwT0MTAOZ5zF9K
         HRHbbFTGxYzDUVElJmesSHjHcs3OMfeAtgCMUH4oZzivwT8CMMWdjWpFwaF40brmlGw6
         o4UAvyOmgBtW65SAbasb5AaSzIB/jQ8hDATcWkYIyLKD6BkM5fWkZIgOazV99kM1AFi0
         325g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736028734; x=1736633534;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VOwe0Oqj8dtcyUoMuTRNorQ4LyH3rHYONRCI2ZTsRqM=;
        b=UbCKTtmtfH3NboQqz6fIpjxFvOZGxhcOSGvbyEBUr31cJh17n7fidxlMvQJ7TZKv8n
         Z39Bdi90kMYBxHO3O4vP+WDbjm/GosP0/r/KGzfbew4E11eoIRER/OUfmN9FSIOPi4Yh
         f2Q6R/W3TJkWGXjPinOgNwAzj/WV84/lfJN6EmW4097NOvMs2CzD6lRwoGgcpeQK5zQ/
         So83UmZuznGb9PERBkXTiD1EVo2vgWTLBGk6pCGwXy48XInWDXIS38kd6gYhSLXQPWAy
         8pZten+XdytzwArtaEhWO78Hhw51f4w1Q2yH8bvtNV+57a4G4KQFUk2WoyQjyc2T9tkf
         N4gg==
X-Forwarded-Encrypted: i=1; AJvYcCXXP9uUWw2ZzAvqjTdCXlBAju/3eu8wscbZ6qCzWm2RqBSAaPXlgfGKJl6SVi0e4NiEzZYH2o8HMw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzrl3eiejhzphaRB76JZYLleSMZLRdjp4PAOy0lKC732D0wVr/H
	6wUdkVLBlXtc/nkuNMZX4iLP5cvJrTcQOpz2Ap3pd0+dSJtdmAZ3nmyu/4GUIxU=
X-Gm-Gg: ASbGncvZdfTc/nZ6mBdXNJfMg7PZttnetiLodDSoJOsHrtgXl1Q8DWtOfq1a7Sahik0
	+qqC+jcI9kK7SqpcFyANkAqTRAbbDIjdbsmAeX1Tes5aLzrjPcI7Vb9IDF+LyKzREFJabTkrvAV
	VtRAZ4qcSJdDObpdCLI+Xe8U51/WVsV+9n8H/qFHKqP64Kn6Z58Yp+YAP904wfepyR39LKfEFES
	uqysZpBzraPRx5ckHA2QgsmH1/kPW16Tr+1q/gJVCNlby5xc/6U9A==
X-Google-Smtp-Source: AGHT+IE18XZvBMN/ZyNZzz/JKyxRdHbIPIDOGr1uIv7DY8rLZ3YWrJIU6FJm2aPV6wA+8bwPQj8Oaw==
X-Received: by 2002:a17:90b:5247:b0:2ea:4578:46d8 with SMTP id 98e67ed59e1d1-2f452e22c2amr81991855a91.9.1736028733734;
        Sat, 04 Jan 2025 14:12:13 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f2ed644d87sm35872730a91.27.2025.01.04.14.12.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Jan 2025 14:12:12 -0800 (PST)
Message-ID: <a0209280-e4c3-42f6-bd40-d135a1716ede@kernel.dk>
Date: Sat, 4 Jan 2025 15:12:11 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/timeout: fix multishot updates
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: Christian Mazakas <christian.mazakas@gmail.com>
References: <e6516c3304eb654ec234cfa65c88a9579861e597.1736015288.git.asml.silence@gmail.com>
 <e37db82f-6ed0-42f1-bbe1-052c64c4dcd3@kernel.dk>
 <c9b2283b-b1ad-4d7e-8042-98fa9908d9df@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c9b2283b-b1ad-4d7e-8042-98fa9908d9df@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/4/25 1:44 PM, Pavel Begunkov wrote:
> On 1/4/25 18:39, Jens Axboe wrote:
>> On 1/4/25 11:29 AM, Pavel Begunkov wrote:
>>> After update only the first shot of a multishot timeout request adheres
>>> to the new timeout value while all subsequent retries continue to use
>>> the old value. Don't forget to update the timeout stored in struct
>>> io_timeout_data.
>>
>> Nice find!
>>
>> Do we have a test case that can go into liburing for this too?
> 
> Christian has a patch, I assume he's going to send it
> 
> https://github.com/axboe/liburing/issues/1316
> https://github.com/axboe/liburing/commit/3a5919aef666bdf0202c76918dbb85f1a6db9a32

Perfect.

-- 
Jens Axboe


