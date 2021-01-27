Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 344153061AE
	for <lists+io-uring@lfdr.de>; Wed, 27 Jan 2021 18:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235034AbhA0RQR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jan 2021 12:16:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22853 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234128AbhA0RO4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jan 2021 12:14:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611767607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z7mGBlHRLZU/PRglXzorkWK1u2MHkwHlUmIrHobRuLA=;
        b=B1dTFyOz7kFDglXJQhJNb5z2T0sFzDG/+BCglBO8Jj8plprlfFGh1UxTjsuLHssTKYAeZP
        rmT2NtQ7t24Dv8sesnatGst0GCJCYC/4JY+Uu0gl9fvjknOQf3ZoduKu12cwPYZxpwrnGJ
        P0lMFz3Q5K7C/bclJ5l+qn2siAjjYNs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-1z67nAIJOyGQ97FrMb-vSA-1; Wed, 27 Jan 2021 12:13:26 -0500
X-MC-Unique: 1z67nAIJOyGQ97FrMb-vSA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0DDA98145E0;
        Wed, 27 Jan 2021 17:13:25 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BDBB660873;
        Wed, 27 Jan 2021 17:13:21 +0000 (UTC)
Date:   Wed, 27 Jan 2021 12:13:21 -0500
From:   Mike Snitzer <snitzer@redhat.com>
To:     Jeffle Xu <jefflexu@linux.alibaba.com>
Cc:     joseph.qi@linux.alibaba.com, dm-devel@redhat.com,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH v2 5/6] block: add QUEUE_FLAG_POLL_CAP flag
Message-ID: <20210127171320.GA11535@redhat.com>
References: <20210125121340.70459-1-jefflexu@linux.alibaba.com>
 <20210125121340.70459-6-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125121340.70459-6-jefflexu@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jan 25 2021 at  7:13am -0500,
Jeffle Xu <jefflexu@linux.alibaba.com> wrote:

> Introduce QUEUE_FLAG_POLL_CAP flag representing if the request queue
> capable of polling or not.
> 
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>

Why are you adding QUEUE_FLAG_POLL_CAP?  Doesn't seem as though DM or
anything else actually needs it.

Mike

