Return-Path: <io-uring+bounces-13644-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id f3nJMWLqJmpOnAIAu9opvQ
	(envelope-from <io-uring+bounces-13644-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 08 Jun 2026 18:14:26 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 4165A658909
	for <lists+io-uring@lfdr.de>; Mon, 08 Jun 2026 18:14:26 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=cbvf0UxF;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13644-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="io-uring+bounces-13644-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9B0403139CD8
	for <lists+io-uring@lfdr.de>; Mon,  8 Jun 2026 15:57:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9891731E82A;
	Mon,  8 Jun 2026 15:57:08 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7EAA31E85C
	for <io-uring@vger.kernel.org>; Mon,  8 Jun 2026 15:57:05 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780934228; cv=none; b=LUybsrhZznIyhqM9gF1ZsHXcmoTHbUL2AIpjWG5iOIpFkH2kKAXIS3bJGgkEHjo4wuGDtgnJ0xU20VOKJpt4HqtURRJjAT7nyVO11v6RzXjldE5tl1rtBUQGhtNYisyVXWgYSMOK4Z1/dOKMKK/rXb/0Q4f5C+CIUTUZeUgK2pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780934228; c=relaxed/simple;
	bh=945iUaWaC+0sbuwhc+JD3qPOzJ9LHnPGhsHw5uznNhY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bXQulnNAP4NcvnAT6LTQtcLVfus8oGtf0xGQ6ppQbMtXcOxjHXebYoIZqb3rz+Tucfz9dhmQqPoHXl0bGAwZJMvb7/414AhpZx3YUnm3H/Wwo5caDPuNfQIbDf8dUnn0nCs74hvKoKxQRam5bUcIqwGaeagFKIV9bxQ91JqkDPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=cbvf0UxF; arc=none smtp.client-ip=209.85.167.181
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-486b93fc7c8so671198b6e.3
        for <io-uring@vger.kernel.org>; Mon, 08 Jun 2026 08:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1780934224; x=1781539024; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uboJEfGdeULZH+WbPQgJR/aqC2xi1VBsBXohsfanUA0=;
        b=cbvf0UxFRPMIPk2mzPAS+ey7LH5mjq0ahRuhnbmtm7MMpbg0zwWVoUl1Y+b+RcpPm5
         v6f2hzkWU4lacBzM+LYRGwzyThWPtb6mKAfHllD3SqM0e0OwiWRJ+HfC+iG/lMNZi3z5
         tPkP0kHtloCwrHYF+7TeHf/9+2/X0+YBvIN/e18uFlXtLTrXuqfwCGtVZmahpCrOw6fB
         6BWovpsJSSgU83FUCjoITZLIIsQxc5fxYHN7PSdq22KTuc5WVDJ9lRRO13D6Vo4od0Ft
         gtyno2h0/D3BPxAS/4Yp2+hEIDDHWcIcOCEIYWPUx0ylJQaFKTmODOz+RadIW6HXXQ6I
         A+sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780934224; x=1781539024;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uboJEfGdeULZH+WbPQgJR/aqC2xi1VBsBXohsfanUA0=;
        b=g4x8E6OxqrRogRaY4KuouEHzZA1celHiTbB2cZ9sfKaszNCnOKQNd/nmwElFaaFuFK
         PRgaiuxi47aqlJgjwQIjX4hSCLOqxsQZXN6CUR5OFpsn9GJ5aVLLb/MgEIdAQGaEbCk1
         uG7+6ZPN5SVrNJ0cdjj8WapHCigNX+Y3wnF53vM3iAnKlhNCS+fee5UnuGWUYicAsKfs
         5tfBJxVpsPL5fgJM98EoX45WLKYXzkpNEaLcI3sRVLI4zwaVCAsHMJ+zo1YJgm1vRami
         hLrZM2PtCB3hKG3+MKV1CiMyTk1sXgiNOvdaEv77PrWzd0S6SRK6fd/KhC4zLtT3ZLzr
         qpcA==
X-Forwarded-Encrypted: i=1; AFNElJ/iO2eJs88y00O7Fs7YrZFj7sDki4aIravBvrRyZ0dce+3+JZxnaxwc6agClJDhCdF1/Hn0vSqO0w==@vger.kernel.org
X-Gm-Message-State: AOJu0YytDLRFAEmu2PFfyqVGJa/o5vaksAMcwsrBpc3tc/+tGDQpkH8E
	Mm0gecu8PRrm8JF00UcewnxT9kpL19hotphq+SlfH/XC3PTRCbPMgWkpPhz7zje1vms=
X-Gm-Gg: Acq92OGaiUbJ8FfVBjNp8E8HsAdcusGjTQTCmQJzKKHtbaltZLdl39l1kDqmgyVPank
	PwDQI9U6pod20ZaqFlFWOpgzA6n1Hi5CykuaJb9DIIX8GtELJ7xzwfv8OWsyoT39hOsvEVPP761
	s9kY2/gi0IuEypOMd9pQfTdWtBa40w0mUUSY7qAiSlXtJYW+oNPrf0HBBHbQ+gaJ7DSNGX8z80H
	j7A3pE3lzoXJI6WbP0qcvJXz/G7qMFTgdK47BUl9Exx/q5t2jQkq6pBKl+Seq+diqx4pmESxuHj
	VlTNKxCOkfOYZ4dX3vo/HKFbL8ECvjpfJI4XRIzdl9x3DtVMamiL20A9bK5Of8Gu4HByShZm6Kp
	jQXruIlzkWBQs9A27nimk7p7xjt5pf8rWTx79ONTtM/fN5f988F+k/pzKmdgKc2a4aGpV6LvpH6
	zUWwSzCmpGuVkmDOCpYeVoptjhtMtFanvLldESbhrluiFq/AOZkWPpU63x0PYOTBimV0pJhNWpp
	BRssrv67cbggre3gtaV
X-Received: by 2002:a05:6808:1b25:b0:486:560d:aa9c with SMTP id 5614622812f47-4868dc63516mr8563993b6e.15.1780934224561;
        Mon, 08 Jun 2026 08:57:04 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4865b5a53bcsm13980952b6e.3.2026.06.08.08.57.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2026 08:57:04 -0700 (PDT)
Message-ID: <bdd63eb8-e8f8-4640-b769-24ceb619779e@kernel.dk>
Date: Mon, 8 Jun 2026 09:57:03 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1] io_uring/rsrc: add fast path huge page handling in
 buffer registration
