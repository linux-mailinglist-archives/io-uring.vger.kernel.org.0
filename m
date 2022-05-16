Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFB4527D95
	for <lists+io-uring@lfdr.de>; Mon, 16 May 2022 08:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235673AbiEPG2N (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 May 2022 02:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239936AbiEPG2M (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 May 2022 02:28:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5809427169;
        Sun, 15 May 2022 23:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rB4GSRFuLVvoeQQc4eYld/JEkwZTPI8rf+K6L4jpkHw=; b=5ErsTIgFUwyLBBOzQryGfX6cPA
        UN4ZwTWUoREruPBX/CfxuNhllpqtCA0Fl2kaxLl152e/yvzVtAuX/xnVrAdcxB1TLV6RrVq9RT4Il
        dWFoAFl7EbnHO4Q01twYofRY6VklciT3Q48Co7X+iz7+ndVb+WWoJeXMC9frTM5eX7xDesPQD7YY+
        E1C1k1n8T4FgLXNnDsegRb424M3nlwVKZ4vJ0fsTnTCf6CzO5s2UQfkEfzs1PCxxgpR7Uwi9c1H67
        Rxt9fFX1Df1yaGJKZzczyd+S6jSVSBRnLcRhMZpYi0E2+g1cTC+7h2glT8Qe/V+hcQSZjqWlpvnvj
        Sn9v5+Kw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nqUDA-006C1S-Uv; Mon, 16 May 2022 06:28:08 +0000
Date:   Sun, 15 May 2022 23:28:08 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Vasily Averin <vvs@openvz.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>, kernel@openvz.org,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, io-uring@vger.kernel.org
Subject: Re: [PATCH] sparse: use force attribute for __kernel_rwf_t casts
Message-ID: <YoHu+HvaDcIpC7gI@infradead.org>
References: <45e8576e-5fcc-bc52-8805-0b5cc3fc1a84@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45e8576e-5fcc-bc52-8805-0b5cc3fc1a84@openvz.org>
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

Please stop sprinkling random __force casts.  95% of them are simplify
wrong, and the others need to go into properly documented helpers.

The right fixes here are thing like:

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4479013854d20..a5d8b5109d3a7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -585,7 +585,7 @@ struct io_rw {
 	struct kiocb			kiocb;
 	u64				addr;
 	u32				len;
-	u32				flags;
+	rwf_t				flags;
 };
 
 struct io_connect {
