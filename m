Return-Path: <io-uring+bounces-13681-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 5L8QDUVtK2p79QMAu9opvQ
	(envelope-from <io-uring+bounces-13681-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 04:21:57 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 771F567643F
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 04:21:56 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=b9Jrmjd3;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13681-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13681-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A853230086D6
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 02:21:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCD3A382287;
	Fri, 12 Jun 2026 02:21:38 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A737028F5
	for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 02:21:34 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781230898; cv=none; b=g+f642MU/ZBSUKczmCyI9rMAme3wN8UzgO42c3vXVglQA8Tz5E/nnVapbD+fI9M8LDkZ7pGGyrFsIRyI8Vsopp4iEj8uBzNUkFv5emIaaTq0G/kSYJte5NQ22tkYs4p7YvgWFVc7ib1Sq175qs4XR5o4Syj85sWXTXrAOP4PCNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781230898; c=relaxed/simple;
	bh=blzoFCioVl0BRG922OXTl/D0tfxEPLxNpZ+7NHngqGw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LreO5ovfYaWBb7iKnE5SigxYnGyHonu+AwODXiKkI/258ho2K/ctL2E25VenPNzVGa6GvWsi0x1F4/b21v0mlAuJyE5ZISNOfsi//2jfjkQgSIN8LjdcAxdIeTlBKlcfDfDmQQZ4TqToohNK/gHIpefOg54cegRG/gkw7uQhkbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=b9Jrmjd3; arc=none smtp.client-ip=209.85.210.52
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7e71198e0adso201674a34.2
        for <io-uring@vger.kernel.org>; Thu, 11 Jun 2026 19:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781230893; x=1781835693; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a5vpVkIs0tcHHQVLbxq3bQ+H56udG5kOy7m12UsKFcE=;
        b=b9Jrmjd3OqfCp2vUdVpxdy7lqkWIXNaJD/qVe6k5Tb85mx3WBTssii6XZ1o+BrGHma
         +FrxQW3//rSMDZ2cUUUjkJt7y2Dzz3rQ7Pv51TMrcSPVSJo7bLpQWYVHITNnVppkaNZM
         TkuHR09uwf7jPx7K3JAbzGSF/Q20oVZ5yo9Z2gHqVhUZHyKnZRZg9bk6czagKIFWDPI4
         4hezXR5sTEjnQnkx0wVkAk5+dAuO9l5+UbeY/lgoa6t3ux6/02cm170DCKz9hkcL3r1i
         VSXNywZHMDmWMVvCLrAvxv/U7Hj3R+qx3h5mSrpYgIUkmmjaEhdv4Wl9N3zOtNNnnqp7
         z6/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781230893; x=1781835693;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a5vpVkIs0tcHHQVLbxq3bQ+H56udG5kOy7m12UsKFcE=;
        b=K24E5Z/Hxv+8aqF64XO9xIUytbB3lLWIRFFOcxP5nP6Kznp9QyifpzJF6IkHzVwrSr
         Hm8azmsK4PO+hlgVX/YKs9/4ASxokk7lFcVhnqJngOPGI99Huk+BfZreInu20a3pnrfR
         cIRTcP0k/IKCa0I7yNPA7/ZTOOfGAmubhfPAUhp3cBhiuMksZM/dp5ezprYdf3ZVHfv6
         cYxbavo8bvzlOr5mZHisx6EGyTS0X1aNZckYGFa6W2n52WFgEgraQ5hOUXgsqhnGzuer
         496gSRro8SJYxuY+3pw0CNMDP057/JUhHW/X4a0fExqRzw9Tqt1l6t+ZXvC5Ckxu0m2E
         UEOw==
X-Gm-Message-State: AOJu0YwkD7JmxRGXDebIa1iiqKC+xCatf7a52pUDJ5Yfo0eHdkWd2QXz
	Ty53GnLdY/7pKrupCtoX0eC5+7k0FKF0ilPBDYWsB5kDacDHCAJQoEVV5yrDtDL1EUo=
X-Gm-Gg: Acq92OGRcxqdlc0dPyUIxNZLc1+MYvjmovitGRfAhZ53aVuJl4QxZJYnFpgJe1gbz3l
	aFAF2RpkLUvmpJf8aksZxyn+T13XkrqZPF8J2MFjEsscvrXXJ5dMJ+HOXnZyu9qa87SEOgRRXPc
	q9FEbU1OfgoujfnINVOhQHpret2ISGxpILMV53ZvH/vTwkrV8addaqVBJYVCdSeRXR1uxUvrFOl
	gHT7YRorLDEDnPqzH4i2UcRyCqbio9VinLR6GSHY263N81CKhrPUiskMSnaOrnWELqHkwRaFJvm
	oULgVvTePMnOmIFtSdSenDOq7Jx28gLolFCnv53/sGvmysxk6eVGr6MVL1OBv+ya1vXymjvvVuV
	EuoqhFSwOnrBOpdAClahEDRACTKBysnMIg6FVjIXTJRON/XuHnYUI7esygBpxmIocnCgQJigkq4
	kDkl5fWLv6ZKHGNF5oiIbAGhwvnofhp1EIiy+3HWuTIAQhB2bLQiOAQEg/kyYZvYFM925Pk+yBf
	ZM/BiR2rQ==
X-Received: by 2002:a05:6820:812:b0:69e:b788:36da with SMTP id 006d021491bc7-69edc71deaamr603225eaf.37.1781230893351;
        Thu, 11 Jun 2026 19:21:33 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4426a449e79sm639059fac.0.2026.06.11.19.21.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2026 19:21:32 -0700 (PDT)
Message-ID: <85660b71-05ce-4a60-a34b-277851e74c1b@kernel.dk>
Date: Thu, 11 Jun 2026 20:21:31 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] io_uring/mpscq: add lockless multi-producer,
 single-consumer FIFO queue
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, dvyukov@google.com
References: <20260611160553.1486640-1-axboe@kernel.dk>
 <20260611160553.1486640-2-axboe@kernel.dk>
 <CADUfDZpQuB=TsQT2aZFkwhsHBhXQnzowPJQa4Fs6z+PA558qcw@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZpQuB=TsQT2aZFkwhsHBhXQnzowPJQa4Fs6z+PA558qcw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-13681-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:csander@purestorage.com,m:io-uring@vger.kernel.org,m:dvyukov@google.com,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	RCPT_COUNT_THREE(0.00)[3];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,kernel.dk:mid,kernel.dk:from_mime,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 771F567643F

