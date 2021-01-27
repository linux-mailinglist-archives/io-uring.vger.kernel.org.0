Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E988C3061BE
	for <lists+io-uring@lfdr.de>; Wed, 27 Jan 2021 18:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbhA0RSY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jan 2021 12:18:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31258 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235118AbhA0RQZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jan 2021 12:16:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611767699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FQDdxr5Ot2UB3/vRDeFPsLgDYn96dHW3VhJaRZHYUTw=;
        b=cnSQUf0z4XoJ5+tNaHmiUwBvUJHtcPOpuwhfitM0wTGr41rN3qIi4M/UWNxdEJkKFMe4uk
        pMvEcO3QzgXpnWOuOsl+E6rN8Yl06pEMKwSupuQQcj+lVntNOFQqAhSdwz0ZoPYnhmNGBl
        C3sZk0rWZhoN7oP//wMLfKSWY+A8fOc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-lgSzPsYjMvSSisgJODNPdA-1; Wed, 27 Jan 2021 12:14:57 -0500
X-MC-Unique: lgSzPsYjMvSSisgJODNPdA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47925AFA80;
        Wed, 27 Jan 2021 17:14:56 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 088B460C77;
        Wed, 27 Jan 2021 17:14:42 +0000 (UTC)
Date:   Wed, 27 Jan 2021 12:14:42 -0500
From:   Mike Snitzer <snitzer@redhat.com>
To:     Jeffle Xu <jefflexu@linux.alibaba.com>
Cc:     joseph.qi@linux.alibaba.com, dm-devel@redhat.com,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH v2 3/6] block: add iopoll method to support bio-based IO
 polling
Message-ID: <20210127171442.GB11535@redhat.com>
References: <20210125121340.70459-1-jefflexu@linux.alibaba.com>
 <20210125121340.70459-4-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125121340.70459-4-jefflexu@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jan 25 2021 at  7:13am -0500,
Jeffle Xu <jefflexu@linux.alibaba.com> wrote:

> ->poll_fn was introduced in commit ea435e1b9392 ("block: add a poll_fn
> callback to struct request_queue") to support bio-based queues such as
> nvme multipath, but was later removed in commit 529262d56dbe ("block:
> remove ->poll_fn").
> 
> Given commit c62b37d96b6e ("block: move ->make_request_fn to struct
> block_device_operations") restore the possibility of bio-based IO
> polling support by adding an ->iopoll method to gendisk->fops.
> Elevate bulk of blk_mq_poll() implementation to blk_poll() and reduce
> blk_mq_poll() to blk-mq specific code that is called from blk_poll().
> 
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> Suggested-by: Mike Snitzer <snitzer@redhat.com>

Reviewed-by: Mike Snitzer <snitzer@redhat.com>

