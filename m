Return-Path: <io-uring+bounces-13076-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OJjlK8KC52k+9gEAu9opvQ
	(envelope-from <io-uring+bounces-13076-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 15:59:30 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 27FCD43BABA
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 15:59:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AA72930C5754
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 13:53:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBA513D88EC;
	Tue, 21 Apr 2026 13:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="xwfwVNmY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326233D905F
	for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 13:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776779437; cv=none; b=BC3WuV7VDR2zqPfE/nvhM2ePvSrxcqiD+Q3fZfPcjZlBxp4UR0VtIMODRia8o5Vr9Swjb8eVZ1P9d/08PbfDZ21WWpZccUgB07CTCXrhEMlLVpnLWUtamRnQFkAhHhCJvZt/6OcAj/is09P+aEdZTEpQw5IRr8wUtb0Ysnwe7Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776779437; c=relaxed/simple;
	bh=vuLA1SJv33UJLQBc1VP0GHwFawJr8g194esrx7zqzO4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Xhkl5iETx5LlDQz9e2OweHTAxqOHpIiLxIaMX+nbp7UO5MfUZYMjo5HV+aGFFIZvrd1sPV13n1FsaKoA/J377n+IhY9Gn78fslC9Xm3BQOLWvfmHjhLthPm3eBN701UEZyHEcfEdDvNfe5/MEqqY01PpqbddQIfxSumMSvkf7ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=xwfwVNmY; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-479ae363aaeso2274119b6e.1
        for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 06:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776779433; x=1777384233; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=d5BfE4Z/kHtmhzYgMKlWkSg30rDiiz7cJrx8Bw29L3E=;
        b=xwfwVNmYiWTxiiWQa6N5G0gLDon54tkY6WZiMhmV8Bkq2AjBgxqQkS8Kq+x7chNi/x
         /DK6Su0adIXqpJLGP2PBMuHMLyX9wajHUjM8yo5tvXyK+i/SvF6A4IDTjVSDlHWfuO/U
         Vzv06K/9wN3Tvpc+F75MmyTIERbFRU9Jg7CmailTPZ59Us+Fg+hYBg8UlxZN9Pi5C6ot
         p10sWWMpwYxaRvbM4lmFM7hm6HqCM6Dw/TbHnBxhZ5Z2H0wIAdC4g3MMmT09kiKQjeRQ
         WvAl5b9r2vWq+vF/4RCc8iAkdWyKCHH062ZzPM0TkhZ+8DO6r/S6wtyKVwV1PVWPcSsG
         hLAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776779433; x=1777384233;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d5BfE4Z/kHtmhzYgMKlWkSg30rDiiz7cJrx8Bw29L3E=;
        b=rPX853fofLEd8PFbrKFSbgAG+lkzAYAXty/6i6zqpEYr1PVSbPetyzPIXp1+XYmbmp
         VOtwB6cngwtKWAKi6GNPf5Tl/4emU6sWP/HaRgDbJp5qxbPdbBfK+Xb8fUMRmzzMqInh
         ypfzGPWbBAgxqRkvekEWUcwLiyHG8ObN+tEPZ3CNfSVEm9sCnuU3GAoLH9lHVYnPL6zy
         umlyCnK7Lh+VjJk4m5PLPxTwEM2Ador/fHBtfl8o4cm0JcCoJcknnA88EcI8UQ3PF9s7
         J2cRpdZUamLTrKvLEiCJZt7LRohWSuTjz3dSJWPqC6TEMytOMoTUH5qBWbvD/K9zVGp3
         P4MQ==
X-Forwarded-Encrypted: i=1; AFNElJ/CkfL/unRTnVttL1A7h8RUmhOqOXWFiddrX409MqU4O3UY18HlJXWFzBlYL1HfrgfhnKwTaQ/xtg==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywt7crcxJOTCsmFc2+txzT+IGnI3eJrwe6aPlv3i017Hp06m02F
	uz1qQKSbxl+nkcHxsxzat0GQ56xSPlSu8bF2bqPU2J4KhPgOYoMbQcnRIlzOBX5jx/P+VE3N8tp
	UKL9Ojcc=
X-Gm-Gg: AeBDieuPcb3Q05j0jovvHbsHnisn83EzYz3qSXedaFWXKh1zqXh2dHLYsl6rwrb3xEQ
	sG7L8H7j2dpclwPBi5goMbbk3F/0dv3dOlPoMQn0TARXHkqE471IuuRDAY9Tr/VM87rovA3OcqZ
	kUMOq6A/1yRYuGejA03ilNd84evyWbm9LiAnspY3ik0uDsig6oMZl6/5v5CWr+ZJrVdgxrNi/KE
	DvSQrFbbB8YSODvxJstWDK58wU8X0BJMcpKGzq6qIpFhcqHkv7fb8Cu/EgxOhLpdkbY99Rug/1f
	QIlrZasNKJ74u4cM+yJ6o8GEs6zTcdgUZhgXjH4ugae0VjSm9rH6Z3vn6KzRtDPIVMpOquqR7MN
	/CgF0A30cfg1tuxM4q//mVUwjZ24P0aLuHFu7KJ3yvrmm6cv3XzXnE4TkL+P+qVzK81ZaBZq1sq
	9haC1EBALiNaFdF6rQd+DoN77d7p+BdyiuxsujUW/pN0lr/6g+Q5wfeq/ig5axBpeXlk2D74A2m
	cuzvVLuo7gcKCgjqRc3i7wTZoZVtd0=
X-Received: by 2002:a05:6808:1806:b0:479:ed97:26e8 with SMTP id 5614622812f47-479ed973e64mr1277587b6e.13.1776779433254;
        Tue, 21 Apr 2026 06:50:33 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-479a028cab5sm8887266b6e.16.2026.04.21.06.50.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 06:50:32 -0700 (PDT)
Message-ID: <842a9dff-b12c-4cec-bc8d-8c1adb3ba280@kernel.dk>
Date: Tue, 21 Apr 2026 07:50:32 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: take page references for NOMMU pbuf_ring mmaps
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, io-uring@vger.kernel.org
References: <2026042115-body-attention-d15b@gregkh>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2026042115-body-attention-d15b@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13076-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: 27FCD43BABA
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/21/26 7:46 AM, Greg Kroah-Hartman wrote:
> Note, I have no way of testing this, I'm only forwarding this on because
> I got the bug report and was able to generate something that "seems"

AI bug report I presume? Because I can't imagine anyone ever attempted
to run this.

> correct, but it might be a total load of crap here, my knowledge of the
> vm layer is very low so take this for where it is coming from (i.e. a
> non-deterministic pattern matching system.)
> 
> I do have another patch that just disables io_uring for !MMU systems, if
> you want that instead?  Or is this feature something that !MMU devices
> actually care about?

I mean, who really cares about !MMU in the first place, we should just
kill that off with a passion.

Let me take a closer look at this and bounce it past some vm people, my
nommu knowledge is close to zero as it's never been relevant in my
professional life time. Which is saying something...

-- 
Jens Axboe

