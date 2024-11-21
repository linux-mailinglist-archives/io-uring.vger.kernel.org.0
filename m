Return-Path: <io-uring+bounces-4916-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 06BA99D4DBF
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 14:28:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7A7F0B23516
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 13:28:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 994D41D04A0;
	Thu, 21 Nov 2024 13:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ayo1rKBf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF941369B4;
	Thu, 21 Nov 2024 13:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732195697; cv=none; b=nKMQh4u54h4BpFugxV/Y3clHF5BFkpA04VhPNEgQRgOiSc1XVQHIkmaYR5lbwew2v4+9TZgr2i3NrFVTeznYK6Jz3Il9AQCLU43nMhrEp++ZqwFVllSDqjwcTHAHi+tFJqPmnuLnhhtn/OoMRBQpGGHoYNgsvOUTC8+shCH4O4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732195697; c=relaxed/simple;
	bh=raHgp5SQRlVYGfMxAEWOYpZN6ecfHDcpykOUZsJA1N8=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=piEKUGmJLmpSzH2QWdT59epR81panodoinPYpMiU2vFwSzi3RL8eJ+99mtI7wZhAmtMPc0nAr1jZ8vPdPs438NKUL5qyhxjTemjCHJM8wmJShTGKeJZnfqnif/MbKCNxOjwtkE/D/nGGwR2gQxhDyfNk1sW0r+sNWsalyDlfqNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ayo1rKBf; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-aa20c733e92so125513166b.0;
        Thu, 21 Nov 2024 05:28:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732195694; x=1732800494; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UcEid6x7hR6WD3NnjxTjV+SHdDeh2G3crDRCwr0C4Xw=;
        b=ayo1rKBfWqXE65UIuezbz2T6LPj85a1IJ0CRUBWRL1GPUEp4Ctw5houMluET0PY2+f
         VQLyMg9NzlIokkzDUZs7irxUknG1xo4y39CK2oqls/684z6Z6LZ29U7iZNsWlLzondMs
         ZIVYNqUNiObiiGWBnk7dm8wd0I8oCQLX56st1IabM1h5VMTR0m2Mo8O0Lfxb4unwpSmq
         rMGNXgyZAYercYjqDkO15az0/midglloBryfHuEmKYHQU4+dh/Nt2VBP1Qq35IzPwMfS
         Yo9BjeodCQ8An/a73cioj/3/IeWOgNGvWGjg9g2XqY9jPlAnQFnUfWW/lurUx/ma0FMo
         rb8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732195694; x=1732800494;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UcEid6x7hR6WD3NnjxTjV+SHdDeh2G3crDRCwr0C4Xw=;
        b=SdfQtnRWbEGG1SsOY36fFJ2ujVt8PKs46YnhjgDXmZfjv2Gn17zDGaqwxuwMLlHEXk
         Lf6F1+OQSX3zJtrKbWsOZMYKVLKaCwMjqyLw13mp71ps3CF8+MVK1kOJDzmTw4yWGlIn
         a+Zw8pad6+1YzRxrRXjvF06g4FlbmdgS8QdZLJ3iL93/wTWZtQemUwK/ICeaVOTLO0Zm
         blF/dspP8TVcFmOwSPcbxqwi/rPqY1bTwrfny6tavqnhIEEgYkP5GrKgTgB/x24Jzugb
         s81kuZyjjZAsx5Cs1yYWjg7MRjWvFSPzaSSBrsy95o80Pf7q+RfB6+B4by80h5BdMy+2
         gd+g==
