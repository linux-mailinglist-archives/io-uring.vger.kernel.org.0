Return-Path: <io-uring+bounces-12930-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2A1eKrE0zmk8mAYAu9opvQ
	(envelope-from <io-uring+bounces-12930-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 02 Apr 2026 11:19:45 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FDCA386BE8
	for <lists+io-uring@lfdr.de>; Thu, 02 Apr 2026 11:19:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 07F0231415CE
	for <lists+io-uring@lfdr.de>; Thu,  2 Apr 2026 09:13:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A5D932F740;
	Thu,  2 Apr 2026 09:13:04 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745653630AE;
	Thu,  2 Apr 2026 09:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775121183; cv=none; b=ol2ZMJLORu/8dXgPGfIv50l0CFVBDo+E1kb0gb27OYgD08C6EQZU0rKgBTLoRXYplkH83VQPEPVC8K+UOXBROy82c0nlrXxOaZqGen0B6/WjaLeVJ2T2ZQRLAID2cQ6lzuzPXnuw4lBknuSoGIB+WPLVHftAKc/VbU0MnGL1GQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775121183; c=relaxed/simple;
	bh=ft2r+AWNQUZRWsqcyrmBNUuSr3HvgNPc6rOk7GiExyI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=STExlS9g1d6Tmi0GFJS1z5H6AfTTqopU3FWa2gdomHBG3jDzBpSAOd6BBFHRN1w06yJ0OoPz8CY2dsYgZP3m71UECefRsuDgD0SefmhQUPVAq4dTY3UyHSGicXfkvBtZYAhmBeAKOxW8R9crNALiOW3NVpdcQxiBPcIzAN1txjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 3626C8654E;
	Thu, 02 Apr 2026 11:12:59 +0200 (CEST)
Message-ID: <bec202bd-cf01-4423-b3f6-f551bf269c8f@proxmox.com>
Date: Thu, 2 Apr 2026 11:12:53 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: io_uring_prep_timeout() leading to an IO pressure close to 100
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: hannes@cmpxchg.org, surenb@google.com, peterz@infradead.org,
 io-uring@vger.kernel.org, Thomas Lamprecht <t.lamprecht@proxmox.com>
References: <14bc6266-5bc9-4454-9518-d1016bfe417b@proxmox.com>
 <49a977f3-45da-41dd-9fd6-75fd6760a591@kernel.dk>
Content-Language: en-US
From: Fiona Ebner <f.ebner@proxmox.com>
In-Reply-To: <49a977f3-45da-41dd-9fd6-75fd6760a591@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Bm-Milter-Handled: 55990f41-d878-4baa-be0a-ee34c49e34d2
X-Bm-Transport-Timestamp: 1775121120230
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.969];
	TAGGED_RCPT(0.00)[io-uring];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_COUNT_THREE(0.00)[4];
	R_DKIM_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[f.ebner@proxmox.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12930-lists,io-uring=lfdr.de];
	DMARC_NA(0.00)[proxmox.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[]
X-Rspamd-Queue-Id: 4FDCA386BE8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Am 01.04.26 um 5:02 PM schrieb Jens Axboe:
> On 4/1/26 8:59 AM, Fiona Ebner wrote:
>> I'm currently investigating an issue with QEMU causing an IO pressure
>> value of nearly 100 when io_uring is used for the event loop of a QEMU
>> iothread (which is the case since QEMU 10.2 if io_uring is enabled
>> during configuration and available).
> 
> It's not "IO pressure", it's the useless iowait metric...

But it is reported as IO pressure by the kernel, i.e. /proc/pressure/io
(and for a cgroup, /sys/fs/cgroup/foo.slice/bar.scope/io.pressure).

>> The cause seems to be the io_uring_prep_timeout() call that is used for
>> blocking wait. I attached a minimal reproducer below, which exposes the
>> issue [0].
>>
>> This was observed on a kernel based on 7.0-rc6 as well as 6.17.13. I
>> haven't investigated what happens inside the kernel yet, so I don't know
>> if it is an accounting issue or within io_uring.
>>
>> Let me know if you need more information or if I should test something
>> specific.
> 
> If you won't want it, just turn it off with io_uring_set_iowait().

QEMU does submit actual IO request on the same ring and I suppose iowait
should still be used for those?

Maybe setting the IORING_ENTER_NO_IOWAIT flag if only the timeout
request is being submitted and no actual IO requests is an option? But
even then, if a request is submitted later via another thread, iowait
for that new request won't be accounted for, right?

Is there a way to say "I don't want IO wait for timeout submissions"?
Wouldn't that even make sense by default?

Best Regards,
Fiona


