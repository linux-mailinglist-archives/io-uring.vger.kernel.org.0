Return-Path: <io-uring+bounces-12729-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OAgPKdiguWmiLQIAu9opvQ
	(envelope-from <io-uring+bounces-12729-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 19:43:36 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 029FE2B10E6
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 19:43:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7012F303EC19
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 18:42:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7ADF37F743;
	Tue, 17 Mar 2026 18:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lwjVQuL1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98912DF152
	for <io-uring@vger.kernel.org>; Tue, 17 Mar 2026 18:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773772975; cv=none; b=D3MWsik/cJQYnqf/+ZxSdf3tFXJhW1H4yZ0khKj7nn/sf4i0BDDWy32um0QR3n25zkk2Enk6KM1jzvzCtv4uPnXE035ZnZ7NqKy9OyZhBDxIJ6xWKQvK6u37p8Q9YP8Y6bT3qdJpt3TR/o1lugXRuiXPhwxUNbBKsMZ2Yx2OTHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773772975; c=relaxed/simple;
	bh=vuZKLDxqBFPHOwBMSb6dIg9nJKz/8Sz/2ZCZztek6W0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sRLOLkgcinfgVDKwblRkWxEdbQkav2Ihrpy4BSJQ9hLi1yv8Si6s8evEbJtAK3jvGsOvX/BAqi7XZ3ODqnfb/FBDNZmTy6NlnwbL9FwTvEjmtkasxOOlB7pluhTK960efD91anzvA6XgTCJF7ZTEmtZBBoMO+LMQDerpqG7b/bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lwjVQuL1; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7d756f2a06dso174911a34.1
        for <io-uring@vger.kernel.org>; Tue, 17 Mar 2026 11:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773772973; x=1774377773; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VDhYwrTGLAoRlvUnQ95Ghz5L7nDG69xmWdR3NUj8PJM=;
        b=lwjVQuL1ZQ/z96ajzXL0pDo1PTbMyMGMuLmIjV7aSquUY6r23VH9YErDYzks+N+yU7
         SebsfbINfHm4NWnKMnGZcf+P3b4A3kE8Rv4gA4QlvCmZN3pQQilH4JvLKgO7oLkhPadP
         83WqeyNHSQ3/MkrXXbP2XhnBAMobf5IUdhe3f+VuxKtmKpbV76NiSfy74+WT+4boWvbd
         wlfrsTYaTDzGYHgO379GDe0cH5i0IdLU2lYaS9oQPqZa2YOK6W8eMUAQVIC6Kf7L8n2g
         +aBt33sm9lkl27zwYL/lzNtAnYhcdeEPsYV64yvtEHoyKRME8c1a9BsM/vTAjQRUadj5
         egBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773772973; x=1774377773;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VDhYwrTGLAoRlvUnQ95Ghz5L7nDG69xmWdR3NUj8PJM=;
        b=scvrCYSe7xGah/mxNDU1ZhYteDHtJLNiaLCGPYTbp1ydp2CrRnBj55EexcUGvyJC+8
         V17dnbIq50pqf6MgJ8+Tjg2I0XjC35AwwCgUptrAATjlx7nnfXfAFuIW7TWhyFIirn73
         lOuPizlf2vD2nqXI/Z1d/evogiKS7Vp5Z2GLkQGfF9LO19PLji6grQCWDMHzvRpwjPs8
         Lc+uuyaLeU+9czkFGIVwnB7AARH8wPl1hCtJJj0Zsb7DZuU69Ds303cXTArQzfN2Y3n9
         05VUFm+0+SHXglAdIbnC0HDoBqtccCQJD+mAOg3eQNyWHcBSbewZdcO5hNdCkW3veg+U
         Sn0g==
X-Forwarded-Encrypted: i=1; AJvYcCW66bJgE+gSQkeFk7wBL5Iov6Lx+eogQSXt8xe6/3V/Pe4TdCJDXZtDmOJrGxjCKhCYr1i1y7iuHw==@vger.kernel.org
X-Gm-Message-State: AOJu0YysO3QmhvagjwMKwZLeKaKJT329TkpaXz8z5Y43RVlw6IgDbinX
	ghOwh6pV1ahdj5umpVgN4Lrod1V4I1gSl6egxalyLhu32xLZzl6eR/u/okz3+BWRZ9o=
X-Gm-Gg: ATEYQzzX7Iu33ByDB6IFsE8BsQJFK42U5/I06ceRDZpCi5zribFU+GR5FnCirENgtiN
	B16fLnHZ5Zcy3bvmYz1ToRloxtEJRd+d/fqbBoZRuvfkAnmfEQiMuDKMnupIB3NdIF1vuLVqBgL
	oyiyfKjzClMfuY8njde8dlJuzfq7mgbsj8K+Ph1pVF1/8DyhQoJV72xQYMGlAmgR/9ZY1Eecubq
	dNfiXbCOTjqGTP84vs6FcXNS7uneVAhYH3n1h8dKv8yeKcj6evcEVoEmoGtORYZqhNxltOuQrJU
	tgJR3MERVTivcT9H2UUptme2Vq6DlenHVMBlh2gBTwZWMBwAQPPKEIMVxLvr/J2ox2ZD9edVD69
	gUVi526wAfpp69IdtnV9An6hGiqPyseoCjiX88meL1bR+KmR77wTfLJl+EG1pDQoxorOXarwuuG
	bVqvzMcm0A1+XoxTe3kokAZmAh/aE956EEJRJQkTyMKHLqFqSOZY6YhHYZvPXF1JeN1M+15g6bg
	MVcsLXL
X-Received: by 2002:a05:6830:83bb:b0:7d1:9066:26b7 with SMTP id 46e09a7af769-7d7c96871e9mr535347a34.6.1773772972814;
        Tue, 17 Mar 2026 11:42:52 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d7c9951092sm365089a34.1.2026.03.17.11.42.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Mar 2026 11:42:52 -0700 (PDT)
Message-ID: <39373749-0c58-43df-89d8-b74adfdaea63@kernel.dk>
Date: Tue, 17 Mar 2026 12:42:51 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] io_uring/poll: fix multishot recv missing EOF on
 wakeup race
