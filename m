Return-Path: <io-uring+bounces-4394-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E31399BABA1
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 04:58:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A837D281B02
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 03:58:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF57F165F04;
	Mon,  4 Nov 2024 03:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IVEOTMWX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A821FC3
	for <io-uring@vger.kernel.org>; Mon,  4 Nov 2024 03:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730692687; cv=none; b=EF2PHUzBoK9R4lA8U/ZYP/ndTPXdNCCk0SCezC6vYF2GFFRUGXdV1NatBO2Ya+lXTTb7lFk0afYva7stZkh9d8G/vS1sL3vug/NZYowJDXM6uRG+SP0OglJOdj1nI2XsN5LEFZHFURkfnfrIn6HdNWumexjoo1CMScmiKz/Z6d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730692687; c=relaxed/simple;
	bh=q25Hza0Pz4DUqCkWtCwr4OLdFYNTtghLvEUjXzRB3zI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k9rygaEhJlGF7nnf2hIuir7Xm3ehrOapWg7vUsAIoKOA3wZCtL0Ss+3YTof423L1NbeXRrTdJPlGCIi/wkh/DfDzU4v7rw0KNJGkzqKKqAUUFjduGQDDpTJm6YKTIlggC0yzLPD+XHzfjv47jmEjQD3upUFKDV3f7wkxeGUJZ+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IVEOTMWX; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2e3686088c3so2728531a91.0
        for <io-uring@vger.kernel.org>; Sun, 03 Nov 2024 19:58:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730692685; x=1731297485; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WoESZVK667Hgfz//e+LiXCa10g6dyuneuQQKs0aNPT0=;
        b=IVEOTMWXn9JpmmmrExWJdxw0MloKq+4d4xImcytkY5SdFqElBM0ds7i7NOBtRLapxd
         TCB83tqo8AXamZ4ouOamhduTzmcRH/JmwEsiNTWEW2J17ohXJ44OlMvFE0oTCblyncL4
         xVf15ddSNDgfPLFmOWfBwvTwxbw826wmqPt7EWwWbbPyTRWkXlv5LZD5mWwDa97D/Lc0
         +JUm1ICywAdIQbB6yrcdHHz0aAiCd5tWo8F8zTmNCSQvOzJCw11FQs+Y88MNaCo8POFH
         E1mfYu1Kh1XQ4u8+o+mtBUbCwj47aWz3FOV8MKzZEa4rH6r/1jlG9JjYJLw19KBTyuDn
         YHqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730692685; x=1731297485;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WoESZVK667Hgfz//e+LiXCa10g6dyuneuQQKs0aNPT0=;
        b=pRdUfu1x1EMie3u8PYTkQCKCoG3i5a5BGk0UlhiMGSBAEn1lnf2nYud53lFnx641Nr
         VGh9MlbD8W9WK74nrCZ1IYswjq6XlcZ/R/o847C62er3dTFLD1UvXWaDMXWSQjBmQT0K
         chMMi5cluTVJJTj+5RUudHymtX6hVy9tZgsTbhITwcPxkldeE7E2gPeat9K7NLwDl/Gq
         e3ad5D4b5Tn8LvoEUg23r94JfwQuOCF1TjDu8KcFTfEd1ARSaUWZrgR970pbXdUbiMkg
         ntIu6YtcZlsbB8iD6QCuIoyFU3oAHuXYEtnkgEt+5jcbzu3ER89GqZ7Zc4mflVJ9sfpy
         CK7A==
X-Forwarded-Encrypted: i=1; AJvYcCUbuEZWfREgNqrY4aQRIlqBOI3RsYo5MPsn7d1sjo5hXI0aqErkSPzNFVyL6dUzB0PQiquuUqmFiQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywf1ZmLnqAwAq2ZRjxShLOgQA2vYz4eOc5BjCVAdTv/G8Qd6dmy
	5Mmsvt3HUsXdi1n2FQaa6pU8YXQItqZ2WY4z3kryMuy8yqZYWGq3c45FYcEioQ8=
X-Google-Smtp-Source: AGHT+IHSzlEn4SnUyAwromaWjOCJLe72lJZnCD+/VbW83o1zZNEuNWD2zS2KN2CM0oZvxNE5X2tJxA==
X-Received: by 2002:a17:90b:4a8c:b0:2e2:acd7:1df0 with SMTP id 98e67ed59e1d1-2e92cf85afamr18367601a91.41.1730692684736;
        Sun, 03 Nov 2024 19:58:04 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e93db183cdsm6479729a91.40.2024.11.03.19.58.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Nov 2024 19:58:04 -0800 (PST)
Message-ID: <1a89b102-19e3-4384-a871-a75bdad32e82@kernel.dk>
Date: Sun, 3 Nov 2024 20:58:02 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rsrc: fix null ptr dereference in
 io_sqe_buffer_register
To: Daniel Yang <danielyangkang@gmail.com>,
 Pavel Begunkov <asml.silence@gmail.com>,
 "open list:IO_URING" <io-uring@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>
Cc: syzbot+05c0f12a4d43d656817e@syzkaller.appspotmail.com
References: <20241104035105.192960-1-danielyangkang@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241104035105.192960-1-danielyangkang@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/3/24 8:51 PM, Daniel Yang wrote:
> The call stack io_sqe_buffer_register -> io_buffer_account_pin ->
> headpage_already_acct results in a null ptr dereference in the for loop.
> There is no guarantee that ctx->buf_table.nodes[i] is an allocated node
> so add a check if null before dereferencing.

Assuming this is an older tree, it's fixed in the current tree.

-- 
Jens Axboe


