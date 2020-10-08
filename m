Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 161CF28745C
	for <lists+io-uring@lfdr.de>; Thu,  8 Oct 2020 14:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730083AbgJHMh4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Oct 2020 08:37:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25303 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729722AbgJHMh4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Oct 2020 08:37:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602160675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8BwNT4iYD45Vztv7nysdJWnSG8XKP2AwXG1rPxDEm6s=;
        b=SsGaG/snu5V9vhw4GSLKi0qLq/km1LSFBgwkhvEhn12jiFlogdLDWdJ1bBEcEdwI362NuV
        vqpbwnzfOI4lcqbg6kQ+HUv5FidSH2P2qYLOcuJWJjEkRvR7VtiRtkExtrD4MRWIljRTxt
        TVlE4DzKGwgPtoGW22C78O07QqJJUy0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-irJx1NGON4yMAaVGgHGWHA-1; Thu, 08 Oct 2020 08:37:53 -0400
X-MC-Unique: irJx1NGON4yMAaVGgHGWHA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 123021019626;
        Thu,  8 Oct 2020 12:37:52 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.192.132])
        by smtp.corp.redhat.com (Postfix) with SMTP id 9706F5D9D5;
        Thu,  8 Oct 2020 12:37:50 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Thu,  8 Oct 2020 14:37:51 +0200 (CEST)
Date:   Thu, 8 Oct 2020 14:37:49 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Subject: Re: [PATCH 1/6] tracehook: clear TIF_NOTIFY_RESUME in
 tracehook_notify_resume()
Message-ID: <20201008123748.GD9995@redhat.com>
References: <20201005150438.6628-1-axboe@kernel.dk>
 <20201005150438.6628-2-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005150438.6628-2-axboe@kernel.dk>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens, sorry for delay..

On 10/05, Jens Axboe wrote:
>
> All the callers currently do this, clean it up and move the clearing
> into tracehook_notify_resume() instead.

To me this looks like a good cleanup regardless.

Oleg.

