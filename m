Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D853D676C
	for <lists+io-uring@lfdr.de>; Mon, 26 Jul 2021 21:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbhGZSbg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Jul 2021 14:31:36 -0400
Received: from mail.efficios.com ([167.114.26.124]:53726 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231548AbhGZSbg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Jul 2021 14:31:36 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id ED6F1338DCA;
        Mon, 26 Jul 2021 15:12:03 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 0mQWDciyMZQ5; Mon, 26 Jul 2021 15:12:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 4F763338B71;
        Mon, 26 Jul 2021 15:12:03 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 4F763338B71
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1627326723;
        bh=+vzX220i5r7HS2zk0OpiF2RimMTFpUgBj6G7unT7ZaM=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=WKNKRiolc/bgzYmLmu0fyirPDvLK66lTIw9fOFYdy82eSjESOSZ5DitAUPiLC3NTu
         i3aGuy2UdtzCn9JdpuoHUypoe05s0LJnFyelYf7VRQsWHEFsK7bdUTmxxE1jobh1+j
         3qj4+JaDl0vEJI/ACmdSxJpRAIisK1tH5bsIE/aPrOwxseWe6q/tP8kdGh5051hs18
         f3A2RPoG3tEyNZRAkipuBqxpGktfHfVo/yxGZOxVQkk64bMadjvOrnVCcNzu6+KiNd
         zMxzv4egMJu/H+8T6NpF7ej31AcC1oQudQz4ZF4J7orLycoce/tXh+o1OfV2QkGJKW
         xvJKGdKlnEUAQ==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id mAK1OlDEdnAX; Mon, 26 Jul 2021 15:12:03 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 3D01833901C;
        Mon, 26 Jul 2021 15:12:03 -0400 (EDT)
Date:   Mon, 26 Jul 2021 15:12:03 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     rostedt <rostedt@goodmis.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        paulmck <paulmck@kernel.org>
Message-ID: <788674472.6819.1627326723120.JavaMail.zimbra@efficios.com>
In-Reply-To: <20210726144903.7736b9ad@oasis.local.home>
References: <20210722223320.53900ddc@rorschach.local.home> <715282075.6481.1627314401745.JavaMail.zimbra@efficios.com> <20210726125604.55bb6655@oasis.local.home> <682927571.6760.1627321158652.JavaMail.zimbra@efficios.com> <20210726144903.7736b9ad@oasis.local.home>
Subject: Re: [PATCH] tracepoints: Update static_call before tp_funcs when
 adding a tracepoint
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_4059 (ZimbraWebClient - FF90 (Linux)/8.8.15_GA_4059)
Thread-Topic: tracepoints: Update static_call before tp_funcs when adding a tracepoint
Thread-Index: YPOTsHRFOYtQ43hidRc8zxkcwL/jEA==
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

----- On Jul 26, 2021, at 2:49 PM, rostedt rostedt@goodmis.org wrote:

> On Mon, 26 Jul 2021 13:39:18 -0400 (EDT)
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
>> ----- On Jul 26, 2021, at 12:56 PM, rostedt rostedt@goodmis.org wrote:
>> 
>> > On Mon, 26 Jul 2021 11:46:41 -0400 (EDT)
>> > Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
>> [...]
>> >   

[...]

>> 
>> AFAIU, none of the synchronization mechanisms you refer to here (memory barrier,
>> IPIs..) will change the fact that this CPU may still be delayed across the
>> entire
>> 1->0->1 transition sequence, and may end up calling the new callback with the
>> old data. Unless an explicit RCU-sync is done.
> 
> OK. I see the issue you are saying. And this came from my assumption
> that the tracepoint code did a synchronization when unregistering the
> last callback. But of course it wont because that would make a lot of
> back to back synchronizations of a large number of tracepoints being
> unregistered at once.
> 

Something along the lines of the work approach you propose should work.

>> 
>> >   
>> >> 
>> >> My third conclusion is that we'd need synchronize RCU whenever tp_funcs[0].data
>> >> changes for transitions 1->2, 2->1, and 1->2 because the priorities don't
>> >> guarantee
>> >> that the first callback stays in the first position, and we also need to rcu
>> >> sync
>> >> unconditionally on transition 1->0. We currently only have sync RCU on
>> >> transition
>> >> from 2->1 when tp_funcs[0].func changes, which is bogus in many ways.
>> > 
>> > Going from 1 to 2, there's no issue. We switch to the iterator, which
>> > is the old method anyway. It looks directly at the array and matches
>> > the data with the func for each element of that array, and the data
>> > read initially (before calling the iterator) is ignored.
>> 
>> This relies on ordering guarantees between RCU assign/dereference and
>> static_call
>> updates/call. It may well be the case, but I'm asking anyway.
>> 
>> Are we guaranteed of the following ordering ?
>> 
>> CPU A                             CPU B
>> 
>>                                   static_call_update()
> 
> The static_call_update() triggers an IPI on all CPUs that perform a full memory
> barrier.
> 
> That is, nothing on any CPU will cross the static_call_update().
> 
>> y = rcu_dereference(x)            rcu_assign_pointer(x, ...)
>> do_static_call(y)
>> 
>> That load of "x" should never happen after the CPU fetches the new static call
>> instruction.
> 
> The 'y' will always be the new static call (which is the iterator in
> this case), and it doesn't matter which x it read, because the iterator
> will read the array just like it was done without static calls.

Here by "y" I mean the pointer loaded by rcu_dereference, which is then passed to the
call. I do not mean the call per se.

I suspect there is something like a control dependency between loading "x" through
rcu_dereference and passing the loaded pointer as argument to the static call (and
the instruction fetch of the static call). But I don't recall reading any documentation
of this specific ordering.

> 
>> 
>> Also, I suspect that transition 2->1 needs an unconditional rcu-sync because you
>> may have a sequence of 3->2->1 (or 1->2->1) where the element 0 data is
>> unchanged
>> between 2->1, but was changed from 3->2 (or from 1->2), which may be observed by
>> the
>> static call.
> 
> 
> I'll agree that we need to add synchronization between 1->0->1, but you
> have not convinced me on this second part.

In addition to 1->0->1, there are actually 2 other scenarios here:

Transition 1->2 to which the ordering question between RCU and static call is
related.

Transition 2->1 would need an unconditional rcu-sync, because of transitions
3->2->1 and 1->2->1 which can lead the static call to observe wrong data if the
rcu_dereference happens when there are e.g. 3 callbacks registered, and then the
static call to the function (single callback) is called on the 3-callbacks array.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
