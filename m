Return-Path: <io-uring+bounces-13736-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id a2fJH7ZIMGpkQwUAu9opvQ
	(envelope-from <io-uring+bounces-13736-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 20:47:18 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B2A168946B
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 20:47:18 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=IINBHRzu;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13736-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13736-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 30772301106E
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 18:47:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEA0B379EDA;
	Mon, 15 Jun 2026 18:47:16 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86233AB460
	for <io-uring@vger.kernel.org>; Mon, 15 Jun 2026 18:47:14 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781549236; cv=none; b=OI75MNLRojKTgeG7YQm1oMjrklyWFBJF6tUN5mktBA9kvXTDcCSU07EFiz7IHZm839HdcJgD3ftA+XDeRadTaWLRqtGPw1wZCyJT7SYjIuI3a0grKX1FQK0HudxKdkG/bdmG4Kn/F8fdjWPzx2GXlK196UQXkNO/Kcc11u4EB7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781549236; c=relaxed/simple;
	bh=t4qo/AFCkNd0sE+uKMV3a8hoTF/GfrXav/5xixzYZvk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bJTQhFDmdN0bWcZqhANTZw9p/zd0PxzidbVQPWHt25YzT2XQQYlFVh534qZAieft1kjfzblr/VAaeGG0oWwyM//Aw3JdkIJjHWEZOZHqfHW/brFNotrLNazLJ9Qfbe7gwqYAjyXCCFDdiBmTfkIwvLFvi9uhtnpXMSSN22s51VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=IINBHRzu; arc=none smtp.client-ip=209.85.210.53
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7e6f586a0d5so1870996a34.0
        for <io-uring@vger.kernel.org>; Mon, 15 Jun 2026 11:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781549233; x=1782154033; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IWpzilE8x53rK//RFh1l8SsyFfuYxxIFY963sqvUkfY=;
        b=IINBHRzuMslYXhuJTKuOKCWrs+Grxx5ikKUFJGwg4o0e9SZU8V3gbI+2B1sC7cDBL7
         2u99CYapfnSq1hPu1dh7DQNFH7hUh9B17cA9S3ErWqj1wGYQLZJuseY1HR3sE720EKsg
         u1Z0gwhbYrlMdzmyWrl0mRztr1mOV8HRHLdRDv9sdvOyLmMPqnZ/G2pvH7cj+Z+7WSHo
         gpMun7i5N8YuqQK2e9IGR7PdNsuWb382DiPBJduz3M5doJDg71UhFGkqYYUOqiIAlt3g
         ltuJ4hGGqkTy2KmZmdyGgs7IbghdrjrniBcpe4U1xPN6C7EyEzPW686816/19M0mUwq1
         PDvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781549233; x=1782154033;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IWpzilE8x53rK//RFh1l8SsyFfuYxxIFY963sqvUkfY=;
        b=pOcPxL6W701TP6lO/kDNDGHI3KTKNEv0VyVylRCrYP0QSHsC0JfUXtrUyXLGbvb8OC
         pizqaB/rFAUqxAhNjtMnIlFrdfj3kKr4GVIKT94zpl3jr1F2lA1eTrHvGh8ARI4qAgYd
         b6NgRbVx1Z8vMseLGew4OtuWZr0bJk7Jkv8jSEmkfgkxwEvEQS2n7aSmQPFXmMeOHvRo
         rLlsgZrQX3R9h92yP6itrPfR8iVBsoa6AsAzEJsGfKwwxGLkZrDHA4C11KcIdZQvUyJA
         9yIWDYpZE4CWorvEBdsDmmJiNCMmMcfucnuFicwefMD6Jo8WfRBVJUMPHU25obzXOJ/q
         1DZw==
X-Gm-Message-State: AOJu0Yw6AtGl7NAuOiKdYDG5lAApcB5B/Y5WR0h9lCXd5iY4o38JnfzE
	5q23ci36BiOZOJcV/r+774zAzHYEBRvVPvcPPN0c0jT8Kt00xNrLWKybzzTVoJ8JUGeTBI8snq5
	7f7Uc69o=
X-Gm-Gg: Acq92OHiUhPzb81KbAfvBAHJX91AdgfZGAzexssZ/jbq14dYM7fk2mEVBYiBZkyPSVC
	nRd2yOf+qL9a7pwyx/agc3TvbJ46F0Oa7VDWjFRqby8TnnzDof1k+6ZbBnt8nBooNDOEKgOUrq4
	Kv1yqWpC/40cIF3RbDmSkUIm3l3chTVK/qjQ56Js2oxLObew0AFvY5VBcJGOhpJ85yBSVP9DCKK
	E7yLAb3EjVZ15mSXoZkmcYOYKTBPWvPD6qew8qL9HP0aujTBrAi2g/mqfetVIzM6ypalyl+YBHf
	EYH1c+TATN+x0PjyECuLxyj9vmOAuyWHXkimcKCZUWdsK+qS0IlDl0UKVhcY2cgPwfXJzjh8LdC
	Y6cUCdhOYJVzENeueQIEf8XaNH3GRKJrJ/Xiwcg0W5MxM3zFqcXSUWzeTE43pZYOi3lpwPB595T
	Qxm8wWiEe5DneK+dT9Zny914plVRAnBeODtRLh9VUEaY0JcGDIRo+mDuHVqy3z+s+HKz06nriSG
	APV6C+Q
X-Received: by 2002:a05:6830:2696:b0:7d7:4fc7:21a with SMTP id 46e09a7af769-7e78e6f0031mr7889465a34.13.1781549233559;
        Mon, 15 Jun 2026 11:47:13 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e7a3c2b08fsm3638160a34.8.2026.06.15.11.47.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2026 11:47:13 -0700 (PDT)
Message-ID: <d0f05189-6192-46ca-9caf-2c71c07ddc4c@kernel.dk>
Date: Mon, 15 Jun 2026 12:47:12 -0600
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
 <9785f0a4-a85c-4f2f-9209-ab7da042d97a@kernel.dk>
 <CADUfDZotc7tRWiYoDGu4nGdG=AR5wmZDyw8C1-Kp5BhxL=ZEmA@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZotc7tRWiYoDGu4nGdG=AR5wmZDyw8C1-Kp5BhxL=ZEmA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-13736-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:csander@purestorage.com,m:io-uring@vger.kernel.org,m:dvyukov@google.com,m:krisman@suse.de,s:lists@lfdr.de];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,kernel-dk.20251104.gappssmtp.com:dkim,kernel.dk:email,kernel.dk:mid,kernel.dk:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 0B2A168946B

