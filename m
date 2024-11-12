Return-Path: <io-uring+bounces-4618-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0519F9C4BE7
	for <lists+io-uring@lfdr.de>; Tue, 12 Nov 2024 02:35:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B20131F21CD2
	for <lists+io-uring@lfdr.de>; Tue, 12 Nov 2024 01:35:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 453F9204F63;
	Tue, 12 Nov 2024 01:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gE82J/Ja"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DDCF20495C;
	Tue, 12 Nov 2024 01:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731375138; cv=none; b=FCoBo1H2kqSMuU7AVVdKVDKhG+LI2GivDNLCSm+pG9AGpzXctEOtAE9XtWXmaBQ1cw4GmbY59UHQEt6P/3ka78DVrZbiLvTkYACqq1TrN5rIdiNBTokifxAlp8F/rXMPR8gV+ALL7xayRocyBKH4Ucm81wnBH+ErR0oDB++yxpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731375138; c=relaxed/simple;
	bh=pkJEhBHO901RWUGMZ4neCm1jieHMbZ7B7rshDp1CaYM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KWL/1yg7RG7nJhsLgivgdMT4p7NL+dNG6WBR0JL2Czs0fmmBc3HuoQWarLTveZ3z3ErGhRoJAs1qV4Qo8gpC7wVr/vVEBJsBAgWxLEenRyVSkkOuaX/o/GgzVz2MTxKjtJrMuUJSVlWw+NacwWf6SOV+FXM/5T2nc8mFKBOSglk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gE82J/Ja; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4315c1c7392so45052265e9.1;
        Mon, 11 Nov 2024 17:32:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731375135; x=1731979935; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WOYYrAKsRLkotEPjA+hBse5PtLPm2vozdMcs0N4/zA4=;
        b=gE82J/JarLuHZcIAbfi89qwthbkNAkbuNQBSIMyi9NDdDkRBLa4yeqHQcJSYCOl5Nv
         rHtpgJ2IZD2YASJNIltE+sjUKkDixDGFCq8MPQh/oHHCoMxi8uF+qb8QRkIK8NfXoU6W
         66dQyCjYu2VLQ/oXUtWPBKlHAVtTu8kBuwTRA6raifLx6FpQd3cItTR41AZSI5e3LSny
         MwDvVE00AvaC+UKBuPw7W22DnZ0xwjeY5IZ9sWf6q/MpDWkT7nl+vQK/gPvlyYjgAqlq
         ud2frSCc/aSa1Xw0vhGo2dV/33yzuH5rYlC8x/0PgHQ8awpEkBIOl+Ez9/9vjFIfLT59
         DKJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731375135; x=1731979935;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WOYYrAKsRLkotEPjA+hBse5PtLPm2vozdMcs0N4/zA4=;
        b=Oa6LF85wm1cyXVerm0iF2YPH157JMSudJi1GQNf5TXxFiKMbrPZp1l9weF0YN7amlb
         BNkE/WhU03ttkj/aGg+L8qP9V5DrjwajeKfW12P1eTRRYXNOJ24JuUzhbFzYLKGIQA5M
         gmtVYvS50kQkWPZim6I6EchdPtbk2EjDphQIi07m3akctIGR8kZ7qiLr53Ta347h73ll
         yHHSmnyTxGmvMdsVBQjLGyZskiu5oTZE2b4CqH/9ZZ+h5VCT/UHcV8Psrbabcdu3xeiR
         s8JKXI8fP1Vr/P6nq63mA25bQD8iY/UpLjWfdX3iCZj+XJ1uqVOXc5NDxAhDwSXcXl8C
         FEMw==
X-Forwarded-Encrypted: i=1; AJvYcCUfWoSA97hYfk+d8qeTFv7QqoBsB520oc3VM92EchZkXLWfOYxIFRIBMEmMgEMu1wRf1QdOEd2lFw==@vger.kernel.org, AJvYcCWb+swigtiaSTFh3b9pZt1DaO/EXdom8syiv6qvDnpxm33Czf7qFVoBFDdzdDiQGkOfHKZdZBo/HjGgBw==@vger.kernel.org, AJvYcCWzYoyZleGHwZz92tlyzfQrcmLi3Io5hply2qDE8yUslzHmGIpvRopl1F2gMPb4aNBRbEy1vNd0YjSp8VzVig==@vger.kernel.org, AJvYcCXgkoRU1w3K/2jAjhD0UpkT3goFMJRgBQGvJngZfDJ3TBz3vtE2jF/tmFIHzh7i2xk8Oa/MRM4D5vSRdFg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPl0hG07Ncp/AUMj12a+ZIKHOJpVAkJ6dxjtwofATDMtI4cUS8
	hrw0fGVakAvNsybydpv5bQfjfvVkGuxZAO7qoVFciwL4yc6mSI0x
