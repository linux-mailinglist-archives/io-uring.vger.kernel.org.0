Return-Path: <io-uring+bounces-4646-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C6389C7049
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 14:08:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C3B21F2802D
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 13:08:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 670171DF73B;
	Wed, 13 Nov 2024 13:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hac8ctGg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF134433CE
	for <io-uring@vger.kernel.org>; Wed, 13 Nov 2024 13:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731503333; cv=none; b=Y6MrKPkYpiLSJIM+Gt9NBboifKHsykZk2Qos/BJgL5SjdokrGU1TD9mOOq1W6maWglpyFQ+S+SqYm6AKDXGCXM0vxsgxjva18VtSE+M/GY84/8+27V6kRbtpHRhgcDOhPQzyZAP6qc6Qq5NMtQdlIkHf/PfgPic4b3c7gRrrVl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731503333; c=relaxed/simple;
	bh=RN3W75fb/pKoBQIbPtQrZBnvIv/4GCnaACgWVIN13bA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ioBNamd/YsFNKzB5GZDRfyPA+nN63Ko/41SXz4Wl/5gzkjxvX70kfAjwaNOokPPEf3ECuwKmLdrbspfb1oWUCTjcKzotIqrYbzHaMVd5ciOzs09ZifDZgp1DPRSevPXX4kdPh5uyl4a9bMDDh0O63JAuyzfmCtEUQH34/Jq082Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hac8ctGg; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a9a6b4ca29bso972461266b.3
        for <io-uring@vger.kernel.org>; Wed, 13 Nov 2024 05:08:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731503330; x=1732108130; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d4JL/aqwBtJeBO1OqNew9P6aEWbj1eMGx764XAo1wF8=;
        b=Hac8ctGgi6AmubXEalt68UoiHjRi50b7O/3EIKEbX33dQ6FT6HUJIDSwkAHBDunb5W
         J6lyNKPo06FsoKh9qapAsFSV76WM8CvM/+UXmouN5bppdJGPd+QE2Ar3CB2RGg5A9Mo8
         ve/F+zQimHWc7F3RlBZwdQDDaN+iI+23h88k9uNh9/W10l4yzRuQa6virjsKPiBvsapR
         CrndIlparKCEVvBsPPu13ZZjhKKK7bUAJycycTYxmOWG749YHSZpPsxtG3qmPrXopKFw
         2GlR08DNCIwMO8UK5KO7TaM4MtyCvSAqfT6HdU1aqir2KnKpkojFCxE7bTyJiNzvQ+ZG
         squw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731503330; x=1732108130;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d4JL/aqwBtJeBO1OqNew9P6aEWbj1eMGx764XAo1wF8=;
        b=ansHrrbMk3223NN5PAV2s5cdewf3949uI5pNR1LoCnuecJoQa0THZ4SiG9s8o+YZGp
         lnHi8m2VCobvMC1zq7HPxNz3UNqmxJ1I7mHtnCwnnDdlVtESlkyrxXCEu/ZsECyIp5Y4
         4ueCDC0dwGb04lp3U9oN+EXJ3PD7rtjBFmCQiHFsFvWTotD/vLrFIeRVu8ZMPsJshzbF
         mhv83erMF1eSodLOZ+0kXNOhGKT3AFpjtFNAnHfvaQVLUe44SHmFx4e22ybsC6GxyWQV
         Gm+wHgWODpMvshG3Ey6f9B9ICXVqrPu26cZ3hHTPnwFs0iZNbxue8InbsvVLMezXE2HJ
         L7zw==
X-Gm-Message-State: AOJu0YwiiR5iBTbZwOIq9D9NV0pS7Wi53ryI/lOtLL2u5zobvTU7aCQ9
	bRnV6ZRD7EIJzmr00FGRToX5fJ08pqHfdXqXcko4vL+npqcSCht/3PLX7A==
X-Google-Smtp-Source: AGHT+IEZ9riYsDjaCTrmGop+XyTM7cPVOKdUgkeIsPm9RHcrZLHf6zA/+VMyMqcE7myWw2qxZopRCg==
X-Received: by 2002:a17:907:3f05:b0:a9a:80bd:2920 with SMTP id a640c23a62f3a-aa1f813b6eamr249682666b.53.1731503329786;
        Wed, 13 Nov 2024 05:08:49 -0800 (PST)
Received: from [192.168.42.17] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9ee0a4c210sm861389766b.78.2024.11.13.05.08.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Nov 2024 05:08:49 -0800 (PST)
Message-ID: <c21ae1b0-f630-481a-afdf-79b6db2942c8@gmail.com>
Date: Wed, 13 Nov 2024 13:09:39 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 2/3] io_uring/bpf: allow to register and run BPF programs
To: Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org
References: <cover.1731285516.git.asml.silence@gmail.com>
 <cffec449e9f6a37b0701f2a8fdd37688db25be55.1731285516.git.asml.silence@gmail.com>
 <ZzRhnDXxkahNB0rx@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZzRhnDXxkahNB0rx@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/13/24 08:21, Ming Lei wrote:
> On Mon, Nov 11, 2024 at 01:50:45AM +0000, Pavel Begunkov wrote:
>> Let the user to register a BPF_PROG_TYPE_IOURING BPF program to a ring.
>> The progrma will be run in the waiting loop every time something
>> happens, i.e. the task was woken up by a task_work / signal / etc.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
...
>>   	do {
>>   		unsigned long check_cq;
>> @@ -2879,6 +2886,13 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
>>   		if (ret < 0)
>>   			break;
>>   
>> +		if (io_bpf_enabled(ctx)) {
>> +			ret = io_run_bpf(ctx);
>> +			if (ret == IOU_BPF_RET_STOP)
>> +				break;
>> +			continue;
>> +		}
> 
> I believe 'struct_ops' is much simpler to run the prog and return the result.
> Then you needn't any bpf core change and the bpf register code.

Right, that's one of the things I need to look into, I have it in my
todo list, but I'm not sure at all I'd want to get rid of the register
opcode. It's a good idea to have stronger registration locking, i.e.
under ->ring_lock, but again I need to check it out.

-- 
Pavel Begunkov

