Return-Path: <io-uring+bounces-12585-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oMYGLnPKrmnEIwIAu9opvQ
	(envelope-from <io-uring+bounces-12585-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 14:26:11 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C83D239B67
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 14:26:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 95E673044BB9
	for <lists+io-uring@lfdr.de>; Mon,  9 Mar 2026 13:21:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADEB23BFE35;
	Mon,  9 Mar 2026 13:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XqeyIaTW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1B23A4F50
	for <io-uring@vger.kernel.org>; Mon,  9 Mar 2026 13:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773062469; cv=none; b=ROGjx/25V+3MScwYcZNYuj+r8PWod8JyLpZtFFG4Xhxm6Nr6wThFSgrsB3sAFfL0zljBRhfkjRbojhcNp4Vs3yaDTlhPyMx/FSwHBg5ON7Vo/Kpipg71Rcz6Bpez9FEFd1VX54sWqyEep8MLuTJHj6WsqfgDtiKSQb7P+LuOeGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773062469; c=relaxed/simple;
	bh=81XGVobUmnUJDacDr2CmGJ5yqFeXBDhN9BGZnLGMOVM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L+FBPbKsggNKKPHAUe2qAaV1t3Srp0PoPutBP9Qn+c5dityjAJO6CVqa5T74SbEosMACTdi8REybgmZzusyszwI6O6GNPuwnr7sPCfFS+cVkVkyhaKMNpOvV8z75zq9tDNdYyGX54bTYZ35sFPoNJNkB/4rYjh9qhXAuhVw+e7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XqeyIaTW; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-439aeed8a5bso9017838f8f.3
        for <io-uring@vger.kernel.org>; Mon, 09 Mar 2026 06:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773062465; x=1773667265; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sF/1iifeFK7cK5xCcFF5Ins/Q/lIdp7OZYqz5HTiA8k=;
        b=XqeyIaTWI8Mgy3aQodJ6o4QewSAbHFsEug4+dhvrZilu8NHUWF5q35IhwFHau2CG3X
         78vxfh4PkHnfmvDqYuUwiawga1rtGgItS0XBek6ZwgTyRj2ZoRiMgYN6PV5xO8HMBmS6
         NdigqzfnQcrh8NFeMzoLuFfHyq2CyWmgTETNcxUgTuON+30xQF1BDEV+aTYJK9LW1cIf
         E3SiNU46tLzuQ/BPK9qp2v+LGfNUuNLQnxuVrfIGns+5kQBzkBsoQ+iHgj2i5cQBL6cv
         Nt7QH9zKh+svvlh+I8c55SD15x0Jfi319Ix06gNRKzJEwyq0R8HFu23v7d70lTPTiSlB
         35lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773062465; x=1773667265;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sF/1iifeFK7cK5xCcFF5Ins/Q/lIdp7OZYqz5HTiA8k=;
        b=Tyq52DVAQgAAo3YHfo/dyoWjByfubo68WM2WhIlbkK29cdStGoitQ+8AByIMx/e1h2
         kEbaWlIYqdGktdXSmAgIB8FxQxWEKM3Pg+UcRTjujtN/c6H1xSWU4jy+tRKEFFoieYM3
         kklw+l1kFAQTT9weVRZ0yREoz0zCiNHM0Mk/Ivveb1XeL0GQ+JWawWnuwCwztZPdmE6Y
         5qmOI3DBSQtLIxm07/XREsBZrJWfMBX/0w4Cly1+Lx06EhbbsYzoUa2bxZI42qDE/CIE
         uTYdlLTsUoJTxrdtGWdBkguVf34bDqr77sngrUf7aUUnH/jCg71+sO8FEkVQ62YyillH
         JwHA==
X-Forwarded-Encrypted: i=1; AJvYcCUClLIChkJEX28AIHVaEX1TMN/W0e6Q+Bfpse0ZAOClbpa8B6skrqLVESb0AkLwxETfydA35QNeDQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8DHmA4Rr9RQzkHCiXC7v/YgdHoqJRP673ul0XfuJ1mTHMFJsE
	PIgscGfjl/HFb2Cvkh7FTD5ZgUZ9yvJjtXzBt3pxRL1E5FB30B/Pxq/j
X-Gm-Gg: ATEYQzzD7e1KP/UpMpMktV73itfuefodq8EfP68Ow91B6xC3GbjsVsWeMnbQ+UalUvc
	dO2QSTFVwLbxfr12zSlYFYUe0QfZQsikPQ9fZl7cdLhH/vl2eJYmJmZS2wLOB5zwiw+dABCSYLC
	NL7HLXo5GpqFxusAyi92JQSHkgdUkXquDD7EL15A//5tZi61zU9m3wfKI1vYlaIskixGZaALNd9
	syGD+fvqOtmWUEs9S++A3sHLLaHmsQp3W/cJdHDK2iPoTavUaDTJtzXh5bNnJAflth1lT8B2kb1
	DNLvEqvLSXUR2tfiGnEjRxQb7s5fSE4GbWktwLVOs7Ctw/QrjClcnlKufYcqbjM4XbRiNsyle1h
	uTt/MsuH+Rb426YZP8gWhHTQmCZGHTf3ZYEHPTwZaIL64PSckY7Lm0NoPaCcUiEEwCmLn8hKMKF
	6LIidt7pu/ZajSL/OwKZs5ApzntsxwuwadBl+bYCxON0sOoaFTIblN4goy1jBTf5hJFYsNwntzL
	BvxvEWi0Aq8VcnmNzFYjGVYbT6yjjvkTN5dnbzyVkQLS5TXBtZSCoSs+SepxoU5weTybBltggd8
	pw==
X-Received: by 2002:a05:6000:2383:b0:439:b736:bd0e with SMTP id ffacd0b85a97d-439da891b21mr20839210f8f.44.1773062464939;
        Mon, 09 Mar 2026 06:21:04 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439dae3c80esm23789904f8f.29.2026.03.09.06.21.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2026 06:21:04 -0700 (PDT)
Message-ID: <218c175c-680c-4ee2-9e00-c81202e4841b@gmail.com>
Date: Mon, 9 Mar 2026 13:21:03 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/zctx: separate notification user_data
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: Dylan Yudaken <dyudaken@gmail.com>
References: <d099d8d0d7526e4eb59f5ffd0e890888a46b21f7.1771242479.git.asml.silence@gmail.com>
 <025de231-a6d2-4fa8-91e5-f4ab81d16e7f@kernel.dk>
 <5fa237b6-420d-413a-b7b5-9f85d9f1e8ba@gmail.com>
 <64ab6b3e-3746-4076-9c0b-b2edc2de92d1@kernel.dk>
 <69a2d3ce-5c77-44f9-99be-1b558cf4c4ca@gmail.com>
 <fc217246-2397-4ae4-8354-7ed0c498d23c@kernel.dk>
 <e59d8887-d908-463b-ad31-3bf10d977de4@gmail.com>
 <133c27e8-7b5f-4754-9f8a-17d96e736621@kernel.dk>
 <3888d916-259b-4d1f-96c2-157c289d867e@gmail.com>
 <fd6ac244-40ee-48e1-b41b-d4d78839fe72@kernel.dk>
 <5eeb233d-74e4-453c-ad18-f30382dc44e7@gmail.com>
 <56a3e17b-8ad1-4623-bc8c-e8f4e9f4e265@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <56a3e17b-8ad1-4623-bc8c-e8f4e9f4e265@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1C83D239B67
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12585-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	NEURAL_HAM(-0.00)[-0.962];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On 2/17/26 15:15, Jens Axboe wrote:
> On 2/17/26 8:03 AM, Pavel Begunkov wrote:
>> On 2/17/26 13:12, Jens Axboe wrote:
>>> On 2/17/26 4:15 AM, Pavel Begunkov wrote:
...
>>> The patch should just be removing that addr3 -EINVAL case, and adding
>>> the two lines that check IORING_SEND_ZC_NOTIF_USER_DATA, and if set, assign
>>> notif->cqe.user_data from addr3.
>>>
>>> But I object to saying this is a "degraded" uapi, to me it's very much a
>>> better one as it allows all values of user_data, rather than have some
>>> magic 0 value that's not valid for no other reason than force policy.
>>
>> Well, we clearly disagree on that one.
> 
> In the spirit of making progress and not wasting anymore time on this
> fairly fruitless discussion, I'm fine with adding the else branch, and
> hence v2 as-is.

Looks like it got lost / forgotten? I can't find it in for-next

-- 
Pavel Begunkov


