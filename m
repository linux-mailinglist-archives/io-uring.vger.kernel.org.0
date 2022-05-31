Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95692538BA8
	for <lists+io-uring@lfdr.de>; Tue, 31 May 2022 08:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244391AbiEaG70 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 May 2022 02:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244359AbiEaG7Z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 May 2022 02:59:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A8B9418D;
        Mon, 30 May 2022 23:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=m75BPNqn9LqwJSETkfwcvStH1N
        V5CcAAJXbqT3ezMtfHOoKVKZBeKcicPeh9WxO0bWF8WCfO1FlZy+1M95iBS+hoNPbGa76G2Jw8Im8
        urQWkTVgFjSxD3PJHCrqXpm3rulpyHNKNtTjNoW82s1NEuo5RniWPhyvAl79AJHs+mKVYLkrJkwDB
        fKRhycfNumdd8Hr5Y6zViUPsQ5etmrwFMJXNEbWwonLbiGuLAPqbKee1k+d7xWE5ZRJGQ+rKCbyMr
        3jfT8R/2S+I1fRiQxRJrq8AkcaToyhMozlB5Ni5A6AqaMZhtBF/i3+avtv1j6rudiBBR9Grjz2Qps
        vVYMuRNw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nvvqe-009dVy-83; Tue, 31 May 2022 06:59:24 +0000
Date:   Mon, 30 May 2022 23:59:24 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org
Subject: Re: [PATCH v6 06/16] fs: Add check for async buffered writes to
 generic_write_checks
Message-ID: <YpW8zCH7Wprb9jkq@infradead.org>
References: <20220526173840.578265-1-shr@fb.com>
 <20220526173840.578265-7-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526173840.578265-7-shr@fb.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
