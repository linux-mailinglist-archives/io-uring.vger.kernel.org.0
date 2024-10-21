Return-Path: <io-uring+bounces-3866-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C0DBC9A6FA7
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 18:36:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78400286785
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 16:36:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EC20199939;
	Mon, 21 Oct 2024 16:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="b98IisYM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856A014A90
	for <io-uring@vger.kernel.org>; Mon, 21 Oct 2024 16:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729528597; cv=none; b=L6Ygbnj6L8XNM3k7PbAUA0CGxz5PETn10jDp4SaWphmDJ3ZXDRsb/j8GkrjeaoFKTCu6Ezt1r9SnbnqTaf1JRAKxCLqDJej5u4noXo+EhhJowCk811idx3ouC4osZidwvkZ0x7Ayw6oZfLjI4I2HrmA7gcoJbc0okWne3Goy804=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729528597; c=relaxed/simple;
	bh=LF/v2APQUH1XNOf6nW5RuGpUkrh2C2KCHmydIhInUF0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E4Ct5lF73jOjrTcX6QJtk2HpibuuyhYXXclzxPLvHlDS5Ko3yFhrKDYSXIz79SOc+c7z8CEqYtWlQJ/aHcnjL8O4KzpOrsio+f+Uh71lrJ+p+GnYR4kjxKP6eQUqZdqqVd8GH3qWPte9XhVgqHKDPfUzEtn8nDWDnCtyz5bMfZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=b98IisYM; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-83ab21c269eso178899439f.2
        for <io-uring@vger.kernel.org>; Mon, 21 Oct 2024 09:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729528594; x=1730133394; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kpdiAit/JMF1gHPpQc8Fla49evuVYP+pTUnVRIxMK3o=;
        b=b98IisYMoDYKIMCEWfa1BBvRcnhZPARN609lDC/X/ujP4oDniAF3VDcuyo+2yAXPGQ
         pffp5+v9iWxEhhSqIgaX5ZAD6KS2gWxOHOrIO6ErPF5M1iv3Ajst70Lt+yGtO+3v0i27
         NHlWjSMkE9keS5fGeif85XsD539y9rdvTQG9xY6Xg+H8+VVMRhwJOh/o2eP+ROM086Ej
         r5cn17/yaztZGpF3I41+4kCYGlwrq10uvh9eaWOv2vJIVpWj/QgjsxzqEz/OkrX++H6w
         nKxYvQvCijR2aDTtj/ARKZ14RC+Izn4KVeploeI6iSlezuyoeGg1nxogw3KX298XPhMa
         1XMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729528594; x=1730133394;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kpdiAit/JMF1gHPpQc8Fla49evuVYP+pTUnVRIxMK3o=;
        b=tciAGqKYmu32g+M7axoQv4LLz4GqgKRHejnyGjsi4rH0d0curPAMuNf4OyWDlzku8M
         UuJJBOu4IQBbMZHMIiKu2yaoAHxR2GP88ojGZq0PjYlhSL3/Jkgra1OpbWtbpsFrrmLS
         nvNUtLNHAkAiPzNTqM8hnZO1TuR+AIiX78ShIgCy1oD7aGKRn4a3P7uUXUV1Uim9F8U5
         63UgdyfN4+moyCfPhe48xLRAKANcFSy4cPkwm6Zs7yXGWnoFUswT2n3F+kaM4M0VHr40
         VXtJR+Czl6exJ/CsQhnH3hOy5nfinTayH4p0JWjQp18pUmXuShlB2m83dYpmcnJ9yd/u
         mj0w==
X-Forwarded-Encrypted: i=1; AJvYcCVx7s0ibJ5A+NHZ1u76CUgvi0YBWL+qxwKM97jLib+9yBimha0nuZ4CTv+MbqZgNvi7ink+CmGPXA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/j9dauwMaTe000XPujn5KVIrB77vvZZk8226AQs4GU7++TlaI
	wulh3hh+CF4rfV/0W5tBT12DkJdWABPbqIt7shf3jVYWj15cimLpAG+yVsQOiTc=
X-Google-Smtp-Source: AGHT+IH8sxT/2fAb5kxlReNE++mbPam1BiFBGzt9LmVdzUVOqPu5mbyUeoikCKAH7Uj3d+kmTueS4w==
X-Received: by 2002:a05:6602:6427:b0:83a:a82b:f861 with SMTP id ca18e2360f4ac-83aba678bb8mr1156493539f.16.1729528594557;
        Mon, 21 Oct 2024 09:36:34 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a63022fsm1096005173.127.2024.10.21.09.36.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2024 09:36:33 -0700 (PDT)
Message-ID: <440c7c15-22e8-4782-9faf-0e9412bc02a4@kernel.dk>
Date: Mon, 21 Oct 2024 10:36:32 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 15/15] io_uring/zcrx: throttle receive requests
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241016185252.3746190-1-dw@davidwei.uk>
 <20241016185252.3746190-16-dw@davidwei.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241016185252.3746190-16-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Looks fine to me:

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

