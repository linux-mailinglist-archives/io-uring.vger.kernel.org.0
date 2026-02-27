Return-Path: <io-uring+bounces-12464-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GMK0G9zsoWl8xQQAu9opvQ
	(envelope-from <io-uring+bounces-12464-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 20:13:32 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D32AD1BC858
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 20:13:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 609B9315C34A
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 19:08:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C578F3859C6;
	Fri, 27 Feb 2026 19:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e83umC5v"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8263939C6
	for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 19:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772219302; cv=none; b=Ar10nchMrRSj3tbNVRq/tdsD03mR3rqZ092PcmME24Uv5sok7nMyI2trAJV7v/OCGe6EC8yIqcs2tg/ZYQmqcbtBfgtP5JJ8j8h5ufcFQEjpX8zxOLkRlLAPCMTanngymSUmj7xlLyHFCr1DI0kf0foTQauHaf6WKeSF0eO4kik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772219302; c=relaxed/simple;
	bh=XoK2uqT31Z4BfhaivfdWmUbjFXHOhOPDNmt2lVETnYo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T2scs4mVmtfVfYJYQ2+2HjG6G9WyF4R4wkGvYeU2gmIhJmCSBzJ+keBArl1GgAgRjmzS2zGoJ7Y+hLnMe/vYsfLR5Tpb16OALV33zkCoEblnPpQROV1x66TbNrEb7vl3sIQJpAGU6MSq3pWxg+uMEt12WVT17ZdSmQlUY3EPExo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e83umC5v; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-43988056dc3so2380054f8f.3
        for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 11:08:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772219300; x=1772824100; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9j/t+CubQmNDtVPqkCYMFL6ytZHBHiJ/dyBupRPyIX0=;
        b=e83umC5vUXI3iRzE91no468h4q3OmJpJEtE7BbtlUVo4vAg1L9LuD1q08Z5LJeXH6E
         5JjXqpXTJFmB4asVkMs44TSpZjUbqpSEkcoCJmbUXuqG3ZTTt2DNSBS9sk2GuOAMzmoB
         uXe4HaSwctoigdiuDHyrsuro7yFNK9AwOuZ3paVgqOp+BqIpsM1JWwUed4u9OgP9cz4v
         /rEXwSn/1F/aqyd3V4Zk+ZQXHOUCmz/wPJ0xJz6o3m85aRGU2gR3aJZyPzc0ri6Slx8v
         vCG1vBGhU98Px61OJn3L2c086lyLTy5uFqjUQkkrgFe8bs7z5/aJpXQrt9auU6WHYYjH
         agNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772219300; x=1772824100;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9j/t+CubQmNDtVPqkCYMFL6ytZHBHiJ/dyBupRPyIX0=;
        b=Jum/3X1r0SyagVCzH7lL4NfTir8IWi29K30os6SUObUt+eGVMYGMl34DXu92IHHJzX
         GPkILUC8s/OjtMO62o4u1WWA/U0Xv7FdODngu3ZXqcqNJwUR1eCGZZw3rhjsr4GUluUN
         nhIzSiHBEYmIl8JsNEUhv4taqx4ny1IuXwdN/nCD1cigHRP3ARPSbsmt31ch2v0d0ZAn
         Zvi29zuKk36waizcQckfeurcKYbRse5jjlyw3vj0Zm6L8ucbDEB8/yrla7QoiEQVmwxc
         Ht65cfSiNxx3l4mSnPr3fPbEBXNjciCeqaaRSKNen/JaZfqHplM1DBPPKKyeyrsRt6Fb
         0oVQ==
X-Forwarded-Encrypted: i=1; AJvYcCXdy7USfORY38Qf4RyZ8jWSXAohDbPGCPdZkcdIrtOeBxbwxyPfBwcqq7mnTIwPhClUjVUMLmlmng==@vger.kernel.org
X-Gm-Message-State: AOJu0YxKRp64jY3CHanmGw5ozearadPrRaetyOT8bdRClD2Q8M1Icuxo
	Zx925+VvqR3UDvv1ezQiuSLL7gf1Scf+298/RT80XO6CobhOGAgfTzXi
X-Gm-Gg: ATEYQzwx88JyXXaXVlMVBywjem71A3st/zkdQgE/VT3+v+iUeaC7uX5+FhrYJEvAbed
	ACZgp3JtWdLyF0JkDXVLRq4tUcVh+8LRUczznknP+GQxt4h1hf465hrep4acA8xocSTht44T3iK
	Z92qLOOSsW6gZCIex1kv285HlPmqQZLXCg4Q+qknItdZDdHbdrNEx/h8Ph7J7Xh2mydZgocbQ/i
	6R9+44VzYjCDJRflHgo4KCEmjBWFYVZxuheRBnLtT4dyUwjHBCw4SzlobR0uiDXS0PHdiBpZvp5
	f/NP0UHgLs6DyqKaLNrn7+ahLiXHp8Sfwzl8RiIwhG6zb0kx9QSmlVmM6/VUOXOb0w05sRUvWLH
	wi/PB2PONf21sOfnOJ5jE2DdB5cdMRvBgfWlSDIwBWH75jrNBFGz3kgREpmQVqxdZ04PtRfKHzZ
	Ly+A9vsVjiWm4NrfL8Xz1H4prank1YDTKl2YPS8cJiLczLUjjtTPglphJXVYYr5KlSvY7aYRAFi
	pY0AP3ATQhGDuzq8CAzuIA/bqVboxzOJ2d5SpYIASvb2uxkfUaj0u/nBwWfDJZXVat9bXalAbXA
	mg==
X-Received: by 2002:a05:6000:4382:b0:436:3732:cfa6 with SMTP id ffacd0b85a97d-4399de55a68mr6916914f8f.53.1772219299522;
        Fri, 27 Feb 2026 11:08:19 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4399c75a523sm8393623f8f.19.2026.02.27.11.08.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Feb 2026 11:08:19 -0800 (PST)
Message-ID: <a6cbceb5-2065-42ff-bcca-bdb1c2443b96@gmail.com>
Date: Fri, 27 Feb 2026 19:08:12 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] io_uring/timeout: immediate timeout arg
To: Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc: axboe@kernel.dk, Keith Busch <kbusch@kernel.org>
References: <cover.1772015321.git.asml.silence@gmail.com>
 <6151302f1dc01d1c4e3176da50ab4224947b709f.1772015321.git.asml.silence@gmail.com>
 <3ae98749-590e-4f8b-a835-c9a15d7866c2@samba.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <3ae98749-590e-4f8b-a835-c9a15d7866c2@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12464-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D32AD1BC858
