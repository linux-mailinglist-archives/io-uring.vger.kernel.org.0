Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B50DA28F50C
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 16:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388965AbgJOOo5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 10:44:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50398 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388876AbgJOOo4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 10:44:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602773095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tcPO3o/hYJXcAJ3J/Kqlj2k7Vj0IiF2WJJc9O8J4a5M=;
        b=cRkk9jej/iiLYrjtpCIlB4W5eSfK3sQh2BfscVa2hDj30tYEyJwrn5BHYROGsMpUI+rtMo
        GKILLd4HTwKqb8Mts1hdeOq1vXlI2dwiQyD8190SQ5R02kqSFuYMzeAVKfUDNIxg3Gwc2b
        ouCGCsQb/xUZ2BQYTwpzduormVs5NKA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-0Ems7peUNB2-9fpNV66wRQ-1; Thu, 15 Oct 2020 10:44:51 -0400
X-MC-Unique: 0Ems7peUNB2-9fpNV66wRQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 00CAB107AFC8;
        Thu, 15 Oct 2020 14:44:50 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.193.8])
        by smtp.corp.redhat.com (Postfix) with SMTP id 8594360C07;
        Thu, 15 Oct 2020 14:44:48 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Thu, 15 Oct 2020 16:44:49 +0200 (CEST)
Date:   Thu, 15 Oct 2020 16:44:47 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Subject: Re: [PATCH 4/5] x86: wire up TIF_NOTIFY_SIGNAL
Message-ID: <20201015144446.GI24156@redhat.com>
References: <20201015131701.511523-1-axboe@kernel.dk>
 <20201015131701.511523-5-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015131701.511523-5-axboe@kernel.dk>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/15, Jens Axboe wrote:
>
> We already get the ti_work passed in arch_do_signal(), define
> TIF_NOTIFY_SIGNAL and take the appropriate action in the signal handling
> based on _TIF_NOTIFY_SIGNAL and _TIF_SIGPENDING being set.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

