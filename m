Return-Path: <io-uring+bounces-8670-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B277EB046E6
	for <lists+io-uring@lfdr.de>; Mon, 14 Jul 2025 19:51:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0931B1A66C7D
	for <lists+io-uring@lfdr.de>; Mon, 14 Jul 2025 17:51:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47A95246BBE;
	Mon, 14 Jul 2025 17:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="R8pI3HPW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10142F22
	for <io-uring@vger.kernel.org>; Mon, 14 Jul 2025 17:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752515481; cv=none; b=iHXAK723GGazdXkqS9haXD+PMlERbGHkxMMcneJuJv4sCVPAnJ7bbunZBUO+XyH+V/n7jG18KC8eIfzNdajhdhUdpbDNeJMTIS4UMFGTeG+7T75SVxjrHOVMSEJkmJyngWrwjNSanvAv4aYucUNMy+6No4exHMg1xQlMX0k9Q/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752515481; c=relaxed/simple;
	bh=78dq+YqDcSMJB+YQReeQoZNwoJ1EK2/ZmHVYzEnrbm0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nRluQ0dTipg0aqD2mTyqAfxPqEv/rd4NxVfRruzSMTokpQ/4tyK3fC6VhwMj0u4UAKfnj4NLOzn0xM/CMFiPFkOoFemsxglqaQZzKjMwQYyjhojFIXpgrhT68FaEqI2H4O2YVaaLYpz0eQK/dFy488YpS57CANQD5hxhicEsuUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=R8pI3HPW; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-8762a0866a3so101740239f.2
        for <io-uring@vger.kernel.org>; Mon, 14 Jul 2025 10:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752515478; x=1753120278; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oc2r5E7GTmR9F52O74qHnIA8pR84kogSt2wDVJPaq+c=;
        b=R8pI3HPW8yZnMyGe0CgqcgwATTExUWQnH//DXqI/6fDJm8fd6KxmVNY9xbA8BX73Y4
         GMCIhmkVQlp5OlxzilvagBuOon/kSSw91QlWfiR6ockpc4D4EoGgUNdkaDF+5L+VXDoT
         gvnzhKhydu7J6uvqAqEt/CoN+VR4NGjzqeFYtPT1yLGeU+aHpuhCiuThAiE4gD1b8jNY
         Ucmd+WhQW9ilSRHP02bq3iUEWWqKE7NRvAUACZ5m77c5Hm0T+5S1caezZbkHgcIkdvlk
         fdE3og3oGNsmfZnSFL/wmy9elWtcK3pBsrQADiOW6OGL0pDL5JtdWxuBZmixQkIlXXOd
         9Bug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752515478; x=1753120278;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oc2r5E7GTmR9F52O74qHnIA8pR84kogSt2wDVJPaq+c=;
        b=oeVt2v34eazHbROw+bRXKrRZQDTRB+/J+jjHNU5UbWbT23AWPZLafpiLDeWKTfJzsP
         vTl+D5fi/JUw34BiSuUvZLlnk7eAltpVFjSwD5ZXq+3r9KJebmbJ151uI+xCUv5+YnVA
         xIG0ixyhgclRNUKRwUQj0vYKRaYf6pC/4b+VpRVT9awZLi2qconzUVRP+pddNj0jCZyV
         scMbXIfZVU2aZ7wv4evaJdDsB+X62UHtvK/H0lXRwdyw28D+oJJsa7cVITF4dGTJ27//
         iMdbQrPDTtlgYgt2bWfdW0p8W9fBpNFVfqXT7QeXdduqjsyGh8VX5kDsGpcHwkwWbi3Z
         otuw==
X-Forwarded-Encrypted: i=1; AJvYcCWBhUKS4YBZKLLK0W7TwOyUJoU5QFweKV/+muDLGI/OidIGhDvJ5bDucxY8ilVyYgRBrKO1MPnIPg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxLzhRODRJv5TTcbor1WrTvG/m71kxcxA+yfIhIsKFK9TySjyFP
	inIbH7Vomp72W5rFWL7gY9pkRJFVrM/LqPTRNe50WfBHgvTuYlg2anRCsLpgk5va5Lg=
