Return-Path: <io-uring+bounces-13230-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iKoAIkGR+Gl8wgIAu9opvQ
	(envelope-from <io-uring+bounces-13230-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 04 May 2026 14:29:53 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A87584BCE10
	for <lists+io-uring@lfdr.de>; Mon, 04 May 2026 14:29:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 002C73013A69
	for <lists+io-uring@lfdr.de>; Mon,  4 May 2026 12:29:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80CB636309C;
	Mon,  4 May 2026 12:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="0vjX551T"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9677D343D64
	for <io-uring@vger.kernel.org>; Mon,  4 May 2026 12:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777897790; cv=none; b=HCuLUswGbJjWjotwirtRf0Xd3VzCGmp+Y395UZL8D+G/mhPRwcffxPD48oCWGX3qmDSKl5EEr6R7uACGJjWoZ5HMvN6hsCDlQF7NH48SvWgJ1LCDEpt9ryra/jIOVmuUtBZQgERxnUMLf9gfASS1woS+3jcVL8YtKAcbTApocEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777897790; c=relaxed/simple;
	bh=0KkI0kBpkRCi3NIOzuMSKejENtjno/8AkBJ+2pGS3rg=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=ndsgOtR7hFVQ54I6veC8fHb0vuGmfVSwRV+idXaThd+zIZAquFES5FtTXp4UTyjgztfD8JLNqvqrlZoETQBcdcEsBeVRSDliGF5vvxUKazca4UY0VFPaN6ibNZ5W4BSbyULXiB4ET4gAeZHf3hf96Z+/wVjOHCpbFB1iKWj0SLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=0vjX551T; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-44a044cb827so2643483f8f.0
        for <io-uring@vger.kernel.org>; Mon, 04 May 2026 05:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777897786; x=1778502586; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=g1l7chewGCM5KRWCoyB1HtpsnY/hG1I2M+B6a3WiNJk=;
        b=0vjX551T8DB/ffX7+8gVGb8x8E+jJS3oztxg2vUrdzbdBFO90wQqmzWjSTQyayAQ58
         fX44uHVyhT4jTjk57buTAYhkAWH416PT4i/82cRUQTn5kF4uI5wMuQ2VJpp3hXbxJ+rv
         2feGoPtEVWYmRGiNyFBwXIGG5aGJRoB0LK+Ox4f3TPsrNT0VeGYNBLGozmTFGYz8T9Up
         d/15QeZyGvjXTosTSloqZn8UhyXNkxkJ0YY/UGMjlx1VX9CrJzYDBd+O3wdV9nzMwfiu
         FbVoFBijBmaOSFY9lRDtVgoHU+zZGnyESZtCKG5iX7r4QCf+pD4SzMkkjBjk5WGOHGYV
         Y+uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777897786; x=1778502586;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g1l7chewGCM5KRWCoyB1HtpsnY/hG1I2M+B6a3WiNJk=;
        b=sy2diidg5y9zjddoL/9lrXlKNmtAUdQhW7Jys5xgN0Z+N7NBUJRNlfAs3SxCaSE8/p
         zKPSrSW2GolaQeIqZ+AoM5OS0gwsEUr37Lw6/E7dDQ8BQN/J0jCLmaX1L/DUaEIhmwbO
         XlSvFEnTLRUt13DJtLyOOzdAwQ72RJmMKLc/8iT+mkKKGW1HGNzmXhrx4JY2f+u/IGlz
         9Q8thasMDcGGjj0CreuDKirRW29tt7qQdmeULD6YR/Uxi68kK/bzgHLD7YugRikUWP20
         sLBInBfJPSvmEulx2+sOliK6fRVvsvl0gUjdSLAWGElWcgAWrS8RIyJ4XAYK0GVJgrnQ
         BUbA==
X-Gm-Message-State: AOJu0Yxiz+xdODq0hGk4KMv8qcnpXRP6katFgv+ylKp79ZrqTlN7159r
	OHSpv5f5LOVW+haQr0RJL/ricKoRRArLan0B8diPgCPsZ0W6/hTkIrN0D74p4q5q8F0yUdFg44P
	Y0O/KZXMgtg==
X-Gm-Gg: AeBDievSh5znkGHP9Deo+I9MjSXfTWtFHxgIetirERD2jNjZizE4BCOmCburK40EeRb
	2tVHH9GcFmp8e0XenYfM4xVWdFGrqXsLvnjjZMdY33wCSd6hOmNR5jtFs0+jvks4nxdpTYFLXRb
	GFsuC5tYsDzwoN6/8YoOk5MvCfWxbq5Xg0spYIdViEx+teFayezZgIVMCj4/GzAe/3E6Krsk1Pb
	uLfB1Jd0sLzmS3k5vl5CRdwJPlFz8fxYsG1/oIiAN/Ou5L5ijcwb/4qALV4HK+iK4RKeq+x1ShV
	/4BtTy/Wq8nxqGrnbABS5dn0eMODUCyplk/lGqM9QDZCSAMHg6ymKamh/Hbwbevm0/1copHa+1j
	D1TNKZ/tl6gYrfXlOKoIiiGbnnYCyWSJ+Tj98A6tM2iDZwR9gpJ1ucD1v39V9gjb7pdEQdg+6O6
	zQUX/PDp2z1YIqMi5yp1GzZ+hwBCu9lPuK8GWfQuGrb262x6atI70MXig2AYqWiV5iNk0GZUPpS
	zppxUZ/+0MLxQZuB+qT
X-Received: by 2002:a05:6000:1acb:b0:43d:7dcf:ae26 with SMTP id ffacd0b85a97d-44bb716f584mr16809595f8f.34.1777897786020;
        Mon, 04 May 2026 05:29:46 -0700 (PDT)
Received: from [10.211.9.114] ([213.147.98.98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-44a981dee90sm25130912f8f.22.2026.05.04.05.29.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2026 05:29:45 -0700 (PDT)
Message-ID: <56388741-f507-44e3-a144-5512a1fd99cb@kernel.dk>
Date: Mon, 4 May 2026 06:29:44 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [SECURITY] io_uring UAF: io_uring_cmd_issue_blocking missing sqe
 copy before RESIZE_RINGS
From: Jens Axboe <axboe@kernel.dk>
To: Carlo Conti <carlottoconti344@gmail.com>
Cc: io-uring@vger.kernel.org
References: <CAAiJJe3rVHjEO6yZ=w6S0igYFE8ROBay+An7PnuMX0KndxwXOg@mail.gmail.com>
 <cbc92665-c340-4827-980e-f36a6dd9ec8e@kernel.dk>
Content-Language: en-US
In-Reply-To: <cbc92665-c340-4827-980e-f36a6dd9ec8e@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A87584BCE10
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13230-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FREEMAIL_TO(0.00)[gmail.com];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim,kernel.dk:mid]

On 5/4/26 6:16 AM, Jens Axboe wrote:
> On 5/4/26 5:59 AM, Carlo Conti wrote:
>> Hello,
>>
>> I have identified a Use-After-Free vulnerability in the Linux kernel
>> io_uring subsystem, confirmed on Linux 6.19.11.
>>
>> The primary finding is the UAF itself, both a read and a write
>> primitive have been confirmed experimentally. As a secondary research
>> step, I also attempted to build a privilege escalation chain on top of
>> these primitives. The LPE reaches root but with a structural
>> limitation described below; I am reporting it in this state because
>> the UAF primitives are reliable and independently exploitable, and I
>> believe the escalation path warrants further investigation by the
>> kernel team.  
>>
>> --- ROOT CAUSE ---
>>
>> io_uring_cmd_issue_blocking() in fs/io_uring.c calls
> 
> fs/io_uring.c hasn't been a thing in many years?
> 
>> io_req_queue_iowq(req) without first calling io_req_sqe_copy(). As a
>> result, the ioucmd->sqe field continues to point to the original
>> sq_sqes buffer.
>>
>> If IORING_REGISTER_RESIZE_RINGS (opcode 33) is issued immediately
>> after, io_free_region() frees the old sq_sqes page. When the io-wq
>> worker is eventually scheduled, it reads sqe->ioprio and other fields
>> from the freed page ? Use-After-Free read.
>>
>> Additional issue: io_free_region() does not call zap_vma_ptes() for
>> single-page non-vmap regions, so the userspace mmap of the old sq_sqes
>> (IORING_OFF_SQES) remains mapped to the freed physical page, providing
>> an arbitrary write primitive ? Use-After-Free write.
> 
> Can you expand? Seems unrelated and also unlikely to be an issue, unless
> it's missing something explicitly.
>>
>> --- PRIMITIVES ---
>>
>> UAF read:  confirmed. ioprio=0xFFFF written to live page before RESIZE;
>>            worker reads it from freed page ? blkdev_uring_cmd() returns
>>            -EINVAL. CQE ud=0x2222 res=-22 observed.
>>
>> UAF write: confirmed. Arbitrary write to freed page via stale PTE,
>>            verified with sentinel probe (new mmap of IORING_OFF_SQES
>>            does not see the sentinel written via the old mmap).
>>
>> --- LPE STATUS ---
>>
>> Cross-cache struct cred overwrite is blocked by a refcount invariant:
>> vm_insert_pages() increments page refcount 1?2 at mmap time;
>> io_free_region()'s release_pages() decrements 2?1 (not to 0). The page
>> remains KPF_MMAP=1, KPF_BUDDY=0 while the stale mmap is open, so
>> cred_jar cannot allocate it. Closing the mmap frees the page but
>> eliminates the write primitive (fundamental mutual exclusion).
>>
>> A fully unprivileged LPE would require a second independent write
>> primitive or a different victim object. Current PoC achieves root via
>> a research-context SUID binary to demonstrate the primitive chain.
> 
>>
>> --- REPRODUCTION ---
>>
>> Requirements:
>>   modprobe null_blk queue_mode=2 submit_queues=1 home_node=0     completion_nsec=500000000 queue_depth=1 discard=1 size=1024
>>   chmod a+rw /dev/nullb0
> 
> So... you need to be root in the first place here?
> 
> Since a) you need to be root, and b) you sent this to both the public
> list and the security list, why don't you just send a patch for this?
> 
> Taking security@ off the CC.