X-Rspamd-Action: no action

On 2/27/26 14:08, Stefan Metzmacher wrote:
> Hi Pavel,
> 
>>       if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
>>           return -EINVAL;
>> @@ -460,10 +461,20 @@ int io_timeout_remove_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>               return -EINVAL;
>>           if (tr->flags & IORING_LINK_TIMEOUT_UPDATE)
>>               tr->ltimeout = true;
>> -        if (tr->flags & ~(IORING_TIMEOUT_UPDATE_MASK|IORING_TIMEOUT_ABS))
>> +        if (tr->flags & ~(IORING_TIMEOUT_UPDATE_MASK |
>> +                  IORING_TIMEOUT_ABS |
>> +                  IORING_TIMEOUT_IMMEDIATE_ARG))
>>               return -EINVAL;
>> -        if (get_timespec64(&tr->ts, u64_to_user_ptr(READ_ONCE(sqe->addr2))))
>> +
>> +        arg = READ_ONCE(sqe->addr2);
>> +        if (tr->flags & IORING_TIMEOUT_IMMEDIATE_ARG) {
>> +            if (tr->flags & IORING_TIMEOUT_ABS)
>> +                return -EINVAL;
>> +            tr->ts = ns_to_timespec64(arg);
> 
> I'm wondering if there is enough free space in a small sqe to hold a full timespec?
> So that there is no restriction for IORING_TIMEOUT_ABS...

Well, u64 gives ~500 years in ns, it should be fine to just
allow the abs mode. We just need to make sure to zero check
the unused fields in case it'd need to be extended.

-- 
Pavel Begunkov


