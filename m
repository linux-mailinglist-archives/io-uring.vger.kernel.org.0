Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7A184B5BA0
	for <lists+io-uring@lfdr.de>; Mon, 14 Feb 2022 22:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiBNU5l (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Feb 2022 15:57:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbiBNUzx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Feb 2022 15:55:53 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6F3723F7;
        Mon, 14 Feb 2022 12:55:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=RrJXEVxpK3klFfhD2JAlYUs7oWDfgfAoLMYIySVZ1WA=; b=DG6aBvauu1zSZI2nWSpyGi9aSx
        vkbVrgJPhD45xXiq2WFVyiv5R+ZvbMSCKFjhJKNC4FMVB7/ljF40Euw4mZ7qykg1NCmMnVREZQZZ8
        8P+Rik0LPQGSdml748t7KpuYbpBcf8bNFPiNRDTg9lMZx4opP45hpnoZOEpd7PuwXZ+qqODpzSASD
        I70EQMeMLMsBy0Rk2JPz8XbRH8phR8iiBWJ5rbDzLv4289KD6RGRUkmX1L8yc2bYJ/qmDbJizGxJM
        KwWYgrpbr+YwX7tqEVkF77Ls+9yntGBeh+14eKmlt8YIiuEwmrkxEYAQOkM9CQMnyQVZvDam9Co9I
        Omrp1sWw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nJh5s-00DCdF-Vq; Mon, 14 Feb 2022 19:33:05 +0000
Date:   Mon, 14 Feb 2022 19:33:04 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v1 03/14] mm: add noio support in filemap_get_pages
Message-ID: <YgqucLAFESyBSD+G@casper.infradead.org>
References: <20220214174403.4147994-1-shr@fb.com>
 <20220214174403.4147994-4-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214174403.4147994-4-shr@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Feb 14, 2022 at 09:43:52AM -0800, Stefan Roesch wrote:
> This adds noio support for async buffered writes in filemap_get_pages.
> The idea is to handle the failure gracefully and return -EAGAIN if we
> can't get the memory quickly.

I don't understand why this helps you.  filemap_get_pages() is for
reads, not writes.
