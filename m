Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3EA2E0B59
	for <lists+io-uring@lfdr.de>; Tue, 22 Dec 2020 15:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbgLVOEn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Dec 2020 09:04:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726904AbgLVOEn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Dec 2020 09:04:43 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F99C0613D3;
        Tue, 22 Dec 2020 06:04:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Rz5UQILXn7pea3r9p2TDb1W76FhMtiR//aY0Ef16jhk=; b=vxpvJLnOsr207exqt7xjJnUFqb
        jLQjigEhD9DsR4TEXjTkeE5O2KigVb/MuZdusj3qacpzp5C+4oiqSuHoxkukt1Nu5iZfWS8nfR13p
        ZQ1Mv1C4aKV8loMldVcLVhKU1XWOA1dqJVorpIT052G0J27K6EAj49ET3tYwf5l2a6bOvgWwv1N/F
        WnHTt/iijcA/kKUcjWb4vR5nuHm0n0HAQGZ+md/a3iInco8pvswATvkhK5Ug2r9ypy+VyrgUOeyNN
        D/JwNiRuowFz6pneEJZS62/4s2bJELNAWGzP4OLWqpGs9KSWxYZfLPnAIQxQM/3oiqw0A3OU48BKg
        3myXV2mA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kriGd-0003Uw-L6; Tue, 22 Dec 2020 14:03:59 +0000
Date:   Tue, 22 Dec 2020 14:03:59 +0000
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
Subject: Re: [PATCH v1 2/6] iov_iter: optimise bvec iov_iter_advance()
Message-ID: <20201222140359.GA13079@infradead.org>
References: <cover.1607976425.git.asml.silence@gmail.com>
 <5c9c22dbeecad883ca29b31896c262a8d2a77132.1607976425.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c9c22dbeecad883ca29b31896c262a8d2a77132.1607976425.git.asml.silence@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
