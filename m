Return-Path: <io-uring+bounces-12673-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MEGXC05ktWke0AAAu9opvQ
	(envelope-from <io-uring+bounces-12673-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 14 Mar 2026 14:36:14 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 82C8428D558
	for <lists+io-uring@lfdr.de>; Sat, 14 Mar 2026 14:36:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 07DEE302EEBE
	for <lists+io-uring@lfdr.de>; Sat, 14 Mar 2026 13:35:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F890352C52;
	Sat, 14 Mar 2026 13:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Dra4U5w8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A453783B4
	for <io-uring@vger.kernel.org>; Sat, 14 Mar 2026 13:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773495353; cv=none; b=TIsDgsbaZxtfIXAA8RUA8fNxN1my0UVLxknVdsGrAbzovYXRdBYdGJoK64EDqVQooqzwLpszA7xfqKgf7dVtGJdiUOcOkSE4gwT4ODysSgABc+u/LKSS/Mlt//WTwpG7UB25+6dBUJ1iEy5wUeJUEqzEeYGCNSSKkWHHHtLQxX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773495353; c=relaxed/simple;
	bh=bWpowM63BrZEH+zI17cM2MZK1ngl/LVP4JxfMAV9JPQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iTirnjzX0fHTcdC461bRhX0dbK/Bw09QJyHyhwCg7U9+83YheFmDB6l9hCxT1hjTFRLdfWvgKp02DfufSdkht6smX6jgkGIBABqPv6BDuDVimK5aUxpW1hivOj6eFo1PhjysIHTfaJAG51L8QqFsO4GUKxT2dZU0lB6ISNwC7jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Dra4U5w8; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7d74dbfe84cso2179068a34.1
        for <io-uring@vger.kernel.org>; Sat, 14 Mar 2026 06:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773495349; x=1774100149; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IG2eajPCTB7XfJNVFuvwk73xzuAipJWrhOXlM3M5KjY=;
        b=Dra4U5w8xtbt1VFkdT6kTHlfdj4AwesRxrAkdWx3TPnHTJwSa7I91HK60tONyh4+c8
         t47nQT6DjSUc0eUAIFUKgTrlBbS7L3AlMwriVuM/uLAtIs3YXzYtdrfYFqw7uWvebX7Z
         t2tH3UZVOOaN4LEtJUxjz37vtNT44EF6NL0aA2kCAwINl9Yk01ryjmhFhXpsgFb9wimd
         Bs7DnjZ/7uyFduFHCq/IsApthngs4eUMrHKxVw4A3oh1kXZe97Ym8X2L6/OPBpzjHtzA
         5DqLWr719IGE+K5thvmvlLQh080v03my/GvyTBWym+FvQw63FRbwJ1LuQxtrSIoW06Xu
         o1AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773495349; x=1774100149;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IG2eajPCTB7XfJNVFuvwk73xzuAipJWrhOXlM3M5KjY=;
        b=QKdH0nVVxvLGK34T9+GtfjhHBaLdhRet7snKelmQ6orEFVfgNA6eglkVL3d9K+rHyc
         UdRkHS4KRmRqIWRHgFgARXRxyRXp3EY1YnVx7SYJdGzetiKW4knjznIvNdwkFeTAaJua
         j4dP+HR8yoBLQUgipRlBm+bmuPdj++mJOoTQyk9SxVFsJ6nXc/h11s046ly1KnQ1wv3a
         Mqn85w9EOAKIar6/kPiaLHijpy4GqDFNvo6XIOF+CLkEzkSzynr8UW1KmAhktBXOXc7Q
         q3tBXWwgP8ftkT6PagpClm7F10cB6lOtn/Yq/OyDSRsJFZr5VlX6pVSRtMRoKsfNJ+wk
         ey5Q==
X-Gm-Message-State: AOJu0Yzu91qmcGNQHZgY9zurS7rszL+zGc+XzjgOdJ3f5t7XAi8JR+Zm
	TBUcYSGsIJ3GIdejaVSSCz1wEBviWKphPqROKaCPI6U4e8MJ9/mxLuZPoF7uy3wDeAyUtTRK8RO
	h0C7vaF8=
X-Gm-Gg: ATEYQzwGJBPvywdQkXiae9dr7BX6gTN5poD/FAzig4ymgaMxovgCoLCEOHOyYH9qOkf
	8fnTjGC69LRlWKF/VA55Drl90S/XshW8jGx4TJ3H3KCW1Qtc3SFFxxN9+wG2FVd2/qelsuCDJeN
	Nl6XK6pY5KmFJN8gurDsWesOXimvDJ5do/vyTE02Td1gRvh26MFmQ9S1sAmaTMuQ+3crrErmv9B
	Pths1VmlcIhmrJ6/ZKR50kkzHm9UO74+Yp+WDnksX4/qJXljLpjeJNGXJ3ga0MzsqwD/8ZjGG+C
	IhkXbdsFQMUEjm4KgpswJcEqNFQ5mILqapPvoCZ24gf0e5XmdbVACqUa6YM/PL8EtHFfFHnLJ7C
	jhAcIiQysW0xMEwkg1MfCMrzCA6avX2r2XGwwtMS0RkQFAsC3nVc+SXQgXY39Sa0VSo9Ktn0VKK
	alk2piVphdMWd7wHarwZ4yzoUgtWLpCndi9SskinGV/6e5Um+W51ylVbO1ACxhfnxujacnmIrQl
	YttMouuWA==
X-Received: by 2002:a05:6830:3c85:b0:7cf:dc3f:6b34 with SMTP id 46e09a7af769-7d78258b4f6mr4645436a34.20.1773495349294;
        Sat, 14 Mar 2026 06:35:49 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d76ae3a55dsm9385071a34.13.2026.03.14.06.35.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Mar 2026 06:35:48 -0700 (PDT)
Message-ID: <10b4b9bf-2dc8-41f3-bed2-110170dff236@kernel.dk>
Date: Sat, 14 Mar 2026 07:35:41 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] test/cbpf_filter: skip when openat2.h is not
 available
To: Yang Xiuwei <yangxiuwei@kylinos.cn>
Cc: io-uring@vger.kernel.org
References: <20260314083538.791693-1-yangxiuwei@kylinos.cn>
 <20260314083538.791693-3-yangxiuwei@kylinos.cn>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260314083538.791693-3-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12673-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 82C8428D558
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/14/26 2:35 AM, Yang Xiuwei wrote:
> cbpf_filter.c unconditionally includes <linux/openat2.h>, so the test
> fails to build on systems whose kernel headers do not provide that
> file (e.g. older distros or LTS). configure already sets
> CONFIG_HAVE_OPEN_HOW=n and provides struct open_how in compat.h for
> the library and other tests; only this test bypassed that by
> including the kernel header directly.
> 
> Wrap the entire test in #ifdef CONFIG_HAVE_OPEN_HOW and add a stub
> main that returns T_EXIT_SKIP in the #else branch. The test then
> always compiles; on systems without openat2.h it skips at runtime.

liburing defines open_how if it's not in the system headers. I feel
like all you need to do here is remove the openat2.h include, rather
than disable the test entirely?

-- 
Jens Axboe

