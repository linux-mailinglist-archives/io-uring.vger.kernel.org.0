Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 885222816CA
	for <lists+io-uring@lfdr.de>; Fri,  2 Oct 2020 17:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726176AbgJBPi7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Oct 2020 11:38:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45503 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388068AbgJBPi7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Oct 2020 11:38:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601653138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=36FCS78Qd5VasTsIOB0fmeKmJgKsqjwU3OSxRwKzeNc=;
        b=AX12vbY19fYeNjHZqer5g5hpR1vce2fxWru1K+Lvd5dYBpW/nhpIQpKFnznAIu1d2k7sQO
        tQXdGcqDlPTH2uqgTQIZc/wOlhJlMFby1WRTrZrwigo3CUf++/dq/fC9y9QKLXwOMnBYkX
        zypkWSJGlrlklwHWQ+feNW64KQiVT/Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-7ZgihHfHOYG4JvHuV0Pt6g-1; Fri, 02 Oct 2020 11:38:54 -0400
X-MC-Unique: 7ZgihHfHOYG4JvHuV0Pt6g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 233098030CE;
        Fri,  2 Oct 2020 15:38:53 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.192.246])
        by smtp.corp.redhat.com (Postfix) with SMTP id 9C5E573678;
        Fri,  2 Oct 2020 15:38:51 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Fri,  2 Oct 2020 17:38:52 +0200 (CEST)
Date:   Fri, 2 Oct 2020 17:38:50 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH 3/3] task_work: use TIF_TASKWORK if available
Message-ID: <20201002153849.GC29066@redhat.com>
References: <20201001194208.1153522-1-axboe@kernel.dk>
 <20201001194208.1153522-4-axboe@kernel.dk>
 <20201002151415.GA29066@redhat.com>
 <871rigejb8.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871rigejb8.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/02, Thomas Gleixner wrote:
>
> I think it's fundamentaly wrong that we have several places and several
> flags which handle task_work_run() instead of having exactly one place
> and one flag.

Damn yes, agreed.

Oleg.

