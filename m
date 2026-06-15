Return-Path: <io-uring+bounces-13730-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 1suDBvIkMGpbOwUAu9opvQ
	(envelope-from <io-uring+bounces-13730-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 18:14:42 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 83323688342
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 18:14:41 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=uB9BRVYm;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13730-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13730-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DDA56302306A
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 16:09:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3B0140861A;
	Mon, 15 Jun 2026 16:09:16 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B6F407CEB
	for <io-uring@vger.kernel.org>; Mon, 15 Jun 2026 16:09:15 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781539756; cv=none; b=H+OqWpsiXSCZB3jV8NLor3A6cG3GtGLkRsac2rILCifhFL2LEtrRj3SCKeF4+qe0P89NYlpjOywmlqSVLS93MOfNHJbVPJr8a8UL9FGe+1I57l5FT8KZN5wNFxiRwRJjoGKUKuypt5+l+fi4ydBoSZ2UeTjq96d0gnVGLdCVlMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781539756; c=relaxed/simple;
	bh=5fNDYoL3t/NQXaAmgk9uSswjWt7W7t1APE8IQPQttPs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FmZGcCiHaDCqtC/IO9PzoZS0IIWkfzxsTCCi5rA81c/s44zREvOGXsEb3v9rpazQo9vF8jvUekepUeihT/JcEJxNFKhRxmlFOxUGvC/uzQVEOlIdNYm6dEv7cSJHa7RmDg4iA7rmJJbFeYYQuN6bSD2w0GIsa77VMT+hcX2tiKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=uB9BRVYm; arc=none smtp.client-ip=209.85.161.42
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-69e9b037d82so2737049eaf.2
        for <io-uring@vger.kernel.org>; Mon, 15 Jun 2026 09:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781539754; x=1782144554; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JbGcf2V6tb+OQGH7QxHtwuaw5rUisvVvpnZ5K9yeiFY=;
        b=uB9BRVYmJ+FyzLf51hKp/S5r2PvPgyF77ttb1fVkfjRYpqLWQln9lZqIHyjKUveTyu
         UqvDIO7+YdBcaAB8KhtzA9zYZIZ83YYQVD4lxUQXPFjvGhKf3xUbls+aDEpknHjPvC1s
         q4QM8ulAirE8+AssPFbYecacezXtqFokwg4NTc8Tevnuspbh6qTGDSLtatGLwwKQQyXO
         BVWKu9J+jIRixmwOjyqNdj3/PTkYGflS8qISosJA48iQX7jS1fw/xF4sUNF7Mg0qQaHK
         vkAw4MG346toqBVQoWvMF9045rQ8htodKbfK5bakhvQkdk2K8bgnOei6twqSGCFsbBKs
         cP7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781539754; x=1782144554;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JbGcf2V6tb+OQGH7QxHtwuaw5rUisvVvpnZ5K9yeiFY=;
        b=AGNLAWraRh7GQL5BM5lWxv3UvIcqAUzNJaRGADWNySDlY0u/92P/vWVU2Kbdm1UtUK
         SdBDNykwLZuNzI7T8NYoky5QhDcSnOiKvbKNrUe581bdXh4Isu9YvVfPLDY+ro/VK+PV
         /pBCQ42E5JplkkujfMlZHuK0P7VezHC0ZV6TVyj2Tgm/xZGVbhcRvVjQiIVoYDFaknOB
         WqELddKezvVAH7eR7JcS6WDIKPj29vueCq/LDIl44sX98lzrU4JS1EgnRhAJzXIHYWGH
         +DHZV3mMqIFrDTNHZ1HB60LeMoe14Xal54aw3zMon0koTdfCmRwREF01wVvQt+t8vZ9m
         oK7w==
X-Gm-Message-State: AOJu0Yxn6jeM4TG1twfu2H7a0piVzvUKadu8hisqT6gGybNQBYFzAvZu
	jjKz2QRKt7p5ax/hoZupdmdAt0G6FSNFz8nInbYUg+U02QWkuYaY9cRAVm81cO7saxaeJSLYvkC
	+BElA+mM=
X-Gm-Gg: Acq92OGklPDWAaLN/pXvK32rD7//U9X7c5qQ+sqexoOh8WQORl7fOx6Bltl1xxJqiVZ
	Psol7jCW5sYPYK7xgHF6AKKpXwbWQBLzjBxQ0l/45wDrxL4atHUQEFvhRl63qvbxgCgJsgGg02g
	6+Nnyvx9fHvXNwu6lkeGEueOxEzdsMRLzuxg7xkf7U16OrkTsiiuzGhBcA5NlTyIxGIoXLmxh73
	q3Iz2qlhJ9q8dIf/mhzBw/lUU/11Pco4tLaZu7Y8zmZzzh4j1AnstCyvo/YXThBK/98C7tBU4Kv
	VFlE87GzjyuR1DE55KAa/NMNOIEe4LsD2ovNYbsKlZ+/nBLaR/baQQ+kZ2ij0wH0E3INdEleSSc
	UJnuZRTAodOdja5X629TFZZKB9E33/ngiCIB/IzgiqyMU5RBODJh7kkDLZOon6bdnvkGJZjFrzb
	C4MmLhVDml9HKWPf417wLS83xrkJg8ELehBtsoKIJmBdnz+35znk4l2RU0AHQBCfWTbvtmIF916
	vEJnAo5
X-Received: by 2002:a05:6820:4d05:b0:69d:513e:1a6c with SMTP id 006d021491bc7-6a0a40eb06bmr38092eaf.50.1781539754343;
        Mon, 15 Jun 2026 09:09:14 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69f00ce1f72sm3144716eaf.1.2026.06.15.09.09.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2026 09:09:13 -0700 (PDT)
Message-ID: <8c1ca105-e27e-4b84-a7c8-f928c05ac7f2@kernel.dk>
Date: Mon, 15 Jun 2026 10:09:12 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/nop: fix file reference leak with
 IOSQE_FIXED_FILE
To: Vasileios Almpanis <vasilisalmpanis@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260615144619.482749-1-vasilisalmpanis@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260615144619.482749-1-vasilisalmpanis@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13730-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:vasilisalmpanis@gmail.com,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,s:lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,kernel.dk:mid,kernel.dk:from_mime,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 83323688342

On 6/15/26 8:45 AM, Vasileios Almpanis wrote:
> NOP file-acquisition support choses between a fixed (registered) file and
> a normal fget()'d file based on its own IORING_NOP_FIXED_FILE flag in
> sqe->nop_flags. However, a request's REQ_F_FIXED_FILE is set
> independently from the generic IOSQE_FIXED_FILE sqe flag during request
> init, before the issue handler runs.
> 
> If a NOP is submitted with IOSQE_FIXED_FILE set (so REQ_F_FIXED_FILE is
> set) but without IORING_NOP_FIXED_FILE, io_nop() takes the normal path
> and grabs a real reference via io_file_get_normal(). On completion,
> io_put_file() only drops the reference when REQ_F_FIXED_FILE is clear,
> so the fget()'d file is never released and leaks:
> 
>   BUG: memory leak
>   unreferenced object 0xffff88800f42c240 (size 176):
>     kmem_cache_alloc_noprof+0x358/0x440
>     alloc_empty_file+0x57/0x180
>     path_openat+0x44/0x1e50
>     do_file_open+0x121/0x200
>     do_sys_openat2+0xa7/0x150
>     __x64_sys_openat+0x82/0xf0
> 
> Decide between fixed and normal file acquisition from REQ_F_FIXED_FILE,
> the same way io_assign_file() does for every other opcode, and fold
> IORING_NOP_FIXED_FILE into REQ_F_FIXED_FILE at prep time.

Fix looks good to me! I've written a test case for this as well, it's
in liburing.

-- 
Jens Axboe


