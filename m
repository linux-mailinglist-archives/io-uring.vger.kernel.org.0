Return-Path: <io-uring+bounces-12218-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id bKWBGMNBkmnlsQEAu9opvQ
	(envelope-from <io-uring+bounces-12218-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 22:59:31 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D993613FD68
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 22:59:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DD1C93006B50
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 21:59:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D31812FBDFD;
	Sun, 15 Feb 2026 21:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="VvwFhs/M"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E9B14A4F9
	for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 21:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771192768; cv=none; b=fI4NjRGWgJcKI/dfagAQtCULiXH3su9htxHOAkY0GxiyaXe03SEDMr96LJsRjRL9DU9iXLClcYBRDhyYxBLMB81XgdkrCxMlY6z8jZx7eAgREnEpox3NHPmXW02q/tshWEc8iJLKbV2Ejn+4iivRHR0azSd/NiFGHduA50krlK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771192768; c=relaxed/simple;
	bh=Evvq4jps98FkJNLgoV4vROHeiOiaCtSNVmaA88k3gIc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=fLPxbcWgpSlWYujeAjA4n5kxqgLeRV65wn1iZTz82zZRcLXq60Gh77CdjLvzWWQnGd5qexAW849gzTuEUlC5TptiFKl+Z8tvcm/NwX7K91LLWkDYsl1BFEYcIMus52uIPmSwl3wvXjBgiGbs7AgDe69KMnWzcGHXx8Kq8Vu959I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=VvwFhs/M; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7d4be7c4ebeso1469358a34.1
        for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 13:59:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771192766; x=1771797566; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Bj7qEP1OVHTMgXCWb0EQ4lPZLCrdFAVYgNvsEcXHd60=;
        b=VvwFhs/MTubClZMjEPEkon69GfM+GzMqt0jKFZBa+yYT7xnTsmVUlibKics14OjDQL
         gKAlgSSS6RXQL3TP8667Ta4+BT4N7ogvRuRTo7rBFvCVR+/SyHwCOG9YvF1G9p0sA/Sd
         d8K9NVXlierDi84Kk0pOZBU81aIqrNRbmXiwsUqA3Bl8fy9Xbcgezr0Jan3khwVK6gHM
         mYbj22SbTvj63KO7C3JVsEukFf0YjyFCIRCn1WagW9v5i5jWD03SNgJ7VDxdtWD6/0Zj
         2nQhDxsnAA+pFRARo+uC9EWM6eMIZDO9dLCFuQp/e07WA1WFVb09JflWI70t2uWN8P9Q
         5FPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771192766; x=1771797566;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bj7qEP1OVHTMgXCWb0EQ4lPZLCrdFAVYgNvsEcXHd60=;
        b=recy9mKHNZBnhtjmc7pSQZ3iU0tk018iHvfvrGRFRtKuU6vQgWd5anNiwPa+O4wD3c
         +bMkl7YdX7xWLHnvmm1BRBS0dwOotKQ21OKg6BLBfGKdmJ9KK/Bu2q+RP1ifV1Bg6vUi
         FA/Nmw2p13ILpIxw7U3G6sjMcnIhQ7R0/563Bpd/dfzZ+0iRCCb9vqvxcP8qjhy5Vh0G
         BR6FCg49jAH4iWg7hwZ+r2XgZM00w+tuGfUPK81f0NzB1UfR/W977seyT/VKAjBpQSPp
         +Vtbc1riraM/czW9HovjbE0d8B4soL6yoOmSirFXQFBLpHh192OaldySD7fzuLXQnGb7
         hVjQ==
X-Forwarded-Encrypted: i=1; AJvYcCXuKo4T3MUD7uCG3sB98J2z3VXy+FbM62cvTGfiiuD5kfRC3Op5HBOv9srvd6eLSWWIJVZ5GsMamA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxFNc9rQvTrLLooqbz57OOUXiC96WNsaDN5KsAQpSMPtImmxKgP
	DdqB8U8ATfCQkf7lwlM6MKcAHNT/xIpB9LYY2wqW+wULOuUtxz70RGx1mOpw3XLeBebThfPQpUu
	dyySxpYk=
X-Gm-Gg: AZuq6aJdTUvOJsiJ5o0ztQCvsZQ6WwR17VVgxnQsptjaM5fsP6/XyQn+xpV9gM3Ajt8
	Zh9sp1MBCiCLiXkPmOb4MI5mHI7NvJJVi8gAtNqxh4haceDJllw7+G33PIFD5J6vyRYAxPTL8bM
	p8LGDQi/8bPGxnOlfwj6J/6U8IhCEJp4M9le+9p3zFg3zStcTLqVMFR4xaznT2IEh7cXDCvmFLv
	QNsnLKZn4Mlv2HODsbKsD1u+4QtGDXdHF31lyiYQsUtBUkGpUk/EXEx2476GMrqcEz1Erc805oV
	bqU1hbCSjUdK2AFCwa7xOF2vZ7xOVh5EqcAcRzw/7WD6d7Pf7mn2RnPiqzzJM05hapv34R4aBxO
	BFjOre1k7NaPXjUFK2GGeBhV6GGtBvbTPJcEq2+OSijDiuz0EMOtb9dbY4WJI5k/PTe2rUO/MZR
	qQ3VOMpYpq2MxeUc1iOoqNgtxvAAsBZW9pI9gFE5siCRblJZ9hThTMLbHlzhj8k9/XgOR/hsoLh
	hZJf/qLSg==
X-Received: by 2002:a05:6830:2aa1:b0:7d1:9c68:8d9d with SMTP id 46e09a7af769-7d4c4af31dcmr5627648a34.29.1771192765857;
        Sun, 15 Feb 2026 13:59:25 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d4c22d11a3sm6873048a34.6.2026.02.15.13.59.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Feb 2026 13:59:25 -0800 (PST)
Message-ID: <ad1b654a-d106-45ac-a1db-60b66bf6a917@kernel.dk>
Date: Sun, 15 Feb 2026 14:59:24 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: delay sqarray static branch disablement
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <8990bf99bc758c6e033e7a75ea5eb1834dd2f920.1771189395.git.asml.silence@gmail.com>
 <ed8a3eca-2e97-4ac5-a63e-81563c57546c@kernel.dk>
 <386f4b36-0c53-4ad7-9f71-dff53345ec4f@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <386f4b36-0c53-4ad7-9f71-dff53345ec4f@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	DMARC_NA(0.00)[kernel.dk];
	TAGGED_FROM(0.00)[bounces-12218-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,kernel.dk:mid,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: D993613FD68
X-Rspamd-Action: no action

On 2/15/26 2:56 PM, Pavel Begunkov wrote:
> On 2/15/26 21:48, Jens Axboe wrote:
>> On 2/15/26 2:29 PM, Pavel Begunkov wrote:
>>> io_key_has_sqarray static branch can be easily switched
>>> on/off by the user. Prevent abuse and defer for a bit when it's
>>> disabled.
>>
>> Can we get something in here for the reason for why the change
>> is being made? The commit message really doesn't explain any
>> of this.
> 
> It appeared to be pretty self-explanatory, I can expand, but in
> short you can spam with

It really wasn't! It says "prevent abuse" but is not specific on what
kind of abuse this is at all.

> while (1) {
>     create_ring_with_sq_array();
>     kill_ring();
> }
> 
> and each iteration it'll be patching kernel code, and that
> can be very disruptive for the entire system depending on arch
> and how removal is synchronized.

OK, so that's the abuse being referred to. I could surely find
out by just checking static_branch_slow_dec_deferred() and
friends, but a commit message should stand by itself and not
need that kind of discovery.

Can you just send a v2 with an updated commit message, please?

-- 
Jens Axboe

