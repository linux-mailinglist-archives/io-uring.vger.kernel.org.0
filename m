Return-Path: <io-uring+bounces-12082-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sOV0DokshmnkKAQAu9opvQ
	(envelope-from <io-uring+bounces-12082-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 06 Feb 2026 19:01:45 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AB99101926
	for <lists+io-uring@lfdr.de>; Fri, 06 Feb 2026 19:01:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7BB41301CFB8
	for <lists+io-uring@lfdr.de>; Fri,  6 Feb 2026 18:01:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5E72426D16;
	Fri,  6 Feb 2026 18:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nXH925yQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69163309DD2
	for <io-uring@vger.kernel.org>; Fri,  6 Feb 2026 18:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770400891; cv=none; b=WjWeJ0VzmlaGOGol0epO3d2boUA7M/hkJIA/HM62Uv758XGLuoTaekjES8iC2Q6E9xELeTB7zbMU5sR5Crc32tjjlqlGPsdqpN9ZsHiafBGHrJOXz8cLgVXg1n7DvbAvXX0j5Gd5Oh6wod6XQeA/L3/j0nAXkM8Y5v5SY5DYtEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770400891; c=relaxed/simple;
	bh=lSzknfIv//vW3XrZo3ZB5GwoTGxjRj4lI8kJmwNoH0g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VvLU6CKedZkC47JHDEI3sAAF8You2fTfIxjMtebdS81huBGCbyagV6JAJt7d/5EqI4hHLlmsCcXBhBbL1Y3JyFxamAfp4qlBvNLDdsGAYAkYqvpDSss7+g5EuNny/e4elE61kVkJwgO4mUzdzrSTwZ9kHsUAeBQrUfAOIHMRRpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nXH925yQ; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-48069a48629so22018245e9.0
        for <io-uring@vger.kernel.org>; Fri, 06 Feb 2026 10:01:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770400890; x=1771005690; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=chld7W3Rbl2PUp6cBiIbC1iT7uESUsO9DngY57S8hBw=;
        b=nXH925yQME2C/lv7xU3N2pyQIphEEpo2HaEr2mjExOB/V12/17synnPdfVx259zHFa
         s/OseDtCvCMxhdFsZLcZGyLFKeicyTGl9TNKK2V162hPxUPSZHxJvxdUWBxeC/uRPbZV
         ba34+SNbt/Tyv8GVhI7vlL39IXY+/iV9t0h1tjdxAzd5rIXvEQYsjGIB/YCOysu+iWg7
         Iu/7ambw7HtnGIKk40JQ/GMgK1cQalk+dr13K8cVTiJXvWpMR0GV5NdL01XtEFRO/VwC
         HQnhdy7a0ZGyIpNM5WWwzlA4q4iNp6c8P5xGdITM5xHOLCZj2YzbHJzegInrFimdGerZ
         mTLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770400890; x=1771005690;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=chld7W3Rbl2PUp6cBiIbC1iT7uESUsO9DngY57S8hBw=;
        b=IKWvK9lQkyD1V504qPCSUONjs3uvaFPo25dGJE00efcXQsLcfprj62/Kfk8rnlQeGf
         Gqt8nakHdTAdyQaOWBZqslfFP/f4R1J8eTx1W+f1DtRSJkyrjWiwwdk6XQ6lo/ZqQUoV
         sDbrYTgRTajkGaePbqzsubp+8wtPrELRReCCQgQ1ag+ix+fM53bfMwjnxqJ2o/aaM6fF
         v/YKA6wHDMkxw+/foU9wL6QWqJDaGfi8AzsgSSkNiQiQ1mBFF0651rBl6T1d+WDaNd2x
         GIrsyGJG2eXYU2GQQAh4D8iQHaTvrjUYEJZ9P0y1a7PQzC5pzb6/l515Wy4gfBZlHGiI
         b1nw==
X-Forwarded-Encrypted: i=1; AJvYcCWGZxtz1A0/q2Qwcm1lJCybTE1NYgoj0qKLfMtY7cAGemI9wK9ffzYHgZHoD5mwr1QLY5P0XX8tEw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwTQvqcEGId8e9UjIjCHy3IsjwS8yk4h6ezqVmQfkl6VrpZgJy3
	AAOTEZbbUTnnBVSC4jHlH0Mh7UpRxpQJ6xqmUzMJaBpQFnDF6mkfz/Da
X-Gm-Gg: AZuq6aKQ3txDYpp0ubZ7kHXOJhLk1sjC0nA1SPW+qDsBNL5RoK69ZtjAMc510j0hRdm
	j3KHWMDm5Qg7rcS4ZFBAqVdQyADNpeo8J5YomWe/X+D1bXcx9JgbkVZNO3MiOHFYqGIUOb+uYX9
	YDfGvYMAaCQtUmhR6gYDqJWfqZw+84IYQOgkawCo9siEwTFGi1+t16H75kRSIUX65fOaruBhw2+
	chRP2FIIXSFeRmTPJds8tI5qRrMptXCR+E/clDQprI9FTaVlTZNaawKGASN1cgV81Wmn1Fx1l93
	zOAHq/wosBRTgTKFRAD32xaUOaQEFNszelq6QcieLIbvsXAqzbRIYJPXEC427PNzjIFuARV68hW
	oeAKrK7ZjvC7sUlwY+8Wa7yRKsUECRIujYC6Q0JLsN5mGngMTHgaijq0v6y2T0KkucU7zyDnfDg
	zTFq0v162quhn46WlpgwvvMTlc56AqyEJ0DCtumgMEZ2dQoRk80i+13HdwfeE4x4zbNKvsMCNUv
	YCnAoy1f2rayk4mMOO8WS771xxbSHAxWKkm3ZIt7MFwfP3UNFPY1f+HS1MEKEc7lA==
X-Received: by 2002:a05:600c:628d:b0:47d:6856:9bd9 with SMTP id 5b1f17b1804b1-48320216d31mr49104765e9.23.1770400889507;
        Fri, 06 Feb 2026 10:01:29 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483203e126dsm51230805e9.2.2026.02.06.10.01.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Feb 2026 10:01:29 -0800 (PST)
Message-ID: <b0ec01bc-4cbd-431b-bcdd-084cc14553be@gmail.com>
Date: Fri, 6 Feb 2026 18:01:31 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 05/11] block: add infra to handle dmabuf tokens
To: Anuj gupta <anuj1072538@gmail.com>
Cc: linux-block@vger.kernel.org, io-uring@vger.kernel.org,
 Vishal Verma <vishal1.verma@intel.com>, tushar.gohad@intel.com,
 Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
References: <cover.1763725387.git.asml.silence@gmail.com>
 <51cddd97b31d80ec8842a88b9f3c9881419e8a7b.1763725387.git.asml.silence@gmail.com>
 <CACzX3AupFeAy0-pPsZ51ixd7qW++LYYjiKBZ3aK5Y2JDrB_JWw@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CACzX3AupFeAy0-pPsZ51ixd7qW++LYYjiKBZ3aK5Y2JDrB_JWw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12082-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCPT_COUNT_TWELVE(0.00)[20];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 8AB99101926
X-Rspamd-Action: no action

On 2/6/26 15:08, Anuj gupta wrote:
>> +
>> +       dma_fence_init(&fence->base, &blk_mq_dma_fence_ops, &fence->lock,
>> +                       token->fence_ctx, atomic_inc_return(&token->fence_seq));
>> +       spin_lock_init(&fence->lock);
> 
> nit lock should be initialized before handing its address to
> dma_fence_init()

Good catch, thanks, I'll apply that and other suggestions. And I still
need to address bits Christoph pointed out during review.

-- 
Pavel Begunkov


