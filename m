Return-Path: <io-uring+bounces-12266-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IMEvMNpRk2nA3QEAu9opvQ
	(envelope-from <io-uring+bounces-12266-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 18:20:26 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E044D146A94
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 18:20:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 503A4300371D
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 17:20:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01F52299948;
	Mon, 16 Feb 2026 17:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fd0No4nm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733B628851F
	for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 17:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771262420; cv=none; b=RJOEzBzuG1X4/RsXp51JTOxXobY0qNSNqUT9YjVM9ZaYc7Fa1pUgUv19Ay3kkYy5ManYMop8wvAOIZTupJfeW15kCUmhuzC72f2N9DFVkhmsekENGOcHWAI+2ZBzPdHfLwYbmZW6Wsq+6uz7WQSJr+EyMB8IWJdaFqVqIqb4j04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771262420; c=relaxed/simple;
	bh=Vr/2osbnjDp5rsIvdgWZq1BW9LHKsKuMwrYVMK379+Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kLauWiTOj5P7DwVZoJ5vLgxUlwkG8tMNOcw8bfuRJZk2lR2eJFOBW0oIoJIGeWSnE84C9/JKB32LJUErNdVNjMDs+V4g8Q08YcgF6sU9U4rOnENdyJaFJKrTfNWWIuEsrtsqUuzgIbwU/y+ceDsqKUDsN0Jz6AYJ4dyqSc4jIMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fd0No4nm; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-48371119eacso31490735e9.2
        for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 09:20:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771262418; x=1771867218; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fSdhEvKbgoY9tgFVjVLRpfMSYalV5NpymzzhhF9knLA=;
        b=fd0No4nmxxC2Hhux4ctVQy4895yN/qUz7aHkwKswxtY4RWbsgutC+O30ZmeMUAbbXa
         b6qIdtHFtS+E3Yc2qE1QKEXwCJ3EIolabDS+iuCf+j8MRG2iP6Jt4+Pb8CB3CdxsN51Z
         qGZ3ZB4Sw6agrDmV0qGCooBhlfFFUFe4T0LMaNatqZkxUg0akghMYId2IFO96GDO5swl
         vJmj/8fY5o6w7+2zeZtB5tGIub+coNThG6BTu9rf4QT/qayvN1ac7wJzIi4b2nO7GYUJ
         GPcJ/PsjRwds60bwcX7v+Rl8LALWYJCqjkNnCvLtxHibyTIkOovDMbG2siO7zVpqE73+
         FvtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771262418; x=1771867218;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fSdhEvKbgoY9tgFVjVLRpfMSYalV5NpymzzhhF9knLA=;
        b=HSiiCjJkPPWvSZBWI3nFYKgc3gsx6UvQYPvjP0we7wnL/G8OIRK3eFXDjb/X/a9Kfe
         fc3GrDSG7+Dy6IPWC7zM8NQ6JfJbQ3Zx6QTXs0u72a3CR5dseHUGF0Qv40zGDiYZZJoz
         kyrX/ML0bk6js+jElAiXpWAA8Bb/267p/993Op4NL4eRzCnvL1NCCIXjS0LHckgjrmYZ
         uBE0SSm6LTxhIVfZb6gXwakXDKuQkCYebjuVQJ+30jG+U6ctyirY8by1hsrR1KcBcNmy
         sJwcUki/3Jtj5ljDuooasdvCApr01hFjF1gk5HCWd36mrFv9TCXK655RSnW/HUbeDKne
         4i1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXHUr6qH4EA0vpETLQwstb6NhMh7gqZTcIjcws97ep7xuiBLfGJhKsEdCyAJ/qetA9VzUrC1Ra8BA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+d0p97VilLFnTt3+v0bj2oBQcw6goHE+qhI4ydRujTtwwO7hC
	v+suTcJpiEeL4bvmFNePERuw4wTwbcp/tu0pEew3PSfbPKeqo0JXU9EHPE9v0HXR
X-Gm-Gg: AZuq6aIYnPP5tdmdUWoOGIi3uHv42NbN8X+OHE1mOUs/AnQmG6RYw7asUlyDLHHNdZ/
	cfQJRQhXKmwhxULK62aXV0OFm25mdAWmt5LejBB4tbODu6Z0ihBvxZz+QPKig/bIvOMqR7qUJd5
	IPQcb2TomXrRvZgRQigjLIUpE+qB9jPHiqZAHvN+lJCBgoTx+7qeoantJ4gXJTUzHzFGhre99sW
	zU3v/kEJz2v/jkjhXxk3ifHYINNpf6KHfSVyfiemmhKI2qPVPiqIMzq2mMoWFnn+E5UWMUXEpBQ
	6ZO5jJD347tSfzJ5bYf9zKTBSF4Y66xAriEqIZrcIhff1jqcZ85AZSeVixnhRXjEVZfXyMzGvcY
	QydOTa+vbvaRKXtZffKhBjywubTlrFUEW598w6b12k/wDhoUk0wsllhSjZPzZxNg7gVNSpbbn7l
	CjXe7mRoCSLj9B3UTpUDGTpJL2B58NMPhdEWi+xwnR6SPHxRFlMCyHoARWiNUQBuA/KrFwbQmkW
	jyEBfagN1VMv1TW8cKRNDb7M1O0uDGosS6noqKeDK//OMTzwgcAsxrMBvPSInnoxSty
X-Received: by 2002:a05:600c:1d89:b0:477:5b0a:e616 with SMTP id 5b1f17b1804b1-48373a085c8mr202691175e9.5.1771262417623;
        Mon, 16 Feb 2026 09:20:17 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:c3fa])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4835d92267bsm669963555e9.0.2026.02.16.09.20.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Feb 2026 09:20:17 -0800 (PST)
