Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF7A143F17E
	for <lists+io-uring@lfdr.de>; Thu, 28 Oct 2021 23:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbhJ1VWD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Oct 2021 17:22:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37898 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230491AbhJ1VV5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Oct 2021 17:21:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635455969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lYnZ+pHXh6p7up/Yz0cfJgXIZrWgYLmVol0wsk3IZqU=;
        b=F1TRfQbydLF2/rEslMbYXK+tJz2d1AyvTE287DHENELoZecUAaGCzU/baU/k/jVWYEq66D
        inA1AbEsscBV50Fo71SBdGf7i19KWRP0KNbxWKodvQxJLqxGQrjRxsfRKR7HmHCbeXbkiK
        /4tpAPRAil9LPahmp/hadAZx9hCagIc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-OWeL722FOPW8SsENBUNCbQ-1; Thu, 28 Oct 2021 17:19:28 -0400
X-MC-Unique: OWeL722FOPW8SsENBUNCbQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4017D1019982
        for <io-uring@vger.kernel.org>; Thu, 28 Oct 2021 21:19:27 +0000 (UTC)
Received: from x2.localnet (unknown [10.22.33.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 54DFC5F4EA;
        Thu, 28 Oct 2021 21:19:18 +0000 (UTC)
From:   Steve Grubb <sgrubb@redhat.com>
To:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        Richard Guy Briggs <rgb@redhat.com>
Cc:     io-uring@vger.kernel.org
Subject: Re: [PATCH v3 1/7] add basic support for the AUDIT_URINGOP record type
Date:   Thu, 28 Oct 2021 17:19:18 -0400
Message-ID: <4784353.GXAFRqVoOG@x2>
Organization: Red Hat
In-Reply-To: <20211028195939.3102767-2-rgb@redhat.com>
References: <20211028195939.3102767-1-rgb@redhat.com> <20211028195939.3102767-2-rgb@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thursday, October 28, 2021 3:59:33 PM EDT Richard Guy Briggs wrote:
> Kernel support to audit io_uring operations was added with commit
> 5bd2182d58e9 ("audit,io_uring,io-wq: add some basic audit support to
> io_uring").  Add basic support to recognize the "AUDIT_URINGOP" record.

Thanks! Applied.

-Steve


