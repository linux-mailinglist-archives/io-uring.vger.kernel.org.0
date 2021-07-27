Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A99FA3D7739
	for <lists+io-uring@lfdr.de>; Tue, 27 Jul 2021 15:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237198AbhG0Nqx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Jul 2021 09:46:53 -0400
Received: from mail.efficios.com ([167.114.26.124]:36740 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236782AbhG0NqV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Jul 2021 09:46:21 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 8585933F472;
        Tue, 27 Jul 2021 09:46:20 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id SocnfGjM-Ps8; Tue, 27 Jul 2021 09:46:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 776FC33F7C1;
        Tue, 27 Jul 2021 09:46:19 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 776FC33F7C1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1627393579;
        bh=QekCrnP9rYFc2wAyaOh6WSKOcQvIPetOoyVWnd/Y2Q4=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=hlee9Wbze4iM5XafRrYQIDuHeEIEG7SziGm1PKHeoPdNw5sJSX1i03ULd/U0aipq/
         LtAy+mvT/YaOSejzhxLm/WhNYlJsheT2//2tPY7PvoxOevGUOwtThgNPP6yp6HmALE
         rLbezCpSfpViQpbbu92Je014KBokrprDIPBONqqzz5tXhpPqhBQ1Lsf4r5bqXUwH1E
         kYLXojlTv/W3qioiavU+A106jAfJqth+0gDScJ2nA0EGi4Wk8qTlWJBwTzmzkE02J9
         Fcn1IHGOUSMa63E5qqNkapn6abVm93MfpKbszsP1NADr+h2j43gz/uvSsr6VpyPEO4
         L8VhACkhqRYGA==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id kfudg1aQlenU; Tue, 27 Jul 2021 09:46:19 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 6425C33F7B1;
        Tue, 27 Jul 2021 09:46:19 -0400 (EDT)
Date:   Tue, 27 Jul 2021 09:46:19 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     rostedt <rostedt@goodmis.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>, paulmck <paulmck@kernel.org>
Message-ID: <1899212311.7583.1627393579305.JavaMail.zimbra@efficios.com>
In-Reply-To: <YP/xjnGx+CRYr5RR@hirez.programming.kicks-ass.net>
References: <20210722223320.53900ddc@rorschach.local.home> <715282075.6481.1627314401745.JavaMail.zimbra@efficios.com> <20210726125604.55bb6655@oasis.local.home> <682927571.6760.1627321158652.JavaMail.zimbra@efficios.com> <20210726144903.7736b9ad@oasis.local.home> <YP/xjnGx+CRYr5RR@hirez.programming.kicks-ass.net>
Subject: Re: [PATCH] tracepoints: Update static_call before tp_funcs when
 adding a tracepoint
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_4059 (ZimbraWebClient - FF90 (Linux)/8.8.15_GA_4059)
Thread-Topic: tracepoints: Update static_call before tp_funcs when adding a tracepoint
Thread-Index: KLxfoKgSNLUnAf2BhIiig6gz8CNLlQ==
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

----- On Jul 27, 2021, at 7:44 AM, Peter Zijlstra peterz@infradead.org wrote:

> On Mon, Jul 26, 2021 at 02:49:03PM -0400, Steven Rostedt wrote:
>> OK. I see the issue you are saying. And this came from my assumption
>> that the tracepoint code did a synchronization when unregistering the
>> last callback. But of course it wont because that would make a lot of
>> back to back synchronizations of a large number of tracepoints being
>> unregistered at once.
>> 
>> And doing it for all 0->1 or 1->0 or even a 1->0->1 can be costly.
>> 
>> One way to handle this is when going from 1->0, set off a worker that
>> will do the synchronization asynchronously, and if a 0->1 comes in,
>> have that block until the synchronization is complete. This should
>> work, and not have too much of an overhead.
>> 
>> If one 1->0 starts the synchronization, and one or more 1->0
>> transitions happen, it will be recorded where the worker will do
>> another synchronization, to make sure all 1->0 have went through a full
>> synchronization before a 0->1 can happen.
>> 
>> If a 0->1 comes in while a synchronization is happening, it will note
>> the current "number" for the synchronizations (if another one is
>> queued, it will wait for one more), before it can begin. As locks will
>> be held while waiting for synchronizations to finish, we don't need to
>> worry about another 1->0 coming in while a 0->1 is waiting.
> 
> Wouldn't get_state_synchronize_rcu() and cond_synchronize_rcu() get you
> what you need?

Indeed, snapshotting the state and conditionally waiting for a grace period
if none happened since the snapshot appears to be the intent here. Using
get_state+cond_sync should allow us to do this without any additional worker
thread.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
