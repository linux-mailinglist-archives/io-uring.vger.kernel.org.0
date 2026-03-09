Return-Path: <io-uring+bounces-12594-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wHeONIbdrmm/JQIAu9opvQ
	(envelope-from <io-uring+bounces-12594-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 15:47:34 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5371923AD43
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 15:47:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A276B3095C3C
	for <lists+io-uring@lfdr.de>; Mon,  9 Mar 2026 14:41:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BE9C3D3490;
	Mon,  9 Mar 2026 14:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="D42nkMLi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4D93D3CF6
	for <io-uring@vger.kernel.org>; Mon,  9 Mar 2026 14:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773067222; cv=none; b=COImY9xHM9ZbKcMBwzTVwzDrLAjm/6xwnIQwIOdqqds83DMV2SnttTDTq/lahen6gP8JWOPrS8Ezaj9QmmtotdOsNT0oEzFtyfNgwvoyNIxZdS8PJCcB0trSd9HN2eqQ2A0HCpcc9QmEjMxeE3U3s3BtSbPC4mH0oHgwPzCi3nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773067222; c=relaxed/simple;
	bh=Big3woC513ka68Nvw694NMNobuNKhWdKnYelAUeSphQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vu3xiIOCks3ArRGw5qzLu3/uVR9xKHFwHhLiOgkfDrAuV6DK61z+aQQal7hI+QPDSnzTAnzCjRt7hkwZAPLUEx3YMwkTtxCKRqdxRcNGWP0hcsSsBQNZGboVfFnjEze+r4UddrKL0x9CNwVmGNDTlpGGSUKSmaEM6W4Ty572vgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=D42nkMLi; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-89a15b9a556so80600586d6.3
        for <io-uring@vger.kernel.org>; Mon, 09 Mar 2026 07:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773067219; x=1773672019; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J4xXxvUpcZoBDTCwzQKAtEKpFkyTCw60qHMNX0GIlGU=;
        b=D42nkMLiYJQE/eDmxyl+UsIgNgJk/FDBXeo2ZCltCy//tEb0/i8FT8qS8Ghxnbbb85
         Fb/PiCeChSkTekof0MVecLPUVfjGYEN7AKJMY1QOQREZUeOtwtSzujAfBq2+7HR/vE/G
         12TCWNrM/v30ccVwcLOX710hWoO7JA2l+B6V2MnJrxEnXIvyxTrQXo2mhwOa/cmwZ/QU
         UmIw6AmyFWBM6FvfuK4gT7+eLmi7TtMZiqOi7LPgk5A7RkmPASVrBYlnLZG5hbNB2/po
         Gs/Xt5KH3H4kbYxi9zu0vO01QEMPQkhGdjqCx3i72/9cOqFcUsonmtF5xlvCM9ZuEKML
         a7Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773067219; x=1773672019;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J4xXxvUpcZoBDTCwzQKAtEKpFkyTCw60qHMNX0GIlGU=;
        b=u6aEQVyb/fHdQ0T+NM9prraF3Jtu4mrkl2vGIYVAFz8t1a3G7U1bdJbzN77KuHMqor
         KTPjXNT/0O0AWHXkKOKSBYp4aqGFPDWcVfDgoMfFtNX4HXv2A+u9HY8ZdYQ4+iE1NQga
         GaO+V97+LFXoEAFNIW+I1qZ/rMYy2ie+RsnL/c0bQDAIAW8g5BzuJ1frJfko762Of3M7
         r9pRwZxKPbaH55DnuJXu9ocsktqVzejtuj0jmx4+oxBLZmZR9/hacM1xLgy+vSTx3GXk
         cSykMGRAnOzaQLBb5C3cLZf3iH+4Ac2J4wo/RJ+uynfdo1VEiAvd9DeCYtvuu808LaXI
         rvDQ==
X-Gm-Message-State: AOJu0YwXOkeIuP2YtKr9VyXiR1/UNRXJu55cOgP0nIgUDCj0ejI/8v3E
	+6kc0EUwqYcxsY/kfL5UJRsoZO8+N2LPROqrD5JfmzgGh1oyzPGyVMbaeDS7pn+q52W9XW1DsWX
	guTYJ/Ag=
X-Gm-Gg: ATEYQzzbav9Clhjipmaa6cKRu1j1MwBcx2/b5IPOAIlQUS87F6kDoBdOr4Jp59iNBSh
	plTfY8GH9nI9AW22JnVr+OP/X68Ym1DIsNP0nn+6Cm4lKnQjJCoYzi2hu3h6EFgMrIdyyWOlIrN
	ED1Il48aNu8iMi8HQKodxq1V+GgVvBeeXK5hMefiL5lQ4CwB+DIeqD/GZc9Sueb+L4c8BTg58cy
	Zv6PiopThyITD9oigxUhqE76JPKxnSHRE3P7inhQTRpmtXmpbVh70NLuVPoJKeD2eOgDhr+yKjI
	SlLkgM37RPkrKA/BC1hp9VzuPx8gZa3NrgvAo/TaV8QXFf+U+zZb0E0qtrRV0g2HaIk7yyFCvxq
	B5H+209794klwT99K5SYOBKzGL4i2SIlFeuMAnXlUgYVRk03lUReASfhEHct27wOFDXSXyIv0yL
	tHFnqsrofPQEkhEVdmTYrOmm4HBhAtzz29Mx6NwcNQe4I4PU+e7w==
X-Received: by 2002:a05:6214:411a:b0:89a:502:6055 with SMTP id 6a1803df08f44-89a30a65172mr166094996d6.24.1773067219352;
        Mon, 09 Mar 2026 07:40:19 -0700 (PDT)
Received: from [172.19.0.48] ([99.196.133.212])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89a3144c874sm84010336d6.15.2026.03.09.07.40.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2026 07:40:18 -0700 (PDT)
Message-ID: <3adb3dee-9707-499c-88ad-43b887f99586@kernel.dk>
Date: Mon, 9 Mar 2026 08:40:09 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/register: fix comment about task_no_new_privs
To: Jann Horn <jannh@google.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260309-uring-nnp-comment-fix-v1-1-e7d185527142@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260309-uring-nnp-comment-fix-v1-1-e7d185527142@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5371923AD43
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-12594-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.963];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Action: no action

On 3/9/26 8:34 AM, Jann Horn wrote:
> The actual code is right, but the comment is the wrong way around.

Huh indeed, wonder how that happened. Thanks for spotting that, will get
it added.

-- 
Jens Axboe

