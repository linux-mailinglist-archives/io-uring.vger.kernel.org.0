Return-Path: <io-uring+bounces-12009-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mALYAY6Yf2n3uAIAu9opvQ
	(envelope-from <io-uring+bounces-12009-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 01 Feb 2026 19:16:46 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E8755C6E04
	for <lists+io-uring@lfdr.de>; Sun, 01 Feb 2026 19:16:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B50E8300427D
	for <lists+io-uring@lfdr.de>; Sun,  1 Feb 2026 18:16:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A07EC2581;
	Sun,  1 Feb 2026 18:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="eY8AQGK2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5AD34CDD
	for <io-uring@vger.kernel.org>; Sun,  1 Feb 2026 18:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769969798; cv=none; b=ds3XsvAwv+tAIOfleRd/zmsqqfoM+tzrEnkLgSz+r+blQlFk5JGIxfQCokwCJh0fVDsCWpKthlJnqP9EOH9aPT5uy58C8BCTLCgfkKr9v3+73qpQxwm5H1OdeZxMlwFuWOygbKefGkWexD26Ui01nJgNMgXxceKpx0wUXYz8lz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769969798; c=relaxed/simple;
	bh=tydGkXYw2DDLhSyreQhs3f9htq1SbD+N1xsVDetCsfk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KhZiexUuqcYWWA9SCYg4larHpIa4175/LCo0Pqj2t1P+Kuszd3U5Cr0w/TLLXQMT2upAzGNYuE2U9ZAZOjmxe5AS98lz8Vax0KXSm32h73O1HcZpaZzpUrGQUC4EdzEL4zTYlz7m5ZQutX9HGHkfI+rKFvgEpbu/NRfE9pzf+2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=eY8AQGK2; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7d18cf89e72so2429608a34.1
        for <io-uring@vger.kernel.org>; Sun, 01 Feb 2026 10:16:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769969794; x=1770574594; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u+qd69DZei4cvz3Cr4QJ8zlJeWj/dQzSCNJkpeTRc+c=;
        b=eY8AQGK27I/kcd6xdyvJaL/lzqa7vqvEzr6WbpjvST9FHLzRU8VPbZwvXsg9eMc27D
         d6js3DAI4LtzkQayB0GxIb7BRo9AGMfMzcUKToe6bFMGrkg1A3jXVc92IeJS05vwDGe3
         ez0rX4KsaMR2SmGrGibsx2W22yQwiic1tdULHTA5/JuEceV3ria8npXa8BZW47LswZB3
         08JabKZLfuo8dEsWoHVqwZCx/czyGMbz7s8nEtF78qAXtxruXwCPgkwTYdHPz9kbgiuY
         l5lJfrpM9OIpA8pm1DKe0rvtw0q4G7lJHXtkKuGPNdFAySpziR02ReQ4PhDP/vOc77oZ
         xaDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769969794; x=1770574594;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u+qd69DZei4cvz3Cr4QJ8zlJeWj/dQzSCNJkpeTRc+c=;
        b=MyvPYh1mJO+C5ijLdxnyNhBCQp8SosripDR8JMQGGxoRRc3iWZ/WlVTF/Od1iaj9Zc
         eU4vbNWe7wKLE/PVNI9vmwJAfHL5FSgw1cO5McHPJXS1D5qqYtF75VZi4+8eaDDTP9Hv
         2Fnvq+FvaA7F/33IUCOHgdYKZvxLYCJh/GpLq1Rees3PZsRa5BvOKae2T9E/xFL6aSuY
         NBtlyQ0qcMQYC/LhwDyJnuXFJKM9Kaxw62sgsRzjX845fhU4SqUIbS0qvGmHVB+KbxoG
         BX1skZzMyjPmoA305H48RNBBoGSpdzBmOLDVZ1ouyCyUuHw1xzaMbgXWOt0tJRhFQyCg
         mh2A==
X-Gm-Message-State: AOJu0Yx+gfUPmHJJPIgtA5vsG4nukfW6BCNSp/1IzpQk8MKoDWkR5Phj
	zcQA+5FMTY3fC8xPpIvThMQfNBfmo1ixzfJHQpLh35BdUANiSGEqJZ2KE9VL9t5u48k=
X-Gm-Gg: AZuq6aI918FofOW0s+WGyE4AWVN43at2AXhylgls/3Q0OJKdpi6tMdNm3LNCyEjf38J
	115W/md59NHZHFXLjpHF/sZza0LBSwP9q9Ozb/1aA7MObpPZpn0YWtW77XPKtIvFT1DZqqr8WB0
	0Ebjs81DJrG2nOGym4U9DcuXLOincdbhdpobDy8HJDCaNIIRzblXpWczPT2pSBnr2iaxDnqLe42
	kfeRWtDkHJdnl5xLyYG7sLY3XmkZghitx4mU/uKQYYWJ30TVGdhj8ZI3gukq7XPw+8lhwWf8a42
	eVpAbr6NSDdXX/v84MuwdnYpjFUTQEuGDNjKipYaHipPhoqtmvpPHT0vldmAtOEORYP9cUuohMt
	gxd3MyZ046AGjkPcgqLwc4WpwLojaGKRzfYQ3dseO6UeSC/CGcKKq3fTB/TvxWrK42/Le5/zbFa
	ArBYyOqa3ZJucCCJRjWmVtvDKBE2SVwEhF3yXaxuKd4UDcSRq57k5YARplqbCev/F1wrcrBA==
X-Received: by 2002:a05:6830:411f:b0:7c7:6479:38ce with SMTP id 46e09a7af769-7d1a5308328mr6009692a34.18.1769969794529;
        Sun, 01 Feb 2026 10:16:34 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d18c7cf4f0sm9108214a34.15.2026.02.01.10.16.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Feb 2026 10:16:33 -0800 (PST)
Message-ID: <f6098b6a-6283-486b-8167-b77c8d2e7880@kernel.dk>
Date: Sun, 1 Feb 2026 11:16:32 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] Introduce IORING_OP_MMAP
To: "David Hildenbrand (arm)" <david@kernel.org>,
 Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org
