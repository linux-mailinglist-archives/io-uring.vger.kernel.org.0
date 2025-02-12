Return-Path: <io-uring+bounces-6354-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 50B45A32721
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 14:31:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A480018860B4
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 13:30:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80FA520D512;
	Wed, 12 Feb 2025 13:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M5suh/CG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25B1134A8;
	Wed, 12 Feb 2025 13:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739367031; cv=none; b=iJHGdr/8z1hoXhtZwOoxQmIuFdAgCEkxZptXfA/2ocqSvqemjGzSoDPBOR1las6RTdHJ70rRNVOLq22YnCTP2RhhkYsT5H+ThuPQAP6LfDIMQ7xsx8NO7LfwySXwpS24bT5rdogDdeqAcM4Tl7IM6jnz+KovHP6ZmhBABHXFamM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739367031; c=relaxed/simple;
	bh=x8AYOnMF7PRVPfCYpeD0g4I5hOenk7Y0XPRJuJ6O6PU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J83uCL44HfOeGBYHst/1W3UP/qkuaDCgc+eCtrEUzvtIDAHo6sp8SXQ0zRy/8iVLXePelF6teXSLUA3Dp+KaKalLEm2Za/au9qx4+N6ibdfoNVNR4hDw7F+0HcJcLxDFyEfB/tmX1eOdS7cQqc4AuM8+pp+JIY5TYveKWHwh5Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M5suh/CG; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43944c51e41so35186905e9.0;
        Wed, 12 Feb 2025 05:30:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739367028; x=1739971828; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QFUpAYQ/EzsN4696Aznq2jleqF4aGdSY4M+7/WbykcI=;
        b=M5suh/CGClE5CJoUtp7EKI4oEr8g8ymVkfs9G4m11+ERNf7mZZWjsSCebba1OzDBe5
         K+yqbGUn5JQ/r4T4QxSDb6mJAEYAq4S2Hk5nz9LNUw1CCaL2oM/h9B9coWtzYi0M2NWp
         LLzMAxIzGRyIQxsk7anKNk8eF8B2SyRgPXe2Uf+oOpzoa788dweSG0JFfH9hfmH/a4yH
         9arDPI3fDFjh9kxo8FhsvkdZHhINlfVqihdJQn1PFSU2R17pltahmp3jpIJx8879/llV
         fTJjkiWGVbh8fHJ8AMF0k3Ah4lDZisPlZohSITof2HbL1PZwWMnVPLJkx6HaEcMGByEm
         SXTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739367028; x=1739971828;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QFUpAYQ/EzsN4696Aznq2jleqF4aGdSY4M+7/WbykcI=;
        b=c90lLMvKTDqMHe20G+wmOP2lNBcUrz7iLiQH3OA8YjcQ8E+A2OABLEWzVyPgBTY7a8
         IGs335xUC9/XQ+YiD1ewqkNE+ERtOvTWveJmdb0uHg4jy2D5oa6CaaPfEzcuJkz17TSq
         ZRyUOcGKKGJ+uu/sqLV1g1Lri06mujZDu/sek16qThQ5YuYQw3VpDj3gxBSYqOCPD1GL
         rRs4n2wH8ZtXWwohzCXwgJyW1i5BkYVX203lR4VdZlK67JcmkraUSm0UJqs+biTqA+dZ
         ey/ohyWqDJPGOdr7QG6rkXLw4LvP42A7m5dJhxgVWej/EUEUdlwQ0q0BcaLY/yKd0key
         qeIw==
X-Forwarded-Encrypted: i=1; AJvYcCXdZ0Z77ul/mMd0s67f4q9I7U+2+cGHy/RE7ofaEZCPw2gM1Gl6mARh0V8QPWg9n0FtXwsSbBV7YKgK480=@vger.kernel.org
X-Gm-Message-State: AOJu0Yym3IcOhXG3P8PMyfN6g9A76jOALWJB2jItzKLnXkyiP7VJHTGS
	+SQ/JjSPk0ZiCyPz99iIP+n8rCce1ToTAR+cNH52L/bwxZFNEvJzJ4Yssg==
X-Gm-Gg: ASbGncuDH9UVb/EQQoxTFtmiOCRatIamiQIWZgJaCxLb/3qxS4G75u7cOF7uZw3l8AT
	TOWqdgcG+0sVi3si3fXIXa82rQHnkTTanDn4VNAgvTW/d5RXcv0q86MgwZ55VwVV8ZtyRdJRsPd
	un4KdbTUPncmhXSPgrlOMEDmnOMRhighyjkZNCCCqjPhY6ebyfmEdm7BlJMRDAz7T4VH5CoXGoc
	tPuXuzkKKb9wRAEyMoaM0gNN7ZkBdN6KdcdM/ZeGjVUjUfsv/afXww4LBpAWaESUj0RxLIgZeEJ
	zyodHelAoAA0dkxRM3m1P2/s
X-Google-Smtp-Source: AGHT+IGRnXj0xPkxw+QISfZ5uRdPjMB50w6jdYQoac4xQcQwkfZCRC02jLlLBsV00Ltaxk4cGvP2cA==
X-Received: by 2002:adf:eb83:0:b0:38d:d9bd:1897 with SMTP id ffacd0b85a97d-38dea271f65mr2235994f8f.22.1739367027596;
        Wed, 12 Feb 2025 05:30:27 -0800 (PST)
Received: from [192.168.8.100] ([148.252.128.10])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4394dc1c56asm33562685e9.0.2025.02.12.05.30.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2025 05:30:26 -0800 (PST)
Message-ID: <80ba6f5e-33dc-4f06-9277-96ae99d89239@gmail.com>
Date: Wed, 12 Feb 2025 13:31:29 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: pass struct io_tw_state by value
To: Caleb Sander Mateos <csander@purestorage.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250211214539.3378714-1-csander@purestorage.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250211214539.3378714-1-csander@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/11/25 21:45, Caleb Sander Mateos wrote:
...
> --- a/io_uring/waitid.c
> +++ b/io_uring/waitid.c
> @@ -14,11 +14,11 @@
>   #include "io_uring.h"
>   #include "cancel.h"
>   #include "waitid.h"
>   #include "../kernel/exit.h"
>   
> -static void io_waitid_cb(struct io_kiocb *req, struct io_tw_state *ts);
> +static void io_waitid_cb(struct io_kiocb *req, struct io_tw_state ts);
>   
>   #define IO_WAITID_CANCEL_FLAG	BIT(31)
>   #define IO_WAITID_REF_MASK	GENMASK(30, 0)
>   
>   struct io_waitid {
> @@ -129,11 +129,11 @@ static void io_waitid_complete(struct io_kiocb *req, int ret)
>   
>   	ret = io_waitid_finish(req, ret);
>   	if (ret < 0)
>   		req_set_fail(req);
>   	io_req_set_res(req, ret, 0);
> -	io_req_task_complete(req, &ts);

This thing will need to be fixed first


> +	io_req_task_complete(req, ts);
>   }

-- 
Pavel Begunkov


