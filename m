Return-Path: <io-uring+bounces-12692-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oGvSEvUQuGmIYgEAu9opvQ
	(envelope-from <io-uring+bounces-12692-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 15:17:25 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DD65D29B2B9
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 15:17:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A438530A1E12
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 14:11:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66493394498;
	Mon, 16 Mar 2026 14:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PDXXwunJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FA11D514E
	for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 14:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773670280; cv=none; b=Pqys7jZ/9hrQ3fUKlbi5WiFooWiBLng5wgmogepq+2SQCjE2143/4xEUCziEvnY2dM1pUeABUYakudXRA7FOQAKLI+Za2lRN5SI5zpwCVSmFZ5dIyiBQgDaIs3i1u4XERAQvlFgFipeQNsHD5uch39fPH/IBconO56ZOV9keBAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773670280; c=relaxed/simple;
	bh=6MhZruKcYazF+3BPm0e8m8792pkYHz/z0j4HoShIO0g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D+ZBynn8xirDiXiKLi+4gWM/sEAk7NNHh02h6OaF9DTQgEkiZj686cXgHYIFTxowX05eevj20gf9cPXdK8QiU176ADzTUjU9vLK+LhLtN8NkcJR3O/dgcVJt9AOEpAMZH1T+aF3MO5wRd2nVtiFffRVQOn53CeT9/ArgodiGmKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PDXXwunJ; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4852e9ca034so42446775e9.2
        for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 07:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773670277; x=1774275077; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CeuCiAK583AilFbkFWhX7tefuvc2DnKYSLxKweQuT/M=;
        b=PDXXwunJ5uYCMbUUThLmom2V6l9c62skkMGoAqvpdB+qk6EOBxMZS1ey9y5ycZriCg
         ewKRr7u+nTLfXR84djuSe+Frlx9y8XQSvrVbaMcVssYz5T500KbQOz2H15ekWT0A5wxd
         OB050fu5qe8hSibZW7U3xyPeOKalso4tDzfBQlVZx28Hj//flQgguMKQZLDrlzeLKNSu
         uyTNoi7xZZ2Gb7pX1gYYNqwiWzshUskOhW3uwXaLPAQqEIgJWPSG8tH7V5jj84lPtvre
         HD26ajZdFGlY2X5LRe59A4lvU45iYOtQX8dkQqVzB/Z+eQWicym89q46UPnxBM6FhH62
         0/1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773670277; x=1774275077;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CeuCiAK583AilFbkFWhX7tefuvc2DnKYSLxKweQuT/M=;
        b=EaCYw7oqHJTxLAb6YyrhmcL2iJknC6TL5IyHOaPtMG02RGngQ/WBB8F5YCnEUfM9oQ
         Z3+hVEyfUp7ybBv+oWsWQTkPYLJY4sg+r5U+q4rEmssg1mNwQ0g7T5lBsRR/rED1xmlV
         OU03N9+0jcDv9ZaEE2X7o21PSqnueHCeb8rugNqMfpd/gAxwfBAgQoQbVx4TlvQoyDEp
         WELWD+qSu55HnFM7kZbIX0R9cJHUoInGG2CZUybdf3TqWc5Xy+4VhBprGBQwrIBxeaK2
         iLDkM3+N7o0IDRTGpnTafcn6Kdn6tuWkG2qRO1IX9i7ocRKrA5hiH2w9olwZeiTJ1xo7
         nADA==
X-Gm-Message-State: AOJu0YyPj0oeChHPlX+CfkxtAf4iNaWpoQag9X3NclDUsvtxRDISVjgc
	BHFxpRHk4B2wXsjOZm7sMlwObXkM3zdG5NrMuj+YSd+v5w6CaEYVvci1
X-Gm-Gg: ATEYQzzm+eYCc1snFNkAHh+fizeZenCZbHRTJnHQ+W8IiFpkiNRAcekkFTLyrYSA0vD
	LLeJ0pGJdp8Ba0E2MAtKzmB271gs9m8tLjqS7E+Fc/N6ZtohbffoFO8ORoYfqaW1qlolGV5vry3
	JRz9ERG28Cx9LHg1nEKHl2pndpX5UK1wEYCNed+Q6aexh3f0pu2Tk2kLiJEH3OEz6rNTWb2DgxE
	CM3s144KMVQD8KMG18JhQy+FFA90KJy65Skph608NhZNLbCC1y5PeOrxQ9qI6u21ulqm0LktHe1
	oovf3ksmj+j3GxKCADZgYDO1zDuCy5v7eAlsPQarzYD1U8XN6CV/kXiECWZN6a+s7fpV/nwysY4
	W9nO0+qCuT32jmWCJ6ilHBXPtvj7icuTopoucw6HKjVt2R1MGEKzlZ/dBMXt4zPK2JfPjwRsbf+
	2zPuesNU9sMklv8OmBJ+0qXRzp8u/pKOSez98vgwINkXsCIKd73eQgWzhYzSdv8EnSBnLhIp9G2
	RwCTbg49VLy3gyEstlyq/3xyPq+HiSFko/eO616eN4i8FFWAoAydCnWEXOFO7uazcDY
X-Received: by 2002:a05:600c:4752:b0:485:3dfc:569 with SMTP id 5b1f17b1804b1-48556700c54mr222906325e9.16.1773670276971;
        Mon, 16 Mar 2026 07:11:16 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:a0ed])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4854e67ea40sm368784765e9.7.2026.03.16.07.11.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2026 07:11:16 -0700 (PDT)
Message-ID: <6d2a9643-962a-4328-b8e1-3bd264d73d19@gmail.com>
Date: Mon, 16 Mar 2026 14:11:10 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 0/4] BPF controlled io_uring
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, bpf@vger.kernel.org, axboe@kernel.dk,
 Alexei Starovoitov <alexei.starovoitov@gmail.com>
References: <cover.1772109579.git.asml.silence@gmail.com>
 <d8c8748a-4b13-4097-bdeb-495e6410a0df@gmail.com>
 <CADUfDZoBTwnCo-f_st9-jdgNhHLWUCjZQFpGdowGUA5BoJ836w@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CADUfDZoBTwnCo-f_st9-jdgNhHLWUCjZQFpGdowGUA5BoJ836w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12692-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.dk,gmail.com];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DD65D29B2B9
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/9/26 15:02, Caleb Sander Mateos wrote:
> On Mon, Mar 9, 2026 at 6:24 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
...
>>> - Smarter polling. Napi polling is performed only once per syscall
>>>     and then it switches to waiting. We can do smarter and intermix
>>>     polling with waiting using the hook.
>>
>> Any comments for the patch set?
> 
> I'm not opposed to this feature, but I agree with Ming that it seems
> largely orthogonal to his patchset allowing BPF programs to access
> io_uring registered buffers[1]. This patchset doesn't provide any

The idea of giving BPF access to registered buffers is largely
orthogonal to underlying ops implementation, I agree.

> kfuncs for interacting with registered buffers, so we would still need
> something like the kfuncs implemented by Ming's patchset to allow BPF
> programs to access registered buffers directly. Although either the

Surely

> ->loop_step() or ->prep()/->issue() interface could allow userspace to
> run a BPF program in the context of the io_uring, I wouldn't be keen
> on reimplementing the entire io_uring_enter() loop logic just to
> intercept a few requests to run BPF programs. 

I don't think some 50 or maybe fewer lines of generic code is that
much of a hassle, I'm thinking about adding it as a library code of
some sort. In either case, I'm not trying to convince you to do more
work.

-- 
Pavel Begunkov


