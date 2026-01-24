Return-Path: <io-uring+bounces-11913-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 9wgwN4jrdGng+wAAu9opvQ
	(envelope-from <io-uring+bounces-11913-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 24 Jan 2026 16:55:52 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 183327E0E7
	for <lists+io-uring@lfdr.de>; Sat, 24 Jan 2026 16:55:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 96432300876D
	for <lists+io-uring@lfdr.de>; Sat, 24 Jan 2026 15:55:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC68D2147FB;
	Sat, 24 Jan 2026 15:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Pko0fuAe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f67.google.com (mail-oa1-f67.google.com [209.85.160.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2FF75464D
	for <io-uring@vger.kernel.org>; Sat, 24 Jan 2026 15:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769270149; cv=none; b=citb4dsfm8ls8EjtJs4HZz8MHzwL4kVJ8Htq+ToltPGNPd/iZ+ABNgoosmkAlk3haTx3Ah+I9zVAQySN4Ycglacr6saTHzLvcK4lMGbGoOQD0t9MEbGxEMr/j3hjThcRw6W3RrPuMEoOMRtKnCWlVG/rkCuN9tGMvy22j0azQoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769270149; c=relaxed/simple;
	bh=U2+e4xKSAYRABwS2qCE3DaefmKfUoZiVs6WXlSlOT1U=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=PBVRruqXL8fMcWufqfWTJgSI2+N8TbrkToS4JaS8R8rw657jwR++/NilN5Pqwwx8iKkbXaPXh+KDrt3SdL6u9fFN3ZBzF7PmEGSWWw9Pe1boFmGrJfBwLqEg+UKjmvTEaCd/T7CrtsQ5Y3Sh8ZqbmgYHg3Utbk4zeDMUyuPn0Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Pko0fuAe; arc=none smtp.client-ip=209.85.160.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f67.google.com with SMTP id 586e51a60fabf-40423f8c5faso1957528fac.0
        for <io-uring@vger.kernel.org>; Sat, 24 Jan 2026 07:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769270146; x=1769874946; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=b28I4oYFav6Da1zUgaoqh5wjH9PdZp3ISEmwrG28SHk=;
        b=Pko0fuAe2cq4uyqMVG0CzsaGKFA4qkVyf5TA6qrYTbQ2miDVXcvlxicQIRHiXRdMjO
         RKYNJ2ofkVCEVhQIAPaQH4TG9Uojmg4ZXVn13n4t2dU2zrUAymfC2wTX+dhcg7yZMV1f
         JFqMOWxyuDUZs71uuBPV+kEq4+z0xs5kxTb2liUuQoUya5XTtOMDwfOfIlk8VTs7CFr0
         2ocpq//Qys+u7BilmV+4EOV+x3aIovX/jjkdZNm6XzaPbxQI5Sx+nnSb6w43sUGIt2md
         inYOYvzzBaCj9/h9Ri0/Adnez2+Mbv3Gpph+weMk3/ewpX7UgNKuKBveDoNnASWSHyoM
         K3TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769270146; x=1769874946;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b28I4oYFav6Da1zUgaoqh5wjH9PdZp3ISEmwrG28SHk=;
        b=Ts3LNxuia0oFFViaoJHwZGWNzfFtctn2rpNppvRnQmlyFGs/HXx8Jn8c/l1wfHaoLT
         NUbCOzjgs0X78CUc7vXSoDV4tm0Vsudk7p7YR/OfN/J8YhX4PVSaHzpmbPVCnOlPZIh5
         fwo4vsL12rcL2h88EMJ3bUCfclnE6z2C3DEE7IatyOK33L8NNezpnfC6XvuDNJViH8+F
         PnHHVu7UKU97E/ecblvQUxTNzyB6AV09lolghIrYMRlbLuS8Bm3b3LptU1TVa82Z3qJl
         kAuNQmpk6i/rSBV0jDhEsGK2jpznWIl9Zk0kJPyOEHw8aQ46ksmS3hXrnBOHGJ09IDfy
         B02A==
X-Gm-Message-State: AOJu0YwDIoKHqbZhBzCt8pPem9qZKHl3CvoKgle65QWt6A4kkT8AqsiU
	Fed7cPiWti/KZMJS2Y93gp++Hym03nGIiTJbYg4v9sleUUb1Xe8NWH4rxUdY80SGNZw=
X-Gm-Gg: AZuq6aIUKNsLK6NJXSOmCaub2vPfJCR9O7Kfz9qIvQmRBc9sXJRtHcSMl0ORU1JPfyB
	rn9cR9udpvEQVhAeULiFbKHOoe3lVh35ZhadtXf76BRPGvkBhx20nediDfjLSiNq3I6Lw0kjfmi
	gmdTcEtDdI1IkuSClQFZ9fNRi4kFN/nJQN4Wv7WQ6TOw/L3nzpC822H9gwq9Bv9W0bb7kge1T6L
	sa0f7XCzLuyjDkDtRWSexmBnFbo6UEd8MRD/o5Tg3CXhl0zX6iB7fJmEY5M2gf0LblHWY53ies/
	b2C8IlEg8kWMpfJQEiOkZk9wi+izo0tFQPn8vJbdeyZ+n3blq9QfBCyC+TyfRMBxfVCvo6FD6qc
	eab03HAUxJh/yfLt36mXkBUugeXQgTm14VHgoGIu2GiXzSOhOkSKtn13SS/1TK2i+7w2ka6d1aO
	RQcNd/W5xTrMoY8Ew9M84GJpMZmpuGp11HhOaKn5J2EoDsUwaXb/mV2snR1rfUS9IoRQMaDg==
X-Received: by 2002:a05:6870:d253:b0:3e0:9188:8f10 with SMTP id 586e51a60fabf-408bd516408mr2231166fac.0.1769270145077;
        Sat, 24 Jan 2026 07:55:45 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-408afba74bfsm3825187fac.13.2026.01.24.07.55.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Jan 2026 07:55:44 -0800 (PST)
Message-ID: <32b884bc-929b-4b27-ae74-5754fa2473de@kernel.dk>
Date: Sat, 24 Jan 2026 08:55:43 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring/rsrc: fix RLIMIT_MEMLOCK bypass by removing
 cross-buffer accounting
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>,
 Yuhao Jiang <danisjiang@gmail.com>
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
Content-Language: en-US
In-Reply-To: <74f2ec89-ca40-44a0-8df7-de404063a1a3@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-11913-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,r7625:email]
X-Rspamd-Queue-Id: 183327E0E7
X-Rspamd-Action: no action

On 1/24/26 8:14 AM, Jens Axboe wrote:
>>> ________________________________________________________
>>> Executed in    2.81 secs    fish           external
>>>     usr time    0.71 secs  497.00 micros    0.71 secs
>>>     sys time   19.57 secs  183.00 micros   19.57 secs
>>>
>>> which isn't insane. Obviously also needs conditional rescheduling in the
>>> page loops, as those can take a loooong time for large amounts of
>>> memory.
>>
>> 2.8 sec sounds like a lot as well, makes me wonder which part of
>> that is mm, but it mm should scale fine-ish. Surely there will be
>> contention on page refcounts but at least the table walk is
>> lockless in the best case scenario and otherwise seems to be read
>> protected by an rw lock.
> 
> Well a lot of that is also just faulting in the memory on clear, test
> case should probably be modified to do its own timing. And iterating
> page arrays is a huge part of it too. There's no real contention in that
> 2.8 seconds.

I checked and the faulting part is 2.0s of that runtime. On a re-run:

axboe@r7625 ~> time ./ppage 32 32
register 32 GB, num threads 32
clear msec 2011

________________________________________________________
Executed in    3.13 secs    fish           external
   usr time    0.78 secs  193.00 micros    0.78 secs
   sys time   27.46 secs  271.00 micros   27.46 secs

Or just a single thread:

axboe@r7625 ~> time ./ppage 32 1
register 32 GB, num threads 1
clear msec 2081

________________________________________________________
Executed in    2.29 secs    fish           external
   usr time    0.58 secs  750.00 micros    0.58 secs
   sys time    1.71 secs    0.00 micros    1.71 secs

axboe@r7625 ~ [1]> time ./ppage 64 1
register 64 GB, num threads 1
clear msec 5380

________________________________________________________
Executed in    6.24 secs    fish           external
   usr time    1.42 secs  328.00 micros    1.42 secs
   sys time    4.82 secs  375.00 micros    4.82 secs

-- 
Jens Axboe

