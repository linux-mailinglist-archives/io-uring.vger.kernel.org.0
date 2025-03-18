Return-Path: <io-uring+bounces-7105-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 42C8AA66B8A
	for <lists+io-uring@lfdr.de>; Tue, 18 Mar 2025 08:25:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 52F6B1898EAD
	for <lists+io-uring@lfdr.de>; Tue, 18 Mar 2025 07:25:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 697411BC099;
	Tue, 18 Mar 2025 07:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LK42TZvp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863761DED4E;
	Tue, 18 Mar 2025 07:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742282699; cv=none; b=eX6hIvYyp7kH/szwsLj2nuN1idnLtorlDYns+TPmkS42stzMJ6JMjAlPtmDYBQUWFRySaHvnn/Qs8k4/+FV1czZgwMxa+6pcMv+If6Hswanxf2dH1MjEJIwSRjmS64pGGGZim5bdbhoh/KicktFa63d/ctZn4Khq0CIit+lx4AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742282699; c=relaxed/simple;
	bh=uK1IjAzG1Sye3ZU1ap+/nhEU+DsTRtYza3G/qzGdO8c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m1nyImpe+x3Anh3khLrco8IB3wAoHo3ZQGLrYZrT+WIQ8m+FwUK6hUT8TDHJKDrd2J04dPvXw+VNtCjEcl2Njt38gYyRjYLYIjuINVI4tPctEedZVU6PdA2U5z4Tjz/hmrAdxz3I7YNiiFSj2rECOzRL7JNiBWhfrB6iNr5Gm4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LK42TZvp; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43cf0d787eeso31352475e9.3;
        Tue, 18 Mar 2025 00:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742282696; x=1742887496; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=acNOCXS5KJbB/aI02vlBq/a0DxGet8J/0jBkVYDk+Ho=;
        b=LK42TZvpwUmjauuqbYHlo5J45bv9HDH1EjHyqEhGkNbGJHYrhe3C/M2uUVHM9L2tdq
         EOQk9KK/+OQ2tuuh+4lNrk4OFa7bWKeel9NYwGzlx4XhYnE8ARReEeVInOgdjWOukh3r
         +CezHDAPrjHZoBlsRCRsK1JJwbYCKGAaQ/j/dCpdw4+OPen1iIwRHc6AxrF7ZxUgXLww
         5kBfyAG5hru3hZ9rPnUyQpO0rGIZvzGqM5bA2M8BKMRNzP5RNOjt5SZoj9zPR1R0vJFq
         vi7j8XbONm2YLUW+PB3E0ep23n5Q1Tnl/TZAroMPdwme/vMu1B/8FESu+36BsaKCdFXa
         SqBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742282696; x=1742887496;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=acNOCXS5KJbB/aI02vlBq/a0DxGet8J/0jBkVYDk+Ho=;
        b=kBLG0xsnbNZ5Cd5QZNJH8k6fupE7sRQhL+7aRpY2HK/oBGEnNCQl1y1ohPwp/ZrgIH
         eJlT5Czh8gTfPw9zHcAirzG/tnvShVMyuvQzcFTBNYdRTIUWb7PmFIol96YGT8gY/cFp
         3FRXMDqOh8FL4vzr0vtsN58TI1tkITw0S6MUEl6y+1zw/9PMtumakdZnlAca4B0XhtOy
         2hEmr2bL3MgQhxXfx+wZkGNlFBTPpPch98zG37AiUCyAtD6F12k5qmwhnU7qaEqDdWct
         8W/24hbWcSukvrtG4CecSiEpFJ9WZPsH9V6/HDTl9wCuil5wScyu0Znv5t5zZTE6kd+0
         q/0Q==
X-Forwarded-Encrypted: i=1; AJvYcCV978VEojbDdg9MfFfrjf8sNlXyY+2WY2HoLgWlm9fuftuH9bO3NZe9BwFpz940jvMgtmyLkSuiRJjTOU4=@vger.kernel.org, AJvYcCXCqW9WSj1MC3e9zV4g1a8W1S9zb8GwQeJUWoewIox6hqwPi4qAyaIihqv7xR+KgY7UUDeBiMXoQzcX7EyG@vger.kernel.org, AJvYcCXpzLIrG5w800khxuGgfacJMNq/EIqL2MViEOuyDRCSFtA/pENQqGUbozJQavwv1f012KCFTiZaXg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxEuSaVSrbYh2rbcY0rA1rTyXRCMsEvqfzNZjqdghNMEI73rqzR
	EByb3qPoPhlCxvT20M3VXgVxHYZejLwl3J10aa3sNmBnx7GOBRn58TFhDEsH
