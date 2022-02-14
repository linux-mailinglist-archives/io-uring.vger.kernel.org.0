Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFEC4B5B94
	for <lists+io-uring@lfdr.de>; Mon, 14 Feb 2022 22:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbiBNU4H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Feb 2022 15:56:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiBNU4F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Feb 2022 15:56:05 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A53419AA;
        Mon, 14 Feb 2022 12:55:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4yPaINfIhHjDxeogf8godB/SLDYFJIZL+IhApoI09+A=; b=jEi/BRRwlarzsw3AwXejwW+kgB
        APfvkHtxgxSsgBUhjdxWDcBfWcZRGXLX2E6ISAI/wdPcujvA0zPUifVfocAXrkMeYKHOk08uDgU7z
        x2sxhEUjOyMsEiTkzuChXoWELvchB9Se7JtqZbe0WSGw+HNwNMnOMTQq5bIO3OsEn5H07ahgWkiHE
        ezqyc3KIlSl0dkk6tWA5V/OZ+utYDAibUy9PDck5wJMyLz9RrYiWvbKEmYXsDB+DKKt7hSWp0DrJY
        8o/4zFW5Re/xNuvsBNSVwwGpc7V+97If25TUwDzRL42mD+ASeK7eL9JB5TijwKg86M8u9lX7gra66
        jq6jvvmg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nJgg8-00DBgE-Ba; Mon, 14 Feb 2022 19:06:28 +0000
Date:   Mon, 14 Feb 2022 19:06:28 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v1 02/14] mm: Introduce do_generic_perform_write
Message-ID: <YgqoNAA+J81E2LJw@casper.infradead.org>
References: <20220214174403.4147994-1-shr@fb.com>
 <20220214174403.4147994-3-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214174403.4147994-3-shr@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Feb 14, 2022 at 09:43:51AM -0800, Stefan Roesch wrote:
> This splits off the do generic_perform_write() function, so an
> additional flags parameter can be specified. It uses the new flag
> parameter to support async buffered writes.

It would seem simpler to pass the iocb pointer to generic_perform_write()
(in place of the struct file pointer) instead of inventing a new flag.
