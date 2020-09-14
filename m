Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF1F02685FD
	for <lists+io-uring@lfdr.de>; Mon, 14 Sep 2020 09:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbgINHcP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Sep 2020 03:32:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54373 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726170AbgINHcM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Sep 2020 03:32:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600068728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=OYbSipL5L5eI7NfL8NygWqGwHAYafKnhDuRZ7yxzWKc=;
        b=bJD1RLfC0iVsX6V9JqmN7dHcUlH3UJUyNpt9CRyuW3nTwYgNv3j35bZzDnd/JU7y8l1Vkx
        fBgcGJ0cuPAIpwcTg3nkovN+GDJHCKxISmBrAa6ub5pbnqwpJOp/5STWzK8KTlclwIO/pM
        eefi+cVRYksBkIUa/XFjaDOWWx4yGMc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-LHUxLaBnOr6rNbR-IwC-eA-1; Mon, 14 Sep 2020 03:32:06 -0400
X-MC-Unique: LHUxLaBnOr6rNbR-IwC-eA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E370425CB
        for <io-uring@vger.kernel.org>; Mon, 14 Sep 2020 07:32:05 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8EDF35D992
        for <io-uring@vger.kernel.org>; Mon, 14 Sep 2020 07:32:04 +0000 (UTC)
Date:   Mon, 14 Sep 2020 15:45:59 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     io-uring@vger.kernel.org
Subject: IO_URING on XFS regression bug report
Message-ID: <20200914074559.GM2937@dhcp-12-102.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Due to I don't know how to report a bug to io_uring maillist, I didn't find a
proper bug component for io_uring. So I have to send this email directly to
report this bug:

  https://bugzilla.kernel.org/show_bug.cgi?id=209243

Due to it's reproducible on XFS+LVM, but the first failed commit is an io_uring
patch:

  bcf5a06304d6 ("io_uring: support true async buffered reads, if file provides it")

So I'm not sure if it's an io_uring bug or xfs bug, so report to io_uring@ list to
help to analyze this failure.

Thanks,
Zorro

