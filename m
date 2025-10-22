Return-Path: <io-uring+bounces-10116-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9177ABFD65F
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 18:55:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CBA8B18820BB
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 16:54:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC87F221FBF;
	Wed, 22 Oct 2025 16:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UqZOb1D4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD2035B13C
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 16:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761151912; cv=none; b=GR+jngDYPyBr6ZIkMed0NBYHIU/TzsrNxk1KtAgdKP+n/5A/tkRNGupBhG1+/2teuqA9yJ0U/JkeWwX9YfewnrlyfsriY93LieynpptVx5XQNLfhSe8gr/rSldptYM/SFtr+TyyLPcVNVZS1r5111QXsAcxNwqCSowmXZJmM/B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761151912; c=relaxed/simple;
	bh=FHxQBxehiKd+2OJLErQhBAycF55sbrjXqKybW9Rkxv4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=emRw0/hHFhDth2LjuH7tnCn591DyT82U8grSF0xs11UKd0vTp/qqrsDCRDlnBZCdm3CzntteIRnzz96yqNFAB2+obBrTbn//ZgbCqiNwo7Jpz2lzIZ1r9Hr6Gxjf7Vqk02JM66P7HL81AvfLQCyYhTx+xXMHNGpM/FDZaHO53X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UqZOb1D4; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-47118259fd8so45493295e9.3
        for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 09:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761151909; x=1761756709; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8MoXXfOSKn6ep3VY2AlKDkKcGxJOplW/KlCkvyC4mvk=;
        b=UqZOb1D4AFRYwCp9djHswQA/5Za7kV7FlTUi7DJGNhQ6cVVQE6WFp0uxW4dA0Mqu1f
         /rAZGRZPeSJab8Jhx/LqN8R4nyrluInKcNsZHZCZAmgFE4obkb0rvEKwE5mNUWX+jt4U
         Ji0WCzbxJ0u6bgvyCLbSbZWQxp6RARjt7dH4iZSIeesiw23AUB5zQMGE46ieoLQkZHi+
         visEtVAWceXGxD3D7nTvnXLQWX6czZE/m8JSqPih7l0FRtnwTw+B1mOBCAekJU8W7QvB
         Rz6WVgD9gv9V/3W9u6mvJZTru3pBEvt1tEWoDr93XhcUo18LaeRRBN5ncZ6JwosyWr7U
         pZNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761151909; x=1761756709;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8MoXXfOSKn6ep3VY2AlKDkKcGxJOplW/KlCkvyC4mvk=;
        b=bHKdtlXVFoFl49CIVnVXghq5BBefNxq9L8Zws0FAkAEiDM7ZQuCtC9eA9EEU4baWUt
         ozk+jKOMm6UKZLtTGmHCKFOZ6nGIErEpQcUzBRb31oV84fW9IEiaz1kSqSw9eYtOdzmQ
         +k+ApphbUBubz//tpKwLJW2FZ68W64p7P4YwQMEU902JtgnDN0zbM1cP7SGYzFuXTn7u
         Y4LwjURUima+7X3uZoNcpdZe5GkUj9lbGtPs4ZbJdbjKa0paoUB+Pt3sLtqDUWloFkXc
         /di4Sm8vBnN/mG2tIAKch5jEl+XXGm4Ofjx1emZoGXewgzSJhGMo1KlLmh2/GUON/Zf9
         tO2A==
X-Gm-Message-State: AOJu0YwT9yQON1/i0+Y6UixdLz2AAYRKH2bT/7viJkRBpQYXnVdDxu+r
	F0PB0WPafAnVf9t2FQesGlOK2SciJi8G/7jonqxmLJvl0nsxkxFaxdaU
X-Gm-Gg: ASbGncv0e4MJNM6FSjRl3zfk6fsv9loPUK5YM/MgE9V8SSMOP8rJDO0Ypmyo6I86mTe
	Qv3J6pd4Lwn14yb8mNREzUHS6mA2YibDdv3UMPYz480hMZFAqcw4EvrrZ7dzs0mM7TKlmj2BdgW
	ZG5d1ZlQCKU3R+PU9h76PMym1depdxinwus7seLUNvjfEXc+bYgAlc/WyY98eLvdCabvJ71w2rx
	KuXKlcZFC/37p8Pw2sm9+rmmWngro9ahdl1zoqVkUMb722hmGY0VC+GCsPaVMgP3RiISA5Uw0aO
	d1yVZyAVQbXuqTBaRmGahB6dXHh51fggtrbHMC+qKyYHZy33ywBc/UXHlGe3VbiDhRxm19PbChZ
	1fRejEsr0hUC1HH7779IJBIwC/7x2DrrIh3WsokTmzVgOA2YVYXhiFzJpdE6Jm2iq/mZoZqZLpc
	pXcoUJZZhM9+Nvb6z8tFCjloTcIZR1kIfIANL9pcWb/U8=
X-Google-Smtp-Source: AGHT+IH6qtsTqGpvmGd0m01ZFY2KHTEvilZtzSWjVBlHHl0BdpOAbCNdOeqMxYHD4Z5Bd7DNjq96rg==
X-Received: by 2002:a05:600c:64cf:b0:46e:3dcb:35b0 with SMTP id 5b1f17b1804b1-4711786d332mr181919645e9.2.1761151909023;
        Wed, 22 Oct 2025 09:51:49 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:b576])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475c4281314sm51788185e9.4.2025.10.22.09.51.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 09:51:48 -0700 (PDT)
Message-ID: <355c371d-124d-4414-9af4-fd9247692db3@gmail.com>
Date: Wed, 22 Oct 2025 17:53:13 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring: check for user passing 0 nr_submit
To: Jeff Moyer <jmoyer@redhat.com>
Cc: io-uring@vger.kernel.org
References: <9f43c61b36bc5976e7629663b4558ce439bccc64.1760609826.git.asml.silence@gmail.com>
 <x49sefbyrkk.fsf@segfault.usersys.redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <x49sefbyrkk.fsf@segfault.usersys.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/22/25 14:49, Jeff Moyer wrote:
> Pavel Begunkov <asml.silence@gmail.com> writes:
> 
>> io_submit_sqes() shouldn't be stepping into its main loop when there is
>> nothing to submit, i.e. nr=0. Fix 0 submission queue entries checks,
>> which should follow after all user input truncations.
> 
> I see two callers of io_submit_sqes, and neither of them will pass 0 for
> nr.  What am I missing?

You're right, we can drop the fixes/stable part. It's still
good to have as it's handled not in the best way.


>> Cc: stable@vger.kernel.org
>> Fixes: 6962980947e2b ("io_uring: restructure submit sqes to_submit checks")
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>
>> v2: split out of the series with extra tags, no functional changes
>>
>>   io_uring/io_uring.c | 5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 820ef0527666..ee04ab9bf968 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -2422,10 +2422,11 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
>>   	unsigned int left;
>>   	int ret;
>>   
>> +	entries = min(nr, entries);
>>   	if (unlikely(!entries))
>>   		return 0;
>> -	/* make sure SQ entry isn't read before tail */
>> -	ret = left = min(nr, entries);
>> +
>> +	ret = left = entries;
>>   	io_get_task_refs(left);
>>   	io_submit_state_start(&ctx->submit_state, left);
> 

-- 
Pavel Begunkov


