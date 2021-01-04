Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60F902E9B4C
	for <lists+io-uring@lfdr.de>; Mon,  4 Jan 2021 17:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbhADQqx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jan 2021 11:46:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbhADQqw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jan 2021 11:46:52 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A9EC061793;
        Mon,  4 Jan 2021 08:46:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=eL74fumxLANh2ZbcpNixBGA0B7
        wUyoY7cx6gt+70I2bVOLeBRO12vHF35hZht208klkPxQ0nXhD3GmvFuIyJI7/JzS+ebdqoyhYi+Sd
        04PS4QN0Rdf+elpvOf4TQHCYarAYPnwyXrunLBH0xJzkbG2IYJD0PimohfAyz+Ru+asjaJeGC2wOL
        1EZvIWSA0SDMfrZP+vy+rLG+EdBNNlrBbk7olNqEGSVlfzOkiHOVpri+jJmavhRT1iZL8+41666Gv
        wBIovUgnhoGz91BZypREIbtXCzgYB0OKuobSYsiNl8ihV1kuFMrPENNTL1BzE2jKx+OzD9CqqxeLS
        JOzgupiA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kwSzO-000JmV-Nc; Mon, 04 Jan 2021 16:45:52 +0000
Date:   Mon, 4 Jan 2021 16:45:50 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Ming Lei <ming.lei@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 3/7] block/psi: remove PSI annotations from direct IO
Message-ID: <20210104164550.GA75889@infradead.org>
References: <cover.1609461359.git.asml.silence@gmail.com>
 <c77839347f1f3fdf917ac2bc251310f1c1f26044.1609461359.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c77839347f1f3fdf917ac2bc251310f1c1f26044.1609461359.git.asml.silence@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
