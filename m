Return-Path: <io-uring+bounces-7962-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2ABECAB5622
	for <lists+io-uring@lfdr.de>; Tue, 13 May 2025 15:34:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C8A4B189361B
	for <lists+io-uring@lfdr.de>; Tue, 13 May 2025 13:34:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D22827056C;
	Tue, 13 May 2025 13:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aOYJIqlG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5691531E8
	for <io-uring@vger.kernel.org>; Tue, 13 May 2025 13:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747143278; cv=none; b=Ca9KYjhZRGRpFLjRfX2QEsDZhE/y+rRfqcTINMNjZvcVWRr4CF9nhWAlc3FwgmyWdKU3QD1Egs9b195yKK6Hfy8QTrlPpxBJwGqPZDc/pBWAwvIn2qKYKZib1Wij2/hfnCfhIkXxBgt9aZ2ry2HB+IkeVVXAA4912Ei0IyyueOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747143278; c=relaxed/simple;
	bh=bho/EUujh9Q+QnOk/XYCHcUrQjczR4ZUDJrFXCEZHqI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HTFd7724vXg/ozfBmGU2lZb+1OAnLjZOFM2EfYNqvpSxbdEcdhzR1AGYRbVdUt2IcZyNaCGCTboWwQ/m/POgvBptIpEjqHPGXJcQrokHflnTyYzX+qhn7FJNItlw6aNy4g2kcRSyHP5W9ye/DCB1J5a4VucL6fsLN8Qt21vvY1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aOYJIqlG; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43d04dc73b7so60493035e9.3
        for <io-uring@vger.kernel.org>; Tue, 13 May 2025 06:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747143274; x=1747748074; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5AnYvs0TE4aZQDPU8tDTX/dCl5bYUmPmmUYM8gteHmA=;
        b=aOYJIqlGWhRSEJNAhWGSL2BDyzdRHxc3PafS2j/lSHQIxcFEn90qDzDJ/l58Vj8s3W
         wokmRbu8O5gMDoOZJQDw513ZLkks+4FnONRzg1t845Zn8DH0Zom5IMUL2iaugZbgu/J+
         CpBcbVaqTLdqBWC7YpQ9BQxXdB52Fd2fE02QMrRaboTpTaFjx0E6Smbdu+3TUVfzPAaX
         cwy2hWackmSSMNQD7PX0BjXZlIQyYe8OTBr/A2s7mDJrrUO5EdcuHiel4lsdUOmkJmWH
         knjJpZsteRCixhl9NWPmCst/9y7+JVG3nqucQJ3GJ6WIoTM04qkSoH/XgACL3M0EdQan
         y48g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747143274; x=1747748074;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5AnYvs0TE4aZQDPU8tDTX/dCl5bYUmPmmUYM8gteHmA=;
        b=Eswbff4KwrG+podqlWX3r+27mn0EZTvvI/uTQ99nIf86+3mTE6zN3YtSW1OV+P/1B0
         IWbppXczXqbR1gmrzTVNaaT5D2UcMyGtB8zeyazyXh3mez2CIRAUSajuvVExafW8DtVX
         ornHjhrUI25iMF7rmnLkLWncnlGnPt0P2tbA7Lh2wIhyn+mSeHHMimDFSB3ngPgp18gT
         Y9Glwo7prR1GLngBgAtdU1DQ09MMxC4R961+Bwg7y6RdHMKOP+FAFkGgwLX2c5VK8jBJ
         J0M8IXYFTJy1f0DEkpRGNYOhfmfU8DEzU+w4AyvhKG8DkDFkKh0BURBDJ7HCDegUbjMO
         moKA==
X-Gm-Message-State: AOJu0YzNdlQXhwaflKZy6tw7Xx/KegkLUazWOhpED42o9z/SECp8yfy+
	UZ5i5xy5UNfrMetNx0vB6q9cOqHGaJaH0K+x4GuU6LEa28A4yizl
X-Gm-Gg: ASbGncvyV+uAxZSVkXkIgjkCYO/5SyRX7ZBfRnFyW9HZHNCWUkmy8OtC0G49XBpVftD
	IEy1zhCXbAjzwgJfKDzqY6YeProP8q+tWwkH/U1mHOrW52ssAjl16dypjYhx2YisVk+90lYlvQr
	nE68S5LPUu72W/xTzo19rQDmfEMY3QmLMY1VCWIAZYFZtUmJtWJKLWmdSCnU40niJszzx5GoNMp
	qYcf9BeWpXWVGANkkxiCfmugJUJEFQsPxshWYZimnR6Lo8I1hrnFIcfz+zBjrwbeE0lRWEdMcPJ
	VKYZycG2/XHP1X8UQJbg2H1zGR/fop3Rc+Ik0qUpn6vHNOKNj7LY42Iv2te4Gg==
X-Google-Smtp-Source: AGHT+IHpHmn3nZgIuL+yJYMtxFwIdQtQmKYYXORleCTPp0u8idsViRePgEomqKk3osnYge/1F0UKnA==
X-Received: by 2002:a5d:59ae:0:b0:39c:268e:ae04 with SMTP id ffacd0b85a97d-3a1f6387432mr13692607f8f.0.1747143273782;
        Tue, 13 May 2025 06:34:33 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.146.237])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f5a2cf0esm16316818f8f.79.2025.05.13.06.34.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 06:34:33 -0700 (PDT)
Message-ID: <56137678-dc9c-484b-8e78-3a4ef07730e9@gmail.com>
Date: Tue, 13 May 2025 14:35:41 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 8/8] io_uring: drain based on allocates reqs
To: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: io-uring@vger.kernel.org
References: <cover.1746788718.git.asml.silence@gmail.com>
 <46ece1e34320b046c06fee2498d6b4cd12a700f2.1746788718.git.asml.silence@gmail.com>
 <aCMg9J25E_Um-kSg@black.fi.intel.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <aCMg9J25E_Um-kSg@black.fi.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/13/25 11:37, Andy Shevchenko wrote:
> On Fri, May 09, 2025 at 12:12:54PM +0100, Pavel Begunkov wrote:
>> Don't rely on CQ sequence numbers for draining, as it has become messy
>> and needs cq_extra adjustments. Instead, base it on the number of
>> allocated requests and only allow flushing when all requests are in the
>> drain list.
>>
>> As a result, cq_extra is gone, no overhead for its accounting in aux cqe
>> posting, less bloating as it was inlined before, and it's in general
>> simpler than trying to track where we should bump it and where it should
>> be put back like in cases of overflow. Also, it'll likely help with
>> cleaning and unifying some of the CQ posting helpers.
> 
> This patch breaks the `make W=1` build. Please, always test your changes with

That's good advice, even if unsolicited, but it doesn't help with the
issue. Not every compiler complain. I'd also say, things like that
should warn by default, and they usually do, at least for basic
"unused variable" cases.

> `make W=1`. See below the details.

Yes, it's dead code and has already been fixed a day ago.

-- 
Pavel Begunkov


