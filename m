Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2FB7415D1
	for <lists+io-uring@lfdr.de>; Wed, 28 Jun 2023 17:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbjF1P4M (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Jun 2023 11:56:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:41473 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232032AbjF1Pz6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Jun 2023 11:55:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687967708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9qZSFuxG0IoUAkOzLqBAsv4mqf5Nr+aL9HVwyHW9Zro=;
        b=RcpICQjNprk2iI6SU6M5tUF4m57sSbeUtNESUqUPi93RbW90unkcPSEu3ESdNt5Z3NMwYY
        Gtg+096xyUzS9g+DOY/1H5jE4AMK6tAJSyP8VNSSzzh8psBWvPSouvtxxPONtml9Rgs5Zd
        qrVjMl1Wdwfe6l+Csiv0q33TfonVpcg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-375-zxQD8_t6NrCMSLSlLOuOGA-1; Wed, 28 Jun 2023 11:54:53 -0400
X-MC-Unique: zxQD8_t6NrCMSLSlLOuOGA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D3320280D21A;
        Wed, 28 Jun 2023 15:54:05 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5CC97111F3B6;
        Wed, 28 Jun 2023 15:54:05 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Matteo Rizzo <matteorizzo@google.com>
Cc:     Ricardo Ribalda <ribalda@chromium.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, jordyzomer@google.com, evn@google.com,
        poprdi@google.com, corbet@lwn.net, axboe@kernel.dk,
        asml.silence@gmail.com, akpm@linux-foundation.org,
        keescook@chromium.org, rostedt@goodmis.org,
        dave.hansen@linux.intel.com, chenhuacai@kernel.org, steve@sk2.org,
        gpiccoli@igalia.com, ldufour@linux.ibm.com
Subject: Re: [PATCH 1/1] Add a new sysctl to disable io_uring system-wide
References: <20230627120058.2214509-1-matteorizzo@google.com>
        <20230627120058.2214509-2-matteorizzo@google.com>
        <e8924389-985a-42ad-9daf-eca2bf12fa57@acm.org>
        <CAHKB1wJANtT27WM6hrhDy_x9H9Lsn4qRjPDmXdKosoL93TJRYg@mail.gmail.com>
        <CANiDSCvjCoj3Q3phbmdhdG-veHNRrfD-gBu=FuZkmrgJ2uxiJg@mail.gmail.com>
        <CAHKB1w+UyOnC_rOBABVhmzG+XeePaWYgPJWxX9NUeqnAi9WcgA@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Wed, 28 Jun 2023 11:59:56 -0400
In-Reply-To: <CAHKB1w+UyOnC_rOBABVhmzG+XeePaWYgPJWxX9NUeqnAi9WcgA@mail.gmail.com>
        (Matteo Rizzo's message of "Wed, 28 Jun 2023 17:12:42 +0200")
Message-ID: <x497crnefwj.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Matteo Rizzo <matteorizzo@google.com> writes:

> On Wed, 28 Jun 2023 at 13:44, Ricardo Ribalda <ribalda@chromium.org> wrote:
>>
>> Have you considered that the new sysctl is "sticky like kexec_load_disabled.
>> When the user disables it there is no way to turn it back on until the
>> system is rebooted.
>
> Are you suggesting making this sysctl sticky? Are there any examples of how to
> implement a sticky sysctl that can take more than 2 values in case we want to
> add an intermediate level that still allows privileged processes to use
> io_uring? Also, what would be the use case? Preventing privileged processes
> from re-enabling io_uring?

See unprivileged_bpf_disabled for an example.  I can't speak to the use
case for a sticky value.

-Jeff

