Return-Path: <io-uring+bounces-11914-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OB3ZJqnzdGlH/QAAu9opvQ
	(envelope-from <io-uring+bounces-11914-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 24 Jan 2026 17:30:33 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id F3C137E1F0
	for <lists+io-uring@lfdr.de>; Sat, 24 Jan 2026 17:30:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3A7E23009176
	for <lists+io-uring@lfdr.de>; Sat, 24 Jan 2026 16:30:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 635292253B0;
	Sat, 24 Jan 2026 16:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WWdYbmJU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f66.google.com (mail-ej1-f66.google.com [209.85.218.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3DAF21C16A
	for <io-uring@vger.kernel.org>; Sat, 24 Jan 2026 16:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769272230; cv=none; b=h4Zi31DXJmWn83hHQWhSt/TMHOlB/zpuEzVc49OVe9UEKfx0GQbkscp+nK3g5RuC2sxklL0P2JoAJbsAQxOKvENXzKLuRfK6jLlBSLio0aNDrn19Sy8VD75d6g+abWCLKGh6uwbQS0hJK1uHYWnNZdP1vALn6WyQh8trahmipbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769272230; c=relaxed/simple;
	bh=L8SxQfCSwBmfGTudwzsqlrN4eU8OYaOz4gCyWiDNshA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aslGb6tVBWu5/yKlw/W8ZFvZocc11Wc7ZKBb2yjA+FN9R9fnRyBVRAwnDJqSYuEmkFmnF3SLzNxyeYHmy33WPaHJF+YSueqOlvL8iCmFa0j1vxQSN2VQcHYzjHF1k0bp2J7Qrkgv4pQbfqWnfYAbEssolPmbDX+8Bk0Dnkxtnns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WWdYbmJU; arc=none smtp.client-ip=209.85.218.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f66.google.com with SMTP id a640c23a62f3a-b884a84e655so403087766b.0
        for <io-uring@vger.kernel.org>; Sat, 24 Jan 2026 08:30:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769272227; x=1769877027; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mOdxhWbrrly9vOYfsFSZEpGnALwy1L1i04bJsdLEpuE=;
        b=WWdYbmJUOXq9+15P2R2mGNmgEXtseyEABXaeY8XBnjHhNuhuEBI5Z5OFgbSHGtLoSu
         KzUkj65XhyEmGz9vp9JemNnSmw1WY5a3REBTFwTDqVhoTTUaMb2loq09aoEHhGFwh4S0
         +z72OlZNReERFD+EJD//h1q5peWsp6GcRV58CF4c2P0hKLqdESg5Vd4JttJ5gSbYXOBw
         tJQ9CJcPjGj95RPHA0h5mtXFNLScBGOIkRsJG3O1pb8f9ed3RSw4XQcyVYJhhiRxizS3
         eX+ynGzGkseyseVS+otrCVTwyRrplMTmv9r4G3pu8of10xQyXYoV78mU6t1Lm1Feu02a
         t5cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769272227; x=1769877027;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mOdxhWbrrly9vOYfsFSZEpGnALwy1L1i04bJsdLEpuE=;
        b=odQ4QAu/vkrJzKbhCdGkADGiyTsNZG5ro6Dg35vyUvmB/pTmRBxq5yeNBi2QS2Pan3
         xF3iah0+MN7Wi5NSjEIFJ5mkzshKN//9eERYmKctKwQj09vvZ6ZJglIP8SW+epSkcSf+
         v7dZo6d2isfI7+S1bucnmhhMHivs8cqx3/MRmPwo2x9V6OgVKa31W+lZk+gR2o8KsHUz
         z3H2FYqyeuZWrVfeuEdzhYO4XyoajB9+8K02C7wbAkLwEr5QA1y83Zd3Sg4nHGUaY88Q
         Fi3YSgWwFnq6JHuJVRD4SqpwWVKE0GYm2cBHaOLpUGlhZOjBTaUIyoRsMkVtnbizxQ+f
         nPVg==
X-Gm-Message-State: AOJu0Yz5N73M9ljX/BduF/GnH8TTR9Wvq0A3Q8QftJY+c0iWm4ToAqSM
	Fm4Si72Zy3WimgGxjjBLlXnBEZM1eagRDkNVVGgmxB/nGaxZ7Vr+8oxy
X-Gm-Gg: AZuq6aIOaiPSzJ+gSgAMhYSyZQtmjGAmrk0s9MBQKq5sxSVUS7a3ulWMvx7fvvHDe+2
	+lWT+JiK6gZJ7bbifE5hDa+RMOhDbdCwi3r8gFiJ1cFHtCqUmJEgFtg50a1Qz6gg1sNpJ4uuX3x
	dZl4Sg41pntGvu7jAkqVwxaQx5WfQHj3I637gUqL57GTDWPEOIpZjzIkB/+lthlDBZ0DH1WAfuF
	smim7v1PdsaPZFhspmfiKVAVhGMIgjTbc9+iJOq+OGiDtlUkt8iaEx+n3TxQLUvI6p/wNqsnmp2
	4uH3/zI5m8h0dWLHYINfsHa/wpbfujz0ooXdgxpE5eTp76JRi4rSnqRk7oeUBkudUq4ElGTVprr
	d/eQ+EZnzGQwdrYz0nCvU4wyms5nsUPCXPwfZcePA5Yx/ClzQ4w4DVYcUtKLDdlATmYmPWe22WG
	exBavvr49dMQ2X/8XKLhD3Ze+plRlgweShygD0+BoDNRtpBrDjCYmNvB5eUPtVLeQx/lEVyPg6w
	zDpQNf/7+78YsVeFoffWNheDb4cLB7tTjDDdYIS1nJoBXsNg7ofc4JKMav2PNNkTQ==
X-Received: by 2002:a17:906:fe44:b0:b88:4fc9:a196 with SMTP id a640c23a62f3a-b885ae08ffamr432721766b.34.1769272226744;
        Sat, 24 Jan 2026 08:30:26 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b885b7661f7sm287380466b.54.2026.01.24.08.30.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Jan 2026 08:30:26 -0800 (PST)
Message-ID: <38a46172-8734-462b-870d-39d0697882e1@gmail.com>
Date: Sat, 24 Jan 2026 16:30:25 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring/rsrc: fix RLIMIT_MEMLOCK bypass by removing
 cross-buffer accounting
To: Jens Axboe <axboe@kernel.dk>, Yuhao Jiang <danisjiang@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260119071039.2113739-1-danisjiang@gmail.com>
 <bc2e8ec1-8809-4603-9519-788cfff2ae12@kernel.dk>
 <CAHYQsXTHfRKBuTDYWus9r5jDLO2WLBeopt4_bGH_vVm=0z7mWw@mail.gmail.com>
 <2919f3c5-2510-4e97-ab7f-c9eef1c76a69@kernel.dk>
 <CAHYQsXQK4nKu+fcni71__=V241RN=QxUHrvNQMQtPMzeL_z=BA@mail.gmail.com>
 <d8d28435-2a89-4b25-925e-14fdb346839b@gmail.com>
 <8c6a9114-82e9-416e-804b-ffaa7a679ab7@kernel.dk>
 <2be71481-ac35-4ff2-b6a9-a7568f81f728@gmail.com>
 <2fcf583a-f521-4e8d-9a89-0985681ca85b@kernel.dk>
 <d2fc2ff2-98d9-49f8-af95-968100174d55@gmail.com>
 <3b7e6088-7d92-4d5c-96c7-f8c0e2cc7745@kernel.dk>
 <efe080c9-5176-4fa1-9f65-5be44074779e@gmail.com>
 <596bc7ac-3d24-43a7-9e7e-e59189525ebc@gmail.com>
 <fc8664bb-7769-48a2-b470-71fb81828e26@kernel.dk>
 <654fe339-5a2b-4c38-9d2d-28cfc306b307@kernel.dk>
 <eea0d7c3-9aed-4c1f-8146-23b82e611899@kernel.dk>
 <9317bad6-aa89-4e93-b7d2-9e28f5d17cc8@gmail.com>
 <74f2ec89-ca40-44a0-8df7-de404063a1a3@kernel.dk>
 <32b884bc-929b-4b27-ae74-5754fa2473de@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <32b884bc-929b-4b27-ae74-5754fa2473de@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-11914-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Queue-Id: F3C137E1F0
X-Rspamd-Action: no action

On 1/24/26 15:55, Jens Axboe wrote:
> On 1/24/26 8:14 AM, Jens Axboe wrote:
>>>> ________________________________________________________
>>>> Executed in    2.81 secs    fish           external
>>>>      usr time    0.71 secs  497.00 micros    0.71 secs
>>>>      sys time   19.57 secs  183.00 micros   19.57 secs
>>>>
>>>> which isn't insane. Obviously also needs conditional rescheduling in the
>>>> page loops, as those can take a loooong time for large amounts of
>>>> memory.
>>>
>>> 2.8 sec sounds like a lot as well, makes me wonder which part of
>>> that is mm, but it mm should scale fine-ish. Surely there will be
>>> contention on page refcounts but at least the table walk is
>>> lockless in the best case scenario and otherwise seems to be read
>>> protected by an rw lock.
>>
>> Well a lot of that is also just faulting in the memory on clear, test
>> case should probably be modified to do its own timing. And iterating
>> page arrays is a huge part of it too. There's no real contention in that
>> 2.8 seconds.
> 
> I checked and the faulting part is 2.0s of that runtime. On a re-run:

Makes sense, I was forgetting it's full time.

-- 
Pavel Begunkov


