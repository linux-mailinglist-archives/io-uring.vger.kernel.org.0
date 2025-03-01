Return-Path: <io-uring+bounces-6899-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC894A4A833
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 04:01:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A51A53B8A3B
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 03:01:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E43401CA84;
	Sat,  1 Mar 2025 03:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B+2yCRB1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5DE18C31
	for <io-uring@vger.kernel.org>; Sat,  1 Mar 2025 03:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740798090; cv=none; b=igjva0Z9XGsK0K0PkGA913JA2WQDNowmpaAPX00jSSk2tyHMUkFB1feAebTaPBakXvjy3mh1KQ8rOdJRVQfqsXd3H96D31yKzNprMw2otuQkWd/BQ0tjSsyQDgJyibmMY66bL8MC4sjR1clGjWdBEQcSmOwwjHQ6rZmKmftm38Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740798090; c=relaxed/simple;
	bh=h1P0qSnqZZgHOCIDR/BoCUq0sJMFltvSFsXA/o22YhA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VlWTD7KnfD4V3FvIFRVKGBuyHCJ2H82FAxk544EtQoO5O1dRlB5sNFwhOnAhf3yV3fEqJjSoQZwQ4tuuYwzuSojIx9wR4Z7o6h/pHNw1kXv5Y42Csf3yKZKOknc5qTM9kUZgUVZcQB6nQ1EmoxkRBX1fqkmkgLCBo8503Zli468=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B+2yCRB1; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-ab7430e27b2so455428766b.3
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 19:01:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740798087; x=1741402887; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tEBdhyLLno6nGG0Z3Af6R/GcHtq7lLUSbV3WYJpI5Mk=;
        b=B+2yCRB1Wsq/c3mJ9cZU8y618tOqImVCjAyAbq1H8BGWjCrFJq5cfF5bRFinEtfo3O
         j6uJjvU3Fd61vzLe4S6pxqSmUyJrRgDWDes3+04T7qsMLLQYBKPRH3y/h8J/54zicp7L
         gkhYN6PlRuFvDvKmtGQXQqjDXgaPK7zgDqGVbT6f4s8tG+mCsxHqDIweC9Lg41aolWN1
         siXnBNa4r4rVa9HTTnSlUZE4dVMkuA0qiJTgddDArMueTb17eaLb705fswCn/AEpzF4W
         5POj2pFdBjeDDkiu3Y3YtvTS20dqbQpV4ksuHsK86jhzawDzp9r99VyU/+PFk12a9Fhe
         vuGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740798087; x=1741402887;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tEBdhyLLno6nGG0Z3Af6R/GcHtq7lLUSbV3WYJpI5Mk=;
        b=XFgWCMCIWFALIbRwbUKO/WouNPpk/oSpjVkB2LnfNKtaa0SFrsdYB8rlqZeYUL2Cbs
         qYVn54RorQ824xBLGZ3FLcJFBklLJjyWFgx7ZRKiuTGtfizbLzMmT0C4/R4e2NQYxoZm
         lP8Etsw9yWAjKyVvBLPQff+00rYuQRb6KNUNQO+hsfNnDlA12Ifo2IaG4CNz4R8NWMS0
         aZtm+ikkQG1EZL3Q9Gnm93un1CGz7drJcoswLioqAiSqBkPDByC2IGrdIbatCfxyg22n
         Fl3MCdTthLtLXgCQvz1OQn0V2mi1BL6bhpHM3UptfRjmNw1VHzZhasKHqgV3xlwZoXuz
         NYNA==
X-Gm-Message-State: AOJu0Ywl1wxgYxB95yQCGiTIsJUVbMdbGLWjoH+Ufk3olTlbvGz64qga
	fMf68rmwvPrHMGXztZbjAsqQsjUGL7/itixJjTlL/5jNtb0nYoLpsms+eg==
X-Gm-Gg: ASbGncsxc5kaQrxbRikn2T+U5tPmUbpPG3jSZoFDUE8WBfKFXtEcx5rNfwghdR0iCyk
	hCf1YSEqIudALZP7lsjH0m6zONhGrcMj/0TVwx8iyfg1NqZC563VK8noKGdDMw9A6KDcd9oT5oE
	xGZDemc9woIupXSg1VokONwCXc80IO27R2oMZTmviBjLzh9ClLzGwg1ijJUsIcZFP+vK2q0hAmF
	0DrtQRW2eVLI5gDDwBw5/vxakeG9ED6+hE/3lhqn+bgaAXmdZNbo7HbcdbWuVnSBsZSPyoEH1wG
	zy4AsMnb2uPzX5ai6+ilnv4fsoDQ0jOs0euXwvJ2Cuf1nZ7Y3QW+m7c=
