Return-Path: <io-uring+bounces-13847-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id MilYGhasPmooKAkAu9opvQ
	(envelope-from <io-uring+bounces-13847-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2026 18:43:02 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B35676CF333
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2026 18:43:01 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=hKY081A0;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13847-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13847-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4B466306445A
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2026 16:36:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C79D73FC5AF;
	Fri, 26 Jun 2026 16:36:00 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34193FBEC3
	for <io-uring@vger.kernel.org>; Fri, 26 Jun 2026 16:35:58 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782491760; cv=none; b=eu0UjOPeBmsBCgwN7rNxA/Une89k0v+yIOISN/ou0UzWYBdhh/bADujzNYgu4bW+Z+9eEvuO4p3ZCwHj/+qNBcJGECR1F8h0TKkNlzQbj7sRVWyhXpBvDJvd6loC4PQrRzxXQan65BCWWwGzMb5dDa6YdIxQ1/BnkJe/LPh9A8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782491760; c=relaxed/simple;
	bh=Aj0WTVmhS7aLZdTxpX3GN4F4MUtqt5ZOTBmOAX3AZnk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u42S+K6/V/SuzCDYYtqgzm5J8+03YLbpgW3WuvwU+bXAZ9CCk+sZPtYgfxThrJtwJCGrDqE3d7Xh12AiLbRj8z7YIDO4YGxKV+zCGPfRakZF2b+OxRlvfkUBmsOXPGkewKYdgk1BWNZFWByf2xfyyOp5IxbB1HzJGuxmDXitO7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=hKY081A0; arc=none smtp.client-ip=209.85.161.43
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-6a11ee16bafso892025eaf.0
        for <io-uring@vger.kernel.org>; Fri, 26 Jun 2026 09:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1782491757; x=1783096557; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5LryfOXbo+aV54LLElCiIhQ/hcSrjxvLdKj9Okup0D8=;
        b=hKY081A0NT3z6rYlkqNgnCl/Mr6z49bh4in4nZFSZC19YwBWpEJcZoDvJAXnFjovVq
         8FNO6QUIDerKBwIQ4Sw6nTyu+BoUsSVTKxagkwXXVaVUCAebg4yspd5d6LnWLlNb/+xR
         wRNSkbZojxV2U7b7mtxQD/rZn0mjy/yd+sFbKYoc0g99EURXkJgRJhSSOcasYifbpXPf
         dKa4Z3Bfro2bK+gF36LN/vnufj9Nqcdg3TCxWar92wbkuyHs6rLg3o8HRbr5xfnBZSV6
         J3OMzpCdfEcjm+BxlbfkGLnlaj15pT/cOMPPmXLFRcAz/ey3dKMfllfI4F5okR0bVwrs
         esuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782491757; x=1783096557;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5LryfOXbo+aV54LLElCiIhQ/hcSrjxvLdKj9Okup0D8=;
        b=Sr35yZ6wx2/DLRMrGdhE4SjBl8TAcEDFNzEWLvBo6WujPwgrYw1GuwprIiCQFMvbhB
         DhtS8rWkANCa/fDljazb671i07lSGsMbtLZhwe7jAxwHjwMsSa3RdDYlAAuaHresQF9T
         XJbkMAOobXCUcYjgiQvPjyXH+guLddZvvDTRQOxA0E/RgXFemrDf+64TBPWNbeokv24n
         FOFwOoSY7MJITV8iJ2MdCxpTjjZ0jzkL8XEAOihkcy9HD7PFOohP70HF+BD4IT3puZvG
         CWGm2ctwrUzzEL/AdzRC+UfVpxncaoqqASIsFiQN/ojRScaj0VF5f4aKsk5+yE6ZMWBm
         vTOw==
X-Forwarded-Encrypted: i=1; AFNElJ9LQFSAUL2DGlmfAPuZmfT0yxKr8w4ndTQBlyh2/6gckX3jeQDxSD5HnVL1VW/k6/lODKOZvOfkCA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyA3rlu1Ah+ZiUdiIMq3d7+XvGQgMkWaZs65EP1JDf7PaD8aHA4
	aEnc7+f2jem9RyQZvVknsnjtg/qBhCFB56IPJ4QJ9N90D07MXyMcBhZXBsyr8RJyf1czlXcO6/9
	MxFlgTug=
X-Gm-Gg: AfdE7ckXfUtH2nrjUpEOL7gqtZBw5dowexf0re9XTHsoeWYTHy9Z2TEP/2khFi1BCx8
	wl5wEbyYfih+CAjifdlVD4UsDZdL8fgQxwD0GpwHEA3JajxLfj0L0iBSmYgutwLByxq5WJORICw
	kSJ3yH+qWMyGCAgVki5Ivolg+xE4DbqENLN9hrAS1EcgpJfV5Dvqew0ccRd0sZKQN4B2mmKtRw6
	gvamVbwnUlbH0JToO1cqBntkYTEXLos/mgcEV71SQoCw7sUYBnwvgxpgYm1DERZ3gMoMxeM8Cs3
	81vCc/zA4N0YYg+Y6WSKLd884Edi+/ZgMcOYC/4VHRDnxWtryYDrRGnW3PV+Tk9yPIu/O6WFVjA
	pr+g9tfAIYPu9Zed57r+hzFS0V686WqMrlNVU2s+BdDxhsR1ptFxTBE+3v05A60mP8S4iPRvLpL
	827/xe02Vevbh2rBg+9q9J2eOA6jyHWvf0DAEnwJ6FsY1PqmwMwND4odE1OuP5zATpKyljJg==
X-Received: by 2002:a05:6820:2216:b0:69e:3bdb:70f5 with SMTP id 006d021491bc7-6a135246610mr6365519eaf.55.1782491757636;
        Fri, 26 Jun 2026 09:35:57 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a1414ec350sm1669115eaf.12.2026.06.26.09.35.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jun 2026 09:35:57 -0700 (PDT)
Message-ID: <94614dd9-9351-4a64-83dc-4fc87e377e59@kernel.dk>
Date: Fri, 26 Jun 2026 10:35:56 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] RCU hang with io_uring nvme polling
To: Keith Busch <kbusch@kernel.org>
Cc: Ben Carey <benjamin.james.carey3@gmail.com>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260626150946.287781-1-benjamin.james.carey3@gmail.com>
 <85d1f999-7778-4c74-9d72-b8ac8500de31@kernel.dk>
 <aj6jQyJd3zmZFcwx@kbusch-mbp>
 <1932a509-4e27-485e-8e09-1da67e0082c8@kernel.dk>
 <aj6p3kZy1a8Mf68S@kbusch-mbp>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aj6p3kZy1a8Mf68S@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13847-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:kbusch@kernel.org,m:benjamin.james.carey3@gmail.com,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:benjaminjamescarey3@gmail.com,s:lists@lfdr.de];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20251104.gappssmtp.com:dkim,kernel.dk:mid,kernel.dk:from_mime,vger.kernel.org:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: B35676CF333

On 6/26/26 10:33 AM, Keith Busch wrote:
> On Fri, Jun 26, 2026 at 10:06:49AM -0600, Jens Axboe wrote:
>> Ah good catch, I missed that. Should've grepped! In general, IO should
>> either get polled, or if the device is misbehaving, then timeouts will
>> catch it. That said, haven't looked at the actual report yet, will do
>> so next week (unless you beat me to it...?)
> 
> I'll give it a shot!
> 
> The test has 1 polling queue with 2 jobs dispatching. One of the job's
> polled the completions for both. The other job is polling for no reason
> at all with nothing outstanding. The only thing that can break us out of
> that loop now is need_resched(), but that appears to never return true.

Yes, it's a bad configuration. I bet it's as simple as:

https://lore.kernel.org/linux-block/20260617155051.1266079-1-anuj20.g@samsung.com/

but in practice nobody should configure a single poll queue and run
multiple jobs, particularly not when the object is framed around "energy
efficiency" as this configuration is pretty much guaranteed to waste 2
cores, with most of the time going towards spinning on a lock rather
than doing potentially useful work.

-- 
Jens Axboe

