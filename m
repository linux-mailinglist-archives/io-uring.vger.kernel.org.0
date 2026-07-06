Return-Path: <io-uring+bounces-13901-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id UZFqJVTyS2oJdgEAu9opvQ
	(envelope-from <io-uring+bounces-13901-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 20:22:12 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F3B171471F
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 20:22:11 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=o08eiW6c;
	dmarc=none;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13901-lists+io-uring=lfdr.de@vger.kernel.org" designates 104.64.211.4 as permitted sender) smtp.mailfrom="io-uring+bounces-13901-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 274363041CDC
	for <lists+io-uring@lfdr.de>; Mon,  6 Jul 2026 18:07:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A39303EB81B;
	Mon,  6 Jul 2026 18:06:53 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA2D2EBDDE
	for <io-uring@vger.kernel.org>; Mon,  6 Jul 2026 18:06:48 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783361212; cv=none; b=oBDkG2lkaNKgw69Eb6eHJf2tWEfNFqGxeOpSd7/vL6hWnHcz6RsehlxOSJ3fKoWP2oWr/tmaIFgtzCWCHfhXLjrfGA/GbOpR3totbTMRB64c9l46o9VyRUdU+bJAGq6RKbkK8KUMzVSlKK6VBzebLo5ahrdC0iuB3OWq4wxT3qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783361212; c=relaxed/simple;
	bh=FHNE4Rr13QpicQ2BOguSldKfvwLiqktREZMUSyCQUhM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PQw9y39KhLnNru1T10QnowxK+ISeQpl6JBKprRiRp4Q+8BwCcjGA4Z9H6Is1iuLtIT3v+z8bzfvdC1oumeOmmBBoflAMg8h0mfltqFXfeaZQ1Ralhc5+6vkDdl9URRkGAGRDzfEzJgAZe9PubtlUWN7aaBejIpjtbMfBVnJceBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=o08eiW6c; arc=none smtp.client-ip=209.85.161.41
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-6a31c05e092so925427eaf.0
        for <io-uring@vger.kernel.org>; Mon, 06 Jul 2026 11:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1783361207; x=1783966007; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+wOhom3Ia3T2p7xfHnwpv96AaUoUVr6T4F3Q4Bb9GK0=;
        b=o08eiW6cHATeazIZrK56MzaaRQmu2T78/ukSMILogzW+/mBQdpW14xu2RvJDDa2R92
         KqTNuGZJlZr4mEWsNZ6N5AJ2VfuZqMvbnP1VnydOKBUPVu9ss/VmYTnfQhn552rN18c4
         2cl4h0z0bgYtLiSTr6mARtxKSj81CZwAobrFapzCa6q/hQH7iyshzYS+dGhiua43TeWD
         5SijWneOu/fbuPeG+B8E2DHb1RkAc2zy6u6QlLZenDTMGft+jHqhx3lHyOUmHQwG/O3T
         hdPgy+8sOViVcqnCbBImESZsKvU4dAezb/0c2BassCO8d6izFffNhTIcmWwd773eSIIr
         x/UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783361207; x=1783966007;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+wOhom3Ia3T2p7xfHnwpv96AaUoUVr6T4F3Q4Bb9GK0=;
        b=N9kRdUFWAUcnKPELPNH0jeNFRXXiKagkrcHS6hlo0O7CIzLdw6RPiaVx4LjN2b7CCd
         kC9H2HtczEMlVdzkRiSEFb7JQBopm/6TwebxcTEf95kDY+J294emxiuafpT3iAlxqzS+
         gxYErh3VEERYx8hXC89sl0A23ujRHcZVQGjt5gydBIGJaHJp09UQg85FWzh4bIUq99o4
         eMeRjYax1wm9z0NVTa1t2fdbvSDCMegt7eczi/y8j1zVxj48zf9HLOLF8sPgUiGmHUJo
         VzGbmRgm1MAjfe4iH768pG4/o6dP6CLalDstWH8BNonOdYm9Ac6DvPkHA3RKq17dGUob
         1mBA==
X-Forwarded-Encrypted: i=1; AFNElJ/1b9yTleO7y4n2ECnhWFpDfzyGc0D5uCGM86lJYH/TNlnykZd9EXI4e+P8CUIA3n+oDZMaNbL9QA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7q3GnH0uW39pTrkJ9wjop6Dsw2QHrQtbn52jrQ24zhrKF5s6j
	bKUkNdyD4r01QM7o5/0lHlsiXlZ4qoNCoQ0TuoVlU6yLxdJdt4mxcw8fgiLP+tMuxu0=
X-Gm-Gg: AfdE7cnPypQYvZ09RJ9nlDEr2OKlMQ5XIlBP/xN72VwuL7xFEBxKf0wFXUJkkQadBe/
	8bsRVOZxjVj/7SGTMEvqdYkKBXuK5lkZZ5Qt9FqRQDdoMbj7V5t0JtK0oNkRlxI2d7dC1Noc8bM
	+U07K3Z/3WY+Bxbi66lF2LSwuIWFi8qAxQpAi34cOOPdFrowIGwTVhmqVebk8jwUPaVQgqJ7eMJ
	XvP2ir5lIooXqzNUDIx83MKVWSh2jqgk4RkThUxcXnf8DyEkLzZNa23UBBcsKcf/Y2mJwi0zDUd
	D9gdsgnOLj8uUew6SrH258KuYx4GlINFAON5rJozyQX9e2MXFBlO7iuEvRVzeNL/4JywwJz0Yd5
	Tsg/CXw1imYS3CHTsfZ6fT9pP2hq+5o94N8SfXuk+0ChHUqaUJfQxT3jFvkegpwBcWxAAuAzG3Z
	J0xrwN9krPTiJcq20/Chcocy2FtBaZJFDCuYsa7dFdgWS9B7DvO6W0Lxkry6OaDoiGYyXsBws=
X-Received: by 2002:a05:6820:6aea:b0:6a1:8192:4d89 with SMTP id 006d021491bc7-6a3552ae6d8mr1096869eaf.29.1783361207152;
        Mon, 06 Jul 2026 11:06:47 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-44cfb1c8092sm10961841fac.6.2026.07.06.11.06.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jul 2026 11:06:46 -0700 (PDT)
Message-ID: <12f15437-4bfe-43ea-af9a-c10d20fe3e3b@kernel.dk>
Date: Mon, 6 Jul 2026 12:06:45 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] io_uring: fix dangling iovec after provided-buffer
 bundle grow failure
