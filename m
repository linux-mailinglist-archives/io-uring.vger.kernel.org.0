Return-Path: <io-uring+bounces-8667-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 25868B0447A
	for <lists+io-uring@lfdr.de>; Mon, 14 Jul 2025 17:46:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 953D07B3932
	for <lists+io-uring@lfdr.de>; Mon, 14 Jul 2025 15:35:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DA7E25F7A9;
	Mon, 14 Jul 2025 15:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K4BrLSp+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5139265CD4
	for <io-uring@vger.kernel.org>; Mon, 14 Jul 2025 15:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752506958; cv=none; b=Mivh6SbRlvAIC+U/IhH8C3ZAHmhlbTAwJbNVoYbGD5uR5II2gJ8KQlghOqtmvuAPGDoSbRvH+DaMVZTcyA1ExD7VK8k/ajGv8Lhqrbj8j/Xqec8PeFoPbrrEzqx+LOn9hSPYCUU0pwSxBTIY61iYhVaffvVS/n0SgNl1+wuKe+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752506958; c=relaxed/simple;
	bh=/stGmoSAfy4Qrmd1idshauK+hqEKcE9JUfNWmZIhaVA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kAPPTPQzDE8f5p8QtadaTWZuz2VH4CNYlzDb77YHrgMYTQSBoZAyIrgU3nMsAC7mlWgtws8cmR3YmzqzXKphDSRF2ZJvm+uiClJJEaJ2zot2tEcBCMDWZYAl8fVKfqmzIRLxIZLaTeT2KmuwBDkyuItQ+eYGsyuuOs/Qvoz2he0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K4BrLSp+; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-60c01b983b6so322868a12.0
        for <io-uring@vger.kernel.org>; Mon, 14 Jul 2025 08:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752506955; x=1753111755; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IuifBKkTk9t4KUoDVG5UZiRL1Q9rlxva2Ukxg/QsMIk=;
        b=K4BrLSp+FlCzrX7ul0OJl1uoMQn7kqnVc62df945ZbGiXIKX1ncBP+A3kXoE/czWCN
         sLNPKyS73F5FgaV9bndMPFmvAR9oEnOw9M1/ZFnaxg/OtrnQtYb6kjssYxLD+fmOMzZf
         CzFL1kOhsms+JjopFdmy9GZr9i1z6o9K/G163K2R9uLmm+UWx6zmHFi4lK4SXQflNnj/
         WBFIyZicSLpsQIbLXja/o97fRjLkuFL2KRFiaueyeUCaYIrbSA/NrtIzcvQozd7IqkT/
         bG/Ybw9Z2hNhpWAW/c7DNLU6QHwC25bcYrF1JftuRwhNzBsFHme33V+evoex9G1Q3Q81
         MDCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752506955; x=1753111755;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IuifBKkTk9t4KUoDVG5UZiRL1Q9rlxva2Ukxg/QsMIk=;
        b=qQJH5aq14dcXDVlLtdkEsSpwGi38BqD/n3x8qiZ5gdGq6fuz7ddENDUisjXOkJLDxT
         rMh1/4HDjSbdMSOdiUlX0j86TCJDQK5A80XT87ZRCwlzY4mDYXqXJlFaqjmv4hJydFge
         mR/niFY25bL/SItGw/5IZHaZZ/eLWYaB4Jn95gOA+gHEo5cq8cNLXUEmlHCkJP7r1Xsn
         exMK1OdmuM/DxiLuoW+0gwtTyLzrhuUez5m4e5e4/pouPQYnBLuRp7Daa112twu/T95S
         RWdzbXVQNlRhzyrBi4EtquRsqRo+pFdg8U0BN3CGUqR2tO3gG9+bXLeGBxMLvWp4tXXb
         cfhQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/tpd3vebNop2mG69GXdKr0t8YzGc20gWLPkkL9cw8ivd1/0MGatSfOI2bpiyUGN5ujnFkRLqAnQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxj9abSIK/5YTxKMw0+6LWWqSuIZyyT5/8m7M9VBZTFdtfE2DCQ
	krYQs0RBQPElL3w8FvzM7pJ7IFIG/uXzdkaq+2J4/Sm9481LSn83nrwunK/Y7A==
