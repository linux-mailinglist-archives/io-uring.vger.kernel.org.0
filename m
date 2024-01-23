Return-Path: <io-uring+bounces-456-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59155839361
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 16:44:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D2192B221E4
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 15:44:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAF085FEE4;
	Tue, 23 Jan 2024 15:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cmDoAJ5T"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1FC524A4
	for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 15:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706024209; cv=none; b=tskAu7kzGzKvKsJ7FzVn7tPQfYCMmovT1RpeZKto+0Hd+Mvq8LOPrv4d8OLCIct+TNf/q9Hx/QVp4Z33s35sUy4sS/e5YmBVKUpLi6AOFAMfZ3+Oie4ns/8GYZWBC+XUexQvF6b9bor5MmwQF4xWzAqfCHoXlNg6hEKO9WWE85c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706024209; c=relaxed/simple;
	bh=zr1ccRRzOKk7EW4+TXSM6MxmSzUZP99rCcF0iZowtTk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GYm30NCYQJ7gBluixz5xr7FbOrcxeO0LPwh8kCCuFc7efDm7KydcIUqpyjqRTOutjFly1kirsupX6iFup5I8VMTBCda5sqb2lSreEeDKWVgOcz6lKmQ1q6m3ELOwRuVhXyUjKzii9q6Hb0Cmi1uMesjlowguoljKjBSGY6fjzWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=cmDoAJ5T; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-7bb06f56fe9so49726339f.0
        for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 07:36:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1706024206; x=1706629006; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CPQExMa7k/Z4ntA1e4zwJUNWM43v4RhA2KXst4WwH/Y=;
        b=cmDoAJ5TybfwBJRaWdFQgyG+pzT7tJj0u+DBbWfantjfrQiHKUJfUBPlm75mIy9mtX
         ixmxqwGACvmkwNCWpfLgVi7oLJntvYcbkkChAiEhKP/A++XN+DpX2wA29zjvssLBHlD2
         anTecgjlYKWujxvLw+KDTiQOKDlZJ5Igg/cl6CcMpuU2QLoFFwXfaULajKUMTFQ4CyQy
         J3uz8upuztFNxuwC70wNYzktP6+9OvQsPUDe9VImiIACzt7a0uVEzbwlfQ4hQGjnc5R0
         pvdWNKeahelYBkyli80piAXELDprZqiQoU/lJwPmfsu7VXKNCzvCk20SkKjs2hEXnEH8
         5iyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706024206; x=1706629006;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CPQExMa7k/Z4ntA1e4zwJUNWM43v4RhA2KXst4WwH/Y=;
        b=YchVwznDVoUPRD2ae7O2v9yUAt+glsU1/UgF50bRzRNX7/FMsGvSDKd/c6BQUXujl1
         S/7bBcr0Nn+ErCfRtHqd23IdLu3+ayIomknyeE36Q/O/VzRrHiuumcs60f07d+q6q09N
         uI5ibe+gHIB7tQ5YjWJEDPop5zTyRAylsaG3Qch2KnFM/elgrqyeHInfDsV68VXqB95G
         /KR4hJ3JTPcS5QaVgDlzFO5tFcCeHjLO0JeN9wElEgiq0eoLk/O8aXqgeE6QpxvieqFw
         yvTvpoBXb9Wh3Z6XSt23VulcaMvIfVjEtOCyLZtgv+Ld0OEVwyy+DtKfHicfAodsiHon
         3qKA==
X-Gm-Message-State: AOJu0YxzX0uX+20TkITbAKlSmTvZInNO7HHSvgNYIODyQPPdibOcdXYs
	XYJSqt8cslzMqP4A6WDoGvxXrk52qyAK5UdFhM8/OG1uFcjZmyc2rxmJumDixRnLKK/52AdtokJ
	qLNg=
X-Google-Smtp-Source: AGHT+IGR7ggCSapwni/wpxBkAlawbqnrwF/0cAmwWz164V1YcU/iNvqKjhEywTw6OxhEhI9uagHT8A==
X-Received: by 2002:a05:6e02:1be8:b0:360:702a:3f89 with SMTP id y8-20020a056e021be800b00360702a3f89mr10611068ilv.0.1706024205853;
        Tue, 23 Jan 2024 07:36:45 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id bl6-20020a056e0232c600b0035fabab7985sm2021370ilb.21.2024.01.23.07.36.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jan 2024 07:36:45 -0800 (PST)
Message-ID: <f1f208b5-e1e0-48da-bc0c-54b47c21bfd2@kernel.dk>
Date: Tue, 23 Jan 2024 08:36:44 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] io_uring: add support for ftruncate
Content-Language: en-US
To: Gabriel Krisman Bertazi <krisman@suse.de>,
 Tony Solomonik <tony.solomonik@gmail.com>
Cc: leitao@debian.org, io-uring@vger.kernel.org, asml.silence@gmail.com
References: <CAD62OrGa9pS6-Qgg_UD4r4d+kCSPQihq0VvtVombrbAAOroG=w@mail.gmail.com>
 <20240123113333.79503-1-tony.solomonik@gmail.com>
 <20240123113333.79503-2-tony.solomonik@gmail.com>
 <87y1cgrt5d.fsf@mailhost.krisman.be>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87y1cgrt5d.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/23/24 8:01 AM, Gabriel Krisman Bertazi wrote:
>> +struct io_ftrunc {
>> +	struct file			*file;
> 
> This is unused in the rest of the patch.

It has to be there, see io_kiocb and how file is first and these are
unioned with that. See the note in tne io_kiocb definition in
io_uring_types.h.

-- 
Jens Axboe


