Return-Path: <io-uring+bounces-1031-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 16C5887DAD9
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 17:36:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AA8B41F2132A
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 16:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA7CC1172C;
	Sat, 16 Mar 2024 16:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="usmkwvGt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039A31BC41
	for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 16:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710606984; cv=none; b=fy8C59ZLtfdmWcgiNQIF4O4Dml+i0/E7wC5ngj0+NUJjLvYPqr2jdk+IZr7YkiMq07qoMgvqedSP6m+DYxRgHU9RMOZAUjxUmze6jJOaNVfOQpRSMeEbstItzWWrPYvf3kZvj9G6Xe11+1o7f58bWP/XONQHRATzRDRPNyNf5Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710606984; c=relaxed/simple;
	bh=JYnUU9mew6YYRRbOZD1xZx7zv6EKUVNC17TuBzdPVnM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=LRbQmCNA884BLiPyFo3cd2DR5IeSGIObKoZ+QvvdqJ9LY0cphd2o0gcavIp4ZQHQQ4BAYXCjEPMcvAaQB1VOWa9nje/JqsDPPbPiD5gO5aFPXSaEgp/qPmVPMjP3EHrOS6XpYq58HuFO84H4LinHrNpSPd6QiR16Ykys1/rXvJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=usmkwvGt; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1def81ee762so2845945ad.0
        for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 09:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710606982; x=1711211782; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sIgc4K5sBCYB4E9ohg/qM50cErwvd5n316PNE/cXMG4=;
        b=usmkwvGttxF5Zavn705EiZMQJZVxO0vPLBAH5P+og98Bt3tgpVUWQapUbhIejwMJSe
         yb+v1aHdpfUay1HPHWVEk/HegBu7pd0MgnIkyY7qKmk0GSZu8ew7qng/6LPr4RrHG4/z
         2g66L0c5uuAra7R8wXR7HX6Tm7ucn60qV1TlyYYTM8XG76K/LdkiXHvLdudSL0VotH0O
         596DBVuoUYC+z+6oDpOxlwD6weGQmh7+cvPfbG8SkXI280apDKcHE/0RXSceA7As33Vk
         7DnmsQrlleEOspwz31zH447pCXdJpGIUoCCwCa0hLsW7c7xPBFgCc8I5gZR5YvSPVBnd
         5etg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710606982; x=1711211782;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sIgc4K5sBCYB4E9ohg/qM50cErwvd5n316PNE/cXMG4=;
        b=liuTCrmnTuEUyWftj+beCRGLbc5TOdO/vB+n8PM8wQGmXmQUpSBodG9ntU0NO76LWj
         WW1+T0BEkAdY7KLBc2P8oLBGY8d8MHNbGFCfO6Yn0X70+tu41DunqJ5RrEqrQ8ziM+3O
         NE4HVx/HDyhsplpiOCY8+T/XaBq0VS1KhHYyy8xwM+su7AJhD0ILaSc/R+DAJQM5Pa51
         T9PhOWk+DdKRY/oh9XIFHLo29rZ3muCc/jgdq5vozYSIMnf8CpZdA0kZ1R9DToyOgRWH
         8num9Da021BLvUR0UYgiCj90bGjKPQ+ucpm0bypmjWvG5FbbrgoJk8Blm0VZlgE4iRbZ
         otiA==
X-Forwarded-Encrypted: i=1; AJvYcCXdIRjlvZFjIdcjuef+LChndhlfau2fux0aoXRoqVKdw3Q+5/+xqxNWkwpUEVbyAmJupdv2LLEZTHl5J28m7PVLVRLDQS/MUQU=
X-Gm-Message-State: AOJu0YxwHi95ZaRyPzSzoxu6T7UNDJqEOzzhjDdkCAok3ahK7oEmRzch
	SP/RgfradMjXJiF24T54FX98oEuwxIxA9xP9xYGHMmp++X7t5sXaLUA+4pD7Pbk=
X-Google-Smtp-Source: AGHT+IGAYUOz3ilALO1v+qbSb1zIMsdRvT5sanMsg9H8UcdIm+tW41XkuRhmWuFdjqwgPhwvJPfCVA==
X-Received: by 2002:a17:903:24e:b0:1dc:c28e:2236 with SMTP id j14-20020a170903024e00b001dcc28e2236mr9620830plh.2.1710606982426;
        Sat, 16 Mar 2024 09:36:22 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id mp16-20020a170902fd1000b001dbb6fef41fsm5991127plb.257.2024.03.16.09.36.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Mar 2024 09:36:21 -0700 (PDT)
Message-ID: <7c16c203-8b5f-41cd-8c86-cba36887b505@kernel.dk>
Date: Sat, 16 Mar 2024 10:36:21 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] KMSAN: uninit-value in io_sendrecv_fail
Content-Language: en-US
To: syzbot <syzbot+f8e9a371388aa62ecab4@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000004db6840613c99fc6@google.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0000000000004db6840613c99fc6@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Let's try this one more time:

#syz test git://git.kernel.dk/linux.git io_uring-6.9

-- 
Jens Axboe