X-Google-Smtp-Source: AGHT+IFUwkZdPumBasVvTtECag2f1YXtLMhxIHiAzpbsfxbCn/aAobFfjpRlKsPysUvhvUitAG5Mww==
X-Received: by 2002:a05:600c:4f83:b0:42a:a6d2:3270 with SMTP id 5b1f17b1804b1-432b7517aa4mr116959285e9.21.1731375134452;
        Mon, 11 Nov 2024 17:32:14 -0800 (PST)
Received: from [192.168.42.75] ([85.255.234.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432b05c1c81sm194974655e9.32.2024.11.11.17.32.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2024 17:32:14 -0800 (PST)
Message-ID: <642d46b9-0869-42a9-b7fb-c9b51cb23b8b@gmail.com>
Date: Tue, 12 Nov 2024 01:32:58 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 06/10] io_uring/rw: add support to send metadata along
 with read/write
To: Kanchan Joshi <joshi.k@samsung.com>, Keith Busch <kbusch@kernel.org>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
 brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org, gost.dev@samsung.com, vishak.g@samsung.com,
 anuj1072538@gmail.com, Anuj Gupta <anuj20.g@samsung.com>
References: <20241030180112.4635-1-joshi.k@samsung.com>
 <CGME20241030181013epcas5p2762403c83e29c81ec34b2a7755154245@epcas5p2.samsung.com>
 <20241030180112.4635-7-joshi.k@samsung.com>
 <ZyKghoCwbOjAxXMz@kbusch-mbp.dhcp.thefacebook.com>
 <914cd186-8d15-4989-ad4e-f7e268cd3266@gmail.com>
 <ceb58d97-b2e3-4d36-898d-753ba69476be@samsung.com>
 <b11cc81d-08b7-437d-85b4-083b84389ff1@gmail.com>
 <6bca474e-361d-40a3-b28b-93f561dbdd85@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <6bca474e-361d-40a3-b28b-93f561dbdd85@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/10/24 18:36, Kanchan Joshi wrote:
> On 11/7/2024 10:53 PM, Pavel Begunkov wrote:
> 
>> Let's say we have 3 different attributes META_TYPE{1,2,3}.
>>
>> How are they placed in an SQE?
>>
>> meta1 = (void *)get_big_sqe(sqe);
>> meta2 = meta1 + sizeof(?); // sizeof(struct meta1_struct)
>> meta3 = meta2 + sizeof(struct meta2_struct);
> 
> Not necessary to do this kind of additions and think in terms of
> sequential ordering for the extra information placed into
> primary/secondary SQE.
> 
> Please see v8:
> https://lore.kernel.org/io-uring/20241106121842.5004-7-anuj20.g@samsung.com/
> 
> It exposes a distinct flag (sqe->ext_cap) for each attribute/cap, and
> userspace should place the corresponding information where kernel has
> mandated.
> 
> If a particular attribute (example write-hint) requires <20b of extra
> information, we should just place that in first SQE. PI requires more so
> we are placing that into second SQE.
> 
> When both PI and write-hint flags are specified by user they can get
> processed fine without actually having to care about above
> additions/ordering.

Ok, this option is to statically define a place in SQE for each
meta type. The problem is that we can't place everything into
an SQE, and the next big meta would need to be a user pointer,
at which point copy_from_user() is expensive again and we need
to invent something new. PI becomes a special case, most likely
handled in a special way, and either becomes one of few "optimised"
or forces for nothing its users into SQE128 (with all additional
costs) when it could've been aligned with other later meta types.

>> Structures are likely not fixed size (?). At least the PI looks large
>> enough to force everyone to be just aliased to it.
>>
>> And can the user pass first meta2 in the sqe and then meta1?
> 
> Yes. Just set the ext_cap flags without bothering about first/second.
> User can pass either or both, along with the corresponding info. Just
> don't have to assume specific placement into SQE.
> 
> 
>> meta2 = (void *)get_big_sqe(sqe);
>> meta1 = meta2 + sizeof(?); // sizeof(struct meta2_struct)
>>
>> If yes, how parsing should look like? Does the kernel need to read each
>> chunk's type and look up its size to iterate to the next one?
> 
> We don't need to iterate if we are not assuming any ordering.
> 
>> If no, what happens if we want to pass meta2 and meta3, do they start
>> from the big_sqe?
> 
> The one who adds the support for meta2/meta3 in kernel decides where to
> place them within first/second SQE or get them fetched via a pointer
> from userspace.
> 
>> How do we pass how many of such attributes is there for the request?
> 
> ext_cap allows to pass 16 cap/attribute flags. Maybe all can or can not
> be passed inline in SQE, but I have no real visibility about the space
> requirement of future users.

I like ext_cap, if not in the current form / API, then as a user
hint - quick map of what meta types are passed.

-- 
Pavel Begunkov

