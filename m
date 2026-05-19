Return-Path: <io-uring+bounces-13443-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EOSWAcuSDGp1jAUAu9opvQ
	(envelope-from <io-uring+bounces-13443-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 18:41:47 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 472B1582897
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 18:41:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C0362318ED58
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 16:09:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D5013F1AA6;
	Tue, 19 May 2026 16:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="U9VlBf1d"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C035340403
	for <io-uring@vger.kernel.org>; Tue, 19 May 2026 16:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779206949; cv=none; b=i15v9F6iynCIaC0rdU68nvQMX8FzUZsUNknluqlK8PoO+e3ccycaQCfrL5CtbhB6Yo6fklCa8NGbureQzsPURKhh3iNZoxjxkj9gGjjEXAqolQhtEhrkjm4gn6np5jFVE2B5/1R0I+05yyoXjBXNs6/FrsITPSnsWKNQ+iFeXxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779206949; c=relaxed/simple;
	bh=Ok8Nr17Ohg5okD2zAIP4CmzIfheXu62v7JM3b3yGU/s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QvZ0pIt2H9HtCjg7IUdwNy/GS6PFrao8VJoQHhUgfzHFrmMaUmECT/gXUGv3fB1Uw6+SM1B7UIwqzr9lwBefSPk30uArCW8O0A161YaDFw/qz6JRTEXWZmUCZzQ27L1ImVismSM2D23SkH5pH1jAxBw9n/F7BkIpc1/XH1l+rJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=U9VlBf1d; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7dca4debedaso3979773a34.2
        for <io-uring@vger.kernel.org>; Tue, 19 May 2026 09:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1779206945; x=1779811745; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SlXePlUJFCKP1Nex3d/ApxGqDNPQ43FckLkYRQKxUgs=;
        b=U9VlBf1dRrPv/fyNVLHxDqKp7wiffZYGDDUfwPSZmPQnUPWnSXyIe6UBRFICnTVm6A
         sUjNtNe8xCxPlcocHxYG7ZbAk2e8dt0IW4IYKbaW717VBwnydUqeI+8m/yj1ypudBdUK
         6bAWrdulrRJVrue/RCAc2lly2fB0VWNtI5zP7E2KVrs9WLPh1Wt44Fx5DfwfZMrB6KLg
         UzqlK539Voczy0GINkSWpB2vi2DNLg/Ob29ZkuX5tkDbWJ3nv472G7LoigURV/Yg1SDR
         3S9BjeQwy/QZ7DUfyDDvYk60bOkvQ5EUS94Vc2hNTHrv5dcNRo5cvu+3zF7yOSnpn5D/
         B9fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779206945; x=1779811745;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SlXePlUJFCKP1Nex3d/ApxGqDNPQ43FckLkYRQKxUgs=;
        b=siUeKomKTa2I0zXLskcJmgFtIUwXXl6seZTXy3r6fyPdgIVC4UdWBiK0zFI9T5FPF4
         mtJR6NyMBOnUvKXomhnlatRAXPEytRCdKzMDQtkUqLEn+WzGb69aLk6NdIPt9FE5PGuF
         pptUQHcrbrmUyLf2nQfTYpNq6kS8zERV0LSW+X6fC2czTrVEgLb0rrM30qigupV24IFC
         HILt4iOzo4wekMhXIqQ+EHJTd/XPg/vU0EwejJoZQbVGiho7KUdC9KuouIdrPWT68HMa
         NESZ5y2HKtINzHb5StXULdLk04ohEtCLmhfluWzikFW/ZQ4+USHtEdVX5JQrzY3XWgtz
         o6nQ==
X-Forwarded-Encrypted: i=1; AFNElJ8JsAt99tvoxuy7XtPylWI3L4fPEW+tFV3a6i1jqqveX6y5SckOWzPJMRvW4bh4efg3SEqOJidyjw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwxLxdItc/PEPEd0g39mVXFdF38hcwr2TsxPzOTB5ON1/w+fcJb
	tEGItCGZFz78Ki3hNBYE9vt4ikxTkthCSPx5oAlUIlGS9KIoRj3a8S1lXiQvi6Y4eus=
X-Gm-Gg: Acq92OGn5S8djD1CuBp0hjWrXw7wDv/DVcoEW+G6UxJ+mYWbdV7VzXvoEeFrIlOEg1N
	hX3PMtLWvJ6OmhF93Gpgp3iDS9dvvOL5Tufb6fWrfi3zli+iothFToNS2k1xapxhuMXj7muNwQN
	5Na0/dJyTaSehlMJGmViJx2Y5oQNONJYeRvaOmFffSHOWvhtLAn8mvrE5fuS14bXitEjRLOJh3p
	HtsIEl28UsFK5T1SjhKuN0j+pdgYwpEFCWb9mf35X1qD7L8fyRZpLdSIIIy6h7UsEbxeMMl03K9
	3CJUg4XOMI3nGIuIf4uD7jpRDPuRDmnBEKVAx7cUsPv8Z0+1+tTzontwJu9KoDFIhWvBP9I68sc
	PysTSkri/oc1cW9P+SJMHJU7IdB1UMli20+NlX+cj1NevfhirickaLo8goWJULGZlRDZJR382Hx
	1OQI32mTVyyZMzSJeA/xXdWp1ZkiW/0lpLY1nMbHj4m/+e+nlpeRq8e/ZHqNkmyWG6RdFudlPCW
	VYEM4Ey
X-Received: by 2002:a05:6820:190a:b0:696:6bc7:696 with SMTP id 006d021491bc7-69c942d61b3mr13693809eaf.14.1779206945467;
        Tue, 19 May 2026 09:09:05 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69d04655cbcsm6936288eaf.8.2026.05.19.09.09.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2026 09:09:04 -0700 (PDT)
Message-ID: <1517926a-4a9d-4c55-958b-b9e23756dd96@kernel.dk>
Date: Tue, 19 May 2026 10:09:03 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/8] io_uring/zcrx: notify user when out of buffers
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: netdev@vger.kernel.org, =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?=
 <cleger@meta.com>, Vishwanath Seshagiri <vishs@meta.com>
