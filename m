Return-Path: <io-uring+bounces-8523-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1829FAEE4E4
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 18:44:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F1D8B1641D4
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 16:44:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47B6F28F94E;
	Mon, 30 Jun 2025 16:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dkLorNim"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA26728C5D9
	for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 16:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751301873; cv=none; b=rdCOCWxmcoEmEovbmGs3qytlfR/RZSaGexibLzH10QRidbnUqxIQNrk8scKtxH2Jg3BA547Uc/WPGLNDLzCpg7CZFVbhjW7erf6OVn96pcmGUWPMmqdFH67Lp9DfM50r+NFmkiWWM+6IWwfuPXcIpyhYHTRht034Ne5ckQVkpQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751301873; c=relaxed/simple;
	bh=5cbWD4t5DvcoXF3AtHmSTeCnx+WklN5SSXLwdmoosUk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Fz0jcV5ezi1evkbjwMivkk5YWhEEMBilesQ2Y+FW3IxumaMFazLIbX6RxnRSq7txjrz1U3+tcxZe6mNKy/HzttzOGY4hBupKL7xjgHR+LgczYj70pqtxEioeapsJAjJCZ86KuV8NFMjQ5H/YB3lAS1hIiEv2/ym8Hxg58XCeiHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dkLorNim; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-23636167b30so19905905ad.1
        for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 09:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751301871; x=1751906671; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5bqNLN9oM/eFK6tGY2yWoO6CjZNMwv1BhYd/kC5LikU=;
        b=dkLorNimtMpnoGxxf7KaG6VZwJ6n3hXQV7CzyKXIpQtNq8I9Gvh3zb4gILBt4RsrN2
         NzoNAQvIoXBXuHZHLQ55AktNa4mtZtSKU9KBhS7FjBEBr7lKmmgI9ni5aXPhwD9bJb5o
         3hSsjy5xDudc1eZpal7JQdIJuhwshfZf+CRXq5rvAeIKI4wm1ycFm/QmzNDlITJ8ngmB
         DalOYrtydZZ498xsrdS3nuGtu0CXJXU7sQHLEStzJCHk7XctbLm1HL3pX9xG+d4WkaAk
         FqDAc+JZS8ixwJsJ8uJhYk5Tn5E/o3y8QIclPcpNc5zRDdjFZNLBPHlz2wiRKKNQeHiC
         /zoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751301871; x=1751906671;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5bqNLN9oM/eFK6tGY2yWoO6CjZNMwv1BhYd/kC5LikU=;
        b=VXhQPH8qwpRN7whocNC0vn4DjiZpP3Iau+DA59xik3orvdHlrjyTW+HFbSgBPylPLA
         kJup0aUSHDy+AJx8Bahu8xdQdX0yu0gvp4xtFSIsDlJDHai9yQ/OT/6xnAGVIB8zpJ4F
         ZFAdASoy3i3NPPlJ7dfcEInR5CJ551cFrtznRWXGq6+f7Mzxc+CSCB5RdIiaHTFLKve6
         d08JkkVnNk7ePQT1deKGpzojnyyCMEc1QDBaronWMyRKyIZodWRnYaJavctT1wHvqzw0
         MuVPLcAP0o6qToVyLqnEn0usOJidwpOce01jD5dOSRvlOHXenYALLJU7fzsG+lqxIXgL
         0bWQ==
X-Forwarded-Encrypted: i=1; AJvYcCW695NN5Wuwb81ZX71uieZ8IZpBqeWSgGX3hcDAIqxD7irEhfUysLneM2NHjvGyZGu0Dz9MgYYqJQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6rR58PI3nPhgLdqTgS71aM+I9NnXrVOxct0sIHVaUP6w/STXK
	7jqNamUe+t/WfS0ubYA4OmAbCDcqLuuXArA5TXSdyuCo7p47mQCY0Dy6Odqp2vmv
X-Gm-Gg: ASbGncul343QYzRDmhadkf0MIFVHX9QHVIHoH4YWZIGdvR9mDiEpQjsYyQThkupDEMY
	GE1tMVDnISDJkNGhvV9/vtQxGbxuUegaBOwk08MI7ZFFDE67HBNZlndfuEe8zORnVJmtpNSUKFF
	n5UNpkr/CQMRDxniX70mX1VCsllws1hJq5QLTATXNL79++ZJyr9+5u1K8UmGJfAjzpA9Fq5szif
	70/OtZkld+y6tHtH04kSTiQ24lgdhnZp+4+C7dHL6pPQLrQL8/QkXMvVAb8wwRtmoA/wYuYD3jX
	oNZsk5MlEH1zZC4ILR5i0W0Ee67Ix6qnRCol5ZC61YlC5qBcMtMB0O6sxmpwgYiWslOeUEYWTiv
	amkiRzK7wMg==
X-Google-Smtp-Source: AGHT+IHHY2td/HAKJ/MK6U74ZTd+5wqd+oW/ZZS6gnBRGyvKo2HhYCJR71x09t1QDrSvNwDx22gIdg==
X-Received: by 2002:a17:902:f601:b0:235:c9a7:d5fb with SMTP id d9443c01a7336-23ac3deaf2cmr222651895ad.16.1751301871063;
        Mon, 30 Jun 2025 09:44:31 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:106::41a? ([2620:10d:c090:600::1:335c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb3bc73csm84898305ad.193.2025.06.30.09.44.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jun 2025 09:44:30 -0700 (PDT)
Message-ID: <79255ffd-9985-41f4-b404-4478d11501e5@gmail.com>
Date: Mon, 30 Jun 2025 17:45:58 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] tests: timestamp example
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1751299730.git.asml.silence@gmail.com>
 <4ba2daee657f4ff41fe4bcae1f75bc0ad7079d6d.1751299730.git.asml.silence@gmail.com>
 <accdc66c-1ee4-44af-9555-be2bd9236e25@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <accdc66c-1ee4-44af-9555-be2bd9236e25@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/30/25 17:20, Jens Axboe wrote:
> On 6/30/25 10:09 AM, Pavel Begunkov wrote:
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> 
> A bit of commit message might be nice? Ditto the other patch.
> I know they are pretty straight forward, but doesn't hurt to
> spell out a bit why the change is being made.

It's not like there is much to describe. The only bit
I can add is the reference to the selftest as per the CV

>> +#ifndef SCM_TS_OPT_ID
>> +#define SCM_TS_OPT_ID 0
>> +#endif

Otherwise it needs to be

#ifdef SCM_TS_OPT_ID

All tests using SCM_TS_OPT_ID

#else
int main() {
	return skip;
}
#endif

which is even uglier

> This one had me a bit puzzled, particularly with:
> 
>> +	if (SCM_TS_OPT_ID == 0) {
>> +		fprintf(stderr, "no SCM_TS_OPT_ID, skip\n");
>> +		return T_EXIT_SKIP;
>> +	}
> 
> as that'll just make the test skip on even my debian unstable/testing
> base as it's still not defined there. But I guess it's because it's arch
> specific? FWIW, looks like anything but sparc/parisc define it as 81,
> hence in terms of coverage might be better to simply define it for
> anything but those and actually have the test run?

That only works until someone runs it on those arches and complain,
i.e. delaying the problem. And I honesty don't want to parse the
current architecture and figuring the value just for a test.

-- 
Pavel Begunkov