X-Google-Smtp-Source: AGHT+IGEzjlmPoWOB9X1+Xl40dtcF5PhJ7E0BUSFrBV+jdUIDnWJFbi0b3t4wvaEpmsL6TGJeABPeQ==
X-Received: by 2002:a17:907:9484:b0:ab3:85f2:ff67 with SMTP id a640c23a62f3a-abf25fc61a1mr548783366b.16.1740798087371;
        Fri, 28 Feb 2025 19:01:27 -0800 (PST)
Received: from [192.168.8.100] ([148.252.144.117])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf0c6e9c25sm393330466b.108.2025.02.28.19.01.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2025 19:01:26 -0800 (PST)
Message-ID: <5349fafb-e481-484c-875f-44b953b9e599@gmail.com>
Date: Sat, 1 Mar 2025 03:02:33 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring/nop: use io_find_buf_node()
To: Jens Axboe <axboe@kernel.dk>,
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org
References: <20250301001610.678223-1-csander@purestorage.com>
 <20250301001610.678223-2-csander@purestorage.com>
 <d4271290-2abb-49ee-a99a-bc8bb6dde558@gmail.com>
 <e84d5e50-617b-421e-bed6-628cacc28cf9@gmail.com>
 <524be10f-c873-40f1-91b7-ae597dadcca0@kernel.dk>
 <cc3a3a35-ab5d-45ac-9f0e-963632c872e4@gmail.com>
 <8d7b4723-a5b0-49ce-8f9b-32bb1acb3592@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <8d7b4723-a5b0-49ce-8f9b-32bb1acb3592@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/1/25 02:39, Jens Axboe wrote:
> On 2/28/25 7:36 PM, Pavel Begunkov wrote:
>> On 3/1/25 02:21, Jens Axboe wrote:
>>> On 2/28/25 7:15 PM, Pavel Begunkov wrote:
>>>> On 3/1/25 01:41, Pavel Begunkov wrote:
>>>>> On 3/1/25 00:16, Caleb Sander Mateos wrote:
>>>>>> Call io_find_buf_node() to avoid duplicating it in io_nop().
>>>>>
>>>>> IORING_NOP_FIXED_BUFFER interface looks odd, instead of pretending
>>>>> to use a buffer, it basically pokes directly into internal infra,
>>>>> it's not something userspace should be able to do.
>>>>>
>>>>> Jens, did use it anywhere? It's new, I'd rather kill it or align with
>>>>> how requests consume buffers, i.e. addr+len, and then do
>>>>> io_import_reg_buf() instead. That'd break the api though, but would
>>>>> anyone care?
>>>>
>>>> 3rd option is to ignore the flag and let the req succeed.
>>>
>>> Honestly what is the problem here? NOP isn't doing anything that
>>> other commands types can't or aren't already. So no, it should stay,
>>
>> It completely ignores any checking and buffer importing stopping
>> half way at looking at nodes, the behaviour other requests don't
>> do. We can also add a request that take a lock and releases it
>> back because other requests do that as well but as a part of some
>> useful sequence of actions.
> 
> Let's not resort to hyperbole - it's useful to be able to test (and

That's not a hyperbole, it's a direct analogy.

> hence quantify) provided buffer usage. I used it while doing the
> resource node rework. We also have a NOP opcode to be able to test
> generic overhead for that very reason. For testing _io_uring_
> infrastructure it was already useful for me. Of course we should not add
> random things that test things like lock acquire and release, that's not
> the scope of NOP.
> 
> Sure you could add import as well, but a) nop doesn't touch the data,
> and b) that's largely testing generic kernel infrastructure as well.
> 
> The whole point of NOP is to be able to test io_uring infrastructure.

And now we add overhead to test overhead of the very path we
add overhead to, just splendid. It's intrusive, it looks into
guts of infra that can change, and the way not to be intrusive
is to follow the way others use the concept, which is why I'm
suggesting importing the buffer, and that would be another
direct analogy with the pure NOP (w/o flags).

-- 
Pavel Begunkov


