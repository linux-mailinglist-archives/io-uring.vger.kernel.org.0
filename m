Return-Path: <io-uring+bounces-12634-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +GIUCWRSsWn8tgIAu9opvQ
	(envelope-from <io-uring+bounces-12634-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 11 Mar 2026 12:30:44 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B0500262E85
	for <lists+io-uring@lfdr.de>; Wed, 11 Mar 2026 12:30:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9D894302307B
	for <lists+io-uring@lfdr.de>; Wed, 11 Mar 2026 11:30:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 221453DBD5E;
	Wed, 11 Mar 2026 11:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M7RRIPTp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977753C9ECA
	for <io-uring@vger.kernel.org>; Wed, 11 Mar 2026 11:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773228641; cv=none; b=ldtSsIsSez65i57FGeyMtvzBj23g7CxJsfuL/ToNT0DTidHfKo2XQoYGvxysXlbmGj3CRPyki05I0MtbH821bknM3goo21zFGFMd1b4iWggiS5qdQYpfJ6Mq5oH1uxqIU3kI8seqgosTRmkGrlXGoO6TMw4iarZyqENEXOIFlVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773228641; c=relaxed/simple;
	bh=7oCS2HEYNPyQYhGX+Y4M/wdQSgV1C0yaTdCo4y1cQ/Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tNev1lXzAsFb3sh7O2LDH8fgAX0VnWgdrbnLjStW8TG4GIcPoOi02Gm3KkH9TDxURooiuss3Dv8zmK0B44Gi2fWtp/C+tsA5HPVBhe1EACS87G2dweKnLC4rdO1Z0rbQIHPoyJmuBQjpSpJGAWHVw9p9hRNL0tpyNnSUod2Owts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M7RRIPTp; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-661d20c9787so6356203a12.0
        for <io-uring@vger.kernel.org>; Wed, 11 Mar 2026 04:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773228636; x=1773833436; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uAJfHwJl0gPO1RoYcdyFqqL0Pcnk/8Jq8qQE4hL861o=;
        b=M7RRIPTpueeICRXzBSPyJ/qa6DOQVXpOCqJd8hLL4v+vE0QdGyhAan/cxHl+6FtHL+
         WribBhDNI9Em/SO9TsDC8jJOHPOuvJp8aLln+7BXPp2KTOeITkTkcintUj/QyqEJXBAC
         wscEyks9a2pvWaLlUtXnudq3EMIqr95aymOU8h3pHbPDS9gcPytxRHkfPuAu1fLwSK8T
         HhLJQomPXrIEti0R89hJuIUM5/AO7woRiRog2oC4GjXXSb9JV22GoLF20irt03T59CVC
         M6K06I+gwdCBHuCMLu6IFMdDPRMor4kms4jSyT+sfhaGKMRqje48QobnWOpUyAidYR7+
         JHsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773228636; x=1773833436;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uAJfHwJl0gPO1RoYcdyFqqL0Pcnk/8Jq8qQE4hL861o=;
        b=rnSWkupIVwdv5DN2DSOZWKgtsiwnqh30268ga7m8ScIKY0/3hDZNV4LqbTWlm8bY+e
         uOLKNh1B8ZE71jG3bDwdktbxzbKwMMyBukkDbXNpGNm6IoSMYBRedu4p5Gzhgjk9sLGn
         2B5qGPNzdDWMVF1C9g1HG/bGsw2pXhYKvDAt/lTMwaKhqSZ/AWKM+hft5CWFpQFU4NiI
         ssVNkKx+xUpnrc4Ro3TBy1fWTFQl9nQAR4XV8jvd41OSNdxCos0xt0Ms7Ogx+dFaN/XK
         GmF7lZiL/l7ZgfzlwbCjIf95XqAHk0CCI1+4Tb9jJiIEA4pf8n2RBpQI9UTSJh26ym0j
         zk6Q==
X-Gm-Message-State: AOJu0Yyii1jdiqndceUSehenvzOZR+og+tT7TQJeaZ0b+R/GwL5B/sPA
	7vhfuM/SjH6jDiCWfjY1Z4eEr9DXuW3OpEvCIpKGWExswzK4Ys1qUfP18odhmg==
X-Gm-Gg: ATEYQzwX9ntZrB3wHQAZex6DvNvg7CSQa7FFcjY2/Ab3VJkUz0ff/Z7ig3swIKrNGX9
	3F6HW5VJBWd7ukyhncFpMtoGOUBKgrDutUVH3lwB5tXTuvY2NaSVZJ0/VYmMpSkci0/iYHXr2Im
	PkJS6I7x3uH74JBpCXFuscbdT+XLAcV/E8LPX9XKB/YAY78Js+UmX1PXfUR3xKAoS4zqS2b0eFD
	yd/vF5UiE0nxxfxX/Vm5D+BEZdGbsiA/ZgmTBugv8Sj9p57ve4YOKmQywhmvRcfuprddJkHqpMY
	IaiEhsETuys3RwBBoa1cuLILkbm19kbhR37cOcWmIzX3H7I2+xWv26Wqpxik4l2SJxyWazUJtXH
	FB5xoRGlRyhf/439n07zL0WsmFdXrFySF90WxNL+Bb6LAoH4XXGWhgOTYgvGlFxmTp6Wl3erdNW
	pc3pEZYPT9U/Y7E6Z8we8j6Q2nZm4h7KcdjFvrBO6I4BOv1ho5gXjDVkjDNNXIilUjUHaKm7rxJ
	6sONJbecCvsZLt3lVeSxngLp3kVicara8UQtTc7rGAAT6zqtSjH8npxEQ==
X-Received: by 2002:a05:6402:13c9:b0:662:e723:9849 with SMTP id 4fb4d7f45d1cf-663192c6ca5mr1083048a12.1.1773228636425;
        Wed, 11 Mar 2026 04:30:36 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:bf9])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6631448605fsm476072a12.12.2026.03.11.04.30.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2026 04:30:35 -0700 (PDT)
