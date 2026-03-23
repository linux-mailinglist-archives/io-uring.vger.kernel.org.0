Return-Path: <io-uring+bounces-12808-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yOKBMnlzwWkQTQQAu9opvQ
	(envelope-from <io-uring+bounces-12808-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 18:08:09 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DE5B02F97B6
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 18:08:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 27E1931762D2
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 16:14:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD88F3BA240;
	Mon, 23 Mar 2026 16:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KOOTwuYW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA9B3AF649
	for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 16:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282472; cv=none; b=XpJNFP/TP1RcuPngggtfjQhXSDPE7USDh5K7DQ5Qj62S6OhI06NBWVJ32NBHgm9kGJPx3wdatadpqevhXjYNjHLz2AakirjNrM4uiQS+DInj9ZJq/eiO/K2vZ8srkZjPUDij1F8Yh/iq47a5Q5spGhhp+7u/uY66I2Px6wRMMRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282472; c=relaxed/simple;
	bh=/9wFtUpwo93aoF/yQoMMoKHh8Zo37Iy0Tbjo1nQyKJ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ULmuAFMRfQM6GrJCjgJ1DCzenbObfX0H6sJ0Du2Am6JybcVjm2bKAkg+koUR3S8E+REnbIu/4NernA6A/sQg2GSRzVQh0hEJLuZZYt7SNUiGSPaEy6zdpbfULy66CURp91Go3CBwunID/5/O2G3v8knpC+VF6/hv8q3+0Rjnd1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KOOTwuYW; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-43b467dcf0bso3200028f8f.0
        for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 09:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774282470; x=1774887270; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e5a/PBQoKYFTkqLtYH0BJ9gW0vtOTD5mPK1HUUNiblo=;
        b=KOOTwuYWe1iXWJrYWpTIqMbs9bUzm5iN2VZ0LhWNa3iT0blGatJ4HN9YByG797WOsK
         At5SMJdJq4F07tbPRpDUbDwvRI3teFg+i6lrPTPmWIOmlKW4l+ZyCde18bCRAB8D2Lj/
         KbcMSiH6N4kPVmLjmpKlAy5irVy7Fnvw3xSOoKTpscxyIUse8g0GE//jpS/OkRod4RsH
         wb2Jfy04fZ3T6P/DuQoSM0zSsZe6sFdFWS0CGDsjHdNGinSwSAkyUTTTpzN+t32EvbF+
         sdoGmK0bZAZ4t6D7mA4MqfyaFNWQG+7+m9PMj9ixTZNjd2cXfGlLJByiskDnVit99M3W
         vGLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774282470; x=1774887270;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e5a/PBQoKYFTkqLtYH0BJ9gW0vtOTD5mPK1HUUNiblo=;
        b=ihKmdQITd0fc1qf/+VJiK6Pwd+ZvmPIocU8y6FLtQKSGIWmoougBPA+KfnQ+cT62eN
         ear7dNdWcK0plyBW4IvjruvB0v7WRzB/Y3aLiTEvsp04tgYyZWNSk+QuG3c++W8uUdps
         XSJ3Y6wQAhQw0t9pBdL/uPEz6GcUqEu4DcXwhKcYo750bEtQKkVyL23bN5jzsPzOUqFY
         doAAjS+XYzEMrPpKMpBtkkXfOvDLzJSL/b0OiieH5WHoHN4SZ6FuLT9W/R+L8ZX5G6lw
         m3Rjz5J2zxxiYkvGD7boL+pMiFhYLSg/Z39l9nUKJeMHrlpReiA7HwQK0EwZ0Li54dSP
         c9qA==
X-Forwarded-Encrypted: i=1; AJvYcCX4zkN+4rGX3EhurGl17cJi3xhW/I+kpgSd39Kf6PQiOnn8t32NnK9KMj69bQTY5jJRgNlgSiqofQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxsEn85YIm/g4Pt2ZfQ1MEuZDKB006u+TDt4/YGoxjBVvdMHYXE
	VXQp7kbK06dqK3eeja+6nmb9WgGuR5aK9Y0atfoGpIhAh5z7oVgJ1hPaexY8zg==
X-Gm-Gg: ATEYQzyx+ASBBe8UTLdmk6WvGkr207YZXDblzjSXR3mobDC6J3rzjdF6dAb+uJzZUPS
	5Go3blPo+lsAk370WM6cFHwaN2LtF3cl3IrNd7ioXMsgOClX3BS1V05T51LgI/kDu1P4fHnxuyk
	IcJmzH9ytMN4ueVNkVpiOjgwTOzdaokcBzIl5U4/XuTNxDoygWje6Kyf9q9frwybEIBfs11dTsd
	ixcZFBIzk5am0hQDl2KZHpffcMwM5ujeCQoUb7ydE+zvcJjPG3fA62Qpgn86LpnVv0xwHlD6Qpl
	xqfZFjmYUAOO2uU7gBHuteu+r1+SlUvpsAsNGokJFiJTixDPum/ggneuWXvkMMXED/U/X1B+oGp
	vHzpuwm3SYCYiT+btZc+nZYzv3BI9TA7NszKakk/BBpxwOMbAViV3RBUvg/UxHgZI/REIJFoJSc
	jUEOIE6bUqkMmqMsRZm23+tW07FOM/b14tdXdhCm7O6vK9ANYY1eyGKrzqCT6MEBrE0sst+VZJu
	XyPKlBvbXmW5fImFoW9tsB9cirv+Tz9Ke/Cil793jBrv2mRBTKVNTbRAQlkg+RY1SfcyiIvrYnG
	JA==
X-Received: by 2002:a05:600c:4f0b:b0:46e:59bd:f7e2 with SMTP id 5b1f17b1804b1-4870f202653mr2228875e9.11.1774282469407;
        Mon, 23 Mar 2026 09:14:29 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-486fe7e2665sm336315005e9.6.2026.03.23.09.14.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 09:14:28 -0700 (PDT)
Message-ID: <d1981803-0b3a-468a-9fe6-a751470cec26@gmail.com>
Date: Mon, 23 Mar 2026 16:14:36 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH io_uring-7.1 01/16] io_uring/zcrx: return back two step
 unregistration
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: netdev@vger.kernel.org, Youngmin Choi <youngminchoi94@gmail.com>
References: <cover.1774261953.git.asml.silence@gmail.com>
 <0ce21f0565ab4358668922a28a8a36922dfebf76.1774261953.git.asml.silence@gmail.com>
 <1b3ad321-866a-4cb8-9810-5eae7805647d@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <1b3ad321-866a-4cb8-9810-5eae7805647d@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12808-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com]
X-Rspamd-Queue-Id: DE5B02F97B6
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/23/26 15:01, Jens Axboe wrote:
> On 3/23/26 6:43 AM, Pavel Begunkov wrote:
>> @@ -898,12 +933,15 @@ void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
>>   			unsigned long id = 0;
>>   
>>   			ifq = xa_find(&ctx->zcrx_ctxs, &id, ULONG_MAX, XA_PRESENT);
>> -			if (ifq)
>> +			if (ifq) {
>> +				if (WARN_ON_ONCE(!is_zcrx_entry_marked(ctx, id)))
>> +					break;
> 
> This break is inside the scoped_guard(), does this need an ifq = NULL
> here? I do like scoped locking, but this seems a bit tricky...

That should work, want me to resend or would you amend it? It's a good
thing I was pointed at it, but I'm not too concerned about this case as
it's a warn once.

-- 
Pavel Begunkov


