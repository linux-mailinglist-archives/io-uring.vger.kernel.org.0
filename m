Return-Path: <io-uring+bounces-799-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6901986BC53
	for <lists+io-uring@lfdr.de>; Thu, 29 Feb 2024 00:49:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A2F31C20404
	for <lists+io-uring@lfdr.de>; Wed, 28 Feb 2024 23:49:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBD6A13D2E8;
	Wed, 28 Feb 2024 23:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="uHEsPm8n"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D984370025
	for <io-uring@vger.kernel.org>; Wed, 28 Feb 2024 23:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709164146; cv=none; b=X6lCHJpv6wqP8RyhVsfl1LVEb+bOuKUPilSkenEA5Qs8+lfNLLzlx9NuIl75Zyz+z26wGXkVy98GMflzU9RXP9UoJPsoARxLC3C96e5xU5KxKaGWMRmNWxvGMIt/N82Od3XenpyWej3zmSlyuMCCLD04Vv/SFoMvdxe1MPzTxX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709164146; c=relaxed/simple;
	bh=/TBBAIhWEOfBO67M8Pc0OBHsyhiAhSKz0A35LpPKKWU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Io1FEQMsEgjfwaNtPJN8wRjWMbwJcTxuk+dzDUlviVq52JE5Wa8Kc+KynFi2ug7+pIJgO6WCtMYMN7YWwHM7Eb7cRCkSYOGevEe/cD2VwjakExrJj09L4ouZjoWx7KAoLSSoG6qmuqnfYubcYcmtaR+wUH8zpGAZhNMGhHuVh+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=uHEsPm8n; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-5cfb8126375so61543a12.1
        for <io-uring@vger.kernel.org>; Wed, 28 Feb 2024 15:49:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709164142; x=1709768942; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mF3fwrO1HPzRsYikyxDi/eosg7W4iywaT5qSqEdZU7A=;
        b=uHEsPm8nBzswTwn0hg5tG8aDVUMgNzKDMtBGrHU4dv7qa3KuvocFIwKDNwsS68jr2U
         /URZUhJV6EDAj9jJ6TIU21f/cOlnjzOwMfoU16TIlKk0AbQwJqMgRIWyTp4qm9UbarKc
         D4o+HRxBBMqPL+9Yy/qLwCrdWQgipxPfLgArp6qxC6XK71dEneNKW6gS9TD99YrOrL62
         pRBqhSojwp0EauwBxeBlZNiU+0gH2mvhjn8dPX/SWejxcSaAUnXUzgvLRPtqmdhcaoJj
         4UjjMBTFANaw3At+2KbCsUTVrMh/NAL6Y/upyII/iEHzXAuZIEFF58XGTLdPExIQmHuF
         jyqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709164142; x=1709768942;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mF3fwrO1HPzRsYikyxDi/eosg7W4iywaT5qSqEdZU7A=;
        b=oaucCf5g9hJg9W6Pvzd3a50uUpMiGpb/0sz/FEL/kVjnfEphhR3NvWTqIL+3rliOaK
         eSx494krWzHyiIljIr4LN2StfYiz2zgYFPf3Y23YIHhYMbRYOy85pkQCBqD8owoksBZO
         0dhnqrowI06Qk/tpMCTga0xtQ38mCxqG51o14BPfJys6IZA+2gJgFdHO+KdIt6kqS39h
         9Vr3KH99eX3uYVTbCOWyIn13zvJrDSCvS3RbA75mcAzUiXp5alO5NcVkIJDOSXzDcQgP
         8YVuCXgAhqxllzjjC483lSdvbNr1UPdIXjNCjIqomrVQ6fGsWtXH6hkNPCzbU+tNx/mG
         k5Vw==
X-Gm-Message-State: AOJu0YxTj6QuI9v/hNWQgGVfTH+/FxmqPFJadkXC57idj/B7835uJQzr
	ByX/BLzeH0qqgNnZAwJ/QlCgSuErMd7aTgSCSS/QjYieyZhJkgmbxibdu5ktA4gNN85Xh3DlGre
	+