Message-ID: <e59d8887-d908-463b-ad31-3bf10d977de4@gmail.com>
Date: Mon, 16 Feb 2026 17:20:15 +0000
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
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <fc217246-2397-4ae4-8354-7ed0c498d23c@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12266-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com]
X-Rspamd-Queue-Id: E044D146A94
X-Rspamd-Action: no action

On 2/16/26 15:55, Jens Axboe wrote:
> On 2/16/26 8:53 AM, Pavel Begunkov wrote:
>> On 2/16/26 15:52, Jens Axboe wrote:
>>> On 2/16/26 8:48 AM, Pavel Begunkov wrote:
>>>> On 2/16/26 15:10, Jens Axboe wrote:
>>>>> On 2/16/26 4:48 AM, Pavel Begunkov wrote:
>>>>>> People previously asked for the notification CQE to have a different
>>>>>> user_data value from the main request completion. It's useful to
>>>>>> separate buffer and request handling logic and avoid separately
>>>>>> refcounting the request.
>>>>>>
>>>>>> Let the user pass the notification user_data in sqe->addr3. If zero,
>>>>>> it'll inherit sqe->user_data as before. It doesn't change the rules for
>>>>>> when the user can expect a notification CQE, and it should still check
>>>>>> the IORING_CQE_F_MORE flag.
>>>>>
>>>>> This should use and sqe->ioprio flag to manage it, otherwise you're
>>>>> excluding 0. Which may not be important in and of itself, but the
>>>>> flag approach is expected way to do this.
>>>>
>>>> What's the benefit? It's not unreasonable to exclude zero, it won't
>>>> limit any use cases, and it's not new either (i.e. buffer tags).
>>>> On the other hand, the user will now have to modify two fields
>>>> instead of one, which is cleaner. And you're taking one extra bit
>>>> out of 16bit ->ioprio, which is not critical if it's all going to
>>>> be flags, but it wouldn't be an outrageous idea to take 8 bits
>>>> out of it for some index, for example.
>>>
>>> The benefit is that it's weird to exclude a given user_data value, just
>>> so it can get used as both a key and a flag. IMHO much cleaner to have a
>>> flag for it which explicitly says "use the user_data I provide". Also
>>> easier to explain in docs, set this flag and then the value in X will be
>>> the user_data for the completion.
>>
>> Ok, I'll respin, let's go with wasting bits for nothing.
> 
> It's not like they are a scarce resource, and if we need more than 16
> bits to modify send/recv behavior, then arguably we have bigger
> problems.

There are already 6, it'll be 7th. I also have one or two more in mind,
that's already over the half. The same was probably thought about
sqe->flags, and even though it's twice as many bits for net, those
are taken faster as potential cost of redesign is lower.

Fwiw, the code is nastier as well, more branchy and away from
other notification init because of dependency on reading the
flags.

@@ -1331,7 +1333,7 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
  
  	zc->done_io = 0;
  
-	if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))
+	if (unlikely(READ_ONCE(sqe->__pad2[0])))
  		return -EINVAL;
  	/* we don't support IOSQE_CQE_SKIP_SUCCESS just yet */
  	if (req->flags & REQ_F_CQE_SKIP)
@@ -1358,6 +1360,13 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
  		}
  	}
  
+	if (zc->flags & IORING_SEND_ZC_NOTIF_USER_DATA) {
+		notif->cqe.user_data = READ_ONCE(sqe->addr3);
+	} else {
+		if (READ_ONCE(sqe->addr3))
+			return -EINVAL;
+	}
+
  	zc->len = READ_ONCE(sqe->len);
  	zc->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL | MSG_ZEROCOPY;
  	req->buf_index = READ_ONCE(sqe->buf_index);

-- 
Pavel Begunkov


