Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C89B6E812E
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 20:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbjDSSXF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 14:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjDSSXE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 14:23:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D20D1EB;
        Wed, 19 Apr 2023 11:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Q4xvshEky23A8vKuMJPJLEAhePbU/BIa4CqJor+C0N8=; b=Ket8KyqL5RDRco3CDXJB2fYj8x
        fF7g2ZhZvwKSsyDdqzGhnNlid/sbJ5FNco67p4fXrTCspmtpigfHk9rp1c9ZqQc9f14y7XzVdn0kQ
        OLsl8j/IkhrWp6ZP3Zv9zLuCMdq+8KoCiaSu2Qb0MdB/LOVQTQrBHG0OXrmKGSVqcrVZgTUij9ReC
        R6Y61loLSdymGzPK/F8+qy4mEf/whwEBSqC5bxlhe4sSo6SiCF7kTvPi5+Hyghv9FX+7X+DPC6NcT
        KI5UCKxqvrwfNkMSBj4X8h7gm6VMEUUIAHnrCqbNRjNESSqNcTwZ6ghC7bv8YHE2JCVfZbadYHrVx
        QIxwqQvA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ppCSK-00DTvc-RX; Wed, 19 Apr 2023 18:23:00 +0000
Date:   Wed, 19 Apr 2023 19:23:00 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v4 4/6] io_uring: rsrc: avoid use of vmas parameter in
 pin_user_pages()
Message-ID: <ZEAxhHx/4Ql6AMt2@casper.infradead.org>
References: <cover.1681831798.git.lstoakes@gmail.com>
 <956f4fc2204f23e4c00e9602ded80cb4e7b5df9b.1681831798.git.lstoakes@gmail.com>
 <936e8f52-00be-6721-cb3e-42338f2ecc2f@kernel.dk>
 <c2e22383-43ee-5cf0-9dc7-7cd05d01ecfb@kernel.dk>
 <f82b9025-a586-44c7-9941-8140c04a4ccc@lucifer.local>
 <69f48cc6-8fc6-0c49-5a79-6c7d248e4ad5@kernel.dk>
 <bec03e0f-a0f9-43c3-870b-be406ca848b9@lucifer.local>
 <8af483d2-0d3d-5ece-fb1d-a3654411752b@kernel.dk>
 <d601ca0c-d9b8-4e5d-a047-98f2d1c65eb9@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d601ca0c-d9b8-4e5d-a047-98f2d1c65eb9@lucifer.local>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Apr 19, 2023 at 07:18:26PM +0100, Lorenzo Stoakes wrote:
> So even if I did the FOLL_ALLOW_BROKEN_FILE_MAPPING patch series first, I
> would still need to come along and delete a bunch of your code
> afterwards. And unfortunately Pavel's recent change which insists on not
> having different vm_file's across VMAs for the buffer would have to be
> reverted so I expect it might not be entirely without discussion.

I don't even understand why Pavel wanted to make this change.  The
commit log really doesn't say.

commit edd478269640
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Wed Feb 22 14:36:48 2023 +0000

    io_uring/rsrc: disallow multi-source reg buffers

    If two or more mappings go back to back to each other they can be passed
    into io_uring to be registered as a single registered buffer. That would
    even work if mappings came from different sources, e.g. it's possible to
    mix in this way anon pages and pages from shmem or hugetlb. That is not
    a problem but it'd rather be less prone if we forbid such mixing.

    Cc: <stable@vger.kernel.org>
    Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

It even says "That is not a problem"!  So why was this patch merged
if it's not fixing a problem?

It's now standing in the way of an actual cleanup.  So why don't we
revert it?  There must be more to it than this ...
