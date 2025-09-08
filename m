Return-Path: <io-uring+bounces-9645-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F0851B4912E
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 16:21:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 25A62202529
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 14:21:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A06F1A2387;
	Mon,  8 Sep 2025 14:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="RdbC8EDv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BD030102F
	for <io-uring@vger.kernel.org>; Mon,  8 Sep 2025 14:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757341247; cv=none; b=jCyNHFxHOqUh3WKOKwkfDL5NQgg3MUX0pSOEt9l/ln7qOG+CrQDnsrPOz1xe4P9qYWXt/7Q5f4tMVol48OEWdsGE9vVzXURzMwjZvXhKAv49744aYHNSsogUU9U2Bo4mOnHvzln611Lv9omMY+B5Nr5QSHF/U0PQRUTI85HnsDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757341247; c=relaxed/simple;
	bh=a5MNQnhmk3mz6jWOs76pD/dm/NnFA+R8u3EEqxeCbPg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SaWyi/+3Uu4goR5r0T2ZqNCreTyFJBK6Lcy6r74IDHpxrpl1LbjKJ+ObjAzEbTMmKVHMd0c+HMZllpkcGOGXS13wK1Ptw/QfGZWU3VYR110766rI3GQk4AsHF83+24tNVz3nWSti0vKwvjFp+I3DCf3Ep+gv9M7lap1OLWUnGjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=RdbC8EDv; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-25634c5ebdeso12571065ad.0
        for <io-uring@vger.kernel.org>; Mon, 08 Sep 2025 07:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1757341244; x=1757946044; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3jjuUuXK+WrOgi1W4/pTHpNwueN6b3LIrqzt6Nh5pAA=;
        b=RdbC8EDvkPMOap97VPvJ9MvX5s4oi4+AqQVW60cx59R/ynnPuflv9PS/DWu9ckjlk1
         eNLIB9okUjlVU09mi7mIgWug2DvMEgxHVkzzaaaiPU6F3vdLOvTrPQ+EMb4c1kx+St6b
         dJPWf5pBL0TmXFjitgFCrPlp43C4aCDgPFrsxlKSbfSZmGGT3REUyoHgMN42pDTBngR+
         BgPDJKd75WD1aLqAJwJSDVB5uA+v18ipQZHoEXHKg/cINwNiljNoFRYop95kb0Isw9WA
         3W3Nls3fP/j0Jg/vAn6vEXSyf+m4KFsh+XJXbnWt2v7YC7dg0wbMx/mA1M4n537UG2es
         xfOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757341244; x=1757946044;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3jjuUuXK+WrOgi1W4/pTHpNwueN6b3LIrqzt6Nh5pAA=;
        b=SeJXWYEvzouqZRo/QVIVXuaLbG+u+e4wRoPGT+CPBHU3FRInddFVQmCmQfVhjexe2K
         /3lgGTkzS3JBhEgpDytqOMDHfUu/emSuJo4S/ViUPclIPBLz8WfMv0yu0RUa6L4MDEfk
         91sZUq5c5HEQvue1/7SssroJwh4batb0lcr3qx04oWzZ579C9wnX4WEoemZI1c+QEVxE
         q737wouHLkoTeX17wj1Tg0mO1QfU4twuVoUGnDZzKN4R/Pcd59QFes94JeAnFqaGEBaL
         ekxHEc+fk6Q3YpTQgKVW8AVeiWDm6ffPAxoGzU1dZxZA9GmKEJR/boaEiPgnHX6z4OAZ
         0h3w==
X-Gm-Message-State: AOJu0YxQsaUUW82ZBcAsIVfqB6sA12kG7KXMVLBCHzx/0nWsKivBbfmU
	GiupJa7g3IBO8WQx+uxqjSwiT070bC1zvIgvENP487U1Apax7kmHFdm4XNO2Cy9q/s8=
X-Gm-Gg: ASbGncsUFm9EQPNqUo9cmYGYG3JO0Vv0BFMU9LocwmFS5hVS65wtihk+4hg1jGzlZtQ
	P/lVmwnHuea/5XfyYRsBvZ787m5vmpu+vpV587amqxn61g+w+MA9yEWnNiVcm/tINLmBwyt4dpP
	uhDcs1zwVEoxr9RQikJCfHv+UxPWXHW3/65uH6NwDILRzuZZ+v6I6uuYggUYx2dObUjyfNXlTKU
	Vu4gqkxdWQZ/G2tqYRO/9GWuXRsJ4oQ//d0eYSx/aYn+7Gp/Uoqj64DTZ/6Em3TflUInfEKIaQY
	gSfu3UMVXmbjwghBRnGrQgwbIqXC4zvxdyJyfTX172k6lYukw3Le2Glur6Bf9HJDvjOxS2F8RUR
	hbI/9qoFt/CX1xlk17LUf
X-Google-Smtp-Source: AGHT+IFhFVAhsFFQfNiBy8ngAoCW32BM2nFvfVL1ex17njJ+QLocbwAbePtZ7yFUeSXhlfB6beIDXA==
X-Received: by 2002:a17:902:f607:b0:24c:8d45:807a with SMTP id d9443c01a7336-25170e41444mr98195675ad.32.1757341243780;
        Mon, 08 Sep 2025 07:20:43 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32d5d6214f9sm5653595a91.26.2025.09.08.07.20.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 07:20:43 -0700 (PDT)
Message-ID: <71c05242-a522-4294-bfc5-d867bb154284@kernel.dk>
Date: Mon, 8 Sep 2025 08:20:42 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/uring_cmd: add io_uring_cmd_tw_t type alias
To: Klara Modin <klarasmodin@gmail.com>,
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250902160657.1726828-1-csander@purestorage.com>
 <3h5wdobeinxy7bbhvw3aztcns33cea3irxg4ckwvmds56ynyi4@45fy2e3uemz2>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <3h5wdobeinxy7bbhvw3aztcns33cea3irxg4ckwvmds56ynyi4@45fy2e3uemz2>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/7/25 6:33 AM, Klara Modin wrote:
>> @@ -104,11 +107,11 @@ static inline int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
>>  static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret,
>>  		u64 ret2, unsigned issue_flags)
>>  {
>>  }
>>  static inline void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
> 
>> -			    void (*task_work_cb)(struct io_uring_cmd *, unsigned),
>> +			    io_uring_tw_t task_work_cb,
> 
> There seems to have slipped in a typo for the !IO_URING stub here:
> s/io_uring_tw_t/io_uring_cmd_tw_t/

Indeed, that's my fault. I had to hand apply a few of those patches and
apparently butter fingered that hunk. I've queued up a fixup with a
Reported-by for you, thanks for catching that!

-- 
Jens Axboe

