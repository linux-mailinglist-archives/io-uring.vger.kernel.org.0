Return-Path: <io-uring+bounces-13088-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IEyDBuSD52m+9gEAu9opvQ
	(envelope-from <io-uring+bounces-13088-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 16:04:20 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A8B3643BB89
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 16:04:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5A162300E59E
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 14:02:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D7BB3D75BF;
	Tue, 21 Apr 2026 14:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="qz0n2h3N"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692323CE4BD
	for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 14:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776780176; cv=none; b=oZHTDEYG7q2v+QAiGgYneL0UEWXe0DvbGiM4pM7bSm1EaiSYTKL8ggvTyFSoMbYCT83DJtNNEo4HKHJohNhitM+2NYQJqlZWxMIzLS7xChKJVZ6XR3MvNgqtLM/QjsffbyND0LRIVoiBKu4+wl/TxxjMbndbeh8Mmopvg4tcifA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776780176; c=relaxed/simple;
	bh=/406WsRMcAZ6Dxzd7zjaMfUACy3P1OtqbcsXSAXZlmY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rFSh7a/6ab9VuW5KDQ3A2pUbxOxMMGqHTlGQLcc5LaMFuuVHCuQgMyBw1V3nEZJzhyk/PSudGAnr6vV91DnJDLPjIgQtHWh9+Mvsxw/QInH2yqeyjMIvhUSlCEz0uSrCC3SMuArx4vhBE8NtTikH3dlDxBZy9pVLV5/k+rOhaFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=qz0n2h3N; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7dbff06e4a6so4209096a34.1
        for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 07:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776780173; x=1777384973; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1h1P+LCNjre1xY1nrF+fr9BE1VZAaQDgj95493UCLi0=;
        b=qz0n2h3NV4zowG7vU87QTkEY0ObCL7KtdKW5QbgIWUp3Dk4PU08i9CM70cXPbwAO+Z
         ncsTPIipC0ROgrxM85uRDlHCuqaBDrrpp9eYOTl8g2osj3Xh/twOPjnpSutlxQe+N1ps
         Obr77PoNSilNOMCscz+e+RPD6ZJHafVauGIGV5R0Kj6iSPPMPQ8gHSWROJ2KZtj5FgwU
         s8CWgtIdbEaOKKZXnzqdn9HMSmZMGy2tJZFilmoVIHgdw0RccvZY0xDMqW933qC9wH2k
         6iRByuZEKGXoSsUhQdPm0l32Z5ynFXLFVdnyvy+oHyxv8BkzSwOm12bU+KghBw03AO9C
         f8KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776780173; x=1777384973;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1h1P+LCNjre1xY1nrF+fr9BE1VZAaQDgj95493UCLi0=;
        b=BVTT6z2FyZ0CMc+LSmZ3SfZevC/cXc2GMHdcTrnTGDCVUK3gfIJzrLWkcEwWqJKBXZ
         qmcvgPJv5fnhr+UBb4GtPCKMiyZ6RMz+7RGzfT9fHqP1s68MH0uuG1/TjQNTJgHgbjIo
         yloE6xlFK26S/3nJnyOoOMhkW5cFUdCdowLwJtBPxr/k9/YZ0gNkNijibUcMENvOShEe
         rDc9u7z4N8Art4VyenP5UZgebluTd5+8i4POtX6aX/MkPug3i8ExmhvPYORdy8yav6pX
         Yzm9zNWbCDGbXW5vVF+8j8ap9W06WOBH9iWGI/Xeuyp3aFoQQZejwKgzusS1wtzduK2M
         TQbQ==
X-Gm-Message-State: AOJu0YxOAPNqTMWuN7rWgSKOzI8nwRu6WmHl45I3/zIVzWce8ykV11Rt
	CoO4VUT/mqb5gvwwL93CDHOsqH/Qfq/W6HJYfnaoBAU5MhgPRZMDcnaL23fwcxN7jv0=
X-Gm-Gg: AeBDieuaMz3Y0U9cwpL/Rp38dy6KGu2dnqIfIgPZyv/n05vyc/zbBTGjtEqmUcIIzor
	PhYRMfTTuTAmdOPpxujJVEm4DpM3JcWfRHURc9F8ZzAwoj8tNnYvi8KT0nk+IHC+Yp8fD5fSHh8
	hMjKcwhcFAncUS+1z8bAzIzddMEYGncSrlImPVgDLsY87cD4ozbQx2z5r5wVd3yrNpUFpoQkAgl
	+LLlP5gh7yTrti7TmkXFQfVKRuiDY5amEEPwDC3NUX3DsO75TkPi1XOezpRDQZ1DTfjgcP0R7kn
	ptBeoBqS159pvcbZvBb/6Osjg8xXoTRpsqMsjmi64vUc7aHDmM1oWop/egnQR3FzYjkD6JhXUjz
	aX7GNRn4MOXS2U2c25RM5BJRsU8bjfHw4kMvzQmn66ZBJnP++aMqKyz9e+rWey3OUt1niTwwBs3
	/e8CFxBIzM6QwkylC5HHwIHhVM+mnYrR0wDn31shaPBfC2RuIRd6cuSErjfb7Ds9Z0GiYlrpQsA
	/g29Dsj/d+nSfb2oMSZ
X-Received: by 2002:a05:6830:82eb:b0:7d7:ecd7:6112 with SMTP id 46e09a7af769-7dc951e13e8mr11483657a34.18.1776780173216;
        Tue, 21 Apr 2026 07:02:53 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dcc712b4easm4501507a34.23.2026.04.21.07.02.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 07:02:52 -0700 (PDT)
Message-ID: <023f90bc-9058-461d-bd68-956665ceed6d@kernel.dk>
Date: Tue, 21 Apr 2026 08:02:51 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: take page references for NOMMU pbuf_ring mmaps
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: io-uring@vger.kernel.org
References: <2026042115-body-attention-d15b@gregkh>
 <842a9dff-b12c-4cec-bc8d-8c1adb3ba280@kernel.dk>
 <2026042108-fiscally-unglazed-56c7@gregkh>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2026042108-fiscally-unglazed-56c7@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13088-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: A8B3643BB89
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/21/26 7:55 AM, Greg Kroah-Hartman wrote:
> On Tue, Apr 21, 2026 at 07:50:32AM -0600, Jens Axboe wrote:
>> On 4/21/26 7:46 AM, Greg Kroah-Hartman wrote:
>>> Note, I have no way of testing this, I'm only forwarding this on because
>>> I got the bug report and was able to generate something that "seems"
>>
>> AI bug report I presume? Because I can't imagine anyone ever attempted
>> to run this.
> 
> Yes, I got a bunch of "non-mmu" bug reports, which is a bit odd but I
> guess you can do that with qemu these days?  I should dig into that,
> maybe that way I can test this and get a reproducer for you.  If not,
> let's just bin the thing.

Was just pondering if I can run it in qemu. I'll take a look. But I knew
it'd be some kind of AI bs, because why else would anyone look at nommu
in the first place. But we have it in the codebase, so...

>>> correct, but it might be a total load of crap here, my knowledge of the
>>> vm layer is very low so take this for where it is coming from (i.e. a
>>> non-deterministic pattern matching system.)
>>>
>>> I do have another patch that just disables io_uring for !MMU systems, if
>>> you want that instead?  Or is this feature something that !MMU devices
>>> actually care about?
>>
>> I mean, who really cares about !MMU in the first place, we should just
>> kill that off with a passion.
>>
>> Let me take a closer look at this and bounce it past some vm people, my
>> nommu knowledge is close to zero as it's never been relevant in my
>> professional life time. Which is saying something...
> 
> Let me try to get a reproducer going first, let's not waste any more
> human time on this just yet, sorry for sending this out without that
> done first...

Thanks!

-- 
Jens Axboe

