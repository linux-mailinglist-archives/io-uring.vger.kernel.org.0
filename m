Return-Path: <io-uring+bounces-13091-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8ClGO/uj52nX+gEAu9opvQ
	(envelope-from <io-uring+bounces-13091-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 18:21:15 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F2E4043D423
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 18:21:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A44AA3009818
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 16:21:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA02E29CE1;
	Tue, 21 Apr 2026 16:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="e5bLqu1+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0171F217F33
	for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 16:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776788469; cv=none; b=FGR7rLqIGu5FHRpOyQUxobNDReZgl3AW97nh/ewN2xsGAB7TAaas0pxwk1DvpnjHgbJhb1TEfvcpSTYZPfq1HkDtce6fAhOLdazNQlj9lOpfu7pifV4vzAz7lvSm1wYYaTMyBi60glGrp1tZPeWxLhWoDF5JgX3VM4JV2FlHv+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776788469; c=relaxed/simple;
	bh=vVbMyLXwEfwuHjVor4/Lf/dB1xQL6XpaU1hR6nXYlKQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=tz/+zl+YCGpY3ahGNYhD17RL4bSgSKu8mol+Hp16zw5PoOLY3SKz6TRYn2zS2jLRZ0Sr0WwqdFBbc7lK7p+yW0lhFrlyr9TOwmQjufCIPMJBe7CAF8t3zON6uor5w5M7KYZkiYhBmor+Y9FgTM1QkqDTQQStJNLpaeYOObHuJIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=e5bLqu1+; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7dccda31d3eso589136a34.3
        for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 09:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776788466; x=1777393266; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=720QGaySENMhKGJVSkl2cLWXtDogmIh6NC0VK0auNhE=;
        b=e5bLqu1+LUoG0sNvxkGcwgbHT9qh9XCJft/rDLpYXLChkdoYO9ORAj+BhRHwsql5s1
         aIzPtMWGyB7389kWmOTcHFffwfo8dSG5Zhj7E8NIlYyutYOkpIdfO5ajpSOluJBK+H+6
         ZiEowB5dlyCXql3Nk6mLgdwKzFDM3D/Dq9Ba4nWi/lb9Zkl9u9qXw8/UCTVclmrsDUHL
         32EEnnLc/FfzM6jpIg/w2TcW80OLdi+UGP6Zjpizt9tsg/mBA0t4GKQZDAmapLZ4JvNh
         ndBgB1QrKdlRKU5lp+LPhDDN0WvJH/MWQPUA3uz8kXxAr9LSyWH3gHqU3gmvDjeVEAQT
         kjdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776788466; x=1777393266;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=720QGaySENMhKGJVSkl2cLWXtDogmIh6NC0VK0auNhE=;
        b=GisI9O3pzHy+/KvMxi8Id3+s+uCSyurgJ2A+ZKuTJ8m8K2zvnJ4ZdNowxWU/ptLLpe
         Aq5gvDfAkk52Ip59coCyxQ9ByYzWu2prwHJgop7xHNlv9oJK7FzKnprKY+auCjhY4g/p
         VphaYCZcH4fgGgu4upobEET2TqL+3WBmn+9Zt3mAg96gb0j6ib79xx4UqAiWVa8PRckw
         cxhRnsHN8hahsa8pFqXsAK+nfv+wC93bNIrSUysRGa7YwNpzZzmY+WH0/6gBWFL7gERf
         XVbPAZOmynstMFCsoGWyyGVAo9vmxPTpihz6QdwNx2waqfORrYBiUpwlTL25c6E8JNIH
         LF6w==
X-Gm-Message-State: AOJu0YyO4448K3fPcqfYpmnIRpmTUunfGolUUVoq/SHChVz/clFA2TRs
	3JoVJD1TGoc8H1xAbaWtxMBrHkY8Rs0xCRrZsYYFvZepN4RiqUcHJ8HVDceKmjUnVIBHv+tvF7+
	7wqPQdgA=
X-Gm-Gg: AeBDievt7vT00U4eitjcHzRJOnBEQIPeL3+OjlYO6ImSh7I7yPup2/0w39oKjiGs0tj
	qaYA7YDBoT6ByFakjrG69dNSIAVVDjGR5dcbBJ2kDuQMobPEhbn9fJIGxfxQ4GdSvwtSJD+E92K
	265WNiXArefjLHAi1i5IIZykYkjoPgQwpHfH4jUYNw41XS+Z0pH2rRHkbudBKjTiPUA9MPyZs5+
	O1Be1E7sEE4GJyPWunZnfbXrG0kcHFpvwtCeOX57gQdDBXp+hJShC4WN3JGOlNvJjPEM5LwD2Pg
	fjOByz1AQauaebjFVnmIYlFK3HBxCvBTUCCbBNMHOKkCxh/HETpr+U6nzryMDCW3nlkyGn95UgY
	cXEYZVlxgsBx9hFhhgI0vm7B9gHiRoBq7XM8rdlHGWrZwHQKvZ/fpFKIzYHwypXi5Emp+/tNNkQ
	xQvufApGubcw9i41SFeShw/4K6WobBRkcMCzmmZ0w0N0luc8Z5cTBjOBGLXJMuVvE3P5xSP3lhB
	3NMokSIbi+DP9ybPxg=
X-Received: by 2002:a05:6830:6f90:b0:7d9:b4d8:38bc with SMTP id 46e09a7af769-7dc952a0a38mr12424950a34.28.1776788465733;
        Tue, 21 Apr 2026 09:21:05 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dccfe912edsm3490231a34.16.2026.04.21.09.21.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 09:21:05 -0700 (PDT)
Message-ID: <aed22e56-a39b-4c4b-a413-b5b1cd64deb4@kernel.dk>
Date: Tue, 21 Apr 2026 10:21:04 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: take page references for NOMMU pbuf_ring mmaps
From: Jens Axboe <axboe@kernel.dk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: io-uring@vger.kernel.org
References: <2026042115-body-attention-d15b@gregkh>
 <842a9dff-b12c-4cec-bc8d-8c1adb3ba280@kernel.dk>
 <2026042108-fiscally-unglazed-56c7@gregkh>
 <2026042140-arrogance-freehand-d8bd@gregkh>
 <c5077dde-0dfe-48d0-9504-76c7ff30b0e8@kernel.dk>
Content-Language: en-US
In-Reply-To: <c5077dde-0dfe-48d0-9504-76c7ff30b0e8@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13091-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: F2E4043D423
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/21/26 10:05 AM, Jens Axboe wrote:
> On 4/21/26 10:01 AM, Greg Kroah-Hartman wrote:
>> On Tue, Apr 21, 2026 at 03:55:38PM +0200, Greg Kroah-Hartman wrote:
>>> On Tue, Apr 21, 2026 at 07:50:32AM -0600, Jens Axboe wrote:
>>>> On 4/21/26 7:46 AM, Greg Kroah-Hartman wrote:
>>>>> Note, I have no way of testing this, I'm only forwarding this on because
>>>>> I got the bug report and was able to generate something that "seems"
>>>>
>>>> AI bug report I presume? Because I can't imagine anyone ever attempted
>>>> to run this.
>>>
>>> Yes, I got a bunch of "non-mmu" bug reports, which is a bit odd but I
>>> guess you can do that with qemu these days?  I should dig into that,
>>> maybe that way I can test this and get a reproducer for you.  If not,
>>> let's just bin the thing.
>>>
>>>>> correct, but it might be a total load of crap here, my knowledge of the
>>>>> vm layer is very low so take this for where it is coming from (i.e. a
>>>>> non-deterministic pattern matching system.)
>>>>>
>>>>> I do have another patch that just disables io_uring for !MMU systems, if
>>>>> you want that instead?  Or is this feature something that !MMU devices
>>>>> actually care about?
>>>>
>>>> I mean, who really cares about !MMU in the first place, we should just
>>>> kill that off with a passion.
>>>>
>>>> Let me take a closer look at this and bounce it past some vm people, my
>>>> nommu knowledge is close to zero as it's never been relevant in my
>>>> professional life time. Which is saying something...
>>>
>>> Let me try to get a reproducer going first, let's not waste any more
>>> human time on this just yet, sorry for sending this out without that
>>> done first...
>>
>> Ok, attached is a poc.c and a script to run it.  If you run this on a
>> 7.0 kernel today, it "should" crash. and then if you apply the patch it
>> doesn't (or at least that's what happened in my testing.)
>>
>> Note, I have run this locally, and it seems to work, but be careful, I
>> can't guarantee anything, it does seem quite odd in that it "crashes"
>> the kernel with a sysrq call to show "proof".  Although that is a cool
>> trick, I need to remember that...
> 
> I'll try and run a nommu qemu and see what pops out on my end. What a
> waste of time for a nothing burger ;-)

What is fix-paddr.py? It's referenced in the build script.

-- 
Jens Axboe


