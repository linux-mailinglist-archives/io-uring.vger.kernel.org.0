Return-Path: <io-uring+bounces-13090-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uInZAj+i52nw+QEAu9opvQ
	(envelope-from <io-uring+bounces-13090-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 18:13:51 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B58B43D340
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 18:13:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EA85930063B5
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 16:06:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2364363C6F;
	Tue, 21 Apr 2026 16:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="B+HSde7G"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4DB28504F
	for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 16:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776787560; cv=none; b=j/aTzfcOkZDzAlOGXSwOp7fuFVqnP/4nho9dlw5xbSUqSQl5JBFa+uVdcF5VySW+QnhSkwSriYTnOvkMb7dZ8haYrD4C/y8i2ymWR2L4BdIkIft3p/S2Rh9iwCwYNB/60AJ8kjoLc8rNZwbmfLSN3aGQAXGDhYbo1c6MMxbbHTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776787560; c=relaxed/simple;
	bh=jAY4keg8FJfNurmuX9nJjOlENNYFl0V76Uqim8ZxTL8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H5oBWEYh1Yz6Kfhk+z57AruO3wPNza0Fu5JOwEdo5HlL7C4eXaSoM4EQDHdPd1/l7e33SZdgGHiZyUMqvtIbaFOP+QpRIa6Md/H4Tvt4XzBW8Li1ZmaBnWSv7/IrOEnxmJwTLTGOqJHUBBCu5YkgUVOOhlwwXqaVCWVQA8L6Vds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=B+HSde7G; arc=none smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-41708f6c3feso2851922fac.3
        for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 09:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776787557; x=1777392357; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KE8Zb2alx5YyGRI4wpRGEaceVt7UtJzgNhyIfugfLzg=;
        b=B+HSde7G04Fj0qPHLo5KVoCYqZLsC9AztWMP2qmkhMA8fktTd5Kq5IZJgBGFaBrZZd
         OnhnrE6H6HSv4nTMFwPZKUKD0cx2cG5WIxLfgntZBUcvTpwO3YDFDudReqBoeMIe4VEy
         w+1C6kzJKFd5y/AM0KGup/krSQJe0uvBZgEnSXwlfp2ii5k004SmFJo9NUku8Puu+QgY
         nONFfT2ZK1s6as5n1R291+OpXowmZ+o9qHjOSh0juvc/tD3eKrt+4O/axpOvAqDijcKR
         Lqy6MA83GxhJvZk8rZYX46Y6i04Qku/jnxJSrZoMy8NmiUDVC2uPOCNB3HTS7vyvlcep
         D/2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776787557; x=1777392357;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KE8Zb2alx5YyGRI4wpRGEaceVt7UtJzgNhyIfugfLzg=;
        b=PNVse36qP0fzISwgSn9LapUfbStL+Nv4b750/PXEPVVevSZOT7o0/OAt1cR4Hc/f3x
         Z0OXDtAJLFOEMpzg3RGKG0gKKw6V+sA138aZfkR6pMeHAcSJxflmz12kb5GUynuahOZc
         HbHXeJSdGl29QMhLg3GSdnVRoKBqso/IYdSE+kekOzt6itGO4G8MuJwwmE8S5DC6MZdC
         6ap0pzOhlBK9GZcdPWcRHnotgiQJbu8zO8joPNXbd14CXlgcEulrEO9jOr2Ev6OLiyyT
         rvqZAxRRz7fLAvk4S8QKOM7hqE/H16X2M9z/g8Yxu19J4GPx6SLmXwYgAWG+MSKIFMio
         JOmQ==
X-Gm-Message-State: AOJu0YxjpRyD5HIqLJ4rxnvQd2kHVVDczA8UykZKyQ5qg+WMGXYlNwIU
	JS7kN/gThrLuk+XM4hHeJV7TuW+Hzkpd+LKUQ/YcjNjuZyLntFq99t9v6UvsJv5bsdm35nl35IY
	uoe9aJlw=
X-Gm-Gg: AeBDieuIrR7AeuWCNPIaKOyGtr59aDXIidxdL/W8lBV77kCHJMZSzE+3QId5AK8tPrT
	Jlwqj+5akdVE6+ahRFn1YOn416IXXp0m98Wx1iJgbAzdehEfvq7DotbG3lAR1pvfeNyb+bxAhIS
	kWsgItQVHJfv4cP128m3wUTn2HoPM0SxQ6dZqnb7XqdF8SUML442LVPOZg4NsU0augEI/fXDIjV
	qEkutfAW06fCx325FCs/ILQCZYBN1ZB6isN6tqruP+L5JUMb9heoqYnEgtpb6cTU+sAKtA74lJR
	7aWAq9gzHxgqM3CVrjfAdUgZq0v5i1LzGaFNVA/exEXmHBsDnfM8nm+U9eo92QKaAzUoPdCQD7/
	/7+E9r56PFF/AUHWZjAfeuUZgpOAx7YjaBdZh72EGJmQCpUGKmccZ7T32rdoz1N0UonsB3/sg8K
	5+vA+s9zGiSa5FuIGM7XdrnGIzaFNCiSHB6vRsXFRjJUDyd1Z3uCI5+1qLC+F0xBfqpJeY9KMAi
	jyfrTigrUW2Du2kfh88lCdwlBtDhw==
X-Received: by 2002:a05:6870:b016:b0:417:49da:7ff8 with SMTP id 586e51a60fabf-42adeda9c9cmr10737156fac.34.1776787556662;
        Tue, 21 Apr 2026 09:05:56 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-42b934a2e8esm12603931fac.10.2026.04.21.09.05.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 09:05:55 -0700 (PDT)
Message-ID: <c5077dde-0dfe-48d0-9504-76c7ff30b0e8@kernel.dk>
Date: Tue, 21 Apr 2026 10:05:54 -0600
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
 <2026042140-arrogance-freehand-d8bd@gregkh>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2026042140-arrogance-freehand-d8bd@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13090-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim,kernel.dk:mid]
