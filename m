Return-Path: <io-uring+bounces-6952-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9143A4EE78
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 21:34:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3FFCE3A6D82
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 20:34:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A30A31FECB4;
	Tue,  4 Mar 2025 20:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MKNm3Z+w"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72231C84D7;
	Tue,  4 Mar 2025 20:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741120489; cv=none; b=I94HSsMu7BvgHty7Q60hoeglkBTiHZNZvBy4Ee/r3sm6cADIBYOkYZAn2VpZLMiYwO8w7pcBS0C61Pm3F0v4zmJrmxbgjo6fQUE3TUdV5VfU4kWt1QxHnk4Pi3oegvbzvSXkl9ePbjxgOIqP+KIJreozgyqtUJOVPdAnVLvoXF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741120489; c=relaxed/simple;
	bh=WG40JMgu7qnNOGjeYbRiWyT7jf1vKrTHwIBXxd2W62Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P+a2lRjec5vpjYWx8lzZLHdSiodx4jFmYAChJIRYq1l5saCA0cnyHZ/AnfJaxoWkkPpUNVIS5jkJsyWYGlX+C6j2SpLIsOscp9kBQi9m16N2Y1dnVrshFfsN6jSlmZC0vAM5urGV0r2D4ouihgTSJVXbyEEof52gYJ4BnhlvwiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MKNm3Z+w; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-43bcc02ca41so10528985e9.0;
        Tue, 04 Mar 2025 12:34:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741120486; x=1741725286; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9ytSAFB7r08STnGv+xSQjPPK03KcMs1RuQclhSrmGN4=;
        b=MKNm3Z+wRE/IrV2LXBxkp9NAMhUoGIijm0LMKfTCmkw1tl8VK+bJt3OQhF0knxwsaI
         AyEGcerffUPufov5jVdShwO6uxMqb3Wv5BDCZ5vYEniy5RRjp5kuZg2h3SL5hJF7E8lQ
         0OlONzLU/ZncDNkZCYwydr4ApIMLHPsJ9KgAhXzErOolIx1GrANsB2RnfrNI747SB5Y7
         xCOx4tD0iCJ6GrfAZxLInKl7Pf/1jTkSc8UL2fdb49nzRTYpJg9mokCNKRcp6I3rUV4s
         9EKxH0C35rGgHewxAzbR9IMtRa9UJuOsxfSijoClz6M0FzHuZGrN3UaP8iWhbuVidq33
         4sOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741120486; x=1741725286;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9ytSAFB7r08STnGv+xSQjPPK03KcMs1RuQclhSrmGN4=;
        b=QKlb5jL7waGeFZoFh3Uq9z7lfrZpYgQuyFxXw3/lgmqYa83fz3EvOXDcynqsvmQx0B
         1fhBK92Ep2aj785wBJ9nXUp1h488yhHfHkcWuJYRTj6NkI/5NCnVK9FTLl/g7bSLujt+
         IHdk6K/TAkXZCKQbOIMgBMLCv+hBlOqP9j14OBZb61V2P2l9nSMm0XyHf8/0xySRamQu
         lxHIt8P/cbEojFXjwKfWGbEznM0ZsXWUwHMWjgi5LIkRnlUqUecYbc8Sd+SCJJH7duLX
         eilswQk0C/KcInMSLl8nQ0TDrtvUmLGWFCamkPBIKz+bXzMiuhgshfm0EIVjYrjQnnvZ
         MTpA==
X-Forwarded-Encrypted: i=1; AJvYcCUviyHcTjDiQ7AxI+pVsprB+Z8QL8lRLO9cPcIE+wKYbuZ8q1SmstM4HVZ9dzqIuddqMPD2ao0RJxAl@vger.kernel.org, AJvYcCVekx61bIr4iuvdw/Oy4LbC/emAZGKhWTPF3Bd+LsDammkHFn9uytCpUJS/Wwfe4ITZPCcENIXQZg==@vger.kernel.org, AJvYcCVj7OGV6I/CjkNNIE8M+oRyJ3IMFXzm+PNbfqS+JzfQsKMYJmzkludLmMGYw4wP/+Iy1nC/HO+ROkuyMygXUw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyco586kH6l3Nz4sz3HoH0PJbDIEw3h1JGEpOhOd4NoRCrZa1zR
	+/f02zolpqxzVp5VCJphRF+cbyKE5y3Y08Kd49+Y+0O7ZkWE4q5y
