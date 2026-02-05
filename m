Return-Path: <io-uring+bounces-12059-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OEseNtXdhGkV6AMAu9opvQ
	(envelope-from <io-uring+bounces-12059-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 05 Feb 2026 19:13:41 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DC45BF6651
	for <lists+io-uring@lfdr.de>; Thu, 05 Feb 2026 19:13:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 11B0E3002D27
	for <lists+io-uring@lfdr.de>; Thu,  5 Feb 2026 18:13:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA14B3081B8;
	Thu,  5 Feb 2026 18:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JMRJfTvg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B1B3016E2
	for <io-uring@vger.kernel.org>; Thu,  5 Feb 2026 18:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770315216; cv=none; b=S2WfyZ6GVwZNoSanc2o2PvE5zUowlRDHjEPDN6C1o4z8FAJceFgKbo3lOfE0Ya/zhI6qkiGxKkFWp8rY89iwXOwvS0BaSX+A7bHSJzRCNKCBb77R3BWs1rD8hb5pwAXR0MlvaqSaq9w2cRCVToHiPTOQSJC+m6BzXDGEngyKbjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770315216; c=relaxed/simple;
	bh=o/o1F1p96xxSNwlR+KUbEXWGnJNwQJAGUizzA2xVzBc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=onY3YxsHdX7uBAK4q0/cPd6bBfREIbK95TLFZMSotbJ0ocJbYdChk3vFEfvhgo2qBwDi6b17Up3F6OAgPw+fvU5sClSsXVB667exWyjK3+ze716BN86Ch3/0kqW30lyI1iD4for+w1w1hjDZPBD4M6KcoTBBVvIXuD6tXlNG8wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JMRJfTvg; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-482f454be5bso19437975e9.0
        for <io-uring@vger.kernel.org>; Thu, 05 Feb 2026 10:13:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770315215; x=1770920015; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tOIgzh7F0/asMA4wYQkOAKt2bxR52YWhKTa5Hn1hbLY=;
        b=JMRJfTvgHK4258VXuMgLxrXiRjiSJnQ/B/YJAF3SwPm/SzwDDwp0pUoJEVuHtWWJEK
         u6TbYtFofMI40OTP52gBjcDuju4NTR8gmwulkoaNLWEHZp1HuB9Hi0i/vtkleMIk3Bog
         TgTKwZnn5yOB4xreLHTsYJ+LEeFM2cPlv+7StToff0Y3ko5i/FWY/p+323tAbbVIdsZD
         k5FNyyqrsevzJIxtCpYAcFFPxIbSLZEWSXvSttSfTDDoiTsoi+RuOeAiDySpOE1Tw81s
         j5JbrnY1O7OXyNV537qD1jtyrhi149wEM8nDOv4V8OTmZN5pJe9KY214kxTf8YwJ5eLJ
         S+DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770315215; x=1770920015;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tOIgzh7F0/asMA4wYQkOAKt2bxR52YWhKTa5Hn1hbLY=;
        b=CZbw8+9NbchM+IdPiWqI2cZZe0E3EUWXg16YqdEpGSPU6DytuLx37dz6Sn/iipemiV
         a72zmhlj4JqnpkZMP0l4ZPrFa9gzXlZb6YKNbF2oAzrWqsTRabeuwTxlCmVZoMvFfCwT
         BO/mwGuBI4DNrA75dbxJNE+Ods1CLCrlDz4bdnj89w8I7CyjxJ6TrADO1qOiecxYBISw
         FsXS3zzF4vVKzfDOhyND0IAJSJgL5ZPLqoxhH/crSgHYXxRtor/eZE61E0eoj8aOQbkK
         lnOwuzJtahHTzVQxjXaNK5LJqgPKm6Jy3njZJoclLDO+vV5nRCGGvRnTw0oV/xXAmmIY
         rztA==
X-Forwarded-Encrypted: i=1; AJvYcCVtOU0GNcqFd+hUVNeOJeZdORlOSBLvrdcZdieztJzIOXSaQ/RbTAlF/35wTYSLGWTpFYJ8vY7Pog==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0YZW6v3JQx/3mXcjvdWlpD/t8YgNnqYYcfL00gEviDKzw13IJ
	mVmA86LZN2MNrqKCJx4nPdgR/KnBvzn9KPDcdzcDiV8BXNxRGVEP6CVCsoe5Zg==
X-Gm-Gg: AZuq6aJ9u/gp6MRqX2i7exuGXS9EUflrqUYJE3bCbFnxRy2FiN+Do0pQaozHWU0Mm+L
	MQ9aS+8S+qp9kGe/b3dalK8Y82nte/FjDGaLhWADqAhX+wW7jO1tPshm+qXngJ/wrkaKvgvAFnw
	1EGwBnGtDbYWxpRZ7stoXVRplzJh3+EP0Jz0VclvgfXSQZG7L5fJLtHcpAQHKJLcZ3YO4nEImoK
	nmFebDjmCTf+tq8heWj0vqsr2wlcsAgKNSI5SxmiQpxBhUZr2yZsujav2W0rYCWOcLeV627Dx9t
	1PW5KNb+VBB4fYOOfLEmEFm8/PraHprMkfN5+14qp7LBaMsFYUd23z0QpSJhpSoDq/zIbJldZxZ
	x4iM3FpfYe/zZiydDpicf2njiBwTAysJON/NSPoyt4ulwYLSOqReCGKCPEGVeBmB9M8l0Vi93+D
	C6O9cDwN214NnuXLNgxBzaPTF3yqyoVF+F3otOoAXB7gH9mlFYO1N8sC0R4+sk61FW+u47rOItg
	PYULvVvcW5343uOjqGrGBeKHNMXoYE0SQqLTOVKxUeicJfNFgkG5LgsjHqVSJaIew==
X-Received: by 2002:a05:600c:2eca:b0:477:991c:a17c with SMTP id 5b1f17b1804b1-483178ebb2emr36092105e9.6.1770315214446;
        Thu, 05 Feb 2026 10:13:34 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48317d2085asm76942305e9.1.2026.02.05.10.13.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Feb 2026 10:13:34 -0800 (PST)
Message-ID: <2403ae2a-0e9e-4b7f-a507-232dc951155d@gmail.com>
Date: Thu, 5 Feb 2026 18:13:30 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] dmabuf backed read/write
To: Ming Lei <ming.lei@redhat.com>
Cc: linux-block@vger.kernel.org, io-uring <io-uring@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "Gohad, Tushar" <tushar.gohad@intel.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Christoph Hellwig <hch@lst.de>, Kanchan Joshi <joshi.k@samsung.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Nitesh Shetty <nj.shetty@samsung.com>,
 "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
