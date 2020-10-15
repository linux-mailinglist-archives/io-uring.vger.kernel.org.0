Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6ED028F4F2
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 16:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388305AbgJOOmR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 10:42:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45775 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388086AbgJOOmQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 10:42:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602772935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=in0hh1/V/h9AqP7nYodG3+/qzGfNpSl7z/ehmExxz38=;
        b=hzbac/nZPCdJveB0hQlZGGe+lk9q7vgAm13ewIwglR87ha4+iQbTgk46BR4QnhE70LpyrC
        iFyC9dxcpbZwy0XSdqVhcbw60yTpZvR/bM76LXKjrbMxySlq8tMTa9eFNDkQMesYwlKYL3
        VlozCLLHqba5lwN6kHYA6iDReeLE8SA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-Z6OFtD9vOSqQzluGFFxKCw-1; Thu, 15 Oct 2020 10:42:13 -0400
X-MC-Unique: Z6OFtD9vOSqQzluGFFxKCw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 54775108E1C2;
        Thu, 15 Oct 2020 14:42:11 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.193.8])
        by smtp.corp.redhat.com (Postfix) with SMTP id C985776642;
        Thu, 15 Oct 2020 14:42:09 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Thu, 15 Oct 2020 16:42:10 +0200 (CEST)
Date:   Thu, 15 Oct 2020 16:42:08 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Subject: Re: [PATCH 1/5] tracehook: clear TIF_NOTIFY_RESUME in
 tracehook_notify_resume()
Message-ID: <20201015144207.GF24156@redhat.com>
References: <20201015131701.511523-1-axboe@kernel.dk>
 <20201015131701.511523-2-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015131701.511523-2-axboe@kernel.dk>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/15, Jens Axboe wrote:
>
> All the callers currently do this, clean it up and move the clearing
> into tracehook_notify_resume() instead.
>
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

in case you didn't notice I already acked this change ;)

Reviewed-by: Oleg Nesterov <oleg@redhat.com>