X-Gm-Gg: ASbGncsuPb1IT9s2oqwifQIBFPeda9ljtpca5zaVs3suNEtZPXQ0K44e+4HChcuI73A
	Oib7Ny89dRc8N2kFMcjwHsu/D8BXjuERUMAL96SX1yLTso/SM1U1DPfSGRQMRIqeOS6bnVOQ5OT
	Kf+GdZ6oR1ffSq/MFC7g7yrhmPhlP5ifLvejDjD/yQHurokT7f/hjRXXN/XYwR5j0zOcBtT2JqW
	Wkwj1z4OuSVVGD3LOOdoxbJfrb9t9TN+/CB2rMkU5GG/ykErzvV+boLmiyhu3UFREd4+5SudMlz
	TvcpUe90EE6Ijpvxe/pY5zxkd39pfIeurnFet+9eXN8vNzS8GUhZDYp8N9v+9sQduE1OzIHDtr1
	iRu0dgoquk+/AAGIXPrhED14KshJiwmaOsIn2eu6s
X-Google-Smtp-Source: AGHT+IEX2e8k1LujP1iJKyGNV2AcMViP/UZ3YTM/qwSerESvJuoZN6oDba7Y1cmtmFJ8DZ0V5DL3kg==
X-Received: by 2002:a05:6402:27d4:b0:607:293:fd6 with SMTP id 4fb4d7f45d1cf-61265d0e6b6mr45217a12.0.1752506954551;
        Mon, 14 Jul 2025 08:29:14 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.234.80])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-611c979893dsm6172822a12.81.2025.07.14.08.29.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jul 2025 08:29:13 -0700 (PDT)
Message-ID: <dd1306f6-faae-4c90-bc1a-9f9639b102d6@gmail.com>
Date: Mon, 14 Jul 2025 16:30:44 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/poll: fix POLLERR handling
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: dw@davidwei.uk
References: <550b470aafd8d018e3e426d96ce10663da90ac45.1752443564.git.asml.silence@gmail.com>
 <62c40bff-f12e-456d-8d68-5cf5c696c743@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <62c40bff-f12e-456d-8d68-5cf5c696c743@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/14/25 15:56, Jens Axboe wrote:
> On 7/14/25 4:59 AM, Pavel Begunkov wrote:
>> 8c8492ca64e7 ("io_uring/net: don't retry connect operation on EPOLLERR")
>> is a little dirty hack that
>> 1) wrongfully assumes that POLLERR equals to a failed request, which
>> breaks all POLLERR users, e.g. all error queue recv interfaces.
>> 2) deviates the connection request behaviour from connect(2), and
>> 3) racy and solved at a wrong level.
>>
>> Nothing can be done with 2) now, and 3) is beyond the scope of the
>> patch. At least solve 1) by moving the hack out of generic poll handling
>> into io_connect().
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 8c8492ca64e79 ("io_uring/net: don't retry connect operation on EPOLLERR")
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   io_uring/net.c  | 4 +++-
>>   io_uring/poll.c | 2 --
>>   2 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/io_uring/net.c b/io_uring/net.c
>> index 43a43522f406..e2213e4d9420 100644
>> --- a/io_uring/net.c
>> +++ b/io_uring/net.c
>> @@ -1732,13 +1732,15 @@ int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>   
>>   int io_connect(struct io_kiocb *req, unsigned int issue_flags)
>>   {
>> +	struct poll_table_struct pt = { ._key = EPOLLERR };
>>   	struct io_connect *connect = io_kiocb_to_cmd(req, struct io_connect);
>>   	struct io_async_msghdr *io = req->async_data;
>>   	unsigned file_flags;
>>   	int ret;
>>   	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
>>   
>> -	if (unlikely(req->flags & REQ_F_FAIL)) {
>> +	ret = vfs_poll(req->file, &pt) & req->apoll_events;
>> +	if (ret & EPOLLERR) {
>>   		ret = -ECONNRESET;
>>   		goto out;
> 
> Is this req->apoll_events masking necessary or useful?

good point, shouldn't be here

-- 
Pavel Begunkov


