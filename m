Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48DBA19E44F
	for <lists+io-uring@lfdr.de>; Sat,  4 Apr 2020 11:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbgDDJlV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Apr 2020 05:41:21 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37216 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgDDJlV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Apr 2020 05:41:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=FjP6zoayZ1fjLTQ5J40k73xEcDLUAFsLpp9ITbvNuIc=; b=E5rDDKMwWfrap1JfG6yNklw4O2
        GNgNgDdFmbxfo1fUVp5J1gaGFscM2Apu4SX2zjRhB1+YnuUkrq4wHrSoK6KStx9kPDNIH/ANmeneN
        wQ02zm0tKQ1R6ebfTq6wzZkFEMzwXBcqrmfyGf8xA5tZRYW83fb+mtQ8J+8dagGuRpquxFp/Q68nq
        FW1kAC2RNliuc7Tp/7ADj02HUyYGYkHXUO6rqnrjgGwA1crPkLp/2s+nq7pS6OYTuy64eguvFMaLD
        xOAvUjLwiu/DrMQZbyP3jl7d3qekyjoqtsaLSBWrrQVdwUV+JywA4azyO0oEnsF6xvSa20P+kDcLL
        Ntn9iIgQ==;
Received: from [2001:4bb8:180:7914:2ca6:9476:bbfa:a4d0] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jKfIc-0002d1-GL; Sat, 04 Apr 2020 09:41:11 +0000
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
Subject: [PATCH 2/6] i915/gvt/kvm: a NULL ->mm does not mean a thread is a kthread
Date:   Sat,  4 Apr 2020 11:40:57 +0200
Message-Id: <20200404094101.672954-3-hch@lst.de>
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

Use the proper API instead.

Fixes: f440c8a572d7 ("drm/i915/gvt/kvmgt: read/write GPA via KVM API")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/gpu/drm/i915/gvt/kvmgt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 074c4efb58eb..5848400620b4 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -2037,7 +2037,7 @@ static int kvmgt_rw_gpa(unsigned long handle, unsigned long gpa,
 	struct kvmgt_guest_info *info;
 	struct kvm *kvm;
 	int idx, ret;
-	bool kthread = current->mm == NULL;
+	bool kthread = (current->flags & PF_KTHREAD);
 
 	if (!handle_valid(handle))
 		return -ESRCH;
-- 
2.25.1

