Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F16D19E453
	for <lists+io-uring@lfdr.de>; Sat,  4 Apr 2020 11:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgDDJlp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Apr 2020 05:41:45 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37224 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgDDJlV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Apr 2020 05:41:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=/tDvMcpQEBI9S68wHOZLUB3dDI6IS68bO71B9/9EwUE=; b=CThSaAilR3ovdk8YHEBYWt5Ywb
        +Ig6dXA4SCkBKlwyH+dnd9gAgLYDklih2fs3Sb/j0+a+tRF+2om4l+ZEMhYbZmkdlBtdFVjiOQh6i
        rsAU0NmW5zgW+9jcbnYb4/kuzcl5lzPPmnD2sruNcp/WjLsPVH8LEVgHKSxKPKtGQYFGDWE4qpe1/
        DN2i1aQV0nYWQyrfC3Q3YeHvjhe4lq6+1lGucDhrbtE0PvUI/PauoxgjTggfvH5eWTsh+88FTmiYE
        czENSm+bnFheaetCcE3kGE4wi0mZP4UK4qBRnn/gHR5USuqGiVuvVJn8j4hTaI6SxpNERUEcH8AUT
        3r99EnWQ==;
Received: from [2001:4bb8:180:7914:2ca6:9476:bbfa:a4d0] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jKfIf-0002dK-G0; Sat, 04 Apr 2020 09:41:14 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Felipe Balbi <balbi@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-usb@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 3/6] i915/gvt: remove unused xen bits
Date:   Sat,  4 Apr 2020 11:40:58 +0200
Message-Id: <20200404094101.672954-4-hch@lst.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200404094101.672954-1-hch@lst.de>
References: <20200404094101.672954-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

No Xen support anywhere here.  Remove a dead declaration and an unused
include.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/gpu/drm/i915/gvt/gvt.c       | 1 -
 drivers/gpu/drm/i915/gvt/hypercall.h | 2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/gvt.c b/drivers/gpu/drm/i915/gvt/gvt.c
index 9e1787867894..c7c561237883 100644
--- a/drivers/gpu/drm/i915/gvt/gvt.c
+++ b/drivers/gpu/drm/i915/gvt/gvt.c
@@ -31,7 +31,6 @@
  */
 
 #include <linux/types.h>
-#include <xen/xen.h>
 #include <linux/kthread.h>
 
 #include "i915_drv.h"
diff --git a/drivers/gpu/drm/i915/gvt/hypercall.h b/drivers/gpu/drm/i915/gvt/hypercall.h
index b17c4a1599cd..b79da5124f83 100644
--- a/drivers/gpu/drm/i915/gvt/hypercall.h
+++ b/drivers/gpu/drm/i915/gvt/hypercall.h
@@ -79,6 +79,4 @@ struct intel_gvt_mpt {
 	bool (*is_valid_gfn)(unsigned long handle, unsigned long gfn);
 };
 
-extern struct intel_gvt_mpt xengt_mpt;
-
 #endif /* _GVT_HYPERCALL_H_ */
-- 
2.25.1

