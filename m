Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4515C28F620
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 17:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389844AbgJOPuF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 11:50:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39272 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389813AbgJOPuD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 11:50:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602777002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+KBQJxnzY9IJB92xwhkX7sURjnYMLbV8YEBAs4xU9Tg=;
        b=cMKoQ16LmjHHrSG33Lfa6fQfmJJ4pHRCbJv9UMvuqKVSnCri4crJ2dkB87EFTSndHuNFON
        R9yLAA3gZqTSNzn892ogObk4F6OBYouUVZNBpM/DNEz9X08gKcuH1iWK+fbTe8R+O1uAFl
        RpBnsyl74npM/GGvDi8SDITwl9JWfss=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-sYJxVKzVPKWhB_A4sNAozQ-1; Thu, 15 Oct 2020 11:49:58 -0400
X-MC-Unique: sYJxVKzVPKWhB_A4sNAozQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 166C8EC50A;
        Thu, 15 Oct 2020 15:49:57 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.193.8])
        by smtp.corp.redhat.com (Postfix) with SMTP id 4F93376670;
        Thu, 15 Oct 2020 15:49:55 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Thu, 15 Oct 2020 17:49:56 +0200 (CEST)
Date:   Thu, 15 Oct 2020 17:49:54 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de,
        Roman Gershman <romger@amazon.com>
Subject: Re: [PATCH 5/5] task_work: use TIF_NOTIFY_SIGNAL if available
Message-ID: <20201015154953.GM24156@redhat.com>
References: <20201015131701.511523-1-axboe@kernel.dk>
 <20201015131701.511523-6-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015131701.511523-6-axboe@kernel.dk>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/15, Jens Axboe wrote:
>
> Reviewed-by: Oleg Nesterov <oleg@redhat.com>

Yes, but ...

> +static void task_work_notify_signal(struct task_struct *task)
> +{
> +#if defined(CONFIG_GENERIC_ENTRY) && defined(TIF_NOTIFY_SIGNAL)

as long as defined(CONFIG_GENERIC_ENTRY) goes away ;)

Thomas, I strongly, strongly disagree with you. But even if you are right
and only CONFIG_GENERIC_ENTRY arches should use TIF_NOTIFY_SIGNAL, why should
this series check CONFIG_GENERIC_ENTRY ?

You can simply nack the patch which adds TIF_NOTIFY_SIGNAL to
arch/xxx/include/asm/thread_info.h.

Oleg.

