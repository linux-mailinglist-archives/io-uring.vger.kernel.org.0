Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 485DA3E5ACF
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 15:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241135AbhHJNPu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Aug 2021 09:15:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38623 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241119AbhHJNPt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Aug 2021 09:15:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628601327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fJ3pNvm7jE2sg7bk2uct+zwhcMqnSG42g9P7ervPcF8=;
        b=azzD7N77xxmRwz831gomcCPZ40f/NU+En3e3Yl18/gG/RzalC61lz9J0N8p7ddlQEYuKSx
        /npZ8aSDjRqaGCE/VsIMTjOxVzj4rVSvv+e3CAl5Bz4nud5JAZvMZwHG62ZbZTg61hgJB/
        4A+hQaPepbxU7GMD5UK4KF/jcB/OXWA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-tLnaUJNyOZ6VcUSwHUGm4A-1; Tue, 10 Aug 2021 09:15:26 -0400
X-MC-Unique: tLnaUJNyOZ6VcUSwHUGm4A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5DA38801AE7;
        Tue, 10 Aug 2021 13:15:25 +0000 (UTC)
Received: from T590 (ovpn-13-190.pek2.redhat.com [10.72.13.190])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 441F12854F;
        Tue, 10 Aug 2021 13:15:18 +0000 (UTC)
Date:   Tue, 10 Aug 2021 21:15:14 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 1/4] bio: add allocation cache abstraction
Message-ID: <YRJ74uUkGfXjR52l@T590>
References: <20210809212401.19807-1-axboe@kernel.dk>
 <20210809212401.19807-2-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809212401.19807-2-axboe@kernel.dk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

On Mon, Aug 09, 2021 at 03:23:58PM -0600, Jens Axboe wrote:
> Add a set of helpers that can encapsulate bio allocations, reusing them
> as needed. Caller must provide the necessary locking, if any is needed.
> The primary intended use case is polled IO from io_uring, which will not
> need any external locking.
> 
> Very simple - keeps a count of bio's in the cache, and maintains a max
> of 512 with a slack of 64. If we get above max + slack, we drop slack
> number of bio's.
> 
> The cache is intended to be per-task, and the user will need to supply
> the storage for it. As io_uring will be the only user right now, provide
> a hook that returns the cache there. Stub it out as NULL initially.

Is it possible for user space to submit & poll IO from different io_uring
tasks?

Then one bio may be allocated from bio cache of the submission task, and
freed to cache of the poll task?


Thanks, 
Ming

