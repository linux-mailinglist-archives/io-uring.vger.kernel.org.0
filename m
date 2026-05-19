Return-Path: <io-uring+bounces-13433-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4A4cGE1QDGqTewUAu9opvQ
	(envelope-from <io-uring+bounces-13433-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 13:58:05 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DA1057E2AE
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 13:58:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 3C783300F63F
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 11:46:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5F2B332EAC;
	Tue, 19 May 2026 11:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fyaIlGIj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D0132E141
	for <io-uring@vger.kernel.org>; Tue, 19 May 2026 11:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779191188; cv=none; b=NB+/hNYDn2FHg++NOD/TMMOFWiykhmyJMMoTFx/x75Js77xWleff6EmScQW9C3uCxvqxfqutD24h88NiFGkyxet9NydD+MpEr91eY5bhgqJGAIM+gZPl84FnsR0cTof1p07Egzi6IybPPAwIz34vaZ/9wr0Qo6kcXtUH2Lldyk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779191188; c=relaxed/simple;
	bh=hDncoP6wUhrOO7HNw6wBMZMEIPeuvOboSQoIXCb8/Po=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nhyrR4WnwktQe08f5y3+GFt3S605SfOUzTlFbz0vr7ir2hScD+IVyoHoQeN/9193GTyuPFAfVN86eDn/oJhW5YRc8gSOFOqvyghc882NG4cXADS8n9yGW0KIjMegpJ1G9tQGUfkwCTkY5cXIYELF1Bl4ut8qDTMZPCzmcoWfUo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fyaIlGIj; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-44e5624c053so2035465f8f.2
        for <io-uring@vger.kernel.org>; Tue, 19 May 2026 04:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779191185; x=1779795985; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PEw0M2zsj3EzjVifOGhWM0yGOgGSRULUyqR8ZQQHmn0=;
        b=fyaIlGIjcJTMQtNNbQX0Q4mberRuQh1PLGwE55LJ/YDnGWV3bDQ5VqU83WuKLQoWiW
         ytpcWE7G/EPE6JtzUaoZiSOWsqf0t+o6VdHjkkb3RaC76MvOnmhNLIwLiWC2OEAJO1M5
         Juc/VaV8V+5/QbV5zIK91RlAinU2nvnb5Dbf9D/wAEcrc3KP+EXz5pLxXY3I3WTB/VN/
         c1UmUiqRzUORy3mLAMxGmwJGTwq5eKqolQ15P/p186S2/NZFba3EF5FAu5rPNsOyOjz+
         bUO3msc0iykvWUXTO25tAS8RAyQazbj2PJH4gTU/KC9aNat7qHIjnDhjixhF0YZCRGS3
         GHAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779191185; x=1779795985;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PEw0M2zsj3EzjVifOGhWM0yGOgGSRULUyqR8ZQQHmn0=;
        b=aErr5D9o6O5f6FX34dMgfUNT65EQRn1r3AH9jRdFC1lDpgAVDxpIg6a6rF1YbFxzh6
         PIVM53O8N44W3XOGcykc22539l60WY2kcj78u/4hZIaArlsoIcqyyeX/sN6zdJr3BYf/
         v69+2VCJ8cwhzK/kyOQHbLNSOyIhvyvkE+UanJbyoSxpvo2jAyTuk/jLDHc1Z7/DfAIr
         X2IZm2yD1k56cH1J1wE9/lJka4siu4w9zGCjLhYCcgWPPahH/jw5f4Uyj2xhoyisShtm
         XcusA/uc0AMJezl1aPzgrqG0001nvypb95ndoaD5Ty2OK6QzSv/qESlBT+mcXU6hXP+6
         hV8w==
X-Gm-Message-State: AOJu0Yw08o9Ar/Zo8GP0bVET8tsnVOUqcWbrZcnSfHCNfT9edXbYQcP8
	8CRsZknnvAZmbSsDZ2gQXlD6QuGxHCUgeE5J+gjUa1CYu99jC4U48LT/4186cg==
X-Gm-Gg: Acq92OFLLa+DNADHKvn253+BGmDJdevatCyg0zC//vV/HCjQO8yxno16sjPrWKggZyY
	BzGGU+SpI0pjiFXzjPkiEYf7dgrKwQF/C7it03H2KdDJUgMABU4eVnfOvFuWfIpbH7AQBlLKhwR
	x+6lYGk8U1Wnm41/6CeoxmglbLkdGH4r1ZyytGbyQvvQ0YebBWdrh0Edyni9yrG6CBPmGloB1su
	siYS+HNnm7TkuXH7Oy/cNxsCsNEDEoDVTouCLLdSfTsayDavFlFkZruzbtV/WA6VbzCdMA3UT/h
	l2UiujREEZf9AqvJut3fD+NkHdBSis96Ghs2tbY55/kLVOxifWRVoJNahnpW+IhgkYc/3Lx/O7A
	WVhJBdNuYSGazOmAqqHgK8DPRp1c6F36mNk3UOF088np16Qw/CSbeZUP/U32mIyFnGC/UiG4Y1T
	iQ/b3VM7GcXOZIdYxRjteC3T1NFCc65UH8u8BJri58bSmbpqs+L2eceWOxc91QUw2/MrTlaGyuT
	H++btbD/7RGy/80ycXpDfMJVxhLs1GAejqPwYhdHe/0dWJClyC9Sft+2BamJSkWhWF2e4iem9iH
	dcm9/wCq/+Ah
X-Received: by 2002:a05:6000:4383:b0:454:1e65:32f0 with SMTP id ffacd0b85a97d-45e5c59fee0mr30666607f8f.10.1779191185357;
        Tue, 19 May 2026 04:46:25 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da0a178adsm47570648f8f.18.2026.05.19.04.46.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2026 04:46:24 -0700 (PDT)
Message-ID: <f4dd9cbb-c0fc-4170-9dc6-014cfc267f44@gmail.com>
Date: Tue, 19 May 2026 12:46:22 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/8] io_uring/zcrx: add ctx pointer to zcrx
To: io-uring@vger.kernel.org
Cc: netdev@vger.kernel.org
References: <cover.1779189667.git.asml.silence@gmail.com>
 <b60514b3d1bd92f571e3bd91751166f8c3599256.1779189667.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b60514b3d1bd92f571e3bd91751166f8c3599256.1779189667.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-13433-lists,io-uring=lfdr.de];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 5DA1057E2AE
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 5/19/26 12:44, Pavel Begunkov wrote:
> zcrx will need to have a pointer to an owning ctx to communicate
> different events. Reference the ctx while it's attached to zcrx, and
> rely on zcrx termination to drop the ctx to avoid circular ref deps.
> 
> Co-developed-by: Vishwanath Seshagiri <vishs@meta.com>

Vish, can I have your sob for this and the next patches?


> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov


