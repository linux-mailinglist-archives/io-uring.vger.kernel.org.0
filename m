Return-Path: <io-uring+bounces-12251-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GKwEMm88k2kg2wEAu9opvQ
	(envelope-from <io-uring+bounces-12251-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 16:49:03 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CB6E145C49
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 16:49:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id EEC4D3004C8E
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 15:48:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD5FC3314DB;
	Mon, 16 Feb 2026 15:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bca96UyJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CB9A937
	for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 15:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771256929; cv=none; b=Uaws5F5TBiL95Q2k+kVuKQ+t2Bj14hsVtH9r0OijpyNHr7/+wxN1klFEWbVyR7xmUbdQNcJzd9DP5dhpOn+hiqjdo0FArH1/XwJHD2PZQlEH/sOaRIAPij4Tm7LTdzKzvDq6sDnXNXhOvlF4qa1SmnAoSVKGaf+w4aUwMsCq25k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771256929; c=relaxed/simple;
	bh=l+35F6IO/1qODsLGFIpcC9/aybEeQCk0ZT4/OUKXiZ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X3VRsIVjNEa3WEeuMBExlwrbkbHxIX5olmg+iO7xGs5Z5212VLhWz06Hhv15beyXLuQBzKgVVt0LaR2R1xOshRszrQioj4+Ck3k5pGTiFghjQH/+FXwlIELCrZDxlF4S9jSOnnj1GPckejdbsp+BeMgbqJD5Q+og9jXhhSVQ19Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bca96UyJ; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-48329eb96a7so17919705e9.3
        for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 07:48:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771256927; x=1771861727; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ULA3I2iv+5DsnkQTfISLWpqDe99iYqGFCX6iLQDzIi4=;
        b=bca96UyJpU+cp1HGQ0YGdLOinSWCkBuGxAUVWgqLIzT1orD+sbW74Wz7H6QM85fK8T
         +QEdk6Sohzo/52gQbhC/Yg7ohKhfbrgcNSCrMjJOsmxwbibRQ2LDROgSAM7mYrqZ71qD
         xzv6GBB3hopWlugh3HdaCy3vJZ26fWO109TX0Kp5juiHhRHVC/47F9Zm2Kom5ZcbupsF
         Uhxw+ewhn2/KIG2YJUi0qwwb+Qfv3/TdVh2QJIfzbaypHZY/Uh5SmTeKznN5H5eGmnBE
         ZPIAIGk4sb0Lx0Q5x7i6zhtI9BtuNYJ7Y5h9TuuYgB+dkNNQ4Xjd7YAeQzmEuOW88zhv
         DJlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771256927; x=1771861727;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ULA3I2iv+5DsnkQTfISLWpqDe99iYqGFCX6iLQDzIi4=;
        b=IkXCAFw2kuRyNxdcKFEONs83EArobyInL6zfIB0ikOnEpLd8RJPwSi/uZnm/EBkxGu
         dSu3ZwMMOlTZwOac2mocww8cEFfQsYUD/t3BdRrE90Y9ZZPCpJNkvVB1GHYW4CnNFfKA
         +7OetRmAOE8x4Io4TO/FlIDRyq6yggOBkxGbcnS+nFcOYsThCVYlv2WPmOz+b0Of6SmV
         6sCfIKt6BFJSTNRBwOwPtA+riT4Bt59RdFN6NqVcKsYDtSKD2xsPuE8hJFda359DtyKE
         1R80dW8u305Z1RaO3KSmbVNxx8atnoExH4nF5iHGPQfP6wE8NBXfpzW0oLVyqZy8pyJT
         BlaA==
X-Forwarded-Encrypted: i=1; AJvYcCV/Z1z/kmlaPIwpJuye/ZazJHZYhKuVOSn34xB9vxVKz6m4lKwWykmIAR02zxLf5RifPfHXRFaRDA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxBJ5A9vejUfxBXVpsNIc2yJizea+wNg+XfRGvsv/ytG9do0NFn
	vvnFUBMxq3Xi7xFmkNmJqR9JCjLOU/j+whD4MQ7XnwsoUVYD7scx/EZ1
X-Gm-Gg: AZuq6aKcdBCzz6+v+2SG6Hrd6pn6TLHdvtjjot57AHezZ87ZoOQ+AeNTgC1qBckGYWr
	YrlX/iw6Uw1p3etYqsr/tZLTzXrLoydIf2+ydwrDQQnoUeKKV7q9ldJXVEm6KYs1fOLQZ7TQW7f
	5G+4DPZTf5/3xwedUnbM54FzLY5gsJdse7BmRLYMDuv/DdqUO4VzkZAwsOBcXvmjG6uqJa2Ci50
	r7MlrR+8Dip9m5OFLvMiZHJOYBZeBubj9T8sr9hQhr/wG+6GifEttxg4deq+tM9WHwsd2Vad4g5
	0VHcBiFqZuDw8YAJXpWrpq3VxfOcgEHsTIj4rQUxHJnEaeQsXsmBE+gxQ5sz5xwXv36He9tAjJo
	dsDsfW1n5RPnlDvP1rkJEFYJEsKbPc3GBDB3YwSY7tN7n/edpN/Mz0+jge2L8+ZhAPlJ1hWx6XL
	27DYa7AArRgml9yLjIzmwv3QrD9O5K27OvOXv08R70QjCGtN9fMgny6zdBc71agYvaJrWdECaUE
	X6YunDYmDMH3pkzSJgplE4PMyCEXxHgYoTGALfQ4bgSBtg+EhQ7z/BaMQ==
X-Received: by 2002:a05:600c:3b93:b0:480:1e9e:f9c with SMTP id 5b1f17b1804b1-48373a02c73mr218163395e9.10.1771256926621;
        Mon, 16 Feb 2026 07:48:46 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:c3fa])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4835d99497asm613014585e9.6.2026.02.16.07.48.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Feb 2026 07:48:46 -0800 (PST)
Message-ID: <5fa237b6-420d-413a-b7b5-9f85d9f1e8ba@gmail.com>
Date: Mon, 16 Feb 2026 15:48:44 +0000
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
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <025de231-a6d2-4fa8-91e5-f4ab81d16e7f@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-12251-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8CB6E145C49
X-Rspamd-Action: no action

On 2/16/26 15:10, Jens Axboe wrote:
> On 2/16/26 4:48 AM, Pavel Begunkov wrote:
>> People previously asked for the notification CQE to have a different
>> user_data value from the main request completion. It's useful to
>> separate buffer and request handling logic and avoid separately
>> refcounting the request.
>>
>> Let the user pass the notification user_data in sqe->addr3. If zero,
>> it'll inherit sqe->user_data as before. It doesn't change the rules for
>> when the user can expect a notification CQE, and it should still check
>> the IORING_CQE_F_MORE flag.
> 
> This should use and sqe->ioprio flag to manage it, otherwise you're
> excluding 0. Which may not be important in and of itself, but the
> flag approach is expected way to do this.

What's the benefit? It's not unreasonable to exclude zero, it won't
limit any use cases, and it's not new either (i.e. buffer tags).
On the other hand, the user will now have to modify two fields
instead of one, which is cleaner. And you're taking one extra bit
out of 16bit ->ioprio, which is not critical if it's all going to
be flags, but it wouldn't be an outrageous idea to take 8 bits
out of it for some index, for example.

-- 
Pavel Begunkov


