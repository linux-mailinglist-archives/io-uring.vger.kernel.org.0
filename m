Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3BBB52CE38
	for <lists+io-uring@lfdr.de>; Thu, 19 May 2022 10:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbiESIV2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 May 2022 04:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiESIUn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 May 2022 04:20:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9744BBDA3B;
        Thu, 19 May 2022 01:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=75wJQ7YlOANtWdF0oOc3s+1K3leawCBdFbyfjR+bGR8=; b=VWjasnU6WqmafgXhrGoXgDAg33
        tiJpKj0tqkRwZseXIy3gBTxIG8oer8iAk0zvcFcKKecq4F+v/5xiUnNDpnFlZ/vG3PKd39YAFrJBM
        7a2f8WkGoQ14DC1YDWdyI65XwY1WiuFUR5szqpZYPxR0weuyMCuHKWnEV3vesfkFpzfYVUDkt4tz6
        Y3nbUPIbLI4WRVrtK2Whe+wtjsvauD7ZBQALbm0SpbJK4VHvuNc9B0ybQeUiBcqNTj76e1d/yegbG
        EjAIJTdu9B4be8neeDDYdRMmWpZZ1xcpOpBnqUVuTmnqHpE/Ld/knxOcaZCrOImIt/+C6qv5fCAJi
        5RGW105Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nrbNl-005lWb-1w; Thu, 19 May 2022 08:19:41 +0000
Date:   Thu, 19 May 2022 01:19:41 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz
Subject: Re: [RFC PATCH v3 03/18] iomap: Use iomap_page_create_gfp() in
 __iomap_write_begin
Message-ID: <YoX9neh8SEOBDNkT@infradead.org>
References: <20220518233709.1937634-1-shr@fb.com>
 <20220518233709.1937634-4-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518233709.1937634-4-shr@fb.com>
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

On Wed, May 18, 2022 at 04:36:54PM -0700, Stefan Roesch wrote:
> This change uses the new iomap_page_create_gfp() function in the
> function __iomap_write_begin().

.. and this now loses the check if we actually need the creation,
see my previous comment.
