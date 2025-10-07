Return-Path: <io-uring+bounces-9924-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BE963BC23FA
	for <lists+io-uring@lfdr.de>; Tue, 07 Oct 2025 19:27:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B3C2F189E0CA
	for <lists+io-uring@lfdr.de>; Tue,  7 Oct 2025 17:27:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A766D2E7F30;
	Tue,  7 Oct 2025 17:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wxKKh3XT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058612D9EF0
	for <io-uring@vger.kernel.org>; Tue,  7 Oct 2025 17:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759858041; cv=none; b=StG+hSKc8Y7k54wCNDxZ85YoIoAJZ64LeInFN0i8/aFUIwW7B6uIH6Cjbe1+6B4SzXnnXlv8ebKUbxI96efAxxHLnRebSPkLAEcGbSCjUrxb09lrH8AmEPHYXD+EuGnjcZzEKQc0S2M4cyeY7WNI1HNm+lDB81Y36mAFjdbuNYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759858041; c=relaxed/simple;
	bh=4boE1QySS7dUBhbnewS9thWHVN2+VNmVMuGmc20NrWI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ak76OIEqBlhsVQkUF2qSXiVa/gYzhO/u7/bJNBOSkNOoJ4Mf4IsknJ30C5C12HwWB6hgRmHnUCsTRNn5sn9VRwR4ilOKnmAq+VjVXyfcqU7CqXl32wMw3B7zT4gL6Q2dXic1xKiJcbykYhqukuhrrjk1v1OW5cZHa2jrBgfxXf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wxKKh3XT; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-42f7b17f9f7so16229205ab.1
        for <io-uring@vger.kernel.org>; Tue, 07 Oct 2025 10:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1759858038; x=1760462838; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JZs6QfA1xQ2jarGgN7Pc8xUu74ta+A8+eWsu2/uVDsY=;
        b=wxKKh3XTOAIafnqvczSS/0uVyIaWzAW8BjFWE5gkBcAmu2AuuW8Z4py900YR+mGDG7
         vGjnxiqR2jfTBZKYIW6kPsX23qVitZqOmupAYLkRzIJ3eZLctejgNTGbsZ0d2RxWsULu
         epokI9W6RaJPnfLxUOgWdx/eZIBErlQMh2ryDi1h55gAY0RlPt9H4VMEEkFitzRFLUt2
         KtDuipyN3fPjwG9IrR+GtW4TRHS4wpcsftz1QkPxMOXAoWrgk1WCpULycKquRJwwyVcM
         AROhoI04e5oMfdlQ2cQDyS8p+g2s/50i2vsWZdOAVl62OPtnbBriAzFrvNAF1R02AeFM
         LRvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759858038; x=1760462838;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JZs6QfA1xQ2jarGgN7Pc8xUu74ta+A8+eWsu2/uVDsY=;
        b=wbdK+vsu9h7M3Scskw/PX93VWMQBaLJVKPRByVyV9/exM5hUWmqqZCmD63Aahux8ye
         slzvByxin1/fDm4mZskUWIk4M+DQSCcCZIwSJtBn4XOsEjAijctbchPELFLeujMQvYNP
         +1i3a2JNi1ZMhepRM6+ATF58WGVtglVHMuCs1UQnRdqi6Zq22Ut2PcqBzWr1bKQJCEKp
         Qr7BbhO78ie6q3BvU/eu8/c+7lMcFuYr+a4Y832FrkXW+SudFTuA5LUwJB6kHMy5uyBr
         +GapSOmghQiCULzVEq68q8mgCMfBVXtVErLcYNOy9Cyg+VP5Jkbwto0CO56WS3rc/D6Y
         NmPA==
X-Gm-Message-State: AOJu0YyQPEHhZwJcr/lz7mx8tZSuHtLnkFzSeMHC6IVSOgNYm/itW7tB
	F7wReqH/mHwlGJQttFBLcYRf0E+nmH7rzxlEEQK6IiMCv9M1VTDHUc6GXTFDAFXu/d6x/rBi1HJ
	Taxty9zk=
X-Gm-Gg: ASbGncsn/1s6KVsKgx1CRf4NUsA+his3Xmpi1g1kkrZ4+Ln/37/G19pUMjBsDPXDKcY
	vsy4vUJ+Re88VZ+13N12ZD4rkoN62nmsubxwhz8Kb9hgUgkSwX75i77n+dW0qDAZRDvIc8T8/rl
	Wt6Nzl0wT2vIgGJI9z00Eiupo6v34rhTOiuJPxkMgHpRf2sKkpor9++UvxBrislIKqRVmNp97jX
	ZRcng7u0iOZ0bH4mPrhY2GWiBMjKVwEGnntfFKUNNeioU+4BwinNzEfv5PNzhbtLn+zx35/iDdJ
	JCvyeufxp1ci0kg2ak62+N9/YvcR22yoe+aH6t4qK0M5LE304gVnYkWoDEH/Gp+/PEsBbhVAtpW
	mGFzJ7Mx3d8p7An+4i5ZODRSau5dr6JTyVshU634nEzbsKyHEnuwtnd8=
X-Google-Smtp-Source: AGHT+IFs+LIUotGR5eckp+7ViCNjBpas7WbwugfqfsfW2v5mzGKmII4S9PbLYy2RkfpE2uXpOMc2lw==
X-Received: by 2002:a05:6e02:12e8:b0:42d:7dea:1e09 with SMTP id e9e14a558f8ab-42f873d23aemr1552605ab.21.1759858037872;
        Tue, 07 Oct 2025 10:27:17 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-57b5ea31e13sm6058157173.18.2025.10.07.10.27.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Oct 2025 10:27:17 -0700 (PDT)
Message-ID: <f1e0ef09-572e-4345-b601-b4aea2de1052@kernel.dk>
Date: Tue, 7 Oct 2025 11:27:16 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: io_uring and crypto
To: David Howells <dhowells@redhat.com>
Cc: io-uring@vger.kernel.org, linux-crypto@vger.kernel.org
References: <4016104.1759857082@warthog.procyon.org.uk>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <4016104.1759857082@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/7/25 11:11 AM, David Howells wrote:
> Hi Jens,
> 
> I was wondering if it might be possible to adapt io_uring to make
> crypto requests as io_uring primitives rather than just having
> io_uring call sendmsg and recvmsg on an AF_ALG socket.
> 
> The reason I think this might make sense is that for the certain
> crypto ops we need to pass two buffers, one input and one output
> (encrypt, decrypt, sign) or two input (verify) and this could directly
> translate to an async crypto request.
> 
> Or possibly we should have a sendrecv socket call (RPC sort of thing)
> and have io_uring drive that.

You could certainly wire it up via io_uring in either way. I don't know
the crypto API, but ideally you need something where you the issue and
completions ide split, rather than just a boring sync syscall type
thing. For the latter, io_uring can't really help you outside of punting
to a thread. Having a reliable way to do non-blocking issue and then
poll for readiness if non-blocking failed would suffice, ideally you
want a way to issue/start the operation and get a callback when it
completes.

> The tricky bit is that it would require two buffers and io_uring seems
> geared around one.

io_uring doesn't care, it's just a transport in that sense. You can
define what the SQE looks like entirely for your opcode, and have 3
buffers per operation if you like.

-- 
Jens Axboe

