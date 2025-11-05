Return-Path: <io-uring+bounces-10378-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BC4FC35B36
	for <lists+io-uring@lfdr.de>; Wed, 05 Nov 2025 13:50:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 18BD31A24047
	for <lists+io-uring@lfdr.de>; Wed,  5 Nov 2025 12:48:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF6C63148C8;
	Wed,  5 Nov 2025 12:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FVn2wPTi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3DC30DEBE
	for <io-uring@vger.kernel.org>; Wed,  5 Nov 2025 12:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762346883; cv=none; b=Vyp3XDVB2ntYkJD4uDVwFgSKPlJ1MpqdTyZxPU6kmsqBvP8FZjYVJz65SuSvMPTCpsZaFrSEVZ8mef5W96JJb+vgR5VdQWzJH+tQuMfCQHBVau08+o2sfMAOYy4lo3NIJ5IyRQADxBqGnTFm+GVCgElylX2lI4ztUFa9eRnc6JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762346883; c=relaxed/simple;
	bh=uITf5cz2xqHm/ZQm2B6vRD+A2Et6+dmQIdzdkF5oMgg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LtML9HHSQh0/jGEsBAFx7Ch0xIMgyo11dF+y0c86qxLbmqC1gfqvdTlcAugRquytls6AI1O0KTRdEUrwQfS2DENA+N6NyfrV3zeWtjx4FVx+ByZL92RkhlyHWgGeprSkZ5V3dPC33W/XWEYjWZFTsczDf18AnO41hG78T/exlLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FVn2wPTi; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-47755de027eso13955615e9.0
        for <io-uring@vger.kernel.org>; Wed, 05 Nov 2025 04:48:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762346880; x=1762951680; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EEw+Oxq6xNnZGC9654HJZ1EwEcMiVMmcBMqIAYuQWtY=;
        b=FVn2wPTiz6wqfRrhIXGa3HbVxBJdqhir0QK9lEt00VULLDMOhS8RhL6A5x0UN21AXJ
         TGGC+L8c/RbW+UHgb86g4PNibqq6x1BV4FrQN4MAT89wRFVtF9fnxejry0iVoZP1aGhe
         /rMsEII0QQT9+2WcRoNzYTqXaFPOfojDUj8rjNPQUvsfLPtSfeJaUu/orDopt/nJ+6L2
         wYE9jniSS9qIATwCgC8wr0/SYwhY1/4HT8eOOahhUTmrzuz/eYO7D/TjFIsqsFXgo6jk
         3CpRy51WLEd/JvePIo70S/uY95V2cKGGnkd7MYcrpksopOOx8pyKpX/BzONtWjTCyw3M
         JsBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762346880; x=1762951680;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EEw+Oxq6xNnZGC9654HJZ1EwEcMiVMmcBMqIAYuQWtY=;
        b=R2d6TPRoMCRv1lzJ/0LmbFFpnoHCTrlMWS+Eu1ulFX4Bd+VoyV/9jeOa7aPKiQoy21
         y5ZvnhEEdrrI6Gqtjz7YFwYC/kXkqizQyzwd/UbwTj7cYWJKPbo3AqNl0mCVwtgMzRpG
         H8KUxAKs0H8TTho9grSE30wEepMrDe8pMna5iqHUeMygz6USMGqOHwRLyGkBA0rFy3Zc
         6UPObpxhc8JXq/4wV5aefA1cC9n1mFnQqSukNAuHoz/GHeku3mFXW1Xaq/Dp1KbF6wKY
         J9cf0jA2XlZDpVZvhjE7aAasNdIP6Agug1+BMpVzI2JaLLmoTB56bxN6fIgYk4U2Ql29
         gQhA==
X-Forwarded-Encrypted: i=1; AJvYcCXpYkvP5J4zZK07UI7rSlLbSqre3SPja6ESNlmS7vh4pzejzxYy4WogctABNlwmeoajPxk5Ty4G6A==@vger.kernel.org
X-Gm-Message-State: AOJu0YwuJchBgKINa7lvKzn5iNTfiGytRXI1IQ36f3UlzvB8W5EvsVFO
	XUhLEItej/XLgjgwxUiUCsO7ZUMNzX0rDfLku0R99ehW1r5ni95OTP68
X-Gm-Gg: ASbGnctmovsPJKVvdNEeO4LH0kYt/aQGHNPxvfNYwASx0Rb1IP+49aqlTuAuAXbYDdp
	hvCmYJNPA501JlqipRaIKPKysTSWoOwWTV2ePDvBI9X4QQXf5boRP1xqfrCSHwrREr31BDmHbXL
	gyQWVr9UV3++iZ/O9Pn9kdQaUjX4wuLsQ0qljQqVzeD/8tER+EK6spbTwfacSSZoDQHXWNNYXKM
	xPvUIYVZTsVPImsqV7LnR2BRM1pli+rR/R9WXHVE1O+KpmFZDQifi7cK0K/HjFrWBM0GI0YjR6t
	M4tZQTQvm2CbixMGDl3ynk+/rqQ718cUYZT5E/QzFX0YvvKNI9MG1xRIGakQMIlsgPpYI7XJH5F
	XaFpbXbYwqbpn0hZFvj0bbCnQJsI49cUG+itWo0ClLBaB9yEzfMfSdbd5FOusKoAiIimy1q5tiP
	7+uqJ+z5hakWC6AVcgK21ZdFEdR4+FwK7wKDYr55WhUzILkf3JrXo=
X-Google-Smtp-Source: AGHT+IFINos5ANaGYcgFtUYkq5WlLP4oVoAKIpDU6+DIih2zYDOnM3Vr4FolOBEF1w7JoKVEdzzFNQ==
X-Received: by 2002:a05:600c:4e88:b0:477:54cd:2021 with SMTP id 5b1f17b1804b1-4775cdad736mr25743725e9.8.1762346880061;
        Wed, 05 Nov 2025 04:48:00 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4775fba5311sm25758435e9.13.2025.11.05.04.47.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Nov 2025 04:47:59 -0800 (PST)
Message-ID: <891f4413-9556-4f0d-87e2-6b452b08a83f@gmail.com>
Date: Wed, 5 Nov 2025 12:47:58 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] io_uring: add IORING_OP_BPF for extending io_uring
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
Cc: Caleb Sander Mateos <csander@purestorage.com>,
 Akilesh Kailash <akailash@google.com>, bpf@vger.kernel.org,
 Alexei Starovoitov <ast@kernel.org>
References: <20251104162123.1086035-1-ming.lei@redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20251104162123.1086035-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/25 16:21, Ming Lei wrote:
> Hello,
> 
> Add IORING_OP_BPF for extending io_uring operations, follows typical cases:

BPF requests were tried long time ago and it wasn't great. Performance
for short BPF programs is not great because of io_uring request handling
overhead. And flexibility was severely lacking, so even simple use cases
were looking pretty ugly, internally, and for BPF writers as well.

I'm not so sure about your criteria, but my requirement was to at least
being able to reuse all io_uring IO handling, i.e. submitting requests,
and to wait/process completions, otherwise a lot of opportunities are
wasted. My approach from a few months back [1] controlling requests from
the outside was looking much better. At least it covered a bunch of needs
without extra changes. I was just wiring up io_uring changes I wanted
to make BPF writer lifes easier. Let me resend the bpf series with it.

It makes me wonder if they are complementary, but I'm not sure what
your use cases are and what capabilities it might need.

[1] https://lore.kernel.org/io-uring/cover.1749214572.git.asml.silence@gmail.com/

-- 
Pavel Begunkov


