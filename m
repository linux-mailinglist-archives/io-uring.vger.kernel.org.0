Return-Path: <io-uring+bounces-12969-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GIsHKELd02kingcAu9opvQ
	(envelope-from <io-uring+bounces-12969-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 06 Apr 2026 18:20:18 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A96563A53B6
	for <lists+io-uring@lfdr.de>; Mon, 06 Apr 2026 18:20:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A8B79300729B
	for <lists+io-uring@lfdr.de>; Mon,  6 Apr 2026 16:20:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D72A31D72E;
	Mon,  6 Apr 2026 16:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="No8CcfUx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ECCF28751B
	for <io-uring@vger.kernel.org>; Mon,  6 Apr 2026 16:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775492412; cv=none; b=rxK4SapgKZGPpNTOgHh/Wc/b2JaPC/jdA0mqVu5SEunh377I6MxiyTo8Mo/FCEzINyphhxGzR8aznkTfJbfieEeuWp0MjWwjOJELhTsrdNjHO1kCUIRXJLLLmy/evKVviMacMCEyr5RbLJincJ7jFv2nrZNTA0rMEHmWUsI5w18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775492412; c=relaxed/simple;
	bh=/EtcsayWkHRiFJMCwkYZf0b+UlZON2ptxTMDBSiYLVg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GRHI9Lt45HeZTKmxrfJOmu14D7XNOOPFxVxUS5IHCXKXUxu2zAgYDzwZsgqKGPKe9TVh18BEPq6La+H68bjRypwosYmADCVoDyS4JW6X4KdP4JjGuXuLosS21O8HE4rjKEbH8ax6z0FP14l6zfNWt0ayMw7Q/dTskBA6+CttQIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=No8CcfUx; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7dbca22dbfeso1183538a34.1
        for <io-uring@vger.kernel.org>; Mon, 06 Apr 2026 09:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1775492409; x=1776097209; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NrGSZmb7W2DBdOyYltmbgehsoiq6uPy8+Vqtb5nWZjA=;
        b=No8CcfUxX8rjdLez/rEAIgC1IlHbjyFrlylf9EsndXGm1A0NnNjYyNNwdHA2r4dj35
         Wqr1zlbExbkHpYyuvOBYGElviSJ+tYvAcFbxFUri8YJSGs5EJmWdarGgic+TO2MjiOgi
         zeXrvQ35qciTusCRpKckQJ4bZ7tW1u+GxaxH/GP7HHHW39USnwFALeTedb1c8H5ilp7E
         BJIwXosBNKNr4Fy81XNalrzzqeH5bVwXbWCZ8b2g3EoRAYvJ89rKlRKbuvoeKKs4dLF6
         22Evc5icRzGRLCEb+l2yPEt4PbZ64C7+u53CQdEKg70gzjzlZ4M+7stBCmJoX6qNAkyc
         UGnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775492409; x=1776097209;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NrGSZmb7W2DBdOyYltmbgehsoiq6uPy8+Vqtb5nWZjA=;
        b=jr/L+eLEyaUFpI5TEcaQo3zGY/i68Tfah0eQQg26MLssUwzTkFIxAk0r5JgZrnZ8oZ
         4DftwYmwny9+SJBv5PfMpylweL0KAGaU8kyLoHmWr/CI6wlgiq8FqRXdHemzbvJz+VxU
         LXijFrzxNnBBlLbi32QU35vgcX8ndkGWBbc57jchDDGlVRA0lE3BXRVo6UzJaM6WxxaE
         ZbBRrBHgjTN/VraVFjdyp9GgS+WibrvOsIsZSsH+KKhgk/kXWuzsjeLs6YFUC/8h52j3
         +3ik6ZMY3e+KLfpGn85utCxfqFjVRTkVoa0fh6Mhc/kisuubDG64nBI5m7omUSWw96Lc
         UuxQ==
X-Forwarded-Encrypted: i=1; AJvYcCWW/jg/P0+vmJsSeRJ3jb9vHw2cCqXsPHqlJ6qd+7ZM5+Td8FH2TtclN1Iil4Wx/YOGGoWnFSjchA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwMkT5415ehPfvIxAvym6QZdRl0SFOG5my4MAtqnR1lm0JwzA7a
	JQ5xdKRYy/GDDKIgWuom2ykjk4h62Ao1NpPW/y79sXdINd41LAu7/+UI+CJ7esqSbuU=
X-Gm-Gg: AeBDievOCKR+uDfXXE1lDY05WdbHVavwUHT1kQDbhMXkTJ+WPf+GzXbUg5EWe1FXRZw
	1txNHpvlx+isx5x5+vxxD6hBoO+HVgdO0Tp4BncOYr5/Z4IB3bTmH5ioO1d2229Nu8VTT0n0htG
	5YEwDgrjJ0Pi2+viH/R7W2Gf0VUnbtBHpNqN/f2AC+r5QWziaqHmQ4ibvlZyFoo+Gd7w7LPgaXl
	Y4N6jx0noJ1QUy7mfaHHTQmqxXCDBoNB6zYeP/cHvpdq+2Q2GdQ0qJ2UX5mgsjXvh4gYK0PJIrq
	6eFHALek/ZZW8Rzo2ZqzFFwihGA+KlHfGc2Hn+reDRuW+KJrsGk7J2wcfFdLQkN6rPJzSMjspN3
	comCSXi1PeMkkXDKSPqHf815Vo6XLYaYm3DkQycdYkPRwVc5kyujJDOzyQFOkG55PVrKAcw2CHY
	f2p8H75Hu9vL56P1UA9y0cpWXrDAYEIGUfVJppbFBo+PvTcxqcP0gnTVRD3Vz8ACr+7Ya9hn13V
	Tq7ySTT
X-Received: by 2002:a05:6830:91f:b0:7d7:4e1f:b1b4 with SMTP id 46e09a7af769-7dbb754ef87mr7947775a34.26.1775492409117;
        Mon, 06 Apr 2026 09:20:09 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dbed6c3512sm947829a34.4.2026.04.06.09.20.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Apr 2026 09:20:08 -0700 (PDT)
Message-ID: <7e4d8e97-850a-40e7-94e8-e82dd56c0386@kernel.dk>
Date: Mon, 6 Apr 2026 10:20:07 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/zcrx: reorder fd allocation and disclosure in
 zcrx_export()
To: Bertie Tryner <bertietryner@gmail.com>, io-uring@vger.kernel.org
Cc: asml.silence@gmail.com, Bertie Tryner <Bertie.Tryner@warwick.ac.uk>
References: <20260405235330.49287-1-Bertie.Tryner@warwick.ac.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260405235330.49287-1-Bertie.Tryner@warwick.ac.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12969-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,warwick.ac.uk];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: A96563A53B6
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/5/26 5:53 PM, Bertie Tryner wrote:
> Currently, zcrx_export() allocates and discloses a file descriptor to
> userspace before the backing file is successfully created. If file
> creation fails, the fd is released back to the pool, but the number
> has already been written to the user-provided control structure.
> 
> While this requires a misbehaving or racing userspace to trigger,
> it is better practice to ensure the file descriptor is only
> disclosed once the operation is guaranteed to succeed. This aligns
> the ZCRX export logic with the standard patterns used in the VFS
> layer and other fd-publishing paths.

Like I explained earlier, there's no "race" here at all. The file is
never visible until fd_install() has been done. Any attempt to use the
fd before that happens will get a NULL file in the kernel, and the IO
operation failed.

The operation clearly fails, and the error is returned to the
application. If the application is so buggy that it ignores that and
wants to use the 'fd' value, then it's just buggy. Simple as that, do
stupid things and win stupid prizes.

As a cleanup, this is fine. But the commit message is horribly
(deliberately?) misleading and that should get fixed. I'll let Pavel
decide what to do with this change.

-- 
Jens Axboe