X-Rspamd-Queue-Id: 5B58B43D340
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/21/26 10:01 AM, Greg Kroah-Hartman wrote:
> On Tue, Apr 21, 2026 at 03:55:38PM +0200, Greg Kroah-Hartman wrote:
>> On Tue, Apr 21, 2026 at 07:50:32AM -0600, Jens Axboe wrote:
>>> On 4/21/26 7:46 AM, Greg Kroah-Hartman wrote:
>>>> Note, I have no way of testing this, I'm only forwarding this on because
>>>> I got the bug report and was able to generate something that "seems"
>>>
>>> AI bug report I presume? Because I can't imagine anyone ever attempted
>>> to run this.
>>
>> Yes, I got a bunch of "non-mmu" bug reports, which is a bit odd but I
>> guess you can do that with qemu these days?  I should dig into that,
>> maybe that way I can test this and get a reproducer for you.  If not,
>> let's just bin the thing.
>>
>>>> correct, but it might be a total load of crap here, my knowledge of the
>>>> vm layer is very low so take this for where it is coming from (i.e. a
>>>> non-deterministic pattern matching system.)
>>>>
>>>> I do have another patch that just disables io_uring for !MMU systems, if
>>>> you want that instead?  Or is this feature something that !MMU devices
>>>> actually care about?
>>>
>>> I mean, who really cares about !MMU in the first place, we should just
>>> kill that off with a passion.
>>>
>>> Let me take a closer look at this and bounce it past some vm people, my
>>> nommu knowledge is close to zero as it's never been relevant in my
>>> professional life time. Which is saying something...
>>
>> Let me try to get a reproducer going first, let's not waste any more
>> human time on this just yet, sorry for sending this out without that
>> done first...
> 
> Ok, attached is a poc.c and a script to run it.  If you run this on a
> 7.0 kernel today, it "should" crash. and then if you apply the patch it
> doesn't (or at least that's what happened in my testing.)
> 
> Note, I have run this locally, and it seems to work, but be careful, I
> can't guarantee anything, it does seem quite odd in that it "crashes"
> the kernel with a sysrq call to show "proof".  Although that is a cool
> trick, I need to remember that...

I'll try and run a nommu qemu and see what pops out on my end. What a
waste of time for a nothing burger ;-)

-- 
Jens Axboe


