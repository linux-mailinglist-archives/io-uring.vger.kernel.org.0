Return-Path: <io-uring+bounces-7144-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8576AA6A592
	for <lists+io-uring@lfdr.de>; Thu, 20 Mar 2025 12:59:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EABFC3BD5BB
	for <lists+io-uring@lfdr.de>; Thu, 20 Mar 2025 11:54:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18FE622172B;
	Thu, 20 Mar 2025 11:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GslEGAVS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D9822173D;
	Thu, 20 Mar 2025 11:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742471561; cv=none; b=mNIKANs0+9OSvwp8UIhY8QdWRfp2kXwXSsVoUkb2hdYp/7AlO73VbwkLpJ+ZSRWdWhGbIZkCFqy7UztdVHN3nnDCeFmBT7Z+Layp7EcJApfq7tM/QMXdfujCxi8+W8ipR2iXXi383/x70+18a78ZA4YVyBib79OT7dNxVA5XdvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742471561; c=relaxed/simple;
	bh=wwYMwFQRAEv66kogG7c9e6lDrkYHDgxQuvQmvun4+Ic=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BFBMbkFRenJjjT74xQ03W7P1tEG5TsiO9zi9+8j2oQQXSsPBL9HOZwRcq7fEgpM2SXCEez+nIK9lJ5r21dQSGk2b4VPYcZEAAMyiY6O7AYGyPjzyvHQIzHHhPBU9nUKthxwzpMaQGy3c5NDVXFBIrOj3EWDdQEcNC8YqJAhzSwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GslEGAVS; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-abbb12bea54so153277566b.0;
        Thu, 20 Mar 2025 04:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742471557; x=1743076357; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MYeHXyTh3fhxrKqIA00QWEYQrk6Uzb2lupwN2gVVWFc=;
        b=GslEGAVSXVwCHjVTKG/s8RpBGuaQz9k4UdPahQ7i59NJcxHC4B30dmDwD2SWmYn+vZ
         01t1c0rKV9VFNZoVV1PKJyX3WBHkc42tcPW3fusHHQkMIPUmshO+tA4rvk2c+ZTQeVgx
         6/yjleMpgj+aLdYtBR1QQCQuE3MqY07rpZ2b9cLqOm9xInr4zQOQwAdVi5ZaFEe6U1Zo
         OYe1DcdQEK9AdcWf29C5bLSn4RytnNPYwX7WOd2Xvhc9Vi75nPn+F5ZcWnJGVtl3gZnE
         HVi925RG0OYeMXIwTXh2Juzua65TDPqaixHrDRXamfsc+FmnmN13l0TwkXnARkaWKJ7R
         C+pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742471557; x=1743076357;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MYeHXyTh3fhxrKqIA00QWEYQrk6Uzb2lupwN2gVVWFc=;
        b=aZ3PLYesiP7CsSnaDTB8ElMOR6h0kprVxJRkrMm0BQkkff28gkRwl294oXClMlZXNW
         3YJ7LlhZvJ00jKoyWfuzGg3d/tWwxmPpTJ8wscWLpAHGtcaacWwXf8Qc0p8TG8Y2JU/V
         oxaVp0iwGtGuQXOaB+AudQOGMdEKbuQi7EyfVqgy+CykekDLBvlCezyxL3TtFhJhQje8
         csiwSwaMUpAn1hUDHUsJYQ4AA/+5DF1Kr8G/PUwhjUgW0mzXEBAuzQ9wq9xHYo66ByRW
         gymtYs11ma6RMm3kacp4BLrhgtHWG3oxPtrU9jSR1vJ33jL8cYpE1kB0fh+FaJnFbNqe
         N6LQ==
X-Forwarded-Encrypted: i=1; AJvYcCULSul1qiVLDVSZxWrASFqJzfX905s9yeunemeX/dISvuNUAnDmDcJAIpWiGul1CvxZDBIONYjDHtCB/FEB@vger.kernel.org, AJvYcCWmSESgK/AgknT7cSCMluc2+B7A6MKJ1rZ+pL3b4D16pOdKMAUFyHmeTUpl1FRcIoSOfL/+/+NDUA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxmw99M1dXUsKZsD2ju1IfcOgoxS1WKZrjv4jX15kozo+D4jIJX
	DpQ/l4ZK9MCvMJeHJMu9/dLpOHDwTaQAQkma4vsqiPqmKuZd8KKfU5RAOA==