On 6/11/26 7:13 PM, Caleb Sander Mateos wrote:
>> + * Push a node onto the queue. Safe against concurrent pushes from any context,
>> + * and against the (single) consumer. Returns the previous tail node, which is
>> + * &q->stub if and only if the queue was empty before this push.
>> + */
>> +static inline struct llist_node *mpscq_push(struct mpscq *q,
>> +                                           struct llist_node *node)
> 
> It seems odd to return the previous tail node. The pointer can't be
> dereferenced, as the node could be popped and freed at any point. The
> return value is only compared against &stub  to determine whether the
> queue was empty. Seems like the interface would be simpler and avoid
> leaking implementation details by just returning whether the queue was
> empty before the push.

That's not a bad idea, I'll take a look at that. I have a v2 of the
series which converts the non-defer task_work as well, so need to send
that out. Will do so tomorrow.

>> +{
>> +       struct llist_node *prev;
>> +
>> +       node->next = NULL;
>> +       /*
>> +        * xchg() implies a full barrier, so the initialization of the
>> +        * entry (including ->next above) is visible before the node can
>> +        * be reached, either via ->tail or via ->next chasing from the
>> +        * head once the store below has linked it.
>> +        */
>> +       prev = xchg(&q->tail, node);
>> +       WRITE_ONCE(prev->next, node);
> 
> I think this needs to be a release-order store and the READ_ONCE()s in
> mpscq_pop() need to be acquire-order loads. Since mpscq_pop() doesn't
> necessarily load q->tail, there's no happens-before relationship
> between pushing a node and popping it.

Don't think that's necessary. The xchg() is fully ordered and hence acts
as smp_mb() on both sides — so every init store propagates before the
link store. A release on the link store would only add ordering for
stores issued between the xchg and the link, but we have none of those.

For the consumer, every dereference of a node should be
address-dependent on the READ_ONCE() that observed it.
Address dependencies from marked loads are honored everywhere, for
example alpha even has a read barrier there.

>> +       return prev;
>> +}
>> +
>> +/*
>> + * Pop the oldest node off the queue, or return NULL if no node is available.
>> + * NULL is returned both when the queue is empty and when a producer has
>> + * published a node via ->tail but hasn't linked it yet; use mpscq_empty() to
>> + * tell the two apart. Single consumer only, with headp being the consumer
>> + * cursor that mpscq_init() set up.
>> + */
>> +static inline struct llist_node *mpscq_pop(struct mpscq *q,
>> +                                          struct llist_node **headp)
>> +{
>> +       struct llist_node *head = *headp;
>> +       struct llist_node *next = READ_ONCE(head->next);
>> +
>> +       if (head == &q->stub) {
>> +               if (!next)
>> +                       return NULL;
>> +               *headp = next;
>> +               head = next;
>> +               next = READ_ONCE(head->next);
>> +       }
> 
> I would find it a bit clearer to avoid using "next" to refer to the
> actual head in the stub case:
> 
> struct llist_node *head = *headp, *next;
> if (head == &q->stub) {
>         head = READ_ONCE(head->next);
>         if (!head)
>                 return NULL;
>        *headp = head;
> }
> next = READ_ONCE(head->next);

I'll see if I can make that part look neater, I agree with you here.

>> +       if (next) {
>> +               *headp = next;
>> +               return head;
>> +       }
>> +       /*
>> +        * 'head' is the last linked node, it can only be handed out once the
>> +        * stub has taken its place as the tail. If the cmpxchg fails, a
>> +        * producer has made a new node the tail but hasn't linked it to 'head'
> 
> nit: "but hasn't linked 'head' to it" since the pointer goes from head
> to the new tail?

Good catch, yes it should read from head to new tail.

>> +        * yet - bail and let the caller retry.
>> +        */
>> +       q->stub.next = NULL;
>> +       if (try_cmpxchg(&q->tail, &head, &q->stub)) {
>> +               *headp = &q->stub;
>> +               return head;
>> +       }
>> +       return NULL;
> 
> An early return if the try_cmpxchg() fails would reduce indentation of
> the successful path.

I deliberately wrote it that way, reads better to me...

-- 
Jens Axboe