On 6/15/26 12:33 PM, Caleb Sander Mateos wrote:
> On Sat, Jun 13, 2026 at 5:08?AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 6/12/26 8:26 PM, Caleb Sander Mateos wrote:
>>> On Fri, Jun 12, 2026 at 12:37?PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On 6/12/26 12:59 PM, Caleb Sander Mateos wrote:
>>>>>> @@ -236,10 +262,14 @@ void io_req_normal_work_add(struct io_kiocb *req)
>>>>>>                 return;
>>>>>>         }
>>>>>>
>>>>>> +       /* task_work must only be added once */
>>>>>> +       if (test_and_set_bit(0, &tctx->tw_pending))
>>>>>> +               return;
>>>>>
>>>>> Is tw_pending necessary? How come the task_work_add() exclusivity
>>>>> isn't already provided by the mpscq_push() check above?
>>>>
>>>> It is, because the transition from empty -> not-empty no longer works
>>>> for that, as the mpscq emtpies one-by-one rather than with a delete-all
>>>> kind of primitive.
>>>
>>> Sorry, I'm still not following why the empty check doesn't suffice.
>>> It's true that mpscq elements can be removed from the head one at a
>>> time, but mpscq_push() will continue to return false until the
>>> consumer pops all the elements and successfully sets tail back to
>>> &stub. mpscq_push() will return true once when tail transitions away
>>> from &stub, and then not again until the task work runs and sets tail
>>> back to &stub.
>>
>> Let's say the task_work is currently running, a producer is adding more.
>> It finds queue empty, re-adds the task_work. That part is fine, we can
>> add the task_work while it's running as it has been detached already.
>> The task_work keeps running and also prunes this new item. Producer adds
>> another one, finds the queue empty, re-adds task_work. This one is not
>> OK, the task_work was already re-added when it previously found it
>> empty. Boom.
> 
> Ah right, I forgot that mpscq_pop() can both return a popped node and
> set the tail back to &stub. Maybe it would make sense for it to return
> whether the queue has been marked empty and break out of
> tctx_task_work_run() in that case instead of relying on a separate
> call to mpscq_empty()? The atomic RMW for tw_pending every time the
> queue transitions between empty and non-empty seems like it could be
> quite expensive.

We could tweak it like that. I didn't look too closely as this is the
!DEFER case and hence a lot less interesting, but if you want to send a
patch my way I'd be happy to stage it on top.

-- 
Jens Axboe

