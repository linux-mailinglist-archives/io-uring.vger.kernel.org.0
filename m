Return-Path: <io-uring+bounces-4751-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 516A89CFBAD
	for <lists+io-uring@lfdr.de>; Sat, 16 Nov 2024 01:31:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 08F641F22B9C
	for <lists+io-uring@lfdr.de>; Sat, 16 Nov 2024 00:31:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89501621;
	Sat, 16 Nov 2024 00:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KaOgf+CO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB174A28;
	Sat, 16 Nov 2024 00:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731717102; cv=none; b=laK+jzGSedeabGi5mnhNYxQ8NN8oqQAAF5ZVZpXREc+XZPEpFvGv815OVfPkFAjhOhzXICMPuF4uHRlq1JZwqeLif4V2FMeB56hvfGb2pPleTTequpX6FX+hprC9C3l7FJqbdf+qhSb97xuBHAPbSmnynY/HbPZSFE7WtDXkwug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731717102; c=relaxed/simple;
	bh=f4Pzo65u6Rk2Do4nQXJFlQAYXXz1GhKN1oPw/UryO9o=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=p/CnX9IGgSXMuVPAzTufPKLpUxu4BOivZeaTYvm1xwgdYiASy8tXgE4hWoowqhHxxuTUZ859wjySsAdHZD7s2RmFTuhWo2AH2sWMef30t4WIeX3U1qxRMth+xTtL9UKW9QW1iSkJ0osHWakSoC8Xu4rh5P32f522qm5JYMeiOLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KaOgf+CO; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4314f38d274so2379715e9.1;
        Fri, 15 Nov 2024 16:31:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731717099; x=1732321899; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wUiuDfFBuPq9wmtwULXkxzA4r3Jz1CPuc0lcmODYolg=;
        b=KaOgf+COwM6BlRzjL2moXTiwudm3DbYGEViM/X+pKbcrqhmfwE1bZXRzHAbSDEWR2v
         lhXLXzijY6SlK+hw3Ng4ipqsdvLP6D/QAMkyHQiFOEthgHD7LMLUVHHS7YRTRyJv73yz
         p3o5aaDFFhctdo7RQu74QYShWOgD2gGWNxTEhCcMQmnGXJuMKuCeUWHSckyIvEfEOM/t
         b1EqBSiwkz2150G8EsuBGYZbcJxWPIaSg9UT26kRRJ76se34HVGymjKImmW+RyqaD0i7
         U0LuMzgyLu8bumNuRXjVCqUeOuxP1m1idG7xsOHXAXCnGeMesfOixLKajwT4Uanxxx8o
         zypQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731717099; x=1732321899;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wUiuDfFBuPq9wmtwULXkxzA4r3Jz1CPuc0lcmODYolg=;
        b=Mkq/N3dSHAWzdA24ubkKlW7Yqgetvn2q4uijSJfoiz0BniFCg4U3/2lA+814U4t3JV
         ytNEFGc+4g29qKuOLy+Pj0SVtQobCOiqDpVEVX+YDYk24rBSvVtnR4B3SU0DP0RmggP8
         t/iaWxJxyAvmZwtWKkRkSMKUv2SGq0eyS1vQiLqAc02RvpwqhTpYtbyGquSGlGuLRmEh
         /oz/tRDIbgpi/xQjqkTtZ1usXVrxxojEDhNJtj1jsgEuyeszPVxfBuDhwu7lchZXou9r
         4TCj3o7/pVyZyvMnIOsw+5DniQW7ocOHRsFRME+HOrCzDnjj+10ltH0VJMYY1TOMAGie
         GIow==