X-Gm-Gg: ASbGncunFRAS9n/vUhAStqpc96X5x3LGf2l0Z7NZwUEPbobJv6bGNdXJmFgitmD+Nub
	Cj8dPkPLTna+UxAJHoF/dzSI9a1ijeayIdFgzjqvsQnCB9dUNtUV1I2MG9MBnAapvthakmfhgK1
	DK5xAMU+/yynzNiWUmzFGKfGkBRAnQfPEhs3FVkegBpGaq6f56zgHZxTi/txtrGciFeovSy42hb
	ardsNASIjeiDxhHez4hr7DvQ7I01mbnKAod2VAFvD6e4spUxwWEDO4T9/sdNs7nlZfUvsZ0ri3e
	E/aiKy699p8bk4CeghhBkgl5vLnA9fpDFXI14Zixnkc7ARFPK4avG01Ve5bHwKvpYYGEDNZBgQ=
	=
X-Google-Smtp-Source: AGHT+IEneGUK3W2IG4isGQlFaWEXfabalN5oQPlvzTV0ocYoSiPZzfc0jYUcf2Xy975SWkrwZDtbzg==
X-Received: by 2002:a05:600c:1389:b0:43c:fdbe:439b with SMTP id 5b1f17b1804b1-43d3b951a25mr10127415e9.4.1742282695520;
        Tue, 18 Mar 2025 00:24:55 -0700 (PDT)
Received: from [172.17.3.89] (philhot.static.otenet.gr. [79.129.48.248])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d200fae4asm126660125e9.27.2025.03.18.00.24.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 00:24:53 -0700 (PDT)
Message-ID: <566c700c-d3d5-4899-8de1-87092e76310c@gmail.com>
Date: Tue, 18 Mar 2025 07:25:51 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 4/5] btrfs: ioctl: introduce
 btrfs_uring_import_iovec()
To: Sidong Yang <sidong.yang@furiosa.ai>, Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org
References: <20250317135742.4331-1-sidong.yang@furiosa.ai>
 <20250317135742.4331-5-sidong.yang@furiosa.ai>
 <3a883e1e-d822-4c89-a7b0-f8802b8cc261@kernel.dk>
 <Z9jTYWAvcWJNyaIN@sidongui-MacBookPro.local>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Z9jTYWAvcWJNyaIN@sidongui-MacBookPro.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/18/25 01:58, Sidong Yang wrote:
> On Mon, Mar 17, 2025 at 09:40:05AM -0600, Jens Axboe wrote:
>> On 3/17/25 7:57 AM, Sidong Yang wrote:
>>> This patch introduces btrfs_uring_import_iovec(). In encoded read/write
>>> with uring cmd, it uses import_iovec without supporting fixed buffer.
>>> btrfs_using_import_iovec() could use fixed buffer if cmd flags has
>>> IORING_URING_CMD_FIXED.
>>>
>>> Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
>>> ---
>>>   fs/btrfs/ioctl.c | 32 ++++++++++++++++++++++++--------
>>>   1 file changed, 24 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>>> index 6c18bad53cd3..a7b52fd99059 100644
>>> --- a/fs/btrfs/ioctl.c
>>> +++ b/fs/btrfs/ioctl.c
>>> @@ -4802,6 +4802,28 @@ struct btrfs_uring_encoded_data {
>>>   	struct iov_iter iter;
>>>   };
>>>   
>>> +static int btrfs_uring_import_iovec(struct io_uring_cmd *cmd,
>>> +				    unsigned int issue_flags, int rw)
>>> +{
>>> +	struct btrfs_uring_encoded_data *data =
>>> +		io_uring_cmd_get_async_data(cmd)->op_data;
>>> +	int ret;
>>> +
>>> +	if (cmd && (cmd->flags & IORING_URING_CMD_FIXED)) {
>>> +		data->iov = NULL;
>>> +		ret = io_uring_cmd_import_fixed_vec(cmd, data->args.iov,
>>> +						    data->args.iovcnt,
>>> +						    ITER_DEST, issue_flags,
>>> +						    &data->iter);
>>> +	} else {
>>> +		data->iov = data->iovstack;
>>> +		ret = import_iovec(rw, data->args.iov, data->args.iovcnt,
>>> +				   ARRAY_SIZE(data->iovstack), &data->iov,
>>> +				   &data->iter);
>>> +	}
>>> +	return ret;
>>> +}
>>
>> How can 'cmd' be NULL here?
> 
> It seems that there is no checkes for 'cmd' before and it works same as before.
> But I think it's better to add a check in function start for safety.

The check goes two lines after you already dereferenced it, and it
seems to be called from io_uring cmd specific code. The null check
only adds to confusion.

-- 
Pavel Begunkov


