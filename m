Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C806C28F4F5
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 16:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388583AbgJOOmt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 10:42:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60983 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388146AbgJOOms (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 10:42:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602772968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=78VLYdCYoG9Jop6L4V/VZuQfN2yvIOeKYNKNorl+SNo=;
        b=hPXtgkbOS5ZlTQPtf9SORwLKhwWPglTvNdWFstUjfe48UyMjJ/oPoZRPJn5JaL91AhbWZ5
        Ch4PabY3AblmWEb9J49U+X9He/asChDEXuaqBhRkVEZ5DRie6x3oxwlS7MN8oq4ZadHzt1
        kVdgKTuofK7YymhOV/6VkqR9SoyNVbg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-GO_ko-UNMDG6Pbn1ee4a2A-1; Thu, 15 Oct 2020 10:42:46 -0400
X-MC-Unique: GO_ko-UNMDG6Pbn1ee4a2A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED7DBE9006;
        Thu, 15 Oct 2020 14:42:44 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.193.8])
        by smtp.corp.redhat.com (Postfix) with SMTP id 6560E5D9D5;
        Thu, 15 Oct 2020 14:42:43 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Thu, 15 Oct 2020 16:42:44 +0200 (CEST)
Date:   Thu, 15 Oct 2020 16:42:42 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Subject: Re: [PATCH 2/5] kernel: add task_sigpending() helper
Message-ID: <20201015144241.GG24156@redhat.com>
References: <20201015131701.511523-1-axboe@kernel.dk>
 <20201015131701.511523-3-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015131701.511523-3-axboe@kernel.dk>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/15, Jens Axboe wrote:
>
> This is in preparation for maintaining signal_pending() as the decider
> of whether or not a schedule() loop should be broken, or continue
> sleeping. This is different than the core signal use cases, where we
> really want to know if an actual signal is pending or not.
> task_sigpending() returns non-zero if TIF_SIGPENDING is set.
> 
> Only core kernel use cases should care about the distinction between
> the two, make sure those use the task_sigpending() helper.
> 
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

the same,

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

