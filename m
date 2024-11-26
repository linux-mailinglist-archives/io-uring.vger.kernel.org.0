Return-Path: <io-uring+bounces-5053-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 20EEB9D97E1
	for <lists+io-uring@lfdr.de>; Tue, 26 Nov 2024 14:03:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B5442166C2E
	for <lists+io-uring@lfdr.de>; Tue, 26 Nov 2024 13:03:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C47DD1CD219;
	Tue, 26 Nov 2024 13:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B4l3bgYz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFD72F32;
	Tue, 26 Nov 2024 13:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732626226; cv=none; b=ndkK1P6eFxj1lgdBKA6l+96eyEIDbrE+kjkhtw/xYDihxf0MbTTCVjrQmNuF8OFgDlTOj12c/56qeDyx3JCLKSiuk4q1hIzFPoLEkMph+EcdCIsCD3YhTmFbYXkDBFRAVXhiijNVKj43Z/6euFjywrkNkg+HNeG+9zfh9VCJ6W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732626226; c=relaxed/simple;
	bh=FXB4PuxmOEd2vZ5z4u6K66VlomCc0+/oFMfpy5SDFF4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=MgTo3OfFo5BFWuUGeRfcXV/VKOgdOZIpAMLIV5/oEr6o7+Q1ZfDluI7Cut3slBnRN4e4vRu2/JoRRibslomEPKImT9ixUSSDlciPNhBo1jqIqSl2G6isIqsS0wvZQQCwuGjfCfVxolXik3cTOeufbz1mc+WgsT9U0Z+o50YPZ44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B4l3bgYz; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a9a0ec0a94fso796860066b.1;
        Tue, 26 Nov 2024 05:03:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732626223; x=1733231023; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=M1sK9vv1q3OjkhDWkUYaudPgFH+wG3hp3SHQxCzra7k=;
        b=B4l3bgYzyHLJHXkaMH7IpUJNzgIJvFaF1GjAqjvdM/7gr3UF5BuirYlDmXyxma21WT
         coZOk/enFsEOb/iqEsFrivR8XuKPa+u6G2CMM/4wfxWGO/d+EkHl33HJOlERHhq0WT7W
         aQ5TbqYQqDE6jS9Sy5vDowJ9K0B4wbQf812Vc1egLACiLN39b6NMO1LPJ6QJmKDnJFJQ
         BZCzM0rWoVZ2A83QAp8FCmbu30CIcBr/x/mSKhEmf8PsqC6uREFwBkj7HbkyCzpZSFfx
         WFAP+kJGPewIxv+C1EmSji9R/H3oXNz++cfL7gtEkmdl7F/wM7iwdzoetgJcQ14XOHui
         kwHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732626223; x=1733231023;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M1sK9vv1q3OjkhDWkUYaudPgFH+wG3hp3SHQxCzra7k=;
        b=M7hvzzWid/YgIOAPH4AanaQUgWsjrw67jmzhG4paJBaXaRIo52U0YnPBdKw2UItCVT
         e8knmkKtzFXVe4GMH5ktj+Qx7OFusluhWYZXXktcBL4/QfoSXmRxqkNaWQCWZ7pfFBro
         /ccNug6keTSjqAbjn2DN7aWzktIrOSjXkThaJESXcVzPdsOO2X0gQVMq0FH/xcpYMSjo
         yAgohNwU+EEfjs6GL61KAMBkaoziCU1ZayriT7Ju2MQMSoXF97fIFVnKtuGvYa0mY7qf
         LoX85CuEhTPmB/Rv9Qj3HicVBlmbXm205OQy+IAQYspy8nQaYGZfzAJkYulELkoPHTcg
         U6wA==