References: <20260129221138.897715-1-krisman@suse.de>
 <62d5954b-8ad5-4674-986b-c1168771429b@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <62d5954b-8ad5-4674-986b-c1168771429b@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-12009-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[11];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel.dk:mid,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: E8755C6E04
X-Rspamd-Action: no action

On 2/1/26 10:46 AM, David Hildenbrand (arm) wrote:
> On 1/29/26 23:11, Gabriel Krisman Bertazi wrote:
>> Hi,
>>
>> There's been a few requests over time for supporting mmap(2) over
>> io_uring. The reasoning are twofold: 1) serving as base for batching
>> multiple mappings in a single operation 2) supporting mmap of fixed
>> files.
>>
>> Since mmap can operate on either anonymous memory and file descriptors,
>> patch 1 adds support for optional fds in io_uring commands.  Patch 2
>> implements the mmap operation itself.
>>
>> Note this patchset doesn't do any kind of smarter batching in MM.  While
>> we can potentially do some interesting optimizations already, like
>> holding the MM write lock instead of reacquiring it for each mapping, I
>> wanted to focus on the API discussion first.  This is left as future
>> work.
>>
>> liburing support, including testcases, will be sent shortly to the list,
>> but can also be found at:
> 
> Just a general question: why do we unlock each syscall individually,
> and not in some intelligent way, all syscalls at once? :)

The hard part isn't enabling all syscalls at once, that could be
trivially done with an IORING_OP_SYSCALL and the SQE carries arg0..argN.
And for any nonblocking/simple syscall, that would Just Work. The
challenge is for syscalls that block - the whole point of io_uring is
that you should be able to do nonblock issues with sane retries. The
futex series I did some time back is a good example of that - you modify
the existing syscall to expose the waitqueue mechanism, which you can
then use to wait in an async way, and get a callback when some action
needs to be taken.

If you just allow blocking, then you're blocking the entire io_uring
issue pipeline. Which was exactly my main complaint on this patchset,
see the review reply to patch 2.

> I assume supporting arbitrary syscalls could be rather hard (or am I
> wrong? :) ).

See above - it's both trivially easy if you ignore the problems, or
somewhat harder as you'd need to refactor the underlying bits of that
particular syscall first. For some of them, that's hard. Traditionally
syscalls have been fully sync, they will just block and prevent the task
from returning back to userspace until they are done. syscalls with
io_uring is more involved as we simply cannot allow that kind of
blocking.

-- 
Jens Axboe

