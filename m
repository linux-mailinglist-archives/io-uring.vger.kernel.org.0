Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E30D2E9AE7
	for <lists+io-uring@lfdr.de>; Mon,  4 Jan 2021 17:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbhADQUN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jan 2021 11:20:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbhADQUN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jan 2021 11:20:13 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9951C061574;
        Mon,  4 Jan 2021 08:19:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=LWMq7OUBtnVBBG+dc0YhdlqaMzMMUhts72RYl0AtdPM=; b=fDlHzLIRBoULufXAaGLtu2g9lo
        yWtvh2rGpxlyYyJzI6muWm8UhXfZl8EY1Uf8s6lM4d56Ju3tavW49tP2tITyeJrTVdWvvf/SkrdbN
        w9GyOcRUToqvJBIrnwCheNjZWrMmlKCzwmF83ON93iMipal4oqwNCrINqceuYAk1RSpR9PINvdA1E
        HG2HzF2SGlTHzlI+frhpw96JXRyHP9itESJNjefRlIHroF4aohOLaWgQSKaCLiNBmM7VIPeI31U1X
        LMfhunOHJEL5DnX6tKtACwCWTlfBFIfuPSBbujxw7kPWIh7VzeU+g0VxNw04YZ1kBf95uS16G6N3j
        eprUSEJg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kwSYt-000HxM-Si; Mon, 04 Jan 2021 16:18:29 +0000
Date:   Mon, 4 Jan 2021 16:18:27 +0000
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
Subject: Re: [PATCH v2 2/7] bvec/iter: disallow zero-length segment bvecs
Message-ID: <20210104161827.GB68600@infradead.org>
References: <cover.1609461359.git.asml.silence@gmail.com>
 <b46b8c1943bbefcb90ea5c4dd9beaad8bbc15448.1609461359.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b46b8c1943bbefcb90ea5c4dd9beaad8bbc15448.1609461359.git.asml.silence@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Jan 02, 2021 at 03:17:34PM +0000, Pavel Begunkov wrote:
> zero-length bvec segments are allowed in general, but not handled by bio
> and down the block layer so filtered out. This inconsistency may be
> confusing and prevent from optimisations. As zero-length segments are
> useless and places that were generating them are patched, declare them
> not allowed.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