X-Forwarded-Encrypted: i=1; AJvYcCV1On2sJUe1VQJnc8x1zDPWr8OeXmZgkt2SlIRiUccTjRmjb98IVAbBHaxot+BYDcw85kvkHIUksBcktNFPCw==@vger.kernel.org, AJvYcCVZ/E5ggL7xHhAxJhqfvQuTNOjSDQrVIWeEwGETboGUrdLQ1TaO4LHlaDMv+uhrW+ZNX6dCApcsOykThQ==@vger.kernel.org, AJvYcCXjSfG3MnU5bt4Abxu+eQ2U2OlJTD4sJXC+kciM164zRbVDFZrwAEB8bDZW3N/G5zZeg++Od6giJjUD8A==@vger.kernel.org
X-Gm-Message-State: AOJu0YwcWu4u/dokRxwZrUOCZKsmT2mTWqtJQi9cfIzf8M9VQSvzmNPX
	0LQDB0edA1CJyR6jGE8IDdMI78Sc44NudoQ2OSelbdoWO8ur1t8k
X-Google-Smtp-Source: AGHT+IHP+NwuGsuzp6CwtW/eEH7kghS9fmgu7RXZGv2sSD+Jk9ssluc8g0aZVNHccATYYsWWJuTJhQ==
X-Received: by 2002:a05:600c:45d1:b0:431:604d:b22 with SMTP id 5b1f17b1804b1-432df74fc6dmr51402325e9.16.1731717098903;
        Fri, 15 Nov 2024 16:31:38 -0800 (PST)
Received: from [192.168.42.251] ([148.252.132.111])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432da27f4f8sm72122775e9.18.2024.11.15.16.31.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2024 16:31:38 -0800 (PST)
Message-ID: <b61e1bfb-a410-4f5f-949d-a56f2d5f7791@gmail.com>
Date: Sat, 16 Nov 2024 00:32:25 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 06/11] io_uring: introduce attributes for read/write
 and PI support
From: Pavel Begunkov <asml.silence@gmail.com>
To: Anuj Gupta <anuj20.g@samsung.com>, axboe@kernel.dk, hch@lst.de,
 kbusch@kernel.org, martin.petersen@oracle.com, anuj1072538@gmail.com,
 brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, gost.dev@samsung.com,
 linux-scsi@vger.kernel.org, vishak.g@samsung.com,
 linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
References: <20241114104517.51726-1-anuj20.g@samsung.com>
 <CGME20241114105405epcas5p24ca2fb9017276ff8a50ef447638fd739@epcas5p2.samsung.com>
 <20241114104517.51726-7-anuj20.g@samsung.com>
 <c622ee8c-82f0-44d4-99da-91357af7ecac@gmail.com>
Content-Language: en-US
In-Reply-To: <c622ee8c-82f0-44d4-99da-91357af7ecac@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/16/24 00:00, Pavel Begunkov wrote:
> On 11/14/24 10:45, Anuj Gupta wrote:
>> Add the ability to pass additional attributes along with read/write.
>> Application can populate an array of 'struct io_uring_attr_vec' and pass
>> its address using the SQE field:
>>     __u64    attr_vec_addr;
>>
>> Along with number of attributes using:
>>     __u8    nr_attr_indirect;
>>
>> Overall 16 attributes are allowed and currently one attribute
>> 'ATTR_TYPE_PI' is supported.
> 
> Why only 16? It's possible that might need more, 256 would
> be a safer choice and fits into u8. I don't think you even
> need to commit to a number, it should be ok to add more as
> long as it fits into the given types (u8 above). It can also
> be u16 as well.
> 
>> With PI attribute, userspace can pass following information:
>> - flags: integrity check flags IO_INTEGRITY_CHK_{GUARD/APPTAG/REFTAG}
>> - len: length of PI/metadata buffer
>> - addr: address of metadata buffer
>> - seed: seed value for reftag remapping
>> - app_tag: application defined 16b value
> 
> In terms of flexibility I like it apart from small nits,
> but the double indirection could be a bit inefficient,
> this thing:
> 
> struct pi_attr pi = {};
> attr_array = { &pi, ... };
> sqe->attr_addr = attr_array;

We can also reuse your idea from your previous iterations and
use the bitmap to list all attributes. Then preamble and
the explicit attr_type field are not needed, type checking
in the loop is removed and packing is better. And just
by looking at the map we can calculate the size of the
array and remove all size checks in the loop.

-- 
Pavel Begunkov