X-Gm-Gg: ASbGncuWKypoEu+5zIa1qLc8JJxwqDe1bKU1F5fagcBv6AG7Cftpv9rhhlirquiOIOd
	w06H3HLV5VHh3sYSyuEMK85DGVRIEoReUzi3xG2N7nMR2KiqOMp0D7cDtgQqwm/iUEe9pnkb6Jp
	qhZmFNfSwMKlGUqoGUffi4SMf+pJ+ZLyPR04QtYkUjQNyWPauulfV1K2nJ+wAPJPpQBdZjBjUaV
	f0mnMv7eI3N4D3xO6+ikdSE5eitIrKWnB9V2QrlofLaHCYdXzP48m5mwXHmd44dkK3mps+ClJ4n
	bZxEA9CaWWP+et8zTgO9YeItItH6jXaQ1zBS1CV+2oJB+VpG9TmRj/4xAzY2pJ0+gEtUq+/Gbh1
	NO8lIN0iSu5Tqj6mOrC4=
X-Google-Smtp-Source: AGHT+IE/2nBuobIAl03H/AKNcIxQR1Llv0WtxT+2ZbgkJArKJ4nB3rXzKO2bs3o+6EIwYWHy7jgxAA==
X-Received: by 2002:a05:6602:6417:b0:876:c5ff:24d4 with SMTP id ca18e2360f4ac-87977f78015mr1558131539f.4.1752515477577;
        Mon, 14 Jul 2025 10:51:17 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8796bc35d38sm263787139f.33.2025.07.14.10.51.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jul 2025 10:51:17 -0700 (PDT)
Message-ID: <7432e60c-c34d-4929-b665-432b6d410b5b@kernel.dk>
Date: Mon, 14 Jul 2025 11:51:15 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/poll: fix POLLERR handling
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: dw@davidwei.uk
References: <550b470aafd8d018e3e426d96ce10663da90ac45.1752443564.git.asml.silence@gmail.com>
 <62c40bff-f12e-456d-8d68-5cf5c696c743@kernel.dk>
 <dd1306f6-faae-4c90-bc1a-9f9639b102d6@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <dd1306f6-faae-4c90-bc1a-9f9639b102d6@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 7/14/25 9:30 AM, Pavel Begunkov wrote:
> On 7/14/25 15:56, Jens Axboe wrote:
>> On 7/14/25 4:59 AM, Pavel Begunkov wrote:
>>> 8c8492ca64e7 ("io_uring/net: don't retry connect operation on EPOLLERR")
>>> is a little dirty hack that
>>> 1) wrongfully assumes that POLLERR equals to a failed request, which
>>> breaks all POLLERR users, e.g. all error queue recv interfaces.
>>> 2) deviates the connection request behaviour from connect(2), and
>>> 3) racy and solved at a wrong level.
>>>
>>> Nothing can be done with 2) now, and 3) is beyond the scope of the
>>> patch. At least solve 1) by moving the hack out of generic poll handling
>>> into io_connect().
>>>
>>> Cc: stable@vger.kernel.org
>>> Fixes: 8c8492ca64e79 ("io_uring/net: don't retry connect operation on EPOLLERR")
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>   io_uring/net.c  | 4 +++-
>>>   io_uring/poll.c | 2 --
>>>   2 files changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/io_uring/net.c b/io_uring/net.c
>>> index 43a43522f406..e2213e4d9420 100644
>>> --- a/io_uring/net.c
>>> +++ b/io_uring/net.c
>>> @@ -1732,13 +1732,15 @@ int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>     int io_connect(struct io_kiocb *req, unsigned int issue_flags)
>>>   {
>>> +    struct poll_table_struct pt = { ._key = EPOLLERR };
>>>       struct io_connect *connect = io_kiocb_to_cmd(req, struct io_connect);
>>>       struct io_async_msghdr *io = req->async_data;
>>>       unsigned file_flags;
>>>       int ret;
>>>       bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
>>>   -    if (unlikely(req->flags & REQ_F_FAIL)) {
>>> +    ret = vfs_poll(req->file, &pt) & req->apoll_events;
>>> +    if (ret & EPOLLERR) {
>>>           ret = -ECONNRESET;
>>>           goto out;
>>
>> Is this req->apoll_events masking necessary or useful?
> 
> good point, shouldn't be here

Do you want to send a v2?

-- 
Jens Axboe