X-Google-Smtp-Source: AGHT+IHAv1yvpkr+H6SES/ckioi1tSQdxgWdUsorIwkZze17lXTZnY5SCcaTYAfbEQ+yqHTUNlKbXQ==
X-Received: by 2002:a17:902:e98b:b0:1dc:c288:40e6 with SMTP id f11-20020a170902e98b00b001dcc28840e6mr491822plb.2.1709164141846;
        Wed, 28 Feb 2024 15:49:01 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id u17-20020a170902e81100b001dbcfa0f1acsm29075plg.83.2024.02.28.15.49.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 15:49:01 -0800 (PST)
Message-ID: <3a0fdcbd-abd2-46e0-a097-9f0553954ad2@kernel.dk>
Date: Wed, 28 Feb 2024 16:49:00 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/8] io_uring/net: support multishot for send
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>,
 Dylan Yudaken <dyudaken@gmail.com>
Cc: io-uring@vger.kernel.org
References: <20240225003941.129030-1-axboe@kernel.dk>
 <20240225003941.129030-7-axboe@kernel.dk>
 <CAO_YeojZHSnx471+HKKFgRo-yy5cv=OmEg_Ri48vMUOwegvOqg@mail.gmail.com>
 <63859888-5602-41fb-9a42-4edc6132766f@kernel.dk>
 <CAO_YeoiTpPALaeiQiCjoW1VSr6PMPDUrH5xT3dTD19=OK1ytPg@mail.gmail.com>
 <ecd796a4-e413-47d3-91c1-015b5c211ee2@kernel.dk>
 <f0046836-ef9d-4b58-bfae-f2bf087233e1@gmail.com>
 <454ef0d2-066f-4bdf-af42-52fd0c57bd56@kernel.dk>
 <a0f62e25-f19c-44b7-bf26-4460ae01de7f@gmail.com>
 <4823c201-8c5d-4a4f-a77e-bd3e6c239cbe@kernel.dk>
 <68adc174-802a-455d-b6ca-a6908e592689@gmail.com>
 <302bf59a-40e1-413a-862d-9b99c8793061@kernel.dk>
 <0d440ebb-206e-4315-a7c4-84edc73e8082@gmail.com>
 <53e69744-7165-4069-bada-8e60c2adc0c7@kernel.dk>
 <63da5078-96ea-4734-9b68-817b1be52ec6@gmail.com>
 <0e02646e-589d-41da-afcb-d885150800e6@kernel.dk>
In-Reply-To: <0e02646e-589d-41da-afcb-d885150800e6@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/28/24 10:28 AM, Jens Axboe wrote:
> When I have some time I can do add the append case, or feel free to do
> that yourself, and I can run some testing with that too.

I did a quick hack to add the append mode, and by default we get roughly
ring_size / 2 number of appended vecs, which I guess is expected.
There's a few complications there:

1) We basically need a per-send data structure at this point. While
   that's not hard to do, at least for my case I'd need to add that just
   for this case and everything would now need to do it. Perhaps. You
   can perhaps steal a few low bits and only do it for sendmsg. But why?
   Because now you have multiple buffer IDs in a send completion, and
   you need to be able to unravel it. If we always receive and send in
   order, then it'd always been contiguous, which I took advantage of.
   Not a huge deal, just mentioning some of the steps I had to go
   through.

2) The iovec. Fine if you have the above data structure, as you can just
   alloc/realloc -> free when done. I just took the easy path and made
   the iovec big enough (eg ring size).

Outside of that, didn't need to make a lot of changes:

 1 file changed, 39 insertions(+), 17 deletions(-)

Performance is great, because we get to pass in N (in my case ~65)
packets per send. No more per packet locking. Which I do think
highlights that we can do better on the multishot send/sendmsg by
grabbing buffers upfront and passing them in in one go rather than
simply loop around calling tcp_sendmsg_locked() for each one.

Anyway, something to look into!

-- 
Jens Axboe


