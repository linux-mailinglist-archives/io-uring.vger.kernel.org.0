Return-Path: <io-uring+bounces-13139-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aAZWHYCP62k+OQAAu9opvQ
	(envelope-from <io-uring+bounces-13139-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 24 Apr 2026 17:42:56 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C1C43460E18
	for <lists+io-uring@lfdr.de>; Fri, 24 Apr 2026 17:42:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9A379300D85B
	for <lists+io-uring@lfdr.de>; Fri, 24 Apr 2026 15:42:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54BBB1A2545;
	Fri, 24 Apr 2026 15:42:49 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D713DA7CA;
	Fri, 24 Apr 2026 15:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777045367; cv=none; b=L72DZBgkERKw9+ngZN4o4sWoNa/JD5FWEekM+XBD4eQARxtFzPWlGm1osyWjlLG1KzVHXy6ehxAEYD0kxmigtp0/T4rUFA/iOYvI+mGQB9ZLmoAWAzYti2CF/kFoxgRgsGRxFOcAPgKkcoCFu025Xfzhb+EELZW2lTTIeeOMU/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777045367; c=relaxed/simple;
	bh=Hpy/B1JHN479/N0WEsuH95lGIGnTH/j3AdtCehW25pc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=tQKzoJnvaJRekh2eTFoE3mgnwhNA/dRURzOWdTt+S7mmZiTXzn3TUHn0YKKmXMBiGFaEz7xbG05uHsDrS8QwhUZZJ0cjjdsNvf7qkIkcvfceEjm0KuLLtnFKx3bbcFBzervycLKZjXOGbeUhQZtv8tRO3XuS6pbmmQQ+Ozd6oBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 8C3BEC59BF;
	Fri, 24 Apr 2026 17:42:26 +0200 (CEST)
Message-ID: <db7e6abb-677b-4b63-a028-d8fe0bec0277@proxmox.com>
Date: Fri, 24 Apr 2026 17:42:25 +0200
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
 <563f9b5f-9649-4a98-9025-671af55f29d7@proxmox.com>
Content-Language: en-US
In-Reply-To: <563f9b5f-9649-4a98-9025-671af55f29d7@proxmox.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Bm-Milter-Handled: 55990f41-d878-4baa-be0a-ee34c49e34d2
X-Bm-Transport-Timestamp: 1777045254701
X-Rspamd-Queue-Id: C1C43460E18
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	R_DKIM_NA(0.00)[];
	DMARC_NA(0.00)[proxmox.com];
	FROM_NEQ_ENVFROM(0.00)[f.ebner@proxmox.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-13139-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[]

Hi Jens,

Am 02.04.26 um 2:30 PM schrieb Fiona Ebner:
> Am 02.04.26 um 11:12 AM schrieb Fiona Ebner:
>> Am 01.04.26 um 5:02 PM schrieb Jens Axboe:
>>> On 4/1/26 8:59 AM, Fiona Ebner wrote:
>>>> I'm currently investigating an issue with QEMU causing an IO pressure
>>>> value of nearly 100 when io_uring is used for the event loop of a QEMU
>>>> iothread (which is the case since QEMU 10.2 if io_uring is enabled
>>>> during configuration and available).
>>>
>>> It's not "IO pressure", it's the useless iowait metric...
>>
>> But it is reported as IO pressure by the kernel, i.e. /proc/pressure/io
>> (and for a cgroup, /sys/fs/cgroup/foo.slice/bar.scope/io.pressure).
>>
>>>> The cause seems to be the io_uring_prep_timeout() call that is used for
>>>> blocking wait. I attached a minimal reproducer below, which exposes the
>>>> issue [0].
>>>>
>>>> This was observed on a kernel based on 7.0-rc6 as well as 6.17.13. I
>>>> haven't investigated what happens inside the kernel yet, so I don't know
>>>> if it is an accounting issue or within io_uring.
>>>>
>>>> Let me know if you need more information or if I should test something
>>>> specific.
>>>
>>> If you won't want it, just turn it off with io_uring_set_iowait().
>>
>> QEMU does submit actual IO request on the same ring and I suppose iowait
>> should still be used for those?
>>
>> Maybe setting the IORING_ENTER_NO_IOWAIT flag if only the timeout
>> request is being submitted and no actual IO requests is an option? But
>> even then, if a request is submitted later via another thread, iowait
>> for that new request won't be accounted for, right?
>>
>> Is there a way to say "I don't want IO wait for timeout submissions"?
>> Wouldn't that even make sense by default?
> 
> Turns out, that in my QEMU instances, the branch doing the
> io_uring_prep_timeout() call is not actually taken, so while the issue
> could arise like that too, it's different in this practical case.
> 
> What I'm actually seeing is io_uring_submit_and_wait() being called with
> wait_nr=1 while there is nothing else going on. So a more accurate
> reproducer for the scenario is attached below [0]. Note that it does not
> happen without sumbitting+completing a single request first. 

I started digging in the kernel now and am wondering whether the number
of inflight requests is correctly tracked? Does current_pending_io()
need to consider tctx->cached_refs?

In __io_cqring_wait_schedule(), there is

> 	if (ext_arg->iowait && current_pending_io())
> 		current->in_iowait = 1;

and current_pending_io() is

> static bool current_pending_io(void)
> {
> 	struct io_uring_task *tctx = current->io_uring;
> 
> 	if (!tctx)
> 		return false;
> 	return percpu_counter_read_positive(&tctx->inflight);
> }

so okay, we get iowait when tctx->inflight is positive. Looking at where
that variable is modified, I found

> void io_task_refs_refill(struct io_uring_task *tctx)
> {
> 	unsigned int refill = -tctx->cached_refs + IO_TCTX_REFS_CACHE_NR;
> 
> 	percpu_counter_add(&tctx->inflight, refill);
> 	refcount_add(refill, &current->usage);
> 	tctx->cached_refs += refill;
> }

as well as io_put_task() and io_uring_drop_tctx_refs().

I made __io_cqring_wait_schedule() and io_put_task() non-static,
non-inline to be able to trace them, made the following bpftrace script
[1] and ran the reproducer [0] getting the following output:

> Attaching 6 probes...
> 12104: io_task_refs_refill: cached: -1 inflight: 0
> 12104: ret io_task_refs_refill: cached: 1024 inflight: 1025
> 12104: io_put_task: cached: 1024 inflight: 1025
> 12104: ret io_put_task: cached: 1025 inflight: 1025
> 12104: __io_cqring_wait_schedule: iowait: 1
> 12104: __io_cqring_wait_schedule: inflight: 1025

And then it's stuck, as expected, but AFAICS, with current->in_iowait
set, which seems surprising to me.

Best Regards,
Fiona

[1]:

> kfunc::io_task_refs_refill
> {
>     printf("%d: %s: cached: %d inflight: %d\n",
>         tid,
>         func,
>         ((struct io_uring_task*)args.tctx)->cached_refs,
>         ((struct io_uring_task*)args.tctx)->inflight.count
>     );
> }
> 
> kretfunc::io_task_refs_refill
> {
>     printf("%d: ret %s: cached: %d inflight: %d\n",
>         tid,
>         func,
>         ((struct io_uring_task*)args.tctx)->cached_refs,
>         ((struct io_uring_task*)args.tctx)->inflight.count
>     );
> }
> 
> kfunc:io_uring_drop_tctx_refs
> {
>     printf("%d: %s\n", tid, func);
> }
> 
> kfunc:__io_cqring_wait_schedule
> {
>     printf("%d: %s: iowait: %d\n",
>         tid,
>         func,
>         ((struct ext_arg*)args.ext_arg)->iowait
>     );
>     if (curtask->io_uring) {
>         printf("%d: %s: inflight: %d\n",
>             tid,
>             func,
>             curtask->io_uring->inflight.count
>         );
>     } else {
>         printf("%d: %s: got no tctx!\n", tid, func);
>     }
> }
> 
> kfunc:io_put_task
> {
>     printf("%d: %s: cached: %d inflight: %d\n",
>         tid,
>         func,
>         ((struct io_kiocb*)args.req)->tctx->cached_refs,
>         ((struct io_kiocb*)args.req)->tctx->inflight.count
>     );
> }
> 
> kretfunc:io_put_task
> {
>     printf("%d: ret %s: cached: %d inflight: %d\n",
>         tid,
>         func,
>         ((struct io_kiocb*)args.req)->tctx->cached_refs,
>         ((struct io_kiocb*)args.req)->tctx->inflight.count
>     );
> }



> 
> [0]:
> 
> #include <errno.h>
> #include <stdio.h>
> #include <unistd.h>
> #include <liburing.h>
> 
> int main(void) {
>     int fd;
>     int ret;
>     struct io_uring ring;
>     struct io_uring_sqe *sqe;
> 
>     ret = io_uring_queue_init(128, &ring, 0);
>     if (ret != 0) {
>         printf("Failed to initialize io_uring\n");
>         return ret;
>     }
> 
>     // before submitting+advancing the issue does not happen
>     // ret = io_uring_submit_and_wait(&ring, 1);
>     // printf("got ret %d\n", ret);
> 
>     sqe = io_uring_get_sqe(&ring);
>     if (!sqe) {
>         printf("Full sq\n");
>         return -1;
>     }
> 
>     io_uring_prep_nop(sqe);
> 
>     do {
>         ret = io_uring_submit_and_wait(&ring, 1);
>     } while (ret == -EINTR);
> 
>     if (ret != 1) {
>         printf("Expected to submit one\n");
>         return -1;
>     }
> 
>     // using peek+seen has the same effect
>     // struct io_uring_cqe* cqe;
>     // io_uring_peek_cqe(&ring, &cqe);
>     // io_uring_cqe_seen(&ring, cqe);
>     io_uring_cq_advance(&ring, 1);
> 
>     ret = io_uring_submit_and_wait(&ring, 1);
>     printf("got ret %d\n", ret);
> 
>     io_uring_queue_exit(&ring);
> 
>     return 0;
> }
> 



