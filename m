Return-Path: <io-uring+bounces-6486-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EF8DA38552
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2025 15:03:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 348897A3EFE
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2025 14:02:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B19721CC6E;
	Mon, 17 Feb 2025 14:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kOoRZU5Y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40C321CC60
	for <io-uring@vger.kernel.org>; Mon, 17 Feb 2025 14:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739800956; cv=none; b=QlbwcV1m5exDorGqLktytf6h55ZQ98Vt/pr8WcKPjSA068WeBz9vmJuVxuw4IHHS6cxiKGoQfmC4Way8Ns9KupVFq4wKiZ3GteM6nfV4EOjs0ClFDS4LeQLYNmHt+BkrEnWchI4InaQBL96JCsNBeUkotjz+u064Z6DPZ0avm3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739800956; c=relaxed/simple;
	bh=pM01BONmxIXxvXJd5W3m+2dFTpzWJtJvj+Q1o/3kxYA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=csQ9MCw1gYHK2tunrwNHvvg3qXhdUvmmTzB+P/7sLt5lWa5Xz8lMS1DiL9tqg2KsWN49etTHH3GOg5CybP4gwxWXlxUJEaDnMsZf/128fmld0UPHTb0atXdxh0TUrtOnLGipzcWZAzYZBpQ2jXU3oTdxp/p1U9rh518tptP1fLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kOoRZU5Y; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4393dc02b78so29051285e9.3
        for <io-uring@vger.kernel.org>; Mon, 17 Feb 2025 06:02:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739800953; x=1740405753; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oayT0ft42O6vaeyMgZTbcMTZK4Idr0fN0yRGiQhVfJc=;
        b=kOoRZU5YMzLvUr/XwcNv0YU9X/r6/Q30RqXztZsoVkFx7P292qzOl+MJdAO6r1wHkE
         M3xqU2iIQtcg76H8PttQ3SmvFm5BLX4dHfZBeR8zp3w36sHt6+x7q7S+VNX4l8ACjYdc
         0ZhCBjDo3fxohjMumdJTkbuwoubkefBnnv9cTPES/1i6WYso6sVD0/2uu5ZWRQ1e9kPq
         s0gbpf81fO1dVUfu4KCqNPYPqPgxpqGFr5iG+OVIRlmZxa4gIhuNJPzc1rKavvvJzg7M
         xzRSARm+yV2cGBDb3xkNLQ4DQE3Hsha59nxvEwX/4lcugt9O4+XQvTdwCc9uZim++rLa
         x+kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739800953; x=1740405753;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oayT0ft42O6vaeyMgZTbcMTZK4Idr0fN0yRGiQhVfJc=;
        b=RrjUVmYEHY+R3Nbx24ZGQd/g7D04aiI4fILkOwUyUFkThf/l8QmQiJgF0SvPi6UPxK
         w5WJujRn8mVnQt4LLM6MJWyiaYNNn4kjg5vn5sKPk3SLNNSfMGLPnP3rlFNYLOUG48N3
         CFlJ1EzZgJgm251BKbWK9X15c7DQ3FlyoGmlJSBGXIsYGDimeitT0QX3whkS6nb3XZau
         iAuiYtZlSK9QrlYj0jK4C9buQZCHnTnx7qogA8ouLZHAenGKGS1Yd7vaazUmNWNndWpN
         VDbizmRJL2TPIzxSH/gw0wSwh8LM7uMPK1l0E29zsAbDDP18WklO3CGdpqWO+Ps1NKDt
         tJ9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWu00nDvjlDD7M+c3JYgaQ85HHzjKSpTLGUjqyn7nIiP5ucG7UeAeWVcf/1Z+dHd2eFMQMV45X1Nw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwgxkKb/UPHoNMyJ1bmzR6z24gXfeNMCE9Upm5X9ZuCKFqvzcZP
	DjbksQ0pWBnfMw/0zQA5SD6aLQfCb7n3k1vg2RhN20Jp0De4yfH8aCFm3A==
X-Gm-Gg: ASbGncuCGJU38c3H2yiVO5shThXkYDQ88Bm+8D9l/VjdHKPp3oTMO5mlLxMaBjeR83w
	QDbNBA9HjnYkgTMOvLfm9jxluMibawlnZBiFsp35NTC70dKzUN/PIF1HXq3rj8/0/QNXt5dAlNI
	DGV3YodcHmrKQ8TpJ+KjKHiC/WgbFv0XAPf/nfob6SQCP0BY104xB+OrE6B7mN9JsvlUBxZsm40
	rNEtI6a2rhHlt1eHZ35ZssICmn6cYRzA2iHQ5HFvArNDrcPjGRWaAee/OSmy5OqQ+1SQ+WJG5RE
	7rF8u0POqJ8QUmCu1PaSNUwo
X-Google-Smtp-Source: AGHT+IEp0Zc+9CiGHyCyhPFgIowJ98L4mLD2e8k1aUTRmBRueUGY1fvwq5h1/658Mc5O8xd8aF9yoQ==
X-Received: by 2002:a05:600c:5110:b0:439:5ea4:c1e8 with SMTP id 5b1f17b1804b1-4396e762833mr80499735e9.26.1739800952931;
        Mon, 17 Feb 2025 06:02:32 -0800 (PST)
Received: from [192.168.8.100] ([185.69.145.170])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4398872fa85sm20109745e9.28.2025.02.17.06.02.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2025 06:02:32 -0800 (PST)
Message-ID: <c4f31fa4-25b8-4efb-80ef-3ffe85c4c421@gmail.com>
Date: Mon, 17 Feb 2025 14:03:27 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/rw: forbid multishot async reads
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <49f065f7b88b7a67190ce65919e7c93c04b3a74b.1739799395.git.asml.silence@gmail.com>
 <cd42f912-df8a-4c9d-a891-1c127f6b6fa0@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cd42f912-df8a-4c9d-a891-1c127f6b6fa0@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/17/25 13:58, Jens Axboe wrote:
> On 2/17/25 6:37 AM, Pavel Begunkov wrote:
>> At the moment we can't sanely handle queuing an async request from a
>> multishot context, so disable them. It shouldn't matter as pollable
>> files / socekts don't normally do async.
> 
> Having something pollable that can return -EIOCBQUEUED is odd, but
> that's just a side comment.

[off list]

It is, but in short alg sockets do that. See
struct msghdr::msg_iocb

-- 
Pavel Begunkov


