Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 403391AD4CA
	for <lists+io-uring@lfdr.de>; Fri, 17 Apr 2020 05:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgDQDSB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Apr 2020 23:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725859AbgDQDSB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Apr 2020 23:18:01 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11CBBC061A0C;
        Thu, 16 Apr 2020 20:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xmaDAhB15m0ca2yw6/7wplovyJ4mJvftQ1TLrqWm/Bs=; b=uiJbu0G1PjxFYlCSgI8qpa82CM
        Jf+ghD0cfM+a0KMTUbFMACA5EI30uXjNpMD2zEISEXPmSYXqhyQKEEbwzH9AqUF93nG2bU1CYOzdf
        uE/0aMhq/Wos8A3WC8t9YU+3Op0i5gKNNEQAk31rtCtemFtzZIR/azxEBpo2EXcKBSQkP6HtuGthY
        tiQhNZ0SPuOroFAl1dURRnnCTLGW193jGaDnIbzveztLpLC2zHPVjSUNOiJwoV8l6f4CTeySJ3FAl
        Y1OhirdABmEj06Gq4QJ1bf5rERxHsavdWdgGHxieEQ0RbgyAutTgpaTeiGSmXgCGDBfJeUaOxUD/y
        hv+0N98g==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jPHVg-0002Ji-ML; Fri, 17 Apr 2020 03:17:44 +0000
Date:   Thu, 16 Apr 2020 20:17:44 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
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
Subject: Re: improve use_mm / unuse_mm v2
Message-ID: <20200417031744.GI5820@bombadil.infradead.org>
References: <20200416053158.586887-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200416053158.586887-1-hch@lst.de>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Apr 16, 2020 at 07:31:55AM +0200, Christoph Hellwig wrote:
> this series improves the use_mm / unuse_mm interface by better
> documenting the assumptions, and my taking the set_fs manipulations
> spread over the callers into the core API.

I appreciate all the work you're doing here.

Do you have plans to introduce a better-named API than set_fs() / get_fs()?

Also, having set_fs() return the previous value of 'fs' would simplify
a lot of the callers.