References: <cover.1779189667.git.asml.silence@gmail.com>
 <35cd307a03a43583838a2e151fc641c69abd786f.1779189667.git.asml.silence@gmail.com>
 <7bfd707b-1e21-413e-a2e7-71e8df3e43d7@kernel.dk>
 <6d1187c8-ba4f-41ad-b692-351d8b072038@gmail.com>
 <a2a92049-0974-478a-9297-76af96b455d8@kernel.dk>
 <c8a21efc-1443-4ff2-ac53-7846533a26bb@gmail.com>
 <2305e4d6-55cf-421c-94b0-ad8aae8db99c@kernel.dk>
 <7db0d602-bbbd-4554-996c-1dcefd69e2bf@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <7db0d602-bbbd-4554-996c-1dcefd69e2bf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13443-lists,io-uring=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,kernel-dk.20251104.gappssmtp.com:dkim,kernel.dk:mid]
X-Rspamd-Queue-Id: 472B1582897
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 5/19/26 10:04 AM, Pavel Begunkov wrote:
> On 5/19/26 16:43, Jens Axboe wrote:
>> On 5/19/26 9:40 AM, Pavel Begunkov wrote:
>>> On 5/19/26 16:37, Jens Axboe wrote:
>>>> On 5/19/26 9:30 AM, Pavel Begunkov wrote:
>>>>> On 5/19/26 16:26, Jens Axboe wrote:
>>>>>> On 5/19/26 5:44 AM, Pavel Begunkov wrote:
>>>>>>> @@ -1126,6 +1142,48 @@ static unsigned io_zcrx_refill_slow(struct page_pool *pp, struct io_zcrx_ifq *if
>>>>>>>         return allocated;
>>>>>>>     }
>>>>>>>     +static void zcrx_notif_tw(struct io_tw_req tw_req, io_tw_token_t tw)
>>>>>>> +{
>>>>>>> +    struct io_kiocb *req = tw_req.req;
>>>>>>> +    struct io_ring_ctx *ctx = req->ctx;
>>>>>>> +
>>>>>>> +    io_post_aux_cqe(ctx, req->cqe.user_data, req->cqe.res, 0);
>>>>>>> +    percpu_ref_put(&ctx->refs);
>>>>>>> +    io_poison_req(req);
>>>>>>> +    kmem_cache_free(req_cachep, req);
>>>>>>> +}
>>>>>>> +
>>>>>>> +static void zcrx_send_notif(struct io_zcrx_ifq *ifq, unsigned type)
>>>>>>> +{
>>>>>>> +    gfp_t gfp = GFP_ATOMIC | __GFP_NOWARN | __GFP_ZERO;
>>>>>>> +    u32 type_mask = 1 << type;
>>>>>>> +    struct io_kiocb *req;
>>>>>>> +
>>>>>>> +    if (!(type_mask & ifq->allowed_notif_mask))
>>>>>>> +        return;
>>>>>>> +
>>>>>>> +    guard(spinlock_bh)(&ifq->ctx_lock);
>>>>>>> +    if (!ifq->master_ctx)
>>>>>>> +        return;
>>>>>>> +    if (type_mask & ifq->fired_notifs)
>>>>>>> +        return;
>>>>>>> +
>>>>>>> +    req = kmem_cache_alloc(req_cachep, gfp);
>>>>>>> +    if (unlikely(!req))
>>>>>>> +        return;
>>>>>>
>>>>>> It'd be nice to avoid an allocation here inside ctx_lock and with bh's
>>>>>> disabled, which looks like is also the only reason why GFP_ATOMIC is
>>>>>> being used here.
>>>>>
>>>>> I thought about it, but it's already bh, it'd need to do pre
>>>>> allocations + caching to be reliable, but that's left out for now.
>>>>
>>>> Not sure I follow - GFP_KERNEL would be more reliable than GFP_ATOMIC.
>>>> What's the contract in terms of the notification? If we fail the alloc,
>>>> then userspace can't rely on the notification on the refill failure.
>>>>
>>>> Are we under bh save already here, before doing it ourselves? If so,
>>>> then how does the guard work?
>>>
>>> In 99% of cases it's called from softirq, not sure what you mean
>>> by how it works.
>>
>> Ah ok, I thought you meant it was already called with softirqs disabled.
>> In which case the guard would seem broken, as we'd enable softirqs when
>> exiting. But if we're just inside softirq yeah it's fine, and there's no
>> point shuffling the allocation either.
> 
> Softirqs are run with bh disabled, but bh_disable()/enable() are
> reenterable.

No worries on that then.

>> Question on the contract still stands, in terms of missing a
>> notification. I guess since it's a hint basically it doesn't really
>> matter, just something that should be documented on the userspace side.
> 
> Should rather be improved than documented, I'd say, but it's still

Of course, that's why I was originally asking about what the contract is
here - is it a hint, or is it more than that? In either case, should be
documented what the application can rely on. And might not be too bad to
harden, since it also really doesn't make sense to have more than one of
these inflight at the time anyway.

> better than not getting anything at all. And it's the only place
> where it can in theory be dropped, e.g. CQE overflow handling,
> though different GFP.
> 
>> Do you have test cases for these?
> 
> Clement needs to resend them. Actually, seems I forgot to CC Vish
> and Clement here, my bad.

Sounds good.

-- 
Jens Axboe

