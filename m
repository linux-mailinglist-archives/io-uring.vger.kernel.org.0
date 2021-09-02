Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A23CF3FF1C8
	for <lists+io-uring@lfdr.de>; Thu,  2 Sep 2021 18:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346286AbhIBQtK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Sep 2021 12:49:10 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:57332 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234478AbhIBQtJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Sep 2021 12:49:09 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 2ECE11FFF2;
        Thu,  2 Sep 2021 16:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1630601290; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5eEaSFkJ0xTGS8oHCd13RxHxJQOpWzHq0hlFTFZ0wR8=;
        b=UEmi6BH6oifmPDQfaYWkIOdPlclsQB9mvkVeHKK8mcvH1JNmCTcsF+/1351+tw7LcZDcWO
        BIpz8D70Zk+VI7dtc4PPJKngxTUjoJv22pwwkSqpm/x71TGKszwa9nkStue7OSbNN3G1V6
        Iuzckd4Z/+yHmuULf4AdmFg/ZDVLE1w=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 0D72B13AC7;
        Thu,  2 Sep 2021 16:48:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id /+ciAkoAMWFUSwAAGKfGzw
        (envelope-from <mkoutny@suse.com>); Thu, 02 Sep 2021 16:48:10 +0000
Date:   Thu, 2 Sep 2021 18:48:08 +0200
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>,
        Tejun Heo <tj@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, cgroups@vger.kernel.org,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH v4 0/2] refactor sqthread cpu binding logic
Message-ID: <20210902164808.GA10014@blackbody.suse.cz>
References: <20210901124322.164238-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901124322.164238-1-haoxu@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello Hao.

On Wed, Sep 01, 2021 at 08:43:20PM +0800, Hao Xu <haoxu@linux.alibaba.com> wrote:
> This patchset is to enhance sqthread cpu binding logic, we didn't
> consider cgroup setting before. In container environment, theoretically
> sqthread is in its container's task group, it shouldn't occupy cpu out
> of its container.

I see in the discussions that there's struggle to make
set_cpus_allowed_ptr() do what's intended under the given constraints.

IIUC, set_cpus_allowed_ptr() is conventionally used for kernel threads
[1]. But does the sqthread fall into this category? You want to have it
_directly_ associated with a container and its cgroups. It looks to me
more like a userspace thread (from this perspective, not literally). Or
is there a different intention?

It seems to me that reusing the sched_setaffinity() (with all its
checks and race pains/solutions) would be a more universal approach.
(I don't mean calling sched_setaffinity() directly, some parts would
need to be factored separately to this end.) WDYT?


Regards,
Michal

[1] Not only spending their life in kernel but providing some
delocalized kernel service.