References: <4796d2f7-5300-4884-bd2e-3fcc7fdd7cea@gmail.com>
 <aYQKhcnTJLimnbEn@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <aYQKhcnTJLimnbEn@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12059-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_SENDER_MAILLIST(0.00)[]
X-Rspamd-Queue-Id: DC45BF6651
X-Rspamd-Action: no action

On 2/5/26 03:12, Ming Lei wrote:
> On Tue, Feb 03, 2026 at 02:29:55PM +0000, Pavel Begunkov wrote:
>> Good day everyone,
>>
>> dma-buf is a powerful abstraction for managing buffers and DMA mappings,
>> and there is growing interest in extending it to the read/write path to
>> enable device-to-device transfers without bouncing data through system
>> memory. I was encouraged to submit it to LSF/MM/BPF as that might be
>> useful to mull over details and what capabilities and features people
>> may need.
>>
>> The proposal consists of two parts. The first is a small in-kernel
>> framework that allows a dma-buf to be registered against a given file
>> and returns an object representing a DMA mapping. The actual mapping
>> creation is delegated to the target subsystem (e.g. NVMe). This
>> abstraction centralises request accounting, mapping management, dynamic
>> recreation, etc. The resulting mapping object is passed through the I/O
>> stack via a new iov_iter type.
>>
>> As for the user API, a dma-buf is installed as an io_uring registered
>> buffer for a specific file. Once registered, the buffer can be used by
>> read / write io_uring requests as normal. io_uring will enforce that the
>> buffer is only used with "compatible files", which is for now restricted
>> to the target registration file, but will be expanded in the future.
>> Notably, io_uring is a consumer of the framework rather than a
>> dependency, and the infrastructure can be reused.
> 
> I am interested in this topic.
> 
> Given dma-buf is inherently designed for sharing, I hope the io-uring
> interface can be generic for covering:
> 
> - read/write with same dma-buf can be submitted to multiple devices
> 
> - read/write with dma-buf can cross stackable devices(device mapper, raid,
>    ...)

Yes, those should be possible to do, IIRC Christoph mentioned it
as well while asking to change the design of v1. The
implementation will need to forward registration down and create
a dma-buf attachment for each device.

-- 
Pavel Begunkov


