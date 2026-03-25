Return-Path: <io-uring+bounces-12853-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0JACKRTbw2lwuQQAu9opvQ
	(envelope-from <io-uring+bounces-12853-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2026 13:54:44 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 51CC932541A
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2026 13:54:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BC9E1339EB96
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2026 12:15:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44D053D9DD1;
	Wed, 25 Mar 2026 12:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r1S7SGGm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050C13D9037
	for <io-uring@vger.kernel.org>; Wed, 25 Mar 2026 12:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774440845; cv=none; b=MzBKXCSN63so6CbMEglvETwPWnLx0EVSrEVimTULdmdMd3SuM5KpNxWwe+NEiLLSrb5Qpud16UIm5kv7usylRe51ImChnt9X2Iq+XHge5gOoL7MP8HA3OW2CxpSk+QB2pDQji3zRS2xxGPHRLE2XFpFqIe8xoIhoGti3p3RVETo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774440845; c=relaxed/simple;
	bh=IBlgjftKWIzJoKPeHDWZXyguS3yOOLm3fUl93OEa0Zg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lHNbDAWphVDhhA1nfmneLANZk+5J87e/7d3bfNvKyrwJfYbfZVK/IBzWxpGsLjF3LNzrCetAVII5i9f4nirgKmFQKy+Ou+gdtzzmLO+JLKk5tvd/wK9qi6zW+MJvlOGExxlZLf8TjB+TI0GOBaXyFUkjPo4GitbWS2kaTJ0SEPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=r1S7SGGm; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-43b4d734678so2250952f8f.1
        for <io-uring@vger.kernel.org>; Wed, 25 Mar 2026 05:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774440842; x=1775045642; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hfPA5C1hRF77uQdfUHH+kcK62hjQci3PCygqqe1s0nc=;
        b=r1S7SGGmpiL4Ebn5JDqRyh+0v9JhmzsZ2/tsNdRX4iL4UuQBQg21/nAB9S1NhhdGpE
         mGkTxsg/byy5eQGv1gGRgajk7CgnA+PFwn3B4tLiSUU2wSf10C3RW6DMdcEXz22l7Bpz
         w6OwjrOFUn/l6cl3Umr9yduxZJlxxd9yvmdonbb7vmkG5Ly1XuoDeMSjsYpLgkfnet6b
         OS6Jd++o2mptWy0DjHm07hhAReCfaD5MKudoJa6zkI5/eTzMZsCTUvAALIgme/C1ELC7
         O79HKGn29TXLUrqcpdeTkR9AOgpGK0+VVfikhMSPDVHs5RpmbwU5QVlZwzXHiGMFytDx
         79tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774440842; x=1775045642;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hfPA5C1hRF77uQdfUHH+kcK62hjQci3PCygqqe1s0nc=;
        b=goflIGGKmbo4c8Mwo7yTeFclWIHVKrUFiE9jf7MKOTJwfJH6Z3SwTcfDv8Z9xKf9tn
         56Dt7wFNsdyvlCpjWR3FJ0X22W8uE6dhVNeUynYWGRKXsR/w2C136bqImE/Ab38Xlne8
         GaQ5+et1nm1FhD2LptBbGDaXK74w31y4TJ9zsjKYEMrT8gglbeNm9sw4luHs/HATnCdJ
         fNqiHMag5Eh11XjQDm91I2YbaeUb4Pioim0jGSYP5vTk4OQOZ4iKl02TlazmDxUS3DjC
         OQZ8WUYyhEri3geLQsD5udiujM0yEUFGl4wItIi/srijOmIn2NkZgcxEEtFiUkyQTG9H
         0oyg==
X-Gm-Message-State: AOJu0Yzr+apIYfF6f/vmwjdEXdOmPjuQrWyzveUUi7FIyl5Z6qj71JTT
	KruYhJ+gQSn4/A4l7UoGdNQnE7CaDfPOGCuVH18eX1IJlYaJAiqVZAJ8ncgLow==
X-Gm-Gg: ATEYQzyMCJ5JTeko6rmLkYnlmftGblJv6QeVxPgkfpscXZ3HNdKAwBauECZZoPkTtup
	lQjjBCXpBrlaRVZacIHm8LttrrVImVRyfZWsYD/j5FAVEjP11ZrrMC8ZUqUz3UCjY9sMadg7/hn
	+t2N68bKASKH6iJoPaEata4EzWwkZH1L4EIdqsGQtMTLJanysbluCzmjMQx7l5EPevYAAj2xrse
	izbaCmo+kfkzoyQyjp5m/4dEIANJFIaHhRX0r8F7/s/YB+CmgiOVjrQi/RMfXcVyjt/iOkFlaSI
	X/DM/IHzlvT8exkyhWCeNB/AMBHWNdsjmdo5Axg7SGsrhIpQFLvhQCUile4fytgnF91GWxWeYin
	KWoQmogEDo1ZjJD90/zqYdABkiPw7Rtefzrq3nnipWN+2ozfee9f+YE9h79DC/SM5GJ6NJkrSPh
	RD3Ui5vwDfefVOyidvKInYSTXHee9fjBgANWhB1JGpm9AkRLNlloRuE2qd3bwbc+HiE51k3+zKB
	895Z6j6vtHQVw8Migtd3DvcjzklUlIoLapgYrI=
X-Received: by 2002:a05:6000:2401:b0:439:b6ae:5d5f with SMTP id ffacd0b85a97d-43b88a1a8f4mr4884625f8f.36.1774440841891;
        Wed, 25 Mar 2026 05:14:01 -0700 (PDT)
Received: from [100.112.116.159] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b64714decsm41468669f8f.31.2026.03.25.05.14.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2026 05:14:01 -0700 (PDT)
Message-ID: <3aa1fb50-3a19-403e-99da-b8a12fa54104@gmail.com>
Date: Wed, 25 Mar 2026 12:14:08 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH io_uring-7.1 0/4] follow up zcrx fixes
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk, netdev@vger.kernel.org
References: <cover.1774439286.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1774439286.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12853-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_NONE(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 51CC932541A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/25/26 12:08, Pavel Begunkov wrote:
> Follow up fixes for the recent update flagged by review.

Actually, I'm not happy how it interacts with the nodev mode,
I'll send a v2

-- 
Pavel Begunkov


