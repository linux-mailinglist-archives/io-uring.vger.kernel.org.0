Return-Path: <io-uring+bounces-12217-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gGSkMCRBkmnEsQEAu9opvQ
	(envelope-from <io-uring+bounces-12217-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 22:56:52 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 4635113FD5D
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 22:56:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 12692300FB65
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 21:56:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 759902C029F;
	Sun, 15 Feb 2026 21:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HSfw93Kj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26651309DCF
	for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 21:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771192608; cv=none; b=ukWcb0YQJX+J4pWvGyA5ThDJ8zZ96lsqRZhUgkjUHgUF9Ha/YkTy/im1dMp1v7s3wx9k/0ECxmUnkKVTzzlYJeZadZx1zrOWan/9ObQK2krJgzPA/hAJUf5TTcWGVLRuSKYO1O9olIzVBLPUIQR7GVQPnI09t77Ak+0Jf/2Lmcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771192608; c=relaxed/simple;
	bh=hWKklEUQGo8V8sRrKUQULL0VWTvV6AZNCVZ36dOWk5g=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=gZISxqjQImU9KsE1i21HIYIR7eSz+p37u8bYh8gBcAoA9NxYi1PSBU+WQAJZjaZuTNqmwWgcGeOvsEbkzhKR0zrEd7PiNH5zK0RwWGBSQ7JTUAOSU0Q6PmtyHpI/hxXBV/jkaEzNcIa84V7ppoHYL07a4KQ5a+QyQU5BetoWIf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HSfw93Kj; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4806e0f6b69so19640135e9.3
        for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 13:56:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771192605; x=1771797405; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=813dI/vjDfd/nbU7oA/ynU9RDYjby0i4blWTL72iAbE=;
        b=HSfw93KjBATLVUs5G6yvU6OkuePKJtuXYUqB8g9dUPKP7PctgbFaVTRZLCnxBbAyaS
         MoYfTYhtpcg0acaU/YvxXiquniRRme2VTiY7ElE3cVJlniRwq3LHRvPevHrCKSGBjzEl
         WGXTaNGED+ghQCevCt/hZWUsZaNob8xpha20MBlMBHQWVMcJQJZMS/MtCBwKyeVFEv7G
         ySJp9gOKMeWMWsiuMkbl3P1FztUE00bdXBMQU8Pkh/E0oo89mIlAY9rZJ96Wk+9CiYLF
         nImOHCBjBMOTIeupTo1tBZE1x8dzBeZ2f9XkpYo8tUWuGGfknqR7L14tk7oCkl6pjWPY
         aSIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771192605; x=1771797405;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=813dI/vjDfd/nbU7oA/ynU9RDYjby0i4blWTL72iAbE=;
        b=MeRmT1oTJxcIvMqvlmH4TV6+GPX0rjNTeNjhyKSSPZWAvv4LFA67yTxoPHSP9Kxig/
         Asbbp6hBjxeXjCI0GWdHxX179qI76ZJmpFx8FJM0sY3MDVzQlat6+QTRblRUDKRvBzM4
         +XOcYlnwg4Tbl/qWMlWIxwZoF6NNC80yj1KWWKLE7b9DnrilbICLHBogkUDHNcp3jy1P
         iEbz16R4ot1l5gGX5EWG2hSXaR9enADL6aeEscodbnqj/CfBqNhf0+Oq4qBCpFXE4gFC
         Dpxw760gxQODJb+vOfRWEcC+lHIO/ehGesvVAYNruM+mlvN23Zz9TMxFRvS/UtF1psxy
         MQfg==
X-Forwarded-Encrypted: i=1; AJvYcCVy4HtB3Zg7vz/VMmZcKRxwOWHZATERUtiA4AnXSlXyE66gZU5pIEw3na7JZiXXWdlN1E/5+4CIoQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YykR4OcssncS+2E/wQpYTZFgxoBiBi+wm1rSn1b5mZaFgDM0JQT
	HovwxeNqvHTdRGeUiX/G4VkyiLiNgC3sD4/iZ6aEyPjWmIVIQ5MUtkgi
X-Gm-Gg: AZuq6aIMEdsU5ZvIg7MNss06GaW05QOWOzik2nbrTy5PCwq3fBp6RWcxD5v3GshfXnO
	wJyGcionn29c0MYwVlsZegYPnQEEbCPTXH6C55dQHnzfeQafb3pT6Iok8OgwcN2/WmIELoA5iyZ
	NlvSv2KbLUs4k/p4c5nwFD2oJoFzMscAvqFozk02m6ZMZbqlWeIWb75aDwruynIcKNQLDpbGIyp
	3FYHRaH+AOR8F7JZcwUC64otVMWUr1+z0XKHcaQPsu/3ImnIjuzgBt5CsYKsD8BDjxFdKZJYeKU
	zKA9YMO+8fIZc6tRr4gFvTEivLWSGaJeMwF3eeOPsHvEstnjU9/mWyWa69HXgNDBjv8P6+GYvpL
	kQ4y02h/TJvn2dEG8j766HoL/iRJFEfavrkKNxA/4bYgPFq86oVVcyJcSRZ7m9sPA+3Lbkbqamc
	WhnXGFeKkiqSCTo5nXrNvGBwPV0IT01756FAVTyONUgmNgS/Xqc1I4LYiC3RLMfwN19K/5a/uaa
	7E8Fl+3SJEezeABHMWmG+iMJWkMZBA5ohhGJGibuphTXlrXhYV9GK57hWi9x7Kh0JIgxUZMN8X7
	1Zz6HaxFZu6j
X-Received: by 2002:a05:600c:8b4c:b0:480:5678:1fdd with SMTP id 5b1f17b1804b1-4837105240amr154997105e9.12.1771192605251;
        Sun, 15 Feb 2026 13:56:45 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4836cd7af87sm266525775e9.1.2026.02.15.13.56.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Feb 2026 13:56:44 -0800 (PST)
Message-ID: <386f4b36-0c53-4ad7-9f71-dff53345ec4f@gmail.com>
Date: Sun, 15 Feb 2026 21:56:40 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: delay sqarray static branch disablement
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <8990bf99bc758c6e033e7a75ea5eb1834dd2f920.1771189395.git.asml.silence@gmail.com>
 <ed8a3eca-2e97-4ac5-a63e-81563c57546c@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ed8a3eca-2e97-4ac5-a63e-81563c57546c@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12217-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4635113FD5D
X-Rspamd-Action: no action

On 2/15/26 21:48, Jens Axboe wrote:
> On 2/15/26 2:29 PM, Pavel Begunkov wrote:
>> io_key_has_sqarray static branch can be easily switched
>> on/off by the user. Prevent abuse and defer for a bit when it's
>> disabled.
> 
> Can we get something in here for the reason for why the change
> is being made? The commit message really doesn't explain any
> of this.

It appeared to be pretty self-explanatory, I can expand, but in
short you can spam with

while (1) {
	create_ring_with_sq_array();
	kill_ring();
}

and each iteration it'll be patching kernel code, and that
can be very disruptive for the entire system depending on arch
and how removal is synchronized.

-- 
Pavel Begunkov


