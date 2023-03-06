Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96FDF6AC035
	for <lists+io-uring@lfdr.de>; Mon,  6 Mar 2023 14:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbjCFNEK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Mar 2023 08:04:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbjCFNEG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Mar 2023 08:04:06 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3104729E0D;
        Mon,  6 Mar 2023 05:03:49 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id EB2CB68B05; Mon,  6 Mar 2023 14:03:44 +0100 (CET)
Date:   Mon, 6 Mar 2023 14:03:44 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Stefan Roesch <shr@meta.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        kernel-team@fb.com, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, david@fromorbit.com, jack@suse.cz,
        hch@infradead.org, axboe@kernel.dk, Christoph Hellwig <hch@lst.de>
Subject: Re: [RESEND PATCH v9 04/14] iomap: Add flags parameter to
 iomap_page_create()
Message-ID: <20230306130344.GA14467@lst.de>
References: <20220623175157.1715274-1-shr@fb.com> <20220623175157.1715274-5-shr@fb.com> <ZAF8vk6Jns/40bc0@casper.infradead.org> <ZAIl7JfPXivtN8qm@magnolia> <0d43e015-057f-2379-a0fb-d55539b803eb@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d43e015-057f-2379-a0fb-d55539b803eb@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Mar 03, 2023 at 09:29:30AM -0800, Stefan Roesch wrote:
> If IOMAP_NOWAIT is set, and the allocation fails, we should return
> -EAGAIN, so the write request is retried in the slow path.

Yes.  Another vote for doing the ERR_PTR.

willy, are you going to look into that yourself or are you waiting for
someone to take care of it?
