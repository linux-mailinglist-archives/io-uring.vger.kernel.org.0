Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D87DA529570
	for <lists+io-uring@lfdr.de>; Tue, 17 May 2022 01:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239630AbiEPXnb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 May 2022 19:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238034AbiEPXnb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 May 2022 19:43:31 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B74D33A10;
        Mon, 16 May 2022 16:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YxY3M3LT/WIgeGnlZxkoqzpD+LP5gUCDlpOVkqcUwrs=; b=gog+o7xlqhzT1ZU+1hQpdRT89a
        FECiBB60DQTaYwIvHmBI9kYguRT9T5vy5+XZOKyNUzQFgs4valNFRrnxM9NC5lQiaeAEJCydw1PeX
        tXY8WUesOk6EH9a628PECxsRUsb8AwdRO3/XGTzigmkTBrtaBUmxIa32hbvsBeeqjq2BhMD7GSFQn
        GKb8dajEU6q7ybNCXh+yXDZJ07+RLxAFcxtVXiaJrvAk3R+aiyykhBMEpFmoPFQzWCyqN2q6q/kSW
        N+hB+wBmNAXOYr8prkTWtyddoxCKFQWUJHwpj9zB/Rz055tN3rC8yD1JBT3uX7by3gWqdtxr6cX0u
        D9SGmsfA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nqkN0-00ALNQ-Fn; Mon, 16 May 2022 23:43:22 +0000
Date:   Tue, 17 May 2022 00:43:22 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz
Subject: Re: [RFC PATCH v2 01/16] block: add check for async buffered writes
 to generic_write_checks
Message-ID: <YoLhmrA0GXAT2Hm7@casper.infradead.org>
References: <20220516164718.2419891-1-shr@fb.com>
 <20220516164718.2419891-2-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516164718.2419891-2-shr@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, May 16, 2022 at 09:47:03AM -0700, Stefan Roesch wrote:
> -	if ((iocb->ki_flags & IOCB_NOWAIT) && !(iocb->ki_flags & IOCB_DIRECT))
> +	if ((iocb->ki_flags & IOCB_NOWAIT) &&
> +	    !((iocb->ki_flags & IOCB_DIRECT) || (file->f_mode & FMODE_BUF_WASYNC)))

Please reduce your window width to 80 columns.  It's exhausting trying to
read all this with the odd wrapping.
