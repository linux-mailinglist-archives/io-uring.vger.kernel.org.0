Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C15EC19E44E
	for <lists+io-uring@lfdr.de>; Sat,  4 Apr 2020 11:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725837AbgDDJlU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Apr 2020 05:41:20 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37190 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgDDJlU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Apr 2020 05:41:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=WdsCUkqz+ZpftO7Mf21Mzxh3783sco48fV7R9K5+cSI=; b=PELXH5ny0M3kB+GT2d8Pd5dD9q
        8eanzcnxkv+aCZo7xU0MTLzbvHbFLRHyVQouUh6JEjIJaO0V5GxWO92Ywe09m95JPqXzd7HiGKqlm
        jW2BNwUQ2BtPIZ5kE6znphfh0jXoXYAcstagyulmremdMh291CUui94WRBcUPNWOAdQzqn5nfvSp9
        wzb7CZc9Qjt0wrAkoz7EHRrJOG0f0ZGg3YNyhb6HyaGU8uJKs2EX+nSZPB8n0IXDvXq/eW66dDriv
        z9PXCQgcdAm8Gv8jY0EKvfNz1aM4G5PN1Z1U6hgvGS5PaLbNtEoMK6qUpnowB9MtGYPkdq0+1JT6U
        CwulSteA==;
Received: from [2001:4bb8:180:7914:2ca6:9476:bbfa:a4d0] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jKfIW-0002cl-88; Sat, 04 Apr 2020 09:41:04 +0000
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
Subject: improve use_mm / unuse_mm
Date:   Sat,  4 Apr 2020 11:40:55 +0200
Message-Id: <20200404094101.672954-1-hch@lst.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi all,

this series improves the use_mm / unuse_mm interface by better
documenting the assumptions, and my taking the set_fs manipulations
spread over the callers into the core API.
