Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 847C33061DD
	for <lists+io-uring@lfdr.de>; Wed, 27 Jan 2021 18:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234939AbhA0RWx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jan 2021 12:22:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42157 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233847AbhA0RVR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jan 2021 12:21:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611767991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+zg44t7vpv/TsMxsvWnB8fciySseIuMy7CjnAeu8Zq4=;
        b=UjW1J1ULRsLcTBqs4/wT2j4RCGCPoXgpF2hC0DxwfcAvbsN/aqrxSuK11TtTTYE5/qHUhb
        bIoOv9DbwONGa9iiUKENFts+I36sgqzCyUzYCc1IzM1Hi4m3ImNW7HUZ8gpifcb/ZZWXw1
        LCq1bfYEePoQjkdYmWltUof9/axWU0c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-604-d_68vmW4PhW3YbNf0g7NRA-1; Wed, 27 Jan 2021 12:19:47 -0500
X-MC-Unique: d_68vmW4PhW3YbNf0g7NRA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3845107ACE4;
        Wed, 27 Jan 2021 17:19:45 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AD19D10246E0;
        Wed, 27 Jan 2021 17:19:42 +0000 (UTC)
Date:   Wed, 27 Jan 2021 12:19:42 -0500
From:   Mike Snitzer <snitzer@redhat.com>
To:     Jeffle Xu <jefflexu@linux.alibaba.com>
Cc:     joseph.qi@linux.alibaba.com, dm-devel@redhat.com,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH v2 0/6] dm: support IO polling for bio-based dm device
Message-ID: <20210127171941.GA11530@redhat.com>
References: <20210125121340.70459-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125121340.70459-1-jefflexu@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jan 25 2021 at  7:13am -0500,
Jeffle Xu <jefflexu@linux.alibaba.com> wrote:

> Since currently we have no simple but efficient way to implement the
> bio-based IO polling in the split-bio tracking style, this patch set
> turns to the original implementation mechanism that iterates and
> polls all underlying hw queues in polling mode. One optimization is
> introduced to mitigate the race of one hw queue among multiple polling
> instances.
> 
> I'm still open to the split bio tracking mechanism, if there's
> reasonable way to implement it.
> 
> 
> [Performance Test]
> The performance is tested by fio (engine=io_uring) 4k randread on
> dm-linear device. The dm-linear device is built upon nvme devices,
> and every nvme device has one polling hw queue (nvme.poll_queues=1).
> 
> Test Case		    | IOPS in IRQ mode | IOPS in polling mode | Diff
> 			    | (hipri=0)	       | (hipri=1)	      |
> --------------------------- | ---------------- | -------------------- | ----
> 3 target nvme, num_jobs = 1 | 198k 	       | 276k		      | ~40%
> 3 target nvme, num_jobs = 3 | 608k 	       | 705k		      | ~16%
> 6 target nvme, num_jobs = 6 | 1197k 	       | 1347k		      | ~13%
> 3 target nvme, num_jobs = 6 | 1285k 	       | 1293k		      | ~0%
> 
> As the number of polling instances (num_jobs) increases, the
> performance improvement decreases, though it's still positive
> compared to the IRQ mode.

I think there is serious room for improvement for DM's implementation;
but the block changes for this are all we'd need for DM in the longrun
anyway (famous last words). So on a block interface level I'm OK with
block patches 1-3.

I don't see why patch 5 is needed (said the same in reply to it; but I
just saw your reason below..).

Anyway, I can pick up DM patches 4 and 6 via linux-dm.git if Jens picks
up patches 1-3. Jens, what do you think?

> [Optimization]
> To mitigate the race when iterating all the underlying hw queues, one
> flag is maintained on a per-hw-queue basis. This flag is used to
> indicate whether this polling hw queue currently being polled on or
> not. Every polling hw queue is exclusive to one polling instance, i.e.,
> the polling instance will skip this polling hw queue if this hw queue
> currently is being polled by another polling instance, and start
> polling on the next hw queue.
> 
> This per-hw-queue flag map is currently maintained in dm layer. In
> the table load phase, a table describing all underlying polling hw
> queues is built and stored in 'struct dm_table'. It is safe when
> reloading the mapping table.
> 
> 
> changes since v1:
> - patch 1,2,4 is the same as v1 and have already been reviewed
> - patch 3 is refactored a bit on the basis of suggestions from
> Mike Snitzer.
> - patch 5 is newly added and introduces one new queue flag
> representing if the queue is capable of IO polling. This mainly
> simplifies the logic in queue_poll_store().

Ah OK, don't see why we want to eat a queue flag for that though!

> - patch 6 implements the core mechanism supporting IO polling.
> The sanity check checking if the dm device supports IO polling is
> also folded into this patch, and the queue flag will be cleared if
> it doesn't support, in case of table reloading.

Thanks,
Mike

