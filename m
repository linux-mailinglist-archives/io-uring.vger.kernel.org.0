Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4184BC0EF
	for <lists+io-uring@lfdr.de>; Fri, 18 Feb 2022 20:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238593AbiBRT77 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Feb 2022 14:59:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236139AbiBRT76 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Feb 2022 14:59:58 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9CEE318;
        Fri, 18 Feb 2022 11:59:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=45tIpttbNmvxojqHc4cb86xvAY0WWzmRzTgs25skYgA=; b=VWFrVYgNL5ubTusKFcT1it2rBC
        xHeaOF0Qdh40XJNaw7CPyMQ9mbyEfvSE+2GCzPfwLn3WGvdVG3xnZobw8evo9sEwxVqxj2ZKjd8mk
        0f6xCQpW+GrK5SpGeEpyfsjawmEttV5rP0vG8DDlBiS1Q8qBLBLhSq1+8SiNK14kfeiyzb90tbIMm
        NBSvujAr6F39ohdkfpg/pQo3DjG4VvYFIH/YU1UCMHYAthmrgegwG4WDqVtJ/v34nV6gxK0VeBhRv
        rlvBJAq7MAMRtJHBjHGC3M5Tn0tWsZ9fNTKLVbkJ/EsTLfbxkCbZjdqGiHq4JbM8R6EAtl7sk6n2/
        JSpRdLWg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nL9Pk-00GtPo-6c; Fri, 18 Feb 2022 19:59:36 +0000
Date:   Fri, 18 Feb 2022 19:59:36 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 01/13] fs: Add flags parameter to
 __block_write_begin_int
Message-ID: <Yg/6qDCDuCLGkYux@casper.infradead.org>
References: <20220218195739.585044-1-shr@fb.com>
 <20220218195739.585044-2-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220218195739.585044-2-shr@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 18, 2022 at 11:57:27AM -0800, Stefan Roesch wrote:
> This adds a flags parameter to the __begin_write_begin_int() function.
> This allows to pass flags down the stack.

Still no.
