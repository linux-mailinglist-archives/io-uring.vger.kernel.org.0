Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC034A4F26
	for <lists+io-uring@lfdr.de>; Mon, 31 Jan 2022 20:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234669AbiAaTE0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 Jan 2022 14:04:26 -0500
Received: from wrqvvpzp.outbound-mail.sendgrid.net ([149.72.131.227]:31364
        "EHLO wrqvvpzp.outbound-mail.sendgrid.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358998AbiAaTE0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 Jan 2022 14:04:26 -0500
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 Jan 2022 14:04:25 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=catern.com;
        h=from:subject:mime-version:to:content-type:content-transfer-encoding;
        s=s1; bh=Hbj6qVYSv0E3VFswWVNNr1celefnDHzNQNQ/1s3SNLc=;
        b=1JOMiUM7INiYj7SX3OLqZb49xEh+/PTga+SpppoQqIZRV4OYotQF1bcZDspycDO9BoWe
        t0uG5BrSAtStLU2O83dLpEPalgTMbECnBU2iOHYQZoLZjThT2ONyhqOF5bXzxKHya4OtZw
        5kdozmLeNRfUjRKr2fDHWONMoatiAdjYEIvdG2HfoIADU2lF4Yg/v0Ld+rU56KMokPuaxs
        ufHOCM7uv3zDtCmsykl5YA6hryyjkrhVKbREauuSMnnAGi4Ot+o0pxUK522+SfUr5aAsat
        JC17HaFLqUqzwsgipRjwV6/ewOgmTJztRJmPdm2sxug2mbnlhPhHzA1fttf2dkNg==
Received: by filterdrecv-7bc86b958d-6sxkj with SMTP id filterdrecv-7bc86b958d-6sxkj-1-61F83098-9
        2022-01-31 18:55:20.170223817 +0000 UTC m=+13120499.550416994
Received: from earth.catern.com (unknown)
        by ismtpd0168p1mdw1.sendgrid.net (SG) with ESMTP id XoXStXjcRqazTt9Irpsawg
        for <io-uring@vger.kernel.org>; Mon, 31 Jan 2022 18:55:19.993 +0000 (UTC)
X-Comment: SPF check N/A for local connections - client-ip=::1; helo=localhost; envelope-from=sbaugh@catern.com; receiver=<UNKNOWN> 
Received: from localhost (localhost [IPv6:::1])
        by earth.catern.com (Postfix) with ESMTPSA id 22080600A9
        for <io-uring@vger.kernel.org>; Mon, 31 Jan 2022 13:55:19 -0500 (EST)
From:   Spencer Baugh <sbaugh@catern.com>
Subject: FlexSC influence on io_uring
Date:   Mon, 31 Jan 2022 18:55:20 +0000 (UTC)
Message-ID: <87o83r7n1k.fsf@catern.com>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?GW3oCMoYnalRiojMOuLzE6x2H5kORXvlCdz1UwQVRMVT4fbh9ODEfCogOe74cO?=
 =?us-ascii?Q?rI4e0V+MFZgakz9Re5a6=2FCgkFJF3YJBpVHNlGj3?=
 =?us-ascii?Q?d1zR=2FKtDhRRtpWOBsu59J3aMntgUCtQOzGzE1d6?=
 =?us-ascii?Q?MYcTqpT4ca76osGdvdjDfQqQ+U5mgfa+JtTjYb9?=
 =?us-ascii?Q?hzhWO4+YIq0MjU2hcoQ0xkO80dwI0RqXx30BcoA?=
 =?us-ascii?Q?qIqGSiir7P2FjWmWvzqP0skvMCzLA0E+spZGOz?=
To:     io-uring@vger.kernel.org
X-Entity-ID: d/0VcHixlS0t7iB1YKCv4Q==
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Hi,

To what extent, if any, was the FlexSC paper an influence on io_uring?

FlexSC is described in a paper from 2010:
https://www.usenix.org/legacy/events/osdi10/tech/full_papers/Soares.pdf

FlexSC is a system for asynchronous system calls aimed at achieving
high-performance by avoiding the cost of system calls, in particular the
locality costs of executing kernel code and user code on the same core.

Implementation-wise, it seems broadly similar to io_uring, in that
system calls are submitted by writing to some location in memory, which
is later picked up by a syscall-execution thread (ala
IORING_SETUP_SQPOLL) which executes it and writes back the result.

I'm just curious if there was any influence from FlexSC on io_uring.

Thanks,
Spencer Baugh