To: Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
Cc: Francis Brosseau <francis@malagauche.com>
References: <f39b5d6d-507c-4b2e-96e0-c5ba38aa2fe4@kernel.dk>
 <06a8b8a6-2cf0-4d1f-835f-06f4070402d9@gmail.com>
 <edcd0d75-6877-409d-8350-915349395a7c@kernel.dk>
 <1e05f8c5-0faa-491a-b62a-33fcf84b96c9@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1e05f8c5-0faa-491a-b62a-33fcf84b96c9@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-12729-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+]
X-Rspamd-Queue-Id: 029FE2B10E6
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/17/26 12:37 PM, Pavel Begunkov wrote:
> On 3/17/26 13:07, Jens Axboe wrote:
> ...
>> Right, as per my earlier emails, this is what introduced the issue for
>> AF_UNIX, when the INQ support was added. We read the whole thing, and
>> INQ is correctly returned as having 0 bytes left. Hence no retry
>> happens, and the EOF is missed. We could do something ala the below,
>> entirely untested, which would ensure we retry for that condition.
> 
> static int tcp_inq_hint(struct sock *sk)
> {
>     ...
>     if (inq == 0 && sock_flag(sk, SOCK_DONE))
>         inq = 1;
>     return inq;
> }
> 
> Assuming TCP doesn't work either, I guess I was curious whether it
> gets shutdown but the sock is !SOCK_DONE, or whether inq=1 is correct.
> Just thinking out loud, maybe I will check later.

Ah indeed, yes that's a good find. Let me test that real quick...
I feel like the AF_UNIX inq addition was somewhat half baked.

-- 
Jens Axboe


