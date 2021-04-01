Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54D01351A91
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 20:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235953AbhDASB7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 14:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236065AbhDAR5R (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 13:57:17 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FFBC0D9426;
        Thu,  1 Apr 2021 07:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:Cc:To:From;
        bh=8jYVTSHcDUfHY7lSnRvxzqvV+XEOiioVeMCNkU5pL/U=; b=gmeqKFSfEmZMR4ikxGpeC9sR6z
        HstPDGcPczEeSWVvfeQryWdLv5R0S8Lvi/AS+peqlhACr6i8pQZvrjTYs8gXY5UGXcNAh11PcNS9h
        L4rOw1MMvCOPtEg7gPMyfgcuEIKpI+SsdA1FnVDympI0txP4z1iGSHrA3YpHoJjq1YCuDNAu04YSN
        GQ2RP1MO7lwug85uFQi7RCikLv5eL9DW8VmzFnPV9DVPXKQnQ68TODydm0GPBcNefySbrIi6JVebG
        dXpnluVTE8W71WJ5ORgMnuBsJlp3ot2ldpSPuXaP93I+7leTSMfTBM6j4kFtCrrlSJXRUyOiHxedD
        qhfjLZo0vOT54tB7E4WWwA/g60y9moxBetQSLwZklwq3ny8AgUd95GtqLA39O29qHkdA3J949aHsx
        TvowkICdfdpaqLCdV/7V2UtVaXPzLpt+qjNcX/xRDAcRPZBxJFt/tVQ3bK8XevOdoCql1pTR3Tpoy
        ArP01jTDNK8Xbe9/GkJ5X9Ae;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lRyhE-0007Rp-QU; Thu, 01 Apr 2021 14:53:20 +0000
Subject: Re: [PATCH 2/8] kernel: unmask SIGSTOP for IO threads
From:   Stefan Metzmacher <metze@samba.org>
To:     Jens Axboe <axboe@kernel.dk>, Oleg Nesterov <oleg@redhat.com>
Cc:     io-uring@vger.kernel.org, torvalds@linux-foundation.org,
        ebiederm@xmission.com, linux-kernel@vger.kernel.org
References: <20210326003928.978750-1-axboe@kernel.dk>
 <20210326003928.978750-3-axboe@kernel.dk> <20210326134840.GA1290@redhat.com>
 <a179ad33-5656-b644-0d92-e74a6bd26cc8@kernel.dk>
 <8f2a4b48-77c9-393f-5194-100ed63c05fc@samba.org>
 <58f67a8b-166e-f19c-ccac-157153e4f17c@kernel.dk>
 <c61fc5eb-c997-738b-1a60-5e3db2754f49@samba.org>
Message-ID: <a891f9b7-81fb-5534-891c-306593961156@samba.org>
Date:   Thu, 1 Apr 2021 16:53:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <c61fc5eb-c997-738b-1a60-5e3db2754f49@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

>>> I don't assume signals wanted by userspace should potentially handled in an io_thread...
>>> e.g. things set with fcntl(fd, F_SETSIG,) used together with F_SETLEASE?
>>
>> I guess we do actually need it, if we're not fiddling with
>> wants_signal() for them. To quell Oleg's concerns, we can just move it
>> to post dup_task_struct(), that should eliminate any race concerns
>> there.
> 
> If that one is racy, don' we better also want this one?
> https://lore.kernel.org/io-uring/438b738c1e4827a7fdfe43087da88bbe17eedc72.1616197787.git.metze@samba.org/T/#u
> 
> And clear tsk->pf_io_worker ?

As the workers don't clone other workers I guess it's fine to defer this to 5.13.

metze

