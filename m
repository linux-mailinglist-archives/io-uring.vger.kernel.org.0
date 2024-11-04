Return-Path: <io-uring+bounces-4437-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A70269BBC69
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 18:53:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EA43CB21E75
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 17:53:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDE8A1CB316;
	Mon,  4 Nov 2024 17:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="LDzswUq6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81E51CB9EF
	for <io-uring@vger.kernel.org>; Mon,  4 Nov 2024 17:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730742728; cv=none; b=GR16mqMJPOMzP0f9GXesXPRb7g2fGOeTCK2AWnIX934fNzGhxv++nKtBLK/pHDAAOA2ioZjNQ/O12xzYLsSjtlh7scHK/mwk00hSgdfFi4zmAFhRcb0Rpgar64GMlc7FQDURHAa3O7pkAZVpxoIcDL/d0UdW6+08Bn7mo7xMjT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730742728; c=relaxed/simple;
	bh=7PScOCV+vQQRYsBAwHi7EtbwfcDD1uktA9vwsvwZlJk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=Mjbdw+wIb/lCh4FeXIi7Dev6oKpjg3Ic9WJbSMNXEJwNSVrdB/qUxc7ntSr8s/vBDv0dHQSIWfsSIsnlDatTtxpPH3VVypO7RvDMWsFVbpmP0ibidijXgj2o7nx0uq7d8tWsWTGmOtS/wpfsn2bE8QWo6S4s7in2AleEabXBDTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=LDzswUq6; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3a6bdc8f7a1so8395645ab.1
        for <io-uring@vger.kernel.org>; Mon, 04 Nov 2024 09:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730742725; x=1731347525; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yuTlNdk2NSH6zLHecV0q69TnUSkSQba1NI0vyDxl/fc=;
        b=LDzswUq6Geg9DjYWsa6B5SxeemgkweMUIM1se+grJChQ/E3Co47mXGQSsiMQriRhVb
         CwJSrnduS599aTYfRLf1eDo9hvXiVsBCpj6/acQ4sqNdNu0aqE2UzLY2Du4KvrFbi8RQ
         iQ/mC+mg1k5ooXAsIeUHrUnOPxMdFjofoROYRI41Wn+ECIJPKTLBCi/1WcKi0jsq+6HI
         CTQTwNXUIttOA4+68GDhXkmcP+y2tSTTwjBHb7AJqOGAkPjUExpsQhEuHdvRz2cW60+u
         ePBFe63mUSL3pFbGoimeVa9osiSX9V62Ok7V2+960G7qbFGa+HWmg9d0Yu+0SoUoTXr5
         mIQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730742725; x=1731347525;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yuTlNdk2NSH6zLHecV0q69TnUSkSQba1NI0vyDxl/fc=;
        b=nlMwlRUaGvQ+pTKUc1vU4ous7SVBwAYkO4E62LElr+Cas3HossJcLVV38GMcDeJncR
         0xl4ipF7yblrAvd4I0MOh2vg8Wnlvx1ESiCc9TaQkgZiRT2soHjhEwZQluIf/1rKifWa
         jYQeC911CuHGATQnV2EdNT6nXzYQV23LgJahoLF+eJeyiwlRrPtt90E3EC3267FmKW/a
         QhrAgBx2wI0DkVf9HYP5WdSXsU3QLmCW7/4OnjW0wRgfxMT10Rit6jlQNlN2LJ23L6vH
         tIH0Ykki05iv7f5l1h4iuNKQd9hRijqjikrUmKUfP8yNp7631t3klP3eC+dWT+wUTmEs
         aMgw==
X-Forwarded-Encrypted: i=1; AJvYcCXPg991NN6BYl69l2r7pfcJfIw4ovKuaiNPQTU9ZKTEXj3/rwLSTiGlbyN8LQ9C7mbFilT+QW9qPA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzW8zS7kQ5o7eKo/iOgCzEB3MOVQnFbj23Ks02W5hCYhdp+l+/6
	VwMcBdknkjoUs7ilLV6t88PlseJXgsJbHgcewY3MiTQAxBeMTYXwN27plmI7h3g=
X-Google-Smtp-Source: AGHT+IG1l+Yt+2Jy9vVo/2j/GUj6+amge+7rWats8dxTVXJPfuU8vxH7l6Oa8G5o/mW4UXRmT9YMsQ==
X-Received: by 2002:a05:6e02:1c45:b0:3a3:b3f4:af42 with SMTP id e9e14a558f8ab-3a60f1fd184mr162543615ab.7.1730742724600;
        Mon, 04 Nov 2024 09:52:04 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a6aaba86absm23139735ab.66.2024.11.04.09.52.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2024 09:52:03 -0800 (PST)
Message-ID: <1fb2ead3-f911-4593-8982-098c7e75564d@kernel.dk>
Date: Mon, 4 Nov 2024 10:52:03 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/6] napi tracking strategy
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 Olivier Langlois <olivier@trillion01.com>
References: <cover.1728828877.git.olivier@trillion01.com>
 <173074259442.421784.9269680507652013350.b4-ty@kernel.dk>
Content-Language: en-US
In-Reply-To: <173074259442.421784.9269680507652013350.b4-ty@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/4/24 10:49 AM, Jens Axboe wrote:
> 
> On Sun, 13 Oct 2024 14:28:05 -0400, Olivier Langlois wrote:
>> the actual napi tracking strategy is inducing a non-negligeable overhead.
>> Everytime a multishot poll is triggered or any poll armed, if the napi is
>> enabled on the ring a lookup is performed to either add a new napi id into
>> the napi_list or its timeout value is updated.
>>
>> For many scenarios, this is overkill as the napi id list will be pretty
>> much static most of the time. To address this common scenario, the concept of io_uring_napi_tracking_strategy has been created.
>> the tracking strategy can be specified when io_register_napi() is called.
>>
>> [...]
> 
> Applied, thanks!
> 
> [1/6] io_uring/napi: protect concurrent io_napi_entry timeout accesses
>       commit: d54db33e51090f68645fecb252a3ad22f28512cf
> [2/6] io_uring/napi: fix io_napi_entry RCU accesses
>       commit: 613dbde4863699fe88e601ddd7315f04c1aa3239
> [3/6] io_uring/napi: improve __io_napi_add
>       commit: e17bd6f1106d8c45e186a52d3ac0412f17e657c3
> [4/6] io_uring/napi: Use lock guards
>       commit: 6710c043c8e9d8fa9649fffd8855e3ad883bf001
> [5/6] io_uring/napi: clean up __io_napi_do_busy_loop
>       commit: c596060fbe5a1c094d46d8f7191a866879fe6672
> [6/6] io_uring/napi: add static napi tracking strategy
>       commit: cc909543d239912669b14250e796bbd877f8128a

Finally got around to this one, apologies for the delay. It looks really
nice at this point.

I'm assuming you have a liburing branch too, with the new register parts
documented, and probably helpers for setting it up? Would be nice to have
an addition to the napi test case as well, so this can get exercised as
part of the usual testing.

-- 
Jens Axboe


