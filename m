Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE99F538BAB
	for <lists+io-uring@lfdr.de>; Tue, 31 May 2022 09:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244406AbiEaHAL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 May 2022 03:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244428AbiEaHAH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 May 2022 03:00:07 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC5C95A17;
        Tue, 31 May 2022 00:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=HZjsjnGyuZeIxxuVqiPxQoNkbf
        VfiZUSyptchCdXVs7qYO+4w5cJQUuw8tIYE/0V/1mZa3WGZ0v921r/gzv/0Z6B1Knm/n0bghdvtgK
        a8CKSoqX8BngyAxiJjWn4ejz4S7GMHiXQoACZF4ILcXladFrofJQXZrlpDVO8cCd0CCyzsyRhcAGC
        /XyqavZlFV8z0amVky6ApxfjgnQti14l6zK3SXBHcBYYC92uD7OUuIzbsNBsCLjSiD0M1VAlA9M35
        6xfES0Y1trZ9EuadiS40jLWqgo7SV9OL1jQOFNzW0qtChOMSZYC0OohW0DzNY5d3Hh4GG4EJzi/Zn
        eLsDJuyg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nvvrK-009dkv-3E; Tue, 31 May 2022 07:00:06 +0000
Date:   Tue, 31 May 2022 00:00:06 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org
Subject: Re: [PATCH v6 07/16] fs: add __remove_file_privs() with flags
 parameter
Message-ID: <YpW89u3Ar2qoLuyk@infradead.org>
References: <20220526173840.578265-1-shr@fb.com>
 <20220526173840.578265-8-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526173840.578265-8-shr@fb.com>
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