Since this is clearly just LLM hallucinations for the most part,
rather than waste my time on this, here's my LLM replying to yours.
tldr - nothing burger, send a patch if you want. If I don't hear back,
I'll add the copy part myself.

Analysis of "io_uring UAF" report ("Carlo")
=====================================================

Verdict: structurally bogus. The "UAF" isn't a UAF, and the reporter
contradicts themselves about it.

What's actually true in the report
----------------------------------

There is a real code-path bug: io_uring_cmd_issue_blocking() at
io_uring/uring_cmd.c:325 queues to iowq without calling io_req_sqe_copy().
For the bdev discard nowait -> partial -> re-issue path
(block/ioctl.c:864-873), this means iowq later re-issues blkdev_uring_cmd()
which still reads cmd->sqe from the user's SQ ring.

Why "UAF" is wrong
------------------

The reporter contradicts their own headline in the LPE STATUS section:

  vm_insert_pages() increments page refcount 1->2 at mmap time;
  io_free_region()'s release_pages() decrements 2->1 (not to 0).
  The page remains KPF_MMAP=1, KPF_BUDDY=0 while the stale mmap is open

That is exactly correct - and exactly why this is NOT a UAF:

1. io_region_init_ptr() (memmap.c:114) for single-page non-highmem
   regions sets mr->ptr = page_address(pages[0]) - the kernel linear-map
   address. That stays valid as long as the page is alive.
