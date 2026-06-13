Return-Path: <io-uring+bounces-13717-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id ldSyAUBILWo7egQAu9opvQ
	(envelope-from <io-uring+bounces-13717-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 13 Jun 2026 14:08:32 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 26A2667E810
	for <lists+io-uring@lfdr.de>; Sat, 13 Jun 2026 14:08:31 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b="iN+z/kZm";
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13717-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13717-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B4B47303CF91
	for <lists+io-uring@lfdr.de>; Sat, 13 Jun 2026 12:08:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B39925776;
	Sat, 13 Jun 2026 12:08:28 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76CC40D589
	for <io-uring@vger.kernel.org>; Sat, 13 Jun 2026 12:08:25 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781352508; cv=none; b=jwspgWxnMFp+JNP0/gTpl3t2bqI64TglID9/3Ky0/JGcFcCltoVXqz8gHhOcVnx1SlwPh0sWfzb4sVMm059kxr/fvkkP+oTyMHFT+uoX0wweDS1H//zxBqs3Lu1VwxPRBjpuc9ZEfNB5zpacQgaT9EOt3ig6cS5JaCFq9EMytow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781352508; c=relaxed/simple;
	bh=yVlc5W3+SxXaEshwp83tbPBx2MgcwGxF/pE6hvk83no=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QeHxNua7yU5B+Ngpro9TJjsSZwpBD5kU9ihg2LZnhYxuFDxMvLdarsle1KwIgKpIwQ7roUoYA/GMMU1cLA1oZwL0OC7uTA5ehPlGHWW5mV4mpbEGXTESj8ypZ7CTKCLmX2NRKBdSezdIcK9GL8ewdFa9+hS2MyK2NK8T8L+BxdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=iN+z/kZm; arc=none smtp.client-ip=209.85.210.54
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7e6dcc22cbcso1740979a34.1
        for <io-uring@vger.kernel.org>; Sat, 13 Jun 2026 05:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781352504; x=1781957304; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NXX1mU/+MpF+a5qW2/kWjq06VfMikmiX2ddBVprJhe0=;
        b=iN+z/kZmVssQTTIxBfzIMPpi7dBYOZftvzkYpFB49h8xFlDAu81kVq/TiUwgTYtOiM
         Qm3zKFCM9QYyG3hagsqnkfPTyynRqBuNShpYbr6iVU3b0RtWrP4BJfYgMYJoedrSoAAS
         +/kyAVB8hT3+h+ZdW7GT8m7o5b2ZLjrR6kse8zqnSJtr0LxiW8UF2hNUXs/2+K5M1MkH
         krDn1l68eisL5T3AVIu48zL2tr1hw9S9goLp2ANmEp4WvtosXi8g2oHJ2VSVoSq8Rii5
         pePcGAjBkX9bhRTMt00pJULiiPM77UiRrLpQXtOW9pk3rMddZK3PROs1BzgBKk4ctVd9
         3jVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781352504; x=1781957304;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NXX1mU/+MpF+a5qW2/kWjq06VfMikmiX2ddBVprJhe0=;
        b=G9zNd4/Iz+ob+xiFR65cjHCuWcAufQ5vPI9BHtRYaDp4TeAWmiIlkNvgAR6LWvXVy5
         aS9yH3aID8aTpzLh+cFvqjFcASewVDNpHtcGLqChRWzuZo8kGVUuxfEE4ee4yYwJ69f0
         KRYqtsLFJQgC+6t3faTCjHbWf2ieuP2gNWVYsa/0BisDvdsz39cyqCnL0Whv8QsrZxj2
         IL10q7/xR2lxI3sGyI9kb98Y2cYKBKmvORilXGSANz0fOKflV8Jv9jDpb+lcJiA2oNYM
         CNBC6auQa4ob9HYOW14H/o72FOzbfo2BQNqx7ncPlSg9/0TZYSZIHc3tx3scfUZVZlm9
         ugUw==
X-Gm-Message-State: AOJu0YxCgYyF1eP9K8aofWchvOO+mni9u6aYii6GO6BqygZJq9HbXijZ
	DdwXsWNyHuPTCuDDfInL3trbTta16BUEMTqR3TD0WCSqvnPhaInFHlDoqJDjzrDZ7KY=
X-Gm-Gg: Acq92OGAcWPrEHhukDrUU3N7zcuPxeGSeI3DAwZmsSub1RvwyxwQw3tfo8iJ3WeyR6M
	F/5VhGBdZli9y+dS9oImiOJZc2zYKvLoTVvlmoaIjW64gtt8YBwNGO3RE1Hu0y+wcVo0Eo3BXz9
	8hFFpjnJFzGzEkNgHf7GF/umrPPHGtzZsIwQV/Oqt1aGuZtiJAV7HqnqH1C2Nyi4Vua3nmkvfxW
	WZtNVGC8XxbF69aB2Z2Amgm2SrUJJ8bWBUjl9xAqxjrrx4BrirQb78h6xE04Ewxu5bfjorjohJb
	6r3MEcvTTev5tdPzTRCUVbJr3qT3E16r+qBoefWMRRwJLnq74GSXpqtBWxNDB2OjgbWw4XEuAwR
	E0btkBFwZnn8VPglHxZzRFnVib8eEVJSHY5jU/RpBnKwDOQKLevXDm41xgxxrsqnFYEnKf5fUkO
	4Sji0LO4jAJ32YN8ztL0Am0zmkiYp4s88ojG42PKNVLJz9w0viYz+8RfEiynUE813LHyMMjjWF5
	PY86Gjw6Q==
X-Received: by 2002:a05:6830:2643:b0:7e6:de36:3f35 with SMTP id 46e09a7af769-7e7847648d7mr4607338a34.10.1781352504397;
        Sat, 13 Jun 2026 05:08:24 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e7814b1345sm4126631a34.8.2026.06.13.05.08.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Jun 2026 05:08:23 -0700 (PDT)
Message-ID: <9785f0a4-a85c-4f2f-9209-ab7da042d97a@kernel.dk>
Date: Sat, 13 Jun 2026 06:08:21 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] io_uring: switch normal task_work to a mpscq
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, dvyukov@google.com, krisman@suse.de
References: <20260612025125.1690253-1-axboe@kernel.dk>
 <20260612025125.1690253-5-axboe@kernel.dk>
 <CADUfDZqrbUyJR9yn8i+eVbVwEuvs7a4mR8kfXF_umnZ9RUAc6g@mail.gmail.com>
 <f230eccc-819e-4e64-954e-a25578888c94@kernel.dk>
 <CADUfDZq2gkcjsQxb_M82WnuFWjF5-kA3sa8wUAJoRL_84a91HA@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZq2gkcjsQxb_M82WnuFWjF5-kA3sa8wUAJoRL_84a91HA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-13717-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:csander@purestorage.com,m:io-uring@vger.kernel.org,m:dvyukov@google.com,m:krisman@suse.de,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,kernel.dk:email,kernel.dk:mid,kernel.dk:from_mime,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 26A2667E810

