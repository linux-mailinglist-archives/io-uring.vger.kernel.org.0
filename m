Return-Path: <io-uring+bounces-13718-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id jw6dDo9LLWqYegQAu9opvQ
	(envelope-from <io-uring+bounces-13718-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 13 Jun 2026 14:22:39 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id B891E67E83D
	for <lists+io-uring@lfdr.de>; Sat, 13 Jun 2026 14:22:38 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=wIdsEN5X;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13718-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.232.135.74 as permitted sender) smtp.mailfrom="io-uring+bounces-13718-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2A17430039B5
	for <lists+io-uring@lfdr.de>; Sat, 13 Jun 2026 12:22:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF40E3955CE;
	Sat, 13 Jun 2026 12:22:36 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E36C2F83A2
	for <io-uring@vger.kernel.org>; Sat, 13 Jun 2026 12:22:34 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781353356; cv=none; b=hbVendiOYpWQR7UYpj/BZ80meZVGMfbGpjjMcxjxcz0KKeoRIuqjhyqjL9KxiKJOt1WfrEYeiQFlTOal3bDEhPwVaCExHKgSaUJnq05WNQqECxJBOv5se15o5wujR6eMZuZpIWtJmgijWQK9pfJLOyKnENuY29R0f4XWQ3M27CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781353356; c=relaxed/simple;
	bh=v1U6gx/00DWdtXH+gBgnGE0MFr2GSZhF45FzPucNJgQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P2ITfIciKKA8/Hv2l3BIaUj6Z0sFVw6t8b3XDJVJaaAilkyHUGTiW078oPAtoYx6LaeXKlF3UDYCQCdEKcveui5v/+n22OOead9NUxlIA/hPzR3RGssmPs/3j0nq07kvdJ21G2cMBg8XxLcBJv3mUtkFbXWGPpAa7ZUP4tSt1S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=wIdsEN5X; arc=none smtp.client-ip=209.85.210.47
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7e6e2d54d3dso1055161a34.2
        for <io-uring@vger.kernel.org>; Sat, 13 Jun 2026 05:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781353353; x=1781958153; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KBxTw/W+Du/xLAfyinJSnLkU1q/MyUhiW447HryFSvg=;
        b=wIdsEN5XNJz9gPiLXRMxXMIddlMPYH9QOb7oBhAZeawaoiiwNm74WaTbf+L2Yc7Lay
         0HhHoOz9vEL+tQl9w6p5wHmgr117Zfw77hb8Y00uwA2X7I8u7rpNFhUVjJDtIxwJ+WrG
         a2pupRDf7LiX6IZm7AXUDSOQOqTufR45sNhXUZXjo60iP6VJVniA5xQwkuGxxf1oMaS6
         PEuppJXEvZSxlJvyTRNwmCPz2CyxqkMWwm7Y+VbKvRyEkEkzgRv8BFJXU4qXC11wqxqa
         oR9vWLltH/M32IHvyULFBy8cUz06V5uuDuD/YM2dOpfG5P1ZWRuvhaqIf9AwbhiS9z9e
         /V2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781353353; x=1781958153;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KBxTw/W+Du/xLAfyinJSnLkU1q/MyUhiW447HryFSvg=;
        b=XFK0TGFRwwr0PkS2L1q80HNItKynVTLqk1ARdn0B4N26d2tsnRtvaAvV7EWMM1Z1Q5
         82FoPpooyTnDErfQXakVKaIk+FO0f+Ba/pohKt6R4Y/qL7pFOnqS2j5y/sB8gJB7pEms
         3FzVSiiXKsm01DYcgxh31QC5XkDNG2zcD859ue9jxDp9t/psoFOKhHuNY8CJsR1JUFIF
         oZ7QRnDcrtslRsKNo3ylN+4HniLYQ96GIJzxwZ3Ucon2EAAacNUP1h9MRr4BDqAPmxcj
         ShYY7i+D8/I2jYRKgzTetiYFIu15I02FESPwHy+cFDBADSRETFXL6CHWyi4zGa271IM8
         hoLg==
X-Gm-Message-State: AOJu0YyNfnUVpxF8yNtfshJ079/wDuvPwYIWYt2nCQTTI5Wn6XSBLnCq
	RE5nO5BUZUvfy/VV38wMlwQAS9T4/3IFzKkI2OOLRnTes3sUwk0wdYNxnq+32J7uf5g=