X-Forwarded-Encrypted: i=1; AJvYcCUdIf9HP/WeBg/btYs4hnLfe8N92kLiWWZJDZe+kw9Lx8oR2bp4u/H2H2JMOIXpAqT08f5mPhqdENaUrpGOXA==@vger.kernel.org, AJvYcCVlyz2OWkHTbSiglCeL3D6CFKs1XNshNqYrd7yJaIiV9+0oKru0xvLoU3WYpHIC8sP1McPPwd/7kaV5LA==@vger.kernel.org, AJvYcCXPfrDqDWBrxOH1HS8m09HzUlhO4ujgpqXqdzlxQ/tgO5WwYx45MFUf3UI7aGy8MTmam7GW9jD3zIhQjw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3w1wiTaS6ycGdou6dD4iyXuP8/1f4j+VBD9caoZt7C79nijut
	Wd5g6Qafv4CV0dvjxxAD3Gn9xQJNi7f3Ih/e9ek4lDWQkNnuPaci
X-Gm-Gg: ASbGncuAggpSo7PAYxBFVtkhCXoaQOKRNIs/2QjnG7WfkW3hr7hFFZZ4JbiFSewnL1X
	wNWvEkSY6XGC5XK8l66u+yJjFSMpumUr5CV1Xv3ZwTKSH/y9oPpJecdTScj1/HPsfgNsVpX7EaA
	wEp275t+RdB4YM1GuH+VagkainM2jBR7CNl1hY/mw9DyI3TY9EMUIYuQxf76R0B8og4pi8jzct6
	KE456rZKN4mzMDeYdqfEmPo3+0uQmhCnYD6NUwbyh430h2TE9jjM6BLNu3foA==
X-Google-Smtp-Source: AGHT+IGUJJ67zkkw70cU7BTJtW/UZE3uVK6vKazeu4jCOhtR1atDsPsUa64nDbaBqFhJig6PgL/VRA==
X-Received: by 2002:a17:906:9ca:b0:aa5:3663:64ba with SMTP id a640c23a62f3a-aa536636946mr882554866b.43.1732626216465;
        Tue, 26 Nov 2024 05:03:36 -0800 (PST)
Received: from [192.168.42.208] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa50b2efbf1sm591067766b.44.2024.11.26.05.03.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Nov 2024 05:03:36 -0800 (PST)
Message-ID: <ad230264-62c1-4e52-b412-d951be514593@gmail.com>
Date: Tue, 26 Nov 2024 13:04:23 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 06/10] io_uring: introduce attributes for read/write
 and PI support
From: Pavel Begunkov <asml.silence@gmail.com>
To: Anuj Gupta <anuj20.g@samsung.com>, axboe@kernel.dk, hch@lst.de,
 kbusch@kernel.org, martin.petersen@oracle.com, anuj1072538@gmail.com,
 brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, gost.dev@samsung.com,
 linux-scsi@vger.kernel.org, vishak.g@samsung.com,
 linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
References: <20241125070633.8042-1-anuj20.g@samsung.com>
 <CGME20241125071502epcas5p46c373574219a958b565f20732797893f@epcas5p4.samsung.com>
 <20241125070633.8042-7-anuj20.g@samsung.com>
 <2cbbe4eb-6969-499e-87b5-02d19f53258f@gmail.com>
Content-Language: en-US
In-Reply-To: <2cbbe4eb-6969-499e-87b5-02d19f53258f@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/26/24 13:01, Pavel Begunkov wrote:
> On 11/25/24 07:06, Anuj Gupta wrote:
> ...
>> +/* sqe->attr_type_mask flags */
>> +#define ATTR_FLAG_PI    (1U << ATTR_TYPE_PI)
>> +/* PI attribute information */
>> +struct io_uring_attr_pi {
>> +        __u16    flags;
>> +        __u16    app_tag;
>> +        __u32    len;
>> +        __u64    addr;
>> +        __u64    seed;
>> +        __u64    rsvd;
>> +};
>> +
>> +/* attribute information along with type */
>> +struct io_uring_attr {
>> +    enum io_uring_attr_type    attr_type;
> 
> Hmm, I think there will be implicit padding, we need to deal
> with it.

And it's better to be explicitly sized, e.g.
s/enum io_uring_attr_type/__u16/

>> +    /* type specific struct here */
>> +    struct io_uring_attr_pi    pi;
>> +};
> 
> This also looks PI specific but with a generic name. Or are
> attribute structures are supposed to be unionised?
> 

-- 
Pavel Begunkov

