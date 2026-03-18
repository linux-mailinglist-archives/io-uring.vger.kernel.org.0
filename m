Return-Path: <io-uring+bounces-12750-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IGoFL8ESu2k3ewIAu9opvQ
	(envelope-from <io-uring+bounces-12750-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 22:01:53 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 610852C2C97
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 22:01:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3F2AF307EEEA
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 21:01:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C41526FD9B;
	Wed, 18 Mar 2026 21:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EH6Gqkb1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C589F36B054
	for <io-uring@vger.kernel.org>; Wed, 18 Mar 2026 21:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773867659; cv=none; b=EFW22P+JuwrEGm9GCL+lcsVCozvDvKaKtZcj8wRdTL9PG9NDulS3c+3OvkpZJcePL3L2yx7w5FyWG0Q88l9YVjMF28aAbhB/XLjCj/ge7j0kW8Z8cEWTddh5WHYvCvWP6s5tq7G1zXmREZ5le1/oiYfb42zAQShKTivYiaTfcKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773867659; c=relaxed/simple;
	bh=7Rsb1sWvKCcw3sxC5j6cXEqvmRGgNLyMNWNG075vlM0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hEeg5EQxTrecuFMvcpqJmr2UZtmp/4MsC/vphbhLTxV/3ApJwzIIUPziiZKSiKNiXZuxPk3QvYbckBHxzlVd9JfklvYHrJ8XDGBFblHdHiqg7zVtytGo4inUSThTahQnlTwz16cKVL+DYsJYih6FDTuqC5jGoJrjZ/wdDWS0jbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EH6Gqkb1; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-439d8df7620so155123f8f.0
        for <io-uring@vger.kernel.org>; Wed, 18 Mar 2026 14:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773867655; x=1774472455; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PZ9nashXBwH2T0WFaLU17lHsgQjFMg59gZdS1pnpvTA=;
        b=EH6Gqkb1jptk2XYYbPM9omUORf9DWFdImFpHRBISPjl59ywXtIBMlp+L/ihTtx9len
         dKsRVSnKWrn+L1SokpzmzpgsZWfY0amYOGWO8uHweXkMap9aZt39IsyG1iTNs3xV00bk
         WG3pBYkpN0rDIeWulGt4YlntabYSHMOr5CH6QbQtglUwkUgNaPpoTL4W5bBxCoKgNdQ+
         RFuL5iPK9bpwIuYRS62XxqxWcpGPtmY4Er2/m1NVLEtS0IxJZbr4hxWWQHoQ0YQo0ZDG
         HvLmiuovw8ftnm5WoTE0tGE1MGUSynb7N8R7ctfGOdRX9MVHN3h6Fxej55lBmZRm2g3m
         nfFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773867655; x=1774472455;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PZ9nashXBwH2T0WFaLU17lHsgQjFMg59gZdS1pnpvTA=;
        b=n5nW2SmLF/51BihYN3a9jkIGoj9JWQkEF12mPnHKckVRqu/tz4cVCCBsBKnWxVpJjI
         743w66w1rqwV5HX0t2n+Aqzmp0TUbzTAR1fmS5AXwnaFXD9/e63lwRqmDJSw1JLqIB8v
         60v4wifTKf/W+ddYHwI7YCEQZHaIFaceWrFU3LV81Mdgj+9dv59fGx1ZltM2XPMwPquo
         eL1t8OQKjI8O1vKC2ElyG7Ti9wh4Rq0MBfEp6c90YuuZ2h6Z7y0cXVHQ0sclNcttH3gf
         TDrODRzDC3/h5B1037S82Po9RRcedmMSYlMTLU/9ihbui/0SmLEqA2kb63YlVY9duo4U
         2ZuA==
X-Gm-Message-State: AOJu0YwIAkmM3ftzAgBlC8xAd+IGl1ueOZUb6VRoqaGnkaGLMW3A9Km1
	ohaSwUB/k5u/2gztwO6ZBOXdwkiUwrzbr37YNzMptUa7z5wGfPFGfGJFkHavaQ==
X-Gm-Gg: ATEYQzwFzJ/jo1NJtpe5dG0rnzsPKoZVzRO21d77haBdUUS+2wxnupVqCSX0PzTWMI7
	+qJ2NAO03Nf6wVvkMdZGZ3Ti+I/W8gwTIDFdNwpQnWN6AXQJWpGtsofCC5HMPmlH7P3SOKCaKuQ
	xrN/NQ26vrtxceiWIlonJWHY/dcBLHhEVzm1koAfrI6fd+SIO8SHeRVug4UEgPdrSc283e0geAQ
	Tyq++21jAUeMZkkqXBqRQOYMPWQeWqaLeSF/hvXWtcQ+pSTuBRh1YBgx6MXdscGFNxMHocNGh9C
	YDBajhQp4i8CJ7ZS46tSlrN0+PfIoEUXWY0BGh6vmrY1Cu4BU1xWJTyLYYX94e8Xoxt8M1md/PA
	RmOsDKXOOrpqsVAiydUsep1rGS/BqV+TzYbYabB55dCnpanCwaJ9ps1hr9g1WG4sxDch0Xdwv3J
	7tdCHs0n91I48b10vjnFkQBERRHRQ60QAmp93YCWcDytSS2RQ6DFRkBwcIhdlEygHwK2g91f/Mf
	YzYLHrvzcyn40KElMvnXXpoxQq5f86H1fXq6J6vV6BzwwMnuH53+axQYb0tZ8FKUjc7X0Id3Jcm
	Fw==
X-Received: by 2002:a05:6000:2006:b0:439:b629:42d7 with SMTP id ffacd0b85a97d-43b527c6c7emr8560571f8f.46.1773867655121;
        Wed, 18 Mar 2026 14:00:55 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b51892161sm11110043f8f.21.2026.03.18.14.00.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2026 14:00:54 -0700 (PDT)
Message-ID: <577e741b-6b2d-4e60-98be-e71f40aaa2e9@gmail.com>
Date: Wed, 18 Mar 2026 21:01:01 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v3 1/1] tests: test io_uring bpf ops
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk
References: <8c9cb9cf824e09271df9c6d6d4398e514d9c5733.1773855222.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <8c9cb9cf824e09271df9c6d6d4398e514d9c5733.1773855222.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12750-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_NONE(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.997];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 610852C2C97
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/18/26 20:59, Pavel Begunkov wrote:
> Add some BPF struct ops io_uring tests/examples, one is issuing nops in
> a loop, the other copies a file.

My bad, ignore this one

-- 
Pavel Begunkov