X-Gm-Gg: Acq92OFUmLjXsDJv83x1rBIYfZimaRfawmApbsSGrvBqB58pUsZZn9mtcAdHdxO+RYm
	CEs8ce8yKpnKZiNQ+Qq+MJO2jYt/aag/0qhuzwFXTr8oMFWdjwPcoLLJr4e1f9uNUwoBMYMtvxZ
	6SCmQB1vgU/cN3WBX3TI3tBb4sO1H5OU6l1vvZEUSVPuKzpvmmaLm45FRC9QB4lcb3MRV8mafOp
	h1xk74SG+mIN/swK7nUk2anBU5YFAgpwFviM1fmYPIchnUOFaw+N2h9Mr/4nK8eP2Rv3yi7oqbz
	a7f/BowwJfPEdp5Y8Q9ebRPtaoyGsZ6yoRm199gRhWGdDv130pk7ekvMa6GGRFvKeKkz1iM/2PC
	6JJuQmjS3vKOYKJqVgilC/cZs0ObVx/A3i9Cd9W3UKr201qzxSm0VsypwubR6R4ldejutOP3UuE
	qY2r5Yb3TrzSpR7wkLiTj0vNxPxChIGbF8XikyI3jLzEbOv6zfbWC3EDYiQcbfLzhZNZ4QjsALB
	SlwXnAmaPkH7lpk5Uzx
X-Received: by 2002:a05:6830:210d:b0:7e6:e1d2:3bd0 with SMTP id 46e09a7af769-7e7846f188emr4903902a34.10.1781353353380;
        Sat, 13 Jun 2026 05:22:33 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e7816b3f4fsm4037647a34.14.2026.06.13.05.22.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Jun 2026 05:22:32 -0700 (PDT)
Message-ID: <9c85aa11-8777-4412-95a3-3995ada98652@kernel.dk>
Date: Sat, 13 Jun 2026 06:22:31 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] io_uring/mpscq: add lockless multi-producer,
 single-consumer FIFO queue
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, dvyukov@google.com, krisman@suse.de
References: <20260612025125.1690253-1-axboe@kernel.dk>
 <20260612025125.1690253-3-axboe@kernel.dk>
 <CADUfDZoLTJ6mtQ5yaP83_K18N7eK3u72gkNSPrnhg-vjb=8p1Q@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZoLTJ6mtQ5yaP83_K18N7eK3u72gkNSPrnhg-vjb=8p1Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-13718-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,kernel.dk:from_mime,vger.kernel.org:from_smtp,purestorage.com:email,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: B891E67E83D

On 6/12/26 8:40 PM, Caleb Sander Mateos wrote:
>> diff --git a/io_uring/mpscq.h b/io_uring/mpscq.h
>> new file mode 100644
>> index 000000000000..bc482d10e0f3
>> --- /dev/null
>> +++ b/io_uring/mpscq.h
>> @@ -0,0 +1,118 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#ifndef IOU_MPSCQ_H
>> +#define IOU_MPSCQ_H
> 
> #include <linux/io_uring_types.h> so this header can compile on its own?

Sure, we can do that.

>> +static inline struct llist_node *mpscq_pop(struct mpscq *q,
>> +                                          struct llist_node **headp)
>> +{
>> +       struct llist_node *head = *headp, *next;
>> +
>> +       if (head == &q->stub) {
>> +               head = READ_ONCE(head->next);
>> +               if (!head)
>> +                       return NULL;
>> +               *headp = head;
>> +       }
>> +       next = READ_ONCE(head->next);
>> +       if (next) {
>> +               *headp = next;
>> +               return head;
>> +       }
>> +       /*
>> +        * 'head' is the last linked node, it can only be handed out once the
>> +        * stub has taken its place as the tail. If the cmpxchg fails, a
>> +        * producer has made a new node the tail but hasn't linked 'head' to
>> +        * it yet - bail and let the caller retry.
>> +        */
>> +       q->stub.next = NULL;
> 
> I think this could be moved before *headp = head. That way it only
> runs once each time the queue becomes nonempty rather than on every
> attempt to switch tail back to &stub. And it would keep next =
> READ_ONCE(head->next) and try_cmpxchg(&q->tail, &head, &q->stub))
> closer together, reducing the window where the consumer could lose the
> race to pop the last element.

That's a nice observation! Yes, that looks correct to me, I'll fold it
in.

> Other that that,
> Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>

Thanks!

-- 
Jens Axboe