X-Gm-Gg: ASbGncuztFpWYrMnkfgwEL6UTzDD+gZaMbgE9w2FRD5Cs9068bCJBu6apWcFnfACj12
	LK8jkq6iH2sSgiJWIENdEaZF7UCq9lgaxeTxa86FNo3Oc0rOT3eLs30oiLG/c8r6GLJZ1I7nB42
	QI6zqNuwvRUovzGIoWQk2KcLg8OYLXxzqP4fHdmZu5uuTKEjT93bF2OhgvL5AEthT8P5QoFS7N6
	qHuHbCs9C7kESaihn//d0rRlb7xmj1mb5eTpVo1sEmvrdlDUKCyvUJ0Vq9KEczGZN/UlAIG0WVj
	09qxfG/6FAERy6CmHpJqaLveElizP86HE4sCEupMPGLF+QNwQvzWCw==
X-Google-Smtp-Source: AGHT+IFnvdHnyWlh3F7RwpvlXkZj4P1PRoUsZ0nd3YffzH6SKeXU6m7JfPdCNnphnPjV8lHCtPksOg==
X-Received: by 2002:a05:6000:1fac:b0:391:1473:336a with SMTP id ffacd0b85a97d-3911f7a8508mr196747f8f.36.1741120485769;
        Tue, 04 Mar 2025 12:34:45 -0800 (PST)
Received: from [192.168.8.100] ([185.69.144.147])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390e47b6ce3sm18374445f8f.43.2025.03.04.12.34.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Mar 2025 12:34:45 -0800 (PST)
Message-ID: <6374c617-e9a3-4e1c-86ee-502356c46557@gmail.com>
Date: Tue, 4 Mar 2025 20:35:52 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] iomap: propagate nowait to block layer
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
 Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
 Dave Chinner <david@fromorbit.com>, io-uring@vger.kernel.org,
 linux-xfs@vger.kernel.org, wu lei <uwydoc@gmail.com>
References: <f287a7882a4c4576e90e55ecc5ab8bf634579afd.1741090631.git.asml.silence@gmail.com>
 <Z8clJ2XSaQhLeIo0@infradead.org>
 <83af597f-e599-41d2-a17b-273d6d877dad@gmail.com>
 <20250304192205.GD2803749@frogsfrogsfrogs>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250304192205.GD2803749@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/25 19:22, Darrick J. Wong wrote:
...
>> Assuming you're suggesting to implement that, I can't say I'm excited by
>> the idea of reworking a non trivial chunk of block layer to fix a problem
>> and then porting it up to some 5.x, especially since it was already
>> attempted before by someone and ultimately got reverted.

Clarification: the mentioned work was reverted or pulled out _upstream_,
it wasn't about back porting.

> [I'm going to ignore the sarcasm downthread because I don't like it and
> will not participate in prolonging that.]
> 
> So don't.  XFS LTS generally doesn't pull large chunks of new code into

I agree, and that's why I'm trying to have a small fix. I think
this patch is concise if you disregard comments taking some
lines. And Christoph even of confirmed that the main check in the patch
does what's intended, i.e. disallowing setups where multiple bios
would be generated from the iterator.

> old kernels, we just tell people they need to keep moving forward if
> they want new code, or even bug fixes that get really involved.  You

It's still a broken io_uring uapi promise though, and I'd still need
to address it in older kernels somehow. For example we can have a
patch like this, and IMHO it'd be the ideal option.

Another option is to push all io_uring filesystem / iomap requests
to the slow path (where blocking is possible) and have a meaningful
perf regression for those who still use fs+io_uring direct IO. And
I don't put any dramaticism into it, it's essentially what users
who detect the problem already do, either that but from the user
space or disabling io_uring all together.

Even then it'd leave the question how to fix it upstream, I don't see
the full scope, but it has non trivial nuances and might likely turn
out to be a very involving project and take a lot of time I don't have
at the moment.

Darrick, any thoughts on the patch? Is there any problem why
it wouldn't work?

> want an XFS that doesn't allocate xfs_bufs from reclaim?  Well, you have
> to move to 6.12, we're not going to backport a ton of super invasive
> changes to 6.6, let alone 5.x.
> 
> We don't let old kernel source dictate changes to new kernels.

-- 
Pavel Begunkov