X-Gm-Gg: ASbGncu0wb/snjP23JSUZ8ex2KRWnFjapyNAaZWoqWupiYYUPs/95zk+PUAAc6Mw29r
	AFqBkvssLz5wFLJBtYadMlWun5sTibxCSTmiHPo3osEwUoEu1Naka2PD5zzDJK6Ru0LUo8K6po2
	jloaBOzgIse7hip4sbhfhPHOLxk4j1NAYLVjZZVWKGjrTH76cUZG3IdXXfu/Haw3cGkpQazelSn
	iw307xEdAwo3o+A1Qkkad8uM59pjZ+rVYS1YqNbJQPONzunA4/iv/6M/H+KJlPO3HWcLdYgYxl2
	JQg2uOpttF+cU4gK7RWPlb9LLQsyyJxKdfwJpR8PqDrLbwFrJfkLLkd/p2GuqoWSegIYGchOgTy
	cfw==
X-Google-Smtp-Source: AGHT+IFAUXWnNkmvXfc46o6a6NN7i+IHxmpDda+DxlLiRENhdKAiO6iDWb3G4KeIpahPY+tfnLzJig==
X-Received: by 2002:a17:907:bd0d:b0:abf:3cb2:1c04 with SMTP id a640c23a62f3a-ac3b7c49f43mr798684366b.9.1742471557171;
        Thu, 20 Mar 2025 04:52:37 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:5148])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3147f0f5dsm1173437166b.63.2025.03.20.04.52.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Mar 2025 04:52:36 -0700 (PDT)
Message-ID: <457194e1-409d-455c-a863-4877934006a0@gmail.com>
Date: Thu, 20 Mar 2025 11:53:33 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (subset) [RFC PATCH v5 0/5] introduce
 io_uring_cmd_import_fixed_vec
To: Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>,
 David Sterba <dsterba@suse.com>, Sidong Yang <sidong.yang@furiosa.ai>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org
References: <20250319061251.21452-1-sidong.yang@furiosa.ai>
 <174239798984.85082.13872425373891225169.b4-ty@kernel.dk>
 <f78c156e-8712-4239-b17f-d917be03226a@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <f78c156e-8712-4239-b17f-d917be03226a@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/19/25 15:27, Jens Axboe wrote:
> On 3/19/25 9:26 AM, Jens Axboe wrote:
>>
>> On Wed, 19 Mar 2025 06:12:46 +0000, Sidong Yang wrote:
>>> This patche series introduce io_uring_cmd_import_vec. With this function,
>>> Multiple fixed buffer could be used in uring cmd. It's vectored version
>>> for io_uring_cmd_import_fixed(). Also this patch series includes a usage
>>> for new api for encoded read/write in btrfs by using uring cmd.
>>>
>>> There was approximately 10 percent of performance improvements through benchmark.
>>> The benchmark code is in
>>> https://github.com/SidongYang/btrfs-encoded-io-test/blob/main/main.c
>>>
>>> [...]
>>
>> Applied, thanks!
>>
>> [1/5] io_uring: rename the data cmd cache
>>        commit: 575e7b0629d4bd485517c40ff20676180476f5f9
>> [2/5] io_uring/cmd: don't expose entire cmd async data
>>        commit: 5f14404bfa245a156915ee44c827edc56655b067
>> [3/5] io_uring/cmd: add iovec cache for commands
>>        commit: fe549edab6c3b7995b58450e31232566b383a249
>> [4/5] io_uring/cmd: introduce io_uring_cmd_import_fixed_vec
>>        commit: b24cb04c1e072ecd859a98b2e4258ca8fe8d2d4d
> 
> 1-4 look pretty straight forward to me - I'll be happy to queue the
> btrfs one as well if the btrfs people are happy with it, just didn't
> want to assume anything here.

fwiw, finally got time to wire a hacky test with a separate cmd,
works fine, but I'll need to setup btrfs to test the last patch.

-- 
Pavel Begunkov


