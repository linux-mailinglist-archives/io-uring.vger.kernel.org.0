Return-Path: <io-uring+bounces-1210-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D1AE88A9C5
	for <lists+io-uring@lfdr.de>; Mon, 25 Mar 2024 17:42:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 426EE1F244D7
	for <lists+io-uring@lfdr.de>; Mon, 25 Mar 2024 16:42:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D797B15A4A1;
	Mon, 25 Mar 2024 14:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="B6LLl978"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1A3156224
	for <io-uring@vger.kernel.org>; Mon, 25 Mar 2024 14:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711378498; cv=none; b=emVEWS65fSQkBSYPLaj9M5oKSfuZ4vEy467FprZa5JXoCNV3t+qMTgjxzLG+4yc2b4NSMZL8kXdrOMLA4aJpYitxSsup9LphYn3R6Ux4OpsFAw2XFS1wykH4lSsr4JiEAiRHmgHc9tCgqJDCrpNpjRiIEwxZKadkng71xXtn3cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711378498; c=relaxed/simple;
	bh=jYhI1XWQgeU7TEThxdW9IY57PTppyjqJ2QyV0ra87cM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tjQJUCn0cKJhoU+sCEo+YtqStOHW0/Vnp/DYQSCSk8XmTanLQQQ0adVUMuuADZzHdfhZEx5JIBDfP7Rpb9uOD5dclb9pu57wwmQmwIOrokxxI9WLkrVPuM1F8st4+ZZM4VL1fQNCLt+SIpnTf2nhOuSh8akoIqzuC+v89ff+Ow8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=B6LLl978; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-7cc0e831e11so75244639f.1
        for <io-uring@vger.kernel.org>; Mon, 25 Mar 2024 07:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711378494; x=1711983294; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UPpFVitym7hRJXbs1NBA1kCIKWBpaebenDSLj694Fgg=;
        b=B6LLl978/SFsY8u2vIdaKGVWe8q4hiQAe1qZutc7TjqPASRVMCQvHz487pxK7l7C7A
         vLtssbdRQPxHiOfv161lPvhI04jYbOANHx/BEeTcYIeiuEVHf0JRzK0opLWlmF6cgme+
         RNkqNOsN4G+D+hkDVUncTUEoP7atWUUVqs0R+AlfyGCPfbRKNPIQ63UmoMomZAp1Opc3
         c6aLFS+7yWWxhnKVNHBj7S+J0j0lqr2PIte40n1kGmfG/Ae1R6QmzL2EPP9uJHoVhjAi
         aUGlCdYKPPVwzx5i4YrzowVVtob1ywU8vEvB2Vmk7cyei6xGx8+6DpAfGBoWQzJ7Efwh
         5W9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711378494; x=1711983294;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UPpFVitym7hRJXbs1NBA1kCIKWBpaebenDSLj694Fgg=;
        b=SWlQwJ33lSZ9B3R7Jk39tKQGTXTb/4xZpzW2J0Hn+9CYOuhXDoZ54nVn81MmTgJVjl
         NndeWbUwgC+WviZrJ7C3tvDyekQ8RIXt5RaAWRQSZ0JywSKRX6DZPuv23jWBYmV5t9Nk
         8hpOtH6PSnoLu1xGXmP2qiX4ZQzR0uzI4U1qzk+1g34Y6jZSzHNTU2G9TdBZwSolWuMs
         YsWnuTwmahxTZNrkmD51z+JSMh2hj1AF2Ty70KNCQqiD3SNma4HOPnAUQBJHaQ4KEXjG
         lMnRP4m5/nA68kZDn4XIkepKauu4moLScRcxsDwTLYEF06b2S7qVbZ/ZD7ETBFj4urpP
         Rmzg==
X-Gm-Message-State: AOJu0YwmvlvS7RKtto884oPpPQpXbDClVhsQv98AO7EpcwhTcjZJ6BmF
	fqiODvqySrnE4/It1USwxgCzny5QuQ88WqQy6Kqh1IZaxrukQPuo18TuC0TVk/Lv2n5n+aoLFqG
	0
X-Google-Smtp-Source: AGHT+IG8/Ucuyk6rVvTsAyA1S6LR5fW67PyVDs1vav258XPJZCd/5dwS+AFQNqsyI7hZZXHCAqTSCA==
X-Received: by 2002:a05:6e02:6d0:b0:366:b0bd:3a1a with SMTP id p16-20020a056e0206d000b00366b0bd3a1amr6531110ils.1.1711378493986;
        Mon, 25 Mar 2024 07:54:53 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id u8-20020a056e02080800b00366c4a8990asm2386978ilm.27.2024.03.25.07.54.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Mar 2024 07:54:53 -0700 (PDT)
Message-ID: <502ac410-e5fa-4733-bf7a-33a8bfac537f@kernel.dk>
Date: Mon, 25 Mar 2024 08:54:52 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/17] io_uring/rw: always setup io_async_rw for
 read/write requests
To: Anuj gupta <anuj1072538@gmail.com>
Cc: io-uring@vger.kernel.org
References: <20240320225750.1769647-1-axboe@kernel.dk>
 <20240320225750.1769647-11-axboe@kernel.dk>
 <CACzX3AvbFtCAH8Lr_zsNjQeMMhrRFdrmLcE=zRygWe61nL5YAA@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CACzX3AvbFtCAH8Lr_zsNjQeMMhrRFdrmLcE=zRygWe61nL5YAA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/25/24 6:03 AM, Anuj gupta wrote:
>> +static int io_prep_rw_setup(struct io_kiocb *req, int ddir, bool do_import)
>> +{
>> +       struct io_async_rw *rw;
>> +       int ret;
>> +
>> +       if (io_rw_alloc_async(req))
>> +               return -ENOMEM;
>> +
>> +       if (!do_import || io_do_buffer_select(req))
>> +               return 0;
>> +
>> +       rw = req->async_data;
>> +       ret = io_import_iovec(ddir, req, rw, 0);
>> +       if (unlikely(ret < 0))
>> +               return ret;
>> +
>> +       iov_iter_save_state(&rw->s.iter, &rw->s.iter_state);
> 
> It seems that the state of iov_iter gets saved in the caller io_import_iovec
> as well. Do we need to save it again here?

There's probably room left for further cleaning this up, as now the
state is always going to be known. But it isn't true right now - for
example, __io_read() will import and not save, yet do a restore if we
need to ensure the state is sane again.

-- 
Jens Axboe


