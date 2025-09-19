Return-Path: <io-uring+bounces-9850-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A7B6BB89DAE
	for <lists+io-uring@lfdr.de>; Fri, 19 Sep 2025 16:16:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6EFFC1C859FB
	for <lists+io-uring@lfdr.de>; Fri, 19 Sep 2025 14:15:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4B7E313D77;
	Fri, 19 Sep 2025 14:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZcxuOw4J"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E736313298
	for <io-uring@vger.kernel.org>; Fri, 19 Sep 2025 14:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758291295; cv=none; b=tABR7Vmb7D6/9ZgL0TADV0hE3/XDbjVPJ9qMgQoR8Hiz7B/TmScRv5rGujos2Cgj7SR2tE4RSbalKwvCFKNOkzLgjYXSTHxpZl32yVaIDdfHaNjBKQoFD5Kw9QMEb+oTCeae8pv+mlDuvBsWBTtLl3YcGhExSzlRbAF+CWoGol8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758291295; c=relaxed/simple;
	bh=qeAufkg7QZCzJ/YcQVklX6SG4NUyYjZ8C2iK5iG4gjM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ry9yoMxNl6hreQnWJuHL96uDC8kHDQtEHtCNKCgJ1/xuVaDeOLr9TqoHnk4A6BBe60QcTGyNPH38Rwl1UItPrO/es4r9oiAG8cNgrIWtmAOKkaALFk86+pvITXB0f3mcG3sLKu72RvvwkRwBZXNnVdrKlIhbr1x2ieNocsi8shg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZcxuOw4J; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3f2ae6fadb4so22940f8f.1
        for <io-uring@vger.kernel.org>; Fri, 19 Sep 2025 07:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758291291; x=1758896091; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FmAW+IE9fUefZ3p5bWlkWLpFxUTqXPTiNOawX0VgkMA=;
        b=ZcxuOw4JAcm7XPmNTFjfuL78tjwSaf0WeVXQgQ/VU2wvmwYUFX0/edldAPw72OKya5
         VVTRndOebUTkzJWb3jRGIrkJ5YBKAMcASvq+olpfQV4pTvp5U3qSwTHLW8/ELqNJa78S
         IWhM75Jaoga8sy8pENDaOuxy+5duKxfByLfST+46Pvjq6Y4fY1xKSzPFdjLg2WDbakOV
         84j+at3Y0zBo2wC8pWhgKvObOBApCqKtPLuJk2GzkyXYIYW61HZz3nZqhvz6nHRpVd8E
         5tlJCXNSIcWZ/f57ihnHaXoTI0raGYtzNRfynYxsxV91vQCjxnOr/aF4ooLv6bp4pihq
         h7lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758291291; x=1758896091;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FmAW+IE9fUefZ3p5bWlkWLpFxUTqXPTiNOawX0VgkMA=;
        b=OGYQvnUrosQ0EwZLtiuv0tR9qQXUfnyagiynfTHAN1kLoSETPga0gG4gqSkfJmd03d
         R4IWP8OjSaNgotlA4T5LQYmrvzHHox30AGAmR6SUsmuMEB3apI0QYlzZDIvqlud0xVuv
         dHi3L8PpMfrkk/eza29fste+M/kdbXUIXHm6rqPH8MTgTQRVVUpT8kcDMIGXjihWjOqn
         mF5YERIPKTO9jjtYh1dgHzti8p2o8Ypxf/i9nQ16eqCgG+iA67wNmBkQvixV/ucLC83K
         dxd5FArGf/qk5qSkPX5JUbMqFR+AZX8SXPS7kAQDuIUdgqyrNsNNLsTAGiLiixR5YszO
         Y5Ow==
X-Forwarded-Encrypted: i=1; AJvYcCWomaHY7jrdtMzpadgUxcZSK77sCq4HZwxDrwcLuDDdrBbNtvdFxT2ZIHtIr0ybzrGtizitIb5bDQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1XsLggrBQdk4HjR5CgdsNoy5Z+i/aHu1Qv10nfvYxeOIE7ilE
	fJbUWMCIfyTKIN+evj9IH0W3e0Zi8WllzqkPKJ3iHYBKMzSFX4N9YNJk