To: sw.prabhu6@gmail.com, io-uring@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dave@stgolabs.net,
 dongjoo.seo1@samsung.com, Swarna Prabhu <s.prabhu@samsung.com>
References: <20260608062937.804758-1-sw.prabhu6@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260608062937.804758-1-sw.prabhu6@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:sw.prabhu6@gmail.com,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:dave@stgolabs.net,m:dongjoo.seo1@samsung.com,m:s.prabhu@samsung.com,m:swprabhu6@gmail.com,s:lists@lfdr.de];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-13644-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,samsung.com:email,kernel-dk.20251104.gappssmtp.com:dkim,kernel.dk:mid,kernel.dk:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 4165A658909

On 6/8/26 12:29 AM, sw.prabhu6@gmail.com wrote:
> From: Swarna Prabhu <sw.prabhu6@gmail.com>
> 
> io_uring sqe buffer registration path returns pinned user pages in 4k
> granularity. If the first pinned page is in a hugetlb folio and
> pages[nr_pages - 1] is also in the same folio then store a single page
> entry and report *npages = 1 while dropping nr_pages - 1 of the pin
> references it took earlier.
> 
> io_uring has support to identify and coalesce multi-hugepage-backed
> fixed buffers from the function 'io_check_coalesce_buffer()'. However
> we need to iterate over the entire page array and this patch bypasses
> the additional checks for this case. The fast path reduces the overall
> sqe buffer registration time that are backed by huge pages.
> 
> Measured with fio on bare metal backed by 1024 boot-allocated 2MB hugetlb
> pages and setting the cpu cores to governor for max performance.
> (hugepages=1024,hugepage_size=2M):
>   fio --ioengine=io_uring --rw=randwrite --bs=1M --size=2G --iodepth=256
>   --direct=1 --numjobs=5 --fixedbufs=1 --registerfiles=1 --iomem=mmaphuge
>   --hugepage-size=2M.
> 
> Avg across 3 runs:
> Metric                          Upstream(7.1-rc1)  Patched    Delta
> Reg time(io_sqe_buffer_register): 3797ns            2970ns   -21.8%
> Total reg for workload:           14.35ms           11.34ms  -21.9%
> fio write bandwidth:              1416MiB/s   1416MiB/s    No regression

This looks pretty reasonable. Curious what inspired this change though?
Workloads that register and unregister huge page backed buffers at
a rapid pace? The registration path should obviously not be slower than
it needs to on purpose, but it should also not be part of the application
fast path in general. I'd expect most users to register their IO memory
pool upfront and then never really touch it.

Can you expand on the background that led to this?

> Signed-off-by: Swarna Prabhu <s.prabhu@samsung.com>

This doesn't match your From: in the patch, that would need to be
corrected.

-- 
Jens Axboe