2. The user's PTE (installed via vm_insert_pages in io_region_mmap())
   holds a refcount on the page.
3. io_free_region() drops the kernel's ref via release_pages(). The page
   is still alive because the user mapping holds it.
4. So when iowq reads cmd->sqe, it reads the same physical page the user
   is writing to - not a freed page. KASAN won't fire.

The "UAF read" demo (writing ioprio=0xFFFF and seeing -EINVAL come out
of blkdev_uring_cmd) doesn't prove a UAF - it just proves that the user
can mutate the SQE between submission and re-issue (which is the
underlying sqe_copy bug, with or without RESIZE). The "UAF write" is
even sillier: writing through your own live mmap to your own
still-refcounted page is not a primitive - it's just memory you own.

Why the LPE claim falls apart
-----------------------------

The reporter admits the cred cross-cache is impossible:

  Closing the mmap frees the page but eliminates the write primitive
  (fundamental mutual exclusion)

Translation: "to free the page I need to drop the only thing keeping
the write working." Then:

  Current PoC achieves root via a research-context SUID binary

i.e. *given a custom SUID binary*, they reach root. That's not a
kernel-side LPE - that's "if you give me root, I have root."

Severity of the actual bug
--------------------------

The missing sqe_copy on the iowq re-issue path is real but benign:

- cmd_op is captured into cmd->cmd_op at prep (uring_cmd.c:206), so
  opcode behavior can't be flipped.
- blkdev_uring_cmd re-reads sqe->ioprio/__pad1/len/rw_flags/file_index
  for the must-be-zero check; tampering yields -EINVAL.
- It re-reads sqe->addr/addr3 for start/len. The user could change
  which range gets discarded on the retry - but they could've passed
  any range originally, so no privilege boundary is crossed.

Worth a small cleanup patch (call io_req_sqe_copy from the
blocking-issue path, or have io_uring_cmd_issue_blocking ensure the
copy), but not a security issue.

Other smell
-----------

- Path "fs/io_uring.c" in the report is wrong; the file moved to
  io_uring/uring_cmd.c years ago. Suggests Carlo didn't actually read
  current source.
- The reproducer setup (null_blk discard=1 size=1024
  completion_nsec=500000000) is engineered specifically to get a
  partial-discard NOWAIT -> bio-completes -> bic->res=-EAGAIN ->
  io_uring_cmd_issue_blocking reissue window - i.e., it exercises the
  missing-sqe-copy path, not a memory-corruption primitive.

Bottom line: not a UAF, not exploitable, and the reporter's own
write-up demonstrates they know it. Fine to acknowledge the
missing-sqe-copy and address it, but push back on the security framing.

-- 
Jens Axboe