X-Gm-Gg: ASbGnct9sh+ekEHuNLPcq3rMCARtZaO+iKfGaaH7pO+rKB2U82Xkly9J4oj60OvN1Xo
	EVoLyG4cAV4AqEgzqUHjdIElmetsg14ncOmzmcGrvQjWQ/p/nTViPQVgFdmCzo0Bwy3lk/Bl0d4
	5Qesli8LrAcirMymylxO7PDbIdjS6FUK2WTJx9S9rXEnern4icACRQese6Oaxmv6aPyKtfbKTCF
	yzUZJ6Z8CceBNL4dpYb/ytiKpRdhCN3nf83d+9sY6yFd0gbu1pwuCoI9ZGOPSYPkY9GK0ANVBd/
	H6nV5kAhqTCfDgyxi+BvdzOQ5ZRuQA0135HJ2JRRgRGqK9IMYEyD4am/yot8Qk5YxjJ6rGvP5JS
	lhT6MvNK0uNeStfu0nKA3InK/Hw+0SIklu700iR8j4/HHwkcDZ9iVskICMRerLcAVtDdy7iw1+w
	==
X-Google-Smtp-Source: AGHT+IEKG3p95DmO2+d62WyufSZPraLdR0G0KFZhwQl7DWDDpR7QiQZ2mlLL4Gj3Vjrq3bna+aTKhg==
X-Received: by 2002:a05:6000:1a87:b0:3e7:60fc:316f with SMTP id ffacd0b85a97d-3ee852a423cmr3413563f8f.45.1758291291281;
        Fri, 19 Sep 2025 07:14:51 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee07407d0asm8076084f8f.17.2025.09.19.07.14.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Sep 2025 07:14:50 -0700 (PDT)
Message-ID: <1e5ff80d-73f8-4acd-8518-3f10c93b4e40@gmail.com>
Date: Fri, 19 Sep 2025 15:16:26 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: fix incorrect io_kiocb reference in io_link_skb
To: David Kahurani <k.kahurani@gmail.com>
Cc: Yang Xiuwei <yangxiuwei2025@163.com>, axboe@kernel.dk,
 io-uring@vger.kernel.org, Yang Xiuwei <yangxiuwei@kylinos.cn>
References: <20250919090352.2725950-1-yangxiuwei2025@163.com>
 <152d553e-de56-4758-ab34-ba9b9cb08714@gmail.com>
 <CAAZOf24YaETroWiDjmTxu=2b2KVTxA1+rq_p5uxqtJqTVBfsJw@mail.gmail.com>
 <CAAZOf251fh-McW=7xdEQiWyQ-XfOC1tRTUnyTD4EHVaLG-2pvA@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAAZOf251fh-McW=7xdEQiWyQ-XfOC1tRTUnyTD4EHVaLG-2pvA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/19/25 12:25, David Kahurani wrote:
...>>>> Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
>>>>
>>>> diff --git a/io_uring/notif.c b/io_uring/notif.c
>>>> index 9a6f6e92d742..ea9c0116cec2 100644
>>>> --- a/io_uring/notif.c
>>>> +++ b/io_uring/notif.c
>>>> @@ -85,7 +85,7 @@ static int io_link_skb(struct sk_buff *skb, struct ubuf_info *uarg)
>>>>                return -EEXIST;
>>>>
>>>>        prev_nd = container_of(prev_uarg, struct io_notif_data, uarg);
>>>> -     prev_notif = cmd_to_io_kiocb(nd);
>>>> +     prev_notif = cmd_to_io_kiocb(prev_nd);
>>>>
>>>>        /* make sure all noifications can be finished in the same task_work */
>>>>        if (unlikely(notif->ctx != prev_notif->ctx ||
>>>
>>> --
>>> Pavel Begunkov
>>>
>>>
> 
> This is something unrelated but just bringing it up because it is in
> the same locality.
> 
> It doesn't seem like the references(uarg->refcnt) are well accounted
> for io_notif_data. Any node that gets passed to 'io_tx_ubuf_complete'
> will gets it's refcnt decremented but assuming there's a list of
> nodes, some of the nodes in the list will not get their reference
> count decremented and 

And not supposed to. Children reference the head, and the head dies
last.

> that will trigger the lockdep_assert in
> 'io_notif_tw_complete'

Did you see it trigger? If so, please attach the warning splat.

> It doesn't look that this will have any consequences beyond triggering
> the lockderp_assert, though.

-- 
Pavel Begunkov


