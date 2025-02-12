Return-Path: <io-uring+bounces-6384-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 545F3A3311B
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 21:55:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF7AE3A0591
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 20:55:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF589202C32;
	Wed, 12 Feb 2025 20:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lVaEr9d9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ADCE201018
	for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 20:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739393736; cv=none; b=kt1KXHFJJisSgFmK2J6jK7MRyoMcI11Z5/ZDt42M9m+88lFFdQkuT1xN8783cfLPzpAmXz6wK7TD/JzNhdDX9QIoURbnZ/W1/BHq59ePz5F8S56pqGP2s/Z+rsenZmWdCvkgNGtD5anXKeT5UhKwDGv7YkccDWr9hfirpYqKltg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739393736; c=relaxed/simple;
	bh=2o3QGSMnn9KoP+JGW2SAdlvf0wc5OFHnSmt2NZVxrok=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lGbqZ9HcOCTUMjJP67bnInKIieCxwBCGLpWjVIgh8sqx8qMJahj62XP20qEEvsb2ZMcb2ByY4h/IuN7CYrvuGJR3teJvlJhtA7GntxwsmhuB2he2JKn+S20lV+KGhiohiipKmvv8YJfpAIt9j3vyKrUUSB4cXKFXAnwEWmEJkQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lVaEr9d9; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-855353491d7so4116539f.3
        for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 12:55:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739393733; x=1739998533; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Lce4h5D4y3dkkSOsbDsIgPhE4jOnyOIj0fgtuUeyuNo=;
        b=lVaEr9d9nmaTsUt6Zwt6kU7vePcs0YfmHYOZ2BrnevYkaDmLK5Co4HN3TqYUWPmURs
         m+CJioGVS1gM0GY8ipXFE1FOPFFZnrZKmxzCFm7SfOHPtmMFvmNTwLG89h1hStY6UOdk
         yfvdQq3+2KBspcvnkTkKwUlXdOY0dFlHlyj5SL7Ar5xVk7A9H6+k56f8og3sJL99yoDJ
         JgcJtTGxlrM09MKgWHxa/gav3OAaBSsb+Tw0N7pfSuLYZ8ji8d9UdtCLjxTnduR/yvxe
         dtUZXbqdEOOX9PPxakwxbnEWAeHD53Bt2n79Ipt3UrCB5z1l8gRdTUoQZWNjebGBlXIC
         PUcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739393733; x=1739998533;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Lce4h5D4y3dkkSOsbDsIgPhE4jOnyOIj0fgtuUeyuNo=;
        b=iteN3ZohDCc2H0OaZRAjHIQP9k2bVzNj/LH8WtAtdC+SisJIDEGD8V1eNuYdHFxMM7
         kyxnfTK+BmMUegXbIVUi01ydPMIzph2loUBDBTWvmVT1xNG0bV+T8a+9pXwci6nU+vK5
         0uoYcaTN64AjoHr9ReyeCMP0Ns91FrJeihg+oLpm1BQ3NeIxouSpeLwfmzONXQ1y16f0
         8rMMkQNoXeSRskVWul4xb6ZtWWpIURcMf2F4+4AqQqnrXPzeWarijIM40bwtLa4H4pXC
         q0I9Y5HNwKDxAqsWK1J06hgug/C9WAI16HSdW1uwyPHp5vAq3+eJkG0aoutE53k7mXyy
         FyoA==
X-Forwarded-Encrypted: i=1; AJvYcCViUWcwfsqB6T5hK1PNWL+Z9NTwQX4ZYPLGH/dbM94d11M+7uhsiUfguUYEvuCCanSXSjaShzDMSA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxRQtglg24KFgEOl+1H7iBrvWHpj5hG0QBk3yO50MqJuWl2sCTg
	dw8yauyb+iO9027+5STkbaVWnJT/KxeuDHJI6xC/famNbzxmFVUcU8jSEin1cso=
X-Gm-Gg: ASbGnctug5EG+ekGto3cUsidZo+wkiUbSOGt+61RgFyasCmUAfqxRQv8iZEAInNPqTM
	96a4GlSxUCYvTIK1u4N6TcXUXLoddbIRSNPguNmXp/JqKVnk4Fd+DhVv27pL/NMAmyImXm68Wbi
	V6LDo1zmtyaMHfTqio/w2eUNDWidUXYs9pRpewpPV9u494pS0kkhBuoNM3j77KpuPZU1KTksY6J
	zMZ8MjmBBprNNlK39D0dft2QRbrWuH5FcCj+lx1p6cukkMkA+ZyISTOHbiPPkOzbaTuGvp/tFPn
	beLu2nhPkic=
