Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E07DA19E446
	for <lists+io-uring@lfdr.de>; Sat,  4 Apr 2020 11:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgDDJl3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Apr 2020 05:41:29 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37324 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgDDJl1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Apr 2020 05:41:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=NRX1JUyAqjf5wXlVipKJFb3msvliCBG3tEKEYgkCtZI=; b=TW+1Nsxw9TeWcVrte9M7Y2RiZf
        bttXuw1z5zLfVK1WKBJ9jQEQf7bg2g3Fg3SjKMFlkWjKtQf8eBs6sAShzs50QzEkhEYuRgGo2cqLw
        sxqzKiUVJKsJNq94JciRHqm24H9d1DSNhAh8AnNZ3OTE4Y7KycDq66CAvr1+dyt8vwvIB3/6gRN4f
        FYCwLQouLYxTM39n5sny6lvKNNYBzZtJ9WiPRttH/ULLC29LcNQ7B4wmHhVkg3k8AWnWyJrXfPzLy
        MA3LbNhEicLxFqAFS+ffkTacJUVr8MK6eq027yBMz9st5HO3pb93uX7KfVLnvtMdvHW+H2Qgc+bx9
        R7AvViAg==;
Received: from [2001:4bb8:180:7914:2ca6:9476:bbfa:a4d0] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jKfIZ-0002cr-En; Sat, 04 Apr 2020 09:41:08 +0000
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
Subject: [PATCH 1/6] amdgpu: a NULL ->mm does not mean a thread is a kthread
Date:   Sat,  4 Apr 2020 11:40:56 +0200
Message-Id: <20200404094101.672954-2-hch@lst.de>
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

Fixes: 70539bd795002 ("drm/amd: Update MEC HQD loading code for KFD")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
index 13feb313e9b3..4db143c19dcc 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -190,7 +190,7 @@ uint8_t amdgpu_amdkfd_get_xgmi_hops_count(struct kgd_dev *dst, struct kgd_dev *s
 			pagefault_disable();				\
 			if ((mmptr) == current->mm) {			\
 				valid = !get_user((dst), (wptr));	\
-			} else if (current->mm == NULL) {		\
+			} else if (current->flags & PF_KTHREAD) {	\
 				use_mm(mmptr);				\
 				valid = !get_user((dst), (wptr));	\
 				unuse_mm(mmptr);			\
-- 
2.25.1

