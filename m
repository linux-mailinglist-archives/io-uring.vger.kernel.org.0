Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F32952CE5D
	for <lists+io-uring@lfdr.de>; Thu, 19 May 2022 10:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233868AbiESIc6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 May 2022 04:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbiESIc6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 May 2022 04:32:58 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 922ED71A33;
        Thu, 19 May 2022 01:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nyposQICT0wzylt3w3i0i3fAC4ar1NheEvxWSf6gqWM=; b=dL0Y/1eYh8R0gXmfi5erVmow7p
        h3JeSBaHeg0fGAPLOlkgIQ5DKg1FmqFFSUM5vN+eosQJwGboMAxb+WwI3D2UX3Yp6qFmqnjcRHVwf
        dYiUYFqUd+CXIuO7/wqylM+0qdMduzhaFOuKjmO1dc7RhO7ossl4vkJQ0eecV8MoiPbhLXSxeEEt0
        FudAUZdFyReV74cP/y8ak9PfG5NI3/U1vWiX728KLYBOhULzC6rdhGw+jIqo7Se+w+xISy1G1Abws
        VIjpNwAfag3cmRrTKd3wjswP1/HyY6xRiDZZNIsJpK2pqMqHPMPGUYblYsTVLTUHVA2iBVwiOvItx
        4BFVc2JQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nrbab-005sNt-5A; Thu, 19 May 2022 08:32:57 +0000
Date:   Thu, 19 May 2022 01:32:57 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz
Subject: Re: [RFC PATCH v3 18/18] xfs: Enable async buffered write support
Message-ID: <YoYAuaT2y7dleHRZ@infradead.org>
References: <20220518233709.1937634-1-shr@fb.com>
 <20220518233709.1937634-19-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518233709.1937634-19-shr@fb.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, May 18, 2022 at 04:37:09PM -0700, Stefan Roesch wrote:
> This turns on the async buffered write support for XFS.

Can you group the patches by code they are touching, i.e, first
VFS enablement, the MM, then iomap, then xfs?  That shoud make
things a bit easier to review sequentially.
