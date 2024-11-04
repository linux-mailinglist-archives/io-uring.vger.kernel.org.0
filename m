Return-Path: <io-uring+bounces-4432-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BE339BBA95
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 17:54:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ABE9F1F22467
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 16:54:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A20871C233C;
	Mon,  4 Nov 2024 16:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H34XPcFN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6E51C232B;
	Mon,  4 Nov 2024 16:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730739242; cv=none; b=YZrdK7Ly1zrJgRgCzGae1tRMNzBdOJA7HgPZeCE/NUfdVvQS2YVN4EvFNKj0jFlUTdAlsN9Bxna0WUXwEZo7YzNRdFWWGwXxLKZYxHZhkjkMDxd3jvjjy3R/q38XYhGn71VAm5Jca6GglcARd8HkkAZ1OR25cKbNo/kwpEgrhjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730739242; c=relaxed/simple;
	bh=YOB8n4D/He926EhIDMQcEt5yNMscrw6BO60Ek5hqPyI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=haB/zivyreCSswvObAzl11Kos4XjPLFg9NBWL2sfDbj3FqjAuBHEY1YMu0CK8E+pWjoe6fL7/Xq8KqUX/JYmaxCtFAALLT7Pczaz3tmmx62AzACBn1tYEdvPy5mDrmW5lM5A4qmODyS36iUV4EcngLadWzga2ot8lonjx3Almg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H34XPcFN; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a9a0c40849cso797704966b.3;
        Mon, 04 Nov 2024 08:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730739239; x=1731344039; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+7nRYR/2twlj2QlRClikfFGq0XOQg6xUVkylrGyMp54=;
        b=H34XPcFNxoaG01vM1wohfCNklsKRyaXTdQGO8iwhoWLSzrvvjfU9flGug/sI/Mj/c/
         gsx30leu+xXqJajCjzXUFQPFNaZphjFt2FwRHkPLkGkRmZoVgF7X/vIyStk1REyEpVRt
         +K7/BYDpmgHlk++9evWXmlxZ2eMNRUyRPUJaCGhRijHuJ50i+vNsmmxxQ1qyZ51Hwehy
         NfX3OWDcLCC4ccaLVrlSt2H+E+20xT8QJZxvm97bNxMyqan4Xl3ULxIPo9pytppSYSTs
         vSuy4FAqSaNNUUjgKeUo3R2l9AbN36lCvhzeIT9FhF/m3aHV3f+Fu+uSZDzmh7zFEBAU
         S7Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730739239; x=1731344039;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+7nRYR/2twlj2QlRClikfFGq0XOQg6xUVkylrGyMp54=;
        b=ek0Mi114YBhIlzvroCOqjCR89TlZRy3vv6fv20DdMoKGLDJNqJGmTsLLge+FZbaAhx
         bj8gASBONNxYzEKUTfDchlYnn6pT+wbALZ9zeESHWCdvQwJTtVpwxRfHOb/s5Y7hPlw4
         qnrXsT5mhm/KQfoOdBH4O4gIM8vu+JVuOjRGrJvZ6HgZj9y/TYwd/Fg8Kvna8HSGH7oh
         X0W0SBt3ppNl3cyKEZhX5E8L4PgdLz6ggAA9FQJEIk5YsPqQ/hzf4jNVWMWC0TACJr3z
         44nL/N/Te+NSJGBTc3BfYE2V2q7dLy9MjjioCa/MrvZ2By/fBXQaEEsXBGV7mV65O30N
         vXVQ==
X-Forwarded-Encrypted: i=1; AJvYcCU0z0KECVOe3LnXFnJ6FQ9fHZ4chcsENpDmxCvCllhaBdyOHFZs0dhA9VboevoKPUotbOEXWS+NYM17@vger.kernel.org, AJvYcCUQr/dtpKkKwgS5SzTWIk/+J1eqt4jU+9Z9CSP0t3ryaabsGXvkWfMGm9A1q1+uL1gou4Fto2+z0A==@vger.kernel.org, AJvYcCVLWvOAT8C4Tav3Z+LngG8pmIj+aatVwkjmfAh4ZbL65cuBujtLXuFuA713RyUhrvU91teuhS1WzshQE0Ld@vger.kernel.org
X-Gm-Message-State: AOJu0YyBu8j5GPJMmiPdzgmsjGhhZlclGJv7Of7ssdj+DavxsQsqGJYN
	mRI6RqrNgBu1/OdnFCMqr06FwkFk7yhcP7Rk9wGhwwcbwPQa8XOt
X-Google-Smtp-Source: AGHT+IEYPdDn43d8xifNgZC0HZIApp23fKzpF1IK9yBHhD8L7WCiQY/joNPOetwS2383jK7J7zAT9A==
X-Received: by 2002:a17:907:d851:b0:a9e:b08e:3de1 with SMTP id a640c23a62f3a-a9eb08e4023mr28483666b.36.1730739238761;
        Mon, 04 Nov 2024 08:53:58 -0800 (PST)
Received: from [192.168.42.71] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9eb17cf8e3sm4303566b.124.2024.11.04.08.53.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2024 08:53:58 -0800 (PST)
Message-ID: <09b7008b-b8c1-4368-9d04-a3bdb96ab26d@gmail.com>
Date: Mon, 4 Nov 2024 16:54:04 +0000
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
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <e003c787-71b5-4373-ac53-c98b6b260e04@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/24 15:43, Jens Axboe wrote:
> On 11/4/24 8:34 AM, Pavel Begunkov wrote:
>> On 11/4/24 15:27, Pavel Begunkov wrote:
...
>> Regardless, the rule with sth like that should be simpler,
>> i.e. a ctx is getting killed => everything is run from fallback/kthread.
> 
> I like it, and now there's another reason to do it. Can you out the
> patch?

Let's see if it works, hopefully will try today.

-- 
Pavel Begunkov

