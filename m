Return-Path: <io-uring+bounces-7866-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D9974AAC98C
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 17:31:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 073A61B683A0
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 15:31:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC74F281363;
	Tue,  6 May 2025 15:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nZ87zeYD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050C7233739;
	Tue,  6 May 2025 15:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746545474; cv=none; b=JzxXsT/hvWCe+7+HdYAC0IFGocmq6xaoOXiLMN73vccZA3aF1qFft8saNgd8BUAYdA+kqlP7ZsA2rsPTYL50aCLdxDaB/XzYVsx1/nkjboDUIb42LMr0Lrs/p8NFHNIrpNccWyKuCxf1X6bkiF561l9dNFh0WXO7DKKWhW4vjMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746545474; c=relaxed/simple;
	bh=hQ66qrlcPr2aRGjQMfct3VpfC5fpz6RikGOf25KYtIY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=esGO063xQUb2JdbZAvHr820enroPGMhnQSYu4647qFwLq0KYLKQJLtKWj8dtEO+sud3/dWOHe0mOSKjTqmYZNzQz3l6XZQRN4XLNC8cg9A6SzO183BhjAVx1OfrAzX56qmPYflQ/2GrDXEgoHR3hPWcn7sFCmTuthSvMZwDgWEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nZ87zeYD; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ac2bdea5a38so826899266b.0;
        Tue, 06 May 2025 08:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746545471; x=1747150271; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZLoqCAaUDJbSQ2HQHcae7rCe5n9iQW/eaBPL5yNMO7s=;
        b=nZ87zeYDFg4l2uT759p/N532XTSJ/Po4w6KIh7CJ2x0e9aPMSLoQtQn/sDyptlQ2ie
         XZISAhnuYYPYFus8uLEJLx9+bDVyRsvGPBzhaW5qF4OaOspY4ELz8i5BiJH8nqVXHY31
         zNSo55XhNAoEpmr8oxf7UAUMnhwdtjnwJ/t1bc858n+2IN13otwNec1encIm01jZPXTy
         Qrj6y0FOH+4Ato6urWiF9u/2C50bocxcXsKrmYbDZRqAFaQsuk17ClsKSYcwibILtGyX
         Tnxn7WnKN1A2gzoxXOGix/Feh47omPcBkLBoTSCGnBcIafLPcNcP2C/1uQMY/QeCJUWU
         JZRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746545471; x=1747150271;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZLoqCAaUDJbSQ2HQHcae7rCe5n9iQW/eaBPL5yNMO7s=;
        b=FDXT+bRJdVOyCcgTa/WYeBem+3M72lYawLKg1YVqdhiDP2CbIUHkKGHCyy2Ws3FEuM
         Osvm/xSXVlRgdsGrMiCsJL6aTTnoD88r/EOdGOs4XMMgXFuuYSsSJuAIho7zG1ZT2CDM
         crc9QKplZB6xLh8v6jnJVZnjB7+0Kvr5LVsSQD5X3EQDIB6lOwW7Xsck5gAFN+bjVcg4
         HbGfUjeew5xdyIcHRSAt5X9z1vxpzW1uTSuBAQoMV1Ctuka2fwQHXf6h7Z+WIWpRiQFu
         zQw53A1D475s1g0PzAKYY8Oljc81IDDq1iTi01zCQ4uWIZUxnPLvp0uoPPkIIKumTzH8
         nRMg==
X-Forwarded-Encrypted: i=1; AJvYcCXS5hjbHol47etB53jHN0GUqE9drvpdsfJZLsUD1RNEoXsdSkHvh2bz7iHzpQH7C+u0VG83THs=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywpc/idBYzD2NiBAm2R7dIMKPTCerSVFhM7L7DcHGsatoReRfy5
	axCS3IfzfxZjf9qcxk8hRmWcPxuHujDA/0aR/sJcKWTeM+3ZV/DBmuWsTw==
