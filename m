Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71B9374E634
	for <lists+io-uring@lfdr.de>; Tue, 11 Jul 2023 07:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbjGKFG3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Jul 2023 01:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjGKFG2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Jul 2023 01:06:28 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F1CFB;
        Mon, 10 Jul 2023 22:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=J9GM/ilzKp71HIAckRdNrtLwkcej9mux7tDYpRNE8jA=; b=OLuLrIvoJpoh+zQtPow9i0DJFd
        FiuDwRevDBZdslkiTu5Mif0ylqDaxIu/g30Uk3RK5u3mBkNuvPCvszgbjt+CCtivUzZyMN5Ek7JpD
        j6yAk9FJIEL7eqRj2SJ3xlZNvzPd2Blkh0PnQaj0D3Mn+e+EHaQuqwPjy/htojd4OBlp4rLj6QQzD
        Aozk1XNqmFM0BNGExCIBTDacCFN1JYB4NFKkVfiBjYcvM2JlXy5FoMd9vbwosBlUU6S1JHr1rYELd
        kML68F29Kx3SlTgBTfWkSbiqHZW7TiXwTgf/b77EkEoJT80OPAF9iJs6Z/dBzDpe//uey4/uKvtYm
        caB/Fy2g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qJ5Zv-00DiFr-00;
        Tue, 11 Jul 2023 05:06:23 +0000
Date:   Mon, 10 Jul 2023 22:06:22 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     Lu Hongfei <luhongfei@vivo.com>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        opensource.kernel@vivo.com
Subject: Re: [PATCH] io_uring: Redefined the meaning of io_alloc_async_data's
 return value
Message-ID: <ZKzjTg1xaoikN9Hh@infradead.org>
References: <20230710090957.10463-1-luhongfei@vivo.com>
 <87o7kjr9d9.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o7kjr9d9.fsf@suse.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jul 10, 2023 at 12:58:58PM -0400, Gabriel Krisman Bertazi wrote:
> practice to change the symbol, making the change hard to miss.  Or
> make the function return int instead of bool, which preserves the
> interface and is a common C idiom.  Or leave it as it is, which is quite
> readable already..

Yeah, returning -ENOMEM and 0 would make a lot more sense here.  But I'd
only change it if we have any good reason to touch the interface anyway.
