Return-Path: <io-uring+bounces-12931-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oIlEFGpizmmXnQYAu9opvQ
	(envelope-from <io-uring+bounces-12931-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 02 Apr 2026 14:34:50 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CAD2F3891C3
	for <lists+io-uring@lfdr.de>; Thu, 02 Apr 2026 14:34:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 22E763023070
	for <lists+io-uring@lfdr.de>; Thu,  2 Apr 2026 12:31:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 232803E3C7F;
	Thu,  2 Apr 2026 12:31:33 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8354370D47;
	Thu,  2 Apr 2026 12:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775133090; cv=none; b=MwJGIg30nRaV0sdIX9VMukjV1/3VnnM8Wjc/rBnu9qQrStQv2Oxrhq+JhoWWyIGaGA6hf6ZeJ5M1P07X24oIONExywFVP38/sIFYvJ6FhjQtwZuUaqwK9/Vjr+3es/ILmjGRHI+7zzItT6fOjMR7SPkZUNmKfK6qgZRv4TW+73k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775133090; c=relaxed/simple;
	bh=L0T5Wo6Ypc4INXj0jpd8cy9hgPUCbJCWfQTNY9s9ZQ0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=ESuOVRcxLHqS/J5i28+Rc1CJ4NtSSwLCd7+wzRwzxkSPxJJfIyGqAAMC3U/Izq4J0gS8hcQBXnXGD0NROY0mb3JlR4w5MCpGc6y/qk6zSz9JukAjnrQzu2WJ4chyVifLNIDaY8mOlTEgCN+LPPdljYi3guQPtIKcJVfc8oswhcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id B65F88661D;
	Thu, 02 Apr 2026 14:31:24 +0200 (CEST)
Message-ID: <563f9b5f-9649-4a98-9025-671af55f29d7@proxmox.com>
Date: Thu, 2 Apr 2026 14:31:23 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: io_uring_prep_timeout() leading to an IO pressure close to 100
From: Fiona Ebner <f.ebner@proxmox.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: hannes@cmpxchg.org, surenb@google.com, peterz@infradead.org,
 io-uring@vger.kernel.org, Thomas Lamprecht <t.lamprecht@proxmox.com>
References: <14bc6266-5bc9-4454-9518-d1016bfe417b@proxmox.com>
 <49a977f3-45da-41dd-9fd6-75fd6760a591@kernel.dk>
 <bec202bd-cf01-4423-b3f6-f551bf269c8f@proxmox.com>
Content-Language: en-US
In-Reply-To: <bec202bd-cf01-4423-b3f6-f551bf269c8f@proxmox.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Bm-Milter-Handled: 55990f41-d878-4baa-be0a-ee34c49e34d2
X-Bm-Transport-Timestamp: 1775133025359
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,proxmox.com:mid];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.963];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_SEVEN(0.00)[7];
	R_DKIM_NA(0.00)[];
	DMARC_NA(0.00)[proxmox.com];
	FROM_NEQ_ENVFROM(0.00)[f.ebner@proxmox.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-12931-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[]
X-Rspamd-Queue-Id: CAD2F3891C3
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Am 02.04.26 um 11:12 AM schrieb Fiona Ebner:
> Am 01.04.26 um 5:02 PM schrieb Jens Axboe:
>> On 4/1/26 8:59 AM, Fiona Ebner wrote:
>>> I'm currently investigating an issue with QEMU causing an IO pressure
>>> value of nearly 100 when io_uring is used for the event loop of a QEMU
>>> iothread (which is the case since QEMU 10.2 if io_uring is enabled
>>> during configuration and available).
>>
>> It's not "IO pressure", it's the useless iowait metric...
> 
> But it is reported as IO pressure by the kernel, i.e. /proc/pressure/io
> (and for a cgroup, /sys/fs/cgroup/foo.slice/bar.scope/io.pressure).
> 
>>> The cause seems to be the io_uring_prep_timeout() call that is used for
>>> blocking wait. I attached a minimal reproducer below, which exposes the
>>> issue [0].
>>>
>>> This was observed on a kernel based on 7.0-rc6 as well as 6.17.13. I
>>> haven't investigated what happens inside the kernel yet, so I don't know
>>> if it is an accounting issue or within io_uring.
>>>
>>> Let me know if you need more information or if I should test something
>>> specific.
>>
>> If you won't want it, just turn it off with io_uring_set_iowait().
> 
> QEMU does submit actual IO request on the same ring and I suppose iowait
> should still be used for those?
> 
> Maybe setting the IORING_ENTER_NO_IOWAIT flag if only the timeout
> request is being submitted and no actual IO requests is an option? But
> even then, if a request is submitted later via another thread, iowait
> for that new request won't be accounted for, right?
> 
> Is there a way to say "I don't want IO wait for timeout submissions"?
> Wouldn't that even make sense by default?

Turns out, that in my QEMU instances, the branch doing the
io_uring_prep_timeout() call is not actually taken, so while the issue
could arise like that too, it's different in this practical case.

What I'm actually seeing is io_uring_submit_and_wait() being called with
wait_nr=1 while there is nothing else going on. So a more accurate
reproducer for the scenario is attached below [0]. Note that it does not
happen without sumbitting+completing a single request first.

Best Regards,
Fiona

[0]:

#include <errno.h>
#include <stdio.h>
#include <unistd.h>
#include <liburing.h>

int main(void) {
    int fd;
    int ret;
    struct io_uring ring;
    struct io_uring_sqe *sqe;

    ret = io_uring_queue_init(128, &ring, 0);
    if (ret != 0) {
        printf("Failed to initialize io_uring\n");
        return ret;
    }

    // before submitting+advancing the issue does not happen
    // ret = io_uring_submit_and_wait(&ring, 1);
    // printf("got ret %d\n", ret);

    sqe = io_uring_get_sqe(&ring);
    if (!sqe) {
        printf("Full sq\n");
        return -1;
    }

    io_uring_prep_nop(sqe);

    do {
        ret = io_uring_submit_and_wait(&ring, 1);
    } while (ret == -EINTR);

    if (ret != 1) {
        printf("Expected to submit one\n");
        return -1;
    }

    // using peek+seen has the same effect
    // struct io_uring_cqe* cqe;
    // io_uring_peek_cqe(&ring, &cqe);
    // io_uring_cqe_seen(&ring, cqe);
    io_uring_cq_advance(&ring, 1);

    ret = io_uring_submit_and_wait(&ring, 1);
    printf("got ret %d\n", ret);

    io_uring_queue_exit(&ring);

    return 0;
}



