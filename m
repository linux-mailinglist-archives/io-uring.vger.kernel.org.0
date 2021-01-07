Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB712EE6F5
	for <lists+io-uring@lfdr.de>; Thu,  7 Jan 2021 21:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbhAGUcz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Jan 2021 15:32:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47044 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726477AbhAGUcz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Jan 2021 15:32:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610051488;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Tzca927SwXjATKFpOJKBKDIo5ui/Nmo6YlcwpAd08V8=;
        b=PSAGcKcs9iQNq11+l2XhSzjSziY2u1rqX+EBC376mNlKIDNpUSKpI3zX8e31qiASnFWdpC
        3XHWtnumYJr9NUxEQRJ1A4pdZHFxeAwIguEG+1pmdPj6b9y2VrcvK5Pd4y+aFMo8N3i5Jb
        043jjJ+ssAZkVcJZLGgem2BXCB0MW64=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-z4mRm48sNCKwIvROr7w6yg-1; Thu, 07 Jan 2021 15:31:27 -0500
X-MC-Unique: z4mRm48sNCKwIvROr7w6yg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 429B48049C2;
        Thu,  7 Jan 2021 20:31:26 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C0D41002391;
        Thu,  7 Jan 2021 20:31:21 +0000 (UTC)
Date:   Thu, 7 Jan 2021 15:31:21 -0500
From:   Mike Snitzer <snitzer@redhat.com>
To:     Jeffle Xu <jefflexu@linux.alibaba.com>
Cc:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        io-uring@vger.kernel.org
Subject: Re: [PATCH RFC 2/7] block: add helper function fetching gendisk from
 queue
Message-ID: <20210107203121.GB21239@redhat.com>
References: <20201223112624.78955-1-jefflexu@linux.alibaba.com>
 <20201223112624.78955-3-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201223112624.78955-3-jefflexu@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Dec 23 2020 at  6:26am -0500,
Jeffle Xu <jefflexu@linux.alibaba.com> wrote:

> Sometimes we need to get the corresponding gendisk from request_queue.
> 
> One such use case is that, the block device driver had ever stored the
> same private data both in queue->queuedata and gendisk->private_data,
> while nowadays gendisk->private_data is more preferable in such case,
> e.g. commit c4a59c4e5db3 ("dm: stop using ->queuedata"). So if only
> request_queue given, we need to get the corresponding gendisk from
> queue, to get the private data stored in gendisk.
> 
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> ---
>  include/linux/blkdev.h       | 2 ++
>  include/trace/events/kyber.h | 6 +++---
>  2 files changed, 5 insertions(+), 3 deletions(-)

Looks good, but please update the patch subject and header to be:

block: add queue_to_disk() to get gendisk from request_queue

Sometimes we need to get the corresponding gendisk from request_queue.

It is preferred that block drivers store private data in
gendisk->private_data rather than request_queue->queuedata, e.g. see:
commit c4a59c4e5db3 ("dm: stop using ->queuedata").

So if only request_queue is given, we need to get its corresponding
gendisk to get the private data stored in that gendisk.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
Review-by: Mike Snitzer <snitzer@redhat.com>