Message-ID: <086190ca-1c34-448f-a565-aa41f671971f@gmail.com>
Date: Wed, 11 Mar 2026 11:30:33 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: Add IORING_OP_DUP
To: Daniele Di Proietto <daniele.di.proietto@gmail.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
References: <20260310154933.2500971-1-daniele.di.proietto@gmail.com>
 <c29a339d-67c5-4e8a-a1c9-2388aa9f28d5@kernel.dk>
 <CAExiqTKBFeyxE4nwSxd3muOuZkP5YDSoweYwns4wb64w8efPVQ@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAExiqTKBFeyxE4nwSxd3muOuZkP5YDSoweYwns4wb64w8efPVQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B0500262E85
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12634-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,kernel.dk:email]
X-Rspamd-Action: no action

On 3/10/26 18:42, Daniele Di Proietto wrote:
> On Tue, Mar 10, 2026 at 4:24 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 3/10/26 9:49 AM, Daniele Di Proietto wrote:
>>> The new operation is like dup3(). The source file can be a regular file
>>> descriptor or a direct descriptor. The destination is a regular file
>>> descriptor.
>>>
>>> The direct descriptor variant is useful to move a descriptor to an fd
>>> and close the existing fd with a single acquisition of the `struct
>>> files_struct` `file_lock`. Combined with IORING_OP_ACCEPT or
>>> IORING_OP_OPENAT2 with direct descriptors, it can reduce lock contention
>>> for multithreaded applications.
>>
>> Overall comment - how does this interact with direct descriptors? Feels
>> like this should support both, rather than just normal file descriptors.
> 
> As implemented, the operation supports:
> 1. src: direct, dst: normal (this is the use case I mostly care about)
> 2. src: normal, dst: normal ()
> 
> I can extend it to also support
> 3. src: direct, dst: direct
> 4, src: normal, dst: direct
> 
> I can use IOSQE_FIXED_FILE to pick the source and I guess I can use a
> bit in dup_flags (something like IORING_DUP_DIRECT) to decide whether
> the destination is a direct descriptor or normal.
> 
> Does that make sense?

Let's not try to reuse IOSQE_FIXED_FILE for that. We may want to
operate with io_uring's filetable entries and not just files you get
from there. Two separate IORING_DUP_* flags should be better. And
you can extract a helper function out of

io_uring/splice.c::io_splice_get_file()

It might also be better to make it a part of IORING_OP_FILES_UPDATE
instead of wasting another opcode, and liburing can provide a
prep_dup helper for convenience.

-- 
Pavel Begunkov