X-Forwarded-Encrypted: i=1; AJvYcCUhyM5Yv6MC0adk86ZJosDqGCxNq5Bdh0U9wh4BXBhpbPw85qTW4bnFPXDQX491Ve3eGSBu1/DlnDRTsgk=@vger.kernel.org, AJvYcCW9FIpaie10QKY4K1/rkzAsT1SFs8sGqKMAgG4+YP+gBLSLJ6PMBkI3LYVWVT8HYemB6dm4sCVadduiyJFfCA==@vger.kernel.org, AJvYcCWM1jJwqoGNvuqi0EpNAXWPBCsqPqljY6gMRgVMiL0RT7zG/tkF2UCdAP9C4+J5rTFKSmkMwjMd7cNaqw==@vger.kernel.org, AJvYcCXZiGCuSPEcwjOWm9tmMv1xICcggnH5vrnO38/Ub/xtPx9FI+aL+Z2xW7Ze8NtHsd3OqPsVyFXbCw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyjxxzRZgnfzLqpukMHWY+sFWOST2ou+QpJSbZ2VVsszLg1+7BK
	NuYqQbEqeYIf69MEEpLuCqofZGcAv/BHtKIZ/Uantl47hfEyNkky
X-Google-Smtp-Source: AGHT+IHecWvqkw6Jt2yCsp8YXvCsBLl3jZ1zTbBKU+p/+FeJdjUtQiX377sGWOz0S8T463Hv+SgYcg==
X-Received: by 2002:a17:907:703:b0:a99:f91e:4abb with SMTP id a640c23a62f3a-aa4dd57ba76mr569480466b.27.1732195693926;
        Thu, 21 Nov 2024 05:28:13 -0800 (PST)
Received: from [192.168.42.195] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa4f42d328dsm81636666b.109.2024.11.21.05.28.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2024 05:28:13 -0800 (PST)
Message-ID: <dfef87ff-175a-4387-9d51-9688e7edbcf6@gmail.com>
Date: Thu, 21 Nov 2024 13:29:05 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH v9 06/11] io_uring: introduce attributes for read/write
 and PI support
To: Christoph Hellwig <hch@lst.de>
Cc: Anuj Gupta <anuj20.g@samsung.com>, axboe@kernel.dk, kbusch@kernel.org,
 martin.petersen@oracle.com, anuj1072538@gmail.com, brauner@kernel.org,
 jack@suse.cz, viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 gost.dev@samsung.com, linux-scsi@vger.kernel.org, vishak.g@samsung.com,
 linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
References: <20241114104517.51726-1-anuj20.g@samsung.com>
 <CGME20241114105405epcas5p24ca2fb9017276ff8a50ef447638fd739@epcas5p2.samsung.com>
 <20241114104517.51726-7-anuj20.g@samsung.com>
 <c622ee8c-82f0-44d4-99da-91357af7ecac@gmail.com>
 <b61e1bfb-a410-4f5f-949d-a56f2d5f7791@gmail.com>
 <20241118125029.GB27505@lst.de>
 <2a98aa33-121b-46ed-b4ae-e4049179819a@gmail.com>
 <20241118170329.GA14956@lst.de>
 <4f5ef808-aef0-40dd-b3c8-c34977de58d2@gmail.com>
 <20241119124938.GA30988@lst.de>
Content-Language: en-US
In-Reply-To: <20241119124938.GA30988@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/19/24 12:49, Christoph Hellwig wrote:
> On Mon, Nov 18, 2024 at 05:45:02PM +0000, Pavel Begunkov wrote:
>> Exactly, _fast path_. PI-only handling is very simple, I don't buy
>> that "complicated". If we'd need to add more without an API expecting
>> that, that'll mean a yet another forest of never ending checks in the
>> fast path effecting all users.
> 
> Well, that's a good argument for a separate opcode for PI, or at least

No, it's not. Apart from full duplication I haven't seen any PI
implementation that doesn't add overhead to the io_uring read-write
path, which is ok, but pretending that dropping a new opcode solves
everything is ill advised.

And I hope there is no misunderstanding on the fact that there are
other criteria as well, and what's not explicitly mentioned is usually
common sense. For example, it's supposed to be correct and bug free
as well as maintainable.

> for a 128-byte write, isn't it?  I have real hard time trying to find
> a coherent line in your arguments.

When coming from invalid assumptions everything would seem incoherent.
And please, I'm not here to humour you, you can leave your crude
statements for yourself, it's getting old.

-- 
Pavel Begunkov

