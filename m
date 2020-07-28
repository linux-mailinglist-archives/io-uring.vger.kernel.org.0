Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E626230ECC
	for <lists+io-uring@lfdr.de>; Tue, 28 Jul 2020 18:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731293AbgG1QFS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jul 2020 12:05:18 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:37230 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731156AbgG1QFR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jul 2020 12:05:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595952316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=luGdo4ZlTRSZ/w7GCxohup5Qeks74U6+9BCtrneg2e4=;
        b=FcHKMJxK1vAC8dQ+AC+wZtmy4ibVeiSxvq8cHYdRg390CzgHiA1G++vDcoJSftT+SPmVPy
        PFwZZ6XjimCRRBnYgSwR46+iQvPMH5KPitkYuLXPJ6VNV1nS8LGCwfHZ3XBL+/AxiEbiPh
        L+AEZXTXYLFUsMlBAK285gbIYrM59ww=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-496-WIdMrX2rPUuzLbIeaWweBw-1; Tue, 28 Jul 2020 12:05:14 -0400
X-MC-Unique: WIdMrX2rPUuzLbIeaWweBw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BFBFE18C63C6;
        Tue, 28 Jul 2020 16:05:13 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-112-109.ams2.redhat.com [10.36.112.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A84951002395;
        Tue, 28 Jul 2020 16:05:10 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: [PATCH liburing] .gitignore: add test/nop-all-sizes
Date:   Tue, 28 Jul 2020 18:05:06 +0200
Message-Id: <20200728160506.49478-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index 5faee05..00f7a86 100644
--- a/.gitignore
+++ b/.gitignore
@@ -63,6 +63,7 @@
 /test/link_drain
 /test/madvise
 /test/nop
+/test/nop-all-sizes
 /test/open-close
 /test/openat2
 /test/personality
-- 
2.26.2