To: Hao-Yu Yang <naup96721@gmail.com>
Cc: linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <20260705234534.768138-1-naup96721@gmail.com>
 <0a370728-f8be-4aaa-bbc6-276376adc5ce@kernel.dk>
 <akvfYLvrpF5104us@naup-virtual-machine>
 <dbf0ae11-ce9a-4c98-bfcc-ff3f8f12b26f@kernel.dk>
 <akvnOaiLOvcHyalG@naup-virtual-machine>
 <92f036c0-2759-417c-b912-8b6f003bc390@kernel.dk>
 <akvp951vbwLP/x7T@naup-virtual-machine>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <akvp951vbwLP/x7T@naup-virtual-machine>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13901-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:naup96721@gmail.com,m:linux-kernel@vger.kernel.org,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim,vger.kernel.org:from_smtp,kernel.dk:mid,kernel.dk:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 8F3B171471F

On 7/6/26 11:46 AM, Hao-Yu Yang wrote:
> On Mon, Jul 06, 2026 at 11:39:14AM -0600, Jens Axboe wrote:
>> On 7/6/26 11:34 AM, Hao-Yu Yang wrote:
>>> On Mon, Jul 06, 2026 at 11:13:55AM -0600, Jens Axboe wrote:
>>>> On 7/6/26 11:01 AM, Hao-Yu Yang wrote:
>>>>> Sorry, i forgot to cc others mail
>>>>>
>>>>> I discovered and wrote the PoC myself. Trigger way is
>>>>>  send1: Submit an IORING_OP_SEND request with four valid
>>>>>  provided buffers. The system will allocate and cache an
>>>>>  iovec array (of size 4) for this request and store the
>>>>>  pointer in kmsg->vec.iovec.
>>>>>
>>>>>  send2: Submit a second send request with 8, and I set
>>>>>  the fourth passed-in address to point to an invalid address.
>>>>>  Now kmsg still hold old iovec, but old iovec object have
>>>>>  been freed.
>>>>>
>>>>>  So this will lead dangling pointer.
>>>>
>>>> Side note: please don't top post, linux mailing lists always reply
>>>> under the text for better readability. Top posting turns any kind
>>>> of threaded conversation into both a mess, and it's also wasteful.
>>>>
>>>> Great thanks! Want to turn this into a liburing test case? Then we can
>>>> include it there as well, and it'd catch both UAF and memory leaks when
>>>> run.
>>>>
>>>> -- 
>>>> Jens Axboe
>>>
>>> How to turn this into a liburing test case? Should this be included in
>>> the v2 patch?
>>
>> Look at the tests in test/ in liburing. Or just send the reproducer and
>> I can get it turned into a test case.
>>
>> Should be separate from a kernel patch, it's a patch for an entirely
>> different repository.
>>
>>
>> -- 
>> Jens Axboe
> 
> OK, I will send v2 patch first when i wake up. And I now my PoC to
> trigger this KASAN have became a exploit can use to priviledge
> escalation. I think i should send this script to your email? (not
> included any public gmail?)

Like I said in my original reply, there's no security concerns here, as
the code in question is NOT IN A RELEASED kernel. It only exists in the
7.2-rc kernels, and the kernel documentation will tell you that unless
it's in a released kernel, it's not a security issue.

-- 
Jens Axboe

