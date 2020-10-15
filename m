Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B0A28F500
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 16:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730793AbgJOOo0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 10:44:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44760 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726925AbgJOOo0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 10:44:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602773065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MeShlhmQePzhYrhnxCh1xoXkzKIrQ+wwpOnr+ODxTdg=;
        b=FR4Zl3nXWO8kB5/J7aucBW8gDa9o9e12rGO50uhEvkNrl8NV8lOHEjXu4nMfSa4/b2qao+
        V09E2UsKN6YvAmKxc9nzyjR5Bzv9qm7g2cDGymmTZYXizzGncVX5prhwvp2YL9fzvuQwTB
        oADBFJjg5rKMF6NvalmekbBbjfdtVuM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-TMBvXjXNOy2CHsx_NNFUqQ-1; Thu, 15 Oct 2020 10:44:23 -0400
X-MC-Unique: TMBvXjXNOy2CHsx_NNFUqQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 70917107AFAF;
        Thu, 15 Oct 2020 14:44:22 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.193.8])
        by smtp.corp.redhat.com (Postfix) with SMTP id 007BB6EF72;
        Thu, 15 Oct 2020 14:44:20 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Thu, 15 Oct 2020 16:44:22 +0200 (CEST)
Date:   Thu, 15 Oct 2020 16:44:19 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Subject: Re: [PATCH 3/5] kernel: add support for TIF_NOTIFY_SIGNAL
Message-ID: <20201015144419.GH24156@redhat.com>
References: <20201015131701.511523-1-axboe@kernel.dk>
 <20201015131701.511523-4-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015131701.511523-4-axboe@kernel.dk>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/15, Jens Axboe wrote:
>
> This adds TIF_NOTIFY_SIGNAL handling in the generic code, which if set,
> will return true if signal_pending() is used in a wait loop. That causes
> an exit of the loop so that notify_signal tracehooks can be run. If the
> wait loop is currently inside a system call, the system call is restarted
> once task_work has been processed.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

So I strongly disagree with CONFIG_GENERIC_ENTRY. Otherwise,

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