On 6/12/26 8:26 PM, Caleb Sander Mateos wrote:
> On Fri, Jun 12, 2026 at 12:37?PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 6/12/26 12:59 PM, Caleb Sander Mateos wrote:
>>>> @@ -236,10 +262,14 @@ void io_req_normal_work_add(struct io_kiocb *req)
>>>>                 return;
>>>>         }
>>>>
>>>> +       /* task_work must only be added once */
>>>> +       if (test_and_set_bit(0, &tctx->tw_pending))
>>>> +               return;
>>>
>>> Is tw_pending necessary? How come the task_work_add() exclusivity
>>> isn't already provided by the mpscq_push() check above?
>>
>> It is, because the transition from empty -> not-empty no longer works
>> for that, as the mpscq emtpies one-by-one rather than with a delete-all
>> kind of primitive.
> 
> Sorry, I'm still not following why the empty check doesn't suffice.
> It's true that mpscq elements can be removed from the head one at a
> time, but mpscq_push() will continue to return false until the
> consumer pops all the elements and successfully sets tail back to
> &stub. mpscq_push() will return true once when tail transitions away
> from &stub, and then not again until the task work runs and sets tail
> back to &stub.

Let's say the task_work is currently running, a producer is adding more.
It finds queue empty, re-adds the task_work. That part is fine, we can
add the task_work while it's running as it has been detached already.
The task_work keeps running and also prunes this new item. Producer adds
another one, finds the queue empty, re-adds task_work. This one is not
OK, the task_work was already re-added when it previously found it
empty. Boom.

-- 
Jens Axboe