X-Google-Smtp-Source: AGHT+IFaY8jGH3EslPee3G+hP0DMmS4KwaHd8nPoClS1FeEEIH/53mdygz/+qHxdAu2XV9D8c/hYZg==
X-Received: by 2002:a05:6602:2dc9:b0:855:371a:ca6b with SMTP id ca18e2360f4ac-85555de1c72mr490314939f.12.1739393733147;
        Wed, 12 Feb 2025 12:55:33 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-854f653d2bfsm325947539f.0.2025.02.12.12.55.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2025 12:55:32 -0800 (PST)
Message-ID: <401f9f7a-b813-43b0-b97f-0165072e2758@kernel.dk>
Date: Wed, 12 Feb 2025 13:55:31 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] uring_cmd SQE corruptions
To: Caleb Sander Mateos <csander@purestorage.com>,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: Riley Thomasson <riley@purestorage.com>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250212204546.3751645-1-csander@purestorage.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250212204546.3751645-1-csander@purestorage.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/12/25 1:45 PM, Caleb Sander Mateos wrote:
> In our application issuing NVMe passthru commands, we have observed
> nvme_uring_cmd fields being corrupted between when userspace initializes
> the io_uring SQE and when nvme_uring_cmd_io() processes it.
> 
> We hypothesized that the uring_cmd's were executing asynchronously after
> the io_uring_enter() syscall returned, yet were still reading the SQE in
> the userspace-mapped SQ. Since io_uring_enter() had already incremented
> the SQ head index, userspace reused the SQ slot for a new SQE once the
> SQ wrapped around to it.
> 
> We confirmed this hypothesis by "poisoning" all SQEs up to the SQ head
> index in userspace upon return from io_uring_enter(). By overwriting the
> nvme_uring_cmd nsid field with a known garbage value, we were able to
> trigger the err message in nvme_validate_passthru_nsid(), which logged
> the garbage nsid value.
> 
> The issue is caused by commit 5eff57fa9f3a ("io_uring/uring_cmd: defer
> SQE copying until it's needed"). With this commit reverted, the poisoned
> values in the SQEs are no longer seen by nvme_uring_cmd_io().
> 
> Prior to the commit, each uring_cmd SQE was unconditionally memcpy()ed
> to async_data at prep time. The commit moved this memcpy() to 2 cases
> when the request goes async:
> - If REQ_F_FORCE_ASYNC is set to force the initial issue to go async
> - If ->uring_cmd() returns -EAGAIN in the initial non-blocking issue
> 
> This patch set fixes a bug in the EAGAIN case where the uring_cmd's sqe
> pointer is not updated to point to async_data after the memcpy(),
> as it correctly is in the REQ_F_FORCE_ASYNC case.
> 
> However, uring_cmd's can be issued async in other cases not enumerated
> by 5eff57fa9f3a, also leading to SQE corruption. These include requests
> besides the first in a linked chain, which are only issued once prior
> requests complete. Requests waiting for a drain to complete would also
> be initially issued async.
> 
> While it's probably possible for io_uring_cmd_prep_setup() to check for
> each of these cases and avoid deferring the SQE memcpy(), we feel it
> might be safer to revert 5eff57fa9f3a to avoid the corruption risk.
> As discussed recently in regard to the ublk zero-copy patches[1], new
> async paths added in the future could break these delicate assumptions.

I don't think it's particularly delicate - did you manage to catch the
case queueing a request for async execution where the sqe wasn't already
copied? I did take a quick look after our out-of-band conversation, and
the only missing bit I immediately spotted is using SQPOLL. But I don't
think you're using that, right? And in any case, lifetime of SQEs with
SQPOLL is the duration of the request anyway, so should not pose any
risk of overwriting SQEs. But I do think the code should copy for that
case too, just to avoid it being a harder-to-use thing than it should
be.

The two patches here look good, I'll go ahead with those. That'll give
us a bit of time to figure out where this missing copy is.

-- 
Jens Axboe

