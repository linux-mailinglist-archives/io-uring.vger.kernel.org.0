Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAE11A170D
	for <lists+io-uring@lfdr.de>; Tue,  7 Apr 2020 22:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgDGUyt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Apr 2020 16:54:49 -0400
Received: from veto.sei.cmu.edu ([147.72.252.17]:46460 "EHLO veto.sei.cmu.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726380AbgDGUyt (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 7 Apr 2020 16:54:49 -0400
X-Greylist: delayed 1075 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Apr 2020 16:54:48 EDT
Received: from korb.sei.cmu.edu (korb.sei.cmu.edu [10.64.21.30])
        by veto.sei.cmu.edu (8.14.7/8.14.7) with ESMTP id 037KarA4022582
        for <io-uring@vger.kernel.org>; Tue, 7 Apr 2020 16:36:53 -0400
DKIM-Filter: OpenDKIM Filter v2.11.0 veto.sei.cmu.edu 037KarA4022582
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cert.org;
        s=yc2bmwvrj62m; t=1586291813;
        bh=aPj8y38zej6ZZz4LeIysicSbyiZ4oHbQosugdnA6cGQ=;
        h=From:To:Subject:Date:From;
        b=k8GyfcYPfBtuWqL0TeiRSSKfYkxr/8JDxJBqL+6ftfgLwZIN8cq7nur18IrgUm1gN
         pPnl7+rhW/K0pL225HfZewZCa9dKnJ8Rbj2WOzRAscBkmZyaXkopxUJS6588w+sBuH
         gO/oQNW1qb2CirvkJfRdW7fxvWp3NapINjqwr0fg=
Received: from CASCADE.ad.sei.cmu.edu (cascade.ad.sei.cmu.edu [10.64.28.248])
        by korb.sei.cmu.edu (8.14.7/8.14.7) with ESMTP id 037KaqEh019408
        for <io-uring@vger.kernel.org>; Tue, 7 Apr 2020 16:36:52 -0400
Received: from MURIEL.ad.sei.cmu.edu (147.72.252.47) by CASCADE.ad.sei.cmu.edu
 (10.64.28.248) with Microsoft SMTP Server (TLS) id 14.3.487.0; Tue, 7 Apr
 2020 16:36:51 -0400
Received: from MORRIS.ad.sei.cmu.edu (147.72.252.46) by MURIEL.ad.sei.cmu.edu
 (147.72.252.47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1847.3; Tue, 7 Apr 2020
 16:36:51 -0400
Received: from MORRIS.ad.sei.cmu.edu ([fe80::555b:9498:552e:d1bb]) by
 MORRIS.ad.sei.cmu.edu ([fe80::555b:9498:552e:d1bb%22]) with mapi id
 15.01.1847.007; Tue, 7 Apr 2020 16:36:51 -0400
From:   Joseph Christopher Sible <jcsible@cert.org>
To:     "'io-uring@vger.kernel.org'" <io-uring@vger.kernel.org>
Subject: Spurious/undocumented EINTR from io_uring_enter
Thread-Topic: Spurious/undocumented EINTR from io_uring_enter
Thread-Index: AdYNHCB8t2qqN/asQKmA7dRl2D+7cw==
Date:   Tue, 7 Apr 2020 20:36:51 +0000
Message-ID: <43b339d3dc0c4b6ab15652faf12afa30@cert.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.64.64.23]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When a process is blocking in io_uring_enter, and a signal stops it for
any reason, it returns -EINTR to userspace. Two comments about this:

1. https://github.com/axboe/liburing/blob/master/man/io_uring_enter.2
   doesn't mention EINTR as a possible error that it can return.
2. When there's no signal handler, and a signal stopped the syscall for
   some other reason (e.g., SIGSTOP, SIGTSTP, or any signal when the
   process is being traced), other syscalls (e.g., read) will be
   restarted transparently, but this one will return to userspace
   with -EINTR just as if there were a signal handler.

Point 1 seems like a no-brainer. I'm not sure if point 2 is possible
to fix, though, especially since some other syscalls (e.g., epoll_wait)
have the same problem as this one.

Joseph C. Sible
