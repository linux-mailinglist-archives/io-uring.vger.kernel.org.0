Return-Path: <io-uring+bounces-7113-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 25B36A674D8
	for <lists+io-uring@lfdr.de>; Tue, 18 Mar 2025 14:21:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3225B1892B0A
	for <lists+io-uring@lfdr.de>; Tue, 18 Mar 2025 13:20:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 323CB20D4FE;
	Tue, 18 Mar 2025 13:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nATSPoQP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D1720D4F6
	for <io-uring@vger.kernel.org>; Tue, 18 Mar 2025 13:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742303977; cv=none; b=V3+z3aT42Ea+EBN8Old72ttjUXYuGpyVR9cx8DCccC4Gkm8qeQ/f5KaA2QBJ8aIR+nPCy0LkhaWhL4ReNb81iX+9+cAPU2Wke1RbRegts0uNdZ++XY2OBnRF1iFX9pb+kKXeYg3MjDM7P6v/CfuxSjpDuHQ4gsvmkDXC67EwWxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742303977; c=relaxed/simple;
	bh=xtVjxeR57GowxzypB8yIQa1TkgnQW6NgiPkaxFWelL8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WkRDka/efuI2SNPU+DdVpUYxJZgkvmOk/7+0ttMJ5vR/Vr824hR4/M4z2CIsMz1NM8b3+PNeN/EOhLwaLwOuu/XxaZKparhAWSSskW95e3J+LRXPOtZWZW/9qCDXvhJaKMIBa8LqrV7Xbc26bRssgrpiiOtBp0Yhw2alG0NqQVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nATSPoQP; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-22401f4d35aso104147025ad.2
        for <io-uring@vger.kernel.org>; Tue, 18 Mar 2025 06:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742303974; x=1742908774; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ciKBTMhrTNIAwAunPC9pvKe2rqwBVkggfAdVsShdNfw=;
        b=nATSPoQPoJCVuT9r+2PYZ2xWBfqCHjFBcrSjoIjkqBw7j7ghhNj70YxpN9jfYuWCr3
         /7c6loPN/CgRPfT8frJrge0vyTytpKmfs/Q5QfKLq2tz2uTSYUBhgWMa1WKdViT2EfFf
         efxFxqURb7A6ihacqxgvepyL/6eQGwH3TaUBfVUtkHHIdMJB8pcpaXjN0EiIXs40cTOY
         +oQhmJo5pq9ARHxWSU9xO3SbyrjlqpCPO7IB3MOPQrUqnhWimZJmdbDILka85NcshkB3
         Wnht3HH/Zj0o/z8793USFRyfy7FSo2vkoy/Owa6M4u7qKTux33LeWi4lJXNSzQ7aBIY9
         ep2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742303974; x=1742908774;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ciKBTMhrTNIAwAunPC9pvKe2rqwBVkggfAdVsShdNfw=;
        b=Ye1s1MA3vtjBhG2u9EaBdBdejPfBC+yuUr5yicIcYksgOClPDfWRLtQuAAGn0xHDTP
         acC4KGlKzTc6UyObt+i1+O6glCnzygC3eNEEqLEStyfMR9ofz7bzge1S5S+DhNs9saWF
         cNAX9yIJjFtOP8PuBXdIh2k2e+RfVUrvoH2UXaxSY51AkcRmQFj3rfv61gvhx8mEU45c
         l+891qyDTcIusAEVf/WSOFSGdwvSber5NhEur6SbHmBfKCJFnU8bP7rKlkwHukmVYlXz
         0yidAKhkzkBz6MID1N9Eg0Kmcl4ZSHAEyr1MnGn1Ht9fputoTN4MA5XD9kAw6mn8kHvC
         T4Ag==
X-Forwarded-Encrypted: i=1; AJvYcCWLS0ZH0jVSA/j8lGhGOLzPsN4nWYNqiUdCOk6DNw+5ELDEydHVWG+XO01wW8seYZdtG8ylL5485Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YzMF6xHIKqTXRpRZ7jhYK7eYCVAeQtFeaM96n5pfs2Kygah9GOs
	dpk8DQrH+KR3exjWhR/iLnj8pjO4LBR0/kTSTGAaQniO+kleaeDB27hnAEKHHzY=
X-Gm-Gg: ASbGncsFDM8QO5Y41xakBDCX+QOMqUASH/xJwGzgU9Iv72PQnA4slGus83Zz0FsNMVa
	U18mYcJcqXXPi5NQB/VJRcW6leGktOpParmvRfpCbf9BVhMX+RGJSJSXc5uR/VhQwvUDZRv3jfS
	rmIzYG+T8uXtBKMEonXWDSIqNfWjGBxsdoiYdhw5O/ZailvZxiDF0nt6nj9HE7k1ZvRjPdx8gZj
	ISlHCqQEej9voroiMV7+Jo95UVYG8EMypKmhe8jE3M7t+S06KMpfvIPJGcQcAq5eIA1GmyM9CN2
	rszaF3+CsMQkEUflbxgPoBAfTx2hAX7ccgHS3cwewg==
X-Google-Smtp-Source: AGHT+IEGhoTxzsJdPHXpMJwhvk5arIo+nzvTx/l2ZiSw07Z2Knppa9h9oRSci/7G9rCpzmb+KAK03Q==
X-Received: by 2002:a17:902:e801:b0:224:c46:d167 with SMTP id d9443c01a7336-2262c539b94mr53342395ad.16.1742303974447;
        Tue, 18 Mar 2025 06:19:34 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-225c688d9eesm93737005ad.35.2025.03.18.06.19.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 06:19:33 -0700 (PDT)
Message-ID: <17154add-faf8-4150-bc07-57e07b5c9ea7@kernel.dk>
Date: Tue, 18 Mar 2025 07:19:32 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 0/5] introduce io_uring_cmd_import_fixed_vec
To: Sidong Yang <sidong.yang@furiosa.ai>,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org
References: <20250317135742.4331-1-sidong.yang@furiosa.ai>
 <fe4fd993-8c9d-4e1d-8b75-1035bdb4dcfa@gmail.com>
 <Z9kjoFcHrdE0FSEb@sidongui-MacBookPro.local>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Z9kjoFcHrdE0FSEb@sidongui-MacBookPro.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/18/25 1:41 AM, Sidong Yang wrote:
> On Tue, Mar 18, 2025 at 07:30:51AM +0000, Pavel Begunkov wrote:
>> On 3/17/25 13:57, Sidong Yang wrote:
>>> This patche series introduce io_uring_cmd_import_vec. With this function,
>>> Multiple fixed buffer could be used in uring cmd. It's vectored version
>>> for io_uring_cmd_import_fixed(). Also this patch series includes a usage
>>> for new api for encoded read/write in btrfs by using uring cmd.
>>
>> You're vigorously ignoring the previous comment, you can't stick
>> your name to my patches and send them as your own, that's not
>> going to work. git format-patch and other tools allow to send
>> other's patches in the same patch set without mutilating them.
> 
> I'm just not familiar with this. That wasn't my intention. Sorry, Your
> patches will be included without modification.

Assuming these are from a git branch you have, just ensure they are
committed with Pavel as the author, and git send-email will do the right
thing when sending out the patch.

-- 
Jens Axboe

