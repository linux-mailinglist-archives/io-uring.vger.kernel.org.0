Return-Path: <io-uring+bounces-13374-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EBGpHFbACGrh3gMAu9opvQ
	(envelope-from <io-uring+bounces-13374-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 16 May 2026 21:07:02 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 125CD55D748
	for <lists+io-uring@lfdr.de>; Sat, 16 May 2026 21:07:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 847F6301725E
	for <lists+io-uring@lfdr.de>; Sat, 16 May 2026 19:06:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADD7134B437;
	Sat, 16 May 2026 19:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="Rf1HNgO9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A9D197A7D
	for <io-uring@vger.kernel.org>; Sat, 16 May 2026 19:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778958407; cv=none; b=rzpf5bT3lnuEY2zz18NLArogketeaNeHcBLIFWuVB5Ma8nUHQHB8rsYPIcpS5wn6cLETb3jc9FV+ABRWpTocmkQIGr4WHFnkY01bsAPGDMwCQHY4nH8nDJ1XTwS+TTkGbZlNDN8A+qNOlpUuCwnHBg6ltvK01JwOgruLClMw9g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778958407; c=relaxed/simple;
	bh=aOOOxtwS47BU27kjezp+YWuh0no9yiOta0v8lP6p424=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=kj3oGCmkwdTRudrP0IrXQC3kjNzokujkDv2bh435lLUO3CHf3LI3aezx8hsRlFQGADRVgp0pyZn+jBOV0vClDV1s/SuH3LxGTdusgEzpk1HEqMJ1orT+myk/X4j63oREscBpe2LJ4j7qM2jASkZienjZjqVbcXneHw/k3cJbC9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=Rf1HNgO9; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7dbd23bc684so465775a34.2
        for <io-uring@vger.kernel.org>; Sat, 16 May 2026 12:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778958404; x=1779563204; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qaeOTyQgpMmhTaTkzXZZ6dUGH8G4c8JGdwyT+X2ku9U=;
        b=Rf1HNgO9HXQMVG1OXYTwvQy5HQkJI/cgD5yq6qfSv05nVMQf2RWm/ydTL3fMRYVYaV
         tAlI0Pq84UArCPjDAuf+2FsJtzJpz5WZLJvUOthL0gYguNsYm1BygEtmlg6h5pQ9bOCf
         zpzbXLYP86XOdHgzLgJ16tsSAsnuOJif0xWZ737oO/Cw9DZmaD7k7KrN0dj3fVzh0UI8
         0s9HePkJ2drxmQhiMjeEYCSKw0daD1ivCjOZ0IecVD0v4prAcMAwu10fM/+lN+F4XSjv
         2RTXs0l0i7Yh4PBhxkmtxHSkA6295HVnR3nZZeREdy1tqN+LBCST5VlMHcTebXBL0Adl
         UaQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778958404; x=1779563204;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qaeOTyQgpMmhTaTkzXZZ6dUGH8G4c8JGdwyT+X2ku9U=;
        b=VxNSJJO4GVp6s3ZwtTUfjBpqYtJ4bkn/s6cGg1GcXWFA9rV8RdBKpF1Qe3KJdQs+N1
         vK0yrgD5zp8/Zpr7+RmayY0VcRUk4hfMtQFDsxekcfUSXanNnSse8fIBCErY6Q5HALwv
         n4FszSuHWT67rKaBMko0l0w3i1O+eVr8trO0dlSzF8JR1q5D63RixxJtHsUfD/vu6271
         fUOh2rGEDKAE1f5U3qMcBy6R5EtYMHZCrBHJ/SWXK94A5Xp7BMIFQDxIrjvA/Rf3Pxv0
         orfY067X0KfQ/ogUtpWzgJ7dLqqn1T0G9FYjg6H/5Hf0BacMEj/DbE3OfDZRXVjnBbHP
         N5xQ==
X-Gm-Message-State: AOJu0YxkEjrrs/NR3Smjvr2vi4PL3+V/O4xWPt+Va3BsGDYPayqSPwHo
	BdfcygFPOosQ+H7qpx2J/98Jzv34CtopwSgaAYBN2Du5uQ9pukz2AL0hfXEosWwkNUSPZZEXqGD
	kRRPs
X-Gm-Gg: Acq92OHWexP3UstM7KcFWHzPUUyzvDdepUq5WUq5sLFpmRdORKcjcAFjJzgqNSRNQG2
	5X1+YwRJRcJpbJ9SpWFfCy9CtYX6i/L6GsKe9AZyCHO8j8z6MMAtrN4iSzT6W7oLwCVn3vD0Arl
	j7JW3RBKPQALAGEE3KHMGByubxtHSZoqcuZQtza4y5HvAK5p7c4fTY2GxPJFKpARF+6gsatce8T
	gyQpycBEqtkSf33QeW3y36V3Voo9CUhid/Oe0O2ZbT0nbAdgPl8SNjYCV0ifes33Zr5thhxe78u
	3J1pc3vCujizlil8HLNC7EdpQJcq1QZpZyUwRncRGSkKWZXLb8gl14P0KMgEHf5u180qpXsZLal
	QwJU4me3FO9cn6t7JEalOJ6sDHvWRPd9JbEPgCvuuXTb87cnu3qCv1k6lqL9gvvO1IIAQOc3RGw
	DURCFXLE4jlqHY9l41WfXuLPmJrmXux76x51SNLTtfXGg6oLlxCdQyTamLK9Ch+SjOpC5El5rMo
	R3dCw4b6p0kkWXumiTtoFM5jKvwJjk=
X-Received: by 2002:a4a:ec43:0:b0:69c:5d2b:4079 with SMTP id 006d021491bc7-69c942a5fcdmr5095624eaf.6.1778958404415;
        Sat, 16 May 2026 12:06:44 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69d046130cbsm3090413eaf.5.2026.05.16.12.06.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 May 2026 12:06:43 -0700 (PDT)
Message-ID: <21a2b88f-ec94-46df-b018-8a027689c38e@kernel.dk>
Date: Sat, 16 May 2026 13:06:42 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: propagate array_index_nospec opcode into
 req->opcode
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Michael Bommarito <michael.bommarito@gmail.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, Li Zetao <lizetao1@huawei.com>,
 bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260515145812.1241925-1-michael.bommarito@gmail.com>
 <177895835722.925638.5480075990608035864.b4-ty@b4>
Content-Language: en-US
In-Reply-To: <177895835722.925638.5480075990608035864.b4-ty@b4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 125CD55D748
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13374-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	FREEMAIL_CC(0.00)[gmail.com,huawei.com,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Action: no action

On 5/16/26 1:05 PM, Jens Axboe wrote:
> 
> On Fri, 15 May 2026 10:58:11 -0400, Michael Bommarito wrote:
>> Commit 1e988c3fe126 ("io_uring: prevent opcode speculation") added
>> array_index_nospec() to the local opcode in io_init_req(), but the
>> sanitised value is not written back to req->opcode.  The
>> unconditional write at the top of io_init_req() stores the raw byte
>> into the persistent field; the success path of the bounds check
>> leaves it unchanged, and downstream consumers read the raw value.
>>
>> [...]
> 
> Applied, thanks!
> 
> [1/1] io_uring: propagate array_index_nospec opcode into req->opcode
>       (no commit info)

Oops, was just applied for review, nothing has been applied. Awaiting
a v2 based on the feedback.

-- 
Jens Axboe


