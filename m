Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3944826CB92
	for <lists+io-uring@lfdr.de>; Wed, 16 Sep 2020 22:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgIPU34 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Sep 2020 16:29:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43984 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726939AbgIPRXw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Sep 2020 13:23:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600276987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=F9u9qYwCYGwnKvUW3Qwuq0EBArWLV1qdPypf2tsQD8g=;
        b=bbyQ8Jq+v1gtgQmHEJzIUpTygGNS+0gY20SwmVdi3OoFBFzHg2Y9iBxTUXzXEE27l7dvQG
        soTA6UWsGNnOegEsjUXKYwx047O3Rj+ocKqU3EVIiJUGNfoJspejDgl3FGyMdJHRwCLTg2
        WahJkLvzpdb6NDhU0Th6fdb3m7pc1KM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-kZoDv5SFO9qf6rrzv4ofjw-1; Wed, 16 Sep 2020 13:14:59 -0400
X-MC-Unique: kZoDv5SFO9qf6rrzv4ofjw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 096DA425F3;
        Wed, 16 Sep 2020 17:14:48 +0000 (UTC)
Received: from bogon.redhat.com (ovpn-13-242.pek2.redhat.com [10.72.13.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C132660BFA;
        Wed, 16 Sep 2020 17:14:46 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     io-uring@vger.kernel.org
Subject: [PATCH 0/3] xfstests: add IO_URING test cases
Date:   Thu, 17 Sep 2020 01:14:40 +0800
Message-Id: <20200916171443.29546-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patchset bases on https://patchwork.kernel.org/cover/11769847/, which
makes xfstests fsstress and fsx supports IO_URING.

The io_uring IOs in fsstress will be run automatically when fsstress get
running. But fsx need a special option '-U' to run IO_URING read/write, so
add two new cases to xfstests to do fsx buffered and direct IO IO_URING
test.

[1/3] new helper to require io_uring feature
[2/3] fsx buffered IO io_uring test
[3/3] fsx direct IO io_uring test

And the [2/3] just found an io_uring regression bug (need LVM TEST_DEV):
https://bugzilla.kernel.org/show_bug.cgi?id=209243

Feel free to tell me, if you have more suggestions to test io_uring on
filesystem.

Thanks,
Zorro