X-Gm-Gg: ASbGncuUXg1NzrJItUFjSFrSK4jf+7JuZsIwdxVuqTiWfcsMRUW0ld/xfJ8xEIOtqkr
	VpxMKB709jk2qEnSt7RzvTJo7AMsL96ZF30BcNwv3H0rPZN0Zuwgezqz9B1+xa0cdHPmbE36qz6
	e5nMg0Yo9QXA+gyRnTS6nAFMTspO+jKHiHuDa2hxIUt0HZqiyOAeCxCPDXbyUQc1DEpjCLudu5d
	XMrBqqOEmlyBmsNTe29ZIrrngnAY91kd3T5aJIsUL5N0ewklCFbw77KDOF9DjeNTpmm8gV7GEm5
	fS0J1DzI6Y2HWViljsR7oQaRsBJSJVM73NKuNlpzJv5v14ed852aktASoUO0qfDhvYHEA+KYvw=
	=
X-Google-Smtp-Source: AGHT+IFAwtSLKgTGUFOgBRSPgi4LXBzpTOtBlAMTBdBjTGYuj9J4pjPg4C+ANgsFVG8DPCV3Y9wgGg==
X-Received: by 2002:a17:907:2d93:b0:ac2:a5c7:7fc9 with SMTP id a640c23a62f3a-ad1a4acf6cdmr1082198466b.51.1746545471116;
        Tue, 06 May 2025 08:31:11 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:4f70])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad18950907bsm720489866b.126.2025.05.06.08.31.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 May 2025 08:31:10 -0700 (PDT)
Message-ID: <355664c5-769b-49b7-aa19-7a2dcfb24818@gmail.com>
Date: Tue, 6 May 2025 16:32:27 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH io_uring 0/5] Add dmabuf support for io_uring zcrx
To: Alexey Charkov <alchark@gmail.com>
Cc: io-uring@vger.kernel.org, David Wei <dw@davidwei.uk>,
 netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
 Pedro Tammela <pctammela@mojatatu.com>, Victor Nogueira <victor@mojatatu.com>
References: <cover.1746097431.git.asml.silence@gmail.com>
 <CABjd4YzAJqvLiNid7RoVpLospTrAFzrBpTcFHuem2-JxfkzpmA@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CABjd4YzAJqvLiNid7RoVpLospTrAFzrBpTcFHuem2-JxfkzpmA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/6/25 15:34, Alexey Charkov wrote:
> On Tue, May 6, 2025 at 6:29 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> Currently, io_uring zcrx uses regular user pages to populate the
>> area for page pools, this series allows the user to pass a dmabuf
>> instead.
>>
>> Patches 1-4 are preparatory and do code shuffling. All dmabuf
>> touching changes are in the last patch. A basic example can be
>> found at:
>>
>> https://github.com/isilence/liburing/tree/zcrx-dmabuf
>> https://github.com/isilence/liburing.git zcrx-dmabuf
>>
>> Pavel Begunkov (5):
>>    io_uring/zcrx: improve area validation
>>    io_uring/zcrx: resolve netdev before area creation
>>    io_uring/zcrx: split out memory holders from area
>>    io_uring/zcrx: split common area map/unmap parts
>>    io_uring/zcrx: dmabuf backed zerocopy receive
>>
>>   include/uapi/linux/io_uring.h |   6 +-
>>   io_uring/rsrc.c               |  27 ++--
>>   io_uring/rsrc.h               |   2 +-
>>   io_uring/zcrx.c               | 260 +++++++++++++++++++++++++++-------
>>   io_uring/zcrx.h               |  18 ++-
>>   5 files changed, 248 insertions(+), 65 deletions(-)
> 
> Hi Pavel,
> 
> Looks like another "depends" line might be needed in io_uring/Kconfig:

Ah yes, thanks for letting know, I'll patch it up. dmabuf is
optional here, so fwiw not going to gate the entire api on
that.

-- 
Pavel Begunkov


